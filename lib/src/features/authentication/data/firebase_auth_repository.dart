import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository(this._firebaseAuth, this._firestore);

  // Use the singleton instance
  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  @override
  UserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    // Note: This returns a basic user from Auth.
    // Use refreshUser() to get full Firestore data.
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'User',
      username: user.email != null
          ? user.email!.split('@')[0]
          : 'user', // Fallback
      role: UserRole.customer,
      verificationStatus: VerificationStatus.unverified,
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  @override
  Stream<UserModel?> getUserStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!..['id'] = userId);
      }
      return null;
    });
  }

  @override
  Future<UserModel?> refreshUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!..['id'] = user.uid);
      }
    } catch (e) {
      // Log or handle error
    }

    // Fallback to basic
    return currentUser;
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncExpand((user) {
      if (user == null) return Stream.value(null);

      // Listen to Firestore updates for real-time role/verification changes
      return _firestore.collection('users').doc(user.uid).snapshots().map((
        doc,
      ) {
        if (doc.exists && doc.data() != null) {
          return UserModel.fromJson(doc.data()!..['id'] = user.uid);
        }
        // Fallback if doc doesn't exist yet (creates race condition but safe default)
        return UserModel(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? 'User',
          username: user.email != null ? user.email!.split('@')[0] : 'user',
          role: UserRole.customer,
          verificationStatus: VerificationStatus.unverified,
        );
      });
    });
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return refreshUser();
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'name': name,
        'role': 'customer',
        'verificationStatus': 'unverified',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return refreshUser();
    }
    return null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    // Basic initialization for mobile/native
    await _googleSignIn.initialize();

    final googleUser = await _googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      // Ensure user document exists in Firestore
      final userDoc = _firestore.collection('users').doc(user.uid);
      final doc = await userDoc.get();

      if (!doc.exists) {
        await userDoc.set({
          'email': user.email ?? '',
          'name': user.displayName ?? 'User',
          'username': user.email != null
              ? user.email!.split('@')[0]
              : 'user_${user.uid.substring(0, 5)}',
          'role': 'customer', // Default role
          'verificationStatus': 'unverified',
          'photoUrl': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return refreshUser();
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> updateUser(UserModel user) async {
    // 1. Update Firestore
    await _firestore
        .collection('users')
        .doc(user.id)
        .set(user.toJson(), SetOptions(merge: true));

    // 2. Update Firebase Auth Profile (Dual Sync)
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      bool needsReload = false;
      if (user.name != currentUser.displayName) {
        await currentUser.updateDisplayName(user.name);
        needsReload = true;
      }
      if (user.photoUrl != null && user.photoUrl != currentUser.photoURL) {
        await currentUser.updatePhotoURL(user.photoUrl);
        needsReload = true;
      }
      if (needsReload) await currentUser.reload();
    }
  }

  @override
  Future<UserModel?> findUserByPhone(String phoneNumber) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return UserModel.fromJson(doc.data()..['id'] = doc.id);
      }
    } catch (e) {
      // Handle error or log
    }
    return null;
  }

  @override
  Future<List<UserModel>> getUsersByRole(UserRole role) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: role.name)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()..['id'] = doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<UserModel>> getFollowers(String userId) async {
    try {
      // Query users where 'followingIds' contains the target userId
      final snapshot = await _firestore
          .collection('users')
          .where('followingIds', arrayContains: userId)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()..['id'] = doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> isUsernameUnique(String username) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .count()
          .get();
      return (snapshot.count ?? 0) == 0;
    } catch (e) {
      debugPrint('Error checking username unique: $e');
      return false; // Fail safe
    }
  }

  @override
  Future<bool> isPhoneUnique(String phone) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phone)
          .count()
          .get();
      return (snapshot.count ?? 0) == 0;
    } catch (e) {
      debugPrint('Error checking phone unique: $e');
      return false;
    }
  }

  @override
  Future<void> blockUser(String userId, String blockedId) async {
    await _firestore.collection('users').doc(userId).update({
      'blockedUserIds': FieldValue.arrayUnion([blockedId]),
    });
  }

  @override
  Future<void> unblockUser(String userId, String blockedId) async {
    await _firestore.collection('users').doc(userId).update({
      'blockedUserIds': FieldValue.arrayRemove([blockedId]),
    });
  }

  @override
  Future<void> updateAccountStatus(String userId, AccountStatus status) async {
    await _firestore.collection('users').doc(userId).update({
      'accountStatus': status.name,
    });
  }
}
