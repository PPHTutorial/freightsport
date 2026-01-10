// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StatusModel _$StatusModelFromJson(Map<String, dynamic> json) {
  return _StatusModel.fromJson(json);
}

/// @nodoc
mixin _$StatusModel {
  String get id => throw _privateConstructorUsedError;
  String get vendorId => throw _privateConstructorUsedError;
  String get vendorName => throw _privateConstructorUsedError;
  String? get vendorPhotoUrl => throw _privateConstructorUsedError;
  String get mediaUrl => throw _privateConstructorUsedError;
  String get mediaType =>
      throw _privateConstructorUsedError; // 'image' or 'video'
  String? get caption => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get expiresAt => throw _privateConstructorUsedError;
  List<String> get viewerIds => throw _privateConstructorUsedError;
  List<String> get likeIds => throw _privateConstructorUsedError; // New
  int get commentCount => throw _privateConstructorUsedError; // New
  int get shareCount => throw _privateConstructorUsedError; // New
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this StatusModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatusModelCopyWith<StatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusModelCopyWith<$Res> {
  factory $StatusModelCopyWith(
    StatusModel value,
    $Res Function(StatusModel) then,
  ) = _$StatusModelCopyWithImpl<$Res, StatusModel>;
  @useResult
  $Res call({
    String id,
    String vendorId,
    String vendorName,
    String? vendorPhotoUrl,
    String mediaUrl,
    String mediaType,
    String? caption,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime expiresAt,
    List<String> viewerIds,
    List<String> likeIds,
    int commentCount,
    int shareCount,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class _$StatusModelCopyWithImpl<$Res, $Val extends StatusModel>
    implements $StatusModelCopyWith<$Res> {
  _$StatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? vendorName = null,
    Object? vendorPhotoUrl = freezed,
    Object? mediaUrl = null,
    Object? mediaType = null,
    Object? caption = freezed,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? viewerIds = null,
    Object? likeIds = null,
    Object? commentCount = null,
    Object? shareCount = null,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            vendorId: null == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                      as String,
            vendorName: null == vendorName
                ? _value.vendorName
                : vendorName // ignore: cast_nullable_to_non_nullable
                      as String,
            vendorPhotoUrl: freezed == vendorPhotoUrl
                ? _value.vendorPhotoUrl
                : vendorPhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            mediaUrl: null == mediaUrl
                ? _value.mediaUrl
                : mediaUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            mediaType: null == mediaType
                ? _value.mediaType
                : mediaType // ignore: cast_nullable_to_non_nullable
                      as String,
            caption: freezed == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            viewerIds: null == viewerIds
                ? _value.viewerIds
                : viewerIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            likeIds: null == likeIds
                ? _value.likeIds
                : likeIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            commentCount: null == commentCount
                ? _value.commentCount
                : commentCount // ignore: cast_nullable_to_non_nullable
                      as int,
            shareCount: null == shareCount
                ? _value.shareCount
                : shareCount // ignore: cast_nullable_to_non_nullable
                      as int,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StatusModelImplCopyWith<$Res>
    implements $StatusModelCopyWith<$Res> {
  factory _$$StatusModelImplCopyWith(
    _$StatusModelImpl value,
    $Res Function(_$StatusModelImpl) then,
  ) = __$$StatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String vendorId,
    String vendorName,
    String? vendorPhotoUrl,
    String mediaUrl,
    String mediaType,
    String? caption,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime expiresAt,
    List<String> viewerIds,
    List<String> likeIds,
    int commentCount,
    int shareCount,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class __$$StatusModelImplCopyWithImpl<$Res>
    extends _$StatusModelCopyWithImpl<$Res, _$StatusModelImpl>
    implements _$$StatusModelImplCopyWith<$Res> {
  __$$StatusModelImplCopyWithImpl(
    _$StatusModelImpl _value,
    $Res Function(_$StatusModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? vendorName = null,
    Object? vendorPhotoUrl = freezed,
    Object? mediaUrl = null,
    Object? mediaType = null,
    Object? caption = freezed,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? viewerIds = null,
    Object? likeIds = null,
    Object? commentCount = null,
    Object? shareCount = null,
    Object? metadata = null,
  }) {
    return _then(
      _$StatusModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        vendorId: null == vendorId
            ? _value.vendorId
            : vendorId // ignore: cast_nullable_to_non_nullable
                  as String,
        vendorName: null == vendorName
            ? _value.vendorName
            : vendorName // ignore: cast_nullable_to_non_nullable
                  as String,
        vendorPhotoUrl: freezed == vendorPhotoUrl
            ? _value.vendorPhotoUrl
            : vendorPhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        mediaUrl: null == mediaUrl
            ? _value.mediaUrl
            : mediaUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        mediaType: null == mediaType
            ? _value.mediaType
            : mediaType // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: freezed == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        viewerIds: null == viewerIds
            ? _value._viewerIds
            : viewerIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        likeIds: null == likeIds
            ? _value._likeIds
            : likeIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        commentCount: null == commentCount
            ? _value.commentCount
            : commentCount // ignore: cast_nullable_to_non_nullable
                  as int,
        shareCount: null == shareCount
            ? _value.shareCount
            : shareCount // ignore: cast_nullable_to_non_nullable
                  as int,
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StatusModelImpl implements _StatusModel {
  const _$StatusModelImpl({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    this.vendorPhotoUrl,
    required this.mediaUrl,
    this.mediaType = 'image',
    this.caption,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.expiresAt,
    final List<String> viewerIds = const [],
    final List<String> likeIds = const [],
    this.commentCount = 0,
    this.shareCount = 0,
    final Map<String, dynamic> metadata = const {},
  }) : _viewerIds = viewerIds,
       _likeIds = likeIds,
       _metadata = metadata;

  factory _$StatusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatusModelImplFromJson(json);

  @override
  final String id;
  @override
  final String vendorId;
  @override
  final String vendorName;
  @override
  final String? vendorPhotoUrl;
  @override
  final String mediaUrl;
  @override
  @JsonKey()
  final String mediaType;
  // 'image' or 'video'
  @override
  final String? caption;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime expiresAt;
  final List<String> _viewerIds;
  @override
  @JsonKey()
  List<String> get viewerIds {
    if (_viewerIds is EqualUnmodifiableListView) return _viewerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_viewerIds);
  }

  final List<String> _likeIds;
  @override
  @JsonKey()
  List<String> get likeIds {
    if (_likeIds is EqualUnmodifiableListView) return _likeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likeIds);
  }

  // New
  @override
  @JsonKey()
  final int commentCount;
  // New
  @override
  @JsonKey()
  final int shareCount;
  // New
  final Map<String, dynamic> _metadata;
  // New
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'StatusModel(id: $id, vendorId: $vendorId, vendorName: $vendorName, vendorPhotoUrl: $vendorPhotoUrl, mediaUrl: $mediaUrl, mediaType: $mediaType, caption: $caption, createdAt: $createdAt, expiresAt: $expiresAt, viewerIds: $viewerIds, likeIds: $likeIds, commentCount: $commentCount, shareCount: $shareCount, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.vendorPhotoUrl, vendorPhotoUrl) ||
                other.vendorPhotoUrl == vendorPhotoUrl) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(
              other._viewerIds,
              _viewerIds,
            ) &&
            const DeepCollectionEquality().equals(other._likeIds, _likeIds) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.shareCount, shareCount) ||
                other.shareCount == shareCount) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    vendorId,
    vendorName,
    vendorPhotoUrl,
    mediaUrl,
    mediaType,
    caption,
    createdAt,
    expiresAt,
    const DeepCollectionEquality().hash(_viewerIds),
    const DeepCollectionEquality().hash(_likeIds),
    commentCount,
    shareCount,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of StatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusModelImplCopyWith<_$StatusModelImpl> get copyWith =>
      __$$StatusModelImplCopyWithImpl<_$StatusModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatusModelImplToJson(this);
  }
}

abstract class _StatusModel implements StatusModel {
  const factory _StatusModel({
    required final String id,
    required final String vendorId,
    required final String vendorName,
    final String? vendorPhotoUrl,
    required final String mediaUrl,
    final String mediaType,
    final String? caption,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime expiresAt,
    final List<String> viewerIds,
    final List<String> likeIds,
    final int commentCount,
    final int shareCount,
    final Map<String, dynamic> metadata,
  }) = _$StatusModelImpl;

  factory _StatusModel.fromJson(Map<String, dynamic> json) =
      _$StatusModelImpl.fromJson;

  @override
  String get id;
  @override
  String get vendorId;
  @override
  String get vendorName;
  @override
  String? get vendorPhotoUrl;
  @override
  String get mediaUrl;
  @override
  String get mediaType; // 'image' or 'video'
  @override
  String? get caption;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get expiresAt;
  @override
  List<String> get viewerIds;
  @override
  List<String> get likeIds; // New
  @override
  int get commentCount; // New
  @override
  int get shareCount; // New
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of StatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatusModelImplCopyWith<_$StatusModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
