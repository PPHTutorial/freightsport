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
import 'package:rightlogistics/src/features/dashboard/presentation/widgets/dashboard_analytics_section.dart';
import 'package:rightlogistics/src/core/presentation/providers/nav_providers.dart';
import 'package:rightlogistics/src/features/social/presentation/widgets/social_post_cards.dart';

class VendorDashboardView extends ConsumerWidget {
  VendorDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    // Update AppBar Branding
    Future.microtask(() {
      final businessName = user?.vendorKyc?.businessName;
      final location = GoRouterState.of(context).uri.path;
      ref
          .read(appBarConfigProvider(location).notifier)
          .setConfig(
            AppBarConfig(
              title: businessName ?? 'Vendor Console',
              centerTitle: false,
              actions: [
                AppBarAction(
                  icon: FontAwesomeIcons.bell,
                  label: 'Notifications',
                  onPressed: () => context.push('/notifications'),
                ),
                AppBarAction(
                  icon: FontAwesomeIcons.user,
                  label: 'Profile',
                  onPressed: () => context.push('/profile'),
                ),
              ],
            ),
          );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVendorHeader(context, ref),
            SizedBox(height: 32.h),
            _buildBusinessMetrics(context, ref),
            SizedBox(height: 32.h),
            _buildAnalyticsSection(context, ref),
            SizedBox(height: 32.h),
            _buildVendorActions(context),
            SizedBox(height: 32.h),
            _buildServicesSection(context, ref),
            SizedBox(height: 32.h),
            _buildSocialUpdatesSection(context, ref),
            SizedBox(height: 32.h),
            _buildInventorySection(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorHeader(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vendor Console',
              style: GoogleFonts.redHatDisplay(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 32.sp,
                letterSpacing: -1,
              ),
            ),
            Text(
              user?.name ?? 'Loading...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.w),
            border: Border.all(
              color: AppTheme.successGreen.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.solidCircleCheck,
                color: AppTheme.successGreen,
                size: 14.w,
              ),
              SizedBox(width: 4.w),
              Text(
                'VERIFIED',
                style: GoogleFonts.redHatDisplay(
                  color: AppTheme.successGreen,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessMetrics(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(vendorStatsProvider);
    final fleetAsync = ref.watch(fleetUtilizationProvider);
    final user = ref.watch(currentUserProvider);

    return Column(
      children: [
        statsAsync.when(
          data: (stats) {
            debugPrint('Vendor Stats: $stats');
            return _RevenueCard(
              totalShipments: stats['total'] ?? 0,
              activeShipments: stats['active'] ?? 0,
              revenue: (stats['revenue'] as num?)?.toDouble() ?? 0.0,
              followersCount: user?.followerIds.length ?? 0,
              rating: user?.averageRating ?? 0.0,
              totalReviews: user?.totalReviews ?? 0,
              userId: user?.id ?? '',
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) {
            debugPrint('Vendor Stats Error: $err');
            debugPrint('Stack: $stack');
            return _RevenueCard(
              totalShipments: 0,
              activeShipments: 0,
              revenue: 0.0,
              followersCount: user?.followerIds.length ?? 0,
              rating: user?.averageRating ?? 0.0,
              totalReviews: user?.totalReviews ?? 0,
              userId: user?.id ?? '',
            );
          },
        ),
        SizedBox(height: 16.h),
        fleetAsync.when(
          data: (fleet) => Row(
            children: [
              Expanded(
                child: _MiniMetaCard(
                  label: 'Fleet Active',
                  value: '${fleet['activeFleet']}/${fleet['totalFleet']}',
                  color: Theme.of(context).colorScheme.primary,
                  icon: FontAwesomeIcons.truck,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _MiniMetaCard(
                  label: 'Utilization',
                  value: fleet['utilization'],
                  color: AppTheme.accentOrange,
                  icon: FontAwesomeIcons.chartPie,
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

  Widget _buildAnalyticsSection(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(vendorStatsProvider);
    return statsAsync.when(
      data: (stats) => ref
          .watch(userShipmentsProvider)
          .when(
            data: (shipments) =>
                DashboardAnalyticsSection(shipments: shipments, isAdmin: false),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildVendorActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Operations',
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
              child: _VendorActionBtn(
                label: 'Broadcast',
                icon: FontAwesomeIcons.bullhorn,
                onTap: () => context.push('/admin/broadcast'),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _VendorActionBtn(
                label: 'Add Fleet',
                icon: Icons.local_shipping_rounded,
                onTap: () => context.push('/fleet'),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _VendorActionBtn(
                label: 'Support',
                icon: FontAwesomeIcons.headset,
                onTap: () => context.push('/support'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServicesSection(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final services =
        user?.vendorKyc?.vendorServices ??
        user?.kycData?['vendorServices'] as List? ??
        [];

    if (services.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services Offered',
          style: GoogleFonts.redHatDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: services.map((service) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.w),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Text(
                service.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSocialUpdatesSection(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(vendorPostsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Social Updates',
              style: GoogleFonts.redHatDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/social'),
              child: const Text('Manage Posts'),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        postsAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(24.w),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.bullhorn,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      size: 32.w,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No recent updates. Share something with your followers!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox(
              height: 280.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: posts.length.clamp(0, 5),
                separatorBuilder: (_, __) => SizedBox(width: 16.w),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 300.w,
                    child: SocialPostCard(post: posts[index]),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Error loading posts')),
        ),
      ],
    );
  }

  Widget _buildInventorySection(BuildContext context, WidgetRef ref) {
    final shipmentsAsync = ref.watch(userShipmentsProvider);
    final user = ref.watch(currentUserProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Store Performance',
              style: GoogleFonts.redHatDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('Detailed Report')),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(24.w),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
            ),
          ),
          child: Column(
            children: [
              _PerformanceRow(
                label: 'Order Fill Rate',
                value: _calculateFillRate(shipmentsAsync.value ?? []),
                color: AppTheme.successGreen,
              ),
              Divider(height: 32.h),
              _PerformanceRow(
                label: 'Avg. Turnaround',
                value: _calculateTurnaround(shipmentsAsync.value ?? []),
                color: Theme.of(context).colorScheme.primary,
              ),
              Divider(height: 32.h),
              _PerformanceRow(
                label: 'Customer Satisfaction',
                value:
                    '${user?.averageRating.toStringAsFixed(1) ?? "0.0"}/5 (${user?.totalReviews ?? 0})',
                color: AppTheme.accentOrange,
              ),
            ],
          ),
        ),
        SizedBox(height: 40.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Live Shipments',
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
                    'No active shipments',
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
              itemCount: shipments.length.clamp(0, 3),
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return _VendorInventoryTile(shipment: shipments[index]);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              const Center(child: Text('Error loading shipments')),
        ),
      ],
    );
  }

  String _calculateFillRate(List<Shipment> shipments) {
    if (shipments.isEmpty) return '0%';
    final delivered = shipments
        .where((s) => s.currentStatus == ShipmentStatusType.delivered)
        .length;
    return '${(delivered / shipments.length * 100).toStringAsFixed(1)}%';
  }

  String _calculateTurnaround(List<Shipment> shipments) {
    final delivered = shipments.where(
      (s) => s.currentStatus == ShipmentStatusType.delivered,
    );
    if (delivered.isEmpty) return 'N/A';

    double totalDays = 0;
    int count = 0;

    for (final s in delivered) {
      final deliveryEvent = s.events.where(
        (e) => e.status == ShipmentStatusType.delivered,
      );
      if (deliveryEvent.isNotEmpty) {
        final duration = deliveryEvent.first.timestamp.difference(s.createdAt);
        totalDays += duration.inHours / 24.0;
        count++;
      }
    }

    if (count == 0) return 'N/A';
    final avg = totalDays / count;
    return '${avg.toStringAsFixed(1)} Days';
  }
}

class _PerformanceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _PerformanceRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final int totalShipments;
  final double revenue;
  final int activeShipments;
  final int followersCount;
  final double rating;
  final int totalReviews;
  final String userId;

  const _RevenueCard({
    required this.totalShipments,
    required this.revenue,
    required this.activeShipments,
    required this.followersCount,
    required this.rating,
    required this.totalReviews,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 20.w,
            offset: Offset(0, 10.h),
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
                'Business Overview',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(
                  FontAwesomeIcons.chartLine,
                  color: Colors.white,
                  size: 16.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            currencyFormat.format(revenue),
            style: GoogleFonts.redHatDisplay(
              color: Colors.white,
              fontSize: 40.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'Gross Platform Revenue',
            style: TextStyle(color: Colors.white70, fontSize: 12.sp),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              _MiniStat(label: 'ACTIVE', value: activeShipments.toString()),
              SizedBox(width: 24.w),
              _MiniStat(
                label: 'COMPLETED',
                value: (totalShipments - activeShipments).toString(),
              ),
              SizedBox(width: 24.w),
              _MiniStat(
                label: 'FOLLOWERS',
                value: followersCount.toString(),
                onTap: () {
                  if (userId.isNotEmpty) {
                    context.push('/followers/$userId');
                  }
                },
              ),
              SizedBox(width: 24.w),
              _MiniStat(label: 'RATING', value: rating.toStringAsFixed(1)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _MiniStat({required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetaCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _MiniMetaCard({
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
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10.w,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24.w),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.redHatDisplay(
                  fontWeight: FontWeight.w900,
                  fontSize: 20.sp,
                ),
              ),
              Text(
                label,
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
}

class _VendorActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _VendorActionBtn({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20.w),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.02),
              blurRadius: 10.w,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24.w,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VendorInventoryTile extends StatelessWidget {
  final Shipment shipment;

  const _VendorInventoryTile({required this.shipment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/tracking?code=${shipment.trackingNumber}'),
      borderRadius: BorderRadius.circular(16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20.w),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
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
                color: AppTheme.accentOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: FaIcon(
                FontAwesomeIcons.box,
                color: AppTheme.accentOrange,
                size: 18.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ID: #${shipment.trackingNumber}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  Text(
                    shipment.recipientName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            _StatusBadge(status: shipment.currentStatus),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ShipmentStatusType status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case ShipmentStatusType.delivered:
        color = AppTheme.successGreen;
        break;
      case ShipmentStatusType.created:
        color = Theme.of(context).colorScheme.primary;
        break;
      default:
        color = AppTheme.accentOrange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
