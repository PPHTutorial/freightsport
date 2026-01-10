import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/admin/presentation/client_directory_screen.dart';
import 'package:rightlogistics/src/features/admin/presentation/create_shipment_controller.dart';
import 'package:rightlogistics/src/features/tracking/domain/shipment_model.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/tracking/data/firestore_shipment_repository.dart';

class CreateShipmentScreen extends ConsumerStatefulWidget {
  const CreateShipmentScreen({super.key});

  @override
  ConsumerState<CreateShipmentScreen> createState() =>
      _CreateShipmentScreenState();
}

class _CreateShipmentScreenState extends ConsumerState<CreateShipmentScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createShipmentProvider);
    final controller = ref.read(createShipmentProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Create Shipment',
          style: GoogleFonts.redHatDisplay(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildStepIndicator(state.currentStep),
          Expanded(
            child: Form(
              key: _formKey,
              child: _buildStepContent(state, controller),
            ),
          ),
          _buildBottomBar(state, controller),
          SizedBox(height: 48.h),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int currentStep) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: List.generate(7, (index) {
          final isActive = index <= currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive
                    ? AppTheme.accentOrange
                    : AppTheme.accentOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent(
    CreateShipmentState state,
    CreateShipmentController controller,
  ) {
    switch (state.currentStep) {
      case 0:
        return _VendorSelectionStep(state: state, controller: controller);
      case 1:
        return _PackageEntryStep(state: state, controller: controller);
      case 2:
        return _OriginStep(state: state, controller: controller);
      case 3:
        return _WarehouseStep(state: state, controller: controller);
      case 4:
        return _DestinationStep(state: state, controller: controller);
      case 5:
        return _CostReviewStep(state: state, controller: controller);
      case 6:
        return _FinalReviewStep(state: state, controller: controller);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomBar(
    CreateShipmentState state,
    CreateShipmentController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (state.currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: controller.previousStep,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back'),
              ),
            )
          else
            const Spacer(),
          SizedBox(width: 8.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () async {
                if (state.currentStep == 6) {
                  // Submit
                  final success = await controller.submitShipment();
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Shipment created successfully!'),
                      ),
                    );
                    context.pop();
                  } else if (state.error != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.error}')),
                    );
                  }
                } else if (state.currentStep == 5) {
                  controller.nextStep();
                } else {
                  controller.validateAndNext((msg) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(msg)));
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentOrange,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                state.currentStep == 6 ? 'Place Order' : 'Continue',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Steps ---

class _VendorSelectionStep extends ConsumerWidget {
  final CreateShipmentState state;
  final CreateShipmentController controller;

  const _VendorSelectionStep({required this.state, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select a Vendor',
            style: GoogleFonts.redHatDisplay(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Choose a logistics freight partner regarding their reliability.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search vendors by name or location...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                final vendors = users
                    .where((u) => u.role == UserRole.vendor)
                    .toList();
                return ListView.separated(
                  itemCount: vendors.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final vendor = vendors[index];
                    final isSelected = state.selectedVendor?.id == vendor.id;
                    return InkWell(
                      onTap: () => controller.selectVendor(vendor),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.accentOrange
                                : Colors.transparent,
                            width: 2,
                          ),
                          color: isSelected
                              ? AppTheme.accentOrange.withOpacity(0.05)
                              : Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: vendor.photoUrl != null
                                  ? CachedNetworkImageProvider(vendor.photoUrl!)
                                  : null,
                              child: vendor.photoUrl == null
                                  ? Text(vendor.name[0])
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vendor.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    vendor.kycData?['businessName'] ??
                                        'Logistics Provider',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: AppTheme.accentOrange,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, __) => Text('Error: $e'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PackageEntryStep extends ConsumerWidget {
  final CreateShipmentState state;
  final CreateShipmentController controller;
  const _PackageEntryStep({required this.state, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inventory',
                style: GoogleFonts.redHatDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddPackageDialog(context, controller),
                icon: const Icon(Icons.add_box_rounded),
                label: const Text('New Package'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.accentOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.accentOrange),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'NOTICE: If items are packaged, list them one by one inside the package.',
                    style: TextStyle(
                      color: AppTheme.accentOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: state.packages.isEmpty
                ? Center(
                    child: Text(
                      'No packages added. Start by creating a package.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: state.packages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, index) {
                      final pkg = state.packages[index];
                      return _PackageCard(
                        pkg: pkg,
                        onDelete: () => controller.removePackage(index),
                        onAddItem: () =>
                            _showAddItemBottomSheet(context, controller, index),
                        onRemoveItem: (itemIdx) =>
                            controller.removeItemFromPackage(index, itemIdx),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddPackageDialog(
    BuildContext context,
    CreateShipmentController controller,
  ) {
    final nameCtrl = TextEditingController(
      text: 'Package ${state.packages.length + 1}',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: EdgeInsets.zero,
        title: const Text('Create New Package'),
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          margin: EdgeInsets.only(top: 10.h),
          width: MediaQuery.of(context).size.width * .75,
          child: TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Package Name / Label',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final pkg = ShipmentPackage(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameCtrl.text,
                items: [],
              );
              controller.addPackage(pkg);
              Navigator.pop(ctx);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showAddItemBottomSheet(
    BuildContext context,
    CreateShipmentController controller,
    int pkgIndex,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          _AddItemSheet(controller: controller, packageIndex: pkgIndex),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final ShipmentPackage pkg;
  final VoidCallback onDelete;
  final VoidCallback onAddItem;
  final Function(int) onRemoveItem;

  const _PackageCard({
    required this.pkg,
    required this.onDelete,
    required this.onAddItem,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: const Icon(Icons.inventory_2, color: AppTheme.primaryBlue),
        title: Text(
          pkg.name ?? 'Unnamed Package',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${pkg.items.length} items • ${(pkg.totalWeight ?? 0).toStringAsFixed(1)} kg',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
        children: [
          ...pkg.items.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return ListTile(
              title: Text(item.name),
              subtitle: Text(
                '${item.quantity}x • ${item.weight}kg • ${item.currency}${item.declaredValue} • ${item.category}',
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: () => onRemoveItem(idx),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onAddItem,
                icon: const Icon(Icons.add),
                label: const Text('Add Item to Package'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddItemSheet extends StatefulWidget {
  final CreateShipmentController controller;
  final int packageIndex;
  const _AddItemSheet({required this.controller, required this.packageIndex});

  @override
  State<_AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<_AddItemSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _currCtrl = TextEditingController(text: 'USD');
  final _valCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  String _category = 'General';
  bool _isPerishable = false;
  bool _isFragile = false;

  final List<String> _categories = [
    'General',
    'Electronics',
    'Beauty Products',
    'Clothing',
    'Documents',
    'Medical',
    'Food',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 52,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Item Details',
              style: GoogleFonts.redHatDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),
            _buildTextField(_nameCtrl, 'Item Name', Icons.label),
            SizedBox(height: 16.h),
            _buildTextField(_typeCtrl, 'Type (e.g. Box)', Icons.category),
            SizedBox(height: 16.h),
            _buildTextField(_descCtrl, 'Description', Icons.description),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _weightCtrl,
                    'Weight (kg)',
                    Icons.monitor_weight,
                    isNum: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    _qtyCtrl,
                    'Quantity',
                    Icons.numbers,
                    isNum: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 120.w,
                  child: TextField(
                    controller: _currCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Curr',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    _valCtrl,
                    'Value (Unit Price)',
                    Icons.attach_money,
                    isNum: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),
            _buildTextField(_colorCtrl, 'Color', Icons.color_lens),
            const SizedBox(height: 16),
            Row(
              children: [
                FilterChip(
                  label: const Text('Perishable'),
                  selected: _isPerishable,
                  onSelected: (v) => setState(() => _isPerishable = v),
                ),
                const SizedBox(width: 12),
                FilterChip(
                  label: const Text('Fragile'),
                  selected: _isFragile,
                  onSelected: (v) => setState(() => _isFragile = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Add to Package',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    bool isNum = false,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
      ),
    );
  }

  void _submit() {
    if (_nameCtrl.text.isEmpty ||
        _weightCtrl.text.isEmpty ||
        _qtyCtrl.text.isEmpty ||
        _valCtrl.text.isEmpty) {
      return;
    }
    final item = ShipmentItem(
      name: _nameCtrl.text,
      description: _descCtrl.text,
      itemType: _typeCtrl.text.isEmpty ? 'Unit' : _typeCtrl.text,
      category: _category,
      quantity: int.tryParse(_qtyCtrl.text) ?? 1,
      weight: double.tryParse(_weightCtrl.text) ?? 0.0,
      declaredValue: double.tryParse(_valCtrl.text) ?? 0.0,
      currency: _currCtrl.text,
      color: _colorCtrl.text,
      isPerishable: _isPerishable,
      isFragile: _isFragile,
    );
    widget.controller.addItemToPackage(widget.packageIndex, item);
    Navigator.pop(context);
  }
}

class _OriginStep extends ConsumerStatefulWidget {
  final CreateShipmentState state;
  final CreateShipmentController controller;
  const _OriginStep({required this.state, required this.controller});

  @override
  ConsumerState<_OriginStep> createState() => _OriginStepState();
}

class _OriginStepState extends ConsumerState<_OriginStep> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.state.senderName);
    _phoneCtrl = TextEditingController(text: widget.state.senderPhone);
    _addressCtrl = TextEditingController(text: widget.state.senderAddress);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pickup Location',
            style: GoogleFonts.redHatDisplay(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildToggle(
            widget.state.pickupType,
            (val) => widget.controller.setPickupType(val),
          ),
          const SizedBox(height: 24),
          if (widget.state.pickupType == PickupType.supplierLocation) ...[
            TextField(
              controller: _nameCtrl,
              onChanged: (v) => widget.controller.updateSenderInfo(name: v),
              decoration: const InputDecoration(
                labelText: 'Sender Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneCtrl,
              onChanged: (v) => widget.controller.updateSenderInfo(phone: v),
              decoration: const InputDecoration(
                labelText: 'Sender Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressCtrl,
              onChanged: (v) => widget.controller.updateSenderInfo(address: v),
              decoration: const InputDecoration(
                labelText: 'Pickup Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ] else
            const Text(
              'You will select a drop-off warehouse in the next step.',
            ),
        ],
      ),
    );
  }

  Widget _buildToggle(PickupType current, Function(PickupType) onChanged) {
    return Row(
      children: [
        Expanded(
          child: ChoiceChip(
            label: const Text('Supplier Pickup'),
            selected: current == PickupType.supplierLocation,
            onSelected: (_) => onChanged(PickupType.supplierLocation),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ChoiceChip(
            label: const Text('Drop-off (Warehouse)'),
            selected: current == PickupType.vendorWarehouse,
            onSelected: (_) => onChanged(PickupType.vendorWarehouse),
          ),
        ),
      ],
    );
  }
}

class _WarehouseStep extends ConsumerWidget {
  final CreateShipmentState state;
  final CreateShipmentController controller;
  const _WarehouseStep({required this.state, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.pickupType != PickupType.vendorWarehouse) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Skipped (Supplier Pickup Selected)',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'We will pick up from your specified address.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    final warehousesAsync = ref.watch(
      warehousesStreamProvider(state.selectedVendor?.id),
    );

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Drop-off Point',
            style: GoogleFonts.redHatDisplay(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose the warehouse where you will drop off your packages.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: warehousesAsync.when(
              data: (warehouses) {
                if (warehouses.isEmpty) {
                  return const Center(child: Text('No warehouses available.'));
                }
                return ListView.separated(
                  itemCount: warehouses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final wh = warehouses[index];
                    final isSelected = state.selectedWarehouseId == wh.id;
                    return InkWell(
                      onTap: () => controller.selectWarehouse(wh),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.accentOrange
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          color: isSelected
                              ? AppTheme.accentOrange.withOpacity(0.05)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warehouse,
                              color: AppTheme.primaryBlue,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wh.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    wh.address,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: AppTheme.accentOrange,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, __) =>
                  Center(child: Text('Error loading warehouses: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _DestinationStep extends ConsumerStatefulWidget {
  final CreateShipmentState state;
  final CreateShipmentController controller;
  const _DestinationStep({required this.state, required this.controller});

  @override
  ConsumerState<_DestinationStep> createState() => _DestinationStepState();
}

class _DestinationStepState extends ConsumerState<_DestinationStep> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.state.recipientName);
    _phoneCtrl = TextEditingController(text: widget.state.recipientPhone);
    _addressCtrl = TextEditingController(text: widget.state.recipientAddress);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Destination',
            style: GoogleFonts.redHatDisplay(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameCtrl,
            onChanged: (v) => widget.controller.updateRecipientInfo(name: v),
            decoration: const InputDecoration(
              labelText: 'Recipient Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneCtrl,
            onChanged: (v) => widget.controller.updateRecipientInfo(phone: v),
            decoration: const InputDecoration(
              labelText: 'Recipient Phone',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _addressCtrl,
            onChanged: (v) => widget.controller.updateRecipientInfo(address: v),
            decoration: const InputDecoration(
              labelText: 'Delivery Address',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class _CostReviewStep extends StatelessWidget {
  final CreateShipmentState state;
  final CreateShipmentController controller;
  const _CostReviewStep({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Estimated Cost',
          style: GoogleFonts.redHatDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Based on declared value: \$${state.totalDeclaredValue.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 24),
        ...state.alternativeQuotes.map(
          (q) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(q['vendorName']),
              subtitle: Text('${q['days']} days • ${q['rating']} stars'),
              trailing: Text(
                '\$${q['price'].toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FinalReviewStep extends StatelessWidget {
  final CreateShipmentState state;
  final CreateShipmentController controller;
  const _FinalReviewStep({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 80,
            color: AppTheme.successGreen,
          ),
          const SizedBox(height: 16),
          Text(
            'Ready to Place Order?',
            style: GoogleFonts.redHatDisplay(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please review your shipment details one last time.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          _buildSummaryCard(
            context,
            'Logistics Partner',
            Icons.business,
            state.selectedVendor?.name ?? 'Not Selected',
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            context,
            'Inventory',
            Icons.inventory_2,
            '${state.packages.length} Packages • \$${state.totalDeclaredValue.toStringAsFixed(2)} Value',
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            context,
            'Origin',
            Icons.location_on,
            state.pickupType == PickupType.supplierLocation
                ? state.senderAddress ?? 'No Address'
                : 'Drop-off at Vendor Warehouse',
            subtitle: state.pickupType == PickupType.vendorWarehouse
                ? state.senderAddress
                : null,
            onCopy: state.pickupType == PickupType.vendorWarehouse
                ? () {
                    final addr = state.senderAddress ?? '';
                    if (addr.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: addr));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Address copied to clipboard'),
                        ),
                      );
                    }
                  }
                : null,
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            context,
            'Destination',
            Icons.local_shipping,
            state.recipientAddress ?? 'No Address',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    IconData icon,
    String value, {
    String? subtitle,
    VoidCallback? onCopy,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (onCopy != null)
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 20),
              onPressed: onCopy,
              color: AppTheme.primaryBlue,
              tooltip: 'Copy Address',
            ),
        ],
      ),
    );
  }
}
