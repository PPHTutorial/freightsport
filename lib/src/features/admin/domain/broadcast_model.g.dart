// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BroadcastMessageImpl _$$BroadcastMessageImplFromJson(
  Map<String, dynamic> json,
) => _$BroadcastMessageImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  imageUrl: json['imageUrl'] as String?,
  senderRole:
      $enumDecodeNullable(_$UserRoleEnumMap, json['senderRole']) ??
      UserRole.admin,
  senderId: json['senderId'] as String,
  senderName: json['senderName'] as String,
  targetRoles:
      (json['targetRoles'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$UserRoleEnumMap, e))
          .toList() ??
      const [],
  targetUserIds:
      (json['targetUserIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  priority:
      $enumDecodeNullable(_$BroadcastPriorityEnumMap, json['priority']) ??
      BroadcastPriority.normal,
  status:
      $enumDecodeNullable(_$BroadcastStatusEnumMap, json['status']) ??
      BroadcastStatus.draft,
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  scheduledFor: const TimestampNullableConverter().fromJson(
    json['scheduledFor'],
  ),
  sentAt: const TimestampNullableConverter().fromJson(json['sentAt']),
  expiresAt: const TimestampNullableConverter().fromJson(json['expiresAt']),
  readByIds:
      (json['readByIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
  actionUrl: json['actionUrl'] as String?,
  actionLabel: json['actionLabel'] as String?,
);

Map<String, dynamic> _$$BroadcastMessageImplToJson(
  _$BroadcastMessageImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'imageUrl': instance.imageUrl,
  'senderRole': _$UserRoleEnumMap[instance.senderRole]!,
  'senderId': instance.senderId,
  'senderName': instance.senderName,
  'targetRoles': instance.targetRoles
      .map((e) => _$UserRoleEnumMap[e]!)
      .toList(),
  'targetUserIds': instance.targetUserIds,
  'priority': _$BroadcastPriorityEnumMap[instance.priority]!,
  'status': _$BroadcastStatusEnumMap[instance.status]!,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'scheduledFor': const TimestampNullableConverter().toJson(
    instance.scheduledFor,
  ),
  'sentAt': const TimestampNullableConverter().toJson(instance.sentAt),
  'expiresAt': const TimestampNullableConverter().toJson(instance.expiresAt),
  'readByIds': instance.readByIds,
  'metadata': instance.metadata,
  'actionUrl': instance.actionUrl,
  'actionLabel': instance.actionLabel,
};

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.vendor: 'vendor',
  UserRole.courier: 'courier',
  UserRole.customer: 'customer',
};

const _$BroadcastPriorityEnumMap = {
  BroadcastPriority.low: 'low',
  BroadcastPriority.normal: 'normal',
  BroadcastPriority.high: 'high',
  BroadcastPriority.urgent: 'urgent',
};

const _$BroadcastStatusEnumMap = {
  BroadcastStatus.draft: 'draft',
  BroadcastStatus.scheduled: 'scheduled',
  BroadcastStatus.sent: 'sent',
  BroadcastStatus.expired: 'expired',
};
