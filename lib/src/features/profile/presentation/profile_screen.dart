import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rightlogistics/src/core/domain/models/country.dart';
import 'package:rightlogistics/src/core/presentation/widgets/glass_card.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/common/data/storage_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rightlogistics/src/core/presentation/providers/nav_providers.dart';
import 'package:rightlogistics/src/core/theme/app_theme.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  bool _isUploading = false;
  String? _localImagePath;

  // Personal
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  // Address (KYC)
  late TextEditingController _streetController;
  late TextEditingController _suburbController; // Added Suburb
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  late TextEditingController _countryController;

  // Professional (KYC)
  late TextEditingController _businessNameController;
  late TextEditingController _vehicleTypeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _streetController = TextEditingController();
    _suburbController = TextEditingController(); // Init Suburb
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipController = TextEditingController();
    _countryController = TextEditingController();
    _businessNameController = TextEditingController();
    _vehicleTypeController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _suburbController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    _businessNameController.dispose();
    _vehicleTypeController.dispose();
    super.dispose();
  }

  void _initializeControllers(UserModel user) {
    if (!_isEditing) {
      _nameController.text = user.name;
      _phoneController.text = user.phoneNumber ?? '';

      // 1. Address Info
      final addr = user.address;
      _streetController.text = addr?.street ?? '';
      _suburbController.text = addr?.suburb ?? '';
      _cityController.text = addr?.city ?? '';
      _stateController.text = addr?.state ?? '';
      _zipController.text = addr?.zip ?? '';
      _countryController.text = addr?.country ?? '';

      // 2. Role Specific Data
      _businessNameController.text = user.vendorKyc?.businessName ?? '';
      _vehicleTypeController.text = user.courierKyc?.vehicleType ?? '';
    }
  }

  // Helper to get formatted or raw country
  Country? _getCountryByName(String name) {
    try {
      return Country.all.firstWhere(
        (c) => c.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveProfile(UserModel user) async {
    // E.164 Validation
    String phone = _phoneController.text.trim();
    if (phone.isNotEmpty && !phone.startsWith('+')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number must start with "+" (E.164 format)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 1. Updated Address Info
    final updatedAddress = AddressInfo(
      street: _streetController.text.trim(),
      suburb: _suburbController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      zip: _zipController.text.trim(),
      country: _countryController.text.trim(),
      fullAddress:
          '${_streetController.text.trim()}, ${_suburbController.text.trim()}, ${_cityController.text.trim()}, ${_countryController.text.trim()}',
    );

    // 2. Updated Role Specific KYC
    VendorKyc? updatedVendorKyc = user.vendorKyc;
    if (user.role == UserRole.vendor) {
      updatedVendorKyc = (updatedVendorKyc ?? const VendorKyc()).copyWith(
        businessName: _businessNameController.text.trim(),
      );
    }

    CourierKyc? updatedCourierKyc = user.courierKyc;
    if (user.role == UserRole.courier) {
      updatedCourierKyc = (updatedCourierKyc ?? const CourierKyc()).copyWith(
        vehicleType: _vehicleTypeController.text.trim(),
      );
    }

    // Unified structured save (kycData will be nulled)

    final updatedUser = user.copyWith(
      name: _nameController.text.trim(),
      phoneNumber: phone,
      address: updatedAddress,
      vendorKyc: updatedVendorKyc,
      courierKyc: updatedCourierKyc,
      kycData: null, // CLEAR LEGACY DATA ON SAVE
    );

    await ref.read(authRepositoryProvider).updateUser(updatedUser);
    setState(() => _isEditing = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  bool _isGoogleUser() {
    final user = firebase.FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    return user.providerData.any((p) => p.providerId == 'google.com');
  }

  Future<void> _handleImageParams(BuildContext context, UserModel user) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.images,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _uploadProfileImage(user, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.camera,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _uploadProfileImage(user, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadProfileImage(UserModel user, ImageSource source) async {
    setState(() => _isUploading = true);
    final url = await ref
        .read(storageRepositoryProvider)
        .pickAndUploadFile(
          pathPrefix: 'profile_images',
          fileType: FileType.image,
          imageSource: source,
          onFileSelected: (file) {
            if (mounted) {
              setState(() => _localImagePath = file.path);
            }
          },
        );

    if (url != null) {
      final updatedUser = user.copyWith(photoUrl: url);
      await ref.read(authRepositoryProvider).updateUser(updatedUser);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile photo updated!')));
      }
    }
    if (mounted) setState(() => _isUploading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to real-time stream
    final asyncUser = ref.watch(authStateChangesProvider);

    Future.microtask(() {
      if (!mounted) return;
      final location = GoRouterState.of(context).uri.path;
      ref
          .read(appBarConfigProvider(location).notifier)
          .setConfig(
            AppBarConfig(
              title: 'My Profile',
              actions: [
                AppBarAction(
                  icon: FontAwesomeIcons.gear,
                  label: 'Settings',
                  onPressed: () {
                    if (mounted) context.push('/settings');
                  },
                ),
                AppBarAction(
                  icon: FontAwesomeIcons.headset,
                  label: 'Support',
                  onPressed: () {
                    if (mounted) context.push('/support');
                  },
                ),
              ],
            ),
          );
    });

    return asyncUser.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => Center(child: Text('Error loading profile: $err')),
      data: (user) {
        if (user == null) {
          return const Center(child: Text('User not found'));
        }

        if (!_isEditing) _initializeControllers(user);

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 100.h),
          child: Column(
            children: [
              _buildProfileHeader(context, user),
              SizedBox(height: 32.h),

              _buildSectionHeader('Personal Information'),
              SizedBox(height: 12.h),
              GlassCard(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    _buildEditableField(
                      label: 'Full Name',
                      controller: _nameController,
                      icon: FontAwesomeIcons.user,
                      enabled: _isEditing,
                    ),
                    Divider(height: 32.h, thickness: 0.5),
                    _buildEditableField(
                      label: 'Email Address',
                      controller: TextEditingController(text: user.email),
                      icon: FontAwesomeIcons.envelope,
                      enabled: false,
                    ),
                    Divider(height: 32.h, thickness: 0.5),
                    _buildEditableField(
                      label: 'Phone Number (E.164)',
                      controller: _phoneController,
                      icon: FontAwesomeIcons.phone,
                      enabled: _isEditing,
                      hint: '+233 55 123 4567',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),
              _buildSectionHeader('Address Details'),
              SizedBox(height: 12.h),
              GlassCard(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    _buildEditableField(
                      label: 'Street',
                      controller: _streetController,
                      icon: FontAwesomeIcons.road,
                      enabled: _isEditing,
                    ),
                    Divider(height: 32.h, thickness: 0.5),
                    _buildEditableField(
                      label: 'Suburb',
                      controller: _suburbController,
                      icon: FontAwesomeIcons.building,
                      enabled: _isEditing,
                    ),
                    Divider(height: 32.h, thickness: 0.5),
                    Row(
                      children: [
                        Expanded(
                          child: _buildEditableField(
                            label: 'City',
                            controller: _cityController,
                            icon: FontAwesomeIcons.city,
                            enabled: _isEditing,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _buildEditableField(
                            label: 'Zip Code',
                            controller: _zipController,
                            icon: FontAwesomeIcons.hashtag,
                            enabled: _isEditing,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 32.h, thickness: 0.5),
                    _buildEditableField(
                      label: 'State / Province',
                      controller: _stateController,
                      icon: FontAwesomeIcons.map,
                      enabled: _isEditing,
                    ),
                    Divider(height: 32.h, thickness: 0.5),
                    _buildCountryField(enabled: _isEditing),
                  ],
                ),
              ),

              if (user.role == UserRole.vendor ||
                  user.role == UserRole.courier) ...[
                const SizedBox(height: 24),
                _buildSectionHeader('Professional Details'),
                const SizedBox(height: 12),
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (user.role == UserRole.vendor)
                        _buildEditableField(
                          label: 'Business Name',
                          controller: _businessNameController,
                          icon: FontAwesomeIcons.shop,
                          enabled: _isEditing,
                        ),
                      if (user.role == UserRole.courier)
                        _buildEditableField(
                          label: 'Vehicle Type',
                          controller: _vehicleTypeController,
                          icon: FontAwesomeIcons.truck,
                          enabled: _isEditing,
                        ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),
              _buildSectionHeader('Account & Security'),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoTile(
                      icon: FontAwesomeIcons.userShield,
                      label: 'Validation Status',
                      value: user.verificationStatus.name.toUpperCase(),
                      valueColor:
                          user.verificationStatus == VerificationStatus.verified
                          ? Colors.green
                          : Theme.of(context).colorScheme.secondary,
                    ),
                    const Divider(height: 32),
                    // Testing Role Switcher
                    Text(
                      'TESTING: CHANGE ROLE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<UserRole>(
                      value: user.role,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      items: UserRole.values.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(role.name.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (newRole) async {
                        if (newRole != null && newRole != user.role) {
                          final updatedUser = user.copyWith(role: newRole);
                          await ref
                              .read(authRepositoryProvider)
                              .updateUser(updatedUser);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Role changed to ${newRole.name}',
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    const Divider(height: 32),
                    if (!_isGoogleUser())
                      _buildNavTile(
                        icon: FontAwesomeIcons.key,
                        label: 'Change Password',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coming soon')),
                          );
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              _buildSectionHeader('Developer & Testing'),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24.w),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppTheme.accentOrange.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.terminal_rounded,
                            color: AppTheme.accentOrange,
                            size: 20.w,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'System Testing Console',
                                style: GoogleFonts.redHatDisplay(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                'Manage database seeding, role switching, and environment simulation.',
                                style: TextStyle(
                                  color: AppTheme.textGrey,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () => context.push('/seeding'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.storage_rounded, size: 18.w),
                          SizedBox(width: 8.w),
                          Text(
                            'Open Seeding Dashboard',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(Icons.chevron_right_rounded, size: 18.w),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),
              if (_isEditing)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                            _initializeControllers(user);
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _saveProfile(user),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => _isEditing = true),
                    icon: FaIcon(
                      FontAwesomeIcons.userPen,
                      color: Colors.white,
                      size: 18.w,
                    ),
                    label: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      elevation: 4,
                      shadowColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.4),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    final localImagePath = _localImagePath;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.w,
                    offset: Offset(0, 5.h),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 55.w,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                backgroundImage: localImagePath != null
                    ? FileImage(File(localImagePath))
                    : (user.photoUrl != null
                              ? CachedNetworkImageProvider(user.photoUrl!)
                              : null)
                          as ImageProvider?,
                child: _isUploading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : (localImagePath == null && user.photoUrl == null
                          ? Text(
                              user.name.isNotEmpty
                                  ? user.name[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 44.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          : null),
              ),
            ),
            if (_isEditing && !_isUploading)
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => _handleImageParams(context, user),
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4.w,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.cameraRetro,
                      color: Colors.white,
                      size: 16.w,
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          user.name,
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: Text(
            user.role.name.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildCountryField({bool enabled = true}) {
    // Attempt to parse country name to get flag
    final countryName = _countryController.text.trim();
    final country = _getCountryByName(countryName);

    // Display: Flag + Name
    final displayValue = country != null
        ? '${country.flag}  ${country.name}'
        : countryName;

    if (!enabled) {
      // Just display it like other fields, but customized for flag
      return _buildEditableField(
        label: 'Country',
        controller: TextEditingController(text: displayValue), // visual only
        icon: FontAwesomeIcons.earthAfrica,
        enabled: false,
      );
    }

    // Edit Mode: Just a text field for now, but prefix the flag if known.
    // Ideally this should differ, but for simplicity we keep text input
    // or we could show the CountrySelectorDialog on tap.
    // Let's keep it simple text input for now, but show flag prefix if recognized.
    return _buildEditableField(
      label: 'Country',
      controller: _countryController,
      icon: FontAwesomeIcons.earthAfrica,
      enabled: true,
      prefixText:
          country?.flag, // Custom param support? No, let's just stick to icon
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    String? hint,
    String? prefixText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled
            ? Colors.grey.withValues(alpha: 0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12.w),
      ),
      padding: enabled
          ? EdgeInsets.symmetric(horizontal: 12.w)
          : EdgeInsets.symmetric(vertical: 4.h),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 12.w),
              FaIcon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 18.w,
              ),
              if (prefixText != null) ...[
                SizedBox(width: 8.w),
                Text(prefixText, style: TextStyle(fontSize: 18.sp)),
              ],
              SizedBox(width: 12.w),
            ],
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          border: InputBorder.none,
          focusedBorder: enabled
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                  ),
                )
              : null,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            fontSize: 13.sp,
          ),
        ),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15.sp,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          FaIcon(
            icon,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            size: 18,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: FaIcon(
        icon,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        size: 18,
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: FaIcon(
        FontAwesomeIcons.chevronRight,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
        size: 14,
      ),
      onTap: onTap,
    );
  }
}
