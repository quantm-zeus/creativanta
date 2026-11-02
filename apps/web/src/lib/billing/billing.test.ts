import { describe, expect, it } from 'vitest';
import {
  CANONICAL_ADDONS,
  CANONICAL_CREDIT_PACKS,
  CANONICAL_PLANS,
  LOT_CONSUMPTION_PRIORITY,
  computeCostBasedQuoteCredits,
  evaluateBillingPermission,
  evaluateConcurrentReservationHold,
  evaluateLastPaymentMethodRemoval,
  evaluatePaidRetryCommit
} from './index';

describe('P0-06 Web Billing & Credit Accounting Contract', () => {
  it('exposes the canonical 5 subscription tiers, 4 credit packs, 4 add-ons, and lot consumption order', () => {
    expect(CANONICAL_PLANS.map((p) => p.tierCode)).toEqual([
      'free',
      'starter',
      'pro',
      'business',
      'enterprise'
    ]);
    expect(CANONICAL_PLANS.find((p) => p.tierCode === 'free')?.monthlyCredits).toBe('50');
    expect(CANONICAL_PLANS.find((p) => p.tierCode === 'pro')?.monthlyPriceVnd).toBe('1499000');

    expect(CANONICAL_CREDIT_PACKS.map((p) => p.packCode)).toEqual([
      'small',
      'medium',
      'large',
      'mega'
    ]);
    expect(CANONICAL_CREDIT_PACKS.every((p) => p.neverExpires)).toBe(true);
    expect(CANONICAL_ADDONS).toHaveLength(4);
    expect(LOT_CONSUMPTION_PRIORITY).toEqual([
      'promotional',
      'subscription',
      'purchased',
      'overage'
    ]);
  });

  it('computes exact cost-based quote ceiling without floating point (pricing_and_credits.md §3.0)', () => {
    expect(computeCostBasedQuoteCredits('0.600000', '0.015000', '0.5000')).toBe('80');
    expect(computeCostBasedQuoteCredits('0.600001', '0.015000', '0.5000')).toBe('81');
    expect(computeCostBasedQuoteCredits('0.060000', '0.015000', '0.5000')).toBe('8');
  });

  it('prevents concurrent holds from overspending available credits (Acceptance Target #1)', () => {
    // Hold 1 of 8 credits against 10 available -> succeeds, leaving 2 available
    const first = evaluateConcurrentReservationHold('10', '8', 0);
    expect(first.allowed).toBe(true);
    expect(first.remainingAvailable).toBe('2');

    // Hold 2 of 8 credits against remaining 2 available -> rejected with BILLING_LIMIT_001
    const second = evaluateConcurrentReservationHold(first.remainingAvailable, '8', 1);
    expect(second.allowed).toBe(false);
    expect(second.errorCode).toBe('BILLING_LIMIT_001');

    // 6th active hold -> rejected with BILLING_LIMIT_002
    const sixth = evaluateConcurrentReservationHold('500', '8', 5);
    expect(sixth.allowed).toBe(false);
    expect(sixth.errorCode).toBe('BILLING_LIMIT_002');
  });

  it('caps paid retry commit at confirmed quote and blocks unbounded retries (Acceptance Target #3)', () => {
    const capped = evaluatePaidRetryCommit('80', '120', 2, 2);
    expect(capped.allowed).toBe(true);
    expect(capped.chargedCredits).toBe('80');
    expect(capped.releasedRemainder).toBe('0');

    const partial = evaluatePaidRetryCommit('80', '48', 1, 2);
    expect(partial.allowed).toBe(true);
    expect(partial.chargedCredits).toBe('48');
    expect(partial.releasedRemainder).toBe('32');

    const exceededAttempts = evaluatePaidRetryCommit('80', '80', 3, 2);
    expect(exceededAttempts.allowed).toBe(false);
    expect(exceededAttempts.errorCode).toBe('BILLING_CONFLICT_002');
  });

  it('enforces Owner-only RBAC for billing mutations and EC-M23-001 last payment method guard', () => {
    expect(evaluateBillingPermission('owner', 'manage_billing').allowed).toBe(true);
    expect(evaluateBillingPermission('owner', 'top_up_credits').allowed).toBe(true);
    expect(evaluateBillingPermission('admin', 'manage_billing').allowed).toBe(false);
    expect(evaluateBillingPermission('editor', 'top_up_credits').allowed).toBe(false);
    expect(evaluateBillingPermission('manager', 'read_billing').allowed).toBe(true);

    const ecBlock = evaluateLastPaymentMethodRemoval('pro', true, 1);
    expect(ecBlock.allowed).toBe(false);
    expect(ecBlock.errorCode).toBe('BILLING_CONFLICT_001');

    const allowWithTwo = evaluateLastPaymentMethodRemoval('pro', true, 2);
    expect(allowWithTwo.allowed).toBe(true);
  });
});
