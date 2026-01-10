import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/tracking/data/shipment_repository.dart';

part 'create_shipment_controller.freezed.dart';

@freezed
class CreateShipmentState with _$CreateShipmentState {
  const factory CreateShipmentState({
    @Default(0) int currentStep,

    // Step 1: Vendor & Route
    UserModel? selectedVendor,
    String? selectedRouteId,

    // Step 2: Packages & Items
    @Default([]) List<ShipmentPackage> packages,
    // Helper to calculate total declared value from all items
    @Default(0.0) double totalDeclaredValue,

    // Step 3: Supplier/Sender Info
    String? senderName,
    String? senderPhone,
    String? senderAddress,
    String? senderNote,

    // Step 4: Warehouse (Drop-off point)
    String? selectedWarehouseId,
    @Default(PickupType.supplierLocation) PickupType pickupType,

    // Step 5: Final Delivery
    String? recipientName,
    String? recipientPhone,
    String? recipientAddress,
    @Default(DeliveryType.doorstep) DeliveryType deliveryType,

    // Step 6: Cost & Suggestions
    @Default([]) List<Map<String, dynamic>> alternativeQuotes,
    Map<String, dynamic>? selectedQuote,

    @Default(false) bool isLoading,
    String? error,
  }) = _CreateShipmentState;

  const CreateShipmentState._();
}

class CreateShipmentController extends StateNotifier<CreateShipmentState> {
  final Ref ref;
  CreateShipmentController(this.ref) : super(const CreateShipmentState());

  bool get canGoNext {
    final s = state;
    switch (s.currentStep) {
      case 0:
        return s.selectedVendor != null;
      case 1:
        // Must have at least one package with at least one item
        return s.packages.isNotEmpty &&
            s.packages.any((p) => p.items.isNotEmpty);
      case 2:
        if (s.pickupType == PickupType.supplierLocation) {
          return s.senderName != null &&
              s.senderName!.isNotEmpty &&
              s.senderPhone != null &&
              s.senderPhone!.isNotEmpty &&
              s.senderAddress != null &&
              s.senderAddress!.isNotEmpty;
        }
        return true;
      case 3:
        if (s.pickupType == PickupType.vendorWarehouse) {
          return s.selectedWarehouseId != null;
        }
        return true;
      case 4:
        return s.recipientName != null &&
            s.recipientName!.isNotEmpty &&
            s.recipientPhone != null &&
            s.recipientPhone!.isNotEmpty &&
            s.recipientAddress != null &&
            s.recipientAddress!.isNotEmpty;
      case 5:
        return true; // Reviewing quotes
      case 6:
        return true; // Final Review
      default:
        return false;
    }
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 6) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void selectVendor(UserModel vendor) {
    state = state.copyWith(selectedVendor: vendor);
  }

  void setRouteId(String routeId) {
    state = state.copyWith(selectedRouteId: routeId);
  }

  void selectWarehouse(LogisticsWarehouse warehouse) {
    state = state.copyWith(
      selectedWarehouseId: warehouse.id,
      senderAddress: warehouse.address,
    );
  }

  // --- Package & Item Management ---

  void addPackage(ShipmentPackage pkg) {
    state = state.copyWith(packages: [...state.packages, pkg]);
    _recalculateTotals();
  }

  void removePackage(int index) {
    final newPackages = [...state.packages];
    newPackages.removeAt(index);
    state = state.copyWith(packages: newPackages);
    _recalculateTotals();
  }

  void addItemToPackage(int packageIndex, ShipmentItem item) {
    final newPackages = [...state.packages];
    final pkg = newPackages[packageIndex];
    final newItems = [...pkg.items, item];

    // Recalculate package weight if needed, or just let backend handle it.
    // Ideally we sum up item weights here.
    double pkgWeight = 0;
    for (var i in newItems) {
      pkgWeight += (i.weight * i.quantity);
    }

    newPackages[packageIndex] = pkg.copyWith(
      items: newItems,
      totalWeight: pkgWeight,
    );
    state = state.copyWith(packages: newPackages);
    _recalculateTotals();
  }

  void removeItemFromPackage(int packageIndex, int itemIndex) {
    final newPackages = [...state.packages];
    final pkg = newPackages[packageIndex];
    final newItems = [...pkg.items];
    newItems.removeAt(itemIndex);

    double pkgWeight = 0;
    for (var i in newItems) {
      pkgWeight += (i.weight * i.quantity);
    }

    newPackages[packageIndex] = pkg.copyWith(
      items: newItems,
      totalWeight: pkgWeight,
    );
    state = state.copyWith(packages: newPackages);
    _recalculateTotals();
  }

  void _recalculateTotals() {
    double totalValue = 0;
    for (final pkg in state.packages) {
      for (final item in pkg.items) {
        totalValue += (item.declaredValue * item.quantity);
      }
    }
    state = state.copyWith(totalDeclaredValue: totalValue);
  }

  // --------------------------------

  void updateSenderInfo({
    String? name,
    String? phone,
    String? address,
    String? note,
  }) {
    state = state.copyWith(
      senderName: name ?? state.senderName,
      senderPhone: phone ?? state.senderPhone,
      senderAddress: address ?? state.senderAddress,
      senderNote: note ?? state.senderNote,
    );
  }

  void setPickupType(PickupType type) {
    state = state.copyWith(pickupType: type);
  }

  void setDeliveryType(DeliveryType type) {
    state = state.copyWith(deliveryType: type);
  }

  void updateRecipientInfo({String? name, String? phone, String? address}) {
    state = state.copyWith(
      recipientName: name ?? state.recipientName,
      recipientPhone: phone ?? state.recipientPhone,
      recipientAddress: address ?? state.recipientAddress,
    );
  }

  void validateAndNext(Function(String) onError) {
    if (canGoNext) {
      if (state.currentStep == 4) {
        transformAndCalculateCosts();
      }
      nextStep();
    } else {
      String msg = 'Please complete all required fields';
      if (state.currentStep == 0) msg = 'Please select a vendor';
      if (state.currentStep == 1) {
        msg = 'Please add at least one package with items';
      }
      onError(msg);
    }
  }

  Future<void> transformAndCalculateCosts() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));

    // Mock quote generation
    final basePrice = 100.0; // Dynamic logic can be added here
    // user's estimate is state.totalDeclaredValue

    final quotes = <Map<String, dynamic>>[];
    for (int i = 0; i < 3; i++) {
      quotes.add({
        'vendorName': 'Vendor ${i + 1}',
        'price': basePrice * (0.8 + (i * 0.1)),
        'days': 3 + i,
        'rating': 4.5 - (i * 0.2),
      });
    }

    state = state.copyWith(isLoading: false, alternativeQuotes: quotes);
  }

  Future<bool> submitShipment() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('User not logged in');

      final trackingNumber =
          'TRK${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

      double totalWeight = 0;
      for (var p in state.packages) {
        totalWeight += (p.totalWeight ?? 0);
      }

      // Determine sender address
      String senderAddr = state.senderAddress ?? '';
      if (state.pickupType == PickupType.vendorWarehouse) {
        // In a real scenario, we'd look up the warehouse address by ID.
        // For now, if no explicit address, use vendor's address or a placeholder.
        senderAddr =
            (state.selectedVendor?.kycData?['address'] as String?) ??
            'Vendor Warehouse: ${state.selectedWarehouseId}';
      }

      final shipment = Shipment(
        id: '',
        trackingNumber: trackingNumber,

        senderName: state.senderName ?? user.name,
        senderAddress: senderAddr,
        senderPhone: state.senderPhone ?? '',
        senderId: user.id,

        recipientName: state.recipientName ?? '',
        recipientAddress: state.recipientAddress ?? '',
        recipientPhone: state.recipientPhone ?? '',

        vendorId: state.selectedVendor?.id,
        routeId: state.selectedRouteId,
        approvalStatus: ShipmentApprovalStatus.pending,

        packages: state.packages, // Using packages
        pickupType: state.pickupType,
        deliveryType: state.deliveryType,
        selectedWarehouseId: state.selectedWarehouseId,

        currentStatus: ShipmentStatusType.created,
        createdAt: DateTime.now(),
        estimatedDeliveryDate: DateTime.now().add(const Duration(days: 3)),
        events: [
          ShipmentEvent(
            id: 'e1',
            status: ShipmentStatusType.created,
            timestamp: DateTime.now(),
            location: const ShipmentLocation(
              latitude: 0,
              longitude: 0,
              address: 'Created',
            ),
            note: 'Order placed',
            updatedByUserId: user.id,
          ),
        ],

        totalPrice: 150.0, // Should be calculated or selected from quote
        totalWeight: totalWeight,
        currency:
            state.packages.isNotEmpty && state.packages.first.items.isNotEmpty
            ? state.packages.first.items.first.currency
            : 'USD',
      );

      await ref.read(shipmentRepositoryProvider).createShipment(shipment);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final createShipmentProvider =
    StateNotifierProvider<CreateShipmentController, CreateShipmentState>((ref) {
      return CreateShipmentController(ref);
    });
