import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rightlogistics/src/core/utils/json_converters.dart';

part 'quotation_model.freezed.dart';
part 'quotation_model.g.dart';

enum FreightType {
  @JsonValue('air')
  air,
  @JsonValue('sea')
  sea,
}

enum DeliverySpeed {
  @JsonValue('express')
  express,
  @JsonValue('normal')
  normal,
}

enum ItemCategory {
  @JsonValue('normal')
  normal,
  @JsonValue('sensitive')
  sensitive,
  @JsonValue('phone')
  phone,
  @JsonValue('laptop')
  laptop,
  @JsonValue('special')
  special,
}

@freezed
class VendorQuotation with _$VendorQuotation {
  const factory VendorQuotation({
    required String id,
    required String vendorId,
    required String vendorName,
    required FreightType freightType,
    DeliverySpeed? deliverySpeed, // Only for air freight
    required ItemCategory itemCategory,
    required double ratePerUnit, // $/kg for air, $/CBM for sea, flat for phone
    @Default('USD') String currency,
    double? minimumWeight, // For air freight
    double? minimumVolume, // For sea freight
    @TimestampConverter() required DateTime validFrom,
    @TimestampConverter() required DateTime validUntil,
    @Default(true) bool isActive,
    @Default({}) Map<String, dynamic> metadata,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    String? createdBy, // Admin user ID
    String? notes,
  }) = _VendorQuotation;

  factory VendorQuotation.fromJson(Map<String, dynamic> json) =>
      _$VendorQuotationFromJson(json);
}
