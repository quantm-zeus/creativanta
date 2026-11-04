package agent

import (
	"context"
	"sync"
	"time"
)

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
}

func NewMemStore() *MemStore {
	return &MemStore{
		runs:        make(map[string]*AgentRun),
		outputs:     make(map[string][]AgentOutput),
		diagnostics: make(map[string][]DiagnosticsRecord),
		audits:      make(map[string][]AuditRecord),
		events:      make([]DomainEvent, 0),
	}
}

var _ Store = (*MemStore)(nil)

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
