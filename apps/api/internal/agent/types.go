package agent

import (
	"context"
	"crypto/rand"
	"errors"
	"fmt"
	"time"

	automationv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	ErrUnauthenticated        = errors.New("agent: unauthenticated caller")
	ErrCrossTenantDenied      = errors.New("agent: cross-tenant access strictly forbidden")
	ErrRunNotFound            = errors.New("agent: agent run not found")
	ErrStepNotFound           = errors.New("agent: agent step not found")
	ErrInvalidStateTransition = errors.New("agent: invalid state transition")
	ErrPermissionDenied       = errors.New("agent: permission denied for delegated action")
	ErrCapabilityMissing      = errors.New("agent: required platform capability is missing or unsupported")
	ErrBudgetCeilingExceeded  = errors.New("agent: budget ceiling reached; execution paused")
	ErrApprovalRequired       = errors.New("agent: action requires manager approval before execution")
	ErrRunAlreadyFinished     = errors.New("agent: agent run is already in terminal state")
	ErrInvalidBudgetCeiling   = errors.New("agent: budget ceiling must be non-negative decimal")
)

// NewID generates an RFC 4122 v4 UUID using crypto/rand.
func NewID() string {
	var b [16]byte
	if _, err := rand.Read(b[:]); err != nil {
		panic("agent: crypto/rand failed")
	}
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x", b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

// CallerContext represents authenticated caller identity and workspace tenant.
type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string // owner, admin, manager, editor, contributor, member
}

type callerCtxKey struct{}

// WithCallerContext binds a CallerContext into a context.Context.
func WithCallerContext(ctx context.Context, caller CallerContext) context.Context {
	return context.WithValue(ctx, callerCtxKey{}, caller)
}

// CallerFromContext retrieves CallerContext from ctx.
func CallerFromContext(ctx context.Context) (CallerContext, bool) {
	if ctx == nil {
		return CallerContext{}, false
	}
	c, ok := ctx.Value(callerCtxKey{}).(CallerContext)
	return c, ok
}

// AgentRunState constants matching database_schema.md §12.4
const (
	StatePlanning           = "planning"
	StateAwaitingApproval   = "awaiting_approval"
	StateExecuting          = "executing"
	StateWaitingContext     = "waiting_context"
	StateCompleted          = "completed"
	StatePartiallyCompleted = "partially_completed"
	StateFailed             = "failed"
	StateHandedOff          = "handed_off"
	StateCancelled          = "cancelled"
)

// AgentApprovalState constants
const (
	ApprovalNotRequired      = "not_required"
	ApprovalAwaitingApproval = "awaiting_approval"
	ApprovalApproved         = "approved"
	ApprovalRejected         = "rejected"
)

// AgentStepStatus constants matching database_schema.md §12.4A
const (
	StepStatusPlanning         = "planning"
	StepStatusAwaitingApproval = "awaiting_approval"
	StepStatusExecuting        = "executing"
	StepStatusWaitingContext   = "waiting_context"
	StepStatusCompleted        = "completed"
	StepStatusFailed           = "failed"
	StepStatusSkipped          = "skipped"
	StepStatusCancelled        = "cancelled"
)

// AgentOutputType constants matching database_schema.md §12.4B
const (
	OutputTypeText           = "text"
	OutputTypeAsset          = "asset"
	OutputTypeDataset        = "dataset"
	OutputTypeWorkflowPatch  = "workflow_patch"
	OutputTypeRecommendation = "recommendation"
	OutputTypeReport         = "report"
	OutputTypeVideo          = "video"
)

// AgentType constants
const (
	AgentTypeGeneric          = "generic"
	AgentTypeVideoAgent       = "video_agent"       // EF-08 1-click video pipeline
	AgentTypeCopilotAction    = "copilot_action"    // Copilot §5.3 multi-step chain
	AgentTypeContentOptimizer = "content_optimizer" // Autonomous improver
)

// AgentStep represents a discrete step in an agent run.
type AgentStep struct {
	StepID             string
	WorkspaceID        string
	AgentRunID         string
	StepOrder          int
	Phase              string
	Title              string
	Status             string
	ExpectedOutcome    string
	ObservedOutcome    string
	RequiredPermission string
	RequiredCapability string
	IsHighRisk         bool
	EstimatedCredits   string // numeric decimal string (NUMERIC(18,6))
	ActualCredits      string // numeric decimal string (NUMERIC(18,6))
	InputContextJSON   string
	OutputContextJSON  string
	DiagnosticsRef     string
	StartedAt          *time.Time
	CompletedAt        *time.Time
	CreatedAt          time.Time
	UpdatedAt          time.Time
}

// AgentOutput represents an artifact produced by an agent run.
type AgentOutput struct {
	OutputID             string
	WorkspaceID          string
	AgentRunID           string
	OutputType           string
	Title                string
	Summary              string
	ObjectRefsJSON       string
	DownloadableRefsJSON string
	PreviewPayloadJSON   string
	ApprovalState        string
	CreatedAt            time.Time
	UpdatedAt            time.Time
}

// AgentMemoryEntry represents a single observation in ephemeral working memory.
type AgentMemoryEntry struct {
	Key        string
	Value      string
	ByteSize   int
	ObservedAt time.Time
}

// AgentMemory represents bounded session-scoped working memory (RULE-M21-003, EC-M21-003).
type AgentMemory struct {
	TotalBytes   int64
	MaxBytes     int64
	IsCompressed bool
	Entries      []AgentMemoryEntry
	Summary      string
}

// AgentHandoffContext captures audited human escalation context (§28.2).
type AgentHandoffContext struct {
	HandoffTargetUserID    string
	Reason                 string
	SummaryOfCompletedWork string
	UnresolvedActions      []string
	DiagnosticsRef         string
	AuditRef               string
}

// AgentRun represents an autonomous agent execution graph (§12.4).
type AgentRun struct {
	AgentRunID             string
	WorkspaceID            string
	AgentType              string
	RecipeID               string
	WorkflowID             string
	PlanSummary            string
	ExecutionScopeJSON     string
	ApprovalState          string
	CurrentState           string
	SideEffectsSummaryJSON string
	HandoffTargetUserID    string
	HandoffContext         string
	DiagnosticsRef         string
	AuditRef               string
	ContextRefsJSON        string
	CreditsUsed            string // numeric decimal string (NUMERIC(18,6))
	BudgetCeiling          string // numeric decimal string (NUMERIC(18,6))
	MemorySnapshotJSON     string
	Memory                 *BoundedMemory
	Steps                  []AgentStep
	Outputs                []AgentOutput
	CreatedBy              string
	StartedAt              *time.Time
	CompletedAt            *time.Time
	CreatedAt              time.Time
	UpdatedAt              time.Time
}

// DomainEvent represents a domain event emitted per domain_event_catalog.md §11.
type DomainEvent struct {
	EventType   string
	WorkspaceID string
	Payload     map[string]any
	OccurredAt  time.Time
}

// AuditRecord represents an immutable audit log entry per RULE-M21-002.
type AuditRecord struct {
	AuditID        string
	WorkspaceID    string
	ActorUserID    string
	ActorRole      string
	Action         string
	AffectedObject string
	OldState       string
	NewState       string
	CorrelationID  string
	Details        map[string]any
	OccurredAt     time.Time
}

// DiagnosticsRecord represents an audited failure diagnostics record.
type DiagnosticsRecord struct {
	DiagnosticsID       string
	WorkspaceID         string
	AgentRunID          string
	FailedStepID        string
	ErrorCode           string
	RootCause           string
	RecoveryGuidance    string
	HandoffTargetUserID string
	CreatedAt           time.Time
}

// Conversions to / from proto types

func ProtoToAgentType(t automationv1.AgentType) string {
	switch t {
	case automationv1.AgentType_AGENT_TYPE_VIDEO_AGENT:
		return AgentTypeVideoAgent
	case automationv1.AgentType_AGENT_TYPE_COPILOT_ACTION:
		return AgentTypeCopilotAction
	case automationv1.AgentType_AGENT_TYPE_CONTENT_OPTIMIZER:
		return AgentTypeContentOptimizer
	default:
		return AgentTypeGeneric
	}
}

func AgentTypeToProto(t string) automationv1.AgentType {
	switch t {
	case AgentTypeVideoAgent:
		return automationv1.AgentType_AGENT_TYPE_VIDEO_AGENT
	case AgentTypeCopilotAction:
		return automationv1.AgentType_AGENT_TYPE_COPILOT_ACTION
	case AgentTypeContentOptimizer:
		return automationv1.AgentType_AGENT_TYPE_CONTENT_OPTIMIZER
	default:
		return automationv1.AgentType_AGENT_TYPE_GENERIC
	}
}

func StateToProto(s string) automationv1.AgentRunState {
	switch s {
	case StatePlanning:
		return automationv1.AgentRunState_AGENT_RUN_STATE_PLANNING
	case StateAwaitingApproval:
		return automationv1.AgentRunState_AGENT_RUN_STATE_AWAITING_APPROVAL
	case StateExecuting:
		return automationv1.AgentRunState_AGENT_RUN_STATE_EXECUTING
	case StateWaitingContext:
		return automationv1.AgentRunState_AGENT_RUN_STATE_WAITING_CONTEXT
	case StateCompleted:
		return automationv1.AgentRunState_AGENT_RUN_STATE_COMPLETED
	case StatePartiallyCompleted:
		return automationv1.AgentRunState_AGENT_RUN_STATE_PARTIALLY_COMPLETED
	case StateFailed:
		return automationv1.AgentRunState_AGENT_RUN_STATE_FAILED
	case StateHandedOff:
		return automationv1.AgentRunState_AGENT_RUN_STATE_HANDED_OFF
	case StateCancelled:
		return automationv1.AgentRunState_AGENT_RUN_STATE_CANCELLED
	default:
		return automationv1.AgentRunState_AGENT_RUN_STATE_UNSPECIFIED
	}
}

func ApprovalStateToProto(a string) automationv1.AgentApprovalState {
	switch a {
	case ApprovalNotRequired:
		return automationv1.AgentApprovalState_AGENT_APPROVAL_STATE_NOT_REQUIRED
	case ApprovalAwaitingApproval:
		return automationv1.AgentApprovalState_AGENT_APPROVAL_STATE_AWAITING_APPROVAL
	case ApprovalApproved:
		return automationv1.AgentApprovalState_AGENT_APPROVAL_STATE_APPROVED
	case ApprovalRejected:
		return automationv1.AgentApprovalState_AGENT_APPROVAL_STATE_REJECTED
	default:
		return automationv1.AgentApprovalState_AGENT_APPROVAL_STATE_UNSPECIFIED
	}
}

func StepStatusToProto(s string) automationv1.AgentStepStatus {
	switch s {
	case StepStatusPlanning:
		return automationv1.AgentStepStatus_AGENT_STEP_STATUS_PLANNING
	case StepStatusAwaitingApproval:
		return automationv1.AgentStepStatus_AGENT_STEP_STATUS_AWAITING_APPROVAL
	case StepStatusExecuting:
		return automationv1.AgentStepStatus_AGENT_STEP_STATUS_EXECUTING
	case StepStatusWaitingContext:
		return automationv1.AgentStepStatus_AGENT_STEP_STATUS_WAITING_CONTEXT
	case StepStatusCompleted:
		return automationv1.AgentStepStatus_AGENT_STEP_STATUS_COMPLETED
	case StepStatusFailed:
		return automationv1.AgentStepStatus_AGENT_STEP_STATUS_FAILED
	case StepStatusSkipped:
		return automationv1.AgentStepStatus_AGENT_STEP_STATUS_SKIPPED
	case StepStatusCancelled:
		return automationv1.AgentStepStatus_AGENT_STEP_STATUS_CANCELLED
	default:
		return automationv1.AgentStepStatus_AGENT_STEP_STATUS_UNSPECIFIED
	}
}

func OutputTypeToProto(t string) automationv1.AgentOutputType {
	switch t {
	case OutputTypeText:
		return automationv1.AgentOutputType_AGENT_OUTPUT_TYPE_TEXT
	case OutputTypeAsset:
		return automationv1.AgentOutputType_AGENT_OUTPUT_TYPE_ASSET
	case OutputTypeDataset:
		return automationv1.AgentOutputType_AGENT_OUTPUT_TYPE_DATASET
	case OutputTypeWorkflowPatch:
		return automationv1.AgentOutputType_AGENT_OUTPUT_TYPE_WORKFLOW_PATCH
	case OutputTypeRecommendation:
		return automationv1.AgentOutputType_AGENT_OUTPUT_TYPE_RECOMMENDATION
	case OutputTypeReport:
		return automationv1.AgentOutputType_AGENT_OUTPUT_TYPE_REPORT
	case OutputTypeVideo:
		return automationv1.AgentOutputType_AGENT_OUTPUT_TYPE_VIDEO
	default:
		return automationv1.AgentOutputType_AGENT_OUTPUT_TYPE_UNSPECIFIED
	}
}

func StepToProto(s *AgentStep) *automationv1.AgentStep {
	if s == nil {
		return nil
	}
	p := &automationv1.AgentStep{
		StepId:             s.StepID,
		AgentRunId:         s.AgentRunID,
		StepOrder:          int32(s.StepOrder),
		Phase:              s.Phase,
		Title:              s.Title,
		Status:             StepStatusToProto(s.Status),
		ExpectedOutcome:    s.ExpectedOutcome,
		ObservedOutcome:    s.ObservedOutcome,
		RequiredPermission: s.RequiredPermission,
		RequiredCapability: s.RequiredCapability,
		IsHighRisk:         s.IsHighRisk,
		EstimatedCredits:   s.EstimatedCredits,
		ActualCredits:      s.ActualCredits,
		InputContextJson:   s.InputContextJSON,
		OutputContextJson:  s.OutputContextJSON,
		DiagnosticsRef:     s.DiagnosticsRef,
	}
	if s.StartedAt != nil {
		p.StartedAt = timestamppb.New(*s.StartedAt)
	}
	if s.CompletedAt != nil {
		p.CompletedAt = timestamppb.New(*s.CompletedAt)
	}
	return p
}

func OutputToProto(o *AgentOutput) *automationv1.AgentOutput {
	if o == nil {
		return nil
	}
	return &automationv1.AgentOutput{
		OutputId:             o.OutputID,
		AgentRunId:           o.AgentRunID,
		OutputType:           OutputTypeToProto(o.OutputType),
		Title:                o.Title,
		Summary:              o.Summary,
		ObjectRefsJson:       o.ObjectRefsJSON,
		DownloadableRefsJson: o.DownloadableRefsJSON,
		PreviewPayloadJson:   o.PreviewPayloadJSON,
		ApprovalState:        o.ApprovalState,
		CreatedAt:            timestamppb.New(o.CreatedAt),
	}
}

func MemoryToProto(m *AgentMemory) *automationv1.AgentMemory {
	if m == nil {
		return nil
	}
	p := &automationv1.AgentMemory{
		TotalBytes:   m.TotalBytes,
		MaxBytes:     m.MaxBytes,
		IsCompressed: m.IsCompressed,
		Summary:      m.Summary,
	}
	for _, e := range m.Entries {
		p.Entries = append(p.Entries, &automationv1.AgentMemoryEntry{
			Key:        e.Key,
			Value:      e.Value,
			ByteSize:   int32(e.ByteSize),
			ObservedAt: timestamppb.New(e.ObservedAt),
		})
	}
	return p
}

func RunToProto(r *AgentRun) *automationv1.AgentRun {
	if r == nil {
		return nil
	}
	p := &automationv1.AgentRun{
		AgentRunId:             r.AgentRunID,
		WorkspaceId:            r.WorkspaceID,
		AgentType:              AgentTypeToProto(r.AgentType),
		RecipeId:               r.RecipeID,
		WorkflowId:             r.WorkflowID,
		PlanSummary:            r.PlanSummary,
		ExecutionScopeJson:     r.ExecutionScopeJSON,
		ApprovalState:          ApprovalStateToProto(r.ApprovalState),
		CurrentState:           StateToProto(r.CurrentState),
		SideEffectsSummaryJson: r.SideEffectsSummaryJSON,
		DiagnosticsRef:         r.DiagnosticsRef,
		AuditRef:               r.AuditRef,
		CreditsUsed:            r.CreditsUsed,
		BudgetCeiling:          r.BudgetCeiling,
		CreatedBy:              r.CreatedBy,
		CreatedAt:              timestamppb.New(r.CreatedAt),
		UpdatedAt:              timestamppb.New(r.UpdatedAt),
	}
	if r.Memory != nil {
		p.Memory = MemoryToProto(r.Memory.Snapshot())
	}
	if r.StartedAt != nil {
		p.StartedAt = timestamppb.New(*r.StartedAt)
	}
	if r.CompletedAt != nil {
		p.CompletedAt = timestamppb.New(*r.CompletedAt)
	}
	if r.HandoffTargetUserID != "" || r.HandoffContext != "" {
		p.HandoffContext = &automationv1.AgentHandoffContext{
			HandoffTargetUserId: r.HandoffTargetUserID,
			Reason:              r.HandoffContext,
			DiagnosticsRef:      r.DiagnosticsRef,
			AuditRef:            r.AuditRef,
		}
	}
	for i := range r.Steps {
		p.Steps = append(p.Steps, StepToProto(&r.Steps[i]))
	}
	for i := range r.Outputs {
		p.Outputs = append(p.Outputs, OutputToProto(&r.Outputs[i]))
	}
	return p
}
