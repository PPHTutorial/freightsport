import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/features/admin/presentation/providers/admin_providers.dart';
import 'package:rightlogistics/src/features/admin/presentation/pages/analytics_screen.dart';
import 'package:rightlogistics/src/features/admin/presentation/pages/bulk_operations_screen.dart';
import 'package:rightlogistics/src/features/admin/presentation/pages/user_management_screen.dart';
import 'package:rightlogistics/src/features/admin/presentation/pages/post_management_screen.dart';
import 'package:rightlogistics/src/features/admin/presentation/pages/warehouse_management_screen.dart';
import 'package:rightlogistics/src/features/admin/presentation/pages/quotation_management_screen.dart';
import 'package:rightlogistics/src/features/admin/presentation/pages/broadcast_management_screen.dart';
import 'package:rightlogistics/src/features/admin/presentation/pages/courier_assignment_screen.dart';
import 'package:rightlogistics/src/features/admin/presentation/pages/audit_log_screen.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(currentUserProvider);

    if (user == null || user.role != UserRole.admin) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 64.w, color: colorScheme.error),
              SizedBox(height: 16.h),
              Text(
                'Access Denied',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              const Text('You do not have permission to view this page.'),
            ],
          ),
        ),
      );
    }

    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Management',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.post_add), text: 'Posts'),
            Tab(icon: Icon(Icons.warehouse), text: 'Warehouses'),
            Tab(icon: Icon(Icons.receipt_long), text: 'Quotations'),
            Tab(icon: Icon(Icons.campaign), text: 'Broadcasts'),
            Tab(icon: Icon(Icons.local_shipping), text: 'Assignments'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const AnalyticsScreen())),
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Advanced Analytics',
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BulkOperationsScreen()),
            ),
            icon: const Icon(Icons.upload_file),
            tooltip: 'Bulk Operations',
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            padding: EdgeInsets.all(16.w),
            color: colorScheme.surfaceContainerHighest,
            child: statsAsync.when(
              data: (stats) => Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Total Users',
                      value: stats['totalUsers']?.toString() ?? '0',
                      icon: Icons.people,
                      color: AppTheme.accentOrange,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _StatCard(
                      title: 'Total Posts',
                      value: stats['totalPosts']?.toString() ?? '0',
                      icon: Icons.post_add,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _StatCard(
                      title: 'Shipments',
                      value: stats['totalShipments']?.toString() ?? '0',
                      icon: Icons.local_shipping,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _StatCard(
                      title: 'Warehouses',
                      value: stats['totalWarehouses']?.toString() ?? '0',
                      icon: Icons.warehouse,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Error loading stats: $err')),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                UserManagementScreen(),
                PostManagementScreen(),
                WarehouseManagementScreen(),
                QuotationManagementScreen(),
                BroadcastManagementScreen(),
                CourierAssignmentScreen(),
                AuditLogScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24.w),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
