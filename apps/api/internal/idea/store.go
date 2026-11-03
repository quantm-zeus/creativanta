package idea

import (
	"context"
	"sort"
	"strings"
	"sync"
	"time"

	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
)

// Store defines persistence operations for M05 ideas and hooks.
type Store interface {
	CreateIdea(ctx context.Context, idea StoredIdea) error
	GetIdea(ctx context.Context, workspaceID, ideaID string) (*StoredIdea, error)
	UpdateIdea(ctx context.Context, idea StoredIdea) error
	DeleteIdea(ctx context.Context, workspaceID, ideaID string) error
	ListIdeas(ctx context.Context, workspaceID string, status contentv1.IdeaStatus, sourceType, searchQuery string, limit int) ([]StoredIdea, error)
	FindSimilarIdeas(ctx context.Context, workspaceID string, title string, embedding []float32, threshold float32) ([]DuplicateMatch, error)
	AddHook(ctx context.Context, hook StoredHook) error
	ListHooks(ctx context.Context, workspaceID, ideaID string) ([]StoredHook, error)
	RecordAIGeneration(ctx context.Context, workspaceID string, timestamp time.Time) error
	CountAIGenerations(ctx context.Context, workspaceID string, since time.Time) (int, error)
	RecordEvent(event DomainEvent)
	Events() []DomainEvent
}

// MemoryStore provides an in-memory, thread-safe, tenant-isolated Store implementation.
type MemoryStore struct {
	mu            sync.RWMutex
	ideas         map[string]map[string]StoredIdea // workspaceID -> ideaID -> StoredIdea
	hooks         map[string]map[string]StoredHook // workspaceID -> hookID -> StoredHook
	aiGenerations map[string][]time.Time           // workspaceID -> []timestamp
	events        []DomainEvent
}

// NewMemoryStore initializes a clean MemoryStore.
func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		ideas:         make(map[string]map[string]StoredIdea),
		hooks:         make(map[string]map[string]StoredHook),
		aiGenerations: make(map[string][]time.Time),
		events:        make([]DomainEvent, 0),
	}
}

func (m *MemoryStore) CreateIdea(ctx context.Context, idea StoredIdea) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsMap, ok := m.ideas[idea.WorkspaceID]
	if !ok {
		wsMap = make(map[string]StoredIdea)
		m.ideas[idea.WorkspaceID] = wsMap
	}

	wsMap[idea.IdeaID] = cloneStoredIdea(idea)
	return nil
}

func (m *MemoryStore) GetIdea(ctx context.Context, workspaceID, ideaID string) (*StoredIdea, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsMap, ok := m.ideas[workspaceID]
	if !ok {
		return nil, ErrIdeaNotFound
	}
	item, ok := wsMap[ideaID]
	if !ok || item.DeletedAt != nil {
		return nil, ErrIdeaNotFound
	}

	res := cloneStoredIdea(item)
	return &res, nil
}

func (m *MemoryStore) UpdateIdea(ctx context.Context, idea StoredIdea) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsMap, ok := m.ideas[idea.WorkspaceID]
	if !ok {
		return ErrIdeaNotFound
	}
	current, ok := wsMap[idea.IdeaID]
	if !ok || current.DeletedAt != nil {
		return ErrIdeaNotFound
	}

	wsMap[idea.IdeaID] = cloneStoredIdea(idea)
	return nil
}

func (m *MemoryStore) DeleteIdea(ctx context.Context, workspaceID, ideaID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsMap, ok := m.ideas[workspaceID]
	if !ok {
		return ErrIdeaNotFound
	}
	current, ok := wsMap[ideaID]
	if !ok || current.DeletedAt != nil {
		return ErrIdeaNotFound
	}

	now := time.Now().UTC()
	current.DeletedAt = &now
	wsMap[ideaID] = current
	return nil
}

func (m *MemoryStore) ListIdeas(ctx context.Context, workspaceID string, status contentv1.IdeaStatus, sourceType, searchQuery string, limit int) ([]StoredIdea, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsMap, ok := m.ideas[workspaceID]
	if !ok {
		return []StoredIdea{}, nil
	}

	var results []StoredIdea
	searchLower := strings.ToLower(strings.TrimSpace(searchQuery))

	for _, item := range wsMap {
		if item.DeletedAt != nil {
			continue
		}
		if status != contentv1.IdeaStatus_IDEA_STATUS_UNSPECIFIED && item.Status != status {
			continue
		}
		if sourceType != "" {
			matchedSource := false
			for _, s := range item.Sources {
				if strings.EqualFold(s.SourceType, sourceType) {
					matchedSource = true
					break
				}
			}
			if !matchedSource {
				continue
			}
		}
		if searchLower != "" {
			titleLower := strings.ToLower(item.Title)
			descLower := strings.ToLower(item.Description)
			if !strings.Contains(titleLower, searchLower) && !strings.Contains(descLower, searchLower) {
				continue
			}
		}

		results = append(results, cloneStoredIdea(item))
	}

	// Sort by UpdatedAt descending
	sort.Slice(results, func(i, j int) bool {
		return results[i].UpdatedAt.After(results[j].UpdatedAt)
	})

	if limit > 0 && len(results) > limit {
		results = results[:limit]
	}

	return results, nil
}

func (m *MemoryStore) FindSimilarIdeas(ctx context.Context, workspaceID string, title string, embedding []float32, threshold float32) ([]DuplicateMatch, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsMap, ok := m.ideas[workspaceID]
	if !ok {
		return nil, nil
	}

	var matches []DuplicateMatch

	for _, existing := range wsMap {
		if existing.DeletedAt != nil {
			continue
		}

		var sim float32
		if len(embedding) > 0 && len(existing.EmbeddingVector) > 0 {
			sim = CalculateCosineSimilarity(embedding, existing.EmbeddingVector)
		} else {
			sim = CalculateTextSimilarity(title, existing.Title)
		}

		if sim >= threshold {
			matches = append(matches, DuplicateMatch{
				ExistingIdeaID:    existing.IdeaID,
				ExistingIdeaTitle: existing.Title,
				SimilarityScore:   sim,
			})
		}
	}

	// Sort matches by highest similarity first
	sort.Slice(matches, func(i, j int) bool {
		return matches[i].SimilarityScore > matches[j].SimilarityScore
	})

	return matches, nil
}

func (m *MemoryStore) AddHook(ctx context.Context, hook StoredHook) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsHooks, ok := m.hooks[hook.WorkspaceID]
	if !ok {
		wsHooks = make(map[string]StoredHook)
		m.hooks[hook.WorkspaceID] = wsHooks
	}
	wsHooks[hook.HookID] = hook
	return nil
}

func (m *MemoryStore) ListHooks(ctx context.Context, workspaceID, ideaID string) ([]StoredHook, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsHooks, ok := m.hooks[workspaceID]
	if !ok {
		return []StoredHook{}, nil
	}

	var list []StoredHook
	for _, h := range wsHooks {
		if h.DeletedAt != nil {
			continue
		}
		if ideaID != "" && h.IdeaID != ideaID {
			continue
		}
		list = append(list, h)
	}

	// Sort by effectiveness score descending
	sort.Slice(list, func(i, j int) bool {
		return list[i].EffectivenessScore > list[j].EffectivenessScore
	})

	return list, nil
}

func (m *MemoryStore) RecordAIGeneration(ctx context.Context, workspaceID string, timestamp time.Time) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.aiGenerations[workspaceID] = append(m.aiGenerations[workspaceID], timestamp)
	return nil
}

func (m *MemoryStore) CountAIGenerations(ctx context.Context, workspaceID string, since time.Time) (int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	times := m.aiGenerations[workspaceID]
	count := 0
	for _, t := range times {
		if t.After(since) || t.Equal(since) {
			count++
		}
	}
	return count, nil
}

func (m *MemoryStore) RecordEvent(event DomainEvent) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.events = append(m.events, event)
}

func (m *MemoryStore) Events() []DomainEvent {
	m.mu.RLock()
	defer m.mu.RUnlock()
	out := make([]DomainEvent, len(m.events))
	copy(out, m.events)
	return out
}

func cloneStoredIdea(src StoredIdea) StoredIdea {
	dst := src
	if src.Sources != nil {
		dst.Sources = make([]StoredIdeaSource, len(src.Sources))
		copy(dst.Sources, src.Sources)
	}
	if src.Hooks != nil {
		dst.Hooks = make([]StoredHook, len(src.Hooks))
		copy(dst.Hooks, src.Hooks)
	}
	if src.EmbeddingVector != nil {
		dst.EmbeddingVector = make([]float32, len(src.EmbeddingVector))
		copy(dst.EmbeddingVector, src.EmbeddingVector)
	}
	if src.RecommendedFormats != nil {
		dst.RecommendedFormats = make([]string, len(src.RecommendedFormats))
		copy(dst.RecommendedFormats, src.RecommendedFormats)
	}
	if src.RecommendedPlatforms != nil {
		dst.RecommendedPlatforms = make([]string, len(src.RecommendedPlatforms))
		copy(dst.RecommendedPlatforms, src.RecommendedPlatforms)
	}
	return dst
}
