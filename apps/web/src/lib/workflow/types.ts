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
