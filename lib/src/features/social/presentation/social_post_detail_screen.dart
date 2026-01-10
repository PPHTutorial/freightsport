import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/social/presentation/widgets/image_zoom_screen.dart';
import 'package:rightlogistics/src/features/social/presentation/providers/social_providers.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/core/utils/date_utils.dart';

class SocialPostDetailScreen extends ConsumerStatefulWidget {
  final VendorPost post;
  const SocialPostDetailScreen({super.key, required this.post});

  @override
  ConsumerState<SocialPostDetailScreen> createState() =>
      _SocialPostDetailScreenState();
}

class _SocialPostDetailScreenState
    extends ConsumerState<SocialPostDetailScreen> {
  String? _replyingToId;
  String? _replyingToName;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        ref.read(socialRepositoryProvider).viewPost(widget.post.id, user.id);
      }
    });
  }

  void _handleReply(String commentId, String userName) {
    setState(() {
      _replyingToId = commentId;
      _replyingToName = userName;
    });
    // Focus logic would go here if we had a FocusNode
  }

  void _cancelReply() {
    setState(() {
      _replyingToId = null;
      _replyingToName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(postCommentsProvider(widget.post.id));
    final user = ref.watch(currentUserProvider);
    final isLiked = widget.post.likeIds.contains(user?.id);
    final isBookmarked = widget.post.bookmarkIds.contains(user?.id);

    return Scaffold(
      /* appBar: AppBar(
        title: Text(
          'Post Details',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ), */
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Header & Content (from previous implementation)
                      _buildHeader(context, user),
                      if (widget.post.imageUrls.isNotEmpty)
                        _buildImageSection(context),
                      _buildContentSection(context),
                      const SizedBox(height: 16),
                      // Engagement Bar
                      _buildEngagementBar(
                        context,
                        ref,
                        isLiked,
                        isBookmarked,
                        user?.id,
                      ),
                      const Divider(thickness: 8),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Comments (${widget.post.commentCount})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                commentsAsync.when(
                  data: (comments) {
                    if (comments.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(
                            child: Text('No comments yet. Be the first!'),
                          ),
                        ),
                      );
                    }

                    // Organize comments: map parentId -> children
                    final Map<String, List<PostComment>> replyMap = {};
                    final List<PostComment> topLevel = [];
                    final Map<String, PostComment> commentMap = {
                      for (var c in comments) c.id: c,
                    };

                    for (var c in comments) {
                      if (c.parentId != null) {
                        // We need to find the root parent for hierarchical display
                        // but TikTok often groups all replies under the top-level parent.
                        // However, parentId points to the immediate parent.
                        replyMap.putIfAbsent(c.parentId!, () => []).add(c);
                      } else {
                        topLevel.add(c);
                      }
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final parent = topLevel[index];
                        return _NestedCommentThread(
                          parent: parent,
                          allReplies: replyMap,
                          commentMap: commentMap,
                          currentUserId: user?.id,
                          onReply: (id, name) => _handleReply(id, name),
                        );
                      }, childCount: topLevel.length),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => SliverToBoxAdapter(child: Text('Error: $e')),
                ),
                // Extra padding for bottom input
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
          _buildInputSection(context, ref, user?.id),
        ],
      ),
    );
  }

  Widget _buildInputSection(
    BuildContext context,
    WidgetRef ref,
    String? userId,
  ) {
    if (userId == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_replyingToName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    'Replying to $_replyingToName',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _cancelReply,
                    icon: const Icon(Icons.close, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: _replyingToName != null
                        ? 'Reply to $_replyingToName...'
                        : 'Write a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () {
                  final content = _commentController.text.trim();
                  if (content.isEmpty) return;

                  final newComment = PostComment(
                    id: '', // Generated by repo
                    postId: widget.post.id,
                    parentId: _replyingToId,
                    userId: userId,
                    userName: 'Me', // Ideally from user model
                    userPhotoUrl: null, // Ideally from user model
                    content: content,
                    createdAt: DateTime.now(),
                    tags: [], // Parsing tags could happen here
                  );

                  ref.read(socialRepositoryProvider).addComment(newComment);
                  _commentController.clear();
                  _cancelReply();
                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserModel? user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: widget.post.vendorPhotoUrl != null
                ? CachedNetworkImageProvider(widget.post.vendorPhotoUrl!)
                : null,
            child: widget.post.vendorPhotoUrl == null
                ? Text(widget.post.vendorName[0])
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.vendorName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Logistics Expert',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (user?.id != null && user!.id != widget.post.vendorId)
            OutlinedButton(
              onPressed: () {
                final isFollowing = user.followingIds.contains(
                  widget.post.vendorId,
                );
                if (isFollowing) {
                  ref
                      .read(socialRepositoryProvider)
                      .unfollowUser(user.id, widget.post.vendorId);
                } else {
                  ref
                      .read(socialRepositoryProvider)
                      .followUser(user.id, widget.post.vendorId);
                }
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(
                  color: user.followingIds.contains(widget.post.vendorId)
                      ? Theme.of(context).colorScheme.outline
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Text(
                user.followingIds.contains(widget.post.vendorId)
                    ? 'Followed'
                    : 'Follow',
                style: TextStyle(
                  color: user.followingIds.contains(widget.post.vendorId)
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ImageZoomScreen(imageUrls: widget.post.imageUrls),
          ),
        );
      },
      child: Hero(
        tag: 'post_image_${widget.post.id}',
        child: CachedNetworkImage(
          imageUrl: widget.post.imageUrls[0],
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.post.title != null) ...[
            Text(
              widget.post.title!,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            widget.post.description,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 24),
          if (widget.post.details != null) ...[
            Text(
              'SPECIFICATIONS',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1.5,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(widget.post.details!),
            const SizedBox(height: 24),
          ],
          _buildDataGrid(colorScheme),
        ],
      ),
    );
  }

  Widget _buildEngagementBar(
    BuildContext context,
    WidgetRef ref,
    bool isLiked,
    bool isBookmarked,
    String? userId,
  ) {
    final repo = ref.read(socialRepositoryProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _EngagementButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          label: 'Like',
          color: isLiked ? Colors.red : null,
          onTap: () {
            if (userId == null) return;
            if (isLiked) {
              repo.unlikePost(widget.post.id, userId);
            } else {
              repo.likePost(widget.post.id, userId);
            }
          },
        ),
        _EngagementButton(
          icon: Icons.comment_outlined,
          label: 'Comment',
          onTap: () {
            // Focus input?
          },
        ),
        _EngagementButton(
          icon: Icons.share_outlined,
          label: 'Share',
          onTap: () {},
        ),
        _EngagementButton(
          icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          label: 'Save',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildDataGrid(ColorScheme colorScheme) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (widget.post.price > 0)
          _DataTile(
            label: 'PRICE',
            value:
                '${widget.post.currency} ${widget.post.price.toStringAsFixed(2)}',
            icon: Icons.payments,
            color: colorScheme.primary,
          ),
        if (widget.post.deliveryTime != null)
          _DataTile(
            label: 'DELIVERY',
            value: widget.post.deliveryTime!,
            icon: Icons.timer,
            color: Colors.orange,
          ),
        if (widget.post.deliveryMode != null)
          _DataTile(
            label: 'MODE',
            value: widget.post.deliveryMode!,
            icon: Icons.airplanemode_active,
            color: Colors.blue,
          ),
        if (widget.post.metadata['location'] != null)
          _DataTile(
            label: 'LOCATION',
            value: widget.post.metadata['location'],
            icon: Icons.location_on,
            color: Colors.green,
          ),
      ],
    );
  }
}

class _EngagementButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _EngagementButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
      ),
    );
  }
}

class _DataTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _DataTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: color.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _NestedCommentThread extends StatefulWidget {
  final PostComment parent;
  final Map<String, List<PostComment>> allReplies;
  final Map<String, PostComment> commentMap;
  final String? currentUserId;
  final Function(String, String) onReply;

  const _NestedCommentThread({
    required this.parent,
    required this.allReplies,
    required this.commentMap,
    this.currentUserId,
    required this.onReply,
  });

  @override
  State<_NestedCommentThread> createState() => _NestedCommentThreadState();
}

class _NestedCommentThreadState extends State<_NestedCommentThread> {
  int _visibleCount = 5;

  @override
  Widget build(BuildContext context) {
    // Collect all replies recursively or just flat under parent as TikTok does?
    // TikTok usually groups all replies under the thread root.
    // Real nesting:
    final replies = widget.allReplies[widget.parent.id] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CommentTile(
          comment: widget.parent,
          currentUserId: widget.currentUserId,
          onReply: () =>
              widget.onReply(widget.parent.id, widget.parent.userName),
        ),
        if (replies.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 48.0),
            child: Column(
              children: [
                ...replies.take(_visibleCount).map((reply) {
                  // Find attribution if immediate parent is not the thread root
                  String? replyingTo;
                  if (reply.parentId != widget.parent.id) {
                    replyingTo = widget.commentMap[reply.parentId]?.userName;
                  }

                  return _CommentTile(
                    comment: reply,
                    currentUserId: widget.currentUserId,
                    isReply: true,
                    replyingToName: replyingTo,
                    onReply: () => widget.onReply(reply.id, reply.userName),
                  );
                }),
                if (replies.length > _visibleCount)
                  TextButton(
                    onPressed: () => setState(() => _visibleCount += 10),
                    child: Text(
                      'View ${replies.length - _visibleCount} more replies',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _CommentTile extends ConsumerWidget {
  final PostComment comment;
  final String? currentUserId;
  final VoidCallback onReply;
  final bool isReply;
  final String? replyingToName;

  const _CommentTile({
    required this.comment,
    required this.currentUserId,
    required this.onReply,
    this.isReply = false,
    this.replyingToName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = comment.likeIds.contains(currentUserId);
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? 8.0 : 16.0,
        right: 16.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: isReply ? 14 : 18,
            backgroundImage: comment.userPhotoUrl != null
                ? CachedNetworkImageProvider(comment.userPhotoUrl!)
                : null,
            child: comment.userPhotoUrl == null
                ? Text(
                    comment.userName[0],
                    style: TextStyle(fontSize: isReply ? 12 : 14),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withOpacity(isReply ? 0.3 : 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (replyingToName != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: RichText(
                            text: TextSpan(
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                              ),
                              children: [
                                TextSpan(
                                  text: 'replied to ',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                TextSpan(
                                  text: '@$replyingToName',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Text(
                        comment.content,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      DateUtilsHelper.timeAgo(comment.createdAt),
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        if (currentUserId == null) return;
                        final repo = ref.read(socialRepositoryProvider);
                        if (isLiked) {
                          repo.unlikeComment(
                            comment.postId,
                            comment.id,
                            currentUserId!,
                          );
                        } else {
                          repo.likeComment(
                            comment.postId,
                            comment.id,
                            currentUserId!,
                          );
                        }
                      },
                      child: Text(
                        'Like',
                        style: TextStyle(
                          color: isLiked ? Colors.red : Colors.grey,
                          fontSize: 12,
                          fontWeight: isLiked
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: onReply,
                      child: const Text(
                        'Reply',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                    const Spacer(),
                    if (comment.likeIds.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            size: 12,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${comment.likeIds.length}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
