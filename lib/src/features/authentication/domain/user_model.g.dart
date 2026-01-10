// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressInfoImpl _$$AddressInfoImplFromJson(Map<String, dynamic> json) =>
    _$AddressInfoImpl(
      street: json['street'] as String? ?? '',
      suburb: json['suburb'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      zip: json['zip'] as String? ?? '',
      country: json['country'] as String? ?? '',
      countryCode: json['countryCode'] as String? ?? '',
      currency: json['currency'] as String? ?? '',
      fullAddress: json['fullAddress'] as String? ?? '',
    );

Map<String, dynamic> _$$AddressInfoImplToJson(_$AddressInfoImpl instance) =>
    <String, dynamic>{
      'street': instance.street,
      'suburb': instance.suburb,
      'city': instance.city,
      'state': instance.state,
      'zip': instance.zip,
      'country': instance.country,
      'countryCode': instance.countryCode,
      'currency': instance.currency,
      'fullAddress': instance.fullAddress,
    };

_$IdentityInfoImpl _$$IdentityInfoImplFromJson(Map<String, dynamic> json) =>
    _$IdentityInfoImpl(
      idType: json['idType'] as String?,
      idNumber: json['idNumber'] as String?,
      idUrl: json['idUrl'] as String?,
      idUploaded: json['idUploaded'] as bool? ?? false,
      regDocUrl: json['regDocUrl'] as String?,
      licenseDocUrl: json['licenseDocUrl'] as String?,
      submittedAt: json['submittedAt'] as String?,
      onboardingStep: (json['onboardingStep'] as num?)?.toInt(),
      lastAutoSavedAt: json['lastAutoSavedAt'] as String?,
    );

Map<String, dynamic> _$$IdentityInfoImplToJson(_$IdentityInfoImpl instance) =>
    <String, dynamic>{
      'idType': instance.idType,
      'idNumber': instance.idNumber,
      'idUrl': instance.idUrl,
      'idUploaded': instance.idUploaded,
      'regDocUrl': instance.regDocUrl,
      'licenseDocUrl': instance.licenseDocUrl,
      'submittedAt': instance.submittedAt,
      'onboardingStep': instance.onboardingStep,
      'lastAutoSavedAt': instance.lastAutoSavedAt,
    };

_$VendorKycImpl _$$VendorKycImplFromJson(Map<String, dynamic> json) =>
    _$VendorKycImpl(
      businessName: json['businessName'] as String? ?? '',
      businessRegNumber: json['businessRegNumber'] as String? ?? '',
      businessDescription: json['businessDescription'] as String? ?? '',
      vendorPhones:
          (json['vendorPhones'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      vendorAddresses:
          (json['vendorAddresses'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      vendorSocials:
          (json['vendorSocials'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      vendorFAQs:
          (json['vendorFAQs'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      vendorRoutes:
          (json['vendorRoutes'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      vendorRates:
          (json['vendorRates'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      vendorServices:
          (json['vendorServices'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$VendorKycImplToJson(_$VendorKycImpl instance) =>
    <String, dynamic>{
      'businessName': instance.businessName,
      'businessRegNumber': instance.businessRegNumber,
      'businessDescription': instance.businessDescription,
      'vendorPhones': instance.vendorPhones,
      'vendorAddresses': instance.vendorAddresses,
      'vendorSocials': instance.vendorSocials,
      'vendorFAQs': instance.vendorFAQs,
      'vendorRoutes': instance.vendorRoutes,
      'vendorRates': instance.vendorRates,
      'vendorServices': instance.vendorServices,
    };

_$CourierKycImpl _$$CourierKycImplFromJson(Map<String, dynamic> json) =>
    _$CourierKycImpl(
      vehicleType: json['vehicleType'] as String? ?? '',
      vehicleRegNumber: json['vehicleRegNumber'] as String? ?? '',
    );

Map<String, dynamic> _$$CourierKycImplToJson(_$CourierKycImpl instance) =>
    <String, dynamic>{
      'vehicleType': instance.vehicleType,
      'vehicleRegNumber': instance.vehicleRegNumber,
    };

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      verificationStatus:
          $enumDecodeNullable(
            _$VerificationStatusEnumMap,
            json['verificationStatus'],
          ) ??
          VerificationStatus.unverified,
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
      kycData: json['kycData'] as Map<String, dynamic>?,
      companyLogo: json['companyLogo'] as String?,
      companyBanner: json['companyBanner'] as String?,
      address: json['address'] == null
          ? null
          : AddressInfo.fromJson(json['address'] as Map<String, dynamic>),
      identity: json['identity'] == null
          ? null
          : IdentityInfo.fromJson(json['identity'] as Map<String, dynamic>),
      vendorKyc: json['vendorKyc'] == null
          ? null
          : VendorKyc.fromJson(json['vendorKyc'] as Map<String, dynamic>),
      courierKyc: json['courierKyc'] == null
          ? null
          : CourierKyc.fromJson(json['courierKyc'] as Map<String, dynamic>),
      verificationNote: json['verificationNote'] as String?,
      followerIds:
          (json['followerIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      followingIds:
          (json['followingIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      accountStatus:
          $enumDecodeNullable(_$AccountStatusEnumMap, json['accountStatus']) ??
          AccountStatus.active,
      blockedUserIds:
          (json['blockedUserIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      ratingBreakdown:
          (json['ratingBreakdown'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'username': instance.username,
      'role': _$UserRoleEnumMap[instance.role]!,
      'photoUrl': instance.photoUrl,
      'phoneNumber': instance.phoneNumber,
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus]!,
      'isProfileComplete': instance.isProfileComplete,
      'kycData': instance.kycData,
      'companyLogo': instance.companyLogo,
      'companyBanner': instance.companyBanner,
      'address': instance.address?.toJson(),
      'identity': instance.identity?.toJson(),
      'vendorKyc': instance.vendorKyc?.toJson(),
      'courierKyc': instance.courierKyc?.toJson(),
      'verificationNote': instance.verificationNote,
      'followerIds': instance.followerIds,
      'followingIds': instance.followingIds,
      'accountStatus': _$AccountStatusEnumMap[instance.accountStatus]!,
      'blockedUserIds': instance.blockedUserIds,
      'averageRating': instance.averageRating,
      'totalReviews': instance.totalReviews,
      'ratingBreakdown': instance.ratingBreakdown,
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.vendor: 'vendor',
  UserRole.courier: 'courier',
  UserRole.customer: 'customer',
};

const _$VerificationStatusEnumMap = {
  VerificationStatus.unverified: 'unverified',
  VerificationStatus.pending: 'pending',
  VerificationStatus.verified: 'verified',
  VerificationStatus.rejected: 'rejected',
};

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.suspended: 'suspended',
  AccountStatus.terminated: 'terminated',
};
