// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['id'] as String,
  buyerId: json['buyerId'] as String,
  vendorId: json['vendorId'] as String,
  postId: json['postId'] as String,
  postType: $enumDecode(_$PostTypeEnumMap, json['postType']),
  title: json['title'] as String,
  quantity: (json['quantity'] as num).toInt(),
  priceAtPurchase: (json['priceAtPurchase'] as num).toDouble(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  serviceFee: (json['serviceFee'] as num).toDouble(),
  tax: (json['tax'] as num).toDouble(),
  currency: json['currency'] as String,
  promoCode: json['promoCode'] as String?,
  discountAmount: (json['discountAmount'] as num?)?.toDouble(),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  updatedAt: const TimestampNullableConverter().fromJson(json['updatedAt']),
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$OrderImplToJson(
  _$OrderImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'buyerId': instance.buyerId,
  'vendorId': instance.vendorId,
  'postId': instance.postId,
  'postType': _$PostTypeEnumMap[instance.postType]!,
  'title': instance.title,
  'quantity': instance.quantity,
  'priceAtPurchase': instance.priceAtPurchase,
  'totalAmount': instance.totalAmount,
  'serviceFee': instance.serviceFee,
  'tax': instance.tax,
  'currency': instance.currency,
  'promoCode': instance.promoCode,
  'discountAmount': instance.discountAmount,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampNullableConverter().toJson(instance.updatedAt),
  'metadata': instance.metadata,
};

const _$PostTypeEnumMap = {
  PostType.pre_Order: 'pre_order',
  PostType.promotion: 'promotion',
  PostType.appreciation: 'appreciation',
  PostType.new_Item: 'new_item',
  PostType.update: 'update',
  PostType.logistics: 'logistics',
  PostType.warehouse: 'warehouse',
  PostType.warehouse_Supplier: 'warehouse_supplier',
  PostType.product_Launch: 'product_launch',
  PostType.status_Update: 'status_update',
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.paid: 'paid',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.shipped: 'shipped',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
};

_$PaymentTransactionImpl _$$PaymentTransactionImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentTransactionImpl(
  id: json['id'] as String,
  orderId: json['orderId'] as String,
  buyerId: json['buyerId'] as String,
  vendorId: json['vendorId'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  provider: json['provider'] as String,
  method: json['method'] as String,
  status: json['status'] as String,
  externalReference: json['externalReference'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$$PaymentTransactionImplToJson(
  _$PaymentTransactionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'orderId': instance.orderId,
  'buyerId': instance.buyerId,
  'vendorId': instance.vendorId,
  'amount': instance.amount,
  'currency': instance.currency,
  'provider': instance.provider,
  'method': instance.method,
  'status': instance.status,
  'externalReference': instance.externalReference,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'metadata': instance.metadata,
};
