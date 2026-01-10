import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rightlogistics/src/core/utils/json_converters.dart';

part 'social_models.freezed.dart';
part 'social_models.g.dart';

enum PostType {
  @JsonValue('pre_order')
  pre_Order,
  @JsonValue('promotion')
  promotion,
  @JsonValue('appreciation')
  appreciation,
  @JsonValue('new_item')
  new_Item,
  @JsonValue('update')
  update,
  @JsonValue('logistics')
  logistics,
  @JsonValue('warehouse')
  warehouse,
  @JsonValue('warehouse_supplier')
  warehouse_Supplier,
  @JsonValue('product_launch')
  product_Launch,
  @JsonValue('status_update')
  status_Update,
}

enum PostVisibility {
  @JsonValue('public')
  public,
  @JsonValue('connections')
  connections,
  @JsonValue('private')
  private,
}

@freezed
class VendorPost with _$VendorPost {
  const factory VendorPost({
    required String id,
    required String vendorId,
    required String vendorName,
    String? vendorPhotoUrl,
    @Default([]) List<String> imageUrls,
    String? title, // New: For Pre-Orders
    required String description,
    String? details,
    @Default(0.0) double price, // Changed to double
    @Default('GHS') String currency,
    @Default(false) bool isPurchasable,

    // Pre-Order & Shipping Specifics
    int? minOrder, // Target amount
    int? maxOrder,
    @Default(0) int currentOrderCount, // Progress
    @TimestampNullableConverter() DateTime? eta,
    String? deliveryTime, // e.g., "3-5 days"
    String? deliveryMode, // e.g., "Air Freight"

    @Default(PostType.update) PostType type,
    @Default(PostVisibility.public) PostVisibility visibility,

    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime expiresAt,
    @Default([]) List<String> viewIds, // New: Tracking views
    @Default([]) List<String> likeIds,
    @Default([]) List<String> bookmarkIds, // New
    @Default(0) int commentCount,
    @Default(0) int shareCount,
    @Default({}) Map<String, dynamic> metadata,
    @Default([]) List<String> tags, // New: Tags support
  }) = _VendorPost;

  factory VendorPost.fromJson(Map<String, dynamic> json) =>
      _$VendorPostFromJson(json);
}

@freezed
class PostComment with _$PostComment {
  const factory PostComment({
    required String id,
    required String postId,
    String? parentId, // New: For replies
    required String userId,
    required String userName,
    String? userPhotoUrl,
    required String content,
    @TimestampConverter() required DateTime createdAt,
    @Default([]) List<String> likeIds, // New: Like support
    @Default(0) int replyCount, // New: Reply count
    @Default([]) List<String> tags, // New: Tags support
  }) = _PostComment;

  factory PostComment.fromJson(Map<String, dynamic> json) =>
      _$PostCommentFromJson(json);
}

@freezed
class ChatRoom with _$ChatRoom {
  const factory ChatRoom({
    required String id,
    required List<String> participantIds,
    required Map<String, dynamic> participantDetails, // uid -> {name, photo}
    String? lastMessage,
    @TimestampNullableConverter() DateTime? lastMessageAt,
    @Default(0) int unreadCount,
  }) = _ChatRoom;

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);
}

@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String senderId,
    required String content,
    @TimestampConverter() required DateTime createdAt,
    @Default(false) bool isRead,
    String? attachmentUrl,
    String? type, // text, image, post_reference
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
