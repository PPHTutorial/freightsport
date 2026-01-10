import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/admin/presentation/providers/admin_providers.dart';
import 'package:rightlogistics/src/features/admin/presentation/widgets/user_form_dialog.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';

// Search query provider
final userSearchQueryProvider = StateProvider<String>((ref) => '');

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);
    final searchQuery = ref.watch(userSearchQueryProvider);

    return Scaffold(
      body: usersAsync.when(
        data: (users) {
          // Filter users based on search query
          final filteredUsers = searchQuery.isEmpty
              ? users
              : users.where((user) {
                  final query = searchQuery.toLowerCase();
                  return user.name.toLowerCase().contains(query) ||
                      user.email.toLowerCase().contains(query) ||
                      (user.phoneNumber?.toLowerCase().contains(query) ??
                          false);
                }).toList();

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: EdgeInsets.all(16.w),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users by name, email, or phone...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () =>
                                ref
                                        .read(userSearchQueryProvider.notifier)
                                        .state =
                                    '',
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                  ),
                  onChanged: (query) {
                    ref.read(userSearchQueryProvider.notifier).state = query;
                  },
                ),
              ),

              // Results count
              if (searchQuery.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${filteredUsers.length} result(s) found',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 8.h),

              // Users Table
              Expanded(
                child: filteredUsers.isEmpty
                    ? Center(
                        child: Text(
                          searchQuery.isEmpty
                              ? 'No users found'
                              : 'No users match your search',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('Role')),
                            DataColumn(label: Text('KYC')),
                            DataColumn(label: Text('Account')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: filteredUsers.map((user) {
                            return DataRow(
                              cells: [
                                DataCell(Text(user.name)),
                                DataCell(Text(user.email)),
                                DataCell(Text(user.phoneNumber ?? '-')),
                                DataCell(_RoleBadge(role: user.role)),
                                DataCell(
                                  _StatusBadge(status: user.verificationStatus),
                                ),
                                DataCell(
                                  _AccountStatusBadge(
                                    status: user.accountStatus,
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 18),
                                        onPressed: () =>
                                            _showUserForm(context, user),
                                        tooltip: 'Edit user',
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(
                                          Icons.more_vert,
                                          size: 18,
                                        ),
                                        onSelected: (value) =>
                                            _handleUserAction(
                                              context,
                                              ref,
                                              user,
                                              value,
                                            ),
                                        itemBuilder: (context) => [
                                          if (user.accountStatus !=
                                              AccountStatus.active)
                                            const PopupMenuItem(
                                              value: 'activate',
                                              child: Text('Activate'),
                                            ),
                                          if (user.accountStatus !=
                                              AccountStatus.suspended)
                                            const PopupMenuItem(
                                              value: 'suspend',
                                              child: Text('Suspend'),
                                            ),
                                          if (user.accountStatus !=
                                              AccountStatus.terminated)
                                            const PopupMenuItem(
                                              value: 'terminate',
                                              child: Text(
                                                'Terminate',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          const PopupMenuDivider(),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Text(
                                              'Delete Permanently',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('New User'),
      ),
    );
  }

  void _showUserForm(BuildContext context, UserModel? user) {
    showDialog(
      context: context,
      builder: (context) => UserFormDialog(user: user),
    );
  }

  Future<void> _handleUserAction(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
    String action,
  ) async {
    final repo = ref.read(authRepositoryProvider);
    switch (action) {
      case 'activate':
        await repo.updateAccountStatus(user.id, AccountStatus.active);
        break;
      case 'suspend':
        await repo.updateAccountStatus(user.id, AccountStatus.suspended);
        break;
      case 'terminate':
        await repo.updateAccountStatus(user.id, AccountStatus.terminated);
        break;
      case 'delete':
        _confirmDelete(context, ref, user);
        break;
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete ${user.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(adminRepositoryProvider).deleteUser(user.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User deleted successfully'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting user: $e'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final UserRole role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (role) {
      case UserRole.admin:
        color = Colors.red;
        break;
      case UserRole.vendor:
        color = Colors.blue;
        break;
      case UserRole.courier:
        color = Colors.green;
        break;
      case UserRole.customer:
        color = Colors.orange;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Text(
        role.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final VerificationStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case VerificationStatus.verified:
        color = Colors.green;
        break;
      case VerificationStatus.pending:
        color = Colors.orange;
        break;
      case VerificationStatus.unverified:
        color = Colors.grey;
        break;
      case VerificationStatus.rejected:
        color = Colors.red;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _AccountStatusBadge extends StatelessWidget {
  final AccountStatus status;

  const _AccountStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case AccountStatus.active:
        color = Colors.green;
        break;
      case AccountStatus.suspended:
        color = Colors.orange;
        break;
      case AccountStatus.terminated:
        color = Colors.red;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
