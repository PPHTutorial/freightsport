import 'package:rightlogistics/src/features/admin/domain/admin_models.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';

/// Admin Repository Interface
/// Provides CRUD operations for all collections that require admin management
abstract class AdminRepository {
  // ========== User Management ==========
  Stream<List<UserModel>> watchAllUsers();
  Future<List<UserModel>> getAllUsers();
  Future<UserModel?> getUserById(String userId);
  Future<void> createUser(UserModel user, String password);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String userId);
  Future<List<UserModel>> searchUsers(String query);
  Future<List<UserModel>> getUsersByRole(UserRole role);

  // ========== Vendor Quotations ==========
  Stream<List<VendorQuotation>> watchQuotations({String? vendorId});
  Future<List<VendorQuotation>> getActiveQuotations({String? vendorId});
  Future<VendorQuotation?> getQuotationById(String quotationId);
  Future<void> createQuotation(VendorQuotation quotation);
  Future<void> updateQuotation(VendorQuotation quotation);
  Future<void> deleteQuotation(String quotationId);
  Future<void> toggleQuotationStatus(String quotationId, bool isActive);

  // ========== Broadcast Messages ==========
  Stream<List<BroadcastMessage>> watchBroadcasts();
  Future<List<BroadcastMessage>> getAllBroadcasts();
  Future<BroadcastMessage?> getBroadcastById(String broadcastId);
  Future<void> createBroadcast(BroadcastMessage broadcast);
  Future<void> updateBroadcast(BroadcastMessage broadcast);
  Future<void> deleteBroadcast(String broadcastId);
  Future<void> sendBroadcast(String broadcastId);
  Future<void> markBroadcastAsRead(String broadcastId, String userId);

  // ========== Social Posts Management ==========
  Stream<List<VendorPost>> watchAllPosts();
  Future<List<VendorPost>> getAllPosts({PostType? type, String? vendorId});
  Future<void> createPost(VendorPost post);
  Future<void> updatePost(VendorPost post);
  Future<void> deletePost(String postId);
  Future<List<VendorPost>> searchPosts(String query);

  // ========== Comments Moderation ==========
  Stream<List<PostComment>> watchAllComments({String? postId});
  Future<List<PostComment>> getCommentsByPost(String postId);
  Future<void> deleteComment(String commentId);
  Future<List<PostComment>> searchComments(String query);

  // ========== Warehouses Management ==========
  Stream<List<LogisticsWarehouse>> watchWarehouses({String? vendorId});
  Future<List<LogisticsWarehouse>> getAllWarehouses();
  Future<LogisticsWarehouse?> getWarehouseById(String warehouseId);
  Future<void> createWarehouse(LogisticsWarehouse warehouse);
  Future<void> updateWarehouse(LogisticsWarehouse warehouse);
  Future<void> deleteWarehouse(String warehouseId);

  // ========== Courier Assignments Management ==========
  Stream<List<CourierAssignment>> watchAssignments({String? courierId});
  Future<List<CourierAssignment>> getAllAssignments();
  Future<void> createAssignment(CourierAssignment assignment);
  Future<void> updateAssignment(CourierAssignment assignment);
  Future<void> deleteAssignment(String assignmentId);
  Future<void> reassignCourier(String assignmentId, String newCourierId);

  // ========== Shipments Management (Extended) ==========
  Stream<List<Shipment>> watchAllShipments();
  Future<List<Shipment>> searchShipments(String query);
  Future<void> updateShipmentStatus(
    String shipmentId,
    ShipmentStatusType status,
    String note,
  );

  // ========== Audit & Analytics ==========
  Future<Map<String, dynamic>> getDashboardStats();
  Future<Map<ShipmentStatusType, int>> getShipmentStatusStats();
  Future<List<Map<String, dynamic>>> getDailyRevenueStats(int days);

  Future<List<AuditLog>> getAuditLogs({
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    int limit = 50,
  });

  Future<void> createAuditLog(AuditLog log);
}
