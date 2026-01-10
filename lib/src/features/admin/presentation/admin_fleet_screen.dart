import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';

import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';

final fleetProvider = FutureProvider.autoDispose<List<UserModel>>((ref) {
  return ref.read(authRepositoryProvider).getUsersByRole(UserRole.courier);
});

class AdminFleetScreen extends ConsumerWidget {
  const AdminFleetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fleetAsync = ref.watch(fleetProvider);

    return Scaffold(
      /* appBar: AppBar(
        title: const Text('Fleet Management'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ), */
      body: fleetAsync.when(
        data: (couriers) {
          if (couriers.isEmpty) {
            return const Center(child: Text('No couriers in the fleet yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: couriers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final courier = couriers[index];
              return _CourierCard(courier: courier);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Logic to invite/add courier
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Courier invitation flow...')),
          );
        },
        label: const Text('Add Courier'),
        icon: const Icon(Icons.person_add),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }
}

class _CourierCard extends StatelessWidget {
  final UserModel courier;
  const _CourierCard({required this.courier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: courier.photoUrl != null
                ? CachedNetworkImageProvider(courier.photoUrl!)
                : null,
            child: courier.photoUrl == null
                ? Text(
                    courier.name[0].toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courier.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  courier.phoneNumber ?? 'No Phone',
                  style: const TextStyle(
                    color: AppTheme.textGrey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    courier.verificationStatus.name.toUpperCase(),
                    style: const TextStyle(
                      color: AppTheme.successGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Management options
            },
          ),
        ],
      ),
    );
  }
}
