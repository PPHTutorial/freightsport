import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rightlogistics/src/core/presentation/widgets/empty_state.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/core/presentation/providers/nav_providers.dart';
import 'package:rightlogistics/src/features/social/presentation/providers/social_providers.dart';

final usersStreamProvider = StreamProvider<List<UserModel>>((ref) {
  return FirebaseFirestore.instance.collection('users').snapshots().map((
    snapshot,
  ) {
    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          try {
            return UserModel.fromJson(data);
          } catch (e) {
            return null;
          }
        })
        .where((e) => e != null)
        .cast<UserModel>()
        .toList();
  });
});

class ClientDirectoryScreen extends ConsumerWidget {
  const ClientDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);

    Future.microtask(() {
      if (context.mounted) {
        final location = GoRouterState.of(context).uri.path;
        ref
            .read(appBarConfigProvider(location).notifier)
            .setConfig(
              AppBarConfig(
                title: 'Network',
                isSearchEnabled: true,
                searchHint: 'Search clients, vendors...',
                actions: [
                  AppBarAction(
                    icon: FontAwesomeIcons.filter,
                    label: 'Filter',
                    onPressed: () => _showFilterSheet(context),
                  ),
                ],
              ),
            );
      }
    });

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70.h),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                labelColor: Theme.of(context).colorScheme.onPrimary,
                unselectedLabelColor: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(
                    child: Text(
                      'Clients',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Vendors',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Couriers',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _UserListTab(
              roleFilter: UserRole.customer,
              searchQuery: searchQuery,
            ),
            _UserListTab(roleFilter: UserRole.vendor, searchQuery: searchQuery),
            _UserListTab(
              roleFilter: UserRole.courier,
              searchQuery: searchQuery,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(ctx).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.userCheck),
              title: const Text('Verified Only'),
              trailing: Switch(value: false, onChanged: (val) {}),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.clock),
              title: const Text('Recently Active'),
              trailing: Switch(value: false, onChanged: (val) {}),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserListTab extends ConsumerWidget {
  final UserRole roleFilter;
  final String searchQuery;
  const _UserListTab({required this.roleFilter, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersStreamProvider);

    return usersAsync.when(
      data: (users) {
        var filteredUsers = users.where((u) => u.role == roleFilter).toList();

        // Apply search filter
        if (searchQuery.isNotEmpty) {
          final query = searchQuery.toLowerCase();
          filteredUsers = filteredUsers.where((u) {
            final name = u.name.toLowerCase();
            final businessName =
                (u.vendorKyc?.businessName ?? u.kycData?['businessName'] ?? '')
                    .toString()
                    .toLowerCase();
            return name.contains(query) || businessName.contains(query);
          }).toList();
        }

        if (filteredUsers.isEmpty) {
          return EmptyState(
            icon: searchQuery.isNotEmpty
                ? Icons.search_off_rounded
                : (roleFilter == UserRole.vendor
                      ? Icons.store_mall_directory
                      : Icons.people_outline),
            title: searchQuery.isNotEmpty
                ? 'No Results Found'
                : 'No ${roleFilter.name}s Found',
            description: searchQuery.isNotEmpty
                ? 'Try searching with different keywords.'
                : 'Registered ${roleFilter.name}s will appear here.',
          );
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 24.w),
          itemCount: filteredUsers.length,
          separatorBuilder: (context, index) => SizedBox(height: 4.h),
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return _UserListItem(user: user);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text('Error loading users: $e')),
    );
  }
}

class _UserListItem extends ConsumerWidget {
  final UserModel user;
  const _UserListItem({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVendor = user.role == UserRole.vendor;
    final displayName = isVendor
        ? (user.vendorKyc?.businessName ??
              user.kycData?['businessName'] ??
              user.name)
        : user.name;

    final displayImage = isVendor && user.companyLogo != null
        ? user.companyLogo
        : user.photoUrl;

    // Requirement 7: No borders, faint divider
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 2.h),
        onTap: () => context.push('/user-profile', extra: user),
        leading: GestureDetector(
          onTap: () =>
              _showAvatarPreview(context, ref, displayImage, displayName),
          child: CircleAvatar(
            radius: 24,
            backgroundImage: displayImage != null
                ? CachedNetworkImageProvider(displayImage)
                : null,
            child: displayImage == null
                ? Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                  )
                : null,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                displayName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (isVendor) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.store,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ],
        ),
        subtitle: Text(
          user.role.name.toUpperCase(),
          style: const TextStyle(fontSize: 10, letterSpacing: 1),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFollowButton(context, ref),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const FaIcon(FontAwesomeIcons.ellipsisVertical, size: 16),
              onSelected: (value) => _handleAction(context, ref, value),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  padding: EdgeInsets.symmetric(horizontal: 24.h),
                  value: 'follow',
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.userPlus, size: 14),
                      SizedBox(width: 12),
                      Text('Follow'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  padding: EdgeInsets.symmetric(horizontal: 24.h),
                  value: 'message',
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.message, size: 14),
                      SizedBox(width: 12),
                      Text('Message'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  padding: EdgeInsets.symmetric(horizontal: 24.h),

                  value: 'profile',
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.solidAddressCard, size: 14),
                      SizedBox(width: 12),
                      Text('View Profile'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  padding: EdgeInsets.symmetric(horizontal: 24.h),

                  value: 'recommend',
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.thumbsUp, size: 14),
                      SizedBox(width: 12),
                      Text('Recommend'),
                    ],
                  ),
                ),
                PopupMenuDivider(
                  color: Theme.of(context).dividerColor.withOpacity(0.4),
                ),
                PopupMenuItem(
                  padding: EdgeInsets.symmetric(horizontal: 24.h),
                  value: 'report',
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.flag,
                        size: 14,
                        color: Colors.orange.shade800,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Report Abuse',
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  padding: EdgeInsets.symmetric(horizontal: 24.h),
                  value: 'block',
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.ban,
                        size: 14,
                        color: Colors.red.shade800,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Block User',
                        style: TextStyle(
                          color: Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowButton(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null || currentUser.id == user.id) {
      return const SizedBox.shrink();
    }

    final followingsAsync = ref.watch(followingIdsProvider(currentUser.id));

    return followingsAsync.when(
      data: (followingIds) {
        final isFollowing = followingIds.contains(user.id);
        return Container();

        /* TODO:
         InkWell(
          onTap: () {
            if (isFollowing) {
              ref
                  .read(socialRepositoryProvider)
                  .unfollowUser(currentUser.id, user.id);
            } else {
              ref
                  .read(socialRepositoryProvider)
                  .followUser(currentUser.id, user.id);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isFollowing
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
              border: isFollowing
                  ? Border.all(color: Theme.of(context).colorScheme.primary)
                  : null,
            ),
            child: Text(
              isFollowing ? 'Following' : 'Follow',
              style: TextStyle(
                color: isFollowing
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );*/
      },
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action) {
    if (action == 'message') {
      context.push('/social/chat/${user.id}');
    } else if (action == 'profile') {
      context.push('/user-profile', extra: user);
    } else if (action == 'follow') {
      ref
          .read(socialRepositoryProvider)
          .followUser(ref.read(currentUserProvider)!.id, user.id);
    }
  }

  void _showAvatarPreview(
    BuildContext context,
    WidgetRef ref,
    String? image,
    String name,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width * .75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 54,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    backgroundImage: image != null
                        ? CachedNetworkImageProvider(image)
                        : null,
                    child: image == null
                        ? Text(
                            name[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : null,
                  ),
                  if (user.verificationStatus == VerificationStatus.verified)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                user.role.name.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _PreviewAction(
                    icon: FontAwesomeIcons.message,
                    label: 'Chat',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/social/chat/${user.id}');
                    },
                  ),
                  _PreviewAction(
                    icon: FontAwesomeIcons.bolt,
                    label: 'Status',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to status if available
                    },
                  ),
                  _PreviewAction(
                    icon: FontAwesomeIcons.userLarge,
                    label: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/user-profile', extra: user);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PreviewAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: FaIcon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
