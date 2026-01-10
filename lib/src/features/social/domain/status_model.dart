import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rightlogistics/src/core/utils/json_converters.dart';

part 'status_model.freezed.dart';
part 'status_model.g.dart';

@freezed
class StatusModel with _$StatusModel {
  const factory StatusModel({
    required String id,
    required String vendorId,
    required String vendorName,
    String? vendorPhotoUrl,
    required String mediaUrl,
    @Default('image') String mediaType, // 'image' or 'video'
    String? caption,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime expiresAt,
    @Default([]) List<String> viewerIds,
    @Default([]) List<String> likeIds, // New
    @Default(0) int commentCount, // New
    @Default(0) int shareCount, // New
    @Default({}) Map<String, dynamic> metadata,
  }) = _StatusModel;

  factory StatusModel.fromJson(Map<String, dynamic> json) =>
      _$StatusModelFromJson(json);
}
