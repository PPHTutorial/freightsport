import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';

class RatingDisplayWidget extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final Map<String, int> ratingBreakdown;
  final bool showBreakdown;

  const RatingDisplayWidget({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    this.ratingBreakdown = const {},
    this.showBreakdown = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: GoogleFonts.redHatDisplay(
                fontSize: 48.sp,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStars(averageRating),
                SizedBox(height: 4.h),
                Text(
                  '$totalReviews ${totalReviews == 1 ? 'review' : 'reviews'}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (showBreakdown && ratingBreakdown.isNotEmpty) ...[
          SizedBox(height: 16.h),
          _buildRatingBreakdown(context),
        ],
      ],
    );
  }

  Widget _buildStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: Colors.amber, size: 20.w);
        } else if (index < rating) {
          return Icon(Icons.star_half, color: Colors.amber, size: 20.w);
        } else {
          return Icon(Icons.star_border, color: Colors.grey, size: 20.w);
        }
      }),
    );
  }

  Widget _buildRatingBreakdown(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        final starCount = 5 - index;
        final count = ratingBreakdown[starCount.toString()] ?? 0;
        final percentage = totalReviews > 0
            ? (count / totalReviews * 100).round()
            : 0;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Row(
            children: [
              Text('$starCount', style: TextStyle(fontSize: 12.sp)),
              SizedBox(width: 4.w),
              Icon(Icons.star, color: Colors.amber, size: 14.w),
              SizedBox(width: 8.w),
              Expanded(
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
