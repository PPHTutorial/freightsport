import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';

class DashboardAnalyticsSection extends StatelessWidget {
  final List<Shipment> shipments;
  final bool isAdmin;

  const DashboardAnalyticsSection({
    super.key,
    required this.shipments,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    if (shipments.isEmpty) {
      return _buildEmptyState(context);
    }

    final stats = _calculateStats();
    final dailyData = _calculateDailyStats();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Performance Analytics',
              style: GoogleFonts.redHatDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: -0.5,
              ),
            ),
            _buildTimeToggle(context),
          ],
        ),
        SizedBox(height: 24.h),

        // Interactive Metric Tiles (FilterTiles concept)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterTile(
                label: 'TOTAL ORDERS',
                value: stats['total'].toString(),
                icon: Icons.inventory_2_outlined,
                color: Theme.of(context).colorScheme.primary,
                isSelected: true,
              ),
              SizedBox(width: 16.w),
              _FilterTile(
                label: 'DELIVERED',
                value: stats['delivered'].toString(),
                icon: Icons.check_circle_outline,
                color: AppTheme.successGreen,
              ),
              SizedBox(width: 16.w),
              _FilterTile(
                label: 'ACTIVE',
                value: stats['active'].toString(),
                icon: Icons.local_shipping_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
              SizedBox(width: 16.w),
              _FilterTile(
                label: 'ISSUES',
                value: stats['delayed'].toString(),
                icon: Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ),
        SizedBox(height: 32.h),

        // Charts Section
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildChartCard(
                context,
                'Volume Trend',
                'Historical activity (Last 7 Days)',
                _buildLineChart(context, dailyData),
              ),
              SizedBox(width: 16.w),
              _buildChartCard(
                context,
                'Status Distribution',
                'Live order mix',
                _buildPieChart(context, stats),
              ),
              SizedBox(width: 16.w),
              _buildChartCard(
                context,
                'Daily Performance',
                'Delivery vs Target',
                _buildBarChart(context, stats, dailyData),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bar_chart_rounded,
              size: 40.w,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Analytics Data Yet',
            style: GoogleFonts.redHatDisplay(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Generate test shipments to see real-time performance metrics and logistics insights.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
          SizedBox(height: 32.h),
          ElevatedButton.icon(
            onPressed: () => context.push('/seeding'),
            icon: Icon(Icons.bolt_rounded, size: 20.w, color: Colors.white),
            label: Text(
              'Seed Sample Data',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeToggle(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Row(
        children: [
          _TimeOption(label: '7D', isSelected: true),
          _TimeOption(label: '30D'),
        ],
      ),
    );
  }

  Map<String, int> _calculateStats() {
    return {
      'active': shipments
          .where(
            (s) =>
                s.currentStatus != ShipmentStatusType.delivered &&
                s.currentStatus != ShipmentStatusType.cancelled &&
                s.currentStatus != ShipmentStatusType.failedAttempt,
          )
          .length,
      'delivered': shipments
          .where((s) => s.currentStatus == ShipmentStatusType.delivered)
          .length,
      'delayed': shipments
          .where((s) => s.currentStatus == ShipmentStatusType.failedAttempt)
          .length,
      'total': shipments.length,
    };
  }

  List<Map<String, dynamic>> _calculateDailyStats() {
    final now = DateTime.now();
    final last7Days = List.generate(
      7,
      (i) => now.subtract(Duration(days: 6 - i)),
    );

    return last7Days.map((date) {
      final dayDelivered = shipments.where((s) {
        if (s.currentStatus != ShipmentStatusType.delivered) return false;
        try {
          final event = s.events.firstWhere(
            (e) => e.status == ShipmentStatusType.delivered,
          );
          return event.timestamp.year == date.year &&
              event.timestamp.month == date.month &&
              event.timestamp.day == date.day;
        } catch (_) {
          return s.createdAt.year == date.year &&
              s.createdAt.month == date.month &&
              s.createdAt.day == date.day;
        }
      });

      final dayTotal = shipments.where(
        (s) =>
            s.createdAt.year == date.year &&
            s.createdAt.month == date.month &&
            s.createdAt.day == date.day,
      );

      return {
        'date': date,
        'total': dayTotal.length.toDouble(),
        'delivered': dayDelivered.length.toDouble(),
        'delayed': dayTotal
            .where((s) => s.currentStatus == ShipmentStatusType.failedAttempt)
            .length
            .toDouble(),
      };
    }).toList();
  }

  Widget _buildChartCard(
    BuildContext context,
    String title,
    String subtitle,
    Widget chart,
  ) {
    return Container(
      width: 320.w,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.05),
        ),
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
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 24.h),
          SizedBox(height: 180.h, child: chart),
        ],
      ),
    );
  }

  Widget _buildPieChart(BuildContext context, Map<String, int> stats) {
    final total = stats['total']!.toDouble();
    if (total == 0) return const Center(child: Text('No data'));

    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 40.w,
        sections: [
          PieChartSectionData(
            value: stats['active']!.toDouble(),
            color: Theme.of(context).colorScheme.secondary,
            title: '',
            radius: 20.w,
          ),
          PieChartSectionData(
            value: stats['delivered']!.toDouble(),
            color: AppTheme.successGreen,
            title: '',
            radius: 20.w,
          ),
          PieChartSectionData(
            value: stats['delayed']!.toDouble(),
            color: Theme.of(context).colorScheme.error,
            title: '',
            radius: 20.w,
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(
    BuildContext context,
    List<Map<String, dynamic>> dailyData,
  ) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: dailyData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value['total']))
                .toList(),
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3.w,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(
    BuildContext context,
    Map<String, int> stats,
    List<Map<String, dynamic>> dailyData,
  ) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY:
            (dailyData
                        .map((e) => e['total'] as double)
                        .reduce((a, b) => a > b ? a : b) *
                    1.5)
                .toDouble()
                .clamp(10, 1000),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Theme.of(context).colorScheme.surface,
          ),
        ),
        titlesData: const FlTitlesData(show: false),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: dailyData.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value['delivered'],
                color: AppTheme.successGreen,
                width: 8.w,
                borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
              ),
              BarChartRodData(
                toY: e.value['total'],
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                width: 8.w,
                borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _FilterTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isSelected;

  const _FilterTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: isSelected ? color : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24.w),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 15.w,
                  offset: Offset(0, 8.h),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isSelected ? Colors.white : color, size: 24.w),
          SizedBox(height: 16.h),
          Text(
            value,
            style: GoogleFonts.redHatDisplay(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white.withOpacity(0.8)
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeOption extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _TimeOption({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: isSelected
              ? Colors.white
              : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
