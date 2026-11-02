import { describe, expect, it } from 'vitest';
import {
  CANONICAL_CONFIDENCE_BANDS,
  evaluateAuthorizedP1Import,
  evaluateMorningBriefSchedule,
  evaluateP1PilotCohort,
  evaluateStripeWebhookReplay,
  filterRepairCardsForRole,
  resolveUnderlyingRepairGap,
  type AuthorizedImportInput,
  type PilotBatchMetricInput,
  type StripeWebhookLedgerState
} from './index';

describe('P1-05 Web First-Value Loop, Local Morning Brief, Payment Replay & Pilot Instrumentation', () => {
  it('Acceptance Target #1: No connector required for authorized import + dynamic repair resolution + RBAC filtering', () => {
    const baseBatch: AuthorizedImportInput = {
      workspaceId: 'ws-p105-web',
      userId: 'user-owner-1',
      role: 'owner',
      connectedAccountsCount: 0, // Zero connected accounts!
      productsCount: 14,
      ordersCount: 92,
      costsCount: 5,
      settlementsCount: 1,
      grossRevenueVnd: '28500000',
      knownCostsVnd: '11200000',
      isDemoFixture: false,
      repairGaps: [
        {
          gapId: 'gap-missing-cogs-sku-9',
          gapKind: 'missing_cogs',
          title: 'Thiếu giá vốn (COGS) cho 2 SKU mới nhập',
          reason: 'Chưa có giá vốn cho 2 SKU, biên lợi nhuận ròng đang tạm tính.',
          repairCtaLabel: 'Bổ sung giá vốn trong Sổ cái (M19)',
          repairRoute: '/kinh-doanh',
          affectedAmountVnd: '3400000',
          resolved: false
        },
        {
          gapId: 'gap-missing-evidence-payout-2',
          gapKind: 'missing_evidence',
          title: 'Thiếu chứng từ phí vận chuyển lô #02',
          reason: 'Khoản phí vận chuyển chưa đính kèm chứng từ đối soát.',
          repairCtaLabel: 'Đính kèm chứng từ đối soát',
          repairRoute: '/kinh-doanh',
          affectedAmountVnd: '850000',
          resolved: false
        }
      ]
    };

    // 1. Demo fixture must be rejected
    expect(() =>
      evaluateAuthorizedP1Import({
        ...baseBatch,
        isDemoFixture: true
      })
    ).toThrow(/DEMO_FORBIDDEN/);

    // 2. Authorized import with 0 connected accounts succeeds
    const proj = evaluateAuthorizedP1Import(baseBatch);
    expect(proj.requiresNativeConnector).toBe(false);
    expect(proj.connectedAccountsCount).toBe(0);
    expect(proj.sourceClass).toBe('imported');
    expect(proj.confidenceBand).toBe('low');
    expect(proj.isIncomplete).toBe(true);
    expect(proj.unknownRequiredComponentsCount).toBe(2);
    expect(proj.netProfitVnd).toBe('17300000');
    expect(proj.activeRepairCards).toHaveLength(2);

    // Personal onboarding: Steps 1, 2, 5 completed; Steps 3 & 4 unavailable; closed loop false
    expect(proj.personalOnboarding.completedCount).toBe(3);
    expect(proj.personalOnboarding.isClosedLoopComplete).toBe(false);
    expect(proj.personalOnboarding.steps.find((s) => s.stepNumber === 3)?.isAvailable).toBe(false);
    expect(proj.personalOnboarding.steps.find((s) => s.stepNumber === 4)?.isAvailable).toBe(false);

    // 3. Viewer role filtering hides finance repair cards
    const viewerCards = filterRepairCardsForRole(proj.activeRepairCards, 'viewer');
    expect(viewerCards).toHaveLength(0);

    // 4. Resolving underlying repair gaps dynamically removes cards and upgrades confidence
    const projAfter1 = resolveUnderlyingRepairGap(
      proj,
      'gap-missing-cogs-sku-9',
      '3400000',
      'owner'
    );
    expect(projAfter1.activeRepairCards).toHaveLength(1);
    expect(projAfter1.netProfitVnd).toBe('13900000');

    const projAfter2 = resolveUnderlyingRepairGap(
      projAfter1,
      'gap-missing-evidence-payout-2',
      '0',
      'owner'
    );
    expect(projAfter2.activeRepairCards).toHaveLength(0);
    expect(projAfter2.isIncomplete).toBe(false);
    expect(projAfter2.confidenceBand).toBe('medium');
  });

  it('Acceptance Target #2: DST/timezone cannot double-deliver Morning Brief', () => {
    const deliveredKeys = new Set<string>();

    // Case A: Asia/Ho_Chi_Minh 07:05 local time (00:05 UTC)
    const vnCfg = {
      workspaceId: 'ws-vn-1',
      timezone: 'Asia/Ho_Chi_Minh',
      morningBriefEnabled: true,
      morningBriefTime: '07:00',
      hasAuthorizedData: true
    };
    const firstVn = evaluateMorningBriefSchedule(
      vnCfg,
      '2026-11-02T00:05:00Z',
      deliveredKeys
    );
    expect(firstVn.decision).toBe('delivered');
    expect(firstVn.localDate).toBe('2026-11-02');

    // Re-evaluating later on the same local date
    const retrySameLocalDay = evaluateMorningBriefSchedule(
      vnCfg,
      '2026-11-02T00:10:00Z',
      deliveredKeys
    );
    expect(retrySameLocalDay.decision).toBe('already_delivered_local_date');
    expect(retrySameLocalDay.alreadyDelivered).toBe(true);

    // Case B: America/New_York Fall-back DST day (2026-11-01) and timezone shift on the same local date
    const nyDelivered = new Set<string>();
    const nyCfg = {
      workspaceId: 'ws-dst-1',
      timezone: 'America/New_York',
      morningBriefEnabled: true,
      morningBriefTime: '07:00',
      hasAuthorizedData: true
    };
    const nyFirst = evaluateMorningBriefSchedule(
      nyCfg,
      '2026-11-01T12:05:00Z',
      nyDelivered
    );
    expect(nyFirst.decision).toBe('delivered');
    expect(nyFirst.localDate).toBe('2026-11-01');

    // Workspace changes timezone to America/Chicago (where 13:05 UTC is 07:05 CST on the SAME local date 2026-11-01)
    const chicagoShift = evaluateMorningBriefSchedule(
      { ...nyCfg, timezone: 'America/Chicago' },
      '2026-11-01T13:05:00Z',
      nyDelivered
    );
    expect(chicagoShift.decision).toBe('already_delivered_local_date');
    expect(chicagoShift.alreadyDelivered).toBe(true);
    expect(nyDelivered.size).toBe(1);
  });

  it('Acceptance Target #3: Payment replay cannot double-grant credits across duplicate or re-emitted webhooks', () => {
    const ledgerState: StripeWebhookLedgerState = {
      processedEventIds: new Set<string>(),
      settledExternalGrantKeys: new Set<string>(),
      availableCreditsMicros: 0n,
      lotCount: 0,
      transactionCount: 0
    };

    const unpaid = evaluateStripeWebhookReplay(ledgerState, {
      eventId: 'evt_unpaid_1',
      eventType: 'checkout.session.completed',
      workspaceId: 'ws-pay-1',
      paymentStatus: 'unpaid',
      externalGrantKey: 'stripe_pack:cs_live_100',
      grantedCredits: '500'
    });
    expect(unpaid.accepted).toBe(false);
    expect(unpaid.availableBalanceAfter).toBe('0');

    const firstPaid = evaluateStripeWebhookReplay(ledgerState, {
      eventId: 'evt_paid_1',
      eventType: 'checkout.session.completed',
      workspaceId: 'ws-pay-1',
      paymentStatus: 'paid',
      externalGrantKey: 'stripe_pack:cs_live_100',
      grantedCredits: '500'
    });
    expect(firstPaid.accepted).toBe(true);
    expect(firstPaid.replayed).toBe(false);
    expect(firstPaid.grantedCredits).toBe('500');
    expect(firstPaid.availableBalanceAfter).toBe('500');
    expect(ledgerState.lotCount).toBe(1);

    const sameEventReplay = evaluateStripeWebhookReplay(ledgerState, {
      eventId: 'evt_paid_1',
      eventType: 'checkout.session.completed',
      workspaceId: 'ws-pay-1',
      paymentStatus: 'paid',
      externalGrantKey: 'stripe_pack:cs_live_100',
      grantedCredits: '500'
    });
    expect(sameEventReplay.accepted).toBe(true);
    expect(sameEventReplay.replayed).toBe(true);
    expect(sameEventReplay.grantedCredits).toBe('0');
    expect(sameEventReplay.availableBalanceAfter).toBe('500');

    const diffEventSameGrantReplay = evaluateStripeWebhookReplay(ledgerState, {
      eventId: 'evt_paid_2_reemitted',
      eventType: 'checkout.session.completed',
      workspaceId: 'ws-pay-1',
      paymentStatus: 'paid',
      externalGrantKey: 'stripe_pack:cs_live_100',
      grantedCredits: '500'
    });
    expect(diffEventSameGrantReplay.accepted).toBe(true);
    expect(diffEventSameGrantReplay.replayed).toBe(true);
    expect(diffEventSameGrantReplay.grantedCredits).toBe('0');
    expect(diffEventSameGrantReplay.availableBalanceAfter).toBe('500');
    expect(ledgerState.lotCount).toBe(1);
    expect(ledgerState.transactionCount).toBe(1);
  });

  it('Acceptance Target #4: P1 pilot measurements record actual unknowns and preserve all 5 canonical confidence bands', () => {
    expect(CANONICAL_CONFIDENCE_BANDS).toEqual([
      'high',
      'medium_high',
      'medium',
      'low_medium',
      'low'
    ]);

    const observations: PilotBatchMetricInput[] = [
      {
        workspaceId: 'ws-real-1',
        objectId: 'batch-1',
        operationId: 'op-1',
        isDemoOrInternal: false,
        sourceClass: 'imported',
        confidenceBand: 'low',
        unresolvedRequiredComponentsCount: 2,
        operatorRepairSeconds: null,
        startedProductionJob: false,
        acceptedOutput: false,
        settledCostUsd: '0'
      },
      {
        workspaceId: 'ws-real-1',
        objectId: 'batch-1',
        operationId: 'op-1',
        isDemoOrInternal: false,
        sourceClass: 'imported',
        confidenceBand: 'low',
        unresolvedRequiredComponentsCount: 2,
        operatorRepairSeconds: null,
        startedProductionJob: false,
        acceptedOutput: false,
        settledCostUsd: '0'
      },
      {
        workspaceId: 'ws-demo-1',
        objectId: 'batch-demo',
        operationId: 'op-demo',
        isDemoOrInternal: true,
        sourceClass: 'unreconciled',
        confidenceBand: 'high',
        unresolvedRequiredComponentsCount: 0,
        operatorRepairSeconds: 15,
        startedProductionJob: true,
        acceptedOutput: true,
        settledCostUsd: '5.000000'
      }
    ];

    const summary = evaluateP1PilotCohort(observations);
    expect(summary.sampleSize).toBe(1);
    expect(summary.excludedDemoOrInternalCount).toBe(1);
    expect(summary.deduplicatedCount).toBe(1);
    expect(summary.confidenceBandCounts.low).toBe(1);

    expect(summary.repairBurden.operatorTimeKnown).toBe(false);
    expect(summary.repairBurden.medianOperatorRepairSeconds).toBeNull();
    expect(summary.repairBurden.unknownOperatorTimeBatchesCount).toBe(1);
    expect(summary.repairBurden.medianUnresolvedComponentsCount).toBe(2);

    expect(summary.costPerAcceptedOutput.known).toBe(false);
    expect(summary.costPerAcceptedOutput.status).toBe('undefined_zero_accepted_outputs');
    expect(summary.costPerAcceptedOutput.costUsdPerAcceptedOutput).toBeNull();
  });
});
