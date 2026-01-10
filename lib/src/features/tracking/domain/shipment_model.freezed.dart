// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShipmentItem _$ShipmentItemFromJson(Map<String, dynamic> json) {
  return _ShipmentItem.fromJson(json);
}

/// @nodoc
mixin _$ShipmentItem {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get itemType => throw _privateConstructorUsedError; // e.g., Box, Unit
  String get category =>
      throw _privateConstructorUsedError; // e.g., Electronics, Beauty
  int get quantity => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  double get declaredValue => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  bool get isPerishable => throw _privateConstructorUsedError;
  bool get isFragile => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get dimensions => throw _privateConstructorUsedError;
  List<String>? get imageUrls => throw _privateConstructorUsedError;

  /// Serializes this ShipmentItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentItemCopyWith<ShipmentItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentItemCopyWith<$Res> {
  factory $ShipmentItemCopyWith(
    ShipmentItem value,
    $Res Function(ShipmentItem) then,
  ) = _$ShipmentItemCopyWithImpl<$Res, ShipmentItem>;
  @useResult
  $Res call({
    String name,
    String description,
    String itemType,
    String category,
    int quantity,
    double weight,
    double declaredValue,
    String currency,
    bool isPerishable,
    bool isFragile,
    String? color,
    String? dimensions,
    List<String>? imageUrls,
  });
}

/// @nodoc
class _$ShipmentItemCopyWithImpl<$Res, $Val extends ShipmentItem>
    implements $ShipmentItemCopyWith<$Res> {
  _$ShipmentItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? itemType = null,
    Object? category = null,
    Object? quantity = null,
    Object? weight = null,
    Object? declaredValue = null,
    Object? currency = null,
    Object? isPerishable = null,
    Object? isFragile = null,
    Object? color = freezed,
    Object? dimensions = freezed,
    Object? imageUrls = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            itemType: null == itemType
                ? _value.itemType
                : itemType // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double,
            declaredValue: null == declaredValue
                ? _value.declaredValue
                : declaredValue // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            isPerishable: null == isPerishable
                ? _value.isPerishable
                : isPerishable // ignore: cast_nullable_to_non_nullable
                      as bool,
            isFragile: null == isFragile
                ? _value.isFragile
                : isFragile // ignore: cast_nullable_to_non_nullable
                      as bool,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            dimensions: freezed == dimensions
                ? _value.dimensions
                : dimensions // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrls: freezed == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShipmentItemImplCopyWith<$Res>
    implements $ShipmentItemCopyWith<$Res> {
  factory _$$ShipmentItemImplCopyWith(
    _$ShipmentItemImpl value,
    $Res Function(_$ShipmentItemImpl) then,
  ) = __$$ShipmentItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String description,
    String itemType,
    String category,
    int quantity,
    double weight,
    double declaredValue,
    String currency,
    bool isPerishable,
    bool isFragile,
    String? color,
    String? dimensions,
    List<String>? imageUrls,
  });
}

/// @nodoc
class __$$ShipmentItemImplCopyWithImpl<$Res>
    extends _$ShipmentItemCopyWithImpl<$Res, _$ShipmentItemImpl>
    implements _$$ShipmentItemImplCopyWith<$Res> {
  __$$ShipmentItemImplCopyWithImpl(
    _$ShipmentItemImpl _value,
    $Res Function(_$ShipmentItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShipmentItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? itemType = null,
    Object? category = null,
    Object? quantity = null,
    Object? weight = null,
    Object? declaredValue = null,
    Object? currency = null,
    Object? isPerishable = null,
    Object? isFragile = null,
    Object? color = freezed,
    Object? dimensions = freezed,
    Object? imageUrls = freezed,
  }) {
    return _then(
      _$ShipmentItemImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        itemType: null == itemType
            ? _value.itemType
            : itemType // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double,
        declaredValue: null == declaredValue
            ? _value.declaredValue
            : declaredValue // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        isPerishable: null == isPerishable
            ? _value.isPerishable
            : isPerishable // ignore: cast_nullable_to_non_nullable
                  as bool,
        isFragile: null == isFragile
            ? _value.isFragile
            : isFragile // ignore: cast_nullable_to_non_nullable
                  as bool,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        dimensions: freezed == dimensions
            ? _value.dimensions
            : dimensions // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrls: freezed == imageUrls
            ? _value._imageUrls
            : imageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShipmentItemImpl implements _ShipmentItem {
  const _$ShipmentItemImpl({
    required this.name,
    required this.description,
    required this.itemType,
    required this.category,
    required this.quantity,
    required this.weight,
    required this.declaredValue,
    required this.currency,
    this.isPerishable = false,
    this.isFragile = false,
    this.color,
    this.dimensions,
    final List<String>? imageUrls,
  }) : _imageUrls = imageUrls;

  factory _$ShipmentItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShipmentItemImplFromJson(json);

  @override
  final String name;
  @override
  final String description;
  @override
  final String itemType;
  // e.g., Box, Unit
  @override
  final String category;
  // e.g., Electronics, Beauty
  @override
  final int quantity;
  @override
  final double weight;
  @override
  final double declaredValue;
  @override
  final String currency;
  @override
  @JsonKey()
  final bool isPerishable;
  @override
  @JsonKey()
  final bool isFragile;
  @override
  final String? color;
  @override
  final String? dimensions;
  final List<String>? _imageUrls;
  @override
  List<String>? get imageUrls {
    final value = _imageUrls;
    if (value == null) return null;
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ShipmentItem(name: $name, description: $description, itemType: $itemType, category: $category, quantity: $quantity, weight: $weight, declaredValue: $declaredValue, currency: $currency, isPerishable: $isPerishable, isFragile: $isFragile, color: $color, dimensions: $dimensions, imageUrls: $imageUrls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.declaredValue, declaredValue) ||
                other.declaredValue == declaredValue) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.isPerishable, isPerishable) ||
                other.isPerishable == isPerishable) &&
            (identical(other.isFragile, isFragile) ||
                other.isFragile == isFragile) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.dimensions, dimensions) ||
                other.dimensions == dimensions) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    description,
    itemType,
    category,
    quantity,
    weight,
    declaredValue,
    currency,
    isPerishable,
    isFragile,
    color,
    dimensions,
    const DeepCollectionEquality().hash(_imageUrls),
  );

  /// Create a copy of ShipmentItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentItemImplCopyWith<_$ShipmentItemImpl> get copyWith =>
      __$$ShipmentItemImplCopyWithImpl<_$ShipmentItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShipmentItemImplToJson(this);
  }
}

abstract class _ShipmentItem implements ShipmentItem {
  const factory _ShipmentItem({
    required final String name,
    required final String description,
    required final String itemType,
    required final String category,
    required final int quantity,
    required final double weight,
    required final double declaredValue,
    required final String currency,
    final bool isPerishable,
    final bool isFragile,
    final String? color,
    final String? dimensions,
    final List<String>? imageUrls,
  }) = _$ShipmentItemImpl;

  factory _ShipmentItem.fromJson(Map<String, dynamic> json) =
      _$ShipmentItemImpl.fromJson;

  @override
  String get name;
  @override
  String get description;
  @override
  String get itemType; // e.g., Box, Unit
  @override
  String get category; // e.g., Electronics, Beauty
  @override
  int get quantity;
  @override
  double get weight;
  @override
  double get declaredValue;
  @override
  String get currency;
  @override
  bool get isPerishable;
  @override
  bool get isFragile;
  @override
  String? get color;
  @override
  String? get dimensions;
  @override
  List<String>? get imageUrls;

  /// Create a copy of ShipmentItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentItemImplCopyWith<_$ShipmentItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShipmentPackage _$ShipmentPackageFromJson(Map<String, dynamic> json) {
  return _ShipmentPackage.fromJson(json);
}

/// @nodoc
mixin _$ShipmentPackage {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError; // "Package 1"
  List<ShipmentItem> get items => throw _privateConstructorUsedError;
  double? get totalWeight => throw _privateConstructorUsedError;
  String? get dimensions => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this ShipmentPackage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentPackage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentPackageCopyWith<ShipmentPackage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentPackageCopyWith<$Res> {
  factory $ShipmentPackageCopyWith(
    ShipmentPackage value,
    $Res Function(ShipmentPackage) then,
  ) = _$ShipmentPackageCopyWithImpl<$Res, ShipmentPackage>;
  @useResult
  $Res call({
    String id,
    String? name,
    List<ShipmentItem> items,
    double? totalWeight,
    String? dimensions,
    String? description,
  });
}

/// @nodoc
class _$ShipmentPackageCopyWithImpl<$Res, $Val extends ShipmentPackage>
    implements $ShipmentPackageCopyWith<$Res> {
  _$ShipmentPackageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentPackage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? items = null,
    Object? totalWeight = freezed,
    Object? dimensions = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<ShipmentItem>,
            totalWeight: freezed == totalWeight
                ? _value.totalWeight
                : totalWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            dimensions: freezed == dimensions
                ? _value.dimensions
                : dimensions // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShipmentPackageImplCopyWith<$Res>
    implements $ShipmentPackageCopyWith<$Res> {
  factory _$$ShipmentPackageImplCopyWith(
    _$ShipmentPackageImpl value,
    $Res Function(_$ShipmentPackageImpl) then,
  ) = __$$ShipmentPackageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? name,
    List<ShipmentItem> items,
    double? totalWeight,
    String? dimensions,
    String? description,
  });
}

/// @nodoc
class __$$ShipmentPackageImplCopyWithImpl<$Res>
    extends _$ShipmentPackageCopyWithImpl<$Res, _$ShipmentPackageImpl>
    implements _$$ShipmentPackageImplCopyWith<$Res> {
  __$$ShipmentPackageImplCopyWithImpl(
    _$ShipmentPackageImpl _value,
    $Res Function(_$ShipmentPackageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShipmentPackage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? items = null,
    Object? totalWeight = freezed,
    Object? dimensions = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _$ShipmentPackageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<ShipmentItem>,
        totalWeight: freezed == totalWeight
            ? _value.totalWeight
            : totalWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        dimensions: freezed == dimensions
            ? _value.dimensions
            : dimensions // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShipmentPackageImpl implements _ShipmentPackage {
  const _$ShipmentPackageImpl({
    required this.id,
    this.name,
    final List<ShipmentItem> items = const [],
    this.totalWeight,
    this.dimensions,
    this.description,
  }) : _items = items;

  factory _$ShipmentPackageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShipmentPackageImplFromJson(json);

  @override
  final String id;
  @override
  final String? name;
  // "Package 1"
  final List<ShipmentItem> _items;
  // "Package 1"
  @override
  @JsonKey()
  List<ShipmentItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double? totalWeight;
  @override
  final String? dimensions;
  @override
  final String? description;

  @override
  String toString() {
    return 'ShipmentPackage(id: $id, name: $name, items: $items, totalWeight: $totalWeight, dimensions: $dimensions, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentPackageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalWeight, totalWeight) ||
                other.totalWeight == totalWeight) &&
            (identical(other.dimensions, dimensions) ||
                other.dimensions == dimensions) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_items),
    totalWeight,
    dimensions,
    description,
  );

  /// Create a copy of ShipmentPackage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentPackageImplCopyWith<_$ShipmentPackageImpl> get copyWith =>
      __$$ShipmentPackageImplCopyWithImpl<_$ShipmentPackageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShipmentPackageImplToJson(this);
  }
}

abstract class _ShipmentPackage implements ShipmentPackage {
  const factory _ShipmentPackage({
    required final String id,
    final String? name,
    final List<ShipmentItem> items,
    final double? totalWeight,
    final String? dimensions,
    final String? description,
  }) = _$ShipmentPackageImpl;

  factory _ShipmentPackage.fromJson(Map<String, dynamic> json) =
      _$ShipmentPackageImpl.fromJson;

  @override
  String get id;
  @override
  String? get name; // "Package 1"
  @override
  List<ShipmentItem> get items;
  @override
  double? get totalWeight;
  @override
  String? get dimensions;
  @override
  String? get description;

  /// Create a copy of ShipmentPackage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentPackageImplCopyWith<_$ShipmentPackageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShipmentLocation _$ShipmentLocationFromJson(Map<String, dynamic> json) {
  return _ShipmentLocation.fromJson(json);
}

/// @nodoc
mixin _$ShipmentLocation {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get street => throw _privateConstructorUsedError;
  String? get zip => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this ShipmentLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentLocationCopyWith<ShipmentLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentLocationCopyWith<$Res> {
  factory $ShipmentLocationCopyWith(
    ShipmentLocation value,
    $Res Function(ShipmentLocation) then,
  ) = _$ShipmentLocationCopyWithImpl<$Res, ShipmentLocation>;
  @useResult
  $Res call({
    double latitude,
    double longitude,
    String address,
    String? country,
    String? state,
    String? city,
    String? street,
    String? zip,
    String? description,
  });
}

/// @nodoc
class _$ShipmentLocationCopyWithImpl<$Res, $Val extends ShipmentLocation>
    implements $ShipmentLocationCopyWith<$Res> {
  _$ShipmentLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? address = null,
    Object? country = freezed,
    Object? state = freezed,
    Object? city = freezed,
    Object? street = freezed,
    Object? zip = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            country: freezed == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                      as String?,
            state: freezed == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            street: freezed == street
                ? _value.street
                : street // ignore: cast_nullable_to_non_nullable
                      as String?,
            zip: freezed == zip
                ? _value.zip
                : zip // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShipmentLocationImplCopyWith<$Res>
    implements $ShipmentLocationCopyWith<$Res> {
  factory _$$ShipmentLocationImplCopyWith(
    _$ShipmentLocationImpl value,
    $Res Function(_$ShipmentLocationImpl) then,
  ) = __$$ShipmentLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double latitude,
    double longitude,
    String address,
    String? country,
    String? state,
    String? city,
    String? street,
    String? zip,
    String? description,
  });
}

/// @nodoc
class __$$ShipmentLocationImplCopyWithImpl<$Res>
    extends _$ShipmentLocationCopyWithImpl<$Res, _$ShipmentLocationImpl>
    implements _$$ShipmentLocationImplCopyWith<$Res> {
  __$$ShipmentLocationImplCopyWithImpl(
    _$ShipmentLocationImpl _value,
    $Res Function(_$ShipmentLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShipmentLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? address = null,
    Object? country = freezed,
    Object? state = freezed,
    Object? city = freezed,
    Object? street = freezed,
    Object? zip = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _$ShipmentLocationImpl(
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        country: freezed == country
            ? _value.country
            : country // ignore: cast_nullable_to_non_nullable
                  as String?,
        state: freezed == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        street: freezed == street
            ? _value.street
            : street // ignore: cast_nullable_to_non_nullable
                  as String?,
        zip: freezed == zip
            ? _value.zip
            : zip // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShipmentLocationImpl implements _ShipmentLocation {
  const _$ShipmentLocationImpl({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.country,
    this.state,
    this.city,
    this.street,
    this.zip,
    this.description,
  });

  factory _$ShipmentLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShipmentLocationImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String address;
  @override
  final String? country;
  @override
  final String? state;
  @override
  final String? city;
  @override
  final String? street;
  @override
  final String? zip;
  @override
  final String? description;

  @override
  String toString() {
    return 'ShipmentLocation(latitude: $latitude, longitude: $longitude, address: $address, country: $country, state: $state, city: $city, street: $street, zip: $zip, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentLocationImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.zip, zip) || other.zip == zip) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    latitude,
    longitude,
    address,
    country,
    state,
    city,
    street,
    zip,
    description,
  );

  /// Create a copy of ShipmentLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentLocationImplCopyWith<_$ShipmentLocationImpl> get copyWith =>
      __$$ShipmentLocationImplCopyWithImpl<_$ShipmentLocationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShipmentLocationImplToJson(this);
  }
}

abstract class _ShipmentLocation implements ShipmentLocation {
  const factory _ShipmentLocation({
    required final double latitude,
    required final double longitude,
    required final String address,
    final String? country,
    final String? state,
    final String? city,
    final String? street,
    final String? zip,
    final String? description,
  }) = _$ShipmentLocationImpl;

  factory _ShipmentLocation.fromJson(Map<String, dynamic> json) =
      _$ShipmentLocationImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get address;
  @override
  String? get country;
  @override
  String? get state;
  @override
  String? get city;
  @override
  String? get street;
  @override
  String? get zip;
  @override
  String? get description;

  /// Create a copy of ShipmentLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentLocationImplCopyWith<_$ShipmentLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShipmentEvent _$ShipmentEventFromJson(Map<String, dynamic> json) {
  return _ShipmentEvent.fromJson(json);
}

/// @nodoc
mixin _$ShipmentEvent {
  String get id => throw _privateConstructorUsedError;
  ShipmentStatusType get status => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  ShipmentLocation get location => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  String? get updatedByUserId => throw _privateConstructorUsedError;

  /// Serializes this ShipmentEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShipmentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentEventCopyWith<ShipmentEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentEventCopyWith<$Res> {
  factory $ShipmentEventCopyWith(
    ShipmentEvent value,
    $Res Function(ShipmentEvent) then,
  ) = _$ShipmentEventCopyWithImpl<$Res, ShipmentEvent>;
  @useResult
  $Res call({
    String id,
    ShipmentStatusType status,
    DateTime timestamp,
    ShipmentLocation location,
    String? note,
    String? updatedByUserId,
  });

  $ShipmentLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$ShipmentEventCopyWithImpl<$Res, $Val extends ShipmentEvent>
    implements $ShipmentEventCopyWith<$Res> {
  _$ShipmentEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShipmentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? timestamp = null,
    Object? location = null,
    Object? note = freezed,
    Object? updatedByUserId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ShipmentStatusType,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as ShipmentLocation,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedByUserId: freezed == updatedByUserId
                ? _value.updatedByUserId
                : updatedByUserId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of ShipmentEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShipmentLocationCopyWith<$Res> get location {
    return $ShipmentLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShipmentEventImplCopyWith<$Res>
    implements $ShipmentEventCopyWith<$Res> {
  factory _$$ShipmentEventImplCopyWith(
    _$ShipmentEventImpl value,
    $Res Function(_$ShipmentEventImpl) then,
  ) = __$$ShipmentEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    ShipmentStatusType status,
    DateTime timestamp,
    ShipmentLocation location,
    String? note,
    String? updatedByUserId,
  });

  @override
  $ShipmentLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$ShipmentEventImplCopyWithImpl<$Res>
    extends _$ShipmentEventCopyWithImpl<$Res, _$ShipmentEventImpl>
    implements _$$ShipmentEventImplCopyWith<$Res> {
  __$$ShipmentEventImplCopyWithImpl(
    _$ShipmentEventImpl _value,
    $Res Function(_$ShipmentEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShipmentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? timestamp = null,
    Object? location = null,
    Object? note = freezed,
    Object? updatedByUserId = freezed,
  }) {
    return _then(
      _$ShipmentEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ShipmentStatusType,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as ShipmentLocation,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedByUserId: freezed == updatedByUserId
            ? _value.updatedByUserId
            : updatedByUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShipmentEventImpl implements _ShipmentEvent {
  const _$ShipmentEventImpl({
    required this.id,
    required this.status,
    required this.timestamp,
    required this.location,
    this.note,
    this.updatedByUserId,
  });

  factory _$ShipmentEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShipmentEventImplFromJson(json);

  @override
  final String id;
  @override
  final ShipmentStatusType status;
  @override
  final DateTime timestamp;
  @override
  final ShipmentLocation location;
  @override
  final String? note;
  @override
  final String? updatedByUserId;

  @override
  String toString() {
    return 'ShipmentEvent(id: $id, status: $status, timestamp: $timestamp, location: $location, note: $note, updatedByUserId: $updatedByUserId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.updatedByUserId, updatedByUserId) ||
                other.updatedByUserId == updatedByUserId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    status,
    timestamp,
    location,
    note,
    updatedByUserId,
  );

  /// Create a copy of ShipmentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentEventImplCopyWith<_$ShipmentEventImpl> get copyWith =>
      __$$ShipmentEventImplCopyWithImpl<_$ShipmentEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShipmentEventImplToJson(this);
  }
}

abstract class _ShipmentEvent implements ShipmentEvent {
  const factory _ShipmentEvent({
    required final String id,
    required final ShipmentStatusType status,
    required final DateTime timestamp,
    required final ShipmentLocation location,
    final String? note,
    final String? updatedByUserId,
  }) = _$ShipmentEventImpl;

  factory _ShipmentEvent.fromJson(Map<String, dynamic> json) =
      _$ShipmentEventImpl.fromJson;

  @override
  String get id;
  @override
  ShipmentStatusType get status;
  @override
  DateTime get timestamp;
  @override
  ShipmentLocation get location;
  @override
  String? get note;
  @override
  String? get updatedByUserId;

  /// Create a copy of ShipmentEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentEventImplCopyWith<_$ShipmentEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Shipment _$ShipmentFromJson(Map<String, dynamic> json) {
  return _Shipment.fromJson(json);
}

/// @nodoc
mixin _$Shipment {
  String get id => throw _privateConstructorUsedError;
  String get trackingNumber => throw _privateConstructorUsedError; // Parties
  String get senderName => throw _privateConstructorUsedError;
  String get senderAddress => throw _privateConstructorUsedError;
  String get senderPhone => throw _privateConstructorUsedError;
  String? get senderId => throw _privateConstructorUsedError;
  String get recipientName => throw _privateConstructorUsedError;
  String get recipientAddress => throw _privateConstructorUsedError;
  String get recipientPhone => throw _privateConstructorUsedError;
  String? get recipientId =>
      throw _privateConstructorUsedError; // Vendor & Route
  String? get vendorId => throw _privateConstructorUsedError;
  String? get routeId => throw _privateConstructorUsedError;
  List<String> get alternativeVendorIds => throw _privateConstructorUsedError;
  ShipmentApprovalStatus get approvalStatus =>
      throw _privateConstructorUsedError; // Logistics Details
  PickupType get pickupType => throw _privateConstructorUsedError;
  DeliveryType get deliveryType => throw _privateConstructorUsedError;
  String? get selectedWarehouseId =>
      throw _privateConstructorUsedError; // Content
  List<ShipmentPackage> get packages => throw _privateConstructorUsedError;
  double? get totalWeight => throw _privateConstructorUsedError;
  double? get totalPrice => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError; // Status & Meta
  ShipmentStatusType get currentStatus => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get estimatedDeliveryDate => throw _privateConstructorUsedError;
  List<ShipmentEvent> get events => throw _privateConstructorUsedError;
  String? get assignedCourierId => throw _privateConstructorUsedError;

  /// Serializes this Shipment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShipmentCopyWith<Shipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipmentCopyWith<$Res> {
  factory $ShipmentCopyWith(Shipment value, $Res Function(Shipment) then) =
      _$ShipmentCopyWithImpl<$Res, Shipment>;
  @useResult
  $Res call({
    String id,
    String trackingNumber,
    String senderName,
    String senderAddress,
    String senderPhone,
    String? senderId,
    String recipientName,
    String recipientAddress,
    String recipientPhone,
    String? recipientId,
    String? vendorId,
    String? routeId,
    List<String> alternativeVendorIds,
    ShipmentApprovalStatus approvalStatus,
    PickupType pickupType,
    DeliveryType deliveryType,
    String? selectedWarehouseId,
    List<ShipmentPackage> packages,
    double? totalWeight,
    double? totalPrice,
    String? currency,
    ShipmentStatusType currentStatus,
    DateTime createdAt,
    DateTime estimatedDeliveryDate,
    List<ShipmentEvent> events,
    String? assignedCourierId,
  });
}

/// @nodoc
class _$ShipmentCopyWithImpl<$Res, $Val extends Shipment>
    implements $ShipmentCopyWith<$Res> {
  _$ShipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trackingNumber = null,
    Object? senderName = null,
    Object? senderAddress = null,
    Object? senderPhone = null,
    Object? senderId = freezed,
    Object? recipientName = null,
    Object? recipientAddress = null,
    Object? recipientPhone = null,
    Object? recipientId = freezed,
    Object? vendorId = freezed,
    Object? routeId = freezed,
    Object? alternativeVendorIds = null,
    Object? approvalStatus = null,
    Object? pickupType = null,
    Object? deliveryType = null,
    Object? selectedWarehouseId = freezed,
    Object? packages = null,
    Object? totalWeight = freezed,
    Object? totalPrice = freezed,
    Object? currency = freezed,
    Object? currentStatus = null,
    Object? createdAt = null,
    Object? estimatedDeliveryDate = null,
    Object? events = null,
    Object? assignedCourierId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            trackingNumber: null == trackingNumber
                ? _value.trackingNumber
                : trackingNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            senderName: null == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                      as String,
            senderAddress: null == senderAddress
                ? _value.senderAddress
                : senderAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            senderPhone: null == senderPhone
                ? _value.senderPhone
                : senderPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            senderId: freezed == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            recipientName: null == recipientName
                ? _value.recipientName
                : recipientName // ignore: cast_nullable_to_non_nullable
                      as String,
            recipientAddress: null == recipientAddress
                ? _value.recipientAddress
                : recipientAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            recipientPhone: null == recipientPhone
                ? _value.recipientPhone
                : recipientPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            recipientId: freezed == recipientId
                ? _value.recipientId
                : recipientId // ignore: cast_nullable_to_non_nullable
                      as String?,
            vendorId: freezed == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                      as String?,
            routeId: freezed == routeId
                ? _value.routeId
                : routeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            alternativeVendorIds: null == alternativeVendorIds
                ? _value.alternativeVendorIds
                : alternativeVendorIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            approvalStatus: null == approvalStatus
                ? _value.approvalStatus
                : approvalStatus // ignore: cast_nullable_to_non_nullable
                      as ShipmentApprovalStatus,
            pickupType: null == pickupType
                ? _value.pickupType
                : pickupType // ignore: cast_nullable_to_non_nullable
                      as PickupType,
            deliveryType: null == deliveryType
                ? _value.deliveryType
                : deliveryType // ignore: cast_nullable_to_non_nullable
                      as DeliveryType,
            selectedWarehouseId: freezed == selectedWarehouseId
                ? _value.selectedWarehouseId
                : selectedWarehouseId // ignore: cast_nullable_to_non_nullable
                      as String?,
            packages: null == packages
                ? _value.packages
                : packages // ignore: cast_nullable_to_non_nullable
                      as List<ShipmentPackage>,
            totalWeight: freezed == totalWeight
                ? _value.totalWeight
                : totalWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            totalPrice: freezed == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
            currency: freezed == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentStatus: null == currentStatus
                ? _value.currentStatus
                : currentStatus // ignore: cast_nullable_to_non_nullable
                      as ShipmentStatusType,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            estimatedDeliveryDate: null == estimatedDeliveryDate
                ? _value.estimatedDeliveryDate
                : estimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            events: null == events
                ? _value.events
                : events // ignore: cast_nullable_to_non_nullable
                      as List<ShipmentEvent>,
            assignedCourierId: freezed == assignedCourierId
                ? _value.assignedCourierId
                : assignedCourierId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShipmentImplCopyWith<$Res>
    implements $ShipmentCopyWith<$Res> {
  factory _$$ShipmentImplCopyWith(
    _$ShipmentImpl value,
    $Res Function(_$ShipmentImpl) then,
  ) = __$$ShipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String trackingNumber,
    String senderName,
    String senderAddress,
    String senderPhone,
    String? senderId,
    String recipientName,
    String recipientAddress,
    String recipientPhone,
    String? recipientId,
    String? vendorId,
    String? routeId,
    List<String> alternativeVendorIds,
    ShipmentApprovalStatus approvalStatus,
    PickupType pickupType,
    DeliveryType deliveryType,
    String? selectedWarehouseId,
    List<ShipmentPackage> packages,
    double? totalWeight,
    double? totalPrice,
    String? currency,
    ShipmentStatusType currentStatus,
    DateTime createdAt,
    DateTime estimatedDeliveryDate,
    List<ShipmentEvent> events,
    String? assignedCourierId,
  });
}

/// @nodoc
class __$$ShipmentImplCopyWithImpl<$Res>
    extends _$ShipmentCopyWithImpl<$Res, _$ShipmentImpl>
    implements _$$ShipmentImplCopyWith<$Res> {
  __$$ShipmentImplCopyWithImpl(
    _$ShipmentImpl _value,
    $Res Function(_$ShipmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trackingNumber = null,
    Object? senderName = null,
    Object? senderAddress = null,
    Object? senderPhone = null,
    Object? senderId = freezed,
    Object? recipientName = null,
    Object? recipientAddress = null,
    Object? recipientPhone = null,
    Object? recipientId = freezed,
    Object? vendorId = freezed,
    Object? routeId = freezed,
    Object? alternativeVendorIds = null,
    Object? approvalStatus = null,
    Object? pickupType = null,
    Object? deliveryType = null,
    Object? selectedWarehouseId = freezed,
    Object? packages = null,
    Object? totalWeight = freezed,
    Object? totalPrice = freezed,
    Object? currency = freezed,
    Object? currentStatus = null,
    Object? createdAt = null,
    Object? estimatedDeliveryDate = null,
    Object? events = null,
    Object? assignedCourierId = freezed,
  }) {
    return _then(
      _$ShipmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        trackingNumber: null == trackingNumber
            ? _value.trackingNumber
            : trackingNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        senderName: null == senderName
            ? _value.senderName
            : senderName // ignore: cast_nullable_to_non_nullable
                  as String,
        senderAddress: null == senderAddress
            ? _value.senderAddress
            : senderAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        senderPhone: null == senderPhone
            ? _value.senderPhone
            : senderPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        senderId: freezed == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        recipientName: null == recipientName
            ? _value.recipientName
            : recipientName // ignore: cast_nullable_to_non_nullable
                  as String,
        recipientAddress: null == recipientAddress
            ? _value.recipientAddress
            : recipientAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        recipientPhone: null == recipientPhone
            ? _value.recipientPhone
            : recipientPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        recipientId: freezed == recipientId
            ? _value.recipientId
            : recipientId // ignore: cast_nullable_to_non_nullable
                  as String?,
        vendorId: freezed == vendorId
            ? _value.vendorId
            : vendorId // ignore: cast_nullable_to_non_nullable
                  as String?,
        routeId: freezed == routeId
            ? _value.routeId
            : routeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        alternativeVendorIds: null == alternativeVendorIds
            ? _value._alternativeVendorIds
            : alternativeVendorIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        approvalStatus: null == approvalStatus
            ? _value.approvalStatus
            : approvalStatus // ignore: cast_nullable_to_non_nullable
                  as ShipmentApprovalStatus,
        pickupType: null == pickupType
            ? _value.pickupType
            : pickupType // ignore: cast_nullable_to_non_nullable
                  as PickupType,
        deliveryType: null == deliveryType
            ? _value.deliveryType
            : deliveryType // ignore: cast_nullable_to_non_nullable
                  as DeliveryType,
        selectedWarehouseId: freezed == selectedWarehouseId
            ? _value.selectedWarehouseId
            : selectedWarehouseId // ignore: cast_nullable_to_non_nullable
                  as String?,
        packages: null == packages
            ? _value._packages
            : packages // ignore: cast_nullable_to_non_nullable
                  as List<ShipmentPackage>,
        totalWeight: freezed == totalWeight
            ? _value.totalWeight
            : totalWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        totalPrice: freezed == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
        currency: freezed == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentStatus: null == currentStatus
            ? _value.currentStatus
            : currentStatus // ignore: cast_nullable_to_non_nullable
                  as ShipmentStatusType,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        estimatedDeliveryDate: null == estimatedDeliveryDate
            ? _value.estimatedDeliveryDate
            : estimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        events: null == events
            ? _value._events
            : events // ignore: cast_nullable_to_non_nullable
                  as List<ShipmentEvent>,
        assignedCourierId: freezed == assignedCourierId
            ? _value.assignedCourierId
            : assignedCourierId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShipmentImpl extends _Shipment {
  const _$ShipmentImpl({
    required this.id,
    required this.trackingNumber,
    required this.senderName,
    required this.senderAddress,
    required this.senderPhone,
    this.senderId,
    required this.recipientName,
    required this.recipientAddress,
    required this.recipientPhone,
    this.recipientId,
    this.vendorId,
    this.routeId,
    final List<String> alternativeVendorIds = const [],
    this.approvalStatus = ShipmentApprovalStatus.pending,
    this.pickupType = PickupType.supplierLocation,
    this.deliveryType = DeliveryType.doorstep,
    this.selectedWarehouseId,
    final List<ShipmentPackage> packages = const [],
    this.totalWeight,
    this.totalPrice,
    this.currency,
    required this.currentStatus,
    required this.createdAt,
    required this.estimatedDeliveryDate,
    required final List<ShipmentEvent> events,
    this.assignedCourierId,
  }) : _alternativeVendorIds = alternativeVendorIds,
       _packages = packages,
       _events = events,
       super._();

  factory _$ShipmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShipmentImplFromJson(json);

  @override
  final String id;
  @override
  final String trackingNumber;
  // Parties
  @override
  final String senderName;
  @override
  final String senderAddress;
  @override
  final String senderPhone;
  @override
  final String? senderId;
  @override
  final String recipientName;
  @override
  final String recipientAddress;
  @override
  final String recipientPhone;
  @override
  final String? recipientId;
  // Vendor & Route
  @override
  final String? vendorId;
  @override
  final String? routeId;
  final List<String> _alternativeVendorIds;
  @override
  @JsonKey()
  List<String> get alternativeVendorIds {
    if (_alternativeVendorIds is EqualUnmodifiableListView)
      return _alternativeVendorIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternativeVendorIds);
  }

  @override
  @JsonKey()
  final ShipmentApprovalStatus approvalStatus;
  // Logistics Details
  @override
  @JsonKey()
  final PickupType pickupType;
  @override
  @JsonKey()
  final DeliveryType deliveryType;
  @override
  final String? selectedWarehouseId;
  // Content
  final List<ShipmentPackage> _packages;
  // Content
  @override
  @JsonKey()
  List<ShipmentPackage> get packages {
    if (_packages is EqualUnmodifiableListView) return _packages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packages);
  }

  @override
  final double? totalWeight;
  @override
  final double? totalPrice;
  @override
  final String? currency;
  // Status & Meta
  @override
  final ShipmentStatusType currentStatus;
  @override
  final DateTime createdAt;
  @override
  final DateTime estimatedDeliveryDate;
  final List<ShipmentEvent> _events;
  @override
  List<ShipmentEvent> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  final String? assignedCourierId;

  @override
  String toString() {
    return 'Shipment(id: $id, trackingNumber: $trackingNumber, senderName: $senderName, senderAddress: $senderAddress, senderPhone: $senderPhone, senderId: $senderId, recipientName: $recipientName, recipientAddress: $recipientAddress, recipientPhone: $recipientPhone, recipientId: $recipientId, vendorId: $vendorId, routeId: $routeId, alternativeVendorIds: $alternativeVendorIds, approvalStatus: $approvalStatus, pickupType: $pickupType, deliveryType: $deliveryType, selectedWarehouseId: $selectedWarehouseId, packages: $packages, totalWeight: $totalWeight, totalPrice: $totalPrice, currency: $currency, currentStatus: $currentStatus, createdAt: $createdAt, estimatedDeliveryDate: $estimatedDeliveryDate, events: $events, assignedCourierId: $assignedCourierId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderAddress, senderAddress) ||
                other.senderAddress == senderAddress) &&
            (identical(other.senderPhone, senderPhone) ||
                other.senderPhone == senderPhone) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.recipientName, recipientName) ||
                other.recipientName == recipientName) &&
            (identical(other.recipientAddress, recipientAddress) ||
                other.recipientAddress == recipientAddress) &&
            (identical(other.recipientPhone, recipientPhone) ||
                other.recipientPhone == recipientPhone) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            const DeepCollectionEquality().equals(
              other._alternativeVendorIds,
              _alternativeVendorIds,
            ) &&
            (identical(other.approvalStatus, approvalStatus) ||
                other.approvalStatus == approvalStatus) &&
            (identical(other.pickupType, pickupType) ||
                other.pickupType == pickupType) &&
            (identical(other.deliveryType, deliveryType) ||
                other.deliveryType == deliveryType) &&
            (identical(other.selectedWarehouseId, selectedWarehouseId) ||
                other.selectedWarehouseId == selectedWarehouseId) &&
            const DeepCollectionEquality().equals(other._packages, _packages) &&
            (identical(other.totalWeight, totalWeight) ||
                other.totalWeight == totalWeight) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.currentStatus, currentStatus) ||
                other.currentStatus == currentStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.estimatedDeliveryDate, estimatedDeliveryDate) ||
                other.estimatedDeliveryDate == estimatedDeliveryDate) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            (identical(other.assignedCourierId, assignedCourierId) ||
                other.assignedCourierId == assignedCourierId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    trackingNumber,
    senderName,
    senderAddress,
    senderPhone,
    senderId,
    recipientName,
    recipientAddress,
    recipientPhone,
    recipientId,
    vendorId,
    routeId,
    const DeepCollectionEquality().hash(_alternativeVendorIds),
    approvalStatus,
    pickupType,
    deliveryType,
    selectedWarehouseId,
    const DeepCollectionEquality().hash(_packages),
    totalWeight,
    totalPrice,
    currency,
    currentStatus,
    createdAt,
    estimatedDeliveryDate,
    const DeepCollectionEquality().hash(_events),
    assignedCourierId,
  ]);

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipmentImplCopyWith<_$ShipmentImpl> get copyWith =>
      __$$ShipmentImplCopyWithImpl<_$ShipmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShipmentImplToJson(this);
  }
}

abstract class _Shipment extends Shipment {
  const factory _Shipment({
    required final String id,
    required final String trackingNumber,
    required final String senderName,
    required final String senderAddress,
    required final String senderPhone,
    final String? senderId,
    required final String recipientName,
    required final String recipientAddress,
    required final String recipientPhone,
    final String? recipientId,
    final String? vendorId,
    final String? routeId,
    final List<String> alternativeVendorIds,
    final ShipmentApprovalStatus approvalStatus,
    final PickupType pickupType,
    final DeliveryType deliveryType,
    final String? selectedWarehouseId,
    final List<ShipmentPackage> packages,
    final double? totalWeight,
    final double? totalPrice,
    final String? currency,
    required final ShipmentStatusType currentStatus,
    required final DateTime createdAt,
    required final DateTime estimatedDeliveryDate,
    required final List<ShipmentEvent> events,
    final String? assignedCourierId,
  }) = _$ShipmentImpl;
  const _Shipment._() : super._();

  factory _Shipment.fromJson(Map<String, dynamic> json) =
      _$ShipmentImpl.fromJson;

  @override
  String get id;
  @override
  String get trackingNumber; // Parties
  @override
  String get senderName;
  @override
  String get senderAddress;
  @override
  String get senderPhone;
  @override
  String? get senderId;
  @override
  String get recipientName;
  @override
  String get recipientAddress;
  @override
  String get recipientPhone;
  @override
  String? get recipientId; // Vendor & Route
  @override
  String? get vendorId;
  @override
  String? get routeId;
  @override
  List<String> get alternativeVendorIds;
  @override
  ShipmentApprovalStatus get approvalStatus; // Logistics Details
  @override
  PickupType get pickupType;
  @override
  DeliveryType get deliveryType;
  @override
  String? get selectedWarehouseId; // Content
  @override
  List<ShipmentPackage> get packages;
  @override
  double? get totalWeight;
  @override
  double? get totalPrice;
  @override
  String? get currency; // Status & Meta
  @override
  ShipmentStatusType get currentStatus;
  @override
  DateTime get createdAt;
  @override
  DateTime get estimatedDeliveryDate;
  @override
  List<ShipmentEvent> get events;
  @override
  String? get assignedCourierId;

  /// Create a copy of Shipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShipmentImplCopyWith<_$ShipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LogisticsWarehouse _$LogisticsWarehouseFromJson(Map<String, dynamic> json) {
  return _LogisticsWarehouse.fromJson(json);
}

/// @nodoc
mixin _$LogisticsWarehouse {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  ShipmentLocation get location => throw _privateConstructorUsedError;
  String get vendorId => throw _privateConstructorUsedError;
  String? get contactPhone => throw _privateConstructorUsedError;

  /// Serializes this LogisticsWarehouse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LogisticsWarehouse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogisticsWarehouseCopyWith<LogisticsWarehouse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogisticsWarehouseCopyWith<$Res> {
  factory $LogisticsWarehouseCopyWith(
    LogisticsWarehouse value,
    $Res Function(LogisticsWarehouse) then,
  ) = _$LogisticsWarehouseCopyWithImpl<$Res, LogisticsWarehouse>;
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    ShipmentLocation location,
    String vendorId,
    String? contactPhone,
  });

  $ShipmentLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$LogisticsWarehouseCopyWithImpl<$Res, $Val extends LogisticsWarehouse>
    implements $LogisticsWarehouseCopyWith<$Res> {
  _$LogisticsWarehouseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogisticsWarehouse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? location = null,
    Object? vendorId = null,
    Object? contactPhone = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as ShipmentLocation,
            vendorId: null == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                      as String,
            contactPhone: freezed == contactPhone
                ? _value.contactPhone
                : contactPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of LogisticsWarehouse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShipmentLocationCopyWith<$Res> get location {
    return $ShipmentLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LogisticsWarehouseImplCopyWith<$Res>
    implements $LogisticsWarehouseCopyWith<$Res> {
  factory _$$LogisticsWarehouseImplCopyWith(
    _$LogisticsWarehouseImpl value,
    $Res Function(_$LogisticsWarehouseImpl) then,
  ) = __$$LogisticsWarehouseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    ShipmentLocation location,
    String vendorId,
    String? contactPhone,
  });

  @override
  $ShipmentLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$LogisticsWarehouseImplCopyWithImpl<$Res>
    extends _$LogisticsWarehouseCopyWithImpl<$Res, _$LogisticsWarehouseImpl>
    implements _$$LogisticsWarehouseImplCopyWith<$Res> {
  __$$LogisticsWarehouseImplCopyWithImpl(
    _$LogisticsWarehouseImpl _value,
    $Res Function(_$LogisticsWarehouseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogisticsWarehouse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? location = null,
    Object? vendorId = null,
    Object? contactPhone = freezed,
  }) {
    return _then(
      _$LogisticsWarehouseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as ShipmentLocation,
        vendorId: null == vendorId
            ? _value.vendorId
            : vendorId // ignore: cast_nullable_to_non_nullable
                  as String,
        contactPhone: freezed == contactPhone
            ? _value.contactPhone
            : contactPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LogisticsWarehouseImpl implements _LogisticsWarehouse {
  const _$LogisticsWarehouseImpl({
    required this.id,
    required this.name,
    required this.address,
    required this.location,
    required this.vendorId,
    this.contactPhone,
  });

  factory _$LogisticsWarehouseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LogisticsWarehouseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String address;
  @override
  final ShipmentLocation location;
  @override
  final String vendorId;
  @override
  final String? contactPhone;

  @override
  String toString() {
    return 'LogisticsWarehouse(id: $id, name: $name, address: $address, location: $location, vendorId: $vendorId, contactPhone: $contactPhone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogisticsWarehouseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    address,
    location,
    vendorId,
    contactPhone,
  );

  /// Create a copy of LogisticsWarehouse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogisticsWarehouseImplCopyWith<_$LogisticsWarehouseImpl> get copyWith =>
      __$$LogisticsWarehouseImplCopyWithImpl<_$LogisticsWarehouseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LogisticsWarehouseImplToJson(this);
  }
}

abstract class _LogisticsWarehouse implements LogisticsWarehouse {
  const factory _LogisticsWarehouse({
    required final String id,
    required final String name,
    required final String address,
    required final ShipmentLocation location,
    required final String vendorId,
    final String? contactPhone,
  }) = _$LogisticsWarehouseImpl;

  factory _LogisticsWarehouse.fromJson(Map<String, dynamic> json) =
      _$LogisticsWarehouseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get address;
  @override
  ShipmentLocation get location;
  @override
  String get vendorId;
  @override
  String? get contactPhone;

  /// Create a copy of LogisticsWarehouse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogisticsWarehouseImplCopyWith<_$LogisticsWarehouseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourierAssignment _$CourierAssignmentFromJson(Map<String, dynamic> json) {
  return _CourierAssignment.fromJson(json);
}

/// @nodoc
mixin _$CourierAssignment {
  String get id => throw _privateConstructorUsedError;
  String get shipmentId => throw _privateConstructorUsedError;
  String get trackingNumber => throw _privateConstructorUsedError;
  String get courierId => throw _privateConstructorUsedError;
  String get courierName => throw _privateConstructorUsedError;
  String get vendorId => throw _privateConstructorUsedError;
  String get vendorName => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  DateTime get assignedAt => throw _privateConstructorUsedError;
  ShipmentApprovalStatus get status => throw _privateConstructorUsedError;

  /// Serializes this CourierAssignment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourierAssignment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourierAssignmentCopyWith<CourierAssignment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourierAssignmentCopyWith<$Res> {
  factory $CourierAssignmentCopyWith(
    CourierAssignment value,
    $Res Function(CourierAssignment) then,
  ) = _$CourierAssignmentCopyWithImpl<$Res, CourierAssignment>;
  @useResult
  $Res call({
    String id,
    String shipmentId,
    String trackingNumber,
    String courierId,
    String courierName,
    String vendorId,
    String vendorName,
    String senderId,
    String senderName,
    DateTime assignedAt,
    ShipmentApprovalStatus status,
  });
}

/// @nodoc
class _$CourierAssignmentCopyWithImpl<$Res, $Val extends CourierAssignment>
    implements $CourierAssignmentCopyWith<$Res> {
  _$CourierAssignmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourierAssignment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shipmentId = null,
    Object? trackingNumber = null,
    Object? courierId = null,
    Object? courierName = null,
    Object? vendorId = null,
    Object? vendorName = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? assignedAt = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            shipmentId: null == shipmentId
                ? _value.shipmentId
                : shipmentId // ignore: cast_nullable_to_non_nullable
                      as String,
            trackingNumber: null == trackingNumber
                ? _value.trackingNumber
                : trackingNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            courierId: null == courierId
                ? _value.courierId
                : courierId // ignore: cast_nullable_to_non_nullable
                      as String,
            courierName: null == courierName
                ? _value.courierName
                : courierName // ignore: cast_nullable_to_non_nullable
                      as String,
            vendorId: null == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                      as String,
            vendorName: null == vendorName
                ? _value.vendorName
                : vendorName // ignore: cast_nullable_to_non_nullable
                      as String,
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderName: null == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                      as String,
            assignedAt: null == assignedAt
                ? _value.assignedAt
                : assignedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ShipmentApprovalStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourierAssignmentImplCopyWith<$Res>
    implements $CourierAssignmentCopyWith<$Res> {
  factory _$$CourierAssignmentImplCopyWith(
    _$CourierAssignmentImpl value,
    $Res Function(_$CourierAssignmentImpl) then,
  ) = __$$CourierAssignmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String shipmentId,
    String trackingNumber,
    String courierId,
    String courierName,
    String vendorId,
    String vendorName,
    String senderId,
    String senderName,
    DateTime assignedAt,
    ShipmentApprovalStatus status,
  });
}

/// @nodoc
class __$$CourierAssignmentImplCopyWithImpl<$Res>
    extends _$CourierAssignmentCopyWithImpl<$Res, _$CourierAssignmentImpl>
    implements _$$CourierAssignmentImplCopyWith<$Res> {
  __$$CourierAssignmentImplCopyWithImpl(
    _$CourierAssignmentImpl _value,
    $Res Function(_$CourierAssignmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourierAssignment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shipmentId = null,
    Object? trackingNumber = null,
    Object? courierId = null,
    Object? courierName = null,
    Object? vendorId = null,
    Object? vendorName = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? assignedAt = null,
    Object? status = null,
  }) {
    return _then(
      _$CourierAssignmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        shipmentId: null == shipmentId
            ? _value.shipmentId
            : shipmentId // ignore: cast_nullable_to_non_nullable
                  as String,
        trackingNumber: null == trackingNumber
            ? _value.trackingNumber
            : trackingNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        courierId: null == courierId
            ? _value.courierId
            : courierId // ignore: cast_nullable_to_non_nullable
                  as String,
        courierName: null == courierName
            ? _value.courierName
            : courierName // ignore: cast_nullable_to_non_nullable
                  as String,
        vendorId: null == vendorId
            ? _value.vendorId
            : vendorId // ignore: cast_nullable_to_non_nullable
                  as String,
        vendorName: null == vendorName
            ? _value.vendorName
            : vendorName // ignore: cast_nullable_to_non_nullable
                  as String,
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderName: null == senderName
            ? _value.senderName
            : senderName // ignore: cast_nullable_to_non_nullable
                  as String,
        assignedAt: null == assignedAt
            ? _value.assignedAt
            : assignedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ShipmentApprovalStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourierAssignmentImpl implements _CourierAssignment {
  const _$CourierAssignmentImpl({
    required this.id,
    required this.shipmentId,
    required this.trackingNumber,
    required this.courierId,
    required this.courierName,
    required this.vendorId,
    required this.vendorName,
    required this.senderId,
    required this.senderName,
    required this.assignedAt,
    this.status = ShipmentApprovalStatus.approved,
  });

  factory _$CourierAssignmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourierAssignmentImplFromJson(json);

  @override
  final String id;
  @override
  final String shipmentId;
  @override
  final String trackingNumber;
  @override
  final String courierId;
  @override
  final String courierName;
  @override
  final String vendorId;
  @override
  final String vendorName;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final DateTime assignedAt;
  @override
  @JsonKey()
  final ShipmentApprovalStatus status;

  @override
  String toString() {
    return 'CourierAssignment(id: $id, shipmentId: $shipmentId, trackingNumber: $trackingNumber, courierId: $courierId, courierName: $courierName, vendorId: $vendorId, vendorName: $vendorName, senderId: $senderId, senderName: $senderName, assignedAt: $assignedAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourierAssignmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shipmentId, shipmentId) ||
                other.shipmentId == shipmentId) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.courierId, courierId) ||
                other.courierId == courierId) &&
            (identical(other.courierName, courierName) ||
                other.courierName == courierName) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    shipmentId,
    trackingNumber,
    courierId,
    courierName,
    vendorId,
    vendorName,
    senderId,
    senderName,
    assignedAt,
    status,
  );

  /// Create a copy of CourierAssignment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourierAssignmentImplCopyWith<_$CourierAssignmentImpl> get copyWith =>
      __$$CourierAssignmentImplCopyWithImpl<_$CourierAssignmentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CourierAssignmentImplToJson(this);
  }
}

abstract class _CourierAssignment implements CourierAssignment {
  const factory _CourierAssignment({
    required final String id,
    required final String shipmentId,
    required final String trackingNumber,
    required final String courierId,
    required final String courierName,
    required final String vendorId,
    required final String vendorName,
    required final String senderId,
    required final String senderName,
    required final DateTime assignedAt,
    final ShipmentApprovalStatus status,
  }) = _$CourierAssignmentImpl;

  factory _CourierAssignment.fromJson(Map<String, dynamic> json) =
      _$CourierAssignmentImpl.fromJson;

  @override
  String get id;
  @override
  String get shipmentId;
  @override
  String get trackingNumber;
  @override
  String get courierId;
  @override
  String get courierName;
  @override
  String get vendorId;
  @override
  String get vendorName;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  DateTime get assignedAt;
  @override
  ShipmentApprovalStatus get status;

  /// Create a copy of CourierAssignment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourierAssignmentImplCopyWith<_$CourierAssignmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
