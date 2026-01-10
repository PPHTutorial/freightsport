// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  timestamp: const TimestampConverter().fromJson(json['timestamp']),
  isRead: json['isRead'] as bool? ?? false,
  targetUserId: json['targetUserId'] as String?,
  relatedShipmentId: json['relatedShipmentId'] as String?,
  senderId: json['senderId'] as String?,
  senderName: json['senderName'] as String?,
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'message': instance.message,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'timestamp': const TimestampConverter().toJson(instance.timestamp),
  'isRead': instance.isRead,
  'targetUserId': instance.targetUserId,
  'relatedShipmentId': instance.relatedShipmentId,
  'senderId': instance.senderId,
  'senderName': instance.senderName,
};

const _$NotificationTypeEnumMap = {
  NotificationType.alert: 'alert',
  NotificationType.info: 'info',
  NotificationType.shipment: 'shipment',
  NotificationType.promo: 'promo',
  NotificationType.message: 'message',
};
