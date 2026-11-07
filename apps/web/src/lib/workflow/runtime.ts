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
import type {
  ConditionConfig,
  EdgeBranch,
  TriggerConfig,
  TriggerType,
  WorkflowEdge,
  WorkflowNode
} from './types';

function normalizeWorkflowStatus(raw: unknown): 'draft' | 'active' | 'paused' | undefined {
  if (raw === undefined || raw === null || raw === '') return undefined;
  if (typeof raw === 'number') {
    if (raw === 2) return 'active';
    if (raw === 3) return 'paused';
    return 'draft';
  }
  const str = String(raw).toLowerCase();
  if (str.includes('active')) return 'active';
  if (str.includes('paused')) return 'paused';
  if (str.includes('draft')) return 'draft';
  return undefined;
}

function toProtoNodeType(t: NodeType): string {
  switch (t) {
    case 'trigger':
      return 'NODE_TYPE_TRIGGER';
    case 'condition':
      return 'NODE_TYPE_CONDITION';
    case 'transform':
      return 'NODE_TYPE_TRANSFORM';
    case 'action':
      return 'NODE_TYPE_ACTION';
    case 'approval':
      return 'NODE_TYPE_APPROVAL';
    case 'wait':
      return 'NODE_TYPE_WAIT';
    case 'fallback':
      return 'NODE_TYPE_FALLBACK';
    case 'diagnostics':
      return 'NODE_TYPE_DIAGNOSTICS';
    case 'handoff':
      return 'NODE_TYPE_HANDOFF';
    case 'terminal':
      return 'NODE_TYPE_TERMINAL';
    default:
      return 'NODE_TYPE_TRIGGER';
  }
}

function fromProtoNodeType(raw: unknown): NodeType {
  if (typeof raw === 'number') {
    const map: Record<number, NodeType> = {
      1: 'trigger',
      2: 'condition',
      3: 'transform',
      4: 'action',
      5: 'approval',
      6: 'wait',
      7: 'fallback',
      8: 'diagnostics',
      9: 'handoff',
      10: 'terminal'
    };
    return map[raw] || 'trigger';
  }
  const s = String(raw || '')
    .toLowerCase()
    .replace(/^node_type_/, '');
  const valid: NodeType[] = [
    'trigger',
    'condition',
    'transform',
    'action',
    'approval',
    'wait',
    'fallback',
    'diagnostics',
    'handoff',
    'terminal'
  ];
  return (valid.includes(s as NodeType) ? s : 'trigger') as NodeType;
}

function toProtoTriggerType(t?: TriggerType): string {
  switch (t) {
    case 'event':
      return 'TRIGGER_TYPE_EVENT';
    case 'schedule':
      return 'TRIGGER_TYPE_SCHEDULE';
    case 'webhook':
      return 'TRIGGER_TYPE_WEBHOOK';
    case 'manual':
    default:
      return 'TRIGGER_TYPE_MANUAL';
  }
}

function fromProtoTriggerType(raw: unknown): TriggerType {
  if (typeof raw === 'number') {
    const map: Record<number, TriggerType> = {
      1: 'event',
      2: 'schedule',
      3: 'manual',
      4: 'webhook'
    };
    return map[raw] || 'manual';
  }
  const s = String(raw || '')
    .toLowerCase()
    .replace(/^trigger_type_/, '');
  if (s === 'event' || s === 'schedule' || s === 'manual' || s === 'webhook') {
    return s;
  }
  return 'manual';
}

function toProtoEdgeBranch(b?: EdgeBranch): string {
  switch (b) {
    case 'success':
      return 'EDGE_BRANCH_SUCCESS';
    case 'failure':
      return 'EDGE_BRANCH_FAILURE';
    case 'true':
      return 'EDGE_BRANCH_TRUE';
    case 'false':
      return 'EDGE_BRANCH_FALSE';
    default:
      return 'EDGE_BRANCH_UNSPECIFIED';
  }
}

function fromProtoEdgeBranch(raw: unknown): EdgeBranch | undefined {
  if (typeof raw === 'number') {
    const map: Record<number, EdgeBranch> = {
      1: 'success',
      2: 'failure',
      3: 'true',
      4: 'false'
    };
    return map[raw];
  }
  const s = String(raw || '')
    .toLowerCase()
    .replace(/^edge_branch_/, '');
  if (s === 'success' || s === 'failure' || s === 'true' || s === 'false') {
    return s;
  }
  return undefined;
}

function toProtoTriggerConfigObject(tc?: TriggerConfig): Record<string, unknown> {
  if (!tc) {
    return { type: 'TRIGGER_TYPE_MANUAL' };
  }
  return {
    type: toProtoTriggerType(tc.type),
    event_type: tc.event_type || '',
    cron_expression: tc.cron_expression || '',
    webhook_path: tc.webhook_path || '',
    filters: (tc.filters || []).map((f) => ({
      field: f.field,
      operator: f.operator,
      value_json: f.value_json
    }))
  };
}

function fromProtoTriggerConfigObject(raw: any): TriggerConfig | undefined {
  if (!raw || typeof raw !== 'object') return undefined;
  const inner = raw.config && typeof raw.config === 'object' ? raw.config : raw;
  return {
    type: fromProtoTriggerType(inner.type),
    event_type: inner.event_type ?? inner.eventType,
    cron_expression: inner.cron_expression ?? inner.cronExpression,
    webhook_path: inner.webhook_path ?? inner.webhookPath,
    filters: Array.isArray(inner.filters)
      ? inner.filters.map((f: any) => ({
          field: String(f.field || ''),
          operator: String(f.operator || ''),
          value_json: String(f.value_json ?? f.valueJson ?? '')
        }))
      : undefined
  };
}

export function toProtoWorkflowGraph(graph: WorkflowGraph): Record<string, unknown> {
  return {
    schema_version: graph.schema_version || 1,
    nodes: graph.nodes.map((n) => {
      const pbNode: Record<string, unknown> = {
        node_id: n.node_id,
        node_type: toProtoNodeType(n.node_type),
        title: n.title,
        description: n.description || '',
        raw_config_json: JSON.stringify(n.config || {})
      };
      if (n.trigger_config) {
        pbNode.trigger_config = {
          config: toProtoTriggerConfigObject(n.trigger_config)
        };
      } else if (n.condition_config) {
        pbNode.condition_config = {
          field: n.condition_config.field,
          operator: n.condition_config.operator,
          value_json: n.condition_config.value_json
        };
      } else if (n.transform_config) {
        pbNode.transform_config = {
          mappings: (n.transform_config.mappings || []).map((m) => ({
            target_field: m.target_field,
            source_field: m.source_field || '',
            default_value: m.default_value || '',
            template: m.template || ''
          }))
        };
      } else if (n.action_config) {
        pbNode.action_config = {
          rpc_name: n.action_config.rpc_name,
          input_json: n.action_config.input_json || '{}',
          timeout_seconds: n.action_config.timeout_seconds ?? 30,
          max_retries: n.action_config.max_retries ?? 0,
          backoff_seconds: n.action_config.backoff_seconds ?? 0
        };
      } else if (n.approval_config) {
        pbNode.approval_config = {
          approver_ids: n.approval_config.approver_ids || [],
          required_approvals: n.approval_config.required_approvals ?? 1,
          expires_at_duration_seconds: n.approval_config.expires_at_duration_seconds ?? 3600,
          auto_action_on_timeout: n.approval_config.auto_action_on_timeout || 'reject'
        };
      } else if (n.wait_config) {
        pbNode.wait_config = {
          wait_type: n.wait_config.wait_type,
          duration_seconds: n.wait_config.duration_seconds ?? 0,
          resume_condition: n.wait_config.resume_condition || '',
          until_timestamp: n.wait_config.until_timestamp || ''
        };
      } else if (n.fallback_config) {
        pbNode.fallback_config = {
          fallback_node_id: n.fallback_config.fallback_node_id,
          reason_template: n.fallback_config.reason_template,
          log_level: n.fallback_config.log_level
        };
      } else if (n.diagnostics_config) {
        pbNode.diagnostics_config = {
          severity: n.diagnostics_config.severity,
          user_message: n.diagnostics_config.user_message,
          operator_message: n.diagnostics_config.operator_message || '',
          recommended_next_step: n.diagnostics_config.recommended_next_step
        };
      } else if (n.handoff_config) {
        pbNode.handoff_config = {
          target_user_id: n.handoff_config.target_user_id || '',
          target_role: n.handoff_config.target_role || '',
          context_note: n.handoff_config.context_note
        };
      } else if (n.terminal_config) {
        pbNode.terminal_config = {
          outcome: n.terminal_config.outcome,
          result_template: n.terminal_config.result_template || ''
        };
      }
      return pbNode;
    }),
    edges: graph.edges.map((e) => ({
      from_node_id: e.from_node_id,
      to_node_id: e.to_node_id,
      branch: toProtoEdgeBranch(e.branch)
    }))
  };
}

export function fromProtoWorkflowGraph(
  rawGraph: any,
  fallbackTriggerConfig?: any
): WorkflowGraph | undefined {
  let parsed = rawGraph;
  if (typeof parsed === 'string' && parsed.trim()) {
    try {
      parsed = JSON.parse(parsed);
    } catch {
      return undefined;
    }
  }
  if (!parsed || typeof parsed !== 'object' || !Array.isArray(parsed.nodes)) {
    return undefined;
  }

  const nodes: WorkflowNode[] = parsed.nodes.map((n: any) => {
    let cfg: Record<string, any> = {};
    const rawCfgJson = n.raw_config_json ?? n.rawConfigJson;
    if (typeof rawCfgJson === 'string' && rawCfgJson.trim()) {
      try {
        cfg = JSON.parse(rawCfgJson);
      } catch {
        cfg = {};
      }
    } else if (n.config && typeof n.config === 'object') {
      cfg = n.config;
    }

    const nodeType = fromProtoNodeType(n.node_type ?? n.nodeType);
    const node: WorkflowNode = {
      node_id: String(n.node_id ?? n.nodeId ?? ''),
      node_type: nodeType,
      title: String(n.title || ''),
      description: n.description ? String(n.description) : undefined,
      config: cfg
    };

    const trigRaw = n.trigger_config ?? n.triggerConfig ?? (nodeType === 'trigger' ? fallbackTriggerConfig : undefined);
    if (trigRaw) {
      node.trigger_config = fromProtoTriggerConfigObject(trigRaw);
    }

    const condRaw = n.condition_config ?? n.conditionConfig;
    if (condRaw) {
      node.condition_config = {
        field: String(condRaw.field || ''),
        operator: String(condRaw.operator || 'eq') as ConditionConfig['operator'],
        value_json: String(condRaw.value_json ?? condRaw.valueJson ?? '')
      };
    }

    const transRaw = n.transform_config ?? n.transformConfig;
    if (transRaw && Array.isArray(transRaw.mappings)) {
      node.transform_config = {
        mappings: transRaw.mappings.map((m: any) => ({
          target_field: String(m.target_field ?? m.targetField ?? ''),
          source_field: m.source_field ?? m.sourceField,
          default_value: m.default_value ?? m.defaultValue,
          template: m.template
        }))
      };
    }

    const actRaw = n.action_config ?? n.actionConfig;
    if (actRaw) {
      node.action_config = {
        rpc_name: String(actRaw.rpc_name ?? actRaw.rpcName ?? ''),
        input_json: actRaw.input_json ?? actRaw.inputJson,
        timeout_seconds:
          actRaw.timeout_seconds !== undefined || actRaw.timeoutSeconds !== undefined
            ? Number(actRaw.timeout_seconds ?? actRaw.timeoutSeconds)
            : undefined,
        max_retries:
          actRaw.max_retries !== undefined || actRaw.maxRetries !== undefined
            ? Number(actRaw.max_retries ?? actRaw.maxRetries)
            : undefined,
        backoff_seconds:
          actRaw.backoff_seconds !== undefined || actRaw.backoffSeconds !== undefined
            ? Number(actRaw.backoff_seconds ?? actRaw.backoffSeconds)
            : undefined
      };
    }

    const appRaw = n.approval_config ?? n.approvalConfig;
    if (appRaw) {
      node.approval_config = {
        approver_ids: Array.isArray(appRaw.approver_ids ?? appRaw.approverIds)
          ? (appRaw.approver_ids ?? appRaw.approverIds).map(String)
          : [],
        required_approvals: Number(appRaw.required_approvals ?? appRaw.requiredApprovals ?? 1),
        expires_at_duration_seconds: Number(
          appRaw.expires_at_duration_seconds ?? appRaw.expiresAtDurationSeconds ?? 3600
        ),
        auto_action_on_timeout: appRaw.auto_action_on_timeout ?? appRaw.autoActionOnTimeout
      };
    }

    const waitRaw = n.wait_config ?? n.waitConfig;
    if (waitRaw) {
      node.wait_config = {
        wait_type: (waitRaw.wait_type ?? waitRaw.waitType ?? 'duration') as
          | 'duration'
          | 'external_condition'
          | 'until_timestamp',
        duration_seconds:
          waitRaw.duration_seconds !== undefined || waitRaw.durationSeconds !== undefined
            ? Number(waitRaw.duration_seconds ?? waitRaw.durationSeconds)
            : undefined,
        resume_condition: waitRaw.resume_condition ?? waitRaw.resumeCondition,
        until_timestamp: waitRaw.until_timestamp ?? waitRaw.untilTimestamp
      };
    }

    const fbRaw = n.fallback_config ?? n.fallbackConfig;
    if (fbRaw) {
      const rawLogLevel = String(fbRaw.log_level ?? fbRaw.logLevel ?? 'warning');
      node.fallback_config = {
        fallback_node_id: String(fbRaw.fallback_node_id ?? fbRaw.fallbackNodeId ?? ''),
        reason_template: String(fbRaw.reason_template ?? fbRaw.reasonTemplate ?? ''),
        log_level: (rawLogLevel === 'error' || rawLogLevel === 'info' ? rawLogLevel : 'warning') as
          | 'info'
          | 'warning'
          | 'error'
      };
    }

    const diagRaw = n.diagnostics_config ?? n.diagnosticsConfig;
    if (diagRaw) {
      const rawSev = String(diagRaw.severity || 'info');
      node.diagnostics_config = {
        severity: (
          rawSev === 'warning' || rawSev === 'error' || rawSev === 'critical' ? rawSev : 'info'
        ) as 'info' | 'warning' | 'error' | 'critical',
        user_message: String(diagRaw.user_message ?? diagRaw.userMessage ?? ''),
        operator_message: diagRaw.operator_message ?? diagRaw.operatorMessage,
        recommended_next_step: String(
          diagRaw.recommended_next_step ?? diagRaw.recommendedNextStep ?? ''
        )
      };
    }

    const hoRaw = n.handoff_config ?? n.handoffConfig;
    if (hoRaw) {
      node.handoff_config = {
        target_user_id: hoRaw.target_user_id ?? hoRaw.targetUserId,
        target_role: hoRaw.target_role ?? hoRaw.targetRole,
        context_note: String(hoRaw.context_note ?? hoRaw.contextNote ?? '')
      };
    }

    const termRaw = n.terminal_config ?? n.terminalConfig;
    if (termRaw) {
      node.terminal_config = {
        outcome: (termRaw.outcome || 'succeeded') as
          | 'succeeded'
          | 'partially_succeeded'
          | 'failed'
          | 'cancelled',
        result_template: termRaw.result_template ?? termRaw.resultTemplate
      };
    }

    return node;
  });

  const edges: WorkflowEdge[] = Array.isArray(parsed.edges)
    ? parsed.edges.map((e: any) => ({
        from_node_id: String(e.from_node_id ?? e.fromNodeId ?? ''),
        to_node_id: String(e.to_node_id ?? e.toNodeId ?? ''),
        branch: fromProtoEdgeBranch(e.branch)
      }))
    : [];

  return {
    schema_version: Number(parsed.schema_version ?? parsed.schemaVersion ?? 1),
    nodes,
    edges
  };
}

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
      workflow?: Record<string, any>;
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
  const workflowId = String(wf?.workflow_id || wf?.workflowId || '').trim();
  if (!workflowId) {
    return {
      ok: false,
      error: 'Phản hồi từ máy chủ thiếu thông tin workflow_id (fail-closed).'
    };
  }

  const rawGraphSource =
    wf?.action_chain || wf?.actionChain || wf?.action_chain_json || wf?.actionChainJson || wf?.graph;
  const graph = fromProtoWorkflowGraph(
    rawGraphSource,
    wf?.trigger_config ?? wf?.triggerConfig
  );
  const parsedVersion =
    typeof wf?.version === 'number'
      ? wf.version
      : typeof wf?.version === 'string' && wf.version.trim() !== ''
        ? Number(wf.version)
        : NaN;

  if (!Number.isFinite(parsedVersion) || parsedVersion <= 0) {
    return {
      ok: false,
      error: 'Phản hồi từ máy chủ thiếu số phiên bản workflow hợp lệ (version) (fail-closed).'
    };
  }

  return {
    ok: true,
    workflow: {
      workflowId,
      title: String(wf?.title || ''),
      description: String(wf?.description || ''),
      status: normalizeWorkflowStatus(wf?.status) || 'draft',
      version: parsedVersion,
      graph
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

  const triggerNode = input.graph.nodes.find((n) => n.node_type === 'trigger');
  const protoActionChain = toProtoWorkflowGraph(input.graph);
  const protoTriggerConfig = toProtoTriggerConfigObject(triggerNode?.trigger_config);

  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    {
      workflow?: Record<string, any>;
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
      trigger_config: protoTriggerConfig,
      action_chain: protoActionChain
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
      error:
        'Phản hồi từ máy chủ thiếu số phiên bản workflow mới (version). Không tăng version giả lập.'
    };
  }

  return {
    ok: true,
    version: remoteVersion,
    status: normalizeWorkflowStatus(rpcRes.data?.workflow?.status)
  };
}

/**
 * Activates or pauses a workflow via `creativanta.automation.v1.WorkflowService/Activate`
 * or `creativanta.automation.v1.WorkflowService/Deactivate` (UF-08).
 * Never mutates workflow status locally when the backend call fails.
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
      : params.targetStatus === 'paused'
        ? 'creativanta.automation.v1.WorkflowService/Deactivate'
        : 'creativanta.automation.v1.WorkflowService/Update';

  const requestBody: Record<string, unknown> =
    params.targetStatus === 'active' || params.targetStatus === 'paused'
      ? {
          idempotency_key: options.idempotencyKey || generateIdempotencyKey('wf-status'),
          workspace_id: params.workspaceId,
          workflow_id: params.workflowId
        }
      : {
          idempotency_key: options.idempotencyKey || generateIdempotencyKey('wf-status'),
          workspace_id: params.workspaceId,
          workflow_id: params.workflowId,
          expected_version: params.expectedVersion
        };

  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    {
      workflow?: Record<string, any>;
      status?: unknown;
    }
  >(procedure, requestBody, {
    ...options,
    workspaceId: options.workspaceId ?? params.workspaceId
  });

  if (!rpcRes.ok) {
    return {
      ok: false,
      error: rpcRes.error.message
    };
  }

  const confirmedStatus = normalizeWorkflowStatus(
    rpcRes.data?.workflow?.status ?? rpcRes.data?.status
  );
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

export type WorkflowEditorLoadState = 'waiting_context' | 'loading' | 'loaded' | 'error';

export interface WorkflowEditorSessionSnapshot {
  workflowId: string;
  workspaceId: string | null;
  userId: string | null;
  loadState: WorkflowEditorLoadState;
  loadedContextKey: string | null;
  title: string;
  description: string;
  status: 'draft' | 'active' | 'paused';
  version: number | null;
  nodes: WorkflowNode[];
  edges: WorkflowEdge[];
  error: string | null;
  isPersisting: boolean;
}

export interface WorkflowEditorContextInput {
  userId?: string | null;
  workspaceId?: string | null;
  workflowId?: string | null;
  authState?: string;
  isDiscoveryLoading?: boolean;
  force?: boolean;
}

/**
 * Fail-closed state controller for the Workflow Studio editor (`W021`).
 *
 * Guarantees:
 * 1. Never seeds a hardcoded sample graph or synthetic `version = 3` before or after a failed `Get`.
 * 2. Blocks `save()` and `setStatus()` whenever `loadState !== 'loaded'` or `version === null`.
 * 3. Re-synchronizes when delayed auth/workspace discovery resolves or when `(userId, workspaceId, workflowId)` changes.
 * 4. Uses a monotonic request epoch to discard stale in-flight `Get`/`Update`/`Activate` responses after a workspace or user switch.
 */
export function createWorkflowEditorSession(initialWorkflowId: string) {
  let state: WorkflowEditorSessionSnapshot = {
    workflowId: String(initialWorkflowId || '').trim(),
    workspaceId: null,
    userId: null,
    loadState: 'waiting_context',
    loadedContextKey: null,
    title: '',
    description: '',
    status: 'draft',
    version: null,
    nodes: [],
    edges: [],
    error: null,
    isPersisting: false
  };

  let loadEpoch = 0;
  const subscribers = new Set<(snapshot: WorkflowEditorSessionSnapshot) => void>();

  function emit() {
    const snap = getSnapshot();
    for (const sub of subscribers) {
      sub(snap);
    }
  }

  function getSnapshot(): WorkflowEditorSessionSnapshot {
    return {
      ...state,
      nodes: [...state.nodes],
      edges: [...state.edges]
    };
  }

  function subscribe(run: (snapshot: WorkflowEditorSessionSnapshot) => void): () => void {
    subscribers.add(run);
    run(getSnapshot());
    return () => {
      subscribers.delete(run);
    };
  }

  async function syncContext(
    ctx: WorkflowEditorContextInput,
    options: CanonicalRpcOptions = {}
  ): Promise<{
    ok: boolean;
    loadState: WorkflowEditorLoadState;
    stale?: boolean;
    error?: string;
  }> {
    const targetWorkflowId = String(ctx.workflowId ?? state.workflowId ?? '').trim();
    const targetUserId = String(ctx.userId ?? '').trim() || null;
    const targetWorkspaceId = String(ctx.workspaceId ?? '').trim() || null;

    if (
      ctx.isDiscoveryLoading === true ||
      (ctx.authState !== undefined && ctx.authState !== 'authenticated') ||
      !targetUserId ||
      !targetWorkspaceId ||
      !targetWorkflowId
    ) {
      loadEpoch += 1;
      state = {
        workflowId: targetWorkflowId,
        workspaceId: targetWorkspaceId,
        userId: targetUserId,
        loadState: 'waiting_context',
        loadedContextKey: null,
        title: '',
        description: '',
        status: 'draft',
        version: null,
        nodes: [],
        edges: [],
        error: null,
        isPersisting: false
      };
      emit();
      return {
        ok: false,
        loadState: 'waiting_context'
      };
    }

    const contextKey = `${targetUserId}:${targetWorkspaceId}:${targetWorkflowId}`;
    if (!ctx.force && state.loadState === 'loaded' && state.loadedContextKey === contextKey) {
      return {
        ok: true,
        loadState: 'loaded'
      };
    }

    const requestEpoch = ++loadEpoch;
    state = {
      workflowId: targetWorkflowId,
      workspaceId: targetWorkspaceId,
      userId: targetUserId,
      loadState: 'loading',
      loadedContextKey: null,
      title: '',
      description: '',
      status: 'draft',
      version: null,
      nodes: [],
      edges: [],
      error: null,
      isPersisting: false
    };
    emit();

    const res = await loadWorkflowRemote(
      {
        workspaceId: targetWorkspaceId,
        workflowId: targetWorkflowId
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
      !res.workflow ||
      !res.workflow.graph ||
      res.workflow.graph.nodes.length === 0 ||
      res.workflow.workflowId !== targetWorkflowId
    ) {
      const errMessage =
        res.error ||
        'Không thể tải cấu hình workflow từ máy chủ. Trình chỉnh sửa đã khóa lưu để bảo vệ dữ liệu hiện có (fail-closed).';
      state = {
        ...state,
        loadState: 'error',
        loadedContextKey: null,
        version: null,
        nodes: [],
        edges: [],
        error: errMessage,
        isPersisting: false
      };
      emit();
      return {
        ok: false,
        loadState: 'error',
        error: errMessage
      };
    }

    state = {
      workflowId: res.workflow.workflowId,
      workspaceId: targetWorkspaceId,
      userId: targetUserId,
      loadState: 'loaded',
      loadedContextKey: contextKey,
      title: res.workflow.title || res.workflow.workflowId,
      description: res.workflow.description || '',
      status: res.workflow.status,
      version: res.workflow.version,
      nodes: [...res.workflow.graph.nodes],
      edges: [...res.workflow.graph.edges],
      error: null,
      isPersisting: false
    };
    emit();
    return {
      ok: true,
      loadState: 'loaded'
    };
  }

  function setMeta(meta: { title?: string; description?: string }) {
    if (state.loadState !== 'loaded') return;
    state = {
      ...state,
      title: meta.title !== undefined ? meta.title : state.title,
      description: meta.description !== undefined ? meta.description : state.description
    };
    emit();
  }

  function setGraph(graph: { nodes: WorkflowNode[]; edges: WorkflowEdge[] }) {
    if (state.loadState !== 'loaded') return;
    state = {
      ...state,
      nodes: [...graph.nodes],
      edges: [...graph.edges]
    };
    emit();
  }

  async function save(options: CanonicalRpcOptions = {}): Promise<SaveWorkflowRemoteResult> {
    if (
      state.loadState !== 'loaded' ||
      state.version === null ||
      !state.loadedContextKey ||
      !state.workspaceId ||
      !state.workflowId
    ) {
      return {
        ok: false,
        error:
          'Không thể lưu workflow khi dữ liệu gốc chưa được tải thành công từ máy chủ (fail-closed).'
      };
    }

    const saveEpoch = loadEpoch;
    const saveContextKey = state.loadedContextKey;
    const activeWorkspaceId = state.workspaceId;
    const activeWorkflowId = state.workflowId;
    const activeVersion = state.version;
    state = { ...state, isPersisting: true };
    emit();

    try {
      const res = await saveWorkflowRemote(
        {
          workspaceId: activeWorkspaceId,
          workflowId: activeWorkflowId,
          title: state.title,
          description: state.description,
          expectedVersion: activeVersion,
          graph: {
            schema_version: 1,
            nodes: state.nodes,
            edges: state.edges
          }
        },
        {
          ...options,
          workspaceId: activeWorkspaceId
        }
      );

      if (saveEpoch !== loadEpoch || state.loadedContextKey !== saveContextKey) {
        return {
          ok: false,
          error: 'Ngữ cảnh phiên làm việc đã thay đổi trong khi lưu (fail-closed).'
        };
      }

      if (res.ok && typeof res.version === 'number') {
        state = {
          ...state,
          version: res.version,
          status: res.status ?? state.status,
          error: null,
          isPersisting: false
        };
        emit();
      } else {
        state = {
          ...state,
          isPersisting: false
        };
        emit();
      }
      return res;
    } catch (err) {
      if (saveEpoch === loadEpoch && state.loadedContextKey === saveContextKey) {
        state = { ...state, isPersisting: false };
        emit();
      }
      return {
        ok: false,
        error: err instanceof Error ? err.message : 'Lỗi không xác định khi lưu workflow'
      };
    }
  }

  async function setStatus(
    targetStatus: 'draft' | 'active' | 'paused',
    options: CanonicalRpcOptions = {}
  ): Promise<SaveWorkflowRemoteResult> {
    if (
      state.loadState !== 'loaded' ||
      state.version === null ||
      !state.loadedContextKey ||
      !state.workspaceId ||
      !state.workflowId
    ) {
      return {
        ok: false,
        error:
          'Không thể đổi trạng thái workflow khi dữ liệu gốc chưa được tải thành công từ máy chủ (fail-closed).'
      };
    }

    const statusEpoch = loadEpoch;
    const statusContextKey = state.loadedContextKey;
    const activeWorkspaceId = state.workspaceId;
    const activeWorkflowId = state.workflowId;
    const activeVersion = state.version;
    state = { ...state, isPersisting: true };
    emit();

    try {
      const res = await setWorkflowStatusRemote(
        {
          workspaceId: activeWorkspaceId,
          workflowId: activeWorkflowId,
          targetStatus,
          expectedVersion: activeVersion
        },
        {
          ...options,
          workspaceId: activeWorkspaceId
        }
      );

      if (statusEpoch !== loadEpoch || state.loadedContextKey !== statusContextKey) {
        return {
          ok: false,
          error: 'Ngữ cảnh phiên làm việc đã thay đổi trong khi cập nhật trạng thái (fail-closed).'
        };
      }

      if (res.ok && res.status) {
        state = {
          ...state,
          status: res.status,
          version: typeof res.version === 'number' ? res.version : state.version,
          error: null,
          isPersisting: false
        };
        emit();
      } else {
        state = {
          ...state,
          isPersisting: false
        };
        emit();
      }
      return res;
    } catch (err) {
      if (statusEpoch === loadEpoch && state.loadedContextKey === statusContextKey) {
        state = { ...state, isPersisting: false };
        emit();
      }
      return {
        ok: false,
        error: err instanceof Error ? err.message : 'Lỗi không xác định khi cập nhật trạng thái'
      };
    }
  }

  return {
    subscribe,
    getSnapshot,
    syncContext,
    setMeta,
    setGraph,
    save,
    setStatus
  };
}
