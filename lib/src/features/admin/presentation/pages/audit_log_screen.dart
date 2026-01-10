import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/admin/presentation/providers/admin_providers.dart';
import 'package:intl/intl.dart';

class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(auditLogsProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // ignore: unused_result
          return ref.refresh(auditLogsProvider);
        },
        child: logsAsync.when(
          data: (logs) {
            if (logs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64.w, color: Colors.grey),
                    SizedBox(height: 16.h),
                    const Text('No audit logs found'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: _getActionColor(
                        log.action,
                      ).withOpacity(0.1),
                      child: Icon(
                        _getActionIcon(log.action),
                        color: _getActionColor(log.action),
                      ),
                    ),
                    title: Text(
                      log.action,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${log.performedByUserName} • ${DateFormat.yMMMd().add_jm().format(log.timestamp)}',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (log.note != null) ...[
                              Text(
                                'Note:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                              Text(log.note!),
                              SizedBox(height: 8.h),
                            ],
                            Text(
                              'Target ID: ${log.targetId}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Type: ${log.targetType}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                            if (log.metadata != null &&
                                log.metadata!.isNotEmpty) ...[
                              SizedBox(height: 8.h),
                              Text(
                                'Metadata:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                              ...log.metadata!.entries.map(
                                (e) => Text(
                                  '${e.key}: ${e.value}',
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              Center(child: Text('Error loading logs: $err')),
        ),
      ),
    );
  }

  Color _getActionColor(String action) {
    if (action.contains('CREATE')) return Colors.green;
    if (action.contains('UPDATE')) return Colors.blue;
    if (action.contains('DELETE')) return Colors.red;
    return Colors.grey;
  }

  IconData _getActionIcon(String action) {
    if (action.contains('USER')) return Icons.person;
    if (action.contains('POST')) return Icons.post_add;
    if (action.contains('QUOTATION')) return Icons.request_quote;
    if (action.contains('BROADCAST')) return Icons.campaign;
    if (action.contains('WAREHOUSE')) return Icons.warehouse;
    if (action.contains('ASSIGNMENT')) return Icons.local_shipping;
    return Icons.info_outline;
  }
}
