/**
 * Creator Store, Digital Delivery, Bundles & Memberships Domain Model
 * Module M15 (docs/02_features/commerce/creator_store.md) & M13 (docs/02_features/commerce/product_hub.md)
 *
 * Implements:
 * - RULE-M15-001: Store page lifecycle states and custom domain / slug uniqueness
 * - RULE-M15-002: Membership plan creation and MRR tracking
 * - RULE-M15-003: Bundle stock atomic verification and component inventory check
 * - RULE-M15-004: Payment replay idempotency and digital delivery token deduplication
 * - RULE-M15-005: Buyer privilege isolation barrier (no SaaS workspace permissions)
 * - Acceptance Targets 1, 2, 3
 */

export type StorePageStatus = 'draft' | 'published' | 'hidden' | 'retired';
export type MembershipPlanStatus = 'draft' | 'active' | 'paused' | 'retired';
export type MembershipSubscriptionStatus = 'active' | 'cancelled' | 'expired';
export type DigitalDeliveryStatus = 'pending' | 'delivered' | 'failed' | 'expired';

export interface StoreTheme {
  themeId: string;
  name: string;
  primaryColor: string;
  fontFamily: string;
  borderRadius: string;
  isDefault: boolean;
}

export interface StorePage {
  storePageId: string;
  workspaceId: string;
  title: string;
  slug: string;
  description: string;
  layoutJson: {
    sections: Array<{
      id: string;
      type: 'hero' | 'featured_products' | 'bundles' | 'memberships' | 'testimonials' | 'faq' | 'footer';
      title?: string;
      config?: Record<string, unknown>;
    }>;
  };
  themeOverridesJson: Record<string, unknown>;
  status: StorePageStatus;
  customDomain?: string;
  seoConfigJson: {
    metaTitle?: string;
    metaDescription?: string;
    ogImage?: string;
  };
  widgetConfigJson: {
    floatingBuyButton?: boolean;
    chatWidget?: boolean;
    announcementBar?: string;
  };
  createdAt: string;
  updatedAt: string;
}

export interface PageStats {
  storePageId: string;
  views: number;
  orders: number;
  conversionRate: number;
  revenue: string; // Exact decimal string
  currency: string;
}

export interface MembershipBenefit {
  title: string;
  description?: string;
  icon?: string;
}

export interface MembershipPlan {
  planId: string;
  workspaceId: string;
  title: string;
  description: string;
  price: string; // Exact decimal string NUMERIC(18,6)
  currency: string;
  billingInterval: 'monthly' | 'quarterly' | 'yearly';
  benefitsJson: MembershipBenefit[];
  entitlementConfigJson: {
    exclusiveContent?: boolean;
    discordRole?: string;
    earlyAccessHours?: number;
    discountPercent?: number;
  };
  status: MembershipPlanStatus;
  subscriberCount: number;
  createdAt: string;
  updatedAt: string;
}

export interface MembershipSubscription {
  membershipId: string;
  workspaceId: string;
  planId: string;
  customerEntityId: string;
  status: MembershipSubscriptionStatus;
  providerSubscriptionId: string;
  currentPeriodStart: string;
  currentPeriodEnd: string;
  entitlementSnapshotJson: Record<string, unknown>;
  createdAt: string;
  updatedAt: string;
}

export interface BundleItem {
  bundleId?: string;
  productId: string;
  quantity: number;
  productTitle: string;
  availableStock?: number;
}

export interface Bundle {
  bundleId: string;
  workspaceId: string;
  title: string;
  offerId?: string;
  bundlePrice: string; // Exact decimal string NUMERIC(18,6)
  currency: string;
  isActive: boolean;
  items: BundleItem[];
  createdAt: string;
  updatedAt: string;
}

export interface DigitalDelivery {
  deliveryId: string;
  workspaceId: string;
  orderId: string;
  productId: string;
  customerEntityId: string;
  downloadToken: string;
  downloadUrl: string;
  status: DigitalDeliveryStatus;
  downloadCount: number;
  maxDownloads: number;
  expiresAt?: string;
  createdAt: string;
}

export interface MRRSummary {
  currentMrr: string; // Exact decimal string
  currency: string;
  activeSubscribers: number;
  churnRate: number;
  averageLtv: string; // Exact decimal string
  trialConversionRate: number;
}

export interface CheckoutRequest {
  workspaceId: string;
  customerEntityId: string;
  idempotencyKey: string;
  paymentIntentId: string;
  offerId?: string;
  bundleId?: string;
  membershipPlanId?: string;
  productIds?: string[];
  orderAmount: string;
  currency: string;
}

export interface CheckoutResult {
  success: boolean;
  orderId: string;
  status: string;
  deliveries: DigitalDelivery[];
  subscription?: MembershipSubscription;
  isReplayed: boolean;
}

/**
 * Exact Decimal Operations without floating point imprecision
 */
export function parseExactDecimal(val: string): bigint {
  const trimmed = val.trim();
  if (!trimmed || isNaN(Number(trimmed))) {
    throw new Error(`Invalid decimal: ${val}`);
  }
  const parts = trimmed.split('.');
  const intPart = BigInt(parts[0] || '0');
  const fracPart = parts[1] || '';
  if (fracPart.length > 6) {
    throw new Error(`Scale exceeds 6 digits in ${val}`);
  }
  const paddedFrac = fracPart.padEnd(6, '0');
  const micros = intPart * 1_000_000n + BigInt(paddedFrac);
  return micros;
}

export function formatExactDecimal(micros: bigint): string {
  const isNeg = micros < 0n;
  const abs = isNeg ? -micros : micros;
  const intPart = abs / 1_000_000n;
  const fracPart = abs % 1_000_000n;
  const fracStr = fracPart.toString().padStart(6, '0').replace(/0+$/, '');
  const prefix = isNeg ? '-' : '';
  return fracStr.length > 0 ? `${prefix}${intPart}.${fracStr}` : `${prefix}${intPart}`;
}

export function addExactDecimals(a: string, b: string): string {
  return formatExactDecimal(parseExactDecimal(a) + parseExactDecimal(b));
}

export function mulExactDecimalByInt(dec: string, count: number): string {
  if (count < 0) throw new Error('Count cannot be negative');
  return formatExactDecimal(parseExactDecimal(dec) * BigInt(count));
}

export function cmpExactDecimals(a: string, b: string): number {
  const ma = parseExactDecimal(a);
  const mb = parseExactDecimal(b);
  if (ma < mb) return -1;
  if (ma > mb) return 1;
  return 0;
}

/**
 * Acceptance Target 1: Bundle stock atomic
 * Verifies that bundle component stock is checked atomically.
 * If ANY component is missing stock or stock < (requestedQty * item.quantity),
 * the bundle is marked unavailable with an explicit explanation and 0 reservations leaked.
 */
export interface BundleStockCheckResult {
  isAvailable: boolean;
  reason?: string;
  stockBreakdown: Array<{
    productId: string;
    productTitle: string;
    requiredPerUnit: number;
    totalRequired: number;
    availableStock: number;
    isSufficient: boolean;
  }>;
  maxPossibleUnits: number;
}

export function checkBundleStockAtomic(
  bundle: Bundle,
  inventoryStock: Record<string, number>,
  requestedQuantity = 1
): BundleStockCheckResult {
  if (requestedQuantity <= 0) {
    return {
      isAvailable: false,
      reason: 'Requested quantity must be positive',
      stockBreakdown: [],
      maxPossibleUnits: 0,
    };
  }

  let isAllAvailable = true;
  let missingReason = '';
  let minPossibleUnits = Number.MAX_SAFE_INTEGER;

  const stockBreakdown = bundle.items.map((item) => {
    const available = inventoryStock[item.productId] ?? 0;
    const totalRequired = item.quantity * requestedQuantity;
    const isSufficient = available >= totalRequired;

    const possibleForThisItem = item.quantity > 0 ? Math.floor(available / item.quantity) : 0;
    if (possibleForThisItem < minPossibleUnits) {
      minPossibleUnits = possibleForThisItem;
    }

    if (!isSufficient) {
      isAllAvailable = false;
      if (!missingReason) {
        missingReason = `Component '${item.productTitle}' has insufficient stock (available: ${available}, required: ${totalRequired})`;
      }
    }

    return {
      productId: item.productId,
      productTitle: item.productTitle,
      requiredPerUnit: item.quantity,
      totalRequired,
      availableStock: available,
      isSufficient,
    };
  });

  const maxUnits = bundle.items.length > 0 ? (minPossibleUnits === Number.MAX_SAFE_INTEGER ? 0 : minPossibleUnits) : 0;

  return {
    isAvailable: isAllAvailable,
    reason: isAllAvailable ? undefined : missingReason,
    stockBreakdown,
    maxPossibleUnits: maxUnits,
  };
}

/**
 * Acceptance Target 2: Payment replay no duplicate delivery
 * Idempotency registry for payments and checkout.
 */
export class MemoryCheckoutLedger {
  private records = new Map<string, CheckoutResult>();
  private stockMap = new Map<string, number>();

  setStock(productId: string, stock: number) {
    this.stockMap.set(productId, stock);
  }

  getStock(productId: string): number {
    return this.stockMap.get(productId) ?? 0;
  }

  processCheckout(
    req: CheckoutRequest,
    bundle?: Bundle,
    digitalAssets?: Array<{ productId: string; assetUrl: string }>
  ): CheckoutResult {
    if (!req.idempotencyKey) {
      throw new Error('Idempotency key is required');
    }

    // Check replay
    const existing = this.records.get(req.idempotencyKey);
    if (existing) {
      return {
        ...existing,
        isReplayed: true,
      };
    }

    // Check payment intent replay
    for (const record of this.records.values()) {
      if (record.orderId === `ord-${req.paymentIntentId}`) {
        return {
          ...record,
          isReplayed: true,
        };
      }
    }

    // If bundle checkout, check atomic stock
    if (bundle) {
      const stockObj: Record<string, number> = {};
      for (const item of bundle.items) {
        stockObj[item.productId] = this.getStock(item.productId);
      }
      const check = checkBundleStockAtomic(bundle, stockObj, 1);
      if (!check.isAvailable) {
        throw new Error(check.reason || 'Bundle component out of stock');
      }

      // Deduct stock atomically
      for (const item of bundle.items) {
        const curr = this.getStock(item.productId);
        this.stockMap.set(item.productId, curr - item.quantity);
      }
    }

    // Create digital deliveries if any
    const deliveries: DigitalDelivery[] = (digitalAssets ?? []).map((asset, idx) => ({
      deliveryId: `del-${req.paymentIntentId}-${idx + 1}`,
      workspaceId: req.workspaceId,
      orderId: `ord-${req.paymentIntentId}`,
      productId: asset.productId,
      customerEntityId: req.customerEntityId,
      downloadToken: `tok-${req.paymentIntentId}-${idx + 1}`,
      downloadUrl: asset.assetUrl,
      status: 'delivered',
      downloadCount: 0,
      maxDownloads: 5,
      createdAt: new Date().toISOString(),
    }));

    const result: CheckoutResult = {
      success: true,
      orderId: `ord-${req.paymentIntentId}`,
      status: 'completed',
      deliveries,
      isReplayed: false,
    };

    this.records.set(req.idempotencyKey, result);
    return result;
  }
}

/**
 * Acceptance Target 3: Buyer subscription cannot unlock SaaS privileges
 * Creator store buyer memberships (membership_subscriptions) grant audience content/discounts/DM perks,
 * but strictly CANNOT grant SaaS workspace permissions.
 */
const SAAS_WORKSPACE_PERMISSIONS = new Set([
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
]);

const ALLOWED_BUYER_STORE_PERMISSIONS = new Set([
  'content:access',
  'discount:view',
  'store:browse',
  'order:view_own',
  'download:execute',
]);

export function validateBuyerPrivilegeBoundary(
  isBuyerSubscription: boolean,
  targetPermission: string
): { allowed: boolean; reason?: string } {
  if (isBuyerSubscription) {
    if (SAAS_WORKSPACE_PERMISSIONS.has(targetPermission)) {
      return {
        allowed: false,
        reason: `Privilege escalation blocked: buyer store subscription cannot unlock SaaS privilege '${targetPermission}'`,
      };
    }
    if (ALLOWED_BUYER_STORE_PERMISSIONS.has(targetPermission)) {
      return { allowed: true };
    }
    return {
      allowed: false,
      reason: `Unknown or disallowed buyer permission: '${targetPermission}'`,
    };
  }

  // Not a buyer subscription (e.g. Workspace member role)
  return { allowed: true };
}
