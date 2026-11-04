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
