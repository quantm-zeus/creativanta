// Package opportunity provides frontend models, score calculation, repair evaluation,
// optimistic concurrency handling, and state transitions for M04 Opportunity Board.
// Canonical sources: docs/02_features/intelligence/opportunity_board.md
// and docs/04_contracts/database_schema.md §5.4 & §5.5.

export type PriorityState =
  | 'draft'
  | 'open'
  | 'prioritized'
  | 'assigned'
  | 'in_progress'
  | 'converted'
  | 'parked'
  | 'closed_won'
  | 'closed_lost';

export type ConfidenceBand =
  | 'unspecified'
  | 'low'
  | 'low_medium'
  | 'medium'
  | 'medium_high'
  | 'high';

export type SourceClass =
  | 'unspecified'
  | 'official'
  | 'imported'
  | 'inferred'
  | 'estimated'
  | 'unreconciled';

export interface OpportunitySourceRef {
  sourceType: string; // 'trend' | 'signal' | 'competitor' | 'product_opportunity' | 'thread'
  sourceId: string;
  sourceName: string;
  sourceUrl?: string;
  isExpired?: boolean;
  archiveNotice?: string;
}

export interface ExpectedImpact {
  score: number; // 0 - 100
  description: string;
  revenueEstimate?: string;
}

export interface ExpectedEffort {
  score: number; // 0 - 100
  description: string;
  timeEstimate?: string;
}

export interface EstimatedProfit {
  amountCents: number;
  currency: string;
  confidence: ConfidenceBand;
  sourceClass: SourceClass;
  isEstimate: boolean; // Always true per RULE-M04-005
  explanation: string;
}

export interface Opportunity {
  id: string;
  workspaceId: string;
  opportunityType: string; // 'content' | 'product' | 'affiliate' | 'live' | 'campaign'
  title: string;
  summary: string;
  whyItMatters: string;
  expectedImpact: ExpectedImpact;
  expectedEffort: ExpectedEffort;
  priorityState: PriorityState;
  priorityReason: string;
  suggestedNextStep: string;
  ownerUserId: string;
  confidence: ConfidenceBand;
  sourceClass: SourceClass;
  convertedToType: string;
  convertedToId: string;
  sources: OpportunitySourceRef[];
  isSaved: boolean;
  isDismissed: boolean;
  overallScore: number;
  estimatedProfit: EstimatedProfit;
  createdAt: string;
  updatedAt: string;
  isRepairable: boolean;
  repairReasons: string[];
}

export interface OpportunitySummaryStats {
  totalCount: number;
  avgScore: number;
  newTodayCount: number;
}

/**
 * Calculates overall score from impact and effort (1 - 100).
 * Impact weight 70%, effort weight 30% (inverted).
 */
export function calculateOverallScore(impactScore: number, effortScore: number): number {
  const i = Math.max(1, Math.min(100, Math.round(impactScore ?? 50)));
  const e = Math.max(0, Math.min(100, Math.round(effortScore ?? 50)));
  const score = Math.round(i * 0.7 + (100 - e) * 0.3);
  return Math.max(1, Math.min(100, score));
}

/**
 * Evaluates whether an opportunity requires repair actions (Acceptance Target 1).
 * Items awaiting assignment or missing priority justifications remain repairable.
 */
export function computeRepairStatus(opp: Partial<Opportunity>): {
  isRepairable: boolean;
  repairReasons: string[];
} {
  const reasons: string[] = [];

  // RULE-M04-002: Open/prioritized items without owner display assign prompt and are repairable
  if (
    (opp.priorityState === 'open' || opp.priorityState === 'prioritized') &&
    (!opp.ownerUserId || opp.ownerUserId.trim() === '')
  ) {
    reasons.push('Chưa phân công người phụ trách (Unassigned owner — assign team member)');
  }

  // RULE-M04-003: Missing priority justification
  if (
    (!opp.priorityReason || opp.priorityReason.trim() === '') &&
    (!opp.confidence || opp.confidence === 'unspecified')
  ) {
    reasons.push('Thiếu ngữ cảnh ưu tiên (Missing priority context — add reason or confidence)');
  }

  // Missing summary
  if (!opp.summary || opp.summary.trim() === '') {
    reasons.push('Thiếu tóm tắt cơ hội (Missing opportunity summary)');
  }

  return {
    isRepairable: reasons.length > 0,
    repairReasons: reasons,
  };
}

/**
 * Validates state transitions per canonical state machine (RULE-M04-004).
 */
export function validateStateTransition(
  current: PriorityState,
  target: PriorityState,
  opp: Partial<Opportunity>,
  targetOwner?: string,
  reason?: string
): { allowed: boolean; error?: string } {
  if (current === target) {
    return { allowed: true };
  }

  // Parking is allowed from non-terminal states with reason
  if (target === 'parked') {
    if (current === 'closed_won' || current === 'closed_lost' || current === 'converted') {
      return {
        allowed: false,
        error: `Không thể tạm dừng cơ hội đã kết thúc ở trạng thái ${current}`,
      };
    }
    if (!reason || reason.trim() === '') {
      return { allowed: false, error: 'Tạm dừng cơ hội yêu cầu ghi rõ lý do' };
    }
    return { allowed: true };
  }

  // Re-activation from parked must go to open
  if (current === 'parked') {
    if (target === 'open') {
      return { allowed: true };
    }
    return {
      allowed: false,
      error: `Cơ hội tạm dừng chỉ có thể kích hoạt lại về trạng thái open, không thể sang ${target}`,
    };
  }

  switch (current) {
    case 'draft':
      if (target !== 'open') {
        return { allowed: false, error: `Bản nháp chỉ có thể chuyển sang open, không phải ${target}` };
      }
      if (!opp.title?.trim() || !opp.summary?.trim()) {
        return { allowed: false, error: 'Bản nháp cần tiêu đề và tóm tắt để mở' };
      }
      return { allowed: true };

    case 'open':
      if (target !== 'prioritized') {
        return { allowed: false, error: `Trạng thái open chỉ có thể chuyển sang prioritized, không phải ${target}` };
      }
      if (
        (!opp.priorityReason || opp.priorityReason.trim() === '') &&
        (!opp.confidence || opp.confidence === 'unspecified')
      ) {
        return {
          allowed: false,
          error: 'Cần có lý do ưu tiên hoặc độ tin cậy để đưa vào danh sách ưu tiên (RULE-M04-003)',
        };
      }
      return { allowed: true };

    case 'prioritized':
      if (target !== 'assigned') {
        return { allowed: false, error: `Trạng thái prioritized chỉ có thể chuyển sang assigned, không phải ${target}` };
      }
      const effectiveOwner = targetOwner || opp.ownerUserId;
      if (!effectiveOwner || effectiveOwner.trim() === '') {
        return { allowed: false, error: 'Cần chỉ định người phụ trách trước khi chuyển sang assigned (RULE-M04-002)' };
      }
      return { allowed: true };

    case 'assigned':
      if (target !== 'in_progress') {
        return { allowed: false, error: `Trạng thái assigned chỉ có thể chuyển sang in_progress, không phải ${target}` };
      }
      return { allowed: true };

    case 'in_progress':
      if (target !== 'converted') {
        return { allowed: false, error: `Trạng thái in_progress chỉ có thể chuyển sang converted, không phải ${target}` };
      }
      return { allowed: true };

    case 'converted':
      if (target === 'closed_won' || target === 'closed_lost') {
        if (!reason || reason.trim() === '') {
          return { allowed: false, error: 'Đóng cơ hội đã chuyển đổi yêu cầu kết quả đánh giá' };
        }
        return { allowed: true };
      }
      return { allowed: false, error: `Cơ hội đã chuyển đổi chỉ có thể đóng won hoặc lost, không thể sang ${target}` };

    default:
      return { allowed: false, error: `Trạng thái kết thúc ${current} không thể chuyển tiếp sang ${target}` };
  }
}

/**
 * Checks for optimistic concurrency conflict (EC-M04-003).
 */
export function isConcurrentConflict(
  currentUpdatedAt: string,
  expectedUpdatedAt: string
): boolean {
  return new Date(currentUpdatedAt).getTime() !== new Date(expectedUpdatedAt).getTime();
}

/**
 * Filters opportunities by criteria.
 */
export function filterOpportunities(
  items: Opportunity[],
  options: {
    priorityState?: PriorityState;
    minScore?: number;
    ownerUserId?: string;
    opportunityType?: string;
    search?: string;
  }
): Opportunity[] {
  return items.filter((opp) => {
    if (options.priorityState && opp.priorityState !== options.priorityState) {
      return false;
    }
    if (options.minScore !== undefined && opp.overallScore < options.minScore) {
      return false;
    }
    if (options.ownerUserId && opp.ownerUserId !== options.ownerUserId) {
      return false;
    }
    if (options.opportunityType && opp.opportunityType !== options.opportunityType) {
      return false;
    }
    if (options.search) {
      const q = options.search.toLowerCase();
      const matchTitle = opp.title.toLowerCase().includes(q);
      const matchSummary = opp.summary.toLowerCase().includes(q);
      if (!matchTitle && !matchSummary) {
        return false;
      }
    }
    return true;
  });
}

/**
 * Sorts opportunities by specified criterion.
 */
export function sortOpportunities(
  items: Opportunity[],
  sortBy: 'score_desc' | 'score_asc' | 'updated_desc' | 'impact_desc'
): Opportunity[] {
  const cloned = [...items];
  switch (sortBy) {
    case 'score_desc':
      return cloned.sort((a, b) => b.overallScore - a.overallScore);
    case 'score_asc':
      return cloned.sort((a, b) => a.overallScore - b.overallScore);
    case 'updated_desc':
      return cloned.sort(
        (a, b) => new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime()
      );
    case 'impact_desc':
      return cloned.sort((a, b) => b.expectedImpact.score - a.expectedImpact.score);
    default:
      return cloned;
  }
}
