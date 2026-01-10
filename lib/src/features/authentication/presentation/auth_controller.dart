import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<UserModel?> build() {
    return ref.watch(currentUserProvider);
  }

  Future<void> signIn(String email, String password) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.signInWithEmailAndPassword(email, password);
      state = AsyncData(user);
    } catch (e) {
      //state = AsyncError(e, st);
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.createUserWithEmailAndPassword(
        email,
        password,
        name,
      );
      state = AsyncData(user);
    } catch (e) {
      //state = AsyncError(e, st);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.sendPasswordResetEmail(email);
      state = AsyncData(state.value); // Maintain current user if any
    } catch (e) {
      //state = AsyncError(e, st);
    }
  }

  Future<void> signInWithGoogle() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.signInWithGoogle();
      state = AsyncData(user);
    } catch (e) {
      //state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.signOut();
      state = const AsyncData(null);
    } catch (e) {
      //state = AsyncError(e, st);
    }
  }
}
