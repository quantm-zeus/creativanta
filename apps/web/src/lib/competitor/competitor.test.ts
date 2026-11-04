import { describe, it, expect } from 'vitest';
import {
  evaluateStaleness,
  getCompetitorRevenueGuard,
  validateNonConflationWithFinance,
  generateBenchmarkWhyExplanation,
  formatCompactNumber,
  formatPercent,
  buildComparativeMetricsTable,
  filterAndSearchCompetitors,
  evaluateContinuousMonitoringAlert,
  type CompetitorItem
} from './index';

describe('Competitor Registry & Benchmark (M03) Web Unit Tests', () => {
  // --------------------------------------------------------------------------
  // Acceptance Target 1: Inferred Insight Labeled (RULE-M03-001, RULE-M03-002, AC 1)
  // --------------------------------------------------------------------------
  describe('Acceptance Target 1: Inferred Insight Labeled & Why Drawer', () => {
    it('generates Why explanation containing data sources, limitations, and data gaps', () => {
      const why = generateBenchmarkWhyExplanation('Skincare Queen', 'TikTok', 30);

      expect(why.basisSummary).toContain('suy luận (INFERRED)');
      expect(why.basisSummary).toContain('Skincare Queen');
      expect(why.basisSummary).toContain('TikTok');

      // Invariant RULE-M03-002: Must contain all 3 sections
      expect(why.dataSources.length).toBeGreaterThan(0);
      expect(why.dataSources[0]).toContain('TikTok');

      expect(why.limitations.length).toBeGreaterThan(0);
      expect(why.limitations.some((l) => l.includes('Dark Posts') || l.includes('xóa'))).toBe(true);

      expect(why.dataGaps.length).toBeGreaterThan(0);
      expect(why.dataGaps.some((g) => g.includes('GMV') || g.includes('chuyển đổi'))).toBe(true);
    });
  });

  // --------------------------------------------------------------------------
  // Acceptance Target 2: Stale Snapshots Visible (RULE-M03-004, AC 2)
  // --------------------------------------------------------------------------
  describe('Acceptance Target 2: Stale Snapshots Visible', () => {
    const mockNow = new Date('2026-11-03T00:00:00Z');

    it('identifies snapshots older than 30 days as stale with warning badge text', () => {
      const captured45DaysAgo = new Date('2026-09-19T00:00:00Z');
      const result = evaluateStaleness(captured45DaysAgo, mockNow);

      expect(result.isStale).toBe(true);
      expect(result.daysOld).toBe(45);
      expect(result.staleWarning).toContain('45 ngày trước');
      expect(result.staleWarning).toContain('vượt ngưỡng 30 ngày');
      expect(result.staleWarning).toContain('Làm mới dữ liệu');
    });

    it('treats recent snapshots (<= 30 days) as fresh with no warning', () => {
      const captured7DaysAgo = new Date('2026-10-27T00:00:00Z');
      const result = evaluateStaleness(captured7DaysAgo, mockNow);

      expect(result.isStale).toBe(false);
      expect(result.daysOld).toBe(7);
      expect(result.staleWarning).toBe('');
    });

    it('handles exact 30-day boundary correctly', () => {
      const captured30DaysAgo = new Date('2026-10-04T00:00:00Z');
      const result = evaluateStaleness(captured30DaysAgo, mockNow);

      expect(result.isStale).toBe(false);
      expect(result.daysOld).toBe(30);
    });
  });

  // --------------------------------------------------------------------------
  // Acceptance Target 3: No Assumed Access to Competitor Finance (RULE-M03-003, EC-M03-002, AC 4)
  // --------------------------------------------------------------------------
  describe('Acceptance Target 3: Financial Non-Conflation Guard', () => {
    it('returns strictly private guard for competitor revenue', () => {
      const guard = getCompetitorRevenueGuard();

      expect(guard.status).toBe('PRIVATE_NOT_COMPARED');
      expect(guard.displayValue).toBe('—');
      expect(guard.isConflationBlocked).toBe(true);
      expect(guard.tooltip).toContain('bảo mật và tách biệt');
      expect(guard.tooltip).toContain('M19');
    });

    it('strictly rejects feeding inferred/estimated data into operating ledger or accounting', () => {
      const resLedger = validateNonConflationWithFinance('inferred', 'operating_ledger');
      expect(resLedger.valid).toBe(false);
      expect(resLedger.error).toContain('RULE-M03-003');
      expect(resLedger.error).toContain('operating_ledger');

      const resCogs = validateNonConflationWithFinance('estimated', 'cogs');
      expect(resCogs.valid).toBe(false);
      expect(resCogs.error).toContain('cogs');

      const resJournal = validateNonConflationWithFinance('inferred', 'accounting_journal');
      expect(resJournal.valid).toBe(false);

      // Non-financial operational domains are permitted
      const resOpportunity = validateNonConflationWithFinance('inferred', 'content_calendar');
      expect(resOpportunity.valid).toBe(true);
    });
  });

  // --------------------------------------------------------------------------
  // Comparative Table & Formatter Tests
  // --------------------------------------------------------------------------
  describe('Comparative Metrics Table Construction', () => {
    const you = {
      name: 'Bạn (Kênh của tôi)',
      handle: '@my_brand',
      followers: 125000,
      growth30d: 8.5,
      engagementRate: 9.8,
      avgViews: 45000,
      postsPerWeek: 14
    };

    const competitors = [
      {
        id: 'comp-1',
        name: 'Skincare Queen',
        handle: '@skincare_queen',
        followers: 245000,
        growth30d: 12.0,
        engagementRate: 7.2,
        avgViews: 120000,
        postsPerWeek: 10
      },
      {
        id: 'comp-2',
        name: 'Beauty Guru',
        handle: '@beauty_guru',
        followers: 80000,
        growth30d: 4.1,
        engagementRate: 6.5,
        avgViews: 25000,
        postsPerWeek: 7
      }
    ];

    it('builds table rows with accurate leader badges and compact formatting', () => {
      const rows = buildComparativeMetricsTable(you, competitors);

      expect(rows.length).toBe(6);

      // Followers row
      const followersRow = rows.find((r) => r.metricKey === 'followers');
      expect(followersRow).toBeDefined();
      expect(followersRow!.you.formattedValue).toBe('125K');
      expect(followersRow!.competitors['comp-1'].formattedValue).toBe('245K');
      expect(followersRow!.competitors['comp-1'].isLeader).toBe(true);
      expect(followersRow!.you.isLeader).toBe(false);

      // Engagement row — You are the leader!
      const engRow = rows.find((r) => r.metricKey === 'engagement');
      expect(engRow).toBeDefined();
      expect(engRow!.you.isLeader).toBe(true);
      expect(engRow!.competitors['comp-1'].isLeader).toBe(false);

      // Revenue row — Strictly guarded with display value '—'
      const revRow = rows.find((r) => r.metricKey === 'revenue');
      expect(revRow).toBeDefined();
      expect(revRow!.isPrivateRevenueGuard).toBe(true);
      expect(revRow!.competitors['comp-1'].formattedValue).toBe('—');
      expect(revRow!.competitors['comp-2'].formattedValue).toBe('—');
      expect(revRow!.marketAvg).toBe('Không so sánh');
    });

    it('formats compact numbers properly', () => {
      expect(formatCompactNumber(245000)).toBe('245K');
      expect(formatCompactNumber(1250000)).toBe('1.3M');
      expect(formatCompactNumber(1000000)).toBe('1M');
      expect(formatCompactNumber(850)).toBe('850');
    });

    it('formats percent values with sign', () => {
      expect(formatPercent(12.5)).toBe('+12.5%');
      expect(formatPercent(-3.2)).toBe('-3.2%');
    });
  });

  // --------------------------------------------------------------------------
  // Competitor Search & Filtering
  // --------------------------------------------------------------------------
  describe('Competitor Search and Filter', () => {
    const list: CompetitorItem[] = [
      {
        id: 'c1',
        workspaceId: 'ws-1',
        name: 'Skincare Queen',
        platform: 'TikTok',
        handle: '@skincare_queen',
        category: 'Làm đẹp / Skincare',
        notes: 'Chuyên serum và kem dưỡng ẩm',
        relevanceScore: 92,
        relevanceReason: 'Cùng phân khúc',
        followersCount: 245000,
        videoCount30d: 35,
        avgViews: 85000,
        growthRate30d: 12,
        avgEngagementRate: 8.5,
        postingFrequencyPerDay: 1.2,
        lastPostAt: '2026-11-02T10:00:00Z',
        status: 'tracking'
      },
      {
        id: 'c2',
        workspaceId: 'ws-1',
        name: 'Tech Reviewer VN',
        platform: 'YouTube',
        handle: '@tech_reviewer',
        category: 'Công nghệ / Gadgets',
        notes: 'Review tai nghe và laptop',
        relevanceScore: 45,
        relevanceReason: 'Khác ngành hàng',
        followersCount: 150000,
        videoCount30d: 12,
        avgViews: 95000,
        growthRate30d: 5,
        avgEngagementRate: 4.2,
        postingFrequencyPerDay: 0.4,
        lastPostAt: '2026-11-01T15:00:00Z',
        status: 'tracking'
      }
    ];

    it('filters by platform', () => {
      const tiktokOnly = filterAndSearchCompetitors(list, { platform: 'TikTok' });
      expect(tiktokOnly.length).toBe(1);
      expect(tiktokOnly[0].id).toBe('c1');

      const youtubeOnly = filterAndSearchCompetitors(list, { platform: 'YouTube' });
      expect(youtubeOnly.length).toBe(1);
      expect(youtubeOnly[0].id).toBe('c2');
    });

    it('searches by query matching name, handle, or notes', () => {
      const byHandle = filterAndSearchCompetitors(list, { query: 'skincare_queen' });
      expect(byHandle.length).toBe(1);
      expect(byHandle[0].id).toBe('c1');

      const byNote = filterAndSearchCompetitors(list, { query: 'tai nghe' });
      expect(byNote.length).toBe(1);
      expect(byNote[0].id).toBe('c2');

      const noMatch = filterAndSearchCompetitors(list, { query: 'không_tồn_tại' });
      expect(noMatch.length).toBe(0);
    });
  });

  // --------------------------------------------------------------------------
  // P8-07 Acceptance Target 1: Continuous Monitoring Alerts & Source Status
  // --------------------------------------------------------------------------
  describe('P8-07 Target 1: Continuous Monitoring Alerts', () => {
    const baseConfig = {
      competitorId: 'comp-101',
      metric: 'growth_rate',
      thresholdPercent: 20.0,
      sourceStatus: 'ACTIVE' as const,
      recoveryLatched: false,
      insufficientData: false
    };

    it('Target 1: No source access routes to paused/import path without false drop alarms', () => {
      // Source is unavailable (e.g. connector disconnected or token expired)
      const res = evaluateContinuousMonitoringAlert(
        baseConfig,
        100000,
        50000,
        'snap-new-01',
        false // sourceAvailable = false
      );

      expect(res.alertTriggered).toBe(false);
      expect(res.sourceStatus).toBe('PAUSED');
      expect(res.sourceStatusReason).toContain('paused until reconnected or manual export imported');
      expect(res.reason).toContain('Monitoring paused');
    });

    it('Target 1: Missing or zero denominator marks insufficient data instead of false alarm', () => {
      // Denominator is 0
      const resZero = evaluateContinuousMonitoringAlert(
        baseConfig,
        0,
        5000,
        'snap-new-02',
        true
      );
      expect(resZero.alertTriggered).toBe(false);
      expect(resZero.insufficientData).toBe(true);

      // Denominator is null/undefined
      const resNull = evaluateContinuousMonitoringAlert(
        baseConfig,
        null,
        5000,
        'snap-new-03',
        true
      );
      expect(resNull.alertTriggered).toBe(false);
      expect(resNull.insufficientData).toBe(true);
    });

    it('Target 1: Triggers alert when metric drops beyond threshold on valid data', () => {
      // 100 -> 70 is -30% drop (threshold is 20%)
      const res = evaluateContinuousMonitoringAlert(
        baseConfig,
        100,
        70,
        'snap-new-04',
        true
      );
      expect(res.alertTriggered).toBe(true);
      expect(res.recoveryLatched).toBe(true);
      expect(res.changePercent).toBe(-30);
      expect(res.newSnapshotId).toBe('snap-new-04');
    });

    it('Target 1: Deduplicates on identical snapshot ID', () => {
      const configWithPrevAlert = {
        ...baseConfig,
        lastAlertSnapshotId: 'snap-already-alerted'
      };
      const res = evaluateContinuousMonitoringAlert(
        configWithPrevAlert,
        100,
        50,
        'snap-already-alerted',
        true
      );
      expect(res.alertTriggered).toBe(false);
      expect(res.reason).toContain('already recorded');
    });

    it('Target 1: Latches alert until metric recovers back above threshold', () => {
      const latchedConfig = {
        ...baseConfig,
        recoveryLatched: true
      };
      // Still dropped (-25%), latched suppresses secondary alert
      const resLatched = evaluateContinuousMonitoringAlert(
        latchedConfig,
        100,
        75,
        'snap-new-05',
        true
      );
      expect(resLatched.alertTriggered).toBe(false);
      expect(resLatched.recoveryLatched).toBe(true);

      // Metric recovers (100 -> 95 is -5%, well above -20% threshold)
      const resRecovered = evaluateContinuousMonitoringAlert(
        latchedConfig,
        100,
        95,
        'snap-new-06',
        true
      );
      expect(resRecovered.alertTriggered).toBe(false);
      expect(resRecovered.recoveryLatched).toBe(false); // Latch reset!
    });
  });
});
