// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VendorPostImpl _$$VendorPostImplFromJson(
  Map<String, dynamic> json,
) => _$VendorPostImpl(
  id: json['id'] as String,
  vendorId: json['vendorId'] as String,
  vendorName: json['vendorName'] as String,
  vendorPhotoUrl: json['vendorPhotoUrl'] as String?,
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  title: json['title'] as String?,
  description: json['description'] as String,
  details: json['details'] as String?,
  price: (json['price'] as num?)?.toDouble() ?? 0.0,
  currency: json['currency'] as String? ?? 'GHS',
  isPurchasable: json['isPurchasable'] as bool? ?? false,
  minOrder: (json['minOrder'] as num?)?.toInt(),
  maxOrder: (json['maxOrder'] as num?)?.toInt(),
  currentOrderCount: (json['currentOrderCount'] as num?)?.toInt() ?? 0,
  eta: const TimestampNullableConverter().fromJson(json['eta']),
  deliveryTime: json['deliveryTime'] as String?,
  deliveryMode: json['deliveryMode'] as String?,
  type: $enumDecodeNullable(_$PostTypeEnumMap, json['type']) ?? PostType.update,
  visibility:
      $enumDecodeNullable(_$PostVisibilityEnumMap, json['visibility']) ??
      PostVisibility.public,
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  expiresAt: const TimestampConverter().fromJson(json['expiresAt'] as Object),
  viewIds:
      (json['viewIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  likeIds:
      (json['likeIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  bookmarkIds:
      (json['bookmarkIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
  shareCount: (json['shareCount'] as num?)?.toInt() ?? 0,
  metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$$VendorPostImplToJson(_$VendorPostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vendorId': instance.vendorId,
      'vendorName': instance.vendorName,
      'vendorPhotoUrl': instance.vendorPhotoUrl,
      'imageUrls': instance.imageUrls,
      'title': instance.title,
      'description': instance.description,
      'details': instance.details,
      'price': instance.price,
      'currency': instance.currency,
      'isPurchasable': instance.isPurchasable,
      'minOrder': instance.minOrder,
      'maxOrder': instance.maxOrder,
      'currentOrderCount': instance.currentOrderCount,
      'eta': const TimestampNullableConverter().toJson(instance.eta),
      'deliveryTime': instance.deliveryTime,
      'deliveryMode': instance.deliveryMode,
      'type': _$PostTypeEnumMap[instance.type]!,
      'visibility': _$PostVisibilityEnumMap[instance.visibility]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'expiresAt': const TimestampConverter().toJson(instance.expiresAt),
      'viewIds': instance.viewIds,
      'likeIds': instance.likeIds,
      'bookmarkIds': instance.bookmarkIds,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
      'metadata': instance.metadata,
      'tags': instance.tags,
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

const _$PostVisibilityEnumMap = {
  PostVisibility.public: 'public',
  PostVisibility.connections: 'connections',
  PostVisibility.private: 'private',
};

_$PostCommentImpl _$$PostCommentImplFromJson(
  Map<String, dynamic> json,
) => _$PostCommentImpl(
  id: json['id'] as String,
  postId: json['postId'] as String,
  parentId: json['parentId'] as String?,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  userPhotoUrl: json['userPhotoUrl'] as String?,
  content: json['content'] as String,
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  likeIds:
      (json['likeIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$$PostCommentImplToJson(_$PostCommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'parentId': instance.parentId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userPhotoUrl': instance.userPhotoUrl,
      'content': instance.content,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'likeIds': instance.likeIds,
      'replyCount': instance.replyCount,
      'tags': instance.tags,
    };

_$ChatRoomImpl _$$ChatRoomImplFromJson(Map<String, dynamic> json) =>
    _$ChatRoomImpl(
      id: json['id'] as String,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      participantDetails: json['participantDetails'] as Map<String, dynamic>,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: const TimestampNullableConverter().fromJson(
        json['lastMessageAt'],
      ),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ChatRoomImplToJson(_$ChatRoomImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participantIds': instance.participantIds,
      'participantDetails': instance.participantDetails,
      'lastMessage': instance.lastMessage,
      'lastMessageAt': const TimestampNullableConverter().toJson(
        instance.lastMessageAt,
      ),
      'unreadCount': instance.unreadCount,
    };

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Object,
      ),
      isRead: json['isRead'] as bool? ?? false,
      attachmentUrl: json['attachmentUrl'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'content': instance.content,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'isRead': instance.isRead,
      'attachmentUrl': instance.attachmentUrl,
      'type': instance.type,
    };
