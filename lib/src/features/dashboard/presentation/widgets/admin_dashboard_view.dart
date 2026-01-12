import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:rightlogistics/src/features/tracking/data/shipment_repository.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/widgets/dashboard_analytics_section.dart';
import 'package:rightlogistics/src/core/presentation/providers/nav_providers.dart';

final adminStatsProvider = StreamProvider.autoDispose<Map<String, int>>((ref) {
  return ref.watch(shipmentRepositoryProvider).watchAllShipments().map((
    shipments,
  ) {
    return {
      'total': shipments.length,
      'active': shipments
          .where((s) => s.currentStatus != ShipmentStatusType.delivered)
          .length,
      'delivered': shipments
          .where((s) => s.currentStatus == ShipmentStatusType.delivered)
          .length,
      'delayed': shipments
          .where((s) => s.currentStatus == ShipmentStatusType.created)
          .length,
    };
  });
});

class AdminDashboardView extends ConsumerWidget {
  AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Update AppBar Branding
    Future.microtask(() {
      if (!context.mounted) return;
      final location = GoRouterState.of(context).uri.path;
      ref
          .read(appBarConfigProvider(location).notifier)
          .setConfig(
            AppBarConfig(
              title: 'Admin Hub',
              centerTitle: false,
              actions: [
                AppBarAction(
                  icon: FontAwesomeIcons.gear,
                  label: 'Settings',
                  onPressed: () {
                    if (context.mounted) context.push('/settings');
                  },
                ),
                AppBarAction(
                  icon: FontAwesomeIcons.magnifyingGlass,
                  label: 'Search',
                  onPressed: () {},
                ),
                AppBarAction(
                  icon: FontAwesomeIcons.bell,
                  label: 'Alerts',
                  onPressed: () {
                    if (context.mounted) context.push('/notifications');
                  },
                ),
              ],
            ),
          );
    });

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdminHeader(context),
          SizedBox(height: 32.h),
          _buildQuickAnalysis(context, ref),
          SizedBox(height: 32.h),
          _buildManagementGrid(context),
          SizedBox(height: 40.h),
          _buildAnalyticsSection(context, ref),
          SizedBox(height: 40.h),
          _buildOperationalPulse(context, ref),
          SizedBox(height: 32.h),
          _buildSettingsAccess(context),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSettingsAccess(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              FontAwesomeIcons.gear,
              color: Theme.of(context).colorScheme.primary,
              size: 20.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  'Global Preferences & Config',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => context.push('/settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.w),
              ),
            ),
            child: const Text('OPEN'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Operation Hub',
              style: GoogleFonts.redHatDisplay(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 32.sp,
                letterSpacing: -1,
              ),
            ),
            Text(
              'System Monitoring & Management',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15.w,
                offset: Offset(0, 5.h),
              ),
            ],
          ),
          child: FaIcon(
            FontAwesomeIcons.gears,
            color: Theme.of(context).colorScheme.primary,
            size: 20.w,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAnalysis(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);
    final healthAsync = ref.watch(systemHealthProvider);

    return Column(
      children: [
        statsAsync.when(
          data: (stats) => Row(
            children: [
              Expanded(
                child: _AdminAnalyticsCard(
                  label: 'TOTAL SHIPMENTS',
                  value: stats['total'].toString(),
                  color: Theme.of(context).colorScheme.primary,
                  icon: FontAwesomeIcons.box,
                  trend: '+12%',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _AdminAnalyticsCard(
                  label: 'IN TRANSIT',
                  value: stats['active'].toString(),
                  color: AppTheme.accentOrange,
                  icon: FontAwesomeIcons.truck,
                  trend: 'Stable',
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox.shrink(),
        ),
        SizedBox(height: 16.h),
        healthAsync.when(
          data: (health) => Row(
            children: [
              Expanded(
                child: _AdminAnalyticsCard(
                  label: 'SYSTEM UPTIME',
                  value: health['uptime'],
                  color: AppTheme.successGreen,
                  icon: FontAwesomeIcons.gaugeHigh,
                  trend: 'Optimal',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _AdminAnalyticsCard(
                  label: 'ERROR RATE',
                  value: health['errorRate'],
                  color: AppTheme.errorRed,
                  icon: FontAwesomeIcons.bug,
                  trend: '-0.02%',
                  isNegative: true,
                ),
              ),
            ],
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildManagementGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Platform Control',
          style: GoogleFonts.redHatDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _AdminQuickAction(
                label: 'Clients',
                icon: FontAwesomeIcons.users,
                onTap: () => context.push('/users'),
                color: Colors.indigo,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _AdminQuickAction(
                label: 'Broadcast',
                icon: FontAwesomeIcons.bullhorn,
                onTap: () => context.push('/admin/broadcast'),
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _AdminQuickAction(
                label: 'Fleet',
                icon: FontAwesomeIcons.truckFast,
                onTap: () => context.push('/fleet'),
                color: Colors.teal,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _AdminQuickAction(
                label: 'Seeding',
                icon: FontAwesomeIcons.database,
                onTap: () => context.push('/seeding'),
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsSection(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(allShipmentsProvider);
    return allAsync.when(
      data: (shipments) =>
          DashboardAnalyticsSection(shipments: shipments, isAdmin: true),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildOperationalPulse(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(adminAuditLogsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Audit Logs',
              style: GoogleFonts.redHatDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('Security Center')),
          ],
        ),
        SizedBox(height: 8.h),
        logsAsync.when(
          data: (logs) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final log = logs[index];
                return _AdminLogTile(log: log);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Error loading logs')),
        ),
      ],
    );
  }
}

class _AdminLogTile extends StatelessWidget {
  final Map<String, dynamic> log;
  const _AdminLogTile({required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: FaIcon(FontAwesomeIcons.clockRotateLeft, size: 16.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log['action'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  '${log['user']} on ${log['target']}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Text(
            DateFormat('HH:mm').format(log['time']),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminAnalyticsCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final String trend;
  final bool isNegative;

  const _AdminAnalyticsCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.trend,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15.w,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18.w),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color:
                      (isNegative ? AppTheme.errorRed : AppTheme.successGreen)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    color: isNegative
                        ? AppTheme.errorRed
                        : AppTheme.successGreen,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: GoogleFonts.redHatDisplay(
              fontWeight: FontWeight.w900,
              fontSize: 32.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminQuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _AdminQuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20.w),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10.w,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28.w),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
