import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/admin/presentation/providers/admin_providers.dart';
import 'package:rightlogistics/src/features/admin/presentation/widgets/warehouse_form_dialog.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';

class WarehouseManagementScreen extends ConsumerWidget {
  const WarehouseManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warehousesAsync = ref.watch(warehousesProvider(null));

    return Scaffold(
      body: warehousesAsync.when(
        data: (warehouses) => ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: warehouses.length,
          itemBuilder: (context, index) {
            final warehouse = warehouses[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              child: ListTile(
                leading: const Icon(Icons.warehouse, size: 40),
                title: Text(
                  warehouse.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(warehouse.address),
                    Text(
                      'Lat: ${warehouse.location.latitude}, Lng: ${warehouse.location.longitude}',
                      style: TextStyle(fontSize: 11.sp),
                    ),
                    if (warehouse.contactPhone != null)
                      Text('📞 ${warehouse.contactPhone}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showWarehouseForm(context, warehouse),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(context, ref, warehouse),
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
        onPressed: () => _showWarehouseForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('New Warehouse'),
      ),
    );
  }

  void _showWarehouseForm(BuildContext context, LogisticsWarehouse? warehouse) {
    showDialog(
      context: context,
      builder: (context) => WarehouseFormDialog(warehouse: warehouse),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    LogisticsWarehouse warehouse,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Warehouse'),
        content: Text('Delete "${warehouse.name}"? This cannot be undone.'),
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
                    .deleteWarehouse(warehouse.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Warehouse deleted')),
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
