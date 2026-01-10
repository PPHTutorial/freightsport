import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/widgets/admin_dashboard_view.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/widgets/courier_dashboard_view.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/widgets/customer_dashboard_view.dart';
import 'package:rightlogistics/src/features/dashboard/presentation/widgets/vendor_dashboard_view.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    switch (user.role) {
      case UserRole.admin:
        return AdminDashboardView();
      case UserRole.vendor:
        return VendorDashboardView();
      case UserRole.courier:
        return CourierDashboardView();
      case UserRole.customer:
        return CustomerDashboardView();
    }
  }
}
