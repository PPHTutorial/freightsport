import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rightlogistics/src/features/tracking/data/shipment_repository.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';

part 'tracking_controller.g.dart';

@riverpod
class TrackingController extends _$TrackingController {
  @override
  FutureOr<Shipment?> build(String trackingNumber) async {
    // If tracking number is empty, return null immediately
    if (trackingNumber.isEmpty) return null;
    
    final repository = ref.watch(shipmentRepositoryProvider);
    return repository.getShipmentByTrackingNumber(trackingNumber);
  }
}
