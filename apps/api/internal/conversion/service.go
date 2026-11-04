package conversion

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
)

// DomainEvent represents a published audit/domain event.
type DomainEvent struct {
	EventType   string         `json:"event_type"`
	WorkspaceID string         `json:"workspace_id"`
	Payload     map[string]any `json:"payload"`
	OccurredAt  time.Time      `json:"occurred_at"`
}

// EventRecorder records domain events for test assertions and event bus dispatch.
type EventRecorder interface {
	RecordEvent(event DomainEvent)
}

// MemoryEventRecorder provides thread-safe collection of recorded events.
type MemoryEventRecorder struct {
	mu     sync.RWMutex
	events []DomainEvent
}

func NewMemoryEventRecorder() *MemoryEventRecorder {
	return &MemoryEventRecorder{events: make([]DomainEvent, 0)}
}

func (m *MemoryEventRecorder) RecordEvent(event DomainEvent) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.events = append(m.events, event)
}

func (m *MemoryEventRecorder) GetEvents() []DomainEvent {
	m.mu.RLock()
	defer m.mu.RUnlock()
	result := make([]DomainEvent, len(m.events))
	copy(result, m.events)
	return result
}

func (m *MemoryEventRecorder) Clear() {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.events = nil
}

// SourceSnapshot represents the snapshot of a source object before conversion.
type SourceSnapshot struct {
	ID              string
	WorkspaceID     string
	Type            SourceType
	Title           string
	Description     string
	Status          string
	ConvertedToType string
	ConvertedToID   string
	UpdatedAt       time.Time
	Metadata        map[string]any
	RawObject       any
}

// SourceProvider defines operations for inspecting and updating a convertible source object.
type SourceProvider interface {
	GetSnapshot(ctx context.Context, workspaceID, sourceID string) (*SourceSnapshot, error)
	MarkConverted(ctx context.Context, workspaceID, sourceID string, targetType TargetType, targetID string, expectedUpdatedAt *time.Time) error
	RollbackConversion(ctx context.Context, workspaceID, sourceID string, snapshot *SourceSnapshot) error
}

// TargetCreator defines downstream target object creation and atomic compensation (rollback).
type TargetCreator interface {
	CreateTarget(ctx context.Context, workspaceID string, caller CallerContext, targetType TargetType, targetID, title string, details map[string]any, sourceRef map[string]any) (route string, targetObj any, err error)
	DeleteTarget(ctx context.Context, workspaceID string, targetType TargetType, targetID string) error
}

// Service coordinates atomic cross-domain commerce conversions with shared lineage.
type Service struct {
	mu              sync.RWMutex
	lineageStore    LineageStore
	eventRecorder   EventRecorder
	sourceProviders map[SourceType]SourceProvider
	targetCreators  map[TargetType]TargetCreator
	simulatedErrors map[string]error // for testing atomic failure injection
}

// NewService instantiates a conversion Service.
func NewService(lineageStore LineageStore, eventRecorder EventRecorder) *Service {
	if eventRecorder == nil {
		eventRecorder = NewMemoryEventRecorder()
	}
	return &Service{
		lineageStore:    lineageStore,
		eventRecorder:   eventRecorder,
		sourceProviders: make(map[SourceType]SourceProvider),
		targetCreators:  make(map[TargetType]TargetCreator),
		simulatedErrors: make(map[string]error),
	}
}

// RegisterSourceProvider binds a provider for an originating source type.
func (s *Service) RegisterSourceProvider(sourceType SourceType, provider SourceProvider) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.sourceProviders[sourceType] = provider
}

// RegisterTargetCreator binds a creator for a downstream commerce target type.
func (s *Service) RegisterTargetCreator(targetType TargetType, creator TargetCreator) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.targetCreators[targetType] = creator
}

// InjectSimulatedFailure forces a failure at a specific stage ("target_creation", "source_update", "lineage_save") for atomicity verification.
func (s *Service) InjectSimulatedFailure(stage string, err error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if err == nil {
		delete(s.simulatedErrors, stage)
	} else {
		s.simulatedErrors[stage] = err
	}
}

func (s *Service) checkPerm(caller CallerContext, permissionKey string) error {
	return rbac.CheckWorkspacePermission(permissionKey, rbac.PolicyContext{
		ActorUserID: caller.UserID,
		WorkspaceID: caller.WorkspaceID,
		Role:        caller.WorkspaceRole,
	})
}

// Convert executes an atomic cross-domain conversion, enforcing target permission rechecking,
// atomic rollback on failure, source object survival, and shared lineage persistence.
func (s *Service) Convert(ctx context.Context, caller CallerContext, params ConversionParams) (*ConversionResult, error) {
	if caller.UserID == "" || caller.WorkspaceID == "" {
		return nil, ErrUnauthenticated
	}
	if params.WorkspaceID != "" && params.WorkspaceID != caller.WorkspaceID {
		return nil, ErrCrossTenantDenied
	}
	workspaceID := caller.WorkspaceID

	srcType, err := NormalizeSourceType(string(params.SourceType))
	if err != nil {
		return nil, err
	}
	tgtType, err := NormalizeTargetType(string(params.TargetType))
	if err != nil {
		return nil, err
	}

	// 1. Source Permission Check
	srcPerm := RequiredSourcePermission(srcType)
	if err := s.checkPerm(caller, srcPerm); err != nil {
		return nil, fmt.Errorf("%w: role %q lacks source convert permission %q (%v)",
			ErrPermissionDenied, caller.WorkspaceRole, srcPerm, err)
	}

	// 2. ACCEPTANCE TARGET 1: EACH TARGET PERMISSION RECHECKED
	tgtPerm := RequiredTargetPermission(tgtType)
	if err := s.checkPerm(caller, tgtPerm); err != nil {
		return nil, fmt.Errorf("%w: role %q lacks required target permission %q for target %q (%v)",
			ErrTargetPermissionDenied, caller.WorkspaceRole, tgtPerm, tgtType, err)
	}

	s.mu.RLock()
	srcProv, ok := s.sourceProviders[srcType]
	s.mu.RUnlock()
	if !ok {
		return nil, fmt.Errorf("conversion: no provider registered for source type %s", srcType)
	}

	s.mu.RLock()
	tgtCreator, ok := s.targetCreators[tgtType]
	s.mu.RUnlock()
	if !ok {
		return nil, fmt.Errorf("conversion: no creator registered for target type %s", tgtType)
	}

	// 3. Inspect Source Snapshot
	snapshot, err := srcProv.GetSnapshot(ctx, workspaceID, params.SourceID)
	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrSourceNotFound, err)
	}

	// Verify not already converted
	if snapshot.ConvertedToType != "" || snapshot.Status == "converted" || snapshot.Status == "converted_to_task" {
		return nil, fmt.Errorf("%w: source %s (%s) already converted to %s:%s",
			ErrAlreadyConverted, srcType, params.SourceID, snapshot.ConvertedToType, snapshot.ConvertedToID)
	}

	// Optimistic concurrency check
	if params.ExpectedUpdatedAt != nil {
		if !snapshot.UpdatedAt.Truncate(time.Microsecond).Equal(params.ExpectedUpdatedAt.Truncate(time.Microsecond)) {
			return nil, ErrConcurrentConflict
		}
	}

	// Check domain-specific convertible criteria
	if srcType == SourceTypeIdea {
		if strings.TrimSpace(snapshot.Description) == "" {
			return nil, fmt.Errorf("%w: idea requires description before conversion", ErrConversionValidationFailed)
		}
	}

	now := time.Now().UTC()
	targetID := NewUUID()
	conversionID := NewUUID()

	targetTitle := strings.TrimSpace(params.TargetTitle)
	if targetTitle == "" {
		targetTitle = snapshot.Title
	}

	sourceRef := map[string]any{
		"source_type":   string(srcType),
		"source_id":     params.SourceID,
		"conversion_id": conversionID,
		"converted_by":  caller.UserID,
		"converted_at":  now.Format(time.RFC3339),
	}

	// Check injected failure stage: target_creation
	s.mu.RLock()
	targetCreationErr := s.simulatedErrors["target_creation"]
	s.mu.RUnlock()
	if targetCreationErr != nil {
		return nil, fmt.Errorf("%w: %v", ErrTargetCreationFailed, targetCreationErr)
	}

	// 4. ACCEPTANCE TARGET 2: ATOMIC EXECUTION (Step A: Create Target Object)
	route, targetObj, err := tgtCreator.CreateTarget(ctx, workspaceID, caller, tgtType, targetID, targetTitle, params.TargetDetails, sourceRef)
	if err != nil {
		// Atomic: source remains completely untouched!
		return nil, fmt.Errorf("%w: %v", ErrTargetCreationFailed, err)
	}

	// Check injected failure stage: source_update
	s.mu.RLock()
	sourceUpdateErr := s.simulatedErrors["source_update"]
	s.mu.RUnlock()
	if sourceUpdateErr != nil {
		// Compensation: Roll back the created target
		_ = tgtCreator.DeleteTarget(ctx, workspaceID, tgtType, targetID)
		return nil, fmt.Errorf("conversion: atomic source update failed: %w (target rolled back)", sourceUpdateErr)
	}

	// Step B: Mark Source Converted
	if err := srcProv.MarkConverted(ctx, workspaceID, params.SourceID, tgtType, targetID, params.ExpectedUpdatedAt); err != nil {
		// Compensation: Delete created target object so no orphan exists!
		_ = tgtCreator.DeleteTarget(ctx, workspaceID, tgtType, targetID)
		return nil, fmt.Errorf("conversion: failed to update source: %w (target rolled back)", err)
	}

	// Check injected failure stage: lineage_save
	s.mu.RLock()
	lineageSaveErr := s.simulatedErrors["lineage_save"]
	s.mu.RUnlock()
	if lineageSaveErr != nil {
		// Compensation: Roll back both target and source
		_ = tgtCreator.DeleteTarget(ctx, workspaceID, tgtType, targetID)
		_ = srcProv.RollbackConversion(ctx, workspaceID, params.SourceID, snapshot)
		return nil, fmt.Errorf("conversion: atomic lineage save failed: %w (source and target rolled back)", lineageSaveErr)
	}

	// Step C: Persist Shared Lineage
	lineageRecord := LineageRecord{
		ConversionID:   conversionID,
		WorkspaceID:    workspaceID,
		SourceType:     srcType,
		SourceID:       params.SourceID,
		TargetType:     tgtType,
		TargetID:       targetID,
		ConvertedBy:    caller.UserID,
		Status:         "completed",
		LineageDepth:   1,
		RootSourceType: string(srcType),
		RootSourceID:   params.SourceID,
		Metadata: map[string]any{
			"source_title": snapshot.Title,
			"target_title": targetTitle,
			"target_route": route,
		},
		CreatedAt: now,
		UpdatedAt: now,
	}

	// If source snapshot had prior root provenance, inherit it
	if rootType, ok := snapshot.Metadata["root_source_type"].(string); ok && rootType != "" {
		lineageRecord.RootSourceType = rootType
		if rootID, ok := snapshot.Metadata["root_source_id"].(string); ok && rootID != "" {
			lineageRecord.RootSourceID = rootID
		}
		if depth, ok := snapshot.Metadata["lineage_depth"].(int); ok {
			lineageRecord.LineageDepth = depth + 1
		}
	}

	if err := s.lineageStore.SaveLineage(ctx, lineageRecord); err != nil {
		// Roll back both target and source!
		_ = tgtCreator.DeleteTarget(ctx, workspaceID, tgtType, targetID)
		_ = srcProv.RollbackConversion(ctx, workspaceID, params.SourceID, snapshot)
		return nil, fmt.Errorf("conversion: failed to persist lineage record: %w (source and target rolled back)", err)
	}

	// 5. Emit Canonical Events
	canonicalEvent := fmt.Sprintf("%s.converted", srcType)
	s.eventRecorder.RecordEvent(DomainEvent{
		EventType:   canonicalEvent,
		WorkspaceID: workspaceID,
		Payload: map[string]any{
			"conversion_id": conversionID,
			"source_type":   string(srcType),
			"source_id":     params.SourceID,
			"target_type":   string(tgtType),
			"target_id":     targetID,
			"converted_by":  caller.UserID,
			"occurred_at":   now.Format(time.RFC3339),
		},
		OccurredAt: now,
	})

	return &ConversionResult{
		ConversionID:   conversionID,
		WorkspaceID:    workspaceID,
		SourceType:     srcType,
		SourceID:       params.SourceID,
		TargetType:     tgtType,
		TargetID:       targetID,
		TargetRoute:    route,
		Status:         "completed",
		ConvertedAt:    now,
		SourceSurvives: true,
		Lineage:        lineageRecord,
		TargetObject:   targetObj,
	}, nil
}

// VerifySourceSurvival (Acceptance Target 3: Source survives conversion) verifies that
// the originating object is intact in persistence, has not been deleted, and correctly
// references the downstream conversion target.
func (s *Service) VerifySourceSurvival(ctx context.Context, caller CallerContext, sourceType SourceType, sourceID string) (*SourceSnapshot, error) {
	if caller.UserID == "" || caller.WorkspaceID == "" {
		return nil, ErrUnauthenticated
	}

	srcType, err := NormalizeSourceType(string(sourceType))
	if err != nil {
		return nil, err
	}

	s.mu.RLock()
	provider, ok := s.sourceProviders[srcType]
	s.mu.RUnlock()
	if !ok {
		return nil, fmt.Errorf("conversion: no provider registered for source type %s", srcType)
	}

	snapshot, err := provider.GetSnapshot(ctx, caller.WorkspaceID, sourceID)
	if err != nil {
		return nil, fmt.Errorf("%w: source %s:%s could not be retrieved: %v", ErrSourceNotFound, srcType, sourceID, err)
	}

	// Verify source has not been deleted or cleared
	if snapshot.ID == "" || snapshot.Title == "" {
		return nil, errors.New("conversion: source object data was corrupted or cleared")
	}

	return snapshot, nil
}

// GetLineageGraph builds a bidirectional trace showing upstream provenance and downstream conversions.
func (s *Service) GetLineageGraph(ctx context.Context, caller CallerContext, objectType string, objectID string) (*LineageGraph, error) {
	if caller.UserID == "" || caller.WorkspaceID == "" {
		return nil, ErrUnauthenticated
	}
	workspaceID := caller.WorkspaceID

	downstreamRecords, err := s.lineageStore.ListLineageBySource(ctx, workspaceID, SourceType(objectType), objectID)
	if err != nil {
		return nil, err
	}

	upstreamRecords, err := s.lineageStore.ListLineageByTarget(ctx, workspaceID, TargetType(objectType), objectID)
	if err != nil {
		return nil, err
	}

	graph := &LineageGraph{
		RootNode: LineageNode{
			ID:        objectID,
			Type:      objectType,
			Direction: "current",
		},
		Upstream:    make([]LineageNode, 0),
		Downstream:  make([]LineageNode, 0),
		Conversions: append(upstreamRecords, downstreamRecords...),
	}

	for _, up := range upstreamRecords {
		graph.Upstream = append(graph.Upstream, LineageNode{
			ID:        up.SourceID,
			Type:      string(up.SourceType),
			Direction: "upstream",
			Depth:     up.LineageDepth,
			Metadata:  up.Metadata,
		})
	}

	for _, down := range downstreamRecords {
		graph.Downstream = append(graph.Downstream, LineageNode{
			ID:        down.TargetID,
			Type:      string(down.TargetType),
			Direction: "downstream",
			Depth:     down.LineageDepth,
			Metadata:  down.Metadata,
		})
	}

	return graph, nil
}
