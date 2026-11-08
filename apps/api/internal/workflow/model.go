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
	InitiatedByUserID  string            `json:"initiated_by_user_id,omitempty"`
	InitiatedByRole    string            `json:"initiated_by_role,omitempty"`
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

// ----------------------------------------------------------------------------
// P7-02 Models: Approvals, Preflight, Diagnostics, DLQ, Side Effects
// ----------------------------------------------------------------------------

// ApprovalRequest defines an approval gate entity per database_schema.md §18.1 and Pack 03 §6.
type ApprovalRequest struct {
	RequestID       string     `json:"request_id"`
	WorkspaceID     string     `json:"workspace_id"`
	RequestType     string     `json:"request_type"` // workflow_approval
	ObjectType      string     `json:"object_type"`  // workflow_run
	ObjectID        string     `json:"object_id"`    // run_id
	RequestedBy     string     `json:"requested_by"`
	ApprovedBy      string     `json:"approved_by,omitempty"`
	Status          string     `json:"status"` // pending_approval, approved, rejected, expired, cancelled
	Reason          string     `json:"reason,omitempty"`
	RejectionReason string     `json:"rejection_reason,omitempty"`
	ExpiresAt       *time.Time `json:"expires_at,omitempty"`
	CreatedAt       time.Time  `json:"created_at"`
	UpdatedAt       time.Time  `json:"updated_at"`

	// Workflow binding metadata (enforces ActionHash / Target / Version / ActionNode / Consumption binding)
	WorkflowID        string   `json:"workflow_id,omitempty"`
	NodeID            string   `json:"node_id,omitempty"`
	ActionNodeID      string   `json:"action_node_id,omitempty"`
	ConsumedByNodeID  string   `json:"consumed_by_node_id,omitempty"`
	ConsumedByStepID  string   `json:"consumed_by_step_id,omitempty"`
	WorkflowVersion   int32    `json:"workflow_version,omitempty"`
	ActionHash        string   `json:"action_hash,omitempty"`
	TargetObjects     []string `json:"target_objects,omitempty"`
	InputSnapshot     string   `json:"input_snapshot,omitempty"`
	MaxBudgetQuote    float64  `json:"max_budget_quote,omitempty"`
	ApproverIDs       []string `json:"approver_ids,omitempty"`
	RequiredApprovals int      `json:"required_approvals,omitempty"`
	ApprovedByIDs     []string `json:"approved_by_ids,omitempty"`
}

// ApprovalFilter provides filtering for approval queries.
type ApprovalFilter struct {
	Status     string
	WorkflowID string
	RunID      string
	Limit      int
	Offset     int
}

// ApprovalQueueStats provides aggregate counts for the approval queue.
type ApprovalQueueStats struct {
	Total     int `json:"total"`
	Pending   int `json:"pending"`
	Approved  int `json:"approved"`
	Rejected  int `json:"rejected"`
	Expired   int `json:"expired"`
	Cancelled int `json:"cancelled"`
}

// DLQItem defines a dead-letter queue entry per database_schema.md §18.4G and Pack 03 §7.2.
type DLQItem struct {
	DLQID               string           `json:"dlq_id"`
	QueueName           string           `json:"queue_name"`
	OriginalMessageID   string           `json:"original_message_id"` // run_id
	Payload             map[string]any   `json:"payload"`
	ErrorClass          string           `json:"error_class"`
	ErrorMessage        string           `json:"error_message"`
	LastErrorAt         time.Time        `json:"last_error_at"`
	AttemptCount        int              `json:"attempt_count"`
	RetryHistory        []map[string]any `json:"retry_history"`
	WorkspaceID         string           `json:"workspace_id,omitempty"`
	Status              string           `json:"status"` // pending, retrying, resolved, discarded
	ResolvedAt          *time.Time       `json:"resolved_at,omitempty"`
	ResolvedBy          string           `json:"resolved_by,omitempty"`
	ResolutionNotes     string           `json:"resolution_notes,omitempty"`
	SuggestedRepairPath string           `json:"suggested_repair_path,omitempty"`
	CanonicalObjectRefs []string         `json:"canonical_object_refs,omitempty"`
	CreatedAt           time.Time        `json:"created_at"`
}

// DiagnosticsRecord defines structured failure/intervention explanations per runtime_workflow.md §8 and RULE-M20-003.
type DiagnosticsRecord struct {
	RecordID              string         `json:"record_id"`
	WorkspaceID           string         `json:"workspace_id"`
	RunID                 string         `json:"run_id"`
	FailureType           string         `json:"failure_type"` // CAPABILITY_DEGRADED, APPROVAL_EXPIRED, APPROVAL_INVALIDATED, ACTION_FAILED, PERMISSION_DENIED, CASCADE_DEPTH_EXCEEDED
	AffectedNodeID        string         `json:"affected_node_id"`
	AffectedNodeType      NodeType       `json:"affected_node_type"`
	UserFacingExplanation string         `json:"user_facing_explanation"`
	OperatorExplanation   string         `json:"operator_explanation"`
	RecommendedNextStep   string         `json:"recommended_next_step"`
	FallbackAvailable     bool           `json:"fallback_available"`
	TechnicalDetails      map[string]any `json:"technical_details,omitempty"`
	CreatedAt             time.Time      `json:"created_at"`
}

// SideEffect defines an immutable business effect audit entry per runtime_workflow.md §10 and RULE-M20-005.
type SideEffect struct {
	SideEffectID    string    `json:"side_effect_id"`
	RunID           string    `json:"run_id"`
	StepID          string    `json:"step_id"`
	NodeID          string    `json:"node_id"`
	Actor           string    `json:"actor"`  // system / user_id
	Action          string    `json:"action"` // rpc_name
	AffectedObjects []string  `json:"affected_objects"`
	OldStateSummary string    `json:"old_state_summary,omitempty"`
	NewStateSummary string    `json:"new_state_summary,omitempty"`
	Reason          string    `json:"reason,omitempty"`
	CorrelationID   string    `json:"correlation_id"`
	Timestamp       time.Time `json:"timestamp"`
}

// PreflightActionSummary provides preflight verification details for an action node.
type PreflightActionSummary struct {
	NodeID             string   `json:"node_id"`
	RPCName            string   `json:"rpc_name"`
	RequiredPermission string   `json:"required_permission"`
	Platform           string   `json:"platform,omitempty"`
	CapabilityStatus   string   `json:"capability_status,omitempty"` // supported, degraded, unsupported
	RequiresApproval   bool     `json:"requires_approval"`
	QuotedCredits      float64  `json:"quoted_credits"`
	MissingInputs      []string `json:"missing_inputs,omitempty"`
}

// PreflightReport aggregates preflight check results prior to activation or execution.
type PreflightReport struct {
	WorkflowID          string                   `json:"workflow_id,omitempty"`
	Valid               bool                     `json:"valid"`
	Actions             []PreflightActionSummary `json:"actions"`
	TotalMaxCreditQuote float64                  `json:"total_max_credit_quote"`
	RequiresApproval    bool                     `json:"requires_approval"`
	Warnings            []string                 `json:"warnings,omitempty"`
	Errors              []string                 `json:"errors,omitempty"`
}

// ResumeSignal defines a wake-up signal delivered to a paused workflow run.
type ResumeSignal struct {
	SignalType string         `json:"signal_type"` // approval_granted, approval_rejected, wait_timer, external_condition
	Payload    map[string]any `json:"payload,omitempty"`
	Token      string         `json:"token,omitempty"`
}
