import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/common/data/storage_repository.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/social/domain/status_model.dart';
import 'package:rightlogistics/src/features/social/presentation/providers/social_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rightlogistics/src/features/notifications/data/notifications_repository.dart';
import 'package:rightlogistics/src/features/onboarding/presentation/widgets/dynamic_input_list.dart';
import 'package:rightlogistics/src/features/common/presentation/widgets/country_selector_dialog.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';

class SocialPostCreator extends ConsumerStatefulWidget {
  const SocialPostCreator({super.key});

  @override
  ConsumerState<SocialPostCreator> createState() => _SocialPostCreatorState();
}

class _SocialPostCreatorState extends ConsumerState<SocialPostCreator> {
  final _descriptionController = TextEditingController();
  final _detailsController = TextEditingController();
  final _priceController = TextEditingController();
  final _minOrderController = TextEditingController();
  final _maxOrderController = TextEditingController();
  final _titleController = TextEditingController();
  final _deliveryTimeController = TextEditingController();
  final _deliveryModeController = TextEditingController();
  final _minQuantityController = TextEditingController();
  final _locationController = TextEditingController();
  final _supplierTypeController = TextEditingController();
  final _capacityController = TextEditingController();
  final _promoCodeController = TextEditingController();
  final _discountPercentageController = TextEditingController();
  final _discountAmountController = TextEditingController();
  final _termsController = TextEditingController();
  final _minPurchaseController = TextEditingController();
  final _usageLimitController = TextEditingController();

  List<Map<String, dynamic>> _warehouseLocations = [];

  final List<File> _imageFiles = [];
  PostType _selectedType = PostType.update;
  bool _isLoading = false;
  bool _isPurchasable = false;
  DateTime? _eta; // New
  DateTime? _promoExpiry;
  PostVisibility _selectedVisibility = PostVisibility.public;

  @override
  void initState() {
    super.initState();
    _discountPercentageController.addListener(_onDiscountChanged);
    _discountAmountController.addListener(_onDiscountChanged);
  }

  @override
  void dispose() {
    _discountPercentageController.removeListener(_onDiscountChanged);
    _discountAmountController.removeListener(_onDiscountChanged);
    _descriptionController.dispose();
    _detailsController.dispose();
    _priceController.dispose();
    _minOrderController.dispose();
    _maxOrderController.dispose();
    _titleController.dispose();
    _deliveryTimeController.dispose();
    _deliveryModeController.dispose();
    _minQuantityController.dispose();
    _locationController.dispose();
    _supplierTypeController.dispose();
    _capacityController.dispose();
    _promoCodeController.dispose();
    _discountPercentageController.dispose();
    _discountAmountController.dispose();
    _termsController.dispose();
    _minPurchaseController.dispose();
    _usageLimitController.dispose();
    super.dispose();
  }

  void _onDiscountChanged() {
    if (_promoCodeController.text.isEmpty) {
      final value =
          _discountPercentageController.text + _discountAmountController.text;
      if (value.isNotEmpty) {
        _generateCouponCode();
      }
    }
  }

  void _generateCouponCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = math.Random();
    final code = String.fromCharCodes(
      Iterable.generate(
        10,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
    setState(() {
      _promoCodeController.text = code;
    });
  }

  Future<void> _pickImages() async {
    final storage = ref.read(storageRepositoryProvider);
    final file = await storage.pickAndProcessFile();
    if (file != null) {
      setState(() => _imageFiles.add(file));
    }
  }

  void _removeImage(int index) {
    setState(() => _imageFiles.removeAt(index));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _eta = picked);
    }
  }

  Future<void> _pickPromoExpiry() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _promoExpiry = picked);
    }
  }

  Future<void> _handleCreatePost() async {
    if (_descriptionController.text.isEmpty || _imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one image and a caption'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      // 1. Upload Images
      final storage = ref.read(storageRepositoryProvider);
      final List<String> imageUrls = [];

      for (final file in _imageFiles) {
        final url = await storage.uploadFile(
          file: file,
          pathPrefix: 'social_posts',
        );
        if (url != null) imageUrls.add(url);
      }

      if (imageUrls.isEmpty) throw Exception('No images were uploaded');

      // 2. Determine if it's a Status or a Post
      if (_selectedType == PostType.status_Update) {
        final status = StatusModel(
          id: '',
          vendorId: user.id,
          vendorName: user.name,
          vendorPhotoUrl: user.photoUrl,
          mediaUrl: imageUrls.first,
          mediaType: 'image',
          caption: _descriptionController.text.trim(),
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
        );
        await ref.read(socialRepositoryProvider).createStatus(status);
      } else {
        // 2. Create Post object
        final post = VendorPost(
          id: '',
          vendorId: user.id,
          vendorName: user.name,
          vendorPhotoUrl: user.photoUrl,
          imageUrls: imageUrls,
          description: _descriptionController.text.trim(),
          title: _titleController.text.trim().isNotEmpty
              ? _titleController.text.trim()
              : null,
          details: _detailsController.text.trim().isNotEmpty
              ? _detailsController.text.trim()
              : null,
          price: double.tryParse(_priceController.text) ?? 0.0,
          isPurchasable: _isPurchasable,
          minOrder: int.tryParse(_minOrderController.text),
          maxOrder: int.tryParse(_maxOrderController.text),
          deliveryTime: _deliveryTimeController.text.trim().isNotEmpty
              ? _deliveryTimeController.text.trim()
              : null,
          deliveryMode: _deliveryModeController.text.trim().isNotEmpty
              ? _deliveryModeController.text.trim()
              : null,
          eta: _eta,
          promoCode: _promoCodeController.text.trim().isNotEmpty
              ? _promoCodeController.text.trim()
              : null,
          discountPercentage: double.tryParse(
            _discountPercentageController.text,
          ),
          discountAmount: double.tryParse(_discountAmountController.text),
          promoExpiry: _promoExpiry,
          termsAndConditions: _termsController.text.trim().isNotEmpty
              ? _termsController.text.trim()
              : null,
          minPurchaseAmount: double.tryParse(_minPurchaseController.text),
          usageLimit: int.tryParse(_usageLimitController.text),
          type: _selectedType,
          visibility: _selectedVisibility,
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(hours: 48)),
          metadata: {
            if (_locationController.text.isNotEmpty)
              'location': _locationController.text.trim(),
            if (_minQuantityController.text.isNotEmpty)
              'minQuantity': _minQuantityController.text.trim(),
            if (_supplierTypeController.text.isNotEmpty)
              'supplierType': _supplierTypeController.text.trim(),
            if (_capacityController.text.isNotEmpty)
              'capacity': _capacityController.text.trim(),
            'locations': _warehouseLocations,
          },
        );

        // 3. Save to Firestore
        await ref.read(socialRepositoryProvider).createPost(post);

        // 4. Update Vendor addresses in KYC if applicable
        if (user.role == UserRole.vendor && _warehouseLocations.isNotEmpty) {
          final currentAddresses = user.vendorKyc?.vendorAddresses ?? [];
          final List<Map<String, dynamic>> updatedAddresses = List.from(
            currentAddresses,
          );

          bool modified = false;
          for (final loc in _warehouseLocations) {
            // Check if location is non-empty enough to be worth adding
            if ((loc['label']?.toString().isNotEmpty ?? false) ||
                (loc['street']?.toString().isNotEmpty ?? false)) {
              // Check for potential duplicate by label and street
              bool isDuplicate = currentAddresses.any(
                (addr) =>
                    addr['label'] == loc['label'] &&
                    addr['street'] == loc['street'],
              );

              if (!isDuplicate) {
                updatedAddresses.add(Map<String, dynamic>.from(loc));
                modified = true;
              }
            }
          }

          if (modified) {
            final updatedKyc = (user.vendorKyc ?? const VendorKyc()).copyWith(
              vendorAddresses: updatedAddresses,
            );
            final updatedUser = user.copyWith(vendorKyc: updatedKyc);
            await ref.read(authRepositoryProvider).updateUser(updatedUser);
          }
        }
      }

      // 4. Send Broadcast Notification
      await ref
          .read(notificationRepositoryProvider)
          .broadcastPostNotification(
            user.name,
            _descriptionController.text.trim(),
            _selectedType,
          );

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post published successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeader(context),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMediaSection(colorScheme),
                    const SizedBox(height: 32),
                    _buildPostTypeSelector(colorScheme),
                    const SizedBox(height: 32),
                    _buildVisibilitySelector(colorScheme),
                    const SizedBox(height: 32),
                    const SizedBox(height: 32),
                    _buildMainFields(colorScheme),
                    const SizedBox(height: 24),
                    if (_selectedType == PostType.pre_Order ||
                        _selectedType == PostType.new_Item ||
                        _selectedType == PostType.product_Launch)
                      _buildCommerceFields(colorScheme),
                    if (_selectedType == PostType.logistics ||
                        _selectedType == PostType.warehouse ||
                        _selectedType == PostType.warehouse_Supplier)
                      _buildLogisticsFields(colorScheme),
                    if (_selectedType == PostType.warehouse ||
                        _selectedType == PostType.warehouse_Supplier)
                      _buildWarehouseFields(colorScheme),
                    if (_selectedType == PostType.promotion)
                      _buildPromotionFields(colorScheme),
                    const SizedBox(height: 48),
                    _buildPostButton(context),
                    const SizedBox(height: 80), // Final bottom space
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, size: 28),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Share an Update',
        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      centerTitle: false,
    );
  }

  Widget _buildMediaSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'MEDIAGALLERY',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1.5,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (_imageFiles.isNotEmpty)
              Text(
                '${_imageFiles.length} Selected',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _imageFiles.length + 1,
            itemBuilder: (context, index) {
              if (index == _imageFiles.length) {
                return _buildAddMediaButton(colorScheme);
              }
              return _buildMediaTile(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddMediaButton(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_rounded,
              color: colorScheme.primary,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              'Add More',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaTile(int index) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: FileImage(_imageFiles[index]),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black54,
                child: Icon(Icons.close_rounded, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostTypeSelector(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'POST CATEGORY',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 1.5,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 4,
          //runSpacing: 4,
          children: PostType.values.map((type) {
            final isSelected = _selectedType == type;
            return FilterChip(
              selected: isSelected,
              label: Text(
                type.name.replaceAll(RegExp(r'_|^'), ' ').toUpperCase(),
              ),
              onSelected: (val) {
                setState(() {
                  _selectedType = type;
                  if (type == PostType.pre_Order) _isPurchasable = true;
                });
              },
              selectedColor: colorScheme.primary.withOpacity(0.15),
              checkmarkColor: colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outline.withOpacity(0.2),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVisibilitySelector(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'VISIBILITY',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 1.5,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PostVisibility>(
              value: _selectedVisibility,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down_rounded,
                color: colorScheme.primary,
              ),
              onChanged: (val) {
                if (val != null) setState(() => _selectedVisibility = val);
              },
              items: PostVisibility.values.map((v) {
                return DropdownMenuItem(
                  value: v,
                  child: Row(
                    children: [
                      Icon(
                        v == PostVisibility.public
                            ? Icons.public
                            : v == PostVisibility.connections
                            ? Icons.people
                            : Icons.lock_outline,
                        size: 18,
                        color: colorScheme.onSurface,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        v.name..toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainFields(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          label: 'CAPTION',
          controller: _descriptionController,
          hint: 'Summarize your update...',
          maxLines: 2,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 24),
        _buildInputField(
          label: 'DETAILS / SPECIFICATIONS',
          controller: _detailsController,
          hint: 'Provide full details, sizes, weight, etc...',
          maxLines: 5,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildCommerceFields(ColorScheme colorScheme) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'SALES & PURCHASE OPTIONS',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: colorScheme.secondary,
                ),
              ),
              const Spacer(),
              Switch.adaptive(
                value: _isPurchasable,
                onChanged: (val) => setState(() => _isPurchasable = val),
                activeColor: colorScheme.secondary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isPurchasable) ...[
            _buildInputField(
              label: 'PRICE (GHS)',
              controller: _priceController,
              hint: '0.00',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.payments_rounded,
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 20),
            if (_selectedType == PostType.pre_Order) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      label: 'MIN QUANTITY',
                      controller: _minQuantityController,
                      hint: 'e.g., 50',
                      keyboardType: TextInputType.number,
                      colorScheme: colorScheme,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputField(
                      label: 'DELIVERY TIME',
                      controller: _deliveryTimeController,
                      hint: 'e.g., 5-7 days',
                      colorScheme: colorScheme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'DELIVERY MODE',
                controller: _deliveryModeController,
                hint: 'e.g., Sea Freight, Air Cargo',
                prefixIcon: Icons.local_shipping_rounded,
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 20),
            ],
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'TITLE / ITEM NAME',
                    controller: _titleController,
                    hint: 'e.g., iPhone 16 Pro',
                    colorScheme: colorScheme,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: _buildInputField(
                        label: 'ETA',
                        controller: TextEditingController(
                          text: _eta != null
                              ? '${_eta!.day}/${_eta!.month}/${_eta!.year}'
                              : '',
                        ),
                        hint: 'Select Date',
                        prefixIcon: Icons.calendar_today_rounded,
                        colorScheme: colorScheme,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogisticsFields(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LOGISTICS PARAMETERS',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 1.5,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                label: 'MIN ORDER (KG)',
                controller: _minOrderController,
                hint: '0.5',
                keyboardType: TextInputType.number,
                colorScheme: colorScheme,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(
                label: 'MAX ORDER (CBM)',
                controller: _maxOrderController,
                hint: '10',
                keyboardType: TextInputType.number,
                colorScheme: colorScheme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWarehouseFields(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'WAREHOUSE & SUPPLIER DETAILS',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 1.5,
            color: colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 16),
        DynamicInputList<Map<String, dynamic>>(
          title: 'Offices & Warehouses',
          addLabel: 'Add Location',
          items: _warehouseLocations,
          onAdd: () => setState(
            () => _warehouseLocations.add({
              'label': '',
              'country': '',
              'street': '',
              'city': '',
              'state': '',
              'zip': '',
              'phones': <String>[],
            }),
          ),
          onRemove: (index) =>
              setState(() => _warehouseLocations.removeAt(index)),
          itemBuilder: (index, item) {
            final phones = (item['phones'] as List? ?? []).cast<String>();
            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(16.w),
                color: colorScheme.surfaceContainerHighest.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabeledTextInput(
                    label: 'LOCATION NAME',
                    hint: 'e.g. Accra Network Hub',
                    initialValue: item['label'] ?? '',
                    onChanged: (val) => item['label'] = val,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'COUNTRY',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      letterSpacing: 1,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CountrySelectorDialog(
                          onSelect: (country) {
                            setState(() {
                              item['country'] = country.name;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withOpacity(
                          0.2,
                        ),
                        borderRadius: BorderRadius.circular(16.w),
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.public_rounded,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item['country']?.isNotEmpty == true
                                  ? item['country']!
                                  : 'Select Country',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: item['country']?.isNotEmpty == true
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurfaceVariant.withOpacity(
                                        0.4,
                                      ),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LabeledTextInput(
                    label: 'STREET ADDRESS',
                    hint: 'Street Name & Number',
                    initialValue: item['street'] ?? '',
                    onChanged: (val) => item['street'] = val,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: LabeledTextInput(
                          label: 'CITY',
                          hint: 'City',
                          initialValue: item['city'] ?? '',
                          onChanged: (val) => item['city'] = val,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: LabeledTextInput(
                          label: 'STATE / REGION',
                          hint: 'Region',
                          initialValue: item['state'] ?? '',
                          onChanged: (val) => item['state'] = val,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LabeledTextInput(
                    label: 'ZIP / POSTAL CODE',
                    hint: 'Zip Code',
                    initialValue: item['zip'] ?? '',
                    onChanged: (val) => item['zip'] = val,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CONTACT NUMBERS',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          letterSpacing: 1,
                          color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            if (item['phones'] == null) {
                              item['phones'] = <String>[];
                            }
                            (item['phones'] as List).add('');
                          });
                        },
                        icon: const Icon(Icons.add, size: 14),
                        label: const Text(
                          'ADD PHONE',
                          style: TextStyle(fontSize: 10),
                        ),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          foregroundColor: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  if (phones.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'No phone numbers added.',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ...phones.asMap().entries.map((entry) {
                    final pIndex = entry.key;
                    final pVal = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          LabeledTextInput(
                            hint: 'Phone Number (e.g. +123...)',
                            initialValue: pVal,
                            keyboardType: TextInputType.phone,
                            onChanged: (val) {
                              phones[pIndex] = val;
                              item['phones'] = phones;
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.redAccent,
                              size: 18,
                            ),
                            onPressed: () {
                              setState(() {
                                (item['phones'] as List).removeAt(pIndex);
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        if (_selectedType == PostType.warehouse ||
            _selectedType == PostType.warehouse_Supplier) ...[
          _buildInputField(
            label: 'SUPPLIER / WAREHOUSE TYPE',
            controller: _supplierTypeController,
            hint: 'e.g., Cold Storage, Manufacturer, etc.',
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 20),
          _buildInputField(
            label: 'AVAILABLE CAPACITY',
            controller: _capacityController,
            hint: 'e.g., 500 SQM, 1000 Tons',
            colorScheme: colorScheme,
          ),
        ],
      ],
    );
  }

  Widget _buildPromotionFields(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'PROMOTION DETAILS',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 1.5,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        _buildInputField(
          label: 'COUPON CODE',
          controller: _promoCodeController,
          hint: 'e.g., WINTER25',
          prefixIcon: Icons.qr_code_rounded,
          suffixIcon: Icons.refresh_rounded,
          onSuffixTap: _generateCouponCode,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                label: 'DISCOUNT %',
                controller: _discountPercentageController,
                hint: '0',
                keyboardType: TextInputType.number,
                colorScheme: colorScheme,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(
                label: 'DISCOUNT AMT (GHS)',
                controller: _discountAmountController,
                hint: '0.00',
                keyboardType: TextInputType.number,
                colorScheme: colorScheme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                label: 'MIN PURCHASE (GHS)',
                controller: _minPurchaseController,
                hint: '0.00',
                keyboardType: TextInputType.number,
                colorScheme: colorScheme,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(
                label: 'USAGE LIMIT',
                controller: _usageLimitController,
                hint: 'e.g., 100',
                keyboardType: TextInputType.number,
                colorScheme: colorScheme,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _pickPromoExpiry,
          child: AbsorbPointer(
            child: _buildInputField(
              label: 'EXPIRY DATE',
              controller: TextEditingController(
                text: _promoExpiry != null
                    ? '${_promoExpiry!.day}/${_promoExpiry!.month}/${_promoExpiry!.year}'
                    : '',
              ),
              hint: 'Select Expiry Date',
              prefixIcon: Icons.event_available_rounded,
              colorScheme: colorScheme,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildInputField(
          label: 'TERMS & CONDITIONS',
          controller: _termsController,
          hint: 'e.g., Only valid for first-time orders...',
          maxLines: 3,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    void Function(String)? onChanged,
    required ColorScheme colorScheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 1,
              color: colorScheme.onSurfaceVariant.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 10),
        ],
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant.withOpacity(0.4),
              fontSize: 14,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: colorScheme.primary, size: 20)
                : null,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      suffixIcon,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    onPressed: onSuffixTap,
                  )
                : null,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.2),
            contentPadding: EdgeInsets.all(18.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.w),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleCreatePost,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        shadowColor: colorScheme.primary.withOpacity(0.4),
      ),
      child: _isLoading
          ? SizedBox(
              width: 24.w,
              height: 24.h,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Text(
              'PUBLISH UPDATE',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                fontSize: 16.sp,
                letterSpacing: 2,
              ),
            ),
    );
  }
}
