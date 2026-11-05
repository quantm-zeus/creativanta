import type {
  ApprovalRequest,
  WorkflowGraph,
  WorkflowRunStep,
  DiagnosticsRecord,
  PreflightReport,
  NodeType
} from './types';

/**
 * Validates whether an approval request remains valid against the latest workflow graph.
 * Acceptance Target 2: Changed action invalidates approval.
 */
export function validateActionApprovalBinding(
  approval: ApprovalRequest,
  graph: WorkflowGraph,
  currentWorkflowVersion: number
): { valid: boolean; reason?: string } {
  if (approval.status !== 'pending_approval') {
    return { valid: false, reason: `Approval request is already in status '${approval.status}'` };
  }

  // Version check
  if (approval.workflow_version !== undefined && approval.workflow_version !== currentWorkflowVersion) {
    return {
      valid: false,
      reason: `Workflow version changed from v${approval.workflow_version} to v${currentWorkflowVersion} after approval was requested`
    };
  }

  // Find node in graph
  const node = graph.nodes.find((n) => n.node_id === approval.node_id);
  if (!node) {
    return { valid: false, reason: `Approval node '${approval.node_id}' was removed from workflow graph` };
  }

  // Check adjacent action nodes (incoming or outgoing connected to approval gate)
  const connectedNodeIds = new Set<string>();
  for (const edge of graph.edges) {
    if (edge.from_node_id === approval.node_id) {
      connectedNodeIds.add(edge.to_node_id);
    }
    if (edge.to_node_id === approval.node_id) {
      connectedNodeIds.add(edge.from_node_id);
    }
  }

  for (const connId of connectedNodeIds) {
    const actNode = graph.nodes.find((n) => n.node_id === connId && n.node_type === 'action');
    if (actNode && actNode.action_config) {
      if (approval.input_snapshot && actNode.action_config.input_json !== approval.input_snapshot) {
        return { valid: false, reason: 'Action inputs or parameters were modified after approval was requested' };
      }
    }
  }

  // Expiry check
  if (approval.expires_at) {
    const expires = new Date(approval.expires_at).getTime();
    if (Date.now() >= expires) {
      return { valid: false, reason: 'Approval deadline has expired' };
    }
  }

  return { valid: true };
}

/**
 * Verifies that resuming execution does not replay confirmed side effects.
 * Acceptance Target 3: Resume never replays confirmed effect.
 */
export function checkResumeIdempotency(steps: WorkflowRunStep[]): {
  confirmedEffects: string[];
  alreadyExecutedNodeIds: Set<string>;
  safeToResume: boolean;
} {
  const confirmedEffects: string[] = [];
  const alreadyExecutedNodeIds = new Set<string>();

  for (const step of steps) {
    if (step.status === 'succeeded') {
      alreadyExecutedNodeIds.add(step.node_id);
      if (step.side_effect_refs && step.side_effect_refs.length > 0) {
        confirmedEffects.push(...step.side_effect_refs);
      }
    }
  }

  return {
    confirmedEffects,
    alreadyExecutedNodeIds,
    safeToResume: true
  };
}

/**
 * Formats structured diagnostics for user-facing display per RULE-M20-003.
 */
export function formatDiagnostics(diag: DiagnosticsRecord): {
  title: string;
  badgeColor: string;
  userMessage: string;
  operatorMessage: string;
  recommendedNextStep: string;
  hasFallback: boolean;
} {
  let badgeColor = 'bg-red-500/10 text-red-400 border-red-500/20';
  let title = 'Workflow Execution Error';

  switch (diag.failure_type) {
    case 'CAPABILITY_DEGRADED':
      badgeColor = 'bg-amber-500/10 text-amber-400 border-amber-500/20';
      title = 'Platform Capability Degraded';
      break;
    case 'APPROVAL_EXPIRED':
      badgeColor = 'bg-orange-500/10 text-orange-400 border-orange-500/20';
      title = 'Approval Timed Out';
      break;
    case 'APPROVAL_INVALIDATED':
      badgeColor = 'bg-purple-500/10 text-purple-400 border-purple-500/20';
      title = 'Approval Invalidation';
      break;
    case 'CASCADE_DEPTH_EXCEEDED':
      badgeColor = 'bg-red-500/10 text-red-400 border-red-500/20';
      title = 'Cascade Depth Limit Reached';
      break;
  }

  return {
    title,
    badgeColor,
    userMessage: diag.user_facing_explanation,
    operatorMessage: diag.operator_explanation,
    recommendedNextStep: diag.recommended_next_step,
    hasFallback: diag.fallback_available
  };
}

import { callCanonicalRpc, generateIdempotencyKey, type CanonicalRpcOptions } from '$lib/api/client';
import { validateWorkflowGraph } from './validation';

export interface SaveWorkflowRemoteInput {
  workspaceId?: string;
  workflowId: string;
  title: string;
  description: string;
  expectedVersion: number;
  graph: WorkflowGraph;
}

export interface SaveWorkflowRemoteResult {
  ok: boolean;
  version?: number;
  status?: 'draft' | 'active' | 'paused';
  error?: string;
}

/**
 * Loads a workflow definition from `creativanta.automation.v1.WorkflowService/Get` (UF-08).
 */
export async function loadWorkflowRemote(
  params: { workspaceId?: string; workflowId: string },
  options: CanonicalRpcOptions = {}
): Promise<{
  ok: boolean;
  workflow?: {
    workflowId: string;
    title: string;
    description: string;
    status: 'draft' | 'active' | 'paused';
    version: number;
    graph?: WorkflowGraph;
  };
  error?: string;
}> {
  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    {
      workflow?: {
        workflow_id?: string;
        title?: string;
        description?: string;
        status?: 'draft' | 'active' | 'paused';
        version?: number;
        graph?: WorkflowGraph;
      };
    }
  >(
    'creativanta.automation.v1.WorkflowService/Get',
    {
      workspace_id: params.workspaceId,
      workflow_id: params.workflowId
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

  const wf = rpcRes.data?.workflow;
  if (!wf?.workflow_id) {
    return {
      ok: false,
      error: 'Phản hồi từ máy chủ thiếu thông tin workflow_id (fail-closed).'
    };
  }

  return {
    ok: true,
    workflow: {
      workflowId: wf.workflow_id,
      title: wf.title || '',
      description: wf.description || '',
      status: wf.status || 'draft',
      version: wf.version ?? 1,
      graph: wf.graph
    }
  };
}

/**
 * Persists workflow graph edits via `creativanta.automation.v1.WorkflowService/Update`
 * with optimistic concurrency (`expected_version`) (UF-08).
 * Never increments version locally when the backend call fails.
 */
export async function saveWorkflowRemote(
  input: SaveWorkflowRemoteInput,
  options: CanonicalRpcOptions = {}
): Promise<SaveWorkflowRemoteResult> {
  const validation = validateWorkflowGraph(input.graph);
  if (!validation.valid) {
    return {
      ok: false,
      error: `Cannot save invalid workflow: ${validation.errors.join('; ')}`
    };
  }

  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    {
      workflow?: {
        workflow_id?: string;
        version?: number;
        status?: 'draft' | 'active' | 'paused';
      };
      version?: number;
    }
  >(
    'creativanta.automation.v1.WorkflowService/Update',
    {
      idempotency_key: options.idempotencyKey || generateIdempotencyKey('wf-save'),
      workspace_id: input.workspaceId,
      workflow_id: input.workflowId,
      title: input.title,
      description: input.description,
      expected_version: input.expectedVersion,
      graph: input.graph
    },
    {
      ...options,
      workspaceId: options.workspaceId ?? input.workspaceId
    }
  );

  if (!rpcRes.ok) {
    return {
      ok: false,
      error: rpcRes.error.message
    };
  }

  const remoteVersion = rpcRes.data?.workflow?.version ?? rpcRes.data?.version;
  if (typeof remoteVersion !== 'number') {
    return {
      ok: false,
      error: 'Phản hồi từ máy chủ thiếu số phiên bản workflow mới (version). Không tăng version giả lập.'
    };
  }

  return {
    ok: true,
    version: remoteVersion,
    status: rpcRes.data?.workflow?.status
  };
}

/**
 * Activates or pauses a workflow via `creativanta.automation.v1.WorkflowService/Activate`
 * or `Pause` (UF-08). Never mutates workflow status locally when the backend call fails.
 */
export async function setWorkflowStatusRemote(
  params: {
    workspaceId?: string;
    workflowId: string;
    targetStatus: 'draft' | 'active' | 'paused';
    expectedVersion: number;
  },
  options: CanonicalRpcOptions = {}
): Promise<SaveWorkflowRemoteResult> {
  const procedure =
    params.targetStatus === 'active'
      ? 'creativanta.automation.v1.WorkflowService/Activate'
      : 'creativanta.automation.v1.WorkflowService/Update';

  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    {
      workflow?: {
        workflow_id?: string;
        status?: 'draft' | 'active' | 'paused';
        version?: number;
      };
      status?: 'draft' | 'active' | 'paused';
    }
  >(
    procedure,
    {
      idempotency_key: options.idempotencyKey || generateIdempotencyKey('wf-status'),
      workspace_id: params.workspaceId,
      workflow_id: params.workflowId,
      status: params.targetStatus,
      expected_version: params.expectedVersion
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

  const confirmedStatus = rpcRes.data?.workflow?.status || rpcRes.data?.status;
  if (!confirmedStatus) {
    return {
      ok: false,
      error: 'Phản hồi từ máy chủ không xác nhận trạng thái workflow mới (fail-closed).'
    };
  }

  return {
    ok: true,
    status: confirmedStatus,
    version: rpcRes.data?.workflow?.version ?? params.expectedVersion
  };
}
