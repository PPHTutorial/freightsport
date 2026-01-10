// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
  id: json['id'] as String,
  reviewerId: json['reviewerId'] as String,
  revieweeId: json['revieweeId'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String? ?? '',
  timestamp: DateTime.parse(json['timestamp'] as String),
  shipmentId: json['shipmentId'] as String?,
  isVerifiedPurchase: json['isVerifiedPurchase'] as bool? ?? false,
  reviewerName: json['reviewerName'] as String?,
  reviewerPhotoUrl: json['reviewerPhotoUrl'] as String?,
);

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reviewerId': instance.reviewerId,
      'revieweeId': instance.revieweeId,
      'rating': instance.rating,
      'comment': instance.comment,
      'timestamp': instance.timestamp.toIso8601String(),
      'shipmentId': instance.shipmentId,
      'isVerifiedPurchase': instance.isVerifiedPurchase,
      'reviewerName': instance.reviewerName,
      'reviewerPhotoUrl': instance.reviewerPhotoUrl,
    };
