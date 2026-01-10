import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/admin/presentation/providers/admin_providers.dart';
import 'package:rightlogistics/src/features/admin/presentation/widgets/quotation_form_dialog.dart';
import 'package:rightlogistics/src/features/admin/domain/admin_models.dart';

class QuotationManagementScreen extends ConsumerWidget {
  const QuotationManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotationsAsync = ref.watch(quotationsProvider(null));

    return Scaffold(
      body: quotationsAsync.when(
        data: (quotations) => ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: quotations.length,
          itemBuilder: (context, index) {
            final quotation = quotations[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              child: ListTile(
                leading: Icon(
                  quotation.freightType == FreightType.air
                      ? Icons.flight
                      : Icons.directions_boat,
                  size: 32,
                  color: quotation.isActive ? Colors.green : Colors.grey,
                ),
                title: Text(
                  '${quotation.vendorName} - ${quotation.freightType.name.toUpperCase()}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category: ${quotation.itemCategory.name}'),
                    Text('Rate: \$${quotation.ratePerUnit}/unit'),
                    if (quotation.deliverySpeed != null)
                      Text('Speed: ${quotation.deliverySpeed!.name}'),
                    Text(
                      'Valid: ${quotation.validFrom.toString().substring(0, 10)} - ${quotation.validUntil.toString().substring(0, 10)}',
                      style: TextStyle(fontSize: 11.sp),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        quotation.isActive ? Icons.toggle_on : Icons.toggle_off,
                      ),
                      onPressed: () => _toggleStatus(context, ref, quotation),
                      tooltip: quotation.isActive ? 'Deactivate' : 'Activate',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showQuotationForm(context, quotation),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(context, ref, quotation),
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
        onPressed: () => _showQuotationForm(context, null),
        icon: const Icon(Icons.add),
        label: const Text('New Quotation'),
      ),
    );
  }

  void _showQuotationForm(BuildContext context, VendorQuotation? quotation) {
    showDialog(
      context: context,
      builder: (context) => QuotationFormDialog(quotation: quotation),
    );
  }

  void _toggleStatus(
    BuildContext context,
    WidgetRef ref,
    VendorQuotation quotation,
  ) async {
    try {
      await ref
          .read(adminRepositoryProvider)
          .toggleQuotationStatus(quotation.id, !quotation.isActive);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Quotation ${!quotation.isActive ? "activated" : "deactivated"}',
            ),
          ),
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
    VendorQuotation quotation,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quotation'),
        content: Text(
          'Delete quotation for ${quotation.vendorName}? This cannot be undone.',
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
                    .deleteQuotation(quotation.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quotation deleted')),
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
