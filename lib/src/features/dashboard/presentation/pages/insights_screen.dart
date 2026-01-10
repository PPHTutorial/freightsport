import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/widgets/dashboard_analytics_section.dart';
import 'package:rightlogistics/src/core/presentation/widgets/glass_card.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allShipments = ref.watch(allShipmentsProvider).value ?? [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Ultimate Insights',
                style: GoogleFonts.redHatDisplay(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.insights_rounded,
                    size: 80.w,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummarySection(context, allShipments),
                  SizedBox(height: 32.h),
                  DashboardAnalyticsSection(
                    shipments: allShipments,
                    isAdmin: true,
                  ),
                  SizedBox(height: 32.h),
                  _buildSystemPulse(context, ref),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, List<dynamic> shipments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Logistics Overview',
          style: GoogleFonts.redHatDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildSimpleStat(
                context,
                'Global Volume',
                shipments.length.toString(),
                Icons.public_rounded,
                Colors.blue,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildSimpleStat(
                context,
                'Success Rate',
                '94.2%',
                Icons.verified_rounded,
                AppTheme.successGreen,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSimpleStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return GlassCard(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20.w),
          SizedBox(height: 12.h),
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
              fontSize: 10.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemPulse(BuildContext context, WidgetRef ref) {
    final health = ref.watch(systemHealthProvider).value ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Pulse',
          style: GoogleFonts.redHatDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        GlassCard(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              _buildPulseItem(
                context,
                'Active Users',
                health['activeUsers']?.toString() ?? '0',
                Icons.people_outline,
              ),
              const Divider(height: 32),
              _buildPulseItem(
                context,
                'API Status',
                'Operational',
                Icons.api_rounded,
                color: AppTheme.successGreen,
              ),
              const Divider(height: 32),
              _buildPulseItem(
                context,
                'Pending Approvals',
                health['pendingApprovals']?.toString() ?? '0',
                Icons.gavel_rounded,
                color: AppTheme.accentOrange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPulseItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.w,
          color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.redHatDisplay(
            fontWeight: FontWeight.bold,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
