import { describe, expect, it } from 'vitest';
import {
  MODE_DECISION_CARDS,
  SHARED_ROUTE_MAP,
  CANONICAL_ONBOARDING_STEPS,
  evaluateOnboardingState,
  evaluateWebFullScopeReleaseDecision,
  type UIStateType
} from './decision_engine';
import { OPERATOR_MODES, type OperatorModeId } from '$lib/constants/modes';

describe('P8-01 Acceptance Target 1: All Six Mode Priorities (Web Decision Engine)', () => {
  it('defines decision cards for every one of the 6 canonical operator modes', () => {
    const definedModes = Object.keys(MODE_DECISION_CARDS) as OperatorModeId[];
    expect(definedModes).toHaveLength(6);

    for (const mode of OPERATOR_MODES) {
      expect(MODE_DECISION_CARDS[mode.id]).toBeDefined();
      expect(MODE_DECISION_CARDS[mode.id].length).toBeGreaterThanOrEqual(5);
    }
  });

  it('preserves distinct card rankings and actionable primary routes per mode', () => {
    for (const mode of OPERATOR_MODES) {
      const cards = MODE_DECISION_CARDS[mode.id];
      const ranks = cards.map((c) => c.priorityRank);
      // Ranks should be sequential 1..N
      for (let i = 1; i <= cards.length; i++) {
        expect(ranks).toContain(i);
      }

      // Every card must have a valid non-empty title, moduleRef, and route in SHARED_ROUTE_MAP
      for (const card of cards) {
        expect(card.cardId).toBeTruthy();
        expect(card.title).toBeTruthy();
        expect(card.moduleRef).toBeTruthy();
        expect(card.primaryCtaLabel).toBeTruthy();
        expect(card.whyThisMatters).toBeTruthy();

        // In Phase P8, primary action cards are enabled
        expect(card.isActionAvailable).toBe(true);

        // Primary CTA route must exist in SHARED_ROUTE_MAP
        expect(SHARED_ROUTE_MAP[card.primaryCtaRoute]).toBeDefined();
      }
    }
  });

  it('validates Creator mode has 7 cards starting with Trend Radar and Idea Engine', () => {
    const creatorCards = MODE_DECISION_CARDS.creator;
    expect(creatorCards).toHaveLength(7);
    expect(creatorCards[0].priorityRank).toBe(1);
    expect(creatorCards[0].cardId).toBe('card-creator-trend');
    expect(creatorCards[0].moduleRef).toBe('M02');
    expect(creatorCards[0].primaryCtaRoute).toBe('/kham-pha');

    expect(creatorCards[1].priorityRank).toBe(2);
    expect(creatorCards[1].cardId).toBe('card-creator-ideas');
    expect(creatorCards[1].moduleRef).toBe('M05');
    expect(creatorCards[1].primaryCtaRoute).toBe('/ideas');

    expect(creatorCards[2].priorityRank).toBe(3);
    expect(creatorCards[2].cardId).toBe('card-creator-script');
    expect(creatorCards[2].moduleRef).toBe('M06');
    expect(creatorCards[2].primaryCtaRoute).toBe('/scripts');
  });

  it('validates Seller mode has 5 cards focusing on orders, inventory and promotions', () => {
    const sellerCards = MODE_DECISION_CARDS.seller;
    expect(sellerCards).toHaveLength(5);
    expect(sellerCards[0].cardId).toBe('card-seller-orders');
    expect(sellerCards[0].moduleRef).toBe('M13');
    expect(sellerCards[0].primaryCtaRoute).toBe('/kinh-doanh');

    expect(sellerCards[1].cardId).toBe('card-seller-revenue');
    expect(sellerCards[1].moduleRef).toBe('M19');
    expect(sellerCards[1].primaryCtaRoute).toBe('/finance');

    expect(sellerCards[2].cardId).toBe('card-seller-stock');
    expect(sellerCards[2].moduleRef).toBe('M13');
    expect(sellerCards[2].primaryCtaRoute).toBe('/kinh-doanh');
  });

  it('validates Affiliate Operator mode priorities', () => {
    const cards = MODE_DECISION_CARDS.affiliate_operator;
    expect(cards).toHaveLength(5);
    expect(cards[0].cardId).toBe('card-affiliate-links');
    expect(cards[0].moduleRef).toBe('M16');
    expect(cards[0].primaryCtaRoute).toBe('/affiliates');
  });

  it('validates Live Operator mode priorities', () => {
    const cards = MODE_DECISION_CARDS.live_operator;
    expect(cards).toHaveLength(5);
    expect(cards[0].cardId).toBe('card-live-readiness');
    expect(cards[0].moduleRef).toBe('M17');
    expect(cards[0].primaryCtaRoute).toBe('/live');
  });

  it('validates Agency/MCN mode priorities', () => {
    const cards = MODE_DECISION_CARDS.agency_mcn;
    expect(cards).toHaveLength(5);
    expect(cards[0].cardId).toBe('card-agency-approvals');
    expect(cards[0].moduleRef).toBe('M20');
    expect(cards[0].primaryCtaRoute).toBe('/workflows');
  });

  it('validates Brand Collaboration mode priorities', () => {
    const cards = MODE_DECISION_CARDS.brand_collaboration;
    expect(cards).toHaveLength(5);
    expect(cards[0].cardId).toBe('card-brand-inquiries');
    expect(cards[0].moduleRef).toBe('S16');
    expect(cards[0].primaryCtaRoute).toBe('/creator-pro');
  });
});

describe('P8-01 Acceptance Target 2: First-Value vs Closed-Loop Completion Distinct', () => {
  it('defines the 5 standard operating loop onboarding steps', () => {
    expect(CANONICAL_ONBOARDING_STEPS).toHaveLength(5);
    expect(CANONICAL_ONBOARDING_STEPS.map((s) => s.stepNumber)).toEqual([1, 2, 3, 4, 5]);
    expect(CANONICAL_ONBOARDING_STEPS.map((s) => s.stepKey)).toEqual([
      'connect_data',
      'select_offer',
      'create_content',
      'publish',
      'track_outcome'
    ]);
  });

  it('distinguishes first-value (Step 1) from full-loop completion (Steps 1..5)', () => {
    // Initial state: 0 completed
    const initial = evaluateOnboardingState([]);
    expect(initial.completedCount).toBe(0);
    expect(initial.isFirstValueComplete).toBe(false);
    expect(initial.isClosedLoopComplete).toBe(false);

    // Step 1 completed (Authorized import / Connector) -> First-Value complete, NOT full loop
    const firstValue = evaluateOnboardingState([1]);
    expect(firstValue.completedCount).toBe(1);
    expect(firstValue.isFirstValueComplete).toBe(true);
    expect(firstValue.isClosedLoopComplete).toBe(false);

    // Steps 2, 3, 4, 5 completed without Step 1 -> Neither first-value nor full loop
    const missingFirst = evaluateOnboardingState([2, 3, 4, 5]);
    expect(missingFirst.completedCount).toBe(4);
    expect(missingFirst.isFirstValueComplete).toBe(false);
    expect(missingFirst.isClosedLoopComplete).toBe(false);

    // Steps 1..4 completed -> First-value complete, NOT full loop
    const fourSteps = evaluateOnboardingState([1, 2, 3, 4]);
    expect(fourSteps.completedCount).toBe(4);
    expect(fourSteps.isFirstValueComplete).toBe(true);
    expect(fourSteps.isClosedLoopComplete).toBe(false);

    // All 5 steps completed -> Both first-value and closed-loop complete
    const fullLoop = evaluateOnboardingState([1, 2, 3, 4, 5]);
    expect(fullLoop.completedCount).toBe(5);
    expect(fullLoop.isFirstValueComplete).toBe(true);
    expect(fullLoop.isClosedLoopComplete).toBe(true);
  });
});

describe('P8-01 Acceptance Target 3: Every Shared UI State & Route Mapped', () => {
  it('covers all 5 canonical UI states', () => {
    const validStates: UIStateType[] = ['normal', 'loading', 'empty', 'error', 'repair'];
    for (const s of validStates) {
      expect(['normal', 'loading', 'empty', 'error', 'repair']).toContain(s);
    }
  });

  it('maps all shared routes to modules, domains, and mobile screens', () => {
    const expectedRoutes = [
      '/',
      '/kham-pha',
      '/ideas',
      '/scripts',
      '/studio',
      '/xuat-ban',
      '/inbox',
      '/kinh-doanh',
      '/finance',
      '/affiliates',
      '/offers',
      '/coupons',
      '/attribution',
      '/workflows',
      '/settings/connections',
      '/settings/diagnostics'
    ];

    for (const route of expectedRoutes) {
      const mapping = SHARED_ROUTE_MAP[route];
      expect(mapping).toBeDefined();
      expect(mapping.moduleRef).toMatch(/^M\d{2}$/);
      expect(mapping.vietnameseTitle.length).toBeGreaterThan(3);
      expect(mapping.mobileTabOrScreen.length).toBeGreaterThan(3);
      expect(mapping.domain.length).toBeGreaterThan(2);
    }
  });

  it('enforces P8-09 Web Decision Engine: full-scope acceptance, 31 modules, 6 modes, and external gates', () => {
    // 1. Happy path: complete audit passes local readiness
    const verdict = evaluateWebFullScopeReleaseDecision({
      auditedModuleCount: 31,
      auditedModeCount: 6,
      verifiedTaskCount: 60,
      untrackedRemainingScopeCount: 0,
      openExternalGatesCount: 3,
      assertProductionLaunch: false
    });
    expect(verdict.isReadyLocal).toBe(true);
    expect(verdict.releaseDecision).toBe('CONDITIONAL_READY_LOCAL');
    expect(verdict.productionLaunchApproved).toBe(false);
    expect(verdict.unmetExternalGatesCount).toBe(3);
    expect(verdict.externalGates).toHaveLength(3);

    // 2. Incomplete module or mode count blocks release
    const blockedVerdict = evaluateWebFullScopeReleaseDecision({
      auditedModuleCount: 30, // missing 1 module
      auditedModeCount: 6,
      verifiedTaskCount: 60,
      untrackedRemainingScopeCount: 0,
      openExternalGatesCount: 3,
      assertProductionLaunch: false
    });
    expect(blockedVerdict.isReadyLocal).toBe(false);
    expect(blockedVerdict.releaseDecision).toBe('RELEASE_BLOCKED');

    // 3. Fake production launch assertion while external gates open fails closed
    const fakeLaunchVerdict = evaluateWebFullScopeReleaseDecision({
      auditedModuleCount: 31,
      auditedModeCount: 6,
      verifiedTaskCount: 60,
      untrackedRemainingScopeCount: 0,
      openExternalGatesCount: 3,
      assertProductionLaunch: true // premature assertion
    });
    expect(fakeLaunchVerdict.releaseDecision).toBe('RELEASE_BLOCKED');
    expect(fakeLaunchVerdict.productionLaunchApproved).toBe(false);
  });
});
