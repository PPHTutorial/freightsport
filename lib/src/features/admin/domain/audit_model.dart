import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_model.freezed.dart';
part 'audit_model.g.dart';

@freezed
class AuditLog with _$AuditLog {
  const factory AuditLog({
    required String id,
    required String action, // e.g., "CREATE_USER", "DELETE_POST"
    required String targetId, // ID of the affected entity
    required String targetType, // e.g., "users", "posts"
    required String performedByUserId,
    required String performedByUserName,
    required DateTime timestamp,
    Map<String, dynamic>? metadata, // Extra details like changes made
    String? note,
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);
}
