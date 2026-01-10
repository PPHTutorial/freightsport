import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/social/domain/status_model.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:rightlogistics/src/features/notifications/domain/notification_model.dart';
import 'package:uuid/uuid.dart';

final seedingServiceProvider = Provider<SeedingService>((ref) {
  return SeedingService();
});

typedef ProgressCallback = void Function(double progress, String message);

class SeedingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _uuid = const Uuid();
  final _random = Random();

  SeedingService();

  Future<void> seedAll() async {
    print('🌱 Starting Database Seeding (Scale: 100 Users)...');

    // 1. Create Real Auth Users using createUserWithEmailAndPassword
    final users = await seedUsers();
    print('✅ Seeded ${users.length} Users');

    if (users.isEmpty) {
      print('❌ No users created. Aborting.');
      return;
    }

    // 2. Seed Warehouses
    await seedWarehouses();
    print('✅ Seeded Warehouses');

    // 3. Create Shipments (Scale up)
    await seedShipments(users: users);
    print('✅ Seeded Shipments');

    // 3.1 Assign Couriers (New)
    await seedCourierAssignments();
    print('✅ Seeded Courier Assignments');

    // 4. Create Social Content (Scale up)
    await seedSocial(users: users);
    print('✅ Seeded Social Content');

    // 4. Create Chats
    await seedChats(users: users);
    print('✅ Seeded Chats');

    print('🌳 Database Seeding Complete!');
  }

  Future<List<UserModel>> seedUsers({
    int adminCount = 5,
    int vendorCount = 20,
    int courierCount = 15,
    int customerCount = 60,
    ProgressCallback? onProgress,
  }) async {
    List<UserModel> users = [];
    final currentPassword =
        'password123'; // Default password for all seed users

    // Distribution
    final targets = [
      (role: UserRole.admin, count: adminCount, prefix: 'admin'),
      (role: UserRole.vendor, count: vendorCount, prefix: 'vendor'),
      (role: UserRole.courier, count: courierCount, prefix: 'courier'),
      (role: UserRole.customer, count: customerCount, prefix: 'customer'),
    ];

    int globalIndex = 0;

    for (var target in targets) {
      if (target.count == 0) continue;
      for (var i = 1; i <= target.count; i++) {
        globalIndex++;
        final progress =
            globalIndex /
            (adminCount + vendorCount + courierCount + customerCount);
        onProgress?.call(
          progress,
          'Creating ${target.prefix} $i of ${target.count}...',
        );
        final email = '${target.prefix}$i@test.com';
        final name = '${_capitalize(target.prefix)} $i';
        final username = '${target.prefix}_$i';

        String? uid;

        // 1. Create in Firebase Auth
        try {
          // Check if user exists by trying to sign in (or just try create and catch)
          // Since we want to ensure fresh data, let's try creation.
          // If it fails (email-already-in-use), we'll try to sign in to get the UID and overwrite data.
          // Note: In a real app we can't get UID from create failure easily without sign-in.
          // For simplicity, we try create. If fails, we skip auth creation and assume existing UID logic or try sign-in.

          try {
            final cred = await _auth.createUserWithEmailAndPassword(
              email: email,
              password: currentPassword,
            );
            uid = cred.user?.uid;
            print('✅ Created Auth User: $email');
          } on FirebaseAuthException catch (e) {
            if (e.code == 'email-already-in-use') {
              try {
                final cred = await _auth.signInWithEmailAndPassword(
                  email: email,
                  password: currentPassword,
                );
                uid = cred.user?.uid;
                print('ℹ️ Re-used Auth User: $email');
              } catch (signInErr) {
                print(
                  '❌ FAILED to recover existing user $email: $signInErr (Likely password mismatch)',
                );
              }
            } else {
              print('❌ FAILED to create auth for $email: ${e.message}');
            }
          }
        } catch (e) {
          print('    Unexpected auth error for $email: $e');
        }

        if (uid == null) {
          // Fallback: If we really can't get an Auth UID, we shouldn't create a firestore doc
          // because they won't be able to login. Skip.
          // OR: Generate a fake one for "view-only" testing if auth is broken.
          // User insisted on "signed in with createuser...", so we strictly need real auth.
          print('    SKIPPING $email: Could not authenticate.');
          continue;
        }

        final location = _randomGlobalLocation();

        final user = UserModel(
          id: uid,
          email: email,
          name: name,
          username: username,
          role: target.role,
          isProfileComplete: true,
          verificationStatus: VerificationStatus.verified,
          phoneNumber: _generatePhoneNumber(),
          photoUrl:
              'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=random&size=200&bold=true',

          // Structured Address
          address: AddressInfo(
            street: '${_random.nextInt(999)} Main St',
            suburb: 'District ${_random.nextInt(10)}',
            city: location.city,
            state: 'Province ${_random.nextInt(20)}',
            zip: '${_random.nextInt(99999)}',
            country: location.country,
            countryCode: _getCountryCode(location.country),
            currency: _getCurrency(location.country),
            fullAddress:
                '${_random.nextInt(999)} Main St, ${location.city}, ${location.country}',
          ),

          // Identity Info
          identity: IdentityInfo(
            idType: 'National ID',
            idNumber: 'ID-${_random.nextInt(999999)}',
            idUploaded: true,
            submittedAt: DateTime.now()
                .subtract(Duration(days: _random.nextInt(100)))
                .toIso8601String(),
          ),

          // Vendor-specific data
          vendorKyc: target.role == UserRole.vendor
              ? VendorKyc(
                  businessName: '$name Logistics',
                  businessRegNumber: 'REG-${_random.nextInt(999999)}',
                  businessDescription:
                      'Global logistics and freight forwarding services with ${_random.nextInt(20) + 5} years of experience.',
                  vendorPhones: [
                    {'label': 'Main Office', 'number': _generatePhoneNumber()},
                    {'label': 'Support', 'number': _generatePhoneNumber()},
                  ],
                  vendorAddresses: [
                    {
                      'label': 'Headquarters',
                      'street': '${_random.nextInt(999)} Business Ave',
                      'city': location.city,
                      'country': location.country,
                    },
                  ],
                  vendorSocials: [
                    {'platform': 'WhatsApp', 'handle': _generatePhoneNumber()},
                    {
                      'platform': 'Instagram',
                      'handle': '@${username}_official',
                    },
                  ],
                  vendorServices: [
                    ['Air Freight', 'Sea Freight', 'Road Transport'][_random
                        .nextInt(3)],
                  ],
                  vendorRates: [
                    {
                      'service': 'Air Freight',
                      'type': 'Normal',
                      'category': 'Normal',
                      'currency': 'USD',
                      'amount': '${_random.nextInt(50) + 20}',
                      'unit': 'Kg',
                    },
                  ],
                  vendorRoutes: [
                    {
                      'origin': location.city,
                      'destination': _randomGlobalLocation().city,
                    },
                  ],
                  vendorFAQs: [
                    {
                      'question': 'Do you ship internationally?',
                      'answer': 'Yes, we ship to over 50 countries worldwide.',
                    },
                  ],
                )
              : null,

          // Courier-specific data
          courierKyc: target.role == UserRole.courier
              ? CourierKyc(
                  vehicleType: [
                    'Van',
                    'Truck',
                    'Motorcycle',
                  ][_random.nextInt(3)],
                  vehicleRegNumber: 'VEH-${_random.nextInt(99999)}',
                )
              : null,

          // Company branding (for vendors)
          companyLogo: target.role == UserRole.vendor
              ? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=random&size=200&bold=true'
              : null,
          companyBanner: target.role == UserRole.vendor
              ? 'https://picsum.photos/seed/${_random.nextInt(9999)}/1200/400'
              : null,

          // Rating fields (will be populated by review seeding)
          averageRating: 0.0,
          totalReviews: 0,
          ratingBreakdown: {},

          // Clear legacy data
          kycData: null,
        );

        // 3. Write to Firestore
        await _firestore.collection('users').doc(uid).set(user.toJson());

        // Update Auth Profile (Display Name & Photo) for consistency
        if (_auth.currentUser?.uid == uid) {
          await _auth.currentUser?.updateDisplayName(name);
          await _auth.currentUser?.updatePhotoURL(user.photoUrl);
        }

        users.add(user);

        // Throttle slightly to avoid heavy rate limits if needed,
        // but 100 isn't massive.
        if (globalIndex % 10 == 0) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    }
    return users;
  }

  Future<void> seedShipments({
    List<UserModel>? users,
    int count = 150,
    ProgressCallback? onProgress,
  }) async {
    List<UserModel> targetUsers = users ?? [];
    if (targetUsers.isEmpty) {
      // Fetch users if not provided (for independent seeding)
      final snapshot = await _firestore.collection('users').get();
      targetUsers = snapshot.docs
          .map((d) => UserModel.fromJson(d.data()))
          .toList();
    }

    final customers = targetUsers
        .where((u) => u.role == UserRole.customer)
        .toList();
    final vendors = targetUsers
        .where((u) => u.role == UserRole.vendor)
        .toList();
    final couriers = targetUsers
        .where((u) => u.role == UserRole.courier)
        .toList();

    final warehouseSnap = await _firestore.collection('warehouses').get();
    final seededWarehouses = warehouseSnap.docs
        .map((d) => LogisticsWarehouse.fromJson(d.data()..['id'] = d.id))
        .toList();

    if (customers.isEmpty || vendors.isEmpty) {
      print('❌ Cannot seed shipments: Not enough customers/vendors.');
      return;
    }

    final statuses = [
      ShipmentStatusType.created,
      ShipmentStatusType.pickedUp,
      ShipmentStatusType.inTransit,
      ShipmentStatusType.delivered,
      ShipmentStatusType.cancelled,
    ];

    print('  - Creating $count shipments...');
    for (var i = 0; i < count; i++) {
      onProgress?.call(i / count, 'Generating Shipment ${i + 1} of $count...');
      final sender = customers[_random.nextInt(customers.length)];
      final recipient = targetUsers[_random.nextInt(targetUsers.length)];
      final vendor = vendors[_random.nextInt(vendors.length)];
      final courier = (couriers.isNotEmpty && _random.nextBool())
          ? couriers[_random.nextInt(couriers.length)]
          : null;

      final status = statuses[_random.nextInt(statuses.length)];
      final pickupType =
          PickupType.values[_random.nextInt(PickupType.values.length)];

      final origin = _randomGlobalLocation();
      final destination = _randomGlobalLocation();

      // Determine sender address (handle Warehouse drop-off)
      final isDropOff = pickupType == PickupType.vendorWarehouse;
      LogisticsWarehouse? selectedWarehouse;
      if (isDropOff && seededWarehouses.isNotEmpty) {
        selectedWarehouse =
            seededWarehouses[_random.nextInt(seededWarehouses.length)];
      }

      final senderAddr = isDropOff
          ? (selectedWarehouse?.address ??
                vendor.kycData?['address'] as String? ??
                'Vendor Warehouse, ${origin.city}')
          : '${origin.city}, ${origin.country}';

      final shipment = Shipment(
        id: '',
        trackingNumber:
            'TRK${_random.nextInt(99999999).toString().padLeft(8, '0')}',
        senderName: sender.name,
        senderAddress: senderAddr,
        senderPhone: sender.phoneNumber!,
        senderId: sender.id,
        recipientName: recipient.name,
        recipientAddress: '${destination.city}, ${destination.country}',
        recipientPhone: recipient.phoneNumber ?? '+1000000000',
        recipientId: recipient.id,
        vendorId: vendor.id,
        selectedWarehouseId: selectedWarehouse?.id,
        approvalStatus: status == ShipmentStatusType.created
            ? ShipmentApprovalStatus.pending
            : ShipmentApprovalStatus.approved,
        pickupType: pickupType,
        deliveryType:
            DeliveryType.values[_random.nextInt(DeliveryType.values.length)],
        packages: List.generate(
          _random.nextInt(3) + 1,
          (pkgIdx) => ShipmentPackage(
            id: _uuid.v4(),
            name: 'Package ${pkgIdx + 1}',
            items: List.generate(
              _random.nextInt(4) + 1,
              (itemIdx) => ShipmentItem(
                name: 'Item ${itemIdx + 1}',
                description: 'Imported Goods - ${_random.nextInt(100)}',
                itemType: 'Box',
                category: [
                  'Electronics',
                  'Clothing',
                  'Home',
                  'Beauty',
                ][_random.nextInt(4)],
                quantity: _random.nextInt(5) + 1,
                weight: _random.nextDouble() * 5.0,
                declaredValue: _random.nextDouble() * 200,
                currency: 'USD',
                isPerishable: _random.nextBool(),
                isFragile: _random.nextBool(),
                color: ['Black', 'White', 'Blue', 'Red'][_random.nextInt(4)],
              ),
            ),
            totalWeight: 10.0,
            description: 'Seeded Package',
          ),
        ),
        totalWeight: 5.0 + _random.nextDouble() * 50,
        totalPrice: 100.0 + _random.nextDouble() * 1000,
        currentStatus: status,
        createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(30))),
        estimatedDeliveryDate: DateTime.now().add(
          Duration(days: _random.nextInt(10)),
        ),
        assignedCourierId: status != ShipmentStatusType.created
            ? courier?.id
            : null,
        events: _generateEventsForStatus(
          status,
          origin,
          destination,
          senderAddr,
        ),
      );

      await _firestore
          .collection('shipments')
          .doc(shipment.trackingNumber)
          .set(shipment.toJson());

      // Create explicit assignment record if courier assigned
      if (shipment.assignedCourierId != null && courier != null) {
        final assignment = CourierAssignment(
          id: _uuid.v4(),
          shipmentId: shipment.trackingNumber,
          trackingNumber: shipment.trackingNumber,
          courierId: courier.id,
          courierName: courier.name,
          vendorId: shipment.vendorId ?? 'unknown',
          vendorName: vendor.name,
          senderId: shipment.senderId ?? 'unknown',
          senderName: shipment.senderName,
          assignedAt: DateTime.now(),
          status: ShipmentApprovalStatus.approved,
        );
        await _firestore
            .collection('courier_assignments')
            .doc(assignment.id)
            .set(assignment.toJson());
      }
    }
  }

  List<ShipmentEvent> _generateEventsForStatus(
    ShipmentStatusType status,
    dynamic origin,
    dynamic destination,
    String senderAddr,
  ) {
    final List<ShipmentEvent> events = [];
    final now = DateTime.now();

    // 1. Created Event
    events.add(
      ShipmentEvent(
        id: _uuid.v4(),
        status: ShipmentStatusType.created,
        timestamp: now.subtract(const Duration(days: 5)),
        location: ShipmentLocation(
          latitude: origin.lat,
          longitude: origin.lng,
          address: senderAddr,
        ),
        note: 'Shipment Created',
      ),
    );

    if (status == ShipmentStatusType.created) return events;

    // 2. Picked Up Event
    events.add(
      ShipmentEvent(
        id: _uuid.v4(),
        status: ShipmentStatusType.pickedUp,
        timestamp: now.subtract(const Duration(days: 4)),
        location: ShipmentLocation(
          latitude: origin.lat,
          longitude: origin.lng,
          address: 'Courier Picked Up',
        ),
        note: 'Picked up by Courier',
      ),
    );

    if (status == ShipmentStatusType.pickedUp) return events;

    // 3. In Transit Event
    events.add(
      ShipmentEvent(
        id: _uuid.v4(),
        status: ShipmentStatusType.inTransit,
        timestamp: now.subtract(const Duration(days: 3)),
        location: ShipmentLocation(
          latitude: (origin.lat + destination.lat) / 2,
          longitude: (origin.lng + destination.lng) / 2,
          address: 'International Hub',
        ),
        note: 'Arrived at International Hub',
      ),
    );

    if (status == ShipmentStatusType.inTransit) return events;

    // 4. Delivered Event
    if (status == ShipmentStatusType.delivered) {
      // For testing, make some delivered TODAY
      final isToday = _random.nextBool();
      events.add(
        ShipmentEvent(
          id: _uuid.v4(),
          status: ShipmentStatusType.delivered,
          timestamp: isToday ? now : now.subtract(const Duration(days: 1)),
          location: ShipmentLocation(
            latitude: destination.lat,
            longitude: destination.lng,
            address: 'Destination',
          ),
          note: 'Shipment Delivered Successfully',
        ),
      );
    }

    return events;
  }

  Future<void> seedSocial({
    List<UserModel>? users,
    ProgressCallback? onProgress,
  }) async {
    List<UserModel> targetUsers = users ?? [];
    if (targetUsers.isEmpty) {
      final snapshot = await _firestore.collection('users').get();
      targetUsers = snapshot.docs
          .map((d) => UserModel.fromJson(d.data()..['id'] = d.id))
          .toList();
    }

    final vendors = targetUsers
        .where((u) => u.role == UserRole.vendor)
        .toList();
    if (vendors.isEmpty) return;

    print('  - Creating social posts & comments...');

    int vendorIndex = 0;
    for (var vendor in vendors) {
      vendorIndex++;
      onProgress?.call(
        vendorIndex / vendors.length,
        'Seeding social for ${vendor.name} (${vendorIndex}/${vendors.length})...',
      );

      // Create one post of EACH type for diversity
      for (var type in PostType.values) {
        final location = _randomGlobalLocation();
        final (title, description, tags, price) = _getPostContent(
          type,
          location.city,
          vendor.name,
        );

        final post = VendorPost(
          id: '',
          vendorId: vendor.id,
          vendorName: vendor.name,
          vendorPhotoUrl: vendor.photoUrl,
          description: description,
          title: title,
          imageUrls: [
            'https://picsum.photos/seed/${_random.nextInt(99999)}/600/400',
            if (_random.nextBool())
              'https://picsum.photos/seed/${_random.nextInt(99999)}/600/400',
          ],
          type: type,
          price: price,
          createdAt: DateTime.now().subtract(
            Duration(hours: _random.nextInt(168)),
          ), // Last week
          expiresAt: DateTime.now().add(Duration(days: 30)),
          likeIds: targetUsers
              .take(_random.nextInt(20))
              .map((u) => u.id)
              .toList(),
          tags: tags,
        );

        final docRef = await _firestore.collection('posts').add(post.toJson());

        // Add 2-8 random comments
        final commentCount = _random.nextInt(7) + 2;
        for (var j = 0; j < commentCount; j++) {
          final commenter = targetUsers[_random.nextInt(targetUsers.length)];

          final commentContent = _getCommentContent(type, commenter.role);

          final comment = PostComment(
            id: '',
            postId: docRef.id,
            userId: commenter.id,
            userName: commenter.name,
            userPhotoUrl: commenter.photoUrl,
            content: commentContent,
            createdAt: DateTime.now().subtract(
              Duration(minutes: _random.nextInt(60)),
            ),
            likeIds: [],
            replyCount: 0,
            tags: [],
          );

          await _firestore
              .collection('posts')
              .doc(docRef.id)
              .collection('comments')
              .add(comment.toJson());

          await _firestore.collection('posts').doc(docRef.id).update({
            'commentCount': FieldValue.increment(1),
          });
        }
      }

      // Add a status update
      final statusLoc = _randomGlobalLocation();
      final status = StatusModel(
        id: '',
        vendorId: vendor.id,
        vendorName: vendor.name,
        vendorPhotoUrl: vendor.photoUrl,
        mediaUrl: 'https://picsum.photos/seed/${_random.nextInt(9999)}/400/800',
        caption: 'Handling shipments live in ${statusLoc.city} 📦✈️',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(Duration(hours: 24)),
      );
      await _firestore.collection('statuses').add(status.toJson());
    }
  }

  (String? title, String description, List<String> tags, double price)
  _getPostContent(PostType type, String city, String vendorName) {
    switch (type) {
      case PostType.pre_Order:
        return (
          'Exclusive Pre-order',
          'Get early access to our new cargo route to $city! Limited slots available.',
          ['preorder', 'exclusive', 'logistics'],
          _random.nextDouble() * 500 + 100,
        );
      case PostType.promotion:
        return (
          'Huge Discount!',
          '50% off on all air freight to $city this week only. Don\'t miss out!',
          ['promo', 'discount', 'deal'],
          0.0,
        );
      case PostType.appreciation:
        return (
          'Thank You!',
          'We just hit 10k shipments! Big thanks to our loyal customers in $city.',
          ['milestone', 'thankyou', 'community'],
          0.0,
        );
      case PostType.new_Item:
        return (
          'New Service Added',
          'We now offer refrigerated storage for perishables in our $city warehouse.',
          ['newservice', 'coldchain', 'innovation'],
          _random.nextDouble() * 1000,
        );
      case PostType.update:
        return (
          'Policy Update',
          'Updated customs regulations for shipping to $city have been applied.',
          ['notice', 'update', 'customs'],
          0.0,
        );
      case PostType.logistics:
        return (
          'Route Optimization',
          'Our transit times to $city have been reduced by 24 hours!',
          ['fast', 'speed', 'logistics'],
          0.0,
        );
      case PostType.warehouse:
        return (
          'Warehouse Expansion',
          'Our $city facility has doubled in capacity. Ready for your bulk orders.',
          ['warehouse', 'expansion', 'growth'],
          0.0,
        );
      case PostType.warehouse_Supplier:
        return (
          'Supplier Partnership',
          'Partnered with top manufacturers in $city to streamline sourcing.',
          ['sourcing', 'supplychain', 'partnership'],
          0.0,
        );
      case PostType.product_Launch:
        return (
          'Product Launch',
          'Introducing our new real-time eco-tracking dashboard.',
          ['launch', 'tech', 'eco'],
          0.0,
        );
      case PostType.status_Update:
        return (
          null,
          'Operations in $city are running smoothly despite the weather.',
          ['status', 'live', 'ops'],
          0.0,
        );
    }
  }

  String _getCommentContent(PostType type, UserRole role) {
    if (role == UserRole.vendor) return 'Great update! Keep pushing.';
    if (role == UserRole.courier) return 'Ready to pick up shipments for this.';

    switch (type) {
      case PostType.pre_Order:
        return 'Interested! Sent a DM.';
      case PostType.promotion:
        return 'Is this valid for sea freight too?';
      case PostType.appreciation:
        return 'Best logistics partner ever! ❤️';
      case PostType.new_Item:
        return 'Exactly what we needed.';
      case PostType.update:
        return 'Thanks for the info.';
      default:
        return 'Awesome work team!';
    }
  }

  Future<void> seedChats({
    List<UserModel>? users,
    ProgressCallback? onProgress,
  }) async {
    List<UserModel> targetUsers = users ?? [];
    if (targetUsers.isEmpty) {
      final snapshot = await _firestore.collection('users').get();
      targetUsers = snapshot.docs
          .map((d) => UserModel.fromJson(d.data()..['id'] = d.id))
          .toList();
    }

    print('  - Creating chats...');
    // Create ~20 random chat pairs with REAL conversations
    for (var i = 0; i < 20; i++) {
      onProgress?.call(i / 20, 'Creating chat room ${i + 1} of 20...');
      final u1 = targetUsers[_random.nextInt(targetUsers.length)];
      final u2 = targetUsers[_random.nextInt(targetUsers.length)];
      if (u1.id == u2.id) continue;

      final roomId = _getChatRoomId(u1.id, u2.id);

      // Generate a conversation of 3-10 messages
      final messages = <Message>[];
      final msgCount = _random.nextInt(8) + 3;
      DateTime msgTime = DateTime.now().subtract(
        Duration(days: _random.nextInt(5)),
      );

      String lastMsgContent = '';

      for (var m = 0; m < msgCount; m++) {
        final sender = m % 2 == 0 ? u1 : u2;
        final content = _getChatMessage(m, u1.role, u2.role);
        lastMsgContent = content;
        msgTime = msgTime.add(Duration(minutes: _random.nextInt(120) + 1));

        messages.add(
          Message(
            id: _uuid.v4(),
            senderId: sender.id,
            content: content,
            createdAt: msgTime,
            isRead: m < msgCount - 1, // All read except maybe last
            type: 'text',
          ),
        );
      }

      final chatRoom = ChatRoom(
        id: roomId,
        participantIds: [u1.id, u2.id],
        participantDetails: {
          u1.id: {'name': u1.name, 'photo': u1.photoUrl},
          u2.id: {'name': u2.name, 'photo': u2.photoUrl},
        },
        lastMessage: lastMsgContent,
        lastMessageAt: msgTime,
        unreadCount: _random.nextBool() ? 1 : 0,
      );

      await _firestore.collection('chats').doc(roomId).set(chatRoom.toJson());

      // Batch add messages
      final batch = _firestore.batch();
      for (var msg in messages) {
        final ref = _firestore
            .collection('chats')
            .doc(roomId)
            .collection('messages')
            .doc(msg.id);
        batch.set(ref, msg.toJson());
      }
      await batch.commit();
    }
  }

  Future<void> seedNotifications({
    List<UserModel>? users,
    ProgressCallback? onProgress,
  }) async {
    List<UserModel> targetUsers = users ?? [];
    if (targetUsers.isEmpty) {
      final snapshot = await _firestore.collection('users').get();
      targetUsers = snapshot.docs
          .map((d) => UserModel.fromJson(d.data()..['id'] = d.id))
          .toList();
    }

    print('  - Creating notifications...');
    int userIndex = 0;
    for (var user in targetUsers) {
      userIndex++;
      onProgress?.call(
        userIndex / targetUsers.length,
        'Seeding notifications for ${user.name}...',
      );

      // 3-7 notifications per user
      final count = _random.nextInt(5) + 3;
      for (var i = 0; i < count; i++) {
        final type = NotificationType
            .values[_random.nextInt(NotificationType.values.length)];
        final relatedUser = targetUsers[_random.nextInt(targetUsers.length)];

        final notification = NotificationModel(
          id: _uuid.v4(),
          targetUserId: user.id,
          title: _getNotificationTitle(type),
          message: _getNotificationBody(type, relatedUser.name),
          type: type,
          isRead: _random.nextBool(),
          timestamp: DateTime.now().subtract(
            Duration(days: _random.nextInt(7)),
          ),
          senderId: relatedUser.id,
          senderName: relatedUser.name,
        );

        await _firestore.collection('notifications').add(notification.toJson());
      }
    }
  }

  String _getChatMessage(int index, UserRole r1, UserRole r2) {
    // Simple mock conversation flow
    final convos = [
      "Hello, is the shipment ready?",
      "Yes, you can pick it up in 1 hour.",
      "Great, I'm on my way.",
      "Don't forget the invoice.",
      "Got it, thanks!",
      "Safe travels.",
    ];
    return convos[index % convos.length];
  }

  String _getNotificationTitle(NotificationType type) {
    switch (type) {
      case NotificationType.shipment:
        return 'Shipment Update';
      case NotificationType.message:
        return 'New Message';
      case NotificationType.alert:
        return 'System Alert';
      case NotificationType.promo:
        return 'Special Offer';
      case NotificationType.info:
        return 'Update';
    }
  }

  String _getNotificationBody(NotificationType type, String userName) {
    switch (type) {
      case NotificationType.shipment:
        return 'Your package has arrived at the local hub.';
      case NotificationType.message:
        return '$userName sent you a message.';
      case NotificationType.alert:
        return 'Maintenance scheduled for tonight.';
      case NotificationType.promo:
        return 'Get 20% off your next shipment!';
      case NotificationType.info:
        return 'You have received a new update from $userName.';
    }
  }

  String _generatePhoneNumber() {
    return '+1${_random.nextInt(900000000) + 100000000}'; // International style
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String _getChatRoomId(String a, String b) {
    return a.compareTo(b) < 0 ? '${a}_$b' : '${b}_$a';
  }

  ({String city, String country, double lat, double lng})
  _randomGlobalLocation() {
    final locations = [
      (city: 'Accra', country: 'Ghana', lat: 5.6037, lng: -0.1870),
      (city: 'Lagos', country: 'Nigeria', lat: 6.5244, lng: 3.3792),
      (city: 'New York', country: 'USA', lat: 40.7128, lng: -74.0060),
      (city: 'London', country: 'UK', lat: 51.5074, lng: -0.1278),
      (city: 'Dubai', country: 'UAE', lat: 25.2048, lng: 55.2708),
      (city: 'Beijing', country: 'China', lat: 39.9042, lng: 116.4074),
      (city: 'Tokyo', country: 'Japan', lat: 35.6762, lng: 139.6503),
      (city: 'Sydney', country: 'Australia', lat: -33.8688, lng: 151.2093),
      (city: 'Berlin', country: 'Germany', lat: 52.5200, lng: 13.4050),
      (city: 'Paris', country: 'France', lat: 48.8566, lng: 2.3522),
      (city: 'Nairobi', country: 'Kenya', lat: -1.2921, lng: 36.8219),
      (city: 'Cairo', country: 'Egypt', lat: 30.0444, lng: 31.2357),
      (city: 'Mumbai', country: 'India', lat: 19.0760, lng: 72.8777),
      (city: 'Sao Paulo', country: 'Brazil', lat: -23.5558, lng: -46.6396),
    ];
    return locations[_random.nextInt(locations.length)];
  }

  Future<void> seedWarehouses({
    int count = 10,
    ProgressCallback? onProgress,
  }) async {
    print('  - Creating $count warehouses mapped to vendors...');

    // Fetch vendors to link warehouses
    final vendorSnap = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'vendor')
        .get();
    final vendors = vendorSnap.docs
        .map((d) => UserModel.fromJson(d.data()))
        .toList();

    if (vendors.isEmpty) {
      print('❌ Cannot seed warehouses: No vendors found.');
      return;
    }

    // Ensure every vendor has at least one warehouse
    int currentWhCount = 0;
    for (final vendor in vendors) {
      currentWhCount++;
      onProgress?.call(
        currentWhCount / (vendors.length + count),
        'Generating Warehouse for ${vendor.name}...',
      );
      final loc = _randomGlobalLocation();
      final warehouse = LogisticsWarehouse(
        id: 'WH-${1000 + currentWhCount}',
        name: '${vendor.name} Hub - ${loc.city}',
        address: '${_random.nextInt(999)} Industrial Way, ${loc.city}',
        vendorId: vendor.id,
        location: ShipmentLocation(
          latitude: loc.lat,
          longitude: loc.lng,
          address: '${loc.city} Hub',
          city: loc.city,
          country: loc.country,
          street: '${_random.nextInt(999)} Industrial Way',
          state: 'Province ${_random.nextInt(20)}',
          zip: '${_random.nextInt(99999)}',
        ),
        contactPhone: vendor.phoneNumber ?? _generatePhoneNumber(),
      );

      await _firestore
          .collection('warehouses')
          .doc(warehouse.id)
          .set(warehouse.toJson());
    }

    // Add extra warehouses if requested
    for (var i = 1; i <= count; i++) {
      final totalSteps = vendors.length + count;
      onProgress?.call(
        (vendors.length + i) / totalSteps,
        'Generating extra Warehouse $i...',
      );
      final vendor = vendors[_random.nextInt(vendors.length)];
      final loc = _randomGlobalLocation();
      final warehouse = LogisticsWarehouse(
        id: 'WH-${2000 + i}',
        name: '${loc.city} Logistics Hub $i',
        address: '${_random.nextInt(999)} Industrial Way, ${loc.city}',
        vendorId: vendor.id,
        location: ShipmentLocation(
          latitude: loc.lat,
          longitude: loc.lng,
          address: '${loc.city} Hub',
          city: loc.city,
          country: loc.country,
          street: '${_random.nextInt(999)} Industrial Way',
          state: 'Region ${_random.nextInt(20)}',
          zip: '${_random.nextInt(99999)}',
        ),
        contactPhone: _generatePhoneNumber(),
      );

      await _firestore
          .collection('warehouses')
          .doc(warehouse.id)
          .set(warehouse.toJson());
    }
  }

  Future<void> seedCourierAssignments({ProgressCallback? onProgress}) async {
    print('  - Seeding courier assignments...');

    // 1. Fetch Couriers
    final courierSnap = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'courier')
        .get();
    final couriers = courierSnap.docs
        .map((d) => UserModel.fromJson(d.data()..['id'] = d.id))
        .toList();

    if (couriers.isEmpty) {
      print('❌ No couriers found to assign.');
      return;
    }

    // Fetch Vendors for naming in assignment records
    final vendorSnap = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'vendor')
        .get();
    final vendorsMap = {
      for (var d in vendorSnap.docs)
        d.id: UserModel.fromJson(d.data()..['id'] = d.id),
    };

    // 2. Fetch Shipments
    final shipmentSnap = await _firestore.collection('shipments').get();
    final shipments = shipmentSnap.docs;

    int assignedCount = 0;
    int alreadyAssignedCount = 0;

    for (var i = 0; i < shipments.length; i++) {
      final doc = shipments[i];
      final data = doc.data();

      // If NOT assigned, assign a random courier
      if (data['assignedCourierId'] == null) {
        final courier = couriers[_random.nextInt(couriers.length)];
        final vendorId = data['vendorId'] as String?;
        final vendor = vendorId != null ? vendorsMap[vendorId] : null;

        // 1. Update Shipment
        await doc.reference.update({
          'assignedCourierId': courier.id,
          'approvalStatus': 'approved', // Auto-approve if assigned
        });

        // 2. Create Explicit Assignment Record for Audit/Visibility
        final assignment = CourierAssignment(
          id: _uuid.v4(),
          shipmentId: doc.id,
          trackingNumber: data['trackingNumber'] ?? doc.id,
          courierId: courier.id,
          courierName: courier.name,
          vendorId: vendorId ?? 'unknown',
          vendorName: vendor?.name ?? 'Unknown Vendor',
          senderId: data['senderId'] ?? 'unknown',
          senderName: data['senderName'] ?? 'Unknown Sender',
          assignedAt: DateTime.now(),
          status: ShipmentApprovalStatus.approved,
        );

        await _firestore
            .collection('courier_assignments')
            .doc(assignment.id)
            .set(assignment.toJson());

        assignedCount++;
      } else {
        alreadyAssignedCount++;
      }

      onProgress?.call(
        i / shipments.length,
        'Processing Assignments: $assignedCount new, $alreadyAssignedCount existing...',
      );
    }
    print('✅ Assigned $assignedCount shipments to couriers.');
  }

  String _getCountryCode(String country) {
    final codes = {
      'Ghana': 'GH',
      'Nigeria': 'NG',
      'USA': 'US',
      'UK': 'GB',
      'UAE': 'AE',
      'China': 'CN',
      'Japan': 'JP',
      'Australia': 'AU',
      'Germany': 'DE',
      'France': 'FR',
      'Kenya': 'KE',
      'Egypt': 'EG',
      'India': 'IN',
      'Brazil': 'BR',
    };
    return codes[country] ?? 'US';
  }

  String _getCurrency(String country) {
    final currencies = {
      'Ghana': 'GHS',
      'Nigeria': 'NGN',
      'USA': 'USD',
      'UK': 'GBP',
      'UAE': 'AED',
      'China': 'CNY',
      'Japan': 'JPY',
      'Australia': 'AUD',
      'Germany': 'EUR',
      'France': 'EUR',
      'Kenya': 'KES',
      'Egypt': 'EGP',
      'India': 'INR',
      'Brazil': 'BRL',
    };
    return currencies[country] ?? 'USD';
  }

  /// Seed reviews for users
  Future<void> seedReviews({
    List<UserModel>? users,
    int reviewsPerUser = 5,
    ProgressCallback? onProgress,
  }) async {
    List<UserModel> targetUsers = users ?? [];
    if (targetUsers.isEmpty) {
      final snapshot = await _firestore.collection('users').get();
      targetUsers = snapshot.docs
          .map((d) => UserModel.fromJson(d.data()))
          .toList();
    }

    final vendors = targetUsers
        .where((u) => u.role == UserRole.vendor)
        .toList();
    final couriers = targetUsers
        .where((u) => u.role == UserRole.courier)
        .toList();
    final customers = targetUsers
        .where((u) => u.role == UserRole.customer)
        .toList();

    if (customers.isEmpty) {
      print('❌ No customers to create reviews');
      return;
    }

    print('  - Creating reviews for vendors and couriers...');

    // Review vendors
    int totalReviews = 0;
    for (var i = 0; i < vendors.length; i++) {
      final vendor = vendors[i];
      onProgress?.call(
        i / (vendors.length + couriers.length),
        'Creating reviews for ${vendor.name}...',
      );

      for (var j = 0; j < reviewsPerUser; j++) {
        final reviewer = customers[_random.nextInt(customers.length)];
        final rating = _generateWeightedRating(); // Weighted toward 4-5

        final review = {
          'id': _uuid.v4(),
          'reviewerId': reviewer.id,
          'revieweeId': vendor.id,
          'rating': rating,
          'comment': _generateReviewComment(rating),
          'timestamp': DateTime.now()
              .subtract(Duration(days: _random.nextInt(90)))
              .toIso8601String(),
          'isVerifiedPurchase': _random.nextBool(),
          'reviewerName': reviewer.name,
          'reviewerPhotoUrl': reviewer.photoUrl,
        };

        await _firestore.collection('reviews').add(review);
        totalReviews++;
      }
    }

    // Review couriers
    for (var i = 0; i < couriers.length; i++) {
      final courier = couriers[i];
      onProgress?.call(
        (vendors.length + i) / (vendors.length + couriers.length),
        'Creating reviews for ${courier.name}...',
      );

      final reviewCount = _random.nextInt(reviewsPerUser) + 2;
      for (var j = 0; j < reviewCount; j++) {
        final reviewer = customers[_random.nextInt(customers.length)];
        final rating = _generateWeightedRating();

        final review = {
          'id': _uuid.v4(),
          'reviewerId': reviewer.id,
          'revieweeId': courier.id,
          'rating': rating,
          'comment': _generateReviewComment(rating, isCourier: true),
          'timestamp': DateTime.now()
              .subtract(Duration(days: _random.nextInt(60)))
              .toIso8601String(),
          'isVerifiedPurchase': true,
          'reviewerName': reviewer.name,
          'reviewerPhotoUrl': reviewer.photoUrl,
        };

        await _firestore.collection('reviews').add(review);
        totalReviews++;
      }
    }

    print('✅ Created $totalReviews reviews');

    // Update user rating stats
    print('  - Updating user rating statistics...');
    for (var user in [...vendors, ...couriers]) {
      await _updateUserRatingStats(user.id);
    }
  }

  int _generateWeightedRating() {
    // 60% chance of 5 stars, 25% of 4 stars, 10% of 3 stars, 5% of 2-1 stars
    final rand = _random.nextDouble();
    if (rand < 0.60) return 5;
    if (rand < 0.85) return 4;
    if (rand < 0.95) return 3;
    if (rand < 0.98) return 2;
    return 1;
  }

  String _generateReviewComment(int rating, {bool isCourier = false}) {
    final excellent = [
      'Excellent service! Highly recommend.',
      'Very professional and fast delivery.',
      'Great experience from start to finish.',
      'Will definitely use again!',
      'Outstanding service and communication.',
    ];

    final good = [
      'Good service overall.',
      'Satisfied with the delivery.',
      'Professional and timely.',
      'Would use again.',
    ];

    final average = [
      'Service was okay.',
      'Had some minor issues but resolved.',
      'Average experience.',
    ];

    final poor = [
      'Could be better.',
      'Had some delays.',
      'Not very satisfied.',
    ];

    if (rating >= 5) return excellent[_random.nextInt(excellent.length)];
    if (rating >= 4) return good[_random.nextInt(good.length)];
    if (rating >= 3) return average[_random.nextInt(average.length)];
    return poor[_random.nextInt(poor.length)];
  }

  Future<void> _updateUserRatingStats(String userId) async {
    final reviews = await _firestore
        .collection('reviews')
        .where('revieweeId', isEqualTo: userId)
        .get();

    if (reviews.docs.isEmpty) return;

    final ratings = reviews.docs
        .map((doc) => (doc.data()['rating'] as int))
        .toList();

    final ratingBreakdown = <String, int>{};
    for (int i = 1; i <= 5; i++) {
      ratingBreakdown[i.toString()] = ratings.where((r) => r == i).length;
    }

    final averageRating = ratings.reduce((a, b) => a + b) / ratings.length;

    await _firestore.collection('users').doc(userId).update({
      'averageRating': averageRating,
      'totalReviews': ratings.length,
      'ratingBreakdown': ratingBreakdown,
    });
  }
}
