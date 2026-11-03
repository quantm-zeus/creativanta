/**
 * M03 Competitor Registry & Benchmark Module ($lib/competitor)
 *
 * Implements logic, invariants, and formatters for:
 * - RULE-M03-001: Every inferred insight MUST carry source_class = 'inferred'
 * - RULE-M03-002: Confidence band and Why explanation (sources, limitations, data gaps)
 * - RULE-M03-003: No assumed access to competitor finance (private "—" and non-conflation with M19)
 * - RULE-M03-004: Stale snapshots visible (>30 days warning badge and refresh CTA)
 */

export type SourceClass = 'inferred' | 'official' | 'estimated';
export type ConfidenceBand = 'high' | 'medium' | 'low';

export interface WhyExplanation {
  basisSummary: string;
  dataSources: string[];
  limitations: string[];
  dataGaps: string[];
}

export interface CompetitorItem {
  id: string;
  workspaceId: string;
  name: string;
  platform: 'TikTok' | 'Instagram' | 'YouTube' | 'Shopee';
  handle: string;
  category: string;
  notes?: string;
  relevanceScore: number;
  relevanceReason: string;
  followersCount: number;
  videoCount30d: number;
  avgViews: number;
  growthRate30d: number;
  avgEngagementRate: number;
  postingFrequencyPerDay: number;
  lastPostAt: string;
  status: 'tracking' | 'paused' | 'archived';
  avatarUrl?: string;
  alertConfig?: {
    enabled: boolean;
    metric: string;
    threshold: number;
    minIntervalMinutes: number;
  };
}

export interface CompetitorSuggestion {
  id: string;
  name: string;
  platform: 'TikTok' | 'Instagram' | 'YouTube' | 'Shopee';
  handle: string;
  followersCount: number;
  relevanceScore: number;
  relevanceReason: string;
}

export interface BenchmarkSnapshotItem {
  id: string;
  workspaceId: string;
  competitorId: string;
  capturedAt: string;
  sourceClass: SourceClass;
  confidence: ConfidenceBand;
  isStale: boolean;
  daysOld: number;
  staleWarning?: string;
  whyExplanation: WhyExplanation;
  followers: number;
  engagementRate: number;
  avgViews: number;
  growthRate30d: number;
  postingFrequency: number;
}

export interface WhiteSpaceGap {
  id: string;
  title: string;
  description: string;
  niche: string;
  potentialScore: number;
  estimatedDemand: string;
  competitorSaturation: string;
  sourceClass: SourceClass;
  confidence: ConfidenceBand;
  whyExplanation: WhyExplanation;
}

export interface MetricComparisonCell {
  value: number | string;
  formattedValue: string;
  isLeader: boolean;
  isAboveAvg?: boolean;
}

export interface MetricComparisonRow {
  metricKey: string;
  metricLabel: string;
  unit: string;
  you: MetricComparisonCell;
  competitors: Record<string, MetricComparisonCell>;
  marketAvg: string;
  isPrivateRevenueGuard?: boolean;
}

// ----------------------------------------------------------------------------
// Staleness Evaluation (RULE-M03-004, AC 2)
// ----------------------------------------------------------------------------

export interface StalenessResult {
  isStale: boolean;
  daysOld: number;
  staleWarning: string;
}

/**
 * Evaluates whether a benchmark snapshot is stale (> 30 days old per RULE-M03-004).
 */
export function evaluateStaleness(capturedAt: string | Date, now: Date = new Date()): StalenessResult {
  const capturedDate = typeof capturedAt === 'string' ? new Date(capturedAt) : capturedAt;
  const diffMs = now.getTime() - capturedDate.getTime();
  const daysOld = Math.max(0, Math.floor(diffMs / (1000 * 60 * 60 * 24)));

  const isStale = daysOld > 30;
  const staleWarning = isStale
    ? `Dữ liệu ảnh chụp đã cũ (${daysOld} ngày trước, vượt ngưỡng 30 ngày). Nhấn "Làm mới dữ liệu" để cập nhật benchmark mới nhất.`
    : '';

  return { isStale, daysOld, staleWarning };
}

// ----------------------------------------------------------------------------
// Financial Non-Conflation Guard (RULE-M03-003, EC-M03-002, AC 4)
// ----------------------------------------------------------------------------

export interface RevenueMetricGuard {
  status: 'PRIVATE_NOT_COMPARED';
  displayValue: '—';
  tooltip: string;
  isConflationBlocked: boolean;
}

/**
 * Returns strictly private placeholder for competitor financial data.
 * Competitor revenue/profit is observational and cannot be compared or fed into ledger truth.
 */
export function getCompetitorRevenueGuard(): RevenueMetricGuard {
  return {
    status: 'PRIVATE_NOT_COMPARED',
    displayValue: '—',
    tooltip: 'Doanh thu đối thủ không được so sánh (dữ liệu bảo mật và tách biệt tuyệt đối khỏi Sổ cái vận hành M19).',
    isConflationBlocked: true
  };
}

/**
 * Validates that observational/inferred competitor data is never fed into M19 finance/accounting.
 */
export function validateNonConflationWithFinance(sourceClass: SourceClass, targetDomain: string): { valid: boolean; error?: string } {
  const financeDomains = ['operating_ledger', 'accounting_journal', 'cogs', 'tax_settlement', 'balance_sheet'];
  if (financeDomains.includes(targetDomain.toLowerCase())) {
    if (sourceClass === 'inferred' || sourceClass === 'estimated') {
      return {
        valid: false,
        error: `Vi phạm RULE-M03-003: Dữ liệu đối thủ dạng '${sourceClass}' không thể đưa vào miền tài chính kế toán '${targetDomain}'.`
      };
    }
  }
  return { valid: true };
}

// ----------------------------------------------------------------------------
// Inferred Why Drawer Generator (RULE-M03-001, RULE-M03-002, AC 1)
// ----------------------------------------------------------------------------

export function generateBenchmarkWhyExplanation(
  competitorName: string,
  platform: string,
  sampleCount: number = 30
): WhyExplanation {
  return {
    basisSummary: `Chỉ số benchmark của ${competitorName} được suy luận (INFERRED) từ phân tích dữ liệu công khai trên nền tảng ${platform} qua ${sampleCount} bài đăng gần nhất.`,
    dataSources: [
      `Công khai API & Web-profile ${platform}`,
      `Lịch sử tương tác (views, likes, comments, shares) 30 ngày qua`,
      `Mô hình phân loại nội dung Creativanta Niche Classifier v2`
    ],
    limitations: [
      'Thuật toán không đo lường được các video/bài viết đã bị đối thủ xóa hoặc ẩn',
      'Tỷ lệ tương tác được tính trên tổng tương tác nhìn thấy chia cho tổng lượng người theo dõi',
      'Không phản ánh các chiến dịch quảng cáo trả phí (Dark Posts) mà đối thủ chạy ngầm'
    ],
    dataGaps: [
      'Không có quyền truy cập vào thông số chuyển đổi đơn hàng hoặc GMV nội bộ của đối thủ',
      'Thời gian giữ chân người xem trung bình (Average Watch Time) không khả dụng từ dữ liệu công khai'
    ]
  };
}

// ----------------------------------------------------------------------------
// Formatters and Calculation Helpers
// ----------------------------------------------------------------------------

export function formatCompactNumber(num: number): string {
  if (num >= 1_000_000) {
    return (num / 1_000_000).toFixed(1).replace(/\.0$/, '') + 'M';
  }
  if (num >= 1_000) {
    return (num / 1_000).toFixed(1).replace(/\.0$/, '') + 'K';
  }
  return num.toLocaleString('vi-VN');
}

export function formatPercent(rate: number): string {
  const sign = rate > 0 ? '+' : '';
  return `${sign}${rate.toFixed(1)}%`;
}

export function buildComparativeMetricsTable(
  you: {
    name: string;
    handle: string;
    followers: number;
    growth30d: number;
    engagementRate: number;
    avgViews: number;
    postsPerWeek: number;
  },
  competitors: Array<{
    id: string;
    name: string;
    handle: string;
    followers: number;
    growth30d: number;
    engagementRate: number;
    avgViews: number;
    postsPerWeek: number;
  }>
): MetricComparisonRow[] {
  const rows: MetricComparisonRow[] = [];

  // Metric 1: Followers
  {
    const allFollowers = [you.followers, ...competitors.map((c) => c.followers)];
    const maxFollowers = Math.max(...allFollowers);
    const avgFollowers = Math.round(allFollowers.reduce((a, b) => a + b, 0) / allFollowers.length);

    const compCells: Record<string, MetricComparisonCell> = {};
    for (const c of competitors) {
      compCells[c.id] = {
        value: c.followers,
        formattedValue: formatCompactNumber(c.followers),
        isLeader: c.followers === maxFollowers,
        isAboveAvg: c.followers >= avgFollowers
      };
    }

    rows.push({
      metricKey: 'followers',
      metricLabel: 'Người theo dõi',
      unit: 'followers',
      you: {
        value: you.followers,
        formattedValue: formatCompactNumber(you.followers),
        isLeader: you.followers === maxFollowers,
        isAboveAvg: you.followers >= avgFollowers
      },
      competitors: compCells,
      marketAvg: formatCompactNumber(avgFollowers)
    });
  }

  // Metric 2: Follower Growth (30d)
  {
    const allGrowth = [you.growth30d, ...competitors.map((c) => c.growth30d)];
    const maxGrowth = Math.max(...allGrowth);
    const avgGrowth = allGrowth.reduce((a, b) => a + b, 0) / allGrowth.length;

    const compCells: Record<string, MetricComparisonCell> = {};
    for (const c of competitors) {
      compCells[c.id] = {
        value: c.growth30d,
        formattedValue: formatPercent(c.growth30d),
        isLeader: c.growth30d === maxGrowth,
        isAboveAvg: c.growth30d >= avgGrowth
      };
    }

    rows.push({
      metricKey: 'growth',
      metricLabel: 'Tăng trưởng (30 ngày)',
      unit: '%',
      you: {
        value: you.growth30d,
        formattedValue: formatPercent(you.growth30d),
        isLeader: you.growth30d === maxGrowth,
        isAboveAvg: you.growth30d >= avgGrowth
      },
      competitors: compCells,
      marketAvg: formatPercent(avgGrowth)
    });
  }

  // Metric 3: Engagement Rate
  {
    const allEng = [you.engagementRate, ...competitors.map((c) => c.engagementRate)];
    const maxEng = Math.max(...allEng);
    const avgEng = allEng.reduce((a, b) => a + b, 0) / allEng.length;

    const compCells: Record<string, MetricComparisonCell> = {};
    for (const c of competitors) {
      compCells[c.id] = {
        value: c.engagementRate,
        formattedValue: `${c.engagementRate.toFixed(1)}%`,
        isLeader: c.engagementRate === maxEng,
        isAboveAvg: c.engagementRate >= avgEng
      };
    }

    rows.push({
      metricKey: 'engagement',
      metricLabel: 'Tỷ lệ tương tác',
      unit: '%',
      you: {
        value: you.engagementRate,
        formattedValue: `${you.engagementRate.toFixed(1)}%`,
        isLeader: you.engagementRate === maxEng,
        isAboveAvg: you.engagementRate >= avgEng
      },
      competitors: compCells,
      marketAvg: `${avgEng.toFixed(1)}%`
    });
  }

  // Metric 4: Average Views
  {
    const allViews = [you.avgViews, ...competitors.map((c) => c.avgViews)];
    const maxViews = Math.max(...allViews);
    const avgViews = Math.round(allViews.reduce((a, b) => a + b, 0) / allViews.length);

    const compCells: Record<string, MetricComparisonCell> = {};
    for (const c of competitors) {
      compCells[c.id] = {
        value: c.avgViews,
        formattedValue: formatCompactNumber(c.avgViews),
        isLeader: c.avgViews === maxViews,
        isAboveAvg: c.avgViews >= avgViews
      };
    }

    rows.push({
      metricKey: 'avg_views',
      metricLabel: 'Lượt xem TB / video',
      unit: 'views',
      you: {
        value: you.avgViews,
        formattedValue: formatCompactNumber(you.avgViews),
        isLeader: you.avgViews === maxViews,
        isAboveAvg: you.avgViews >= avgViews
      },
      competitors: compCells,
      marketAvg: formatCompactNumber(avgViews)
    });
  }

  // Metric 5: Posts per Week
  {
    const allFreq = [you.postsPerWeek, ...competitors.map((c) => c.postsPerWeek)];
    const maxFreq = Math.max(...allFreq);
    const avgFreq = allFreq.reduce((a, b) => a + b, 0) / allFreq.length;

    const compCells: Record<string, MetricComparisonCell> = {};
    for (const c of competitors) {
      compCells[c.id] = {
        value: c.postsPerWeek,
        formattedValue: `${c.postsPerWeek}`,
        isLeader: c.postsPerWeek === maxFreq,
        isAboveAvg: c.postsPerWeek >= avgFreq
      };
    }

    rows.push({
      metricKey: 'posting_frequency',
      metricLabel: 'Bài đăng / tuần',
      unit: 'posts',
      you: {
        value: you.postsPerWeek,
        formattedValue: `${you.postsPerWeek}`,
        isLeader: you.postsPerWeek === maxFreq,
        isAboveAvg: you.postsPerWeek >= avgFreq
      },
      competitors: compCells,
      marketAvg: `${avgFreq.toFixed(1)}`
    });
  }

  // Metric 6: Revenue & Profit (RULE-M03-003 strictly hidden / private!)
  {
    const compCells: Record<string, MetricComparisonCell> = {};
    for (const c of competitors) {
      compCells[c.id] = {
        value: '—',
        formattedValue: '—',
        isLeader: false,
        isAboveAvg: false
      };
    }

    rows.push({
      metricKey: 'revenue',
      metricLabel: 'Doanh thu ước tính*',
      unit: 'VND',
      you: {
        value: 'Riêng tư',
        formattedValue: 'Bảo mật',
        isLeader: false,
        isAboveAvg: false
      },
      competitors: compCells,
      marketAvg: 'Không so sánh',
      isPrivateRevenueGuard: true
    });
  }

  return rows;
}

// ----------------------------------------------------------------------------
// Search and Filter
// ----------------------------------------------------------------------------

export function filterAndSearchCompetitors(
  list: CompetitorItem[],
  filters: { query?: string; platform?: string; category?: string }
): CompetitorItem[] {
  const q = (filters.query || '').trim().toLowerCase();
  const plat = (filters.platform || '').trim().toLowerCase();
  const cat = (filters.category || '').trim().toLowerCase();

  return list.filter((item) => {
    if (plat && plat !== 'all' && item.platform.toLowerCase() !== plat) {
      return false;
    }
    if (cat && cat !== 'all' && !item.category.toLowerCase().includes(cat)) {
      return false;
    }
    if (q) {
      const matchName = item.name.toLowerCase().includes(q);
      const matchHandle = item.handle.toLowerCase().includes(q);
      const matchCategory = item.category.toLowerCase().includes(q);
      const matchNotes = (item.notes || '').toLowerCase().includes(q);
      return matchName || matchHandle || matchCategory || matchNotes;
    }
    return true;
  });
}
