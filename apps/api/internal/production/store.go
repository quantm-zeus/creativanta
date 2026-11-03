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

	// Remix & Multi-Merge (§22.1, §22.2, P4-04)
	CreateRemixBlueprint(ctx context.Context, bp *RemixBlueprint) error
	GetRemixBlueprint(ctx context.Context, workspaceID, blueprintID string) (*RemixBlueprint, error)
	UpdateRemixBlueprint(ctx context.Context, bp *RemixBlueprint) error

	CreateVideoEditJob(ctx context.Context, job *VideoEditJobRecord) error
	GetVideoEditJob(ctx context.Context, workspaceID, jobID string) (*VideoEditJobRecord, error)
	ListVideoEditJobs(ctx context.Context, workspaceID, mode, status string, limit, offset int) ([]*VideoEditJobRecord, int64, error)
	UpdateVideoEditJob(ctx context.Context, job *VideoEditJobRecord) error

	// Translation jobs (§22.6, EF-05, P4-06)
	CreateTranslationJob(ctx context.Context, job *TranslationJob) error
	GetTranslationJob(ctx context.Context, workspaceID, jobID string) (*TranslationJob, error)
	UpdateTranslationJob(ctx context.Context, job *TranslationJob) error
	ListTranslationJobs(ctx context.Context, workspaceID string, limit, offset int) ([]*TranslationJob, int64, error)

	// Voice clones (§22.12, M08, P4-06)
	CreateVoiceClone(ctx context.Context, record *VoiceCloneRecord) error
	GetVoiceClone(ctx context.Context, workspaceID, cloneID string) (*VoiceCloneRecord, error)
	UpdateVoiceClone(ctx context.Context, record *VoiceCloneRecord) error
	DeleteVoiceClone(ctx context.Context, workspaceID, cloneID string) error
	ListVoiceClones(ctx context.Context, workspaceID, characterID string, limit, offset int) ([]*VoiceCloneRecord, int64, error)

	// Sound tracks (EF-06, P4-06)
	CreateSoundTrack(ctx context.Context, track *SoundTrack) error
	GetSoundTrack(ctx context.Context, workspaceID, trackID string) (*SoundTrack, error)
	ListSoundTracks(ctx context.Context, workspaceID, category, genre, mood string, limit, offset int) ([]*SoundTrack, int64, error)

	// Style packs (EF-07, P4-07)
	CreateStylePack(ctx context.Context, pack *StylePackRecord) error
	GetStylePack(ctx context.Context, workspaceID, packID string) (*StylePackRecord, error)
	ListStylePacks(ctx context.Context, workspaceID string, limit, offset int) ([]*StylePackRecord, int64, error)
	UpdateStylePack(ctx context.Context, pack *StylePackRecord) error
	DeleteStylePack(ctx context.Context, workspaceID, packID string) error

	// Continuity violations & QA (M08, P4-07)
	CreateContinuityViolation(ctx context.Context, v *ContinuityViolationRecord) error
	GetContinuityViolation(ctx context.Context, workspaceID, violationID string) (*ContinuityViolationRecord, error)
	ResolveContinuityViolation(ctx context.Context, workspaceID, violationID, resolvedBy, overrideReason string) error
	ListContinuityViolations(ctx context.Context, workspaceID, assetID string) ([]*ContinuityViolationRecord, error)

	// Characters & Consent for Previews (M08, P4-07)
	SaveCharacter(ctx context.Context, char *ProductionCharacter) error
	GetCharacter(ctx context.Context, workspaceID, characterID string) (*ProductionCharacter, error)
	SaveConsentRecord(ctx context.Context, cr *ProductionConsentRecord) error
	GetConsentRecord(ctx context.Context, workspaceID, consentID string) (*ProductionConsentRecord, error)
	RevokeConsentRecord(ctx context.Context, workspaceID, consentID string) error
}

// MemoryStore provides a thread-safe, tenant-isolated in-memory store for production.
type MemoryStore struct {
	mu           sync.RWMutex
	assets       map[string]map[string]*Asset              // workspaceID -> assetID -> Asset
	jobs         map[string]map[string]*GenerationJob      // workspaceID -> jobID -> GenerationJob
	uploads      map[string]map[string]*FileUpload         // workspaceID -> uploadID -> FileUpload
	blueprints   map[string]map[string]*RemixBlueprint     // workspaceID -> blueprintID -> RemixBlueprint
	videoJobs    map[string]map[string]*VideoEditJobRecord // workspaceID -> jobID -> VideoEditJobRecord
	translations map[string]map[string]*TranslationJob     // workspaceID -> jobID -> TranslationJob
	voiceClones  map[string]map[string]*VoiceCloneRecord   // workspaceID -> cloneID -> VoiceCloneRecord
	soundTracks  map[string]map[string]*SoundTrack         // workspaceID -> trackID -> SoundTrack
	stylePacks   map[string]map[string]*StylePackRecord    // workspaceID -> stylePackID -> StylePackRecord
	violations   map[string]map[string]*ContinuityViolationRecord // workspaceID -> violationID -> ContinuityViolationRecord
	characters   map[string]map[string]*ProductionCharacter       // workspaceID -> characterID -> ProductionCharacter
	consents     map[string]map[string]*ProductionConsentRecord   // workspaceID -> consentID -> ProductionConsentRecord
}

// NewMemoryStore constructs a new MemoryStore.
func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		assets:       make(map[string]map[string]*Asset),
		jobs:         make(map[string]map[string]*GenerationJob),
		uploads:      make(map[string]map[string]*FileUpload),
		blueprints:   make(map[string]map[string]*RemixBlueprint),
		videoJobs:    make(map[string]map[string]*VideoEditJobRecord),
		translations: make(map[string]map[string]*TranslationJob),
		voiceClones:  make(map[string]map[string]*VoiceCloneRecord),
		soundTracks:  make(map[string]map[string]*SoundTrack),
		stylePacks:   make(map[string]map[string]*StylePackRecord),
		violations:   make(map[string]map[string]*ContinuityViolationRecord),
		characters:   make(map[string]map[string]*ProductionCharacter),
		consents:     make(map[string]map[string]*ProductionConsentRecord),
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
		if a.DeletedAt == nil {
			cp := *a
			list = append(list, &cp)
		}
	}

	if limit <= 0 || limit > len(list) {
		limit = len(list)
	}
	return list[:limit], nil
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

func (s *MemoryStore) SyncJobAndAsset(
	ctx context.Context,
	workspaceID, jobID, jobStatus, assetState, errorMsg, resultURL string,
	actualCredits, actualCostUSD string,
) error {
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

// ----------------------------------------------------------------------------
// Remix Blueprint implementation (P4-04)
// ----------------------------------------------------------------------------

func (s *MemoryStore) CreateRemixBlueprint(ctx context.Context, bp *RemixBlueprint) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.blueprints[bp.WorkspaceID] == nil {
		s.blueprints[bp.WorkspaceID] = make(map[string]*RemixBlueprint)
	}
	cp := *bp
	s.blueprints[bp.WorkspaceID][bp.BlueprintID] = &cp
	return nil
}

func (s *MemoryStore) GetRemixBlueprint(ctx context.Context, workspaceID, blueprintID string) (*RemixBlueprint, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.blueprints[workspaceID]
	if ws == nil {
		return nil, ErrBlueprintNotFound
	}
	bp, ok := ws[blueprintID]
	if !ok || bp.DeletedAt != nil {
		return nil, ErrBlueprintNotFound
	}
	cp := *bp
	return &cp, nil
}

func (s *MemoryStore) UpdateRemixBlueprint(ctx context.Context, bp *RemixBlueprint) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := s.blueprints[bp.WorkspaceID]
	if ws == nil || ws[bp.BlueprintID] == nil {
		return ErrBlueprintNotFound
	}
	cp := *bp
	cp.UpdatedAt = time.Now().UTC()
	ws[bp.BlueprintID] = &cp
	return nil
}

// ----------------------------------------------------------------------------
// Video Edit Job implementation (P4-04)
// ----------------------------------------------------------------------------

func (s *MemoryStore) CreateVideoEditJob(ctx context.Context, job *VideoEditJobRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.videoJobs[job.WorkspaceID] == nil {
		s.videoJobs[job.WorkspaceID] = make(map[string]*VideoEditJobRecord)
	}
	cp := *job
	s.videoJobs[job.WorkspaceID][job.JobID] = &cp
	return nil
}

func (s *MemoryStore) GetVideoEditJob(ctx context.Context, workspaceID, jobID string) (*VideoEditJobRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.videoJobs[workspaceID]
	if ws == nil {
		return nil, ErrVideoEditJobNotFound
	}
	j, ok := ws[jobID]
	if !ok || j.DeletedAt != nil {
		return nil, ErrVideoEditJobNotFound
	}
	cp := *j
	return &cp, nil
}

func (s *MemoryStore) ListVideoEditJobs(ctx context.Context, workspaceID, mode, status string, limit, offset int) ([]*VideoEditJobRecord, int64, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.videoJobs[workspaceID]
	if ws == nil {
		return []*VideoEditJobRecord{}, 0, nil
	}

	var matched []*VideoEditJobRecord
	for _, j := range ws {
		if j.DeletedAt != nil {
			continue
		}
		if mode != "" && j.Mode != mode {
			continue
		}
		if status != "" && j.Status != status {
			continue
		}
		cp := *j
		matched = append(matched, &cp)
	}

	total := int64(len(matched))
	if offset < 0 {
		offset = 0
	}
	if offset >= len(matched) {
		return []*VideoEditJobRecord{}, total, nil
	}

	end := offset + limit
	if limit <= 0 || end > len(matched) {
		end = len(matched)
	}
	return matched[offset:end], total, nil
}

func (s *MemoryStore) UpdateVideoEditJob(ctx context.Context, job *VideoEditJobRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := s.videoJobs[job.WorkspaceID]
	if ws == nil || ws[job.JobID] == nil {
		return ErrVideoEditJobNotFound
	}
	cp := *job
	cp.UpdatedAt = time.Now().UTC()
	ws[job.JobID] = &cp
	return nil
}

// ----------------------------------------------------------------------------
// Translation Jobs implementation (P4-06)
// ----------------------------------------------------------------------------

func (s *MemoryStore) CreateTranslationJob(ctx context.Context, job *TranslationJob) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.translations[job.WorkspaceID] == nil {
		s.translations[job.WorkspaceID] = make(map[string]*TranslationJob)
	}
	cp := *job
	s.translations[job.WorkspaceID][job.TranslationJobID] = &cp
	return nil
}

func (s *MemoryStore) GetTranslationJob(ctx context.Context, workspaceID, jobID string) (*TranslationJob, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.translations[workspaceID]
	if ws == nil {
		return nil, fmt.Errorf("translation job %q not found in workspace %q", jobID, workspaceID)
	}
	j, ok := ws[jobID]
	if !ok || j.DeletedAt != nil {
		return nil, fmt.Errorf("translation job %q not found in workspace %q", jobID, workspaceID)
	}
	cp := *j
	return &cp, nil
}

func (s *MemoryStore) UpdateTranslationJob(ctx context.Context, job *TranslationJob) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := s.translations[job.WorkspaceID]
	if ws == nil || ws[job.TranslationJobID] == nil {
		return fmt.Errorf("translation job %q not found in workspace %q", job.TranslationJobID, job.WorkspaceID)
	}
	cp := *job
	cp.UpdatedAt = time.Now().UTC()
	ws[job.TranslationJobID] = &cp
	return nil
}

func (s *MemoryStore) ListTranslationJobs(ctx context.Context, workspaceID string, limit, offset int) ([]*TranslationJob, int64, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.translations[workspaceID]
	if ws == nil {
		return []*TranslationJob{}, 0, nil
	}

	var matched []*TranslationJob
	for _, j := range ws {
		if j.DeletedAt != nil {
			continue
		}
		cp := *j
		matched = append(matched, &cp)
	}

	total := int64(len(matched))
	if offset < 0 {
		offset = 0
	}
	if offset >= len(matched) {
		return []*TranslationJob{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(matched) {
		end = len(matched)
	}
	return matched[offset:end], total, nil
}

// ----------------------------------------------------------------------------
// Voice Clones implementation (P4-06)
// ----------------------------------------------------------------------------

func (s *MemoryStore) CreateVoiceClone(ctx context.Context, record *VoiceCloneRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.voiceClones[record.WorkspaceID] == nil {
		s.voiceClones[record.WorkspaceID] = make(map[string]*VoiceCloneRecord)
	}
	cp := *record
	s.voiceClones[record.WorkspaceID][record.VoiceCloneID] = &cp
	return nil
}

func (s *MemoryStore) GetVoiceClone(ctx context.Context, workspaceID, cloneID string) (*VoiceCloneRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.voiceClones[workspaceID]
	if ws == nil {
		return nil, fmt.Errorf("voice clone %q not found in workspace %q", cloneID, workspaceID)
	}
	vc, ok := ws[cloneID]
	if !ok || vc.CloneStatus == "revoked" {
		return nil, fmt.Errorf("voice clone %q not found or revoked in workspace %q", cloneID, workspaceID)
	}
	cp := *vc
	return &cp, nil
}

func (s *MemoryStore) UpdateVoiceClone(ctx context.Context, record *VoiceCloneRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := s.voiceClones[record.WorkspaceID]
	if ws == nil || ws[record.VoiceCloneID] == nil {
		return fmt.Errorf("voice clone %q not found in workspace %q", record.VoiceCloneID, record.WorkspaceID)
	}
	cp := *record
	cp.UpdatedAt = time.Now().UTC()
	ws[record.VoiceCloneID] = &cp
	return nil
}

func (s *MemoryStore) DeleteVoiceClone(ctx context.Context, workspaceID, cloneID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := s.voiceClones[workspaceID]
	if ws == nil || ws[cloneID] == nil {
		return fmt.Errorf("voice clone %q not found in workspace %q", cloneID, workspaceID)
	}
	ws[cloneID].CloneStatus = "revoked"
	ws[cloneID].UpdatedAt = time.Now().UTC()
	return nil
}

func (s *MemoryStore) ListVoiceClones(ctx context.Context, workspaceID, characterID string, limit, offset int) ([]*VoiceCloneRecord, int64, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.voiceClones[workspaceID]
	if ws == nil {
		return []*VoiceCloneRecord{}, 0, nil
	}

	var matched []*VoiceCloneRecord
	for _, vc := range ws {
		if vc.CloneStatus == "revoked" {
			continue
		}
		if characterID != "" && vc.CharacterID != characterID {
			continue
		}
		cp := *vc
		matched = append(matched, &cp)
	}

	total := int64(len(matched))
	if offset < 0 {
		offset = 0
	}
	if offset >= len(matched) {
		return []*VoiceCloneRecord{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(matched) {
		end = len(matched)
	}
	return matched[offset:end], total, nil
}

// ----------------------------------------------------------------------------
// Sound Tracks implementation (P4-06)
// ----------------------------------------------------------------------------

func (s *MemoryStore) CreateSoundTrack(ctx context.Context, track *SoundTrack) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.soundTracks[track.WorkspaceID] == nil {
		s.soundTracks[track.WorkspaceID] = make(map[string]*SoundTrack)
	}
	cp := *track
	s.soundTracks[track.WorkspaceID][track.TrackID] = &cp
	return nil
}

func (s *MemoryStore) GetSoundTrack(ctx context.Context, workspaceID, trackID string) (*SoundTrack, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.soundTracks[workspaceID]
	if ws == nil {
		return nil, fmt.Errorf("sound track %q not found in workspace %q", trackID, workspaceID)
	}
	tr, ok := ws[trackID]
	if !ok {
		return nil, fmt.Errorf("sound track %q not found in workspace %q", trackID, workspaceID)
	}
	cp := *tr
	return &cp, nil
}

func (s *MemoryStore) ListSoundTracks(ctx context.Context, workspaceID, category, genre, mood string, limit, offset int) ([]*SoundTrack, int64, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.soundTracks[workspaceID]
	if ws == nil {
		return []*SoundTrack{}, 0, nil
	}

	var matched []*SoundTrack
	for _, tr := range ws {
		if category != "" && tr.Category != category {
			continue
		}
		if genre != "" && tr.Genre != genre {
			continue
		}
		if mood != "" && tr.Mood != mood {
			continue
		}
		cp := *tr
		matched = append(matched, &cp)
	}

	total := int64(len(matched))
	if offset < 0 {
		offset = 0
	}
	if offset >= len(matched) {
		return []*SoundTrack{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(matched) {
		end = len(matched)
	}
	return matched[offset:end], total, nil
}

// Style Pack Store Implementation

func (s *MemoryStore) CreateStylePack(ctx context.Context, pack *StylePackRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.stylePacks[pack.WorkspaceID] == nil {
		s.stylePacks[pack.WorkspaceID] = make(map[string]*StylePackRecord)
	}
	cp := *pack
	s.stylePacks[pack.WorkspaceID][pack.StylePackID] = &cp
	return nil
}

func (s *MemoryStore) GetStylePack(ctx context.Context, workspaceID, packID string) (*StylePackRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.stylePacks[workspaceID]
	if ws == nil {
		return nil, ErrStylePackNotFound
	}
	p, ok := ws[packID]
	if !ok || p.DeletedAt != nil {
		return nil, ErrStylePackNotFound
	}
	cp := *p
	return &cp, nil
}

func (s *MemoryStore) ListStylePacks(ctx context.Context, workspaceID string, limit, offset int) ([]*StylePackRecord, int64, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.stylePacks[workspaceID]
	if ws == nil {
		return []*StylePackRecord{}, 0, nil
	}

	var active []*StylePackRecord
	for _, p := range ws {
		if p.DeletedAt == nil && p.IsActive {
			cp := *p
			active = append(active, &cp)
		}
	}

	total := int64(len(active))
	if offset < 0 {
		offset = 0
	}
	if offset >= len(active) {
		return []*StylePackRecord{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(active) {
		end = len(active)
	}
	return active[offset:end], total, nil
}

func (s *MemoryStore) UpdateStylePack(ctx context.Context, pack *StylePackRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.stylePacks[pack.WorkspaceID] == nil {
		return ErrStylePackNotFound
	}
	if _, ok := s.stylePacks[pack.WorkspaceID][pack.StylePackID]; !ok {
		return ErrStylePackNotFound
	}
	cp := *pack
	s.stylePacks[pack.WorkspaceID][pack.StylePackID] = &cp
	return nil
}

func (s *MemoryStore) DeleteStylePack(ctx context.Context, workspaceID, packID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := s.stylePacks[workspaceID]
	if ws == nil {
		return ErrStylePackNotFound
	}
	p, ok := ws[packID]
	if !ok || p.DeletedAt != nil {
		return ErrStylePackNotFound
	}
	now := time.Now().UTC()
	p.DeletedAt = &now
	p.IsActive = false
	return nil
}

// Continuity Violation Store Implementation

func (s *MemoryStore) CreateContinuityViolation(ctx context.Context, v *ContinuityViolationRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.violations[v.WorkspaceID] == nil {
		s.violations[v.WorkspaceID] = make(map[string]*ContinuityViolationRecord)
	}
	cp := *v
	s.violations[v.WorkspaceID][v.ViolationID] = &cp
	return nil
}

func (s *MemoryStore) GetContinuityViolation(ctx context.Context, workspaceID, violationID string) (*ContinuityViolationRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.violations[workspaceID]
	if ws == nil {
		return nil, ErrViolationNotFound
	}
	v, ok := ws[violationID]
	if !ok {
		return nil, ErrViolationNotFound
	}
	cp := *v
	return &cp, nil
}

func (s *MemoryStore) ResolveContinuityViolation(ctx context.Context, workspaceID, violationID, resolvedBy, overrideReason string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := s.violations[workspaceID]
	if ws == nil {
		return ErrViolationNotFound
	}
	v, ok := ws[violationID]
	if !ok {
		return ErrViolationNotFound
	}
	now := time.Now().UTC()
	v.Resolved = true
	v.ResolvedBy = resolvedBy
	v.ResolvedAt = &now
	v.OverrideReason = overrideReason
	return nil
}

func (s *MemoryStore) ListContinuityViolations(ctx context.Context, workspaceID, assetID string) ([]*ContinuityViolationRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.violations[workspaceID]
	if ws == nil {
		return []*ContinuityViolationRecord{}, nil
	}

	var matched []*ContinuityViolationRecord
	for _, v := range ws {
		if assetID == "" || v.AssetID == assetID {
			cp := *v
			matched = append(matched, &cp)
		}
	}
	return matched, nil
}

// Characters & Consent Store Implementation

func (s *MemoryStore) SaveCharacter(ctx context.Context, char *ProductionCharacter) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.characters[char.WorkspaceID] == nil {
		s.characters[char.WorkspaceID] = make(map[string]*ProductionCharacter)
	}
	cp := *char
	s.characters[char.WorkspaceID][char.CharacterID] = &cp
	return nil
}

func (s *MemoryStore) GetCharacter(ctx context.Context, workspaceID, characterID string) (*ProductionCharacter, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.characters[workspaceID]
	if ws == nil {
		return nil, fmt.Errorf("character %q not found in workspace %q", characterID, workspaceID)
	}
	c, ok := ws[characterID]
	if !ok {
		return nil, fmt.Errorf("character %q not found in workspace %q", characterID, workspaceID)
	}
	cp := *c
	return &cp, nil
}

func (s *MemoryStore) SaveConsentRecord(ctx context.Context, cr *ProductionConsentRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.consents[cr.WorkspaceID] == nil {
		s.consents[cr.WorkspaceID] = make(map[string]*ProductionConsentRecord)
	}
	cp := *cr
	s.consents[cr.WorkspaceID][cr.ConsentID] = &cp
	return nil
}

func (s *MemoryStore) GetConsentRecord(ctx context.Context, workspaceID, consentID string) (*ProductionConsentRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.consents[workspaceID]
	if ws == nil {
		return nil, fmt.Errorf("consent record %q not found in workspace %q", consentID, workspaceID)
	}
	cr, ok := ws[consentID]
	if !ok {
		return nil, fmt.Errorf("consent record %q not found in workspace %q", consentID, workspaceID)
	}
	cp := *cr
	return &cp, nil
}

func (s *MemoryStore) RevokeConsentRecord(ctx context.Context, workspaceID, consentID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := s.consents[workspaceID]
	if ws == nil {
		return fmt.Errorf("consent record %q not found in workspace %q", consentID, workspaceID)
	}
	cr, ok := ws[consentID]
	if !ok {
		return fmt.Errorf("consent record %q not found in workspace %q", consentID, workspaceID)
	}
	now := time.Now().UTC()
	cr.Granted = false
	cr.RevokedAt = &now

	// Cascade revocation to any characters in workspace referencing this consent record
	if chars := s.characters[workspaceID]; chars != nil {
		for _, c := range chars {
			if c.ConsentRecordID == consentID {
				c.ConsentVerified = false
				c.Status = "archived"
			}
		}
	}
	return nil
}

