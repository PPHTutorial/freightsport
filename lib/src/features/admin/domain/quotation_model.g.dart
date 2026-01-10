// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorQuotationImpl _$$VendorQuotationImplFromJson(
  Map<String, dynamic> json,
) => _$VendorQuotationImpl(
  id: json['id'] as String,
  vendorId: json['vendorId'] as String,
  vendorName: json['vendorName'] as String,
  freightType: $enumDecode(_$FreightTypeEnumMap, json['freightType']),
  deliverySpeed: $enumDecodeNullable(
    _$DeliverySpeedEnumMap,
    json['deliverySpeed'],
  ),
  itemCategory: $enumDecode(_$ItemCategoryEnumMap, json['itemCategory']),
  ratePerUnit: (json['ratePerUnit'] as num).toDouble(),
  currency: json['currency'] as String? ?? 'USD',
  minimumWeight: (json['minimumWeight'] as num?)?.toDouble(),
  minimumVolume: (json['minimumVolume'] as num?)?.toDouble(),
  validFrom: const TimestampConverter().fromJson(json['validFrom'] as Object),
  validUntil: const TimestampConverter().fromJson(json['validUntil'] as Object),
  isActive: json['isActive'] as bool? ?? true,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt'] as Object),
  createdBy: json['createdBy'] as String?,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$$VendorQuotationImplToJson(
  _$VendorQuotationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'vendorId': instance.vendorId,
  'vendorName': instance.vendorName,
  'freightType': _$FreightTypeEnumMap[instance.freightType]!,
  'deliverySpeed': _$DeliverySpeedEnumMap[instance.deliverySpeed],
  'itemCategory': _$ItemCategoryEnumMap[instance.itemCategory]!,
  'ratePerUnit': instance.ratePerUnit,
  'currency': instance.currency,
  'minimumWeight': instance.minimumWeight,
  'minimumVolume': instance.minimumVolume,
  'validFrom': const TimestampConverter().toJson(instance.validFrom),
  'validUntil': const TimestampConverter().toJson(instance.validUntil),
  'isActive': instance.isActive,
  'metadata': instance.metadata,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
  'createdBy': instance.createdBy,
  'notes': instance.notes,
};

const _$FreightTypeEnumMap = {FreightType.air: 'air', FreightType.sea: 'sea'};

const _$DeliverySpeedEnumMap = {
  DeliverySpeed.express: 'express',
  DeliverySpeed.normal: 'normal',
};

const _$ItemCategoryEnumMap = {
  ItemCategory.normal: 'normal',
  ItemCategory.sensitive: 'sensitive',
  ItemCategory.phone: 'phone',
  ItemCategory.laptop: 'laptop',
  ItemCategory.special: 'special',
};
