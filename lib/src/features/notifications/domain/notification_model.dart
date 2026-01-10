import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.parse(json);
    return DateTime.now();
  }

  @override
  dynamic toJson(DateTime date) => Timestamp.fromDate(date);
}

enum NotificationType {
  @JsonValue('alert')
  alert,
  @JsonValue('info')
  info,
  @JsonValue('shipment')
  shipment,
  @JsonValue('promo')
  promo,
  @JsonValue('message')
  message,
}

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String message,
    required NotificationType type,
    @TimestampConverter() required DateTime timestamp,
    @Default(false) bool isRead,
    String? targetUserId,
    String? relatedShipmentId,
    String? senderId,
    String? senderName,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
