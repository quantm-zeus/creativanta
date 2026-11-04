export type SourceClass =
  | 'official'
  | 'imported'
  | 'inferred'
  | 'estimated'
  | 'unreconciled';

export type ConfidenceBand =
  | 'high'
  | 'medium_high'
  | 'medium'
  | 'low_medium'
  | 'low'
  | 'unspecified';

export interface SafeMetric {
  value: string | null;
  isUnknown: boolean;
  unknownReason?: string;
  status: 'calculated' | 'unknown_denominator' | 'collecting_data' | 'low_exposure_inconclusive';
}

export interface AttributionRecord {
  attributionId: string;
  workspaceId: string;
  publishItemId?: string;
  channelPostId?: string;
  orderId: string;
  attributionType: 'direct_click' | 'utm_match' | 'affiliate' | 'organic';
  revenueAttributed: string;
  sourceClass: SourceClass;
  confidence: ConfidenceBand;
  utmSource?: string;
  utmMedium?: string;
  utmCampaign?: string;
  createdAt?: string;
}

export interface CanonicalOrder {
  orderId: string;
  workspaceId: string;
  grossRevenue: string;
  refundDeductions: string;
  netRevenue: string;
  currency: string;
  sourceClass: SourceClass;
  confidence: ConfidenceBand;
  isRecognized: boolean;
}

export interface WorkspaceDeduplicationSummary {
  workspaceId: string;
  totalOrdersAttributed: number;
  uniqueOrdersCounted: number;
  canonicalWorkspaceRevenue: string;
  sumAttributionLines: string;
  isRevenueCountedOnce: boolean;
  aggregateConfidence: ConfidenceBand;
  includesEstimatedOrImported: boolean;
  caveatMessage?: string;
}

export interface ContentRevenueAttribution {
  contentId: string;
  publishItemId: string;
  directOrderCount: number;
  attributedRevenue: string;
  views: number;
  clicks: number;
  isViewsUnknown: boolean;
  isClicksUnknown: boolean;
  unknownReason?: string;
  rpm: string | null;
  isRpmUnknown: boolean;
  ctr: string | null;
  isCtrUnknown: boolean;
  conversionRate: string | null;
  isConversionRateUnknown: boolean;
  confidence: ConfidenceBand;
  sourceClassPercentages: Record<string, number>;
  status: string;
}
