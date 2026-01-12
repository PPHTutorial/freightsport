import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rightlogistics/src/core/presentation/widgets/gradient_button.dart';
import 'package:rightlogistics/src/core/utils/size_config.dart';
import 'package:rightlogistics/src/features/authentication/data/auth_repository.dart';
import 'package:rightlogistics/src/features/authentication/domain/user_model.dart';
import 'package:rightlogistics/src/features/common/data/storage_repository.dart';
import 'package:rightlogistics/src/core/domain/models/country.dart';
import 'package:rightlogistics/src/features/common/presentation/widgets/country_selector_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rightlogistics/src/features/onboarding/presentation/widgets/dynamic_input_list.dart';
import 'package:rightlogistics/src/core/services/location_service.dart';
import 'package:rightlogistics/src/core/services/permission_service.dart';

class ProfileBuilderScreen extends ConsumerStatefulWidget {
  final int initialStep;
  const ProfileBuilderScreen({super.key, this.initialStep = 0});

  @override
  ConsumerState<ProfileBuilderScreen> createState() =>
      _ProfileBuilderScreenState();
}

class _ProfileBuilderScreenState extends ConsumerState<ProfileBuilderScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  UserRole? _selectedRole;

  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController(); // Editable name
  // Address Details
  Country? _selectedCountry;
  final _streetController = TextEditingController();
  final _suburbController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  final _businessNameController = TextEditingController(); // For Vendor
  final _businessRegNumberController = TextEditingController(); // For Vendor
  final _businessDescriptionController = TextEditingController(); // For Vendor
  final _vehicleTypeController = TextEditingController(); // For Courier
  final _vehicleRegNumberController = TextEditingController(); // For Courier
  final _idNumberController = TextEditingController();
  final _usernameController = TextEditingController(); // Unique Username
  bool _isUsernameUnique = true;
  bool _isCheckingUsername = false;
  String? _usernameError;

  // Multi-tenant Vendor Data Lists
  List<Map<String, String>> _vendorPhones = []; // {label: Sales, number: ...}
  List<Map<String, dynamic>> _vendorAddresses =
      []; // {label: Warehouse, address: ..., phones: []}
  List<Map<String, String>> _vendorSocials =
      []; // {platform: Instagram, handle: ..., url: ...}
  List<Map<String, String>> _vendorFAQs = []; // {question: ..., answer: ...}
  List<Map<String, String>> _vendorRoutes =
      []; // {origin: China, destination: Ghana}
  List<Map<String, String>> _vendorRates =
      []; // {service: Air Freight, rate: $5/kg}
  List<String> _vendorServices = []; // Selected services

  // Verification State
  String? _selectedDocType;
  final List<String> _docTypes = [
    'National ID',
    'Passport',
    'Driver\'s License',
  ];

  // Payout Config
  final _payoutAccountNameController = TextEditingController();
  final _payoutAccountNumberController = TextEditingController();
  final _payoutBankNameController = TextEditingController();
  final _payoutBranchCodeController = TextEditingController();
  final _payoutSwiftCodeController = TextEditingController();
  String _payoutType = 'bank_transfer';
  String _payoutCurrency = 'USD';

  // Verification State
  bool _idUploaded = false;
  bool _isSubmitting = false;
  String? _uploadedIdUrl;
  String? _localDocPath; // For personal ID preview
  String? _localRegDocPath; // For Business Registration preview
  String? _localLicenseDocPath; // For Operating License preview
  String? _localLogoPath; // For Company Logo preview
  String? _localBannerPath; // For Company Banner preview
  String? _uploadedLogoUrl;
  String? _uploadedBannerUrl;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _streetController.dispose();
    _suburbController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _businessNameController.dispose();
    _businessRegNumberController.dispose();
    _businessDescriptionController.dispose();
    _vehicleTypeController.dispose();
    _vehicleRegNumberController.dispose();
    _idNumberController.dispose();
    _usernameController.dispose();

    // Payout Controllers
    _payoutAccountNameController.dispose();
    _payoutAccountNumberController.dispose();
    _payoutBankNameController.dispose();
    _payoutBranchCodeController.dispose();
    _payoutSwiftCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.initialStep != 0) {
        _pageController.jumpToPage(widget.initialStep);
      }

      // Fetch fresh data from Firestore to ensure we have KYC/Role info
      final user = await ref.read(authRepositoryProvider).refreshUser();

      if (user != null) {
        if (mounted) _prefillData(user);
        if (user.verificationStatus == VerificationStatus.pending &&
            widget.initialStep == 0) {
          if (mounted) _showPendingDialog();
        }
      }
    });

    // Request permissions after a short delay to allow UI to settle
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) PermissionService.requestOnboardingPermissions(context);
    });
  }

  void _prefillData(UserModel user) {
    try {
      setState(() {
        final kyc = user.kycData;

        // --- Helper for safe type conversion ---
        String s(dynamic value) => value?.toString() ?? '';

        // --- Optimized helper for list conversion ---
        List<Map<String, String>> convertStringList(dynamic list) {
          if (list == null || list is! List) return [];
          return list
              .map((e) {
                if (e is Map) {
                  return e.map((k, v) => MapEntry(k.toString(), s(v)));
                }
                return <String, String>{};
              })
              .where((m) => m.isNotEmpty)
              .toList();
        }

        // --- Role Detection (More robust, even for admins) ---
        if (user.role == UserRole.vendor || user.role == UserRole.courier) {
          _selectedRole = user.role;
        } else if (user.vendorKyc != null ||
            kyc?['businessName'] != null ||
            kyc?['vendorServices'] != null ||
            kyc?['locations'] != null ||
            kyc?['warehouses'] != null) {
          _selectedRole = UserRole.vendor;
        } else if (user.role != UserRole.customer) {
          _selectedRole = user.role;
        }

        // --- 1. Top-Level Profile Fields ---
        final phone = user.phoneNumber ?? kyc?['phone'] ?? kyc?['phoneNumber'];
        if (phone != null) _phoneController.text = s(phone);

        if (user.name.isNotEmpty) _nameController.text = user.name;
        if (user.username.isNotEmpty) _usernameController.text = user.username;

        // --- 2. Primary/Personal Address ---
        final addr = user.address;
        _streetController.text = (addr?.street.isNotEmpty ?? false)
            ? addr!.street
            : s(kyc?['street'] ?? kyc?['address'] ?? kyc?['fullAddress']);

        _suburbController.text = (addr?.suburb.isNotEmpty ?? false)
            ? addr!.suburb
            : s(kyc?['suburb'] ?? '');

        _cityController.text = (addr?.city.isNotEmpty ?? false)
            ? addr!.city
            : s(kyc?['city'] ?? '');

        _stateController.text = (addr?.state.isNotEmpty ?? false)
            ? addr!.state
            : s(kyc?['state'] ?? kyc?['region'] ?? '');

        _zipController.text = (addr?.zip.isNotEmpty ?? false)
            ? addr!.zip
            : s(kyc?['zip'] ?? kyc?['postalCode'] ?? '');

        // Country matching
        final countryVal = addr?.country ?? kyc?['country'];
        final countryCodeVal = addr?.countryCode ?? kyc?['countryCode'];
        if (countryVal != null || countryCodeVal != null) {
          try {
            _selectedCountry = Country.all.firstWhere(
              (c) =>
                  s(c.name).toLowerCase() == s(countryVal).toLowerCase() ||
                  s(c.code).toLowerCase() == s(countryCodeVal).toLowerCase(),
            );
          } catch (_) {}
        }

        // --- 3. Identity Data ---
        final ident = user.identity;
        _selectedDocType = (ident?.idType?.isNotEmpty ?? false)
            ? ident!.idType
            : s(kyc?['idType'] ?? '');
        if (_selectedDocType!.isEmpty) _selectedDocType = null;

        _idNumberController.text = (ident?.idNumber?.isNotEmpty ?? false)
            ? ident!.idNumber!
            : s(kyc?['idNumber'] ?? '');

        _idUploaded =
            (ident?.idUploaded ?? false) || kyc?['idUploaded'] == true;
        _uploadedIdUrl = (ident?.idUrl?.isNotEmpty ?? false)
            ? ident!.idUrl
            : s(kyc?['idUrl'] ?? '');

        // --- 4. Vendor Specific Data ---
        if (_selectedRole == UserRole.vendor) {
          final vKyc = user.vendorKyc;

          _businessNameController.text =
              (vKyc?.businessName.isNotEmpty ?? false)
              ? vKyc!.businessName
              : s(kyc?['businessName'] ?? kyc?['companyName'] ?? kyc?['name']);

          _businessRegNumberController.text =
              (vKyc?.businessRegNumber.isNotEmpty ?? false)
              ? vKyc!.businessRegNumber
              : s(kyc?['businessRegNumber'] ?? kyc?['regNumber'] ?? '');

          _businessDescriptionController.text =
              (vKyc?.businessDescription.isNotEmpty ?? false)
              ? vKyc!.businessDescription
              : s(kyc?['businessDescription'] ?? kyc?['description'] ?? '');

          // Contact Numbers
          if (vKyc != null && vKyc.vendorPhones.isNotEmpty) {
            _vendorPhones = List<Map<String, String>>.from(vKyc.vendorPhones);
          } else {
            _vendorPhones = convertStringList(
              kyc?['vendorPhones'] ?? kyc?['phones'],
            );
          }

          // Offices & Warehouses (Complex dynamic mapping)
          if (vKyc != null && vKyc.vendorAddresses.isNotEmpty) {
            _vendorAddresses = List<Map<String, dynamic>>.from(
              vKyc.vendorAddresses,
            );
          } else {
            final legacyLocations =
                kyc?['vendorAddresses'] ??
                kyc?['locations'] ??
                kyc?['warehouses'];
            if (legacyLocations is List) {
              _vendorAddresses = legacyLocations
                  .map((loc) {
                    if (loc is Map) {
                      // Robust field mapping for nested addresses
                      return {
                        'label': s(
                          loc['label'] ?? loc['locationName'] ?? loc['name'],
                        ),
                        'country': s(loc['country']),
                        'street': s(loc['street'] ?? loc['address']),
                        'city': s(loc['city']),
                        'state': s(loc['state'] ?? loc['region']),
                        'zip': s(loc['zip'] ?? loc['postalCode']),
                        'phones':
                            (loc['phones'] ??
                                    loc['phoneNumber'] ??
                                    loc['contacts'])
                                is List
                            ? (loc['phones'] ??
                                      loc['phoneNumber'] ??
                                      loc['contacts'] as List)
                                  .map((p) => s(p))
                                  .toList()
                            : (loc['phones'] ??
                                      loc['phoneNumber'] ??
                                      loc['contacts'] != null
                                  ? [
                                      s(
                                        loc['phones'] ??
                                            loc['phoneNumber'] ??
                                            loc['contacts'],
                                      ),
                                    ]
                                  : <String>[]),
                      };
                    }
                    return <String, dynamic>{};
                  })
                  .where((m) => m.isNotEmpty)
                  .toList();
            }
          }

          // Socials
          if (vKyc != null && vKyc.vendorSocials.isNotEmpty) {
            _vendorSocials = List<Map<String, String>>.from(vKyc.vendorSocials);
          } else {
            _vendorSocials = convertStringList(
              kyc?['vendorSocials'] ?? kyc?['socials'],
            );
          }

          // FAQs
          if (vKyc != null && vKyc.vendorFAQs.isNotEmpty) {
            _vendorFAQs = List<Map<String, String>>.from(vKyc.vendorFAQs);
          } else {
            _vendorFAQs = convertStringList(kyc?['vendorFAQs'] ?? kyc?['faqs']);
          }

          // Routes
          if (vKyc != null && vKyc.vendorRoutes.isNotEmpty) {
            _vendorRoutes = List<Map<String, String>>.from(vKyc.vendorRoutes);
          } else {
            _vendorRoutes = convertStringList(
              kyc?['vendorRoutes'] ?? kyc?['routes'],
            );
          }

          // Rates
          if (vKyc != null && vKyc.vendorRates.isNotEmpty) {
            _vendorRates = List<Map<String, String>>.from(vKyc.vendorRates);
          } else {
            _vendorRates = convertStringList(
              kyc?['vendorRates'] ?? kyc?['rates'],
            );
          }

          // Services
          if (vKyc != null && vKyc.vendorServices.isNotEmpty) {
            _vendorServices = List<String>.from(vKyc.vendorServices);
          } else {
            final services = kyc?['vendorServices'] ?? kyc?['services'];
            if (services is List) {
              _vendorServices = services.map((e) => s(e)).toList();
            }
          }
        } else if (_selectedRole == UserRole.courier) {
          final cKyc = user.courierKyc;
          _vehicleTypeController.text = (cKyc?.vehicleType.isNotEmpty ?? false)
              ? cKyc!.vehicleType
              : s(kyc?['vehicleType'] ?? '');
          _vehicleRegNumberController.text =
              (cKyc?.vehicleRegNumber.isNotEmpty ?? false)
              ? cKyc!.vehicleRegNumber
              : s(kyc?['vehicleRegNumber'] ?? '');
        }

        // --- 5. Branded Assets ---
        _uploadedLogoUrl =
            user.companyLogo ?? kyc?['logo'] ?? kyc?['companyLogo'];
        _uploadedBannerUrl =
            user.companyBanner ?? kyc?['banner'] ?? kyc?['companyBanner'];

        // --- 6. Payout Data ---
        final pay = user.payoutDetails;
        if (pay != null) {
          _payoutAccountNameController.text = pay.accountName;
          _payoutAccountNumberController.text = pay.accountNumber;
          _payoutBankNameController.text = pay.bankName;
          _payoutBranchCodeController.text = pay.branchCode;
          _payoutSwiftCodeController.text = pay.swiftCode;
          _payoutType = pay.type;
          _payoutCurrency = pay.currency;
        } else if (kyc?['payout'] != null) {
          final p = kyc!['payout'];
          _payoutAccountNameController.text = s(p['accountName']);
          _payoutAccountNumberController.text = s(p['accountNumber']);
          _payoutBankNameController.text = s(p['bankName']);
          _payoutBranchCodeController.text = s(p['branchCode']);
          _payoutSwiftCodeController.text = s(p['swiftCode']);
          _payoutType = s(p['type']).isEmpty ? 'bank_transfer' : s(p['type']);
          _payoutCurrency = s(p['currency']).isEmpty ? 'USD' : s(p['currency']);
        }

        // --- 7. Step Restoration ---
        if (widget.initialStep == 0 && kyc?['onboardingStep'] != null) {
          _currentStep = int.tryParse(kyc!['onboardingStep'].toString()) ?? 0;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_pageController.hasClients) {
              _pageController.jumpToPage(_currentStep);
            }
          });
        }
      });
    } catch (e, stack) {
      debugPrint('CRITICAL: Prefill data failed: $e');
      debugPrint(stack.toString());
    }
  }

  void _showPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Verification Pending'),
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          margin: EdgeInsets.only(top: 10.h),
          width: MediaQuery.of(context).size.width * .75,
          child: const Text(
            'Your profile is currently under review by our administrators. You will be notified once approved.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
              context.go('/login');
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _pruneEmptyVendorLists() {
    setState(() {
      _vendorPhones.removeWhere(
        (item) => (item['number'] ?? '').trim().isEmpty,
      );
      _vendorAddresses.removeWhere(
        (item) => (item['street'] ?? '').trim().isEmpty,
      );
      _vendorSocials.removeWhere(
        (item) => (item['handle'] ?? '').trim().isEmpty,
      );
      _vendorFAQs.removeWhere(
        (item) =>
            (item['question'] ?? '').trim().isEmpty ||
            (item['answer'] ?? '').trim().isEmpty,
      );
      _vendorRoutes.removeWhere(
        (item) =>
            (item['origin'] ?? '').trim().isEmpty ||
            (item['destination'] ?? '').trim().isEmpty,
      );
      _vendorRates.removeWhere(
        (item) =>
            (item['service'] ?? '').trim().isEmpty ||
            (item['amount'] ?? '').trim().isEmpty,
      );
    });
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role to proceed')),
      );
      return;
    }

    if (_currentStep == 1) {
      if (!_formKey.currentState!.validate()) return;
      if (_selectedCountry == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a country')),
        );
        return;
      }

      // Vendor Specific Validation
      if (_selectedRole == UserRole.vendor) {
        _pruneEmptyVendorLists();

        if (_vendorServices.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select at least one service')),
          );
          return;
        }
        if (_vendorPhones.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please add at least one contact number'),
            ),
          );
          return;
        }
        if (_vendorAddresses.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please add at least one warehouse/office'),
            ),
          );
          return;
        }
        if (_vendorRates.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please add at least one shipping rate'),
            ),
          );
          return;
        }
        if (_vendorSocials.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please add at least one social media handle'),
            ),
          );
          return;
        }
        if (_vendorFAQs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please add at least one FAQ')),
          );
          return;
        }
        if (_vendorRoutes.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please add at least one shipping route'),
            ),
          );
          return;
        }
      }
    }

    // Step 2: Payout Setup (Only for Vendor/Courier)
    if (_currentStep == 2 &&
        (_selectedRole == UserRole.vendor ||
            _selectedRole == UserRole.courier)) {
      // Payout Step Validation
      if (_payoutType == 'bank_transfer') {
        if (_payoutBankNameController.text.isEmpty ||
            _payoutAccountNameController.text.isEmpty ||
            _payoutAccountNumberController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill all mandatory bank details.'),
            ),
          );
          return;
        }
      } else if (_payoutType == 'mobile_money') {
        if (_payoutBankNameController.text.isEmpty ||
            _payoutAccountNameController.text.isEmpty ||
            _payoutAccountNumberController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill all mandatory mobile money details.'),
            ),
          );
          return;
        }
      } else {
        // Crypto
        if (_payoutBankNameController.text.isEmpty ||
            _payoutAccountNumberController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill all mandatory wallet details.'),
            ),
          );
          return;
        }
      }
    }

    // Determine Logic Index for Verification
    final isVendorOrCourier =
        _selectedRole == UserRole.vendor || _selectedRole == UserRole.courier;
    final verificationStepIndex = isVendorOrCourier ? 3 : 2;

    if (_currentStep == verificationStepIndex) {
      if (_selectedDocType == null || _idNumberController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select Document Type and enter ID Number'),
          ),
        );
        return;
      }
      // Strict Verification: ID Selection is MANDATORY
      if (_localDocPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You MUST select a valid Government ID to proceed.'),
          ),
        );
        return;
      }
    }

    if (_currentStep < verificationStepIndex) {
      // Transition Logic
      _saveProgress();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _completeProfile();
    }
  }

  // Renamed or adjusted for clarity, removing old block
  /*
    if (_currentStep < 2) {
      if (widget.initialStep == 1 && _currentStep == 1) {
        _completeProfile();
        return;
      }
      _saveProgress(); // Auto-save on transition
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _completeProfile();
    }
  */

  Future<void> _completeProfile() async {
    setState(() => _isSubmitting = true);
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null) {
        // Upload documents if needed
        String? idUrl = _uploadedIdUrl;
        String? regDocUrl;
        String? licenseDocUrl;

        // Use a helper to upload if path is local
        Future<String?> uploadDoc(String? localPath, String category) async {
          if (localPath == null) return null;
          debugPrint('DEBUG: Initializing upload for $category: $localPath');
          return await ref
              .read(storageRepositoryProvider)
              .uploadFile(file: File(localPath), pathPrefix: 'kyc_$category');
        }

        if (_localDocPath != null) {
          idUrl = await uploadDoc(_localDocPath, 'ids');
        }
        if (_localRegDocPath != null) {
          regDocUrl = await uploadDoc(_localRegDocPath, 'registration');
        }
        if (_localLicenseDocPath != null) {
          licenseDocUrl = await uploadDoc(_localLicenseDocPath, 'licenses');
        }

        String? logoUrl = _uploadedLogoUrl;
        String? bannerUrl = _uploadedBannerUrl;

        if (_localLogoPath != null) {
          logoUrl = await uploadDoc(_localLogoPath, 'logos');
        }
        if (_localBannerPath != null) {
          bannerUrl = await uploadDoc(_localBannerPath, 'banners');
        }

        final bool uploadSuccess = idUrl != null;
        if (!uploadSuccess && _localDocPath != null) {
          throw Exception('Failed to upload ID document.');
        }

        final updatedUser = currentUser.copyWith(
          name: _nameController.text.trim(),
          role: _selectedRole!,
          phoneNumber: _phoneController.text.trim(),
          isProfileComplete: true,
          // Payout Details
          payoutDetails:
              (_selectedRole == UserRole.vendor ||
                  _selectedRole == UserRole.courier)
              ? PayoutDetails(
                  accountName: _payoutAccountNameController.text.trim(),
                  accountNumber: _payoutAccountNumberController.text.trim(),
                  bankName: _payoutBankNameController.text.trim(),
                  branchCode: _payoutBranchCodeController.text.trim(),
                  swiftCode: _payoutSwiftCodeController.text.trim(),
                  type: _payoutType,
                  currency: _payoutCurrency,
                )
              : null,
          verificationStatus: uploadSuccess
              ? VerificationStatus.pending
              : VerificationStatus.unverified,
          companyLogo: logoUrl,
          companyBanner: bannerUrl,
          address: AddressInfo(
            street: _streetController.text.trim(),
            suburb: _suburbController.text.trim(),
            city: _cityController.text.trim(),
            state: _stateController.text.trim(),
            zip: _zipController.text.trim(),
            country: _selectedCountry?.name ?? '',
            countryCode: _selectedCountry?.code ?? '',
            currency: _selectedCountry?.currency ?? '',
            fullAddress:
                '${_streetController.text.trim()}, ${_suburbController.text.trim()}, ${_cityController.text.trim()}',
          ),
          identity: IdentityInfo(
            idType: _selectedDocType,
            idNumber: _idNumberController.text.trim(),
            idUrl: idUrl,
            idUploaded: uploadSuccess,
            regDocUrl: regDocUrl,
            licenseDocUrl: licenseDocUrl,
            submittedAt: DateTime.now().toIso8601String(),
          ),
          vendorKyc: _selectedRole == UserRole.vendor
              ? VendorKyc(
                  businessName: _businessNameController.text.trim(),
                  businessRegNumber: _businessRegNumberController.text.trim(),
                  businessDescription: _businessDescriptionController.text
                      .trim(),
                  vendorPhones: _vendorPhones,
                  vendorAddresses: _vendorAddresses,
                  vendorSocials: _vendorSocials,
                  vendorFAQs: _vendorFAQs,
                  vendorRoutes: _vendorRoutes,
                  vendorRates: _vendorRates,
                  vendorServices: _vendorServices,
                )
              : null,
          courierKyc: _selectedRole == UserRole.courier
              ? CourierKyc(
                  vehicleType: _vehicleTypeController.text.trim(),
                  vehicleRegNumber: _vehicleRegNumberController.text.trim(),
                )
              : null,
          // kycData: null, // REMOVED: Prevent data loss until migration verified
        );

        debugPrint('DEBUG: Updating user with ID: ${updatedUser.id}');
        debugPrint('DEBUG: KYC Data: ${updatedUser.kycData}');
        await ref.read(authRepositoryProvider).updateUser(updatedUser);
        debugPrint('DEBUG: updateUser call completed successfully.');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile setup complete!')),
          );
          // Router should auto-redirect based on state change, but force if needed
          context.go('/dashboard');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(
      () => _isSubmitting = true,
    ); // Using submitting state for simple loading indicator reuse
    try {
      final location = await LocationService.getBestLocation();

      if (mounted) {
        if (location.city.isEmpty && location.latitude == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Could not fetch location. Please check permissions.',
              ),
            ),
          );
          return;
        }

        // Auto-fill fields
        if (location.city.isNotEmpty) _cityController.text = location.city;
        if (location.region.isNotEmpty) _stateController.text = location.region;
        if (location.zip.isNotEmpty) _zipController.text = location.zip;

        // Try to match country
        if (location.country.isNotEmpty) {
          try {
            _selectedCountry = Country.all.firstWhere(
              (c) =>
                  c.name.toLowerCase() == location.country.toLowerCase() ||
                  c.code.toLowerCase() == location.countryCode.toLowerCase(),
            );
          } catch (_) {
            // Best effort match
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location details updated from current position.'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Location error: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construct pages conditionally
    List<Widget> pages = [_buildRoleSelectionStep(), _buildDetailsStep()];

    if (_selectedRole == UserRole.vendor || _selectedRole == UserRole.courier) {
      pages.add(
        Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: _PayoutSetupStep(
              accountNameController: _payoutAccountNameController,
              accountNumberController: _payoutAccountNumberController,
              bankNameController: _payoutBankNameController,
              branchCodeController: _payoutBranchCodeController,
              swiftCodeController: _payoutSwiftCodeController,
              selectedType: _payoutType,
              selectedCurrency: _payoutCurrency,
              onTypeChanged: (val) {
                if (val != null) setState(() => _payoutType = val);
              },
              onCurrencyChanged: (val) {
                if (val != null) setState(() => _payoutCurrency = val);
              },
            ),
          ),
        ),
      );
    }

    pages.add(_buildVerificationStep());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialStep != 0 ? 'Update Profile' : 'Setup Profile',
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(), // Keep or remove? Header has step indicator which matches logic.
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.initialStep != 0 ? 'Update Profile' : 'Setup Profile',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 24.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.w),
                ),
                child: Text(
                  'Step ${_currentStep + 1}/3',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.onSurface.withOpacity(0.1),
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(2.w),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelectionStep() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      children: [
        Text(
          'How will you use Right Logistics?',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          'Select the account type that best fits your needs.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 24.h),
        _RoleCard(
          title: 'Individual / Customer',
          description: 'I want to send or receive packages personally.',
          icon: FontAwesomeIcons.solidUser,
          isSelected: _selectedRole == UserRole.customer,
          onTap: () => setState(() => _selectedRole = UserRole.customer),
        ),
        SizedBox(height: 16.h),
        _RoleCard(
          title: 'Business / Vendor',
          description: 'I manage shipments for my business customers.',
          icon: FontAwesomeIcons.shop,
          isSelected: _selectedRole == UserRole.vendor,
          onTap: () => setState(() => _selectedRole = UserRole.vendor),
        ),
        SizedBox(height: 16.h),
        _RoleCard(
          title: 'Courier Partner',
          description: 'I want to deliver packages and earn.',
          icon: FontAwesomeIcons.truck,
          isSelected: _selectedRole == UserRole.courier,
          onTap: () => setState(() => _selectedRole = UserRole.courier),
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Details',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Tell us more about yourself and your business.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: '@username',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: FaIcon(FontAwesomeIcons.at, size: 18.w),
                ),
                suffixIcon: _isCheckingUsername
                    ? Transform.scale(
                        scale: 0.5,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : null,
                border: const OutlineInputBorder(),
                errorText: _usernameError,
              ),
              onChanged: (val) => _debouncedCheckUsername(val),
              validator: (v) {
                if (v!.isEmpty) return 'Required';
                if (!_isUsernameUnique) return 'Username already taken';
                return null;
              },
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Review or update your full name',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: FaIcon(FontAwesomeIcons.user, size: 18.w),
                ),
                border: const OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: '+233 XX XXX XXXX',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: FaIcon(FontAwesomeIcons.phone, size: 18.w),
                ),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty ? 'Required' : null,
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 24.h),
            _buildBrandingSection(),
            SizedBox(height: 24.h),
            Text(
              'Address Details',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _useCurrentLocation,
                icon: const Icon(Icons.my_location, size: 16),
                label: const Text('Use Current Location'),
                style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => CountrySelectorDialog(
                    onSelect: (country) {
                      setState(() => _selectedCountry = country);
                    },
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.earthAfrica,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                      size: 18.w,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        _selectedCountry != null
                            ? '${_selectedCountry!.flag}  ${_selectedCountry!.name}'
                            : 'Select Country',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: _selectedCountry != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                    FaIcon(
                      FontAwesomeIcons.chevronDown,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                      size: 14.w,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: _streetController,
              decoration: InputDecoration(
                labelText: _selectedRole == UserRole.vendor
                    ? 'Street Address / HQ'
                    : 'Street Address',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: FaIcon(FontAwesomeIcons.locationDot, size: 18.w),
                ),
                border: const OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: _suburbController,
              decoration: InputDecoration(
                labelText: 'Suburb',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: FaIcon(
                    FontAwesomeIcons.locationCrosshairs,
                    size: 18.w,
                  ),
                ),
                border: const OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: 'City',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: FaIcon(FontAwesomeIcons.city, size: 18.w),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      labelText: 'State/Region',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: _zipController,
              decoration: InputDecoration(
                labelText: 'Zip / Postal Code',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: FaIcon(FontAwesomeIcons.mapLocationDot, size: 18.w),
                ),
                border: const OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
              style: TextStyle(fontSize: 16.sp),
            ),
            if (_selectedRole == UserRole.vendor) ...[
              const SizedBox(height: 32),
              _buildVendorOperationalDetails(),
            ],
            if (_selectedRole == UserRole.courier) ...[
              SizedBox(height: 16.h),
              TextFormField(
                controller: _vehicleTypeController,
                decoration: InputDecoration(
                  labelText: 'Vehicle Type (Bike, Van...)',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: FaIcon(FontAwesomeIcons.bicycle, size: 18.w),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                style: TextStyle(fontSize: 16.sp),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _vehicleRegNumberController,
                decoration: InputDecoration(
                  labelText: 'Vehicle Registration Number',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: FaIcon(FontAwesomeIcons.idCard, size: 18.w),
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
                style: TextStyle(fontSize: 16.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              FontAwesomeIcons.palette,
              size: 16.sp,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 8.w),
            Text(
              'Brand Visuals',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Portion (Flex 2)
            Expanded(
              flex: 2,
              child: _buildUploadBox(
                label: 'Logo',
                guide: 'PNG/JPG (1:1)',
                localPath: _localLogoPath,
                networkUrl: _uploadedLogoUrl,
                onTap: () => _pickImage(isBanner: false),
                isCircular: true,
                height: 100.w,
              ),
            ),
            SizedBox(width: 16.w),
            // Banner Portion (Flex 4)
            Expanded(
              flex: 4,
              child: _buildUploadBox(
                label: 'Business Banner',
                guide: '1200 x 400 pixels',
                localPath: _localBannerPath,
                networkUrl: _uploadedBannerUrl,
                onTap: () => _pickImage(isBanner: true),
                isCircular: false,
                height: 100.w,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              _buildGuideRow(
                Icons.check_circle_outline,
                'Recommended for professional trust.',
              ),
              SizedBox(height: 4.h),
              _buildGuideRow(
                Icons.check_circle_outline,
                'Banner appears on your store header.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadBox({
    required String label,
    required String guide,
    required String? localPath,
    required String? networkUrl,
    required VoidCallback onTap,
    required bool isCircular,
    required double height,
  }) {
    final hasImage = localPath != null || networkUrl != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.02),
              shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: isCircular ? null : BorderRadius.circular(12),
              border: Border.all(
                color: hasImage
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: isCircular
                  ? BorderRadius.circular(height)
                  : BorderRadius.circular(12),
              child: Stack(
                children: [
                  if (localPath != null)
                    Image.file(
                      File(localPath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  else if (networkUrl != null)
                    Image.network(
                      networkUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  else
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            isCircular
                                ? Icons.camera_alt_outlined
                                : Icons.add_photo_alternate_outlined,
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.5),
                            size: 48.sp,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            label,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (hasImage)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        color: Colors.black54,
                        child: Icon(
                          Icons.edit,
                          color: Theme.of(context).primaryColor,
                          size: 14.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Center(
          child: Text(
            guide,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              fontSize: 9.sp,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuideRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12.sp, color: Theme.of(context).primaryColor),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage({required bool isBanner}) async {
    final file = await ref
        .read(storageRepositoryProvider)
        .pickAndProcessFile(fileType: FileType.image);

    if (file != null) {
      setState(() {
        if (isBanner) {
          _localBannerPath = file.path;
        } else {
          _localLogoPath = file.path;
        }
      });
    }
  }

  // Debounce helper
  void _debouncedCheckUsername(String username) {
    // Simple debounce implementation or direct check if lazy
    // For now, implementing direct call but with flag
    if (username.length < 3) return;

    setState(() {
      _isCheckingUsername = true;
      _usernameError = null;
    });
    ref.read(authRepositoryProvider).isUsernameUnique(username).then((
      isUnique,
    ) {
      if (mounted) {
        setState(() {
          _isCheckingUsername = false;
          _isUsernameUnique = isUnique;
          if (!isUnique) _usernameError = 'Username taken';
        });
      }
    });
  }

  Widget _buildVendorOperationalDetails() {
    const frieghtServices = [
      'Air Freight',
      'Sea Freight',
      'Pre Ordering',
      'Procurement',
      'Supplier Inspection',
      'Auto Logistics',
      'Port Clearance',
      'Container Booking',
      'Sourcing',
      'Container Purchase',
      'Vehicle Purchase',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Company Operations',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _businessRegNumberController,
          decoration: InputDecoration(
            labelText: 'Business Registration Number (Optional)',
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.w),
              child: FaIcon(FontAwesomeIcons.fileContract, size: 18.w),
            ),
            border: const OutlineInputBorder(),
          ),
          style: TextStyle(fontSize: 16.sp),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _businessNameController,
          decoration: InputDecoration(
            labelText: 'Business Name',
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.w),
              child: FaIcon(FontAwesomeIcons.building, size: 18.w),
            ),
            border: const OutlineInputBorder(),
          ),
          style: TextStyle(fontSize: 16.sp),
          validator: (v) => v!.isEmpty ? 'Required' : null,
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: _businessDescriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Company Description',
            hintText: 'Tell us about your services...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.w),
              child: FaIcon(FontAwesomeIcons.fileLines, size: 18.w),
            ),
            border: const OutlineInputBorder(),
          ),
          style: TextStyle(fontSize: 15.sp),
          validator: (v) => v!.isEmpty ? 'Required' : null,
        ),
        SizedBox(height: 24.h),

        // Services Checklist
        Text(
          'Services Offered',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          children: frieghtServices
              .map(
                (service) => FilterChip(
                  label: Text(service, style: TextStyle(fontSize: 12.sp)),
                  selected: _vendorServices.contains(service),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _vendorServices.add(service);
                      } else {
                        _vendorServices.remove(service);
                      }
                    });
                  },
                ),
              )
              .toList(),
        ),
        SizedBox(height: 24.h),

        // Multiple Phone Numbers
        DynamicInputList<Map<String, String>>(
          title: 'Contact Numbers',
          addLabel: 'Add Phone',
          items: _vendorPhones,
          onAdd: () => setState(
            () => _vendorPhones.add({'label': 'Support', 'number': ''}),
          ),
          onRemove: (i) => setState(() => _vendorPhones.removeAt(i)),
          itemBuilder: (index, item) => Row(
            children: [
              SizedBox(
                width: 100.w,
                child: LabeledTextInput(
                  hint: 'Label',
                  initialValue: item['label']!,
                  onChanged: (val) => _vendorPhones[index]['label'] = val,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: LabeledTextInput(
                  hint: 'Phone Number',
                  initialValue: item['number']!,
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => _vendorPhones[index]['number'] = val,
                ),
              ),
            ],
          ),
        ),

        DynamicInputList<Map<String, dynamic>>(
          title: 'Offices & Warehouses',
          addLabel: 'Add Location',
          items: _vendorAddresses,
          onAdd: () => setState(
            () => _vendorAddresses.add({
              'label': '',
              'country': '',
              'street': '',
              'city': '',
              'state': '',
              'zip': '',
              'phones': <String>[],
            }),
          ),
          onRemove: (index) => setState(() => _vendorAddresses.removeAt(index)),
          itemBuilder: (index, item) {
            final phones = (item['phones'] as List? ?? []).cast<String>();
            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabeledTextInput(
                    label: 'Location Name',
                    hint: 'e.g. Accra Network Hub',
                    initialValue: item['label'] ?? '',
                    onChanged: (val) => item['label'] = val,
                  ),
                  SizedBox(height: 8.h),
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
                              // Optional: Auto-fill dial code or currency if needed
                            });
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item['country']?.isNotEmpty == true
                                  ? item['country']!
                                  : 'Select Country',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: item['country']?.isNotEmpty == true
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  LabeledTextInput(
                    label: 'Street Address',
                    hint: 'Street Name & Number',
                    initialValue: item['street'] ?? '',
                    onChanged: (val) => item['street'] = val,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: LabeledTextInput(
                          label: 'City',
                          hint: 'City',
                          initialValue: item['city'] ?? '',
                          onChanged: (val) => item['city'] = val,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: LabeledTextInput(
                          label: 'State/Region',
                          hint: 'Region',
                          initialValue: item['state'] ?? '',
                          onChanged: (val) => item['state'] = val,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  LabeledTextInput(
                    label: 'Zip / Postal Code',
                    hint: 'Zip Code',
                    initialValue: item['zip'] ?? '',
                    onChanged: (val) => item['zip'] = val,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phone Numbers',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
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
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Phone'),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                  if (phones.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Text(
                        'No phone numbers added.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ...phones.asMap().entries.map((entry) {
                    final pIndex = entry.key;
                    final pVal = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: LabeledTextInput(
                              hint: 'Phone Number (e.g. +123...)',
                              initialValue: pVal,
                              keyboardType: TextInputType.phone,
                              onChanged: (val) {
                                phones[pIndex] = val;
                                item['phones'] = phones;
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                (item['phones'] as List).removeAt(pIndex);
                              });
                            },
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

        // Shipping Routes
        DynamicInputList<Map<String, String>>(
          title: 'Primary Routes',
          addLabel: 'Add Route',
          items: _vendorRoutes,
          onAdd: () => setState(
            () => _vendorRoutes.add({'origin': '', 'destination': ''}),
          ),
          onRemove: (i) => setState(() => _vendorRoutes.removeAt(i)),
          itemBuilder: (index, item) => Row(
            children: [
              Expanded(
                child: LabeledTextInput(
                  hint: 'Origin (e.g. China)',
                  initialValue: item['origin']!,
                  onChanged: (val) => _vendorRoutes[index]['origin'] = val,
                ),
              ),
              SizedBox(width: 8.w),
              FaIcon(
                FontAwesomeIcons.arrowRight,
                size: 14.w,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: LabeledTextInput(
                  hint: 'Destination (e.g. Ghana)',
                  initialValue: item['destination']!,
                  onChanged: (val) => _vendorRoutes[index]['destination'] = val,
                ),
              ),
            ],
          ),
        ),

        // Shipping Rates
        DynamicInputList<Map<String, String>>(
          title: 'Standard Shipping Rates',
          addLabel: 'Add Rate',
          items: _vendorRates,
          onAdd: () => setState(
            () => _vendorRates.add({
              'service': '',
              'type': 'Air Freight',
              'category': 'Normal',
              'currency': 'USD',
              'amount': '',
              'unit': 'Kg',
            }),
          ),
          onRemove: (i) => setState(() => _vendorRates.removeAt(i)),
          itemBuilder: (index, item) {
            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Column(
                children: [
                  // Service & Type Row
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: item['service']?.isNotEmpty == true
                              ? item['service']
                              : null,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Service',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                          ),
                          items: frieghtServices.map((s) {
                            return DropdownMenuItem(value: s, child: Text(s));
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _vendorRates[index]['service'] = val!;
                              // Reset type and category if not Air Freight
                              if (val != 'Air Freight') {
                                _vendorRates[index]['type'] = 'Normal';
                                _vendorRates[index]['category'] = 'Normal';
                              }
                            });
                          },
                          validator: (v) => v == null ? 'Required' : null,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: item['type'] ?? 'Normal',
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Type',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                          ),
                          items:
                              (item['service'] == 'Air Freight'
                                      ? ['Normal', 'Express']
                                      : ['Normal'])
                                  .map((t) {
                                    return DropdownMenuItem(
                                      value: t,
                                      child: Text(t),
                                    );
                                  })
                                  .toList(),
                          onChanged: (val) => setState(
                            () => _vendorRates[index]['type'] = val!,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (item['service'] == 'Air Freight') ...[
                    SizedBox(height: 12.h),
                    DropdownButtonFormField<String>(
                      value: item['category'] ?? 'Normal',
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Critical Item Category',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                      ),
                      items:
                          [
                            'Normal',
                            'Special',
                            'Dangerous',
                            'Powder',
                            'Liquid',
                            'Phone',
                            'Laptop',
                            'Documents',
                            'Fragile',
                            'Other',
                          ].map((c) {
                            return DropdownMenuItem(value: c, child: Text(c));
                          }).toList(),
                      onChanged: (val) => setState(
                        () => _vendorRates[index]['category'] = val!,
                      ),
                    ),
                  ],
                  SizedBox(height: 12.h),
                  // Currency & Amount Row
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => CountrySelectorDialog(
                                onSelect: (country) {
                                  setState(() {
                                    // Storing currency code (e.g. GHS)
                                    item['currency'] = country.currency;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 40.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['currency']?.isNotEmpty == true
                                        ? item['currency']!
                                        : 'Currency',
                                    style: TextStyle(
                                      color:
                                          item['currency']?.isNotEmpty == true
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onSurface
                                          : Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.6),
                                    ),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        flex: 4,
                        child: LabeledTextInput(
                          hint: 'Amount (e.g. 5.00)',
                          initialValue: item['amount'] ?? '',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (val) =>
                              _vendorRates[index]['amount'] = val,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'per /',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        flex: 5,
                        child: DropdownButtonFormField<String>(
                          value: (item['unit'] == 'kg' || item['unit'] == null)
                              ? 'Kg'
                              : item['unit'],
                          isExpanded: false,
                          decoration: const InputDecoration(
                            labelText: 'Unit',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                          ),
                          items: ['Kg', 'CBM', 'Flat'].map((u) {
                            return DropdownMenuItem(value: u, child: Text(u));
                          }).toList(),
                          onChanged: (val) => setState(
                            () => _vendorRates[index]['unit'] = val!,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),

        // Social Handles
        DynamicInputList<Map<String, String>>(
          title: 'Social Media',
          addLabel: 'Add Social',
          items: _vendorSocials,
          onAdd: () => setState(
            () => _vendorSocials.add({
              'platform': 'Instagram',
              'handle': '',
              'url': '',
            }),
          ),
          onRemove: (i) => setState(() => _vendorSocials.removeAt(i)),
          itemBuilder: (index, item) => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: _socialPlatforms.containsKey(item['platform'])
                          ? item['platform']
                          : 'Instagram',
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Platform',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                      ),
                      items: _socialPlatforms.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Row(
                            children: [
                              FaIcon(entry.value, size: 16.w),
                              SizedBox(width: 8.w),
                              Text(
                                entry.key,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(
                        () => _vendorSocials[index]['platform'] = val!,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    flex: 4,
                    child: LabeledTextInput(
                      hint: 'Handle (e.g. @company)',
                      initialValue: item['handle']!,
                      onChanged: (val) => _vendorSocials[index]['handle'] = val,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              LabeledTextInput(
                hint: 'Full Profile URL',
                initialValue: item['url']!,
                onChanged: (val) => _vendorSocials[index]['url'] = val,
              ),
            ],
          ),
        ),

        // Custom FAQs
        DynamicInputList<Map<String, String>>(
          title: 'Company FAQs',
          addLabel: 'Add FAQ',
          items: _vendorFAQs,
          onAdd: () =>
              setState(() => _vendorFAQs.add({'question': '', 'answer': ''})),
          onRemove: (i) => setState(() => _vendorFAQs.removeAt(i)),
          itemBuilder: (index, item) => KeyValueInput(
            keyHint: 'Question',
            valueHint: 'Answer',
            initialKey: item['question']!,
            initialValue: item['answer']!,
            onKeyChanged: (val) => _vendorFAQs[index]['question'] = val,
            onValueChanged: (val) => _vendorFAQs[index]['answer'] = val,
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationStep() {
    final localDocPath = _localDocPath;
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Identity Verification (KYC)',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'To ensure security, we need to verify your identity. Please upload a valid Government ID.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 24.h),
          DropdownButtonFormField<String>(
            value: _selectedDocType,
            decoration: InputDecoration(
              labelText: 'Document Type',
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.w),
                child: FaIcon(FontAwesomeIcons.idBadge, size: 18.w),
              ),
              border: const OutlineInputBorder(),
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            items: _docTypes.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (val) => setState(() => _selectedDocType = val),
          ),
          SizedBox(height: 16.h),
          TextFormField(
            controller: _idNumberController,
            decoration: InputDecoration(
              labelText: 'ID Number',
              hintText: 'e.g. GHA-123456789-0',
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.w),
                child: FaIcon(FontAwesomeIcons.hashtag, size: 18.w),
              ),
              border: const OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () async {
              // Now we only pick and process locally. Upload happens on finish.
              final file = await ref
                  .read(storageRepositoryProvider)
                  .pickAndProcessFile(
                    fileType: FileType.any, // Allow PDF or Image
                  );

              if (file != null) {
                setState(() {
                  _localDocPath = file.path;
                  // We don't set _idUploaded yet because it's not on the server
                });
                debugPrint('Local ID selected: $_localDocPath');
              }
            },
            child: Container(
              height: 250.h,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: _idUploaded
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.05),
                border: Border.all(
                  color: _idUploaded
                      ? Colors.green
                      : Colors.grey.withOpacity(0.3),
                  width: 2.w,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(16.w),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (localDocPath != null &&
                      (localDocPath.toLowerCase().endsWith('.jpg') ||
                          localDocPath.toLowerCase().endsWith('.jpeg') ||
                          localDocPath.toLowerCase().endsWith('.png'))) ...[
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.file(
                            File(localDocPath),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          if (_isSubmitting)
                            const Center(child: CircularProgressIndicator()),
                          if (_idUploaded)
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.solidCheckCircle,
                                  color: Colors.green,
                                  size: 16.w,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ] else if (_idUploaded) ...[
                    FaIcon(
                      FontAwesomeIcons.solidCheckCircle,
                      size: 48.w,
                      color: Colors.green,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'ID Uploaded',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 14.sp,
                      ),
                    ),
                  ] else ...[
                    FaIcon(
                      FontAwesomeIcons.cloudArrowUp,
                      size: 40.w,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Tap to Upload ID Front',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_selectedRole == UserRole.vendor) ...[
            SizedBox(height: 32.h),
            Text(
              'Business Compliance (Optional)',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'You can upload your Business Registration and Operating License now for faster verification, or provide them later.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: _buildDocUploadBox(
                    label: 'Business Registration (Optional)',
                    path: _localRegDocPath,
                    onTap: () async {
                      final file = await ref
                          .read(storageRepositoryProvider)
                          .pickAndProcessFile(fileType: FileType.any);
                      if (file != null) {
                        setState(() => _localRegDocPath = file.path);
                      }
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildDocUploadBox(
                    label: 'Operating License (Optional)',
                    path: _localLicenseDocPath,
                    onTap: () async {
                      final file = await ref
                          .read(storageRepositoryProvider)
                          .pickAndProcessFile(fileType: FileType.any);
                      if (file != null) {
                        setState(() => _localLicenseDocPath = file.path);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 32.h),
          Center(
            child: GestureDetector(
              onTap: () => context.push('/terms'),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                  ),
                  children: [
                    const TextSpan(text: 'By continuing, you agree to our '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' regarding data processing.'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h), // Extra padding for scroll
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Row(
        children: [
          if (_currentStep > 0 && widget.initialStep == 0)
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                setState(() => _currentStep--);
              },
              child: const Text('Back'),
            ),
          const Spacer(),
          GradientButton(
            text: _currentStep == 2
                ? (_isSubmitting ? 'Verifying...' : 'Complete Setup')
                : (widget.initialStep == 1 && _currentStep == 1
                      ? 'Save Changes'
                      : 'Continue'),
            width: 150.w,
            onPressed: _isSubmitting ? null : _nextStep,
          ),
        ],
      ),
    );
  }

  Widget _buildDocUploadBox({
    required String label,
    required String? path,
    required VoidCallback onTap,
  }) {
    final bool isUploaded = path != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          color: isUploaded
              ? Colors.green.withOpacity(0.05)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isUploaded
                ? Colors.green
                : Theme.of(context).colorScheme.outline,
            width: 2.w,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              isUploaded
                  ? FontAwesomeIcons.solidCheckCircle
                  : FontAwesomeIcons.fileArrowUp,
              color: isUploaded
                  ? Colors.green
                  : Theme.of(context).colorScheme.primary,
              size: 28.w,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: isUploaded
                    ? Colors.green
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            if (isUploaded)
              Text(
                'File selected',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.green.withOpacity(0.8),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProgress() async {
    // Only save if a role is selected
    if (_selectedRole == null) return;

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) return;

      final updatedUser = currentUser.copyWith(
        name: _nameController.text.trim(),
        role: _selectedRole!,
        phoneNumber: _phoneController.text.trim(),
        companyLogo: _uploadedLogoUrl ?? currentUser.companyLogo,
        companyBanner: _uploadedBannerUrl ?? currentUser.companyBanner,
        address: AddressInfo(
          street: _streetController.text.trim(),
          suburb: _suburbController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          zip: _zipController.text.trim(),
          country: _selectedCountry?.name ?? '',
          countryCode: _selectedCountry?.code ?? '',
          currency: _selectedCountry?.currency ?? '',
          fullAddress:
              '${_streetController.text.trim()}, ${_suburbController.text.trim()}, ${_cityController.text.trim()}',
        ),
        identity: IdentityInfo(
          idType: _selectedDocType,
          idNumber: _idNumberController.text.trim(),
          idUploaded: _idUploaded,
          idUrl: _uploadedIdUrl,
          onboardingStep: _currentStep,
          lastAutoSavedAt: DateTime.now().toIso8601String(),
        ),
        vendorKyc: _selectedRole == UserRole.vendor
            ? VendorKyc(
                businessName: _businessNameController.text.trim(),
                businessRegNumber: _businessRegNumberController.text.trim(),
                businessDescription: _businessDescriptionController.text.trim(),
                vendorPhones: _vendorPhones,
                vendorAddresses: _vendorAddresses,
                vendorSocials: _vendorSocials,
                vendorFAQs: _vendorFAQs,
                vendorRoutes: _vendorRoutes,
                vendorRates: _vendorRates,
                vendorServices: _vendorServices,
              )
            : null,
        courierKyc: _selectedRole == UserRole.courier
            ? CourierKyc(
                vehicleType: _vehicleTypeController.text.trim(),
                vehicleRegNumber: _vehicleRegNumberController.text.trim(),
              )
            : null,
        payoutDetails:
            (_selectedRole == UserRole.vendor ||
                _selectedRole == UserRole.courier)
            ? PayoutDetails(
                accountName: _payoutAccountNameController.text.trim(),
                accountNumber: _payoutAccountNumberController.text.trim(),
                bankName: _payoutBankNameController.text.trim(),
                branchCode: _payoutBranchCodeController.text.trim(),
                swiftCode: _payoutSwiftCodeController.text.trim(),
                type: _payoutType,
                currency: _payoutCurrency,
              )
            : null,
        // kycData: null, // REMOVED: Prevent data loss until migration verified
      );

      await ref.read(authRepositoryProvider).updateUser(updatedUser);
      debugPrint('Progress auto-saved successfully');
    } catch (e) {
      debugPrint('Failed to auto-save progress: $e');
    }
  }

  static const Map<String, IconData> _socialPlatforms = {
    'Instagram': FontAwesomeIcons.instagram,
    'Facebook': FontAwesomeIcons.facebook,
    'Twitter / X': FontAwesomeIcons.twitter,
    'TikTok': FontAwesomeIcons.tiktok,
    'LinkedIn': FontAwesomeIcons.linkedin,
    'YouTube': FontAwesomeIcons.youtube,
    'Website': FontAwesomeIcons.globe,
    'WhatsApp': FontAwesomeIcons.whatsapp,
    'Telegram': FontAwesomeIcons.telegram,
  };
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 3.w : 1.w, // Deep border for selected
          ),
          borderRadius: BorderRadius.circular(16.w),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10.w,
                offset: Offset(0, 5.h),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                icon,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                size: 20.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ... (Existing Imports)

// Add Payout Controllers to State in _ProfileBuilderScreenState
/*
  // Payout Config
  final _payoutAccountNameController = TextEditingController();
  final _payoutAccountNumberController = TextEditingController();
  final _payoutBankNameController = TextEditingController();
  final _payoutBranchCodeController = TextEditingController();
  final _payoutSwiftCodeController = TextEditingController();
  String _payoutType = 'bank_transfer'; // bank_transfer, mobile_money, crypto_wallet
  String _payoutCurrency = 'USD';
*/

// ... (Existing Code)

class _PayoutSetupStep extends StatelessWidget {
  final TextEditingController accountNameController;
  final TextEditingController accountNumberController;
  final TextEditingController bankNameController;
  final TextEditingController branchCodeController;
  final TextEditingController swiftCodeController;
  final String selectedType;
  final String selectedCurrency;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onCurrencyChanged;

  const _PayoutSetupStep({
    required this.accountNameController,
    required this.accountNumberController,
    required this.bankNameController,
    required this.branchCodeController,
    required this.swiftCodeController,
    required this.selectedType,
    required this.selectedCurrency,
    required this.onTypeChanged,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payout Setup',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedType,
          items: const [
            DropdownMenuItem(
              value: 'bank_transfer',
              child: Text('Bank Transfer'),
            ),
            DropdownMenuItem(
              value: 'mobile_money',
              child: Text('Mobile Money'),
            ),
            DropdownMenuItem(
              value: 'crypto_wallet',
              child: Text('Crypto Wallet'),
            ),
          ],
          onChanged: onTypeChanged,
          decoration: InputDecoration(
            labelText: 'Payout Method',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedCurrency,
          items: const [
            DropdownMenuItem(value: 'USD', child: Text('USD')),
            DropdownMenuItem(value: 'GHS', child: Text('GHS')),
            DropdownMenuItem(value: 'NGN', child: Text('NGN')),
            DropdownMenuItem(value: 'KES', child: Text('KES')),
            DropdownMenuItem(value: 'ZAR', child: Text('ZAR')),
            DropdownMenuItem(value: 'BTC', child: Text('BTC')),
            DropdownMenuItem(value: 'USDT', child: Text('USDT')),
          ],
          onChanged: onCurrencyChanged,
          decoration: InputDecoration(
            labelText: 'Currency',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        if (selectedType == 'bank_transfer') ...[
          TextFormField(
            controller: bankNameController,
            decoration: InputDecoration(
              labelText: 'Bank Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: accountNameController,
            decoration: InputDecoration(
              labelText: 'Account Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: accountNumberController,
            decoration: InputDecoration(
              labelText: 'Account Number',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: branchCodeController,
            decoration: InputDecoration(
              labelText: 'Branch Code (Optional)',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: swiftCodeController,
            decoration: InputDecoration(
              labelText: 'SWIFT Code (Optional)',
              border: OutlineInputBorder(),
            ),
          ),
        ] else if (selectedType == 'mobile_money') ...[
          TextFormField(
            controller: bankNameController,
            decoration: InputDecoration(
              labelText: 'Network (e.g. MTN)',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: accountNameController,
            decoration: InputDecoration(
              labelText: 'Account Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: accountNumberController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
          ),
        ] else ...[
          TextFormField(
            controller: bankNameController,
            decoration: InputDecoration(
              labelText: 'Wallet Provider (e.g. Binance)',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: accountNumberController,
            decoration: InputDecoration(
              labelText: 'Wallet Address',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ],
    );
  }
}
