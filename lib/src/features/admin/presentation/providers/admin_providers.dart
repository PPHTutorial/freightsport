import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/admin/data/admin_repository.dart';
import 'package:rightlogistics/src/features/admin/data/firebase_admin_repository.dart';
import 'package:rightlogistics/src/features/admin/domain/admin_models.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';

// ========== Repository Provider ==========

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return FirebaseAdminRepository();
});

// ========== User Management Providers ==========

final allUsersProvider = StreamProvider<List<UserModel>>((ref) {
  return ref.watch(adminRepositoryProvider).watchAllUsers();
});

final usersByRoleProvider = FutureProvider.family<List<UserModel>, UserRole>((
  ref,
  role,
) {
  return ref.read(adminRepositoryProvider).getUsersByRole(role);
});

// ========== Quotations Providers ==========

final quotationsProvider =
    StreamProvider.family<List<VendorQuotation>, String?>((ref, vendorId) {
      return ref
          .watch(adminRepositoryProvider)
          .watchQuotations(vendorId: vendorId);
    });

final activeQuotationsProvider =
    FutureProvider.family<List<VendorQuotation>, String?>((ref, vendorId) {
      return ref
          .read(adminRepositoryProvider)
          .getActiveQuotations(vendorId: vendorId);
    });

// ========== Broadcasts Providers ==========

final broadcastsProvider = StreamProvider<List<BroadcastMessage>>((ref) {
  return ref.watch(adminRepositoryProvider).watchBroadcasts();
});

// ========== Posts Management Providers ==========

final allPostsProvider = StreamProvider<List<VendorPost>>((ref) {
  return ref.watch(adminRepositoryProvider).watchAllPosts();
});

final postsByTypeProvider = FutureProvider.family<List<VendorPost>, PostType>((
  ref,
  type,
) async {
  return ref.read(adminRepositoryProvider).getAllPosts(type: type);
});

// ========== Comments Management Providers ==========

final allCommentsProvider = StreamProvider.family<List<PostComment>, String?>((
  ref,
  postId,
) {
  return ref.watch(adminRepositoryProvider).watchAllComments(postId: postId);
});

// ========== Warehouses Providers ==========

final warehousesProvider =
    StreamProvider.family<List<LogisticsWarehouse>, String?>((ref, vendorId) {
      return ref
          .watch(adminRepositoryProvider)
          .watchWarehouses(vendorId: vendorId);
    });

// ========== Assignments Providers ==========

final assignmentsProvider =
    StreamProvider.family<List<CourierAssignment>, String?>((ref, courierId) {
      return ref
          .watch(adminRepositoryProvider)
          .watchAssignments(courierId: courierId);
    });

// ========== Shipments Provider ==========

final allShipmentsProvider = StreamProvider<List<Shipment>>((ref) {
  return ref.watch(adminRepositoryProvider).watchAllShipments();
});

// ========== Dashboard Stats Provider ==========

final dashboardStatsProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.read(adminRepositoryProvider).getDashboardStats();
});

final shipmentStatusStatsProvider =
    FutureProvider<Map<ShipmentStatusType, int>>((ref) {
      return ref.read(adminRepositoryProvider).getShipmentStatusStats();
    });

final dailyRevenueStatsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, int>((ref, days) {
      return ref.read(adminRepositoryProvider).getDailyRevenueStats(days);
    });

// ========== Audit Logs Provider ==========

final auditLogsProvider = FutureProvider<List<AuditLog>>((ref) {
  return ref.read(adminRepositoryProvider).getAuditLogs(limit: 100);
});
