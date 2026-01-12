import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/social/presentation/widgets/image_zoom_screen.dart';
import 'package:rightlogistics/src/features/social/presentation/providers/social_providers.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/core/utils/date_utils.dart';
import 'package:share_plus/share_plus.dart';

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
    final postAsync = ref.watch(postProvider(widget.post.id));
    final activePost = postAsync.value ?? widget.post;
    final commentsAsync = ref.watch(postCommentsProvider(widget.post.id));
    final user = ref.watch(currentUserProvider);
    final isLiked = activePost.likeIds.contains(user?.id);
    final isBookmarked = activePost.bookmarkIds.contains(user?.id);
    final isFollowing =
        user?.followingIds.contains(activePost.vendorId) ?? false;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: activePost.imageUrls.isNotEmpty ? 350 : 0,
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: activePost.imageUrls.isEmpty
                      ? Text(
                          activePost.type.name
                              .replaceAll(RegExp(r'_|^'), ' ')
                              .toUpperCase(),
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      : null,
                  flexibleSpace: activePost.imageUrls.isNotEmpty
                      ? FlexibleSpaceBar(
                          background: _buildImageSection(
                            context,
                            activePost,
                            isAppBar: true,
                          ),
                        )
                      : null,
                  actions: [
                    IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? Colors.amber[700] : null,
                      ),
                      onPressed: () {
                        if (user == null) return;
                        if (isBookmarked) {
                          ref
                              .read(socialRepositoryProvider)
                              .unbookmarkPost(activePost.id, user.id);
                        } else {
                          ref
                              .read(socialRepositoryProvider)
                              .bookmarkPost(activePost.id, user.id);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () {
                        Share.share(
                          'Check out this ${activePost.type.name} from ${activePost.vendorName} on RightLogistics!\n\n${activePost.description}',
                        );
                        ref
                            .read(socialRepositoryProvider)
                            .sharePost(activePost.id);
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildHeader(context, user, activePost, isFollowing),
                      _buildContentSection(context, activePost, user),
                      const SizedBox(height: 16),
                      // Engagement Bar
                      _buildEngagementBar(
                        context,
                        ref,
                        activePost,
                        isLiked,
                        user?.id,
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'COMMENTS (${activePost.commentCount})',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
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
                // Padding for bottom input
                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
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
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.paddingOf(context).bottom + 12,
        top: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_replyingToName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Replying to @$_replyingToName',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _cancelReply,
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  maxLines: 4,
                  minLines: 1,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: _replyingToName != null
                        ? 'Reply to @$_replyingToName...'
                        : 'Share your thoughts...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  onPressed: () {
                    final content = _commentController.text.trim();
                    if (content.isEmpty) return;

                    final newComment = PostComment(
                      id: '',
                      postId: widget.post.id,
                      parentId: _replyingToId,
                      userId: userId,
                      userName: 'Me',
                      userPhotoUrl: null,
                      content: content,
                      createdAt: DateTime.now(),
                      tags: [],
                    );

                    ref.read(socialRepositoryProvider).addComment(newComment);
                    _commentController.clear();
                    _cancelReply();
                    FocusScope.of(context).unfocus();
                  },
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    UserModel? user,
    VendorPost post,
    bool isFollowing,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: post.vendorPhotoUrl != null
                ? CachedNetworkImageProvider(post.vendorPhotoUrl!)
                : null,
            child: post.vendorPhotoUrl == null
                ? Text(post.vendorName[0])
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.vendorName,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                'Logistics Expert',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (user?.id != null && user!.id != post.vendorId)
            TextButton(
              onPressed: () {
                if (isFollowing) {
                  ref
                      .read(socialRepositoryProvider)
                      .unfollowUser(user.id, post.vendorId);
                } else {
                  ref
                      .read(socialRepositoryProvider)
                      .followUser(user.id, post.vendorId);
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: isFollowing
                    ? null
                    : Theme.of(context).colorScheme.primary,
                foregroundColor: isFollowing
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: isFollowing
                      ? BorderSide(color: Theme.of(context).colorScheme.primary)
                      : BorderSide.none,
                ),
              ),
              child: Text(
                isFollowing ? 'Following' : 'Follow',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    VendorPost post, {
    bool isAppBar = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ImageZoomScreen(imageUrls: post.imageUrls),
          ),
        );
      },
      child: Hero(
        tag: 'post_image_${post.id}',
        child: Container(
          margin: isAppBar
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: isAppBar
                ? BorderRadius.zero
                : BorderRadius.circular(24),
            boxShadow: isAppBar
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: isAppBar
                ? BorderRadius.zero
                : BorderRadius.circular(24),
            child: CachedNetworkImage(
              imageUrl: post.imageUrls[0],
              width: double.infinity,
              height: isAppBar ? double.infinity : 350,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection(
    BuildContext context,
    VendorPost post,
    UserModel? user,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (post.title != null) ...[
                      Text(
                        post.title!,
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: colorScheme.onSurface,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Text(
                      post.description,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              if (post.price > 0) ...[
                const SizedBox(width: 12),
                Text(
                  '${post.currency}${post.price.toStringAsFixed(0)}',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ],
          ),
          if (post.details != null) ...[
            const SizedBox(height: 16),
            Text(
              'SPECIFICATIONS',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 1.5,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              post.details!,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
          if (post.type == PostType.promotion) ...[
            const SizedBox(height: 24),
            _buildPromoBanner(context, post),
          ],
          const SizedBox(height: 32),
          _buildDataGrid(colorScheme, post),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context, VendorPost post) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.local_offer_rounded, color: Colors.amber),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'SPECIAL OFFER',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1.5,
                    color: Colors.amber[900],
                  ),
                ),
              ),
              if (post.discountPercentage != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '-${post.discountPercentage!.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: post.promoCode ?? ''));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Code copied to clipboard!')),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    post.promoCode ?? 'NO CODE',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                      letterSpacing: 1,
                    ),
                  ),
                  const Icon(Icons.copy_rounded, size: 20, color: Colors.grey),
                ],
              ),
            ),
          ),
          if (post.promoExpiry != null) ...[
            const SizedBox(height: 12),
            Text(
              'Expires: ${DateUtilsHelper.formatFullDate(post.promoExpiry!)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber[900],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEngagementBar(
    BuildContext context,
    WidgetRef ref,
    VendorPost post,
    bool isLiked,
    String? userId,
  ) {
    final repo = ref.read(socialRepositoryProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _EngagementButton(
                icon: isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                label: '${post.likeIds.length}',
                color: isLiked ? Colors.red : colorScheme.onSurfaceVariant,
                onTap: () {
                  if (userId == null) return;
                  if (isLiked) {
                    repo.unlikePost(post.id, userId);
                  } else {
                    repo.likePost(post.id, userId);
                  }
                },
              ),
              const SizedBox(width: 16),
              _EngagementButton(
                icon: Icons.chat_bubble_outline_rounded,
                label: '${post.commentCount}',
                color: colorScheme.onSurfaceVariant,
                onTap: () {
                  // Scroll to comment section or focus?
                },
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.share_outlined, size: 20),
                onPressed: () {
                  Share.share(
                    'Check out this ${post.type.name} from ${post.vendorName} on RightLogistics!\n\n${post.description}',
                  );
                  repo.sharePost(post.id);
                },
              ),
              IconButton(
                icon: Icon(
                  post.bookmarkIds.contains(userId)
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  size: 20,
                  color: post.bookmarkIds.contains(userId)
                      ? Colors.amber[700]
                      : null,
                ),
                onPressed: () {
                  if (userId == null) return;
                  if (post.bookmarkIds.contains(userId)) {
                    repo.unbookmarkPost(post.id, userId);
                  } else {
                    repo.bookmarkPost(post.id, userId);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataGrid(ColorScheme colorScheme, VendorPost post) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (post.deliveryTime != null)
          _DataTile(
            label: 'DELIVERY',
            value: post.deliveryTime!,
            icon: Icons.timer_outlined,
            color: Colors.orange,
          ),
        if (post.deliveryMode != null)
          _DataTile(
            label: 'MODE',
            value: post.deliveryMode!,
            icon: Icons.airplanemode_active,
            color: Colors.blue,
          ),
        if (post.metadata['location'] != null)
          _DataTile(
            label: 'LOCATION',
            value: post.metadata['location'],
            icon: Icons.location_on_outlined,
            color: Colors.green,
          ),
        if (post.promoCode != null)
          _DataTile(
            label: 'PROMO CODE',
            value: post.promoCode!,
            icon: Icons.qr_code_rounded,
            color: Colors.amber,
          ),
        if (post.discountPercentage != null)
          _DataTile(
            label: 'DISCOUNT',
            value: '${post.discountPercentage!.toStringAsFixed(0)}%',
            icon: Icons.trending_down_rounded,
            color: Colors.redAccent,
          ),
        if (post.discountAmount != null)
          _DataTile(
            label: 'DISCOUNT',
            value:
                '${post.currency} ${post.discountAmount!.toStringAsFixed(2)}',
            icon: Icons.money_off_rounded,
            color: Colors.redAccent,
          ),
        if (post.promoExpiry != null)
          _DataTile(
            label: 'EXPIRES',
            value:
                '${post.promoExpiry!.day}/${post.promoExpiry!.month}/${post.promoExpiry!.year}',
            icon: Icons.event_available_rounded,
            color: Colors.deepOrange,
          ),
        if (post.minPurchaseAmount != null && post.minPurchaseAmount! > 0)
          _DataTile(
            label: 'MIN PURCHASE',
            value:
                '${post.currency} ${post.minPurchaseAmount!.toStringAsFixed(2)}',
            icon: Icons.shopping_bag_outlined,
            color: Colors.purple,
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
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color ?? colorScheme.onSurfaceVariant,
              ),
            ),
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

  List<PostComment> _getAllReplies(String parentId) {
    final List<PostComment> results = [];
    final directReplies = widget.allReplies[parentId] ?? [];

    // Sort direct replies by creation date
    directReplies.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    for (var reply in directReplies) {
      results.add(reply);
      // Recursively add replies to this reply
      results.addAll(_getAllReplies(reply.id));
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    // Collect ALL replies in the tree under this parent
    final allNestedReplies = _getAllReplies(widget.parent.id);

    // Note: Since we want a flat-ish display like TikTok/Instagram under the parent,
    // we take the first few.
    final visibleReplies = allNestedReplies.take(_visibleCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CommentTile(
          comment: widget.parent,
          currentUserId: widget.currentUserId,
          onReply: () =>
              widget.onReply(widget.parent.id, widget.parent.userName),
        ),
        if (allNestedReplies.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 48.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...visibleReplies.map((reply) {
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
                if (allNestedReplies.length > _visibleCount)
                  TextButton(
                    onPressed: () => setState(() => _visibleCount += 10),
                    child: Text(
                      'View ${allNestedReplies.length - _visibleCount} more replies',
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
                        '${comment.userName}${replyingToName != null ? ' > @$replyingToName' : ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
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
