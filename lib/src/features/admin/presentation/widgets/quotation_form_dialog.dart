import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/admin/domain/admin_models.dart';
import 'package:rightlogistics/src/features/admin/presentation/providers/admin_providers.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';

class QuotationFormDialog extends ConsumerStatefulWidget {
  final VendorQuotation? quotation;

  const QuotationFormDialog({super.key, this.quotation});

  @override
  ConsumerState<QuotationFormDialog> createState() =>
      _QuotationFormDialogState();
}

class _QuotationFormDialogState extends ConsumerState<QuotationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _rateController;
  late TextEditingController _minimumWeightController;
  late TextEditingController _minimumVolumeController;
  late TextEditingController _notesController;
  late FreightType _selectedFreightType;
  DeliverySpeed? _selectedDeliverySpeed;
  late ItemCategory _selectedCategory;
  String? _selectedVendorId;
  DateTime? _validFrom;
  DateTime? _validUntil;
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _rateController = TextEditingController(
      text: widget.quotation?.ratePerUnit.toString() ?? '',
    );
    _minimumWeightController = TextEditingController(
      text: widget.quotation?.minimumWeight?.toString() ?? '',
    );
    _minimumVolumeController = TextEditingController(
      text: widget.quotation?.minimumVolume?.toString() ?? '',
    );
    _notesController = TextEditingController(
      text: widget.quotation?.notes ?? '',
    );
    _selectedFreightType = widget.quotation?.freightType ?? FreightType.air;
    _selectedDeliverySpeed = widget.quotation?.deliverySpeed;
    _selectedCategory = widget.quotation?.itemCategory ?? ItemCategory.normal;
    _selectedVendorId = widget.quotation?.vendorId;
    _validFrom = widget.quotation?.validFrom ?? DateTime.now();
    _validUntil =
        widget.quotation?.validUntil ??
        DateTime.now().add(const Duration(days: 30));
    _isActive = widget.quotation?.isActive ?? true;
  }

  @override
  void dispose() {
    _rateController.dispose();
    _minimumWeightController.dispose();
    _minimumVolumeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveQuotation() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedVendorId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a vendor')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(adminRepositoryProvider);
      final vendor = await repository.getUserById(_selectedVendorId!);

      if (vendor == null) throw Exception('Vendor not found');

      final now = DateTime.now();

      if (widget.quotation == null) {
        // Create new quotation
        final newQuotation = VendorQuotation(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          vendorId: _selectedVendorId!,
          vendorName: vendor.name,
          freightType: _selectedFreightType,
          deliverySpeed: _selectedDeliverySpeed,
          itemCategory: _selectedCategory,
          ratePerUnit: double.parse(_rateController.text),
          minimumWeight: _minimumWeightController.text.trim().isEmpty
              ? null
              : double.tryParse(_minimumWeightController.text),
          minimumVolume: _minimumVolumeController.text.trim().isEmpty
              ? null
              : double.tryParse(_minimumVolumeController.text),
          validFrom: _validFrom!,
          validUntil: _validUntil!,
          isActive: _isActive,
          createdAt: now,
          updatedAt: now,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

        await repository.createQuotation(newQuotation);
      } else {
        // Update existing quotation
        final updatedQuotation = widget.quotation!.copyWith(
          vendorId: _selectedVendorId!,
          vendorName: vendor.name,
          freightType: _selectedFreightType,
          deliverySpeed: _selectedDeliverySpeed,
          itemCategory: _selectedCategory,
          ratePerUnit: double.parse(_rateController.text),
          minimumWeight: _minimumWeightController.text.trim().isEmpty
              ? null
              : double.tryParse(_minimumWeightController.text),
          minimumVolume: _minimumVolumeController.text.trim().isEmpty
              ? null
              : double.tryParse(_minimumVolumeController.text),
          validFrom: _validFrom!,
          validUntil: _validUntil!,
          isActive: _isActive,
          updatedAt: now,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

        await repository.updateQuotation(updatedQuotation);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.quotation == null
                  ? 'Quotation created successfully'
                  : 'Quotation updated successfully',
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
    final vendorsAsync = ref.watch(usersByRoleProvider(UserRole.vendor));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 600.w, maxHeight: 700.h),
        padding: EdgeInsets.all(24.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.quotation == null
                          ? 'Create Quotation'
                          : 'Edit Quotation',
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

                // Vendor Selector
                vendorsAsync.when(
                  data: (vendors) => DropdownButtonFormField<String>(
                    value: _selectedVendorId,
                    decoration: InputDecoration(
                      labelText: 'Vendor',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                    ),
                    items: vendors.map((vendor) {
                      return DropdownMenuItem(
                        value: vendor.id,
                        child: Text(vendor.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVendorId = value;
                        if (value != null) {
                          final vendor = vendors.firstWhere(
                            (v) => v.id == value,
                          );
                          final rates = vendor.vendorKyc?.vendorRates ?? [];

                          // Convert 'FreightType.air' -> 'Air' or similar for matching
                          // Assuming rate map has keys like 'type' and 'rate'
                          // Simple heuristic: find first rate that matches current freight type or just take first

                          if (rates.isNotEmpty) {
                            // Example structure: {'type': 'Air Freight', 'rate': '5.50', 'minWeight': '10'}
                            // You might need to refine this based on actual data structure seeded
                            // For now, let's try to find a match or default to first

                            Map<String, String>? match;
                            try {
                              match = rates.firstWhere(
                                (r) =>
                                    r['type'].toString().toLowerCase().contains(
                                      _selectedFreightType.name.toLowerCase(),
                                    ),
                              );
                            } catch (_) {
                              if (rates.isNotEmpty) match = rates.first;
                            }

                            if (match != null) {
                              _rateController.text = match['rate'] ?? '';
                              if (_selectedFreightType == FreightType.air) {
                                _minimumWeightController.text =
                                    match['minWeight'] ?? '';
                              } else {
                                _minimumVolumeController.text =
                                    match['minVolume'] ?? '';
                              }
                            }
                          }
                        }
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Vendor is required' : null,
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                ),
                SizedBox(height: 16.h),

                // Freight Type
                Text(
                  'Freight Type',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  children: FreightType.values.map((type) {
                    final isSelected = _selectedFreightType == type;
                    return FilterChip(
                      selected: isSelected,
                      label: Text(type.name.toUpperCase()),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedFreightType = type;
                            if (type == FreightType.sea)
                              _selectedDeliverySpeed = null;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),

                // Delivery Speed (Air only)
                if (_selectedFreightType == FreightType.air) ...[
                  Text(
                    'Delivery Speed',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    children: DeliverySpeed.values.map((speed) {
                      final isSelected = _selectedDeliverySpeed == speed;
                      return FilterChip(
                        selected: isSelected,
                        label: Text(speed.name.toUpperCase()),
                        onSelected: (selected) {
                          setState(
                            () => _selectedDeliverySpeed = selected
                                ? speed
                                : null,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),
                ],

                // Item Category
                Text(
                  'Item Category',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  children:
                      (_selectedFreightType == FreightType.air
                              ? [
                                  ItemCategory.normal,
                                  ItemCategory.sensitive,
                                  ItemCategory.phone,
                                  ItemCategory.laptop,
                                ]
                              : [ItemCategory.normal, ItemCategory.special])
                          .map((category) {
                            final isSelected = _selectedCategory == category;
                            return FilterChip(
                              selected: isSelected,
                              label: Text(category.name.toUpperCase()),
                              onSelected: (selected) {
                                if (selected)
                                  setState(() => _selectedCategory = category);
                              },
                            );
                          })
                          .toList(),
                ),
                SizedBox(height: 16.h),

                // Rate Per Unit
                TextFormField(
                  controller: _rateController,
                  decoration: InputDecoration(
                    labelText: 'Rate Per Unit (\$/kg or \$/CBM or flat)',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true)
                      return 'Rate is required';
                    if (double.tryParse(value!) == null)
                      return 'Invalid number';
                    return null;
                  },
                ),
                SizedBox(height: 16.h),

                // Minimum Weight/Volume
                if (_selectedFreightType == FreightType.air)
                  TextFormField(
                    controller: _minimumWeightController,
                    decoration: InputDecoration(
                      labelText: 'Minimum Weight (kg) - Optional',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  )
                else
                  TextFormField(
                    controller: _minimumVolumeController,
                    decoration: InputDecoration(
                      labelText: 'Minimum Volume (CBM) - Optional',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                SizedBox(height: 16.h),

                // Validity Dates
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _validFrom ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 730),
                            ),
                          );
                          if (date != null) setState(() => _validFrom = date);
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          'From: ${_validFrom?.toString().substring(0, 10) ?? "Not set"}',
                          style: TextStyle(fontSize: 11.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate:
                                _validUntil ??
                                DateTime.now().add(const Duration(days: 30)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 730),
                            ),
                          );
                          if (date != null) setState(() => _validUntil = date);
                        },
                        icon: const Icon(Icons.event),
                        label: Text(
                          'Until: ${_validUntil?.toString().substring(0, 10) ?? "Not set"}',
                          style: TextStyle(fontSize: 11.sp),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 16.h),

                // Active Status
                SwitchListTile(
                  title: const Text('Active Status'),
                  subtitle: Text(
                    _isActive ? 'Quotation is active' : 'Quotation is inactive',
                  ),
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                ),
                SizedBox(height: 24.h),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveQuotation,
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
                            widget.quotation == null
                                ? 'CREATE QUOTATION'
                                : 'UPDATE QUOTATION',
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
        ),
      ),
    );
  }
}
