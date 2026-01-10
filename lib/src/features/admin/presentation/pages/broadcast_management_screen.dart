import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/admin/presentation/providers/admin_providers.dart';
import 'package:rightlogistics/src/features/admin/presentation/widgets/broadcast_form_dialog.dart';
import 'package:rightlogistics/src/features/admin/domain/admin_models.dart';

class BroadcastManagementScreen extends ConsumerWidget {
  const BroadcastManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcastsAsync = ref.watch(broadcastsProvider);

    return Scaffold(
      body: broadcastsAsync.when(
        data: (broadcasts) => ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: broadcasts.length,
          itemBuilder: (context, index) {
            final broadcast = broadcasts[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              child: ListTile(
                leading: _PriorityBadge(priority: broadcast.priority),
                title: Text(broadcast.title, maxLines: 1),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(broadcast.content, maxLines: 2),
                    SizedBox(height: 4.h),
                    _StatusBadge(status: broadcast.status),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (broadcast.status == BroadcastStatus.draft ||
                        broadcast.status == BroadcastStatus.scheduled)
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () =>
                            _sendBroadcast(context, ref, broadcast.id),
                        tooltip: 'Send now',
                      ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showBroadcastForm(context, broadcast),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(context, ref, broadcast),
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
        onPressed: () => _showBroadcastForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('New Broadcast'),
      ),
    );
  }

  void _showBroadcastForm(BuildContext context, BroadcastMessage? broadcast) {
    showDialog(
      context: context,
      builder: (context) => BroadcastFormDialog(broadcast: broadcast),
    );
  }

  void _sendBroadcast(
    BuildContext context,
    WidgetRef ref,
    String broadcastId,
  ) async {
    try {
      await ref.read(adminRepositoryProvider).sendBroadcast(broadcastId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Broadcast sent successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    BroadcastMessage broadcast,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Broadcast'),
        content: Text('Delete "${broadcast.title}"? This cannot be undone.'),
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
                    .deleteBroadcast(broadcast.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Broadcast deleted')),
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
}

class _PriorityBadge extends StatelessWidget {
  final BroadcastPriority priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (priority) {
      case BroadcastPriority.low:
        color = Colors.grey;
        icon = Icons.info_outline;
        break;
      case BroadcastPriority.normal:
        color = Colors.blue;
        icon = Icons.notifications;
        break;
      case BroadcastPriority.high:
        color = Colors.orange;
        icon = Icons.priority_high;
        break;
      case BroadcastPriority.urgent:
        color = Colors.red;
        icon = Icons.warning;
        break;
    }

    return Icon(icon, color: color, size: 32.w);
  }
}

class _StatusBadge extends StatelessWidget {
  final BroadcastStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case BroadcastStatus.draft:
        color = Colors.grey;
        break;
      case BroadcastStatus.scheduled:
        color = Colors.orange;
        break;
      case BroadcastStatus.sent:
        color = Colors.green;
        break;
      case BroadcastStatus.expired:
        color = Colors.red;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
