package outbox

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// ExternalEffectStatus enumerates the canonical 6 states in external_effects (§26.8).
type ExternalEffectStatus string

const (
	EffectStatusPrepared  ExternalEffectStatus = "prepared"
	EffectStatusSubmitted ExternalEffectStatus = "submitted"
	EffectStatusSucceeded ExternalEffectStatus = "succeeded"
	EffectStatusFailed    ExternalEffectStatus = "failed"
	EffectStatusUnknown   ExternalEffectStatus = "unknown"
	EffectStatusCancelled ExternalEffectStatus = "cancelled"
)

// ExecutionDecision indicates whether an external side effect may proceed.
type ExecutionDecision string

const (
	DecisionProceed                        ExecutionDecision = "proceed"
	DecisionAlreadySucceeded               ExecutionDecision = "already_succeeded"
	DecisionBlockedRequiresReconciliation  ExecutionDecision = "blocked_requires_reconciliation"
	DecisionBlockedTerminalFailureOrCancel ExecutionDecision = "blocked_terminal_failure_or_cancel"
)

var (
	// ErrExternalOutcomeUnresolved is returned whenever a worker or caller attempts to blindly retry
	// an operation whose external_effects row is in 'unknown' or 'submitted' state.
	ErrExternalOutcomeUnresolved = errors.New("outbox: external effect outcome is unresolved (unknown/submitted); blind retry is forbidden until reconciled")
	// ErrExternalEffectCancelled is returned when an external effect was explicitly cancelled.
	ErrExternalEffectCancelled = errors.New("outbox: external effect was cancelled")
	// ErrReconciliationProofRequired is returned when attempting to reconcile an unknown effect without provider proof or manual verification reference.
	ErrReconciliationProofRequired = errors.New("outbox: reconciling an unknown external effect requires provider status proof or manual verification reference")
)

// ExternalEffectRecord represents a tracked external side effect.
type ExternalEffectRecord struct {
	EffectID           string               `json:"effect_id"`
	WorkspaceID        string               `json:"workspace_id"`
	OperationKey       string               `json:"operation_key"`
	Provider           string               `json:"provider"`
	ConnectedAccountID string               `json:"connected_account_id,omitempty"`
	AggregateType      string               `json:"aggregate_type"`
	AggregateID        string               `json:"aggregate_id"`
	ProviderRequestID  string               `json:"provider_request_id,omitempty"`
	Status             ExternalEffectStatus `json:"status"`
	ResultPayload      json.RawMessage      `json:"result_payload,omitempty"`
	LastCheckedAt      *time.Time           `json:"last_checked_at,omitempty"`
	CreatedAt          time.Time            `json:"created_at"`
	UpdatedAt          time.Time            `json:"updated_at"`
}

// BeginEffectRequest contains the identity of an external side-effect operation.
type BeginEffectRequest struct {
	EffectID           string
	WorkspaceID        string
	OperationKey       string
	Provider           string
	ConnectedAccountID string
	AggregateType      string
	AggregateID        string
	Now                time.Time
}

// ReconcileMode specifies how an unknown external effect was verified.
type ReconcileMode string

const (
	ReconcileConfirmedSucceeded   ReconcileMode = "confirmed_succeeded"
	ReconcileConfirmedNotExecuted ReconcileMode = "confirmed_not_executed"
	ReconcileManualCancel         ReconcileMode = "manual_cancel"
)

// ReconcileRequest defines parameters for resolving an 'unknown' external effect.
type ReconcileRequest struct {
	WorkspaceID           string
	OperationKey          string
	ActorID               string
	Mode                  ReconcileMode
	ProviderRequestID     string
	VerificationReference string
	ResultPayload         json.RawMessage
	Now                   time.Time
}

// ExternalEffectGuard coordinates external_effects state transitions and guarantees
// that unresolved ('unknown' or 'submitted') outcomes are NEVER blindly retried.
type ExternalEffectGuard struct {
	mu          sync.Mutex
	effects     map[string]*ExternalEffectRecord
	diagnostics map[string]*tenantdb.DiagnosticRecordRow
	audits      []AuditLogEntry
}

// NewExternalEffectGuard creates an in-memory ExternalEffectGuard (see PgExternalEffectGuard for PostgreSQL).
func NewExternalEffectGuard() *ExternalEffectGuard {
	return &ExternalEffectGuard{
		effects:     make(map[string]*ExternalEffectRecord),
		diagnostics: make(map[string]*tenantdb.DiagnosticRecordRow),
	}
}

func effectMapKey(workspaceID, operationKey string) string {
	return workspaceID + "::" + operationKey
}

// BeginExecution checks the current state of (workspace_id, operation_key) before calling an external provider:
// - Not found: inserts 'prepared' and returns DecisionProceed
// - 'succeeded': returns DecisionAlreadySucceeded with cached ResultPayload (zero duplicate call)
// - 'unknown' or 'submitted': returns DecisionBlockedRequiresReconciliation and ErrExternalOutcomeUnresolved
// - 'cancelled': returns DecisionBlockedTerminalFailureOrCancel and ErrExternalEffectCancelled
// - 'prepared' or 'failed': returns DecisionProceed.
func (g *ExternalEffectGuard) BeginExecution(_ context.Context, req BeginEffectRequest) (ExecutionDecision, ExternalEffectRecord, error) {
	if !tenantdb.IsValidNonZeroUUID(req.WorkspaceID) || !tenantdb.IsValidNonZeroUUID(req.AggregateID) {
		return "", ExternalEffectRecord{}, tenantdb.ErrInvalidTenantScope
	}
	if strings.TrimSpace(req.OperationKey) == "" || strings.TrimSpace(req.Provider) == "" {
		return "", ExternalEffectRecord{}, errors.New("outbox: operation_key and provider are required")
	}
	now := req.Now
	if now.IsZero() {
		now = time.Now().UTC()
	}

	g.mu.Lock()
	defer g.mu.Unlock()

	k := effectMapKey(req.WorkspaceID, req.OperationKey)
	existing, ok := g.effects[k]
	if !ok {
		effID := req.EffectID
		if !tenantdb.IsValidNonZeroUUID(effID) {
			effID = req.AggregateID
		}
		rec := &ExternalEffectRecord{
			EffectID:           effID,
			WorkspaceID:        req.WorkspaceID,
			OperationKey:       req.OperationKey,
			Provider:           req.Provider,
			ConnectedAccountID: req.ConnectedAccountID,
			AggregateType:      req.AggregateType,
			AggregateID:        req.AggregateID,
			Status:             EffectStatusPrepared,
			ResultPayload:      json.RawMessage(`{}`),
			CreatedAt:          now,
			UpdatedAt:          now,
		}
		g.effects[k] = rec
		return DecisionProceed, *rec, nil
	}

	switch existing.Status {
	case EffectStatusSucceeded:
		return DecisionAlreadySucceeded, *existing, nil
	case EffectStatusUnknown, EffectStatusSubmitted:
		return DecisionBlockedRequiresReconciliation, *existing, fmt.Errorf(
			"%w: workspace=%s operation_key=%s status=%s",
			ErrExternalOutcomeUnresolved, req.WorkspaceID, req.OperationKey, existing.Status,
		)
	case EffectStatusCancelled:
		return DecisionBlockedTerminalFailureOrCancel, *existing, ErrExternalEffectCancelled
	case EffectStatusPrepared, EffectStatusFailed:
		existing.Status = EffectStatusPrepared
		existing.UpdatedAt = now
		return DecisionProceed, *existing, nil
	default:
		return DecisionBlockedRequiresReconciliation, *existing, ErrExternalOutcomeUnresolved
	}
}

// MarkSubmitted records that the outbound provider request has left the process ('prepared' -> 'submitted').
// If the worker crashes or times out after this point, the effect CANNOT be blindly retried.
func (g *ExternalEffectGuard) MarkSubmitted(_ context.Context, workspaceID, operationKey, providerRequestID string, now time.Time) (ExternalEffectRecord, error) {
	g.mu.Lock()
	defer g.mu.Unlock()

	k := effectMapKey(workspaceID, operationKey)
	rec, ok := g.effects[k]
	if !ok {
		return ExternalEffectRecord{}, fmt.Errorf("outbox: external effect %q not found", operationKey)
	}
	if rec.Status == EffectStatusSucceeded {
		return *rec, nil
	}
	rec.Status = EffectStatusSubmitted
	if providerRequestID != "" {
		rec.ProviderRequestID = providerRequestID
	}
	ts := now
	rec.LastCheckedAt = &ts
	rec.UpdatedAt = now
	return *rec, nil
}

// MarkUnknownOnTimeout transitions an in-flight effect to 'unknown' when a provider call times out
// or returns an ambiguous transport error, and creates a user-facing M23 diagnostic record.
func (g *ExternalEffectGuard) MarkUnknownOnTimeout(
	_ context.Context,
	workspaceID, operationKey, diagnosticsID string,
	providerErr string,
	now time.Time,
) (ExternalEffectRecord, tenantdb.DiagnosticRecordRow, error) {
	g.mu.Lock()
	defer g.mu.Unlock()

	k := effectMapKey(workspaceID, operationKey)
	rec, ok := g.effects[k]
	if !ok {
		return ExternalEffectRecord{}, tenantdb.DiagnosticRecordRow{}, fmt.Errorf("outbox: external effect %q not found", operationKey)
	}
	rec.Status = EffectStatusUnknown
	ts := now
	rec.LastCheckedAt = &ts
	rec.UpdatedAt = now

	diag := &tenantdb.DiagnosticRecordRow{
		DiagnosticsID: diagnosticsID,
		WorkspaceID:   workspaceID,
		ScopeType:     rec.AggregateType,
		ScopeID:       rec.AggregateID,
		ErrorType:     "external_effect_outcome_unknown",
		Severity:      "warning",
		UserFacingExplanation: fmt.Sprintf(
			"Phản hồi từ nền tảng %s bị gián đoạn trước khi xác nhận hoàn tất. Hệ thống đã tạm khóa tự động gửi lại để tránh trùng lặp tác vụ.",
			rec.Provider,
		),
		OperatorExplanation: fmt.Sprintf("operation_key=%s provider=%s timeout/ambiguous: %s", operationKey, rec.Provider, providerErr),
		LikelyCauses: []string{
			"Kết nối mạng tới nền tảng đối tác phản hồi chậm hoặc hết thời gian chờ (timeout).",
			"Nền tảng đối tác đang xử lý yêu cầu nhưng chưa trả về mã xác nhận.",
		},
		SuggestedActions: []string{
			"Kiểm tra trạng thái thực tế trên nền tảng đối tác hoặc chạy bước xác minh trong Trình sửa lỗi 4 bước.",
			"Chỉ thực hiện gửi lại sau khi đã xác nhận tác vụ chưa được tạo trên nền tảng đối tác.",
		},
		RepairPath: "reconcile_external_effect:" + operationKey,
		Status:     "open",
		DetectedAt: now,
		CreatedAt:  now,
		UpdatedAt:  now,
	}
	g.diagnostics[k] = diag
	return *rec, *diag, nil
}

// RecordSucceeded marks an external effect as definitively 'succeeded' with its result payload.
func (g *ExternalEffectGuard) RecordSucceeded(_ context.Context, workspaceID, operationKey, providerRequestID string, resultPayload json.RawMessage, now time.Time) (ExternalEffectRecord, error) {
	g.mu.Lock()
	defer g.mu.Unlock()

	k := effectMapKey(workspaceID, operationKey)
	rec, ok := g.effects[k]
	if !ok {
		return ExternalEffectRecord{}, fmt.Errorf("outbox: external effect %q not found", operationKey)
	}
	rec.Status = EffectStatusSucceeded
	if providerRequestID != "" {
		rec.ProviderRequestID = providerRequestID
	}
	if len(resultPayload) > 0 {
		rec.ResultPayload = append(json.RawMessage(nil), resultPayload...)
	}
	ts := now
	rec.LastCheckedAt = &ts
	rec.UpdatedAt = now
	return *rec, nil
}

// RecordDefinitiveFailure marks an external effect as 'failed' ONLY when the provider definitively rejected the request before execution.
func (g *ExternalEffectGuard) RecordDefinitiveFailure(_ context.Context, workspaceID, operationKey string, resultPayload json.RawMessage, now time.Time) (ExternalEffectRecord, error) {
	g.mu.Lock()
	defer g.mu.Unlock()

	k := effectMapKey(workspaceID, operationKey)
	rec, ok := g.effects[k]
	if !ok {
		return ExternalEffectRecord{}, fmt.Errorf("outbox: external effect %q not found", operationKey)
	}
	rec.Status = EffectStatusFailed
	if len(resultPayload) > 0 {
		rec.ResultPayload = append(json.RawMessage(nil), resultPayload...)
	}
	ts := now
	rec.LastCheckedAt = &ts
	rec.UpdatedAt = now
	return *rec, nil
}

// ReconcileUnknownEffect resolves an 'unknown' or 'submitted' external effect after provider status verification or manual operator confirmation.
func (g *ExternalEffectGuard) ReconcileUnknownEffect(_ context.Context, req ReconcileRequest) (ExternalEffectRecord, error) {
	if strings.TrimSpace(req.VerificationReference) == "" && strings.TrimSpace(req.ProviderRequestID) == "" {
		return ExternalEffectRecord{}, ErrReconciliationProofRequired
	}
	now := req.Now
	if now.IsZero() {
		now = time.Now().UTC()
	}

	g.mu.Lock()
	defer g.mu.Unlock()

	k := effectMapKey(req.WorkspaceID, req.OperationKey)
	rec, ok := g.effects[k]
	if !ok {
		return ExternalEffectRecord{}, fmt.Errorf("outbox: external effect %q not found", req.OperationKey)
	}
	if rec.Status != EffectStatusUnknown && rec.Status != EffectStatusSubmitted {
		return *rec, nil
	}

	switch req.Mode {
	case ReconcileConfirmedSucceeded:
		rec.Status = EffectStatusSucceeded
		if req.ProviderRequestID != "" {
			rec.ProviderRequestID = req.ProviderRequestID
		}
		if len(req.ResultPayload) > 0 {
			rec.ResultPayload = append(json.RawMessage(nil), req.ResultPayload...)
		}
	case ReconcileConfirmedNotExecuted:
		// Confirmed that the provider never executed the effect -> safe to transition to 'failed' so a controlled retry can prepare it cleanly.
		rec.Status = EffectStatusFailed
	case ReconcileManualCancel:
		rec.Status = EffectStatusCancelled
	default:
		return ExternalEffectRecord{}, fmt.Errorf("outbox: unsupported reconcile mode %q", req.Mode)
	}

	ts := now
	rec.LastCheckedAt = &ts
	rec.UpdatedAt = now

	if diag, exists := g.diagnostics[k]; exists {
		diag.Status = "resolved"
		diag.ResolvedAt = &ts
		diag.UpdatedAt = now
	}

	g.audits = append(g.audits, AuditLogEntry{
		AuditEventID: req.OperationKey,
		WorkspaceID:  req.WorkspaceID,
		ActorID:      req.ActorID,
		ActorType:    nonEmpty(req.ActorID, "system"),
		Action:       "external_effect.reconciled:" + string(req.Mode),
		ResourceType: rec.AggregateType,
		ResourceID:   rec.AggregateID,
		Reason:       nonEmpty(req.VerificationReference, req.ProviderRequestID),
		CreatedAt:    now,
	})
	return *rec, nil
}

// GetRecord returns the current ExternalEffectRecord for (workspaceID, operationKey).
func (g *ExternalEffectGuard) GetRecord(workspaceID, operationKey string) (ExternalEffectRecord, bool) {
	g.mu.Lock()
	defer g.mu.Unlock()
	rec, ok := g.effects[effectMapKey(workspaceID, operationKey)]
	if !ok {
		return ExternalEffectRecord{}, false
	}
	return *rec, true
}

// CountUnknownEffects returns the number of unresolved ('unknown' or 'submitted') effects in a workspace.
func (g *ExternalEffectGuard) CountUnknownEffects(workspaceID string) int {
	g.mu.Lock()
	defer g.mu.Unlock()
	count := 0
	for _, rec := range g.effects {
		if rec.WorkspaceID == workspaceID && (rec.Status == EffectStatusUnknown || rec.Status == EffectStatusSubmitted) {
			count++
		}
	}
	return count
}
