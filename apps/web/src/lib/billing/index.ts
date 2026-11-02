import type { WorkspaceRole } from '$lib/auth';

export const PRICEBOOK_VERSION = '2026-10-30.v1';
export const DEFAULT_USD_PER_CREDIT_FLOOR = '0.015000';
export const DEFAULT_GROSS_MARGIN_FLOOR = '0.5000';
export const MAX_ACTIVE_RESERVATIONS = 5;

export type CreditSourceType = 'promotional' | 'subscription' | 'purchased' | 'overage';

export type ReservationStatus =
  | 'held'
  | 'in_flight'
  | 'reconciling'
  | 'committed'
  | 'released'
  | 'expired';

export type PlanTierCode = 'free' | 'starter' | 'pro' | 'business' | 'enterprise';

export interface PlanCatalogSpec {
  tierCode: PlanTierCode;
  displayName: string;
  monthlyPriceUsd: string;
  annualPriceUsd: string;
  monthlyPriceVnd: string;
  annualPriceVnd: string;
  monthlyCredits: string;
  rolloverPercentLabel: string;
  maxSeats: number;
  maxChannels: number;
  maxStorageGb: number;
  overageEligible: boolean;
  pauseEligible: boolean;
}

export const CANONICAL_PLANS: readonly PlanCatalogSpec[] = [
  {
    tierCode: 'free',
    displayName: 'Free',
    monthlyPriceUsd: '0',
    annualPriceUsd: '0',
    monthlyPriceVnd: '0',
    annualPriceVnd: '0',
    monthlyCredits: '50',
    rolloverPercentLabel: '0%',
    maxSeats: 1,
    maxChannels: 2,
    maxStorageGb: 5,
    overageEligible: false,
    pauseEligible: false
  },
  {
    tierCode: 'starter',
    displayName: 'Starter',
    monthlyPriceUsd: '20',
    annualPriceUsd: '200',
    monthlyPriceVnd: '499000',
    annualPriceVnd: '4990000',
    monthlyCredits: '500',
    rolloverPercentLabel: '0%',
    maxSeats: 1,
    maxChannels: 5,
    maxStorageGb: 50,
    overageEligible: false,
    pauseEligible: false
  },
  {
    tierCode: 'pro',
    displayName: 'Pro',
    monthlyPriceUsd: '60',
    annualPriceUsd: '600',
    monthlyPriceVnd: '1499000',
    annualPriceVnd: '14990000',
    monthlyCredits: '2000',
    rolloverPercentLabel: '20% (tối đa 1 kỳ)',
    maxSeats: 5,
    maxChannels: 15,
    maxStorageGb: 250,
    overageEligible: false,
    pauseEligible: false
  },
  {
    tierCode: 'business',
    displayName: 'Business',
    monthlyPriceUsd: '200',
    annualPriceUsd: '2000',
    monthlyPriceVnd: '4999000',
    annualPriceVnd: '49990000',
    monthlyCredits: '10000',
    rolloverPercentLabel: '20% (tối đa 1 kỳ)',
    maxSeats: 25,
    maxChannels: 50,
    maxStorageGb: 2000,
    overageEligible: true,
    pauseEligible: true
  },
  {
    tierCode: 'enterprise',
    displayName: 'Enterprise',
    monthlyPriceUsd: '1000',
    annualPriceUsd: '10000',
    monthlyPriceVnd: '24990000',
    annualPriceVnd: '249900000',
    monthlyCredits: '50000',
    rolloverPercentLabel: '20% (tối đa 1 kỳ)',
    maxSeats: 100,
    maxChannels: 200,
    maxStorageGb: 10000,
    overageEligible: true,
    pauseEligible: true
  }
] as const;

export interface CreditPackCatalogSpec {
  packCode: 'small' | 'medium' | 'large' | 'mega';
  displayName: string;
  credits: string;
  priceUsd: string;
  priceVnd: string;
  neverExpires: true;
}

export const CANONICAL_CREDIT_PACKS: readonly CreditPackCatalogSpec[] = [
  {
    packCode: 'small',
    displayName: 'Gói Small (100 Credits)',
    credits: '100',
    priceUsd: '5',
    priceVnd: '129000',
    neverExpires: true
  },
  {
    packCode: 'medium',
    displayName: 'Gói Medium (500 Credits)',
    credits: '500',
    priceUsd: '20',
    priceVnd: '499000',
    neverExpires: true
  },
  {
    packCode: 'large',
    displayName: 'Gói Large (2.000 Credits)',
    credits: '2000',
    priceUsd: '60',
    priceVnd: '1499000',
    neverExpires: true
  },
  {
    packCode: 'mega',
    displayName: 'Gói Mega (10.000 Credits)',
    credits: '10000',
    priceUsd: '200',
    priceVnd: '4999000',
    neverExpires: true
  }
] as const;

export interface AddonCatalogSpec {
  addonCode: string;
  displayName: string;
  monthlyPriceUsd: string;
  monthlyPriceVnd: string;
  eligibleTiers: readonly PlanTierCode[];
}

export const CANONICAL_ADDONS: readonly AddonCatalogSpec[] = [
  {
    addonCode: 'commerce_intelligence',
    displayName: 'Commerce Intelligence Add-on',
    monthlyPriceUsd: '39',
    monthlyPriceVnd: '999000',
    eligibleTiers: ['pro', 'business', 'enterprise']
  },
  {
    addonCode: 'continuity_pro',
    displayName: 'Continuity Pro Add-on',
    monthlyPriceUsd: '29',
    monthlyPriceVnd: '749000',
    eligibleTiers: ['pro', 'business', 'enterprise']
  },
  {
    addonCode: 'advanced_profit',
    displayName: 'Advanced Profit & Attribution Add-on',
    monthlyPriceUsd: '79',
    monthlyPriceVnd: '1999000',
    eligibleTiers: ['pro', 'business', 'enterprise']
  },
  {
    addonCode: 'workflow_agent_pro',
    displayName: 'Workflow & Agent Pro Add-on',
    monthlyPriceUsd: '59',
    monthlyPriceVnd: '1499000',
    eligibleTiers: ['pro', 'business', 'enterprise']
  }
] as const;

export const LOT_CONSUMPTION_PRIORITY: readonly CreditSourceType[] = [
  'promotional',
  'subscription',
  'purchased',
  'overage'
] as const;

const MICRO_SCALE = 1_000_000n;
const DECIMAL_RE = /^-?(?:0|[1-9][0-9]*)(?:\.[0-9]{1,6})?$/;

/**
 * Parses a canonical decimal string into exact BigInt micro-units (10^6) without floating point.
 */
export function parseExactMicros(raw: string): bigint {
  const trimmed = raw.trim();
  if (!DECIMAL_RE.test(trimmed)) {
    throw new Error(`Invalid canonical NUMERIC(18,6) decimal string: ${raw}`);
  }
  const negative = trimmed.startsWith('-');
  const unsigned = negative ? trimmed.slice(1) : trimmed;
  const [intPart, fracPart = ''] = unsigned.split('.');
  const paddedFrac = fracPart.padEnd(6, '0');
  const micros = BigInt(intPart + paddedFrac);
  return negative ? -micros : micros;
}

export function formatExactMicros(micros: bigint): string {
  if (micros === 0n) {
    return '0';
  }
  const neg = micros < 0n;
  const abs = neg ? -micros : micros;
  const intPart = abs / MICRO_SCALE;
  const fracPart = abs % MICRO_SCALE;
  if (fracPart === 0n) {
    return `${neg ? '-' : ''}${intPart.toString()}`;
  }
  const fracStr = fracPart.toString().padStart(6, '0').replace(/0+$/, '');
  return `${neg ? '-' : ''}${intPart.toString()}.${fracStr}`;
}

/**
 * Computes the canonical cost-based quote ceiling using exact BigInt arithmetic (never float):
 *   quoted_credits = ceil(cost_ceiling_usd / (usd_per_credit_floor * (1 - gross_margin_floor)))
 */
export function computeCostBasedQuoteCredits(
  costCeilingUsd: string,
  usdPerCreditFloor: string = DEFAULT_USD_PER_CREDIT_FLOOR,
  grossMarginFloor: string = DEFAULT_GROSS_MARGIN_FLOOR
): string {
  const costMicros = parseExactMicros(costCeilingUsd);
  const floorMicros = parseExactMicros(usdPerCreditFloor);
  const marginMicros = parseExactMicros(grossMarginFloor);
  if (costMicros <= 0n || floorMicros <= 0n || marginMicros < 0n || marginMicros >= MICRO_SCALE) {
    throw new Error('Invalid cost-based quote floor parameters');
  }
  const oneMinusMargin = MICRO_SCALE - marginMicros;
  const denom = floorMicros * oneMinusMargin;
  const num = costMicros * MICRO_SCALE;
  const ceilWholeCredits = (num + denom - 1n) / denom;
  return (ceilWholeCredits > 0n ? ceilWholeCredits : 1n).toString();
}

export interface ConcurrentHoldVerdict {
  allowed: boolean;
  errorCode: string | null;
  remainingAvailable: string;
  reason: string;
}

/**
 * Evaluates a credit reservation request against available balance and active hold count
 * (Acceptance Target #1).
 */
export function evaluateConcurrentReservationHold(
  availableCredits: string,
  requestedCredits: string,
  activeReservationCount: number
): ConcurrentHoldVerdict {
  if (activeReservationCount >= MAX_ACTIVE_RESERVATIONS) {
    return {
      allowed: false,
      errorCode: 'BILLING_LIMIT_002',
      remainingAvailable: availableCredits,
      reason: `Workspace đã đạt giới hạn tối đa ${MAX_ACTIVE_RESERVATIONS} lệnh giữ chỗ (reservations) đồng thời.`
    };
  }
  const avail = parseExactMicros(availableCredits);
  const req = parseExactMicros(requestedCredits);
  if (req <= 0n) {
    return {
      allowed: false,
      errorCode: 'AI_INVALID_001',
      remainingAvailable: availableCredits,
      reason: 'Số lượng credits giữ chỗ phải lớn hơn 0.'
    };
  }
  if (avail < req) {
    return {
      allowed: false,
      errorCode: 'BILLING_LIMIT_001',
      remainingAvailable: formatExactMicros(avail),
      reason: `Không đủ credits khả dụng (yêu cầu ${formatExactMicros(req)}, khả dụng ${formatExactMicros(avail)}). Khóa chống chi vượt mức (BILLING_LIMIT_001).`
    };
  }
  return {
    allowed: true,
    errorCode: null,
    remainingAvailable: formatExactMicros(avail - req),
    reason: `Đã giữ chỗ ${formatExactMicros(req)} credits nguyên tử (trạng thái held, TTL 30 phút).`
  };
}

export interface PaidRetryCommitVerdict {
  allowed: boolean;
  errorCode: string | null;
  chargedCredits: string;
  releasedRemainder: string;
  reason: string;
}

/**
 * Evaluates a commit with bounded retries/fallbacks against the confirmed quote ceiling
 * (Acceptance Target #3).
 */
export function evaluatePaidRetryCommit(
  confirmedQuotedCredits: string,
  measuredActualCredits: string,
  attemptNumber: number,
  maxAllowedAttempts: number
): PaidRetryCommitVerdict {
  if (attemptNumber > maxAllowedAttempts) {
    return {
      allowed: false,
      errorCode: 'BILLING_CONFLICT_002',
      chargedCredits: '0',
      releasedRemainder: '0',
      reason: `Lần thử thứ ${attemptNumber} vượt quá trần ${maxAllowedAttempts} lần thử trong báo giá đã xác nhận. Bắt buộc tạo báo giá mới và xin xác nhận người dùng (BILLING_CONFLICT_002).`
    };
  }
  const confirmed = parseExactMicros(confirmedQuotedCredits);
  const measured = parseExactMicros(measuredActualCredits);
  const charged = measured > confirmed ? confirmed : measured;
  const released = confirmed - charged;
  return {
    allowed: true,
    errorCode: null,
    chargedCredits: formatExactMicros(charged),
    releasedRemainder: formatExactMicros(released),
    reason:
      measured > confirmed
        ? `Chi phí thực tế (${formatExactMicros(measured)}) đã được khóa trần ở mức báo giá đã xác nhận (${formatExactMicros(confirmed)} credits).`
        : `Đã quyết toán ${formatExactMicros(charged)} credits theo đơn vị đo thực tế và hoàn trả ${formatExactMicros(released)} credits giữ dư.`
  };
}

export function evaluateBillingPermission(
  role: WorkspaceRole,
  action: 'view_balance' | 'read_billing' | 'manage_billing' | 'top_up_credits'
): { allowed: boolean; permissionKey: string; reason: string } {
  switch (action) {
    case 'view_balance':
      return {
        allowed: role !== 'external',
        permissionKey: 'credits:view_balance',
        reason:
          role !== 'external'
            ? `Vai trò ${role} được xem số dư credits và ước tính báo giá.`
            : 'Vai trò external không có quyền xem số dư credits workspace.'
      };
    case 'read_billing':
      return {
        allowed: role === 'owner' || role === 'admin' || role === 'manager',
        permissionKey: 'workspace:billing:read',
        reason:
          role === 'owner' || role === 'admin' || role === 'manager'
            ? `Vai trò ${role} được quyền xem tổng quan thanh toán, sổ cái và hóa đơn.`
            : `Vai trò ${role} không có quyền xem sổ cái tài chính và hóa đơn (yêu cầu Manager+).`
      };
    case 'manage_billing':
    case 'top_up_credits': {
      const key = action === 'manage_billing' ? 'workspace:billing:manage' : 'credits:top_up';
      return {
        allowed: role === 'owner',
        permissionKey: key,
        reason:
          role === 'owner'
            ? `Vai trò owner có toàn quyền ${key}.`
            : `Chỉ Chủ sở hữu (Owner) mới được phép đổi gói cước, hủy gói, cập nhật thẻ hoặc mua thêm credits (${key}).`
      };
    }
  }
}

/**
 * Enforces EC-M23-001: prevents removing the last payment method when on an active paid plan.
 */
export function evaluateLastPaymentMethodRemoval(
  planTier: PlanTierCode,
  subscriptionActive: boolean,
  paymentMethodCount: number
): { allowed: boolean; errorCode: string | null; reason: string } {
  if (planTier !== 'free' && subscriptionActive && paymentMethodCount <= 1) {
    return {
      allowed: false,
      errorCode: 'BILLING_CONFLICT_001',
      reason:
        'Không thể xóa phương thức thanh toán cuối cùng khi đang sử dụng gói trả phí hoạt động (EC-M23-001 / BILLING_CONFLICT_001).'
    };
  }
  return {
    allowed: true,
    errorCode: null,
    reason: 'Cho phép xóa phương thức thanh toán.'
  };
}
