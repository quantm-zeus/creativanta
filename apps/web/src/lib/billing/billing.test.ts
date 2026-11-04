import { describe, expect, it } from 'vitest';
import {
  BIZ_007_TAX_RESPONSIBILITY_DISCLAIMER,
  CANONICAL_ADDONS,
  CANONICAL_CREDIT_PACKS,
  CANONICAL_PAYMENT_METHOD_GATES,
  CANONICAL_PLANS,
  LOT_CONSUMPTION_PRIORITY,
  computeAddonProration,
  computeCostBasedQuoteCredits,
  computeMeasuredCohortEconomics,
  evaluateBillingPermission,
  evaluateConcurrentReservationHold,
  evaluateLastPaymentMethodRemoval,
  evaluatePaidRetryCommit,
  evaluatePaymentMethodAccessGate,
  evaluateReportExportQuota,
  evaluateRestoreExportAndErasureEvidence,
  evaluateTrialDunningPauseAndCancellationLifecycle
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

  it('P8-02 Target #1 & #2: enforces payment method access gates, Starter+ add-on proration, cancellation != dunning, and purchased credit preservation', () => {
    expect(CANONICAL_PAYMENT_METHOD_GATES).toHaveLength(6);
    expect(evaluatePaymentMethodAccessGate('card', 'starter', []).allowed).toBe(true);
    expect(evaluatePaymentMethodAccessGate('momo', 'pro', []).allowed).toBe(false);
    expect(evaluatePaymentMethodAccessGate('momo', 'pro', ['momo']).allowed).toBe(true);
    expect(
      evaluatePaymentMethodAccessGate('bank_transfer', 'starter', ['bank_transfer']).allowed
    ).toBe(false);
    expect(
      evaluatePaymentMethodAccessGate('bank_transfer', 'business', ['bank_transfer']).allowed
    ).toBe(true);

    expect(
      CANONICAL_ADDONS.every((a) => a.eligibleTiers.includes('starter') && a.annualPriceUsd !== '0')
    ).toBe(true);
    expect(computeAddonProration('commerce_intelligence', 'USD', 'monthly', 15, 30)).toBe('19.5');

    // Cancellation differs from Dunning:
    const dunningDay7 = evaluateTrialDunningPauseAndCancellationLifecycle(
      'dunning_grace_day_7',
      'pro',
      '500'
    );
    const dunningDay14 = evaluateTrialDunningPauseAndCancellationLifecycle(
      'dunning_downgrade_day_14',
      'pro',
      '500'
    );
    const cancelScheduled = evaluateTrialDunningPauseAndCancellationLifecycle(
      'cancel_scheduled_before_period_end',
      'pro',
      '500'
    );
    const cancelPhase1 = evaluateTrialDunningPauseAndCancellationLifecycle(
      'cancel_phase_1_quarantine_0_30d',
      'pro',
      '500'
    );

    expect(dunningDay7.subscriptionStatus).toBe('past_due');
    expect(dunningDay7.readOnlyMode).toBe(true);
    expect(dunningDay14.effectiveTier).toBe('free');
    expect(dunningDay14.readOnlyMode).toBe(false);
    expect(dunningDay14.preservedPurchasedCredits).toBe('500');

    expect(cancelScheduled.subscriptionStatus).toBe('active');
    expect(cancelScheduled.readOnlyMode).toBe(false);
    expect(cancelPhase1.subscriptionStatus).toBe('canceled');
    expect(cancelPhase1.retentionPhase).toBe('read_only_quarantine_0_30d');
    expect(cancelPhase1.readOnlyMode).toBe(true);
    expect(cancelPhase1.preservedPurchasedCredits).toBe('500');
  });

  it('P8-02 Target #3 & #4: enforces restore/export/erase SHA-512 evidence, EC-M23-002, report export tier limits, and 7 measured cohort metrics', () => {
    const blockedErase = evaluateRestoreExportAndErasureEvidence({
      actionType: 'erase_right_to_erasure',
      workspaceId: '00000000-0000-4000-8000-000000000001',
      activeMemberCount: 3,
      ownershipTransferredOrMembersRemoved: false,
      hasValidPaymentMethod: true,
      purchasedCredits: '250'
    });
    expect(blockedErase.allowed).toBe(false);
    expect(blockedErase.errorCode).toBe('BILLING_CONFLICT_002');

    const phase2Restore = evaluateRestoreExportAndErasureEvidence({
      actionType: 'restore_phase_2',
      workspaceId: '00000000-0000-4000-8000-000000000001',
      activeMemberCount: 1,
      ownershipTransferredOrMembersRemoved: true,
      hasValidPaymentMethod: true,
      supportTicketId: 'SUP-2026-9001',
      purchasedCredits: '250'
    });
    expect(phase2Restore.allowed).toBe(true);
    expect(phase2Restore.evidenceSha512Prefix).toHaveLength(128);
    expect(phase2Restore.preservedPurchasedCredits).toBe('250');

    expect(evaluateReportExportQuota('free', 0).allowed).toBe(false);
    expect(evaluateReportExportQuota('starter', 4).allowed).toBe(true);
    expect(evaluateReportExportQuota('starter', 5).allowed).toBe(false);
    expect(evaluateReportExportQuota('pro', 99).allowed).toBe(true);
    expect(BIZ_007_TAX_RESPONSIBILITY_DISCLAIMER).toContain('creator_responsible');

    const cohort = computeMeasuredCohortEconomics({
      cohortMonth: '2026-11',
      planTier: 'pro',
      activeWorkspaces: 100,
      subscriptionRevenueUsd: '6000',
      creditPackRevenueUsd: '2000',
      addonRevenueUsd: '2000',
      aiProviderCostUsd: '2000',
      cloudInfraCostUsd: '700',
      paymentProcessingFeeUsd: '300',
      startingMrrUsd: '8000',
      expansionMrrUsd: '1600',
      contractionMrrUsd: '400',
      churnedMrrUsd: '400',
      salesAndMarketingSpendUsd: '2800',
      newPaidWorkspacesAcquired: 20,
      monthlyLogoChurnRatePct: '5'
    });
    expect(cohort.grossMarginPct).toBe('70');
    expect(cohort.netRevenueRetentionPct).toBe('110');
    expect(cohort.blendedCacUsd).toBe('140');
    expect(cohort.ltvUsd).toBe('1400');
    expect(cohort.ltvToCacRatio).toBe('10');
    expect(cohort.cacPaybackMonths).toBe('2');
    expect(cohort.aiCostPerActiveWorkspaceUsd).toBe('20');
    expect(cohort.withinGuardrails).toBe(true);
  });
});
