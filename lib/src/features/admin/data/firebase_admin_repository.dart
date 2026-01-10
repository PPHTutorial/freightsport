import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rightlogistics/src/features/admin/data/admin_repository.dart';
import 'package:rightlogistics/src/features/admin/domain/admin_models.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';

class FirebaseAdminRepository implements AdminRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseAdminRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  // ========== User Management ==========

  @override
  Stream<List<UserModel>> watchAllUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }

  @override
  Future<void> createUser(UserModel user, String password) async {
    // Create auth account
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );

    // Create Firestore document with the auth UID
    final userWithId = user.copyWith(id: userCredential.user!.uid);
    await _firestore
        .collection('users')
        .doc(userWithId.id)
        .set(userWithId.toJson());

    await _logAction(
      action: 'CREATE_USER',
      targetId: userWithId.id,
      targetType: 'users',
      metadata: {'role': user.role.name},
      note: 'Created user ${user.email}',
    );
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update(user.toJson());

    await _logAction(
      action: 'UPDATE_USER',
      targetId: user.id,
      targetType: 'users',
      note: 'Updated user profile',
    );
  }

  @override
  Future<void> deleteUser(String userId) async {
    // Delete Firestore document
    await _firestore.collection('users').doc(userId).delete();

    // TODO: Delete auth account requires admin SDK or Cloud Functions
    // For now, just delete the Firestore document
    await _logAction(
      action: 'DELETE_USER',
      targetId: userId,
      targetType: 'users',
      note: 'Deleted user account',
    );
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    final snapshot = await _firestore.collection('users').get();
    final allUsers = snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .toList();

    return allUsers.where((user) {
      final searchLower = query.toLowerCase();
      return user.name.toLowerCase().contains(searchLower) ||
          user.email.toLowerCase().contains(searchLower) ||
          (user.phoneNumber?.toLowerCase().contains(searchLower) ?? false);
    }).toList();
  }

  @override
  Future<List<UserModel>> getUsersByRole(UserRole role) async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: role.name)
        .get();
    return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }

  // ========== Vendor Quotations ==========

  @override
  Stream<List<VendorQuotation>> watchQuotations({String? vendorId}) {
    Query query = _firestore.collection('quotations');
    if (vendorId != null) {
      query = query.where('vendorId', isEqualTo: vendorId);
    }
    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                VendorQuotation.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  @override
  Future<List<VendorQuotation>> getActiveQuotations({String? vendorId}) async {
    Query query = _firestore
        .collection('quotations')
        .where('isActive', isEqualTo: true)
        .where('validUntil', isGreaterThan: Timestamp.now());

    if (vendorId != null) {
      query = query.where('vendorId', isEqualTo: vendorId);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map(
          (doc) => VendorQuotation.fromJson(doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<VendorQuotation?> getQuotationById(String quotationId) async {
    final doc = await _firestore
        .collection('quotations')
        .doc(quotationId)
        .get();
    if (!doc.exists) return null;
    return VendorQuotation.fromJson(doc.data()!);
  }

  @override
  Future<void> createQuotation(VendorQuotation quotation) async {
    await _firestore
        .collection('quotations')
        .doc(quotation.id)
        .set(quotation.toJson());

    await _logAction(
      action: 'CREATE_QUOTATION',
      targetId: quotation.id,
      targetType: 'quotations',
      metadata: {'vendorId': quotation.vendorId},
    );
  }

  @override
  Future<void> updateQuotation(VendorQuotation quotation) async {
    await _firestore
        .collection('quotations')
        .doc(quotation.id)
        .update(quotation.toJson());
  }

  @override
  Future<void> deleteQuotation(String quotationId) async {
    await _firestore.collection('quotations').doc(quotationId).delete();
  }

  @override
  Future<void> toggleQuotationStatus(String quotationId, bool isActive) async {
    await _firestore.collection('quotations').doc(quotationId).update({
      'isActive': isActive,
      'updatedAt': Timestamp.now(),
    });
  }

  // ========== Broadcast Messages ==========

  @override
  Stream<List<BroadcastMessage>> watchBroadcasts() {
    return _firestore
        .collection('broadcasts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BroadcastMessage.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<List<BroadcastMessage>> getAllBroadcasts() async {
    final snapshot = await _firestore.collection('broadcasts').get();
    return snapshot.docs
        .map((doc) => BroadcastMessage.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<BroadcastMessage?> getBroadcastById(String broadcastId) async {
    final doc = await _firestore
        .collection('broadcasts')
        .doc(broadcastId)
        .get();
    if (!doc.exists) return null;
    return BroadcastMessage.fromJson(doc.data()!);
  }

  @override
  Future<void> createBroadcast(BroadcastMessage broadcast) async {
    await _firestore
        .collection('broadcasts')
        .doc(broadcast.id)
        .set(broadcast.toJson());

    await _logAction(
      action: 'CREATE_BROADCAST',
      targetId: broadcast.id,
      targetType: 'broadcasts',
      note: 'Title: ${broadcast.title}',
    );
  }

  @override
  Future<void> updateBroadcast(BroadcastMessage broadcast) async {
    await _firestore
        .collection('broadcasts')
        .doc(broadcast.id)
        .update(broadcast.toJson());
  }

  @override
  Future<void> deleteBroadcast(String broadcastId) async {
    await _firestore.collection('broadcasts').doc(broadcastId).delete();
  }

  @override
  Future<void> sendBroadcast(String broadcastId) async {
    await _firestore.collection('broadcasts').doc(broadcastId).update({
      'status': BroadcastStatus.sent.name,
      'sentAt': Timestamp.now(),
    });
  }

  @override
  Future<void> markBroadcastAsRead(String broadcastId, String userId) async {
    await _firestore.collection('broadcasts').doc(broadcastId).update({
      'readByIds': FieldValue.arrayUnion([userId]),
    });
  }

  // ========== Social Posts Management ==========

  @override
  Stream<List<VendorPost>> watchAllPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => VendorPost.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<List<VendorPost>> getAllPosts({
    PostType? type,
    String? vendorId,
  }) async {
    Query query = _firestore.collection('posts');

    if (type != null) {
      final typeMap = {
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
      query = query.where('type', isEqualTo: typeMap[type]);
    }
    if (vendorId != null) {
      query = query.where('vendorId', isEqualTo: vendorId);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => VendorPost.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> createPost(VendorPost post) async {
    await _firestore.collection('posts').doc(post.id).set(post.toJson());
  }

  @override
  Future<void> updatePost(VendorPost post) async {
    await _firestore.collection('posts').doc(post.id).update(post.toJson());
  }

  @override
  Future<void> deletePost(String postId) async {
    // Delete post
    await _firestore.collection('posts').doc(postId).delete();

    // Delete associated comments
    final commentsSnapshot = await _firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .get();

    final batch = _firestore.batch();
    for (var doc in commentsSnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  @override
  Future<List<VendorPost>> searchPosts(String query) async {
    final snapshot = await _firestore.collection('posts').get();
    final allPosts = snapshot.docs
        .map((doc) => VendorPost.fromJson(doc.data()))
        .toList();

    return allPosts.where((post) {
      final searchLower = query.toLowerCase();
      return post.description.toLowerCase().contains(searchLower) ||
          (post.title?.toLowerCase().contains(searchLower) ?? false) ||
          post.vendorName.toLowerCase().contains(searchLower);
    }).toList();
  }

  // ========== Comments Moderation ==========

  @override
  Stream<List<PostComment>> watchAllComments({String? postId}) {
    Query query = _firestore.collection('comments');
    if (postId != null) {
      query = query.where('postId', isEqualTo: postId);
    }
    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) => PostComment.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  @override
  Future<List<PostComment>> getCommentsByPost(String postId) async {
    final snapshot = await _firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .get();
    return snapshot.docs
        .map((doc) => PostComment.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> deleteComment(String commentId) async {
    await _firestore.collection('comments').doc(commentId).delete();
  }

  @override
  Future<List<PostComment>> searchComments(String query) async {
    final snapshot = await _firestore.collection('comments').get();
    final allComments = snapshot.docs
        .map((doc) => PostComment.fromJson(doc.data()))
        .toList();

    return allComments.where((comment) {
      final searchLower = query.toLowerCase();
      return comment.content.toLowerCase().contains(searchLower) ||
          comment.userName.toLowerCase().contains(searchLower);
    }).toList();
  }

  // ========== Warehouses Management ==========

  @override
  Stream<List<LogisticsWarehouse>> watchWarehouses({String? vendorId}) {
    Query query = _firestore.collection('warehouses');
    if (vendorId != null) {
      query = query.where('vendorId', isEqualTo: vendorId);
    }
    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                LogisticsWarehouse.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  @override
  Future<List<LogisticsWarehouse>> getAllWarehouses() async {
    final snapshot = await _firestore.collection('warehouses').get();
    return snapshot.docs
        .map((doc) => LogisticsWarehouse.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<LogisticsWarehouse?> getWarehouseById(String warehouseId) async {
    final doc = await _firestore
        .collection('warehouses')
        .doc(warehouseId)
        .get();
    if (!doc.exists) return null;
    return LogisticsWarehouse.fromJson(doc.data()!);
  }

  @override
  Future<void> createWarehouse(LogisticsWarehouse warehouse) async {
    await _firestore
        .collection('warehouses')
        .doc(warehouse.id)
        .set(warehouse.toJson());

    await _logAction(
      action: 'CREATE_WAREHOUSE',
      targetId: warehouse.id,
      targetType: 'warehouses',
      metadata: {'vendorId': warehouse.vendorId},
    );
  }

  @override
  Future<void> updateWarehouse(LogisticsWarehouse warehouse) async {
    await _firestore
        .collection('warehouses')
        .doc(warehouse.id)
        .update(warehouse.toJson());
  }

  @override
  Future<void> deleteWarehouse(String warehouseId) async {
    await _firestore.collection('warehouses').doc(warehouseId).delete();
  }

  // ========== Courier Assignments Management ==========

  @override
  Stream<List<CourierAssignment>> watchAssignments({String? courierId}) {
    Query query = _firestore.collection('courier_assignments');
    if (courierId != null) {
      query = query.where('courierId', isEqualTo: courierId);
    }
    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                CourierAssignment.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  @override
  Future<List<CourierAssignment>> getAllAssignments() async {
    final snapshot = await _firestore.collection('courier_assignments').get();
    return snapshot.docs
        .map((doc) => CourierAssignment.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> createAssignment(CourierAssignment assignment) async {
    await _firestore
        .collection('courier_assignments')
        .doc(assignment.id)
        .set(assignment.toJson());

    await _logAction(
      action: 'ASSIGN_COURIER',
      targetId: assignment.id,
      targetType: 'courier_assignments',
      metadata: {
        'shipmentId': assignment.shipmentId,
        'courierId': assignment.courierId,
      },
    );
  }

  @override
  Future<void> updateAssignment(CourierAssignment assignment) async {
    await _firestore
        .collection('courier_assignments')
        .doc(assignment.id)
        .update(assignment.toJson());
  }

  @override
  Future<void> deleteAssignment(String assignmentId) async {
    await _firestore
        .collection('courier_assignments')
        .doc(assignmentId)
        .delete();
  }

  @override
  Future<void> reassignCourier(String assignmentId, String newCourierId) async {
    // Get new courier info
    final courierDoc = await _firestore
        .collection('users')
        .doc(newCourierId)
        .get();
    final courier = UserModel.fromJson(courierDoc.data()!);

    await _firestore.collection('courier_assignments').doc(assignmentId).update(
      {'courierId': newCourierId, 'courierName': courier.name},
    );
  }

  // ========== Shipments Management (Extended) ==========

  @override
  Stream<List<Shipment>> watchAllShipments() {
    return _firestore
        .collection('shipments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Shipment.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<List<Shipment>> searchShipments(String query) async {
    final snapshot = await _firestore.collection('shipments').get();
    final allShipments = snapshot.docs
        .map((doc) => Shipment.fromJson(doc.data()))
        .toList();

    return allShipments.where((shipment) {
      final searchLower = query.toLowerCase();
      return shipment.trackingNumber.toLowerCase().contains(searchLower) ||
          shipment.senderName.toLowerCase().contains(searchLower) ||
          shipment.recipientName.toLowerCase().contains(searchLower);
    }).toList();
  }

  @override
  Future<void> updateShipmentStatus(
    String shipmentId,
    ShipmentStatusType status,
    String note,
  ) async {
    final shipmentDoc = await _firestore
        .collection('shipments')
        .doc(shipmentId)
        .get();
    final shipment = Shipment.fromJson(shipmentDoc.data()!);

    // Create new event
    final newEvent = ShipmentEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      status: status,
      timestamp: DateTime.now(),
      location: shipment.events.last.location, // Use last known location
      note: note,
      updatedByUserId: _auth.currentUser?.uid,
    );

    final updatedEvents = [...shipment.events, newEvent];

    // Determine the JSON value for the status manually to match @JsonValue
    final statusMap = {
      ShipmentStatusType.created: 'created',
      ShipmentStatusType.pickedUp: 'picked_up',
      ShipmentStatusType.inTransit: 'in_transit',
      ShipmentStatusType.outForDelivery: 'out_for_delivery',
      ShipmentStatusType.delivered: 'delivered',
      ShipmentStatusType.failedAttempt: 'failed_attempt',
      ShipmentStatusType.cancelled: 'cancelled',
    };

    await _firestore.collection('shipments').doc(shipmentId).update({
      'currentStatus': statusMap[status],
      'events': updatedEvents.map((e) => e.toJson()).toList(),
    });
  }

  // ========== Audit & Analytics ==========

  @override
  Future<Map<String, dynamic>> getDashboardStats() async {
    final usersCount =
        (await _firestore.collection('users').count().get()).count;
    final postsCount =
        (await _firestore.collection('posts').count().get()).count;
    final shipmentsCount =
        (await _firestore.collection('shipments').count().get()).count;
    final warehousesCount =
        (await _firestore.collection('warehouses').count().get()).count;

    return {
      'totalUsers': usersCount,
      'totalPosts': postsCount,
      'totalShipments': shipmentsCount,
      'totalWarehouses': warehousesCount,
    };
  }

  @override
  Future<Map<ShipmentStatusType, int>> getShipmentStatusStats() async {
    final Map<ShipmentStatusType, int> stats = {};

    final statusMap = {
      ShipmentStatusType.created: 'created',
      ShipmentStatusType.pickedUp: 'picked_up',
      ShipmentStatusType.inTransit: 'in_transit',
      ShipmentStatusType.outForDelivery: 'out_for_delivery',
      ShipmentStatusType.delivered: 'delivered',
      ShipmentStatusType.failedAttempt: 'failed_attempt',
      ShipmentStatusType.cancelled: 'cancelled',
    };

    // Run parallel count queries for each status
    await Future.wait(
      ShipmentStatusType.values.map((status) async {
        final count = await _firestore
            .collection('shipments')
            .where('currentStatus', isEqualTo: statusMap[status])
            .count()
            .get();
        stats[status] = count.count ?? 0;
      }),
    );

    return stats;
  }

  @override
  Future<List<Map<String, dynamic>>> getDailyRevenueStats(int days) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));

    // Fetch shipments from the last N days
    final snapshot = await _firestore
        .collection('shipments')
        .where('createdAt', isGreaterThan: startDate)
        .get();

    // Group by date and sum price
    final Map<String, double> dailyMap = {};

    // Initialize map with 0s
    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final key =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      dailyMap[key] = 0.0;
    }

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final createdAt = (data['createdAt'] as Timestamp).toDate();
      final price = (data['totalPrice'] as num?)?.toDouble() ?? 0.0;

      final key =
          "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}";
      if (dailyMap.containsKey(key)) {
        dailyMap[key] = (dailyMap[key] ?? 0) + price;
      }
    }

    // Convert to list sorted by date
    final sortedKeys = dailyMap.keys.toList()..sort();
    return sortedKeys
        .map((key) => {'date': key, 'amount': dailyMap[key]})
        .toList();
  }

  @override
  Future<List<AuditLog>> getAuditLogs({
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    int limit = 50,
  }) async {
    Query query = _firestore
        .collection('audit_logs')
        .orderBy('timestamp', descending: true);

    if (startDate != null) {
      query = query.where('timestamp', isGreaterThanOrEqualTo: startDate);
    }
    if (endDate != null) {
      query = query.where('timestamp', isLessThanOrEqualTo: endDate);
    }
    if (userId != null) {
      query = query.where('performedByUserId', isEqualTo: userId);
    }

    final snapshot = await query.limit(limit).get();
    return snapshot.docs
        .map((doc) => AuditLog.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> createAuditLog(AuditLog log) async {
    await _firestore.collection('audit_logs').doc(log.id).set(log.toJson());
  }

  /// Helper to log actions internally
  Future<void> _logAction({
    required String action,
    required String targetId,
    required String targetType,
    Map<String, dynamic>? metadata,
    String? note,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Get user name (optimistic, or generic)
    String userName = user.displayName ?? 'Unknown Admin';
    // Ideally we would fetch the user profile if displayName is missing,
    // but for performance we might skip or rely on auth profile.

    final log = AuditLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      action: action,
      targetId: targetId,
      targetType: targetType,
      performedByUserId: user.uid,
      performedByUserName: userName,
      timestamp: DateTime.now(),
      metadata: metadata,
      note: note,
    );

    try {
      await createAuditLog(log);
    } catch (e) {
      // Silently fail logging to not disrupt main flow, but ideally print error
      debugPrint('Failed to create audit log: $e');
    }
  }
}
