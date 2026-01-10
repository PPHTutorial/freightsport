// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quotation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VendorQuotation _$VendorQuotationFromJson(Map<String, dynamic> json) {
  return _VendorQuotation.fromJson(json);
}

/// @nodoc
mixin _$VendorQuotation {
  String get id => throw _privateConstructorUsedError;
  String get vendorId => throw _privateConstructorUsedError;
  String get vendorName => throw _privateConstructorUsedError;
  FreightType get freightType => throw _privateConstructorUsedError;
  DeliverySpeed? get deliverySpeed =>
      throw _privateConstructorUsedError; // Only for air freight
  ItemCategory get itemCategory => throw _privateConstructorUsedError;
  double get ratePerUnit =>
      throw _privateConstructorUsedError; // $/kg for air, $/CBM for sea, flat for phone
  String get currency => throw _privateConstructorUsedError;
  double? get minimumWeight =>
      throw _privateConstructorUsedError; // For air freight
  double? get minimumVolume =>
      throw _privateConstructorUsedError; // For sea freight
  @TimestampConverter()
  DateTime get validFrom => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get validUntil => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError; // Admin user ID
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this VendorQuotation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VendorQuotation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VendorQuotationCopyWith<VendorQuotation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorQuotationCopyWith<$Res> {
  factory $VendorQuotationCopyWith(
    VendorQuotation value,
    $Res Function(VendorQuotation) then,
  ) = _$VendorQuotationCopyWithImpl<$Res, VendorQuotation>;
  @useResult
  $Res call({
    String id,
    String vendorId,
    String vendorName,
    FreightType freightType,
    DeliverySpeed? deliverySpeed,
    ItemCategory itemCategory,
    double ratePerUnit,
    String currency,
    double? minimumWeight,
    double? minimumVolume,
    @TimestampConverter() DateTime validFrom,
    @TimestampConverter() DateTime validUntil,
    bool isActive,
    Map<String, dynamic> metadata,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
    String? createdBy,
    String? notes,
  });
}

/// @nodoc
class _$VendorQuotationCopyWithImpl<$Res, $Val extends VendorQuotation>
    implements $VendorQuotationCopyWith<$Res> {
  _$VendorQuotationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VendorQuotation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? vendorName = null,
    Object? freightType = null,
    Object? deliverySpeed = freezed,
    Object? itemCategory = null,
    Object? ratePerUnit = null,
    Object? currency = null,
    Object? minimumWeight = freezed,
    Object? minimumVolume = freezed,
    Object? validFrom = null,
    Object? validUntil = null,
    Object? isActive = null,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? notes = freezed,
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
            freightType: null == freightType
                ? _value.freightType
                : freightType // ignore: cast_nullable_to_non_nullable
                      as FreightType,
            deliverySpeed: freezed == deliverySpeed
                ? _value.deliverySpeed
                : deliverySpeed // ignore: cast_nullable_to_non_nullable
                      as DeliverySpeed?,
            itemCategory: null == itemCategory
                ? _value.itemCategory
                : itemCategory // ignore: cast_nullable_to_non_nullable
                      as ItemCategory,
            ratePerUnit: null == ratePerUnit
                ? _value.ratePerUnit
                : ratePerUnit // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            minimumWeight: freezed == minimumWeight
                ? _value.minimumWeight
                : minimumWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            minimumVolume: freezed == minimumVolume
                ? _value.minimumVolume
                : minimumVolume // ignore: cast_nullable_to_non_nullable
                      as double?,
            validFrom: null == validFrom
                ? _value.validFrom
                : validFrom // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            validUntil: null == validUntil
                ? _value.validUntil
                : validUntil // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VendorQuotationImplCopyWith<$Res>
    implements $VendorQuotationCopyWith<$Res> {
  factory _$$VendorQuotationImplCopyWith(
    _$VendorQuotationImpl value,
    $Res Function(_$VendorQuotationImpl) then,
  ) = __$$VendorQuotationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String vendorId,
    String vendorName,
    FreightType freightType,
    DeliverySpeed? deliverySpeed,
    ItemCategory itemCategory,
    double ratePerUnit,
    String currency,
    double? minimumWeight,
    double? minimumVolume,
    @TimestampConverter() DateTime validFrom,
    @TimestampConverter() DateTime validUntil,
    bool isActive,
    Map<String, dynamic> metadata,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
    String? createdBy,
    String? notes,
  });
}

/// @nodoc
class __$$VendorQuotationImplCopyWithImpl<$Res>
    extends _$VendorQuotationCopyWithImpl<$Res, _$VendorQuotationImpl>
    implements _$$VendorQuotationImplCopyWith<$Res> {
  __$$VendorQuotationImplCopyWithImpl(
    _$VendorQuotationImpl _value,
    $Res Function(_$VendorQuotationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VendorQuotation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? vendorName = null,
    Object? freightType = null,
    Object? deliverySpeed = freezed,
    Object? itemCategory = null,
    Object? ratePerUnit = null,
    Object? currency = null,
    Object? minimumWeight = freezed,
    Object? minimumVolume = freezed,
    Object? validFrom = null,
    Object? validUntil = null,
    Object? isActive = null,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? createdBy = freezed,
    Object? notes = freezed,
  }) {
    return _then(
      _$VendorQuotationImpl(
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
        freightType: null == freightType
            ? _value.freightType
            : freightType // ignore: cast_nullable_to_non_nullable
                  as FreightType,
        deliverySpeed: freezed == deliverySpeed
            ? _value.deliverySpeed
            : deliverySpeed // ignore: cast_nullable_to_non_nullable
                  as DeliverySpeed?,
        itemCategory: null == itemCategory
            ? _value.itemCategory
            : itemCategory // ignore: cast_nullable_to_non_nullable
                  as ItemCategory,
        ratePerUnit: null == ratePerUnit
            ? _value.ratePerUnit
            : ratePerUnit // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        minimumWeight: freezed == minimumWeight
            ? _value.minimumWeight
            : minimumWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        minimumVolume: freezed == minimumVolume
            ? _value.minimumVolume
            : minimumVolume // ignore: cast_nullable_to_non_nullable
                  as double?,
        validFrom: null == validFrom
            ? _value.validFrom
            : validFrom // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        validUntil: null == validUntil
            ? _value.validUntil
            : validUntil // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VendorQuotationImpl implements _VendorQuotation {
  const _$VendorQuotationImpl({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.freightType,
    this.deliverySpeed,
    required this.itemCategory,
    required this.ratePerUnit,
    this.currency = 'USD',
    this.minimumWeight,
    this.minimumVolume,
    @TimestampConverter() required this.validFrom,
    @TimestampConverter() required this.validUntil,
    this.isActive = true,
    final Map<String, dynamic> metadata = const {},
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
    this.createdBy,
    this.notes,
  }) : _metadata = metadata;

  factory _$VendorQuotationImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorQuotationImplFromJson(json);

  @override
  final String id;
  @override
  final String vendorId;
  @override
  final String vendorName;
  @override
  final FreightType freightType;
  @override
  final DeliverySpeed? deliverySpeed;
  // Only for air freight
  @override
  final ItemCategory itemCategory;
  @override
  final double ratePerUnit;
  // $/kg for air, $/CBM for sea, flat for phone
  @override
  @JsonKey()
  final String currency;
  @override
  final double? minimumWeight;
  // For air freight
  @override
  final double? minimumVolume;
  // For sea freight
  @override
  @TimestampConverter()
  final DateTime validFrom;
  @override
  @TimestampConverter()
  final DateTime validUntil;
  @override
  @JsonKey()
  final bool isActive;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;
  @override
  final String? createdBy;
  // Admin user ID
  @override
  final String? notes;

  @override
  String toString() {
    return 'VendorQuotation(id: $id, vendorId: $vendorId, vendorName: $vendorName, freightType: $freightType, deliverySpeed: $deliverySpeed, itemCategory: $itemCategory, ratePerUnit: $ratePerUnit, currency: $currency, minimumWeight: $minimumWeight, minimumVolume: $minimumVolume, validFrom: $validFrom, validUntil: $validUntil, isActive: $isActive, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorQuotationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.freightType, freightType) ||
                other.freightType == freightType) &&
            (identical(other.deliverySpeed, deliverySpeed) ||
                other.deliverySpeed == deliverySpeed) &&
            (identical(other.itemCategory, itemCategory) ||
                other.itemCategory == itemCategory) &&
            (identical(other.ratePerUnit, ratePerUnit) ||
                other.ratePerUnit == ratePerUnit) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.minimumWeight, minimumWeight) ||
                other.minimumWeight == minimumWeight) &&
            (identical(other.minimumVolume, minimumVolume) ||
                other.minimumVolume == minimumVolume) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    vendorId,
    vendorName,
    freightType,
    deliverySpeed,
    itemCategory,
    ratePerUnit,
    currency,
    minimumWeight,
    minimumVolume,
    validFrom,
    validUntil,
    isActive,
    const DeepCollectionEquality().hash(_metadata),
    createdAt,
    updatedAt,
    createdBy,
    notes,
  );

  /// Create a copy of VendorQuotation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorQuotationImplCopyWith<_$VendorQuotationImpl> get copyWith =>
      __$$VendorQuotationImplCopyWithImpl<_$VendorQuotationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorQuotationImplToJson(this);
  }
}

abstract class _VendorQuotation implements VendorQuotation {
  const factory _VendorQuotation({
    required final String id,
    required final String vendorId,
    required final String vendorName,
    required final FreightType freightType,
    final DeliverySpeed? deliverySpeed,
    required final ItemCategory itemCategory,
    required final double ratePerUnit,
    final String currency,
    final double? minimumWeight,
    final double? minimumVolume,
    @TimestampConverter() required final DateTime validFrom,
    @TimestampConverter() required final DateTime validUntil,
    final bool isActive,
    final Map<String, dynamic> metadata,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
    final String? createdBy,
    final String? notes,
  }) = _$VendorQuotationImpl;

  factory _VendorQuotation.fromJson(Map<String, dynamic> json) =
      _$VendorQuotationImpl.fromJson;

  @override
  String get id;
  @override
  String get vendorId;
  @override
  String get vendorName;
  @override
  FreightType get freightType;
  @override
  DeliverySpeed? get deliverySpeed; // Only for air freight
  @override
  ItemCategory get itemCategory;
  @override
  double get ratePerUnit; // $/kg for air, $/CBM for sea, flat for phone
  @override
  String get currency;
  @override
  double? get minimumWeight; // For air freight
  @override
  double? get minimumVolume; // For sea freight
  @override
  @TimestampConverter()
  DateTime get validFrom;
  @override
  @TimestampConverter()
  DateTime get validUntil;
  @override
  bool get isActive;
  @override
  Map<String, dynamic> get metadata;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;
  @override
  String? get createdBy; // Admin user ID
  @override
  String? get notes;

  /// Create a copy of VendorQuotation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VendorQuotationImplCopyWith<_$VendorQuotationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
