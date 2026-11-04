/// Fulfillment, Returns, Refunds and Operating Ledger Mobile Models
/// Module M13 (docs/02_features/commerce/product_hub.md) & M19 (docs/02_features/finance/operating_ledger.md)
///
/// Implements:
/// - Target 1: I01–I10 stock sync & payment races
/// - Target 2: Correcting fees preserve proof (F06)
/// - Target 3: No double refund/restock (cumulative bounds & orthogonality)
library;

enum MobileCommercePlatform {
  tiktok,
  shopee,
  lazada,
  stripe,
}

enum MobileOrderLifecycleState {
  created,
  confirmed,
  fulfilled,
  completed,
  partiallyRefunded,
  refunded,
  returned,
  cancelled,
}

enum MobileReturnLifecycleState {
  initiated,
  approved,
  shippedBack,
  received,
  inspected,
  closed,
  rejected,
}

enum MobileRefundLifecycleState {
  requested,
  approved,
  processing,
  completed,
  rejected,
  failed,
  cancelled,
}

class MobileReturnItem {
  final String sku;
  final int quantity;
  final String? reason;

  const MobileReturnItem({
    required this.sku,
    required this.quantity,
    this.reason,
  });
}

class MobileOrderItem {
  final String sku;
  final String name;
  final int quantity;
  final String unitPrice;
  final String? unitCogs;

  const MobileOrderItem({
    required this.sku,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.unitCogs,
  });
}

class MobileReturnRecord {
  final String returnId;
  final String orderId;
  final List<MobileReturnItem> items;
  final MobileReturnLifecycleState lifecycleState;
  final String? trackingNumber;
  final DateTime createdAt;

  const MobileReturnRecord({
    required this.returnId,
    required this.orderId,
    required this.items,
    required this.lifecycleState,
    this.trackingNumber,
    required this.createdAt,
  });
}

class MobileRefundRecord {
  final String refundId;
  final String orderId;
  final String amount;
  final String currency;
  final MobileRefundLifecycleState lifecycleState;
  final String reason;
  final DateTime createdAt;

  const MobileRefundRecord({
    required this.refundId,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.lifecycleState,
    required this.reason,
    required this.createdAt,
  });
}

class MobilePlatformCapability {
  final MobileCommercePlatform platform;
  final bool isNative;
  final String status; // 'verified' | 'manual'
  final String reason;

  const MobilePlatformCapability({
    required this.platform,
    required this.isNative,
    required this.status,
    required this.reason,
  });
}

/// Exact decimal micros math (scaled by 1,000,000) to avoid floating point drift.
BigInt parseExactMicros(String val) {
  final clean = val.trim();
  if (clean.isEmpty) return BigInt.zero;
  final isNegative = clean.startsWith('-');
  final unsigned = isNegative ? clean.substring(1) : clean;

  final parts = unsigned.split('.');
  final wholePart = BigInt.parse(parts[0].isEmpty ? '0' : parts[0]);
  var fracStr = parts.length > 1 ? parts[1] : '';
  if (fracStr.length > 6) {
    fracStr = fracStr.substring(0, 6);
  }
  while (fracStr.length < 6) {
    fracStr += '0';
  }
  final fracPart = BigInt.parse(fracStr);
  final total = wholePart * BigInt.from(1000000) + fracPart;
  return isNegative ? -total : total;
}

String formatExactMicros(BigInt micros) {
  final isNegative = micros < BigInt.zero;
  final abs = isNegative ? -micros : micros;
  final whole = abs ~/ BigInt.from(1000000);
  final frac = abs % BigInt.from(1000000);
  final prefix = isNegative ? '-' : '';
  if (frac == BigInt.zero) {
    return '$prefix$whole';
  }
  var fracStr = frac.toString().padLeft(6, '0');
  fracStr = fracStr.replaceAll(RegExp(r'0+$'), '');
  return '$prefix$whole.$fracStr';
}

/// Validates physical return cumulative quantities against purchased items (RULE-M13-006).
bool validateReturnBounds(
  List<MobileOrderItem> orderItems,
  List<MobileReturnRecord> priorReturns,
  List<MobileReturnItem> newItems,
) {
  final orderedQty = <String, int>{};
  for (final it in orderItems) {
    orderedQty[it.sku] = (orderedQty[it.sku] ?? 0) + it.quantity;
  }

  final returnedQty = <String, int>{};
  for (final pr in priorReturns) {
    if (pr.lifecycleState != MobileReturnLifecycleState.rejected) {
      for (final it in pr.items) {
        returnedQty[it.sku] = (returnedQty[it.sku] ?? 0) + it.quantity;
      }
    }
  }

  for (final it in newItems) {
    if (it.quantity <= 0) return false;
    final maxAllowed = orderedQty[it.sku] ?? 0;
    final current = returnedQty[it.sku] ?? 0;
    if (current + it.quantity > maxAllowed) {
      return false;
    }
  }
  return true;
}

/// Validates cumulative monetary refunds against order total.
bool validateRefundBounds(
  String orderAmount,
  List<MobileRefundRecord> priorRefunds,
  String newRefundAmount,
) {
  final orderMicros = parseExactMicros(orderAmount);
  var refundedMicros = BigInt.zero;

  for (final r in priorRefunds) {
    if (r.lifecycleState == MobileRefundLifecycleState.approved ||
        r.lifecycleState == MobileRefundLifecycleState.completed) {
      refundedMicros += parseExactMicros(r.amount);
    }
  }

  final remainingMicros = orderMicros - refundedMicros;
  final newMicros = parseExactMicros(newRefundAmount);

  if (newMicros <= BigInt.zero) return false;
  if (newMicros > remainingMicros) return false;
  return true;
}

/// Evaluates platform capability with safe fallback to manual export.
MobilePlatformCapability evaluatePlatformCapability(
  MobileCommercePlatform platform,
  bool hasVerifiedAccess,
) {
  if (hasVerifiedAccess) {
    return MobilePlatformCapability(
      platform: platform,
      isNative: true,
      status: 'verified',
      reason: 'Direct API partner integration active and authorized',
    );
  }
  return MobilePlatformCapability(
    platform: platform,
    isNative: false,
    status: 'manual',
    reason: 'Provider unverified; fallback to authorized CSV and manual export under connector specs §2',
  );
}

/// Computes polling delta and duplicate poll no-op detection (I10).
Map<String, dynamic> computeStockDelta(int currentOnHand, int reportedStock) {
  final delta = reportedStock - currentOnHand;
  return {
    'delta': delta,
    'isNoOp': delta == 0,
  };
}

/// Calculates net profit preserving ledger proof (F06).
String calculateNetProfit({
  required String grossRevenue,
  required String platformFee,
  required String shippingCost,
  required String affiliateCommission,
  required String cogs,
  String refundDeductions = '0',
}) {
  final rev = parseExactMicros(grossRevenue);
  final pf = parseExactMicros(platformFee);
  final sc = parseExactMicros(shippingCost);
  final ac = parseExactMicros(affiliateCommission);
  final cg = parseExactMicros(cogs);
  final rf = parseExactMicros(refundDeductions);

  final totalDeductions = pf + sc + ac + cg + rf;
  final net = rev - totalDeductions;
  return formatExactMicros(net);
}
