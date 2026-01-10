import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/tracking/data/firestore_shipment_repository.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';

abstract class ShipmentRepository {
  Future<Shipment?> getShipmentByTrackingNumber(String trackingNumber);
  Future<List<Shipment>> getShipmentsForCourier(String courierId);
  Future<List<Shipment>> getShipmentsForUser(String userId); // Sender/Recipient
  Stream<Shipment?> watchShipment(String trackingNumber);
  Stream<List<Shipment>> watchAllShipments();
  Future<void> updateShipmentStatus(String shipmentId, ShipmentEvent event);
  Future<void> createShipment(Shipment shipment);
  Stream<List<Shipment>> watchShipmentsForCourier(String courierId);
  Stream<List<Shipment>> watchShipmentsForUser(String userId);
  Stream<List<Shipment>> watchShipmentsForVendor(String vendorId);
  Future<void> approveShipment(String shipmentId);
  Future<void> rejectShipment(String shipmentId, String reason);
  Stream<List<LogisticsWarehouse>> watchWarehouses({String? vendorId});
}

class MockShipmentRepository implements ShipmentRepository {
  @override
  Stream<List<LogisticsWarehouse>> watchWarehouses({String? vendorId}) {
    return Stream.value([
      LogisticsWarehouse(
        id: 'wh1',
        name: 'Main Hub - New York',
        address: '123 Logistics Way, NY',
        vendorId: 'v1',
        location: const ShipmentLocation(
          latitude: 40.7128,
          longitude: -74.0060,
          address: 'NY Hub',
          city: 'New York',
          country: 'USA',
          street: '123 Logistics Way',
          state: 'NY',
          zip: '10001',
        ),
      ),
    ]);
  }

  @override
  Future<void> approveShipment(String shipmentId) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> rejectShipment(String shipmentId, String reason) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> createShipment(Shipment shipment) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<Shipment?> getShipmentByTrackingNumber(String trackingNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    if (trackingNumber == '123456') {
      return Shipment(
        id: '1',
        trackingNumber: '123456',
        senderName: 'Acme Corp',
        senderAddress: '123 Warehouse St, New York, NY',
        senderPhone: '+1 555-0101',
        recipientName: 'John Doe',
        recipientAddress: '456 residential Ave, Austin, TX',
        recipientPhone: '+1 555-0202',
        currentStatus: ShipmentStatusType.inTransit,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        estimatedDeliveryDate: DateTime.now().add(const Duration(days: 1)),
        totalWeight: 5.5,
        totalPrice: 150.0,
        packages: [
          ShipmentPackage(
            id: 'pkg1',
            name: 'Box 1',
            items: [
              ShipmentItem(
                name: 'Widget',
                description: 'Box of Widgets',
                itemType: 'Box',
                category: 'General',
                quantity: 5,
                weight: 1.1,
                declaredValue: 30.0,
                currency: 'USD',
                isPerishable: false,
                isFragile: false,
                color: 'Brown',
              ),
            ],
            totalWeight: 5.5,
          ),
        ],
        events: [
          ShipmentEvent(
            id: 'e1',
            status: ShipmentStatusType.created,
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            location: const ShipmentLocation(
              latitude: 40.7128,
              longitude: -74.0060,
              address: 'New York, NY',
            ),
            note: 'Shipment created',
          ),
          ShipmentEvent(
            id: 'e2',
            status: ShipmentStatusType.pickedUp,
            timestamp: DateTime.now().subtract(
              const Duration(days: 2, hours: 2),
            ),
            location: const ShipmentLocation(
              latitude: 40.7128,
              longitude: -74.0060,
              address: 'New York, NY',
            ),
            note: 'Picked up by courier',
          ),
          ShipmentEvent(
            id: 'e3',
            status: ShipmentStatusType.inTransit,
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            location: const ShipmentLocation(
              latitude: 35.1495,
              longitude: -90.0490,
              address: 'Memphis, TN',
            ),
            note: 'Arrived at hub',
          ),
        ],
      );
    }
    return null;
  }

  @override
  Future<List<Shipment>> getShipmentsForCourier(String courierId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  @override
  Future<List<Shipment>> getShipmentsForUser(String userId) async {
    // Return mock data for dashboard testing
    return [
      Shipment(
        id: '1',
        trackingNumber: '123456',
        senderName: 'Acme Corp',
        senderAddress: 'NY',
        senderPhone: '123',
        recipientName: 'John',
        recipientAddress: 'TX',
        recipientPhone: '456',
        currentStatus: ShipmentStatusType.inTransit,
        createdAt: DateTime.now(),
        estimatedDeliveryDate: DateTime.now().add(const Duration(days: 2)),
        events: [],
        packages: [
          ShipmentPackage(
            id: 'pkg_mock',
            name: 'Test Package',
            items: [
              ShipmentItem(
                name: 'Test Item',
                description: 'Test Description',
                itemType: 'Unit',
                category: 'General',
                quantity: 1,
                weight: 1.0,
                declaredValue: 10.0,
                currency: 'USD',
                isPerishable: false,
                isFragile: false,
                color: 'N/A',
              ),
            ],
            totalWeight: 1.0,
          ),
        ],
      ),
    ];
  }

  @override
  Future<void> updateShipmentStatus(
    String shipmentId,
    ShipmentEvent event,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Stream<Shipment?> watchShipment(String trackingNumber) {
    return Stream.fromFuture(getShipmentByTrackingNumber(trackingNumber));
  }

  @override
  Stream<List<Shipment>> watchAllShipments() async* {
    yield [];
  }

  @override
  Stream<List<Shipment>> watchShipmentsForCourier(String courierId) {
    return Stream.value([]);
  }

  @override
  Stream<List<Shipment>> watchShipmentsForUser(String userId) {
    return Stream.value([]);
  }

  @override
  Stream<List<Shipment>> watchShipmentsForVendor(String vendorId) {
    return Stream.value([]);
  }
}

final shipmentRepositoryProvider = Provider<ShipmentRepository>((ref) {
  return FirestoreShipmentRepository(FirebaseFirestore.instance, ref);
});
