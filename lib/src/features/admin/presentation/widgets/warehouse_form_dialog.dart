import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:rightlogistics/src/features/admin/presentation/providers/admin_providers.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';

class WarehouseFormDialog extends ConsumerStatefulWidget {
  final LogisticsWarehouse? warehouse;

  const WarehouseFormDialog({super.key, this.warehouse});

  @override
  ConsumerState<WarehouseFormDialog> createState() =>
      _WarehouseFormDialogState();
}

class _WarehouseFormDialogState extends ConsumerState<WarehouseFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  late TextEditingController _countryController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _streetController;
  late TextEditingController _zipController;
  late TextEditingController _phoneController;
  String? _selectedVendorId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.warehouse?.name ?? '');
    _addressController = TextEditingController(
      text: widget.warehouse?.address ?? '',
    );
    _latController = TextEditingController(
      text: widget.warehouse?.location.latitude.toString() ?? '',
    );
    _lngController = TextEditingController(
      text: widget.warehouse?.location.longitude.toString() ?? '',
    );
    _countryController = TextEditingController(
      text: widget.warehouse?.location.country ?? '',
    );
    _stateController = TextEditingController(
      text: widget.warehouse?.location.state ?? '',
    );
    _cityController = TextEditingController(
      text: widget.warehouse?.location.city ?? '',
    );
    _streetController = TextEditingController(
      text: widget.warehouse?.location.street ?? '',
    );
    _zipController = TextEditingController(
      text: widget.warehouse?.location.zip ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.warehouse?.contactPhone ?? '',
    );
    _selectedVendorId = widget.warehouse?.vendorId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _zipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveWarehouse() async {
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
      final location = ShipmentLocation(
        latitude: double.parse(_latController.text),
        longitude: double.parse(_lngController.text),
        address: _addressController.text.trim(),
        country: _countryController.text.trim().isEmpty
            ? null
            : _countryController.text.trim(),
        state: _stateController.text.trim().isEmpty
            ? null
            : _stateController.text.trim(),
        city: _cityController.text.trim().isEmpty
            ? null
            : _cityController.text.trim(),
        street: _streetController.text.trim().isEmpty
            ? null
            : _streetController.text.trim(),
        zip: _zipController.text.trim().isEmpty
            ? null
            : _zipController.text.trim(),
      );

      if (widget.warehouse == null) {
        // Create new warehouse
        final newWarehouse = LogisticsWarehouse(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text.trim(),
          address: _addressController.text.trim(),
          location: location,
          vendorId: _selectedVendorId!,
          contactPhone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        );

        await repository.createWarehouse(newWarehouse);
      } else {
        // Update existing warehouse
        final updatedWarehouse = widget.warehouse!.copyWith(
          name: _nameController.text.trim(),
          address: _addressController.text.trim(),
          location: location,
          vendorId: _selectedVendorId!,
          contactPhone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        );

        await repository.updateWarehouse(updatedWarehouse);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.warehouse == null
                  ? 'Warehouse created successfully'
                  : 'Warehouse updated successfully',
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
                      widget.warehouse == null
                          ? 'Create Warehouse'
                          : 'Edit Warehouse',
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

                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Warehouse Name',
                    prefixIcon: const Icon(Icons.warehouse),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                  ),
                  validator: (value) =>
                      value?.trim().isEmpty ?? true ? 'Name is required' : null,
                ),
                SizedBox(height: 16.h),

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
                    onChanged: (value) =>
                        setState(() => _selectedVendorId = value),
                    validator: (value) =>
                        value == null ? 'Vendor is required' : null,
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error loading vendors: $err'),
                ),
                SizedBox(height: 16.h),

                // Address
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Full Address',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                  ),
                  maxLines: 2,
                  validator: (value) => value?.trim().isEmpty ?? true
                      ? 'Address is required'
                      : null,
                ),
                SizedBox(height: 16.h),

                // Location Coordinates
                Text(
                  'GPS Coordinates',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latController,
                        decoration: InputDecoration(
                          labelText: 'Latitude',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) return 'Required';
                          if (double.tryParse(value!) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: TextFormField(
                        controller: _lngController,
                        decoration: InputDecoration(
                          labelText: 'Longitude',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) return 'Required';
                          if (double.tryParse(value!) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Additional Location Details
                ExpansionTile(
                  title: Text(
                    'Additional Details (Optional)',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  children: [
                    TextFormField(
                      controller: _streetController,
                      decoration: InputDecoration(
                        labelText: 'Street',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _stateController,
                            decoration: InputDecoration(
                              labelText: 'State/Region',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextFormField(
                            controller: _zipController,
                            decoration: InputDecoration(
                              labelText: 'Zip/Postal',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    TextFormField(
                      controller: _countryController,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Contact Phone
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Contact Phone (Optional)',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 24.h),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveWarehouse,
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
                            widget.warehouse == null
                                ? 'CREATE WAREHOUSE'
                                : 'UPDATE WAREHOUSE',
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
