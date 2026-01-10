import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    required String reviewerId,
    required String revieweeId,
    required int rating, // 1-5 stars
    @Default('') String comment,
    required DateTime timestamp,
    String? shipmentId, // Optional link to transaction
    @Default(false) bool isVerifiedPurchase,
    String? reviewerName,
    String? reviewerPhotoUrl,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  // Firestore converter helpers
  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Review.fromJson({
      ...data,
      'id': doc.id,
      'timestamp': (data['timestamp'] as Timestamp).toDate().toIso8601String(),
    });
  }

  static Map<String, dynamic> toFirestore(Review review) {
    final json = review.toJson();
    json['timestamp'] = Timestamp.fromDate(review.timestamp);
    return json;
  }
}
