// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_shipment_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateShipmentState {
  int get currentStep =>
      throw _privateConstructorUsedError; // Step 1: Vendor & Route
  UserModel? get selectedVendor => throw _privateConstructorUsedError;
  String? get selectedRouteId =>
      throw _privateConstructorUsedError; // Step 2: Packages & Items
  List<ShipmentPackage> get packages =>
      throw _privateConstructorUsedError; // Helper to calculate total declared value from all items
  double get totalDeclaredValue =>
      throw _privateConstructorUsedError; // Step 3: Supplier/Sender Info
  String? get senderName => throw _privateConstructorUsedError;
  String? get senderPhone => throw _privateConstructorUsedError;
  String? get senderAddress => throw _privateConstructorUsedError;
  String? get senderNote =>
      throw _privateConstructorUsedError; // Step 4: Warehouse (Drop-off point)
  String? get selectedWarehouseId => throw _privateConstructorUsedError;
  PickupType get pickupType =>
      throw _privateConstructorUsedError; // Step 5: Final Delivery
  String? get recipientName => throw _privateConstructorUsedError;
  String? get recipientPhone => throw _privateConstructorUsedError;
  String? get recipientAddress => throw _privateConstructorUsedError;
  DeliveryType get deliveryType =>
      throw _privateConstructorUsedError; // Step 6: Cost & Suggestions
  List<Map<String, dynamic>> get alternativeQuotes =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get selectedQuote => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of CreateShipmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateShipmentStateCopyWith<CreateShipmentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateShipmentStateCopyWith<$Res> {
  factory $CreateShipmentStateCopyWith(
    CreateShipmentState value,
    $Res Function(CreateShipmentState) then,
  ) = _$CreateShipmentStateCopyWithImpl<$Res, CreateShipmentState>;
  @useResult
  $Res call({
    int currentStep,
    UserModel? selectedVendor,
    String? selectedRouteId,
    List<ShipmentPackage> packages,
    double totalDeclaredValue,
    String? senderName,
    String? senderPhone,
    String? senderAddress,
    String? senderNote,
    String? selectedWarehouseId,
    PickupType pickupType,
    String? recipientName,
    String? recipientPhone,
    String? recipientAddress,
    DeliveryType deliveryType,
    List<Map<String, dynamic>> alternativeQuotes,
    Map<String, dynamic>? selectedQuote,
    bool isLoading,
    String? error,
  });

  $UserModelCopyWith<$Res>? get selectedVendor;
}

/// @nodoc
class _$CreateShipmentStateCopyWithImpl<$Res, $Val extends CreateShipmentState>
    implements $CreateShipmentStateCopyWith<$Res> {
  _$CreateShipmentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateShipmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? selectedVendor = freezed,
    Object? selectedRouteId = freezed,
    Object? packages = null,
    Object? totalDeclaredValue = null,
    Object? senderName = freezed,
    Object? senderPhone = freezed,
    Object? senderAddress = freezed,
    Object? senderNote = freezed,
    Object? selectedWarehouseId = freezed,
    Object? pickupType = null,
    Object? recipientName = freezed,
    Object? recipientPhone = freezed,
    Object? recipientAddress = freezed,
    Object? deliveryType = null,
    Object? alternativeQuotes = null,
    Object? selectedQuote = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as int,
            selectedVendor: freezed == selectedVendor
                ? _value.selectedVendor
                : selectedVendor // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
            selectedRouteId: freezed == selectedRouteId
                ? _value.selectedRouteId
                : selectedRouteId // ignore: cast_nullable_to_non_nullable
                      as String?,
            packages: null == packages
                ? _value.packages
                : packages // ignore: cast_nullable_to_non_nullable
                      as List<ShipmentPackage>,
            totalDeclaredValue: null == totalDeclaredValue
                ? _value.totalDeclaredValue
                : totalDeclaredValue // ignore: cast_nullable_to_non_nullable
                      as double,
            senderName: freezed == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                      as String?,
            senderPhone: freezed == senderPhone
                ? _value.senderPhone
                : senderPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            senderAddress: freezed == senderAddress
                ? _value.senderAddress
                : senderAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            senderNote: freezed == senderNote
                ? _value.senderNote
                : senderNote // ignore: cast_nullable_to_non_nullable
                      as String?,
            selectedWarehouseId: freezed == selectedWarehouseId
                ? _value.selectedWarehouseId
                : selectedWarehouseId // ignore: cast_nullable_to_non_nullable
                      as String?,
            pickupType: null == pickupType
                ? _value.pickupType
                : pickupType // ignore: cast_nullable_to_non_nullable
                      as PickupType,
            recipientName: freezed == recipientName
                ? _value.recipientName
                : recipientName // ignore: cast_nullable_to_non_nullable
                      as String?,
            recipientPhone: freezed == recipientPhone
                ? _value.recipientPhone
                : recipientPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            recipientAddress: freezed == recipientAddress
                ? _value.recipientAddress
                : recipientAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            deliveryType: null == deliveryType
                ? _value.deliveryType
                : deliveryType // ignore: cast_nullable_to_non_nullable
                      as DeliveryType,
            alternativeQuotes: null == alternativeQuotes
                ? _value.alternativeQuotes
                : alternativeQuotes // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            selectedQuote: freezed == selectedQuote
                ? _value.selectedQuote
                : selectedQuote // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of CreateShipmentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get selectedVendor {
    if (_value.selectedVendor == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.selectedVendor!, (value) {
      return _then(_value.copyWith(selectedVendor: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateShipmentStateImplCopyWith<$Res>
    implements $CreateShipmentStateCopyWith<$Res> {
  factory _$$CreateShipmentStateImplCopyWith(
    _$CreateShipmentStateImpl value,
    $Res Function(_$CreateShipmentStateImpl) then,
  ) = __$$CreateShipmentStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentStep,
    UserModel? selectedVendor,
    String? selectedRouteId,
    List<ShipmentPackage> packages,
    double totalDeclaredValue,
    String? senderName,
    String? senderPhone,
    String? senderAddress,
    String? senderNote,
    String? selectedWarehouseId,
    PickupType pickupType,
    String? recipientName,
    String? recipientPhone,
    String? recipientAddress,
    DeliveryType deliveryType,
    List<Map<String, dynamic>> alternativeQuotes,
    Map<String, dynamic>? selectedQuote,
    bool isLoading,
    String? error,
  });

  @override
  $UserModelCopyWith<$Res>? get selectedVendor;
}

/// @nodoc
class __$$CreateShipmentStateImplCopyWithImpl<$Res>
    extends _$CreateShipmentStateCopyWithImpl<$Res, _$CreateShipmentStateImpl>
    implements _$$CreateShipmentStateImplCopyWith<$Res> {
  __$$CreateShipmentStateImplCopyWithImpl(
    _$CreateShipmentStateImpl _value,
    $Res Function(_$CreateShipmentStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateShipmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? selectedVendor = freezed,
    Object? selectedRouteId = freezed,
    Object? packages = null,
    Object? totalDeclaredValue = null,
    Object? senderName = freezed,
    Object? senderPhone = freezed,
    Object? senderAddress = freezed,
    Object? senderNote = freezed,
    Object? selectedWarehouseId = freezed,
    Object? pickupType = null,
    Object? recipientName = freezed,
    Object? recipientPhone = freezed,
    Object? recipientAddress = freezed,
    Object? deliveryType = null,
    Object? alternativeQuotes = null,
    Object? selectedQuote = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _$CreateShipmentStateImpl(
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        selectedVendor: freezed == selectedVendor
            ? _value.selectedVendor
            : selectedVendor // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
        selectedRouteId: freezed == selectedRouteId
            ? _value.selectedRouteId
            : selectedRouteId // ignore: cast_nullable_to_non_nullable
                  as String?,
        packages: null == packages
            ? _value._packages
            : packages // ignore: cast_nullable_to_non_nullable
                  as List<ShipmentPackage>,
        totalDeclaredValue: null == totalDeclaredValue
            ? _value.totalDeclaredValue
            : totalDeclaredValue // ignore: cast_nullable_to_non_nullable
                  as double,
        senderName: freezed == senderName
            ? _value.senderName
            : senderName // ignore: cast_nullable_to_non_nullable
                  as String?,
        senderPhone: freezed == senderPhone
            ? _value.senderPhone
            : senderPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        senderAddress: freezed == senderAddress
            ? _value.senderAddress
            : senderAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        senderNote: freezed == senderNote
            ? _value.senderNote
            : senderNote // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedWarehouseId: freezed == selectedWarehouseId
            ? _value.selectedWarehouseId
            : selectedWarehouseId // ignore: cast_nullable_to_non_nullable
                  as String?,
        pickupType: null == pickupType
            ? _value.pickupType
            : pickupType // ignore: cast_nullable_to_non_nullable
                  as PickupType,
        recipientName: freezed == recipientName
            ? _value.recipientName
            : recipientName // ignore: cast_nullable_to_non_nullable
                  as String?,
        recipientPhone: freezed == recipientPhone
            ? _value.recipientPhone
            : recipientPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        recipientAddress: freezed == recipientAddress
            ? _value.recipientAddress
            : recipientAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryType: null == deliveryType
            ? _value.deliveryType
            : deliveryType // ignore: cast_nullable_to_non_nullable
                  as DeliveryType,
        alternativeQuotes: null == alternativeQuotes
            ? _value._alternativeQuotes
            : alternativeQuotes // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        selectedQuote: freezed == selectedQuote
            ? _value._selectedQuote
            : selectedQuote // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CreateShipmentStateImpl extends _CreateShipmentState {
  const _$CreateShipmentStateImpl({
    this.currentStep = 0,
    this.selectedVendor,
    this.selectedRouteId,
    final List<ShipmentPackage> packages = const [],
    this.totalDeclaredValue = 0.0,
    this.senderName,
    this.senderPhone,
    this.senderAddress,
    this.senderNote,
    this.selectedWarehouseId,
    this.pickupType = PickupType.supplierLocation,
    this.recipientName,
    this.recipientPhone,
    this.recipientAddress,
    this.deliveryType = DeliveryType.doorstep,
    final List<Map<String, dynamic>> alternativeQuotes = const [],
    final Map<String, dynamic>? selectedQuote,
    this.isLoading = false,
    this.error,
  }) : _packages = packages,
       _alternativeQuotes = alternativeQuotes,
       _selectedQuote = selectedQuote,
       super._();

  @override
  @JsonKey()
  final int currentStep;
  // Step 1: Vendor & Route
  @override
  final UserModel? selectedVendor;
  @override
  final String? selectedRouteId;
  // Step 2: Packages & Items
  final List<ShipmentPackage> _packages;
  // Step 2: Packages & Items
  @override
  @JsonKey()
  List<ShipmentPackage> get packages {
    if (_packages is EqualUnmodifiableListView) return _packages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_packages);
  }

  // Helper to calculate total declared value from all items
  @override
  @JsonKey()
  final double totalDeclaredValue;
  // Step 3: Supplier/Sender Info
  @override
  final String? senderName;
  @override
  final String? senderPhone;
  @override
  final String? senderAddress;
  @override
  final String? senderNote;
  // Step 4: Warehouse (Drop-off point)
  @override
  final String? selectedWarehouseId;
  @override
  @JsonKey()
  final PickupType pickupType;
  // Step 5: Final Delivery
  @override
  final String? recipientName;
  @override
  final String? recipientPhone;
  @override
  final String? recipientAddress;
  @override
  @JsonKey()
  final DeliveryType deliveryType;
  // Step 6: Cost & Suggestions
  final List<Map<String, dynamic>> _alternativeQuotes;
  // Step 6: Cost & Suggestions
  @override
  @JsonKey()
  List<Map<String, dynamic>> get alternativeQuotes {
    if (_alternativeQuotes is EqualUnmodifiableListView)
      return _alternativeQuotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternativeQuotes);
  }

  final Map<String, dynamic>? _selectedQuote;
  @override
  Map<String, dynamic>? get selectedQuote {
    final value = _selectedQuote;
    if (value == null) return null;
    if (_selectedQuote is EqualUnmodifiableMapView) return _selectedQuote;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'CreateShipmentState(currentStep: $currentStep, selectedVendor: $selectedVendor, selectedRouteId: $selectedRouteId, packages: $packages, totalDeclaredValue: $totalDeclaredValue, senderName: $senderName, senderPhone: $senderPhone, senderAddress: $senderAddress, senderNote: $senderNote, selectedWarehouseId: $selectedWarehouseId, pickupType: $pickupType, recipientName: $recipientName, recipientPhone: $recipientPhone, recipientAddress: $recipientAddress, deliveryType: $deliveryType, alternativeQuotes: $alternativeQuotes, selectedQuote: $selectedQuote, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateShipmentStateImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.selectedVendor, selectedVendor) ||
                other.selectedVendor == selectedVendor) &&
            (identical(other.selectedRouteId, selectedRouteId) ||
                other.selectedRouteId == selectedRouteId) &&
            const DeepCollectionEquality().equals(other._packages, _packages) &&
            (identical(other.totalDeclaredValue, totalDeclaredValue) ||
                other.totalDeclaredValue == totalDeclaredValue) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.senderPhone, senderPhone) ||
                other.senderPhone == senderPhone) &&
            (identical(other.senderAddress, senderAddress) ||
                other.senderAddress == senderAddress) &&
            (identical(other.senderNote, senderNote) ||
                other.senderNote == senderNote) &&
            (identical(other.selectedWarehouseId, selectedWarehouseId) ||
                other.selectedWarehouseId == selectedWarehouseId) &&
            (identical(other.pickupType, pickupType) ||
                other.pickupType == pickupType) &&
            (identical(other.recipientName, recipientName) ||
                other.recipientName == recipientName) &&
            (identical(other.recipientPhone, recipientPhone) ||
                other.recipientPhone == recipientPhone) &&
            (identical(other.recipientAddress, recipientAddress) ||
                other.recipientAddress == recipientAddress) &&
            (identical(other.deliveryType, deliveryType) ||
                other.deliveryType == deliveryType) &&
            const DeepCollectionEquality().equals(
              other._alternativeQuotes,
              _alternativeQuotes,
            ) &&
            const DeepCollectionEquality().equals(
              other._selectedQuote,
              _selectedQuote,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    currentStep,
    selectedVendor,
    selectedRouteId,
    const DeepCollectionEquality().hash(_packages),
    totalDeclaredValue,
    senderName,
    senderPhone,
    senderAddress,
    senderNote,
    selectedWarehouseId,
    pickupType,
    recipientName,
    recipientPhone,
    recipientAddress,
    deliveryType,
    const DeepCollectionEquality().hash(_alternativeQuotes),
    const DeepCollectionEquality().hash(_selectedQuote),
    isLoading,
    error,
  ]);

  /// Create a copy of CreateShipmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateShipmentStateImplCopyWith<_$CreateShipmentStateImpl> get copyWith =>
      __$$CreateShipmentStateImplCopyWithImpl<_$CreateShipmentStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateShipmentState extends CreateShipmentState {
  const factory _CreateShipmentState({
    final int currentStep,
    final UserModel? selectedVendor,
    final String? selectedRouteId,
    final List<ShipmentPackage> packages,
    final double totalDeclaredValue,
    final String? senderName,
    final String? senderPhone,
    final String? senderAddress,
    final String? senderNote,
    final String? selectedWarehouseId,
    final PickupType pickupType,
    final String? recipientName,
    final String? recipientPhone,
    final String? recipientAddress,
    final DeliveryType deliveryType,
    final List<Map<String, dynamic>> alternativeQuotes,
    final Map<String, dynamic>? selectedQuote,
    final bool isLoading,
    final String? error,
  }) = _$CreateShipmentStateImpl;
  const _CreateShipmentState._() : super._();

  @override
  int get currentStep; // Step 1: Vendor & Route
  @override
  UserModel? get selectedVendor;
  @override
  String? get selectedRouteId; // Step 2: Packages & Items
  @override
  List<ShipmentPackage> get packages; // Helper to calculate total declared value from all items
  @override
  double get totalDeclaredValue; // Step 3: Supplier/Sender Info
  @override
  String? get senderName;
  @override
  String? get senderPhone;
  @override
  String? get senderAddress;
  @override
  String? get senderNote; // Step 4: Warehouse (Drop-off point)
  @override
  String? get selectedWarehouseId;
  @override
  PickupType get pickupType; // Step 5: Final Delivery
  @override
  String? get recipientName;
  @override
  String? get recipientPhone;
  @override
  String? get recipientAddress;
  @override
  DeliveryType get deliveryType; // Step 6: Cost & Suggestions
  @override
  List<Map<String, dynamic>> get alternativeQuotes;
  @override
  Map<String, dynamic>? get selectedQuote;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of CreateShipmentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateShipmentStateImplCopyWith<_$CreateShipmentStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
