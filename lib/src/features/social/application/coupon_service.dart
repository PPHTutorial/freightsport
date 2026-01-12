import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/social/data/social_repository.dart';
import 'package:rightlogistics/src/features/social/domain/social_models.dart';
import 'package:rightlogistics/src/features/social/presentation/providers/social_providers.dart';

class CouponService {
  final SocialRepository _repository;

  CouponService(this._repository);

  Future<VendorPost?> validateCoupon({
    required String code,
    required String vendorId,
    required double orderAmount,
  }) async {
    // In a real app, this would be a specific Firestore query.
    // For now, we'll fetch all posts (or use the existing provider) and filter.
    // However, it's better to add a search method to the repository.

    // For this implementation, we assume coupons are stored as VendorPost with type 'promotion'
    final snaps = await _repository.watchActivePosts().first;

    try {
      final coupon = snaps.firstWhere(
        (p) =>
            p.type == PostType.promotion &&
            p.promoCode?.trim().toUpperCase() == code.trim().toUpperCase() &&
            p.vendorId == vendorId,
      );

      // Check Expiry
      if (coupon.promoExpiry != null &&
          coupon.promoExpiry!.isBefore(DateTime.now())) {
        throw 'This coupon has expired.';
      }

      // Check Min Purchase
      if (coupon.minPurchaseAmount != null &&
          orderAmount < coupon.minPurchaseAmount!) {
        throw 'Minimum purchase of ${coupon.currency} ${coupon.minPurchaseAmount} required.';
      }

      // Check Usage Limit (if implemented)
      // if (coupon.usageLimit != null && coupon.usageCount >= coupon.usageLimit!) { ... }

      return coupon;
    } catch (e) {
      if (e is String) rethrow;
      throw 'Invalid coupon code for this vendor.';
    }
  }
}

final couponServiceProvider = Provider<CouponService>((ref) {
  return CouponService(ref.watch(socialRepositoryProvider));
});
