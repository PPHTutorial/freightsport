import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel?> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  );
  Future<void> sendPasswordResetEmail(String email);
  Future<UserModel?> signInWithGoogle();
  Future<void> signOut();
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;
  Stream<UserModel?> getUserStream(String userId);
  Future<UserModel?> refreshUser();
  Future<void> updateUser(UserModel user);
  Future<UserModel?> findUserByPhone(String phoneNumber);
  Future<List<UserModel>> getUsersByRole(UserRole role);
  Future<List<UserModel>> getFollowers(String userId);

  // Validation Checks
  Future<bool> isUsernameUnique(String username);
  Future<bool> isPhoneUnique(String phone);

  // User Management
  Future<void> blockUser(String userId, String blockedId);
  Future<void> unblockUser(String userId, String blockedId);
  Future<void> updateAccountStatus(String userId, AccountStatus status);
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
});

final authStateChangesProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateChangesProvider).value;
});

final userProvider = StreamProvider.family<UserModel?, String>((ref, userId) {
  return ref.watch(authRepositoryProvider).getUserStream(userId);
});
