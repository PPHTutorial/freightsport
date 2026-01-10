// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatusModelImpl _$$StatusModelImplFromJson(
  Map<String, dynamic> json,
) => _$StatusModelImpl(
  id: json['id'] as String,
  vendorId: json['vendorId'] as String,
  vendorName: json['vendorName'] as String,
  vendorPhotoUrl: json['vendorPhotoUrl'] as String?,
  mediaUrl: json['mediaUrl'] as String,
  mediaType: json['mediaType'] as String? ?? 'image',
  caption: json['caption'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  expiresAt: const TimestampConverter().fromJson(json['expiresAt'] as Object),
  viewerIds:
      (json['viewerIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  likeIds:
      (json['likeIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
  shareCount: (json['shareCount'] as num?)?.toInt() ?? 0,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$StatusModelImplToJson(_$StatusModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendorId': instance.vendorId,
      'vendorName': instance.vendorName,
      'vendorPhotoUrl': instance.vendorPhotoUrl,
      'mediaUrl': instance.mediaUrl,
      'mediaType': instance.mediaType,
      'caption': instance.caption,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'expiresAt': const TimestampConverter().toJson(instance.expiresAt),
      'viewerIds': instance.viewerIds,
      'likeIds': instance.likeIds,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
      'metadata': instance.metadata,
    };
