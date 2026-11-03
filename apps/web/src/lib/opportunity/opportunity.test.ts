import { describe, it, expect } from 'vitest';
import {
  calculateOverallScore,
  computeRepairStatus,
  validateStateTransition,
  isConcurrentConflict,
  filterOpportunities,
  sortOpportunities,
  type Opportunity,
} from './index';

const mockOpportunity = (overrides: Partial<Opportunity> = {}): Opportunity => ({
  id: 'opp-1',
  workspaceId: 'ws-1',
  opportunityType: 'content',
  title: 'Morning skincare routine - viral gap',
  summary: 'Search volume +200% on TikTok VN',
  whyItMatters: 'Only 3 competitors covered this topic',
  expectedImpact: { score: 85, description: 'High reach' },
  expectedEffort: { score: 30, description: 'Quick video' },
  priorityState: 'draft',
  priorityReason: '',
  suggestedNextStep: 'Draft 30s TikTok script',
  ownerUserId: '',
  confidence: 'unspecified',
  sourceClass: 'inferred',
  convertedToType: '',
  convertedToId: '',
  sources: [
    {
      sourceType: 'trend',
      sourceId: 't-1',
      sourceName: 'Morning routine',
    },
  ],
  isSaved: false,
  isDismissed: false,
  overallScore: 81,
  estimatedProfit: {
    amountCents: 15000000,
    currency: 'VND',
    confidence: 'medium',
    sourceClass: 'estimated',
    isEstimate: true,
    explanation: 'Estimated projection based on audience match',
  },
  createdAt: '2026-11-01T10:00:00Z',
  updatedAt: '2026-11-01T10:00:00Z',
  isRepairable: false,
  repairReasons: [],
  ...overrides,
});

describe('Opportunity Scoring Calculation', () => {
  it('calculates weighted composite score correctly', () => {
    // impact 85 (85*0.7 = 59.5), effort 30 ((100-30)*0.3 = 21) => 59.5 + 21 = 80.5 => 81
    const score = calculateOverallScore(85, 30);
    expect(score).toBe(81);
  });

  it('clamps scores between 1 and 100', () => {
    expect(calculateOverallScore(120, 0)).toBe(100);
    expect(calculateOverallScore(0, 100)).toBe(1);
  });
});

describe('Acceptance Target 1: Unassigned open items remain repairable', () => {
  it('identifies unassigned open items as repairable with prompt', () => {
    const opp = mockOpportunity({
      priorityState: 'open',
      ownerUserId: '',
      priorityReason: 'High audience match',
      confidence: 'high',
    });

    const repair = computeRepairStatus(opp);
    expect(repair.isRepairable).toBe(true);
    expect(repair.repairReasons.some((r) => r.includes('Chưa phân công người phụ trách'))).toBe(true);
  });

  it('identifies missing priority justification as repairable', () => {
    const opp = mockOpportunity({
      priorityState: 'open',
      ownerUserId: 'user-1',
      priorityReason: '',
      confidence: 'unspecified',
    });

    const repair = computeRepairStatus(opp);
    expect(repair.isRepairable).toBe(true);
    expect(repair.repairReasons.some((r) => r.includes('Thiếu ngữ cảnh ưu tiên'))).toBe(true);
  });

  it('flags missing summary as repairable', () => {
    const opp = mockOpportunity({
      summary: '',
      ownerUserId: 'user-1',
      priorityReason: 'Valid reason',
      confidence: 'high',
    });

    const repair = computeRepairStatus(opp);
    expect(repair.isRepairable).toBe(true);
    expect(repair.repairReasons.some((r) => r.includes('Thiếu tóm tắt cơ hội'))).toBe(true);
  });

  it('reports non-repairable when fully assigned, justified, and documented', () => {
    const opp = mockOpportunity({
      priorityState: 'prioritized',
      ownerUserId: 'user-1',
      priorityReason: 'Clear justification',
      confidence: 'high',
      summary: 'Complete summary',
    });

    const repair = computeRepairStatus(opp);
    expect(repair.isRepairable).toBe(false);
    expect(repair.repairReasons).toHaveLength(0);
  });
});

describe('Acceptance Target 2: State Transitions & Concurrency Conflict', () => {
  it('prevents transitioning draft to prioritized without opening first', () => {
    const opp = mockOpportunity({ priorityState: 'draft' });
    const res = validateStateTransition('draft', 'prioritized', opp);
    expect(res.allowed).toBe(false);
  });

  it('enforces priority justification when transitioning open -> prioritized (RULE-M04-003)', () => {
    const unjustifiedOpp = mockOpportunity({
      priorityState: 'open',
      priorityReason: '',
      confidence: 'unspecified',
    });
    const failRes = validateStateTransition('open', 'prioritized', unjustifiedOpp);
    expect(failRes.allowed).toBe(false);
    expect(failRes.error).toContain('RULE-M04-003');

    const justifiedOpp = mockOpportunity({
      priorityState: 'open',
      priorityReason: 'Strong search volume spike',
    });
    const passRes = validateStateTransition('open', 'prioritized', justifiedOpp);
    expect(passRes.allowed).toBe(true);
  });

  it('enforces owner requirement when transitioning prioritized -> assigned (RULE-M04-002)', () => {
    const unassignedOpp = mockOpportunity({
      priorityState: 'prioritized',
      ownerUserId: '',
    });
    const failRes = validateStateTransition('prioritized', 'assigned', unassignedOpp);
    expect(failRes.allowed).toBe(false);
    expect(failRes.error).toContain('RULE-M04-002');

    const passRes = validateStateTransition('prioritized', 'assigned', unassignedOpp, 'user-assigned-1');
    expect(passRes.allowed).toBe(true);
  });

  it('detects optimistic concurrency conflicts on outdated timestamp', () => {
    const currentUpdatedAt = '2026-11-01T10:05:00.123Z';
    const staleUpdatedAt = '2026-11-01T10:00:00.000Z';
    expect(isConcurrentConflict(currentUpdatedAt, staleUpdatedAt)).toBe(true);
    expect(isConcurrentConflict(currentUpdatedAt, currentUpdatedAt)).toBe(false);
  });
});

describe('Filtering & Sorting', () => {
  const items: Opportunity[] = [
    mockOpportunity({ id: '1', overallScore: 90, priorityState: 'open', opportunityType: 'content', title: 'Skincare A' }),
    mockOpportunity({ id: '2', overallScore: 65, priorityState: 'assigned', opportunityType: 'product', title: 'Beauty B' }),
    mockOpportunity({ id: '3', overallScore: 82, priorityState: 'open', opportunityType: 'content', title: 'Makeup C' }),
  ];

  it('filters by state and minimum score', () => {
    const filtered = filterOpportunities(items, { priorityState: 'open', minScore: 85 });
    expect(filtered).toHaveLength(1);
    expect(filtered[0].id).toBe('1');
  });

  it('filters by search keyword', () => {
    const filtered = filterOpportunities(items, { search: 'makeup' });
    expect(filtered).toHaveLength(1);
    expect(filtered[0].id).toBe('3');
  });

  it('sorts by score descending', () => {
    const sorted = sortOpportunities(items, 'score_desc');
    expect(sorted.map((o) => o.id)).toEqual(['1', '3', '2']);
  });
});
