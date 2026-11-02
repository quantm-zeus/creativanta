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
