// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShipmentItemImpl _$$ShipmentItemImplFromJson(Map<String, dynamic> json) =>
    _$ShipmentItemImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      itemType: json['itemType'] as String,
      category: json['category'] as String,
      quantity: (json['quantity'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      declaredValue: (json['declaredValue'] as num).toDouble(),
      currency: json['currency'] as String,
      isPerishable: json['isPerishable'] as bool? ?? false,
      isFragile: json['isFragile'] as bool? ?? false,
      color: json['color'] as String?,
      dimensions: json['dimensions'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ShipmentItemImplToJson(_$ShipmentItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'itemType': instance.itemType,
      'category': instance.category,
      'quantity': instance.quantity,
      'weight': instance.weight,
      'declaredValue': instance.declaredValue,
      'currency': instance.currency,
      'isPerishable': instance.isPerishable,
      'isFragile': instance.isFragile,
      'color': instance.color,
      'dimensions': instance.dimensions,
      'imageUrls': instance.imageUrls,
    };

_$ShipmentPackageImpl _$$ShipmentPackageImplFromJson(
  Map<String, dynamic> json,
) => _$ShipmentPackageImpl(
  id: json['id'] as String,
  name: json['name'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ShipmentItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totalWeight: (json['totalWeight'] as num?)?.toDouble(),
  dimensions: json['dimensions'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$$ShipmentPackageImplToJson(
  _$ShipmentPackageImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'totalWeight': instance.totalWeight,
  'dimensions': instance.dimensions,
  'description': instance.description,
};

_$ShipmentLocationImpl _$$ShipmentLocationImplFromJson(
  Map<String, dynamic> json,
) => _$ShipmentLocationImpl(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  address: json['address'] as String,
  country: json['country'] as String?,
  state: json['state'] as String?,
  city: json['city'] as String?,
  street: json['street'] as String?,
  zip: json['zip'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$$ShipmentLocationImplToJson(
  _$ShipmentLocationImpl instance,
) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'address': instance.address,
  'country': instance.country,
  'state': instance.state,
  'city': instance.city,
  'street': instance.street,
  'zip': instance.zip,
  'description': instance.description,
};

_$ShipmentEventImpl _$$ShipmentEventImplFromJson(Map<String, dynamic> json) =>
    _$ShipmentEventImpl(
      id: json['id'] as String,
      status: $enumDecode(_$ShipmentStatusTypeEnumMap, json['status']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      location: ShipmentLocation.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      note: json['note'] as String?,
      updatedByUserId: json['updatedByUserId'] as String?,
    );

Map<String, dynamic> _$$ShipmentEventImplToJson(_$ShipmentEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$ShipmentStatusTypeEnumMap[instance.status]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'location': instance.location.toJson(),
      'note': instance.note,
      'updatedByUserId': instance.updatedByUserId,
    };

const _$ShipmentStatusTypeEnumMap = {
  ShipmentStatusType.created: 'created',
  ShipmentStatusType.pickedUp: 'picked_up',
  ShipmentStatusType.inTransit: 'in_transit',
  ShipmentStatusType.outForDelivery: 'out_for_delivery',
  ShipmentStatusType.delivered: 'delivered',
  ShipmentStatusType.failedAttempt: 'failed_attempt',
  ShipmentStatusType.cancelled: 'cancelled',
};

_$ShipmentImpl _$$ShipmentImplFromJson(Map<String, dynamic> json) =>
    _$ShipmentImpl(
      id: json['id'] as String,
      trackingNumber: json['trackingNumber'] as String,
      senderName: json['senderName'] as String,
      senderAddress: json['senderAddress'] as String,
      senderPhone: json['senderPhone'] as String,
      senderId: json['senderId'] as String?,
      recipientName: json['recipientName'] as String,
      recipientAddress: json['recipientAddress'] as String,
      recipientPhone: json['recipientPhone'] as String,
      recipientId: json['recipientId'] as String?,
      vendorId: json['vendorId'] as String?,
      routeId: json['routeId'] as String?,
      alternativeVendorIds:
          (json['alternativeVendorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      approvalStatus:
          $enumDecodeNullable(
            _$ShipmentApprovalStatusEnumMap,
            json['approvalStatus'],
          ) ??
          ShipmentApprovalStatus.pending,
      pickupType:
          $enumDecodeNullable(_$PickupTypeEnumMap, json['pickupType']) ??
          PickupType.supplierLocation,
      deliveryType:
          $enumDecodeNullable(_$DeliveryTypeEnumMap, json['deliveryType']) ??
          DeliveryType.doorstep,
      selectedWarehouseId: json['selectedWarehouseId'] as String?,
      packages:
          (json['packages'] as List<dynamic>?)
              ?.map((e) => ShipmentPackage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalWeight: (json['totalWeight'] as num?)?.toDouble(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      currentStatus: $enumDecode(
        _$ShipmentStatusTypeEnumMap,
        json['currentStatus'],
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      estimatedDeliveryDate: DateTime.parse(
        json['estimatedDeliveryDate'] as String,
      ),
      events: (json['events'] as List<dynamic>)
          .map((e) => ShipmentEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      assignedCourierId: json['assignedCourierId'] as String?,
    );

Map<String, dynamic> _$$ShipmentImplToJson(
  _$ShipmentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'trackingNumber': instance.trackingNumber,
  'senderName': instance.senderName,
  'senderAddress': instance.senderAddress,
  'senderPhone': instance.senderPhone,
  'senderId': instance.senderId,
  'recipientName': instance.recipientName,
  'recipientAddress': instance.recipientAddress,
  'recipientPhone': instance.recipientPhone,
  'recipientId': instance.recipientId,
  'vendorId': instance.vendorId,
  'routeId': instance.routeId,
  'alternativeVendorIds': instance.alternativeVendorIds,
  'approvalStatus': _$ShipmentApprovalStatusEnumMap[instance.approvalStatus]!,
  'pickupType': _$PickupTypeEnumMap[instance.pickupType]!,
  'deliveryType': _$DeliveryTypeEnumMap[instance.deliveryType]!,
  'selectedWarehouseId': instance.selectedWarehouseId,
  'packages': instance.packages.map((e) => e.toJson()).toList(),
  'totalWeight': instance.totalWeight,
  'totalPrice': instance.totalPrice,
  'currency': instance.currency,
  'currentStatus': _$ShipmentStatusTypeEnumMap[instance.currentStatus]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'estimatedDeliveryDate': instance.estimatedDeliveryDate.toIso8601String(),
  'events': instance.events.map((e) => e.toJson()).toList(),
  'assignedCourierId': instance.assignedCourierId,
};

const _$ShipmentApprovalStatusEnumMap = {
  ShipmentApprovalStatus.pending: 'pending',
  ShipmentApprovalStatus.approved: 'approved',
  ShipmentApprovalStatus.rejected: 'rejected',
  ShipmentApprovalStatus.completed: 'completed',
};

const _$PickupTypeEnumMap = {
  PickupType.vendorWarehouse: 'vendor_warehouse',
  PickupType.supplierLocation: 'supplier_location',
};

const _$DeliveryTypeEnumMap = {
  DeliveryType.doorstep: 'doorstep',
  DeliveryType.warehousePickup: 'warehouse_pickup',
};

_$LogisticsWarehouseImpl _$$LogisticsWarehouseImplFromJson(
  Map<String, dynamic> json,
) => _$LogisticsWarehouseImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  location: ShipmentLocation.fromJson(json['location'] as Map<String, dynamic>),
  vendorId: json['vendorId'] as String,
  contactPhone: json['contactPhone'] as String?,
);

Map<String, dynamic> _$$LogisticsWarehouseImplToJson(
  _$LogisticsWarehouseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'location': instance.location.toJson(),
  'vendorId': instance.vendorId,
  'contactPhone': instance.contactPhone,
};

_$CourierAssignmentImpl _$$CourierAssignmentImplFromJson(
  Map<String, dynamic> json,
) => _$CourierAssignmentImpl(
  id: json['id'] as String,
  shipmentId: json['shipmentId'] as String,
  trackingNumber: json['trackingNumber'] as String,
  courierId: json['courierId'] as String,
  courierName: json['courierName'] as String,
  vendorId: json['vendorId'] as String,
  vendorName: json['vendorName'] as String,
  senderId: json['senderId'] as String,
  senderName: json['senderName'] as String,
  assignedAt: DateTime.parse(json['assignedAt'] as String),
  status:
      $enumDecodeNullable(_$ShipmentApprovalStatusEnumMap, json['status']) ??
      ShipmentApprovalStatus.approved,
);

Map<String, dynamic> _$$CourierAssignmentImplToJson(
  _$CourierAssignmentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'shipmentId': instance.shipmentId,
  'trackingNumber': instance.trackingNumber,
  'courierId': instance.courierId,
  'courierName': instance.courierName,
  'vendorId': instance.vendorId,
  'vendorName': instance.vendorName,
  'senderId': instance.senderId,
  'senderName': instance.senderName,
  'assignedAt': instance.assignedAt.toIso8601String(),
  'status': _$ShipmentApprovalStatusEnumMap[instance.status]!,
};
