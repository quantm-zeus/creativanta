package copilot

import (
	"context"
	"fmt"
	"sort"
	"sync"
	"time"
)

// Store defines persistence operations for Copilot sessions, quotes, and draft generation.
type Store interface {
	CreateSession(ctx context.Context, session *StoredSession) (*StoredSession, error)
	GetSession(ctx context.Context, workspaceID, sessionID string) (*StoredSession, error)
	UpdateSession(ctx context.Context, session *StoredSession) (*StoredSession, error)
	ListSessions(ctx context.Context, workspaceID, userID string, limit int, pageToken string) ([]*StoredSession, string, error)
	ClearSession(ctx context.Context, workspaceID, sessionID string) error

	CreateQuote(ctx context.Context, quote *StoredActionQuote) (*StoredActionQuote, error)
	GetQuote(ctx context.Context, workspaceID, quoteID string) (*StoredActionQuote, error)
	UpdateQuote(ctx context.Context, quote *StoredActionQuote) (*StoredActionQuote, error)

	SaveCreatedScriptDraft(ctx context.Context, workspaceID, title, content, authorID string) (string, error)
	DeleteProduct(ctx context.Context, workspaceID, productID string) error
	IsProductDeleted(ctx context.Context, workspaceID, productID string) bool
}

// MemoryStore implements Store in memory with thread safety and strict multi-tenant isolation.
type MemoryStore struct {
	mu              sync.RWMutex
	sessions        map[string]map[string]*StoredSession     // workspaceID -> sessionID -> session
	quotes          map[string]map[string]*StoredActionQuote // workspaceID -> quoteID -> quote
	scripts         map[string]map[string]string             // workspaceID -> scriptID -> title
	deletedProducts map[string]map[string]bool               // workspaceID -> productID -> deleted
}

// NewMemoryStore initializes an in-memory store.
func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		sessions:        make(map[string]map[string]*StoredSession),
		quotes:          make(map[string]map[string]*StoredActionQuote),
		scripts:         make(map[string]map[string]string),
		deletedProducts: make(map[string]map[string]bool),
	}
}

func cloneQuote(q *StoredActionQuote) *StoredActionQuote {
	if q == nil {
		return nil
	}
	cp := *q
	return &cp
}

func cloneMessage(m *StoredMessage) StoredMessage {
	cp := *m
	if m.PendingQuote != nil {
		cp.PendingQuote = cloneQuote(m.PendingQuote)
	}
	if len(m.ActionCards) > 0 {
		cp.ActionCards = make([]StoredActionCard, len(m.ActionCards))
		for i, ac := range m.ActionCards {
			cp.ActionCards[i] = ac
			if ac.Quote != nil {
				cp.ActionCards[i].Quote = cloneQuote(ac.Quote)
			}
			if len(ac.Parameters) > 0 {
				cp.ActionCards[i].Parameters = make(map[string]string, len(ac.Parameters))
				for k, v := range ac.Parameters {
					cp.ActionCards[i].Parameters[k] = v
				}
			}
		}
	}
	if len(m.DataCards) > 0 {
		cp.DataCards = make([]StoredDataCard, len(m.DataCards))
		for i, dc := range m.DataCards {
			cp.DataCards[i] = dc
			if len(dc.SourceBadges) > 0 {
				cp.DataCards[i].SourceBadges = append([]string(nil), dc.SourceBadges...)
			}
			if len(dc.Metrics) > 0 {
				cp.DataCards[i].Metrics = make(map[string]string, len(dc.Metrics))
				for k, v := range dc.Metrics {
					cp.DataCards[i].Metrics[k] = v
				}
			}
		}
	}
	return cp
}

func cloneSession(s *StoredSession) *StoredSession {
	if s == nil {
		return nil
	}
	cp := *s
	if s.EndedAt != nil {
		t := *s.EndedAt
		cp.EndedAt = &t
	}
	if len(s.Messages) > 0 {
		cp.Messages = make([]StoredMessage, len(s.Messages))
		for i := range s.Messages {
			cp.Messages[i] = cloneMessage(&s.Messages[i])
		}
	}
	return &cp
}

func (m *MemoryStore) CreateSession(ctx context.Context, session *StoredSession) (*StoredSession, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	if session.WorkspaceID == "" || session.SessionID == "" {
		return nil, fmt.Errorf("copilot store: workspace_id and session_id required")
	}

	wsSessions, ok := m.sessions[session.WorkspaceID]
	if !ok {
		wsSessions = make(map[string]*StoredSession)
		m.sessions[session.WorkspaceID] = wsSessions
	}

	cloned := cloneSession(session)
	wsSessions[session.SessionID] = cloned
	return cloneSession(cloned), nil
}

func (m *MemoryStore) GetSession(ctx context.Context, workspaceID, sessionID string) (*StoredSession, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsSessions, ok := m.sessions[workspaceID]
	if !ok {
		return nil, ErrSessionNotFound
	}
	session, ok := wsSessions[sessionID]
	if !ok {
		return nil, ErrSessionNotFound
	}
	return cloneSession(session), nil
}

func (m *MemoryStore) UpdateSession(ctx context.Context, session *StoredSession) (*StoredSession, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsSessions, ok := m.sessions[session.WorkspaceID]
	if !ok {
		return nil, ErrSessionNotFound
	}
	if _, ok := wsSessions[session.SessionID]; !ok {
		return nil, ErrSessionNotFound
	}

	session.UpdatedAt = time.Now().UTC()
	cloned := cloneSession(session)
	wsSessions[session.SessionID] = cloned
	return cloneSession(cloned), nil
}

func (m *MemoryStore) ListSessions(ctx context.Context, workspaceID, userID string, limit int, pageToken string) ([]*StoredSession, string, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsSessions, ok := m.sessions[workspaceID]
	if !ok {
		return nil, "", nil
	}

	var userSessions []*StoredSession
	for _, s := range wsSessions {
		if userID == "" || s.UserID == userID {
			userSessions = append(userSessions, cloneSession(s))
		}
	}

	sort.Slice(userSessions, func(i, j int) bool {
		return userSessions[i].CreatedAt.After(userSessions[j].CreatedAt)
	})

	if limit <= 0 {
		limit = 20
	}
	if len(userSessions) > limit {
		return userSessions[:limit], "next-page", nil
	}
	return userSessions, "", nil
}

func (m *MemoryStore) ClearSession(ctx context.Context, workspaceID, sessionID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsSessions, ok := m.sessions[workspaceID]
	if !ok {
		return ErrSessionNotFound
	}
	s, ok := wsSessions[sessionID]
	if !ok {
		return ErrSessionNotFound
	}
	s.Messages = nil
	s.UpdatedAt = time.Now().UTC()
	return nil
}

func (m *MemoryStore) CreateQuote(ctx context.Context, quote *StoredActionQuote) (*StoredActionQuote, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	if quote.WorkspaceID == "" || quote.QuoteID == "" {
		return nil, fmt.Errorf("copilot store: workspace_id and quote_id required")
	}

	wsQuotes, ok := m.quotes[quote.WorkspaceID]
	if !ok {
		wsQuotes = make(map[string]*StoredActionQuote)
		m.quotes[quote.WorkspaceID] = wsQuotes
	}

	cloned := cloneQuote(quote)
	wsQuotes[quote.QuoteID] = cloned
	return cloneQuote(cloned), nil
}

func (m *MemoryStore) GetQuote(ctx context.Context, workspaceID, quoteID string) (*StoredActionQuote, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsQuotes, ok := m.quotes[workspaceID]
	if !ok {
		return nil, ErrQuoteNotFound
	}
	quote, ok := wsQuotes[quoteID]
	if !ok {
		return nil, ErrQuoteNotFound
	}
	return cloneQuote(quote), nil
}

func (m *MemoryStore) UpdateQuote(ctx context.Context, quote *StoredActionQuote) (*StoredActionQuote, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsQuotes, ok := m.quotes[quote.WorkspaceID]
	if !ok {
		return nil, ErrQuoteNotFound
	}
	if _, ok := wsQuotes[quote.QuoteID]; !ok {
		return nil, ErrQuoteNotFound
	}

	cloned := cloneQuote(quote)
	wsQuotes[quote.QuoteID] = cloned
	return cloneQuote(cloned), nil
}

func (m *MemoryStore) SaveCreatedScriptDraft(ctx context.Context, workspaceID, title, content, authorID string) (string, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsScripts, ok := m.scripts[workspaceID]
	if !ok {
		wsScripts = make(map[string]string)
		m.scripts[workspaceID] = wsScripts
	}
	scriptID := fmt.Sprintf("scr-%d", time.Now().UnixNano())
	wsScripts[scriptID] = title
	return scriptID, nil
}

func (m *MemoryStore) DeleteProduct(ctx context.Context, workspaceID, productID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsProducts, ok := m.deletedProducts[workspaceID]
	if !ok {
		wsProducts = make(map[string]bool)
		m.deletedProducts[workspaceID] = wsProducts
	}
	wsProducts[productID] = true
	return nil
}

func (m *MemoryStore) IsProductDeleted(ctx context.Context, workspaceID, productID string) bool {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsProducts, ok := m.deletedProducts[workspaceID]
	if !ok {
		return false
	}
	return wsProducts[productID]
}
