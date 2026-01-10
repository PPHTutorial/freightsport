import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rightlogistics/src/features/reviews/domain/review_model.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback? onDelete;

  const ReviewCard({super.key, required this.review, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.w,
                  backgroundImage: review.reviewerPhotoUrl != null
                      ? CachedNetworkImageProvider(review.reviewerPhotoUrl!)
                      : null,
                  child: review.reviewerPhotoUrl == null
                      ? Text(
                          review.reviewerName?[0].toUpperCase() ?? '?',
                          style: TextStyle(fontSize: 16.sp),
                        )
                      : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review.reviewerName ?? 'Anonymous',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (review.isVerifiedPurchase) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.w),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'VERIFIED',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          _buildStars(review.rating),
                          SizedBox(width: 8.w),
                          Text(
                            timeago.format(review.timestamp),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    iconSize: 20.w,
                    color: Colors.red,
                    onPressed: onDelete,
                  ),
              ],
            ),
            if (review.comment.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                review.comment,
                style: TextStyle(fontSize: 13.sp, height: 1.4),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 14.w,
        );
      }),
    );
  }
}
