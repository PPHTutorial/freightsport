import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/features/tracking/data/shipment_repository.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';

class UpdateStatusScreen extends ConsumerStatefulWidget {
  final String trackingNumber;
  final Shipment? shipment;

  const UpdateStatusScreen({
    super.key,
    required this.trackingNumber,
    this.shipment,
  });

  @override
  ConsumerState<UpdateStatusScreen> createState() => _UpdateStatusScreenState();
}

class _UpdateStatusScreenState extends ConsumerState<UpdateStatusScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _locationController = TextEditingController(
    text: "Current Location (Mock)",
  );

  ShipmentStatusType? _selectedStatus;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.shipment?.currentStatus;
  }

  @override
  void dispose() {
    _noteController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _selectedStatus != null) {
      setState(() => _isLoading = true);

      // Create new event
      final event = ShipmentEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        status: _selectedStatus!,
        timestamp: DateTime.now(),
        location: ShipmentLocation(
          latitude: 0,
          longitude: 0,
          address: _locationController.text,
        ),
        note: _noteController.text.isNotEmpty ? _noteController.text : null,
      );

      try {
        await ref
            .read(shipmentRepositoryProvider)
            .updateShipmentStatus(
              widget.shipment?.id ??
                  widget
                      .trackingNumber, // Fallback to tracking num as ID for mock
              event,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Status updated successfully')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppTheme.errorRed,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New Status', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<ShipmentStatusType>(
              value: _selectedStatus,
              items: ShipmentStatusType.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(
                    status
                        .toString()
                        .split('.')
                        .last
                        .toUpperCase()
                        .replaceAll('_', ' '),
                  ),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedStatus = val),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.flag_outlined),
              ),
            ),
            const SizedBox(height: 24),
            Text('Location', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.place_outlined),
              ),
            ),
            const SizedBox(height: 24),
            Text('Notes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'Add details (e.g., Left at front door)',
                prefixIcon: Icon(Icons.note_alt_outlined),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Update Status'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
