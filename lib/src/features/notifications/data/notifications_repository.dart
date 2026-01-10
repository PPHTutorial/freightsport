import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/notifications/domain/notification_model.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rxdart/rxdart.dart';

final notificationRepositoryProvider = Provider((ref) {
  return FirestoreNotificationRepository(FirebaseFirestore.instance, ref);
});

final userNotificationsProvider = StreamProvider<List<NotificationModel>>((
  ref,
) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.watchNotifications(user);
});

class FirestoreNotificationRepository {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  FirestoreNotificationRepository(this._firestore, this._ref);

  Stream<List<NotificationModel>> watchNotifications(UserModel user) {
    // 1. Personal Notifications Stream
    final personalStream = _firestore
        .collection('users')
        .doc(user.id)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    NotificationModel.fromJson(doc.data()..['id'] = doc.id),
              )
              .toList(),
        );

    // 2. Broadcast Stream (For everyone)
    // Assuming 'broadcasts' collection has documents compatible with NotificationModel
    // or we map them manually.
    final broadcastStream = _firestore
        .collection('broadcasts')
        .orderBy('timestamp', descending: true)
        .limit(20) // Limit to recent broadcasts
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    NotificationModel.fromJson(doc.data()..['id'] = doc.id),
              )
              .toList(),
        );

    // 3. Admin Stream (System Alerts) - Only if Admin
    Stream<List<NotificationModel>> adminStream = Stream.value([]);
    if (user.role == UserRole.admin) {
      adminStream = _firestore
          .collection('admin_alerts')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) =>
                      NotificationModel.fromJson(doc.data()..['id'] = doc.id),
                )
                .toList(),
          );
    }

    // Merge Streams
    return Rx.combineLatest3(personalStream, broadcastStream, adminStream, (
      List<NotificationModel> personal,
      List<NotificationModel> broadcasts,
      List<NotificationModel> alerts,
    ) {
      final all = [...alerts, ...personal, ...broadcasts];
      // Sort explicitly again as merge might mix order
      all.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return all;
    });
  }

  Future<void> markAsRead(
    String notificationId, {
    bool isPersonal = true,
  }) async {
    final user = _ref.read(currentUserProvider);
    if (user == null) return;

    // Logic to mark read varies by collection.
    // For simplicity, we only mark Personal notifications as read in DB.
    // broadcasts might need a local 'seen' list or a subcollection 'read_receipts'.
    // Here we implement personal only for now.

    // We try to find where it is or just assume personal for this scope
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      // Ignore if not found (might be broadcast)
    }
  }

  Future<void> sendNotification(NotificationModel notification) async {
    if (notification.targetUserId == null) return;
    await _firestore
        .collection('users')
        .doc(notification.targetUserId)
        .collection('notifications')
        .add(notification.toJson()..remove('id'));
  }

  Future<void> broadcastPostNotification(
    String vendorName,
    String postDescription,
    PostType type,
  ) async {
    await _firestore.collection('broadcasts').add({
      'title': 'New ${type.name.replaceAll('_', ' ')} from $vendorName',
      'message': postDescription.length > 50
          ? '${postDescription.substring(0, 47)}...'
          : postDescription,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'shipment', // Reuse shipment type or add 'social'
      'senderId': 'system',
      'senderName': vendorName,
      'isRead': false,
    });
  }
}
