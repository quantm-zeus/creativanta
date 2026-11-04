import 'package:creativanta_mobile/generated/creativanta/commerce/v1/affiliate.pb.dart';

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

/// Mobile Affiliate Link domain representation.
class MobileAffiliateLink {
  const MobileAffiliateLink({
    required this.affiliateLinkId,
    required this.workspaceId,
    required this.platform,
    required this.originalUrl,
    required this.trackedUrl,
    required this.shortCode,
    required this.commissionRate,
    required this.lifecycleState,
    required this.healthStatus,
    this.productId,
    this.campaignId,
    this.clickCount = 0,
    this.conversionCount = 0,
    required this.revenueAttributed,
    this.suggestedReplacementProductId,
    this.expiresAt,
  });

  final String affiliateLinkId;
  final String workspaceId;
  final String platform;
  final String originalUrl;
  final String trackedUrl;
  final String shortCode;
  final String commissionRate;
  final AffiliateLinkLifecycleState lifecycleState;
  final LinkHealthStatus healthStatus;
  final String? productId;
  final String? campaignId;
  final int clickCount;
  final int conversionCount;
  final String revenueAttributed;
  final String? suggestedReplacementProductId;
  final DateTime? expiresAt;

  MobileAffiliateLink copyWith({
    String? originalUrl,
    String? productId,
    LinkHealthStatus? healthStatus,
    String? suggestedReplacementProductId,
  }) {
    return MobileAffiliateLink(
      affiliateLinkId: affiliateLinkId,
      workspaceId: workspaceId,
      platform: platform,
      originalUrl: originalUrl ?? this.originalUrl,
      trackedUrl: trackedUrl,
      shortCode: shortCode,
      commissionRate: commissionRate,
      lifecycleState: lifecycleState,
      healthStatus: healthStatus ?? this.healthStatus,
      productId: productId ?? this.productId,
      campaignId: campaignId,
      clickCount: clickCount,
      conversionCount: conversionCount,
      revenueAttributed: revenueAttributed,
      suggestedReplacementProductId:
          suggestedReplacementProductId ?? this.suggestedReplacementProductId,
      expiresAt: expiresAt,
    );
  }
}

/// Mobile Attribution Record domain representation.
class MobileAttributionRecord {
  const MobileAttributionRecord({
    required this.attributionId,
    required this.workspaceId,
    required this.orderId,
    required this.affiliateLinkId,
    this.creatorEntityId,
    this.touchpointCount = 1,
    this.isMultiTouch = false,
    required this.sourceClass,
    required this.confidence,
    required this.attributionNote,
    required this.orderAmount,
    required this.attributedRevenue,
    required this.commissionAmount,
    required this.currency,
  });

  final String attributionId;
  final String workspaceId;
  final String orderId;
  final String affiliateLinkId;
  final String? creatorEntityId;
  final int touchpointCount;
  final bool isMultiTouch;
  final AttributionSourceClass sourceClass;
  final AttributionConfidence confidence;
  final String attributionNote;
  final String orderAmount;
  final String attributedRevenue;
  final String commissionAmount;
  final String currency;
}

/// Mobile Ledger Posting Evaluation.
class MobileLedgerPostingEvaluation {
  const MobileLedgerPostingEvaluation({
    required this.postingId,
    required this.workspaceId,
    required this.economicRole,
    required this.postingType,
    required this.amount,
    required this.currency,
    required this.cogsDeducted,
    required this.netProfitImpact,
  });

  final String postingId;
  final String workspaceId;
  final WorkspaceEconomicRole economicRole;
  final String postingType;
  final String amount;
  final String currency;
  final bool cogsDeducted;
  final String netProfitImpact;
}

/// Acceptance Target 1:
/// Evaluates ledger posting to guarantee creator income is separate from seller expense,
/// with ZERO COGS deduction from creator income.
MobileLedgerPostingEvaluation evaluateMobileLedgerImpact({
  required String workspaceId,
  required String commissionAmount,
  required String currency,
  required WorkspaceEconomicRole role,
}) {
  final postingId = 'post-mob-${DateTime.now().millisecondsSinceEpoch}';

  if (role == WorkspaceEconomicRole.WORKSPACE_ECONOMIC_ROLE_CREATOR) {
    return MobileLedgerPostingEvaluation(
      postingId: postingId,
      workspaceId: workspaceId,
      economicRole: role,
      postingType: 'creator_income',
      amount: commissionAmount,
      currency: currency,
      cogsDeducted: false, // Acceptance Target 1: ZERO COGS deducted from creator income
      netProfitImpact: '+$commissionAmount',
    );
  }

  // Seller role
  return MobileLedgerPostingEvaluation(
    postingId: postingId,
    workspaceId: workspaceId,
    economicRole: role,
    postingType: 'seller_commission_expense',
    amount: commissionAmount,
    currency: currency,
    cogsDeducted: true, // Seller expense deduction
    netProfitImpact: '-$commissionAmount',
  );
}

/// Acceptance Target 2:
/// Evaluates and labels ambiguous attribution.
MobileAttributionRecord evaluateMobileAttribution({
  required String workspaceId,
  required String orderId,
  required String affiliateLinkId,
  required String orderAmount,
  required String commissionRate,
  required String currency,
  required int touchpointCount,
  required bool isMultiTouch,
  required bool isOfficialAPI,
}) {
  AttributionSourceClass sourceClass;
  AttributionConfidence confidence;
  String note;

  if (isMultiTouch || touchpointCount > 1) {
    sourceClass = AttributionSourceClass.ATTRIBUTION_SOURCE_CLASS_INFERRED;
    confidence = touchpointCount > 3
        ? AttributionConfidence.ATTRIBUTION_CONFIDENCE_LOW
        : AttributionConfidence.ATTRIBUTION_CONFIDENCE_MEDIUM;
    note = 'Multiple touch points detected — last click rule applied.';
  } else if (isOfficialAPI) {
    sourceClass = AttributionSourceClass.ATTRIBUTION_SOURCE_CLASS_OFFICIAL;
    confidence = AttributionConfidence.ATTRIBUTION_CONFIDENCE_HIGH;
    note = 'Official platform API attribution.';
  } else {
    sourceClass = AttributionSourceClass.ATTRIBUTION_SOURCE_CLASS_IMPORTED;
    confidence = AttributionConfidence.ATTRIBUTION_CONFIDENCE_MEDIUM;
    note = 'Imported statement attribution.';
  }

  final orderMicros = parseMicros(orderAmount);
  final rateMicros = parseMicros(commissionRate);
  final commMicros = (orderMicros * rateMicros) ~/ BigInt.from(100000000);
  final commFormatted = formatMicros(commMicros);

  return MobileAttributionRecord(
    attributionId: 'attr-mob-${DateTime.now().millisecondsSinceEpoch}',
    workspaceId: workspaceId,
    orderId: orderId,
    affiliateLinkId: affiliateLinkId,
    touchpointCount: touchpointCount,
    isMultiTouch: isMultiTouch || touchpointCount > 1,
    sourceClass: sourceClass,
    confidence: confidence,
    attributionNote: note,
    orderAmount: orderAmount,
    attributedRevenue: orderAmount,
    commissionAmount: commFormatted,
    currency: currency,
  );
}

/// Acceptance Target 3:
/// Broken link repair workflow for mobile.
MobileAffiliateLink repairMobileBrokenLink(
  MobileAffiliateLink link,
  String newUrl, {
  String? replacementProductId,
}) {
  if (link.lifecycleState ==
      AffiliateLinkLifecycleState.AFFILIATE_LINK_LIFECYCLE_STATE_REVOKED) {
    throw StateError('Cannot repair permanently revoked affiliate link');
  }

  return link.copyWith(
    originalUrl: newUrl.isEmpty ? link.originalUrl : newUrl,
    productId: replacementProductId ?? link.productId,
    suggestedReplacementProductId: replacementProductId,
    healthStatus: LinkHealthStatus.LINK_HEALTH_STATUS_HEALTHY,
  );
}
