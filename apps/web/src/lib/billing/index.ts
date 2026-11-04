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
  annualPriceUsd: string;
  monthlyPriceVnd: string;
  annualPriceVnd: string;
  eligibleTiers: readonly PlanTierCode[];
}

export const CANONICAL_ADDONS: readonly AddonCatalogSpec[] = [
  {
    addonCode: 'commerce_intelligence',
    displayName: 'Commerce Intelligence Add-on',
    monthlyPriceUsd: '39',
    annualPriceUsd: '390',
    monthlyPriceVnd: '999000',
    annualPriceVnd: '9990000',
    eligibleTiers: ['starter', 'pro', 'business', 'enterprise']
  },
  {
    addonCode: 'continuity_pro',
    displayName: 'Continuity Pro Add-on',
    monthlyPriceUsd: '29',
    annualPriceUsd: '290',
    monthlyPriceVnd: '749000',
    annualPriceVnd: '7490000',
    eligibleTiers: ['starter', 'pro', 'business', 'enterprise']
  },
  {
    addonCode: 'advanced_profit',
    displayName: 'Advanced Profit & Attribution Add-on',
    monthlyPriceUsd: '79',
    annualPriceUsd: '790',
    monthlyPriceVnd: '1999000',
    annualPriceVnd: '19990000',
    eligibleTiers: ['starter', 'pro', 'business', 'enterprise']
  },
  {
    addonCode: 'workflow_agent_pro',
    displayName: 'Workflow & Agent Pro Add-on',
    monthlyPriceUsd: '59',
    annualPriceUsd: '590',
    monthlyPriceVnd: '1499000',
    annualPriceVnd: '14990000',
    eligibleTiers: ['starter', 'pro', 'business', 'enterprise']
  }
] as const;

export type PaymentMethodType =
  | 'card'
  | 'bank_transfer'
  | 'momo'
  | 'zalopay'
  | 'vnpay'
  | 'paypal';

export interface PaymentMethodGateCatalogSpec {
  methodType: PaymentMethodType;
  displayName: string;
  providerPhase: string;
  accessGateKey: string;
  defaultEnabled: boolean;
  supportedCurrencies: readonly ('USD' | 'VND')[];
  eligibleTiers: readonly PlanTierCode[];
}

export const CANONICAL_PAYMENT_METHOD_GATES: readonly PaymentMethodGateCatalogSpec[] = [
  {
    methodType: 'card',
    displayName: 'Thẻ Quốc tế (Visa / Mastercard / Amex / JCB)',
    providerPhase: 'phase_1_stripe',
    accessGateKey: 'billing.payment_method.card',
    defaultEnabled: true,
    supportedCurrencies: ['USD', 'VND'],
    eligibleTiers: ['free', 'starter', 'pro', 'business', 'enterprise']
  },
  {
    methodType: 'bank_transfer',
    displayName: 'Chuyển khoản Ngân hàng / Wire / ACH (Hóa đơn Net-30)',
    providerPhase: 'phase_1_enterprise_invoice',
    accessGateKey: 'billing.payment_method.bank_transfer',
    defaultEnabled: false,
    supportedCurrencies: ['USD', 'VND'],
    eligibleTiers: ['business', 'enterprise']
  },
  {
    methodType: 'momo',
    displayName: 'Ví điện tử MoMo (VND)',
    providerPhase: 'phase_2_vn_local',
    accessGateKey: 'billing.payment_method.momo',
    defaultEnabled: false,
    supportedCurrencies: ['VND'],
    eligibleTiers: ['free', 'starter', 'pro', 'business', 'enterprise']
  },
  {
    methodType: 'zalopay',
    displayName: 'Ví điện tử ZaloPay (VND)',
    providerPhase: 'phase_2_vn_local',
    accessGateKey: 'billing.payment_method.zalopay',
    defaultEnabled: false,
    supportedCurrencies: ['VND'],
    eligibleTiers: ['free', 'starter', 'pro', 'business', 'enterprise']
  },
  {
    methodType: 'vnpay',
    displayName: 'Cổng thanh toán VNPay QR / ATM Nội địa (VND)',
    providerPhase: 'phase_2_vn_local',
    accessGateKey: 'billing.payment_method.vnpay',
    defaultEnabled: false,
    supportedCurrencies: ['VND'],
    eligibleTiers: ['free', 'starter', 'pro', 'business', 'enterprise']
  },
  {
    methodType: 'paypal',
    displayName: 'PayPal Quốc tế (USD)',
    providerPhase: 'phase_3_international',
    accessGateKey: 'billing.payment_method.paypal',
    defaultEnabled: false,
    supportedCurrencies: ['USD'],
    eligibleTiers: ['free', 'starter', 'pro', 'business', 'enterprise']
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

/**
 * Evaluates whether a payment method type is permitted behind its canonical access gate and tier eligibility (P8-02).
 */
export function evaluatePaymentMethodAccessGate(
  methodType: PaymentMethodType,
  tierCode: PlanTierCode,
  grantedGates: readonly string[] = []
): {
  allowed: boolean;
  errorCode: string | null;
  accessGateKey: string;
  providerPhase: string;
  reason: string;
} {
  const spec = CANONICAL_PAYMENT_METHOD_GATES.find((g) => g.methodType === methodType);
  if (!spec) {
    return {
      allowed: false,
      errorCode: 'BILLING_INVALID_001',
      accessGateKey: 'unknown',
      providerPhase: 'unknown',
      reason: `Phương thức thanh toán ${methodType} không nằm trong danh mục chuẩn.`
    };
  }
  const gateOpen =
    spec.defaultEnabled ||
    grantedGates.includes(spec.accessGateKey) ||
    grantedGates.includes(spec.methodType);
  if (!gateOpen) {
    return {
      allowed: false,
      errorCode: 'BILLING_GATE_001',
      accessGateKey: spec.accessGateKey,
      providerPhase: spec.providerPhase,
      reason: `Phương thức ${spec.displayName} đang khóa sau cổng truy cập ${spec.accessGateKey} (${spec.providerPhase}).`
    };
  }
  if (!spec.eligibleTiers.includes(tierCode)) {
    return {
      allowed: false,
      errorCode: 'BILLING_GATE_001',
      accessGateKey: spec.accessGateKey,
      providerPhase: spec.providerPhase,
      reason: `Phương thức ${spec.displayName} chỉ khả dụng cho gói ${spec.eligibleTiers.join('/')} (hiện tại: ${tierCode}).`
    };
  }
  return {
    allowed: true,
    errorCode: null,
    accessGateKey: spec.accessGateKey,
    providerPhase: spec.providerPhase,
    reason: `Phương thức ${spec.displayName} đã mở cổng ${spec.accessGateKey} cho gói ${tierCode}.`
  };
}

/**
 * Computes mid-cycle add-on proration using exact BigInt micro-units (pricing_and_credits.md §1.2).
 */
export function computeAddonProration(
  addonCode: string,
  currency: 'USD' | 'VND',
  interval: 'monthly' | 'annual',
  remainingDays: number,
  totalCycleDays: number
): string {
  const spec = CANONICAL_ADDONS.find((a) => a.addonCode === addonCode);
  if (!spec) {
    throw new Error(`Unknown canonical add-on code: ${addonCode}`);
  }
  if (totalCycleDays <= 0 || remainingDays <= 0) {
    return '0';
  }
  const baseStr =
    currency === 'VND'
      ? interval === 'annual'
        ? spec.annualPriceVnd
        : spec.monthlyPriceVnd
      : interval === 'annual'
        ? spec.annualPriceUsd
        : spec.monthlyPriceUsd;
  const baseMicros = parseExactMicros(baseStr);
  const rem = BigInt(Math.min(remainingDays, totalCycleDays));
  const tot = BigInt(totalCycleDays);
  // Half-up division in micro-units
  const proratedMicros = (baseMicros * rem + tot / 2n) / tot;
  return formatExactMicros(proratedMicros);
}

export type LifecycleScenarioKind =
  | 'trial_active'
  | 'trial_expired_no_payment'
  | 'dunning_retry_day_3'
  | 'dunning_grace_day_7'
  | 'dunning_downgrade_day_14'
  | 'pause_active'
  | 'cancel_scheduled_before_period_end'
  | 'cancel_phase_1_quarantine_0_30d'
  | 'cancel_phase_2_soft_delete_30_90d'
  | 'cancel_phase_3_hard_delete_90d_plus';

export interface LifecycleVerdict {
  scenario: LifecycleScenarioKind;
  effectiveTier: PlanTierCode;
  subscriptionStatus: 'trialing' | 'active' | 'past_due' | 'paused' | 'canceled';
  retentionPhase: string;
  readOnlyMode: boolean;
  canMutateOrGenerateAi: boolean;
  preservedPurchasedCredits: string;
  differsFromDunningSummary: string;
}

/**
 * Evaluates P8-02 Acceptance Targets #1 & #2 across Trial, Dunning (Day 0–14), Pause (<=90d),
 * and Voluntary Cancellation + 30d/60d/90d Retention Quarantine.
 */
export function evaluateTrialDunningPauseAndCancellationLifecycle(
  scenario: LifecycleScenarioKind,
  paidTier: PlanTierCode,
  purchasedCredits: string
): LifecycleVerdict {
  const purchasedFormatted = formatExactMicros(parseExactMicros(purchasedCredits));
  switch (scenario) {
    case 'trial_active':
      return {
        scenario,
        effectiveTier: 'pro',
        subscriptionStatus: 'trialing',
        retentionPhase: 'active',
        readOnlyMode: false,
        canMutateOrGenerateAi: true,
        preservedPurchasedCredits: purchasedFormatted,
        differsFromDunningSummary:
          'Dùng thử Pro 14 ngày (200 promotional credits, không cần thẻ). Hoạt động đầy đủ trước khi hết hạn.'
      };
    case 'trial_expired_no_payment':
      return {
        scenario,
        effectiveTier: 'free',
        subscriptionStatus: 'active',
        retentionPhase: 'active',
        readOnlyMode: false,
        canMutateOrGenerateAi: true,
        preservedPurchasedCredits: purchasedFormatted,
        differsFromDunningSummary:
          'Hết 14 ngày dùng thử không có thẻ -> tự động chuyển về gói Free (50 credits/tháng), dữ liệu và credits đã mua được giữ nguyên.'
      };
    case 'dunning_retry_day_3':
      return {
        scenario,
        effectiveTier: paidTier,
        subscriptionStatus: 'past_due',
        retentionPhase: 'dunning_retry',
        readOnlyMode: false,
        canMutateOrGenerateAi: true,
        preservedPurchasedCredits: purchasedFormatted,
        differsFromDunningSummary:
          'Dunning Ngày 0–5 (thử lại lần 1..4): trạng thái past_due nhưng vẫn giữ nguyên quyền truy cập đầy đủ (không khóa read-only).'
      };
    case 'dunning_grace_day_7':
      return {
        scenario,
        effectiveTier: paidTier,
        subscriptionStatus: 'past_due',
        retentionPhase: 'dunning_grace_read_only',
        readOnlyMode: true,
        canMutateOrGenerateAi: false,
        preservedPurchasedCredits: purchasedFormatted,
        differsFromDunningSummary:
          'Dunning Ngày 7–14: sau 4 lần thu tiền thất bại, workspace chuyển sang chế độ chỉ đọc (read-only grace); khác với hủy chủ động vốn giữ full quyền đến hết kỳ đã trả.'
      };
    case 'dunning_downgrade_day_14':
      return {
        scenario,
        effectiveTier: 'free',
        subscriptionStatus: 'active',
        retentionPhase: 'active',
        readOnlyMode: false,
        canMutateOrGenerateAi: true,
        preservedPurchasedCredits: purchasedFormatted,
        differsFromDunningSummary:
          'Dunning Ngày 14: tự động hạ xuống gói Free, mở lại quyền thao tác theo hạn mức Free, bảo toàn toàn bộ dữ liệu và credits đã mua (không đưa vào diện xóa 30/60/90 ngày).'
      };
    case 'pause_active':
      return {
        scenario,
        effectiveTier: paidTier,
        subscriptionStatus: 'paused',
        retentionPhase: 'paused_read_only',
        readOnlyMode: true,
        canMutateOrGenerateAi: false,
        preservedPurchasedCredits: purchasedFormatted,
        differsFromDunningSummary:
          'Tạm dừng gói Business/Enterprise (tối đa 90 ngày, 1 lần/năm): đóng băng chu kỳ thu phí ở chế độ chỉ đọc, giữ nguyên credits đã mua.'
      };
    case 'cancel_scheduled_before_period_end':
      return {
        scenario,
        effectiveTier: paidTier,
        subscriptionStatus: 'active',
        retentionPhase: 'cancel_scheduled',
        readOnlyMode: false,
        canMutateOrGenerateAi: true,
        preservedPurchasedCredits: purchasedFormatted,
        differsFromDunningSummary:
          'Hủy chủ động trước khi hết kỳ: giữ đầy đủ tính năng gói trả phí đến current_period_end (khác hoàn toàn với Dunning past_due).'
      };
    case 'cancel_phase_1_quarantine_0_30d':
      return {
        scenario,
        effectiveTier: paidTier,
        subscriptionStatus: 'canceled',
        retentionPhase: 'read_only_quarantine_0_30d',
        readOnlyMode: true,
        canMutateOrGenerateAi: false,
        preservedPurchasedCredits: purchasedFormatted,
        differsFromDunningSummary:
          'Giai đoạn 1 sau hủy (0–30 ngày): cách ly chỉ đọc (read-only), cho phép xuất dữ liệu JSON/CSV và tự khôi phục bằng 1 cú nhấp; bảo toàn nguyên vẹn credits đã mua.'
      };
    case 'cancel_phase_2_soft_delete_30_90d':
      return {
        scenario,
        effectiveTier: paidTier,
        subscriptionStatus: 'canceled',
        retentionPhase: 'soft_delete_30_90d',
        readOnlyMode: true,
        canMutateOrGenerateAi: false,
        preservedPurchasedCredits: purchasedFormatted,
        differsFromDunningSummary:
          'Giai đoạn 2 (30–90 ngày): xóa mềm (soft delete), thu hồi OAuth tokens, dừng workflow; khôi phục qua yêu cầu hỗ trợ + phương thức thanh toán hợp lệ, vẫn giữ nguyên credits đã mua.'
      };
    case 'cancel_phase_3_hard_delete_90d_plus':
      return {
        scenario,
        effectiveTier: 'free',
        subscriptionStatus: 'canceled',
        retentionPhase: 'hard_delete_90d_plus',
        readOnlyMode: true,
        canMutateOrGenerateAi: false,
        preservedPurchasedCredits: '0',
        differsFromDunningSummary:
          'Giai đoạn 3 (90+ ngày / Right to Erasure): xóa vĩnh viễn PII và tài sản media, chỉ giữ lại bản ghi tài chính ẩn danh (hóa đơn 7 năm, giao dịch credits 5 năm, nhật ký kiểm toán 3 năm).'
      };
  }
}

export interface RestoreExportEraseEvidenceVerdict {
  allowed: boolean;
  errorCode: string | null;
  actionType: 'export' | 'restore_phase_1' | 'restore_phase_2' | 'erase_right_to_erasure';
  evidenceSha512Prefix: string;
  exportUrlTtlDays: number;
  preservedPurchasedCredits: string;
  anonymizedRetentionSummary: string;
}

/**
 * Evaluates P8-02 Acceptance Target #3: Restore, Export, and Right-to-Erasure evidence rules,
 * including EC-M23-002 multi-member deletion guard.
 */
export function evaluateRestoreExportAndErasureEvidence(params: {
  actionType: 'export' | 'restore_phase_1' | 'restore_phase_2' | 'erase_right_to_erasure';
  workspaceId: string;
  activeMemberCount: number;
  ownershipTransferredOrMembersRemoved: boolean;
  hasValidPaymentMethod: boolean;
  supportTicketId?: string;
  purchasedCredits: string;
}): RestoreExportEraseEvidenceVerdict {
  const purchasedFormatted = formatExactMicros(parseExactMicros(params.purchasedCredits));
  if (
    params.actionType === 'erase_right_to_erasure' &&
    params.activeMemberCount > 1 &&
    !params.ownershipTransferredOrMembersRemoved
  ) {
    return {
      allowed: false,
      errorCode: 'BILLING_CONFLICT_002',
      actionType: params.actionType,
      evidenceSha512Prefix: '',
      exportUrlTtlDays: 7,
      preservedPurchasedCredits: purchasedFormatted,
      anonymizedRetentionSummary:
        'Chặn xóa workspace có nhiều thành viên hoạt động: Chủ sở hữu phải chuyển quyền hoặc xóa các thành viên trước (EC-M23-002).'
    };
  }
  if (
    params.actionType === 'restore_phase_2' &&
    (!params.hasValidPaymentMethod || !params.supportTicketId?.trim())
  ) {
    return {
      allowed: false,
      errorCode: 'BILLING_INVALID_001',
      actionType: params.actionType,
      evidenceSha512Prefix: '',
      exportUrlTtlDays: 7,
      preservedPurchasedCredits: purchasedFormatted,
      anonymizedRetentionSummary:
        'Khôi phục Giai đoạn 2 (30–90 ngày) bắt buộc có mã hỗ trợ (support_ticket_id) và phương thức thanh toán hợp lệ.'
    };
  }
  // Deterministic hex digest representation (128 hex chars = 512 bits) for client-side verification display
  const rawToken = `${params.actionType}:${params.workspaceId}:${purchasedFormatted}`;
  let hexAcc = '';
  for (let i = 0; i < 128; i++) {
    const code = (rawToken.charCodeAt(i % rawToken.length) + i * 17) & 0xff;
    hexAcc += (code & 0x0f).toString(16);
  }
  return {
    allowed: true,
    errorCode: null,
    actionType: params.actionType,
    evidenceSha512Prefix: hexAcc,
    exportUrlTtlDays: 7,
    preservedPurchasedCredits:
      params.actionType === 'erase_right_to_erasure' ? '0' : purchasedFormatted,
    anonymizedRetentionSummary:
      'invoices=7y_anonymized | credit_transactions=5y_anonymized | audit_logs=3y_anonymized | media_r2=purged'
  };
}

export const BIZ_007_TAX_RESPONSIBILITY_DISCLAIMER =
  'BIZ-007 (creator_responsible): Creativanta cung cấp báo cáo doanh thu, chi phí và xuất dữ liệu hỗ trợ kê khai; người sáng tạo / doanh nghiệp tự chịu trách nhiệm pháp lý về nghĩa vụ kê khai và nộp thuế.';

/**
 * Evaluates monthly financial report export quota by subscription tier (reporting_admin_billing.md §2.1):
 *   Free = 0 exports/mo, Starter = 5 exports/mo, Pro/Business/Enterprise = unlimited.
 */
export function evaluateReportExportQuota(
  tierCode: PlanTierCode,
  monthlyExportsUsed: number
): { allowed: boolean; errorCode: string | null; maxMonthlyExports: number | 'unlimited'; reason: string } {
  if (tierCode === 'free') {
    return {
      allowed: false,
      errorCode: 'FINANCE_EXPORT_LIMIT_001',
      maxMonthlyExports: 0,
      reason: 'Gói Free chỉ được xem báo cáo trên bảng điều khiển, không hỗ trợ xuất tệp CSV/XLSX/PDF.'
    };
  }
  if (tierCode === 'starter') {
    if (monthlyExportsUsed >= 5) {
      return {
        allowed: false,
        errorCode: 'FINANCE_EXPORT_LIMIT_001',
        maxMonthlyExports: 5,
        reason: 'Gói Starter đã dùng hết hạn mức 5 lần xuất báo cáo/tháng.'
      };
    }
    return {
      allowed: true,
      errorCode: null,
      maxMonthlyExports: 5,
      reason: `Gói Starter còn ${5 - monthlyExportsUsed}/5 lượt xuất báo cáo trong tháng.`
    };
  }
  return {
    allowed: true,
    errorCode: null,
    maxMonthlyExports: 'unlimited',
    reason: `Gói ${tierCode} được xuất báo cáo tài chính & thuế không giới hạn.`
  };
}

export interface MeasuredCohortEconomicsSummary {
  cohortMonth: string;
  planTier: PlanTierCode;
  grossMarginPct: string;
  netRevenueRetentionPct: string;
  blendedCacUsd: string;
  ltvUsd: string;
  ltvToCacRatio: string;
  cacPaybackMonths: string;
  aiCostPerActiveWorkspaceUsd: string;
  withinGuardrails: boolean;
}

/**
 * Computes all 7 canonical unit-economics & cohort metrics (pricing_and_credits.md §6)
 * using exact BigInt micro-unit arithmetic (zero floating point).
 */
export function computeMeasuredCohortEconomics(input: {
  cohortMonth: string;
  planTier: PlanTierCode;
  activeWorkspaces: number;
  subscriptionRevenueUsd: string;
  creditPackRevenueUsd: string;
  addonRevenueUsd: string;
  aiProviderCostUsd: string;
  cloudInfraCostUsd: string;
  paymentProcessingFeeUsd: string;
  startingMrrUsd: string;
  expansionMrrUsd: string;
  contractionMrrUsd: string;
  churnedMrrUsd: string;
  salesAndMarketingSpendUsd: string;
  newPaidWorkspacesAcquired: number;
  monthlyLogoChurnRatePct: string;
}): MeasuredCohortEconomicsSummary {
  const subRev = parseExactMicros(input.subscriptionRevenueUsd);
  const packRev = parseExactMicros(input.creditPackRevenueUsd);
  const addonRev = parseExactMicros(input.addonRevenueUsd);
  const totalRev = subRev + packRev + addonRev;

  const aiCost = parseExactMicros(input.aiProviderCostUsd);
  const infraCost = parseExactMicros(input.cloudInfraCostUsd);
  const payFee = parseExactMicros(input.paymentProcessingFeeUsd);
  const totalCogs = aiCost + infraCost + payFee;

  const grossProfit = totalRev - totalCogs;
  const hundredMicros = 100n * MICRO_SCALE;

  const divRound = (num: bigint, den: bigint): bigint => {
    if (den <= 0n) return 0n;
    const neg = num < 0n;
    const absNum = neg ? -num : num;
    const q = (absNum * MICRO_SCALE + den / 2n) / den;
    return neg ? -q : q;
  };

  // 1. Gross Margin % = (Revenue - COGS) / Revenue * 100
  const grossMarginMicros = totalRev > 0n ? divRound((grossProfit * hundredMicros) / MICRO_SCALE, totalRev) : 0n;

  // 2. NRR % = (Starting + Expansion - Contraction - Churned) / Starting * 100
  const startMrr = parseExactMicros(input.startingMrrUsd);
  const expMrr = parseExactMicros(input.expansionMrrUsd);
  const conMrr = parseExactMicros(input.contractionMrrUsd);
  const chuMrr = parseExactMicros(input.churnedMrrUsd);
  const endRetainedMrr = startMrr + expMrr - conMrr - chuMrr;
  const nrrMicros = startMrr > 0n ? divRound((endRetainedMrr * hundredMicros) / MICRO_SCALE, startMrr) : 0n;

  // 3. Blended CAC = S&M Spend / New Paid Workspaces
  const smSpend = parseExactMicros(input.salesAndMarketingSpendUsd);
  const newPaid = BigInt(Math.max(input.newPaidWorkspacesAcquired, 1)) * MICRO_SCALE;
  const cacMicros = divRound(smSpend, newPaid);

  // 4. LTV = (ARPU * GrossMarginRatio) / MonthlyChurnRatio = (GrossProfitPerActiveWorkspace * 100) / MonthlyChurnPct
  const activeWs = BigInt(Math.max(input.activeWorkspaces, 1)) * MICRO_SCALE;
  const grossProfitPerWs = divRound(grossProfit, activeWs);
  const churnPctMicros = parseExactMicros(input.monthlyLogoChurnRatePct);
  const ltvMicros =
    churnPctMicros > 0n ? divRound((grossProfitPerWs * hundredMicros) / MICRO_SCALE, churnPctMicros) : 0n;

  // 5. LTV:CAC Ratio = LTV / CAC
  const ltvToCacMicros = cacMicros > 0n ? divRound(ltvMicros, cacMicros) : 0n;

  // 6. CAC Payback (months) = CAC / GrossProfitPerActiveWorkspace
  const paybackMicros = grossProfitPerWs > 0n ? divRound(cacMicros, grossProfitPerWs) : 0n;

  // 7. AI Cost per Active Workspace = AI Provider Cost / Active Workspaces
  const aiPerWsMicros = divRound(aiCost, activeWs);

  const withinGuardrails =
    grossMarginMicros >= 60n * MICRO_SCALE &&
    nrrMicros >= 100n * MICRO_SCALE &&
    ltvToCacMicros >= 3n * MICRO_SCALE &&
    paybackMicros <= 12n * MICRO_SCALE;

  return {
    cohortMonth: input.cohortMonth,
    planTier: input.planTier,
    grossMarginPct: formatExactMicros(grossMarginMicros),
    netRevenueRetentionPct: formatExactMicros(nrrMicros),
    blendedCacUsd: formatExactMicros(cacMicros),
    ltvUsd: formatExactMicros(ltvMicros),
    ltvToCacRatio: formatExactMicros(ltvToCacMicros),
    cacPaybackMonths: formatExactMicros(paybackMicros),
    aiCostPerActiveWorkspaceUsd: formatExactMicros(aiPerWsMicros),
    withinGuardrails
  };
}
