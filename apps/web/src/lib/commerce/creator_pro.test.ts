import { describe, it, expect } from 'vitest';
import {
  validateDealTransition,
  evaluateLinkThreat,
  canPublishBioPage,
  computeRPM,
  checkRPMDropAlert,
  isToolEntitledForMode,
  getEntitledTools,
  MODE_ENTITLED_TOOLS,
  type BrandDealStatus,
  type LinkItem,
  type LinkInBioPage,
  type WorkspaceMode,
  type CreatorProTool
} from './creator_pro';

describe('Creator Pro - Target 1: Canonical Deal Lifecycle', () => {
  it('allows canonical sequential progression from negotiating to completed', () => {
    const sequence: BrandDealStatus[] = [
      'negotiating',
      'agreed',
      'in_progress',
      'delivered',
      'paid',
      'completed'
    ];

    for (let i = 0; i < sequence.length - 1; i++) {
      const from = sequence[i];
      const to = sequence[i + 1];
      const result = validateDealTransition(from, to);
      expect(result.valid).toBe(true);
      expect(result.error).toBeUndefined();
    }
  });

  it('rejects skipping states in lifecycle', () => {
    const skipToDelivered = validateDealTransition('negotiating', 'delivered');
    expect(skipToDelivered.valid).toBe(false);
    expect(skipToDelivered.error).toContain('canonical sequence');

    const skipToPaid = validateDealTransition('agreed', 'paid');
    expect(skipToPaid.valid).toBe(false);
    expect(skipToPaid.error).toContain('canonical sequence');
  });

  it('enforces completed as a terminal state', () => {
    const reopen = validateDealTransition('completed', 'negotiating');
    expect(reopen.valid).toBe(false);
    expect(reopen.error).toContain('already completed');

    const cancelCompleted = validateDealTransition('completed', 'cancelled', {
      cancellationReason: 'refund'
    });
    expect(cancelCompleted.valid).toBe(false);
    expect(cancelCompleted.error).toContain('already completed');
  });

  it('requires cancellation reason when cancelling a deal', () => {
    const noReason = validateDealTransition('in_progress', 'cancelled');
    expect(noReason.valid).toBe(false);
    expect(noReason.error).toContain('requires a non-empty reason');

    const withReason = validateDealTransition('in_progress', 'cancelled', {
      cancellationReason: 'Client halted marketing spend'
    });
    expect(withReason.valid).toBe(true);
  });

  it('requires financial reversal audit when cancelling a paid deal', () => {
    // Attempt to cancel paid deal without financial reversal confirmation
    const paidWithoutReversal = validateDealTransition('paid', 'cancelled', {
      cancellationReason: 'Creator failed to deliver video milestone'
    });
    expect(paidWithoutReversal.valid).toBe(false);
    expect(paidWithoutReversal.error).toContain('explicit financial reversal confirmation');

    // Attempt to cancel paid deal WITH financial reversal confirmation
    const paidWithReversal = validateDealTransition('paid', 'cancelled', {
      cancellationReason: 'Creator failed to deliver video milestone',
      financialReversalConfirmed: true
    });
    expect(paidWithReversal.valid).toBe(true);
  });
});

describe('Creator Pro - Target 2: Phishing Cannot Be Acknowledged Away & Security', () => {
  it('identifies phishing URLs via threat intelligence', () => {
    const phishingScan = evaluateLinkThreat('https://steal-login.fake-bank-phishing.com/login');
    expect(phishingScan.scanStatus).toBe('phishing');
    expect(phishingScan.phishingDetected).toBe(true);
    expect(phishingScan.blockedFromPublishing).toBe(true);

    const safeScan = evaluateLinkThreat('https://myofficialstore.vn/products/merch');
    expect(safeScan.scanStatus).toBe('safe');
    expect(safeScan.phishingDetected).toBe(false);
    expect(safeScan.blockedFromPublishing).toBe(false);
  });

  it('strictly rejects bio page publishing when phishing link exists even with AUP acknowledgment', () => {
    const dummyPage: LinkInBioPage = {
      pageId: 'page-001',
      workspaceId: 'ws-001',
      slug: 'creator-slug',
      title: 'Creator Links',
      bio: 'Welcome to my bio',
      theme: 'clean',
      customDomainVerified: false,
      analyticsEnabled: true,
      totalViews: 100,
      status: 'draft',
      createdAt: '2026-11-04T00:00:00Z',
      updatedAt: '2026-11-04T00:00:00Z'
    };

    const itemsWithPhishing: LinkItem[] = [
      {
        linkItemId: 'item-1',
        pageId: 'page-001',
        workspaceId: 'ws-001',
        linkType: 'store',
        title: 'Safe Store Link',
        url: 'https://store.vn/item1',
        position: 0,
        isActive: true,
        isPinned: false,
        clickCount: 15,
        scanStatus: 'safe',
        phishingDetected: false,
        createdAt: '2026-11-04T00:00:00Z',
        updatedAt: '2026-11-04T00:00:00Z'
      },
      {
        linkItemId: 'item-2',
        pageId: 'page-001',
        workspaceId: 'ws-001',
        linkType: 'custom',
        title: 'Urgent Account Verification',
        url: 'https://steal-login.phishing.io',
        position: 1,
        isActive: false,
        isPinned: false,
        clickCount: 0,
        scanStatus: 'phishing',
        phishingDetected: true,
        createdAt: '2026-11-04T00:00:00Z',
        updatedAt: '2026-11-04T00:00:00Z'
      }
    ];

    // Acceptance Target 2: Phishing CANNOT be acknowledged away!
    // Even if user clicks AUP acknowledge checkbox (true), publishing must fail
    const attemptWithAUP = canPublishBioPage(dummyPage, itemsWithPhishing, true);
    expect(attemptWithAUP.allowed).toBe(false);
    expect(attemptWithAUP.reason).toContain('confirmed phishing threat');
    expect(attemptWithAUP.reason).toContain('AUP acknowledgment cannot bypass');

    // Removing phishing link allows publication
    const cleanItems = itemsWithPhishing.filter((it) => !it.phishingDetected);
    const cleanPublish = canPublishBioPage(dummyPage, cleanItems, false);
    expect(cleanPublish.allowed).toBe(true);
  });
});

describe('Creator Pro - Target 3: Zero-View RPM Undefined Representation', () => {
  it('represents zero-view RPM as strictly undefined', () => {
    const zeroView = computeRPM(0, 500000);
    expect(zeroView.rpmIsUndefined).toBe(true);
    expect(zeroView.rpm).toBe(0);
    expect(zeroView.formatted).toContain('undefined');

    const negativeView = computeRPM(-10, 500000);
    expect(negativeView.rpmIsUndefined).toBe(true);
    expect(negativeView.rpm).toBe(0);
  });

  it('accurately calculates RPM when views are non-zero', () => {
    // 20,000 views, 1,000,000 VND revenue => RPM = 1,000,000 / 20 = 50,000 VND
    const normal = computeRPM(20000, 1000000);
    expect(normal.rpmIsUndefined).toBe(false);
    expect(normal.rpm).toBe(50000);
  });

  it('triggers drop alert on > 20% RPM decline only when both periods are defined', () => {
    // Period 1: 100,000 VND, Period 2: 70,000 VND (-30% drop > 20%)
    const prev = { rpm: 100000, isUndefined: false };
    const curr = { rpm: 70000, isUndefined: false };

    const alert = checkRPMDropAlert(prev, curr, 20.0);
    expect(alert.alertTriggered).toBe(true);
    expect(alert.changePercent).toBe(-30);

    // Period 2: 85,000 VND (-15% drop <= 20% threshold)
    const smallDrop = checkRPMDropAlert(prev, { rpm: 85000, isUndefined: false }, 20.0);
    expect(smallDrop.alertTriggered).toBe(false);

    // Undefined period does not trigger alert
    const undefPrev = checkRPMDropAlert({ rpm: 0, isUndefined: true }, curr, 20.0);
    expect(undefPrev.alertTriggered).toBe(false);
  });
});

describe('Creator Pro - Target 4: All Six Modes Can Reach Entitled Tools', () => {
  const modes: WorkspaceMode[] = [
    'creator',
    'seller',
    'agency',
    'affiliate',
    'brand_collab',
    'live_operator'
  ];

  const tools: CreatorProTool[] = [
    'bio_pages',
    'media_kits',
    'rate_cards',
    'brand_deals',
    'content_roi',
    'tax_reports'
  ];

  it('provides entitled tool access across all six modes', () => {
    for (const mode of modes) {
      const entitled = getEntitledTools(mode);
      expect(entitled.length).toBeGreaterThan(0);
      for (const t of entitled) {
        expect(isToolEntitledForMode(mode, t)).toBe(true);
      }
    }
  });

  it('verifies exact mode entitlements per S16 §8.2', () => {
    // Creator mode has all 6 tools
    expect(getEntitledTools('creator').length).toBe(6);

    // Seller mode has rate_cards, brand_deals, content_roi
    expect(isToolEntitledForMode('seller', 'rate_cards')).toBe(true);
    expect(isToolEntitledForMode('seller', 'brand_deals')).toBe(true);
    expect(isToolEntitledForMode('seller', 'content_roi')).toBe(true);
    expect(isToolEntitledForMode('seller', 'bio_pages')).toBe(false);

    // Agency mode has all 6 tools for managing creators
    expect(getEntitledTools('agency').length).toBe(6);

    // Affiliate mode has bio_pages, content_roi, tax_reports
    expect(isToolEntitledForMode('affiliate', 'bio_pages')).toBe(true);
    expect(isToolEntitledForMode('affiliate', 'content_roi')).toBe(true);
    expect(isToolEntitledForMode('affiliate', 'tax_reports')).toBe(true);
    expect(isToolEntitledForMode('affiliate', 'rate_cards')).toBe(false);

    // Brand collab mode has media_kits, rate_cards, brand_deals
    expect(isToolEntitledForMode('brand_collab', 'media_kits')).toBe(true);
    expect(isToolEntitledForMode('brand_collab', 'rate_cards')).toBe(true);
    expect(isToolEntitledForMode('brand_collab', 'brand_deals')).toBe(true);
    expect(isToolEntitledForMode('brand_collab', 'tax_reports')).toBe(false);

    // Live operator mode has bio_pages, content_roi
    expect(isToolEntitledForMode('live_operator', 'bio_pages')).toBe(true);
    expect(isToolEntitledForMode('live_operator', 'content_roi')).toBe(true);
    expect(isToolEntitledForMode('live_operator', 'media_kits')).toBe(false);
  });
});
