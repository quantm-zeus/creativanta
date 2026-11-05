package publish

import (
	"context"
	"sort"
	"sync"
)

// Store defines the persistence contract for Publish Hub state (R10 / 00026).
// Implementations must enforce workspace isolation on all reads and mutations.
type Store interface {
	SaveItem(ctx context.Context, item *PublishItem) error
	GetItem(ctx context.Context, workspaceID, publishItemID string) (*PublishItem, error)
	ListItems(ctx context.Context, workspaceID string) ([]*PublishItem, error)
	DeleteItem(ctx context.Context, workspaceID, publishItemID string) error

	SaveJob(ctx context.Context, job *PublishJob) error
	GetJob(ctx context.Context, workspaceID, publishJobID string) (*PublishJob, error)
	GetJobByItemID(ctx context.Context, workspaceID, publishItemID string) (*PublishJob, error)
	ListJobs(ctx context.Context, workspaceID string) ([]*PublishJob, error)
	DeleteJobsByItemID(ctx context.Context, workspaceID, publishItemID string) error

	AppendLog(ctx context.Context, logEntry *PublishLog) error
	ListLogsByItemID(ctx context.Context, workspaceID, publishItemID string) ([]*PublishLog, error)

	SavePost(ctx context.Context, post *ChannelPost) error
	GetPost(ctx context.Context, workspaceID, channelPostID string) (*ChannelPost, error)
	GetPostByItemID(ctx context.Context, workspaceID, publishItemID string) (*ChannelPost, error)
	ListPosts(ctx context.Context, workspaceID string) ([]*ChannelPost, error)

	SaveEffect(ctx context.Context, effect *ExternalEffect) error
	GetEffectByKey(ctx context.Context, workspaceID, operationKey string) (*ExternalEffect, error)
	ListEffectsByAggregate(ctx context.Context, workspaceID, aggregateType, aggregateID string) ([]*ExternalEffect, error)

	AppendEvent(ctx context.Context, ev DomainEvent) error
	ListEvents(ctx context.Context, workspaceID string) ([]DomainEvent, error)

	SetAccountPaused(ctx context.Context, workspaceID, accountID string, paused bool, reason string) error
	IsAccountPaused(ctx context.Context, workspaceID, accountID string) (bool, string, error)
}

// MemoryStore is a concurrency-safe store implementation that can be shared
// across Service restarts in unit tests, enforcing strict workspace scoping.
type MemoryStore struct {
	mu             sync.RWMutex
	items          map[string]*PublishItem
	jobs           map[string]*PublishJob
	logs           map[string][]*PublishLog
	posts          map[string]*ChannelPost
	effects        map[string]*ExternalEffect // key: workspaceID + "|" + operationKey
	pausedAccounts map[string]string          // key: workspaceID + "|" + accountID -> reason
	events         []DomainEvent
}

// NewMemoryStore creates a new isolated MemoryStore.
func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		items:          make(map[string]*PublishItem),
		jobs:           make(map[string]*PublishJob),
		logs:           make(map[string][]*PublishLog),
		posts:          make(map[string]*ChannelPost),
		effects:        make(map[string]*ExternalEffect),
		pausedAccounts: make(map[string]string),
		events:         make([]DomainEvent, 0),
	}
}

func clonePublishItem(in *PublishItem) *PublishItem {
	if in == nil {
		return nil
	}
	cp := *in
	if in.ScheduleAt != nil {
		t := *in.ScheduleAt
		cp.ScheduleAt = &t
	}
	if in.DeletedAt != nil {
		t := *in.DeletedAt
		cp.DeletedAt = &t
	}
	if in.Hashtags != nil {
		cp.Hashtags = append([]string(nil), in.Hashtags...)
	}
	if in.LinkedOfferIDs != nil {
		cp.LinkedOfferIDs = append([]string(nil), in.LinkedOfferIDs...)
	}
	if in.LinkedCampaignIDs != nil {
		cp.LinkedCampaignIDs = append([]string(nil), in.LinkedCampaignIDs...)
	}
	if in.ComplianceDetails != nil {
		cp.ComplianceDetails = make(map[string]any, len(in.ComplianceDetails))
		for k, v := range in.ComplianceDetails {
			cp.ComplianceDetails[k] = v
		}
	}
	if in.Metadata != nil {
		cp.Metadata = make(map[string]any, len(in.Metadata))
		for k, v := range in.Metadata {
			cp.Metadata[k] = v
		}
	}
	return &cp
}

func clonePublishJob(in *PublishJob) *PublishJob {
	if in == nil {
		return nil
	}
	cp := *in
	if in.DeletedAt != nil {
		t := *in.DeletedAt
		cp.DeletedAt = &t
	}
	if in.LastExecutionSummary != nil {
		cp.LastExecutionSummary = make(map[string]any, len(in.LastExecutionSummary))
		for k, v := range in.LastExecutionSummary {
			cp.LastExecutionSummary[k] = v
		}
	}
	return &cp
}

func clonePublishLog(in *PublishLog) *PublishLog {
	if in == nil {
		return nil
	}
	cp := *in
	if in.CompletedAt != nil {
		t := *in.CompletedAt
		cp.CompletedAt = &t
	}
	if in.FailedAt != nil {
		t := *in.FailedAt
		cp.FailedAt = &t
	}
	if in.Metadata != nil {
		cp.Metadata = make(map[string]any, len(in.Metadata))
		for k, v := range in.Metadata {
			cp.Metadata[k] = v
		}
	}
	return &cp
}

func cloneChannelPost(in *ChannelPost) *ChannelPost {
	if in == nil {
		return nil
	}
	cp := *in
	if in.SyncedAt != nil {
		t := *in.SyncedAt
		cp.SyncedAt = &t
	}
	if in.Metrics != nil {
		cp.Metrics = make(map[string]any, len(in.Metrics))
		for k, v := range in.Metrics {
			cp.Metrics[k] = v
		}
	}
	if in.Metadata != nil {
		cp.Metadata = make(map[string]any, len(in.Metadata))
		for k, v := range in.Metadata {
			cp.Metadata[k] = v
		}
	}
	return &cp
}

func cloneExternalEffect(in *ExternalEffect) *ExternalEffect {
	if in == nil {
		return nil
	}
	cp := *in
	if in.LastCheckedAt != nil {
		t := *in.LastCheckedAt
		cp.LastCheckedAt = &t
	}
	if in.ResultPayload != nil {
		cp.ResultPayload = make(map[string]any, len(in.ResultPayload))
		for k, v := range in.ResultPayload {
			cp.ResultPayload[k] = v
		}
	}
	return &cp
}

func (m *MemoryStore) SaveItem(_ context.Context, item *PublishItem) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.items[item.PublishItemID] = clonePublishItem(item)
	return nil
}

func (m *MemoryStore) GetItem(_ context.Context, workspaceID, publishItemID string) (*PublishItem, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	item, ok := m.items[publishItemID]
	if !ok || item.DeletedAt != nil || (workspaceID != "" && item.WorkspaceID != workspaceID) {
		return nil, ErrItemNotFound
	}
	return clonePublishItem(item), nil
}

func (m *MemoryStore) ListItems(_ context.Context, workspaceID string) ([]*PublishItem, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	if workspaceID == "" {
		return nil, ErrUnauthenticated
	}
	var out []*PublishItem
	for _, it := range m.items {
		if it.DeletedAt == nil && it.WorkspaceID == workspaceID {
			out = append(out, clonePublishItem(it))
		}
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].CreatedAt.Equal(out[j].CreatedAt) {
			return out[i].PublishItemID < out[j].PublishItemID
		}
		return out[i].CreatedAt.Before(out[j].CreatedAt)
	})
	return out, nil
}

func (m *MemoryStore) DeleteItem(_ context.Context, workspaceID, publishItemID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	item, ok := m.items[publishItemID]
	if !ok || (workspaceID != "" && item.WorkspaceID != workspaceID) {
		return ErrItemNotFound
	}
	delete(m.items, publishItemID)
	return nil
}

func (m *MemoryStore) SaveJob(_ context.Context, job *PublishJob) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.jobs[job.PublishJobID] = clonePublishJob(job)
	return nil
}

func (m *MemoryStore) GetJob(_ context.Context, workspaceID, publishJobID string) (*PublishJob, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	job, ok := m.jobs[publishJobID]
	if !ok || job.DeletedAt != nil || (workspaceID != "" && job.WorkspaceID != workspaceID) {
		return nil, ErrJobNotFound
	}
	return clonePublishJob(job), nil
}

func (m *MemoryStore) GetJobByItemID(_ context.Context, workspaceID, publishItemID string) (*PublishJob, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	var latest *PublishJob
	for _, j := range m.jobs {
		if j.DeletedAt != nil || j.PublishItemID != publishItemID {
			continue
		}
		if workspaceID != "" && j.WorkspaceID != workspaceID {
			continue
		}
		if latest == nil || j.CreatedAt.After(latest.CreatedAt) || (j.CreatedAt.Equal(latest.CreatedAt) && j.PublishJobID > latest.PublishJobID) {
			latest = j
		}
	}
	if latest == nil {
		return nil, ErrJobNotFound
	}
	return clonePublishJob(latest), nil
}

func (m *MemoryStore) ListJobs(_ context.Context, workspaceID string) ([]*PublishJob, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	if workspaceID == "" {
		return nil, ErrUnauthenticated
	}
	var out []*PublishJob
	for _, j := range m.jobs {
		if j.DeletedAt == nil && j.WorkspaceID == workspaceID {
			out = append(out, clonePublishJob(j))
		}
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].CreatedAt.Equal(out[j].CreatedAt) {
			return out[i].PublishJobID < out[j].PublishJobID
		}
		return out[i].CreatedAt.Before(out[j].CreatedAt)
	})
	return out, nil
}

func (m *MemoryStore) DeleteJobsByItemID(_ context.Context, workspaceID, publishItemID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	for id, j := range m.jobs {
		if j.PublishItemID == publishItemID && (workspaceID == "" || j.WorkspaceID == workspaceID) {
			delete(m.jobs, id)
		}
	}
	return nil
}

func (m *MemoryStore) AppendLog(_ context.Context, logEntry *PublishLog) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.logs[logEntry.PublishItemID] = append(m.logs[logEntry.PublishItemID], clonePublishLog(logEntry))
	return nil
}

func (m *MemoryStore) ListLogsByItemID(_ context.Context, workspaceID, publishItemID string) ([]*PublishLog, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	entries := m.logs[publishItemID]
	var out []*PublishLog
	for _, l := range entries {
		if workspaceID == "" || l.WorkspaceID == workspaceID {
			out = append(out, clonePublishLog(l))
		}
	}
	return out, nil
}

func (m *MemoryStore) SavePost(_ context.Context, post *ChannelPost) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.posts[post.ChannelPostID] = cloneChannelPost(post)
	return nil
}

func (m *MemoryStore) GetPost(_ context.Context, workspaceID, channelPostID string) (*ChannelPost, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	p, ok := m.posts[channelPostID]
	if !ok || (workspaceID != "" && p.WorkspaceID != workspaceID) {
		return nil, ErrItemNotFound
	}
	return cloneChannelPost(p), nil
}

func (m *MemoryStore) GetPostByItemID(_ context.Context, workspaceID, publishItemID string) (*ChannelPost, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	var latest *ChannelPost
	for _, p := range m.posts {
		if p.PublishItemID != publishItemID {
			continue
		}
		if workspaceID != "" && p.WorkspaceID != workspaceID {
			continue
		}
		if latest == nil || p.CreatedAt.After(latest.CreatedAt) {
			latest = p
		}
	}
	if latest == nil {
		return nil, ErrItemNotFound
	}
	return cloneChannelPost(latest), nil
}

func (m *MemoryStore) ListPosts(_ context.Context, workspaceID string) ([]*ChannelPost, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	if workspaceID == "" {
		return nil, ErrUnauthenticated
	}
	var out []*ChannelPost
	for _, p := range m.posts {
		if p.WorkspaceID == workspaceID {
			out = append(out, cloneChannelPost(p))
		}
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].CreatedAt.Equal(out[j].CreatedAt) {
			return out[i].ChannelPostID < out[j].ChannelPostID
		}
		return out[i].CreatedAt.Before(out[j].CreatedAt)
	})
	return out, nil
}

func effectCompositeKey(workspaceID, operationKey string) string {
	return workspaceID + "|" + operationKey
}

func (m *MemoryStore) SaveEffect(_ context.Context, effect *ExternalEffect) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.effects[effectCompositeKey(effect.WorkspaceID, effect.OperationKey)] = cloneExternalEffect(effect)
	return nil
}

func (m *MemoryStore) GetEffectByKey(_ context.Context, workspaceID, operationKey string) (*ExternalEffect, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	if eff, ok := m.effects[effectCompositeKey(workspaceID, operationKey)]; ok {
		return cloneExternalEffect(eff), nil
	}
	return nil, nil
}

func (m *MemoryStore) ListEffectsByAggregate(_ context.Context, workspaceID, aggregateType, aggregateID string) ([]*ExternalEffect, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	var out []*ExternalEffect
	for _, eff := range m.effects {
		if eff.WorkspaceID == workspaceID &&
			(aggregateType == "" || eff.AggregateType == aggregateType) &&
			eff.AggregateID == aggregateID {
			out = append(out, cloneExternalEffect(eff))
		}
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].CreatedAt.Equal(out[j].CreatedAt) {
			return out[i].EffectID < out[j].EffectID
		}
		return out[i].CreatedAt.Before(out[j].CreatedAt)
	})
	return out, nil
}

func (m *MemoryStore) AppendEvent(_ context.Context, ev DomainEvent) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.events = append(m.events, ev)
	return nil
}

func (m *MemoryStore) ListEvents(_ context.Context, workspaceID string) ([]DomainEvent, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	var out []DomainEvent
	for _, ev := range m.events {
		if workspaceID == "" || ev.WorkspaceID == workspaceID {
			out = append(out, ev)
		}
	}
	return out, nil
}

func (m *MemoryStore) SetAccountPaused(_ context.Context, workspaceID, accountID string, paused bool, reason string) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	key := workspaceID + "|" + accountID
	if paused {
		m.pausedAccounts[key] = reason
	} else {
		delete(m.pausedAccounts, key)
	}
	return nil
}

func (m *MemoryStore) IsAccountPaused(_ context.Context, workspaceID, accountID string) (bool, string, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	reason, ok := m.pausedAccounts[workspaceID+"|"+accountID]
	return ok, reason, nil
}
