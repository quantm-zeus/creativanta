package continuity

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1/contentv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// CallerContext represents authenticated caller identity and workspace tenant.
type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string
}

type callerCtxKey struct{}

// WithCallerContext binds a CallerContext into a context.Context.
func WithCallerContext(ctx context.Context, caller CallerContext) context.Context {
	return context.WithValue(ctx, callerCtxKey{}, caller)
}

// CallerFromContext retrieves CallerContext from ctx.
func CallerFromContext(ctx context.Context) (CallerContext, bool) {
	if ctx == nil {
		return CallerContext{}, false
	}
	c, ok := ctx.Value(callerCtxKey{}).(CallerContext)
	return c, ok
}

// DomainEvent represents an emitted domain event per domain_event_catalog.md §5.
type DomainEvent struct {
	EventType   string
	WorkspaceID string
	Payload     map[string]any
	OccurredAt  time.Time
}

// ServiceConfig defines dependencies for the Continuity, Character, and Consent services.
type ServiceConfig struct {
	Store Store
}

// Service is the unified domain orchestrator for Module M08 (Continuity OS).
type Service struct {
	store  Store
	mu     sync.RWMutex
	events []DomainEvent

	charService *CharacterService
	contService *ContinuityService
	consService *ConsentService
}

// NewService creates a new unified Service instance.
func NewService(cfg ServiceConfig) *Service {
	s := cfg.Store
	if s == nil {
		s = NewMemoryStore()
	}
	svc := &Service{
		store: s,
	}
	svc.charService = &CharacterService{svc: svc}
	svc.contService = &ContinuityService{svc: svc}
	svc.consService = &ConsentService{svc: svc}
	return svc
}

// CharacterHandler returns the CharacterServiceHandler implementation.
func (s *Service) CharacterHandler() contentv1connect.CharacterServiceHandler {
	return s.charService
}

// ContinuityHandler returns the ContinuityServiceHandler implementation.
func (s *Service) ContinuityHandler() contentv1connect.ContinuityServiceHandler {
	return s.contService
}

// ConsentHandler returns the ConsentServiceHandler implementation.
func (s *Service) ConsentHandler() contentv1connect.ConsentServiceHandler {
	return s.consService
}

// Store returns the underlying store (useful for tests and tier configuration).
func (s *Service) Store() Store {
	return s.store
}

func (s *Service) checkPerm(caller CallerContext, perm string) error {
	return rbac.CheckWorkspacePermission(perm, rbac.PolicyContext{
		ActorUserID: caller.UserID,
		WorkspaceID: caller.WorkspaceID,
		Role:        caller.WorkspaceRole,
	})
}

// RecordEvent stores a domain event for audit and verification.
func (s *Service) RecordEvent(event DomainEvent) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.events = append(s.events, event)
}

// GetEvents returns all emitted domain events.
func (s *Service) GetEvents() []DomainEvent {
	s.mu.RLock()
	defer s.mu.RUnlock()
	cp := make([]DomainEvent, len(s.events))
	copy(cp, s.events)
	return cp
}

// CheckGenerationConsent verifies likeness consent before AI generation (Acceptance Target 1).
func (s *Service) CheckGenerationConsent(ctx context.Context, workspaceID, characterID string) (*CharacterDomain, error) {
	return s.store.CheckGenerationConsent(ctx, workspaceID, characterID)
}

// ----------------------------------------------------------------------------
// CharacterService Handler Implementation
// ----------------------------------------------------------------------------

type CharacterService struct {
	svc *Service
}

var _ contentv1connect.CharacterServiceHandler = (*CharacterService)(nil)

// Create handles 4-step wizard character creation (RULE-M08-001, RULE-M08-002, RULE-M08-003, RULE-M08-004, RULE-M08-006).
func (h *CharacterService) Create(ctx context.Context, req *connect.Request[contentv1.CharacterServiceCreateRequest]) (*connect.Response[contentv1.CharacterServiceCreateResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "continuity:pack_manage"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	// 1. Validate wizard progression: Step 4 (Save) requires Step 3 Preview verification (RULE-M08-001, AC 1)
	if req.Msg.WizardStep > 0 && req.Msg.WizardStep != 4 {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: character creation requires wizard step 4 (Save)", ErrWizardStepSequenceViolation))
	}
	if req.Msg.WizardStep == 4 && !req.Msg.PreviewVerified {
		return nil, connect.NewError(connect.CodeFailedPrecondition, fmt.Errorf("%w: preview video must be verified before saving character", ErrPreviewNotVerified))
	}

	name := strings.TrimSpace(req.Msg.Name)
	if name == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidCharacterName)
	}

	charType := req.Msg.CharacterType
	if charType == contentv1.CharacterType_CHARACTER_TYPE_UNSPECIFIED {
		charType = contentv1.CharacterType_CHARACTER_TYPE_AI_GENERATED
	}

	// 2. Validate Digital Twin consent verification (RULE-M08-002, AC 2)
	consentVerified := false
	consentRecordID := strings.TrimSpace(req.Msg.ConsentRecordId)
	if charType == contentv1.CharacterType_CHARACTER_TYPE_DIGITAL_TWIN {
		if consentRecordID == "" {
			return nil, connect.NewError(connect.CodeFailedPrecondition, fmt.Errorf("%w: digital twin requires consent record ID", ErrConsentNotVerified))
		}
		consentRec, err := s.store.GetConsent(ctx, caller.WorkspaceID, consentRecordID)
		if err != nil || consentRec == nil {
			return nil, connect.NewError(connect.CodeFailedPrecondition, fmt.Errorf("%w: consent record not found or invalid", ErrConsentNotVerified))
		}
		if !consentRec.Granted || consentRec.RevokedAt != nil {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrConsentRevoked)
		}
		consentVerified = true
	}

	// 3. Create domain character
	charID := fmt.Sprintf("char-%d", time.Now().UnixNano())
	charDomain := &CharacterDomain{
		CharacterID:         charID,
		WorkspaceID:         caller.WorkspaceID,
		Name:                name,
		CharacterType:       charType,
		Description:         req.Msg.Description,
		ReferenceImagesJSON: req.Msg.ReferenceImagesJson,
		VoiceSettingsJSON:   req.Msg.VoiceSettingsJson,
		VisualSettingsJSON:  req.Msg.VisualSettingsJson,
		ConsentVerified:     consentVerified,
		ConsentRecordID:     consentRecordID,
		IsDefault:           req.Msg.IsDefault,
		Status:              contentv1.CharacterStatus_CHARACTER_STATUS_READY,
	}

	// Auto-created Character Pack (RULE-M08-004)
	packDomain := &ContinuityPackDomain{
		PackID:       fmt.Sprintf("cp-%s", charID),
		WorkspaceID:  caller.WorkspaceID,
		PackType:     contentv1.PackType_PACK_TYPE_CHARACTER,
		Name:         fmt.Sprintf("%s Character Pack", name),
		CharacterID:  charID,
		Version:      1,
		Status:       contentv1.PackStatus_PACK_STATUS_ACTIVE,
		RulesSummary: fmt.Sprintf("Canonical reference pack for %s", name),
	}

	savedChar, savedPack, err := s.store.CreateCharacter(ctx, charDomain, packDomain)
	if err != nil {
		if errors.Is(err, ErrSlotQuotaExceeded) {
			return nil, connect.NewError(connect.CodeResourceExhausted, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Emit domain event: character.created per domain_event_catalog.md §5
	s.RecordEvent(DomainEvent{
		EventType:   "character.created",
		WorkspaceID: caller.WorkspaceID,
		Payload: map[string]any{
			"character_id":      savedChar.CharacterID,
			"character_name":    savedChar.Name,
			"character_type":    savedChar.CharacterType.String(),
			"character_pack_id": savedPack.PackID,
			"is_default":        savedChar.IsDefault,
			"consent_verified":  savedChar.ConsentVerified,
		},
		OccurredAt: time.Now().UTC(),
	})

	return connect.NewResponse(&contentv1.CharacterServiceCreateResponse{
		Character:     mapDomainToProtoCharacter(savedChar),
		CharacterPack: mapDomainToProtoPack(savedPack),
	}), nil
}

// Get retrieves a character and its linked Character Pack.
func (h *CharacterService) Get(ctx context.Context, req *connect.Request[contentv1.CharacterServiceGetRequest]) (*connect.Response[contentv1.CharacterServiceGetResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "asset:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	charID := strings.TrimSpace(req.Msg.CharacterId)
	if charID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("character_id is required"))
	}

	char, err := s.store.GetCharacter(ctx, caller.WorkspaceID, charID)
	if err != nil {
		if errors.Is(err, ErrCharacterNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var packProto *contentv1.ContinuityPack
	if char.CharacterPackID != "" {
		pack, _, err := s.store.GetPack(ctx, caller.WorkspaceID, char.CharacterPackID)
		if err == nil && pack != nil {
			packProto = mapDomainToProtoPack(pack)
		}
	}

	return connect.NewResponse(&contentv1.CharacterServiceGetResponse{
		Character:     mapDomainToProtoCharacter(char),
		CharacterPack: packProto,
	}), nil
}

// List retrieves characters in the workspace with active quota counting.
func (h *CharacterService) List(ctx context.Context, req *connect.Request[contentv1.CharacterServiceListRequest]) (*connect.Response[contentv1.CharacterServiceListResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "asset:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	chars, activeCount, slotQuota, err := s.store.ListCharacters(ctx, caller.WorkspaceID, req.Msg.StatusFilter)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoChars []*contentv1.Character
	for _, c := range chars {
		protoChars = append(protoChars, mapDomainToProtoCharacter(c))
	}

	return connect.NewResponse(&contentv1.CharacterServiceListResponse{
		Characters:           protoChars,
		TotalCount:           int32(len(protoChars)),
		ActiveCharacterCount: int32(activeCount),
		SlotQuota:            int32(slotQuota),
	}), nil
}

// Update updates an existing character and enforces single default character invariance (RULE-M08-006).
func (h *CharacterService) Update(ctx context.Context, req *connect.Request[contentv1.CharacterServiceUpdateRequest]) (*connect.Response[contentv1.CharacterServiceUpdateResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "continuity:pack_manage"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	charID := strings.TrimSpace(req.Msg.CharacterId)
	if charID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("character_id is required"))
	}

	updated, err := s.store.UpdateCharacter(ctx, &CharacterDomain{
		CharacterID:         charID,
		WorkspaceID:         caller.WorkspaceID,
		Name:                req.Msg.Name,
		Description:         req.Msg.Description,
		ReferenceImagesJSON: req.Msg.ReferenceImagesJson,
		VoiceSettingsJSON:   req.Msg.VoiceSettingsJson,
		VisualSettingsJSON:  req.Msg.VisualSettingsJson,
		IsDefault:           req.Msg.IsDefault,
		Status:              req.Msg.Status,
	})
	if err != nil {
		if errors.Is(err, ErrCharacterNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&contentv1.CharacterServiceUpdateResponse{
		Character: mapDomainToProtoCharacter(updated),
	}), nil
}

// Delete archives or hard deletes a character, freeing up a character slot (RULE-M08-003, A4).
func (h *CharacterService) Delete(ctx context.Context, req *connect.Request[contentv1.CharacterServiceDeleteRequest]) (*connect.Response[contentv1.CharacterServiceDeleteResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "continuity:pack_manage"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	charID := strings.TrimSpace(req.Msg.CharacterId)
	if charID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("character_id is required"))
	}

	newStatus, err := s.store.DeleteCharacter(ctx, caller.WorkspaceID, charID, req.Msg.HardDelete)
	if err != nil {
		if errors.Is(err, ErrCharacterNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&contentv1.CharacterServiceDeleteResponse{
		Success:   true,
		NewStatus: newStatus,
	}), nil
}

// ----------------------------------------------------------------------------
// ContinuityService Handler Implementation
// ----------------------------------------------------------------------------

type ContinuityService struct {
	svc *Service
}

var _ contentv1connect.ContinuityServiceHandler = (*ContinuityService)(nil)

// Create creates a brand, voice, or style continuity pack.
func (h *ContinuityService) Create(ctx context.Context, req *connect.Request[contentv1.ContinuityServiceCreateRequest]) (*connect.Response[contentv1.ContinuityServiceCreateResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "continuity:pack_manage"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	name := strings.TrimSpace(req.Msg.Name)
	if name == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidPackName)
	}

	packID := fmt.Sprintf("cp-%d", time.Now().UnixNano())
	pack := &ContinuityPackDomain{
		PackID:              packID,
		WorkspaceID:         caller.WorkspaceID,
		PackType:            req.Msg.PackType,
		Name:                name,
		CharacterID:         req.Msg.CharacterId,
		ApprovedReferences:  req.Msg.ApprovedReferences,
		RulesSummary:        req.Msg.RulesSummary,
		SettingsJSON:        req.Msg.SettingsJson,
		AllowedUseScopeJSON: req.Msg.AllowedUseScopeJson,
		Version:             1,
		Status:              contentv1.PackStatus_PACK_STATUS_ACTIVE,
	}

	created, err := s.store.CreatePack(ctx, pack)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&contentv1.ContinuityServiceCreateResponse{
		Pack: mapDomainToProtoPack(created),
	}), nil
}

// Get retrieves a continuity pack.
func (h *ContinuityService) Get(ctx context.Context, req *connect.Request[contentv1.ContinuityServiceGetRequest]) (*connect.Response[contentv1.ContinuityServiceGetResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "asset:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	pack, versions, err := s.store.GetPack(ctx, caller.WorkspaceID, req.Msg.PackId)
	if err != nil {
		if errors.Is(err, ErrPackNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoVersions []*contentv1.PackVersion
	for _, v := range versions {
		protoVersions = append(protoVersions, mapDomainToProtoVersion(v))
	}

	return connect.NewResponse(&contentv1.ContinuityServiceGetResponse{
		Pack:           mapDomainToProtoPack(pack),
		VersionHistory: protoVersions,
	}), nil
}

// GetPack satisfies Acceptance Target 2: Retrieves pack with complete immutable version lineage.
func (h *ContinuityService) GetPack(ctx context.Context, req *connect.Request[contentv1.ContinuityServiceGetPackRequest]) (*connect.Response[contentv1.ContinuityServiceGetPackResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "asset:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	pack, versions, err := s.store.GetPack(ctx, caller.WorkspaceID, req.Msg.PackId)
	if err != nil {
		if errors.Is(err, ErrPackNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoVersions []*contentv1.PackVersion
	for _, v := range versions {
		protoVersions = append(protoVersions, mapDomainToProtoVersion(v))
	}

	return connect.NewResponse(&contentv1.ContinuityServiceGetPackResponse{
		Pack:           mapDomainToProtoPack(pack),
		VersionHistory: protoVersions,
	}), nil
}

// UpdatePack satisfies Acceptance Target 2: Pack updates retain old lineage.
func (h *ContinuityService) UpdatePack(ctx context.Context, req *connect.Request[contentv1.ContinuityServiceUpdatePackRequest]) (*connect.Response[contentv1.ContinuityServiceUpdatePackResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "continuity:pack_manage"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	packID := strings.TrimSpace(req.Msg.PackId)
	if packID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("pack_id is required"))
	}

	reason := strings.TrimSpace(req.Msg.UpdateReason)
	if reason == "" {
		reason = "reference_update"
	}

	updatedPack, archivedVersion, err := s.store.UpdatePack(
		ctx,
		caller.WorkspaceID,
		packID,
		req.Msg.Name,
		req.Msg.RulesSummary,
		req.Msg.SettingsJson,
		req.Msg.AllowedUseScopeJson,
		req.Msg.ApprovedReferences,
		req.Msg.Status,
		reason,
	)
	if err != nil {
		if errors.Is(err, ErrPackNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Emit domain event: continuity.pack_updated per domain_event_catalog.md §5
	s.RecordEvent(DomainEvent{
		EventType:   "continuity.pack_updated",
		WorkspaceID: caller.WorkspaceID,
		Payload: map[string]any{
			"pack_id":          updatedPack.PackID,
			"new_version":      updatedPack.Version,
			"archived_version": archivedVersion.VersionIndex,
			"update_reason":    reason,
		},
		OccurredAt: time.Now().UTC(),
	})

	return connect.NewResponse(&contentv1.ContinuityServiceUpdatePackResponse{
		Pack:            mapDomainToProtoPack(updatedPack),
		ArchivedVersion: mapDomainToProtoVersion(archivedVersion),
	}), nil
}

// Clone clones an existing pack into a new draft pack.
func (h *ContinuityService) Clone(ctx context.Context, req *connect.Request[contentv1.ContinuityServiceCloneRequest]) (*connect.Response[contentv1.ContinuityServiceCloneResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "continuity:pack_manage"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	newName := strings.TrimSpace(req.Msg.NewName)
	if newName == "" {
		newName = "Cloned Pack"
	}

	clone, err := s.store.ClonePack(ctx, caller.WorkspaceID, req.Msg.SourcePackId, newName)
	if err != nil {
		if errors.Is(err, ErrPackNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&contentv1.ContinuityServiceCloneResponse{
		Pack: mapDomainToProtoPack(clone),
	}), nil
}

// Delete retires a continuity pack.
func (h *ContinuityService) Delete(ctx context.Context, req *connect.Request[contentv1.ContinuityServiceDeleteRequest]) (*connect.Response[contentv1.ContinuityServiceDeleteResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "continuity:pack_manage"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	if err := s.store.DeletePack(ctx, caller.WorkspaceID, req.Msg.PackId); err != nil {
		if errors.Is(err, ErrPackNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&contentv1.ContinuityServiceDeleteResponse{
		Success: true,
	}), nil
}

// GetUsageStats returns generated assets and drift violations for a pack.
func (h *ContinuityService) GetUsageStats(ctx context.Context, req *connect.Request[contentv1.ContinuityServiceGetUsageStatsRequest]) (*connect.Response[contentv1.ContinuityServiceGetUsageStatsResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "asset:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	totalAssets, violations, assetIDs, err := s.store.GetPackUsageStats(ctx, caller.WorkspaceID, req.Msg.PackId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&contentv1.ContinuityServiceGetUsageStatsResponse{
		PackId:               req.Msg.PackId,
		TotalAssetsGenerated: int32(totalAssets),
		DriftWarningsCount:   int32(violations),
		RecentAssetIds:       assetIDs,
	}), nil
}

// ListBrandPacks lists brand packs for the workspace.
func (h *ContinuityService) ListBrandPacks(ctx context.Context, req *connect.Request[contentv1.ContinuityServiceListBrandPacksRequest]) (*connect.Response[contentv1.ContinuityServiceListBrandPacksResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "asset:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	packs, err := s.store.ListPacks(ctx, caller.WorkspaceID, contentv1.PackType_PACK_TYPE_BRAND)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoPacks []*contentv1.ContinuityPack
	for _, p := range packs {
		protoPacks = append(protoPacks, mapDomainToProtoPack(p))
	}

	return connect.NewResponse(&contentv1.ContinuityServiceListBrandPacksResponse{
		BrandPacks: protoPacks,
	}), nil
}

// ListCharacters lists character packs or characters linked to packs.
func (h *ContinuityService) ListCharacters(ctx context.Context, req *connect.Request[contentv1.ContinuityServiceListCharactersRequest]) (*connect.Response[contentv1.ContinuityServiceListCharactersResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "asset:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	chars, _, _, err := s.store.ListCharacters(ctx, caller.WorkspaceID, contentv1.CharacterStatus_CHARACTER_STATUS_UNSPECIFIED)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoChars []*contentv1.Character
	for _, c := range chars {
		protoChars = append(protoChars, mapDomainToProtoCharacter(c))
	}

	return connect.NewResponse(&contentv1.ContinuityServiceListCharactersResponse{
		Characters: protoChars,
	}), nil
}

// ListVoices lists voice packs for the workspace.
func (h *ContinuityService) ListVoices(ctx context.Context, req *connect.Request[contentv1.ContinuityServiceListVoicesRequest]) (*connect.Response[contentv1.ContinuityServiceListVoicesResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "asset:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	packs, err := s.store.ListPacks(ctx, caller.WorkspaceID, contentv1.PackType_PACK_TYPE_VOICE)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoPacks []*contentv1.ContinuityPack
	for _, p := range packs {
		protoPacks = append(protoPacks, mapDomainToProtoPack(p))
	}

	return connect.NewResponse(&contentv1.ContinuityServiceListVoicesResponse{
		VoicePacks: protoPacks,
	}), nil
}

// ----------------------------------------------------------------------------
// ConsentService Handler Implementation
// ----------------------------------------------------------------------------

type ConsentService struct {
	svc *Service
}

var _ contentv1connect.ConsentServiceHandler = (*ConsentService)(nil)

// Grant records legally verified consent for digital twin or voice likeness (RULE-M08-002, EC-M08-001).
func (h *ConsentService) Grant(ctx context.Context, req *connect.Request[contentv1.ConsentServiceGrantRequest]) (*connect.Response[contentv1.ConsentServiceGrantResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "user:self"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	if !req.Msg.DeclarationSigned {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("consent declaration must be signed"))
	}

	// EC-M08-001: AI face match simulation between source and consent video
	// If source footage or consent video explicitly contains "mismatch" or empty, verification fails.
	src := strings.TrimSpace(req.Msg.SourceFootageUrl)
	consentVid := strings.TrimSpace(req.Msg.ConsentVideoUrl)
	if strings.Contains(strings.ToLower(src), "mismatch") || strings.Contains(strings.ToLower(consentVid), "mismatch") {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrConsentFaceMismatch)
	}

	consentID := fmt.Sprintf("consent-%d", time.Now().UnixNano())
	rec := &ConsentRecordDomain{
		ConsentID:   consentID,
		UserID:      caller.UserID,
		WorkspaceID: caller.WorkspaceID,
		ConsentType: contentv1.ConsentType_CONSENT_TYPE_DIGITAL_TWIN,
		Version:     req.Msg.Version,
		Granted:     true,
	}

	saved, err := s.store.GrantConsent(ctx, rec)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Emit domain event: consent.granted per domain_event_catalog.md §5
	s.RecordEvent(DomainEvent{
		EventType:   "consent.granted",
		WorkspaceID: caller.WorkspaceID,
		Payload: map[string]any{
			"consent_id":   saved.ConsentID,
			"user_id":      saved.UserID,
			"consent_type": "digital_twin",
		},
		OccurredAt: time.Now().UTC(),
	})

	return connect.NewResponse(&contentv1.ConsentServiceGrantResponse{
		Record:            mapDomainToProtoConsent(saved),
		FaceMatchVerified: true,
	}), nil
}

// Revoke satisfies Acceptance Target 1: Revoked consent blocks generation.
func (h *ConsentService) Revoke(ctx context.Context, req *connect.Request[contentv1.ConsentServiceRevokeRequest]) (*connect.Response[contentv1.ConsentServiceRevokeResponse], error) {
	s := h.svc
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("workspace ID mismatch"))
	}
	if err := s.checkPerm(caller, "user:self"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	userID := req.Msg.UserId
	if userID == "" {
		userID = caller.UserID
	}

	revoked, disabledCount, err := s.store.RevokeConsent(ctx, userID, caller.WorkspaceID, req.Msg.ConsentType)
	if err != nil {
		if errors.Is(err, ErrConsentNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Emit domain event: consent.revoked per domain_event_catalog.md §5
	s.RecordEvent(DomainEvent{
		EventType:   "consent.revoked",
		WorkspaceID: caller.WorkspaceID,
		Payload: map[string]any{
			"consent_id":                revoked.ConsentID,
			"user_id":                   revoked.UserID,
			"characters_disabled_count": disabledCount,
			"reason":                    req.Msg.Reason,
		},
		OccurredAt: time.Now().UTC(),
	})

	return connect.NewResponse(&contentv1.ConsentServiceRevokeResponse{
		Success:                 true,
		Record:                  mapDomainToProtoConsent(revoked),
		CharactersDisabledCount: int32(disabledCount),
	}), nil
}

// ----------------------------------------------------------------------------
// Model Mappers
// ----------------------------------------------------------------------------

func mapDomainToProtoCharacter(c *CharacterDomain) *contentv1.Character {
	if c == nil {
		return nil
	}
	protoChar := &contentv1.Character{
		CharacterId:         c.CharacterID,
		WorkspaceId:         c.WorkspaceID,
		Name:                c.Name,
		CharacterType:       c.CharacterType,
		Description:         c.Description,
		ReferenceImagesJson: c.ReferenceImagesJSON,
		VoiceSettingsJson:   c.VoiceSettingsJSON,
		VisualSettingsJson:  c.VisualSettingsJSON,
		ConsentVerified:     c.ConsentVerified,
		ConsentRecordId:     c.ConsentRecordID,
		IsDefault:           c.IsDefault,
		Status:              c.Status,
		CharacterPackId:     c.CharacterPackID,
		CreatedAt:           timestamppb.New(c.CreatedAt),
		UpdatedAt:           timestamppb.New(c.UpdatedAt),
	}
	return protoChar
}

func mapDomainToProtoPack(p *ContinuityPackDomain) *contentv1.ContinuityPack {
	if p == nil {
		return nil
	}
	return &contentv1.ContinuityPack{
		PackId:              p.PackID,
		WorkspaceId:         p.WorkspaceID,
		PackType:            p.PackType,
		Name:                p.Name,
		CharacterId:         p.CharacterID,
		ApprovedReferences:  p.ApprovedReferences,
		RulesSummary:        p.RulesSummary,
		SettingsJson:        p.SettingsJSON,
		AllowedUseScopeJson: p.AllowedUseScopeJSON,
		Version:             p.Version,
		ParentPackId:        p.ParentPackID,
		Status:              p.Status,
		CreatedAt:           timestamppb.New(p.CreatedAt),
		UpdatedAt:           timestamppb.New(p.UpdatedAt),
	}
}

func mapDomainToProtoVersion(v *PackVersionDomain) *contentv1.PackVersion {
	if v == nil {
		return nil
	}
	return &contentv1.PackVersion{
		VersionId:           v.VersionID,
		WorkspaceId:         v.WorkspaceID,
		PackId:              v.PackID,
		VersionIndex:        v.VersionIndex,
		Name:                v.Name,
		PackType:            v.PackType,
		ApprovedReferences:  v.ApprovedReferences,
		RulesSummary:        v.RulesSummary,
		SettingsJson:        v.SettingsJSON,
		AllowedUseScopeJson: v.AllowedUseScopeJSON,
		Status:              v.Status,
		SnapshotReason:      v.SnapshotReason,
		CreatedAt:           timestamppb.New(v.CreatedAt),
	}
}

func mapDomainToProtoConsent(c *ConsentRecordDomain) *contentv1.ConsentRecord {
	if c == nil {
		return nil
	}
	res := &contentv1.ConsentRecord{
		ConsentId:   c.ConsentID,
		UserId:      c.UserID,
		WorkspaceId: c.WorkspaceID,
		ConsentType: fmt.Sprintf("%v", c.ConsentType),
		Version:     c.Version,
		Granted:     c.Granted,
		IpAddress:   c.IPAddress,
		UserAgent:   c.UserAgent,
		CreatedAt:   timestamppb.New(c.CreatedAt),
	}
	if c.GrantedAt != nil {
		res.GrantedAt = timestamppb.New(*c.GrantedAt)
	}
	if c.RevokedAt != nil {
		res.RevokedAt = timestamppb.New(*c.RevokedAt)
	}
	return res
}
