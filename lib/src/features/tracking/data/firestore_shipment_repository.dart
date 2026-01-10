import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/tracking/data/shipment_repository.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:rightlogistics/src/features/notifications/data/notifications_repository.dart';
import 'package:rightlogistics/src/features/notifications/domain/notification_model.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreShipmentRepository implements ShipmentRepository {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  FirestoreShipmentRepository(this._firestore, this._ref);

  CollectionReference<Shipment> get _shipmentsRef => _firestore
      .collection('shipments')
      .withConverter<Shipment>(
        fromFirestore: (doc, _) =>
            Shipment.fromJson(doc.data()!..['id'] = doc.id),
        toFirestore: (shipment, _) => shipment.toJson()..remove('id'),
      );

  @override
  Future<void> createShipment(Shipment shipment) async {
    await _shipmentsRef.doc(shipment.trackingNumber).set(shipment);

    // Notify Sender
    await _ref
        .read(notificationRepositoryProvider)
        .sendNotification(
          NotificationModel(
            id: '',
            title: 'Shipment Created',
            message:
                'Your shipment ${shipment.trackingNumber} has been placed successfully.',
            type: NotificationType.shipment,
            timestamp: DateTime.now(),
            targetUserId: shipment.senderId,
            relatedShipmentId: shipment.trackingNumber,
            senderId: 'system',
            senderName: 'RightLogistics',
          ),
        );

    // Notify Vendor
    if (shipment.vendorId != null) {
      await _ref
          .read(notificationRepositoryProvider)
          .sendNotification(
            NotificationModel(
              id: '',
              title: 'New Shipment Request',
              message:
                  'You have a new shipment request (${shipment.trackingNumber}) waiting for approval.',
              type: NotificationType.shipment,
              timestamp: DateTime.now(),
              targetUserId: shipment.vendorId,
              relatedShipmentId: shipment.trackingNumber,
              senderId: shipment.senderId,
              senderName: shipment.senderName,
            ),
          );
    }
  }

  @override
  Future<Shipment?> getShipmentByTrackingNumber(String trackingNumber) async {
    final doc = await _shipmentsRef.doc(trackingNumber).get();
    return doc.data();
  }

  @override
  Future<List<Shipment>> getShipmentsForCourier(String courierId) async {
    final snapshot = await _shipmentsRef
        .where('assignedCourierId', isEqualTo: courierId)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<List<Shipment>> getShipmentsForUser(String userId) async {
    // Fetch shipments where user is sender
    final senderQuery = _shipmentsRef
        .where('senderId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    // Fetch shipments where user is recipient
    final recipientQuery = _shipmentsRef
        .where('recipientId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    final results = await Future.wait([senderQuery, recipientQuery]);

    // Combine and remove duplicates (though unlikely)
    final allShipments = <String, Shipment>{};
    for (var snapshot in results) {
      for (var doc in snapshot.docs) {
        allShipments[doc.id] = doc.data();
      }
    }

    final sortedList = allShipments.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return sortedList;
  }

  @override
  Future<void> updateShipmentStatus(
    String shipmentId,
    ShipmentEvent event,
  ) async {
    final docRef = _shipmentsRef.doc(shipmentId);

    // Transaction to ensure atomic update of status and events list
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) throw Exception('Shipment not found');

      final shipment = snapshot.data()!;
      var events = List<ShipmentEvent>.from(shipment.events);
      events.add(event);

      // Determine the JSON value for the status manually to match @JsonValue
      final statusMap = {
        ShipmentStatusType.created: 'created',
        ShipmentStatusType.pickedUp: 'picked_up',
        ShipmentStatusType.inTransit: 'in_transit',
        ShipmentStatusType.outForDelivery: 'out_for_delivery',
        ShipmentStatusType.delivered: 'delivered',
        ShipmentStatusType.failedAttempt: 'failed_attempt',
        ShipmentStatusType.cancelled: 'cancelled',
      };

      transaction.update(docRef, {
        'currentStatus': statusMap[event.status],
        'events': events.map((e) => e.toJson()).toList(),
      });
    });
  }

  @override
  Stream<Shipment?> watchShipment(String trackingNumber) {
    return _shipmentsRef
        .doc(trackingNumber)
        .snapshots()
        .map((doc) => doc.data());
  }

  @override
  Stream<List<Shipment>> watchAllShipments() {
    return _shipmentsRef
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Stream<List<Shipment>> watchShipmentsForCourier(String courierId) {
    return _shipmentsRef
        .where('assignedCourierId', isEqualTo: courierId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Stream<List<Shipment>> watchShipmentsForUser(String userId) {
    final senderStream = _shipmentsRef
        .where('senderId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();

    final recipientStream = _shipmentsRef
        .where('recipientId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Rx.combineLatest2(senderStream, recipientStream, (
      senderSnapshot,
      recipientSnapshot,
    ) {
      final allShipments = <String, Shipment>{};

      for (var doc in senderSnapshot.docs) {
        allShipments[doc.id] = doc.data();
      }
      for (var doc in recipientSnapshot.docs) {
        allShipments[doc.id] = doc.data();
      }

      final sortedList = allShipments.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return sortedList;
    });
  }

  @override
  Stream<List<Shipment>> watchShipmentsForVendor(String vendorId) {
    return _shipmentsRef
        .where('vendorId', isEqualTo: vendorId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Future<void> approveShipment(String shipmentId) async {
    final docRef = _shipmentsRef.doc(shipmentId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) throw Exception('Shipment not found');

      final shipment = snapshot.data()!;
      var events = List<ShipmentEvent>.from(shipment.events);
      events.add(
        ShipmentEvent(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          status: ShipmentStatusType
              .created, // Remains created until picked up? Or custom status?
          // Actually, approval moves it to 'approved' if we had that status, but 'created' is fine.
          // Maybe we change approvalStatus only.
          timestamp: DateTime.now(),
          location: const ShipmentLocation(
            latitude: 0,
            longitude: 0,
            address: 'Online',
          ),
          note: 'Vendor Approved Shipment',
        ),
      );

      transaction.update(docRef, {
        'approvalStatus': 'approved',
        'events': events.map((e) => e.toJson()).toList(),
      });
    });

    // Notify Sender
    final docSnapshot = await _shipmentsRef.doc(shipmentId).get();

    final shipmentData = docSnapshot.data();
    if (shipmentData != null) {
      await _ref
          .read(notificationRepositoryProvider)
          .sendNotification(
            NotificationModel(
              id: '',
              title: 'Shipment Approved',
              message:
                  'Your shipment ${shipmentData.trackingNumber} has been approved by the vendor.',
              type: NotificationType.shipment,
              timestamp: DateTime.now(),
              targetUserId: shipmentData.senderId,
              relatedShipmentId: shipmentData.trackingNumber,
              senderId: shipmentData.vendorId, // Vendor ID
              senderName: 'Vendor',
            ),
          );
    }
  }

  @override
  Future<void> rejectShipment(String shipmentId, String reason) async {
    final docRef = _shipmentsRef.doc(shipmentId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) throw Exception('Shipment not found');

      final shipment = snapshot.data()!;
      var events = List<ShipmentEvent>.from(shipment.events);

      List<String> alternatives = List<String>.from(
        shipment.alternativeVendorIds,
      );

      if (alternatives.isNotEmpty) {
        // Cascade to next vendor
        final nextVendorId = alternatives.removeAt(0);

        events.add(
          ShipmentEvent(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            status: shipment.currentStatus,
            timestamp: DateTime.now(),
            location: const ShipmentLocation(
              latitude: 0,
              longitude: 0,
              address: 'Online',
            ),
            note: 'Vendor declined: $reason. Auto-assigned to next vendor.',
          ),
        );

        transaction.update(docRef, {
          'vendorId': nextVendorId,
          'alternativeVendorIds': alternatives,
          'approvalStatus': 'pending',
          'events': events.map((e) => e.toJson()).toList(),
        });
      } else {
        // No more vendors, fully reject
        events.add(
          ShipmentEvent(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            status: ShipmentStatusType.cancelled,
            timestamp: DateTime.now(),
            location: const ShipmentLocation(
              latitude: 0,
              longitude: 0,
              address: 'Online',
            ),
            note: 'Vendor declined: $reason. No alternative vendors available.',
          ),
        );

        transaction.update(docRef, {
          'approvalStatus': 'rejected',
          'currentStatus': 'cancelled',
          'events': events.map((e) => e.toJson()).toList(),
        });
      }
    });
  }

  @override
  Stream<List<LogisticsWarehouse>> watchWarehouses({String? vendorId}) {
    Query query = _firestore.collection('warehouses');
    if (vendorId != null) {
      query = query.where('vendorId', isEqualTo: vendorId);
    }

    return query
        .withConverter<LogisticsWarehouse>(
          fromFirestore: (doc, _) => LogisticsWarehouse.fromJson(
            doc.data() as Map<String, dynamic>..['id'] = doc.id,
          ),
          toFirestore: (warehouse, _) => warehouse.toJson()..remove('id'),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}

final warehousesStreamProvider =
    StreamProvider.family<List<LogisticsWarehouse>, String?>((ref, vendorId) {
      final repository = ref.watch(shipmentRepositoryProvider);
      return repository.watchWarehouses(vendorId: vendorId);
    });
