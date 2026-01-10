// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'broadcast_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BroadcastMessage _$BroadcastMessageFromJson(Map<String, dynamic> json) {
  return _BroadcastMessage.fromJson(json);
}

/// @nodoc
mixin _$BroadcastMessage {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  UserRole get senderRole => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  List<UserRole> get targetRoles =>
      throw _privateConstructorUsedError; // Empty = all roles
  List<String> get targetUserIds =>
      throw _privateConstructorUsedError; // Specific users (optional)
  BroadcastPriority get priority => throw _privateConstructorUsedError;
  BroadcastStatus get status => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampNullableConverter()
  DateTime? get scheduledFor => throw _privateConstructorUsedError;
  @TimestampNullableConverter()
  DateTime? get sentAt => throw _privateConstructorUsedError;
  @TimestampNullableConverter()
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  List<String> get readByIds => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  String? get actionUrl =>
      throw _privateConstructorUsedError; // Deep link for call-to-action
  String? get actionLabel => throw _privateConstructorUsedError;

  /// Serializes this BroadcastMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BroadcastMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BroadcastMessageCopyWith<BroadcastMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BroadcastMessageCopyWith<$Res> {
  factory $BroadcastMessageCopyWith(
    BroadcastMessage value,
    $Res Function(BroadcastMessage) then,
  ) = _$BroadcastMessageCopyWithImpl<$Res, BroadcastMessage>;
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    String? imageUrl,
    UserRole senderRole,
    String senderId,
    String senderName,
    List<UserRole> targetRoles,
    List<String> targetUserIds,
    BroadcastPriority priority,
    BroadcastStatus status,
    @TimestampConverter() DateTime createdAt,
    @TimestampNullableConverter() DateTime? scheduledFor,
    @TimestampNullableConverter() DateTime? sentAt,
    @TimestampNullableConverter() DateTime? expiresAt,
    List<String> readByIds,
    Map<String, dynamic> metadata,
    String? actionUrl,
    String? actionLabel,
  });
}

/// @nodoc
class _$BroadcastMessageCopyWithImpl<$Res, $Val extends BroadcastMessage>
    implements $BroadcastMessageCopyWith<$Res> {
  _$BroadcastMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BroadcastMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? imageUrl = freezed,
    Object? senderRole = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? targetRoles = null,
    Object? targetUserIds = null,
    Object? priority = null,
    Object? status = null,
    Object? createdAt = null,
    Object? scheduledFor = freezed,
    Object? sentAt = freezed,
    Object? expiresAt = freezed,
    Object? readByIds = null,
    Object? metadata = null,
    Object? actionUrl = freezed,
    Object? actionLabel = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            senderRole: null == senderRole
                ? _value.senderRole
                : senderRole // ignore: cast_nullable_to_non_nullable
                      as UserRole,
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderName: null == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                      as String,
            targetRoles: null == targetRoles
                ? _value.targetRoles
                : targetRoles // ignore: cast_nullable_to_non_nullable
                      as List<UserRole>,
            targetUserIds: null == targetUserIds
                ? _value.targetUserIds
                : targetUserIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as BroadcastPriority,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BroadcastStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            scheduledFor: freezed == scheduledFor
                ? _value.scheduledFor
                : scheduledFor // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            sentAt: freezed == sentAt
                ? _value.sentAt
                : sentAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            readByIds: null == readByIds
                ? _value.readByIds
                : readByIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            actionUrl: freezed == actionUrl
                ? _value.actionUrl
                : actionUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            actionLabel: freezed == actionLabel
                ? _value.actionLabel
                : actionLabel // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BroadcastMessageImplCopyWith<$Res>
    implements $BroadcastMessageCopyWith<$Res> {
  factory _$$BroadcastMessageImplCopyWith(
    _$BroadcastMessageImpl value,
    $Res Function(_$BroadcastMessageImpl) then,
  ) = __$$BroadcastMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    String? imageUrl,
    UserRole senderRole,
    String senderId,
    String senderName,
    List<UserRole> targetRoles,
    List<String> targetUserIds,
    BroadcastPriority priority,
    BroadcastStatus status,
    @TimestampConverter() DateTime createdAt,
    @TimestampNullableConverter() DateTime? scheduledFor,
    @TimestampNullableConverter() DateTime? sentAt,
    @TimestampNullableConverter() DateTime? expiresAt,
    List<String> readByIds,
    Map<String, dynamic> metadata,
    String? actionUrl,
    String? actionLabel,
  });
}

/// @nodoc
class __$$BroadcastMessageImplCopyWithImpl<$Res>
    extends _$BroadcastMessageCopyWithImpl<$Res, _$BroadcastMessageImpl>
    implements _$$BroadcastMessageImplCopyWith<$Res> {
  __$$BroadcastMessageImplCopyWithImpl(
    _$BroadcastMessageImpl _value,
    $Res Function(_$BroadcastMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BroadcastMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? imageUrl = freezed,
    Object? senderRole = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? targetRoles = null,
    Object? targetUserIds = null,
    Object? priority = null,
    Object? status = null,
    Object? createdAt = null,
    Object? scheduledFor = freezed,
    Object? sentAt = freezed,
    Object? expiresAt = freezed,
    Object? readByIds = null,
    Object? metadata = null,
    Object? actionUrl = freezed,
    Object? actionLabel = freezed,
  }) {
    return _then(
      _$BroadcastMessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        senderRole: null == senderRole
            ? _value.senderRole
            : senderRole // ignore: cast_nullable_to_non_nullable
                  as UserRole,
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderName: null == senderName
            ? _value.senderName
            : senderName // ignore: cast_nullable_to_non_nullable
                  as String,
        targetRoles: null == targetRoles
            ? _value._targetRoles
            : targetRoles // ignore: cast_nullable_to_non_nullable
                  as List<UserRole>,
        targetUserIds: null == targetUserIds
            ? _value._targetUserIds
            : targetUserIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as BroadcastPriority,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BroadcastStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        scheduledFor: freezed == scheduledFor
            ? _value.scheduledFor
            : scheduledFor // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        sentAt: freezed == sentAt
            ? _value.sentAt
            : sentAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        readByIds: null == readByIds
            ? _value._readByIds
            : readByIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        actionUrl: freezed == actionUrl
            ? _value.actionUrl
            : actionUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        actionLabel: freezed == actionLabel
            ? _value.actionLabel
            : actionLabel // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BroadcastMessageImpl implements _BroadcastMessage {
  const _$BroadcastMessageImpl({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.senderRole = UserRole.admin,
    required this.senderId,
    required this.senderName,
    final List<UserRole> targetRoles = const [],
    final List<String> targetUserIds = const [],
    this.priority = BroadcastPriority.normal,
    this.status = BroadcastStatus.draft,
    @TimestampConverter() required this.createdAt,
    @TimestampNullableConverter() this.scheduledFor,
    @TimestampNullableConverter() this.sentAt,
    @TimestampNullableConverter() this.expiresAt,
    final List<String> readByIds = const [],
    final Map<String, dynamic> metadata = const {},
    this.actionUrl,
    this.actionLabel,
  }) : _targetRoles = targetRoles,
       _targetUserIds = targetUserIds,
       _readByIds = readByIds,
       _metadata = metadata;

  factory _$BroadcastMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$BroadcastMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final UserRole senderRole;
  @override
  final String senderId;
  @override
  final String senderName;
  final List<UserRole> _targetRoles;
  @override
  @JsonKey()
  List<UserRole> get targetRoles {
    if (_targetRoles is EqualUnmodifiableListView) return _targetRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetRoles);
  }

  // Empty = all roles
  final List<String> _targetUserIds;
  // Empty = all roles
  @override
  @JsonKey()
  List<String> get targetUserIds {
    if (_targetUserIds is EqualUnmodifiableListView) return _targetUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetUserIds);
  }

  // Specific users (optional)
  @override
  @JsonKey()
  final BroadcastPriority priority;
  @override
  @JsonKey()
  final BroadcastStatus status;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampNullableConverter()
  final DateTime? scheduledFor;
  @override
  @TimestampNullableConverter()
  final DateTime? sentAt;
  @override
  @TimestampNullableConverter()
  final DateTime? expiresAt;
  final List<String> _readByIds;
  @override
  @JsonKey()
  List<String> get readByIds {
    if (_readByIds is EqualUnmodifiableListView) return _readByIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_readByIds);
  }

  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final String? actionUrl;
  // Deep link for call-to-action
  @override
  final String? actionLabel;

  @override
  String toString() {
    return 'BroadcastMessage(id: $id, title: $title, content: $content, imageUrl: $imageUrl, senderRole: $senderRole, senderId: $senderId, senderName: $senderName, targetRoles: $targetRoles, targetUserIds: $targetUserIds, priority: $priority, status: $status, createdAt: $createdAt, scheduledFor: $scheduledFor, sentAt: $sentAt, expiresAt: $expiresAt, readByIds: $readByIds, metadata: $metadata, actionUrl: $actionUrl, actionLabel: $actionLabel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BroadcastMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.senderRole, senderRole) ||
                other.senderRole == senderRole) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            const DeepCollectionEquality().equals(
              other._targetRoles,
              _targetRoles,
            ) &&
            const DeepCollectionEquality().equals(
              other._targetUserIds,
              _targetUserIds,
            ) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(
              other._readByIds,
              _readByIds,
            ) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.actionLabel, actionLabel) ||
                other.actionLabel == actionLabel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    content,
    imageUrl,
    senderRole,
    senderId,
    senderName,
    const DeepCollectionEquality().hash(_targetRoles),
    const DeepCollectionEquality().hash(_targetUserIds),
    priority,
    status,
    createdAt,
    scheduledFor,
    sentAt,
    expiresAt,
    const DeepCollectionEquality().hash(_readByIds),
    const DeepCollectionEquality().hash(_metadata),
    actionUrl,
    actionLabel,
  ]);

  /// Create a copy of BroadcastMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BroadcastMessageImplCopyWith<_$BroadcastMessageImpl> get copyWith =>
      __$$BroadcastMessageImplCopyWithImpl<_$BroadcastMessageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BroadcastMessageImplToJson(this);
  }
}

abstract class _BroadcastMessage implements BroadcastMessage {
  const factory _BroadcastMessage({
    required final String id,
    required final String title,
    required final String content,
    final String? imageUrl,
    final UserRole senderRole,
    required final String senderId,
    required final String senderName,
    final List<UserRole> targetRoles,
    final List<String> targetUserIds,
    final BroadcastPriority priority,
    final BroadcastStatus status,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampNullableConverter() final DateTime? scheduledFor,
    @TimestampNullableConverter() final DateTime? sentAt,
    @TimestampNullableConverter() final DateTime? expiresAt,
    final List<String> readByIds,
    final Map<String, dynamic> metadata,
    final String? actionUrl,
    final String? actionLabel,
  }) = _$BroadcastMessageImpl;

  factory _BroadcastMessage.fromJson(Map<String, dynamic> json) =
      _$BroadcastMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  String? get imageUrl;
  @override
  UserRole get senderRole;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  List<UserRole> get targetRoles; // Empty = all roles
  @override
  List<String> get targetUserIds; // Specific users (optional)
  @override
  BroadcastPriority get priority;
  @override
  BroadcastStatus get status;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampNullableConverter()
  DateTime? get scheduledFor;
  @override
  @TimestampNullableConverter()
  DateTime? get sentAt;
  @override
  @TimestampNullableConverter()
  DateTime? get expiresAt;
  @override
  List<String> get readByIds;
  @override
  Map<String, dynamic> get metadata;
  @override
  String? get actionUrl; // Deep link for call-to-action
  @override
  String? get actionLabel;

  /// Create a copy of BroadcastMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BroadcastMessageImplCopyWith<_$BroadcastMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
