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

import {
  callCanonicalRpc,
  generateIdempotencyKey,
  type CanonicalRpcOptions
} from '$lib/api/client';

export function normalizeScriptLifecycleState(raw: unknown): ScriptLifecycleState | null {
  if (typeof raw === 'number') {
    switch (raw) {
      case 1:
        return 'draft';
      case 2:
        return 'in_review';
      case 3:
        return 'approved';
      case 4:
        return 'revision_required';
      case 5:
        return 'ready_for_production';
      case 6:
        return 'archived';
      default:
        return null;
    }
  }
  if (typeof raw !== 'string') return null;
  const cleaned = raw
    .trim()
    .toLowerCase()
    .replace(/^script_lifecycle_state_/, '');
  switch (cleaned) {
    case 'draft':
    case 'in_review':
    case 'approved':
    case 'revision_required':
    case 'ready_for_production':
    case 'archived':
      return cleaned;
    default:
      return null;
  }
}

export function normalizeScriptApprovalState(raw: unknown): ScriptApprovalState | null {
  if (typeof raw === 'number') {
    switch (raw) {
      case 0:
        return 'unspecified';
      case 1:
        return 'not_submitted';
      case 2:
        return 'pending_approval';
      case 3:
        return 'approved';
      case 4:
        return 'rejected';
      default:
        return null;
    }
  }
  if (typeof raw !== 'string') return null;
  const cleaned = raw
    .trim()
    .toLowerCase()
    .replace(/^script_approval_state_/, '');
  switch (cleaned) {
    case 'unspecified':
    case 'not_submitted':
    case 'pending_approval':
    case 'approved':
    case 'rejected':
      return cleaned;
    default:
      return null;
  }
}

export function normalizeAssetBriefStatus(raw: unknown): AssetBriefStatus {
  if (typeof raw === 'number') {
    switch (raw) {
      case 1:
        return 'draft';
      case 2:
        return 'ready';
      case 3:
        return 'locked';
      case 4:
        return 'superseded';
      default:
        return 'unspecified';
    }
  }
  if (typeof raw !== 'string') return 'unspecified';
  const cleaned = raw
    .trim()
    .toLowerCase()
    .replace(/^asset_brief_status_/, '');
  switch (cleaned) {
    case 'draft':
    case 'ready':
    case 'locked':
    case 'superseded':
      return cleaned;
    default:
      return 'unspecified';
  }
}

function parseRemoteScene(
  raw: Record<string, any>,
  index: number,
  fallbackScriptId: string,
  fallbackWorkspaceId: string
): Scene {
  const rawShots = Array.isArray(raw.shot_list ?? raw.shotList) ? (raw.shot_list ?? raw.shotList) : [];
  const sceneId = String(raw.scene_id || raw.sceneId || `sc-${index + 1}`).trim();
  return {
    sceneId,
    scriptId: String(raw.script_id || raw.scriptId || fallbackScriptId).trim(),
    workspaceId: String(raw.workspace_id || raw.workspaceId || fallbackWorkspaceId).trim(),
    sceneIndex:
      typeof (raw.scene_index ?? raw.sceneIndex) === 'number'
        ? Number(raw.scene_index ?? raw.sceneIndex)
        : index,
    description: String(raw.description || ''),
    content: String(raw.content || ''),
    durationSeconds: Number(raw.duration_seconds ?? raw.durationSeconds ?? 0) || 0,
    visualNotes: String(raw.visual_notes ?? raw.visualNotes ?? ''),
    audioNotes: String(raw.audio_notes ?? raw.audioNotes ?? ''),
    shotList: rawShots.map((sh: Record<string, any>, shotIdx: number) => ({
      shotId: String(sh?.shot_id || sh?.shotId || `${sceneId}-shot-${shotIdx + 1}`),
      sceneId,
      workspaceId: String(sh?.workspace_id || sh?.workspaceId || fallbackWorkspaceId),
      shotIndex: typeof (sh?.shot_index ?? sh?.shotIndex) === 'number' ? Number(sh.shot_index ?? sh.shotIndex) : shotIdx,
      shotType: String(sh?.shot_type ?? sh?.shotType ?? 'medium_shot'),
      description: String(sh?.description || ''),
      durationSeconds: Number(sh?.duration_seconds ?? sh?.durationSeconds ?? 0) || 0,
      createdAt: String(sh?.created_at ?? sh?.createdAt ?? '')
    })),
    createdAt: String(raw.created_at ?? raw.createdAt ?? '')
  };
}

function toProtoScenes(scenes: Scene[], scriptId: string, workspaceId: string) {
  return scenes.map((sc, idx) => ({
    scene_id: sc.sceneId,
    script_id: sc.scriptId || scriptId,
    workspace_id: sc.workspaceId || workspaceId,
    scene_index: typeof sc.sceneIndex === 'number' ? sc.sceneIndex : idx,
    description: sc.description,
    content: sc.content,
    duration_seconds: sc.durationSeconds,
    visual_notes: sc.visualNotes,
    audio_notes: sc.audioNotes,
    shot_list: (sc.shotList || []).map((sh, shotIdx) => ({
      shot_id: sh.shotId,
      scene_id: sc.sceneId,
      workspace_id: sh.workspaceId || workspaceId,
      shot_index: typeof sh.shotIndex === 'number' ? sh.shotIndex : shotIdx,
      shot_type: sh.shotType,
      description: sh.description,
      duration_seconds: sh.durationSeconds
    }))
  }));
}

export function parseRemoteScriptPayload(
  raw: unknown,
  fallbackWorkspaceId = ''
): Script | null {
  if (!raw || typeof raw !== 'object') return null;
  const obj = raw as Record<string, any>;
  const scriptObj = (obj.script && typeof obj.script === 'object' ? obj.script : obj) as Record<
    string,
    any
  >;

  const scriptId = String(
    scriptObj.script_id || scriptObj.scriptId || scriptObj.id || ''
  ).trim();
  if (!scriptId) return null;

  const rawVersion =
    scriptObj.version_index ?? scriptObj.versionIndex ?? scriptObj.version;
  const parsedVersion =
    typeof rawVersion === 'number'
      ? rawVersion
      : typeof rawVersion === 'string' && rawVersion.trim() !== ''
        ? Number(rawVersion)
        : NaN;
  if (!Number.isFinite(parsedVersion) || parsedVersion <= 0) {
    return null;
  }

  const workspaceId = String(
    scriptObj.workspace_id || scriptObj.workspaceId || fallbackWorkspaceId
  ).trim();
  const rawScenes = Array.isArray(scriptObj.scenes)
    ? scriptObj.scenes
    : Array.isArray(scriptObj.body)
      ? scriptObj.body
      : [];
  const scenes = rawScenes.map((sc: Record<string, any>, idx: number) =>
    parseRemoteScene(sc || {}, idx, scriptId, workspaceId)
  );

  const lifecycleState =
    normalizeScriptLifecycleState(
      scriptObj.lifecycle_state ?? scriptObj.lifecycleState
    ) || 'draft';
  const rawApproval = normalizeScriptApprovalState(
    scriptObj.approval_state ?? scriptObj.approvalState
  );
  const approvalState: ScriptApprovalState =
    rawApproval && rawApproval !== 'unspecified' ? rawApproval : 'not_submitted';

  return {
    scriptId,
    workspaceId,
    ideaId: scriptObj.idea_id || scriptObj.ideaId || undefined,
    sourceIdeaTitle: scriptObj.source_idea_title || scriptObj.sourceIdeaTitle || undefined,
    title: String(scriptObj.title || ''),
    formatType: String(scriptObj.format_type || scriptObj.formatType || '9:16 vertical short'),
    scenes,
    ctaBlocks: Array.isArray(scriptObj.cta_blocks ?? scriptObj.ctaBlocks)
      ? (scriptObj.cta_blocks ?? scriptObj.ctaBlocks)
      : [],
    disclosureBlocks: Array.isArray(scriptObj.disclosure_blocks ?? scriptObj.disclosureBlocks)
      ? (scriptObj.disclosure_blocks ?? scriptObj.disclosureBlocks)
      : [],
    durationTargetSeconds:
      Number(
        scriptObj.duration_target_seconds ??
          scriptObj.durationTargetSeconds ??
          calculateTotalDuration(scenes)
      ) || 60,
    lifecycleState,
    approvalState,
    publishTargetProfiles: Array.isArray(
      scriptObj.publish_target_profiles ?? scriptObj.publishTargetProfiles
    )
      ? (scriptObj.publish_target_profiles ?? scriptObj.publishTargetProfiles)
      : [],
    continuityRefs: Array.isArray(scriptObj.continuity_refs ?? scriptObj.continuityRefs)
      ? (scriptObj.continuity_refs ?? scriptObj.continuityRefs)
      : [],
    offerProductHooks: Array.isArray(scriptObj.offer_product_hooks ?? scriptObj.offerProductHooks)
      ? (scriptObj.offer_product_hooks ?? scriptObj.offerProductHooks)
      : [],
    rejectionReason: scriptObj.rejection_reason ?? scriptObj.rejectionReason ?? undefined,
    versionIndex: parsedVersion,
    createdBy: String(scriptObj.created_by ?? scriptObj.createdBy ?? ''),
    approvedBy: scriptObj.approved_by ?? scriptObj.approvedBy ?? undefined,
    createdAt: String(scriptObj.created_at ?? scriptObj.createdAt ?? ''),
    updatedAt: String(scriptObj.updated_at ?? scriptObj.updatedAt ?? '')
  };
}

function isStaleConflictError(code?: string, message?: string, httpStatus?: number): boolean {
  if (httpStatus === 409 || httpStatus === 412) return true;
  if (code && /CONFLICT|PRECONDITION|STALE/i.test(code)) return true;
  if (message && /conflict|updated since|stale|expected_version|version mismatch/i.test(message)) {
    return true;
  }
  return false;
}

export async function loadScriptRemote(
  params: { workspaceId?: string; scriptId: string },
  options: CanonicalRpcOptions = {}
): Promise<{
  ok: boolean;
  script?: Script;
  assetBrief?: AssetBrief;
  error?: string;
}> {
  const scriptId = String(params.scriptId || '').trim();
  if (!scriptId) {
    return {
      ok: false,
      error: 'Thiếu mã định danh kịch bản (script_id) (fail-closed).'
    };
  }

  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    Record<string, any>
  >(
    'creativanta.content.v1.ScriptService/Get',
    {
      workspace_id: params.workspaceId,
      script_id: scriptId
    },
    {
      ...options,
      workspaceId: options.workspaceId ?? params.workspaceId
    }
  );

  if (!rpcRes.ok) {
    return {
      ok: false,
      error: rpcRes.error.message
    };
  }

  const parsed = parseRemoteScriptPayload(rpcRes.data, params.workspaceId || '');
  if (!parsed || parsed.scriptId !== scriptId) {
    return {
      ok: false,
      error: 'Phản hồi từ máy chủ thiếu dữ liệu kịch bản hoặc version hợp lệ (fail-closed).'
    };
  }

  const rawBrief = rpcRes.data?.asset_brief ?? rpcRes.data?.assetBrief;
  let assetBrief: AssetBrief | undefined;
  if (rawBrief && typeof rawBrief === 'object') {
    const briefId = String(rawBrief.asset_brief_id || rawBrief.assetBriefId || '').trim();
    if (briefId) {
      assetBrief = {
        assetBriefId: briefId,
        workspaceId: String(rawBrief.workspace_id || rawBrief.workspaceId || parsed.workspaceId),
        scriptId: String(rawBrief.script_id || rawBrief.scriptId || parsed.scriptId),
        outputType: String(rawBrief.output_type || rawBrief.outputType || ''),
        targetFormat: String(rawBrief.target_format || rawBrief.targetFormat || ''),
        targetDurationSeconds:
          Number(rawBrief.target_duration_seconds ?? rawBrief.targetDurationSeconds ?? 0) || 0,
        targetPlatforms: Array.isArray(rawBrief.target_platforms ?? rawBrief.targetPlatforms)
          ? (rawBrief.target_platforms ?? rawBrief.targetPlatforms)
          : [],
        continuityRequirementsJson: String(
          rawBrief.continuity_requirements_json ?? rawBrief.continuityRequirementsJson ?? ''
        ),
        brandVoiceRequirementsJson: String(
          rawBrief.brand_voice_requirements_json ?? rawBrief.brandVoiceRequirementsJson ?? ''
        ),
        productionInstructions: String(
          rawBrief.production_instructions ?? rawBrief.productionInstructions ?? ''
        ),
        status: normalizeAssetBriefStatus(rawBrief.status),
        createdAt: String(rawBrief.created_at ?? rawBrief.createdAt ?? ''),
        updatedAt: String(rawBrief.updated_at ?? rawBrief.updatedAt ?? '')
      };
    }
  }

  return {
    ok: true,
    script: parsed,
    assetBrief
  };
}

export interface SaveScriptRemoteInput {
  workspaceId?: string;
  scriptId: string;
  title: string;
  formatType: string;
  durationTargetSeconds: number;
  expectedVersion: number;
  scenes: Scene[];
  ctaBlocks?: CtaBlock[];
  disclosureBlocks?: DisclosureBlock[];
  publishTargetProfiles?: PublishTargetProfile[];
  continuityRefs?: string[];
  offerProductHooks?: string[];
}

export interface SaveScriptRemoteResult {
  ok: boolean;
  script?: Script;
  conflict?: boolean;
  error?: string;
}

export async function saveScriptRemote(
  input: SaveScriptRemoteInput,
  options: CanonicalRpcOptions = {}
): Promise<SaveScriptRemoteResult> {
  const title = String(input.title || '').trim();
  if (!title) {
    return {
      ok: false,
      error: 'Tiêu đề kịch bản không được để trống.'
    };
  }
  if (!Number.isFinite(input.expectedVersion) || input.expectedVersion <= 0) {
    return {
      ok: false,
      error: 'Thiếu số phiên bản gốc (expected_version) để kiểm soát đồng thời (fail-closed).'
    };
  }

  const workspaceId = String(options.workspaceId ?? input.workspaceId ?? '').trim();
  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    Record<string, any>
  >(
    'creativanta.content.v1.ScriptService/Update',
    {
      idempotency_key: options.idempotencyKey || generateIdempotencyKey('script-save'),
      workspace_id: workspaceId || undefined,
      script_id: input.scriptId,
      title,
      format_type: input.formatType,
      duration_target_seconds: input.durationTargetSeconds,
      expected_version: input.expectedVersion,
      scenes: toProtoScenes(input.scenes, input.scriptId, workspaceId),
      cta_blocks: input.ctaBlocks ?? [],
      disclosure_blocks: input.disclosureBlocks ?? [],
      publish_target_profiles: input.publishTargetProfiles ?? [],
      continuity_refs: input.continuityRefs ?? [],
      offer_product_hooks: input.offerProductHooks ?? []
    },
    {
      ...options,
      workspaceId: workspaceId || undefined
    }
  );

  if (!rpcRes.ok) {
    const conflict = isStaleConflictError(
      rpcRes.error.code,
      rpcRes.error.message,
      rpcRes.error.status
    );
    return {
      ok: false,
      conflict,
      error: rpcRes.error.message
    };
  }

  const parsed = parseRemoteScriptPayload(rpcRes.data, workspaceId);
  if (!parsed || parsed.scriptId !== input.scriptId) {
    return {
      ok: false,
      error:
        'Phản hồi từ máy chủ không xác nhận kịch bản và phiên bản mới (version_index). Không tăng version giả lập (fail-closed).'
    };
  }

  return {
    ok: true,
    script: parsed
  };
}

export interface SubmitScriptApprovalRemoteInput {
  workspaceId?: string;
  scriptId: string;
  expectedVersion: number;
  scenes: Scene[];
  reviewerId?: string;
}

export interface SubmitScriptApprovalRemoteResult {
  ok: boolean;
  script?: Script;
  approvalRequestId?: string;
  conflict?: boolean;
  error?: string;
}

export async function submitScriptApprovalRemote(
  input: SubmitScriptApprovalRemoteInput,
  options: CanonicalRpcOptions = {}
): Promise<SubmitScriptApprovalRemoteResult> {
  const sceneValidation = validateScenesForSubmission(input.scenes);
  if (!sceneValidation.valid) {
    return {
      ok: false,
      error: sceneValidation.error
    };
  }
  if (!Number.isFinite(input.expectedVersion) || input.expectedVersion <= 0) {
    return {
      ok: false,
      error: 'Không thể gửi duyệt khi kịch bản chưa có phiên bản được đồng bộ từ máy chủ (fail-closed).'
    };
  }

  const workspaceId = String(options.workspaceId ?? input.workspaceId ?? '').trim();
  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    Record<string, any>
  >(
    'creativanta.content.v1.ScriptService/SubmitApproval',
    {
      idempotency_key: options.idempotencyKey || generateIdempotencyKey('script-submit-approval'),
      workspace_id: workspaceId || undefined,
      script_id: input.scriptId,
      expected_version: input.expectedVersion,
      reviewer_id: input.reviewerId || ''
    },
    {
      ...options,
      workspaceId: workspaceId || undefined
    }
  );

  if (!rpcRes.ok) {
    const conflict = isStaleConflictError(
      rpcRes.error.code,
      rpcRes.error.message,
      rpcRes.error.status
    );
    return {
      ok: false,
      conflict,
      error: rpcRes.error.message
    };
  }

  const parsed = parseRemoteScriptPayload(rpcRes.data, workspaceId);
  const approvalRequestId = String(
    rpcRes.data?.approval_request_id || rpcRes.data?.approvalRequestId || ''
  ).trim();
  if (
    !parsed ||
    parsed.scriptId !== input.scriptId ||
    parsed.approvalState !== 'pending_approval' ||
    !approvalRequestId
  ) {
    return {
      ok: false,
      error:
        'Phản hồi máy chủ thiếu xác nhận trạng thái chờ duyệt (pending_approval) hoặc mã yêu cầu phê duyệt (approval_request_id) (fail-closed).'
    };
  }

  return {
    ok: true,
    script: parsed,
    approvalRequestId
  };
}

export async function approveScriptRemote(
  params: {
    workspaceId?: string;
    scriptId: string;
    expectedVersion: number;
    reviewerSnapshotTime?: string;
  },
  options: CanonicalRpcOptions = {}
): Promise<SaveScriptRemoteResult> {
  if (!Number.isFinite(params.expectedVersion) || params.expectedVersion <= 0) {
    return {
      ok: false,
      error: 'Không thể phê duyệt khi kịch bản chưa được tải từ máy chủ (fail-closed).'
    };
  }

  const workspaceId = String(options.workspaceId ?? params.workspaceId ?? '').trim();
  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    Record<string, any>
  >(
    'creativanta.content.v1.ScriptService/Approve',
    {
      idempotency_key: options.idempotencyKey || generateIdempotencyKey('script-approve'),
      workspace_id: workspaceId || undefined,
      script_id: params.scriptId,
      expected_version: params.expectedVersion,
      reviewer_snapshot_time: params.reviewerSnapshotTime
    },
    {
      ...options,
      workspaceId: workspaceId || undefined
    }
  );

  if (!rpcRes.ok) {
    return {
      ok: false,
      conflict: isStaleConflictError(
        rpcRes.error.code,
        rpcRes.error.message,
        rpcRes.error.status
      ),
      error: rpcRes.error.message
    };
  }

  const parsed = parseRemoteScriptPayload(rpcRes.data, workspaceId);
  if (!parsed || parsed.approvalState !== 'approved') {
    return {
      ok: false,
      error: 'Phản hồi từ máy chủ không xác nhận trạng thái đã phê duyệt (approved) (fail-closed).'
    };
  }

  return {
    ok: true,
    script: parsed
  };
}

export async function rejectScriptRemote(
  params: {
    workspaceId?: string;
    scriptId: string;
    rejectionReason: string;
    expectedVersion: number;
    reviewerSnapshotTime?: string;
  },
  options: CanonicalRpcOptions = {}
): Promise<SaveScriptRemoteResult> {
  const reasonCheck = validateRejectionReason(params.rejectionReason);
  if (!reasonCheck.valid) {
    return {
      ok: false,
      error: reasonCheck.error
    };
  }
  if (!Number.isFinite(params.expectedVersion) || params.expectedVersion <= 0) {
    return {
      ok: false,
      error: 'Không thể từ chối khi kịch bản chưa được tải từ máy chủ (fail-closed).'
    };
  }

  const workspaceId = String(options.workspaceId ?? params.workspaceId ?? '').trim();
  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    Record<string, any>
  >(
    'creativanta.content.v1.ScriptService/Reject',
    {
      idempotency_key: options.idempotencyKey || generateIdempotencyKey('script-reject'),
      workspace_id: workspaceId || undefined,
      script_id: params.scriptId,
      rejection_reason: params.rejectionReason.trim(),
      expected_version: params.expectedVersion,
      reviewer_snapshot_time: params.reviewerSnapshotTime
    },
    {
      ...options,
      workspaceId: workspaceId || undefined
    }
  );

  if (!rpcRes.ok) {
    return {
      ok: false,
      conflict: isStaleConflictError(
        rpcRes.error.code,
        rpcRes.error.message,
        rpcRes.error.status
      ),
      error: rpcRes.error.message
    };
  }

  const parsed = parseRemoteScriptPayload(rpcRes.data, workspaceId);
  if (!parsed || parsed.approvalState !== 'rejected') {
    return {
      ok: false,
      error: 'Phản hồi từ máy chủ không xác nhận trạng thái từ chối (rejected) (fail-closed).'
    };
  }

  return {
    ok: true,
    script: parsed
  };
}

export type ScriptEditorLoadState = 'waiting_context' | 'loading' | 'loaded' | 'error';

export function cloneScenes(scenes: Scene[]): Scene[] {
  return (scenes || []).map((sc, idx) => ({
    ...sc,
    sceneIndex: typeof sc.sceneIndex === 'number' ? sc.sceneIndex : idx,
    shotList: (sc.shotList || []).map((sh, shotIdx) => ({
      ...sh,
      shotIndex: typeof sh.shotIndex === 'number' ? sh.shotIndex : shotIdx
    }))
  }));
}

export function updateSceneInList(
  scenes: Scene[],
  sceneIndex: number,
  patch: Partial<Scene>
): Scene[] {
  return cloneScenes(scenes).map((sc, idx) => {
    if (idx !== sceneIndex) return sc;
    const nextShots = patch.shotList
      ? patch.shotList.map((sh, shotIdx) => ({
          ...sh,
          shotIndex: typeof sh.shotIndex === 'number' ? sh.shotIndex : shotIdx
        }))
      : sc.shotList;
    return {
      ...sc,
      ...patch,
      sceneIndex: idx,
      shotList: nextShots
    };
  });
}

export function updateShotInList(
  scenes: Scene[],
  sceneIndex: number,
  shotIndex: number,
  patch: Partial<Shot>
): Scene[] {
  return cloneScenes(scenes).map((sc, idx) => {
    if (idx !== sceneIndex) return sc;
    return {
      ...sc,
      shotList: (sc.shotList || []).map((sh, sIdx) =>
        sIdx === shotIndex
          ? {
              ...sh,
              ...patch,
              shotIndex: sIdx
            }
          : sh
      )
    };
  });
}

interface PersistedScriptBaseline {
  title: string;
  formatType: string;
  durationTargetSeconds: number;
  scenesSignature: string;
}

function serializeScenesSignature(scenes: Scene[]): string {
  return JSON.stringify(
    (scenes || []).map((sc, idx) => ({
      sceneId: String(sc.sceneId || ''),
      sceneIndex: typeof sc.sceneIndex === 'number' ? sc.sceneIndex : idx,
      description: String(sc.description || ''),
      content: String(sc.content || ''),
      durationSeconds: Number(sc.durationSeconds || 0) || 0,
      visualNotes: String(sc.visualNotes || ''),
      audioNotes: String(sc.audioNotes || ''),
      shotList: (sc.shotList || []).map((sh, sIdx) => ({
        shotId: String(sh.shotId || ''),
        shotIndex: typeof sh.shotIndex === 'number' ? sh.shotIndex : sIdx,
        shotType: String(sh.shotType || ''),
        description: String(sh.description || ''),
        durationSeconds: Number(sh.durationSeconds || 0) || 0
      }))
    }))
  );
}

function buildPersistedBaseline(
  title: string,
  formatType: string,
  durationTargetSeconds: number,
  scenes: Scene[]
): PersistedScriptBaseline {
  return {
    title: String(title || '').trim(),
    formatType: String(formatType || ''),
    durationTargetSeconds: Number(durationTargetSeconds || 0) || 0,
    scenesSignature: serializeScenesSignature(scenes)
  };
}

function isDraftDirtyAgainstBaseline(
  draft: {
    title: string;
    formatType: string;
    durationTargetSeconds: number;
    scenes: Scene[];
  },
  baseline: PersistedScriptBaseline | null
): boolean {
  if (!baseline) return false;
  if (String(draft.title || '').trim() !== baseline.title) return true;
  if (String(draft.formatType || '') !== baseline.formatType) return true;
  if ((Number(draft.durationTargetSeconds || 0) || 0) !== baseline.durationTargetSeconds) {
    return true;
  }
  return serializeScenesSignature(draft.scenes) !== baseline.scenesSignature;
}

export interface ScriptEditorSessionSnapshot {
  scriptId: string;
  workspaceId: string | null;
  userId: string | null;
  loadState: ScriptEditorLoadState;
  loadedContextKey: string | null;
  title: string;
  formatType: string;
  durationTargetSeconds: number;
  versionIndex: number | null;
  lifecycleState: ScriptLifecycleState;
  approvalState: ScriptApprovalState;
  rejectionReason: string;
  scenes: Scene[];
  isDirty: boolean;
  isConflict: boolean;
  conflictReason: string;
  saveFeedback: string;
  error: string | null;
  approvalRequestId: string | null;
  isPersisting: boolean;
  isReverifying: boolean;
}

export interface ScriptEditorContextInput {
  userId?: string | null;
  workspaceId?: string | null;
  scriptId?: string | null;
  authState?: string;
  isDiscoveryLoading?: boolean;
  force?: boolean;
}

/**
 * Fail-closed state controller for Script Lab editor (`/scripts/[id]`, M06).
 *
 * Guarantees:
 * 1. Never increments `versionIndex`, clears `isConflict`, or reports save/review success without backend RPC confirmation (N3).
 * 2. Locks `save()` and `submitForReview()` when `loadState !== 'loaded'`, `isReverifying === true`, `isPersisting === true`, or `versionIndex === null`.
 * 3. Preserves unsaved edits and in-flight mutations across same-tenant re-discovery while purging state immediately on user/workspace switch or logout.
 * 4. Tracks `isDirty` across title, format, duration, scene, and shot edits (R2) and persists dirty edits via `ScriptService/Update` before `ScriptService/SubmitApproval` (failing closed if `Update` fails or conflicts) (R3).
 */
export function createScriptEditorSession(initialScriptId: string) {
  let state: ScriptEditorSessionSnapshot = {
    scriptId: String(initialScriptId || '').trim(),
    workspaceId: null,
    userId: null,
    loadState: 'waiting_context',
    loadedContextKey: null,
    title: '',
    formatType: '9:16 vertical short',
    durationTargetSeconds: 60,
    versionIndex: null,
    lifecycleState: 'draft',
    approvalState: 'not_submitted',
    rejectionReason: '',
    scenes: [],
    isDirty: false,
    isConflict: false,
    conflictReason: '',
    saveFeedback: '',
    error: null,
    approvalRequestId: null,
    isPersisting: false,
    isReverifying: false
  };

  let persistedBaseline: PersistedScriptBaseline | null = null;
  let loadEpoch = 0;
  let pendingMutations = 0;
  const subscribers = new Set<(snapshot: ScriptEditorSessionSnapshot) => void>();

  function getSnapshot(): ScriptEditorSessionSnapshot {
    return {
      ...state,
      scenes: cloneScenes(state.scenes)
    };
  }

  function emit() {
    const snap = getSnapshot();
    for (const sub of subscribers) {
      sub(snap);
    }
  }

  function subscribe(run: (snapshot: ScriptEditorSessionSnapshot) => void): () => void {
    subscribers.add(run);
    run(getSnapshot());
    return () => {
      subscribers.delete(run);
    };
  }

  async function syncContext(
    ctx: ScriptEditorContextInput,
    options: CanonicalRpcOptions = {}
  ): Promise<{
    ok: boolean;
    loadState: ScriptEditorLoadState;
    stale?: boolean;
    error?: string;
  }> {
    const targetScriptId = String(ctx.scriptId ?? state.scriptId ?? '').trim();
    const targetUserId = String(ctx.userId ?? '').trim() || null;
    const targetWorkspaceId = String(ctx.workspaceId ?? '').trim() || null;
    const isAuthenticated = ctx.authState === undefined || ctx.authState === 'authenticated';

    const hasLoadedScriptForSameSubject =
      state.loadedContextKey !== null &&
      state.versionIndex !== null &&
      isAuthenticated &&
      Boolean(targetUserId) &&
      targetUserId === state.userId &&
      Boolean(targetScriptId) &&
      targetScriptId === state.scriptId &&
      (targetWorkspaceId === null || targetWorkspaceId === state.workspaceId);

    if (ctx.isDiscoveryLoading === true && hasLoadedScriptForSameSubject) {
      state = {
        ...state,
        isReverifying: true,
        isPersisting: pendingMutations > 0,
        error: null
      };
      emit();
      return {
        ok: false,
        loadState: state.loadState
      };
    }

    if (
      ctx.isDiscoveryLoading === true ||
      !isAuthenticated ||
      !targetUserId ||
      !targetWorkspaceId ||
      !targetScriptId
    ) {
      loadEpoch += 1;
      pendingMutations = 0;
      persistedBaseline = null;
      state = {
        scriptId: targetScriptId,
        workspaceId: targetWorkspaceId,
        userId: targetUserId,
        loadState: 'waiting_context',
        loadedContextKey: null,
        title: '',
        formatType: '9:16 vertical short',
        durationTargetSeconds: 60,
        versionIndex: null,
        lifecycleState: 'draft',
        approvalState: 'not_submitted',
        rejectionReason: '',
        scenes: [],
        isDirty: false,
        isConflict: false,
        conflictReason: '',
        saveFeedback: '',
        error: null,
        approvalRequestId: null,
        isPersisting: false,
        isReverifying: false
      };
      emit();
      return {
        ok: false,
        loadState: 'waiting_context'
      };
    }

    const contextKey = `${targetUserId}:${targetWorkspaceId}:${targetScriptId}`;
    if (
      !ctx.force &&
      state.loadedContextKey === contextKey &&
      state.versionIndex !== null &&
      (state.loadState === 'loaded' || state.isReverifying)
    ) {
      if (
        state.loadState !== 'loaded' ||
        state.isReverifying ||
        state.isPersisting !== (pendingMutations > 0) ||
        state.error !== null
      ) {
        state = {
          ...state,
          loadState: 'loaded',
          isReverifying: false,
          isPersisting: pendingMutations > 0,
          error: null
        };
        emit();
      }
      return {
        ok: true,
        loadState: 'loaded'
      };
    }

    const requestEpoch = ++loadEpoch;
    pendingMutations = 0;
    persistedBaseline = null;
    state = {
      scriptId: targetScriptId,
      workspaceId: targetWorkspaceId,
      userId: targetUserId,
      loadState: 'loading',
      loadedContextKey: null,
      title: '',
      formatType: '9:16 vertical short',
      durationTargetSeconds: 60,
      versionIndex: null,
      lifecycleState: 'draft',
      approvalState: 'not_submitted',
      rejectionReason: '',
      scenes: [],
      isDirty: false,
      isConflict: false,
      conflictReason: '',
      saveFeedback: '',
      error: null,
      approvalRequestId: null,
      isPersisting: false,
      isReverifying: false
    };
    emit();

    const res = await loadScriptRemote(
      {
        workspaceId: targetWorkspaceId,
        scriptId: targetScriptId
      },
      {
        ...options,
        workspaceId: targetWorkspaceId
      }
    );

    if (requestEpoch !== loadEpoch) {
      return {
        ok: false,
        stale: true,
        loadState: state.loadState
      };
    }

    if (!res.ok || !res.script || res.script.scriptId !== targetScriptId) {
      const errMessage =
        res.error ||
        'Không thể tải kịch bản từ máy chủ (ScriptService/Get). Đã khóa thao tác lưu và gửi duyệt để tránh mất dữ liệu (fail-closed).';
      persistedBaseline = null;
      state = {
        ...state,
        loadState: 'error',
        loadedContextKey: null,
        versionIndex: null,
        scenes: [],
        isDirty: false,
        saveFeedback: '',
        error: errMessage,
        isPersisting: false,
        isReverifying: false
      };
      emit();
      return {
        ok: false,
        loadState: 'error',
        error: errMessage
      };
    }

    const loadedScenes = cloneScenes(res.script.scenes);
    persistedBaseline = buildPersistedBaseline(
      res.script.title,
      res.script.formatType,
      res.script.durationTargetSeconds,
      loadedScenes
    );
    state = {
      scriptId: res.script.scriptId,
      workspaceId: targetWorkspaceId,
      userId: targetUserId,
      loadState: 'loaded',
      loadedContextKey: contextKey,
      title: res.script.title,
      formatType: res.script.formatType,
      durationTargetSeconds: res.script.durationTargetSeconds,
      versionIndex: res.script.versionIndex,
      lifecycleState: res.script.lifecycleState,
      approvalState: res.script.approvalState,
      rejectionReason: res.script.rejectionReason || '',
      scenes: loadedScenes,
      isDirty: false,
      isConflict: false,
      conflictReason: '',
      saveFeedback: '',
      error: null,
      approvalRequestId: state.approvalRequestId,
      isPersisting: false,
      isReverifying: false
    };
    emit();
    return {
      ok: true,
      loadState: 'loaded'
    };
  }

  function applyDraftChange(patch: Partial<Pick<ScriptEditorSessionSnapshot, 'title' | 'formatType' | 'durationTargetSeconds' | 'scenes'>>) {
    if (state.loadState !== 'loaded' || state.isReverifying || state.isPersisting) return;
    const nextTitle = patch.title !== undefined ? patch.title : state.title;
    const nextFormatType = patch.formatType !== undefined ? patch.formatType : state.formatType;
    const nextDuration =
      patch.durationTargetSeconds !== undefined
        ? patch.durationTargetSeconds
        : state.durationTargetSeconds;
    const nextScenes = patch.scenes !== undefined ? cloneScenes(patch.scenes) : state.scenes;
    const nextDirty = isDraftDirtyAgainstBaseline(
      {
        title: nextTitle,
        formatType: nextFormatType,
        durationTargetSeconds: nextDuration,
        scenes: nextScenes
      },
      persistedBaseline
    );
    state = {
      ...state,
      title: nextTitle,
      formatType: nextFormatType,
      durationTargetSeconds: nextDuration,
      scenes: nextScenes,
      isDirty: nextDirty,
      saveFeedback: ''
    };
    emit();
  }

  function setTitle(title: string) {
    applyDraftChange({ title });
  }

  function setFormatType(formatType: string) {
    applyDraftChange({ formatType });
  }

  function setDurationTarget(durationTargetSeconds: number) {
    applyDraftChange({ durationTargetSeconds });
  }

  function setScenes(scenes: Scene[]) {
    applyDraftChange({ scenes });
  }

  function updateScene(sceneIndex: number, patch: Partial<Scene>) {
    applyDraftChange({
      scenes: updateSceneInList(state.scenes, sceneIndex, patch)
    });
  }

  function updateShot(sceneIndex: number, shotIndex: number, patch: Partial<Shot>) {
    applyDraftChange({
      scenes: updateShotInList(state.scenes, sceneIndex, shotIndex, patch)
    });
  }

  function markConflict(reason: string) {
    state = {
      ...state,
      isConflict: true,
      conflictReason:
        reason ||
        'Kịch bản đã được cập nhật bởi phiên khác. Vui lòng tải lại trước khi lưu hoặc gửi duyệt (EC-M06-003).',
      saveFeedback: ''
    };
    emit();
  }

  async function save(options: CanonicalRpcOptions = {}): Promise<SaveScriptRemoteResult> {
    if (
      state.loadState !== 'loaded' ||
      state.isReverifying ||
      state.isPersisting ||
      pendingMutations > 0 ||
      state.versionIndex === null ||
      !state.loadedContextKey ||
      !state.workspaceId ||
      !state.scriptId
    ) {
      const errMessage = state.isReverifying
        ? 'Đang xác minh lại ngữ cảnh workspace. Thao tác lưu kịch bản tạm khóa (fail-closed).'
        : state.isPersisting || pendingMutations > 0
          ? 'Đang xử lý yêu cầu lưu hoặc gửi duyệt kịch bản. Vui lòng đợi hoàn tất (fail-closed).'
          : 'Không thể lưu bản nháp khi kịch bản chưa được tải từ máy chủ (ScriptService/Update fail-closed).';
      state = {
        ...state,
        saveFeedback: '',
        error: errMessage
      };
      emit();
      return {
        ok: false,
        error: errMessage
      };
    }

    const saveEpoch = loadEpoch;
    const saveContextKey = state.loadedContextKey;
    const activeWorkspaceId = state.workspaceId;
    const activeScriptId = state.scriptId;
    const expectedVersion = state.versionIndex;
    const submittedTitle = state.title;
    const submittedFormatType = state.formatType;
    const submittedDuration = state.durationTargetSeconds;
    const submittedScenes = cloneScenes(state.scenes);

    pendingMutations += 1;
    state = {
      ...state,
      isPersisting: true,
      saveFeedback: '',
      error: null
    };
    emit();

    try {
      const res = await saveScriptRemote(
        {
          workspaceId: activeWorkspaceId,
          scriptId: activeScriptId,
          title: submittedTitle,
          formatType: submittedFormatType,
          durationTargetSeconds: submittedDuration,
          expectedVersion,
          scenes: submittedScenes
        },
        {
          ...options,
          workspaceId: activeWorkspaceId
        }
      );

      if (saveEpoch !== loadEpoch || state.loadedContextKey !== saveContextKey) {
        return {
          ok: false,
          error: 'Ngữ cảnh phiên làm việc đã thay đổi trong khi lưu kịch bản (fail-closed).'
        };
      }

      pendingMutations = Math.max(0, pendingMutations - 1);
      if (!res.ok || !res.script) {
        state = {
          ...state,
          isConflict: res.conflict ? true : state.isConflict,
          conflictReason: res.conflict ? res.error || state.conflictReason : state.conflictReason,
          saveFeedback: '',
          error:
            res.error ||
            'Không thể lưu kịch bản lên máy chủ (ScriptService/Update). Phiên bản và nội dung không được đánh dấu đã lưu.',
          isPersisting: pendingMutations > 0
        };
        emit();
        return res;
      }

      const persistedScenes =
        res.script.scenes.length > 0 ? cloneScenes(res.script.scenes) : submittedScenes;
      persistedBaseline = buildPersistedBaseline(
        res.script.title,
        res.script.formatType,
        res.script.durationTargetSeconds,
        persistedScenes
      );
      const stillDirty = isDraftDirtyAgainstBaseline(
        {
          title: res.script.title,
          formatType: res.script.formatType,
          durationTargetSeconds: res.script.durationTargetSeconds,
          scenes: persistedScenes
        },
        persistedBaseline
      );

      state = {
        ...state,
        title: res.script.title,
        formatType: res.script.formatType,
        durationTargetSeconds: res.script.durationTargetSeconds,
        versionIndex: res.script.versionIndex,
        lifecycleState: res.script.lifecycleState,
        approvalState: res.script.approvalState,
        scenes: persistedScenes,
        isDirty: stillDirty,
        isConflict: false,
        conflictReason: '',
        saveFeedback: `Đã lưu phiên bản v${res.script.versionIndex} trên máy chủ.`,
        error: null,
        isPersisting: pendingMutations > 0
      };
      emit();
      return res;
    } catch (err) {
      if (saveEpoch === loadEpoch && state.loadedContextKey === saveContextKey) {
        pendingMutations = Math.max(0, pendingMutations - 1);
        const msg = err instanceof Error ? err.message : 'Lỗi kết nối khi lưu kịch bản (fail-closed)';
        state = {
          ...state,
          saveFeedback: '',
          error: msg,
          isPersisting: pendingMutations > 0
        };
        emit();
      }
      return {
        ok: false,
        error: err instanceof Error ? err.message : 'Lỗi kết nối khi lưu kịch bản (fail-closed)'
      };
    }
  }

  async function submitForReview(
    options: CanonicalRpcOptions = {}
  ): Promise<SubmitScriptApprovalRemoteResult> {
    const trimmedTitle = String(state.title || '').trim();
    if (!trimmedTitle) {
      const errMessage = 'Tiêu đề kịch bản không được để trống trước khi gửi duyệt.';
      state = {
        ...state,
        saveFeedback: '',
        error: errMessage
      };
      emit();
      return {
        ok: false,
        error: errMessage
      };
    }

    const sceneValidation = validateScenesForSubmission(state.scenes);
    if (!sceneValidation.valid) {
      state = {
        ...state,
        saveFeedback: '',
        error: sceneValidation.error || 'Kịch bản chưa đủ điều kiện gửi duyệt (EC-M06-001).'
      };
      emit();
      return {
        ok: false,
        error: state.error || undefined
      };
    }

    if (
      state.loadState !== 'loaded' ||
      state.isReverifying ||
      state.isPersisting ||
      pendingMutations > 0 ||
      state.versionIndex === null ||
      !state.loadedContextKey ||
      !state.workspaceId ||
      !state.scriptId
    ) {
      const errMessage = state.isReverifying
        ? 'Đang xác minh lại ngữ cảnh workspace. Thao tác gửi duyệt tạm khóa (fail-closed).'
        : state.isPersisting || pendingMutations > 0
          ? 'Đang xử lý yêu cầu lưu hoặc gửi duyệt kịch bản. Vui lòng đợi hoàn tất (fail-closed).'
          : 'Không thể gửi duyệt khi kịch bản chưa được lưu và đồng bộ từ máy chủ (ScriptService/SubmitApproval fail-closed).';
      state = {
        ...state,
        saveFeedback: '',
        error: errMessage
      };
      emit();
      return {
        ok: false,
        error: errMessage
      };
    }

    const submitEpoch = loadEpoch;
    const submitContextKey = state.loadedContextKey;
    const activeWorkspaceId = state.workspaceId;
    const activeScriptId = state.scriptId;

    // R3: If draft has unsaved changes (title, format, duration, or scenes/shots),
    // persist them via ScriptService/Update first and verify the server accepted the draft
    // before calling ScriptService/SubmitApproval on the new version.
    if (state.isDirty) {
      const dirtyTitle = trimmedTitle;
      const dirtyFormatType = state.formatType;
      const dirtyDuration = state.durationTargetSeconds;
      const dirtyScenes = cloneScenes(state.scenes);
      const dirtyExpectedVersion = state.versionIndex;

      pendingMutations += 1;
      state = {
        ...state,
        isPersisting: true,
        saveFeedback: '',
        error: null
      };
      emit();

      let saveRes: SaveScriptRemoteResult;
      try {
        saveRes = await saveScriptRemote(
          {
            workspaceId: activeWorkspaceId,
            scriptId: activeScriptId,
            title: dirtyTitle,
            formatType: dirtyFormatType,
            durationTargetSeconds: dirtyDuration,
            expectedVersion: dirtyExpectedVersion,
            scenes: dirtyScenes
          },
          {
            ...options,
            workspaceId: activeWorkspaceId
          }
        );
      } catch (err) {
        if (submitEpoch === loadEpoch && state.loadedContextKey === submitContextKey) {
          pendingMutations = Math.max(0, pendingMutations - 1);
          const msg =
            err instanceof Error
              ? err.message
              : 'Lỗi kết nối khi lưu thay đổi trước khi gửi duyệt (fail-closed)';
          state = {
            ...state,
            saveFeedback: '',
            error: msg,
            isPersisting: pendingMutations > 0
          };
          emit();
        }
        return {
          ok: false,
          error:
            err instanceof Error
              ? err.message
              : 'Lỗi kết nối khi lưu thay đổi trước khi gửi duyệt (fail-closed)'
        };
      }

      if (submitEpoch !== loadEpoch || state.loadedContextKey !== submitContextKey) {
        return {
          ok: false,
          error: 'Ngữ cảnh phiên làm việc đã thay đổi trong khi lưu kịch bản trước khi gửi duyệt (fail-closed).'
        };
      }

      const savedScript = saveRes.script;
      const titlePersisted =
        Boolean(savedScript) && String(savedScript!.title || '').trim() === dirtyTitle;
      const scenesPersisted =
        Boolean(savedScript) &&
        (savedScript!.scenes.length === 0 ||
          serializeScenesSignature(savedScript!.scenes) === serializeScenesSignature(dirtyScenes));

      if (!saveRes.ok || !savedScript || !titlePersisted || !scenesPersisted) {
        pendingMutations = Math.max(0, pendingMutations - 1);
        const errMessage =
          saveRes.error ||
          'Không thể gửi duyệt: thay đổi chưa lưu chưa được máy chủ xác nhận qua ScriptService/Update (fail-closed).';
        state = {
          ...state,
          isConflict: saveRes.conflict ? true : state.isConflict,
          conflictReason: saveRes.conflict ? saveRes.error || state.conflictReason : state.conflictReason,
          saveFeedback: '',
          error: errMessage,
          isPersisting: pendingMutations > 0
        };
        emit();
        return {
          ok: false,
          conflict: saveRes.conflict,
          error: errMessage
        };
      }

      const updatedScenes =
        savedScript.scenes.length > 0 ? cloneScenes(savedScript.scenes) : dirtyScenes;
      persistedBaseline = buildPersistedBaseline(
        savedScript.title,
        savedScript.formatType,
        savedScript.durationTargetSeconds,
        updatedScenes
      );
      state = {
        ...state,
        title: savedScript.title,
        formatType: savedScript.formatType,
        durationTargetSeconds: savedScript.durationTargetSeconds,
        versionIndex: savedScript.versionIndex,
        lifecycleState: savedScript.lifecycleState,
        approvalState: savedScript.approvalState,
        scenes: updatedScenes,
        isDirty: false,
        isConflict: false,
        conflictReason: '',
        error: null
      };
      pendingMutations = Math.max(0, pendingMutations - 1);
    }

    const expectedVersion = state.versionIndex!;
    pendingMutations += 1;
    state = {
      ...state,
      isPersisting: true,
      saveFeedback: '',
      error: null
    };
    emit();

    try {
      const res = await submitScriptApprovalRemote(
        {
          workspaceId: activeWorkspaceId,
          scriptId: activeScriptId,
          expectedVersion,
          scenes: state.scenes
        },
        {
          ...options,
          workspaceId: activeWorkspaceId
        }
      );

      if (submitEpoch !== loadEpoch || state.loadedContextKey !== submitContextKey) {
        return {
          ok: false,
          error: 'Ngữ cảnh phiên làm việc đã thay đổi trong khi gửi duyệt kịch bản (fail-closed).'
        };
      }

      pendingMutations = Math.max(0, pendingMutations - 1);
      if (!res.ok || !res.script || !res.approvalRequestId) {
        state = {
          ...state,
          isConflict: res.conflict ? true : state.isConflict,
          conflictReason: res.conflict ? res.error || state.conflictReason : state.conflictReason,
          saveFeedback: '',
          error:
            res.error ||
            'Không thể gửi duyệt kịch bản trên máy chủ (ScriptService/SubmitApproval). Trạng thái duyệt được giữ nguyên.',
          isPersisting: pendingMutations > 0
        };
        emit();
        return res;
      }

      const submittedScenes =
        res.script.scenes.length > 0 ? cloneScenes(res.script.scenes) : state.scenes;
      persistedBaseline = buildPersistedBaseline(
        res.script.title || state.title,
        res.script.formatType || state.formatType,
        res.script.durationTargetSeconds || state.durationTargetSeconds,
        submittedScenes
      );

      state = {
        ...state,
        title: res.script.title || state.title,
        formatType: res.script.formatType || state.formatType,
        durationTargetSeconds: res.script.durationTargetSeconds || state.durationTargetSeconds,
        versionIndex: res.script.versionIndex,
        lifecycleState: res.script.lifecycleState,
        approvalState: res.script.approvalState,
        scenes: submittedScenes,
        isDirty: false,
        approvalRequestId: res.approvalRequestId,
        isConflict: false,
        conflictReason: '',
        saveFeedback: `Đã gửi kịch bản cho quản lý phê duyệt (Mã yêu cầu: ${res.approvalRequestId}).`,
        error: null,
        isPersisting: pendingMutations > 0
      };
      emit();
      return res;
    } catch (err) {
      if (submitEpoch === loadEpoch && state.loadedContextKey === submitContextKey) {
        pendingMutations = Math.max(0, pendingMutations - 1);
        const msg = err instanceof Error ? err.message : 'Lỗi kết nối khi gửi duyệt kịch bản (fail-closed)';
        state = {
          ...state,
          saveFeedback: '',
          error: msg,
          isPersisting: pendingMutations > 0
        };
        emit();
      }
      return {
        ok: false,
        error: err instanceof Error ? err.message : 'Lỗi kết nối khi gửi duyệt kịch bản (fail-closed)'
      };
    }
  }

  return {
    subscribe,
    getSnapshot,
    syncContext,
    setTitle,
    setFormatType,
    setDurationTarget,
    setScenes,
    updateScene,
    updateShot,
    markConflict,
    save,
    submitForReview
  };
}

export interface ScriptReviewSessionSnapshot {
  scriptId: string;
  workspaceId: string | null;
  userId: string | null;
  loadState: ScriptEditorLoadState;
  loadedContextKey: string | null;
  title: string;
  formatType: string;
  durationTargetSeconds: number;
  versionIndex: number | null;
  lifecycleState: ScriptLifecycleState;
  approvalState: ScriptApprovalState;
  rejectionReason: string;
  scenes: Scene[];
  reviewerSnapshotTime: string | null;
  scriptUpdatedAt: string | null;
  isConflict: boolean;
  conflictReason: string;
  feedbackMessage: string;
  error: string | null;
  isProcessingReview: boolean;
  isReverifying: boolean;
}

/**
 * Fail-closed state controller for Script Lab review (`/scripts/[id]/review`, M06, R1).
 *
 * Guarantees:
 * 1. Never initializes synthetic version numbers or sample skincare scenes.
 * 2. Requires `ScriptService/Get` to load the script and its scenes for the active `userId:workspaceId:scriptId` before enabling `approve()` or `reject()`.
 * 3. Sends the exact `versionIndex` and `reviewerSnapshotTime` of the currently displayed script on `approve()` / `reject()`, and locks review actions immediately on load error, conflict, or tenant/user switch.
 */
export function createScriptReviewSession(initialScriptId: string) {
  let state: ScriptReviewSessionSnapshot = {
    scriptId: String(initialScriptId || '').trim(),
    workspaceId: null,
    userId: null,
    loadState: 'waiting_context',
    loadedContextKey: null,
    title: '',
    formatType: '',
    durationTargetSeconds: 0,
    versionIndex: null,
    lifecycleState: 'draft',
    approvalState: 'not_submitted',
    rejectionReason: '',
    scenes: [],
    reviewerSnapshotTime: null,
    scriptUpdatedAt: null,
    isConflict: false,
    conflictReason: '',
    feedbackMessage: '',
    error: null,
    isProcessingReview: false,
    isReverifying: false
  };

  let loadEpoch = 0;
  let pendingMutations = 0;
  const subscribers = new Set<(snapshot: ScriptReviewSessionSnapshot) => void>();

  function getSnapshot(): ScriptReviewSessionSnapshot {
    return {
      ...state,
      scenes: cloneScenes(state.scenes)
    };
  }

  function emit() {
    const snap = getSnapshot();
    for (const sub of subscribers) {
      sub(snap);
    }
  }

  function subscribe(run: (snapshot: ScriptReviewSessionSnapshot) => void): () => void {
    subscribers.add(run);
    run(getSnapshot());
    return () => {
      subscribers.delete(run);
    };
  }

  async function syncContext(
    ctx: ScriptEditorContextInput,
    options: CanonicalRpcOptions = {}
  ): Promise<{
    ok: boolean;
    loadState: ScriptEditorLoadState;
    stale?: boolean;
    error?: string;
  }> {
    const targetScriptId = String(ctx.scriptId ?? state.scriptId ?? '').trim();
    const targetUserId = String(ctx.userId ?? '').trim() || null;
    const targetWorkspaceId = String(ctx.workspaceId ?? '').trim() || null;
    const isAuthenticated = ctx.authState === undefined || ctx.authState === 'authenticated';

    const hasLoadedScriptForSameSubject =
      state.loadedContextKey !== null &&
      state.versionIndex !== null &&
      isAuthenticated &&
      Boolean(targetUserId) &&
      targetUserId === state.userId &&
      Boolean(targetScriptId) &&
      targetScriptId === state.scriptId &&
      (targetWorkspaceId === null || targetWorkspaceId === state.workspaceId);

    if (ctx.isDiscoveryLoading === true && hasLoadedScriptForSameSubject) {
      state = {
        ...state,
        isReverifying: true,
        isProcessingReview: pendingMutations > 0,
        error: null
      };
      emit();
      return {
        ok: false,
        loadState: state.loadState
      };
    }

    if (
      ctx.isDiscoveryLoading === true ||
      !isAuthenticated ||
      !targetUserId ||
      !targetWorkspaceId ||
      !targetScriptId
    ) {
      loadEpoch += 1;
      pendingMutations = 0;
      state = {
        scriptId: targetScriptId,
        workspaceId: targetWorkspaceId,
        userId: targetUserId,
        loadState: 'waiting_context',
        loadedContextKey: null,
        title: '',
        formatType: '',
        durationTargetSeconds: 0,
        versionIndex: null,
        lifecycleState: 'draft',
        approvalState: 'not_submitted',
        rejectionReason: '',
        scenes: [],
        reviewerSnapshotTime: null,
        scriptUpdatedAt: null,
        isConflict: false,
        conflictReason: '',
        feedbackMessage: '',
        error: null,
        isProcessingReview: false,
        isReverifying: false
      };
      emit();
      return {
        ok: false,
        loadState: 'waiting_context'
      };
    }

    const contextKey = `${targetUserId}:${targetWorkspaceId}:${targetScriptId}`;
    if (
      !ctx.force &&
      state.loadedContextKey === contextKey &&
      state.versionIndex !== null &&
      (state.loadState === 'loaded' || state.isReverifying)
    ) {
      if (
        state.loadState !== 'loaded' ||
        state.isReverifying ||
        state.isProcessingReview !== (pendingMutations > 0) ||
        state.error !== null
      ) {
        state = {
          ...state,
          loadState: 'loaded',
          isReverifying: false,
          isProcessingReview: pendingMutations > 0,
          error: null
        };
        emit();
      }
      return {
        ok: true,
        loadState: 'loaded'
      };
    }

    const requestEpoch = ++loadEpoch;
    pendingMutations = 0;
    state = {
      scriptId: targetScriptId,
      workspaceId: targetWorkspaceId,
      userId: targetUserId,
      loadState: 'loading',
      loadedContextKey: null,
      title: '',
      formatType: '',
      durationTargetSeconds: 0,
      versionIndex: null,
      lifecycleState: 'draft',
      approvalState: 'not_submitted',
      rejectionReason: '',
      scenes: [],
      reviewerSnapshotTime: null,
      scriptUpdatedAt: null,
      isConflict: false,
      conflictReason: '',
      feedbackMessage: '',
      error: null,
      isProcessingReview: false,
      isReverifying: false
    };
    emit();

    const res = await loadScriptRemote(
      {
        workspaceId: targetWorkspaceId,
        scriptId: targetScriptId
      },
      {
        ...options,
        workspaceId: targetWorkspaceId
      }
    );

    if (requestEpoch !== loadEpoch) {
      return {
        ok: false,
        stale: true,
        loadState: state.loadState
      };
    }

    if (
      !res.ok ||
      !res.script ||
      res.script.scriptId !== targetScriptId ||
      res.script.scenes.length === 0
    ) {
      const errMessage =
        res.error ||
        (res.script && res.script.scenes.length === 0
          ? 'Kịch bản chưa có phân cảnh nào để kiểm duyệt. Đã khóa thao tác phê duyệt/từ chối (fail-closed).'
          : 'Không thể tải kịch bản từ máy chủ (ScriptService/Get). Đã khóa thao tác phê duyệt và từ chối (fail-closed).');
      state = {
        ...state,
        loadState: 'error',
        loadedContextKey: null,
        versionIndex: null,
        scenes: [],
        reviewerSnapshotTime: null,
        scriptUpdatedAt: null,
        feedbackMessage: '',
        error: errMessage,
        isProcessingReview: false,
        isReverifying: false
      };
      emit();
      return {
        ok: false,
        loadState: 'error',
        error: errMessage
      };
    }

    const snapshotTimestamp = res.script.updatedAt || new Date().toISOString();
    state = {
      scriptId: res.script.scriptId,
      workspaceId: targetWorkspaceId,
      userId: targetUserId,
      loadState: 'loaded',
      loadedContextKey: contextKey,
      title: res.script.title,
      formatType: res.script.formatType,
      durationTargetSeconds: res.script.durationTargetSeconds,
      versionIndex: res.script.versionIndex,
      lifecycleState: res.script.lifecycleState,
      approvalState: res.script.approvalState,
      rejectionReason: res.script.rejectionReason || '',
      scenes: cloneScenes(res.script.scenes),
      reviewerSnapshotTime: snapshotTimestamp,
      scriptUpdatedAt: snapshotTimestamp,
      isConflict: false,
      conflictReason: '',
      feedbackMessage: ctx.force
        ? `Đã tải lại phiên bản v${res.script.versionIndex} mới nhất từ máy chủ.`
        : '',
      error: null,
      isProcessingReview: false,
      isReverifying: false
    };
    emit();
    return {
      ok: true,
      loadState: 'loaded'
    };
  }

  function setConflictSimulation(enabled: boolean) {
    state = {
      ...state,
      isConflict: enabled,
      conflictReason: enabled
        ? 'Tác giả vừa cập nhật cảnh 2 cách đây 5 giây. Vui lòng tải lại trước khi phê duyệt (EC-M06-003).'
        : '',
      feedbackMessage: ''
    };
    emit();
  }

  async function approve(options: CanonicalRpcOptions = {}): Promise<SaveScriptRemoteResult> {
    if (state.isConflict) {
      const errMessage =
        'Không thể phê duyệt: Phiên bản kịch bản đã bị thay đổi kể từ khi bạn mở trang (EC-M06-003). Vui lòng tải lại trang.';
      state = {
        ...state,
        feedbackMessage: '',
        error: errMessage
      };
      emit();
      return {
        ok: false,
        conflict: true,
        error: errMessage
      };
    }

    if (
      state.loadState !== 'loaded' ||
      state.isReverifying ||
      state.isProcessingReview ||
      pendingMutations > 0 ||
      state.versionIndex === null ||
      state.scenes.length === 0 ||
      !state.loadedContextKey ||
      !state.workspaceId ||
      !state.scriptId
    ) {
      const errMessage = state.isReverifying
        ? 'Đang xác minh lại ngữ cảnh workspace. Thao tác phê duyệt tạm khóa (fail-closed).'
        : 'Không thể phê duyệt khi kịch bản và phân cảnh chưa được tải từ máy chủ (ScriptService/Get fail-closed).';
      state = {
        ...state,
        feedbackMessage: '',
        error: errMessage
      };
      emit();
      return {
        ok: false,
        error: errMessage
      };
    }

    const approveEpoch = loadEpoch;
    const approveContextKey = state.loadedContextKey;
    const activeWorkspaceId = state.workspaceId;
    const activeScriptId = state.scriptId;
    const expectedVersion = state.versionIndex;
    const snapshotTime = state.reviewerSnapshotTime || undefined;

    pendingMutations += 1;
    state = {
      ...state,
      isProcessingReview: true,
      feedbackMessage: '',
      error: null
    };
    emit();

    try {
      const res = await approveScriptRemote(
        {
          workspaceId: activeWorkspaceId,
          scriptId: activeScriptId,
          expectedVersion,
          reviewerSnapshotTime: snapshotTime
        },
        {
          ...options,
          workspaceId: activeWorkspaceId
        }
      );

      if (approveEpoch !== loadEpoch || state.loadedContextKey !== approveContextKey) {
        return {
          ok: false,
          error: 'Ngữ cảnh phiên làm việc đã thay đổi trong khi phê duyệt kịch bản (fail-closed).'
        };
      }

      pendingMutations = Math.max(0, pendingMutations - 1);
      if (!res.ok || !res.script) {
        state = {
          ...state,
          isConflict: res.conflict ? true : state.isConflict,
          conflictReason: res.conflict
            ? res.error ||
              'Kịch bản đã được tác giả cập nhật mới kể từ khi bạn mở trang (EC-M06-003). Vui lòng tải lại.'
            : state.conflictReason,
          feedbackMessage: '',
          error:
            res.error ||
            'Không thể phê duyệt kịch bản trên máy chủ (ScriptService/Approve fail-closed).',
          isProcessingReview: pendingMutations > 0
        };
        emit();
        return res;
      }

      state = {
        ...state,
        title: res.script.title || state.title,
        formatType: res.script.formatType || state.formatType,
        durationTargetSeconds: res.script.durationTargetSeconds || state.durationTargetSeconds,
        versionIndex: res.script.versionIndex,
        lifecycleState: res.script.lifecycleState,
        approvalState: res.script.approvalState,
        scenes: res.script.scenes.length > 0 ? cloneScenes(res.script.scenes) : state.scenes,
        isConflict: false,
        conflictReason: '',
        feedbackMessage: '✓ Đã phê duyệt kịch bản thành công trên máy chủ!',
        error: null,
        isProcessingReview: pendingMutations > 0
      };
      emit();
      return res;
    } catch (err) {
      if (approveEpoch === loadEpoch && state.loadedContextKey === approveContextKey) {
        pendingMutations = Math.max(0, pendingMutations - 1);
        const msg =
          err instanceof Error ? err.message : 'Lỗi kết nối khi phê duyệt kịch bản (fail-closed)';
        state = {
          ...state,
          feedbackMessage: '',
          error: msg,
          isProcessingReview: pendingMutations > 0
        };
        emit();
      }
      return {
        ok: false,
        error: err instanceof Error ? err.message : 'Lỗi kết nối khi phê duyệt kịch bản (fail-closed)'
      };
    }
  }

  async function reject(
    rejectionReason: string,
    options: CanonicalRpcOptions = {}
  ): Promise<SaveScriptRemoteResult> {
    const reasonValidation = validateRejectionReason(rejectionReason);
    if (!reasonValidation.valid) {
      state = {
        ...state,
        feedbackMessage: '',
        error: reasonValidation.error || null
      };
      emit();
      return {
        ok: false,
        error: reasonValidation.error
      };
    }

    if (state.isConflict) {
      const errMessage =
        'Không thể từ chối: Kịch bản đã được tác giả cập nhật mới (EC-M06-003). Vui lòng tải lại.';
      state = {
        ...state,
        feedbackMessage: '',
        error: errMessage
      };
      emit();
      return {
        ok: false,
        conflict: true,
        error: errMessage
      };
    }

    if (
      state.loadState !== 'loaded' ||
      state.isReverifying ||
      state.isProcessingReview ||
      pendingMutations > 0 ||
      state.versionIndex === null ||
      state.scenes.length === 0 ||
      !state.loadedContextKey ||
      !state.workspaceId ||
      !state.scriptId
    ) {
      const errMessage = state.isReverifying
        ? 'Đang xác minh lại ngữ cảnh workspace. Thao tác từ chối tạm khóa (fail-closed).'
        : 'Không thể từ chối khi kịch bản và phân cảnh chưa được tải từ máy chủ (ScriptService/Get fail-closed).';
      state = {
        ...state,
        feedbackMessage: '',
        error: errMessage
      };
      emit();
      return {
        ok: false,
        error: errMessage
      };
    }

    const rejectEpoch = loadEpoch;
    const rejectContextKey = state.loadedContextKey;
    const activeWorkspaceId = state.workspaceId;
    const activeScriptId = state.scriptId;
    const expectedVersion = state.versionIndex;
    const snapshotTime = state.reviewerSnapshotTime || undefined;

    pendingMutations += 1;
    state = {
      ...state,
      isProcessingReview: true,
      feedbackMessage: '',
      error: null
    };
    emit();

    try {
      const res = await rejectScriptRemote(
        {
          workspaceId: activeWorkspaceId,
          scriptId: activeScriptId,
          rejectionReason,
          expectedVersion,
          reviewerSnapshotTime: snapshotTime
        },
        {
          ...options,
          workspaceId: activeWorkspaceId
        }
      );

      if (rejectEpoch !== loadEpoch || state.loadedContextKey !== rejectContextKey) {
        return {
          ok: false,
          error: 'Ngữ cảnh phiên làm việc đã thay đổi trong khi từ chối kịch bản (fail-closed).'
        };
      }

      pendingMutations = Math.max(0, pendingMutations - 1);
      if (!res.ok || !res.script) {
        state = {
          ...state,
          isConflict: res.conflict ? true : state.isConflict,
          conflictReason: res.conflict
            ? res.error ||
              'Kịch bản đã được tác giả cập nhật mới kể từ khi bạn mở trang (EC-M06-003). Vui lòng tải lại.'
            : state.conflictReason,
          feedbackMessage: '',
          error:
            res.error ||
            'Không thể từ chối kịch bản trên máy chủ (ScriptService/Reject fail-closed).',
          isProcessingReview: pendingMutations > 0
        };
        emit();
        return res;
      }

      state = {
        ...state,
        title: res.script.title || state.title,
        formatType: res.script.formatType || state.formatType,
        durationTargetSeconds: res.script.durationTargetSeconds || state.durationTargetSeconds,
        versionIndex: res.script.versionIndex,
        lifecycleState: res.script.lifecycleState,
        approvalState: res.script.approvalState,
        rejectionReason: res.script.rejectionReason || rejectionReason.trim(),
        scenes: res.script.scenes.length > 0 ? cloneScenes(res.script.scenes) : state.scenes,
        isConflict: false,
        conflictReason: '',
        feedbackMessage: `Đã từ chối kịch bản trên máy chủ và gửi phản hồi: "${rejectionReason.trim()}"`,
        error: null,
        isProcessingReview: pendingMutations > 0
      };
      emit();
      return res;
    } catch (err) {
      if (rejectEpoch === loadEpoch && state.loadedContextKey === rejectContextKey) {
        pendingMutations = Math.max(0, pendingMutations - 1);
        const msg =
          err instanceof Error ? err.message : 'Lỗi kết nối khi từ chối kịch bản (fail-closed)';
        state = {
          ...state,
          feedbackMessage: '',
          error: msg,
          isProcessingReview: pendingMutations > 0
        };
        emit();
      }
      return {
        ok: false,
        error: err instanceof Error ? err.message : 'Lỗi kết nối khi từ chối kịch bản (fail-closed)'
      };
    }
  }

  return {
    subscribe,
    getSnapshot,
    syncContext,
    setConflictSimulation,
    approve,
    reject
  };
}
