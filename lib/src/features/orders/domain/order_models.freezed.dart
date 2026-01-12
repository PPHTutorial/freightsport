// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  String get id => throw _privateConstructorUsedError;
  String get buyerId => throw _privateConstructorUsedError;
  String get vendorId => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  PostType get postType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get priceAtPurchase => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get serviceFee => throw _privateConstructorUsedError;
  double get tax => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get promoCode => throw _privateConstructorUsedError;
  double? get discountAmount => throw _privateConstructorUsedError;
  OrderStatus get status => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampNullableConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call({
    String id,
    String buyerId,
    String vendorId,
    String postId,
    PostType postType,
    String title,
    int quantity,
    double priceAtPurchase,
    double totalAmount,
    double serviceFee,
    double tax,
    String currency,
    String? promoCode,
    double? discountAmount,
    OrderStatus status,
    @TimestampConverter() DateTime createdAt,
    @TimestampNullableConverter() DateTime? updatedAt,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? buyerId = null,
    Object? vendorId = null,
    Object? postId = null,
    Object? postType = null,
    Object? title = null,
    Object? quantity = null,
    Object? priceAtPurchase = null,
    Object? totalAmount = null,
    Object? serviceFee = null,
    Object? tax = null,
    Object? currency = null,
    Object? promoCode = freezed,
    Object? discountAmount = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            buyerId: null == buyerId
                ? _value.buyerId
                : buyerId // ignore: cast_nullable_to_non_nullable
                      as String,
            vendorId: null == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                      as String,
            postId: null == postId
                ? _value.postId
                : postId // ignore: cast_nullable_to_non_nullable
                      as String,
            postType: null == postType
                ? _value.postType
                : postType // ignore: cast_nullable_to_non_nullable
                      as PostType,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            priceAtPurchase: null == priceAtPurchase
                ? _value.priceAtPurchase
                : priceAtPurchase // ignore: cast_nullable_to_non_nullable
                      as double,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            serviceFee: null == serviceFee
                ? _value.serviceFee
                : serviceFee // ignore: cast_nullable_to_non_nullable
                      as double,
            tax: null == tax
                ? _value.tax
                : tax // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            promoCode: freezed == promoCode
                ? _value.promoCode
                : promoCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            discountAmount: freezed == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
    _$OrderImpl value,
    $Res Function(_$OrderImpl) then,
  ) = __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String buyerId,
    String vendorId,
    String postId,
    PostType postType,
    String title,
    int quantity,
    double priceAtPurchase,
    double totalAmount,
    double serviceFee,
    double tax,
    String currency,
    String? promoCode,
    double? discountAmount,
    OrderStatus status,
    @TimestampConverter() DateTime createdAt,
    @TimestampNullableConverter() DateTime? updatedAt,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
    _$OrderImpl _value,
    $Res Function(_$OrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? buyerId = null,
    Object? vendorId = null,
    Object? postId = null,
    Object? postType = null,
    Object? title = null,
    Object? quantity = null,
    Object? priceAtPurchase = null,
    Object? totalAmount = null,
    Object? serviceFee = null,
    Object? tax = null,
    Object? currency = null,
    Object? promoCode = freezed,
    Object? discountAmount = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? metadata = null,
  }) {
    return _then(
      _$OrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        buyerId: null == buyerId
            ? _value.buyerId
            : buyerId // ignore: cast_nullable_to_non_nullable
                  as String,
        vendorId: null == vendorId
            ? _value.vendorId
            : vendorId // ignore: cast_nullable_to_non_nullable
                  as String,
        postId: null == postId
            ? _value.postId
            : postId // ignore: cast_nullable_to_non_nullable
                  as String,
        postType: null == postType
            ? _value.postType
            : postType // ignore: cast_nullable_to_non_nullable
                  as PostType,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        priceAtPurchase: null == priceAtPurchase
            ? _value.priceAtPurchase
            : priceAtPurchase // ignore: cast_nullable_to_non_nullable
                  as double,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        serviceFee: null == serviceFee
            ? _value.serviceFee
            : serviceFee // ignore: cast_nullable_to_non_nullable
                  as double,
        tax: null == tax
            ? _value.tax
            : tax // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        promoCode: freezed == promoCode
            ? _value.promoCode
            : promoCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        discountAmount: freezed == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$OrderImpl implements _Order {
  const _$OrderImpl({
    required this.id,
    required this.buyerId,
    required this.vendorId,
    required this.postId,
    required this.postType,
    required this.title,
    required this.quantity,
    required this.priceAtPurchase,
    required this.totalAmount,
    required this.serviceFee,
    required this.tax,
    required this.currency,
    this.promoCode,
    this.discountAmount,
    required this.status,
    @TimestampConverter() required this.createdAt,
    @TimestampNullableConverter() this.updatedAt,
    final Map<String, dynamic> metadata = const {},
  }) : _metadata = metadata;

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final String id;
  @override
  final String buyerId;
  @override
  final String vendorId;
  @override
  final String postId;
  @override
  final PostType postType;
  @override
  final String title;
  @override
  final int quantity;
  @override
  final double priceAtPurchase;
  @override
  final double totalAmount;
  @override
  final double serviceFee;
  @override
  final double tax;
  @override
  final String currency;
  @override
  final String? promoCode;
  @override
  final double? discountAmount;
  @override
  final OrderStatus status;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampNullableConverter()
  final DateTime? updatedAt;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'Order(id: $id, buyerId: $buyerId, vendorId: $vendorId, postId: $postId, postType: $postType, title: $title, quantity: $quantity, priceAtPurchase: $priceAtPurchase, totalAmount: $totalAmount, serviceFee: $serviceFee, tax: $tax, currency: $currency, promoCode: $promoCode, discountAmount: $discountAmount, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.buyerId, buyerId) || other.buyerId == buyerId) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.priceAtPurchase, priceAtPurchase) ||
                other.priceAtPurchase == priceAtPurchase) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.serviceFee, serviceFee) ||
                other.serviceFee == serviceFee) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.promoCode, promoCode) ||
                other.promoCode == promoCode) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    buyerId,
    vendorId,
    postId,
    postType,
    title,
    quantity,
    priceAtPurchase,
    totalAmount,
    serviceFee,
    tax,
    currency,
    promoCode,
    discountAmount,
    status,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(this);
  }
}

abstract class _Order implements Order {
  const factory _Order({
    required final String id,
    required final String buyerId,
    required final String vendorId,
    required final String postId,
    required final PostType postType,
    required final String title,
    required final int quantity,
    required final double priceAtPurchase,
    required final double totalAmount,
    required final double serviceFee,
    required final double tax,
    required final String currency,
    final String? promoCode,
    final double? discountAmount,
    required final OrderStatus status,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampNullableConverter() final DateTime? updatedAt,
    final Map<String, dynamic> metadata,
  }) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  String get id;
  @override
  String get buyerId;
  @override
  String get vendorId;
  @override
  String get postId;
  @override
  PostType get postType;
  @override
  String get title;
  @override
  int get quantity;
  @override
  double get priceAtPurchase;
  @override
  double get totalAmount;
  @override
  double get serviceFee;
  @override
  double get tax;
  @override
  String get currency;
  @override
  String? get promoCode;
  @override
  double? get discountAmount;
  @override
  OrderStatus get status;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampNullableConverter()
  DateTime? get updatedAt;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentTransaction _$PaymentTransactionFromJson(Map<String, dynamic> json) {
  return _PaymentTransaction.fromJson(json);
}

/// @nodoc
mixin _$PaymentTransaction {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  String get buyerId => throw _privateConstructorUsedError;
  String get vendorId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get provider =>
      throw _privateConstructorUsedError; // flutterwave, stripe, nowpayments
  String get method =>
      throw _privateConstructorUsedError; // mobile_money, card, crypto, etc.
  String get status =>
      throw _privateConstructorUsedError; // successful, failed, pending
  String? get externalReference => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this PaymentTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentTransactionCopyWith<PaymentTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentTransactionCopyWith<$Res> {
  factory $PaymentTransactionCopyWith(
    PaymentTransaction value,
    $Res Function(PaymentTransaction) then,
  ) = _$PaymentTransactionCopyWithImpl<$Res, PaymentTransaction>;
  @useResult
  $Res call({
    String id,
    String orderId,
    String buyerId,
    String vendorId,
    double amount,
    String currency,
    String provider,
    String method,
    String status,
    String? externalReference,
    @TimestampConverter() DateTime createdAt,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class _$PaymentTransactionCopyWithImpl<$Res, $Val extends PaymentTransaction>
    implements $PaymentTransactionCopyWith<$Res> {
  _$PaymentTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? buyerId = null,
    Object? vendorId = null,
    Object? amount = null,
    Object? currency = null,
    Object? provider = null,
    Object? method = null,
    Object? status = null,
    Object? externalReference = freezed,
    Object? createdAt = null,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            buyerId: null == buyerId
                ? _value.buyerId
                : buyerId // ignore: cast_nullable_to_non_nullable
                      as String,
            vendorId: null == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            provider: null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                      as String,
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            externalReference: freezed == externalReference
                ? _value.externalReference
                : externalReference // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
abstract class _$$PaymentTransactionImplCopyWith<$Res>
    implements $PaymentTransactionCopyWith<$Res> {
  factory _$$PaymentTransactionImplCopyWith(
    _$PaymentTransactionImpl value,
    $Res Function(_$PaymentTransactionImpl) then,
  ) = __$$PaymentTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String orderId,
    String buyerId,
    String vendorId,
    double amount,
    String currency,
    String provider,
    String method,
    String status,
    String? externalReference,
    @TimestampConverter() DateTime createdAt,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class __$$PaymentTransactionImplCopyWithImpl<$Res>
    extends _$PaymentTransactionCopyWithImpl<$Res, _$PaymentTransactionImpl>
    implements _$$PaymentTransactionImplCopyWith<$Res> {
  __$$PaymentTransactionImplCopyWithImpl(
    _$PaymentTransactionImpl _value,
    $Res Function(_$PaymentTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? buyerId = null,
    Object? vendorId = null,
    Object? amount = null,
    Object? currency = null,
    Object? provider = null,
    Object? method = null,
    Object? status = null,
    Object? externalReference = freezed,
    Object? createdAt = null,
    Object? metadata = null,
  }) {
    return _then(
      _$PaymentTransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        buyerId: null == buyerId
            ? _value.buyerId
            : buyerId // ignore: cast_nullable_to_non_nullable
                  as String,
        vendorId: null == vendorId
            ? _value.vendorId
            : vendorId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        provider: null == provider
            ? _value.provider
            : provider // ignore: cast_nullable_to_non_nullable
                  as String,
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        externalReference: freezed == externalReference
            ? _value.externalReference
            : externalReference // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
class _$PaymentTransactionImpl implements _PaymentTransaction {
  const _$PaymentTransactionImpl({
    required this.id,
    required this.orderId,
    required this.buyerId,
    required this.vendorId,
    required this.amount,
    required this.currency,
    required this.provider,
    required this.method,
    required this.status,
    this.externalReference,
    @TimestampConverter() required this.createdAt,
    final Map<String, dynamic> metadata = const {},
  }) : _metadata = metadata;

  factory _$PaymentTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String orderId;
  @override
  final String buyerId;
  @override
  final String vendorId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String provider;
  // flutterwave, stripe, nowpayments
  @override
  final String method;
  // mobile_money, card, crypto, etc.
  @override
  final String status;
  // successful, failed, pending
  @override
  final String? externalReference;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'PaymentTransaction(id: $id, orderId: $orderId, buyerId: $buyerId, vendorId: $vendorId, amount: $amount, currency: $currency, provider: $provider, method: $method, status: $status, externalReference: $externalReference, createdAt: $createdAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.buyerId, buyerId) || other.buyerId == buyerId) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.externalReference, externalReference) ||
                other.externalReference == externalReference) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderId,
    buyerId,
    vendorId,
    amount,
    currency,
    provider,
    method,
    status,
    externalReference,
    createdAt,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of PaymentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentTransactionImplCopyWith<_$PaymentTransactionImpl> get copyWith =>
      __$$PaymentTransactionImplCopyWithImpl<_$PaymentTransactionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentTransactionImplToJson(this);
  }
}

abstract class _PaymentTransaction implements PaymentTransaction {
  const factory _PaymentTransaction({
    required final String id,
    required final String orderId,
    required final String buyerId,
    required final String vendorId,
    required final double amount,
    required final String currency,
    required final String provider,
    required final String method,
    required final String status,
    final String? externalReference,
    @TimestampConverter() required final DateTime createdAt,
    final Map<String, dynamic> metadata,
  }) = _$PaymentTransactionImpl;

  factory _PaymentTransaction.fromJson(Map<String, dynamic> json) =
      _$PaymentTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  String get buyerId;
  @override
  String get vendorId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String get provider; // flutterwave, stripe, nowpayments
  @override
  String get method; // mobile_money, card, crypto, etc.
  @override
  String get status; // successful, failed, pending
  @override
  String? get externalReference;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of PaymentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentTransactionImplCopyWith<_$PaymentTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
