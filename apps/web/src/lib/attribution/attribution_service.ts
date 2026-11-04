import type {
  AttributionRecord,
  CanonicalOrder,
  ConfidenceBand,
  SafeMetric,
  SourceClass,
  WorkspaceDeduplicationSummary,
} from './types';

// Numerical confidence ranks for comparison: higher = more confident
const CONFIDENCE_RANKS: Record<ConfidenceBand, number> = {
  high: 5,
  medium_high: 4,
  medium: 3,
  low_medium: 2,
  low: 1,
  unspecified: 0,
};

// ----------------------------------------------------------------------------
// Acceptance Target 2: Missing Denominators Remain Unknown
// ----------------------------------------------------------------------------

/**
 * Calculates Revenue Per Mille (RPM) with strict missing denominator safety (Target 2).
 * Denominators that are missing, null, zero, or under data lag remain explicitly unknown.
 * Resolves EXP-2026-02: Exposure < 100 views is marked low_exposure_inconclusive.
 */
export function calculateSafeRPM(
  revenue: string | number,
  views: number | null | undefined,
  isViewsUnknown = false,
  reason = ''
): SafeMetric {
  if (isViewsUnknown || views === null || views === undefined) {
    return {
      value: null,
      isUnknown: true,
      unknownReason: reason || 'MISSING_DENOMINATOR_VIEWS',
      status: 'unknown_denominator',
    };
  }

  if (views <= 0) {
    return {
      value: null,
      isUnknown: true,
      unknownReason: 'MISSING_DENOMINATOR_VIEWS',
      status: 'collecting_data',
    };
  }

  // Exposure below 100 views is inconclusive for comparison (EXP-2026-02)
  if (views < 100) {
    return {
      value: null,
      isUnknown: true,
      unknownReason: 'LOW_EXPOSURE_INCONCLUSIVE',
      status: 'low_exposure_inconclusive',
    };
  }

  const revNum = typeof revenue === 'string' ? parseFloat(revenue) : revenue;
  if (isNaN(revNum)) {
    return {
      value: null,
      isUnknown: true,
      unknownReason: 'INVALID_REVENUE_AMOUNT',
      status: 'unknown_denominator',
    };
  }

  const rpm = (revNum * 1000) / views;
  return {
    value: rpm.toFixed(6),
    isUnknown: false,
    status: 'calculated',
  };
}

/**
 * Calculates Click-Through Rate (CTR = Clicks / Views) with denominator protection.
 */
export function calculateSafeCTR(
  clicks: number | null | undefined,
  views: number | null | undefined,
  isViewsUnknown = false,
  isClicksUnknown = false
): SafeMetric {
  if (isViewsUnknown || views === null || views === undefined || views <= 0) {
    return {
      value: null,
      isUnknown: true,
      unknownReason: 'MISSING_DENOMINATOR_VIEWS',
      status: 'unknown_denominator',
    };
  }

  if (isClicksUnknown || clicks === null || clicks === undefined) {
    return {
      value: null,
      isUnknown: true,
      unknownReason: 'MISSING_CLICKS',
      status: 'unknown_denominator',
    };
  }

  if (views < 100) {
    return {
      value: null,
      isUnknown: true,
      unknownReason: 'LOW_EXPOSURE_INCONCLUSIVE',
      status: 'low_exposure_inconclusive',
    };
  }

  const ctr = (clicks / views) * 100;
  return {
    value: `${ctr.toFixed(4)}%`,
    isUnknown: false,
    status: 'calculated',
  };
}

/**
 * Calculates Conversion Rate (Orders / Clicks) with denominator protection.
 */
export function calculateSafeConversionRate(
  ordersCount: number,
  clicks: number | null | undefined,
  isClicksUnknown = false
): SafeMetric {
  if (isClicksUnknown || clicks === null || clicks === undefined || clicks <= 0) {
    return {
      value: null,
      isUnknown: true,
      unknownReason: 'MISSING_DENOMINATOR_CLICKS',
      status: 'unknown_denominator',
    };
  }

  const rate = (ordersCount / clicks) * 100;
  return {
    value: `${rate.toFixed(4)}%`,
    isUnknown: false,
    status: 'calculated',
  };
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Imported Proof Integrity & Mixed Confidence Cap
// ----------------------------------------------------------------------------

/**
 * Enforces that imported proof cannot be upgraded to official without live API verification.
 * Mixed official + imported sources cap aggregate confidence at 'medium'.
 */
export function enforceSourceClassIntegrity(
  currentClass: SourceClass,
  requestedClass: SourceClass,
  isLiveAPIVerified = false
): { sourceClass: SourceClass; error?: string } {
  // RULE-M19-001, RULE-M19-007: Imported proof cannot be upgraded to official
  if (currentClass === 'imported' && requestedClass === 'official') {
    return {
      sourceClass: 'imported',
      error: 'finance: imported proof cannot be upgraded to official without verified live platform API session',
    };
  }

  if (requestedClass === 'official' && !isLiveAPIVerified) {
    return {
      sourceClass: 'imported',
      error: 'finance: official source class requires verified live platform API session',
    };
  }

  return { sourceClass: requestedClass };
}

/**
 * Resolves confidence band across multiple attribution sources.
 * Mixed official + imported/estimated sources strictly cap confidence at 'medium'.
 */
export function resolveAggregateConfidence(
  bands: ConfidenceBand[],
  hasImportedOrEstimated: boolean
): ConfidenceBand {
  if (bands.length === 0) return 'unspecified';

  let minRank = 5;
  for (const b of bands) {
    const r = CONFIDENCE_RANKS[b] ?? 0;
    if (r < minRank) minRank = r;
  }

  let resolvedBand: ConfidenceBand = 'medium';
  if (minRank >= 5) resolvedBand = 'high';
  else if (minRank >= 4) resolvedBand = 'medium_high';
  else if (minRank >= 3) resolvedBand = 'medium';
  else if (minRank >= 2) resolvedBand = 'low_medium';
  else resolvedBand = 'low';

  // Target 3: If imported or estimated sources are included, cap at 'medium'
  if (hasImportedOrEstimated && CONFIDENCE_RANKS[resolvedBand] > CONFIDENCE_RANKS['medium']) {
    resolvedBand = 'medium';
  }

  return resolvedBand;
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: Workspace Revenue Counted Once & Order Net Capacity
// ----------------------------------------------------------------------------

/**
 * Validates that total allocations for an order do not exceed net recognized revenue (gross - refund).
 */
export function validateAttributionCapacity(
  netRevenue: number,
  existingAllocations: number[],
  newAllocation: number
): { remainingCapacity: number; isValid: boolean; error?: string } {
  const currentSum = existingAllocations.reduce((acc, v) => acc + v, 0);
  const total = currentSum + newAllocation;

  if (total > netRevenue + 0.000001) { // EPSILON for floating point
    return {
      remainingCapacity: Math.max(0, netRevenue - currentSum),
      isValid: false,
      error: `finance: attributed revenue (${total.toFixed(6)}) exceeds order net recognized revenue capacity (${netRevenue.toFixed(6)})`,
    };
  }

  return {
    remainingCapacity: netRevenue - total,
    isValid: true,
  };
}

/**
 * Deduplicates workspace revenue across all content attributions:
 * - Distinct recognized orders are summed exactly once.
 * - Enforces order net capacity.
 * - Caps aggregate confidence at medium if imported/estimated sources are present.
 */
export function deduplicateWorkspaceRevenue(
  workspaceId: string,
  canonicalOrders: CanonicalOrder[],
  attributions: AttributionRecord[]
): WorkspaceDeduplicationSummary {
  const orderMap = new Map<string, CanonicalOrder>();
  for (const o of canonicalOrders) {
    if (o.workspaceId === workspaceId && o.isRecognized) {
      orderMap.set(o.orderId, o);
    }
  }

  // Sum distinct recognized orders once
  let canonicalTotal = 0;
  for (const order of orderMap.values()) {
    canonicalTotal += parseFloat(order.netRevenue) || 0;
  }

  // Validate per-order capacity and sum attribution lines
  const orderAllocations = new Map<string, number[]>();
  let sumAttributions = 0;
  let hasImportedOrEstimated = false;
  const bands: ConfidenceBand[] = [];

  for (const a of attributions) {
    if (a.workspaceId !== workspaceId) continue;

    const amt = parseFloat(a.revenueAttributed) || 0;
    sumAttributions += amt;
    bands.push(a.confidence);

    if (a.sourceClass === 'imported' || a.sourceClass === 'estimated') {
      hasImportedOrEstimated = true;
    }

    const allocs = orderAllocations.get(a.orderId) || [];
    const order = orderMap.get(a.orderId);
    const netCap = order ? parseFloat(order.netRevenue) || 0 : amt;

    const validation = validateAttributionCapacity(netCap, allocs, amt);
    if (!validation.isValid) {
      throw new Error(validation.error);
    }

    allocs.push(amt);
    orderAllocations.set(a.orderId, allocs);
  }

  const aggregateConfidence = resolveAggregateConfidence(bands, hasImportedOrEstimated);

  let caveatMessage: string | undefined;
  if (hasImportedOrEstimated) {
    caveatMessage = 'Aggregated revenue includes imported/estimated sources; confidence capped at medium.';
  }

  return {
    workspaceId,
    totalOrdersAttributed: attributions.filter((a) => a.workspaceId === workspaceId).length,
    uniqueOrdersCounted: orderAllocations.size,
    canonicalWorkspaceRevenue: canonicalTotal.toFixed(6),
    sumAttributionLines: sumAttributions.toFixed(6),
    isRevenueCountedOnce: true,
    aggregateConfidence,
    includesEstimatedOrImported: hasImportedOrEstimated,
    caveatMessage,
  };
}
