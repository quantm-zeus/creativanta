package production

import (
	"context"
	"fmt"
	"sync"
	"time"
)

// Store defines persistence operations for assets, generation jobs, and uploads.
type Store interface {
	CreateAsset(ctx context.Context, asset *Asset) error
	GetAsset(ctx context.Context, workspaceID, assetID string) (*Asset, error)
	UpdateAsset(ctx context.Context, asset *Asset) error
	ListAssets(ctx context.Context, workspaceID, assetType, genState, qualityState string, limit, offset int) ([]*Asset, int64, error)
	GetRecentAssets(ctx context.Context, workspaceID string, limit int) ([]*Asset, error)

	CreateJob(ctx context.Context, job *GenerationJob) error
	GetJob(ctx context.Context, workspaceID, jobID string) (*GenerationJob, error)
	UpdateJob(ctx context.Context, job *GenerationJob) error
	ListActiveJobs(ctx context.Context, workspaceID string) ([]*GenerationJob, error)

	// SyncJobAndAsset atomically updates generation_jobs.status and assets.generation_state per RULE-M07-007.
	SyncJobAndAsset(ctx context.Context, workspaceID, jobID, jobStatus, assetState, errorMsg, resultURL string, actualCredits, actualCostUSD string) error

	CreateUpload(ctx context.Context, upload *FileUpload) error
	GetUpload(ctx context.Context, workspaceID, uploadID string) (*FileUpload, error)
}

// MemoryStore provides a thread-safe, tenant-isolated in-memory store for production.
type MemoryStore struct {
	mu      sync.RWMutex
	assets  map[string]map[string]*Asset         // workspaceID -> assetID -> Asset
	jobs    map[string]map[string]*GenerationJob // workspaceID -> jobID -> GenerationJob
	uploads map[string]map[string]*FileUpload    // workspaceID -> uploadID -> FileUpload
}

// NewMemoryStore constructs a new MemoryStore.
func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		assets:  make(map[string]map[string]*Asset),
		jobs:    make(map[string]map[string]*GenerationJob),
		uploads: make(map[string]map[string]*FileUpload),
	}
}

func (s *MemoryStore) CreateAsset(ctx context.Context, asset *Asset) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.assets[asset.WorkspaceID] == nil {
		s.assets[asset.WorkspaceID] = make(map[string]*Asset)
	}
	cp := *asset
	s.assets[asset.WorkspaceID][asset.AssetID] = &cp
	return nil
}

func (s *MemoryStore) GetAsset(ctx context.Context, workspaceID, assetID string) (*Asset, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.assets[workspaceID]
	if ws == nil {
		return nil, ErrAssetNotFound
	}
	a, ok := ws[assetID]
	if !ok || a.DeletedAt != nil {
		return nil, ErrAssetNotFound
	}
	cp := *a
	return &cp, nil
}

func (s *MemoryStore) UpdateAsset(ctx context.Context, asset *Asset) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := s.assets[asset.WorkspaceID]
	if ws == nil || ws[asset.AssetID] == nil {
		return ErrAssetNotFound
	}
	cp := *asset
	cp.UpdatedAt = time.Now().UTC()
	ws[asset.AssetID] = &cp
	return nil
}

func (s *MemoryStore) ListAssets(ctx context.Context, workspaceID, assetType, genState, qualityState string, limit, offset int) ([]*Asset, int64, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.assets[workspaceID]
	if ws == nil {
		return []*Asset{}, 0, nil
	}

	var matched []*Asset
	for _, a := range ws {
		if a.DeletedAt != nil {
			continue
		}
		if assetType != "" && a.AssetType != assetType {
			continue
		}
		if genState != "" && a.GenerationState != genState {
			continue
		}
		if qualityState != "" && a.QualityState != qualityState {
			continue
		}
		cp := *a
		matched = append(matched, &cp)
	}

	total := int64(len(matched))
	if offset >= len(matched) {
		return []*Asset{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(matched) {
		end = len(matched)
	}
	return matched[offset:end], total, nil
}

func (s *MemoryStore) GetRecentAssets(ctx context.Context, workspaceID string, limit int) ([]*Asset, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.assets[workspaceID]
	if ws == nil {
		return []*Asset{}, nil
	}

	var list []*Asset
	for _, a := range ws {
		if a.DeletedAt != nil {
			continue
		}
		cp := *a
		list = append(list, &cp)
	}

	// Sort newest first
	for i := 0; i < len(list)-1; i++ {
		for j := i + 1; j < len(list); j++ {
			if list[i].CreatedAt.Before(list[j].CreatedAt) {
				list[i], list[j] = list[j], list[i]
			}
		}
	}

	if limit > 0 && len(list) > limit {
		list = list[:limit]
	}
	return list, nil
}

func (s *MemoryStore) CreateJob(ctx context.Context, job *GenerationJob) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.jobs[job.WorkspaceID] == nil {
		s.jobs[job.WorkspaceID] = make(map[string]*GenerationJob)
	}
	cp := *job
	s.jobs[job.WorkspaceID][job.JobID] = &cp
	return nil
}

func (s *MemoryStore) GetJob(ctx context.Context, workspaceID, jobID string) (*GenerationJob, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.jobs[workspaceID]
	if ws == nil {
		return nil, ErrJobNotFound
	}
	j, ok := ws[jobID]
	if !ok {
		return nil, ErrJobNotFound
	}
	cp := *j
	return &cp, nil
}

func (s *MemoryStore) UpdateJob(ctx context.Context, job *GenerationJob) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := s.jobs[job.WorkspaceID]
	if ws == nil || ws[job.JobID] == nil {
		return ErrJobNotFound
	}
	cp := *job
	cp.UpdatedAt = time.Now().UTC()
	ws[job.JobID] = &cp
	return nil
}

func (s *MemoryStore) ListActiveJobs(ctx context.Context, workspaceID string) ([]*GenerationJob, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.jobs[workspaceID]
	if ws == nil {
		return []*GenerationJob{}, nil
	}

	var active []*GenerationJob
	for _, j := range ws {
		if j.Status == "queued" || j.Status == "processing" {
			cp := *j
			active = append(active, &cp)
		}
	}
	return active, nil
}

// SyncJobAndAsset satisfies RULE-M07-007 (Audit v4 — M1):
// Atomically synchronizes generation_jobs.status and assets.generation_state.
func (s *MemoryStore) SyncJobAndAsset(ctx context.Context, workspaceID, jobID, jobStatus, assetState, errorMsg, resultURL string, actualCredits, actualCostUSD string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	wsJobs := s.jobs[workspaceID]
	if wsJobs == nil || wsJobs[jobID] == nil {
		return ErrJobNotFound
	}
	job := wsJobs[jobID]
	now := time.Now().UTC()

	job.Status = jobStatus
	job.UpdatedAt = now
	if errorMsg != "" {
		job.ErrorMessage = errorMsg
	}
	if resultURL != "" {
		job.ResultURL = resultURL
	}
	if jobStatus == "completed" || jobStatus == "failed" || jobStatus == "cancelled" {
		job.CompletedAt = &now
	}

	// Update corresponding asset atomically
	if job.AssetID != "" {
		wsAssets := s.assets[workspaceID]
		if wsAssets != nil && wsAssets[job.AssetID] != nil {
			asset := wsAssets[job.AssetID]
			asset.GenerationState = assetState
			asset.UpdatedAt = now
			if errorMsg != "" {
				asset.ErrorMessage = errorMsg
			}
			if resultURL != "" {
				asset.FileURL = resultURL
			}
		}
	}

	return nil
}

func (s *MemoryStore) CreateUpload(ctx context.Context, upload *FileUpload) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.uploads[upload.WorkspaceID] == nil {
		s.uploads[upload.WorkspaceID] = make(map[string]*FileUpload)
	}
	cp := *upload
	s.uploads[upload.WorkspaceID][upload.UploadID] = &cp
	return nil
}

func (s *MemoryStore) GetUpload(ctx context.Context, workspaceID, uploadID string) (*FileUpload, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.uploads[workspaceID]
	if ws == nil {
		return nil, fmt.Errorf("upload %q not found in workspace %q", uploadID, workspaceID)
	}
	u, ok := ws[uploadID]
	if !ok {
		return nil, fmt.Errorf("upload %q not found in workspace %q", uploadID, workspaceID)
	}
	cp := *u
	return &cp, nil
}
