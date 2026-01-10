import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';

class AuthActionGuard {
  static void protect(
    BuildContext context,
    WidgetRef ref, {
    required VoidCallback onAuthenticated,
  }) {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      onAuthenticated();
    } else {
      final location = GoRouterState.of(context).uri.toString();
      final encodedLocation = Uri.encodeComponent(location);
      context.push('/login?redirect=$encodedLocation');
    }
  }
}
