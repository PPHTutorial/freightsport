import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';

final followersProvider = FutureProvider.family
    .autoDispose<List<UserModel>, String>((ref, userId) {
      return ref.read(authRepositoryProvider).getFollowers(userId);
    });

class FollowersListScreen extends ConsumerWidget {
  final String userId;
  const FollowersListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followersAsync = ref.watch(followersProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: followersAsync.when(
        data: (followers) {
          if (followers.isEmpty) {
            return const Center(child: Text('No followers yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: followers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = followers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.photoUrl != null
                      ? CachedNetworkImageProvider(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? Text(user.name[0].toUpperCase())
                      : null,
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(userRoleToString(user.role)),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  String userRoleToString(UserRole role) {
    return role.name[0].toUpperCase() + role.name.substring(1);
  }
}
