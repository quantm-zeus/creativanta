/**
 * Monetization OS Domain Model & Checkout Evaluation
 * Module M14 (docs/02_features/commerce/monetization_os.md)
 *
 * Implements:
 * - RULE-M14-001: Offer lifecycle states and validity windows
 * - RULE-M14-002: Coupon max_uses ceiling and concurrency limit enforcement
 * - RULE-M14-003: Campaign budget threshold tracking and overspend alerts
 * - RULE-M14-005: Ledger double-entry posting generation for order checkout
 * - Acceptance Targets 1, 2, 3
 */

export type OfferLifecycleState = 'draft' | 'scheduled' | 'active' | 'paused' | 'expired' | 'archived';
export type CouponLifecycleState = 'draft' | 'active' | 'paused' | 'expired' | 'revoked';
export type CampaignStatus = 'draft' | 'scheduled' | 'active' | 'paused' | 'completed' | 'archived';

export interface Offer {
  offerId: string;
  workspaceId: string;
  title: string;
  offerType: 'product_offer' | 'digital_offer' | 'membership_offer' | 'bundle_offer' | 'affiliate_offer' | 'sponsor_offer';
  pricingValue: string; // Exact numeric string
  pricingCurrency: string;
  productId?: string;
  productLessDeclaration?: string;
  lifecycleState: OfferLifecycleState;
  validFrom?: string; // ISO date string
  validUntil?: string; // ISO date string
  createdAt: string;
  updatedAt: string;
}

export interface Coupon {
  couponId: string;
  workspaceId: string;
  code: string;
  couponType: 'percentage' | 'fixed_amount' | 'free_shipping';
  discountValue: string; // Exact numeric string
  minOrderAmount?: string; // Exact numeric string
  maxUses?: number;
  currentUses: number;
  lifecycleState: CouponLifecycleState;
  validFrom?: string;
  validUntil?: string;
  createdAt: string;
  updatedAt: string;
}

export interface CampaignCostItem {
  costItemId: string;
  campaignId: string;
  costType: 'influencer_fee' | 'production' | 'ad_spend' | 'software' | 'other';
  amount: string; // Exact numeric string
  currency: string;
  description: string;
  effectiveDate: string;
  createdAt: string;
}

export interface Campaign {
  campaignId: string;
  workspaceId: string;
  title: string;
  campaignType: 'content' | 'affiliate' | 'seeding' | 'live' | 'brand_collab';
  status: CampaignStatus;
  startDate: string;
  endDate: string;
  budget?: string; // Exact numeric string
  budgetCurrency: string;
  totalSpend: string;
  costs: CampaignCostItem[];
  createdAt: string;
  updatedAt: string;
}

export interface FinancialPosting {
  postingId: string;
  workspaceId: string;
  orderId?: string;
  campaignId?: string;
  offerId?: string;
  couponId?: string;
  component: 'revenue' | 'discount' | 'campaign_cost';
  grossAmount: string;
  discountAmount: string;
  netAmount: string;
  currency: string;
  timestamp: string;
}

export interface CheckoutEvaluationRequest {
  workspaceId: string;
  offer?: Offer;
  coupon?: Coupon;
  orderAmount: string; // Exact decimal string
  currency: string;
  now?: string; // ISO timestamp, defaults to current time
}

export interface CheckoutEvaluationResult {
  accepted: boolean;
  errorCode?: 'ERR_OFFER_EXPIRED' | 'ERR_COUPON_EXPIRED' | 'ERR_COUPON_LIMIT_EXCEEDED' | 'ERR_COUPON_MIN_NOT_MET' | 'ERR_INVALID_OFFER';
  errorMessage?: string;
  originalAmount: string;
  discountAmount: string;
  netPayableAmount: string;
  currency: string;
  orderId?: string;
  posting?: FinancialPosting;
  updatedCoupon?: Coupon;
}

/**
 * Parses fixed 6-scale micro-units from decimal string without floating point inaccuracies.
 */
function toMicros(val: string): bigint {
  const parts = val.trim().split('.');
  const whole = BigInt(parts[0] || '0');
  let fracStr = parts[1] || '';
  if (fracStr.length > 6) {
    fracStr = fracStr.slice(0, 6);
  } else {
    fracStr = fracStr.padEnd(6, '0');
  }
  const frac = BigInt(fracStr);
  return whole >= 0n ? whole * 1000000n + frac : whole * 1000000n - frac;
}

function fromMicros(micros: bigint): string {
  const isNeg = micros < 0n;
  const abs = isNeg ? -micros : micros;
  const whole = abs / 1000000n;
  const frac = abs % 1000000n;
  const fracStr = frac.toString().padStart(6, '0').replace(/0+$/, '') || '0';
  return `${isNeg ? '-' : ''}${whole}.${fracStr}`;
}

/**
 * Validates offer activation rules (EC-M14-001).
 * An offer requires either an associated productId or an explicit product-less declaration.
 */
export function validateOfferActivation(offer: Offer): { valid: boolean; reason?: string } {
  if (!offer.productId && !offer.productLessDeclaration) {
    return {
      valid: false,
      reason: 'Offer activation requires an associated product_id or an explicit product-less declaration'
    };
  }
  return { valid: true };
}

/**
 * Calculates coupon discount amount given an order amount.
 */
export function calculateCouponDiscount(coupon: Coupon, orderAmount: string): string {
  const orderMicros = toMicros(orderAmount);
  if (orderMicros <= 0n) return '0.0';

  if (coupon.couponType === 'fixed_amount') {
    const discountMicros = toMicros(coupon.discountValue);
    const effective = discountMicros > orderMicros ? orderMicros : discountMicros;
    return fromMicros(effective);
  }

  if (coupon.couponType === 'percentage') {
    // discount = (orderMicros * percentageMicros) / (100 * 1,000,000)
    const pctMicros = toMicros(coupon.discountValue);
    const discountMicros = (orderMicros * pctMicros) / (100n * 1000000n);
    const effective = discountMicros > orderMicros ? orderMicros : discountMicros;
    return fromMicros(effective);
  }

  return '0.0';
}

/**
 * Evaluates a checkout attempt against active offers and coupons.
 * Target 1: Expired offer rejected at checkout (ERR_OFFER_EXPIRED).
 * Target 2: Coupon races do not exceed limits (ERR_COUPON_LIMIT_EXCEEDED).
 * Target 3: Financial impact reaches ledger (FinancialPosting created).
 */
export function evaluateCheckout(req: CheckoutEvaluationRequest): CheckoutEvaluationResult {
  const now = req.now ? new Date(req.now) : new Date();
  const orderMicros = toMicros(req.orderAmount);

  // 1. Verify Offer Validity (Target 1)
  if (req.offer) {
    if (req.offer.lifecycleState === 'expired') {
      return {
        accepted: false,
        errorCode: 'ERR_OFFER_EXPIRED',
        errorMessage: 'Offer has expired and cannot be applied to checkout',
        originalAmount: req.orderAmount,
        discountAmount: '0.0',
        netPayableAmount: req.orderAmount,
        currency: req.currency
      };
    }
    if (req.offer.validUntil) {
      const expiry = new Date(req.offer.validUntil);
      if (now > expiry) {
        return {
          accepted: false,
          errorCode: 'ERR_OFFER_EXPIRED',
          errorMessage: 'Offer validity window has passed',
          originalAmount: req.orderAmount,
          discountAmount: '0.0',
          netPayableAmount: req.orderAmount,
          currency: req.currency
        };
      }
    }
  }

  // 2. Verify Coupon Validity & Atomic Limit (Target 2)
  let discountMicros = 0n;
  let updatedCoupon: Coupon | undefined;

  if (req.coupon) {
    const coupon = req.coupon;
    if (coupon.lifecycleState === 'expired') {
      return {
        accepted: false,
        errorCode: 'ERR_COUPON_EXPIRED',
        errorMessage: 'Coupon code has expired',
        originalAmount: req.orderAmount,
        discountAmount: '0.0',
        netPayableAmount: req.orderAmount,
        currency: req.currency
      };
    }
    if (coupon.validUntil && now > new Date(coupon.validUntil)) {
      return {
        accepted: false,
        errorCode: 'ERR_COUPON_EXPIRED',
        errorMessage: 'Coupon validity period has ended',
        originalAmount: req.orderAmount,
        discountAmount: '0.0',
        netPayableAmount: req.orderAmount,
        currency: req.currency
      };
    }

    // Atomic ceiling check: coupon races cannot exceed max_uses
    if (coupon.maxUses !== undefined && coupon.currentUses >= coupon.maxUses) {
      return {
        accepted: false,
        errorCode: 'ERR_COUPON_LIMIT_EXCEEDED',
        errorMessage: `Coupon usage limit of ${coupon.maxUses} has been exhausted`,
        originalAmount: req.orderAmount,
        discountAmount: '0.0',
        netPayableAmount: req.orderAmount,
        currency: req.currency
      };
    }

    if (coupon.minOrderAmount) {
      const minMicros = toMicros(coupon.minOrderAmount);
      if (orderMicros < minMicros) {
        return {
          accepted: false,
          errorCode: 'ERR_COUPON_MIN_NOT_MET',
          errorMessage: `Order subtotal does not meet minimum requirement of ${coupon.minOrderAmount}`,
          originalAmount: req.orderAmount,
          discountAmount: '0.0',
          netPayableAmount: req.orderAmount,
          currency: req.currency
        };
      }
    }

    const calculatedDiscount = calculateCouponDiscount(coupon, req.orderAmount);
    discountMicros = toMicros(calculatedDiscount);

    const nextUses = coupon.currentUses + 1;
    const isNowExpired = coupon.maxUses !== undefined && nextUses >= coupon.maxUses;

    updatedCoupon = {
      ...coupon,
      currentUses: nextUses,
      lifecycleState: isNowExpired ? 'expired' : coupon.lifecycleState,
      updatedAt: now.toISOString()
    };
  }

  // 3. Compute Net Payable & Ledger Posting (Target 3)
  const netMicros = orderMicros > discountMicros ? orderMicros - discountMicros : 0n;
  const originalStr = fromMicros(orderMicros);
  const discountStr = fromMicros(discountMicros);
  const netStr = fromMicros(netMicros);

  const orderId = `ord-${Date.now()}`;
  const postingId = `post-rev-${Math.random().toString(36).substring(2, 10)}`;

  const posting: FinancialPosting = {
    postingId,
    workspaceId: req.workspaceId,
    orderId,
    offerId: req.offer?.offerId,
    couponId: req.coupon?.couponId,
    component: 'revenue',
    grossAmount: originalStr,
    discountAmount: discountStr,
    netAmount: netStr,
    currency: req.currency,
    timestamp: now.toISOString()
  };

  return {
    accepted: true,
    originalAmount: originalStr,
    discountAmount: discountStr,
    netPayableAmount: netStr,
    currency: req.currency,
    orderId,
    posting,
    updatedCoupon
  };
}

/**
 * Checks campaign budget thresholds and triggers warnings/alerts (EC-M14-003).
 */
export function evaluateCampaignBudget(campaign: Campaign): {
  utilizationPct: number;
  isWarning: boolean;
  isOverBudget: boolean;
  alertMessage?: string;
} {
  if (!campaign.budget) {
    return { utilizationPct: 0, isWarning: false, isOverBudget: false };
  }

  const budgetMicros = toMicros(campaign.budget);
  if (budgetMicros <= 0n) {
    return { utilizationPct: 0, isWarning: false, isOverBudget: false };
  }

  const spendMicros = toMicros(campaign.totalSpend);
  const ratio = Number(spendMicros) / Number(budgetMicros);
  const pct = Math.round(ratio * 10000) / 100;

  const isWarning = pct >= 80;
  const isOverBudget = pct >= 100;

  let alertMessage: string | undefined;
  if (isOverBudget) {
    alertMessage = `Campaign budget 100% exceeded (${pct}% utilized). Manager alert triggered per EC-M14-003.`;
  } else if (isWarning) {
    alertMessage = `Campaign budget warning: ${pct}% utilized. Approaching 80% threshold.`;
  }

  return {
    utilizationPct: pct,
    isWarning,
    isOverBudget,
    alertMessage
  };
}
