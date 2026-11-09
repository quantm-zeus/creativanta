package agent

import (
	"context"
	"fmt"
	"strings"
	"sync"
	"time"
)

// StepLeaseStore provides atomic step lease claims, fencing token enforcement, and serialized run mutations (N4).
type StepLeaseStore interface {
	MutateRunAtomically(ctx context.Context, workspaceID, runID string, fn func(run *AgentRun) error) (*AgentRun, error)
	ClaimStepForExecution(ctx context.Context, workspaceID, runID, ownerID string, leaseTTL time.Duration) (runSnap *AgentRun, stepIndex int, claimed bool, allDone bool, err error)
}

// WorkspaceMembershipStore provides authoritative live membership resolution for a workspace member.
type WorkspaceMembershipStore interface {
	ResolveWorkspaceMemberRole(ctx context.Context, workspaceID, userID string) (role string, active bool, found bool, err error)
}

// WorkspaceMembershipMutator allows tests and administrative reconciliation to update workspace membership in a store.
type WorkspaceMembershipMutator interface {
	SetMemberRole(workspaceID, userID, role string, active bool)
	RevokeMemberAccess(workspaceID, userID string)
}

// Store defines persistence operations for agent runs, steps, outputs, and audit records.
type Store interface {
	CreateRun(ctx context.Context, run *AgentRun) error
	GetRun(ctx context.Context, workspaceID, runID string) (*AgentRun, error)
	ListRuns(ctx context.Context, workspaceID string, agentType string, stateFilter string, limit int, offset int) ([]AgentRun, int, error)
	UpdateRun(ctx context.Context, run *AgentRun) error
	CreateOutput(ctx context.Context, output AgentOutput) error
	AddDiagnostics(ctx context.Context, record DiagnosticsRecord) error
	AddAuditRecord(ctx context.Context, record AuditRecord) error
	PublishEvent(ctx context.Context, event DomainEvent)
	GetAuditRecords(ctx context.Context, workspaceID string, runID string) []AuditRecord
	GetDiagnostics(ctx context.Context, workspaceID string, runID string) []DiagnosticsRecord
	GetEvents() []DomainEvent
}

// MemStore is a thread-safe, tenant-isolated in-memory store for AgentService.
type MemStore struct {
	mu          sync.RWMutex
	runs        map[string]*AgentRun           // runID -> AgentRun
	outputs     map[string][]AgentOutput       // runID -> []AgentOutput
	diagnostics map[string][]DiagnosticsRecord // runID -> []DiagnosticsRecord
	audits      map[string][]AuditRecord       // runID -> []AuditRecord
	events      []DomainEvent
	members     map[string]agentMemberState // workspaceID:userID -> agentMemberState
}

func NewMemStore() *MemStore {
	return &MemStore{
		runs:        make(map[string]*AgentRun),
		outputs:     make(map[string][]AgentOutput),
		diagnostics: make(map[string][]DiagnosticsRecord),
		audits:      make(map[string][]AuditRecord),
		events:      make([]DomainEvent, 0),
		members:     make(map[string]agentMemberState),
	}
}

var _ Store = (*MemStore)(nil)
var _ WorkspaceMembershipStore = (*MemStore)(nil)
var _ WorkspaceMembershipMutator = (*MemStore)(nil)
var _ StepLeaseStore = (*MemStore)(nil)

func (s *MemStore) SetMemberRole(workspaceID, userID, role string, active bool) {
	ws := strings.TrimSpace(workspaceID)
	uid := strings.TrimSpace(userID)
	if ws == "" || uid == "" {
		return
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.members == nil {
		s.members = make(map[string]agentMemberState)
	}
	s.members[ws+":"+uid] = agentMemberState{
		role:   strings.TrimSpace(role),
		active: active,
	}
}

func (s *MemStore) RevokeMemberAccess(workspaceID, userID string) {
	s.SetMemberRole(workspaceID, userID, "", false)
}

func (s *MemStore) ResolveWorkspaceMemberRole(ctx context.Context, workspaceID, userID string) (string, bool, bool, error) {
	ws := strings.TrimSpace(workspaceID)
	uid := strings.TrimSpace(userID)
	if ws == "" || uid == "" {
		return "", false, false, nil
	}
	s.mu.RLock()
	defer s.mu.RUnlock()
	st, ok := s.members[ws+":"+uid]
	if !ok {
		return "", false, false, nil
	}
	return st.role, st.active, true, nil
}

func (s *MemStore) CreateRun(ctx context.Context, run *AgentRun) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if run.AgentRunID == "" {
		run.AgentRunID = NewID()
	}
	now := time.Now().UTC()
	run.CreatedAt = now
	run.UpdatedAt = now

	// Clone run to prevent external mutation
	cloned := cloneRun(run)
	s.runs[run.AgentRunID] = cloned
	return nil
}

func (s *MemStore) GetRun(ctx context.Context, workspaceID, runID string) (*AgentRun, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	run, ok := s.runs[runID]
	if !ok {
		return nil, ErrRunNotFound
	}
	if run.WorkspaceID != workspaceID {
		return nil, ErrCrossTenantDenied
	}
	return cloneRun(run), nil
}

func (s *MemStore) ListRuns(ctx context.Context, workspaceID string, agentType string, stateFilter string, limit int, offset int) ([]AgentRun, int, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matched []AgentRun
	for _, run := range s.runs {
		if run.WorkspaceID != workspaceID {
			continue
		}
		if agentType != "" && run.AgentType != agentType {
			continue
		}
		if stateFilter != "" && run.CurrentState != stateFilter {
			continue
		}
		matched = append(matched, *cloneRun(run))
	}

	total := len(matched)
	if offset >= total {
		return []AgentRun{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > total {
		end = total
	}
	return matched[offset:end], total, nil
}

func (s *MemStore) UpdateRun(ctx context.Context, run *AgentRun) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	existing, ok := s.runs[run.AgentRunID]
	if !ok {
		return ErrRunNotFound
	}
	if existing.WorkspaceID != run.WorkspaceID {
		return ErrCrossTenantDenied
	}
	run.UpdatedAt = time.Now().UTC()
	s.runs[run.AgentRunID] = cloneRun(run)
	return nil
}

func (s *MemStore) MutateRunAtomically(ctx context.Context, workspaceID, runID string, fn func(run *AgentRun) error) (*AgentRun, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	existing, ok := s.runs[runID]
	if !ok {
		return nil, ErrRunNotFound
	}
	if existing.WorkspaceID != workspaceID {
		return nil, ErrCrossTenantDenied
	}
	work := cloneRun(existing)
	if err := fn(work); err != nil {
		return cloneRun(existing), err
	}
	work.UpdatedAt = time.Now().UTC()
	s.runs[runID] = work
	return cloneRun(work), nil
}

func (s *MemStore) ClaimStepForExecution(
	ctx context.Context,
	workspaceID, runID, ownerID string,
	leaseTTL time.Duration,
) (*AgentRun, int, bool, bool, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	run, ok := s.runs[runID]
	if !ok {
		return nil, -1, false, false, ErrRunNotFound
	}
	if run.WorkspaceID != workspaceID {
		return nil, -1, false, false, ErrCrossTenantDenied
	}
	if run.CurrentState != StateExecuting {
		return cloneRun(run), -1, false, false, fmt.Errorf("%w: run is in state %q, cannot execute", ErrInvalidStateTransition, run.CurrentState)
	}

	now := time.Now().UTC()
	if leaseTTL <= 0 {
		leaseTTL = 5 * time.Minute
	}

	// Reject concurrent claim if any step currently holds an active lease owned by another worker.
	for i := range run.Steps {
		st := &run.Steps[i]
		if st.Status == StepStatusExecuting && st.LeaseExpiresAt != nil && now.Before(*st.LeaseExpiresAt) && st.ExecutionOwner != "" && st.ExecutionOwner != ownerID {
			return cloneRun(run), i, false, false, ErrStepAlreadyClaimed
		}
	}

	targetIdx := -1
	for i := range run.Steps {
		st := &run.Steps[i]
		if st.Status == StepStatusPlanning {
			targetIdx = i
			break
		}
		if st.Status == StepStatusExecuting {
			leaseExpired := st.LeaseExpiresAt == nil || !now.Before(*st.LeaseExpiresAt) || st.ExecutionOwner == ownerID
			notYetCompleted := st.CompletedAt == nil && strings.TrimSpace(st.ActualCredits) == ""
			if leaseExpired && notYetCompleted {
				targetIdx = i
				break
			}
			return cloneRun(run), i, false, false, ErrStepAlreadyClaimed
		}
	}

	if targetIdx < 0 {
		allCompleted := true
		for i := range run.Steps {
			if run.Steps[i].Status != StepStatusCompleted {
				allCompleted = false
				break
			}
		}
		if allCompleted {
			return cloneRun(run), -1, false, true, nil
		}
		return cloneRun(run), -1, false, false, ErrStepAlreadyClaimed
	}

	exp := now.Add(leaseTTL)
	st := &run.Steps[targetIdx]
	st.FencingToken++
	st.ExecutionOwner = ownerID
	st.LeaseExpiresAt = &exp
	if strings.TrimSpace(st.OperationKey) == "" {
		st.OperationKey = fmt.Sprintf("agent_run:%s:step:%d", run.AgentRunID, st.StepOrder)
	}
	st.StartedAt = &now
	st.Status = StepStatusExecuting
	st.UpdatedAt = now
	run.UpdatedAt = now

	return cloneRun(run), targetIdx, true, false, nil
}

func (s *MemStore) CreateOutput(ctx context.Context, output AgentOutput) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	s.outputs[output.AgentRunID] = append(s.outputs[output.AgentRunID], output)
	return nil
}

func (s *MemStore) AddDiagnostics(ctx context.Context, record DiagnosticsRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	s.diagnostics[record.AgentRunID] = append(s.diagnostics[record.AgentRunID], record)
	return nil
}

func (s *MemStore) AddAuditRecord(ctx context.Context, record AuditRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	s.audits[record.CorrelationID] = append(s.audits[record.CorrelationID], record)
	return nil
}

func (s *MemStore) PublishEvent(ctx context.Context, event DomainEvent) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.events = append(s.events, event)
}

func (s *MemStore) GetAuditRecords(ctx context.Context, workspaceID string, runID string) []AuditRecord {
	s.mu.RLock()
	defer s.mu.RUnlock()

	records := s.audits[runID]
	var res []AuditRecord
	for _, r := range records {
		if r.WorkspaceID == workspaceID {
			res = append(res, r)
		}
	}
	return res
}

func (s *MemStore) GetDiagnostics(ctx context.Context, workspaceID string, runID string) []DiagnosticsRecord {
	s.mu.RLock()
	defer s.mu.RUnlock()

	records := s.diagnostics[runID]
	var res []DiagnosticsRecord
	for _, r := range records {
		if r.WorkspaceID == workspaceID {
			res = append(res, r)
		}
	}
	return res
}

func (s *MemStore) GetEvents() []DomainEvent {
	s.mu.RLock()
	defer s.mu.RUnlock()

	cp := make([]DomainEvent, len(s.events))
	copy(cp, s.events)
	return cp
}

func cloneRun(r *AgentRun) *AgentRun {
	if r == nil {
		return nil
	}
	cp := *r
	if len(r.Steps) > 0 {
		cp.Steps = make([]AgentStep, len(r.Steps))
		copy(cp.Steps, r.Steps)
		for i := range cp.Steps {
			if r.Steps[i].LeaseExpiresAt != nil {
				t := *r.Steps[i].LeaseExpiresAt
				cp.Steps[i].LeaseExpiresAt = &t
			}
			if r.Steps[i].StartedAt != nil {
				t := *r.Steps[i].StartedAt
				cp.Steps[i].StartedAt = &t
			}
			if r.Steps[i].CompletedAt != nil {
				t := *r.Steps[i].CompletedAt
				cp.Steps[i].CompletedAt = &t
			}
		}
	}
	if len(r.Outputs) > 0 {
		cp.Outputs = make([]AgentOutput, len(r.Outputs))
		copy(cp.Outputs, r.Outputs)
	}
	if r.Memory != nil {
		cp.Memory = NewBoundedMemory(r.Memory.maxBytes)
		snap := r.Memory.Snapshot()
		for _, e := range snap.Entries {
			_ = cp.Memory.AddObservation(e.Key, e.Value)
		}
	}
	return &cp
}
