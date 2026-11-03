package continuity

import (
	"context"
	"fmt"
	"sync"
	"time"

	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
)

// Store provides tenant-isolated, thread-safe persistence for characters, packs, and consent.
type Store interface {
	// Character operations
	CreateCharacter(ctx context.Context, char *CharacterDomain, pack *ContinuityPackDomain) (*CharacterDomain, *ContinuityPackDomain, error)
	GetCharacter(ctx context.Context, workspaceID, characterID string) (*CharacterDomain, error)
	ListCharacters(ctx context.Context, workspaceID string, statusFilter contentv1.CharacterStatus) ([]*CharacterDomain, int, int, error)
	UpdateCharacter(ctx context.Context, char *CharacterDomain) (*CharacterDomain, error)
	DeleteCharacter(ctx context.Context, workspaceID, characterID string, hardDelete bool) (contentv1.CharacterStatus, error)
	SetDefaultCharacter(ctx context.Context, workspaceID, characterID string) (*CharacterDomain, error)

	// Continuity pack operations
	CreatePack(ctx context.Context, pack *ContinuityPackDomain) (*ContinuityPackDomain, error)
	GetPack(ctx context.Context, workspaceID, packID string) (*ContinuityPackDomain, []*PackVersionDomain, error)
	UpdatePack(ctx context.Context, workspaceID, packID, name, rulesSummary, settingsJSON, allowedScopeJSON string, refs []*contentv1.ApprovedReference, status contentv1.PackStatus, reason string) (*ContinuityPackDomain, *PackVersionDomain, error)
	ClonePack(ctx context.Context, workspaceID, sourcePackID, newName string) (*ContinuityPackDomain, error)
	DeletePack(ctx context.Context, workspaceID, packID string) error
	ListPacks(ctx context.Context, workspaceID string, packType contentv1.PackType) ([]*ContinuityPackDomain, error)
	GetPackUsageStats(ctx context.Context, workspaceID, packID string) (int, int, []string, error)

	// Consent operations
	GrantConsent(ctx context.Context, record *ConsentRecordDomain) (*ConsentRecordDomain, error)
	RevokeConsent(ctx context.Context, userID, workspaceID, consentType string) (*ConsentRecordDomain, int, error)
	GetConsent(ctx context.Context, workspaceID, consentID string) (*ConsentRecordDomain, error)
	CheckGenerationConsent(ctx context.Context, workspaceID, characterID string) (*CharacterDomain, error)

	// Workspace tier config (for slot gating)
	SetWorkspaceTier(workspaceID, tier string)
	GetWorkspaceTier(workspaceID string) string
}

// MemoryStore is an in-memory implementation of Store adhering to all multi-tenant invariants.
type MemoryStore struct {
	mu             sync.RWMutex
	characters     map[string]map[string]*CharacterDomain      // workspaceID -> characterID -> character
	packs          map[string]map[string]*ContinuityPackDomain // workspaceID -> packID -> pack
	packVersions   map[string]map[string][]*PackVersionDomain  // workspaceID -> packID -> versions
	consents       map[string]map[string]*ConsentRecordDomain  // workspaceID -> consentID -> consent
	workspaceTiers map[string]string                           // workspaceID -> tier
	packAssetUsage map[string][]string                         // packID -> assetIDs
	packViolations map[string]int                              // packID -> count
}

// NewMemoryStore initializes an empty memory store.
func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		characters:     make(map[string]map[string]*CharacterDomain),
		packs:          make(map[string]map[string]*ContinuityPackDomain),
		packVersions:   make(map[string]map[string][]*PackVersionDomain),
		consents:       make(map[string]map[string]*ConsentRecordDomain),
		workspaceTiers: make(map[string]string),
		packAssetUsage: make(map[string][]string),
		packViolations: make(map[string]int),
	}
}

func (s *MemoryStore) SetWorkspaceTier(workspaceID, tier string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.workspaceTiers[workspaceID] = tier
}

func (s *MemoryStore) GetWorkspaceTier(workspaceID string) string {
	s.mu.RLock()
	defer s.mu.RUnlock()
	if tier, exists := s.workspaceTiers[workspaceID]; exists {
		return tier
	}
	return "free"
}

func cloneCharacter(c *CharacterDomain) *CharacterDomain {
	if c == nil {
		return nil
	}
	cp := *c
	return &cp
}

func clonePack(p *ContinuityPackDomain) *ContinuityPackDomain {
	if p == nil {
		return nil
	}
	cp := *p
	return &cp
}

func cloneVersion(v *PackVersionDomain) *PackVersionDomain {
	if v == nil {
		return nil
	}
	cp := *v
	return &cp
}

func cloneConsent(c *ConsentRecordDomain) *ConsentRecordDomain {
	if c == nil {
		return nil
	}
	cp := *c
	return &cp
}

// CreateCharacter implements RULE-M08-001 (wizard), RULE-M08-003 (slot quota),
// RULE-M08-004 (auto-create Character Pack), and RULE-M08-006 (single default character).
func (s *MemoryStore) CreateCharacter(ctx context.Context, char *CharacterDomain, pack *ContinuityPackDomain) (*CharacterDomain, *ContinuityPackDomain, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := char.WorkspaceID
	if ws == "" {
		return nil, nil, ErrUnauthenticated
	}

	// 1. Enforce Tier Character Slot Quota (RULE-M08-003, AC-M08-008)
	tier := s.workspaceTiers[ws]
	if tier == "" {
		tier = "free"
	}
	quota := GetSlotQuota(tier)

	wsChars := s.characters[ws]
	if wsChars == nil {
		wsChars = make(map[string]*CharacterDomain)
		s.characters[ws] = wsChars
	}

	activeCount := 0
	for _, c := range wsChars {
		if c.DeletedAt == nil && c.Status != contentv1.CharacterStatus_CHARACTER_STATUS_ARCHIVED {
			activeCount++
		}
	}

	if quota != SlotQuotaEnterprise && activeCount >= quota {
		return nil, nil, fmt.Errorf("%w: current limit %d for plan %s (active: %d)", ErrSlotQuotaExceeded, quota, tier, activeCount)
	}

	// 2. Acceptance Target 3: Exactly one default character per workspace (RULE-M08-006)
	if char.IsDefault {
		for _, existing := range wsChars {
			if existing.DeletedAt == nil {
				existing.IsDefault = false
			}
		}
	} else if activeCount == 0 {
		// If this is the very first character in the workspace, make it default automatically
		char.IsDefault = true
	}

	// 3. Auto-create canonical Character Pack (RULE-M08-004, AC-M08-002)
	now := time.Now().UTC()
	char.CreatedAt = now
	char.UpdatedAt = now

	if pack == nil {
		pack = &ContinuityPackDomain{
			PackID:      fmt.Sprintf("cp-%s", char.CharacterID),
			WorkspaceID: ws,
			PackType:    contentv1.PackType_PACK_TYPE_CHARACTER,
			Name:        fmt.Sprintf("%s Character Pack", char.Name),
			CharacterID: char.CharacterID,
			Version:     1,
			Status:      contentv1.PackStatus_PACK_STATUS_ACTIVE,
			CreatedAt:   now,
			UpdatedAt:   now,
		}
	}
	pack.CharacterID = char.CharacterID
	pack.PackType = contentv1.PackType_PACK_TYPE_CHARACTER
	char.CharacterPackID = pack.PackID

	wsPacks := s.packs[ws]
	if wsPacks == nil {
		wsPacks = make(map[string]*ContinuityPackDomain)
		s.packs[ws] = wsPacks
	}
	wsPacks[pack.PackID] = pack

	// Record initial pack version lineage (RULE-M08-007)
	wsVersions := s.packVersions[ws]
	if wsVersions == nil {
		wsVersions = make(map[string][]*PackVersionDomain)
		s.packVersions[ws] = wsVersions
	}
	initialVersion := &PackVersionDomain{
		VersionID:           fmt.Sprintf("v1-%s", pack.PackID),
		WorkspaceID:         ws,
		PackID:              pack.PackID,
		VersionIndex:        1,
		Name:                pack.Name,
		PackType:            pack.PackType,
		ApprovedReferences:  pack.ApprovedReferences,
		RulesSummary:        pack.RulesSummary,
		SettingsJSON:        pack.SettingsJSON,
		AllowedUseScopeJSON: pack.AllowedUseScopeJSON,
		Status:              pack.Status,
		SnapshotReason:      "initial_creation",
		CreatedAt:           now,
	}
	wsVersions[pack.PackID] = append(wsVersions[pack.PackID], initialVersion)

	wsChars[char.CharacterID] = char
	return cloneCharacter(char), clonePack(pack), nil
}

func (s *MemoryStore) GetCharacter(ctx context.Context, workspaceID, characterID string) (*CharacterDomain, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsChars, exists := s.characters[workspaceID]
	if !exists {
		return nil, ErrCharacterNotFound
	}
	char, exists := wsChars[characterID]
	if !exists || char.DeletedAt != nil {
		return nil, ErrCharacterNotFound
	}
	return cloneCharacter(char), nil
}

func (s *MemoryStore) ListCharacters(ctx context.Context, workspaceID string, statusFilter contentv1.CharacterStatus) ([]*CharacterDomain, int, int, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsChars, exists := s.characters[workspaceID]
	if !exists {
		tier := s.workspaceTiers[workspaceID]
		if tier == "" {
			tier = "free"
		}
		return []*CharacterDomain{}, 0, GetSlotQuota(tier), nil
	}

	tier := s.workspaceTiers[workspaceID]
	if tier == "" {
		tier = "free"
	}
	quota := GetSlotQuota(tier)

	var result []*CharacterDomain
	activeCount := 0
	for _, c := range wsChars {
		if c.DeletedAt != nil {
			continue
		}
		if c.Status != contentv1.CharacterStatus_CHARACTER_STATUS_ARCHIVED {
			activeCount++
		}
		if statusFilter == contentv1.CharacterStatus_CHARACTER_STATUS_UNSPECIFIED || c.Status == statusFilter {
			result = append(result, cloneCharacter(c))
		}
	}
	return result, activeCount, quota, nil
}

func (s *MemoryStore) UpdateCharacter(ctx context.Context, char *CharacterDomain) (*CharacterDomain, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := char.WorkspaceID
	wsChars, exists := s.characters[ws]
	if !exists {
		return nil, ErrCharacterNotFound
	}
	existing, exists := wsChars[char.CharacterID]
	if !exists || existing.DeletedAt != nil {
		return nil, ErrCharacterNotFound
	}

	// Acceptance Target 3: If setting to default, unset all others
	if char.IsDefault && !existing.IsDefault {
		for _, c := range wsChars {
			if c.DeletedAt == nil {
				c.IsDefault = false
			}
		}
	}

	existing.Name = char.Name
	existing.Description = char.Description
	existing.ReferenceImagesJSON = char.ReferenceImagesJSON
	existing.VoiceSettingsJSON = char.VoiceSettingsJSON
	existing.VisualSettingsJSON = char.VisualSettingsJSON
	existing.IsDefault = char.IsDefault
	if char.Status != contentv1.CharacterStatus_CHARACTER_STATUS_UNSPECIFIED {
		existing.Status = char.Status
	}
	existing.UpdatedAt = time.Now().UTC()

	return cloneCharacter(existing), nil
}

// DeleteCharacter archives or soft-deletes a character, freeing up a character slot (A4, RULE-M08-003).
func (s *MemoryStore) DeleteCharacter(ctx context.Context, workspaceID, characterID string, hardDelete bool) (contentv1.CharacterStatus, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	wsChars, exists := s.characters[workspaceID]
	if !exists {
		return contentv1.CharacterStatus_CHARACTER_STATUS_UNSPECIFIED, ErrCharacterNotFound
	}
	existing, exists := wsChars[characterID]
	if !exists || existing.DeletedAt != nil {
		return contentv1.CharacterStatus_CHARACTER_STATUS_UNSPECIFIED, ErrCharacterNotFound
	}

	now := time.Now().UTC()
	if hardDelete {
		existing.DeletedAt = &now
		if existing.IsDefault {
			existing.IsDefault = false
		}
		return contentv1.CharacterStatus_CHARACTER_STATUS_UNSPECIFIED, nil
	}

	// Soft delete / Archival (frees slot)
	existing.Status = contentv1.CharacterStatus_CHARACTER_STATUS_ARCHIVED
	existing.UpdatedAt = now
	if existing.IsDefault {
		existing.IsDefault = false
	}
	return existing.Status, nil
}

// SetDefaultCharacter satisfies Acceptance Target 3: Exactly one default character.
func (s *MemoryStore) SetDefaultCharacter(ctx context.Context, workspaceID, characterID string) (*CharacterDomain, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	wsChars, exists := s.characters[workspaceID]
	if !exists {
		return nil, ErrCharacterNotFound
	}
	target, exists := wsChars[characterID]
	if !exists || target.DeletedAt != nil {
		return nil, ErrCharacterNotFound
	}

	for _, c := range wsChars {
		if c.DeletedAt == nil {
			c.IsDefault = false
		}
	}
	target.IsDefault = true
	target.UpdatedAt = time.Now().UTC()
	return cloneCharacter(target), nil
}

// CreatePack creates a new continuity pack.
func (s *MemoryStore) CreatePack(ctx context.Context, pack *ContinuityPackDomain) (*ContinuityPackDomain, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := pack.WorkspaceID
	wsPacks := s.packs[ws]
	if wsPacks == nil {
		wsPacks = make(map[string]*ContinuityPackDomain)
		s.packs[ws] = wsPacks
	}

	now := time.Now().UTC()
	pack.CreatedAt = now
	pack.UpdatedAt = now
	pack.Version = 1
	wsPacks[pack.PackID] = pack

	// Save initial version
	wsVersions := s.packVersions[ws]
	if wsVersions == nil {
		wsVersions = make(map[string][]*PackVersionDomain)
		s.packVersions[ws] = wsVersions
	}
	wsVersions[pack.PackID] = append(wsVersions[pack.PackID], &PackVersionDomain{
		VersionID:           fmt.Sprintf("v1-%s", pack.PackID),
		WorkspaceID:         ws,
		PackID:              pack.PackID,
		VersionIndex:        1,
		Name:                pack.Name,
		PackType:            pack.PackType,
		ApprovedReferences:  pack.ApprovedReferences,
		RulesSummary:        pack.RulesSummary,
		SettingsJSON:        pack.SettingsJSON,
		AllowedUseScopeJSON: pack.AllowedUseScopeJSON,
		Status:              pack.Status,
		SnapshotReason:      "create",
		CreatedAt:           now,
	})

	return clonePack(pack), nil
}

func (s *MemoryStore) GetPack(ctx context.Context, workspaceID, packID string) (*ContinuityPackDomain, []*PackVersionDomain, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsPacks, exists := s.packs[workspaceID]
	if !exists {
		return nil, nil, ErrPackNotFound
	}
	pack, exists := wsPacks[packID]
	if !exists || pack.DeletedAt != nil {
		return nil, nil, ErrPackNotFound
	}
	versions := s.packVersions[workspaceID][packID]
	var cpVersions []*PackVersionDomain
	for _, v := range versions {
		cpVersions = append(cpVersions, cloneVersion(v))
	}
	return clonePack(pack), cpVersions, nil
}

// UpdatePack satisfies Acceptance Target 2: Pack updates retain old lineage.
// It snapshots the previous pack state into an immutable version record, then increments version to version+1.
func (s *MemoryStore) UpdatePack(ctx context.Context, workspaceID, packID, name, rulesSummary, settingsJSON, allowedScopeJSON string, refs []*contentv1.ApprovedReference, status contentv1.PackStatus, reason string) (*ContinuityPackDomain, *PackVersionDomain, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	wsPacks, exists := s.packs[workspaceID]
	if !exists {
		return nil, nil, ErrPackNotFound
	}
	pack, exists := wsPacks[packID]
	if !exists || pack.DeletedAt != nil {
		return nil, nil, ErrPackNotFound
	}

	now := time.Now().UTC()

	// Snapshot old version before mutating (Acceptance Target 2)
	oldVersion := pack.Version
	archivedVersion := &PackVersionDomain{
		VersionID:           fmt.Sprintf("v%d-%s-%d", oldVersion, packID, now.UnixNano()),
		WorkspaceID:         workspaceID,
		PackID:              packID,
		VersionIndex:        oldVersion,
		Name:                pack.Name,
		PackType:            pack.PackType,
		ApprovedReferences:  pack.ApprovedReferences,
		RulesSummary:        pack.RulesSummary,
		SettingsJSON:        pack.SettingsJSON,
		AllowedUseScopeJSON: pack.AllowedUseScopeJSON,
		Status:              contentv1.PackStatus_PACK_STATUS_DEPRECATED,
		SnapshotReason:      reason,
		CreatedAt:           now,
	}

	wsVersions := s.packVersions[workspaceID]
	if wsVersions == nil {
		wsVersions = make(map[string][]*PackVersionDomain)
		s.packVersions[workspaceID] = wsVersions
	}
	wsVersions[packID] = append(wsVersions[packID], archivedVersion)

	// Increment version and update current pack
	pack.Version = oldVersion + 1
	if name != "" {
		pack.Name = name
	}
	if rulesSummary != "" {
		pack.RulesSummary = rulesSummary
	}
	if settingsJSON != "" {
		pack.SettingsJSON = settingsJSON
	}
	if allowedScopeJSON != "" {
		pack.AllowedUseScopeJSON = allowedScopeJSON
	}
	if refs != nil {
		pack.ApprovedReferences = refs
	}
	if status != contentv1.PackStatus_PACK_STATUS_UNSPECIFIED {
		pack.Status = status
	}
	pack.UpdatedAt = now

	return clonePack(pack), cloneVersion(archivedVersion), nil
}

func (s *MemoryStore) ClonePack(ctx context.Context, workspaceID, sourcePackID, newName string) (*ContinuityPackDomain, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	wsPacks, exists := s.packs[workspaceID]
	if !exists {
		return nil, ErrPackNotFound
	}
	source, exists := wsPacks[sourcePackID]
	if !exists || source.DeletedAt != nil {
		return nil, ErrPackNotFound
	}

	now := time.Now().UTC()
	cloneID := fmt.Sprintf("cp-clone-%d", now.UnixNano())
	clone := &ContinuityPackDomain{
		PackID:              cloneID,
		WorkspaceID:         workspaceID,
		PackType:            source.PackType,
		Name:                newName,
		CharacterID:         source.CharacterID,
		ApprovedReferences:  source.ApprovedReferences,
		RulesSummary:        source.RulesSummary,
		SettingsJSON:        source.SettingsJSON,
		AllowedUseScopeJSON: source.AllowedUseScopeJSON,
		Version:             1,
		ParentPackID:        sourcePackID,
		Status:              contentv1.PackStatus_PACK_STATUS_DRAFT,
		CreatedAt:           now,
		UpdatedAt:           now,
	}
	wsPacks[cloneID] = clone
	return clonePack(clone), nil
}

func (s *MemoryStore) DeletePack(ctx context.Context, workspaceID, packID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	wsPacks, exists := s.packs[workspaceID]
	if !exists {
		return ErrPackNotFound
	}
	pack, exists := wsPacks[packID]
	if !exists || pack.DeletedAt != nil {
		return ErrPackNotFound
	}
	now := time.Now().UTC()
	pack.DeletedAt = &now
	pack.Status = contentv1.PackStatus_PACK_STATUS_RETIRED
	return nil
}

func (s *MemoryStore) ListPacks(ctx context.Context, workspaceID string, packType contentv1.PackType) ([]*ContinuityPackDomain, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsPacks, exists := s.packs[workspaceID]
	if !exists {
		return []*ContinuityPackDomain{}, nil
	}

	var result []*ContinuityPackDomain
	for _, p := range wsPacks {
		if p.DeletedAt != nil {
			continue
		}
		if packType == contentv1.PackType_PACK_TYPE_UNSPECIFIED || p.PackType == packType {
			result = append(result, clonePack(p))
		}
	}
	return result, nil
}

func (s *MemoryStore) GetPackUsageStats(ctx context.Context, workspaceID, packID string) (int, int, []string, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	assets := s.packAssetUsage[packID]
	violations := s.packViolations[packID]
	return len(assets), violations, assets, nil
}

func (s *MemoryStore) RecordPackAssetUsage(packID, assetID string, driftSeverity contentv1.DriftSeverity) {
	s.mu.Lock()
	defer s.mu.Unlock()

	s.packAssetUsage[packID] = append(s.packAssetUsage[packID], assetID)
	if driftSeverity == contentv1.DriftSeverity_DRIFT_SEVERITY_MODERATE || driftSeverity == contentv1.DriftSeverity_DRIFT_SEVERITY_HIGH {
		s.packViolations[packID]++
	}
}

// GrantConsent records consent and links to user/workspace (RULE-M08-002, database_schema.md §18.3).
func (s *MemoryStore) GrantConsent(ctx context.Context, record *ConsentRecordDomain) (*ConsentRecordDomain, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	ws := record.WorkspaceID
	wsConsents := s.consents[ws]
	if wsConsents == nil {
		wsConsents = make(map[string]*ConsentRecordDomain)
		s.consents[ws] = wsConsents
	}

	now := time.Now().UTC()
	record.CreatedAt = now
	record.Granted = true
	record.GrantedAt = &now
	record.RevokedAt = nil
	wsConsents[record.ConsentID] = record

	return cloneConsent(record), nil
}

// RevokeConsent satisfies Acceptance Target 1: Revoked consent blocks generation.
// It marks the consent record revoked and automatically un-verifies all characters linked to this consent record or user.
func (s *MemoryStore) RevokeConsent(ctx context.Context, userID, workspaceID, consentType string) (*ConsentRecordDomain, int, error) {
	s.mu.Lock()
	defer s.mu.Unlock()

	wsConsents, exists := s.consents[workspaceID]
	if !exists {
		return nil, 0, ErrConsentNotFound
	}

	now := time.Now().UTC()
	var revokedRecord *ConsentRecordDomain

	for _, c := range wsConsents {
		if c.UserID == userID && (consentType == "" || fmt.Sprintf("%v", c.ConsentType) == consentType || consentType == "digital_twin") {
			c.Granted = false
			c.RevokedAt = &now
			revokedRecord = c
		}
	}

	if revokedRecord == nil {
		return nil, 0, ErrConsentNotFound
	}

	// Disable/un-verify all digital twin characters relying on this consent
	disabledCount := 0
	if wsChars, exists := s.characters[workspaceID]; exists {
		for _, char := range wsChars {
			if char.CharacterType == contentv1.CharacterType_CHARACTER_TYPE_DIGITAL_TWIN {
				if char.ConsentRecordID == revokedRecord.ConsentID || char.ConsentRecordID == "" {
					char.ConsentVerified = false
					char.UpdatedAt = now
					disabledCount++
				}
			}
		}
	}

	return cloneConsent(revokedRecord), disabledCount, nil
}

func (s *MemoryStore) GetConsent(ctx context.Context, workspaceID, consentID string) (*ConsentRecordDomain, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsConsents, exists := s.consents[workspaceID]
	if !exists {
		return nil, ErrConsentNotFound
	}
	record, exists := wsConsents[consentID]
	if !exists {
		return nil, ErrConsentNotFound
	}
	return cloneConsent(record), nil
}

// CheckGenerationConsent verifies likeness consent before AI generation (Acceptance Target 1).
func (s *MemoryStore) CheckGenerationConsent(ctx context.Context, workspaceID, characterID string) (*CharacterDomain, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	wsChars, exists := s.characters[workspaceID]
	if !exists {
		return nil, ErrCharacterNotFound
	}
	char, exists := wsChars[characterID]
	if !exists || char.DeletedAt != nil {
		return nil, ErrCharacterNotFound
	}

	// Only digital_twin characters require consent verification (RULE-M08-002)
	if char.CharacterType == contentv1.CharacterType_CHARACTER_TYPE_DIGITAL_TWIN {
		if !char.ConsentVerified {
			return nil, ErrConsentNotVerified
		}

		if char.ConsentRecordID != "" {
			if wsConsents, ok := s.consents[workspaceID]; ok {
				if consent, ok := wsConsents[char.ConsentRecordID]; ok {
					if !consent.Granted || consent.RevokedAt != nil {
						return nil, ErrConsentRevoked
					}
				} else {
					return nil, ErrConsentNotFound
				}
			}
		}
	}

	return cloneCharacter(char), nil
}
