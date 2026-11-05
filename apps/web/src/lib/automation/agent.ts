// Creativanta P7-04: Agent Runtime, Video Agent & Copilot Actions Client Library.
// Canonical references: docs/02_features/automation/recipe_agent_center.md,
// docs/02_features/production/ai_video_studio.md, docs/02_features/platform/copilot.md,
// and database_schema.md §12.4, §12.4A, §12.4B.

export type AgentRunState =
  | 'unspecified'
  | 'planning'
  | 'awaiting_approval'
  | 'executing'
  | 'waiting_context'
  | 'completed'
  | 'partially_completed'
  | 'failed'
  | 'handed_off'
  | 'cancelled';

export type AgentApprovalState =
  | 'not_required'
  | 'awaiting_approval'
  | 'approved'
  | 'rejected';

export type AgentStepStatus =
  | 'planning'
  | 'awaiting_approval'
  | 'executing'
  | 'waiting_context'
  | 'completed'
  | 'failed'
  | 'skipped'
  | 'cancelled';

export type AgentOutputType =
  | 'text'
  | 'asset'
  | 'dataset'
  | 'workflow_patch'
  | 'recommendation'
  | 'report'
  | 'video';

export type AgentType =
  | 'generic'
  | 'video_agent'
  | 'copilot_action'
  | 'content_optimizer';

export interface AgentMemoryEntry {
  key: string;
  value: string;
  byteSize: number;
  observedAt: string;
}

export interface AgentMemory {
  totalBytes: number;
  maxBytes: number;
  isCompressed: boolean;
  entries: AgentMemoryEntry[];
  summary: string;
}

export interface AgentStep {
  stepId: string;
  agentRunId: string;
  stepOrder: number;
  phase: string;
  title: string;
  status: AgentStepStatus;
  expectedOutcome: string;
  observedOutcome?: string;
  requiredPermission: string;
  requiredCapability?: string;
  isHighRisk: boolean;
  estimatedCredits: number;
  actualCredits: number;
  inputContext?: Record<string, unknown>;
  outputContext?: Record<string, unknown>;
  diagnosticsRef?: string;
  startedAt?: string;
  completedAt?: string;
}

export interface AgentOutput {
  outputId: string;
  agentRunId: string;
  outputType: AgentOutputType;
  title: string;
  summary: string;
  objectRefs: string[];
  downloadableRefs: string[];
  previewPayload?: Record<string, unknown>;
  approvalState: string;
  createdAt: string;
}

export interface AgentHandoffContext {
  handoffTargetUserId: string;
  reason: string;
  summaryOfCompletedWork: string;
  unresolvedActions: string[];
  diagnosticsRef: string;
  auditRef: string;
}

export interface AgentRun {
  agentRunId: string;
  workspaceId: string;
  agentType: AgentType;
  recipeId?: string;
  workflowId?: string;
  planSummary: string;
  executionScope: Record<string, unknown>;
  approvalState: AgentApprovalState;
  currentState: AgentRunState;
  sideEffectsSummary: Record<string, unknown>;
  handoffContext?: AgentHandoffContext;
  diagnosticsRef?: string;
  auditRef?: string;
  creditsUsed: number;
  budgetCeiling: number;
  memory: AgentMemory;
  steps: AgentStep[];
  outputs: AgentOutput[];
  createdBy: string;
  createdAt: string;
  updatedAt: string;
}

export interface VideoAgentOptions {
  workspaceId: string;
  userId: string;
  prompt: string;
  characterId?: string;
  brandPackId?: string;
  productId?: string;
  stylePackId?: string;
  durationSeconds?: number;
  platforms?: string[];
  qualityTier?: 'standard' | 'premium';
  budgetCeiling?: number;
  autoPublish?: boolean;
}

export interface CopilotActionOptions {
  workspaceId: string;
  userId: string;
  userRole: string;
  intent: string;
  targetObject?: string;
  parameters?: Record<string, unknown>;
  budgetCeiling?: number;
}

export const MAX_MEMORY_BYTES = 50000;

export function createBoundedMemory(maxBytes: number = MAX_MEMORY_BYTES): AgentMemory {
  return {
    totalBytes: 0,
    maxBytes,
    isCompressed: false,
    entries: [],
    summary: ''
  };
}

export function appendBoundedMemory(
  memory: AgentMemory,
  key: string,
  value: string
): AgentMemory {
  const entryBytes = new TextEncoder().encode(key + ':' + value).length;
  const updatedEntries = [...memory.entries];
  let updatedBytes = memory.totalBytes + entryBytes;
  let compressed = memory.isCompressed;
  let summary = memory.summary;

  // Compression triggered when reaching 80% capacity
  if (updatedBytes > memory.maxBytes * 0.8) {
    compressed = true;
    summary = `[Compressed memory: ${updatedEntries.length} previous observations summarized]`;
    // Evict oldest entries until within 50% capacity
    while (updatedEntries.length > 2 && updatedBytes > memory.maxBytes * 0.5) {
      const removed = updatedEntries.shift();
      if (removed) {
        updatedBytes -= removed.byteSize;
      }
    }
  }

  // Strict cap: do not exceed maxBytes
  if (updatedBytes > memory.maxBytes) {
    const allowed = Math.max(0, memory.maxBytes - (updatedBytes - entryBytes));
    value = value.substring(0, Math.max(0, allowed - 20)) + '...[truncated]';
  }

  const finalBytes = new TextEncoder().encode(key + ':' + value).length;
  updatedEntries.push({
    key,
    value,
    byteSize: finalBytes,
    observedAt: new Date().toISOString()
  });

  return {
    totalBytes: updatedEntries.reduce((sum, e) => sum + e.byteSize, 0),
    maxBytes: memory.maxBytes,
    isCompressed: compressed,
    entries: updatedEntries,
    summary
  };
}

/**
 * Plans a 6-stage video production pipeline for Screen W031 and AI Video Studio.
 * Canonical stages: Script -> Scenes -> Visuals -> Voiceover -> Music/SFX -> Assembly.
 */
export function planVideoAgent(options: VideoAgentOptions): AgentRun {
  const runId = `run-vid-${Date.now()}-${Math.random().toString(36).substring(2, 8)}`;
  const quality = options.qualityTier || 'standard';
  const isPremium = quality === 'premium';
  const budgetCeiling = options.budgetCeiling ?? (isPremium ? 75 : 50);

  const steps: AgentStep[] = [
    {
      stepId: `${runId}-s1`,
      agentRunId: runId,
      stepOrder: 1,
      phase: 'script_generation',
      title: 'Tạo kịch bản & phân cảnh (Script Lab)',
      status: 'planning',
      expectedOutcome: 'Kịch bản phân đoạn 3 hồi có hook mạnh, CTA chuyển đổi',
      requiredPermission: 'content:write',
      requiredCapability: 'ai_scripting',
      isHighRisk: false,
      estimatedCredits: 3,
      actualCredits: 0
    },
    {
      stepId: `${runId}-s2`,
      agentRunId: runId,
      stepOrder: 2,
      phase: 'scene_planning',
      title: 'Lập kế hoạch storyboard & nhân vật đồng nhất',
      status: 'planning',
      expectedOutcome: '5 cảnh visual định danh nhân vật và đạo cụ thương hiệu',
      requiredPermission: 'asset:generate',
      requiredCapability: 'character_binding',
      isHighRisk: false,
      estimatedCredits: 2,
      actualCredits: 0
    },
    {
      stepId: `${runId}-s3`,
      agentRunId: runId,
      stepOrder: 3,
      phase: 'visual_generation',
      title: isPremium ? 'Sinh hình ảnh đa cảnh chất lượng cao (Veo 2 / Kling 1080p)' : 'Sinh hình ảnh đa cảnh tiêu chuẩn (Veo 720p)',
      status: 'planning',
      expectedOutcome: '5 video clips ngắn theo timeline storyboard',
      requiredPermission: 'asset:generate',
      requiredCapability: 'video_generation',
      isHighRisk: false,
      estimatedCredits: isPremium ? 45 : 25,
      actualCredits: 0
    },
    {
      stepId: `${runId}-s4`,
      agentRunId: runId,
      stepOrder: 4,
      phase: 'voiceover_synthesis',
      title: 'Tổng hợp giọng đọc AI đa cảm xúc',
      status: 'planning',
      expectedOutcome: 'Tệp audio voiceover đồng bộ từng phân đoạn',
      requiredPermission: 'asset:generate',
      requiredCapability: 'voice_synthesis',
      isHighRisk: false,
      estimatedCredits: 4,
      actualCredits: 0
    },
    {
      stepId: `${runId}-s5`,
      agentRunId: runId,
      stepOrder: 5,
      phase: 'music_sfx',
      title: 'Phối nhạc nền bản quyền & SFX chuyển cảnh',
      status: 'planning',
      expectedOutcome: 'Track âm thanh chuẩn -14 LUFS với beat-drop',
      requiredPermission: 'asset:generate',
      requiredCapability: 'audio_mix',
      isHighRisk: false,
      estimatedCredits: 3,
      actualCredits: 0
    },
    {
      stepId: `${runId}-s6`,
      agentRunId: runId,
      stepOrder: 6,
      phase: 'assembly_and_export',
      title: options.autoPublish ? 'Lắp ghép video & Tự động xuất bản lên kênh' : 'Lắp ghép video & Xuất bản thảo',
      status: 'planning',
      expectedOutcome: 'Render video MP4 1080p và tạo asset library ref',
      requiredPermission: options.autoPublish ? 'publish:manage' : 'asset:generate',
      requiredCapability: 'video_render',
      isHighRisk: Boolean(options.autoPublish),
      estimatedCredits: 3,
      actualCredits: 0
    }
  ];

  return {
    agentRunId: runId,
    workspaceId: options.workspaceId,
    agentType: 'video_agent',
    planSummary: `Tự động tạo video từ mô tả: "${options.prompt.substring(0, 60)}..."`,
    executionScope: {
      prompt: options.prompt,
      characterId: options.characterId,
      brandPackId: options.brandPackId,
      qualityTier: quality,
      platforms: options.platforms || ['tiktok'],
      autoPublish: Boolean(options.autoPublish)
    },
    approvalState: options.autoPublish ? 'awaiting_approval' : 'not_required',
    currentState: 'planning',
    sideEffectsSummary: {},
    creditsUsed: 0,
    budgetCeiling,
    memory: createBoundedMemory(),
    steps,
    outputs: [],
    createdBy: options.userId,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };
}

/**
 * Plans a Copilot Action agent run for cross-module operational tasks.
 */
export function planCopilotAction(options: CopilotActionOptions): AgentRun {
  const runId = `run-cop-${Date.now()}-${Math.random().toString(36).substring(2, 8)}`;
  const budgetCeiling = options.budgetCeiling ?? 20;

  const isDestructive = options.intent.toLowerCase().includes('delete') ||
    options.intent.toLowerCase().includes('xóa') ||
    options.intent.toLowerCase().includes('archive');

  const requiredPermission = isDestructive ? 'product:delete' : 'content:write';

  const step: AgentStep = {
    stepId: `${runId}-s1`,
    agentRunId: runId,
    stepOrder: 1,
    phase: 'action_dispatch',
    title: `Copilot Action: ${options.intent}`,
    status: 'planning',
    expectedOutcome: `Thực thi thao tác ${options.intent}`,
    requiredPermission,
    isHighRisk: isDestructive,
    estimatedCredits: 5,
    actualCredits: 0,
    inputContext: options.parameters
  };

  return {
    agentRunId: runId,
    workspaceId: options.workspaceId,
    agentType: 'copilot_action',
    planSummary: `Copilot action dispatch: ${options.intent}`,
    executionScope: {
      intent: options.intent,
      targetObject: options.targetObject,
      userRole: options.userRole
    },
    approvalState: isDestructive ? 'awaiting_approval' : 'not_required',
    currentState: 'planning',
    sideEffectsSummary: {},
    creditsUsed: 0,
    budgetCeiling,
    memory: createBoundedMemory(),
    steps: [step],
    outputs: [],
    createdBy: options.userId,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  };
}

// Role-to-permission mapping per docs/04_contracts/rbac_permission_matrix.md
const ROLE_PERMISSIONS: Record<string, string[]> = {
  owner: ['*'],
  admin: ['*'],
  manager: [
    'content:write',
    'asset:generate',
    'publish:manage',
    'product:write',
    'billing:read'
  ],
  editor: ['content:write', 'asset:generate'],
  contributor: ['content:write'],
  viewer: ['content:read'],
  external: []
};

export function hasPermission(role: string, requiredPermission: string): boolean {
  if (role === 'owner' || role === 'admin') return true;
  const perms = ROLE_PERMISSIONS[role] || [];
  return perms.includes(requiredPermission) || perms.includes('*');
}

export interface StepExecutionResult {
  success: boolean;
  run: AgentRun;
  pausedReason?: string;
  error?: string;
}

/**
 * Executes a single step of the agent run while enforcing:
 * 1. Acceptance Target 1: Caller delegated permissions and high-risk approval pauses.
 * 2. Acceptance Target 2: Budget ceiling pause without overdraft.
 * 3. Memory boundedness updates.
 */
export function executeAgentStep(
  run: AgentRun,
  stepIndex: number,
  callerRole: string,
  availableBalance: number
): StepExecutionResult {
  const currentRun = { ...run, steps: [...run.steps], outputs: [...run.outputs] };
  const step = { ...currentRun.steps[stepIndex] };

  if (!step) {
    return { success: false, run: currentRun, error: 'Chỉ mục bước không hợp lệ' };
  }

  // Acceptance Target 1: Delegated permission check per step
  if (!hasPermission(callerRole, step.requiredPermission)) {
    const errorMsg = `Từ chối ủy quyền: Quyền '${callerRole}' không có permission '${step.requiredPermission}' để thực hiện bước ${step.stepOrder}`;
    step.status = 'failed';
    step.observedOutcome = errorMsg;
    currentRun.steps[stepIndex] = step;
    currentRun.currentState = 'failed';
    currentRun.diagnosticsRef = `diag-${step.stepId}-perm-denied`;
    currentRun.auditRef = `audit-${step.stepId}-${Date.now()}`;
    return {
      success: false,
      run: currentRun,
      error: errorMsg
    };
  }

  // High risk operations require explicit approval before dispatching external side effects
  if (step.isHighRisk && currentRun.approvalState !== 'approved') {
    step.status = 'awaiting_approval';
    currentRun.steps[stepIndex] = step;
    currentRun.currentState = 'awaiting_approval';
    currentRun.approvalState = 'awaiting_approval';
    return {
      success: false,
      run: currentRun,
      pausedReason: `Bước ${step.stepOrder} (${step.title}) là thao tác rủi ro cao và cần phê duyệt trước khi kích hoạt.`
    };
  }

  // Acceptance Target 2: Budget ceiling pause without overdraft
  const projectedTotal = currentRun.creditsUsed + step.estimatedCredits;
  if (projectedTotal > currentRun.budgetCeiling || projectedTotal > availableBalance) {
    step.status = 'waiting_context';
    currentRun.steps[stepIndex] = step;
    currentRun.currentState = 'waiting_context';
    const pauseMsg = `Tạm dừng vì chạm hạn mức tín dụng: Dự kiến ${projectedTotal} cr > Hạn mức ${currentRun.budgetCeiling} cr (Số dư: ${availableBalance} cr). Không trừ credits dư thừa.`;
    return {
      success: false,
      run: currentRun,
      pausedReason: pauseMsg
    };
  }

  // Execute step successfully
  step.status = 'completed';
  step.actualCredits = step.estimatedCredits;
  step.observedOutcome = `Hoàn thành thành công bước ${step.stepOrder}: ${step.title}`;
  step.completedAt = new Date().toISOString();
  currentRun.steps[stepIndex] = step;

  // Deduct credits accurately
  currentRun.creditsUsed += step.actualCredits;

  // Append memory bounded observation
  currentRun.memory = appendBoundedMemory(
    currentRun.memory,
    `step_${step.stepOrder}_output`,
    step.observedOutcome
  );

  // Generate output artifact if applicable
  if (step.phase === 'script_generation') {
    currentRun.outputs.push({
      outputId: `out-script-${Date.now()}`,
      agentRunId: currentRun.agentRunId,
      outputType: 'text',
      title: 'Bản thảo kịch bản phân đoạn',
      summary: 'Kịch bản video đã hoàn thành phân cảnh 1-5',
      objectRefs: [`script:${currentRun.agentRunId}`],
      downloadableRefs: [],
      approvalState: 'approved',
      createdAt: new Date().toISOString()
    });
  } else if (step.phase === 'visual_generation') {
    currentRun.outputs.push({
      outputId: `out-visuals-${Date.now()}`,
      agentRunId: currentRun.agentRunId,
      outputType: 'asset',
      title: 'Gói hình ảnh & phân cảnh video clips',
      summary: '5 phân cảnh video 1080p sinh từ AI visual studio',
      objectRefs: [`asset:visuals:${currentRun.agentRunId}`],
      downloadableRefs: [`https://storage.creativanta.vn/clips/${currentRun.agentRunId}.zip`],
      approvalState: 'approved',
      createdAt: new Date().toISOString()
    });
  } else if (step.phase === 'assembly_and_export') {
    currentRun.outputs.push({
      outputId: `out-final-video-${Date.now()}`,
      agentRunId: currentRun.agentRunId,
      outputType: 'video',
      title: 'Video thành phẩm 1080p',
      summary: 'Video hoàn chỉnh sẵn sàng đăng tải hoặc chỉnh sửa',
      objectRefs: [`asset:video:${currentRun.agentRunId}`],
      downloadableRefs: [`https://storage.creativanta.vn/final/${currentRun.agentRunId}.mp4`],
      previewPayload: {
        streamUrl: `https://storage.creativanta.vn/final/${currentRun.agentRunId}.mp4`,
        durationSeconds: 30,
        resolution: '1080p'
      },
      approvalState: 'approved',
      createdAt: new Date().toISOString()
    });
  }

  // Update run state
  const allCompleted = currentRun.steps.every((s) => s.status === 'completed');
  if (allCompleted) {
    currentRun.currentState = 'completed';
  } else {
    currentRun.currentState = 'executing';
  }
  currentRun.updatedAt = new Date().toISOString();

  return {
    success: true,
    run: currentRun
  };
}

/**
 * Acceptance Target 3: Partial failure has audited handoff.
 * When a step fails, succeeded steps and outputs are preserved.
 * Diagnostics and immutable audit records are attached, transitioning run to
 * `partially_completed` or `handed_off`.
 */
export function recordPartialFailureHandoff(
  run: AgentRun,
  failedStepIndex: number,
  errorReason: string,
  targetUserId: string = 'user-ops-lead-01'
): AgentRun {
  const currentRun = { ...run, steps: [...run.steps], outputs: [...run.outputs] };
  const failedStep = { ...currentRun.steps[failedStepIndex] };

  if (failedStep) {
    failedStep.status = 'failed';
    failedStep.observedOutcome = `Lỗi tại bước ${failedStep.stepOrder}: ${errorReason}`;
    failedStep.diagnosticsRef = `diag-${failedStep.stepId}-fail`;
    currentRun.steps[failedStepIndex] = failedStep;
  }

  // Remaining un-executed steps become skipped or waiting
  for (let i = failedStepIndex + 1; i < currentRun.steps.length; i++) {
    currentRun.steps[i] = {
      ...currentRun.steps[i],
      status: 'skipped'
    };
  }

  const completedCount = currentRun.steps.filter((s) => s.status === 'completed').length;
  const diagnosticsRef = `diag-p7-04-${currentRun.agentRunId}-step-${failedStep ? failedStep.stepOrder : 0}`;
  const auditRef = `audit-handoff-${currentRun.agentRunId}-${Date.now()}`;

  const unresolvedActions = currentRun.steps
    .filter((s) => s.status === 'failed' || s.status === 'skipped')
    .map((s) => `Bước ${s.stepOrder}: ${s.title}`);

  const handoffContext: AgentHandoffContext = {
    handoffTargetUserId: targetUserId,
    reason: `Gặp lỗi tại bước ${failedStep ? failedStep.title : 'chưa xác định'}: ${errorReason}`,
    summaryOfCompletedWork: `Đã hoàn thành ${completedCount}/${currentRun.steps.length} bước. Đã bảo tồn ${currentRun.outputs.length} outputs thành phẩm.`,
    unresolvedActions,
    diagnosticsRef,
    auditRef
  };

  currentRun.currentState = completedCount > 0 ? 'partially_completed' : 'failed';
  if (targetUserId) {
    currentRun.currentState = 'handed_off';
  }
  currentRun.handoffContext = handoffContext;
  currentRun.diagnosticsRef = diagnosticsRef;
  currentRun.auditRef = auditRef;
  currentRun.updatedAt = new Date().toISOString();

  return currentRun;
}

/**
 * Resumes a run paused at budget ceiling by increasing budget ceiling.
 */
export function increaseBudgetCeiling(
  run: AgentRun,
  additionalCredits: number
): AgentRun {
  const currentRun = { ...run, steps: [...run.steps] };
  currentRun.budgetCeiling += additionalCredits;
  if (currentRun.currentState === 'waiting_context') {
    currentRun.currentState = 'executing';
    // Reset any waiting_context step back to planning
    for (let i = 0; i < currentRun.steps.length; i++) {
      if (currentRun.steps[i].status === 'waiting_context') {
        currentRun.steps[i] = { ...currentRun.steps[i], status: 'planning' };
      }
    }
  }
  currentRun.updatedAt = new Date().toISOString();
  return currentRun;
}

/**
 * Manager approves a pending high-risk step.
 */
export function approvePendingStep(
  run: AgentRun,
  approverRole: string
): { success: boolean; run: AgentRun; error?: string } {
  if (approverRole !== 'owner' && approverRole !== 'admin' && approverRole !== 'manager') {
    return {
      success: false,
      run,
      error: 'Chỉ Quản lý hoặc Quản trị viên mới có thẩm quyền phê duyệt bước rủi ro cao.'
    };
  }

  const currentRun = { ...run, steps: [...run.steps] };
  currentRun.approvalState = 'approved';
  if (currentRun.currentState === 'awaiting_approval') {
    currentRun.currentState = 'executing';
  }
  for (let i = 0; i < currentRun.steps.length; i++) {
    if (currentRun.steps[i].status === 'awaiting_approval') {
      currentRun.steps[i] = { ...currentRun.steps[i], status: 'planning' };
    }
  }
  currentRun.updatedAt = new Date().toISOString();
  return { success: true, run: currentRun };
}

import { callCanonicalRpc, generateIdempotencyKey, type CanonicalRpcOptions } from '$lib/api/client';

/**
 * Executes a single Video Agent step against canonical backend
 * `creativanta.automation.v1.AgentService/ExecuteStep` (AI-02).
 * Enforces delegated RBAC permission, high-risk approval pause, and budget ceiling pause
 * before dispatching, and fails closed without deducting credits or fabricating video URLs
 * when unauthenticated or when backend runtime is unavailable.
 */
export async function executeVideoAgentStepRemote(
  run: AgentRun,
  stepIndex: number,
  callerRole: string,
  availableBalance: number,
  options: CanonicalRpcOptions = {}
): Promise<StepExecutionResult> {
  const currentRun = { ...run, steps: [...run.steps], outputs: [...run.outputs] };
  const step = currentRun.steps[stepIndex] ? { ...currentRun.steps[stepIndex] } : null;

  if (!step) {
    return { success: false, run: currentRun, error: 'Chỉ mục bước không hợp lệ' };
  }

  // 1. Delegated permission check per step
  if (!hasPermission(callerRole, step.requiredPermission)) {
    const errorMsg = `Từ chối ủy quyền: Quyền '${callerRole}' không có permission '${step.requiredPermission}' để thực hiện bước ${step.stepOrder}`;
    step.status = 'failed';
    step.observedOutcome = errorMsg;
    currentRun.steps[stepIndex] = step;
    currentRun.currentState = 'failed';
    currentRun.diagnosticsRef = `diag-${step.stepId}-perm-denied`;
    return {
      success: false,
      run: currentRun,
      error: errorMsg
    };
  }

  // 2. High-risk approval gate
  if (step.isHighRisk && currentRun.approvalState !== 'approved') {
    step.status = 'awaiting_approval';
    currentRun.steps[stepIndex] = step;
    currentRun.currentState = 'awaiting_approval';
    currentRun.approvalState = 'awaiting_approval';
    return {
      success: false,
      run: currentRun,
      pausedReason: `Bước ${step.stepOrder} (${step.title}) là thao tác rủi ro cao và cần phê duyệt trước khi kích hoạt.`
    };
  }

  // 3. Budget ceiling gate without overdraft
  const projectedTotal = currentRun.creditsUsed + step.estimatedCredits;
  if (projectedTotal > currentRun.budgetCeiling || projectedTotal > availableBalance) {
    step.status = 'waiting_context';
    currentRun.steps[stepIndex] = step;
    currentRun.currentState = 'waiting_context';
    const pauseMsg = `Tạm dừng vì chạm hạn mức tín dụng: Dự kiến ${projectedTotal} cr > Hạn mức ${currentRun.budgetCeiling} cr (Số dư: ${availableBalance} cr). Không trừ credits dư thừa.`;
    return {
      success: false,
      run: currentRun,
      pausedReason: pauseMsg
    };
  }

  // 4. Dispatch to backend AgentService/ExecuteStep
  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    {
      step?: {
        step_id?: string;
        status?: AgentStepStatus;
        actual_credits?: number;
        observed_outcome?: string;
        completed_at?: string;
      };
      output?: AgentOutput;
      credits_used?: number;
      current_state?: AgentRunState;
    }
  >(
    'creativanta.automation.v1.AgentService/ExecuteStep',
    {
      idempotency_key: options.idempotencyKey || generateIdempotencyKey(`agent-step-${step.stepId}`),
      workspace_id: currentRun.workspaceId,
      agent_run_id: currentRun.agentRunId,
      step_id: step.stepId,
      step_order: step.stepOrder,
      phase: step.phase,
      caller_role: callerRole,
      estimated_credits: step.estimatedCredits,
      budget_ceiling: currentRun.budgetCeiling
    },
    {
      ...options,
      workspaceId: options.workspaceId ?? currentRun.workspaceId
    }
  );

  if (!rpcRes.ok) {
    return {
      success: false,
      run: currentRun,
      error: rpcRes.error.message
    };
  }

  const remoteStep = rpcRes.data?.step;
  if (!remoteStep || remoteStep.status !== 'completed') {
    return {
      success: false,
      run: currentRun,
      error:
        'Máy chủ AgentService chưa xác nhận hoàn thành bước thực thi (fail-closed). Không trừ credits.'
    };
  }

  const actualCredits =
    typeof remoteStep.actual_credits === 'number' ? remoteStep.actual_credits : step.estimatedCredits;

  step.status = 'completed';
  step.actualCredits = actualCredits;
  step.observedOutcome =
    remoteStep.observed_outcome || `Hoàn thành bước ${step.stepOrder}: ${step.title}`;
  step.completedAt = remoteStep.completed_at || new Date().toISOString();
  currentRun.steps[stepIndex] = step;
  currentRun.creditsUsed =
    typeof rpcRes.data?.credits_used === 'number'
      ? rpcRes.data.credits_used
      : currentRun.creditsUsed + actualCredits;

  currentRun.memory = appendBoundedMemory(
    currentRun.memory,
    `step_${step.stepOrder}_output`,
    step.observedOutcome
  );

  if (rpcRes.data?.output) {
    currentRun.outputs.push(rpcRes.data.output);
  }

  const allCompleted = currentRun.steps.every((s) => s.status === 'completed');
  currentRun.currentState =
    rpcRes.data?.current_state || (allCompleted ? 'completed' : 'executing');
  currentRun.updatedAt = new Date().toISOString();

  return {
    success: true,
    run: currentRun
  };
}
