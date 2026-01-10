import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/widgets/courier_dashboard_view.dart';

class CourierDashboardScreen extends ConsumerWidget {
  const CourierDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CourierDashboardView();
  }
}
