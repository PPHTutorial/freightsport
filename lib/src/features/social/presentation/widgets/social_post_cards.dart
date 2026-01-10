import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/date_utils.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/social/presentation/providers/social_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rightlogistics/src/features/social/presentation/social_post_detail_screen.dart';
import 'package:rightlogistics/src/features/social/presentation/widgets/image_zoom_screen.dart';
import 'package:rightlogistics/src/core/utils/luminance_utils.dart';
import 'package:rightlogistics/src/features/social/presentation/providers/luminance_provider.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/core/utils/auth_action_guard.dart';
import 'package:share_plus/share_plus.dart';
import 'package:rightlogistics/src/features/profile/presentation/public_profile_screen.dart';

class SocialPostCard extends StatelessWidget {
  final VendorPost post;
  const SocialPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    switch (post.type) {
      case PostType.logistics:
      case PostType.warehouse:
      case PostType.warehouse_Supplier:
        return LogisticsPostCard(post: post);
      case PostType.promotion:
        return PromotionPostCard(post: post);
      case PostType.appreciation:
        return AppreciationPostCard(post: post);
      case PostType.pre_Order:
        return PreOrderPostCard(post: post);
      default:
        return GeneralPostCard(post: post);
    }
  }
}

class GeneralPostCard extends ConsumerWidget {
  final VendorPost post;
  const GeneralPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(currentUserProvider);
    final isLiked = post.likeIds.contains(user?.id);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SocialPostDetailScreen(post: post)),
      ),
      onDoubleTap: () {
        final u = user;
        if (u != null) {
          if (!isLiked) {
            ref.read(socialRepositoryProvider).likePost(post.id, u.id);
          } else {
            ref.read(socialRepositoryProvider).unlikePost(post.id, u.id);
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(24.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15.w,
              offset: Offset(0, 5.h),
            ),
          ],
          border: Border.all(
            color: colorScheme.outline.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PostHeader(post: post),
            if (post.imageUrls.isNotEmpty)
              _ImageCarousel(imageUrls: post.imageUrls, postId: post.id),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TypeBadge(type: post.type),
                  SizedBox(height: 12.h),
                  Text(
                    post.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      height: 1.6,
                      color: colorScheme.onSurface.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _EngagementActions(
                    post: post,
                    isLiked: isLiked,
                    userId: user?.id,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LogisticsPostCard extends ConsumerWidget {
  final VendorPost post;
  const LogisticsPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(currentUserProvider);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SocialPostDetailScreen(post: post)),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24.w),
          border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.05),
              blurRadius: 20.w,
              offset: Offset(0, 10.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PostHeader(post: post),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: Icon(
                          post.type == PostType.logistics
                              ? FontAwesomeIcons.plane
                              : FontAwesomeIcons.warehouse,
                          size: 16.w,
                          color: colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        post.type.name.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12.sp,
                          letterSpacing: 1.2,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              post.description,
              maxLines: 3,
              style: TextStyle(fontSize: 15.sp, height: 1.5),
            ),
            if (post.details != null) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16.w),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16.w,
                      color: colorScheme.primary,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        post.details!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => _QuotationDialog(post: post),
                ),
                icon: Icon(Icons.request_quote_rounded, size: 20.w),
                label: Text('GET QUOTATION', style: TextStyle(fontSize: 14.sp)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: _EngagementActions(
                post: post,
                isLiked: post.likeIds.contains(user?.id),
                userId: user?.id,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PromotionPostCard extends ConsumerWidget {
  final VendorPost post;
  const PromotionPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(currentUserProvider);
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SocialPostDetailScreen(post: post)),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24.w),
          border: Border.all(color: Colors.amber.withOpacity(0.3), width: 2.w),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.1),
              blurRadius: 15.w,
              offset: Offset(0, 5.h),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                if (post.imageUrls.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.w),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: post.imageUrls[0],
                      height: 180.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _ShimmerBox(height: 180.h),
                      errorWidget: (context, url, err) =>
                          const SocialErrorPlaceholder(),
                    ),
                  ),
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20.w),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.stars, color: Colors.white, size: 14.w),
                        SizedBox(width: 4.w),
                        Text(
                          'HOT PROMO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _PostHeader(post: post, isOverImage: true),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.description,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.w),
                            ),
                          ),
                          child: Text(
                            'CLAIM OFFER',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _EngagementActions(
                    post: post,
                    isLiked: post.likeIds.contains(user?.id),
                    userId: user?.id,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppreciationPostCard extends StatelessWidget {
  final VendorPost post;
  const AppreciationPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SocialPostDetailScreen(post: post)),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.accentOrange.withOpacity(0.8),
              const Color(0xFFFF8C00),
            ],
          ),
          borderRadius: BorderRadius.circular(24.w),
        ),
        child: Column(
          children: [
            _PostHeader(post: post),
            const SizedBox(height: 20),
            Icon(FontAwesomeIcons.heart, color: Colors.white, size: 40.w),
            SizedBox(height: 20.h),
            Text(
              post.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            _EngagementActions(
              post: post,
              isLiked: post.likeIds.contains(null),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class PreOrderPostCard extends ConsumerStatefulWidget {
  final VendorPost post;
  const PreOrderPostCard({super.key, required this.post});

  @override
  ConsumerState<PreOrderPostCard> createState() => _PreOrderPostCardState();
}

class _PreOrderPostCardState extends ConsumerState<PreOrderPostCard> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(currentUserProvider);
    final isLiked = widget.post.likeIds.contains(user?.id);
    final double minOrder = widget.post.minOrder?.toDouble() ?? 100.0;
    final double current = widget.post.currentOrderCount.toDouble();
    final double progress = (current / minOrder).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SocialPostDetailScreen(post: widget.post),
        ),
      ),
      onDoubleTap: () {
        final u = user;
        if (u != null) {
          if (!isLiked) {
            ref.read(socialRepositoryProvider).likePost(widget.post.id, u.id);
          } else {
            ref.read(socialRepositoryProvider).unlikePost(widget.post.id, u.id);
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(24.w),
          border: Border.all(color: AppTheme.accentOrange.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                if (widget.post.imageUrls.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ImageZoomScreen(imageUrls: widget.post.imageUrls),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'post_image_${widget.post.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.w),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: CachedNetworkImage(
                            imageUrl: widget.post.imageUrls[0],
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const _ShimmerBox(height: double.infinity),
                            errorWidget: (context, url, error) =>
                                const SocialErrorPlaceholder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                /* Positioned(
                  top: 16.h,
                  left: 16.w,
                  child: Expanded(child: 
                  )),
                 */
                _PostHeader(post: widget.post, isOverImage: true),
                Positioned(
                  bottom: 10.h,
                  left: 16.w,
                  child: _Badge(
                    label: 'PRE-ORDER',
                    color: AppTheme.accentOrange,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.post.title ?? 'Exclusive Drop',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${widget.post.currency} ${widget.post.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    widget.post.description,
                    maxLines: 2,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Min Order: ${minOrder.toInt()}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${(progress * 100).toStringAsFixed(0)}% Filled',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppTheme.accentOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ElevatedButton(
                        onPressed: () {
                          _showOrderDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentOrange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: 14.h,
                            horizontal: 24.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                        ),
                        child: Text(
                          'ORDER NOW',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _EngagementActions(
                    post: widget.post,
                    isLiked: isLiked,
                    userId: user?.id,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _PreOrderDialog(post: widget.post),
    );
  }
}

// --- Internal Utilities ---

class _PostHeader extends ConsumerWidget {
  final VendorPost post;
  final bool isOverImage;
  const _PostHeader({required this.post, this.isOverImage = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(currentUserProvider);

    // Determine Roles
    final isOwner = user?.id == post.vendorId;
    final isAdmin = user?.role == UserRole.admin;
    // Couriers are treated as standard users for social interactions unless specified otherwise

    Color textColor = colorScheme.onSurface;
    Color subtextColor = colorScheme.onSurfaceVariant;
    Color iconColor = colorScheme.onSurface;

    if (isOverImage && post.imageUrls.isNotEmpty) {
      final luminanceAsync = ref.watch(luminanceProvider(post.imageUrls[0]));

      luminanceAsync.whenData((luminance) {
        if (LuminanceUtils.isBright(luminance)) {
          // Image is bright -> use dark text
          textColor = Colors.black87;
          subtextColor = Colors.black54;
          iconColor = Colors.black87;
        } else {
          // Image is dark -> use white text
          textColor = Colors.white;
          subtextColor = Colors.white70;
          iconColor = Colors.white;
        }
      });
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: const BoxDecoration(),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.w),
                child: post.vendorPhotoUrl != null
                    ? CachedNetworkImage(
                        imageUrl: post.vendorPhotoUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            _ShimmerBox(height: 40.w),
                        errorWidget: (context, url, err) => Center(
                          child: Text(
                            post.vendorName.isNotEmpty
                                ? post.vendorName[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: iconColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          post.vendorName.isNotEmpty
                              ? post.vendorName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: iconColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.vendorName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: textColor,
                    ),
                  ),
                  Text(
                    DateUtilsHelper.timeAgo(post.createdAt),
                    style: TextStyle(color: subtextColor, fontSize: 11.sp),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz, size: 24.w, color: iconColor),
              menuPadding: EdgeInsets.all(12.w),
              onSelected: (value) =>
                  _handleHeaderAction(context, ref, value, post, isOwner),
              itemBuilder: (context) {
                final List<PopupMenuEntry<String>> items = [];

                // 1. Common Actions (Everyone sees these)
                items.add(
                  PopupMenuItem(
                    value: 'view_user',
                    child: Row(
                      children: [
                        Icon(Icons.person_outline, size: 18.w),
                        SizedBox(width: 12.w),
                        Text('View User', style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                  ),
                );

                // 2. Owner Actions
                if (isOwner) {
                  items.add(
                    PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share_outlined, size: 18.w),
                          SizedBox(width: 12.w),
                          Text('Share', style: TextStyle(fontSize: 14.sp)),
                        ],
                      ),
                    ),
                  );
                  items.add(const PopupMenuDivider());
                  items.add(
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18.w),
                          SizedBox(width: 12.w),
                          Text('Edit Post', style: TextStyle(fontSize: 14.sp)),
                        ],
                      ),
                    ),
                  );
                  items.add(
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 18.w,
                            color: Colors.red,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Delete Post',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                // 3. Admin Actions (Can moderate)
                else if (isAdmin) {
                  items.add(
                    PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share_outlined, size: 18.w),
                          SizedBox(width: 12.w),
                          Text('Share', style: TextStyle(fontSize: 14.sp)),
                        ],
                      ),
                    ),
                  );
                  items.add(const PopupMenuDivider());
                  items.add(
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 18.w,
                            color: Colors.red,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Delete Post (Admin)',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  items.add(
                    PopupMenuItem(
                      value:
                          'report', // Admins might want to test report flow or flag internally?
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag_outlined,
                            size: 18.w,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Flag/Report',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                // 4. Non-Owner / Standard User / Courier
                else {
                  items.add(
                    PopupMenuItem(
                      value: 'recommend',
                      child: Row(
                        children: [
                          Icon(Icons.thumb_up_outlined, size: 18.w),
                          SizedBox(width: 12.w),
                          Text(
                            'Recommend Post',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  );
                  items.add(
                    PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share_outlined, size: 18.w),
                          SizedBox(width: 12.w),
                          Text('Share', style: TextStyle(fontSize: 14.sp)),
                        ],
                      ),
                    ),
                  );
                  items.add(
                    PopupMenuItem(
                      value: 'follow',
                      child: Row(
                        children: [
                          Icon(Icons.person_add_outlined, size: 18.w),
                          SizedBox(width: 12.w),
                          Text(
                            'Follow User',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  );
                  items.add(const PopupMenuDivider());
                  items.add(
                    PopupMenuItem(
                      value: 'report',
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag_outlined,
                            size: 18.w,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Report Post',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  items.add(
                    PopupMenuItem(
                      value: 'not_interested',
                      child: Row(
                        children: [
                          Icon(Icons.visibility_off_outlined, size: 18.w),
                          SizedBox(width: 12.w),
                          Text(
                            'Not Interested',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  );
                  items.add(
                    PopupMenuItem(
                      value: 'hide',
                      child: Row(
                        children: [
                          Icon(
                            Icons.block_outlined,
                            size: 18.w,
                            color: Colors.red,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Hide posts from this user',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return items;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleHeaderAction(
    BuildContext context,
    WidgetRef ref,
    String action,
    VendorPost post,
    bool isOwner,
  ) async {
    // Hide any previous snackbars
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final currentUser = ref.read(currentUserProvider);

    switch (action) {
      case 'view_user':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PublicProfileScreen(userId: post.vendorId),
          ),
        );
        break;

      case 'recommend':
        // For now, treating recommend as a "super like" or just a like if not distinct
        if (currentUser != null) {
          ref.read(socialRepositoryProvider).likePost(post.id, currentUser.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You recommended this post!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please sign in to recommend posts.')),
          );
        }
        break;

      case 'share':
        final String content =
            "${post.title ?? 'Check out this post'} by ${post.vendorName}\n\n${post.description}\n\nView more on RightLogistics app!";
        await Share.share(content);
        break;

      case 'follow':
        if (currentUser == null) {
          AuthActionGuard.protect(context, ref, onAuthenticated: () {});
          return;
        }
        try {
          await ref
              .read(socialRepositoryProvider)
              .followUser(currentUser.id, post.vendorId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You are now following ${post.vendorName}')),
          );
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to follow: $e')));
        }
        break;

      case 'report':
        if (currentUser == null) {
          AuthActionGuard.protect(context, ref, onAuthenticated: () {});
          return;
        }
        final reason = await showDialog<String>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Reason for reporting'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'SPAM'),
                child: const Text('Spam or Misleading'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'INAPPROPRIATE'),
                child: const Text('Inappropriate Content'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'HARASSMENT'),
                child: const Text('Harassment or Hate Speech'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'OTHER'),
                child: const Text('Other'),
              ),
            ],
          ),
        );

        if (reason != null) {
          await ref
              .read(socialRepositoryProvider)
              .reportPost(post.id, currentUser.id, reason);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post reported. We will review it shortly.'),
            ),
          );
        }
        break;

      case 'not_interested':
        // We can hide it locally or call hidePost
        if (currentUser != null) {
          await ref
              .read(socialRepositoryProvider)
              .hidePost(post.id, currentUser.id);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('We will show fewer posts like this.')),
        );
        break;

      case 'hide':
        if (currentUser != null) {
          await ref
              .read(socialRepositoryProvider)
              .hidePost(post.id, currentUser.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post hidden from your feed.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please sign in to hide posts.')),
          );
        }
        break;

      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Post'),
            content: const Text('Are you sure you want to delete this post?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        );

        if (confirm == true) {
          try {
            await ref.read(socialRepositoryProvider).deletePost(post.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post deleted successfully')),
            );
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error deleting post: $e')));
          }
        }
        break;

      case 'edit':
        // TODO: Navigation to edit screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit feature coming soon!')),
        );
        break;

      default:
        // Handle unknown actions
        break;
    }
  }
}

class _EngagementActions extends ConsumerWidget {
  final VendorPost post;
  final bool isLiked;
  final String? userId;
  final Color? color;

  const _EngagementActions({
    required this.post,
    required this.isLiked,
    this.userId,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isBookmarked = post.bookmarkIds.contains(userId);
    final themeColor = color ?? Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      children: [
        _ActionButton(
          icon: isLiked ? Icons.favorite : Icons.favorite_border,
          label: post.likeIds.length.toString(),
          color: isLiked ? Colors.red : themeColor,
          onTap: () {
            if (userId == null) return;
            if (isLiked)
              ref.read(socialRepositoryProvider).unlikePost(post.id, userId!);
            else
              ref.read(socialRepositoryProvider).likePost(post.id, userId!);
          },
        ),
        const SizedBox(width: 20),
        _ActionButton(
          icon: FontAwesomeIcons.comment,
          label: post.commentCount.toString(),
          color: themeColor,
          onTap: () {},
        ),
        const SizedBox(width: 20),
        _ActionButton(
          icon: FontAwesomeIcons.shareFromSquare,
          label: post.shareCount.toString(),
          color: themeColor,
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Post Link Copied!'))),
        ),
        const SizedBox(width: 20),
        _ActionButton(
          icon: Icons.remove_red_eye_outlined,
          label: post.viewIds.length.toString(),
          color: themeColor,
          onTap: () {},
        ),
        const Spacer(),
        _ActionButton(
          icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          label: isBookmarked ? 'Saved' : null,
          color: isBookmarked ? Colors.amber : themeColor,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Saved to your collection!')),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color? color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.w,
            color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          if (label != null) ...[
            SizedBox(width: 6.w),
            Text(
              label!,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final PostType type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (type) {
      case PostType.promotion:
        color = Colors.purple;
        break;
      case PostType.new_Item:
        color = Colors.green;
        break;
      case PostType.logistics:
        color = Colors.blue;
        break;
      case PostType.warehouse:
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Text(
        type.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8.w),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 10.sp,
      ),
    ),
  );
}

class _PreOrderDialog extends StatefulWidget {
  final VendorPost post;
  const _PreOrderDialog({required this.post});

  @override
  State<_PreOrderDialog> createState() => _PreOrderDialogState();
}

class _PreOrderDialogState extends State<_PreOrderDialog> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final totalPrice = widget.post.price * _quantity;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400.w),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Details',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 24.w),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Product Preview
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.post.imageUrls.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.w),
                    child: CachedNetworkImage(
                      imageUrl: widget.post.imageUrls[0],
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.title ?? 'Pre-Order Item',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '${widget.post.currency} ${widget.post.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accentOrange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Quantity Selector
            Text(
              'Quantity',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _QuantityButton(
                  icon: Icons.remove,
                  onPressed: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                ),
                SizedBox(width: 16.w),
                Container(
                  width: 60.w,
                  alignment: Alignment.center,
                  child: Text(
                    '$_quantity',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                _QuantityButton(
                  icon: Icons.add,
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Total
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${widget.post.currency} ${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _proceedToPurchase();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentOrange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'PROCEED TO PURCHASE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _proceedToPurchase() {
    // TODO: Implement purchase/payment flow
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Purchase of $_quantity item(s) initiated!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: onPressed != null
          ? AppTheme.accentOrange
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8.w),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8.w),
        child: Container(
          width: 40.w,
          height: 40.w,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: onPressed != null
                ? Colors.white
                : colorScheme.onSurfaceVariant.withOpacity(0.5),
            size: 20.w,
          ),
        ),
      ),
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final String postId;
  const _ImageCarousel({required this.imageUrls, required this.postId});
  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 240.h,
          child: PageView.builder(
            itemCount: widget.imageUrls.length,
            onPageChanged: (val) => setState(() => _currentPage = val),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ImageZoomScreen(
                        imageUrls: widget.imageUrls,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'post_image_${widget.postId}_$index',
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.w),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          widget.imageUrls[index],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.w),
                        child: CachedNetworkImage(
                          imageUrl: widget.imageUrls[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) =>
                              const _ShimmerBox(height: double.infinity),
                          errorWidget: (context, url, err) =>
                              const SocialErrorPlaceholder(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.imageUrls.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.imageUrls.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentPage == index ? 20 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: _currentPage == index
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const _ShimmerBox({required this.height, this.width, this.borderRadius = 0});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class SocialErrorPlaceholder extends StatelessWidget {
  const SocialErrorPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_not_supported_rounded,
              color: colorScheme.primary.withOpacity(0.5),
              size: 40.w,
            ),
            SizedBox(height: 8.h),
            Text(
              'Failed to load media',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuotationDialog extends ConsumerStatefulWidget {
  final VendorPost post;
  const _QuotationDialog({required this.post});

  @override
  ConsumerState<_QuotationDialog> createState() => _QuotationDialogState();
}

class _QuotationDialogState extends ConsumerState<_QuotationDialog> {
  // Store the full rate objects to allow access in _calculatePrice
  List<Map<String, dynamic>> _cachedRates = [];
  int _selectedRateIndex = 0;

  final TextEditingController _unitsController = TextEditingController();
  double _estimatedTotal = 0.0;
  String _currency = '\$';

  @override
  void initState() {
    super.initState();
    _unitsController.addListener(_calculatePrice);
  }

  @override
  void dispose() {
    _unitsController.dispose();
    super.dispose();
  }

  void _calculatePrice() {
    if (_cachedRates.isEmpty || _selectedRateIndex >= _cachedRates.length) {
      if (mounted) setState(() => _estimatedTotal = 0.0);
      return;
    }

    final currentRate = _cachedRates[_selectedRateIndex];
    final ratePrice =
        double.tryParse(
          currentRate['amount']?.toString() ??
              currentRate['rate']?.toString() ??
              '0',
        ) ??
        0;
    final units = double.tryParse(_unitsController.text) ?? 0;

    double total = units * ratePrice;
    if (mounted) setState(() => _estimatedTotal = total);
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider(widget.post.vendorId));
    final colorScheme = Theme.of(context).colorScheme;

    return userAsync.when(
      loading: () => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Loading rates..."),
            ],
          ),
        ),
      ),
      error: (err, stack) => Dialog(
        child: Padding(padding: EdgeInsets.all(20), child: Text("Error: $err")),
      ),
      data: (user) {
        final rates = user?.vendorKyc?.vendorRates ?? [];
        if (rates.isEmpty) {
          return _buildNoRatesDialog(context);
        }

        // Initialize _cachedRates if it's the first time we have data
        if (_cachedRates.isEmpty) {
          _cachedRates = rates
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
          if (_cachedRates.isNotEmpty) {
            _selectedRateIndex = 0;
            // Schedule price calculation after build
            Future.microtask(() => _calculatePrice());
          }
        }

        return _buildDialogContent(context, _cachedRates, colorScheme);
      },
    );
  }

  Widget _buildNoRatesDialog(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 48.sp,
              color: Colors.orange,
            ),
            SizedBox(height: 16.h),
            Text(
              "No shipping rates available",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              "This vendor hasn't configured any shipping rates yet.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24.h),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogContent(
    BuildContext context,
    List<Map<String, dynamic>> rates,
    ColorScheme colorScheme,
  ) {
    // Determine UI labels based on selected rate (safe access)

    // Use index based selection to avoid object identity issues
    // If index is out of bounds (e.g. list changes), reset to 0
    final selectedIndex = _selectedRateIndex < rates.length
        ? _selectedRateIndex
        : 0;
    final currentRate = rates[selectedIndex];

    // "fields which are: amount, catgory, currency, service, type, and unit"
    final amount = currentRate['amount'] ?? currentRate['rate'] ?? '0';
    final category =
        currentRate['category'] ?? currentRate['itemCategory'] ?? 'General';
    final currency = currentRate['currency'] ?? _currency;
    final service = currentRate['service'] ?? 'Standard';
    final type = currentRate['type'] ?? 'Shipping';
    final unit = currentRate['unit'] ?? 'kg';

    // Update logic:
    // We need to display these specific fields to the user.
    // We allow user to select which rate (via Dropdown).
    // User enters weight.

    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(24.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Get Shipping Quote',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 24.w),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // 1. Selector - List all rates
              Text(
                "Service Type",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: selectedIndex,
                    items: List.generate(rates.length, (index) {
                      final r = rates[index];
                      final rType = r['type'] ?? 'Unknown';
                      final rService = r['service'] ?? '';
                      return DropdownMenuItem(
                        value: index,
                        child: Text(
                          '$rType ${rService.isNotEmpty ? "($rService)" : ""}',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      );
                    }),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedRateIndex = val;
                          _calculatePrice();
                        });
                      }
                    },
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // 2. Info Card - Showing specifically requested fields
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12.w),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(context, "Category", category.toString()),
                    _buildInfoRow(context, "Service", service.toString()),
                    _buildInfoRow(context, "Unit", unit.toString()),
                    _buildInfoRow(context, "Rate Amount", "$currency $amount"),
                    // Add Min weight/volume if relevant? User didn't ask explicitly but it's good UX.
                    // We stick to what user asked first.
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // 3. User Input (Weight/Units)
              Text(
                "Enter Weight ($unit)",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: _unitsController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: "0.0",
                  suffixText: unit.toString(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // 4. Total Calculation
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.calculator,
                      color: colorScheme.onPrimaryContainer,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        "Estimated Cost",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    Text(
                      "$currency ${_estimatedTotal.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // 5. Action Buttons
              /*    Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        // _proceedToBooking(currentRate);
                      },
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Request Quote"),
                    ),
                  ),
                ],
              ),
            */
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 13.sp,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}
