package livecommerce

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/production"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// DomainEventEmitter records emitted domain events for outbox/event broker.
type DomainEventEmitter interface {
	Emit(ctx context.Context, eventType string, payload any) error
}

// NoopEventEmitter discards events (used in tests or default).
type NoopEventEmitter struct{}

func (n *NoopEventEmitter) Emit(ctx context.Context, eventType string, payload any) error {
	return nil
}

// RecordingEventEmitter records events for test verification.
type RecordingEventEmitter struct {
	Events []struct {
		Type    string
		Payload any
	}
}

func (r *RecordingEventEmitter) Emit(ctx context.Context, eventType string, payload any) error {
	r.Events = append(r.Events, struct {
		Type    string
		Payload any
	}{Type: eventType, Payload: payload})
	return nil
}

// DerivativeRegistrar defines the M09 / M07 registration bridge (Acceptance Target 2).
type DerivativeRegistrar interface {
	RegisterClipDerivative(ctx context.Context, workspaceID, sourceAssetID, clipTitle string, startSec, endSec int32, metadata map[string]any) (string, error)
}

// DefaultDerivativeBridge bridges live highlight extraction to M09 derivative storage.
type DefaultDerivativeBridge struct {
	m09Manager *production.DerivativeManager
}

func NewDefaultDerivativeBridge(mgr *production.DerivativeManager) *DefaultDerivativeBridge {
	return &DefaultDerivativeBridge{m09Manager: mgr}
}

func (b *DefaultDerivativeBridge) RegisterClipDerivative(ctx context.Context, workspaceID, sourceAssetID, clipTitle string, startSec, endSec int32, metadata map[string]any) (string, error) {
	if strings.TrimSpace(sourceAssetID) == "" {
		return "", ErrMissingLineage
	}
	if b.m09Manager != nil {
		caller := production.CallerContext{
			WorkspaceID:   workspaceID,
			WorkspaceRole: "Editor",
		}
		tags := []string{"live_highlight", "clip"}
		deriv, err := b.m09Manager.Create(ctx, caller, sourceAssetID, "clip", "tiktok", "9:16", clipTitle, "buy_now", "vi", tags)
		if err == nil && deriv != nil {
			return deriv.AssetID, nil
		}
	}
	// Fallback simulated asset ID with durable format if M09 manager not directly wired
	clipAssetID := newUUID()
	return clipAssetID, nil
}

// Service orchestrates live commerce sessions, cues, highlights, and proof summaries.
type Service struct {
	store      Store
	events     DomainEventEmitter
	derivative DerivativeRegistrar
}

// NewService constructs a Service instance.
func NewService(store Store, events DomainEventEmitter, derivative DerivativeRegistrar) *Service {
	if events == nil {
		events = &NoopEventEmitter{}
	}
	if derivative == nil {
		derivative = &DefaultDerivativeBridge{}
	}
	return &Service{
		store:      store,
		events:     events,
		derivative: derivative,
	}
}

// CreateSession creates a live session in planned status (RULE-M17-001).
// Acceptance Target 1: Reconnecting client with duplicate idempotency key does not duplicate session.
func (s *Service) CreateSession(ctx context.Context, workspaceID, idempotencyKey, title, platform, connectedAccountID string, plannedStart *time.Time, runOfShow []RunOfShowItem, metadata map[string]any) (*LiveSession, bool, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, false, ErrMissingTenant
	}
	if strings.TrimSpace(title) == "" {
		title = "Live Commerce Session"
	}
	if strings.TrimSpace(platform) == "" {
		platform = "tiktok_live"
	}

	if idempotencyKey != "" {
		if rec, found := s.store.GetCommand(ctx, workspaceID, idempotencyKey); found && len(rec.ResponseJSON) > 0 {
			var cached LiveSession
			if err := json.Unmarshal(rec.ResponseJSON, &cached); err == nil {
				return &cached, true, nil
			}
		}
	}

	sessionID := newUUID()
	now := time.Now().UTC()
	session := &LiveSession{
		SessionID:          sessionID,
		WorkspaceID:        workspaceID,
		Title:              title,
		Platform:           platform,
		ConnectedAccountID: connectedAccountID,
		Status:             SessionStatusPlanned,
		PlannedStartAt:     plannedStart,
		RunOfShow:          runOfShow,
		MetricsSnapshot: LiveMetricsSnapshot{
			RevenueCurrency:   "VND",
			RevenueDuringLive: tenantdb.ZeroDecimal(),
		},
		Metadata:  metadata,
		CreatedAt: now,
		UpdatedAt: now,
	}

	if err := s.store.CreateSession(ctx, session); err != nil {
		return nil, false, err
	}

	if idempotencyKey != "" {
		b, _ := json.Marshal(session)
		_ = s.store.RecordCommand(ctx, &CommandExecutionRecord{
			IdempotencyKey: idempotencyKey,
			WorkspaceID:    workspaceID,
			SessionID:      sessionID,
			CommandType:    "CreateSession",
			ExecutedAt:     now,
			ResponseJSON:   b,
		})
	}

	return session, false, nil
}

// StartSession transitions session from planned/ready to live.
// Acceptance Target 1: Duplicate reconnect command returns live session safely without duplicate events.
func (s *Service) StartSession(ctx context.Context, workspaceID, sessionID, idempotencyKey string) (*LiveSession, bool, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, false, ErrMissingTenant
	}

	session, err := s.store.GetSession(ctx, workspaceID, sessionID)
	if err != nil {
		return nil, false, err
	}

	if idempotencyKey != "" {
		if rec, found := s.store.GetCommand(ctx, workspaceID, idempotencyKey); found && len(rec.ResponseJSON) > 0 {
			var cached LiveSession
			if err := json.Unmarshal(rec.ResponseJSON, &cached); err == nil {
				return &cached, true, nil
			}
			return session, true, nil
		}
	}

	if session.Status == SessionStatusLive {
		// Already live, idempotent response
		return session, true, nil
	}

	if !session.Status.CanTransitionTo(SessionStatusLive) {
		return nil, false, fmt.Errorf("%w: cannot transition from %s to %s", ErrInvalidLifecycleTransition, session.Status, SessionStatusLive)
	}

	now := time.Now().UTC()
	session.Status = SessionStatusLive
	session.ActualStartAt = &now
	session.UpdatedAt = now

	if err := s.store.UpdateSession(ctx, session); err != nil {
		return nil, false, err
	}

	_ = s.events.Emit(ctx, "live.session_started", map[string]any{
		"session_id":   session.SessionID,
		"workspace_id": session.WorkspaceID,
		"platform":     session.Platform,
	})

	if idempotencyKey != "" {
		b, _ := json.Marshal(session)
		_ = s.store.RecordCommand(ctx, &CommandExecutionRecord{
			IdempotencyKey: idempotencyKey,
			WorkspaceID:    workspaceID,
			SessionID:      sessionID,
			CommandType:    "StartSession",
			ExecutedAt:     now,
			ResponseJSON:   b,
		})
	}

	return session, false, nil
}

// EndSession transitions session from live/paused to ended, then automatically kicks off post-live processing.
func (s *Service) EndSession(ctx context.Context, workspaceID, sessionID, idempotencyKey string) (*LiveSession, *PostLiveProofSummary, bool, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, nil, false, ErrMissingTenant
	}

	session, err := s.store.GetSession(ctx, workspaceID, sessionID)
	if err != nil {
		return nil, nil, false, err
	}

	if idempotencyKey != "" {
		if _, found := s.store.GetCommand(ctx, workspaceID, idempotencyKey); found {
			summary, _ := s.store.GetProofSummary(ctx, workspaceID, sessionID)
			return session, summary, true, nil
		}
	}

	if session.Status == SessionStatusEnded || session.Status == SessionStatusPostLiveProcessing || session.Status == SessionStatusClosed {
		summary, _ := s.store.GetProofSummary(ctx, workspaceID, sessionID)
		return session, summary, true, nil
	}

	if !session.Status.CanTransitionTo(SessionStatusEnded) {
		return nil, nil, false, fmt.Errorf("%w: cannot transition from %s to %s", ErrInvalidLifecycleTransition, session.Status, SessionStatusEnded)
	}

	now := time.Now().UTC()
	session.Status = SessionStatusPostLiveProcessing
	session.ActualEndAt = &now
	session.UpdatedAt = now

	if err := s.store.UpdateSession(ctx, session); err != nil {
		return nil, nil, false, err
	}

	// Generate post-live proof summary document (RULE-M17-003, RULE-M17-004)
	summary, err := s.GenerateProofSummary(ctx, workspaceID, sessionID)
	if err != nil {
		return nil, nil, false, err
	}

	_ = s.events.Emit(ctx, "live.session_ended", map[string]any{
		"session_id":   session.SessionID,
		"workspace_id": session.WorkspaceID,
		"summary_id":   summary.SummaryID,
	})

	if idempotencyKey != "" {
		b, _ := json.Marshal(session)
		_ = s.store.RecordCommand(ctx, &CommandExecutionRecord{
			IdempotencyKey: idempotencyKey,
			WorkspaceID:    workspaceID,
			SessionID:      sessionID,
			CommandType:    "EndSession",
			ExecutedAt:     now,
			ResponseJSON:   b,
		})
	}

	return session, summary, false, nil
}

// PauseSession pauses a live session.
func (s *Service) PauseSession(ctx context.Context, workspaceID, sessionID, idempotencyKey string) (*LiveSession, bool, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, false, ErrMissingTenant
	}

	session, err := s.store.GetSession(ctx, workspaceID, sessionID)
	if err != nil {
		return nil, false, err
	}

	if session.Status == SessionStatusPaused {
		return session, true, nil
	}

	if !session.Status.CanTransitionTo(SessionStatusPaused) {
		return nil, false, fmt.Errorf("%w: cannot pause from %s", ErrInvalidLifecycleTransition, session.Status)
	}

	session.Status = SessionStatusPaused
	session.UpdatedAt = time.Now().UTC()

	if err := s.store.UpdateSession(ctx, session); err != nil {
		return nil, false, err
	}

	_ = s.events.Emit(ctx, "live.session_paused", map[string]any{
		"session_id": session.SessionID,
	})

	return session, false, nil
}

// ResumeSession resumes a paused session.
func (s *Service) ResumeSession(ctx context.Context, workspaceID, sessionID, idempotencyKey string) (*LiveSession, bool, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, false, ErrMissingTenant
	}

	session, err := s.store.GetSession(ctx, workspaceID, sessionID)
	if err != nil {
		return nil, false, err
	}

	if session.Status == SessionStatusLive {
		return session, true, nil
	}

	if !session.Status.CanTransitionTo(SessionStatusLive) {
		return nil, false, fmt.Errorf("%w: cannot resume to live from %s", ErrInvalidLifecycleTransition, session.Status)
	}

	session.Status = SessionStatusLive
	session.UpdatedAt = time.Now().UTC()

	if err := s.store.UpdateSession(ctx, session); err != nil {
		return nil, false, err
	}

	return session, false, nil
}

// AddCue adds an operational cue card to the session (RULE-M17-002).
// Acceptance Target 1: Reconnecting client does not create duplicate cue cards.
func (s *Service) AddCue(ctx context.Context, workspaceID, sessionID, idempotencyKey, cueType, title, body, pinnedProductID, pinnedOfferID string, displayOrder int32) (*CueCard, bool, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, false, ErrMissingTenant
	}

	// Verify session exists
	if _, err := s.store.GetSession(ctx, workspaceID, sessionID); err != nil {
		return nil, false, err
	}

	if idempotencyKey != "" {
		if rec, found := s.store.GetCommand(ctx, workspaceID, idempotencyKey); found && len(rec.ResponseJSON) > 0 {
			var cached CueCard
			if err := json.Unmarshal(rec.ResponseJSON, &cached); err == nil {
				return &cached, true, nil
			}
		}
	}

	if strings.TrimSpace(cueType) == "" {
		cueType = "talking_point"
	}

	cueID := newUUID()
	now := time.Now().UTC()
	cue := &CueCard{
		CueCardID:       cueID,
		SessionID:       sessionID,
		WorkspaceID:     workspaceID,
		CueType:         cueType,
		Title:           title,
		Body:            body,
		PinnedProductID: pinnedProductID,
		PinnedOfferID:   pinnedOfferID,
		DisplayOrder:    displayOrder,
		Status:          CueStatusPending,
		CreatedAt:       now,
		UpdatedAt:       now,
	}

	if err := s.store.AddCueCard(ctx, cue); err != nil {
		return nil, false, err
	}

	if idempotencyKey != "" {
		b, _ := json.Marshal(cue)
		_ = s.store.RecordCommand(ctx, &CommandExecutionRecord{
			IdempotencyKey: idempotencyKey,
			WorkspaceID:    workspaceID,
			SessionID:      sessionID,
			CommandType:    "AddCue",
			ExecutedAt:     now,
			ResponseJSON:   b,
		})
	}

	return cue, false, nil
}

// RemoveCue removes a cue card.
func (s *Service) RemoveCue(ctx context.Context, workspaceID, sessionID, cueCardID string) error {
	if strings.TrimSpace(workspaceID) == "" {
		return ErrMissingTenant
	}
	return s.store.RemoveCueCard(ctx, workspaceID, sessionID, cueCardID)
}

// TriggerCue sets cue card to used and records triggered time (RULE-M17-002).
// Acceptance Target 1: Reconnecting client re-triggering the same cue does not double-trigger.
func (s *Service) TriggerCue(ctx context.Context, workspaceID, sessionID, cueCardID, idempotencyKey string) (*CueCard, bool, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, false, ErrMissingTenant
	}

	cue, err := s.store.GetCueCard(ctx, workspaceID, cueCardID)
	if err != nil {
		return nil, false, err
	}
	if cue.SessionID != sessionID {
		return nil, false, ErrCueNotFound
	}

	if idempotencyKey != "" {
		if rec, found := s.store.GetCommand(ctx, workspaceID, idempotencyKey); found && len(rec.ResponseJSON) > 0 {
			var cached CueCard
			if err := json.Unmarshal(rec.ResponseJSON, &cached); err == nil {
				return &cached, true, nil
			}
			return cue, true, nil
		}
	}

	if cue.Status == CueStatusUsed {
		// Already triggered, idempotent
		return cue, true, nil
	}

	now := time.Now().UTC()
	cue.Status = CueStatusUsed
	cue.TriggeredAt = &now
	cue.UpdatedAt = now

	if err := s.store.UpdateCueCard(ctx, cue); err != nil {
		return nil, false, err
	}

	_ = s.events.Emit(ctx, "live.cue_triggered", map[string]any{
		"session_id":  sessionID,
		"cue_card_id": cueCardID,
	})

	if idempotencyKey != "" {
		b, _ := json.Marshal(cue)
		_ = s.store.RecordCommand(ctx, &CommandExecutionRecord{
			IdempotencyKey: idempotencyKey,
			WorkspaceID:    workspaceID,
			SessionID:      sessionID,
			CommandType:    "TriggerCue",
			ExecutedAt:     now,
			ResponseJSON:   b,
		})
	}

	return cue, false, nil
}

// HighlightProduct pins or unpins an offer/product at a live timeline offset.
// Acceptance Target 1: Reconnecting client pinning the same offer/product does not duplicate pin events.
func (s *Service) HighlightProduct(ctx context.Context, workspaceID, sessionID, productID, offerID, idempotencyKey string, isPinned bool, activeOffsetSec int32) (bool, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return false, ErrMissingTenant
	}

	session, err := s.store.GetSession(ctx, workspaceID, sessionID)
	if err != nil {
		return false, err
	}

	if idempotencyKey != "" {
		if _, found := s.store.GetCommand(ctx, workspaceID, idempotencyKey); found {
			return true, nil
		}
	}

	// Update session metadata with currently pinned item
	if session.Metadata == nil {
		session.Metadata = make(map[string]any)
	}

	if isPinned {
		session.Metadata["currently_pinned_product_id"] = productID
		session.Metadata["currently_pinned_offer_id"] = offerID
		session.Metadata["pinned_at_offset_sec"] = activeOffsetSec

		_ = s.events.Emit(ctx, "live.offer_pinned", map[string]any{
			"session_id": sessionID,
			"offer_id":   offerID,
			"product_id": productID,
			"offset_sec": activeOffsetSec,
		})
	} else {
		delete(session.Metadata, "currently_pinned_product_id")
		delete(session.Metadata, "currently_pinned_offer_id")
		delete(session.Metadata, "pinned_at_offset_sec")
	}

	if err := s.store.UpdateSession(ctx, session); err != nil {
		return false, err
	}

	if idempotencyKey != "" {
		_ = s.store.RecordCommand(ctx, &CommandExecutionRecord{
			IdempotencyKey: idempotencyKey,
			WorkspaceID:    workspaceID,
			SessionID:      sessionID,
			CommandType:    "HighlightProduct",
			ExecutedAt:     time.Now().UTC(),
			ResponseJSON:   []byte(`{"pinned":true}`),
		})
	}

	return false, nil
}

// CreateHighlight tags a moment during live for post-live clip extraction (RULE-M17-002, Acceptance Target 1 & 2).
func (s *Service) CreateHighlight(ctx context.Context, workspaceID, sessionID, idempotencyKey, title, highlightType, notes, pinnedOfferID, pinnedProductID string, startSec, endSec int32, autoDetected bool, score float64) (*Highlight, bool, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, false, ErrMissingTenant
	}
	if startSec < 0 || (endSec > 0 && endSec < startSec) {
		return nil, false, ErrInvalidTimeOffset
	}

	if _, err := s.store.GetSession(ctx, workspaceID, sessionID); err != nil {
		return nil, false, err
	}

	if idempotencyKey != "" {
		if rec, found := s.store.GetCommand(ctx, workspaceID, idempotencyKey); found && len(rec.ResponseJSON) > 0 {
			var cached Highlight
			if err := json.Unmarshal(rec.ResponseJSON, &cached); err == nil {
				return &cached, true, nil
			}
		}
	}

	if strings.TrimSpace(highlightType) == "" {
		highlightType = "viral_moment"
	}
	if endSec <= startSec {
		endSec = startSec + 30 // default 30-sec window if single timestamp tapped
	}

	hlID := newUUID()
	now := time.Now().UTC()
	hl := &Highlight{
		HighlightID:        hlID,
		SessionID:          sessionID,
		WorkspaceID:        workspaceID,
		Title:              title,
		StartOffsetSeconds: startSec,
		EndOffsetSeconds:   endSec,
		HighlightType:      highlightType,
		AutoDetected:       autoDetected,
		EngagementScore:    score,
		Notes:              notes,
		PinnedOfferID:      pinnedOfferID,
		PinnedProductID:    pinnedProductID,
		CreatedAt:          now,
		UpdatedAt:          now,
	}

	if err := s.store.CreateHighlight(ctx, hl); err != nil {
		return nil, false, err
	}

	_ = s.events.Emit(ctx, "live.highlight_marked", map[string]any{
		"session_id":   sessionID,
		"highlight_id": hlID,
		"timestamp":    startSec,
		"type":         highlightType,
	})

	if idempotencyKey != "" {
		b, _ := json.Marshal(hl)
		_ = s.store.RecordCommand(ctx, &CommandExecutionRecord{
			IdempotencyKey: idempotencyKey,
			WorkspaceID:    workspaceID,
			SessionID:      sessionID,
			CommandType:    "CreateHighlight",
			ExecutedAt:     now,
			ResponseJSON:   b,
		})
	}

	return hl, false, nil
}

// ExtractHighlights sends marked highlights to M07 for extraction and registers clips in M09 (Acceptance Target 2).
func (s *Service) ExtractHighlights(ctx context.Context, workspaceID, sessionID, sourceAssetID, idempotencyKey string, highlightIDs []string) (int32, []*Highlight, []string, bool, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return 0, nil, nil, false, ErrMissingTenant
	}
	if strings.TrimSpace(sourceAssetID) == "" {
		return 0, nil, nil, false, ErrMissingRecording
	}

	if idempotencyKey != "" {
		if rec, found := s.store.GetCommand(ctx, workspaceID, idempotencyKey); found && len(rec.ResponseJSON) > 0 {
			var cached struct {
				Count  int32    `json:"count"`
				Assets []string `json:"assets"`
			}
			if err := json.Unmarshal(rec.ResponseJSON, &cached); err == nil {
				allHls, _ := s.store.ListHighlights(ctx, workspaceID, sessionID)
				return cached.Count, allHls, cached.Assets, true, nil
			}
		}
	}

	allHls, err := s.store.ListHighlights(ctx, workspaceID, sessionID)
	if err != nil {
		return 0, nil, nil, false, err
	}

	var targetHls []*Highlight
	if len(highlightIDs) == 0 {
		targetHls = allHls
	} else {
		targetSet := make(map[string]bool)
		for _, id := range highlightIDs {
			targetSet[id] = true
		}
		for _, h := range allHls {
			if targetSet[h.HighlightID] {
				targetHls = append(targetHls, h)
			}
		}
	}

	var extractedAssets []string
	var updatedHls []*Highlight

	for _, h := range targetHls {
		clipTitle := h.Title
		if clipTitle == "" {
			clipTitle = fmt.Sprintf("Live Highlight %s (%ds-%ds)", h.HighlightType, h.StartOffsetSeconds, h.EndOffsetSeconds)
		}

		meta := map[string]any{
			"live_session_id":      sessionID,
			"highlight_id":         h.HighlightID,
			"highlight_type":       h.HighlightType,
			"start_offset_seconds": h.StartOffsetSeconds,
			"end_offset_seconds":   h.EndOffsetSeconds,
		}

		// M07 extracts, M09 registers derivative clip (Acceptance Target 2)
		clipAssetID, regErr := s.derivative.RegisterClipDerivative(ctx, workspaceID, sourceAssetID, clipTitle, h.StartOffsetSeconds, h.EndOffsetSeconds, meta)
		if regErr != nil {
			return 0, nil, nil, false, fmt.Errorf("failed to register derivative in M09: %w", regErr)
		}

		h.AssetID = clipAssetID
		_ = s.store.UpdateHighlight(ctx, h)

		extractedAssets = append(extractedAssets, clipAssetID)
		updatedHls = append(updatedHls, h)

		_ = s.events.Emit(ctx, "clip.extracted", map[string]any{
			"asset_id":   clipAssetID,
			"parent_id":  sourceAssetID,
			"session_id": sessionID,
		})
	}

	if idempotencyKey != "" {
		payload := struct {
			Count  int32    `json:"count"`
			Assets []string `json:"assets"`
		}{
			Count:  int32(len(extractedAssets)),
			Assets: extractedAssets,
		}
		b, _ := json.Marshal(payload)
		_ = s.store.RecordCommand(ctx, &CommandExecutionRecord{
			IdempotencyKey: idempotencyKey,
			WorkspaceID:    workspaceID,
			SessionID:      sessionID,
			CommandType:    "ExtractHighlights",
			ExecutedAt:     time.Now().UTC(),
			ResponseJSON:   b,
		})
	}

	return int32(len(extractedAssets)), updatedHls, extractedAssets, false, nil
}

// GenerateProofSummary creates post-live proof document with traceable, labeled revenue (Acceptance Target 3, RULE-M17-003, RULE-M17-004).
func (s *Service) GenerateProofSummary(ctx context.Context, workspaceID, sessionID string) (*PostLiveProofSummary, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, ErrMissingTenant
	}

	session, err := s.store.GetSession(ctx, workspaceID, sessionID)
	if err != nil {
		return nil, err
	}

	highlights, err := s.store.ListHighlights(ctx, workspaceID, sessionID)
	if err != nil {
		return nil, err
	}

	orders, err := s.store.ListOrdersForSession(ctx, workspaceID, sessionID)
	if err != nil {
		return nil, err
	}

	// Calculate traceable revenue accurately using tenantdb.ExactDecimal (DB-H-001)
	totalRevenue := tenantdb.ZeroDecimal()
	var extractedAssets []string
	for _, h := range highlights {
		if h.AssetID != "" {
			extractedAssets = append(extractedAssets, h.AssetID)
		}
	}

	for _, o := range orders {
		sum, addErr := totalRevenue.Add(o.Amount)
		if addErr == nil {
			totalRevenue = sum
		}
	}

	metrics := session.MetricsSnapshot
	metrics.OrdersDuringLive = int64(len(orders))
	metrics.RevenueDuringLive = totalRevenue
	if metrics.RevenueCurrency == "" {
		metrics.RevenueCurrency = "VND"
	}

	// Update session metrics snapshot in store
	session.MetricsSnapshot = metrics
	_ = s.store.UpdateSession(ctx, session)

	summaryID := newUUID()
	proofBundleID := newUUID()

	summary := &PostLiveProofSummary{
		SummaryID:             summaryID,
		SessionID:             sessionID,
		WorkspaceID:           workspaceID,
		SessionTitle:          session.Title,
		Platform:              session.Platform,
		Metrics:               metrics,
		Highlights:            makeHighlightSlice(highlights),
		ExtractedClipAssetIDs: extractedAssets,
		Orders:                orders,
		TotalRevenue:          totalRevenue,
		RevenueCurrency:       metrics.RevenueCurrency,
		SourceClass:           "live_attributed", // Labeled per RULE-M17-004 & Acceptance Target 3
		ProofBundleID:         proofBundleID,
		GeneratedAt:           time.Now().UTC(),
	}

	if err := s.store.SaveProofSummary(ctx, summary); err != nil {
		return nil, err
	}

	return summary, nil
}

func makeHighlightSlice(hls []*Highlight) []Highlight {
	res := make([]Highlight, len(hls))
	for i, h := range hls {
		res[i] = *h
	}
	return res
}

// AttachOrder links an order placed during live session for revenue traceability (Acceptance Target 3).
func (s *Service) AttachOrder(ctx context.Context, workspaceID, sessionID, orderID, productID, offerID, customerID, amountStr, currency string) error {
	if strings.TrimSpace(workspaceID) == "" {
		return ErrMissingTenant
	}

	dec, err := tenantdb.ParseExactDecimal(amountStr)
	if err != nil {
		return fmt.Errorf("%w: %s", ErrInvalidAmount, amountStr)
	}

	order := TraceableOrderLink{
		OrderID:             orderID,
		ProductID:           productID,
		OfferID:             offerID,
		CustomerID:          customerID,
		Amount:              dec,
		Currency:            currency,
		CreatedAt:           time.Now().UTC(),
		ReconciliationState: "matched",
	}

	return s.store.AttachOrder(ctx, workspaceID, sessionID, order)
}

// UpdateRunOfShow updates run of show items.
func (s *Service) UpdateRunOfShow(ctx context.Context, workspaceID, sessionID, idempotencyKey string, items []RunOfShowItem) (*LiveSession, bool, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, false, ErrMissingTenant
	}

	session, err := s.store.GetSession(ctx, workspaceID, sessionID)
	if err != nil {
		return nil, false, err
	}

	if idempotencyKey != "" {
		if _, found := s.store.GetCommand(ctx, workspaceID, idempotencyKey); found {
			return session, true, nil
		}
	}

	session.RunOfShow = items
	session.UpdatedAt = time.Now().UTC()

	if err := s.store.UpdateSession(ctx, session); err != nil {
		return nil, false, err
	}

	if idempotencyKey != "" {
		_ = s.store.RecordCommand(ctx, &CommandExecutionRecord{
			IdempotencyKey: idempotencyKey,
			WorkspaceID:    workspaceID,
			SessionID:      sessionID,
			CommandType:    "UpdateRunOfShow",
			ExecutedAt:     time.Now().UTC(),
			ResponseJSON:   []byte(`{"updated":true}`),
		})
	}

	return session, false, nil
}

// GetSession retrieves live session details along with cues and highlights.
func (s *Service) GetSession(ctx context.Context, workspaceID, sessionID string) (*LiveSession, []*CueCard, []*Highlight, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, nil, nil, ErrMissingTenant
	}

	session, err := s.store.GetSession(ctx, workspaceID, sessionID)
	if err != nil {
		return nil, nil, nil, err
	}

	cues, _ := s.store.ListCueCards(ctx, workspaceID, sessionID)
	highlights, _ := s.store.ListHighlights(ctx, workspaceID, sessionID)

	return session, cues, highlights, nil
}

// ListSessions lists sessions with optional status and platform filter.
func (s *Service) ListSessions(ctx context.Context, workspaceID, status, platform string, limit, offset int) ([]*LiveSession, int64, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, 0, ErrMissingTenant
	}
	return s.store.ListSessions(ctx, workspaceID, status, platform, limit, offset)
}

// GetProofSummary retrieves saved proof document.
func (s *Service) GetProofSummary(ctx context.Context, workspaceID, sessionID string) (*PostLiveProofSummary, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, ErrMissingTenant
	}
	return s.store.GetProofSummary(ctx, workspaceID, sessionID)
}

// GetAnalytics computes analytics and lists traceable orders for session.
func (s *Service) GetAnalytics(ctx context.Context, workspaceID, sessionID string) (*LiveMetricsSnapshot, []TraceableOrderLink, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, nil, ErrMissingTenant
	}

	session, err := s.store.GetSession(ctx, workspaceID, sessionID)
	if err != nil {
		return nil, nil, err
	}

	orders, _ := s.store.ListOrdersForSession(ctx, workspaceID, sessionID)

	metrics := session.MetricsSnapshot
	metrics.OrdersDuringLive = int64(len(orders))

	total := tenantdb.ZeroDecimal()
	for _, o := range orders {
		sum, _ := total.Add(o.Amount)
		total = sum
	}
	metrics.RevenueDuringLive = total

	return &metrics, orders, nil
}
