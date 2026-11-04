import { describe, expect, it } from 'vitest';
import { get } from 'svelte/store';
import {
  helpStore,
  filteredArticles,
  staleArticles,
  lowRatingArticles,
  isArticleStale,
  KB_CATEGORIES,
  KB_ARTICLES,
  betaStore,
  statusStore,
  CANONICAL_STATUS_COMPONENTS,
  supportStore,
  calculateSupportSLA,
  filterMessagesForWorkspace,
  announcementStore,
  CANONICAL_ANNOUNCEMENTS,
  type SupportMessageItem
} from './store';

describe('Contextual Help Center & Knowledge Base (docs/02_features/platform/help_center.md)', () => {
  it('defines knowledge base categories and seed articles', () => {
    expect(KB_CATEGORIES.length).toBeGreaterThanOrEqual(4);
    expect(KB_ARTICLES.length).toBeGreaterThanOrEqual(5);

    const slugs = KB_ARTICLES.map((a) => a.slug);
    expect(slugs).toContain('6-operator-modes-guide');
    expect(slugs).toContain('understanding-why-this-number');
    expect(slugs).toContain('reconnect-tiktok-shop-channel');
  });

  it('filters articles by search query', () => {
    helpStore.searchQuery.set('TikTok');

    const results = get(filteredArticles);
    expect(results.length).toBeGreaterThanOrEqual(1);
    expect(results.some((a) => a.title.includes('TikTok') || a.summary.includes('TikTok'))).toBe(true);

    helpStore.searchQuery.set('');
  });

  it('filters articles by active module', () => {
    helpStore.activeModuleFilter.set('M11');

    const results = get(filteredArticles);
    expect(results.length).toBeGreaterThanOrEqual(1);
    expect(results.every((a) => a.moduleRef.includes('M11') || a.moduleRef === 'help')).toBe(true);

    helpStore.activeModuleFilter.set(null);
  });

  it('records helpful and unhelpful article ratings', () => {
    const article = KB_ARTICLES[0];
    const initialHelpful = article.helpfulVotes;

    helpStore.rateArticle(article.id, true);

    const ratings = get(helpStore.userRatings);
    expect(ratings[article.id]).toBe(true);

    const articles = get(helpStore.articles);
    const updated = articles.find((a) => a.id === article.id);
    expect(updated?.helpfulVotes).toBe(initialHelpful + 1);
  });

  // ---------------------------------------------------------------------------
  // ACCEPTANCE TARGET 1: Stale Article Review & Quality Rewrite Queue
  // ---------------------------------------------------------------------------
  it('detects stale articles unreviewed in >90 days (§2.4)', () => {
    const staleList = get(staleArticles);
    expect(staleList.length).toBeGreaterThanOrEqual(1);

    const art3 = staleList.find((a) => a.id === 'art-003');
    expect(art3).toBeDefined();
    expect(art3?.slug).toBe('reconnect-tiktok-shop-channel');
  });

  it('detects low-rating articles (<60% helpful) for priority rewrite (§2.4)', () => {
    const lowList = get(lowRatingArticles);
    expect(lowList.length).toBeGreaterThanOrEqual(1);

    const art6 = lowList.find((a) => a.id === 'art-006');
    expect(art6).toBeDefined();
    const ratio = art6!.helpfulVotes / (art6!.helpfulVotes + art6!.unhelpfulVotes);
    expect(ratio).toBeLessThan(0.6);
  });

  it('completes stale article review and clears stale status', () => {
    const artId = 'art-003';
    helpStore.reviewArticle(artId, 'admin-support-01', 'Đã cập nhật hướng dẫn kết nối TikTok Shop 2026.');

    const articles = get(helpStore.articles);
    const reviewed = articles.find((a) => a.id === artId);
    expect(reviewed?.lastReviewedBy).toBe('admin-support-01');
    expect(reviewed?.reviewNotes).toBe('Đã cập nhật hướng dẫn kết nối TikTok Shop 2026.');
    expect(isArticleStale(reviewed!, Date.now())).toBe(false);
  });
});

describe('Beta Program ("Beta grant once" — docs/02_features/platform/help_center.md §4)', () => {
  it('rejects Free tier users from Beta program', () => {
    expect(() => betaStore.enroll('ws-free', 'free')).toThrow(/Gói Free không đủ điều kiện/);
  });

  it('grants 50 credits once on first enrollment, and 0 credits on re-enrollment', () => {
    const wsId = 'ws-beta-creator-99';

    // 1. Initial enrollment -> 50 bonus credits awarded
    const res1 = betaStore.enroll(wsId, 'starter');
    expect(res1.success).toBe(true);
    expect(res1.creditsAwarded).toBe(50);

    const enrollments = get(betaStore.enrollments);
    expect(enrollments[wsId]?.status).toBe('active');
    expect(enrollments[wsId]?.bonusCreditsGranted).toBe(true);

    // 2. Opt-out
    betaStore.optOut(wsId);
    const afterOptOut = get(betaStore.enrollments);
    expect(afterOptOut[wsId]?.status).toBe('opted_out');
    expect(afterOptOut[wsId]?.enabledFlags.length).toBe(0);

    // 3. Re-enrollment (ACCEPTANCE TARGET 2: "Beta grant once")
    const res2 = betaStore.enroll(wsId, 'pro');
    expect(res2.success).toBe(true);
    expect(res2.creditsAwarded).toBe(0); // 0 credits on re-enrollment!

    const afterReEnroll = get(betaStore.enrollments);
    expect(afterReEnroll[wsId]?.status).toBe('active');
    expect(afterReEnroll[wsId]?.enabledFlags.length).toBeGreaterThan(0);
  });

  it('validates feedback rating range 1-5', () => {
    expect(() => betaStore.submitFeedback('beta_video', 0, 'Too low', false)).toThrow(/1 đến 5 sao/);
    expect(() => betaStore.submitFeedback('beta_video', 6, 'Too high', false)).toThrow(/1 đến 5 sao/);

    betaStore.submitFeedback('beta_video', 5, 'Rất hữu ích', false);
    const feedbacks = get(betaStore.feedbacks);
    expect(feedbacks[0].rating).toBe(5);
  });
});

describe('Public Status Page & Subscription Privacy (docs/02_features/platform/help_center.md §5)', () => {
  it('exposes all 8 monitored components per §5.1', () => {
    expect(CANONICAL_STATUS_COMPONENTS.length).toBe(8);
    const ids = CANONICAL_STATUS_COMPONENTS.map((c) => c.id);
    expect(ids).toContain('web_app');
    expect(ids).toContain('mobile_backend');
    expect(ids).toContain('public_api');
    expect(ids).toContain('database');
    expect(ids).toContain('ai_services');
    expect(ids).toContain('platform_connectors');
    expect(ids).toContain('payment_processing');
    expect(ids).toContain('notification_delivery');
  });

  it('enforces subscription privacy and management token lifecycle (§5.4)', () => {
    const email = 'secret-subscriber@agency.com';
    const initCount = get(statusStore.subscriberCount);

    const sub = statusStore.subscribe('email', email);
    expect(sub.privacyToken).toMatch(/^tok_priv_/);
    expect(get(statusStore.subscriberCount)).toBe(initCount + 1);

    // Unsubscribe with token
    const unsub = statusStore.unsubscribe(sub.privacyToken);
    expect(unsub).toBe(true);
    expect(get(statusStore.subscriberCount)).toBe(initCount);

    // Bogus token rejected
    expect(() => statusStore.unsubscribe('invalid-token')).toThrow(/Mã token hủy đăng ký không hợp lệ/);
  });
});

describe('Customer Support SLAs & Internal Note Isolation (legal_compliance.md §7)', () => {
  it('calculates plan-based SLAs accurately per §7.2', () => {
    expect(calculateSupportSLA('free')).toEqual({ responseHours: 48, resolutionHours: 120 });
    expect(calculateSupportSLA('starter')).toEqual({ responseHours: 24, resolutionHours: 72 });
    expect(calculateSupportSLA('pro')).toEqual({ responseHours: 8, resolutionHours: 24 });
    expect(calculateSupportSLA('business')).toEqual({ responseHours: 2, resolutionHours: 8 });
    expect(calculateSupportSLA('enterprise')).toEqual({ responseHours: 1, resolutionHours: 4 });
  });

  it('filters out internal admin notes from creator/workspace messages', () => {
    const rawMessages: SupportMessageItem[] = [
      {
        id: 'm1',
        ticketId: 'tk-1',
        authorType: 'user',
        body: 'Em không kết nối được TikTok Shop',
        isInternalNote: false,
        createdAt: '2026-11-04T10:00:00Z'
      },
      {
        id: 'm2',
        ticketId: 'tk-1',
        authorType: 'admin',
        body: '[NỘI BỘ] User này bị lỗi token do IP nhảy vùng, kiểm tra auth service',
        isInternalNote: true, // INTERNAL NOTE
        createdAt: '2026-11-04T10:05:00Z'
      },
      {
        id: 'm3',
        ticketId: 'tk-1',
        authorType: 'admin',
        body: 'Chào bạn, đội ngũ kỹ thuật đang kiểm tra và sẽ phản hồi sớm nhất.',
        isInternalNote: false,
        createdAt: '2026-11-04T10:10:00Z'
      }
    ];

    const safeMessages = filterMessagesForWorkspace(rawMessages);
    expect(safeMessages.length).toBe(2);
    expect(safeMessages.some((m) => m.isInternalNote)).toBe(false);
    expect(safeMessages.some((m) => m.body.includes('[NỘI BỘ]'))).toBe(false);
  });

  it('records CSAT score (1-5) on ticket close (§7.1)', () => {
    const ticket = supportStore.createTicket('pro', 'Lỗi đối soát', 'high', 'Doanh thu bị lệch 500k');
    expect(ticket.responseDueMinutes).toBe(8 * 60);

    expect(() => supportStore.closeTicket(ticket.id, 0)).toThrow(/1 đến 5 sao/);
    supportStore.closeTicket(ticket.id, 5);

    const tickets = get(supportStore.tickets);
    const closed = tickets.find((t) => t.id === ticket.id);
    expect(closed?.status).toBe('closed');
    expect(closed?.csatScore).toBe(5);
  });
});

describe('In-App Announcement System (§3.2)', () => {
  it('enforces max 1 announcement per session', () => {
    const firstCall = announcementStore.getAnnouncementForSession('pro', 0, {});
    expect(firstCall).not.toBeNull();

    const secondCall = announcementStore.getAnnouncementForSession('pro', 1, {});
    expect(secondCall).toBeNull();
  });

  it('respects tier targeting and priority ranking', () => {
    // Pro user gets Pro feature launch modal (Priority 3 > 2)
    const proAnn = announcementStore.getAnnouncementForSession('pro', 0, {});
    expect(proAnn?.id).toBe('ann-pro-feature-02');

    // Free user gets general improvement banner
    const freeAnn = announcementStore.getAnnouncementForSession('free', 0, {});
    expect(freeAnn?.id).toBe('ann-speed-improvement-03');

    // Enterprise user gets breaking change blocking modal (Priority 4)
    const entAnn = announcementStore.getAnnouncementForSession('enterprise', 0, {});
    expect(entAnn?.id).toBe('ann-breaking-01');
  });

  it('does not re-display dismissed announcements', () => {
    const dismissed = { 'ann-pro-feature-02': true };
    const nextAnn = announcementStore.getAnnouncementForSession('pro', 0, dismissed);
    expect(nextAnn?.id).toBe('ann-speed-improvement-03');
  });
});
