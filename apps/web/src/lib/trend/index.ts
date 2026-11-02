// Package trend provides frontend models, scoring computations, alert deduplication,
// degraded source handling, and tenant-scoped search for Trend Fusion Radar (M02).
// Canonical references: docs/02_features/intelligence/trend_radar.md & docs/04_contracts/database_schema.md §5.

export type ConfidenceBand =
  | 'high'
  | 'medium_high'
  | 'medium'
  | 'low_medium'
  | 'low';

export type SourceClass =
  | 'official'
  | 'imported'
  | 'inferred'
  | 'estimated'
  | 'unreconciled';

export interface SignalRef {
  signalId: string;
  platform: string;
  weight: number;
  sampleSize: number;
  observedAt: string;
}

export interface TrendItem {
  id: string;
  workspaceId: string;
  title: string;
  category: string;
  platform: string;
  velocity: number; // 0 - 100
  freshnessScore: number; // 0 - 100
  saturationScore: number; // 0 - 100
  strengthScore: number; // Composite 0 - 100
  confidence: ConfidenceBand;
  sourceClass: SourceClass;
  isDegraded: boolean;
  degradedReason?: string;
  sampleSize: number;
  signals: SignalRef[];
  whyNow: string;
  relevanceDescription: string;
  isSavedToWatchlist?: boolean;
  createdAt: string;
}

export interface Watchlist {
  id: string;
  workspaceId: string;
  name: string;
  itemCount: number;
  alertsEnabled: boolean;
  minVelocityThreshold: number; // e.g. 70
  maxSaturationThreshold: number; // e.g. 60
  cooldownMinutes: number; // default 60
  trendIds: string[];
}

export interface WatchlistAlert {
  alertId: string;
  workspaceId: string;
  watchlistId: string;
  trendId: string;
  trendTitle: string;
  metricName: string;
  thresholdValue: number;
  actualValue: number;
  fingerprint: string;
  isBatchedSummary: boolean;
  batchedAlertCount: number;
  createdAt: string;
}

export interface PlatformConnectionStatus {
  platform: string;
  label: string;
  isConnected: boolean;
  statusNote: string;
  lastSyncAt?: string;
}

/**
 * Multi-dimensional scoring formula per RULE-M02-002:
 * strength_score = 0.45 * velocity + 0.35 * freshness + 0.20 * (100 - saturation)
 * Clamped strictly between 0 and 100, rounded to 1 decimal place.
 */
export function calculateStrengthScore(
  velocity: number,
  freshness: number,
  saturation: number
): number {
  const v = Math.max(0, Math.min(100, velocity));
  const f = Math.max(0, Math.min(100, freshness));
  const s = Math.max(0, Math.min(100, saturation));
  const raw = 0.45 * v + 0.35 * f + 0.20 * (100.0 - s);
  return Math.max(0, Math.min(100, Math.round(raw * 10) / 10));
}

/**
 * Evaluates whether a trend's platform source is unavailable or token-expired.
 * Acceptance Target 1: Source unavailable shows degraded data.
 * When degraded: marks isDegraded = true, demotes confidence to 'low', and marks sourceClass = 'estimated'.
 */
export function evaluateSourceDegradation(
  trend: TrendItem,
  platformStatuses: PlatformConnectionStatus[]
): TrendItem {
  const status = platformStatuses.find(
    (p) => p.platform.toLowerCase() === trend.platform.toLowerCase()
  );

  if (status && !status.isConnected) {
    return {
      ...trend,
      isDegraded: true,
      confidence: 'low',
      sourceClass: 'estimated',
      degradedReason: `Nguồn ${status.label} bị gián đoạn (${status.statusNote}). Dữ liệu hiển thị dựa trên ước tính lịch sử.`
    };
  }

  return trend;
}

/**
 * Deterministic fingerprint for alert deduplication (Acceptance Target 2).
 * Formed from sha256 or deterministic string hash: workspaceId:watchlistId:trendId:metricName
 */
export function generateAlertFingerprint(
  workspaceId: string,
  watchlistId: string,
  trendId: string,
  metricName: string
): string {
  const input = `${workspaceId}:${watchlistId}:${trendId}:${metricName}`;
  let hash = 0;
  for (let i = 0; i < input.length; i++) {
    const char = input.charCodeAt(i);
    hash = (hash << 5) - hash + char;
    hash |= 0; // Convert to 32bit integer
  }
  return `fp-${Math.abs(hash).toString(16)}-${trendId}`;
}

export interface AlertEvaluationInput {
  workspaceId: string;
  watchlistId: string;
  trendId: string;
  trendTitle: string;
  metricName: string;
  thresholdValue: number;
  actualValue: number;
  timestampMs?: number;
}

export interface AlertEvaluationResult {
  emittedAlerts: WatchlistAlert[];
  suppressedCount: number;
  updatedFingerprints: Map<string, number>;
}

/**
 * Deduplicates watchlist threshold alerts and batches alert storms (Acceptance Target 2 & EC-M02-004).
 * Consecutive breaches with the same fingerprint within cooldownMinutes are suppressed.
 * When simultaneous breaches exceed 5, they are batched into a summary alert.
 */
export function evaluateAndDeduplicateAlerts(
  breaches: AlertEvaluationInput[],
  existingFingerprintTimestamps: Map<string, number>,
  cooldownMinutes: number = 60,
  nowMs: number = Date.now()
): AlertEvaluationResult {
  const updatedFingerprints = new Map(existingFingerprintTimestamps);
  const cooldownMs = cooldownMinutes * 60 * 1000;
  const passedBreaches: WatchlistAlert[] = [];
  let suppressedCount = 0;

  for (const b of breaches) {
    const fp = generateAlertFingerprint(b.workspaceId, b.watchlistId, b.trendId, b.metricName);
    const lastTriggered = updatedFingerprints.get(fp);

    if (lastTriggered && nowMs - lastTriggered < cooldownMs) {
      suppressedCount++;
      continue;
    }

    updatedFingerprints.set(fp, nowMs);
    passedBreaches.push({
      alertId: `alert-${Date.now()}-${passedBreaches.length + 1}`,
      workspaceId: b.workspaceId,
      watchlistId: b.watchlistId,
      trendId: b.trendId,
      trendTitle: b.trendTitle,
      metricName: b.metricName,
      thresholdValue: b.thresholdValue,
      actualValue: b.actualValue,
      fingerprint: fp,
      isBatchedSummary: false,
      batchedAlertCount: 1,
      createdAt: new Date(nowMs).toISOString()
    });
  }

  // Alert storm batching per EC-M02-004: if more than 5 alerts occur simultaneously,
  // collapse them into a single batched summary notification.
  if (passedBreaches.length > 5) {
    const summaryAlert: WatchlistAlert = {
      alertId: `alert-storm-summary-${nowMs}`,
      workspaceId: breaches[0]?.workspaceId ?? 'unknown',
      watchlistId: breaches[0]?.watchlistId ?? 'unknown',
      trendId: 'multiple',
      trendTitle: `Tổng hợp cảnh báo: ${passedBreaches.length} xu hướng cùng lúc vượt ngưỡng`,
      metricName: 'multi_breach_storm',
      thresholdValue: 0,
      actualValue: passedBreaches.length,
      fingerprint: `storm-${nowMs}`,
      isBatchedSummary: true,
      batchedAlertCount: passedBreaches.length,
      createdAt: new Date(nowMs).toISOString()
    };
    return {
      emittedAlerts: [summaryAlert],
      suppressedCount,
      updatedFingerprints
    };
  }

  return {
    emittedAlerts: passedBreaches,
    suppressedCount,
    updatedFingerprints
  };
}

export interface TrendFilterOptions {
  query?: string;
  platform?: string;
  category?: string;
  minScore?: number;
  confidence?: ConfidenceBand | 'all';
  sortBy?: 'score_desc' | 'velocity_desc' | 'freshness_desc';
}

/**
 * Searches and filters trends strictly scoped to the caller's workspace (Acceptance Target 3).
 * Zero cross-tenant data disclosure: items belonging to other workspaces are strictly rejected.
 */
export function searchAndFilterTrends(
  trends: TrendItem[],
  currentWorkspaceId: string,
  options: TrendFilterOptions = {}
): TrendItem[] {
  if (!currentWorkspaceId) {
    return [];
  }

  // Strict tenant isolation boundary
  const tenantScoped = trends.filter((t) => t.workspaceId === currentWorkspaceId);

  return tenantScoped
    .filter((trend) => {
      // Platform filter
      if (options.platform && options.platform !== 'all') {
        if (trend.platform.toLowerCase() !== options.platform.toLowerCase()) {
          return false;
        }
      }

      // Category filter
      if (options.category && options.category !== 'all') {
        if (trend.category.toLowerCase() !== options.category.toLowerCase()) {
          return false;
        }
      }

      // Min strength score filter
      if (options.minScore !== undefined && options.minScore > 0) {
        if (trend.strengthScore < options.minScore) {
          return false;
        }
      }

      // Confidence band filter
      if (options.confidence && options.confidence !== 'all') {
        if (trend.confidence !== options.confidence) {
          return false;
        }
      }

      // Semantic / keyword query filter
      if (options.query && options.query.trim().length > 0) {
        const q = options.query.trim().toLowerCase();
        const matchesTitle = trend.title.toLowerCase().includes(q);
        const matchesWhy = trend.whyNow.toLowerCase().includes(q);
        const matchesRel = trend.relevanceDescription.toLowerCase().includes(q);
        const matchesCat = trend.category.toLowerCase().includes(q);
        if (!matchesTitle && !matchesWhy && !matchesRel && !matchesCat) {
          return false;
        }
      }

      return true;
    })
    .sort((a, b) => {
      switch (options.sortBy) {
        case 'velocity_desc':
          return b.velocity - a.velocity;
        case 'freshness_desc':
          return b.freshnessScore - a.freshnessScore;
        case 'score_desc':
        default:
          return b.strengthScore - a.strengthScore;
      }
    });
}

/**
 * Converts a trend item into an Opportunity draft for Module M04.
 */
export function convertTrendToOpportunity(
  trend: TrendItem,
  workspaceId: string,
  userId: string
) {
  if (trend.workspaceId !== workspaceId) {
    throw new Error('Tenant mismatch: cannot convert trend from another workspace');
  }

  return {
    opportunityId: `opp-${trend.id}`,
    workspaceId,
    sourceTrendId: trend.id,
    title: `Cơ hội: ${trend.title}`,
    category: trend.category,
    platform: trend.platform,
    initialStrengthScore: trend.strengthScore,
    estimatedVelocity: trend.velocity,
    createdBy: userId,
    createdAt: new Date().toISOString(),
    status: 'draft' as const
  };
}
