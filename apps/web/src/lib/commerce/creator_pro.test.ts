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
  type CreatorProTool,
  type BrandDeal,
  organizeDealsIntoKanban,
  validateOptimisticKanbanMove,
  attachContractToDeal,
  filterCreatorDirectory,
  getCreatorDirectoryProfile,
  submitSponsorInquiry,
  type CreatorDirectoryEntry
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

describe('Creator Pro - P8-07: Deal Kanban & Optimistic Concurrency', () => {
  const sampleDeals: BrandDeal[] = [
    {
      dealId: 'deal-1',
      workspaceId: 'ws-test',
      brandName: 'Brand Alpha',
      dealType: 'sponsored_post',
      value: 10000000,
      currency: 'VND',
      status: 'negotiating',
      contractEvidenceIds: [],
      createdAt: '2026-11-01T10:00:00Z',
      updatedAt: '2026-11-01T10:00:00Z'
    },
    {
      dealId: 'deal-2',
      workspaceId: 'ws-test',
      brandName: 'Brand Beta',
      dealType: 'ugc_creation',
      value: 20000000,
      currency: 'VND',
      status: 'agreed',
      contractEvidenceIds: ['ev-deal2-v1'],
      createdAt: '2026-11-02T10:00:00Z',
      updatedAt: '2026-11-02T10:00:00Z'
    }
  ];

  it('organizes deals into kanban stage columns', () => {
    const columns = organizeDealsIntoKanban(sampleDeals);
    expect(columns.length).toBe(6);
    expect(columns[0].status).toBe('negotiating');
    expect(columns[0].deals.length).toBe(1);
    expect(columns[0].deals[0].dealId).toBe('deal-1');

    expect(columns[1].status).toBe('agreed');
    expect(columns[1].deals.length).toBe(1);
    expect(columns[1].deals[0].dealId).toBe('deal-2');

    expect(columns[2].status).toBe('in_progress');
    expect(columns[2].deals.length).toBe(0);
  });

  it('enforces optimistic concurrency validation on kanban move', () => {
    const deal = sampleDeals[0]; // status: negotiating, updatedAt: '2026-11-01T10:00:00Z'

    // Valid move with matching expectedUpdatedAt
    const validMove = validateOptimisticKanbanMove(deal, '2026-11-01T10:00:00Z', 'agreed');
    expect(validMove.valid).toBe(true);

    // Stale move with mismatched expectedUpdatedAt (concurrent edit detected)
    const staleMove = validateOptimisticKanbanMove(deal, '2026-11-01T09:00:00Z', 'agreed');
    expect(staleMove.valid).toBe(false);
    expect(staleMove.error).toContain('modified concurrently');

    // Invalid transition (skipping state)
    const invalidTransition = validateOptimisticKanbanMove(deal, '2026-11-01T10:00:00Z', 'delivered');
    expect(invalidTransition.valid).toBe(false);
    expect(invalidTransition.error).toContain('canonical sequence');
  });
});

describe('Creator Pro - P8-07: Immutable Contract Templates (Target 4)', () => {
  const deal: BrandDeal = {
    dealId: 'deal-legal-1',
    workspaceId: 'ws-legal',
    brandName: 'Cosmetics Co',
    dealType: 'sponsored_post',
    value: 12000000,
    currency: 'VND',
    status: 'agreed',
    contractEvidenceIds: ['ev-tmpl-v1'],
    createdAt: '2026-11-03T10:00:00Z',
    updatedAt: '2026-11-03T10:00:00Z'
  };

  it('attaches new immutable contract version evidence', () => {
    const res = attachContractToDeal(deal, 'ev-tmpl-v2');
    expect(res.success).toBe(true);
    expect(res.deal).toBeDefined();
    expect(res.deal?.contractEvidenceIds).toEqual(['ev-tmpl-v1', 'ev-tmpl-v2']);
  });

  it('rejects duplicate or overwrite of identical version evidence', () => {
    const res = attachContractToDeal(deal, 'ev-tmpl-v1');
    expect(res.success).toBe(false);
    expect(res.error).toContain('immutable');
  });

  it('rejects empty evidence ID', () => {
    const res = attachContractToDeal(deal, '   ');
    expect(res.success).toBe(false);
    expect(res.error).toContain('cannot be empty');
  });
});

describe('Creator Pro - P8-07: Public Creator Directory & Inquiries (Targets 2 & 3)', () => {
  const directoryEntries: CreatorDirectoryEntry[] = [
    {
      mediaKitId: 'mk-published-01',
      profile: {
        creatorName: 'Lan Anh Review',
        headline: 'Beauty & Skincare Creator',
        bio: 'Chuyên đánh giá mỹ phẩm và chăm sóc da khoa học',
        categories: ['beauty', 'skincare'],
        languages: ['vi', 'en'],
        publicRates: [
          {
            serviceType: 'Tiktok Video 60s',
            priceMin: 5000000,
            priceMax: 8000000,
            currency: 'VND',
            deliveryDays: 5
          }
        ],
        socialMetrics: [
          {
            platform: 'TikTok',
            handle: '@lananh.skincare',
            followers: 250000,
            avgViews: 85000,
            engagementRate: 6.8,
            verified: true
          }
        ],
        directoryStatus: 'published',
        directoryOptIn: true
      },
      verifiedBadge: true,
      lastActiveAt: '2026-11-04T12:00:00Z'
    },
    {
      mediaKitId: 'mk-opted-out-02',
      profile: {
        creatorName: 'Minh Tech',
        headline: 'Consumer Tech Reviewer',
        bio: 'Đánh giá đồ công nghệ chi tiết',
        categories: ['tech', 'gadgets'],
        languages: ['vi'],
        publicRates: [],
        socialMetrics: [],
        directoryStatus: 'hidden',
        directoryOptIn: false
      },
      verifiedBadge: false,
      lastActiveAt: '2026-11-01T12:00:00Z'
    }
  ];

  it('Target 2: Filters search to show only published and opted-in creators', () => {
    const results = filterCreatorDirectory(directoryEntries);
    expect(results.length).toBe(1);
    expect(results[0].mediaKitId).toBe('mk-published-01');
  });

  it('Target 2: Opt-out removes creator immediately from search and direct lookup', () => {
    // When opted-out creator is queried by category
    const techSearch = filterCreatorDirectory(directoryEntries, { category: 'tech' });
    expect(techSearch.length).toBe(0);

    // Direct lookup fails closed
    const directLookup = getCreatorDirectoryProfile(directoryEntries, 'mk-opted-out-02');
    expect(directLookup).toBeNull();
  });

  it('Target 3: Public profile does not expose private workspace fields', () => {
    const entry = getCreatorDirectoryProfile(directoryEntries, 'mk-published-01');
    expect(entry).not.toBeNull();
    // Verify private workspace IDs or CRM deal info are absent
    expect((entry as any).workspaceId).toBeUndefined();
    expect((entry as any).internalNotes).toBeUndefined();
    expect((entry as any).revenueSummary).toBeUndefined();
  });

  it('submits sponsor inquiry and generates opaque receipt', () => {
    const entry = getCreatorDirectoryProfile(directoryEntries, 'mk-published-01')!;
    const res = submitSponsorInquiry(entry, {
      mediaKitId: entry.mediaKitId,
      brandName: 'Cosmetics Brand Vietnam',
      contactEmail: 'contact@cosmeticsbrand.vn',
      message: 'Chúng tôi muốn hợp tác video giới thiệu bộ sản phẩm dưỡng ẩm mùa đông.',
      estimatedBudget: 7000000
    });

    expect(res.success).toBe(true);
    expect(res.receipt).toBeDefined();
    expect(res.receipt?.receiptId).toMatch(/^rcpt-/);
    expect(res.receipt?.status).toBe('received');
  });

  it('fails closed when submitting inquiry to opted-out or hidden creator', () => {
    const hiddenEntry = directoryEntries[1]; // directoryOptIn: false
    const res = submitSponsorInquiry(hiddenEntry, {
      mediaKitId: hiddenEntry.mediaKitId,
      brandName: 'Brand X',
      contactEmail: 'x@brand.com',
      message: 'Hợp tác chiến dịch mới...',
      estimatedBudget: 10000000
    });

    expect(res.success).toBe(false);
    expect(res.error).toContain('unavailable');
  });
});
