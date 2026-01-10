import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/social/domain/status_model.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';

class SocialRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Posts ---
  Stream<List<VendorPost>> watchActivePosts() {
    return _firestore
        .collection('posts')
        // .where('expiresAt', isGreaterThan: DateTime.now())
        // .orderBy('expiresAt') // Keep expiresAt for range filter
        .snapshots(includeMetadataChanges: true)
        .map((snapshot) {
          print(
            'SocialRepo: Received ${snapshot.docs.length} posts from Firestore (NO FILTER)',
          );
          if (snapshot.docs.isNotEmpty) {
            final firstData = snapshot.docs.first.data();
            print('SocialRepo: First post RAW data: $firstData');
            print(
              'SocialRepo: First post expiresAt type: ${firstData['expiresAt'].runtimeType}',
            );
          }
          try {
            final posts = snapshot.docs
                .map((doc) {
                  try {
                    return VendorPost.fromJson({...doc.data(), 'id': doc.id});
                  } catch (e) {
                    print('SocialRepo: Error parsing post ${doc.id}: $e');
                    return null; // Handle individual failure
                  }
                })
                .whereType<VendorPost>() // Filter out nulls
                .toList();

            print('SocialRepo: Successfully parsed ${posts.length} posts');
            // Sort client-side to avoid needing a composite index on (expiresAt, createdAt)
            posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return posts;
          } catch (e) {
            print('SocialRepo: Critical error in map: $e');
            return <VendorPost>[];
          }
        });
  }

  Future<void> createPost(VendorPost post) async {
    final docRef = await _firestore.collection('posts').add(post.toJson());

    // Auto-create warehouse if it's a warehouse post
    if (post.type == PostType.warehouse ||
        post.type == PostType.warehouse_Supplier) {
      try {
        final warehouseName =
            post.metadata['warehouseName'] as String? ??
            post.title ??
            '${post.vendorName} Hub';

        final street = post.metadata['street'] as String? ?? '';
        final city = post.metadata['city'] as String? ?? '';
        final state = post.metadata['state'] as String? ?? '';
        final country = post.metadata['country'] as String? ?? '';
        final zip = post.metadata['zip'] as String? ?? '';

        final locStr = post.metadata['location'] as String? ?? '';
        double lat = 0;
        double lng = 0;
        if (locStr.contains(',')) {
          final parts = locStr.split(',');
          lat = double.tryParse(parts[0].trim()) ?? 0;
          lng = double.tryParse(parts[1].trim()) ?? 0;
        }

        final warehouse = LogisticsWarehouse(
          id: '',
          name: warehouseName,
          address: '$street, $city, $state, $zip, $country'.replaceAll(
            RegExp(r'^, |, , '),
            '',
          ),
          vendorId: post.vendorId,
          location: ShipmentLocation(
            latitude: lat,
            longitude: lng,
            address: locStr.isNotEmpty ? locStr : '$street, $city',
            country: country,
            state: state,
            city: city,
            street: street,
            zip: zip,
          ),
        );

        final whRef = _firestore.collection('warehouses').doc();
        await whRef.set(warehouse.copyWith(id: whRef.id).toJson());

        print('Auto-created warehouse ${whRef.id} from post ${docRef.id}');
      } catch (e) {
        print('Error auto-creating warehouse from post: $e');
      }
    }
  }

  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }

  Future<void> updatePost(VendorPost post) async {
    // Exclude id from update data/set to reference doc
    await _firestore
        .collection('posts')
        .doc(post.id)
        .update(post.toJson()..remove('id'));
  }

  Future<void> updatePostVisibility(
    String postId,
    PostVisibility visibility,
  ) async {
    if (postId.startsWith('mock_')) return; // Ignore mock posts
    String visibilityStr;
    switch (visibility) {
      case PostVisibility.public:
        visibilityStr = 'public';
        break;
      case PostVisibility.connections:
        visibilityStr = 'connections';
        break;
      case PostVisibility.private:
        visibilityStr = 'private';
        break;
    }
    await _firestore.collection('posts').doc(postId).update({
      'visibility': visibilityStr,
    });
  }

  Future<void> likePost(String postId, String userId) async {
    if (postId.startsWith('mock_')) return; // Ignore mock posts
    await _firestore.collection('posts').doc(postId).update({
      'likeIds': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> unlikePost(String postId, String userId) async {
    if (postId.startsWith('mock_')) return; // Ignore mock posts
    await _firestore.collection('posts').doc(postId).update({
      'likeIds': FieldValue.arrayRemove([userId]),
    });
  }

  Future<void> viewPost(String postId, String userId) async {
    if (postId.startsWith('mock_')) return; // Ignore mock posts
    await _firestore.collection('posts').doc(postId).update({
      'viewIds': FieldValue.arrayUnion([userId]),
    });
  }

  // --- Comments ---
  Future<void> addComment(PostComment comment) async {
    if (comment.postId.startsWith('mock_')) return; // Ignore mock posts
    final batch = _firestore.batch();
    final commentRef = _firestore
        .collection('posts')
        .doc(comment.postId)
        .collection('comments')
        .doc();

    batch.set(commentRef, comment.copyWith(id: commentRef.id).toJson());

    // Increment post comment count
    batch.update(_firestore.collection('posts').doc(comment.postId), {
      'commentCount': FieldValue.increment(1),
    });

    // If it's a reply, increment parent comment's reply count
    if (comment.parentId != null) {
      batch.update(
        _firestore
            .collection('posts')
            .doc(comment.postId)
            .collection('comments')
            .doc(comment.parentId),
        {'replyCount': FieldValue.increment(1)},
      );
    }

    await batch.commit();
  }

  Future<void> likeComment(
    String postId,
    String commentId,
    String userId,
  ) async {
    if (postId.startsWith('mock_')) return;
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({
          'likeIds': FieldValue.arrayUnion([userId]),
        });
  }

  Future<void> unlikeComment(
    String postId,
    String commentId,
    String userId,
  ) async {
    if (postId.startsWith('mock_')) return;
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({
          'likeIds': FieldValue.arrayRemove([userId]),
        });
  }

  Stream<List<PostComment>> watchComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PostComment.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // --- Following ---
  Future<void> followUser(String currentUserId, String targetUserId) async {
    await _firestore.collection('follows').doc(currentUserId).set({
      'following': FieldValue.arrayUnion([targetUserId]),
    }, SetOptions(merge: true));

    await _firestore.collection('follows').doc(targetUserId).set({
      'followers': FieldValue.arrayUnion([currentUserId]),
    }, SetOptions(merge: true));
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    await _firestore.collection('follows').doc(currentUserId).update({
      'following': FieldValue.arrayRemove([targetUserId]),
    });

    await _firestore.collection('follows').doc(targetUserId).update({
      'followers': FieldValue.arrayRemove([currentUserId]),
    });
  }

  Stream<List<String>> watchFollowingIds(String userId) {
    return _firestore.collection('follows').doc(userId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) return [];
      final data = snapshot.data();
      return List<String>.from(data?['following'] ?? []);
    });
  }

  Stream<int> watchFollowerCount(String userId) {
    return _firestore.collection('follows').doc(userId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) return 0;
      final data = snapshot.data();
      return (data?['followers'] as List?)?.length ?? 0;
    });
  }

  Stream<DocumentSnapshot> watchFollowings(String userId) {
    return _firestore.collection('follows').doc(userId).snapshots();
  }

  // --- Messaging ---
  Stream<List<ChatRoom>> watchChatRooms(String userId) {
    return _firestore
        .collection('chats')
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatRoom.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  Future<ChatRoom> getOrCreateChatRoom(
    String userId1,
    String userId2, {
    Map<String, dynamic>? userDetails1,
    Map<String, dynamic>? userDetails2,
  }) async {
    final ids = [userId1, userId2]..sort();
    final roomId = ids.join('_');

    final doc = await _firestore.collection('chats').doc(roomId).get();
    if (doc.exists) {
      return ChatRoom.fromJson({...doc.data()!, 'id': doc.id});
    }

    final newRoom = ChatRoom(
      id: roomId,
      participantIds: ids,
      participantDetails: {
        userId1: userDetails1 ?? {},
        userId2: userDetails2 ?? {},
      },
      lastMessageAt: DateTime.now(),
    );

    await _firestore.collection('chats').doc(roomId).set(newRoom.toJson());
    return newRoom;
  }

  Future<void> sendMessage(String roomId, Message message) async {
    final batch = _firestore.batch();

    final msgRef = _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .doc();
    batch.set(msgRef, message.copyWith(id: msgRef.id).toJson());

    batch.update(_firestore.collection('chats').doc(roomId), {
      'lastMessage': message.content,
      'lastMessageAt': message.createdAt,
    });

    await batch.commit();
  }

  Stream<List<Message>> watchMessages(String roomId) {
    return _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // --- Statuses ---
  Stream<List<StatusModel>> watchActiveStatuses() {
    return _firestore
        .collection('statuses')
        .where('expiresAt', isGreaterThan: DateTime.now())
        .orderBy('expiresAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => StatusModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  Future<void> createStatus(StatusModel status) async {
    await _firestore.collection('statuses').add(status.toJson()..remove('id'));
  }

  Future<void> likeStatus(String statusId, String userId) async {
    await _firestore.collection('statuses').doc(statusId).update({
      'likeIds': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> unlikeStatus(String statusId, String userId) async {
    await _firestore.collection('statuses').doc(statusId).update({
      'likeIds': FieldValue.arrayRemove([userId]),
    });
  }

  Future<void> shareStatus(String statusId) async {
    await _firestore.collection('statuses').doc(statusId).update({
      'shareCount': FieldValue.increment(1),
    });
  }

  Future<void> addStatusComment(String statusId, PostComment comment) async {
    final batch = _firestore.batch();
    final commentRef = _firestore
        .collection('statuses')
        .doc(statusId)
        .collection('comments')
        .doc();
    batch.set(commentRef, comment.copyWith(id: commentRef.id).toJson());
    batch.update(_firestore.collection('statuses').doc(statusId), {
      'commentCount': FieldValue.increment(1),
    });
    await batch.commit();
  }

  // --- Moderation & User Actions ---
  Future<void> reportPost(String postId, String userId, String reason) async {
    if (postId.startsWith('mock_')) return;
    await _firestore.collection('reports').add({
      'targetId': postId,
      'targetType': 'post',
      'reporterId': userId,
      'reason': reason,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
  }

  Future<void> hidePost(String postId, String userId) async {
    if (postId.startsWith('mock_')) return;
    // Store in a user-specific subcollection or a separate 'hidden_content' collection
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('hidden_posts')
        .doc(postId)
        .set({'hiddenAt': FieldValue.serverTimestamp()});
  }
}
