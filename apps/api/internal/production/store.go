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

	CreateTranscript(ctx context.Context, t *TranscriptRecord) error
	GetTranscript(ctx context.Context, workspaceID, transcriptID string) (*TranscriptRecord, error)
	GetTranscriptByAsset(ctx context.Context, workspaceID, assetID string) (*TranscriptRecord, error)
	UpdateTranscript(ctx context.Context, t *TranscriptRecord) error

	SaveQuickEditDraft(ctx context.Context, draft *QuickEditDraftRecord) error
	GetQuickEditDraft(ctx context.Context, workspaceID, draftID string) (*QuickEditDraftRecord, error)

	CreateSoundRecord(ctx context.Context, track *SoundTrackRecord) error
	GetSoundRecord(ctx context.Context, workspaceID, soundID string) (*SoundTrackRecord, error)
	ListSoundRecords(ctx context.Context, workspaceID, genre string, royaltyFreeOnly bool, limit, offset int) ([]*SoundTrackRecord, int64, error)

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
}

// MemoryStore provides a thread-safe, tenant-isolated in-memory store for production.
type MemoryStore struct {
	mu           sync.RWMutex
	assets       map[string]map[string]*Asset                // workspaceID -> assetID -> Asset
	jobs         map[string]map[string]*GenerationJob        // workspaceID -> jobID -> GenerationJob
	uploads      map[string]map[string]*FileUpload           // workspaceID -> uploadID -> FileUpload
	transcripts  map[string]map[string]*TranscriptRecord     // workspaceID -> transcriptID -> TranscriptRecord
	drafts       map[string]map[string]*QuickEditDraftRecord // workspaceID -> draftID -> QuickEditDraftRecord
	sounds       map[string]map[string]*SoundTrackRecord     // workspaceID ("" for global) -> soundID -> SoundTrackRecord
	blueprints   map[string]map[string]*RemixBlueprint       // workspaceID -> blueprintID -> RemixBlueprint
	videoJobs    map[string]map[string]*VideoEditJobRecord   // workspaceID -> jobID -> VideoEditJobRecord
	translations map[string]map[string]*TranslationJob       // workspaceID -> jobID -> TranslationJob
	voiceClones  map[string]map[string]*VoiceCloneRecord     // workspaceID -> cloneID -> VoiceCloneRecord
	soundTracks  map[string]map[string]*SoundTrack           // workspaceID -> trackID -> SoundTrack
}

// NewMemoryStore constructs a new MemoryStore.
func NewMemoryStore() *MemoryStore {
	ms := &MemoryStore{
		assets:       make(map[string]map[string]*Asset),
		jobs:         make(map[string]map[string]*GenerationJob),
		uploads:      make(map[string]map[string]*FileUpload),
		transcripts:  make(map[string]map[string]*TranscriptRecord),
		drafts:       make(map[string]map[string]*QuickEditDraftRecord),
		sounds:       make(map[string]map[string]*SoundTrackRecord),
		blueprints:   make(map[string]map[string]*RemixBlueprint),
		videoJobs:    make(map[string]map[string]*VideoEditJobRecord),
		translations: make(map[string]map[string]*TranslationJob),
		voiceClones:  make(map[string]map[string]*VoiceCloneRecord),
		soundTracks:  make(map[string]map[string]*SoundTrack),
	}
	ms.initGlobalSoundLibrary()
	return ms
}

func (s *MemoryStore) initGlobalSoundLibrary() {
	globalTracks := []*SoundTrackRecord{
		{
			SoundID:         "11111111-aaaa-1111-aaaa-111111111101",
			Title:           "Midnight Chill Lo-Fi",
			Artist:          "Nova Beats",
			Genre:           "chill",
			BPM:             85,
			DurationSeconds: 145.0,
			AudioURL:        "https://cdn.creativanta.com/audio/lofi_chill_01.mp3",
			IsRoyaltyFree:   true,
			ACRCloudCleared: true,
			LicenseType:     "commercial_royalty_free",
			Tags:            []string{"chill", "lofi", "focus", "relax"},
			CreatedAt:       time.Now().UTC(),
			UpdatedAt:       time.Now().UTC(),
		},
		{
			SoundID:         "11111111-aaaa-1111-aaaa-111111111102",
			Title:           "Neon Electric Pulse",
			Artist:          "CyberSynth",
			Genre:           "electronic",
			BPM:             128,
			DurationSeconds: 180.0,
			AudioURL:        "https://cdn.creativanta.com/audio/electronic_pulse_02.mp3",
			IsRoyaltyFree:   true,
			ACRCloudCleared: true,
			LicenseType:     "commercial_royalty_free",
			Tags:            []string{"electronic", "upbeat", "tech", "cyber"},
			CreatedAt:       time.Now().UTC(),
			UpdatedAt:       time.Now().UTC(),
		},
		{
			SoundID:         "11111111-aaaa-1111-aaaa-111111111103",
			Title:           "Upbeat Viral Groove",
			Artist:          "Sunlight Trio",
			Genre:           "upbeat",
			BPM:             120,
			DurationSeconds: 155.0,
			AudioURL:        "https://cdn.creativanta.com/audio/viral_groove_03.mp3",
			IsRoyaltyFree:   true,
			ACRCloudCleared: true,
			LicenseType:     "commercial_royalty_free",
			Tags:            []string{"upbeat", "tiktok", "trending", "happy"},
			CreatedAt:       time.Now().UTC(),
			UpdatedAt:       time.Now().UTC(),
		},
		{
			SoundID:         "11111111-aaaa-1111-aaaa-111111111104",
			Title:           "Cinematic Horizon",
			Artist:          "Epic Soundscapes",
			Genre:           "dramatic",
			BPM:             90,
			DurationSeconds: 210.0,
			AudioURL:        "https://cdn.creativanta.com/audio/cinematic_horizon_04.mp3",
			IsRoyaltyFree:   true,
			ACRCloudCleared: true,
			LicenseType:     "commercial_royalty_free",
			Tags:            []string{"dramatic", "trailer", "epic", "story"},
			CreatedAt:       time.Now().UTC(),
			UpdatedAt:       time.Now().UTC(),
		},
		{
			SoundID:         "11111111-aaaa-1111-aaaa-111111111105",
			Title:           "Warm Acoustic Morning",
			Artist:          "Elena Wood",
			Genre:           "acoustic",
			BPM:             105,
			DurationSeconds: 165.0,
			AudioURL:        "https://cdn.creativanta.com/audio/acoustic_morning_05.mp3",
			IsRoyaltyFree:   true,
			ACRCloudCleared: true,
			LicenseType:     "commercial_royalty_free",
			Tags:            []string{"acoustic", "guitar", "vlog", "warm"},
			CreatedAt:       time.Now().UTC(),
			UpdatedAt:       time.Now().UTC(),
		},
		{
			SoundID:         "11111111-aaaa-1111-aaaa-111111111106",
			Title:           "Tech Minimal Flow",
			Artist:          "Circuit Lab",
			Genre:           "tech_pulse",
			BPM:             124,
			DurationSeconds: 190.0,
			AudioURL:        "https://cdn.creativanta.com/audio/tech_minimal_06.mp3",
			IsRoyaltyFree:   true,
			ACRCloudCleared: true,
			LicenseType:     "commercial_royalty_free",
			Tags:            []string{"minimal", "tech", "modern", "clean"},
			CreatedAt:       time.Now().UTC(),
			UpdatedAt:       time.Now().UTC(),
		},
	}
	s.sounds[""] = make(map[string]*SoundTrackRecord)
	s.soundTracks[""] = make(map[string]*SoundTrack)
	for _, tr := range globalTracks {
		s.sounds[""][tr.SoundID] = tr
		s.soundTracks[""][tr.SoundID] = &SoundTrack{
			TrackID:           tr.SoundID,
			WorkspaceID:       "",
			Title:             tr.Title,
			Category:          "music",
			Genre:             tr.Genre,
			Mood:              "energetic",
			BPM:               tr.BPM,
			DurationSeconds:   tr.DurationSeconds,
			FileURL:           tr.AudioURL,
			LicenseType:       tr.LicenseType,
			LicenseID:         "LIC-CC0-GLOBAL",
			IsVerifiedLicense: true,
			WaveformPeaks:     []float32{0.2, 0.5, 0.8, 0.4},
			CreatedAt:         tr.CreatedAt,
		}
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

func (s *MemoryStore) CreateTranscript(ctx context.Context, t *TranscriptRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.transcripts[t.WorkspaceID] == nil {
		s.transcripts[t.WorkspaceID] = make(map[string]*TranscriptRecord)
	}
	cp := *t
	s.transcripts[t.WorkspaceID][t.TranscriptID] = &cp
	return nil
}

func (s *MemoryStore) GetTranscript(ctx context.Context, workspaceID, transcriptID string) (*TranscriptRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.transcripts[workspaceID]
	if ws == nil {
		return nil, ErrTranscriptNotFound
	}
	t, ok := ws[transcriptID]
	if !ok || t.DeletedAt != nil {
		return nil, ErrTranscriptNotFound
	}
	cp := *t
	return &cp, nil
}

func (s *MemoryStore) GetTranscriptByAsset(ctx context.Context, workspaceID, assetID string) (*TranscriptRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.transcripts[workspaceID]
	if ws == nil {
		return nil, ErrTranscriptNotFound
	}
	for _, t := range ws {
		if t.AssetID == assetID && t.DeletedAt == nil {
			cp := *t
			return &cp, nil
		}
	}
	return nil, ErrTranscriptNotFound
}

func (s *MemoryStore) UpdateTranscript(ctx context.Context, t *TranscriptRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := s.transcripts[t.WorkspaceID]
	if ws == nil || ws[t.TranscriptID] == nil {
		return ErrTranscriptNotFound
	}
	cp := *t
	cp.UpdatedAt = time.Now().UTC()
	ws[t.TranscriptID] = &cp
	return nil
}

func (s *MemoryStore) SaveQuickEditDraft(ctx context.Context, draft *QuickEditDraftRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if s.drafts[draft.WorkspaceID] == nil {
		s.drafts[draft.WorkspaceID] = make(map[string]*QuickEditDraftRecord)
	}
	cp := *draft
	cp.UpdatedAt = time.Now().UTC()
	s.drafts[draft.WorkspaceID][draft.DraftID] = &cp
	return nil
}

func (s *MemoryStore) GetQuickEditDraft(ctx context.Context, workspaceID, draftID string) (*QuickEditDraftRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	ws := s.drafts[workspaceID]
	if ws == nil {
		return nil, ErrDraftNotFound
	}
	d, ok := ws[draftID]
	if !ok {
		return nil, ErrDraftNotFound
	}
	cp := *d
	return &cp, nil
}

func (s *MemoryStore) CreateSoundRecord(ctx context.Context, track *SoundTrackRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	wsKey := track.WorkspaceID
	if s.sounds[wsKey] == nil {
		s.sounds[wsKey] = make(map[string]*SoundTrackRecord)
	}
	cp := *track
	s.sounds[wsKey][track.SoundID] = &cp
	return nil
}

func (s *MemoryStore) GetSoundRecord(ctx context.Context, workspaceID, soundID string) (*SoundTrackRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	// Check workspace first
	if ws := s.sounds[workspaceID]; ws != nil {
		if tr, ok := ws[soundID]; ok {
			cp := *tr
			return &cp, nil
		}
	}
	// Check global library
	if gl := s.sounds[""]; gl != nil {
		if tr, ok := gl[soundID]; ok {
			cp := *tr
			return &cp, nil
		}
	}
	return nil, ErrSoundNotFound
}

func (s *MemoryStore) ListSoundRecords(ctx context.Context, workspaceID, genre string, royaltyFreeOnly bool, limit, offset int) ([]*SoundTrackRecord, int64, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var all []*SoundTrackRecord
	seen := make(map[string]bool)

	// Collect global
	for _, tr := range s.sounds[""] {
		if genre != "" && tr.Genre != genre {
			continue
		}
		if royaltyFreeOnly && !tr.IsRoyaltyFree {
			continue
		}
		if !seen[tr.SoundID] {
			seen[tr.SoundID] = true
			cp := *tr
			all = append(all, &cp)
		}
	}

	// Collect workspace-specific
	if ws := s.sounds[workspaceID]; ws != nil {
		for _, tr := range ws {
			if genre != "" && tr.Genre != genre {
				continue
			}
			if royaltyFreeOnly && !tr.IsRoyaltyFree {
				continue
			}
			if !seen[tr.SoundID] {
				seen[tr.SoundID] = true
				cp := *tr
				all = append(all, &cp)
			}
		}
	}

	total := int64(len(all))
	if offset >= len(all) {
		return []*SoundTrackRecord{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(all) {
		end = len(all)
	}

	return all[offset:end], total, nil
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

	var matched []*SoundTrack
	seen := make(map[string]bool)

	// Include tenant tracks
	if ws := s.soundTracks[workspaceID]; ws != nil {
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
			if !seen[tr.TrackID] {
				seen[tr.TrackID] = true
				cp := *tr
				matched = append(matched, &cp)
			}
		}
	}

	// Include global library tracks
	if gl := s.soundTracks[""]; gl != nil {
		for _, tr := range gl {
			if category != "" && tr.Category != category {
				continue
			}
			if genre != "" && tr.Genre != genre {
				continue
			}
			if mood != "" && tr.Mood != mood {
				continue
			}
			if !seen[tr.TrackID] {
				seen[tr.TrackID] = true
				cp := *tr
				matched = append(matched, &cp)
			}
		}
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
