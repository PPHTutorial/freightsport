import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/presentation/widgets/glass_card.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/features/social/presentation/providers/social_providers.dart';
import 'package:rightlogistics/src/core/presentation/providers/nav_providers.dart';
import 'package:rightlogistics/src/features/reviews/presentation/widgets/rating_display_widget.dart';

class PublicProfileScreen extends ConsumerWidget {
  final String userId;
  final UserModel? user;

  const PublicProfileScreen({super.key, required this.userId, this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to real-time updates
    final userAsync = ref.watch(userProvider(userId));
    final u = userAsync.value ?? user;

    if (u == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading Profile...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentUser = ref.watch(currentUserProvider);
    final isOwner = currentUser?.id == u.id;

    // Update Parent AppBar Branding
    Future.microtask(() {
      if (!context.mounted) return;
      final location = GoRouterState.of(context).uri.path;
      final bizName = u.role == UserRole.vendor
          ? (u.vendorKyc?.businessName ??
                u.kycData?['businessName'] as String? ??
                u.name)
          : u.name;

      ref
          .read(appBarConfigProvider(location).notifier)
          .setConfig(
            AppBarConfig(
              title: u.role == UserRole.vendor ? bizName : 'User Profile',
              actions: [
                if (isOwner)
                  AppBarAction(
                    icon: Icons.edit_note_rounded,
                    label: 'Edit',
                    onPressed: () {
                      if (context.mounted)
                        context.push('/onboarding/setup?step=1');
                    },
                  ),
              ],
            ),
          );
    });

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: u.photoUrl != null
                    ? CachedNetworkImageProvider(u.photoUrl!)
                    : null,
                child: u.photoUrl == null
                    ? Text(u.name[0], style: const TextStyle(fontSize: 40))
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              u.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              u.role.name.toUpperCase(),
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            _buildVerificationBadge(context, u.verificationStatus),
            if ((u.role == UserRole.vendor || u.role == UserRole.courier) &&
                u.totalReviews > 0) ...[
              const SizedBox(height: 16),
              RatingDisplayWidget(
                averageRating: u.averageRating,
                totalReviews: u.totalReviews,
                ratingBreakdown: u.ratingBreakdown,
                showBreakdown: false, // Keep concise on profile header
              ),
            ],
            const SizedBox(height: 24),
            Consumer(
              builder: (context, ref, child) {
                final currentUser = ref.watch(currentUserProvider);
                if (currentUser == null || currentUser.id == u.id) {
                  return const SizedBox.shrink();
                }

                final isFollowing = currentUser.followingIds.contains(u.id);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push('/social/chat/${u.id}');
                      },
                      icon: const Icon(Icons.message),
                      label: const Text('Message'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        if (isFollowing) {
                          ref
                              .read(socialRepositoryProvider)
                              .unfollowUser(currentUser.id, u.id);
                        } else {
                          ref
                              .read(socialRepositoryProvider)
                              .followUser(currentUser.id, u.id);
                        }
                      },
                      icon: Icon(
                        isFollowing ? Icons.person_remove : Icons.person_add,
                      ),
                      label: Text(isFollowing ? 'Unfollow' : 'Follow'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Divider(),
                  _buildInfoRow(Icons.email, 'Email', u.email),
                  if (u.phoneNumber != null)
                    _buildInfoRow(Icons.phone, 'Phone', u.phoneNumber!),
                  if (u.address?.fullAddress.isNotEmpty == true)
                    _buildInfoRow(
                      Icons.location_on,
                      'Address',
                      u.address!.fullAddress,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (u.role == UserRole.vendor || u.role == UserRole.courier)
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      u.role == UserRole.courier
                          ? 'Logistics Details'
                          : 'Business Details',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Divider(),
                    if (u.role == UserRole.courier) ...[
                      _buildInfoRow(
                        Icons.local_shipping,
                        'Vehicle Type',
                        u.courierKyc?.vehicleType ??
                            u.kycData?['vehicleType'] as String? ??
                            'Not Specified',
                      ),
                      _buildInfoRow(
                        Icons.numbers,
                        'Registration',
                        u.courierKyc?.vehicleRegNumber ??
                            u.kycData?['vehicleRegNumber'] as String? ??
                            'Not Specified',
                      ),
                    ],
                    if (u.role == UserRole.vendor) ...[
                      _buildInfoRow(
                        Icons.business_center,
                        'Business Name',
                        u.vendorKyc?.businessName ??
                            u.kycData?['businessName'] as String? ??
                            u.kycData?['name'] as String? ??
                            u.name,
                      ),
                      _buildInfoRow(
                        Icons.description,
                        'Description',
                        u.vendorKyc?.businessDescription ??
                            u.kycData?['description'] as String? ??
                            u.kycData?['businessDescription'] as String? ??
                            'No description provided.',
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationBadge(
    BuildContext context,
    VerificationStatus status,
  ) {
    IconData icon;
    Color color;
    String text;

    switch (status) {
      case VerificationStatus.verified:
        icon = Icons.verified;
        color = Colors.blue;
        text = 'Verified Account';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(value, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
