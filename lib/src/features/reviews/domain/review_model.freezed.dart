// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return _Review.fromJson(json);
}

/// @nodoc
mixin _$Review {
  String get id => throw _privateConstructorUsedError;
  String get reviewerId => throw _privateConstructorUsedError;
  String get revieweeId => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError; // 1-5 stars
  String get comment => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get shipmentId =>
      throw _privateConstructorUsedError; // Optional link to transaction
  bool get isVerifiedPurchase => throw _privateConstructorUsedError;
  String? get reviewerName => throw _privateConstructorUsedError;
  String? get reviewerPhotoUrl => throw _privateConstructorUsedError;

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewCopyWith<Review> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewCopyWith<$Res> {
  factory $ReviewCopyWith(Review value, $Res Function(Review) then) =
      _$ReviewCopyWithImpl<$Res, Review>;
  @useResult
  $Res call({
    String id,
    String reviewerId,
    String revieweeId,
    int rating,
    String comment,
    DateTime timestamp,
    String? shipmentId,
    bool isVerifiedPurchase,
    String? reviewerName,
    String? reviewerPhotoUrl,
  });
}

/// @nodoc
class _$ReviewCopyWithImpl<$Res, $Val extends Review>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reviewerId = null,
    Object? revieweeId = null,
    Object? rating = null,
    Object? comment = null,
    Object? timestamp = null,
    Object? shipmentId = freezed,
    Object? isVerifiedPurchase = null,
    Object? reviewerName = freezed,
    Object? reviewerPhotoUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reviewerId: null == reviewerId
                ? _value.reviewerId
                : reviewerId // ignore: cast_nullable_to_non_nullable
                      as String,
            revieweeId: null == revieweeId
                ? _value.revieweeId
                : revieweeId // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as int,
            comment: null == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            shipmentId: freezed == shipmentId
                ? _value.shipmentId
                : shipmentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isVerifiedPurchase: null == isVerifiedPurchase
                ? _value.isVerifiedPurchase
                : isVerifiedPurchase // ignore: cast_nullable_to_non_nullable
                      as bool,
            reviewerName: freezed == reviewerName
                ? _value.reviewerName
                : reviewerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            reviewerPhotoUrl: freezed == reviewerPhotoUrl
                ? _value.reviewerPhotoUrl
                : reviewerPhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewImplCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$$ReviewImplCopyWith(
    _$ReviewImpl value,
    $Res Function(_$ReviewImpl) then,
  ) = __$$ReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reviewerId,
    String revieweeId,
    int rating,
    String comment,
    DateTime timestamp,
    String? shipmentId,
    bool isVerifiedPurchase,
    String? reviewerName,
    String? reviewerPhotoUrl,
  });
}

/// @nodoc
class __$$ReviewImplCopyWithImpl<$Res>
    extends _$ReviewCopyWithImpl<$Res, _$ReviewImpl>
    implements _$$ReviewImplCopyWith<$Res> {
  __$$ReviewImplCopyWithImpl(
    _$ReviewImpl _value,
    $Res Function(_$ReviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reviewerId = null,
    Object? revieweeId = null,
    Object? rating = null,
    Object? comment = null,
    Object? timestamp = null,
    Object? shipmentId = freezed,
    Object? isVerifiedPurchase = null,
    Object? reviewerName = freezed,
    Object? reviewerPhotoUrl = freezed,
  }) {
    return _then(
      _$ReviewImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewerId: null == reviewerId
            ? _value.reviewerId
            : reviewerId // ignore: cast_nullable_to_non_nullable
                  as String,
        revieweeId: null == revieweeId
            ? _value.revieweeId
            : revieweeId // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
        comment: null == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        shipmentId: freezed == shipmentId
            ? _value.shipmentId
            : shipmentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isVerifiedPurchase: null == isVerifiedPurchase
            ? _value.isVerifiedPurchase
            : isVerifiedPurchase // ignore: cast_nullable_to_non_nullable
                  as bool,
        reviewerName: freezed == reviewerName
            ? _value.reviewerName
            : reviewerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        reviewerPhotoUrl: freezed == reviewerPhotoUrl
            ? _value.reviewerPhotoUrl
            : reviewerPhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewImpl implements _Review {
  const _$ReviewImpl({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    this.comment = '',
    required this.timestamp,
    this.shipmentId,
    this.isVerifiedPurchase = false,
    this.reviewerName,
    this.reviewerPhotoUrl,
  });

  factory _$ReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewImplFromJson(json);

  @override
  final String id;
  @override
  final String reviewerId;
  @override
  final String revieweeId;
  @override
  final int rating;
  // 1-5 stars
  @override
  @JsonKey()
  final String comment;
  @override
  final DateTime timestamp;
  @override
  final String? shipmentId;
  // Optional link to transaction
  @override
  @JsonKey()
  final bool isVerifiedPurchase;
  @override
  final String? reviewerName;
  @override
  final String? reviewerPhotoUrl;

  @override
  String toString() {
    return 'Review(id: $id, reviewerId: $reviewerId, revieweeId: $revieweeId, rating: $rating, comment: $comment, timestamp: $timestamp, shipmentId: $shipmentId, isVerifiedPurchase: $isVerifiedPurchase, reviewerName: $reviewerName, reviewerPhotoUrl: $reviewerPhotoUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.revieweeId, revieweeId) ||
                other.revieweeId == revieweeId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.shipmentId, shipmentId) ||
                other.shipmentId == shipmentId) &&
            (identical(other.isVerifiedPurchase, isVerifiedPurchase) ||
                other.isVerifiedPurchase == isVerifiedPurchase) &&
            (identical(other.reviewerName, reviewerName) ||
                other.reviewerName == reviewerName) &&
            (identical(other.reviewerPhotoUrl, reviewerPhotoUrl) ||
                other.reviewerPhotoUrl == reviewerPhotoUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    reviewerId,
    revieweeId,
    rating,
    comment,
    timestamp,
    shipmentId,
    isVerifiedPurchase,
    reviewerName,
    reviewerPhotoUrl,
  );

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      __$$ReviewImplCopyWithImpl<_$ReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewImplToJson(this);
  }
}

abstract class _Review implements Review {
  const factory _Review({
    required final String id,
    required final String reviewerId,
    required final String revieweeId,
    required final int rating,
    final String comment,
    required final DateTime timestamp,
    final String? shipmentId,
    final bool isVerifiedPurchase,
    final String? reviewerName,
    final String? reviewerPhotoUrl,
  }) = _$ReviewImpl;

  factory _Review.fromJson(Map<String, dynamic> json) = _$ReviewImpl.fromJson;

  @override
  String get id;
  @override
  String get reviewerId;
  @override
  String get revieweeId;
  @override
  int get rating; // 1-5 stars
  @override
  String get comment;
  @override
  DateTime get timestamp;
  @override
  String? get shipmentId; // Optional link to transaction
  @override
  bool get isVerifiedPurchase;
  @override
  String? get reviewerName;
  @override
  String? get reviewerPhotoUrl;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
