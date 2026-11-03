package script

import (
	"context"
	"fmt"
	"sort"
	"strconv"
	"sync"
	"time"

	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
)

// Store defines persistence operations for M06 Script Lab.
type Store interface {
	CreateScript(ctx context.Context, script StoredScript) error
	GetScript(ctx context.Context, workspaceID, scriptID string) (*StoredScript, error)
	UpdateScript(ctx context.Context, script StoredScript) error
	DeleteScript(ctx context.Context, workspaceID, scriptID string) error
	ListScripts(ctx context.Context, workspaceID string, lifecycle contentv1.ScriptLifecycleState, approval contentv1.ScriptApprovalState, ideaID string, limit int, pageToken string) ([]StoredScript, string, int, error)

	GetAssetBrief(ctx context.Context, workspaceID, scriptID string) (*StoredAssetBrief, error)
	UpsertAssetBrief(ctx context.Context, brief StoredAssetBrief) error

	CreateScriptVersion(ctx context.Context, ver StoredScriptVersion) error
	GetScriptVersion(ctx context.Context, workspaceID, scriptID string, versionIndex int32) (*StoredScriptVersion, error)
	ListScriptVersions(ctx context.Context, workspaceID, scriptID string) ([]StoredScriptVersion, error)

	CreateApprovalRequest(ctx context.Context, req StoredApprovalRequest) error
	GetApprovalRequest(ctx context.Context, workspaceID, scriptID string) (*StoredApprovalRequest, error)
	UpdateApprovalRequest(ctx context.Context, req StoredApprovalRequest) error

	AddComment(ctx context.Context, comment StoredComment) error
	ListComments(ctx context.Context, scriptID string) ([]StoredComment, error)
	ResolveComment(ctx context.Context, scriptID, commentID string) error

	RecordEvent(event DomainEventRecord)
	Events() []DomainEventRecord
	GetEvents(scriptID string) []DomainEventRecord
}

// MemoryStore provides a thread-safe, tenant-isolated Store implementation.
type MemoryStore struct {
	mu               sync.RWMutex
	scripts          map[string]map[string]StoredScript          // workspaceID -> scriptID -> StoredScript
	assetBriefs      map[string]map[string]StoredAssetBrief      // workspaceID -> scriptID -> StoredAssetBrief
	scriptVersions   map[string]map[string][]StoredScriptVersion // workspaceID -> scriptID -> []StoredScriptVersion
	approvalRequests map[string]map[string]StoredApprovalRequest // workspaceID -> scriptID -> StoredApprovalRequest
	comments         map[string][]StoredComment                  // scriptID -> []StoredComment
	events           []DomainEventRecord
}

// NewMemoryStore initializes a clean MemoryStore.
func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		scripts:          make(map[string]map[string]StoredScript),
		assetBriefs:      make(map[string]map[string]StoredAssetBrief),
		scriptVersions:   make(map[string]map[string][]StoredScriptVersion),
		approvalRequests: make(map[string]map[string]StoredApprovalRequest),
		comments:         make(map[string][]StoredComment),
		events:           make([]DomainEventRecord, 0),
	}
}

// Deep copy helpers
func cloneShots(in []StoredShot) []StoredShot {
	if in == nil {
		return nil
	}
	out := make([]StoredShot, len(in))
	copy(out, in)
	return out
}

func cloneScenes(in []StoredScene) []StoredScene {
	if in == nil {
		return nil
	}
	out := make([]StoredScene, len(in))
	for i, sc := range in {
		out[i] = sc
		out[i].ShotList = cloneShots(sc.ShotList)
	}
	return out
}

func cloneCtaBlocks(in []StoredCtaBlock) []StoredCtaBlock {
	if in == nil {
		return nil
	}
	out := make([]StoredCtaBlock, len(in))
	copy(out, in)
	return out
}

func cloneDisclosureBlocks(in []StoredDisclosureBlock) []StoredDisclosureBlock {
	if in == nil {
		return nil
	}
	out := make([]StoredDisclosureBlock, len(in))
	for i, d := range in {
		out[i] = d
		if d.DismissedAt != nil {
			t := *d.DismissedAt
			out[i].DismissedAt = &t
		}
	}
	return out
}

func cloneProfiles(in []StoredPublishTargetProfile) []StoredPublishTargetProfile {
	if in == nil {
		return nil
	}
	out := make([]StoredPublishTargetProfile, len(in))
	copy(out, in)
	return out
}

func cloneStrings(in []string) []string {
	if in == nil {
		return nil
	}
	out := make([]string, len(in))
	copy(out, in)
	return out
}

func cloneStoredScript(s StoredScript) StoredScript {
	res := s
	res.Scenes = cloneScenes(s.Scenes)
	res.CtaBlocks = cloneCtaBlocks(s.CtaBlocks)
	res.DisclosureBlocks = cloneDisclosureBlocks(s.DisclosureBlocks)
	res.PublishTargetProfiles = cloneProfiles(s.PublishTargetProfiles)
	res.ContinuityRefs = cloneStrings(s.ContinuityRefs)
	res.OfferProductHooks = cloneStrings(s.OfferProductHooks)
	if s.DeletedAt != nil {
		t := *s.DeletedAt
		res.DeletedAt = &t
	}
	return res
}

func cloneStoredAssetBrief(b StoredAssetBrief) StoredAssetBrief {
	res := b
	res.TargetPlatforms = cloneStrings(b.TargetPlatforms)
	if b.DeletedAt != nil {
		t := *b.DeletedAt
		res.DeletedAt = &t
	}
	return res
}

func cloneStoredScriptVersion(v StoredScriptVersion) StoredScriptVersion {
	res := v
	res.Scenes = cloneScenes(v.Scenes)
	res.CtaBlocks = cloneCtaBlocks(v.CtaBlocks)
	res.DisclosureBlocks = cloneDisclosureBlocks(v.DisclosureBlocks)
	return res
}

// --- Store Implementation ---

func (m *MemoryStore) CreateScript(ctx context.Context, script StoredScript) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsMap, ok := m.scripts[script.WorkspaceID]
	if !ok {
		wsMap = make(map[string]StoredScript)
		m.scripts[script.WorkspaceID] = wsMap
	}
	wsMap[script.ScriptID] = cloneStoredScript(script)
	return nil
}

func (m *MemoryStore) GetScript(ctx context.Context, workspaceID, scriptID string) (*StoredScript, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsMap, ok := m.scripts[workspaceID]
	if !ok {
		return nil, ErrScriptNotFound
	}
	s, ok := wsMap[scriptID]
	if !ok || s.DeletedAt != nil {
		return nil, ErrScriptNotFound
	}
	res := cloneStoredScript(s)
	return &res, nil
}

func (m *MemoryStore) UpdateScript(ctx context.Context, script StoredScript) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsMap, ok := m.scripts[script.WorkspaceID]
	if !ok {
		return ErrScriptNotFound
	}
	current, ok := wsMap[script.ScriptID]
	if !ok || current.DeletedAt != nil {
		return ErrScriptNotFound
	}
	wsMap[script.ScriptID] = cloneStoredScript(script)
	return nil
}

func (m *MemoryStore) DeleteScript(ctx context.Context, workspaceID, scriptID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsMap, ok := m.scripts[workspaceID]
	if !ok {
		return ErrScriptNotFound
	}
	current, ok := wsMap[scriptID]
	if !ok || current.DeletedAt != nil {
		return ErrScriptNotFound
	}
	now := time.Now().UTC()
	current.DeletedAt = &now
	wsMap[scriptID] = current
	return nil
}

func (m *MemoryStore) ListScripts(ctx context.Context, workspaceID string, lifecycle contentv1.ScriptLifecycleState, approval contentv1.ScriptApprovalState, ideaID string, limit int, pageToken string) ([]StoredScript, string, int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsMap, ok := m.scripts[workspaceID]
	if !ok {
		return []StoredScript{}, "", 0, nil
	}

	var all []StoredScript
	for _, s := range wsMap {
		if s.DeletedAt != nil {
			continue
		}
		if lifecycle != contentv1.ScriptLifecycleState_SCRIPT_LIFECYCLE_STATE_UNSPECIFIED && s.LifecycleState != lifecycle {
			continue
		}
		if approval != contentv1.ScriptApprovalState_SCRIPT_APPROVAL_STATE_UNSPECIFIED && s.ApprovalState != approval {
			continue
		}
		if ideaID != "" && s.IdeaID != ideaID {
			continue
		}
		all = append(all, cloneStoredScript(s))
	}

	sort.Slice(all, func(i, j int) bool {
		return all[i].UpdatedAt.After(all[j].UpdatedAt)
	})

	totalCount := len(all)
	startIndex := 0
	if pageToken != "" {
		if idx, err := strconv.Atoi(pageToken); err == nil && idx >= 0 && idx < len(all) {
			startIndex = idx
		}
	}

	if limit <= 0 {
		limit = 20
	}
	endIndex := startIndex + limit
	var nextPageToken string
	if endIndex < len(all) {
		nextPageToken = strconv.Itoa(endIndex)
	} else {
		endIndex = len(all)
	}

	if startIndex >= len(all) {
		return []StoredScript{}, "", totalCount, nil
	}

	return all[startIndex:endIndex], nextPageToken, totalCount, nil
}

func (m *MemoryStore) GetAssetBrief(ctx context.Context, workspaceID, scriptID string) (*StoredAssetBrief, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsMap, ok := m.assetBriefs[workspaceID]
	if !ok {
		return nil, ErrAssetBriefNotFound
	}
	b, ok := wsMap[scriptID]
	if !ok || b.DeletedAt != nil {
		return nil, ErrAssetBriefNotFound
	}
	res := cloneStoredAssetBrief(b)
	return &res, nil
}

func (m *MemoryStore) UpsertAssetBrief(ctx context.Context, brief StoredAssetBrief) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsMap, ok := m.assetBriefs[brief.WorkspaceID]
	if !ok {
		wsMap = make(map[string]StoredAssetBrief)
		m.assetBriefs[brief.WorkspaceID] = wsMap
	}
	wsMap[brief.ScriptID] = cloneStoredAssetBrief(brief)
	return nil
}

func (m *MemoryStore) CreateScriptVersion(ctx context.Context, ver StoredScriptVersion) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsMap, ok := m.scriptVersions[ver.WorkspaceID]
	if !ok {
		wsMap = make(map[string][]StoredScriptVersion)
		m.scriptVersions[ver.WorkspaceID] = wsMap
	}
	wsMap[ver.ScriptID] = append(wsMap[ver.ScriptID], cloneStoredScriptVersion(ver))
	return nil
}

func (m *MemoryStore) GetScriptVersion(ctx context.Context, workspaceID, scriptID string, versionIndex int32) (*StoredScriptVersion, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsMap, ok := m.scriptVersions[workspaceID]
	if !ok {
		return nil, ErrVersionNotFound
	}
	versions, ok := wsMap[scriptID]
	if !ok {
		return nil, ErrVersionNotFound
	}
	for _, v := range versions {
		if v.VersionIndex == versionIndex {
			res := cloneStoredScriptVersion(v)
			return &res, nil
		}
	}
	return nil, ErrVersionNotFound
}

func (m *MemoryStore) ListScriptVersions(ctx context.Context, workspaceID, scriptID string) ([]StoredScriptVersion, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsMap, ok := m.scriptVersions[workspaceID]
	if !ok {
		return []StoredScriptVersion{}, nil
	}
	versions, ok := wsMap[scriptID]
	if !ok {
		return []StoredScriptVersion{}, nil
	}
	out := make([]StoredScriptVersion, len(versions))
	for i, v := range versions {
		out[i] = cloneStoredScriptVersion(v)
	}
	// Sort newest version first
	sort.Slice(out, func(i, j int) bool {
		return out[i].VersionIndex > out[j].VersionIndex
	})
	return out, nil
}

func (m *MemoryStore) CreateApprovalRequest(ctx context.Context, req StoredApprovalRequest) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsMap, ok := m.approvalRequests[req.WorkspaceID]
	if !ok {
		wsMap = make(map[string]StoredApprovalRequest)
		m.approvalRequests[req.WorkspaceID] = wsMap
	}
	wsMap[req.ObjectID] = req
	return nil
}

func (m *MemoryStore) GetApprovalRequest(ctx context.Context, workspaceID, scriptID string) (*StoredApprovalRequest, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	wsMap, ok := m.approvalRequests[workspaceID]
	if !ok {
		return nil, fmt.Errorf("no approval request found for script %s", scriptID)
	}
	req, ok := wsMap[scriptID]
	if !ok {
		return nil, fmt.Errorf("no approval request found for script %s", scriptID)
	}
	return &req, nil
}

func (m *MemoryStore) UpdateApprovalRequest(ctx context.Context, req StoredApprovalRequest) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	wsMap, ok := m.approvalRequests[req.WorkspaceID]
	if !ok {
		return fmt.Errorf("approval request not found for workspace %s", req.WorkspaceID)
	}
	wsMap[req.ObjectID] = req
	return nil
}

func (m *MemoryStore) AddComment(ctx context.Context, comment StoredComment) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.comments[comment.ScriptID] = append(m.comments[comment.ScriptID], comment)
	return nil
}

func (m *MemoryStore) ListComments(ctx context.Context, scriptID string) ([]StoredComment, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	list, ok := m.comments[scriptID]
	if !ok {
		return []StoredComment{}, nil
	}
	out := make([]StoredComment, len(list))
	copy(out, list)
	return out, nil
}

func (m *MemoryStore) ResolveComment(ctx context.Context, scriptID, commentID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	list, ok := m.comments[scriptID]
	if !ok {
		return fmt.Errorf("comment not found")
	}
	for i := range list {
		if list[i].CommentID == commentID {
			list[i].IsResolved = true
			return nil
		}
	}
	return fmt.Errorf("comment not found")
}

func (m *MemoryStore) RecordEvent(event DomainEventRecord) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.events = append(m.events, event)
}

func (m *MemoryStore) Events() []DomainEventRecord {
	m.mu.RLock()
	defer m.mu.RUnlock()
	out := make([]DomainEventRecord, len(m.events))
	copy(out, m.events)
	return out
}

func (m *MemoryStore) GetEvents(scriptID string) []DomainEventRecord {
	m.mu.RLock()
	defer m.mu.RUnlock()
	var out []DomainEventRecord
	for _, e := range m.events {
		if e.ScriptID == scriptID {
			out = append(out, e)
		}
	}
	return out
}
