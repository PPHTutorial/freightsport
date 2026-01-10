import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:rightlogistics/src/features/admin/presentation/providers/admin_providers.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';

class CourierAssignmentFormDialog extends ConsumerStatefulWidget {
  final CourierAssignment? assignment;

  const CourierAssignmentFormDialog({super.key, this.assignment});

  @override
  ConsumerState<CourierAssignmentFormDialog> createState() =>
      _CourierAssignmentFormDialogState();
}

class _CourierAssignmentFormDialogState
    extends ConsumerState<CourierAssignmentFormDialog> {
  String? _selectedShipmentId;
  String? _selectedCourierId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedShipmentId = widget.assignment?.shipmentId;
    _selectedCourierId = widget.assignment?.courierId;
  }

  Future<void> _saveAssignment() async {
    if (_selectedShipmentId == null || _selectedCourierId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both shipment and courier'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(adminRepositoryProvider);

      // If editing, just reassign the courier
      if (widget.assignment != null) {
        await repository.reassignCourier(
          widget.assignment!.id,
          _selectedCourierId!,
        );
      } else {
        // Create new assignment
        // Get shipment details
        final shipments = await ref.read(allShipmentsProvider.future);
        final shipment = shipments.firstWhere(
          (s) => s.id == _selectedShipmentId,
        );

        // Get courier details
        final courier = await repository.getUserById(_selectedCourierId!);
        if (courier == null) throw Exception('Courier not found');

        final newAssignment = CourierAssignment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          shipmentId: _selectedShipmentId!,
          trackingNumber: shipment.trackingNumber,
          courierId: _selectedCourierId!,
          courierName: courier.name,
          vendorId: shipment.vendorId ?? 'N/A',
          vendorName: 'N/A',
          senderId: shipment.senderId ?? 'N/A',
          senderName: shipment.senderName,
          assignedAt: DateTime.now(),
          status: ShipmentApprovalStatus.approved,
        );

        await repository.createAssignment(newAssignment);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.assignment == null
                  ? 'Assignment created successfully'
                  : 'Courier reassigned successfully',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shipmentsAsync = ref.watch(allShipmentsProvider);
    final couriersAsync = ref.watch(usersByRoleProvider(UserRole.courier));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500.w),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.assignment == null
                      ? 'Assign Courier'
                      : 'Reassign Courier',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 24.w),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Shipment Selector (only for new assignments)
            if (widget.assignment == null)
              shipmentsAsync.when(
                data: (shipments) {
                  // Only show unassigned or pending shipments
                  final availableShipments = shipments
                      .where(
                        (s) =>
                            s.assignedCourierId == null ||
                            s.currentStatus == ShipmentStatusType.created,
                      )
                      .toList();

                  return DropdownButtonFormField<String>(
                    value: _selectedShipmentId,
                    decoration: InputDecoration(
                      labelText: 'Select Shipment',
                      prefixIcon: const Icon(Icons.local_shipping),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                    ),
                    items: availableShipments.map((shipment) {
                      return DropdownMenuItem(
                        value: shipment.id,
                        child: Text(
                          '${shipment.trackingNumber} - ${shipment.recipientName}',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedShipmentId = value),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error loading shipments: $err'),
              )
            else
              ListTile(
                leading: const Icon(Icons.local_shipping),
                title: Text('Shipment: ${widget.assignment!.trackingNumber}'),
                subtitle: Text('Current: ${widget.assignment!.courierName}'),
              ),
            SizedBox(height: 16.h),

            // Courier Selector
            couriersAsync.when(
              data: (couriers) => DropdownButtonFormField<String>(
                value: _selectedCourierId,
                decoration: InputDecoration(
                  labelText: widget.assignment == null
                      ? 'Select Courier'
                      : 'Reassign to Courier',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                ),
                items: couriers.map((courier) {
                  return DropdownMenuItem(
                    value: courier.id,
                    child: Text(courier.name),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedCourierId = value),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error loading couriers: $err'),
            ),
            SizedBox(height: 24.h),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveAssignment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(
                        widget.assignment == null
                            ? 'ASSIGN COURIER'
                            : 'REASSIGN COURIER',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
