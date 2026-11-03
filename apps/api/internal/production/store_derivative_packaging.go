package production

import (
	"context"
	"strings"
	"time"
)

// ----------------------------------------------------------------------------
// Derivatives Storage Methods (M09, P4-08)
// ----------------------------------------------------------------------------

func (s *MemoryStore) SaveDerivative(ctx context.Context, d *DerivativeRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if d.WorkspaceID == "" || d.AssetID == "" {
		return ErrCrossTenantDenied
	}
	if s.derivatives[d.WorkspaceID] == nil {
		s.derivatives[d.WorkspaceID] = make(map[string]*DerivativeRecord)
	}

	clone := *d
	if clone.CreatedAt.IsZero() {
		clone.CreatedAt = time.Now().UTC()
	}
	clone.UpdatedAt = time.Now().UTC()
	s.derivatives[d.WorkspaceID][d.AssetID] = &clone
	return nil
}

func (s *MemoryStore) GetDerivative(ctx context.Context, workspaceID, assetID string) (*DerivativeRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsMap, ok := s.derivatives[workspaceID]
	if !ok {
		return nil, ErrDerivativeNotFound
	}
	d, ok := wsMap[assetID]
	if !ok || d.DeletedAt != nil {
		return nil, ErrDerivativeNotFound
	}
	clone := *d
	return &clone, nil
}

func (s *MemoryStore) ListDerivatives(ctx context.Context, workspaceID, sourceAssetID, derivativeType, targetChannel, status string, limit, offset int) ([]*DerivativeRecord, int64, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsMap, ok := s.derivatives[workspaceID]
	if !ok {
		return []*DerivativeRecord{}, 0, nil
	}

	var matched []*DerivativeRecord
	for _, d := range wsMap {
		if d.DeletedAt != nil {
			continue
		}
		if sourceAssetID != "" && d.ParentAssetID != sourceAssetID {
			continue
		}
		if derivativeType != "" && !strings.EqualFold(d.DerivativeType, derivativeType) {
			continue
		}
		if targetChannel != "" && !strings.EqualFold(d.TargetChannel, targetChannel) {
			continue
		}
		if status != "" && !strings.EqualFold(d.QualityState, status) {
			continue
		}
		clone := *d
		matched = append(matched, &clone)
	}

	total := int64(len(matched))
	if offset < 0 {
		offset = 0
	}
	if offset >= len(matched) {
		return []*DerivativeRecord{}, total, nil
	}
	end := len(matched)
	if limit > 0 && offset+limit < end {
		end = offset + limit
	}
	return matched[offset:end], total, nil
}

func (s *MemoryStore) UpdateDerivativeTags(ctx context.Context, workspaceID, assetID string, addTags, removeTags []string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	wsMap, ok := s.derivatives[workspaceID]
	if !ok {
		return ErrDerivativeNotFound
	}
	d, ok := wsMap[assetID]
	if !ok || d.DeletedAt != nil {
		return ErrDerivativeNotFound
	}

	tagSet := make(map[string]bool)
	for _, t := range d.Tags {
		tagSet[t] = true
	}
	for _, t := range addTags {
		trimmed := strings.TrimSpace(t)
		if trimmed != "" {
			tagSet[trimmed] = true
		}
	}
	for _, t := range removeTags {
		delete(tagSet, strings.TrimSpace(t))
	}

	var newTags []string
	for t := range tagSet {
		newTags = append(newTags, t)
	}
	d.Tags = newTags
	d.UpdatedAt = time.Now().UTC()
	return nil
}

func (s *MemoryStore) DeleteDerivative(ctx context.Context, workspaceID, assetID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	wsMap, ok := s.derivatives[workspaceID]
	if !ok {
		return ErrDerivativeNotFound
	}
	d, ok := wsMap[assetID]
	if !ok || d.DeletedAt != nil {
		return ErrDerivativeNotFound
	}
	now := time.Now().UTC()
	d.DeletedAt = &now
	d.UpdatedAt = now
	return nil
}

func (s *MemoryStore) GetLineageChain(ctx context.Context, workspaceID, assetID string) ([]*DerivativeRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsMap, ok := s.derivatives[workspaceID]
	if !ok {
		return nil, ErrDerivativeNotFound
	}

	var chain []*DerivativeRecord
	currID := assetID
	visited := make(map[string]bool)

	for currID != "" && !visited[currID] {
		visited[currID] = true
		d, ok := wsMap[currID]
		if !ok {
			break
		}
		clone := *d
		chain = append([]*DerivativeRecord{&clone}, chain...)
		currID = d.ParentAssetID
	}
	return chain, nil
}

func (s *MemoryStore) GetDerivativeChildren(ctx context.Context, workspaceID, parentAssetID string) ([]*DerivativeRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsMap, ok := s.derivatives[workspaceID]
	if !ok {
		return []*DerivativeRecord{}, nil
	}

	var children []*DerivativeRecord
	for _, d := range wsMap {
		if d.DeletedAt != nil {
			continue
		}
		if d.ParentAssetID == parentAssetID {
			clone := *d
			children = append(children, &clone)
		}
	}
	return children, nil
}

// ----------------------------------------------------------------------------
// Packaging QA Storage Methods (M10, P4-08)
// ----------------------------------------------------------------------------

func (s *MemoryStore) SaveQAResult(ctx context.Context, r *PackagingQAItem) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if r.WorkspaceID == "" || r.ReportID == "" {
		return ErrCrossTenantDenied
	}
	if s.qaResults[r.WorkspaceID] == nil {
		s.qaResults[r.WorkspaceID] = make(map[string]*PackagingQAItem)
	}

	clone := *r
	if clone.CreatedAt.IsZero() {
		clone.CreatedAt = time.Now().UTC()
	}
	clone.UpdatedAt = time.Now().UTC()
	s.qaResults[r.WorkspaceID][r.ReportID] = &clone
	return nil
}

func (s *MemoryStore) GetQAResult(ctx context.Context, workspaceID, assetID, publishItemID string) (*PackagingQAItem, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsMap, ok := s.qaResults[workspaceID]
	if !ok {
		return nil, ErrPackagingReportNotFound
	}

	// Look up by publishItemID or latest for assetID
	var latest *PackagingQAItem
	for _, r := range wsMap {
		if r.DeletedAt != nil {
			continue
		}
		if publishItemID != "" && r.PublishItemID == publishItemID {
			clone := *r
			return &clone, nil
		}
		if r.AssetID == assetID {
			if latest == nil || r.CreatedAt.After(latest.CreatedAt) {
				latest = r
			}
		}
	}
	if latest == nil {
		return nil, ErrPackagingReportNotFound
	}
	clone := *latest
	return &clone, nil
}

func (s *MemoryStore) ListQAResults(ctx context.Context, workspaceID, assetID string, limit, offset int) ([]*PackagingQAItem, int64, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsMap, ok := s.qaResults[workspaceID]
	if !ok {
		return []*PackagingQAItem{}, 0, nil
	}

	var matched []*PackagingQAItem
	for _, r := range wsMap {
		if r.DeletedAt != nil {
			continue
		}
		if assetID != "" && r.AssetID != assetID {
			continue
		}
		clone := *r
		matched = append(matched, &clone)
	}

	total := int64(len(matched))
	if offset < 0 {
		offset = 0
	}
	if offset >= len(matched) {
		return []*PackagingQAItem{}, total, nil
	}
	end := len(matched)
	if limit > 0 && offset+limit < end {
		end = offset + limit
	}
	return matched[offset:end], total, nil
}

func (s *MemoryStore) UpdateQAResultOverrides(ctx context.Context, workspaceID, qaResultID string, override *OverrideRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	wsMap, ok := s.qaResults[workspaceID]
	if !ok {
		return ErrPackagingReportNotFound
	}
	r, ok := wsMap[qaResultID]
	if !ok || r.DeletedAt != nil {
		return ErrPackagingReportNotFound
	}

	r.AppliedOverrides = append(r.AppliedOverrides, override)
	r.UpdatedAt = time.Now().UTC()
	return nil
}

// ----------------------------------------------------------------------------
// Presets Storage Methods (M10, P4-08)
// ----------------------------------------------------------------------------

func (s *MemoryStore) SavePreset(ctx context.Context, p *UploadPresetRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if p.WorkspaceID == "" || p.PresetID == "" {
		return ErrCrossTenantDenied
	}
	if s.presets[p.WorkspaceID] == nil {
		s.presets[p.WorkspaceID] = make(map[string]*UploadPresetRecord)
	}

	clone := *p
	if clone.CreatedAt.IsZero() {
		clone.CreatedAt = time.Now().UTC()
	}
	clone.UpdatedAt = time.Now().UTC()
	s.presets[p.WorkspaceID][p.PresetID] = &clone
	return nil
}

func (s *MemoryStore) GetPreset(ctx context.Context, workspaceID, presetID string) (*UploadPresetRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsMap, ok := s.presets[workspaceID]
	if !ok {
		return nil, ErrPresetNotFound
	}
	p, ok := wsMap[presetID]
	if !ok || p.DeletedAt != nil {
		return nil, ErrPresetNotFound
	}
	clone := *p
	return &clone, nil
}

func (s *MemoryStore) ListPresets(ctx context.Context, workspaceID, targetPlatform string) ([]*UploadPresetRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsMap, ok := s.presets[workspaceID]
	if !ok {
		return []*UploadPresetRecord{}, nil
	}

	var matched []*UploadPresetRecord
	for _, p := range wsMap {
		if p.DeletedAt != nil {
			continue
		}
		if targetPlatform != "" && !strings.EqualFold(p.TargetPlatform, targetPlatform) {
			continue
		}
		clone := *p
		matched = append(matched, &clone)
	}
	return matched, nil
}

// ----------------------------------------------------------------------------
// A/B Experiments Storage Methods (§22.9, M10, P4-08)
// ----------------------------------------------------------------------------

func (s *MemoryStore) SaveExperiment(ctx context.Context, exp *ABExperimentRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if exp.WorkspaceID == "" || exp.ExperimentID == "" {
		return ErrCrossTenantDenied
	}
	if s.experiments[exp.WorkspaceID] == nil {
		s.experiments[exp.WorkspaceID] = make(map[string]*ABExperimentRecord)
	}

	clone := *exp
	if clone.CreatedAt.IsZero() {
		clone.CreatedAt = time.Now().UTC()
	}
	clone.UpdatedAt = time.Now().UTC()
	s.experiments[exp.WorkspaceID][exp.ExperimentID] = &clone
	return nil
}

func (s *MemoryStore) GetExperiment(ctx context.Context, workspaceID, experimentID string) (*ABExperimentRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsMap, ok := s.experiments[workspaceID]
	if !ok {
		return nil, ErrExperimentNotFound
	}
	exp, ok := wsMap[experimentID]
	if !ok || exp.DeletedAt != nil {
		return nil, ErrExperimentNotFound
	}
	clone := *exp
	return &clone, nil
}

func (s *MemoryStore) ListExperiments(ctx context.Context, workspaceID, sourceAssetID string) ([]*ABExperimentRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsMap, ok := s.experiments[workspaceID]
	if !ok {
		return []*ABExperimentRecord{}, nil
	}

	var matched []*ABExperimentRecord
	for _, exp := range wsMap {
		if exp.DeletedAt != nil {
			continue
		}
		if sourceAssetID != "" && exp.SourceAssetID != sourceAssetID {
			continue
		}
		clone := *exp
		matched = append(matched, &clone)
	}
	return matched, nil
}

func (s *MemoryStore) UpdateExperiment(ctx context.Context, exp *ABExperimentRecord) error {
	return s.SaveExperiment(ctx, exp)
}

// ----------------------------------------------------------------------------
// Repurpose Jobs Storage Methods (§22.13, M09, P4-08)
// ----------------------------------------------------------------------------

func (s *MemoryStore) SaveRepurposeJob(ctx context.Context, job *RepurposeJobRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	if job.WorkspaceID == "" || job.RepurposeJobID == "" {
		return ErrCrossTenantDenied
	}
	if s.repurposeJobs[job.WorkspaceID] == nil {
		s.repurposeJobs[job.WorkspaceID] = make(map[string]*RepurposeJobRecord)
	}

	clone := *job
	if clone.CreatedAt.IsZero() {
		clone.CreatedAt = time.Now().UTC()
	}
	clone.UpdatedAt = time.Now().UTC()
	s.repurposeJobs[job.WorkspaceID][job.RepurposeJobID] = &clone
	return nil
}

func (s *MemoryStore) GetRepurposeJob(ctx context.Context, workspaceID, jobID string) (*RepurposeJobRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsMap, ok := s.repurposeJobs[workspaceID]
	if !ok {
		return nil, ErrJobNotFound
	}
	job, ok := wsMap[jobID]
	if !ok || job.DeletedAt != nil {
		return nil, ErrJobNotFound
	}
	clone := *job
	return &clone, nil
}

func (s *MemoryStore) UpdateRepurposeJob(ctx context.Context, job *RepurposeJobRecord) error {
	return s.SaveRepurposeJob(ctx, job)
}
