package livecommerce

import (
	"context"
	"fmt"
	"strings"
	"sync"
	"time"
)

// Store defines tenant-isolated persistence interface for M17 Live Commerce War Room.
type Store interface {
	CreateSession(ctx context.Context, s *LiveSession) error
	GetSession(ctx context.Context, workspaceID, sessionID string) (*LiveSession, error)
	UpdateSession(ctx context.Context, s *LiveSession) error
	ListSessions(ctx context.Context, workspaceID, status, platform string, limit, offset int) ([]*LiveSession, int64, error)

	AddCueCard(ctx context.Context, c *CueCard) error
	GetCueCard(ctx context.Context, workspaceID, cueCardID string) (*CueCard, error)
	ListCueCards(ctx context.Context, workspaceID, sessionID string) ([]*CueCard, error)
	UpdateCueCard(ctx context.Context, c *CueCard) error
	RemoveCueCard(ctx context.Context, workspaceID, sessionID, cueCardID string) error

	CreateHighlight(ctx context.Context, h *Highlight) error
	GetHighlight(ctx context.Context, workspaceID, highlightID string) (*Highlight, error)
	ListHighlights(ctx context.Context, workspaceID, sessionID string) ([]*Highlight, error)
	UpdateHighlight(ctx context.Context, h *Highlight) error

	SaveProofSummary(ctx context.Context, summary *PostLiveProofSummary) error
	GetProofSummary(ctx context.Context, workspaceID, sessionID string) (*PostLiveProofSummary, error)

	// Idempotency across reconnects (Acceptance Target 1)
	GetCommand(ctx context.Context, workspaceID, idempotencyKey string) (*CommandExecutionRecord, bool)
	RecordCommand(ctx context.Context, rec *CommandExecutionRecord) error
	CheckOrRecordCommand(ctx context.Context, workspaceID, sessionID, idempotencyKey, commandType string, responseJSON []byte) (*CommandExecutionRecord, bool, error)

	// Traceable revenue orders (Acceptance Target 3)
	AttachOrder(ctx context.Context, workspaceID, sessionID string, order TraceableOrderLink) error
	ListOrdersForSession(ctx context.Context, workspaceID, sessionID string) ([]TraceableOrderLink, error)
}

// MemoryStore provides a thread-safe, strictly tenant-isolated in-memory store.
type MemoryStore struct {
	mu         sync.RWMutex
	sessions   map[string]*LiveSession            // key: workspaceID + ":" + sessionID
	cueCards   map[string]*CueCard                // key: workspaceID + ":" + cueCardID
	highlights map[string]*Highlight              // key: workspaceID + ":" + highlightID
	proofs     map[string]*PostLiveProofSummary   // key: workspaceID + ":" + sessionID
	commands   map[string]*CommandExecutionRecord // key: workspaceID + ":" + idempotencyKey
	orders     map[string][]TraceableOrderLink    // key: workspaceID + ":" + sessionID
}

// NewMemoryStore constructs a fresh MemoryStore.
func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		sessions:   make(map[string]*LiveSession),
		cueCards:   make(map[string]*CueCard),
		highlights: make(map[string]*Highlight),
		proofs:     make(map[string]*PostLiveProofSummary),
		commands:   make(map[string]*CommandExecutionRecord),
		orders:     make(map[string][]TraceableOrderLink),
	}
}

func sessionKey(workspaceID, sessionID string) string {
	return workspaceID + ":" + sessionID
}

func cueKey(workspaceID, cueID string) string {
	return workspaceID + ":" + cueID
}

func highlightKey(workspaceID, hlID string) string {
	return workspaceID + ":" + hlID
}

func (s *MemoryStore) CreateSession(ctx context.Context, ls *LiveSession) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	k := sessionKey(ls.WorkspaceID, ls.SessionID)
	if _, exists := s.sessions[k]; exists {
		return fmt.Errorf("livecommerce: session %s already exists in workspace %s", ls.SessionID, ls.WorkspaceID)
	}

	clone := *ls
	s.sessions[k] = &clone
	return nil
}

func (s *MemoryStore) GetSession(ctx context.Context, workspaceID, sessionID string) (*LiveSession, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ls, ok := s.sessions[sessionKey(workspaceID, sessionID)]
	if !ok || ls.DeletedAt != nil {
		return nil, ErrSessionNotFound
	}
	clone := *ls
	return &clone, nil
}

func (s *MemoryStore) UpdateSession(ctx context.Context, ls *LiveSession) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	k := sessionKey(ls.WorkspaceID, ls.SessionID)
	existing, ok := s.sessions[k]
	if !ok || existing.DeletedAt != nil {
		return ErrSessionNotFound
	}

	ls.UpdatedAt = time.Now().UTC()
	clone := *ls
	s.sessions[k] = &clone
	return nil
}

func (s *MemoryStore) ListSessions(ctx context.Context, workspaceID, status, platform string, limit, offset int) ([]*LiveSession, int64, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matching []*LiveSession
	for _, ls := range s.sessions {
		if ls.WorkspaceID != workspaceID || ls.DeletedAt != nil {
			continue
		}
		if status != "" && string(ls.Status) != status {
			continue
		}
		if platform != "" && !strings.EqualFold(ls.Platform, platform) {
			continue
		}
		clone := *ls
		matching = append(matching, &clone)
	}

	total := int64(len(matching))
	if offset >= len(matching) {
		return []*LiveSession{}, total, nil
	}

	end := offset + limit
	if limit <= 0 || end > len(matching) {
		end = len(matching)
	}

	return matching[offset:end], total, nil
}

func (s *MemoryStore) AddCueCard(ctx context.Context, c *CueCard) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	k := cueKey(c.WorkspaceID, c.CueCardID)
	clone := *c
	s.cueCards[k] = &clone
	return nil
}

func (s *MemoryStore) GetCueCard(ctx context.Context, workspaceID, cueCardID string) (*CueCard, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	c, ok := s.cueCards[cueKey(workspaceID, cueCardID)]
	if !ok {
		return nil, ErrCueNotFound
	}
	clone := *c
	return &clone, nil
}

func (s *MemoryStore) ListCueCards(ctx context.Context, workspaceID, sessionID string) ([]*CueCard, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []*CueCard
	for _, c := range s.cueCards {
		if c.WorkspaceID == workspaceID && c.SessionID == sessionID {
			clone := *c
			result = append(result, &clone)
		}
	}
	return result, nil
}

func (s *MemoryStore) UpdateCueCard(ctx context.Context, c *CueCard) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	k := cueKey(c.WorkspaceID, c.CueCardID)
	if _, ok := s.cueCards[k]; !ok {
		return ErrCueNotFound
	}

	c.UpdatedAt = time.Now().UTC()
	clone := *c
	s.cueCards[k] = &clone
	return nil
}

func (s *MemoryStore) RemoveCueCard(ctx context.Context, workspaceID, sessionID, cueCardID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	k := cueKey(workspaceID, cueCardID)
	c, ok := s.cueCards[k]
	if !ok || c.SessionID != sessionID {
		return ErrCueNotFound
	}
	delete(s.cueCards, k)
	return nil
}

func (s *MemoryStore) CreateHighlight(ctx context.Context, h *Highlight) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	k := highlightKey(h.WorkspaceID, h.HighlightID)
	clone := *h
	s.highlights[k] = &clone
	return nil
}

func (s *MemoryStore) GetHighlight(ctx context.Context, workspaceID, highlightID string) (*Highlight, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	h, ok := s.highlights[highlightKey(workspaceID, highlightID)]
	if !ok {
		return nil, ErrHighlightNotFound
	}
	clone := *h
	return &clone, nil
}

func (s *MemoryStore) ListHighlights(ctx context.Context, workspaceID, sessionID string) ([]*Highlight, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []*Highlight
	for _, h := range s.highlights {
		if h.WorkspaceID == workspaceID && h.SessionID == sessionID {
			clone := *h
			result = append(result, &clone)
		}
	}
	return result, nil
}

func (s *MemoryStore) UpdateHighlight(ctx context.Context, h *Highlight) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	k := highlightKey(h.WorkspaceID, h.HighlightID)
	if _, ok := s.highlights[k]; !ok {
		return ErrHighlightNotFound
	}

	h.UpdatedAt = time.Now().UTC()
	clone := *h
	s.highlights[k] = &clone
	return nil
}

func (s *MemoryStore) SaveProofSummary(ctx context.Context, summary *PostLiveProofSummary) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	k := sessionKey(summary.WorkspaceID, summary.SessionID)
	clone := *summary
	s.proofs[k] = &clone
	return nil
}

func (s *MemoryStore) GetProofSummary(ctx context.Context, workspaceID, sessionID string) (*PostLiveProofSummary, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	p, ok := s.proofs[sessionKey(workspaceID, sessionID)]
	if !ok {
		return nil, fmt.Errorf("livecommerce: proof summary not found for session %s", sessionID)
	}
	clone := *p
	return &clone, nil
}

func (s *MemoryStore) GetCommand(ctx context.Context, workspaceID, idempotencyKey string) (*CommandExecutionRecord, bool) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	if idempotencyKey == "" {
		return nil, false
	}
	rec, ok := s.commands[workspaceID+":"+idempotencyKey]
	if !ok {
		return nil, false
	}
	clone := *rec
	return &clone, true
}

func (s *MemoryStore) RecordCommand(ctx context.Context, rec *CommandExecutionRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	if rec == nil || rec.IdempotencyKey == "" {
		return nil
	}
	clone := *rec
	s.commands[rec.WorkspaceID+":"+rec.IdempotencyKey] = &clone
	return nil
}

func (s *MemoryStore) CheckOrRecordCommand(ctx context.Context, workspaceID, sessionID, idempotencyKey, commandType string, responseJSON []byte) (*CommandExecutionRecord, bool, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	if idempotencyKey == "" {
		return nil, false, nil
	}

	k := workspaceID + ":" + idempotencyKey
	if existing, ok := s.commands[k]; ok {
		if len(existing.ResponseJSON) == 0 && len(responseJSON) > 0 {
			existing.ResponseJSON = responseJSON
		}
		clone := *existing
		return &clone, true, nil
	}

	rec := &CommandExecutionRecord{
		IdempotencyKey: idempotencyKey,
		WorkspaceID:    workspaceID,
		SessionID:      sessionID,
		CommandType:    commandType,
		ExecutedAt:     time.Now().UTC(),
		ResponseJSON:   responseJSON,
	}
	s.commands[k] = rec
	clone := *rec
	return &clone, false, nil
}

func (s *MemoryStore) AttachOrder(ctx context.Context, workspaceID, sessionID string, order TraceableOrderLink) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	k := sessionKey(workspaceID, sessionID)
	s.orders[k] = append(s.orders[k], order)
	return nil
}

func (s *MemoryStore) ListOrdersForSession(ctx context.Context, workspaceID, sessionID string) ([]TraceableOrderLink, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	orders := s.orders[sessionKey(workspaceID, sessionID)]
	res := make([]TraceableOrderLink, len(orders))
	copy(res, orders)
	return res, nil
}

var _ Store = (*MemoryStore)(nil)
