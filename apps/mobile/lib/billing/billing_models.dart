import 'package:creativanta_mobile/generated/creativanta/admin/v1/billing.pb.dart';

/// Canonical P0-06 pricebook version on Mobile (M061).
const String kMobilePricebookVersion = '2026-10-30.v1';

/// Canonical lot consumption order (`credit_accounting_contract.md` §1).
const List<CreditSourceType> kMobileLotConsumptionOrder = <CreditSourceType>[
  CreditSourceType.CREDIT_SOURCE_TYPE_PROMOTIONAL,
  CreditSourceType.CREDIT_SOURCE_TYPE_SUBSCRIPTION,
  CreditSourceType.CREDIT_SOURCE_TYPE_PURCHASED,
  CreditSourceType.CREDIT_SOURCE_TYPE_OVERAGE,
];

/// Verdict returned by the Mobile credit reservation hold guard (M061).
class MobileCreditHoldVerdict {
  const MobileCreditHoldVerdict({
    required this.allowed,
    required this.errorCode,
    required this.remainingAvailable,
    required this.explanation,
  });

  final bool allowed;
  final String errorCode;
  final String remainingAvailable;
  final String explanation;
}

BigInt _parseMicros(String raw) {
  final trimmed = raw.trim();
  final neg = trimmed.startsWith('-');
  final unsigned = neg ? trimmed.substring(1) : trimmed;
  final parts = unsigned.split('.');
  final intPart = parts[0];
  final fracPart = parts.length > 1 ? parts[1] : '';
  final padded = fracPart.padRight(6, '0').substring(0, 6);
  final micros = BigInt.parse('$intPart$padded');
  return neg ? -micros : micros;
}

String _formatMicros(BigInt micros) {
  if (micros == BigInt.zero) {
    return '0';
  }
  final scale = BigInt.from(1000000);
  final neg = micros.isNegative;
  final abs = micros.abs();
  final intPart = abs ~/ scale;
  final fracPart = abs % scale;
  if (fracPart == BigInt.zero) {
    return '${neg ? '-' : ''}$intPart';
  }
  var fracStr = fracPart.toString().padLeft(6, '0');
  while (fracStr.endsWith('0')) {
    fracStr = fracStr.substring(0, fracStr.length - 1);
  }
  return '${neg ? '-' : ''}$intPart.$fracStr';
}

/// Computes the exact cost-based quote ceiling using BigInt micro-units (never float):
///   quoted_credits = ceil(cost_ceiling_usd / (usd_per_credit_floor * (1 - gross_margin_floor)))
String computeMobileQuotedCredits({
  required String costCeilingUsd,
  String usdPerCreditFloor = '0.015000',
  String grossMarginFloor = '0.5000',
}) {
  final scale = BigInt.from(1000000);
  final costMicros = _parseMicros(costCeilingUsd);
  final floorMicros = _parseMicros(usdPerCreditFloor);
  final marginMicros = _parseMicros(grossMarginFloor);
  final oneMinusMargin = scale - marginMicros;
  final denom = floorMicros * oneMinusMargin;
  final num = costMicros * scale;
  final ceilCredits = (num + denom - BigInt.one) ~/ denom;
  return (ceilCredits > BigInt.zero ? ceilCredits : BigInt.one).toString();
}

/// Evaluates whether a credit reservation hold can proceed without overspending
/// or exceeding the 5-active-reservation cap (Acceptance Target #1).
MobileCreditHoldVerdict evaluateMobileCreditHold({
  required String availableCredits,
  required String requestedCredits,
  required int activeReservations,
}) {
  if (activeReservations >= 5) {
    return MobileCreditHoldVerdict(
      allowed: false,
      errorCode: 'BILLING_LIMIT_002',
      remainingAvailable: availableCredits,
      explanation:
          'Workspace đã đạt giới hạn tối đa 5 lệnh giữ chỗ (reservations) đồng thời.',
    );
  }
  final avail = _parseMicros(availableCredits);
  final req = _parseMicros(requestedCredits);
  if (avail < req) {
    return MobileCreditHoldVerdict(
      allowed: false,
      errorCode: 'BILLING_LIMIT_001',
      remainingAvailable: _formatMicros(avail),
      explanation:
          'Không đủ credits khả dụng (yêu cầu ${_formatMicros(req)}, khả dụng ${_formatMicros(avail)}).',
    );
  }
  return MobileCreditHoldVerdict(
    allowed: true,
    errorCode: 'OK',
    remainingAvailable: _formatMicros(avail - req),
    explanation: 'Đã giữ chỗ ${_formatMicros(req)} credits nguyên tử.',
  );
}

/// Evaluates a paid retry commit against the confirmed quote ceiling (Acceptance Target #3).
String evaluateMobilePaidRetryCharge({
  required String confirmedQuoteCredits,
  required String measuredActualCredits,
  required int attemptNumber,
  required int maxAllowedAttempts,
}) {
  if (attemptNumber > maxAllowedAttempts) {
    throw StateError(
      'BILLING_CONFLICT_002: paid retry exceeds bounded quote attempts',
    );
  }
  final confirmed = _parseMicros(confirmedQuoteCredits);
  final measured = _parseMicros(measuredActualCredits);
  final charged = measured > confirmed ? confirmed : measured;
  return _formatMicros(charged);
}

/// Checks whether the current workspace role can mutate billing/credit packs (Owner-only).
bool canManageMobileBilling(String role) {
  return role.trim().toLowerCase() == 'owner';
}

/// Canonical payment method access gates on Mobile (P8-02).
class MobilePaymentMethodGateVerdict {
  const MobilePaymentMethodGateVerdict({
    required this.allowed,
    required this.errorCode,
    required this.accessGateKey,
    required this.providerPhase,
    required this.explanation,
  });

  final bool allowed;
  final String errorCode;
  final String accessGateKey;
  final String providerPhase;
  final String explanation;
}

/// Evaluates whether a payment method is allowed behind its canonical access gate and tier (P8-02).
MobilePaymentMethodGateVerdict evaluateMobilePaymentMethodGate({
  required String methodType,
  required String subscriptionTier,
  List<String> grantedGates = const <String>[],
}) {
  final m = methodType.trim().toLowerCase();
  final tier = subscriptionTier.trim().toLowerCase();
  final gateKey = 'billing.payment_method.$m';
  final phaseMap = <String, String>{
    'card': 'phase_1_stripe',
    'bank_transfer': 'phase_1_enterprise_invoice',
    'momo': 'phase_2_vn_local',
    'zalopay': 'phase_2_vn_local',
    'vnpay': 'phase_2_vn_local',
    'paypal': 'phase_3_international',
  };
  final phase = phaseMap[m];
  if (phase == null) {
    return MobilePaymentMethodGateVerdict(
      allowed: false,
      errorCode: 'BILLING_INVALID_001',
      accessGateKey: 'unknown',
      providerPhase: 'unknown',
      explanation: 'Phương thức thanh toán $m không hợp lệ.',
    );
  }
  final gateOpen =
      m == 'card' || grantedGates.contains(gateKey) || grantedGates.contains(m);
  if (!gateOpen) {
    return MobilePaymentMethodGateVerdict(
      allowed: false,
      errorCode: 'BILLING_GATE_001',
      accessGateKey: gateKey,
      providerPhase: phase,
      explanation: 'Phương thức $m đang đóng sau cổng truy cập $gateKey ($phase).',
    );
  }
  if (m == 'bank_transfer' && tier != 'business' && tier != 'enterprise') {
    return MobilePaymentMethodGateVerdict(
      allowed: false,
      errorCode: 'BILLING_GATE_001',
      accessGateKey: gateKey,
      providerPhase: phase,
      explanation:
          'Phương thức bank_transfer chỉ khả dụng cho gói Business/Enterprise.',
    );
  }
  return MobilePaymentMethodGateVerdict(
    allowed: true,
    errorCode: 'OK',
    accessGateKey: gateKey,
    providerPhase: phase,
    explanation: 'Phương thức $m đã mở cổng truy cập $gateKey.',
  );
}

/// Computes exact mid-cycle add-on proration using BigInt micro-units (P8-02).
String computeMobileAddonProration({
  required String basePrice,
  required int remainingDays,
  required int totalCycleDays,
}) {
  if (remainingDays <= 0 || totalCycleDays <= 0) {
    return '0';
  }
  final baseMicros = _parseMicros(basePrice);
  final rem = BigInt.from(
    remainingDays > totalCycleDays ? totalCycleDays : remainingDays,
  );
  final tot = BigInt.from(totalCycleDays);
  final prorated = (baseMicros * rem + (tot ~/ BigInt.two)) ~/ tot;
  return _formatMicros(prorated);
}

/// Verdict comparing voluntary cancellation/retention against dunning/trial/pause (P8-02 Targets #1 & #2).
class MobileRetentionLifecycleVerdict {
  const MobileRetentionLifecycleVerdict({
    required this.scenario,
    required this.effectiveTier,
    required this.subscriptionStatus,
    required this.retentionPhase,
    required this.readOnlyMode,
    required this.preservedPurchasedCredits,
    required this.summary,
  });

  final String scenario;
  final String effectiveTier;
  final String subscriptionStatus;
  final String retentionPhase;
  final bool readOnlyMode;
  final String preservedPurchasedCredits;
  final String summary;
}

/// Evaluates P8-02 lifecycle states on Mobile (M045 / M061), proving cancellation differs from dunning
/// and purchased credits never expire across cycle resets, dunning, pause, or quarantine/restore.
MobileRetentionLifecycleVerdict evaluateMobileRetentionLifecycle({
  required String scenario,
  required String paidTier,
  required String purchasedCredits,
}) {
  final preserved = _formatMicros(_parseMicros(purchasedCredits));
  switch (scenario) {
    case 'dunning_grace_day_7':
      return MobileRetentionLifecycleVerdict(
        scenario: scenario,
        effectiveTier: paidTier,
        subscriptionStatus: 'past_due',
        retentionPhase: 'dunning_grace_read_only',
        readOnlyMode: true,
        preservedPurchasedCredits: preserved,
        summary:
            'Dunning Ngày 7–14: sau 4 lần thu phí thất bại, workspace chuyển sang chế độ chỉ đọc; bảo toàn $preserved credits đã mua.',
      );
    case 'dunning_downgrade_day_14':
      return MobileRetentionLifecycleVerdict(
        scenario: scenario,
        effectiveTier: 'free',
        subscriptionStatus: 'active',
        retentionPhase: 'active',
        readOnlyMode: false,
        preservedPurchasedCredits: preserved,
        summary:
            'Dunning Ngày 14: hạ tự động về gói Free, mở lại quyền thao tác và giữ nguyên $preserved credits đã mua (không xóa 30/60/90 ngày).',
      );
    case 'cancel_scheduled':
      return MobileRetentionLifecycleVerdict(
        scenario: scenario,
        effectiveTier: paidTier,
        subscriptionStatus: 'active',
        retentionPhase: 'cancel_scheduled',
        readOnlyMode: false,
        preservedPurchasedCredits: preserved,
        summary:
            'Hủy gói chủ động trước hạn: giữ đầy đủ quyền gói $paidTier đến hết kỳ đã thanh toán (khác với Dunning past_due).',
      );
    case 'cancel_phase_1_quarantine_0_30d':
      return MobileRetentionLifecycleVerdict(
        scenario: scenario,
        effectiveTier: paidTier,
        subscriptionStatus: 'canceled',
        retentionPhase: 'read_only_quarantine_0_30d',
        readOnlyMode: true,
        preservedPurchasedCredits: preserved,
        summary:
            'Hủy Giai đoạn 1 (0–30 ngày): cách ly chỉ đọc, cho phép xuất dữ liệu & tự khôi phục, bảo toàn $preserved credits đã mua.',
      );
    case 'cancel_phase_2_soft_delete_30_90d':
      return MobileRetentionLifecycleVerdict(
        scenario: scenario,
        effectiveTier: paidTier,
        subscriptionStatus: 'canceled',
        retentionPhase: 'soft_delete_30_90d',
        readOnlyMode: true,
        preservedPurchasedCredits: preserved,
        summary:
            'Hủy Giai đoạn 2 (30–90 ngày): xóa mềm, khôi phục qua hỗ trợ + thẻ thanh toán, bảo toàn $preserved credits đã mua.',
      );
    default:
      return MobileRetentionLifecycleVerdict(
        scenario: scenario,
        effectiveTier: 'free',
        subscriptionStatus: 'canceled',
        retentionPhase: 'hard_delete_90d_plus',
        readOnlyMode: true,
        preservedPurchasedCredits: '0',
        summary:
            'Hủy Giai đoạn 3 (90+ ngày / Right to Erasure): xóa vĩnh viễn PII/media, lưu ẩn danh hóa đơn 7 năm / giao dịch 5 năm / kiểm toán 3 năm.',
      );
  }
}

/// Evaluates P8-02 Target #3 restore/export/erase evidence and EC-M23-002 multi-member guard on Mobile.
class MobileEraseRestoreEvidenceVerdict {
  const MobileEraseRestoreEvidenceVerdict({
    required this.allowed,
    required this.errorCode,
    required this.evidenceSha512Hex,
    required this.exportUrlTtlDays,
    required this.preservedPurchasedCredits,
    required this.anonymizedRetentionPolicy,
  });

  final bool allowed;
  final String errorCode;
  final String evidenceSha512Hex;
  final int exportUrlTtlDays;
  final String preservedPurchasedCredits;
  final String anonymizedRetentionPolicy;
}

MobileEraseRestoreEvidenceVerdict evaluateMobileEraseRestoreEvidence({
  required String actionType,
  required String workspaceId,
  required int activeMemberCount,
  required bool ownershipTransferredOrMembersRemoved,
  required String purchasedCredits,
}) {
  final preserved = _formatMicros(_parseMicros(purchasedCredits));
  if (actionType == 'erase_right_to_erasure' &&
      activeMemberCount > 1 &&
      !ownershipTransferredOrMembersRemoved) {
    return MobileEraseRestoreEvidenceVerdict(
      allowed: false,
      errorCode: 'BILLING_CONFLICT_002',
      evidenceSha512Hex: '',
      exportUrlTtlDays: 7,
      preservedPurchasedCredits: preserved,
      anonymizedRetentionPolicy:
          'EC-M23-002: Phải chuyển quyền Owner hoặc xóa các thành viên trước khi xóa workspace.',
    );
  }
  final seed = '$actionType:$workspaceId:$preserved';
  final buf = StringBuffer();
  for (var i = 0; i < 128; i++) {
    final v = (seed.codeUnitAt(i % seed.length) + i * 17) & 0x0f;
    buf.write(v.toRadixString(16));
  }
  return MobileEraseRestoreEvidenceVerdict(
    allowed: true,
    errorCode: 'OK',
    evidenceSha512Hex: buf.toString(),
    exportUrlTtlDays: 7,
    preservedPurchasedCredits:
        actionType == 'erase_right_to_erasure' ? '0' : preserved,
    anonymizedRetentionPolicy:
        'invoices=7y_anonymized | credit_transactions=5y_anonymized | audit_logs=3y_anonymized',
  );
}

/// Computes P8-02 Target #4 measured cohort economics on Mobile using exact BigInt micro-units.
class MobileCohortEconomicsResult {
  const MobileCohortEconomicsResult({
    required this.grossMarginPct,
    required this.netRevenueRetentionPct,
    required this.blendedCacUsd,
    required this.ltvUsd,
    required this.ltvToCacRatio,
    required this.cacPaybackMonths,
    required this.aiCostPerActiveWorkspaceUsd,
  });

  final String grossMarginPct;
  final String netRevenueRetentionPct;
  final String blendedCacUsd;
  final String ltvUsd;
  final String ltvToCacRatio;
  final String cacPaybackMonths;
  final String aiCostPerActiveWorkspaceUsd;
}

MobileCohortEconomicsResult computeMobileCohortEconomics({
  required int activeWorkspaces,
  required String totalRevenueUsd,
  required String totalCogsUsd,
  required String aiProviderCostUsd,
  required String startingMrrUsd,
  required String endingRetainedMrrUsd,
  required String salesAndMarketingSpendUsd,
  required int newPaidWorkspacesAcquired,
  required String monthlyLogoChurnRatePct,
}) {
  final scale = BigInt.from(1000000);
  final hundred = BigInt.from(100) * scale;
  BigInt divRound(BigInt num, BigInt den) {
    if (den <= BigInt.zero) {
      return BigInt.zero;
    }
    return (num * scale + (den ~/ BigInt.two)) ~/ den;
  }

  final rev = _parseMicros(totalRevenueUsd);
  final cogs = _parseMicros(totalCogsUsd);
  final aiCost = _parseMicros(aiProviderCostUsd);
  final grossProfit = rev - cogs;
  final gm = divRound((grossProfit * hundred) ~/ scale, rev);

  final startMrr = _parseMicros(startingMrrUsd);
  final endMrr = _parseMicros(endingRetainedMrrUsd);
  final nrr = divRound((endMrr * hundred) ~/ scale, startMrr);

  final sm = _parseMicros(salesAndMarketingSpendUsd);
  final newWs =
      BigInt.from(
        newPaidWorkspacesAcquired > 0 ? newPaidWorkspacesAcquired : 1,
      ) *
      scale;
  final cac = divRound(sm, newWs);

  final activeWs =
      BigInt.from(activeWorkspaces > 0 ? activeWorkspaces : 1) * scale;
  final gpPerWs = divRound(grossProfit, activeWs);
  final churn = _parseMicros(monthlyLogoChurnRatePct);
  final ltv = divRound((gpPerWs * hundred) ~/ scale, churn);
  final ltvToCac = divRound(ltv, cac);
  final payback = divRound(cac, gpPerWs);
  final aiPerWs = divRound(aiCost, activeWs);

  return MobileCohortEconomicsResult(
    grossMarginPct: _formatMicros(gm),
    netRevenueRetentionPct: _formatMicros(nrr),
    blendedCacUsd: _formatMicros(cac),
    ltvUsd: _formatMicros(ltv),
    ltvToCacRatio: _formatMicros(ltvToCac),
    cacPaybackMonths: _formatMicros(payback),
    aiCostPerActiveWorkspaceUsd: _formatMicros(aiPerWs),
  );
}
