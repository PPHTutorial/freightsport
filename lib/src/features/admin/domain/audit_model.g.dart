// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditLogImpl _$$AuditLogImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogImpl(
      id: json['id'] as String,
      action: json['action'] as String,
      targetId: json['targetId'] as String,
      targetType: json['targetType'] as String,
      performedByUserId: json['performedByUserId'] as String,
      performedByUserName: json['performedByUserName'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$AuditLogImplToJson(_$AuditLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'targetId': instance.targetId,
      'targetType': instance.targetType,
      'performedByUserId': instance.performedByUserId,
      'performedByUserName': instance.performedByUserName,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
      'note': instance.note,
    };
