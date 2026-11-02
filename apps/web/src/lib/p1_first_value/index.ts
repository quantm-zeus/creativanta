import type { WorkspaceRole } from '$lib/auth';
import { formatExactMicros, parseExactMicros } from '$lib/billing';

export type CanonicalSourceClass =
  | 'official'
  | 'imported'
  | 'inferred'
  | 'estimated'
  | 'unreconciled';

export type CanonicalConfidenceBand =
  | 'high'
  | 'medium_high'
  | 'medium'
  | 'low_medium'
  | 'low';

export const CANONICAL_CONFIDENCE_BANDS: readonly CanonicalConfidenceBand[] = [
  'high',
  'medium_high',
  'medium',
  'low_medium',
  'low'
] as const;

export interface DataRepairGapItem {
  gapId: string;
  gapKind: 'missing_cogs' | 'missing_evidence' | 'unmatched_settlement' | 'stale_connector';
  title: string;
  reason: string;
  repairCtaLabel: string;
  repairRoute: string;
  affectedAmountVnd: string; // exact decimal string, never float
  resolved: boolean;
}

export interface OnboardingStepState {
  stepNumber: 1 | 2 | 3 | 4 | 5;
  stepKey: 'connect_data' | 'select_offer' | 'create_content' | 'publish' | 'track_outcome';
  title: string;
  isAvailable: boolean;
  isCompleted: boolean;
  unavailableReason: string;
}

export interface PersonalOnboardingProjection {
  workspaceId: string;
  userId: string;
  steps: OnboardingStepState[];
  completedCount: number;
  totalSteps: 5;
  isClosedLoopComplete: boolean;
}

export interface AuthorizedImportInput {
  workspaceId: string;
  userId: string;
  role: WorkspaceRole;
  connectedAccountsCount: number;
  productsCount: number;
  ordersCount: number;
  costsCount: number;
  settlementsCount: number;
  grossRevenueVnd: string;
  knownCostsVnd: string;
  repairGaps: DataRepairGapItem[];
  isDemoFixture?: boolean;
}

export interface LabeledProfitAndRepairProjection {
  workspaceId: string;
  connectedAccountsCount: number;
  requiresNativeConnector: false;
  grossRevenueVnd: string;
  knownCostsVnd: string;
  netProfitVnd: string;
  sourceClass: CanonicalSourceClass;
  confidenceBand: CanonicalConfidenceBand;
  isIncomplete: boolean;
  unknownRequiredComponentsCount: number;
  activeRepairCards: DataRepairGapItem[];
  personalOnboarding: PersonalOnboardingProjection;
}

export function buildPersonalOnboarding(
  workspaceId: string,
  userId: string,
  completedSteps: ReadonlySet<number>
): PersonalOnboardingProjection {
  const defs: Array<{
    stepNumber: 1 | 2 | 3 | 4 | 5;
    stepKey: OnboardingStepState['stepKey'];
    title: string;
    isAvailable: boolean;
    unavailableReason: string;
  }> = [
    {
      stepNumber: 1,
      stepKey: 'connect_data',
      title: 'Kết nối tài khoản hoặc nhập dữ liệu CSV hợp lệ',
      isAvailable: true,
      unavailableReason: ''
    },
    {
      stepNumber: 2,
      stepKey: 'select_offer',
      title: 'Tạo hoặc chọn sản phẩm & SKU kinh doanh (M13)',
      isAvailable: true,
      unavailableReason: ''
    },
    {
      stepNumber: 3,
      stepKey: 'create_content',
      title: 'Tạo kịch bản và tài sản video AI (M06/M07)',
      isAvailable: false,
      unavailableReason: 'AI Video Studio M07 sẽ khả dụng tại Phase P4.'
    },
    {
      stepNumber: 4,
      stepKey: 'publish',
      title: 'Xuất bản đa kênh chuẩn lịch vàng (M11)',
      isAvailable: false,
      unavailableReason: 'Publish Hub M11 sẽ khả dụng tại Phase P5.'
    },
    {
      stepNumber: 5,
      stepKey: 'track_outcome',
      title: 'Đo lường doanh thu, chi phí và đối soát lợi nhuận (M19)',
      isAvailable: true,
      unavailableReason: ''
    }
  ];

  const steps: OnboardingStepState[] = defs.map((d) => ({
    ...d,
    isCompleted: d.isAvailable && completedSteps.has(d.stepNumber)
  }));
  const completedCount = steps.filter((s) => s.isCompleted).length;
  const allAvailable = steps.every((s) => s.isAvailable);

  return {
    workspaceId,
    userId,
    steps,
    completedCount,
    totalSteps: 5,
    isClosedLoopComplete: allAvailable && completedCount === 5
  };
}

/**
 * Evaluates an authorized P1 product/order/cost import without requiring any native connector
 * (Acceptance Target #1: "No connector required for authorized import").
 */
export function evaluateAuthorizedP1Import(
  input: AuthorizedImportInput
): LabeledProfitAndRepairProjection {
  if (input.role === 'viewer') {
    throw new Error('RBAC_DENIED: viewer role cannot ingest financial/commerce imports');
  }
  if (input.isDemoFixture) {
    throw new Error('DEMO_FORBIDDEN: demo fixtures never contribute to customer profit or activation');
  }

  const grossMicros = parseExactMicros(input.grossRevenueVnd);
  const costMicros = parseExactMicros(input.knownCostsVnd);
  const netMicros = grossMicros - costMicros;

  const activeRepairCards = input.repairGaps.filter((g) => !g.resolved);
  const unresolvedCount = activeRepairCards.length;
  const sourceClass: CanonicalSourceClass =
    input.connectedAccountsCount > 0 ? 'official' : 'imported';
  const confidenceBand: CanonicalConfidenceBand =
    unresolvedCount > 0 ? 'low' : sourceClass === 'official' ? 'high' : 'medium';

  const completed = new Set<number>();
  if (
    input.productsCount > 0 ||
    input.ordersCount > 0 ||
    input.costsCount > 0 ||
    input.settlementsCount > 0
  ) {
    completed.add(1);
  }
  if (input.productsCount > 0 || input.ordersCount > 0) {
    completed.add(2);
  }
  if (input.ordersCount > 0 || input.costsCount > 0 || input.settlementsCount > 0) {
    completed.add(5);
  }

  return {
    workspaceId: input.workspaceId,
    connectedAccountsCount: input.connectedAccountsCount,
    requiresNativeConnector: false,
    grossRevenueVnd: formatExactMicros(grossMicros),
    knownCostsVnd: formatExactMicros(costMicros),
    netProfitVnd: formatExactMicros(netMicros),
    sourceClass,
    confidenceBand,
    isIncomplete: unresolvedCount > 0,
    unknownRequiredComponentsCount: unresolvedCount,
    activeRepairCards,
    personalOnboarding: buildPersonalOnboarding(input.workspaceId, input.userId, completed)
  };
}

/**
 * Resolves an underlying finance/reconciliation repair gap and dynamically recomputes
 * the projection and active repair cards (rather than marking fixed locally).
 */
export function resolveUnderlyingRepairGap(
  projection: LabeledProfitAndRepairProjection,
  gapId: string,
  addedKnownCostVnd: string = '0',
  callerRole: WorkspaceRole = 'owner'
): LabeledProfitAndRepairProjection {
  if (callerRole === 'viewer') {
    throw new Error('RBAC_DENIED: viewer role cannot resolve finance repair gaps');
  }
  const grossMicros = parseExactMicros(projection.grossRevenueVnd);
  const prevCostMicros = parseExactMicros(projection.knownCostsVnd);
  const addedMicros = parseExactMicros(addedKnownCostVnd);
  const nextCostMicros = prevCostMicros + addedMicros;
  const nextNetMicros = grossMicros - nextCostMicros;

  const remainingCards = projection.activeRepairCards.filter((g) => g.gapId !== gapId);
  const unresolvedCount = remainingCards.length;
  const confidenceBand: CanonicalConfidenceBand =
    unresolvedCount > 0 ? 'low' : projection.sourceClass === 'official' ? 'high' : 'medium';

  return {
    ...projection,
    knownCostsVnd: formatExactMicros(nextCostMicros),
    netProfitVnd: formatExactMicros(nextNetMicros),
    confidenceBand,
    isIncomplete: unresolvedCount > 0,
    unknownRequiredComponentsCount: unresolvedCount,
    activeRepairCards: remainingCards
  };
}

/**
 * Filters repair cards for the viewer role so lacking finance permission never reveals
 * a money gap, amount, or related private finance object.
 */
export function filterRepairCardsForRole(
  cards: readonly DataRepairGapItem[],
  role: WorkspaceRole
): DataRepairGapItem[] {
  if (role === 'viewer') {
    return [];
  }
  return [...cards];
}

export interface MorningBriefScheduleConfig {
  workspaceId: string;
  timezone: string; // IANA timezone, e.g. 'Asia/Ho_Chi_Minh' or 'America/New_York'
  morningBriefEnabled: boolean;
  morningBriefTime: string; // 'HH:MM', default '07:00'
  hasAuthorizedData: boolean;
}

export interface MorningBriefScheduleVerdict {
  deliveryKey: string;
  localDate: string;
  localTimeHHMM: string;
  decision:
    | 'delivered'
    | 'already_delivered_local_date'
    | 'skipped_stale_window'
    | 'not_yet_due'
    | 'disabled'
    | 'ineligible_no_authorized_data';
  alreadyDelivered: boolean;
}

/**
 * Evaluates workspace local Morning Brief schedule using IANA timezone and unique
 * (workspaceId, localDate) delivery identity so DST transitions or timezone changes
 * cannot double-deliver a brief for the same local calendar date (Acceptance Target #2).
 */
export function evaluateMorningBriefSchedule(
  cfg: MorningBriefScheduleConfig,
  nowUtcIso: string,
  deliveredKeys: Set<string>,
  maxLatenessMinutes: number = 15
): MorningBriefScheduleVerdict {
  const dt = new Date(nowUtcIso);
  const fmt = new Intl.DateTimeFormat('en-CA', {
    timeZone: cfg.timezone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    hour12: false
  });
  const parts = fmt.formatToParts(dt);
  const partMap: Record<string, string> = {};
  for (const p of parts) {
    partMap[p.type] = p.value;
  }
  const localDate = `${partMap.year}-${partMap.month}-${partMap.day}`;
  const rawHour = Number(partMap.hour === '24' ? '0' : partMap.hour);
  const rawMin = Number(partMap.minute);
  const localTimeHHMM = `${String(rawHour).padStart(2, '0')}:${String(rawMin).padStart(2, '0')}`;
  const deliveryKey = `morning_brief:${cfg.workspaceId}:${localDate}`;

  if (!cfg.morningBriefEnabled) {
    return { deliveryKey, localDate, localTimeHHMM, decision: 'disabled', alreadyDelivered: false };
  }
  if (deliveredKeys.has(deliveryKey)) {
    return {
      deliveryKey,
      localDate,
      localTimeHHMM,
      decision: 'already_delivered_local_date',
      alreadyDelivered: true
    };
  }
  if (!cfg.hasAuthorizedData) {
    return {
      deliveryKey,
      localDate,
      localTimeHHMM,
      decision: 'ineligible_no_authorized_data',
      alreadyDelivered: false
    };
  }

  const [cfgHStr, cfgMStr] = (cfg.morningBriefTime || '07:00').split(':');
  const targetMinutes = Number(cfgHStr) * 60 + Number(cfgMStr);
  const nowMinutes = rawHour * 60 + rawMin;
  const diff = nowMinutes - targetMinutes;

  if (diff < 0) {
    return {
      deliveryKey,
      localDate,
      localTimeHHMM,
      decision: 'not_yet_due',
      alreadyDelivered: false
    };
  }
  if (diff > maxLatenessMinutes) {
    return {
      deliveryKey,
      localDate,
      localTimeHHMM,
      decision: 'skipped_stale_window',
      alreadyDelivered: false
    };
  }

  deliveredKeys.add(deliveryKey);
  return {
    deliveryKey,
    localDate,
    localTimeHHMM,
    decision: 'delivered',
    alreadyDelivered: false
  };
}

export interface PilotBatchMetricInput {
  workspaceId: string;
  objectId: string;
  operationId: string;
  isDemoOrInternal: boolean;
  sourceClass: CanonicalSourceClass;
  confidenceBand: CanonicalConfidenceBand;
  unresolvedRequiredComponentsCount: number;
  operatorRepairSeconds: number | null; // null when time tracking is missing -> MUST remain unknown, NEVER 0
  startedProductionJob: boolean;
  acceptedOutput: boolean;
  settledCostUsd: string;
}

export interface PilotCohortMetricsSummary {
  sampleSize: number;
  excludedDemoOrInternalCount: number;
  deduplicatedCount: number;
  confidenceBandCounts: Record<CanonicalConfidenceBand, number>;
  repairBurden: {
    operatorTimeKnown: boolean;
    medianOperatorRepairSeconds: number | null;
    unknownOperatorTimeBatchesCount: number;
    medianUnresolvedComponentsCount: number | null;
  };
  costPerAcceptedOutput: {
    known: boolean;
    status: 'computed' | 'undefined_zero_accepted_outputs';
    costUsdPerAcceptedOutput: string | null;
  };
}

/**
 * Evaluates P1 pilot measurements, preserving all 5 canonical confidence bands and recording
 * actual unknowns (null) when operator time tracking is missing or accepted outputs = 0
 * (Acceptance Target #4: "P1 pilot measurements record actual unknowns").
 */
export function evaluateP1PilotCohort(
  observations: readonly PilotBatchMetricInput[]
): PilotCohortMetricsSummary {
  const seen = new Set<string>();
  let excludedDemoOrInternalCount = 0;
  let deduplicatedCount = 0;
  const confidenceBandCounts: Record<CanonicalConfidenceBand, number> = {
    high: 0,
    medium_high: 0,
    medium: 0,
    low_medium: 0,
    low: 0
  };

  const knownRepairTimes: number[] = [];
  let unknownOperatorTimeBatchesCount = 0;
  const unresolvedCounts: number[] = [];
  let acceptedCount = 0;
  let totalCostMicros = 0n;
  let sampleSize = 0;

  for (const obs of observations) {
    if (obs.isDemoOrInternal) {
      excludedDemoOrInternalCount++;
      continue;
    }
    const key = `${obs.workspaceId}|${obs.objectId}|${obs.operationId}`;
    if (seen.has(key)) {
      deduplicatedCount++;
      continue;
    }
    seen.add(key);
    sampleSize++;
    confidenceBandCounts[obs.confidenceBand]++;
    unresolvedCounts.push(obs.unresolvedRequiredComponentsCount);

    if (obs.operatorRepairSeconds === null) {
      unknownOperatorTimeBatchesCount++;
    } else {
      knownRepairTimes.push(obs.operatorRepairSeconds);
    }

    if (obs.acceptedOutput) {
      acceptedCount++;
    }
    totalCostMicros += parseExactMicros(obs.settledCostUsd);
  }

  const median = (arr: number[]): number | null => {
    if (arr.length === 0) return null;
    const sorted = [...arr].sort((a, b) => a - b);
    const mid = Math.floor(sorted.length / 2);
    return sorted.length % 2 === 1 ? sorted[mid] : Math.floor((sorted[mid - 1] + sorted[mid]) / 2);
  };

  const operatorTimeKnown = knownRepairTimes.length > 0;
  const medianOperatorRepairSeconds = operatorTimeKnown ? median(knownRepairTimes) : null;

  return {
    sampleSize,
    excludedDemoOrInternalCount,
    deduplicatedCount,
    confidenceBandCounts,
    repairBurden: {
      operatorTimeKnown,
      medianOperatorRepairSeconds,
      unknownOperatorTimeBatchesCount,
      medianUnresolvedComponentsCount: median(unresolvedCounts)
    },
    costPerAcceptedOutput:
      acceptedCount === 0
        ? {
            known: false,
            status: 'undefined_zero_accepted_outputs',
            costUsdPerAcceptedOutput: null
          }
        : {
            known: true,
            status: 'computed',
            costUsdPerAcceptedOutput: formatExactMicros(totalCostMicros / BigInt(acceptedCount))
          }
  };
}

export interface StripeWebhookReplayEvent {
  eventId: string;
  eventType: 'checkout.session.completed' | 'invoice.paid' | 'invoice.payment_failed';
  workspaceId: string;
  paymentStatus: 'paid' | 'unpaid' | 'no_payment_required';
  externalGrantKey: string; // e.g. 'stripe_pack:cs_test_123' or 'sub_alloc:in_test_456'
  grantedCredits: string; // NUMERIC(18,6) string
}

export interface StripeWebhookLedgerState {
  processedEventIds: Set<string>;
  settledExternalGrantKeys: Set<string>;
  availableCreditsMicros: bigint;
  lotCount: number;
  transactionCount: number;
}

export interface StripeWebhookReplayVerdict {
  accepted: boolean;
  replayed: boolean;
  grantedCredits: string;
  availableBalanceAfter: string;
  reason: string;
}

/**
 * Evaluates Stripe payment/invoice webhook delivery against both event-ID and
 * economic grant identity (externalGrantKey) so duplicate or re-emitted webhooks
 * with new event IDs can never double-grant credits (Acceptance Target #3).
 */
export function evaluateStripeWebhookReplay(
  state: StripeWebhookLedgerState,
  event: StripeWebhookReplayEvent
): StripeWebhookReplayVerdict {
  if (event.eventType === 'invoice.payment_failed') {
    const isDuplicateEvent = state.processedEventIds.has(event.eventId);
    state.processedEventIds.add(event.eventId);
    return {
      accepted: true,
      replayed: isDuplicateEvent,
      grantedCredits: '0',
      availableBalanceAfter: formatExactMicros(state.availableCreditsMicros),
      reason: 'Hóa đơn thanh toán thất bại — không cấp phát thêm lot credits.'
    };
  }

  if (event.paymentStatus !== 'paid') {
    return {
      accepted: false,
      replayed: false,
      grantedCredits: '0',
      availableBalanceAfter: formatExactMicros(state.availableCreditsMicros),
      reason: `Từ chối cấp credits khi payment_status="${event.paymentStatus}" chưa đạt trạng thái "paid".`
    };
  }

  if (
    state.processedEventIds.has(event.eventId) ||
    state.settledExternalGrantKeys.has(event.externalGrantKey)
  ) {
    state.processedEventIds.add(event.eventId);
    return {
      accepted: true,
      replayed: true,
      grantedCredits: '0',
      availableBalanceAfter: formatExactMicros(state.availableCreditsMicros),
      reason: `Phát hiện phát lại thanh toán (event_id=${event.eventId}, external_grant_key=${event.externalGrantKey}) — khóa chống cấp trùng (0 credits cấp thêm).`
    };
  }

  const grantMicros = parseExactMicros(event.grantedCredits);
  state.processedEventIds.add(event.eventId);
  state.settledExternalGrantKeys.add(event.externalGrantKey);
  state.availableCreditsMicros += grantMicros;
  state.lotCount += 1;
  state.transactionCount += 1;

  return {
    accepted: true,
    replayed: false,
    grantedCredits: formatExactMicros(grantMicros),
    availableBalanceAfter: formatExactMicros(state.availableCreditsMicros),
    reason: `Đã cấp phát nguyên tử ${formatExactMicros(grantMicros)} credits cho khoá ${event.externalGrantKey}.`
  };
}
