import { describe, it, expect } from 'vitest';
import {
  calculateStrengthScore,
  evaluateSourceDegradation,
  generateAlertFingerprint,
  evaluateAndDeduplicateAlerts,
  searchAndFilterTrends,
  convertTrendToOpportunity,
  type TrendItem,
  type PlatformConnectionStatus,
  type AlertEvaluationInput
} from './index';

describe('Trend Fusion Radar (M02) Unit Tests', () => {
  describe('Multi-dimensional Scoring Formula (RULE-M02-002)', () => {
    it('calculates score accurately: 45% velocity + 35% freshness + 20% (100 - saturation)', () => {
      // 100 vel, 100 freshness, 0 saturation => 45 + 35 + 20 = 100
      expect(calculateStrengthScore(100, 100, 0)).toBe(100);

      // 0 vel, 0 freshness, 100 saturation => 0 + 0 + 0 = 0
      expect(calculateStrengthScore(0, 0, 100)).toBe(0);

      // 80 vel, 60 freshness, 30 saturation => 0.45*80 + 0.35*60 + 0.20*70 = 36 + 21 + 14 = 71
      expect(calculateStrengthScore(80, 60, 30)).toBe(71);

      // High saturation penalizes composite score:
      // 80 vel, 60 freshness, 90 saturation => 36 + 21 + 0.20*10 = 59
      expect(calculateStrengthScore(80, 60, 90)).toBe(59);
    });

    it('clamps values between 0 and 100 for outlier input', () => {
      expect(calculateStrengthScore(150, 200, -50)).toBe(100);
      expect(calculateStrengthScore(-50, -20, 200)).toBe(0);
    });
  });

  describe('Acceptance Target 1: Source Unavailable Shows Degraded Data', () => {
    const baseTrend: TrendItem = {
      id: 'trend-tiktok-01',
      workspaceId: 'ws-alpha',
      title: 'Review đồ gia dụng thông minh',
      category: 'Home & Living',
      platform: 'TikTok',
      velocity: 85,
      freshnessScore: 90,
      saturationScore: 25,
      strengthScore: 84.8,
      confidence: 'high',
      sourceClass: 'official',
      isDegraded: false,
      sampleSize: 450,
      signals: [],
      whyNow: 'Mùa giảm giá cuối năm kích thích nhu cầu mua sắm thiết bị gia đình',
      relevanceDescription: 'Tỷ lệ tương tác cao trong phân khúc gia đình trẻ',
      createdAt: new Date().toISOString()
    };

    it('marks trend as degraded, demotes confidence to low, and sets sourceClass to estimated when platform is disconnected', () => {
      const platformStatuses: PlatformConnectionStatus[] = [
        {
          platform: 'TikTok',
          label: 'TikTok Shop & Video',
          isConnected: false,
          statusNote: 'OAuth token hết hạn cần kết nối lại'
        },
        {
          platform: 'Shopee',
          label: 'Shopee Trends',
          isConnected: true,
          statusNote: 'Hoạt động bình thường'
        }
      ];

      const evaluated = evaluateSourceDegradation(baseTrend, platformStatuses);

      expect(evaluated.isDegraded).toBe(true);
      expect(evaluated.confidence).toBe('low');
      expect(evaluated.sourceClass).toBe('estimated');
      expect(evaluated.degradedReason).toContain('TikTok');
      expect(evaluated.degradedReason).toContain('ước tính lịch sử');
    });

    it('preserves official status and confidence when platform is connected', () => {
      const platformStatuses: PlatformConnectionStatus[] = [
        {
          platform: 'TikTok',
          label: 'TikTok Shop & Video',
          isConnected: true,
          statusNote: 'Kết nối ổn định'
        }
      ];

      const evaluated = evaluateSourceDegradation(baseTrend, platformStatuses);

      expect(evaluated.isDegraded).toBe(false);
      expect(evaluated.confidence).toBe('high');
      expect(evaluated.sourceClass).toBe('official');
      expect(evaluated.degradedReason).toBeUndefined();
    });
  });

  describe('Acceptance Target 2: Threshold Alerts Deduplicate and Batch Storms', () => {
    it('deduplicates identical breaches within cooldown window', () => {
      const initialFingerprints = new Map<string, number>();
      const now = Date.now();

      const breach1: AlertEvaluationInput = {
        workspaceId: 'ws-1',
        watchlistId: 'wl-1',
        trendId: 't-1',
        trendTitle: 'Xu hướng nồi chiên không dầu',
        metricName: 'velocity',
        thresholdValue: 70,
        actualValue: 88,
        timestampMs: now
      };

      // First breach passes
      const firstRun = evaluateAndDeduplicateAlerts([breach1], initialFingerprints, 60, now);
      expect(firstRun.emittedAlerts).toHaveLength(1);
      expect(firstRun.suppressedCount).toBe(0);

      // Identical breach 15 minutes later is suppressed (within 60-min cooldown)
      const secondRun = evaluateAndDeduplicateAlerts(
        [breach1],
        firstRun.updatedFingerprints,
        60,
        now + 15 * 60 * 1000
      );
      expect(secondRun.emittedAlerts).toHaveLength(0);
      expect(secondRun.suppressedCount).toBe(1);

      // Identical breach 65 minutes later passes (after cooldown expires)
      const thirdRun = evaluateAndDeduplicateAlerts(
        [breach1],
        firstRun.updatedFingerprints,
        60,
        now + 65 * 60 * 1000
      );
      expect(thirdRun.emittedAlerts).toHaveLength(1);
      expect(thirdRun.suppressedCount).toBe(0);
    });

    it('batches alert storms exceeding 5 simultaneous breaches into a summary alert (EC-M02-004)', () => {
      const now = Date.now();
      const breaches: AlertEvaluationInput[] = [];

      for (let i = 1; i <= 8; i++) {
        breaches.push({
          workspaceId: 'ws-1',
          watchlistId: 'wl-1',
          trendId: `t-storm-${i}`,
          trendTitle: `Bão xu hướng ${i}`,
          metricName: 'velocity',
          thresholdValue: 70,
          actualValue: 80 + i
        });
      }

      const result = evaluateAndDeduplicateAlerts(breaches, new Map(), 60, now);

      // Exactly 1 summary alert emitted
      expect(result.emittedAlerts).toHaveLength(1);
      const summary = result.emittedAlerts[0];
      expect(summary.isBatchedSummary).toBe(true);
      expect(summary.batchedAlertCount).toBe(8);
      expect(summary.trendTitle).toContain('8 xu hướng cùng lúc vượt ngưỡng');
    });
  });

  describe('Acceptance Target 3: Tenant-Scoped Semantic Search', () => {
    const mockTrends: TrendItem[] = [
      {
        id: 't-a1',
        workspaceId: 'ws-tenant-A',
        title: 'Cà phê muối đóng lon',
        category: 'Food & Cooking',
        platform: 'TikTok',
        velocity: 92,
        freshnessScore: 85,
        saturationScore: 30,
        strengthScore: 85.1,
        confidence: 'high',
        sourceClass: 'official',
        isDegraded: false,
        sampleSize: 850,
        signals: [],
        whyNow: 'Trend đồ uống đường phố chuyển dịch sang sản phẩm đóng gói tiện lợi',
        relevanceDescription: 'Phù hợp ngành F&B đóng gói',
        createdAt: '2026-11-01T10:00:00Z'
      },
      {
        id: 't-a2',
        workspaceId: 'ws-tenant-A',
        title: 'Serum phục hồi da rau má',
        category: 'Beauty',
        platform: 'Shopee',
        velocity: 78,
        freshnessScore: 80,
        saturationScore: 40,
        strengthScore: 75.1,
        confidence: 'medium_high',
        sourceClass: 'official',
        isDegraded: false,
        sampleSize: 620,
        signals: [],
        whyNow: 'Chuyển mùa hanh khô làm tăng nhu cầu chăm sóc da nhạy cảm',
        relevanceDescription: 'Mỹ phẩm thiên nhiên Việt Nam',
        createdAt: '2026-11-01T11:00:00Z'
      },
      {
        id: 't-b1',
        workspaceId: 'ws-tenant-B',
        title: 'Bàn phím cơ không dây giá rẻ',
        category: 'Tech & Gadgets',
        platform: 'YouTube',
        velocity: 95,
        freshnessScore: 90,
        saturationScore: 20,
        strengthScore: 90.25,
        confidence: 'high',
        sourceClass: 'official',
        isDegraded: false,
        sampleSize: 1200,
        signals: [],
        whyNow: 'Mùa tựu trường và setup góc làm việc',
        relevanceDescription: 'Sản phẩm công nghệ phổ thông',
        createdAt: '2026-11-01T12:00:00Z'
      }
    ];

    it('strictly isolates trends by tenant workspace, returning zero items from foreign tenant', () => {
      const resultsForA = searchAndFilterTrends(mockTrends, 'ws-tenant-A');
      expect(resultsForA).toHaveLength(2);
      expect(resultsForA.every((t) => t.workspaceId === 'ws-tenant-A')).toBe(true);

      const resultsForB = searchAndFilterTrends(mockTrends, 'ws-tenant-B');
      expect(resultsForB).toHaveLength(1);
      expect(resultsForB[0].id).toBe('t-b1');

      // Foreign workspace returns zero
      const resultsForC = searchAndFilterTrends(mockTrends, 'ws-tenant-C');
      expect(resultsForC).toHaveLength(0);
    });

    it('searches semantically across title, whyNow, and category', () => {
      const searchByWhy = searchAndFilterTrends(mockTrends, 'ws-tenant-A', {
        query: 'đóng gói'
      });
      expect(searchByWhy).toHaveLength(1);
      expect(searchByWhy[0].id).toBe('t-a1');

      const searchByCategory = searchAndFilterTrends(mockTrends, 'ws-tenant-A', {
        query: 'Beauty'
      });
      expect(searchByCategory).toHaveLength(1);
      expect(searchByCategory[0].id).toBe('t-a2');
    });

    it('filters by platform, minScore, and confidence band', () => {
      const filtered = searchAndFilterTrends(mockTrends, 'ws-tenant-A', {
        platform: 'TikTok',
        minScore: 80,
        confidence: 'high'
      });
      expect(filtered).toHaveLength(1);
      expect(filtered[0].id).toBe('t-a1');

      const noMatch = searchAndFilterTrends(mockTrends, 'ws-tenant-A', {
        platform: 'Shopee',
        minScore: 80 // t-a2 score is 75.1
      });
      expect(noMatch).toHaveLength(0);
    });
  });

  describe('Module M04 Opportunity Conversion', () => {
    it('creates valid opportunity draft from trend', () => {
      const trend: TrendItem = {
        id: 't-100',
        workspaceId: 'ws-main',
        title: 'Son dưỡng thuần chay',
        category: 'Beauty',
        platform: 'TikTok',
        velocity: 82,
        freshnessScore: 85,
        saturationScore: 35,
        strengthScore: 79.65,
        confidence: 'high',
        sourceClass: 'official',
        isDegraded: false,
        sampleSize: 450,
        signals: [],
        whyNow: 'Xu hướng mỹ phẩm an toàn',
        relevanceDescription: 'Mỹ phẩm phân khúc gen Z',
        createdAt: '2026-11-01T00:00:00Z'
      };

      const opp = convertTrendToOpportunity(trend, 'ws-main', 'user-01');
      expect(opp.opportunityId).toBe('opp-t-100');
      expect(opp.sourceTrendId).toBe('t-100');
      expect(opp.title).toContain('Son dưỡng thuần chay');
      expect(opp.initialStrengthScore).toBe(79.65);
      expect(opp.status).toBe('draft');
    });

    it('rejects cross-tenant opportunity conversion with error', () => {
      const trend: TrendItem = {
        id: 't-foreign',
        workspaceId: 'ws-foreign',
        title: 'Áo khoác gió oversize',
        category: 'Fashion',
        platform: 'Shopee',
        velocity: 70,
        freshnessScore: 60,
        saturationScore: 50,
        strengthScore: 62.5,
        confidence: 'medium',
        sourceClass: 'official',
        isDegraded: false,
        sampleSize: 300,
        signals: [],
        whyNow: 'Mùa thu đông',
        relevanceDescription: 'Thời trang đường phố',
        createdAt: '2026-11-01T00:00:00Z'
      };

      expect(() => convertTrendToOpportunity(trend, 'ws-different', 'user-01')).toThrow(
        /Tenant mismatch/
      );
    });
  });
});
