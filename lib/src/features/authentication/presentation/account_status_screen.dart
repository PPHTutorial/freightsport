import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';

class AccountStatusScreen extends ConsumerWidget {
  const AccountStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isTerminated = user.accountStatus == AccountStatus.terminated;
    final title = isTerminated ? 'Account Terminated' : 'Account Suspended';
    final message = isTerminated
        ? 'Your account has been permanently terminated due to a violation of our terms of service.'
        : 'Your account has been temporarily suspended. Please contact support for more information.';
    final icon = isTerminated ? Icons.block : Icons.pause_circle_outline;
    final color = isTerminated ? Colors.red : Colors.orange;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 80, color: color),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              if (!isTerminated) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to support or email
                    // For now, just a placeholder or could link to support email
                  },
                  icon: const Icon(Icons.mail_outline),
                  label: const Text('Contact Support'),
                ),
                const SizedBox(height: 16),
              ],
              TextButton(
                onPressed: () {
                  ref.read(authRepositoryProvider).signOut();
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
