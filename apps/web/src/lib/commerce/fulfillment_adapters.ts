/**
 * Fulfillment, Refund, Physical Returns, and Finance Adapters (M13 & M19)
 * Canonical Sources:
 * - docs/02_features/commerce/product_hub.md (M13)
 * - docs/02_features/finance/operating_ledger.md (M19)
 * - docs/04_contracts/inventory_computation_contract.md
 * - docs/04_contracts/financial_computation_contract.md
 * - docs/04_contracts/connector_specs.md
 */

export type CommercePlatform = 'tiktok' | 'shopee' | 'lazada' | 'stripe';

export type OrderLifecycleState =
  | 'created'
  | 'confirmed'
  | 'fulfilled'
  | 'completed'
  | 'partially_refunded'
  | 'refunded'
  | 'returned'
  | 'cancelled';

export type ReturnLifecycleState =
  | 'initiated'
  | 'approved'
  | 'shipped_back'
  | 'received'
  | 'inspected'
  | 'closed'
  | 'rejected';

export type RefundLifecycleState =
  | 'requested'
  | 'approved'
  | 'processing'
  | 'completed'
  | 'rejected'
  | 'failed'
  | 'cancelled';

export type ReconciliationState =
  | 'awaiting_evidence'
  | 'imported_only'
  | 'inferred_pending_confirmation'
  | 'partially_reconciled'
  | 'fully_reconciled'
  | 'conflict_detected'
  | 'manually_overridden';

export interface FeeBreakdown {
  platformFee: string;
  paymentFee: string;
  shippingFee: string;
  affiliateCommission: string;
  vatAmount: string;
  otherFees?: Array<{ name: string; amount: string }>;
}

export interface ReturnItem {
  sku: string;
  quantity: number;
  reason?: string;
}

export interface OrderItem {
  sku: string;
  name: string;
  quantity: number;
  unitPrice: string;
  unitCogs?: string;
}

export interface ReturnRecord {
  returnId: string;
  orderId: string;
  items: ReturnItem[];
  lifecycleState: ReturnLifecycleState;
  trackingNumber?: string;
  createdAt: string;
}

export interface RefundRecord {
  refundId: string;
  orderId: string;
  amount: string;
  currency: string;
  lifecycleState: RefundLifecycleState;
  reason: string;
  createdAt: string;
}

export interface StockDiscrepancy {
  skuId: string;
  locationId: string;
  onHand: number;
  movementSum: number;
  discrepancy: number;
  status: 'balanced' | 'drift_detected';
}

export interface PlatformCapabilityStatus {
  platform: CommercePlatform;
  isNative: boolean;
  status: 'verified' | 'degraded' | 'manual' | 'unsupported';
  reason: string;
}

// Decimal arithmetic helper: string representation to BigInt scaled by 1,000,000 (micros)
export function parseExactMicros(val: string): bigint {
  if (!val || val.trim() === '') return 0n;
  const clean = val.trim();
  const isNegative = clean.startsWith('-');
  const unsigned = isNegative ? clean.slice(1) : clean;

  const parts = unsigned.split('.');
  const wholePart = BigInt(parts[0] || '0');
  let fracPartStr = (parts[1] || '').slice(0, 6);
  while (fracPartStr.length < 6) {
    fracPartStr += '0';
  }
  const fracPart = BigInt(fracPartStr);
  const totalMicros = wholePart * 1000000n + fracPart;
  return isNegative ? -totalMicros : totalMicros;
}

export function formatExactMicros(micros: bigint): string {
  const isNegative = micros < 0n;
  const abs = isNegative ? -micros : micros;
  const whole = abs / 1000000n;
  const frac = abs % 1000000n;
  const prefix = isNegative ? '-' : '';
  if (frac === 0n) {
    return prefix + whole.toString();
  }
  let fracStr = frac.toString().padStart(6, '0');
  fracStr = fracStr.replace(/0+$/, '');
  return `${prefix}${whole}.${fracStr}`;
}

/**
 * Validates cumulative return quantity bounds (RULE-M13-006, inventory contract §3):
 * Cumulative returned quantity across non-rejected returns must NOT exceed sold quantity for each SKU.
 */
export function validateReturnBounds(
  orderItems: OrderItem[],
  priorReturns: ReturnRecord[],
  newItems: ReturnItem[]
): { valid: boolean; error?: string } {
  const orderedQty = new Map<string, number>();
  for (const it of orderItems) {
    orderedQty.set(it.sku, (orderedQty.get(it.sku) || 0) + it.quantity);
  }

  const returnedQty = new Map<string, number>();
  for (const pr of priorReturns) {
    if (pr.lifecycleState !== 'rejected') {
      for (const it of pr.items) {
        returnedQty.set(it.sku, (returnedQty.get(it.sku) || 0) + it.quantity);
      }
    }
  }

  for (const it of newItems) {
    if (it.quantity <= 0) {
      return { valid: false, error: `Invalid return quantity: ${it.quantity} for sku ${it.sku}` };
    }
    const maxAllowed = orderedQty.get(it.sku) || 0;
    const currentReturned = returnedQty.get(it.sku) || 0;
    if (currentReturned + it.quantity > maxAllowed) {
      return {
        valid: false,
        error: `Cumulative return (${currentReturned + it.quantity}) exceeds ordered quantity (${maxAllowed}) for sku ${it.sku}`
      };
    }
  }

  return { valid: true };
}

/**
 * Validates cumulative refund bounds (financial computation contract §1):
 * Cumulative refund cannot exceed captured order amount.
 */
export function validateRefundBounds(
  orderAmount: string,
  priorRefunds: RefundRecord[],
  newRefundAmount: string
): { valid: boolean; remainingRefundable: string; error?: string } {
  const orderMicros = parseExactMicros(orderAmount);
  let refundedMicros = 0n;

  for (const r of priorRefunds) {
    if (r.lifecycleState === 'approved' || r.lifecycleState === 'completed') {
      refundedMicros += parseExactMicros(r.amount);
    }
  }

  const remainingMicros = orderMicros - refundedMicros;
  const newMicros = parseExactMicros(newRefundAmount);

  if (newMicros <= 0n) {
    return {
      valid: false,
      remainingRefundable: formatExactMicros(remainingMicros),
      error: 'Refund amount must be strictly positive'
    };
  }

  if (newMicros > remainingMicros) {
    return {
      valid: false,
      remainingRefundable: formatExactMicros(remainingMicros),
      error: `Requested refund (${newRefundAmount}) exceeds remaining refundable balance (${formatExactMicros(remainingMicros)})`
    };
  }

  return {
    valid: true,
    remainingRefundable: formatExactMicros(remainingMicros - newMicros)
  };
}

/**
 * Evaluates order state transition based on cumulative refund amount.
 */
export function computeOrderStateAfterRefund(
  orderAmount: string,
  cumulativeRefundAmount: string
): OrderLifecycleState {
  const orderMicros = parseExactMicros(orderAmount);
  const refundMicros = parseExactMicros(cumulativeRefundAmount);

  if (refundMicros >= orderMicros) {
    return 'refunded';
  }
  if (refundMicros > 0n) {
    return 'partially_refunded';
  }
  return 'completed';
}

/**
 * Platform connector capability assessment (connector specs §2 & §6).
 * Never returns empty success for unsupported features.
 */
export function evaluatePlatformCapability(
  platform: CommercePlatform,
  hasVerifiedAccess: boolean
): PlatformCapabilityStatus {
  if (hasVerifiedAccess) {
    return {
      platform,
      isNative: true,
      status: 'verified',
      reason: 'Direct API partner integration active and authorized'
    };
  }
  return {
    platform,
    isNative: false,
    status: 'manual',
    reason: 'Provider unverified; fallback to authorized CSV and manual export under connector specs §2'
  };
}

/**
 * Stock polling delta calculation (I10).
 * Prevents redundant movements on duplicate polls.
 */
export function computeStockDelta(
  currentOnHand: number,
  reportedPlatformStock: number
): { delta: number; isNoOp: boolean } {
  const delta = reportedPlatformStock - currentOnHand;
  return {
    delta,
    isNoOp: delta === 0
  };
}

/**
 * Stock & Ledger reconciliation check (I09).
 */
export function reconcileStockBalances(
  onHand: number,
  movementSum: number
): StockDiscrepancy {
  const discrepancy = movementSum - onHand;
  return {
    skuId: '',
    locationId: '',
    onHand,
    movementSum,
    discrepancy,
    status: discrepancy === 0 ? 'balanced' : 'drift_detected'
  };
}

/**
 * Profit calculation preserving proof (RULE-M19-004, F01-F09):
 * Net Profit = Revenue - Platform Fees - Shipping - Affiliate Commissions - COGS - Ads - AI Credits - Seeding - Refunds - Other
 */
export function calculateNetProfit(
  grossRevenue: string,
  fees: FeeBreakdown,
  cogs: string,
  refundDeductions: string = '0',
  aiCredits: string = '0',
  adsSpend: string = '0',
  seedingCosts: string = '0',
  otherCosts: string = '0'
): string {
  const rev = parseExactMicros(grossRevenue);
  const pf = parseExactMicros(fees.platformFee);
  const pay = parseExactMicros(fees.paymentFee);
  const ship = parseExactMicros(fees.shippingFee);
  const comm = parseExactMicros(fees.affiliateCommission);
  const cg = parseExactMicros(cogs);
  const ref = parseExactMicros(refundDeductions);
  const ai = parseExactMicros(aiCredits);
  const ads = parseExactMicros(adsSpend);
  const seed = parseExactMicros(seedingCosts);
  const oth = parseExactMicros(otherCosts);

  const totalDeductions = pf + pay + ship + comm + cg + ref + ai + ads + seed + oth;
  const net = rev - totalDeductions;
  return formatExactMicros(net);
}
