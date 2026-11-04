/**
 * Workflow domain types per docs/04_contracts/database_schema.md §12.2, §12.3, §12.3A, §25.4, §25.7, §27.4
 * and docs/02_features/automation/workflow_studio.md (RULE-M20-001 - RULE-M20-007).
 */

export type WorkflowStatus = 'draft' | 'active' | 'paused' | 'error' | 'archived';

export type WorkflowRunStatus =
  | 'queued'
  | 'running'
  | 'waiting_approval'
  | 'waiting_external_condition'
  | 'succeeded'
  | 'partially_succeeded'
  | 'failed'
  | 'cancelled'
  | 'requires_manual_intervention';

export type NodeType =
  | 'trigger'
  | 'condition'
  | 'transform'
  | 'action'
  | 'approval'
  | 'wait'
  | 'fallback'
  | 'diagnostics'
  | 'handoff'
  | 'terminal';

export type TriggerType = 'event' | 'schedule' | 'manual' | 'webhook';

export type EdgeBranch = 'success' | 'failure' | 'true' | 'false';

export interface TriggerFilter {
  field: string;
  operator: 'eq' | 'neq' | 'gt' | 'gte' | 'lt' | 'lte' | 'in' | 'contains' | 'exists' | 'matches';
  value_json: string;
}

export interface TriggerConfig {
  type: TriggerType;
  event_type?: string;
  cron_expression?: string;
  webhook_path?: string;
  filters?: TriggerFilter[];
}

export interface ConditionConfig {
  field: string;
  operator: 'eq' | 'neq' | 'gt' | 'gte' | 'lt' | 'lte' | 'in' | 'contains' | 'exists' | 'matches';
  value_json: string;
}

export interface TransformMapping {
  target_field: string;
  source_field: string;
  default_value?: string;
  template?: string;
}

export interface TransformConfig {
  mappings: TransformMapping[];
}

export interface ActionConfig {
  rpc_name: string;
  input_json: string;
  timeout_seconds?: number;
  max_retries?: number;
  backoff_seconds?: number;
}

export interface ApprovalConfig {
  approver_ids: string[];
  required_approvals: number;
  expires_at_duration_seconds: number;
  auto_action_on_timeout?: 'reject' | 'fallback' | 'fail';
}

export interface WaitConfig {
  wait_type: 'duration' | 'until_timestamp' | 'external_condition';
  duration_seconds?: number;
  resume_condition?: string;
  until_timestamp?: string;
}

export interface FallbackConfig {
  fallback_node_id: string;
  reason_template?: string;
  log_level?: 'info' | 'warning' | 'error';
}

export interface DiagnosticsConfig {
  severity: 'info' | 'warning' | 'error' | 'critical';
  user_message: string;
  operator_message: string;
  recommended_next_step?: string;
}

export interface HandoffConfig {
  target_user_id?: string;
  target_role?: string;
  context_note?: string;
}

export interface TerminalConfig {
  outcome: 'succeeded' | 'partially_succeeded' | 'failed' | 'cancelled';
  result_template?: string;
}

export interface WorkflowNode {
  node_id: string;
  node_type: NodeType;
  title: string;
  description?: string;
  config?: Record<string, unknown>;
  trigger_config?: TriggerConfig;
  condition_config?: ConditionConfig;
  transform_config?: TransformConfig;
  action_config?: ActionConfig;
  approval_config?: ApprovalConfig;
  wait_config?: WaitConfig;
  fallback_config?: FallbackConfig;
  diagnostics_config?: DiagnosticsConfig;
  handoff_config?: HandoffConfig;
  terminal_config?: TerminalConfig;
}

export interface WorkflowEdge {
  from_node_id: string;
  to_node_id: string;
  branch?: EdgeBranch;
}

export interface WorkflowGraph {
  schema_version: number; // strictly 1
  nodes: WorkflowNode[];
  edges: WorkflowEdge[];
}

export interface Workflow {
  workflow_id: string;
  workspace_id: string;
  title: string;
  description?: string;
  workflow_type: string; // custom, recipe_installed, agent
  status: WorkflowStatus;
  version: number;
  trigger_config: TriggerConfig;
  action_chain: WorkflowGraph;
  approval_requirements: string[];
  activepieces_flow_id?: string;
  tier_limit_check: boolean;
  run_count: number;
  created_by?: string;
  created_at: string;
  updated_at: string;
}

export interface WorkflowSummary {
  workflow_id: string;
  workspace_id: string;
  title: string;
  workflow_type: string;
  status: WorkflowStatus;
  version: number;
  trigger_type: TriggerType;
  node_count: number;
  run_count: number;
  created_at: string;
  updated_at: string;
}

export interface WorkflowRun {
  run_id: string;
  workspace_id: string;
  workflow_id: string;
  status: WorkflowRunStatus;
  current_node?: string;
  trigger_event: Record<string, unknown>;
  result_summary?: Record<string, unknown>;
  execution_log: unknown[];
  affected_object_refs: unknown[];
  side_effects_summary: unknown[];
  started_at?: string;
  completed_at?: string;
  created_at: string;
  updated_at: string;
}

export interface WorkflowRunStep {
  step_id: string;
  workspace_id: string;
  run_id: string;
  node_id: string;
  node_type: NodeType;
  step_order: number;
  status: string;
  input_snapshot: string;
  output_snapshot: string;
  diagnostics_ref?: string;
  side_effect_refs: string[];
  started_at?: string;
  completed_at?: string;
  created_at: string;
  updated_at: string;
}

export interface PortableWorkflowPayload {
  schema_version: number; // 1
  title: string;
  description?: string;
  workflow_type: string;
  trigger_config: TriggerConfig;
  graph: WorkflowGraph;
  license_notice: string;
  parameters?: Record<string, unknown>;
}

export interface SimulationStepResult {
  node_id: string;
  node_type: NodeType;
  status: 'simulated_success' | 'simulated_skipped' | 'simulated_failure';
  simulated_output?: Record<string, unknown>;
  diagnostic_message?: string;
  estimated_credits: number;
}

export interface SimulationReport {
  success: boolean;
  step_results: SimulationStepResult[];
  total_estimated_credits: number;
  simulation_summary: string;
}

// ----------------------------------------------------------------------------
// P7-02: Approvals, Preflight, Diagnostics, DLQ, Side Effects
// ----------------------------------------------------------------------------

export interface ApprovalRequest {
  request_id?: string;
  approval_id?: string;
  workspace_id: string;
  request_type?: string;
  object_type?: string;
  object_id?: string;
  requested_by?: string;
  approved_by?: string;
  title?: string;
  status: 'pending_approval' | 'approved' | 'rejected' | 'expired' | 'cancelled' | 'pending' | 'invalidated';
  reason?: string;
  rejection_reason?: string;
  expires_at?: string;
  workflow_id?: string;
  run_id?: string;
  node_id?: string;
  workflow_version?: number;
  action_hash?: string;
  action_rpc?: string;
  target_objects?: string[];
  input_snapshot?: string;
  max_budget_quote?: number;
  budget_quote_credits?: number;
  approver_roles?: string[];
  is_invalidated?: boolean;
  invalidation_reason?: string;
  decided_at?: string;
  decided_by?: string;
  decision_notes?: string;
  requested_at?: string;
  created_at?: string;
  updated_at?: string;
}

export interface ApprovalQueueStats {
  total: number;
  pending: number;
  approved: number;
  rejected: number;
  expired: number;
  cancelled: number;
  pending_count?: number;
  invalidated_count?: number;
  expiring_soon_count?: number;
  total_approved?: number;
  total_rejected?: number;
}

export interface DLQItem {
  dlq_id: string;
  queue_name?: string;
  original_message_id?: string;
  payload?: Record<string, unknown>;
  failed_payload?: Record<string, unknown>;
  error_class?: string;
  error_code?: string;
  error_message: string;
  last_error_at?: string;
  attempt_count?: number;
  retry_count?: number;
  max_retries?: number;
  retry_history?: Array<Record<string, unknown>>;
  workspace_id?: string;
  workflow_id?: string;
  run_id?: string;
  node_id?: string;
  status: 'pending' | 'retrying' | 'resolved' | 'discarded';
  resolved_at?: string;
  resolved_by?: string;
  resolution_notes?: string;
  suggested_repair_path?: string;
  canonical_object_refs?: string[];
  created_at: string;
  updated_at?: string;
}

export interface DiagnosticsRecord {
  record_id: string;
  workspace_id: string;
  run_id: string;
  failure_type: string;
  affected_node_id: string;
  affected_node_type: NodeType;
  user_facing_explanation: string;
  operator_explanation: string;
  recommended_next_step: string;
  fallback_available: boolean;
  technical_details?: Record<string, unknown>;
  created_at: string;
}

export interface SideEffect {
  side_effect_id: string;
  run_id: string;
  step_id: string;
  node_id: string;
  actor: string;
  action: string;
  affected_objects: string[];
  old_state_summary?: string;
  new_state_summary?: string;
  reason?: string;
  correlation_id: string;
  timestamp: string;
}

export interface PreflightActionSummary {
  node_id: string;
  rpc_name: string;
  required_permission: string;
  platform?: string;
  capability_status?: string;
  requires_approval: boolean;
  quoted_credits: number;
  missing_inputs?: string[];
}

export interface PreflightReport {
  workflow_id?: string;
  valid: boolean;
  actions: PreflightActionSummary[];
  total_max_credit_quote: number;
  requires_approval: boolean;
  warnings: string[];
  errors: string[];
}

