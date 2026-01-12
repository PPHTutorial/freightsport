import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/orders/domain/order_models.dart';

final orderRepositoryProvider = Provider((ref) {
  return OrderRepository(FirebaseFirestore.instance);
});

class OrderRepository {
  final FirebaseFirestore _firestore;

  OrderRepository(this._firestore);

  Future<void> createOrder(Order order) async {
    await _firestore.collection('orders').doc(order.id).set(order.toJson());
  }

  Future<void> recordTransaction(PaymentTransaction transaction) async {
    await _firestore
        .collection('transactions')
        .doc(transaction.id)
        .set(transaction.toJson());
  }

  Future<void> fulfillPreOrder({
    required String postId,
    required String userId,
    required int quantity,
  }) async {
    final postRef = _firestore.collection('vendor_posts').doc(postId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);
      if (!snapshot.exists) return;

      final currentCount = snapshot.data()?['currentOrderCount'] ?? 0;
      final newCount = currentCount + quantity;

      // Update order count atomically
      transaction.update(postRef, {'currentOrderCount': newCount});

      // Add user to pre-order list (using a subcollection for scalability)
      final preOrderListRef = postRef.collection('pre_orders').doc(userId);
      transaction.set(preOrderListRef, {
        'userId': userId,
        'quantity': quantity,
        'timestamp': FieldValue.serverTimestamp(),
      });
    });
  }

  Stream<List<Order>> watchUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('buyerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Order.fromJson(doc.data()..['id'] = doc.id))
              .toList(),
        );
  }

  Stream<List<Order>> watchVendorOrders(String vendorId) {
    return _firestore
        .collection('orders')
        .where('vendorId', isEqualTo: vendorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Order.fromJson(doc.data()..['id'] = doc.id))
              .toList(),
        );
  }
}
