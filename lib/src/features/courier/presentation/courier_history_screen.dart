import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/tracking/data/shipment_repository.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/providers/dashboard_providers.dart';

final courierHistoryProvider = StreamProvider.autoDispose<List<Shipment>>((
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
                  s.currentStatus == ShipmentStatusType.delivered ||
                  s.currentStatus == ShipmentStatusType.cancelled ||
                  s.currentStatus == ShipmentStatusType.failedAttempt,
            )
            .toList(),
      );
});

class CourierHistoryScreen extends ConsumerWidget {
  const CourierHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(courierHistoryProvider);
    final earningsAsync = ref.watch(courierEarningsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.h,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Run History',
                style: GoogleFonts.redHatDisplay(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 24.sp,
                ),
              ),
              centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: 16.h),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: earningsAsync.when(
                data: (stats) => _buildHistoryStats(context, stats),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            sliver: historyAsync.when(
              data: (shipments) {
                if (shipments.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('No completed runs yet.')),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final shipment = shipments[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: _HistoryCard(shipment: shipment),
                    );
                  }, childCount: shipments.length),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, s) =>
                  SliverFillRemaining(child: Center(child: Text('Error: $e'))),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
    );
  }

  Widget _buildHistoryStats(BuildContext context, Map<String, dynamic> stats) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 15.w,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                'TOTAL RUNS',
                stats['total_count']?.toString() ?? '0',
                Colors.white,
              ),
              _buildStatItem(
                'EARNINGS',
                NumberFormat.currency(
                  symbol: r'$',
                ).format(stats['total'] ?? 0.0),
                Colors.white,
              ),
              _buildStatItem(
                'SUCCESS',
                stats['efficiency'] ?? '0%',
                Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.6),
            fontSize: 9.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.redHatDisplay(
            color: color,
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Shipment shipment;
  const _HistoryCard({required this.shipment});

  @override
  Widget build(BuildContext context) {
    final isDelivered = shipment.currentStatus == ShipmentStatusType.delivered;
    final color = isDelivered ? AppTheme.successGreen : Colors.red;

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${shipment.trackingNumber}',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.sp),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isDelivered) ...[
                      Text(
                        NumberFormat.currency(
                          symbol: r'$',
                        ).format((shipment.totalPrice ?? 0.0) * 0.1),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w900,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      shipment.currentStatus.name.toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w900,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 14.w,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  shipment.recipientAddress,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 14.w,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 8.w),
              Text(
                DateFormat('MMM d, y • h:mm a').format(
                  shipment.events.isNotEmpty
                      ? shipment.events.last.timestamp
                      : shipment.createdAt,
                ),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
