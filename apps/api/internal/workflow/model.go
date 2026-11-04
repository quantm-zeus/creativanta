package workflow

import (
	"time"
)

// WorkflowStatus defines canonical lifecycle states per database_schema.md §12.2 and workflow_studio.md RULE-M20-001.
type WorkflowStatus string

const (
	WorkflowStatusDraft    WorkflowStatus = "draft"
	WorkflowStatusActive   WorkflowStatus = "active"
	WorkflowStatusPaused   WorkflowStatus = "paused"
	WorkflowStatusError    WorkflowStatus = "error"
	WorkflowStatusArchived WorkflowStatus = "archived"
)

// WorkflowRunStatus defines runtime run lifecycle states per database_schema.md §12.3 and workflow_studio.md.
type WorkflowRunStatus string

const (
	WorkflowRunStatusQueued                     WorkflowRunStatus = "queued"
	WorkflowRunStatusRunning                    WorkflowRunStatus = "running"
	WorkflowRunStatusWaitingApproval            WorkflowRunStatus = "waiting_approval"
	WorkflowRunStatusWaitingExternalCondition   WorkflowRunStatus = "waiting_external_condition"
	WorkflowRunStatusSucceeded                  WorkflowRunStatus = "succeeded"
	WorkflowRunStatusPartiallySucceeded         WorkflowRunStatus = "partially_succeeded"
	WorkflowRunStatusFailed                     WorkflowRunStatus = "failed"
	WorkflowRunStatusCancelled                  WorkflowRunStatus = "cancelled"
	WorkflowRunStatusRequiresManualIntervention WorkflowRunStatus = "requires_manual_intervention"
)

// NodeType defines all 10 canonical workflow node types per database_schema.md §12.3A and runtime_workflow.md §4.2.
type NodeType string

const (
	NodeTypeTrigger     NodeType = "trigger"
	NodeTypeCondition   NodeType = "condition"
	NodeTypeTransform   NodeType = "transform"
	NodeTypeAction      NodeType = "action"
	NodeTypeApproval    NodeType = "approval"
	NodeTypeWait        NodeType = "wait"
	NodeTypeFallback    NodeType = "fallback"
	NodeTypeDiagnostics NodeType = "diagnostics"
	NodeTypeHandoff     NodeType = "handoff"
	NodeTypeTerminal    NodeType = "terminal"
)

// TriggerType defines supported trigger types per database_schema.md §25.4.
type TriggerType string

const (
	TriggerTypeEvent    TriggerType = "event"
	TriggerTypeSchedule TriggerType = "schedule"
	TriggerTypeManual   TriggerType = "manual"
	TriggerTypeWebhook  TriggerType = "webhook"
)

// EdgeBranch defines branching condition labels per database_schema.md §25.7.
type EdgeBranch string

const (
	EdgeBranchSuccess EdgeBranch = "success"
	EdgeBranchFailure EdgeBranch = "failure"
	EdgeBranchTrue    EdgeBranch = "true"
	EdgeBranchFalse   EdgeBranch = "false"
)

// TriggerFilter defines filtering on trigger payload properties.
type TriggerFilter struct {
	Field     string `json:"field"`
	Operator  string `json:"operator"` // eq, neq, gt, gte, lt, lte, in, contains, exists, matches
	ValueJSON string `json:"value_json"`
}

// TriggerConfig defines trigger configuration per database_schema.md §25.4.
type TriggerConfig struct {
	Type           TriggerType     `json:"type"`
	EventType      string          `json:"event_type,omitempty"`
	CronExpression string          `json:"cron_expression,omitempty"`
	WebhookPath    string          `json:"webhook_path,omitempty"`
	Filters        []TriggerFilter `json:"filters,omitempty"`
}

// ConditionConfig defines condition node rules.
type ConditionConfig struct {
	Field     string `json:"field"`
	Operator  string `json:"operator"` // eq, neq, gt, gte, lt, lte, in, contains, exists, matches
	ValueJSON string `json:"value_json"`
}

// TransformMapping defines declarative field mapping (no arbitrary eval).
type TransformMapping struct {
	TargetField  string `json:"target_field"`
	SourceField  string `json:"source_field"`
	DefaultValue string `json:"default_value,omitempty"`
	Template     string `json:"template,omitempty"`
}

// TransformConfig defines declarative transform node configuration.
type TransformConfig struct {
	Mappings []TransformMapping `json:"mappings"`
}

// ActionConfig defines an inventory RPC execution node.
type ActionConfig struct {
	RPCName        string `json:"rpc_name"`
	InputJSON      string `json:"input_json"`
	TimeoutSeconds int    `json:"timeout_seconds,omitempty"`
	MaxRetries     int    `json:"max_retries,omitempty"`
	BackoffSeconds int    `json:"backoff_seconds,omitempty"`
}

// ApprovalConfig defines an approval gate node.
type ApprovalConfig struct {
	ApproverIDs              []string `json:"approver_ids"`
	RequiredApprovals        int      `json:"required_approvals"`
	ExpiresAtDurationSeconds int64    `json:"expires_at_duration_seconds"`
	AutoActionOnTimeout      string   `json:"auto_action_on_timeout,omitempty"` // reject, fallback, fail
}

// WaitConfig defines a pause/wait node.
type WaitConfig struct {
	WaitType        string `json:"wait_type"` // duration, until_timestamp, external_condition
	DurationSeconds int64  `json:"duration_seconds,omitempty"`
	ResumeCondition string `json:"resume_condition,omitempty"`
	UntilTimestamp  string `json:"until_timestamp,omitempty"`
}

// FallbackConfig defines a fallback routing node.
type FallbackConfig struct {
	FallbackNodeID string `json:"fallback_node_id"`
	ReasonTemplate string `json:"reason_template,omitempty"`
	LogLevel       string `json:"log_level,omitempty"` // info, warning, error
}

// DiagnosticsConfig defines a diagnostics node emitting structured logs.
type DiagnosticsConfig struct {
	Severity            string `json:"severity"` // info, warning, error, critical
	UserMessage         string `json:"user_message"`
	OperatorMessage     string `json:"operator_message"`
	RecommendedNextStep string `json:"recommended_next_step,omitempty"`
}

// HandoffConfig defines a human escalation node.
type HandoffConfig struct {
	TargetUserID string `json:"target_user_id,omitempty"`
	TargetRole   string `json:"target_role,omitempty"`
	ContextNote  string `json:"context_note,omitempty"`
}

// TerminalConfig defines a workflow outcome terminal node.
type TerminalConfig struct {
	Outcome        string `json:"outcome"` // succeeded, partially_succeeded, failed, cancelled
	ResultTemplate string `json:"result_template,omitempty"`
}

// WorkflowNode defines a single node in a WorkflowGraph.
type WorkflowNode struct {
	NodeID            string             `json:"node_id"`
	NodeType          NodeType           `json:"node_type"`
	Title             string             `json:"title,omitempty"`
	Description       string             `json:"description,omitempty"`
	Config            map[string]any     `json:"config"`
	TriggerConfig     *TriggerConfig     `json:"trigger_config,omitempty"`
	ConditionConfig   *ConditionConfig   `json:"condition_config,omitempty"`
	TransformConfig   *TransformConfig   `json:"transform_config,omitempty"`
	ActionConfig      *ActionConfig      `json:"action_config,omitempty"`
	ApprovalConfig    *ApprovalConfig    `json:"approval_config,omitempty"`
	WaitConfig        *WaitConfig        `json:"wait_config,omitempty"`
	FallbackConfig    *FallbackConfig    `json:"fallback_config,omitempty"`
	DiagnosticsConfig *DiagnosticsConfig `json:"diagnostics_config,omitempty"`
	HandoffConfig     *HandoffConfig     `json:"handoff_config,omitempty"`
	TerminalConfig    *TerminalConfig    `json:"terminal_config,omitempty"`
}

// WorkflowEdge defines a directed connection between two nodes.
type WorkflowEdge struct {
	FromNodeID string     `json:"from_node_id"`
	ToNodeID   string     `json:"to_node_id"`
	Branch     EdgeBranch `json:"branch,omitempty"` // success, failure, true, false
}

// WorkflowGraph defines the complete canonical directed workflow graph per database_schema.md §25.7.
type WorkflowGraph struct {
	SchemaVersion int            `json:"schema_version"` // strictly 1
	Nodes         []WorkflowNode `json:"nodes"`
	Edges         []WorkflowEdge `json:"edges"`
}

// Workflow defines a canonical workflow entity per database_schema.md §12.2.
type Workflow struct {
	WorkflowID           string         `json:"workflow_id"`
	WorkspaceID          string         `json:"workspace_id"`
	Title                string         `json:"title"`
	Description          string         `json:"description,omitempty"`
	WorkflowType         string         `json:"workflow_type"` // custom, recipe_installed, agent
	Status               WorkflowStatus `json:"status"`        // draft, active, paused, error, archived
	Version              int32          `json:"version"`
	TriggerConfig        TriggerConfig  `json:"trigger_config"`
	ActionChain          WorkflowGraph  `json:"action_chain"`
	ApprovalRequirements []string       `json:"approval_requirements"`
	ActivepiecesFlowID   string         `json:"activepieces_flow_id,omitempty"`
	TierLimitCheck       bool           `json:"tier_limit_check"`
	RunCount             int32          `json:"run_count"`
	CreatedBy            string         `json:"created_by,omitempty"`
	CreatedAt            time.Time      `json:"created_at"`
	UpdatedAt            time.Time      `json:"updated_at"`
	DeletedAt            *time.Time     `json:"deleted_at,omitempty"`
}

// WorkflowRun defines an execution run instance per database_schema.md §12.3.
type WorkflowRun struct {
	RunID              string            `json:"run_id"`
	WorkspaceID        string            `json:"workspace_id"`
	WorkflowID         string            `json:"workflow_id"`
	TriggerEvent       map[string]any    `json:"trigger_event"`
	Status             WorkflowRunStatus `json:"status"`
	CurrentNode        string            `json:"current_node,omitempty"`
	ResultSummary      map[string]any    `json:"result_summary,omitempty"`
	ExecutionLog       []any             `json:"execution_log"`
	AffectedObjectRefs []any             `json:"affected_object_refs"`
	SideEffectsSummary []any             `json:"side_effects_summary"`
	ActivepiecesRunID  string            `json:"activepieces_run_id,omitempty"`
	StartedAt          *time.Time        `json:"started_at,omitempty"`
	CompletedAt        *time.Time        `json:"completed_at,omitempty"`
	CreatedAt          time.Time         `json:"created_at"`
	UpdatedAt          time.Time         `json:"updated_at"`
	DeletedAt          *time.Time        `json:"deleted_at,omitempty"`
}

// WorkflowRunStep defines a single node execution step per database_schema.md §12.3A.
type WorkflowRunStep struct {
	StepID         string     `json:"step_id"`
	WorkspaceID    string     `json:"workspace_id"`
	RunID          string     `json:"run_id"`
	NodeID         string     `json:"node_id"`
	NodeType       NodeType   `json:"node_type"`
	StepOrder      int16      `json:"step_order"`
	Status         string     `json:"status"` // queued, running, waiting_approval, waiting_external_condition, succeeded, skipped, failed, cancelled
	InputSnapshot  string     `json:"input_snapshot"`
	OutputSnapshot string     `json:"output_snapshot"`
	DiagnosticsRef string     `json:"diagnostics_ref,omitempty"`
	SideEffectRefs []string   `json:"side_effect_refs"`
	StartedAt      *time.Time `json:"started_at,omitempty"`
	CompletedAt    *time.Time `json:"completed_at,omitempty"`
	CreatedAt      time.Time  `json:"created_at"`
	UpdatedAt      time.Time  `json:"updated_at"`
	DeletedAt      *time.Time `json:"deleted_at,omitempty"`
}

// PortableWorkflowPayload defines portable export/import format per database_schema.md §27.4.
type PortableWorkflowPayload struct {
	SchemaVersion int            `json:"schema_version"` // 1
	Title         string         `json:"title"`
	Description   string         `json:"description,omitempty"`
	WorkflowType  string         `json:"workflow_type"`
	TriggerConfig TriggerConfig  `json:"trigger_config"`
	Graph         WorkflowGraph  `json:"graph"`
	LicenseNotice string         `json:"license_notice"`
	Parameters    map[string]any `json:"parameters,omitempty"`
}
