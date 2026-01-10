import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/admin/presentation/providers/admin_providers.dart';
import 'package:rightlogistics/src/features/admin/presentation/widgets/courier_assignment_form_dialog.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';

class CourierAssignmentScreen extends ConsumerWidget {
  const CourierAssignmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentsAsync = ref.watch(assignmentsProvider(null));

    return Scaffold(
      body: assignmentsAsync.when(
        data: (assignments) => ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            final assignment = assignments[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              child: ListTile(
                leading: Icon(
                  Icons.delivery_dining,
                  size: 32,
                  color: _getStatusColor(assignment.status),
                ),
                title: Text(
                  assignment.trackingNumber,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Courier: ${assignment.courierName}'),
                    Text('Sender: ${assignment.senderName}'),
                    Text(
                      'Assigned: ${assignment.assignedAt.toString().substring(0, 16)}',
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.swap_horiz),
                      onPressed: () => _showAssignmentForm(context, assignment),
                      tooltip: 'Reassign',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(context, ref, assignment),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAssignmentForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('New Assignment'),
      ),
    );
  }

  void _showAssignmentForm(
    BuildContext context,
    CourierAssignment? assignment,
  ) {
    showDialog(
      context: context,
      builder: (context) => CourierAssignmentFormDialog(assignment: assignment),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    CourierAssignment assignment,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: Text(
          'Delete assignment for ${assignment.trackingNumber}? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref
                    .read(adminRepositoryProvider)
                    .deleteAssignment(assignment.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Assignment deleted')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ShipmentApprovalStatus status) {
    switch (status) {
      case ShipmentApprovalStatus.pending:
        return Colors.orange;
      case ShipmentApprovalStatus.approved:
        return Colors.green;
      case ShipmentApprovalStatus.rejected:
        return Colors.red;
      case ShipmentApprovalStatus.completed:
        return Colors.blue;
    }
  }
}
