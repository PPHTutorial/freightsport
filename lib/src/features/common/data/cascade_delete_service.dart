import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CascadeDeleteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Delete all data from Firestore, Auth, and Storage except protected user IDs
  Future<void> deleteAllDataExcept(List<String> protectedUserIds) async {
    print(
      '🗑️ Starting CASCADE DELETE (Protected: ${protectedUserIds.length} users)',
    );

    // 1. Delete Firestore Collections
    await _deleteCollection('reviews');
    await _deleteCollection('posts');
    await _deleteCollection('statuses');
    await _deleteCollection('chats');
    await _deleteCollection('shipments');
    await _deleteCollection('warehouses');
    await _deleteCollection('courier_assignments');
    await _deleteCollection('notifications');

    // 2. Delete users collection (except protected)
    final deletedIds = await _deleteUsersExcept(protectedUserIds);

    // 3. Delete Auth users (except protected) via Cloud Function
    await _deleteAuthUsersExcept(deletedIds);

    // 4. Clean up Storage
    await _deleteAllStorage(protectedUserIds);

    print('✅ CASCADE DELETE Complete!');
  }

  /// Delete specific users and all their related data
  Future<void> deleteSelectedUsers(
    List<String> userIds, {
    Function(String)? onProgress,
  }) async {
    print('🗑️ Deleting ${userIds.length} users with CASCADE...');

    for (var i = 0; i < userIds.length; i++) {
      final userId = userIds[i];
      onProgress?.call('Deleting user ${i + 1}/${userIds.length}: $userId');

      await deleteUser(userId);
    }

    print('✅ Deleted ${userIds.length} users');
  }

  /// Delete a single user and all related data
  Future<void> deleteUser(String userId) async {
    // 1. Delete from all collections where user is referenced
    await _deleteUserReviews(userId);
    await _deleteUserPosts(userId);
    await _deleteUserStatuses(userId);
    await _deleteUserChats(userId);
    await _deleteUserShipments(userId);
    await _deleteUserWarehouses(userId);
    await _deleteUserNotifications(userId);

    // 2. Delete user document
    await _firestore.collection('users').doc(userId).delete();

    // 3. Delete from Auth via Cloud Function
    try {
      final currentUser = _auth.currentUser;
      if (currentUser?.uid == userId) {
        await currentUser?.delete();
        print('✅ Deleted current user from Auth (local)');
      } else {
        // Call cloud function
        await _functions.httpsCallable('deleteUser').call({'userId': userId});
        print('✅ Deleted user $userId from Auth (via Cloud Function)');
      }
    } catch (e) {
      print('⚠️ Auth deletion failed for $userId: $e');
      print(
        'ℹ️ Ensure "deleteUser" Cloud Function is deployed: firebase deploy --only functions',
      );
    }

    // 4. Delete Storage files
    await deleteUserStorage(userId);
  }

  /// Delete all storage files for a specific user
  Future<void> deleteUserStorage(String userId) async {
    try {
      final ref = _storage.ref('users/$userId');
      final listResult = await ref.listAll();

      for (var item in listResult.items) {
        await item.delete();
      }

      for (var prefix in listResult.prefixes) {
        await _deleteStorageFolder(prefix);
      }

      print('✅ Deleted storage for user: $userId');
    } catch (e) {
      if (e.toString().contains('object-not-found')) return;
      print('⚠️ Storage deletion failed for $userId: $e');
    }
  }

  // Private helper methods

  Future<void> _deleteCollection(String collectionName) async {
    print('  Deleting collection: $collectionName');
    final snapshot = await _firestore.collection(collectionName).get();

    // Batch delete
    const batchSize = 400;
    var batch = _firestore.batch();
    var count = 0;

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
      count++;
      if (count >= batchSize) {
        await batch.commit();
        batch = _firestore.batch();
        count = 0;
      }
    }
    if (count > 0) await batch.commit();

    print('  ✅ Deleted ${snapshot.docs.length} documents from $collectionName');
  }

  Future<List<String>> _deleteUsersExcept(List<String> protectedUserIds) async {
    print('  Deleting users (except protected)...');
    final snapshot = await _firestore.collection('users').get();
    final deletedIds = <String>[];

    // Batch delete
    const batchSize = 400;
    var batch = _firestore.batch();
    var count = 0;

    for (var doc in snapshot.docs) {
      if (!protectedUserIds.contains(doc.id)) {
        batch.delete(doc.reference);
        deletedIds.add(doc.id);
        count++;
        if (count >= batchSize) {
          await batch.commit();
          batch = _firestore.batch();
          count = 0;
        }
      }
    }
    if (count > 0) await batch.commit();

    print(
      '  ✅ Deleted ${deletedIds.length} users (Protected: ${protectedUserIds.length})',
    );
    return deletedIds;
  }

  Future<void> _deleteAuthUsersExcept(List<String> userIdsToDelete) async {
    print(
      '  Attempting to delete ${userIdsToDelete.length} users from Auth...',
    );
    if (userIdsToDelete.isEmpty) return;

    try {
      // Chunk into 1000s for batchDeleteUsers (max 1000)
      for (var i = 0; i < userIdsToDelete.length; i += 1000) {
        final end = (i + 1000 < userIdsToDelete.length)
            ? i + 1000
            : userIdsToDelete.length;
        final batch = userIdsToDelete.sublist(i, end);

        await _functions.httpsCallable('batchDeleteUsers').call({
          'userIds': batch,
        });
        print('    ✅ Batch delete success (${batch.length} users)');
      }
    } catch (e) {
      print('  ⚠️ Auth batch deletion failed: $e');
      print('  ℹ️ Ensure "batchDeleteUsers" Cloud Function is deployed.');
    }
  }

  Future<void> _deleteUserReviews(String userId) async {
    // Delete reviews BY user
    final reviewsByUser = await _firestore
        .collection('reviews')
        .where('reviewerId', isEqualTo: userId)
        .get();
    for (var doc in reviewsByUser.docs) {
      await doc.reference.delete();
    }

    // Delete reviews FOR user
    final reviewsForUser = await _firestore
        .collection('reviews')
        .where('revieweeId', isEqualTo: userId)
        .get();
    for (var doc in reviewsForUser.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> _deleteUserPosts(String userId) async {
    final posts = await _firestore
        .collection('posts')
        .where('vendorId', isEqualTo: userId)
        .get();

    for (var doc in posts.docs) {
      // Delete comments subcollection
      final comments = await doc.reference.collection('comments').get();
      for (var comment in comments.docs) {
        await comment.reference.delete();
      }

      await doc.reference.delete();
    }
  }

  Future<void> _deleteUserStatuses(String userId) async {
    final statuses = await _firestore
        .collection('statuses')
        .where('vendorId', isEqualTo: userId)
        .get();

    for (var doc in statuses.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> _deleteUserChats(String userId) async {
    final chats = await _firestore
        .collection('chats')
        .where('participantIds', arrayContains: userId)
        .get();

    for (var doc in chats.docs) {
      // Delete messages subcollection
      final messages = await doc.reference.collection('messages').get();
      for (var message in messages.docs) {
        await message.reference.delete();
      }

      await doc.reference.delete();
    }
  }

  Future<void> _deleteUserShipments(String userId) async {
    // Delete as sender
    final asSender = await _firestore
        .collection('shipments')
        .where('senderId', isEqualTo: userId)
        .get();
    for (var doc in asSender.docs) {
      await doc.reference.delete();
    }

    // Delete as recipient
    final asRecipient = await _firestore
        .collection('shipments')
        .where('recipientId', isEqualTo: userId)
        .get();
    for (var doc in asRecipient.docs) {
      await doc.reference.delete();
    }

    // Delete as vendor
    final asVendor = await _firestore
        .collection('shipments')
        .where('vendorId', isEqualTo: userId)
        .get();
    for (var doc in asVendor.docs) {
      await doc.reference.delete();
    }

    // Delete courier assignments
    final assignments = await _firestore
        .collection('courier_assignments')
        .where('courierId', isEqualTo: userId)
        .get();
    for (var doc in assignments.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> _deleteUserWarehouses(String userId) async {
    final warehouses = await _firestore
        .collection('warehouses')
        .where('vendorId', isEqualTo: userId)
        .get();

    for (var doc in warehouses.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> _deleteUserNotifications(String userId) async {
    final notifications = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in notifications.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> _deleteStorageFolder(Reference folderRef) async {
    final listResult = await folderRef.listAll();

    for (var item in listResult.items) {
      await item.delete();
    }

    for (var prefix in listResult.prefixes) {
      await _deleteStorageFolder(prefix);
    }
  }

  Future<void> _deleteAllStorage(List<String> protectedUserIds) async {
    print('  Cleaning up Storage...');
    try {
      final usersRef = _storage.ref('users');
      final listResult = await usersRef.listAll();

      for (var prefix in listResult.prefixes) {
        final userId = prefix.name;
        if (!protectedUserIds.contains(userId)) {
          await _deleteStorageFolder(prefix);
        }
      }
    } catch (e) {
      print('  ⚠️ Storage cleanup error: $e');
    }
  }
}
