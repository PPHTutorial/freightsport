import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/core/presentation/widgets/empty_state.dart';
import 'package:rightlogistics/src/features/social/domain/status_model.dart';
import 'package:rightlogistics/src/features/social/presentation/providers/social_providers.dart';
import 'package:rightlogistics/src/core/presentation/providers/nav_providers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rightlogistics/src/features/social/presentation/widgets/social_post_cards.dart';
import 'package:rightlogistics/src/features/social/presentation/status_viewer_screen.dart';
import 'package:rightlogistics/src/core/utils/auth_action_guard.dart';

class SocialHubScreen extends ConsumerWidget {
  const SocialHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // New Content Notification Listener
    ref.listen(activePostsProvider, (previous, next) {
      if (previous?.value != null &&
          next.value != null &&
          next.value!.length > previous!.value!.length) {
        final newPost = next.value!.first;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'New ${newPost.type.name} from ${newPost.vendorName}!',
            ),
            action: SnackBarAction(label: 'VIEW', onPressed: () {}),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });

    final postsAsync = ref.watch(activePostsProvider);
    final statusesAsync = ref.watch(activeStatusesProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final user = ref.watch(currentUserProvider); // Watch user for auth state

    Future.microtask(() {
      if (!context.mounted) return;
      final actions = <AppBarAction>[];

      if (user != null) {
        if (user.role == UserRole.vendor) {
          actions.add(
            AppBarAction(
              icon: FontAwesomeIcons.plus,
              label: 'Add Post',
              onPressed: () {
                if (context.mounted) context.push('/social/create');
              },
            ),
          );
        }
        actions.addAll([
          AppBarAction(
            icon: FontAwesomeIcons.users,
            label: 'My Vendors',
            onPressed: () {},
          ),
          AppBarAction(
            icon: FontAwesomeIcons.bookmark,
            label: 'Saved Posts',
            onPressed: () {},
          ),
        ]);
      } else {
        actions.add(
          AppBarAction(
            icon: FontAwesomeIcons.rightToBracket,
            label: 'Sign In',
            onPressed: () {
              if (context.mounted) {
                final location = GoRouterState.of(context).uri.toString();
                final encodedLocation = Uri.encodeComponent(location);
                context.push('/login?redirect=$encodedLocation');
              }
            },
          ),
        );
      }

      final location = GoRouterState.of(context).uri.path;
      ref
          .read(appBarConfigProvider(location).notifier)
          .setConfig(
            AppBarConfig(
              title: 'SOCIAL HUB',
              isSearchEnabled: true,
              searchHint: 'Search posts, vendors...',
              actions: actions,
            ),
          );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          // ignore: unused_result
          ref.refresh(activePostsProvider);
          // ignore: unused_result
          ref.refresh(activeStatusesProvider);
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
          slivers: [
            SliverToBoxAdapter(
              child: statusesAsync.when(
                data: (statuses) =>
                    _buildStoriesSection(context, ref, statuses),
                loading: () => _buildStoriesShimmer(context),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
            postsAsync.when(
              data: (posts) {
                final filteredPosts = posts.where((p) {
                  if (searchQuery.isEmpty) return true;
                  final term = searchQuery.toLowerCase();
                  return p.description.toLowerCase().contains(term) ||
                      p.vendorName.toLowerCase().contains(term) ||
                      (p.title?.toLowerCase().contains(term) ?? false);
                }).toList();

                if (filteredPosts.isEmpty) {
                  return SliverFillRemaining(
                    child: EmptyState(
                      icon: searchQuery.isEmpty
                          ? Icons.auto_awesome_motion_rounded
                          : Icons.search_off_rounded,
                      title: searchQuery.isEmpty
                          ? 'No Updates Yet'
                          : 'No Results Found',
                      description: searchQuery.isEmpty
                          ? 'Be the first to share what\'s happening!'
                          : 'Try searching with different keywords.',
                      actionLabel: searchQuery.isEmpty
                          ? 'Post Update'
                          : 'Clear Search',
                      onAction: () {
                        if (searchQuery.isEmpty) {
                          context.push('/social/create');
                        } else {
                          ref.read(searchQueryProvider.notifier).state = '';
                          ref.read(isSearchingProvider.notifier).state = false;
                        }
                      },
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 8.h,
                      ),
                      child: _buildSocialPost(
                        context,
                        ref,
                        filteredPosts[index],
                      ),
                    ),
                    childCount: filteredPosts.length,
                  ),
                );
              },
              loading: () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 8.h,
                    ),
                    child: _buildPostShimmer(context),
                  ),
                  childCount: 3,
                ),
              ),
              error: (e, __) =>
                  SliverFillRemaining(child: Center(child: Text('Error: $e'))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesSection(
    BuildContext context,
    WidgetRef ref,
    List<StatusModel> statuses,
  ) {
    if (statuses.isEmpty) return const SizedBox.shrink();

    // Group by Vendor
    final Map<String, List<StatusModel>> grouped = {};
    for (var s in statuses) {
      if (!grouped.containsKey(s.vendorId)) grouped[s.vendorId] = [];
      grouped[s.vendorId]!.add(s);
    }
    final vendorIds = grouped.keys.toList();

    return Container(
      height: 120.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        scrollDirection: Axis.horizontal,
        itemCount: vendorIds.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Need to pass ref from build method.
            // But _buildStoriesSection doesn't have ref.
            // I need to update _buildStoriesSection signature first.
            // Actually, I can just use Consumer in the item builder or pass ref down.
            // Passing ref down is cleaner here.
            return _buildAddStoryButton(context, ref);
          }
          final vendorId = vendorIds[index - 1];
          final vendorStatuses = grouped[vendorId]!;
          final preview = vendorStatuses.first;

          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        StatusViewerScreen(statuses: vendorStatuses),
                  ),
                );
              },
              child: _buildStoryCircle(context, preview, vendorStatuses.length),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddStoryButton(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              AuthActionGuard.protect(
                context,
                ref,
                onAuthenticated: () {
                  context.push('/social/create');
                },
              );
            },
            child: Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withOpacity(0.1),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.2),
                  width: 1.5.w,
                ),
              ),
              child: Icon(Icons.add_rounded, color: colorScheme.primary),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Create',
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCircle(
    BuildContext context,
    StatusModel preview,
    int count,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        CustomPaint(
          painter: StoryBorderPainter(
            count: count,
            color: AppTheme.successGreen,
          ),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 24.w,
              backgroundColor: colorScheme.primary.withOpacity(0.1),
              backgroundImage: preview.vendorPhotoUrl != null
                  ? CachedNetworkImageProvider(preview.vendorPhotoUrl!)
                  : null,
              child: preview.vendorPhotoUrl == null
                  ? Text(
                      preview.vendorName[0],
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          preview.vendorName.split(' ')[0],
          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildSocialPost(
    BuildContext context,
    WidgetRef ref,
    VendorPost post,
  ) {
    switch (post.type) {
      case PostType.pre_Order:
        // Purchase types usually have a title for pre-orders
        if (post.title != null && post.title!.isNotEmpty) {
          return PreOrderPostCard(post: post);
        }
        return GeneralPostCard(post: post);
      case PostType.logistics:
      case PostType.warehouse:
        return LogisticsPostCard(post: post);
      case PostType.appreciation:
        return AppreciationPostCard(post: post);
      case PostType.promotion:
        return PromotionPostCard(post: post);
      default:
        return GeneralPostCard(post: post);
    }
  }

  Widget _buildStoriesShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        height: 120.h,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          separatorBuilder: (_, __) => SizedBox(width: 16.w),
          itemBuilder: (_, __) => Column(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                width: 40.w,
                height: 10.h,
                color: isDark ? Colors.black : Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        height: 300.h,
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(24.w),
        ),
      ),
    );
  }

  // Removed internal helper widgets as they are now in social_post_cards.dart
  // Search dialog removed in favor of global adaptive search in AppBar
}

class StoryBorderPainter extends CustomPainter {
  final int count;
  final Color color;

  StoryBorderPainter({required this.count, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (count <= 1) {
      canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
      return;
    }

    const double spacing = 0.15; // Spacing between segments in radians
    final double sweepAngle = (2 * pi / count) - spacing;

    for (int i = 0; i < count; i++) {
      final double startAngle = (2 * pi / count) * i - (pi / 2) + (spacing / 2);
      canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(StoryBorderPainter oldDelegate) =>
      oldDelegate.count != count || oldDelegate.color != color;
}
