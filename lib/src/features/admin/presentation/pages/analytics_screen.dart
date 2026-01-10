import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/admin/presentation/providers/admin_providers.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusStatsAsync = ref.watch(shipmentStatusStatsProvider);
    final revenueStatsAsync = ref.watch(dailyRevenueStatsProvider(7));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Analytics')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shipment Distribution',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Container(
              height: 300.h,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16.w),
              ),
              child: statusStatsAsync.when(
                data: (stats) => _ShipmentPieChart(stats: stats),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Revenue Trend (Last 7 Days)',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Container(
              height: 300.h,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16.w),
              ),
              child: revenueStatsAsync.when(
                data: (data) => _RevenueLineChart(data: data),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShipmentPieChart extends StatelessWidget {
  final Map<ShipmentStatusType, int> stats;
  const _ShipmentPieChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final total = stats.values.fold(0, (a, b) => a + b);
    if (total == 0) return const Center(child: Text('No shipment data'));

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: stats.entries.map((entry) {
          final color = _getColorForStatus(entry.key);
          final value = entry.value.toDouble();
          final percentage = (value / total * 100).toStringAsFixed(1);

          return PieChartSectionData(
            color: color,
            value: value,
            title: '$percentage%',
            radius: 50,
            titleStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getColorForStatus(ShipmentStatusType status) {
    switch (status) {
      case ShipmentStatusType.created:
        return Colors.blueGrey;
      case ShipmentStatusType.pickedUp:
        return Colors.blue;
      case ShipmentStatusType.inTransit:
        return Colors.orange;
      case ShipmentStatusType.outForDelivery:
        return Colors.purple;
      case ShipmentStatusType.delivered:
        return Colors.green;
      case ShipmentStatusType.failedAttempt:
        return Colors.red;
      case ShipmentStatusType.cancelled:
        return Colors.black54;
    }
  }
}

class _RevenueLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const _RevenueLineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (data.isEmpty) return const Center(child: Text('No revenue data'));

    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), (e.value['amount'] as double));
    }).toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < data.length) {
                  final dateStr = data[value.toInt()]['date'] as String;
                  // Format 'yyyy-MM-dd' to 'MM/dd'
                  final date = DateTime.parse(dateStr);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat('MM/dd').format(date),
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: colorScheme.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: colorScheme.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
