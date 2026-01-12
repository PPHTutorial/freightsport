import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rightlogistics/src/core/presentation/providers/nav_providers.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/widgets/dashboard_analytics_section.dart';

class CustomerDashboardView extends ConsumerWidget {
  CustomerDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Schedule AppBar update
    Future.microtask(() {
      if (!context.mounted) return;
      final location = GoRouterState.of(context).uri.path;
      ref
          .read(appBarConfigProvider(location).notifier)
          .setConfig(
            AppBarConfig(
              title: 'Dashboard',
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
                  icon: FontAwesomeIcons.calculator,
                  label: 'Get Quote',
                  onPressed: () {
                    if (context.mounted) context.push('/get-quote');
                  },
                ),
                AppBarAction(
                  icon: FontAwesomeIcons.circlePlus,
                  label: 'Book Shipment',
                  onPressed: () {
                    if (context.mounted) context.push('/admin/create-shipment');
                  },
                ),
                AppBarAction(
                  icon: FontAwesomeIcons.user,
                  label: 'Profile',
                  onPressed: () {
                    if (context.mounted) context.push('/profile');
                  },
                ),
                AppBarAction(
                  icon: FontAwesomeIcons.magnifyingGlassLocation,
                  label: 'Tracking',
                  onPressed: () {
                    if (context.mounted) context.push('/tracking');
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
          _buildPremiumHeader(context, ref),
          SizedBox(height: 24.h),
          _buildConciergeSection(context, ref),
          SizedBox(height: 32.h),
          _buildLogisticsOverview(context, ref),
          SizedBox(height: 32.h),
          _buildAnalyticsSection(context, ref),
          SizedBox(height: 32.h),
          _buildModernTracking(context),
          SizedBox(height: 40.h),
          _buildActionGrid(context),
          SizedBox(height: 40.h),
          _buildActivitySection(context, ref),
          SizedBox(height: 32.h),
          _buildSettingsAccess(context),
          SizedBox(height: 48.h),
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
                  'App Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  'Preferences & Base Currency',
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

  Widget _buildConciergeSection(BuildContext context, WidgetRef ref) {
    final shipmentsAsync = ref.watch(userShipmentsProvider);

    return shipmentsAsync.when(
      data: (shipments) {
        final outForDelivery = shipments
            .where((s) => s.currentStatus == ShipmentStatusType.outForDelivery)
            .length;

        String message = 'Everything looks good today.';
        if (outForDelivery > 0) {
          message =
              'Excellent! $outForDelivery of your items are out for delivery.';
        } else if (shipments.any(
          (s) => s.currentStatus == ShipmentStatusType.inTransit,
        )) {
          message = 'Your shipments are moving steadily across the network.';
        }

        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppTheme.accentOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24.w),
            border: Border.all(color: AppTheme.accentOrange.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: const BoxDecoration(
                  color: AppTheme.accentOrange,
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  FontAwesomeIcons.wandMagicSparkles,
                  color: Colors.white,
                  size: 16.w,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONCIERGE INSIGHT',
                      style: TextStyle(
                        color: AppTheme.accentOrange,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildPremiumHeader(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: GoogleFonts.redHatDisplay(
                color: colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 32.sp,
                letterSpacing: -1,
              ),
            ),
            Text(
              'Welcome back, ${user?.name.split(' ')[0] ?? 'Explorer'}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => context.push('/profile'),
          child: CircleAvatar(
            radius: 20.w,
            backgroundColor: colorScheme.surface,
            backgroundImage:
                user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                ? CachedNetworkImageProvider(user.photoUrl!)
                : null,
            child: user?.photoUrl == null || user!.photoUrl!.isEmpty
                ? Icon(Icons.person, color: colorScheme.primary, size: 20.w)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsSection(BuildContext context, WidgetRef ref) {
    final shipmentsAsync = ref.watch(userShipmentsProvider);
    return shipmentsAsync.when(
      data: (shipments) =>
          DashboardAnalyticsSection(shipments: shipments, isAdmin: false),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildLogisticsOverview(BuildContext context, WidgetRef ref) {
    final shipmentsAsync = ref.watch(userShipmentsProvider);

    return shipmentsAsync.when(
      data: (shipments) {
        final inTransit = shipments
            .where((s) => s.currentStatus == ShipmentStatusType.inTransit)
            .length;
        final pending = shipments
            .where((s) => s.currentStatus == ShipmentStatusType.created)
            .length;
        final delivered = shipments
            .where((s) => s.currentStatus == ShipmentStatusType.delivered)
            .length;

        return Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'In Transit',
                value: inTransit.toString(),
                color: AppTheme.accentOrange,
                icon: FontAwesomeIcons.truck,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _StatCard(
                label: 'Pending',
                value: pending.toString(),
                color: Theme.of(context).colorScheme.primary,
                icon: FontAwesomeIcons.clock,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _StatCard(
                label: 'Delivered',
                value: delivered.toString(),
                color: AppTheme.successGreen,
                icon: FontAwesomeIcons.circleCheck,
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildModernTracking(BuildContext context) {
    final controller = TextEditingController();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 20.w,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Track your Parcel',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Enter your tracking number to see instant updates',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 20.h),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            onSubmitted: (val) {
              if (val.trim().isNotEmpty) {
                context.push('/tracking?code=${val.trim()}');
              }
            },
            decoration: InputDecoration(
              hintText: 'RL-123456...',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.white.withOpacity(0.15),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.w),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.w),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.w),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(16.w),
                child: FaIcon(
                  FontAwesomeIcons.locationCrosshairs,
                  color: Colors.white,
                  size: 18.w,
                ),
              ),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: IconButton(
                  onPressed: () {
                    final code = controller.text.trim();
                    if (code.isNotEmpty) {
                      context.push('/tracking?code=$code');
                    }
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.arrowRight,
                    color: Colors.white,
                    size: 16.w,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.accentOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Logistics Actions',
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
              child: _ActionSquare(
                label: 'Get Quote',
                icon: FontAwesomeIcons.calculator,
                color: Theme.of(context).colorScheme.primary,
                onTap: () => context.push('/get-quote'),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _ActionSquare(
                label: 'Book Shipment',
                icon: FontAwesomeIcons.circlePlus,
                color: AppTheme.accentOrange,
                onTap: () => context.push('/admin/create-shipment'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivitySection(BuildContext context, WidgetRef ref) {
    final shipmentsAsync = ref.watch(userShipmentsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: GoogleFonts.redHatDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/tracking'),
              child: const Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        shipmentsAsync.when(
          data: (shipments) {
            if (shipments.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(40.w),
                  child: Text(
                    'No recent movements',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shipments.length.clamp(0, 4),
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final s = shipments[index];
                return _ActivityTile(shipment: s);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Error loading activity')),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10.w,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.w),
            ),
            child: Icon(icon, color: color, size: 20.w),
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: GoogleFonts.redHatDisplay(
              fontWeight: FontWeight.w900,
              fontSize: 24.sp,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionSquare extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionSquare({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.w),
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20.w),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28.w),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final Shipment shipment;

  const _ActivityTile({required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10.w,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              FontAwesomeIcons.box,
              color: Theme.of(context).colorScheme.primary,
              size: 18.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${shipment.trackingNumber}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
                Text(
                  '${shipment.senderName.split(' ')[0]} → ${shipment.recipientName.split(' ')[0]}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatStatus(shipment.currentStatus),
                style: TextStyle(
                  color: _getStatusColor(shipment.currentStatus),
                  fontWeight: FontWeight.w900,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                DateFormat('MMM d, HH:mm').format(shipment.createdAt),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatStatus(ShipmentStatusType status) {
    return status.name.toUpperCase();
  }

  Color _getStatusColor(ShipmentStatusType status) {
    switch (status) {
      case ShipmentStatusType.delivered:
        return AppTheme.successGreen;
      case ShipmentStatusType.cancelled:
        return AppTheme.errorRed;
      default:
        return AppTheme.accentOrange;
    }
  }
}
