// Package script provides frontend models, validation logic, approval workflow guards,
// version diffing, and asset brief readiness checks for Module M06 (Script Lab).
// Canonical source: docs/02_features/content/script_lab.md
// and docs/04_contracts/database_schema.md §6.4, §6.5, §6.6, §18.1.

export type ScriptLifecycleState =
  | 'draft'
  | 'in_review'
  | 'approved'
  | 'revision_required'
  | 'ready_for_production'
  | 'archived';

export type ScriptApprovalState =
  | 'unspecified'
  | 'not_submitted'
  | 'pending_approval'
  | 'approved'
  | 'rejected';

export type AssetBriefStatus = 'unspecified' | 'draft' | 'ready' | 'locked' | 'superseded';

export interface Shot {
  shotId: string;
  sceneId: string;
  workspaceId: string;
  shotIndex: number;
  shotType: string;
  description: string;
  durationSeconds: number;
  createdAt: string;
}

export interface Scene {
  sceneId: string;
  scriptId: string;
  workspaceId: string;
  sceneIndex: number;
  description: string;
  content: string;
  durationSeconds: number;
  visualNotes: string;
  audioNotes: string;
  shotList: Shot[];
  createdAt: string;
}

export interface CtaBlock {
  ctaId: string;
  text: string;
  buttonText: string;
  destinationUrl: string;
  ctaType: string;
}

export interface DisclosureBlock {
  disclosureId: string;
  text: string;
  platform: string;
  isDismissed: boolean;
  dismissedBy?: string;
  dismissedAt?: string;
  dismissalReason?: string;
}

export interface PublishTargetProfile {
  platform: string;
  format: string;
  accountId: string;
}

export interface AssetBrief {
  assetBriefId: string;
  workspaceId: string;
  scriptId: string;
  outputType: string;
  targetFormat: string;
  targetDurationSeconds: number;
  targetPlatforms: string[];
  continuityRequirementsJson: string;
  brandVoiceRequirementsJson: string;
  productionInstructions: string;
  status: AssetBriefStatus;
  createdAt: string;
  updatedAt: string;
}

export interface ScriptVersion {
  versionId: string;
  workspaceId: string;
  scriptId: string;
  versionIndex: number;
  title: string;
  scenes: Scene[];
  ctaBlocks: CtaBlock[];
  disclosureBlocks: DisclosureBlock[];
  durationTargetSeconds: number;
  lifecycleState: ScriptLifecycleState;
  approvalState: ScriptApprovalState;
  snapshotReason: string;
  createdBy: string;
  createdAt: string;
}

export interface Script {
  scriptId: string;
  workspaceId: string;
  ideaId?: string;
  sourceIdeaTitle?: string;
  title: string;
  formatType: string;
  scenes: Scene[];
  ctaBlocks: CtaBlock[];
  disclosureBlocks: DisclosureBlock[];
  durationTargetSeconds: number;
  lifecycleState: ScriptLifecycleState;
  approvalState: ScriptApprovalState;
  publishTargetProfiles: PublishTargetProfile[];
  continuityRefs: string[];
  offerProductHooks: string[];
  rejectionReason?: string;
  versionIndex: number;
  createdBy: string;
  approvedBy?: string;
  createdAt: string;
  updatedAt: string;
}

/**
 * Validates non-empty scenes requirement per EC-M06-001:
 * Script must have at least one scene and no scene may have empty or whitespace-only content.
 */
export function validateScenesForSubmission(scenes: Scene[]): {
  valid: boolean;
  error?: string;
} {
  if (!scenes || scenes.length === 0) {
    return {
      valid: false,
      error: 'Kịch bản phải có ít nhất 1 phân cảnh trước khi gửi duyệt.'
    };
  }
  for (let i = 0; i < scenes.length; i++) {
    const sc = scenes[i];
    if (!sc.content || sc.content.trim() === '') {
      return {
        valid: false,
        error: `Phân cảnh #${i + 1} chưa có nội dung. Vui lòng hoàn thiện toàn bộ phân cảnh trước khi gửi duyệt (EC-M06-001).`
      };
    }
  }
  return { valid: true };
}

/**
 * Validates rejection feedback requirement per RULE-M06-002, EC-M06-002:
 * Rejection reason must be at least 10 characters of actionable feedback.
 */
export function validateRejectionReason(reason: string): {
  valid: boolean;
  error?: string;
  characterCount: number;
} {
  const trimmed = (reason || '').trim();
  if (trimmed.length < 10) {
    return {
      valid: false,
      error: 'Lý do từ chối phải có ít nhất 10 ký tự phản hồi cụ thể để tác giả chỉnh sửa (RULE-M06-002, EC-M06-002).',
      characterCount: trimmed.length
    };
  }
  return { valid: true, characterCount: trimmed.length };
}

/**
 * Validates if an Asset Brief has all mandatory production fields populated per RULE-M06-005.
 */
export function isAssetBriefComplete(brief?: Partial<AssetBrief> | null): boolean {
  if (!brief) return false;
  if (!brief.outputType || brief.outputType.trim() === '') return false;
  if (!brief.targetFormat || brief.targetFormat.trim() === '') return false;
  if (!brief.targetDurationSeconds || brief.targetDurationSeconds <= 0) return false;
  if (
    !brief.continuityRequirementsJson ||
    brief.continuityRequirementsJson.trim() === '' ||
    brief.continuityRequirementsJson.trim() === '{}'
  ) {
    return false;
  }
  return true;
}

/**
 * Validates whether a script is eligible to transition to 'ready_for_production' per RULE-M06-005, RULE-M06-006, AC-2.
 * Requires:
 * 1. Script approvalState === 'approved'
 * 2. AssetBrief is complete
 */
export function isReadyForProductionEligible(
  script: Script,
  brief?: AssetBrief | null
): {
  eligible: boolean;
  reasons: string[];
} {
  const reasons: string[] = [];

  if (script.approvalState !== 'approved') {
    reasons.push('Kịch bản chưa được người quản lý duyệt (Approval State phải là Approved).');
  }

  if (!brief) {
    reasons.push('Chưa tạo Bản tóm tắt sản xuất (Asset Brief) liên kết với kịch bản.');
  } else if (!isAssetBriefComplete(brief)) {
    reasons.push('Bản tóm tắt sản xuất chưa hoàn chỉnh (thiếu định dạng, thời lượng mục tiêu hoặc yêu cầu tính liên tục).');
  }

  return {
    eligible: reasons.length === 0,
    reasons
  };
}

/**
 * Detects stale review conflict per EC-M06-003.
 * Returns true if author updated the script since reviewer opened it.
 */
export function isReviewStale(
  currentScriptVersion: number,
  reviewerExpectedVersion: number
): boolean {
  if (reviewerExpectedVersion <= 0) return false;
  return currentScriptVersion !== reviewerExpectedVersion;
}

/**
 * Computes total estimated duration across all scenes.
 */
export function calculateTotalDuration(scenes: Scene[]): number {
  if (!scenes) return 0;
  return scenes.reduce((total, sc) => total + (sc.durationSeconds || 0), 0);
}

/**
 * Computes total word count across all scenes.
 */
export function calculateWordCount(scenes: Scene[]): number {
  if (!scenes) return 0;
  return scenes.reduce((total, sc) => {
    const words = (sc.content || '').trim().split(/\s+/).filter(Boolean);
    return total + words.length;
  }, 0);
}

/**
 * Auto-suggests legal disclosure block if commercial offer hooks are present (RULE-M06-007).
 */
export function suggestDisclosureForHooks(
  offerProductHooks: string[],
  platform = 'all'
): DisclosureBlock | null {
  if (!offerProductHooks || offerProductHooks.length === 0) {
    return null;
  }
  return {
    disclosureId: `disc-${Date.now()}`,
    text: 'Bao gồm nội dung tài trợ / quảng bá sản phẩm liên kết (RULE-M06-007)',
    platform,
    isDismissed: false
  };
}
