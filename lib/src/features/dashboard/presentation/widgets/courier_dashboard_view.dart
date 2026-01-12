import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/tracking/data/shipment_repository.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/widgets/dashboard_analytics_section.dart';
import 'package:rightlogistics/src/core/presentation/providers/nav_providers.dart';

final courierShipmentsProvider = StreamProvider.autoDispose<List<Shipment>>((
  ref,
) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref
      .watch(shipmentRepositoryProvider)
      .watchShipmentsForCourier(user.id)
      .map(
        (list) => list
            .where(
              (s) =>
                  s.currentStatus != ShipmentStatusType.delivered &&
                  s.currentStatus != ShipmentStatusType.cancelled &&
                  s.currentStatus != ShipmentStatusType.failedAttempt,
            )
            .toList(),
      );
});

final allCourierShipmentsProvider = StreamProvider.autoDispose<List<Shipment>>((
  ref,
) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref
      .watch(shipmentRepositoryProvider)
      .watchShipmentsForCourier(user.id);
});

class CourierDashboardView extends ConsumerWidget {
  const CourierDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Update AppBar Config
    Future.microtask(() {
      if (!context.mounted) return;
      final location = GoRouterState.of(context).uri.path;
      ref
          .read(appBarConfigProvider(location).notifier)
          .setConfig(
            AppBarConfig(
              title: 'Courier Console',
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
                  icon: FontAwesomeIcons.bell,
                  label: 'Notifications',
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
          _buildCourierHeader(context, ref),
          SizedBox(height: 32.h),
          if (ref.watch(currentUserProvider)?.payoutDetails == null) ...[
            _buildPayoutWarning(context),
            SizedBox(height: 32.h),
          ],
          _buildMapPreview(context),
          SizedBox(height: 32.h),
          _buildEarningsSection(context, ref),
          SizedBox(height: 32.h),
          _buildQuickPerformance(context, ref),
          SizedBox(height: 32.h),
          _buildAnalyticsSection(context, ref),
          SizedBox(height: 40.h),
          _buildRunList(context, ref),
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
                  'Account Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  'Preferences, Currency & Security',
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

  Widget _buildCourierHeader(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Run',
              style: GoogleFonts.redHatDisplay(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 32.sp,
                letterSpacing: -1,
              ),
            ),
            Text(
              user?.name ?? 'Courier',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10.w,
              ),
            ],
          ),
          child: FaIcon(
            FontAwesomeIcons.qrcode,
            color: Theme.of(context).colorScheme.primary,
            size: 20.w,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsSection(BuildContext context, WidgetRef ref) {
    final shipmentsAsync = ref.watch(allCourierShipmentsProvider);
    return shipmentsAsync.when(
      data: (shipments) =>
          DashboardAnalyticsSection(shipments: shipments, isAdmin: false),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildQuickPerformance(BuildContext context, WidgetRef ref) {
    final earningsAsync = ref.watch(courierEarningsProvider);

    return earningsAsync.when(
      data: (stats) {
        return Row(
          children: [
            Expanded(
              child: _CourierStatCard(
                label: 'EFFICIENCY',
                value: stats['efficiency'] ?? '0%',
                color: AppTheme.successGreen,
                icon: FontAwesomeIcons.chartLine,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _CourierStatCard(
                label: 'RATING',
                value: stats['rating']?.toString() ?? '5.0',
                color: AppTheme.accentOrange,
                icon: FontAwesomeIcons.solidStar,
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildMapPreview(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=shipping',
        );
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open maps')),
            );
          }
        }
      },
      child: Container(
        height: 180.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Use a static map image if network one fails, or fallback
              // Since we don't have a key, this will fail. Better to use a generic placeholder that WORKS.
              // Reverting to placeholder.com but with error handling to avoid "producing error" visually.
              Image.asset(
                'assets/images/courier_map.png',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(color: Colors.black.withOpacity(0.1)),
              Positioned(
                bottom: 16.h,
                left: 16.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.locationArrow,
                        size: 14.w,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Open in Maps',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarningsSection(BuildContext context, WidgetRef ref) {
    final earningsAsync = ref.watch(courierEarningsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Revenue',
          style: GoogleFonts.redHatDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        earningsAsync.when(
          data: (stats) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildRevenueCard(
                      context,
                      'DAILY REVENUE',
                      stats['daily'] ?? 0.0,
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildRevenueCard(
                      context,
                      'TOTAL EARNED',
                      stats['total'] ?? 0.0,
                      AppTheme.successGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildRevenueCard(
    BuildContext context,
    String label,
    double amount,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12.w,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              FaIcon(
                FontAwesomeIcons.wallet,
                color: Colors.white.withOpacity(0.4),
                size: 12.w,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            NumberFormat.currency(symbol: r'$').format(amount),
            style: GoogleFonts.redHatDisplay(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunList(BuildContext context, WidgetRef ref) {
    final shipmentsAsync = ref.watch(courierShipmentsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Assignments',
              style: GoogleFonts.redHatDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/courier/history'),
              child: const Text('View History'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        shipmentsAsync.when(
          data: (shipments) {
            if (shipments.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(40.w),
                  child: Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.thumbsUp,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withOpacity(0.3),
                        size: 40.w,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No deliveries assigned for today',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shipments.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                return _CourierTaskTile(shipment: shipments[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              const Center(child: Text('Error loading assignments')),
        ),
      ],
    );
  }

  Widget _buildPayoutWarning(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Theme.of(context).colorScheme.onErrorContainer,
            size: 24.w,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payout Method Missing',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'You won\'t be able to receive earnings.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              context.push('/onboarding/setup?step=2');
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.onErrorContainer.withOpacity(0.1),
            ),
            child: Text(
              'Setup Now',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourierStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _CourierStatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              Icon(icon, color: color.withValues(alpha: 0.5), size: 16.w),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: GoogleFonts.redHatDisplay(
              fontWeight: FontWeight.w900,
              fontSize: 28.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourierTaskTile extends StatelessWidget {
  final Shipment shipment;

  const _CourierTaskTile({required this.shipment});

  @override
  Widget build(BuildContext context) {
    final isDelivered = shipment.currentStatus == ShipmentStatusType.delivered;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10.w,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(
            '/courier/update/${shipment.trackingNumber}',
            extra: shipment,
          ),
          borderRadius: BorderRadius.circular(24.w),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color:
                            (isDelivered
                                    ? AppTheme.successGreen
                                    : Theme.of(context).colorScheme.primary)
                                .withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(
                        isDelivered
                            ? FontAwesomeIcons.solidCircleCheck
                            : FontAwesomeIcons.truckFast,
                        color: isDelivered
                            ? AppTheme.successGreen
                            : Theme.of(context).colorScheme.primary,
                        size: 18.w,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '#${shipment.trackingNumber}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () async {
                                  await Clipboard.setData(
                                    ClipboardData(
                                      text: shipment.trackingNumber,
                                    ),
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Copied to clipboard'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                                child: Icon(
                                  Icons.copy_rounded,
                                  size: 14.w,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            shipment.recipientName,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FaIcon(
                      FontAwesomeIcons.chevronRight,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 12.w,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                const Divider(height: 1),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.locationDot,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 12.w,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        shipment.recipientAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.phone,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 12.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      shipment.recipientPhone,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12.sp,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            (isDelivered
                                    ? AppTheme.successGreen
                                    : AppTheme.accentOrange)
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      child: Text(
                        shipment.currentStatus.name.toUpperCase(),
                        style: TextStyle(
                          color: isDelivered
                              ? AppTheme.successGreen
                              : AppTheme.accentOrange,
                          fontWeight: FontWeight.w900,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
