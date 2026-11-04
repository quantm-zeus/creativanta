/// Creator Store, Digital Delivery, Bundles & Memberships Mobile Domain Models
/// Module M15 (docs/02_features/commerce/creator_store.md) & M13 (docs/02_features/commerce/product_hub.md)
///
/// Implements:
/// - Target 1: Bundle stock atomic
/// - Target 2: Payment replay no duplicate delivery
/// - Target 3: Buyer subscription cannot unlock SaaS privileges
library;

enum StorePageStatus { draft, published, hidden, retired }
enum MembershipBillingInterval { monthly, quarterly, yearly }
enum MembershipPlanStatus { draft, active, paused, retired }
enum MembershipSubscriptionStatus { active, cancelled, expired }
enum DigitalDeliveryStatus { pending, delivered, failed, expired }

class MobileStorePage {
  final String storePageId;
  final String workspaceId;
  final String title;
  final String slug;
  final String description;
  final StorePageStatus status;
  final String? customDomain;
  final Map<String, dynamic> layoutJson;
  final Map<String, dynamic> themeOverridesJson;
  final Map<String, dynamic> seoConfigJson;
  final Map<String, dynamic> widgetConfigJson;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MobileStorePage({
    required this.storePageId,
    required this.workspaceId,
    required this.title,
    required this.slug,
    required this.description,
    required this.status,
    this.customDomain,
    this.layoutJson = const {},
    this.themeOverridesJson = const {},
    this.seoConfigJson = const {},
    this.widgetConfigJson = const {},
    required this.createdAt,
    required this.updatedAt,
  });
}

class MobileMembershipPlan {
  final String planId;
  final String workspaceId;
  final String title;
  final String description;
  final String price; // Exact decimal string NUMERIC(18,6)
  final String currency;
  final MembershipBillingInterval interval;
  final List<String> benefits;
  final MembershipPlanStatus status;
  final int subscriberCount;

  const MobileMembershipPlan({
    required this.planId,
    required this.workspaceId,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.interval,
    required this.benefits,
    required this.status,
    this.subscriberCount = 0,
  });
}

class MobileBundleItem {
  final String productId;
  final String productTitle;
  final int quantity;
  final int availableStock;

  const MobileBundleItem({
    required this.productId,
    required this.productTitle,
    required this.quantity,
    this.availableStock = 0,
  });
}

class MobileBundle {
  final String bundleId;
  final String workspaceId;
  final String title;
  final String bundlePrice; // Exact decimal string NUMERIC(18,6)
  final String currency;
  final bool isActive;
  final List<MobileBundleItem> items;

  const MobileBundle({
    required this.bundleId,
    required this.workspaceId,
    required this.title,
    required this.bundlePrice,
    required this.currency,
    this.isActive = true,
    required this.items,
  });
}

class MobileDigitalDelivery {
  final String deliveryId;
  final String orderId;
  final String productId;
  final String downloadToken;
  final String downloadUrl;
  final DigitalDeliveryStatus status;
  final int downloadCount;
  final int maxDownloads;

  const MobileDigitalDelivery({
    required this.deliveryId,
    required this.orderId,
    required this.productId,
    required this.downloadToken,
    required this.downloadUrl,
    required this.status,
    this.downloadCount = 0,
    this.maxDownloads = 5,
  });
}

class MobileBundleStockResult {
  final bool isAvailable;
  final String? reason;
  final int maxPossibleUnits;
  final List<Map<String, dynamic>> stockBreakdown;

  const MobileBundleStockResult({
    required this.isAvailable,
    this.reason,
    required this.maxPossibleUnits,
    required this.stockBreakdown,
  });
}

/// Acceptance Target 1: Bundle stock atomic
MobileBundleStockResult checkMobileBundleStock(
  MobileBundle bundle,
  Map<String, int> inventoryStock, [
  int requestedQty = 1,
]) {
  if (requestedQty <= 0) {
    return const MobileBundleStockResult(
      isAvailable: false,
      reason: 'Requested quantity must be positive',
      maxPossibleUnits: 0,
      stockBreakdown: [],
    );
  }

  bool isAvailable = true;
  String? failReason;
  int minPossible = 999999999;
  final breakdown = <Map<String, dynamic>>[];

  for (final item in bundle.items) {
    final stock = inventoryStock[item.productId] ?? 0;
    final requiredTotal = item.quantity * requestedQty;
    final isSufficient = stock >= requiredTotal;

    final possibleForThis = item.quantity > 0 ? (stock ~/ item.quantity) : 0;
    if (possibleForThis < minPossible) {
      minPossible = possibleForThis;
    }

    if (!isSufficient) {
      isAvailable = false;
      failReason ??= "Component '${item.productTitle}' has insufficient stock (available: $stock, required: $requiredTotal)";
    }

    breakdown.add({
      'productId': item.productId,
      'productTitle': item.productTitle,
      'requiredTotal': requiredTotal,
      'availableStock': stock,
      'isSufficient': isSufficient,
    });
  }

  final maxUnits = bundle.items.isEmpty ? 0 : (minPossible == 999999999 ? 0 : minPossible);

  return MobileBundleStockResult(
    isAvailable: isAvailable,
    reason: isAvailable ? null : failReason,
    maxPossibleUnits: maxUnits,
    stockBreakdown: breakdown,
  );
}

/// Acceptance Target 2: Payment replay no duplicate delivery
class MobileCheckoutRequest {
  final String workspaceId;
  final String customerEntityId;
  final String idempotencyKey;
  final String paymentIntentId;
  final String? bundleId;
  final String orderAmount;
  final String currency;

  const MobileCheckoutRequest({
    required this.workspaceId,
    required this.customerEntityId,
    required this.idempotencyKey,
    required this.paymentIntentId,
    this.bundleId,
    required this.orderAmount,
    required this.currency,
  });
}

class MobileCheckoutResult {
  final bool success;
  final String orderId;
  final List<MobileDigitalDelivery> deliveries;
  final bool isReplayed;

  const MobileCheckoutResult({
    required this.success,
    required this.orderId,
    required this.deliveries,
    required this.isReplayed,
  });
}

class MobileCheckoutLedger {
  final Map<String, MobileCheckoutResult> _history = {};
  final Map<String, int> stockMap = {};

  MobileCheckoutResult processCheckout(
    MobileCheckoutRequest req, {
    MobileBundle? bundle,
    List<String>? digitalProductIds,
  }) {
    if (req.idempotencyKey.isEmpty) {
      throw ArgumentError('Idempotency key is required');
    }

    // Check replay by idempotency key
    if (_history.containsKey(req.idempotencyKey)) {
      final existing = _history[req.idempotencyKey]!;
      return MobileCheckoutResult(
        success: existing.success,
        orderId: existing.orderId,
        deliveries: existing.deliveries,
        isReplayed: true,
      );
    }

    // Check replay by payment intent id
    for (final res in _history.values) {
      if (res.orderId == 'ord-${req.paymentIntentId}') {
        return MobileCheckoutResult(
          success: res.success,
          orderId: res.orderId,
          deliveries: res.deliveries,
          isReplayed: true,
        );
      }
    }

    // Atomic bundle stock check and deduction
    if (bundle != null) {
      final check = checkMobileBundleStock(bundle, stockMap, 1);
      if (!check.isAvailable) {
        throw StateError(check.reason ?? 'Bundle out of stock');
      }
      for (final item in bundle.items) {
        final curr = stockMap[item.productId] ?? 0;
        stockMap[item.productId] = curr - item.quantity;
      }
    }

    final deliveries = (digitalProductIds ?? []).map((pId) => MobileDigitalDelivery(
      deliveryId: 'del-${req.paymentIntentId}-$pId',
      orderId: 'ord-${req.paymentIntentId}',
      productId: pId,
      downloadToken: 'tok-${req.paymentIntentId}-$pId',
      downloadUrl: 'https://dl.creativanta.example/assets/$pId.zip',
      status: DigitalDeliveryStatus.delivered,
    )).toList();

    final result = MobileCheckoutResult(
      success: true,
      orderId: 'ord-${req.paymentIntentId}',
      deliveries: deliveries,
      isReplayed: false,
    );

    _history[req.idempotencyKey] = result;
    return result;
  }
}

/// Acceptance Target 3: Buyer subscription cannot unlock SaaS privileges
class MobilePrivilegeCheck {
  final bool allowed;
  final String? denialReason;

  const MobilePrivilegeCheck({required this.allowed, this.denialReason});
}

const saasWorkspacePrivileges = {
  'store:manage',
  'product:manage',
  'workspace:admin',
  'workspace:read',
  'workspace:write',
  'workspace:delete',
  'billing:manage',
  'team:invite',
  'campaign:manage',
  'order:fulfill',
};

const buyerAllowedStorePerks = {
  'content:access',
  'discount:view',
  'store:browse',
  'order:view_own',
  'download:execute',
};

MobilePrivilegeCheck validateMobileBuyerPrivilegeBoundary(
  bool isBuyerSubscription,
  String requestedPermission,
) {
  if (isBuyerSubscription) {
    if (saasWorkspacePrivileges.contains(requestedPermission)) {
      return MobilePrivilegeCheck(
        allowed: false,
        denialReason: "Privilege escalation blocked: buyer subscription cannot unlock SaaS privilege '$requestedPermission'",
      );
    }
    if (buyerAllowedStorePerks.contains(requestedPermission)) {
      return const MobilePrivilegeCheck(allowed: true);
    }
    return MobilePrivilegeCheck(
      allowed: false,
      denialReason: "Unknown or disallowed buyer privilege: '$requestedPermission'",
    );
  }

  return const MobilePrivilegeCheck(allowed: true);
}
