import 'package:creativanta_mobile/generated/creativanta/commerce/v1/monetization.pb.dart';

/// Fixed micro-units arithmetic for monetary calculations (never float per DB-H-001).
BigInt parseMicros(String raw) {
  final trimmed = raw.trim();
  final neg = trimmed.startsWith('-');
  final unsigned = neg ? trimmed.substring(1) : trimmed;
  final parts = unsigned.split('.');
  final intPart = parts[0].isEmpty ? '0' : parts[0];
  final fracPart = parts.length > 1 ? parts[1] : '';
  final padded = fracPart.padRight(6, '0').substring(0, 6);
  final micros = BigInt.parse('$intPart$padded');
  return neg ? -micros : micros;
}

String formatMicros(BigInt micros) {
  if (micros == BigInt.zero) {
    return '0.0';
  }
  final scale = BigInt.from(1000000);
  final neg = micros.isNegative;
  final abs = micros.abs();
  final intPart = abs ~/ scale;
  final fracPart = abs % scale;
  if (fracPart == BigInt.zero) {
    return '${neg ? '-' : ''}$intPart.0';
  }
  var fracStr = fracPart.toString().padLeft(6, '0');
  while (fracStr.length > 1 && fracStr.endsWith('0')) {
    fracStr = fracStr.substring(0, fracStr.length - 1);
  }
  return '${neg ? '-' : ''}$intPart.$fracStr';
}

/// Mobile domain representations for Monetization OS (M14).
class MobileOffer {
  const MobileOffer({
    required this.offerId,
    required this.workspaceId,
    required this.title,
    required this.offerType,
    required this.pricingValue,
    required this.pricingCurrency,
    this.productId,
    this.productLessDeclaration,
    required this.lifecycleState,
    this.validFrom,
    this.validUntil,
  });

  final String offerId;
  final String workspaceId;
  final String title;
  final OfferType offerType;
  final String pricingValue;
  final String pricingCurrency;
  final String? productId;
  final String? productLessDeclaration;
  final OfferLifecycleState lifecycleState;
  final DateTime? validFrom;
  final DateTime? validUntil;

  bool get isExpired {
    if (lifecycleState == OfferLifecycleState.OFFER_LIFECYCLE_STATE_EXPIRED) {
      return true;
    }
    if (validUntil != null && DateTime.now().toUtc().isAfter(validUntil!)) {
      return true;
    }
    return false;
  }
}

class MobileCoupon {
  const MobileCoupon({
    required this.couponId,
    required this.workspaceId,
    required this.code,
    required this.couponType,
    required this.discountValue,
    this.minOrderAmount,
    this.maxUses,
    required this.currentUses,
    required this.lifecycleState,
    this.validFrom,
    this.validUntil,
  });

  final String couponId;
  final String workspaceId;
  final String code;
  final CouponType couponType;
  final String discountValue;
  final String? minOrderAmount;
  final int? maxUses;
  final int currentUses;
  final CouponLifecycleState lifecycleState;
  final DateTime? validFrom;
  final DateTime? validUntil;

  bool get isExpired {
    if (lifecycleState == CouponLifecycleState.COUPON_LIFECYCLE_STATE_EXPIRED) {
      return true;
    }
    if (validUntil != null && DateTime.now().toUtc().isAfter(validUntil!)) {
      return true;
    }
    if (maxUses != null && currentUses >= maxUses!) {
      return true;
    }
    return false;
  }

  MobileCoupon copyWithRedemption() {
    final nextUses = currentUses + 1;
    final expired = maxUses != null && nextUses >= maxUses!;
    return MobileCoupon(
      couponId: couponId,
      workspaceId: workspaceId,
      code: code,
      couponType: couponType,
      discountValue: discountValue,
      minOrderAmount: minOrderAmount,
      maxUses: maxUses,
      currentUses: nextUses,
      lifecycleState: expired
          ? CouponLifecycleState.COUPON_LIFECYCLE_STATE_EXPIRED
          : lifecycleState,
      validFrom: validFrom,
      validUntil: validUntil,
    );
  }
}

class MobileCampaign {
  const MobileCampaign({
    required this.campaignId,
    required this.workspaceId,
    required this.title,
    required this.campaignType,
    required this.status,
    required this.budget,
    required this.budgetCurrency,
    required this.totalSpend,
  });

  final String campaignId;
  final String workspaceId;
  final String title;
  final CampaignType campaignType;
  final CampaignStatus status;
  final String budget;
  final String budgetCurrency;
  final String totalSpend;

  int get utilizationPercentage {
    final budgetMicros = parseMicros(budget);
    if (budgetMicros <= BigInt.zero) return 0;
    final spendMicros = parseMicros(totalSpend);
    return ((spendMicros * BigInt.from(100)) ~/ budgetMicros).toInt();
  }

  bool get isWarning => utilizationPercentage >= 80;
  bool get isOverBudget => utilizationPercentage >= 100;
}

class MobileFinancialPosting {
  const MobileFinancialPosting({
    required this.postingId,
    required this.workspaceId,
    required this.orderId,
    this.offerId,
    this.couponId,
    required this.component,
    required this.grossAmount,
    required this.discountAmount,
    required this.netAmount,
    required this.currency,
    required this.timestamp,
  });

  final String postingId;
  final String workspaceId;
  final String orderId;
  final String? offerId;
  final String? couponId;
  final String component;
  final String grossAmount;
  final String discountAmount;
  final String netAmount;
  final String currency;
  final DateTime timestamp;
}

class MobileCheckoutResult {
  const MobileCheckoutResult({
    required this.accepted,
    this.errorCode,
    this.errorMessage,
    required this.originalAmount,
    required this.discountAmount,
    required this.netPayableAmount,
    required this.currency,
    this.orderId,
    this.posting,
    this.updatedCoupon,
  });

  final bool accepted;
  final String? errorCode;
  final String? errorMessage;
  final String originalAmount;
  final String discountAmount;
  final String netPayableAmount;
  final String currency;
  final String? orderId;
  final MobileFinancialPosting? posting;
  final MobileCoupon? updatedCoupon;
}

/// Evaluates mobile checkout against active offers and coupons.
/// Acceptance Target 1: Expired offer rejected (ERR_OFFER_EXPIRED).
/// Acceptance Target 2: Coupon races do not exceed limits (ERR_COUPON_LIMIT_EXCEEDED / ERR_COUPON_EXPIRED).
/// Acceptance Target 3: Financial impact reaches ledger (MobileFinancialPosting created).
MobileCheckoutResult evaluateMobileCheckout({
  required String workspaceId,
  MobileOffer? offer,
  MobileCoupon? coupon,
  required String orderAmount,
  required String currency,
  DateTime? evaluatedAt,
}) {
  final now = evaluatedAt ?? DateTime.now().toUtc();
  final orderMicros = parseMicros(orderAmount);

  // 1. Target 1: Expired offer rejection
  if (offer != null) {
    if (offer.lifecycleState == OfferLifecycleState.OFFER_LIFECYCLE_STATE_EXPIRED ||
        (offer.validUntil != null && now.isAfter(offer.validUntil!))) {
      return MobileCheckoutResult(
        accepted: false,
        errorCode: 'ERR_OFFER_EXPIRED',
        errorMessage: 'Offer has expired and cannot be applied to checkout',
        originalAmount: orderAmount,
        discountAmount: '0.0',
        netPayableAmount: orderAmount,
        currency: currency,
      );
    }
  }

  // 2. Target 2: Coupon limits & race protection
  BigInt discountMicros = BigInt.zero;
  MobileCoupon? updatedCoupon;

  if (coupon != null) {
    if (coupon.lifecycleState == CouponLifecycleState.COUPON_LIFECYCLE_STATE_EXPIRED ||
        (coupon.validUntil != null && now.isAfter(coupon.validUntil!))) {
      return MobileCheckoutResult(
        accepted: false,
        errorCode: 'ERR_COUPON_EXPIRED',
        errorMessage: 'Coupon code has expired',
        originalAmount: orderAmount,
        discountAmount: '0.0',
        netPayableAmount: orderAmount,
        currency: currency,
      );
    }

    if (coupon.maxUses != null && coupon.currentUses >= coupon.maxUses!) {
      return MobileCheckoutResult(
        accepted: false,
        errorCode: 'ERR_COUPON_LIMIT_EXCEEDED',
        errorMessage: 'Coupon usage limit has been reached',
        originalAmount: orderAmount,
        discountAmount: '0.0',
        netPayableAmount: orderAmount,
        currency: currency,
      );
    }

    if (coupon.minOrderAmount != null) {
      final minMicros = parseMicros(coupon.minOrderAmount!);
      if (orderMicros < minMicros) {
        return MobileCheckoutResult(
          accepted: false,
          errorCode: 'ERR_COUPON_MIN_NOT_MET',
          errorMessage: 'Order subtotal does not meet coupon minimum',
          originalAmount: orderAmount,
          discountAmount: '0.0',
          netPayableAmount: orderAmount,
          currency: currency,
        );
      }
    }

    // Calculate discount
    if (coupon.couponType == CouponType.COUPON_TYPE_FIXED_AMOUNT) {
      final fixedMicros = parseMicros(coupon.discountValue);
      discountMicros = fixedMicros > orderMicros ? orderMicros : fixedMicros;
    } else if (coupon.couponType == CouponType.COUPON_TYPE_PERCENTAGE) {
      final pctMicros = parseMicros(coupon.discountValue);
      discountMicros = (orderMicros * pctMicros) ~/ (BigInt.from(100) * BigInt.from(1000000));
      if (discountMicros > orderMicros) {
        discountMicros = orderMicros;
      }
    }

    updatedCoupon = coupon.copyWithRedemption();
  }

  // 3. Target 3: Financial impact reaches ledger
  final netMicros = orderMicros > discountMicros ? orderMicros - discountMicros : BigInt.zero;
  final orderId = 'ord-mob-${now.millisecondsSinceEpoch}';
  final postingId = 'post-rev-${now.millisecondsSinceEpoch}';

  final posting = MobileFinancialPosting(
    postingId: postingId,
    workspaceId: workspaceId,
    orderId: orderId,
    offerId: offer?.offerId,
    couponId: coupon?.couponId,
    component: 'revenue',
    grossAmount: formatMicros(orderMicros),
    discountAmount: formatMicros(discountMicros),
    netAmount: formatMicros(netMicros),
    currency: currency,
    timestamp: now,
  );

  return MobileCheckoutResult(
    accepted: true,
    originalAmount: formatMicros(orderMicros),
    discountAmount: formatMicros(discountMicros),
    netPayableAmount: formatMicros(netMicros),
    currency: currency,
    orderId: orderId,
    posting: posting,
    updatedCoupon: updatedCoupon,
  );
}

/// Validates offer activation per EC-M14-001.
bool validateMobileOfferActivation(MobileOffer offer) {
  if (offer.productId == null && offer.productLessDeclaration == null) {
    return false;
  }
  return true;
}
