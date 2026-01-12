import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rightlogistics/src/core/utils/json_converters.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';

part 'order_models.freezed.dart';
part 'order_models.g.dart';

enum OrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('paid')
  paid,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('shipped')
  shipped,
  @JsonValue('delivered')
  delivered,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String buyerId,
    required String vendorId,
    required String postId,
    required PostType postType,
    required String title,
    required int quantity,
    required double priceAtPurchase,
    required double totalAmount,
    required double serviceFee,
    required double tax,
    required String currency,
    String? promoCode,
    double? discountAmount,
    required OrderStatus status,
    @TimestampConverter() required DateTime createdAt,
    @TimestampNullableConverter() DateTime? updatedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class PaymentTransaction with _$PaymentTransaction {
  const factory PaymentTransaction({
    required String id,
    required String orderId,
    required String buyerId,
    required String vendorId,
    required double amount,
    required String currency,
    required String provider, // flutterwave, stripe, nowpayments
    required String method, // mobile_money, card, crypto, etc.
    required String status, // successful, failed, pending
    String? externalReference,
    @TimestampConverter() required DateTime createdAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _PaymentTransaction;

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) =>
      _$PaymentTransactionFromJson(json);
}
