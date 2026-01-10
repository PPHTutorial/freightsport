import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rightlogistics/src/core/utils/json_converters.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';

part 'broadcast_model.freezed.dart';
part 'broadcast_model.g.dart';

enum BroadcastPriority {
  @JsonValue('low')
  low,
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

enum BroadcastStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('sent')
  sent,
  @JsonValue('expired')
  expired,
}

@freezed
class BroadcastMessage with _$BroadcastMessage {
  const factory BroadcastMessage({
    required String id,
    required String title,
    required String content,
    String? imageUrl,
    @Default(UserRole.admin) UserRole senderRole,
    required String senderId,
    required String senderName,
    @Default([]) List<UserRole> targetRoles, // Empty = all roles
    @Default([]) List<String> targetUserIds, // Specific users (optional)
    @Default(BroadcastPriority.normal) BroadcastPriority priority,
    @Default(BroadcastStatus.draft) BroadcastStatus status,
    @TimestampConverter() required DateTime createdAt,
    @TimestampNullableConverter() DateTime? scheduledFor,
    @TimestampNullableConverter() DateTime? sentAt,
    @TimestampNullableConverter() DateTime? expiresAt,
    @Default([]) List<String> readByIds,
    @Default({}) Map<String, dynamic> metadata,
    String? actionUrl, // Deep link for call-to-action
    String? actionLabel, // Button text like "View Shipment"
  }) = _BroadcastMessage;

  factory BroadcastMessage.fromJson(Map<String, dynamic> json) =>
      _$BroadcastMessageFromJson(json);
}
