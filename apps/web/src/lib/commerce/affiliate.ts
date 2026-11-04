/**
 * In-Product Affiliate Network & Operating Ledger Integration (M16 & M19)
 * Canonical Sources:
 * - docs/02_features/commerce/affiliate_network.md
 * - docs/02_features/finance/operating_ledger.md
 * - docs/04_contracts/financial_computation_contract.md
 *
 * Implements:
 * - Acceptance Target 1: Creator income distinct from seller expense (no COGS deduction for creator)
 * - Acceptance Target 2: Ambiguous attribution labeled as inferred with multi-touch note
 * - Acceptance Target 3: Broken link repair workflow restoring healthy status while preserving terminal revoke
 */

export type AffiliateLinkState = 'draft' | 'active' | 'paused' | 'revoked' | 'expired';
export type LinkHealthStatus = 'healthy' | 'warning' | 'broken' | 'expired' | 'product_unavailable';
export type AttributionSourceClass = 'official' | 'imported' | 'inferred' | 'estimated' | 'unreconciled';
export type AttributionConfidence = 'high' | 'medium' | 'low';
export type CommissionStatus = 'pending' | 'confirmed' | 'clawed_back' | 'paid_out';
export type PayoutStatus = 'pending' | 'processing' | 'completed' | 'failed';
export type AssignmentStatus = 'active' | 'completed' | 'cancelled';
export type WorkspaceEconomicRole = 'creator' | 'seller';

export interface AffiliateLink {
  affiliateLinkId: string;
  workspaceId: string;
  productId?: string;
  offerId?: string;
  campaignId?: string;
  platform: string;
  originalUrl: string;
  trackedUrl: string;
  shortCode: string;
  commissionRate: string; // e.g. "10.00"
  lifecycleState: AffiliateLinkState;
  healthStatus: LinkHealthStatus;
  clickCount: number;
  conversionCount: number;
  revenueAttributed: string;
  suggestedReplacementProductId?: string;
  expiresAt?: string;
  createdAt: string;
  updatedAt: string;
}

export interface CreatorAssignment {
  assignmentId: string;
  workspaceId: string;
  campaignId?: string;
  creatorEntityId: string;
  affiliateLinkId?: string;
  couponId?: string;
  status: AssignmentStatus;
  notes?: string;
  createdAt: string;
  updatedAt: string;
}

export interface AttributionRecord {
  attributionId: string;
  workspaceId: string;
  orderId: string;
  affiliateLinkId: string;
  creatorEntityId?: string;
  clickId?: string;
  touchpointCount: number;
  isMultiTouch: boolean;
  sourceClass: AttributionSourceClass;
  confidence: AttributionConfidence;
  attributionNote: string;
  orderAmount: string;
  attributedRevenue: string;
  commissionAmount: string;
  currency: string;
  attributedAt: string;
}

export interface AffiliateCommission {
  commissionId: string;
  workspaceId: string;
  affiliateLinkId: string;
  orderId: string;
  creatorEntityId?: string;
  commissionAmount: string;
  currency: string;
  status: CommissionStatus;
  holdUntil: string;
  clawbackReason?: string;
  clawbackAmount?: string;
  payoutId?: string;
  createdAt: string;
  updatedAt: string;
}

export interface AffiliatePayout {
  payoutId: string;
  workspaceId: string;
  creatorEntityId: string;
  commissionIds: string[];
  totalAmount: string;
  currency: string;
  status: PayoutStatus;
  proofHash?: string;
  settlementId?: string;
  paidAt?: string;
  createdAt: string;
}

export interface LinkHealthRecord {
  healthId: string;
  workspaceId: string;
  affiliateLinkId: string;
  httpStatus: number;
  productStatus: string;
  commissionStatus: string;
  linkStatus: LinkHealthStatus;
  suggestedAction: string;
  checkedAt: string;
  alertSent: boolean;
  estimatedRevenueImpact: string;
  suggestedReplacementProductId?: string;
}

export interface LedgerPostingEvaluation {
  postingId: string;
  workspaceId: string;
  economicRole: WorkspaceEconomicRole;
  postingType: 'creator_income' | 'seller_commission_expense';
  amount: string;
  currency: string;
  cogsDeducted: boolean;
  netProfitImpact: string;
  postedAt: string;
}

/**
 * Acceptance Target 1:
 * Creator income distinct from seller expense.
 * In accordance with financial_computation_contract.md §1:
 * "Affiliate income belongs to creator revenue; affiliate commission expense belongs to seller cost.
 *  Record the workspace's economic role and do not charge a creator both seller COGS and commission cost for the same affiliate sale."
 */
export function evaluateLedgerImpact(
  workspaceId: string,
  commissionAmount: string,
  currency: string,
  role: WorkspaceEconomicRole
): LedgerPostingEvaluation {
  const postingId = `post-aff-${Math.random().toString(36).substring(2, 10)}`;
  const now = new Date().toISOString();

  if (role === 'creator') {
    return {
      postingId,
      workspaceId,
      economicRole: 'creator',
      postingType: 'creator_income',
      amount: commissionAmount,
      currency,
      cogsDeducted: false, // Acceptance Target 1: COGS is NEVER deducted from creator income!
      netProfitImpact: `+${commissionAmount}`,
      postedAt: now,
    };
  }

  // Seller role: commission is a seller cost/expense deduction
  return {
    postingId,
    workspaceId,
    economicRole: 'seller',
    postingType: 'seller_commission_expense',
    amount: commissionAmount,
    currency,
    cogsDeducted: true, // Seller expense structure
    netProfitImpact: `-${commissionAmount}`,
    postedAt: now,
  };
}

/**
 * Acceptance Target 2:
 * Ambiguous attribution labeled.
 * In accordance with RULE-M16-001 & RULE-M16-002:
 * "Ambiguous attribution MUST be explicitly labeled as inferred or unreconciled.
 *  The system MUST NOT present uncertain attribution as definitive truth.
 *  UI badge shows 'Attributed (inferred)' with multi-touch scenario explanation."
 */
export function labelAttributionProvenance(
  touchpointCount: number,
  isMultiTouch: boolean,
  isOfficialAPI: boolean
): {
  sourceClass: AttributionSourceClass;
  confidence: AttributionConfidence;
  badgeLabel: string;
  explanationNote: string;
} {
  if (isMultiTouch || touchpointCount > 1) {
    const confidence: AttributionConfidence = touchpointCount > 3 ? 'low' : 'medium';
    return {
      sourceClass: 'inferred',
      confidence,
      badgeLabel: 'Attributed (inferred)',
      explanationNote: 'Multiple touch points detected — last click rule applied.',
    };
  }

  if (isOfficialAPI) {
    return {
      sourceClass: 'official',
      confidence: 'high',
      badgeLabel: 'Official',
      explanationNote: 'Official platform API attribution.',
    };
  }

  return {
    sourceClass: 'imported',
    confidence: 'medium',
    badgeLabel: 'Imported',
    explanationNote: 'Imported statement attribution.',
  };
}

/**
 * Acceptance Target 3:
 * Broken link repair workflow.
 * In accordance with RULE-M16-005 & State Machine:
 * Link health check flags broken/out-of-stock destinations.
 * Operator repairs link with replacement product/URL, recovering healthy state.
 * Policy revocation (revoked) is terminal and cannot be reactivated by health check!
 */
export function repairBrokenLink(
  link: AffiliateLink,
  newDestinationUrl: string,
  replacementProductId?: string
): { success: boolean; link: AffiliateLink; error?: string } {
  if (link.lifecycleState === 'revoked') {
    return {
      success: false,
      link,
      error: 'Cannot repair permanently revoked affiliate link',
    };
  }

  const updated: AffiliateLink = {
    ...link,
    originalUrl: newDestinationUrl || link.originalUrl,
    healthStatus: 'healthy',
    suggestedReplacementProductId: replacementProductId || link.suggestedReplacementProductId,
    productId: replacementProductId || link.productId,
    updatedAt: new Date().toISOString(),
  };

  return {
    success: true,
    link: updated,
  };
}

/**
 * UI Badges and formatting
 */
export function getHealthStatusColor(status: LinkHealthStatus): { bg: string; text: string; label: string } {
  switch (status) {
    case 'healthy':
      return { bg: 'bg-emerald-50 dark:bg-emerald-950/30', text: 'text-emerald-700 dark:text-emerald-400', label: 'Healthy' };
    case 'warning':
      return { bg: 'bg-amber-50 dark:bg-amber-950/30', text: 'text-amber-700 dark:text-amber-400', label: 'Warning' };
    case 'broken':
      return { bg: 'bg-rose-50 dark:bg-rose-950/30', text: 'text-rose-700 dark:text-rose-400', label: 'Broken' };
    case 'expired':
      return { bg: 'bg-slate-100 dark:bg-slate-800', text: 'text-slate-600 dark:text-slate-400', label: 'Expired' };
    default:
      return { bg: 'bg-slate-100 dark:bg-slate-800', text: 'text-slate-600 dark:text-slate-400', label: status };
  }
}

export function getSourceClassBadge(sourceClass: AttributionSourceClass): { bg: string; text: string; label: string } {
  switch (sourceClass) {
    case 'official':
      return { bg: 'bg-blue-50 dark:bg-blue-950/30', text: 'text-blue-700 dark:text-blue-400', label: 'Official' };
    case 'inferred':
      return { bg: 'bg-amber-50 dark:bg-amber-950/30', text: 'text-amber-700 dark:text-amber-400', label: 'Inferred' };
    case 'imported':
      return { bg: 'bg-purple-50 dark:bg-purple-950/30', text: 'text-purple-700 dark:text-purple-400', label: 'Imported' };
    case 'unreconciled':
      return { bg: 'bg-rose-50 dark:bg-rose-950/30', text: 'text-rose-700 dark:text-rose-400', label: 'Unreconciled' };
    default:
      return { bg: 'bg-slate-100 dark:bg-slate-800', text: 'text-slate-600 dark:text-slate-400', label: sourceClass };
  }
}
