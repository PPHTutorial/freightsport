import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('vendor')
  vendor,
  @JsonValue('courier')
  courier,
  @JsonValue('customer')
  customer,
}

enum VerificationStatus {
  @JsonValue('unverified')
  unverified,
  @JsonValue('pending')
  pending,
  @JsonValue('verified')
  verified,
  @JsonValue('rejected')
  rejected,
}

@freezed
class AddressInfo with _$AddressInfo {
  const factory AddressInfo({
    @Default('') String street,
    @Default('') String suburb,
    @Default('') String city,
    @Default('') String state,
    @Default('') String zip,
    @Default('') String country,
    @Default('') String countryCode,
    @Default('') String currency,
    @Default('') String fullAddress,
  }) = _AddressInfo;

  factory AddressInfo.fromJson(Map<String, dynamic> json) =>
      _$AddressInfoFromJson(json);
}

@freezed
class IdentityInfo with _$IdentityInfo {
  const factory IdentityInfo({
    String? idType,
    String? idNumber,
    String? idUrl,
    @Default(false) bool idUploaded,
    String? regDocUrl,
    String? licenseDocUrl,
    String? submittedAt,
    int? onboardingStep,
    String? lastAutoSavedAt,
  }) = _IdentityInfo;

  factory IdentityInfo.fromJson(Map<String, dynamic> json) =>
      _$IdentityInfoFromJson(json);
}

@freezed
class VendorKyc with _$VendorKyc {
  const factory VendorKyc({
    @Default('') String businessName,
    @Default('') String businessRegNumber,
    @Default('') String businessDescription,
    @Default([]) List<Map<String, String>> vendorPhones,
    @Default([]) List<Map<String, dynamic>> vendorAddresses,
    @Default([]) List<Map<String, String>> vendorSocials,
    @Default([]) List<Map<String, String>> vendorFAQs,
    @Default([]) List<Map<String, String>> vendorRoutes,
    @Default([]) List<Map<String, String>> vendorRates,
    @Default([]) List<String> vendorServices,
  }) = _VendorKyc;

  factory VendorKyc.fromJson(Map<String, dynamic> json) =>
      _$VendorKycFromJson(json);
}

@freezed
class CourierKyc with _$CourierKyc {
  const factory CourierKyc({
    @Default('') String vehicleType,
    @Default('') String vehicleRegNumber,
  }) = _CourierKyc;

  factory CourierKyc.fromJson(Map<String, dynamic> json) =>
      _$CourierKycFromJson(json);
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    required String username,
    required UserRole role,
    String? photoUrl,
    String? phoneNumber,
    @Default(VerificationStatus.unverified)
    VerificationStatus verificationStatus,
    @Default(false) bool isProfileComplete,
    Map<String, dynamic>? kycData,
    String? companyLogo,
    String? companyBanner,
    AddressInfo? address,
    IdentityInfo? identity,
    VendorKyc? vendorKyc,
    CourierKyc? courierKyc,
    String? verificationNote,
    @Default([]) List<String> followerIds,
    @Default([]) List<String> followingIds,
    @Default(AccountStatus.active) AccountStatus accountStatus,
    @Default([]) List<String> blockedUserIds,
    @Default(0.0) double averageRating,
    @Default(0) int totalReviews,
    @Default({}) Map<String, int> ratingBreakdown,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

enum AccountStatus {
  @JsonValue('active')
  active,
  @JsonValue('suspended')
  suspended,
  @JsonValue('terminated')
  terminated,
}
