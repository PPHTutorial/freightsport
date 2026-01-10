// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VendorPost _$VendorPostFromJson(Map<String, dynamic> json) {
  return _VendorPost.fromJson(json);
}

/// @nodoc
mixin _$VendorPost {
  String get id => throw _privateConstructorUsedError;
  String get vendorId => throw _privateConstructorUsedError;
  String get vendorName => throw _privateConstructorUsedError;
  String? get vendorPhotoUrl => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  String? get title =>
      throw _privateConstructorUsedError; // New: For Pre-Orders
  String get description => throw _privateConstructorUsedError;
  String? get details => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError; // Changed to double
  String get currency => throw _privateConstructorUsedError;
  bool get isPurchasable =>
      throw _privateConstructorUsedError; // Pre-Order & Shipping Specifics
  int? get minOrder => throw _privateConstructorUsedError; // Target amount
  int? get maxOrder => throw _privateConstructorUsedError;
  int get currentOrderCount => throw _privateConstructorUsedError; // Progress
  @TimestampNullableConverter()
  DateTime? get eta => throw _privateConstructorUsedError;
  String? get deliveryTime =>
      throw _privateConstructorUsedError; // e.g., "3-5 days"
  String? get deliveryMode =>
      throw _privateConstructorUsedError; // e.g., "Air Freight"
  PostType get type => throw _privateConstructorUsedError;
  PostVisibility get visibility => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get expiresAt => throw _privateConstructorUsedError;
  List<String> get viewIds =>
      throw _privateConstructorUsedError; // New: Tracking views
  List<String> get likeIds => throw _privateConstructorUsedError;
  List<String> get bookmarkIds => throw _privateConstructorUsedError; // New
  int get commentCount => throw _privateConstructorUsedError;
  int get shareCount => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  /// Serializes this VendorPost to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorPostCopyWith<VendorPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorPostCopyWith<$Res> {
  factory $VendorPostCopyWith(
    VendorPost value,
    $Res Function(VendorPost) then,
  ) = _$VendorPostCopyWithImpl<$Res, VendorPost>;
  @useResult
  $Res call({
    String id,
    String vendorId,
    String vendorName,
    String? vendorPhotoUrl,
    List<String> imageUrls,
    String? title,
    String description,
    String? details,
    double price,
    String currency,
    bool isPurchasable,
    int? minOrder,
    int? maxOrder,
    int currentOrderCount,
    @TimestampNullableConverter() DateTime? eta,
    String? deliveryTime,
    String? deliveryMode,
    PostType type,
    PostVisibility visibility,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime expiresAt,
    List<String> viewIds,
    List<String> likeIds,
    List<String> bookmarkIds,
    int commentCount,
    int shareCount,
    Map<String, dynamic> metadata,
    List<String> tags,
  });
}

/// @nodoc
class _$VendorPostCopyWithImpl<$Res, $Val extends VendorPost>
    implements $VendorPostCopyWith<$Res> {
  _$VendorPostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? vendorName = null,
    Object? vendorPhotoUrl = freezed,
    Object? imageUrls = null,
    Object? title = freezed,
    Object? description = null,
    Object? details = freezed,
    Object? price = null,
    Object? currency = null,
    Object? isPurchasable = null,
    Object? minOrder = freezed,
    Object? maxOrder = freezed,
    Object? currentOrderCount = null,
    Object? eta = freezed,
    Object? deliveryTime = freezed,
    Object? deliveryMode = freezed,
    Object? type = null,
    Object? visibility = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? viewIds = null,
    Object? likeIds = null,
    Object? bookmarkIds = null,
    Object? commentCount = null,
    Object? shareCount = null,
    Object? metadata = null,
    Object? tags = null,
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
            imageUrls: null == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            details: freezed == details
                ? _value.details
                : details // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            isPurchasable: null == isPurchasable
                ? _value.isPurchasable
                : isPurchasable // ignore: cast_nullable_to_non_nullable
                      as bool,
            minOrder: freezed == minOrder
                ? _value.minOrder
                : minOrder // ignore: cast_nullable_to_non_nullable
                      as int?,
            maxOrder: freezed == maxOrder
                ? _value.maxOrder
                : maxOrder // ignore: cast_nullable_to_non_nullable
                      as int?,
            currentOrderCount: null == currentOrderCount
                ? _value.currentOrderCount
                : currentOrderCount // ignore: cast_nullable_to_non_nullable
                      as int,
            eta: freezed == eta
                ? _value.eta
                : eta // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deliveryTime: freezed == deliveryTime
                ? _value.deliveryTime
                : deliveryTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            deliveryMode: freezed == deliveryMode
                ? _value.deliveryMode
                : deliveryMode // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as PostType,
            visibility: null == visibility
                ? _value.visibility
                : visibility // ignore: cast_nullable_to_non_nullable
                      as PostVisibility,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            viewIds: null == viewIds
                ? _value.viewIds
                : viewIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            likeIds: null == likeIds
                ? _value.likeIds
                : likeIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            bookmarkIds: null == bookmarkIds
                ? _value.bookmarkIds
                : bookmarkIds // ignore: cast_nullable_to_non_nullable
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
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VendorPostImplCopyWith<$Res>
    implements $VendorPostCopyWith<$Res> {
  factory _$$VendorPostImplCopyWith(
    _$VendorPostImpl value,
    $Res Function(_$VendorPostImpl) then,
  ) = __$$VendorPostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String vendorId,
    String vendorName,
    String? vendorPhotoUrl,
    List<String> imageUrls,
    String? title,
    String description,
    String? details,
    double price,
    String currency,
    bool isPurchasable,
    int? minOrder,
    int? maxOrder,
    int currentOrderCount,
    @TimestampNullableConverter() DateTime? eta,
    String? deliveryTime,
    String? deliveryMode,
    PostType type,
    PostVisibility visibility,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime expiresAt,
    List<String> viewIds,
    List<String> likeIds,
    List<String> bookmarkIds,
    int commentCount,
    int shareCount,
    Map<String, dynamic> metadata,
    List<String> tags,
  });
}

/// @nodoc
class __$$VendorPostImplCopyWithImpl<$Res>
    extends _$VendorPostCopyWithImpl<$Res, _$VendorPostImpl>
    implements _$$VendorPostImplCopyWith<$Res> {
  __$$VendorPostImplCopyWithImpl(
    _$VendorPostImpl _value,
    $Res Function(_$VendorPostImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VendorPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? vendorName = null,
    Object? vendorPhotoUrl = freezed,
    Object? imageUrls = null,
    Object? title = freezed,
    Object? description = null,
    Object? details = freezed,
    Object? price = null,
    Object? currency = null,
    Object? isPurchasable = null,
    Object? minOrder = freezed,
    Object? maxOrder = freezed,
    Object? currentOrderCount = null,
    Object? eta = freezed,
    Object? deliveryTime = freezed,
    Object? deliveryMode = freezed,
    Object? type = null,
    Object? visibility = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? viewIds = null,
    Object? likeIds = null,
    Object? bookmarkIds = null,
    Object? commentCount = null,
    Object? shareCount = null,
    Object? metadata = null,
    Object? tags = null,
  }) {
    return _then(
      _$VendorPostImpl(
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
        imageUrls: null == imageUrls
            ? _value._imageUrls
            : imageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        details: freezed == details
            ? _value.details
            : details // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        isPurchasable: null == isPurchasable
            ? _value.isPurchasable
            : isPurchasable // ignore: cast_nullable_to_non_nullable
                  as bool,
        minOrder: freezed == minOrder
            ? _value.minOrder
            : minOrder // ignore: cast_nullable_to_non_nullable
                  as int?,
        maxOrder: freezed == maxOrder
            ? _value.maxOrder
            : maxOrder // ignore: cast_nullable_to_non_nullable
                  as int?,
        currentOrderCount: null == currentOrderCount
            ? _value.currentOrderCount
            : currentOrderCount // ignore: cast_nullable_to_non_nullable
                  as int,
        eta: freezed == eta
            ? _value.eta
            : eta // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deliveryTime: freezed == deliveryTime
            ? _value.deliveryTime
            : deliveryTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryMode: freezed == deliveryMode
            ? _value.deliveryMode
            : deliveryMode // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as PostType,
        visibility: null == visibility
            ? _value.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as PostVisibility,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        viewIds: null == viewIds
            ? _value._viewIds
            : viewIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        likeIds: null == likeIds
            ? _value._likeIds
            : likeIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        bookmarkIds: null == bookmarkIds
            ? _value._bookmarkIds
            : bookmarkIds // ignore: cast_nullable_to_non_nullable
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
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VendorPostImpl implements _VendorPost {
  const _$VendorPostImpl({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    this.vendorPhotoUrl,
    final List<String> imageUrls = const [],
    this.title,
    required this.description,
    this.details,
    this.price = 0.0,
    this.currency = 'GHS',
    this.isPurchasable = false,
    this.minOrder,
    this.maxOrder,
    this.currentOrderCount = 0,
    @TimestampNullableConverter() this.eta,
    this.deliveryTime,
    this.deliveryMode,
    this.type = PostType.update,
    this.visibility = PostVisibility.public,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.expiresAt,
    final List<String> viewIds = const [],
    final List<String> likeIds = const [],
    final List<String> bookmarkIds = const [],
    this.commentCount = 0,
    this.shareCount = 0,
    final Map<String, dynamic> metadata = const {},
    final List<String> tags = const [],
  }) : _imageUrls = imageUrls,
       _viewIds = viewIds,
       _likeIds = likeIds,
       _bookmarkIds = bookmarkIds,
       _metadata = metadata,
       _tags = tags;

  factory _$VendorPostImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorPostImplFromJson(json);

  @override
  final String id;
  @override
  final String vendorId;
  @override
  final String vendorName;
  @override
  final String? vendorPhotoUrl;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  final String? title;
  // New: For Pre-Orders
  @override
  final String description;
  @override
  final String? details;
  @override
  @JsonKey()
  final double price;
  // Changed to double
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey()
  final bool isPurchasable;
  // Pre-Order & Shipping Specifics
  @override
  final int? minOrder;
  // Target amount
  @override
  final int? maxOrder;
  @override
  @JsonKey()
  final int currentOrderCount;
  // Progress
  @override
  @TimestampNullableConverter()
  final DateTime? eta;
  @override
  final String? deliveryTime;
  // e.g., "3-5 days"
  @override
  final String? deliveryMode;
  // e.g., "Air Freight"
  @override
  @JsonKey()
  final PostType type;
  @override
  @JsonKey()
  final PostVisibility visibility;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime expiresAt;
  final List<String> _viewIds;
  @override
  @JsonKey()
  List<String> get viewIds {
    if (_viewIds is EqualUnmodifiableListView) return _viewIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_viewIds);
  }

  // New: Tracking views
  final List<String> _likeIds;
  // New: Tracking views
  @override
  @JsonKey()
  List<String> get likeIds {
    if (_likeIds is EqualUnmodifiableListView) return _likeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likeIds);
  }

  final List<String> _bookmarkIds;
  @override
  @JsonKey()
  List<String> get bookmarkIds {
    if (_bookmarkIds is EqualUnmodifiableListView) return _bookmarkIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookmarkIds);
  }

  // New
  @override
  @JsonKey()
  final int commentCount;
  @override
  @JsonKey()
  final int shareCount;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'VendorPost(id: $id, vendorId: $vendorId, vendorName: $vendorName, vendorPhotoUrl: $vendorPhotoUrl, imageUrls: $imageUrls, title: $title, description: $description, details: $details, price: $price, currency: $currency, isPurchasable: $isPurchasable, minOrder: $minOrder, maxOrder: $maxOrder, currentOrderCount: $currentOrderCount, eta: $eta, deliveryTime: $deliveryTime, deliveryMode: $deliveryMode, type: $type, visibility: $visibility, createdAt: $createdAt, expiresAt: $expiresAt, viewIds: $viewIds, likeIds: $likeIds, bookmarkIds: $bookmarkIds, commentCount: $commentCount, shareCount: $shareCount, metadata: $metadata, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorPostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.vendorPhotoUrl, vendorPhotoUrl) ||
                other.vendorPhotoUrl == vendorPhotoUrl) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.details, details) || other.details == details) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.isPurchasable, isPurchasable) ||
                other.isPurchasable == isPurchasable) &&
            (identical(other.minOrder, minOrder) ||
                other.minOrder == minOrder) &&
            (identical(other.maxOrder, maxOrder) ||
                other.maxOrder == maxOrder) &&
            (identical(other.currentOrderCount, currentOrderCount) ||
                other.currentOrderCount == currentOrderCount) &&
            (identical(other.eta, eta) || other.eta == eta) &&
            (identical(other.deliveryTime, deliveryTime) ||
                other.deliveryTime == deliveryTime) &&
            (identical(other.deliveryMode, deliveryMode) ||
                other.deliveryMode == deliveryMode) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(other._viewIds, _viewIds) &&
            const DeepCollectionEquality().equals(other._likeIds, _likeIds) &&
            const DeepCollectionEquality().equals(
              other._bookmarkIds,
              _bookmarkIds,
            ) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.shareCount, shareCount) ||
                other.shareCount == shareCount) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    vendorId,
    vendorName,
    vendorPhotoUrl,
    const DeepCollectionEquality().hash(_imageUrls),
    title,
    description,
    details,
    price,
    currency,
    isPurchasable,
    minOrder,
    maxOrder,
    currentOrderCount,
    eta,
    deliveryTime,
    deliveryMode,
    type,
    visibility,
    createdAt,
    expiresAt,
    const DeepCollectionEquality().hash(_viewIds),
    const DeepCollectionEquality().hash(_likeIds),
    const DeepCollectionEquality().hash(_bookmarkIds),
    commentCount,
    shareCount,
    const DeepCollectionEquality().hash(_metadata),
    const DeepCollectionEquality().hash(_tags),
  ]);

  /// Create a copy of VendorPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorPostImplCopyWith<_$VendorPostImpl> get copyWith =>
      __$$VendorPostImplCopyWithImpl<_$VendorPostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorPostImplToJson(this);
  }
}

abstract class _VendorPost implements VendorPost {
  const factory _VendorPost({
    required final String id,
    required final String vendorId,
    required final String vendorName,
    final String? vendorPhotoUrl,
    final List<String> imageUrls,
    final String? title,
    required final String description,
    final String? details,
    final double price,
    final String currency,
    final bool isPurchasable,
    final int? minOrder,
    final int? maxOrder,
    final int currentOrderCount,
    @TimestampNullableConverter() final DateTime? eta,
    final String? deliveryTime,
    final String? deliveryMode,
    final PostType type,
    final PostVisibility visibility,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime expiresAt,
    final List<String> viewIds,
    final List<String> likeIds,
    final List<String> bookmarkIds,
    final int commentCount,
    final int shareCount,
    final Map<String, dynamic> metadata,
    final List<String> tags,
  }) = _$VendorPostImpl;

  factory _VendorPost.fromJson(Map<String, dynamic> json) =
      _$VendorPostImpl.fromJson;

  @override
  String get id;
  @override
  String get vendorId;
  @override
  String get vendorName;
  @override
  String? get vendorPhotoUrl;
  @override
  List<String> get imageUrls;
  @override
  String? get title; // New: For Pre-Orders
  @override
  String get description;
  @override
  String? get details;
  @override
  double get price; // Changed to double
  @override
  String get currency;
  @override
  bool get isPurchasable; // Pre-Order & Shipping Specifics
  @override
  int? get minOrder; // Target amount
  @override
  int? get maxOrder;
  @override
  int get currentOrderCount; // Progress
  @override
  @TimestampNullableConverter()
  DateTime? get eta;
  @override
  String? get deliveryTime; // e.g., "3-5 days"
  @override
  String? get deliveryMode; // e.g., "Air Freight"
  @override
  PostType get type;
  @override
  PostVisibility get visibility;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get expiresAt;
  @override
  List<String> get viewIds; // New: Tracking views
  @override
  List<String> get likeIds;
  @override
  List<String> get bookmarkIds; // New
  @override
  int get commentCount;
  @override
  int get shareCount;
  @override
  Map<String, dynamic> get metadata;
  @override
  List<String> get tags;

  /// Create a copy of VendorPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorPostImplCopyWith<_$VendorPostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostComment _$PostCommentFromJson(Map<String, dynamic> json) {
  return _PostComment.fromJson(json);
}

/// @nodoc
mixin _$PostComment {
  String get id => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String? get parentId =>
      throw _privateConstructorUsedError; // New: For replies
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String? get userPhotoUrl => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<String> get likeIds =>
      throw _privateConstructorUsedError; // New: Like support
  int get replyCount => throw _privateConstructorUsedError; // New: Reply count
  List<String> get tags => throw _privateConstructorUsedError;

  /// Serializes this PostComment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCommentCopyWith<PostComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCommentCopyWith<$Res> {
  factory $PostCommentCopyWith(
    PostComment value,
    $Res Function(PostComment) then,
  ) = _$PostCommentCopyWithImpl<$Res, PostComment>;
  @useResult
  $Res call({
    String id,
    String postId,
    String? parentId,
    String userId,
    String userName,
    String? userPhotoUrl,
    String content,
    @TimestampConverter() DateTime createdAt,
    List<String> likeIds,
    int replyCount,
    List<String> tags,
  });
}

/// @nodoc
class _$PostCommentCopyWithImpl<$Res, $Val extends PostComment>
    implements $PostCommentCopyWith<$Res> {
  _$PostCommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? parentId = freezed,
    Object? userId = null,
    Object? userName = null,
    Object? userPhotoUrl = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? likeIds = null,
    Object? replyCount = null,
    Object? tags = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            postId: null == postId
                ? _value.postId
                : postId // ignore: cast_nullable_to_non_nullable
                      as String,
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            userPhotoUrl: freezed == userPhotoUrl
                ? _value.userPhotoUrl
                : userPhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            likeIds: null == likeIds
                ? _value.likeIds
                : likeIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            replyCount: null == replyCount
                ? _value.replyCount
                : replyCount // ignore: cast_nullable_to_non_nullable
                      as int,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostCommentImplCopyWith<$Res>
    implements $PostCommentCopyWith<$Res> {
  factory _$$PostCommentImplCopyWith(
    _$PostCommentImpl value,
    $Res Function(_$PostCommentImpl) then,
  ) = __$$PostCommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String postId,
    String? parentId,
    String userId,
    String userName,
    String? userPhotoUrl,
    String content,
    @TimestampConverter() DateTime createdAt,
    List<String> likeIds,
    int replyCount,
    List<String> tags,
  });
}

/// @nodoc
class __$$PostCommentImplCopyWithImpl<$Res>
    extends _$PostCommentCopyWithImpl<$Res, _$PostCommentImpl>
    implements _$$PostCommentImplCopyWith<$Res> {
  __$$PostCommentImplCopyWithImpl(
    _$PostCommentImpl _value,
    $Res Function(_$PostCommentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? parentId = freezed,
    Object? userId = null,
    Object? userName = null,
    Object? userPhotoUrl = freezed,
    Object? content = null,
    Object? createdAt = null,
    Object? likeIds = null,
    Object? replyCount = null,
    Object? tags = null,
  }) {
    return _then(
      _$PostCommentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        postId: null == postId
            ? _value.postId
            : postId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        userPhotoUrl: freezed == userPhotoUrl
            ? _value.userPhotoUrl
            : userPhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        likeIds: null == likeIds
            ? _value._likeIds
            : likeIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        replyCount: null == replyCount
            ? _value.replyCount
            : replyCount // ignore: cast_nullable_to_non_nullable
                  as int,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostCommentImpl implements _PostComment {
  const _$PostCommentImpl({
    required this.id,
    required this.postId,
    this.parentId,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.content,
    @TimestampConverter() required this.createdAt,
    final List<String> likeIds = const [],
    this.replyCount = 0,
    final List<String> tags = const [],
  }) : _likeIds = likeIds,
       _tags = tags;

  factory _$PostCommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostCommentImplFromJson(json);

  @override
  final String id;
  @override
  final String postId;
  @override
  final String? parentId;
  // New: For replies
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String? userPhotoUrl;
  @override
  final String content;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  final List<String> _likeIds;
  @override
  @JsonKey()
  List<String> get likeIds {
    if (_likeIds is EqualUnmodifiableListView) return _likeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likeIds);
  }

  // New: Like support
  @override
  @JsonKey()
  final int replyCount;
  // New: Reply count
  final List<String> _tags;
  // New: Reply count
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'PostComment(id: $id, postId: $postId, parentId: $parentId, userId: $userId, userName: $userName, userPhotoUrl: $userPhotoUrl, content: $content, createdAt: $createdAt, likeIds: $likeIds, replyCount: $replyCount, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostCommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userPhotoUrl, userPhotoUrl) ||
                other.userPhotoUrl == userPhotoUrl) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._likeIds, _likeIds) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    postId,
    parentId,
    userId,
    userName,
    userPhotoUrl,
    content,
    createdAt,
    const DeepCollectionEquality().hash(_likeIds),
    replyCount,
    const DeepCollectionEquality().hash(_tags),
  );

  /// Create a copy of PostComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostCommentImplCopyWith<_$PostCommentImpl> get copyWith =>
      __$$PostCommentImplCopyWithImpl<_$PostCommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostCommentImplToJson(this);
  }
}

abstract class _PostComment implements PostComment {
  const factory _PostComment({
    required final String id,
    required final String postId,
    final String? parentId,
    required final String userId,
    required final String userName,
    final String? userPhotoUrl,
    required final String content,
    @TimestampConverter() required final DateTime createdAt,
    final List<String> likeIds,
    final int replyCount,
    final List<String> tags,
  }) = _$PostCommentImpl;

  factory _PostComment.fromJson(Map<String, dynamic> json) =
      _$PostCommentImpl.fromJson;

  @override
  String get id;
  @override
  String get postId;
  @override
  String? get parentId; // New: For replies
  @override
  String get userId;
  @override
  String get userName;
  @override
  String? get userPhotoUrl;
  @override
  String get content;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  List<String> get likeIds; // New: Like support
  @override
  int get replyCount; // New: Reply count
  @override
  List<String> get tags;

  /// Create a copy of PostComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostCommentImplCopyWith<_$PostCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) {
  return _ChatRoom.fromJson(json);
}

/// @nodoc
mixin _$ChatRoom {
  String get id => throw _privateConstructorUsedError;
  List<String> get participantIds => throw _privateConstructorUsedError;
  Map<String, dynamic> get participantDetails =>
      throw _privateConstructorUsedError; // uid -> {name, photo}
  String? get lastMessage => throw _privateConstructorUsedError;
  @TimestampNullableConverter()
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;

  /// Serializes this ChatRoom to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatRoomCopyWith<ChatRoom> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatRoomCopyWith<$Res> {
  factory $ChatRoomCopyWith(ChatRoom value, $Res Function(ChatRoom) then) =
      _$ChatRoomCopyWithImpl<$Res, ChatRoom>;
  @useResult
  $Res call({
    String id,
    List<String> participantIds,
    Map<String, dynamic> participantDetails,
    String? lastMessage,
    @TimestampNullableConverter() DateTime? lastMessageAt,
    int unreadCount,
  });
}

/// @nodoc
class _$ChatRoomCopyWithImpl<$Res, $Val extends ChatRoom>
    implements $ChatRoomCopyWith<$Res> {
  _$ChatRoomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? participantIds = null,
    Object? participantDetails = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? unreadCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            participantIds: null == participantIds
                ? _value.participantIds
                : participantIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            participantDetails: null == participantDetails
                ? _value.participantDetails
                : participantDetails // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            lastMessage: freezed == lastMessage
                ? _value.lastMessage
                : lastMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastMessageAt: freezed == lastMessageAt
                ? _value.lastMessageAt
                : lastMessageAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            unreadCount: null == unreadCount
                ? _value.unreadCount
                : unreadCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatRoomImplCopyWith<$Res>
    implements $ChatRoomCopyWith<$Res> {
  factory _$$ChatRoomImplCopyWith(
    _$ChatRoomImpl value,
    $Res Function(_$ChatRoomImpl) then,
  ) = __$$ChatRoomImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    List<String> participantIds,
    Map<String, dynamic> participantDetails,
    String? lastMessage,
    @TimestampNullableConverter() DateTime? lastMessageAt,
    int unreadCount,
  });
}

/// @nodoc
class __$$ChatRoomImplCopyWithImpl<$Res>
    extends _$ChatRoomCopyWithImpl<$Res, _$ChatRoomImpl>
    implements _$$ChatRoomImplCopyWith<$Res> {
  __$$ChatRoomImplCopyWithImpl(
    _$ChatRoomImpl _value,
    $Res Function(_$ChatRoomImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? participantIds = null,
    Object? participantDetails = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? unreadCount = null,
  }) {
    return _then(
      _$ChatRoomImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        participantIds: null == participantIds
            ? _value._participantIds
            : participantIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        participantDetails: null == participantDetails
            ? _value._participantDetails
            : participantDetails // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        lastMessage: freezed == lastMessage
            ? _value.lastMessage
            : lastMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastMessageAt: freezed == lastMessageAt
            ? _value.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        unreadCount: null == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatRoomImpl implements _ChatRoom {
  const _$ChatRoomImpl({
    required this.id,
    required final List<String> participantIds,
    required final Map<String, dynamic> participantDetails,
    this.lastMessage,
    @TimestampNullableConverter() this.lastMessageAt,
    this.unreadCount = 0,
  }) : _participantIds = participantIds,
       _participantDetails = participantDetails;

  factory _$ChatRoomImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatRoomImplFromJson(json);

  @override
  final String id;
  final List<String> _participantIds;
  @override
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  final Map<String, dynamic> _participantDetails;
  @override
  Map<String, dynamic> get participantDetails {
    if (_participantDetails is EqualUnmodifiableMapView)
      return _participantDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_participantDetails);
  }

  // uid -> {name, photo}
  @override
  final String? lastMessage;
  @override
  @TimestampNullableConverter()
  final DateTime? lastMessageAt;
  @override
  @JsonKey()
  final int unreadCount;

  @override
  String toString() {
    return 'ChatRoom(id: $id, participantIds: $participantIds, participantDetails: $participantDetails, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, unreadCount: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatRoomImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._participantIds,
              _participantIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._participantDetails,
              _participantDetails,
            ) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    const DeepCollectionEquality().hash(_participantIds),
    const DeepCollectionEquality().hash(_participantDetails),
    lastMessage,
    lastMessageAt,
    unreadCount,
  );

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatRoomImplCopyWith<_$ChatRoomImpl> get copyWith =>
      __$$ChatRoomImplCopyWithImpl<_$ChatRoomImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatRoomImplToJson(this);
  }
}

abstract class _ChatRoom implements ChatRoom {
  const factory _ChatRoom({
    required final String id,
    required final List<String> participantIds,
    required final Map<String, dynamic> participantDetails,
    final String? lastMessage,
    @TimestampNullableConverter() final DateTime? lastMessageAt,
    final int unreadCount,
  }) = _$ChatRoomImpl;

  factory _ChatRoom.fromJson(Map<String, dynamic> json) =
      _$ChatRoomImpl.fromJson;

  @override
  String get id;
  @override
  List<String> get participantIds;
  @override
  Map<String, dynamic> get participantDetails; // uid -> {name, photo}
  @override
  String? get lastMessage;
  @override
  @TimestampNullableConverter()
  DateTime? get lastMessageAt;
  @override
  int get unreadCount;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatRoomImplCopyWith<_$ChatRoomImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  String get id => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  String? get attachmentUrl => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call({
    String id,
    String senderId,
    String content,
    @TimestampConverter() DateTime createdAt,
    bool isRead,
    String? attachmentUrl,
    String? type,
  });
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? content = null,
    Object? createdAt = null,
    Object? isRead = null,
    Object? attachmentUrl = freezed,
    Object? type = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            attachmentUrl: freezed == attachmentUrl
                ? _value.attachmentUrl
                : attachmentUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
    _$MessageImpl value,
    $Res Function(_$MessageImpl) then,
  ) = __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String senderId,
    String content,
    @TimestampConverter() DateTime createdAt,
    bool isRead,
    String? attachmentUrl,
    String? type,
  });
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
    _$MessageImpl _value,
    $Res Function(_$MessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? content = null,
    Object? createdAt = null,
    Object? isRead = null,
    Object? attachmentUrl = freezed,
    Object? type = freezed,
  }) {
    return _then(
      _$MessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        attachmentUrl: freezed == attachmentUrl
            ? _value.attachmentUrl
            : attachmentUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImpl implements _Message {
  const _$MessageImpl({
    required this.id,
    required this.senderId,
    required this.content,
    @TimestampConverter() required this.createdAt,
    this.isRead = false,
    this.attachmentUrl,
    this.type,
  });

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  final String id;
  @override
  final String senderId;
  @override
  final String content;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isRead;
  @override
  final String? attachmentUrl;
  @override
  final String? type;

  @override
  String toString() {
    return 'Message(id: $id, senderId: $senderId, content: $content, createdAt: $createdAt, isRead: $isRead, attachmentUrl: $attachmentUrl, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.attachmentUrl, attachmentUrl) ||
                other.attachmentUrl == attachmentUrl) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    senderId,
    content,
    createdAt,
    isRead,
    attachmentUrl,
    type,
  );

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(this);
  }
}

abstract class _Message implements Message {
  const factory _Message({
    required final String id,
    required final String senderId,
    required final String content,
    @TimestampConverter() required final DateTime createdAt,
    final bool isRead,
    final String? attachmentUrl,
    final String? type,
  }) = _$MessageImpl;

  factory _Message.fromJson(Map<String, dynamic> json) = _$MessageImpl.fromJson;

  @override
  String get id;
  @override
  String get senderId;
  @override
  String get content;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  bool get isRead;
  @override
  String? get attachmentUrl;
  @override
  String? get type;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
