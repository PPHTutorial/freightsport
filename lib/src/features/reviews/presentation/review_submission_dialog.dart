import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/reviews/data/review_repository.dart';
import 'package:rightlogistics/src/features/reviews/domain/review_model.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewSubmissionDialog extends ConsumerStatefulWidget {
  final String revieweeId;
  final String revieweeName;
  final String? shipmentId;
  final bool isVerifiedPurchase;

  const ReviewSubmissionDialog({
    super.key,
    required this.revieweeId,
    required this.revieweeName,
    this.shipmentId,
    this.isVerifiedPurchase = false,
  });

  @override
  ConsumerState<ReviewSubmissionDialog> createState() =>
      _ReviewSubmissionDialogState();
}

class _ReviewSubmissionDialogState
    extends ConsumerState<ReviewSubmissionDialog> {
  int _rating = 0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a rating')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) return;

      final review = Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        reviewerId: currentUser.id,
        revieweeId: widget.revieweeId,
        rating: _rating,
        comment: _commentController.text.trim(),
        timestamp: DateTime.now(),
        shipmentId: widget.shipmentId,
        isVerifiedPurchase: widget.isVerifiedPurchase,
        reviewerName: currentUser.name,
        reviewerPhotoUrl: currentUser.photoUrl,
      );

      await ReviewRepository().createReview(review);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error submitting review: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Rate ${widget.revieweeName}',
        style: GoogleFonts.redHatDisplay(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'How would you rate your experience?',
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 36.w,
                ),
                onPressed: () => setState(() => _rating = index + 1),
              );
            }),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Comment (optional)',
              hintText: 'Share your experience...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            maxLength: 500,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitReview,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }
}
