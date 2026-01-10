import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rightlogistics/src/features/reviews/domain/review_model.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a new review
  Future<void> createReview(Review review) async {
    await _firestore
        .collection('reviews')
        .doc(review.id)
        .set(Review.toFirestore(review));

    // Update reviewee's rating stats
    await updateUserRatingStats(review.revieweeId);
  }

  /// Get reviews for a specific user (as reviewee)
  Stream<List<Review>> watchReviewsForUser(String userId, {int limit = 10}) {
    return _firestore
        .collection('reviews')
        .where('revieweeId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList(),
        );
  }

  /// Get rating summary for a user
  Future<Map<String, dynamic>> getUserRatingSummary(String userId) async {
    final reviews = await _firestore
        .collection('reviews')
        .where('revieweeId', isEqualTo: userId)
        .get();

    if (reviews.docs.isEmpty) {
      return {
        'averageRating': 0.0,
        'totalReviews': 0,
        'ratingBreakdown': <String, int>{},
      };
    }

    final ratings = reviews.docs
        .map((doc) => (doc.data()['rating'] as int))
        .toList();

    final ratingBreakdown = <String, int>{};
    for (int i = 1; i <= 5; i++) {
      ratingBreakdown[i.toString()] = ratings.where((r) => r == i).length;
    }

    final averageRating = ratings.reduce((a, b) => a + b) / ratings.length;

    return {
      'averageRating': averageRating,
      'totalReviews': ratings.length,
      'ratingBreakdown': ratingBreakdown,
    };
  }

  /// Update user's rating statistics (called after creating a review)
  Future<void> updateUserRatingStats(String userId) async {
    final summary = await getUserRatingSummary(userId);

    await _firestore.collection('users').doc(userId).update({
      'averageRating': summary['averageRating'],
      'totalReviews': summary['totalReviews'],
      'ratingBreakdown': summary['ratingBreakdown'],
    });
  }

  /// Check if a user can review another user for a specific shipment
  Future<bool> canUserReview({
    required String reviewerId,
    required String revieweeId,
    String? shipmentId,
  }) async {
    // Check if review already exists
    final existingReview = await _firestore
        .collection('reviews')
        .where('reviewerId', isEqualTo: reviewerId)
        .where('revieweeId', isEqualTo: revieweeId)
        .where('shipmentId', isEqualTo: shipmentId)
        .get();

    return existingReview.docs.isEmpty;
  }

  /// Delete a review (admin only)
  Future<void> deleteReview(String reviewId, String revieweeId) async {
    await _firestore.collection('reviews').doc(reviewId).delete();
    await updateUserRatingStats(revieweeId);
  }
}
