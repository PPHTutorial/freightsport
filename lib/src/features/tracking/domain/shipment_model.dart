import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipment_model.freezed.dart';
part 'shipment_model.g.dart';

enum ShipmentStatusType {
  @JsonValue('created')
  created,
  @JsonValue('picked_up')
  pickedUp,
  @JsonValue('in_transit')
  inTransit,
  @JsonValue('out_for_delivery')
  outForDelivery,
  @JsonValue('delivered')
  delivered,
  @JsonValue('failed_attempt')
  failedAttempt,
  @JsonValue('cancelled')
  cancelled,
}

enum ShipmentApprovalStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('completed')
  completed,
}

enum PickupType {
  @JsonValue('vendor_warehouse')
  vendorWarehouse,
  @JsonValue('supplier_location')
  supplierLocation,
}

enum DeliveryType {
  @JsonValue('doorstep')
  doorstep,
  @JsonValue('warehouse_pickup')
  warehousePickup,
}

@freezed
class ShipmentItem with _$ShipmentItem {
  const factory ShipmentItem({
    required String name,
    required String description,
    required String itemType, // e.g., Box, Unit
    required String category, // e.g., Electronics, Beauty
    required int quantity,
    required double weight,
    required double declaredValue,
    required String currency,
    @Default(false) bool isPerishable,
    @Default(false) bool isFragile,
    String? color,
    String? dimensions,
    List<String>? imageUrls,
  }) = _ShipmentItem;

  factory ShipmentItem.fromJson(Map<String, dynamic> json) =>
      _$ShipmentItemFromJson(json);
}

@freezed
class ShipmentPackage with _$ShipmentPackage {
  const factory ShipmentPackage({
    required String id,
    String? name, // "Package 1"
    @Default([]) List<ShipmentItem> items,
    double? totalWeight,
    String? dimensions,
    String? description,
  }) = _ShipmentPackage;

  factory ShipmentPackage.fromJson(Map<String, dynamic> json) =>
      _$ShipmentPackageFromJson(json);
}

@freezed
@freezed
class ShipmentLocation with _$ShipmentLocation {
  const factory ShipmentLocation({
    required double latitude,
    required double longitude,
    required String address,
    String? country,
    String? state,
    String? city,
    String? street,
    String? zip,
    String? description,
  }) = _ShipmentLocation;

  factory ShipmentLocation.fromJson(Map<String, dynamic> json) =>
      _$ShipmentLocationFromJson(json);
}

@freezed
class ShipmentEvent with _$ShipmentEvent {
  const factory ShipmentEvent({
    required String id,
    required ShipmentStatusType status,
    required DateTime timestamp,
    required ShipmentLocation location,
    String? note,
    String? updatedByUserId,
  }) = _ShipmentEvent;

  factory ShipmentEvent.fromJson(Map<String, dynamic> json) =>
      _$ShipmentEventFromJson(json);
}

@freezed
class Shipment with _$Shipment {
  const Shipment._(); // Needed for custom methods/getters

  const factory Shipment({
    required String id,
    required String trackingNumber,

    // Parties
    required String senderName,
    required String senderAddress,
    required String senderPhone,
    String? senderId,

    required String recipientName,
    required String recipientAddress,
    required String recipientPhone,
    String? recipientId,

    // Vendor & Route
    String? vendorId,
    String? routeId,
    @Default([]) List<String> alternativeVendorIds,
    @Default(ShipmentApprovalStatus.pending)
    ShipmentApprovalStatus approvalStatus,

    // Logistics Details
    @Default(PickupType.supplierLocation) PickupType pickupType,
    @Default(DeliveryType.doorstep) DeliveryType deliveryType,
    String? selectedWarehouseId,

    // Content
    @Default([]) List<ShipmentPackage> packages,
    double? totalWeight,
    double? totalPrice,
    String? currency,

    // Status & Meta
    required ShipmentStatusType currentStatus,
    required DateTime createdAt,
    required DateTime estimatedDeliveryDate,
    required List<ShipmentEvent> events,
    String? assignedCourierId,
  }) = _Shipment;

  factory Shipment.fromJson(Map<String, dynamic> json) =>
      _$ShipmentFromJson(json);

  // Backwards compatibility getter for flattened items
  List<ShipmentItem> get items => packages.expand((p) => p.items).toList();
}

@freezed
class LogisticsWarehouse with _$LogisticsWarehouse {
  const factory LogisticsWarehouse({
    required String id,
    required String name,
    required String address,
    required ShipmentLocation location,
    required String vendorId,
    String? contactPhone,
  }) = _LogisticsWarehouse;

  factory LogisticsWarehouse.fromJson(Map<String, dynamic> json) =>
      _$LogisticsWarehouseFromJson(json);
}

@freezed
class CourierAssignment with _$CourierAssignment {
  const factory CourierAssignment({
    required String id,
    required String shipmentId,
    required String trackingNumber,
    required String courierId,
    required String courierName,
    required String vendorId,
    required String vendorName,
    required String senderId,
    required String senderName,
    required DateTime assignedAt,
    @Default(ShipmentApprovalStatus.approved) ShipmentApprovalStatus status,
  }) = _CourierAssignment;

  factory CourierAssignment.fromJson(Map<String, dynamic> json) =>
      _$CourierAssignmentFromJson(json);
}
