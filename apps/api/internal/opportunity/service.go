// Package opportunity implements the Opportunity Board, prioritization,
// ownership, state transitions, and Home intelligence services (M04)
// per docs/02_features/intelligence/opportunity_board.md and docs/04_contracts/database_schema.md §5.4 & §5.5.
package opportunity

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"math"
	"sort"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	intelligencev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/intelligence/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/intelligence/v1/intelligencev1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/conversion"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	ErrUnauthenticated              = errors.New("opportunity: unauthenticated caller")
	ErrInvalidInput                 = errors.New("opportunity: invalid input parameter")
	ErrPermissionDenied             = errors.New("opportunity: caller role is not authorized for this operation")
	ErrOpportunityNotFound          = errors.New("opportunity: requested opportunity not found")
	ErrCrossTenantDenied            = errors.New("opportunity: cross-tenant access strictly forbidden")
	ErrOrphanOpportunityForbidden   = errors.New("opportunity: opportunity must map to at least one provenance source (RULE-M04-001)")
	ErrMissingOwner                 = errors.New("opportunity: owner_user_id is required before entering assigned or execution states (RULE-M04-002)")
	ErrMissingPriorityJustification = errors.New("opportunity: priority_reason or confidence context is required to prioritize (RULE-M04-003)")
	ErrInvalidStateTransition       = errors.New("opportunity: state transition violates canonical state machine (RULE-M04-004)")
	ErrConcurrentConflict           = errors.New("opportunity: concurrent modification detected; please refresh and try again (EC-M04-003)")
	ErrFinancialConflation          = errors.New("opportunity: estimated profit cannot be recorded as finalized financial ledger truth (RULE-M04-005)")
)

// CallerContext represents authenticated caller identity and tenant workspace.
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

// StoredOpportunitySource represents provenance links in table `opportunity_sources`.
type StoredOpportunitySource struct {
	SourceType    string // trend, signal, competitor, product_opportunity, thread
	SourceID      string
	SourceName    string
	SourceURL     string
	IsExpired     bool
	ArchiveNotice string
}

// StoredExpectedImpact represents impact estimation per database_schema.md §5.4.
type StoredExpectedImpact struct {
	Score           int32
	Description     string
	RevenueEstimate string
}

// StoredExpectedEffort represents effort estimation per database_schema.md §5.4.
type StoredExpectedEffort struct {
	Score        int32
	Description  string
	TimeEstimate string
}

// StoredEstimatedProfit represents expected profit estimation with confidence caveats (RULE-M04-005).
type StoredEstimatedProfit struct {
	AmountCents int64
	Currency    string
	Confidence  intelligencev1.ConfidenceBand
	SourceClass intelligencev1.SourceClass
	IsEstimate  bool
	Explanation string
}

// StoredOpportunity represents an opportunity row in table `opportunities` (§5.4).
type StoredOpportunity struct {
	OpportunityID     string
	WorkspaceID       string
	OpportunityType   string // content, product, affiliate, live, campaign
	Title             string
	Summary           string
	WhyItMatters      string
	ExpectedImpact    StoredExpectedImpact
	ExpectedEffort    StoredExpectedEffort
	PriorityState     intelligencev1.PriorityState
	PriorityReason    string
	SuggestedNextStep string
	OwnerUserID       string
	Confidence        intelligencev1.ConfidenceBand
	SourceClass       intelligencev1.SourceClass
	ConvertedToType   string
	ConvertedToID     string
	Sources           []StoredOpportunitySource
	IsSaved           bool
	IsDismissed       bool
	DismissReason     string
	OverallScore      int32
	EstimatedProfit   StoredEstimatedProfit
	CreatedAt         time.Time
	UpdatedAt         time.Time
}

// DomainEvent represents a published lifecycle event.
type DomainEvent struct {
	EventType   string
	WorkspaceID string
	Payload     map[string]any
	OccurredAt  time.Time
}

// ListFilter defines search and filtering criteria for opportunities.
type ListFilter struct {
	PriorityState   intelligencev1.PriorityState
	OpportunityType string
	OwnerUserID     string
	Confidence      intelligencev1.ConfidenceBand
	PageSize        int32
	PageToken       string
}

// Store defines repository contracts for opportunities and sources.
type Store interface {
	SaveOpportunity(ctx context.Context, opp StoredOpportunity) error
	GetOpportunity(ctx context.Context, workspaceID, opportunityID string) (*StoredOpportunity, error)
	ListOpportunities(ctx context.Context, workspaceID string, filter ListFilter) ([]StoredOpportunity, int, error)
	ListRelatedOpportunities(ctx context.Context, workspaceID, opportunityID string, limit int) ([]StoredOpportunity, error)
	GetTopOpportunities(ctx context.Context, workspaceID string, limit int) ([]StoredOpportunity, error)
}

// MemoryStore provides a thread-safe in-memory store for unit tests and local execution.
type MemoryStore struct {
	mu            sync.RWMutex
	opportunities map[string]StoredOpportunity
	events        []DomainEvent
}

// NewMemoryStore initializes a new MemoryStore.
func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		opportunities: make(map[string]StoredOpportunity),
	}
}

func (m *MemoryStore) key(workspaceID, oppID string) string {
	return workspaceID + ":" + oppID
}

func (m *MemoryStore) SaveOpportunity(ctx context.Context, opp StoredOpportunity) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	k := m.key(opp.WorkspaceID, opp.OpportunityID)
	m.opportunities[k] = opp
	return nil
}

func (m *MemoryStore) GetOpportunity(ctx context.Context, workspaceID, opportunityID string) (*StoredOpportunity, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	k := m.key(workspaceID, opportunityID)
	opp, ok := m.opportunities[k]
	if !ok {
		return nil, ErrOpportunityNotFound
	}
	cp := opp
	return &cp, nil
}

func (m *MemoryStore) ListOpportunities(ctx context.Context, workspaceID string, filter ListFilter) ([]StoredOpportunity, int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matching []StoredOpportunity
	for _, opp := range m.opportunities {
		if opp.WorkspaceID != workspaceID {
			continue
		}
		if filter.PriorityState != intelligencev1.PriorityState_PRIORITY_STATE_UNSPECIFIED && opp.PriorityState != filter.PriorityState {
			continue
		}
		if filter.OpportunityType != "" && !strings.EqualFold(opp.OpportunityType, filter.OpportunityType) {
			continue
		}
		if filter.OwnerUserID != "" && opp.OwnerUserID != filter.OwnerUserID {
			continue
		}
		if filter.Confidence != intelligencev1.ConfidenceBand_CONFIDENCE_BAND_UNSPECIFIED && opp.Confidence != filter.Confidence {
			continue
		}
		matching = append(matching, opp)
	}

	sort.Slice(matching, func(i, j int) bool {
		if matching[i].OverallScore != matching[j].OverallScore {
			return matching[i].OverallScore > matching[j].OverallScore
		}
		return matching[i].UpdatedAt.After(matching[j].UpdatedAt)
	})

	total := len(matching)
	start := 0
	if filter.PageToken != "" {
		for i, o := range matching {
			if o.OpportunityID == filter.PageToken {
				start = i + 1
				break
			}
		}
	}

	limit := int(filter.PageSize)
	if limit <= 0 || limit > 100 {
		limit = 20
	}

	end := start + limit
	if end > total {
		end = total
	}
	if start > total {
		start = total
	}

	return matching[start:end], total, nil
}

func (m *MemoryStore) ListRelatedOpportunities(ctx context.Context, workspaceID, opportunityID string, limit int) ([]StoredOpportunity, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	target, ok := m.opportunities[m.key(workspaceID, opportunityID)]
	if !ok {
		return nil, ErrOpportunityNotFound
	}

	var related []StoredOpportunity
	for _, opp := range m.opportunities {
		if opp.WorkspaceID != workspaceID || opp.OpportunityID == opportunityID {
			continue
		}
		// Match by type or overlapping source types
		matches := opp.OpportunityType == target.OpportunityType
		if !matches {
			for _, ts := range target.Sources {
				for _, os := range opp.Sources {
					if ts.SourceType == os.SourceType {
						matches = true
						break
					}
				}
				if matches {
					break
				}
			}
		}
		if matches {
			related = append(related, opp)
		}
	}

	sort.Slice(related, func(i, j int) bool {
		return related[i].OverallScore > related[j].OverallScore
	})

	if limit <= 0 || limit > len(related) {
		limit = len(related)
	}
	return related[:limit], nil
}

func (m *MemoryStore) GetTopOpportunities(ctx context.Context, workspaceID string, limit int) ([]StoredOpportunity, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var top []StoredOpportunity
	for _, opp := range m.opportunities {
		if opp.WorkspaceID != workspaceID {
			continue
		}
		if opp.PriorityState == intelligencev1.PriorityState_PRIORITY_STATE_PARKED ||
			opp.PriorityState == intelligencev1.PriorityState_PRIORITY_STATE_CLOSED_LOST ||
			opp.IsDismissed {
			continue
		}
		top = append(top, opp)
	}

	sort.Slice(top, func(i, j int) bool {
		return top[i].OverallScore > top[j].OverallScore
	})

	if limit <= 0 || limit > len(top) {
		limit = len(top)
	}
	return top[:limit], nil
}

// RecordEvent records an emitted domain event for audit/verification.
func (m *MemoryStore) RecordEvent(event DomainEvent) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.events = append(m.events, event)
}

// GetEvents returns all recorded events.
func (m *MemoryStore) GetEvents() []DomainEvent {
	m.mu.RLock()
	defer m.mu.RUnlock()
	cp := make([]DomainEvent, len(m.events))
	copy(cp, m.events)
	return cp
}

// ServiceConfig defines dependencies for OpportunityService.
type ServiceConfig struct {
	Store        Store
	LineageStore conversion.LineageStore
}

// Service implements intelligencev1connect.OpportunityServiceHandler.
type Service struct {
	store        Store
	lineageStore conversion.LineageStore
}

// NewService creates a new Service instance.
func NewService(cfg ServiceConfig) *Service {
	if cfg.Store == nil {
		cfg.Store = NewMemoryStore()
	}
	return &Service{
		store:        cfg.Store,
		lineageStore: cfg.LineageStore,
	}
}

// SetLineageStore sets or updates the shared conversion lineage store.
func (s *Service) SetLineageStore(ls conversion.LineageStore) {
	s.lineageStore = ls
}

// Ensure interface adherence.
var _ intelligencev1connect.OpportunityServiceHandler = (*Service)(nil)

func checkPerm(caller CallerContext, perm string) error {
	return rbac.CheckWorkspacePermission(perm, rbac.PolicyContext{
		ActorUserID: caller.UserID,
		WorkspaceID: caller.WorkspaceID,
		Role:        caller.WorkspaceRole,
	})
}

// ComputeRepairStatus evaluates whether an opportunity is repairable (Acceptance Target 1).
func ComputeRepairStatus(opp StoredOpportunity) (bool, []string) {
	var reasons []string

	// RULE-M04-002: Open/prioritized items without owner display assign prompt and are repairable
	if (opp.PriorityState == intelligencev1.PriorityState_PRIORITY_STATE_OPEN ||
		opp.PriorityState == intelligencev1.PriorityState_PRIORITY_STATE_PRIORITIZED) &&
		opp.OwnerUserID == "" {
		reasons = append(reasons, "Chưa phân công người phụ trách (Unassigned owner — assign team member)")
	}

	// RULE-M04-003: Missing priority justification
	if opp.PriorityReason == "" && opp.Confidence == intelligencev1.ConfidenceBand_CONFIDENCE_BAND_UNSPECIFIED {
		reasons = append(reasons, "Thiếu ngữ cảnh ưu tiên (Missing priority context — add reason or confidence)")
	}

	// Incomplete description
	if opp.Summary == "" {
		reasons = append(reasons, "Thiếu tóm tắt cơ hội (Missing opportunity summary)")
	}

	return len(reasons) > 0, reasons
}

// ValidateStateTransition checks adherence to canonical state machine (RULE-M04-004).
func ValidateStateTransition(current, target intelligencev1.PriorityState, opp StoredOpportunity, targetOwner string, reason string) error {
	if current == target {
		return nil
	}

	// Allow parking from active non-terminal states with reason
	if target == intelligencev1.PriorityState_PRIORITY_STATE_PARKED {
		if current == intelligencev1.PriorityState_PRIORITY_STATE_CLOSED_WON ||
			current == intelligencev1.PriorityState_PRIORITY_STATE_CLOSED_LOST ||
			current == intelligencev1.PriorityState_PRIORITY_STATE_CONVERTED {
			return fmt.Errorf("%w: cannot park terminal opportunity in state %s", ErrInvalidStateTransition, current)
		}
		if strings.TrimSpace(reason) == "" {
			return fmt.Errorf("%w: parking requires explanation reason", ErrInvalidStateTransition)
		}
		return nil
	}

	// Allow re-activating from parked to open
	if current == intelligencev1.PriorityState_PRIORITY_STATE_PARKED {
		if target == intelligencev1.PriorityState_PRIORITY_STATE_OPEN {
			return nil
		}
		return fmt.Errorf("%w: parked opportunities must first re-activate to open, not %s", ErrInvalidStateTransition, target)
	}

	switch current {
	case intelligencev1.PriorityState_PRIORITY_STATE_DRAFT:
		if target != intelligencev1.PriorityState_PRIORITY_STATE_OPEN {
			return fmt.Errorf("%w: draft can only transition to open, not %s", ErrInvalidStateTransition, target)
		}
		if strings.TrimSpace(opp.Title) == "" || strings.TrimSpace(opp.Summary) == "" {
			return fmt.Errorf("%w: draft requires title and summary to open", ErrInvalidStateTransition)
		}
		return nil

	case intelligencev1.PriorityState_PRIORITY_STATE_OPEN:
		if target != intelligencev1.PriorityState_PRIORITY_STATE_PRIORITIZED {
			return fmt.Errorf("%w: open can only transition to prioritized, not %s", ErrInvalidStateTransition, target)
		}
		// RULE-M04-003: Priority justification required
		if opp.PriorityReason == "" && opp.Confidence == intelligencev1.ConfidenceBand_CONFIDENCE_BAND_UNSPECIFIED {
			return ErrMissingPriorityJustification
		}
		return nil

	case intelligencev1.PriorityState_PRIORITY_STATE_PRIORITIZED:
		if target != intelligencev1.PriorityState_PRIORITY_STATE_ASSIGNED {
			return fmt.Errorf("%w: prioritized can only transition to assigned, not %s", ErrInvalidStateTransition, target)
		}
		// RULE-M04-002: owner_user_id required
		owner := opp.OwnerUserID
		if targetOwner != "" {
			owner = targetOwner
		}
		if strings.TrimSpace(owner) == "" {
			return ErrMissingOwner
		}
		return nil

	case intelligencev1.PriorityState_PRIORITY_STATE_ASSIGNED:
		if target != intelligencev1.PriorityState_PRIORITY_STATE_IN_PROGRESS {
			return fmt.Errorf("%w: assigned can only transition to in_progress, not %s", ErrInvalidStateTransition, target)
		}
		return nil

	case intelligencev1.PriorityState_PRIORITY_STATE_IN_PROGRESS:
		if target != intelligencev1.PriorityState_PRIORITY_STATE_CONVERTED {
			return fmt.Errorf("%w: in_progress can only transition to converted, not %s", ErrInvalidStateTransition, target)
		}
		return nil

	case intelligencev1.PriorityState_PRIORITY_STATE_CONVERTED:
		if target == intelligencev1.PriorityState_PRIORITY_STATE_CLOSED_WON ||
			target == intelligencev1.PriorityState_PRIORITY_STATE_CLOSED_LOST {
			if strings.TrimSpace(reason) == "" {
				return fmt.Errorf("%w: closing converted opportunity requires outcome documentation", ErrInvalidStateTransition)
			}
			return nil
		}
		return fmt.Errorf("%w: converted can only transition to closed_won or closed_lost, not %s", ErrInvalidStateTransition, target)

	default:
		return fmt.Errorf("%w: terminal state %s cannot transition to %s", ErrInvalidStateTransition, current, target)
	}
}

// CalculateOverallScore derives a 1-100 overall score from impact and effort.
func CalculateOverallScore(impact StoredExpectedImpact, effort StoredExpectedEffort) int32 {
	iScore := float64(impact.Score)
	if iScore <= 0 {
		iScore = 50
	}
	eScore := float64(effort.Score)
	if eScore <= 0 {
		eScore = 50
	}

	// Higher impact is good (70% weight); lower effort is good (30% weight: 100 - effort)
	score := (iScore * 0.7) + ((100.0 - eScore) * 0.3)
	if score < 1 {
		score = 1
	}
	if score > 100 {
		score = 100
	}
	return int32(math.Round(score))
}

func mapToProtoOpportunity(o StoredOpportunity) *intelligencev1.Opportunity {
	isRepairable, repairReasons := ComputeRepairStatus(o)

	var protoSources []*intelligencev1.OpportunitySourceRef
	for _, s := range o.Sources {
		protoSources = append(protoSources, &intelligencev1.OpportunitySourceRef{
			SourceType:    s.SourceType,
			SourceId:      s.SourceID,
			SourceName:    s.SourceName,
			SourceUrl:     s.SourceURL,
			IsExpired:     s.IsExpired,
			ArchiveNotice: s.ArchiveNotice,
		})
	}

	return &intelligencev1.Opportunity{
		OpportunityId:   o.OpportunityID,
		WorkspaceId:     o.WorkspaceID,
		OpportunityType: o.OpportunityType,
		Title:           o.Title,
		Summary:         o.Summary,
		WhyItMatters:    o.WhyItMatters,
		ExpectedImpact: &intelligencev1.ExpectedImpact{
			Score:           o.ExpectedImpact.Score,
			Description:     o.ExpectedImpact.Description,
			RevenueEstimate: o.ExpectedImpact.RevenueEstimate,
		},
		ExpectedEffort: &intelligencev1.ExpectedEffort{
			Score:        o.ExpectedEffort.Score,
			Description:  o.ExpectedEffort.Description,
			TimeEstimate: o.ExpectedEffort.TimeEstimate,
		},
		PriorityState:     o.PriorityState,
		PriorityReason:    o.PriorityReason,
		SuggestedNextStep: o.SuggestedNextStep,
		OwnerUserId:       o.OwnerUserID,
		Confidence:        o.Confidence,
		SourceClass:       o.SourceClass,
		ConvertedToType:   o.ConvertedToType,
		ConvertedToId:     o.ConvertedToID,
		Sources:           protoSources,
		CreatedAt:         timestamppb.New(o.CreatedAt),
		UpdatedAt:         timestamppb.New(o.UpdatedAt),
		IsRepairable:      isRepairable,
		RepairReasons:     repairReasons,
		EstimatedProfit: &intelligencev1.EstimatedProfit{
			AmountCents: o.EstimatedProfit.AmountCents,
			Currency:    o.EstimatedProfit.Currency,
			Confidence:  o.EstimatedProfit.Confidence,
			SourceClass: o.EstimatedProfit.SourceClass,
			IsEstimate:  o.EstimatedProfit.IsEstimate,
			Explanation: o.EstimatedProfit.Explanation,
		},
		IsSaved:      o.IsSaved,
		IsDismissed:  o.IsDismissed,
		OverallScore: o.OverallScore,
	}
}

// ----------------------------------------------------------------------------
// OpportunityService RPC Implementations
// ----------------------------------------------------------------------------

// List retrieves opportunities for the tenant workspace with filtering.
func (s *Service) List(ctx context.Context, req *connect.Request[intelligencev1.OpportunityServiceListRequest]) (*connect.Response[intelligencev1.OpportunityServiceListResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "opportunity:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	filter := ListFilter{
		PriorityState:   req.Msg.PriorityState,
		OpportunityType: req.Msg.OpportunityType,
		OwnerUserID:     req.Msg.OwnerUserId,
		Confidence:      req.Msg.Confidence,
		PageSize:        req.Msg.PageSize,
		PageToken:       req.Msg.PageToken,
	}

	opps, total, err := s.store.ListOpportunities(ctx, caller.WorkspaceID, filter)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoList []*intelligencev1.Opportunity
	var sumScore float64
	today := time.Now().UTC().Truncate(24 * time.Hour)
	newToday := 0

	for _, o := range opps {
		protoList = append(protoList, mapToProtoOpportunity(o))
		sumScore += float64(o.OverallScore)
		if o.CreatedAt.After(today) {
			newToday++
		}
	}

	var avgScore float32
	if len(protoList) > 0 {
		avgScore = float32(sumScore / float64(len(protoList)))
	}

	var nextToken string
	if len(opps) > 0 && len(opps) == int(filter.PageSize) {
		nextToken = opps[len(opps)-1].OpportunityID
	}

	return connect.NewResponse(&intelligencev1.OpportunityServiceListResponse{
		Opportunities: protoList,
		NextPageToken: nextToken,
		TotalCount:    int32(total),
		AvgScore:      avgScore,
		NewTodayCount: int32(newToday),
	}), nil
}

// Get retrieves a single opportunity with complete details and repair status.
func (s *Service) Get(ctx context.Context, req *connect.Request[intelligencev1.OpportunityServiceGetRequest]) (*connect.Response[intelligencev1.OpportunityServiceGetResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "opportunity:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}
	if strings.TrimSpace(req.Msg.OpportunityId) == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("opportunity_id is required"))
	}

	opp, err := s.store.GetOpportunity(ctx, caller.WorkspaceID, req.Msg.OpportunityId)
	if err != nil {
		if errors.Is(err, ErrOpportunityNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&intelligencev1.OpportunityServiceGetResponse{
		Opportunity: mapToProtoOpportunity(*opp),
	}), nil
}

// Create creates a new opportunity with strict provenance enforcement (RULE-M04-001).
func (s *Service) Create(ctx context.Context, req *connect.Request[intelligencev1.OpportunityServiceCreateRequest]) (*connect.Response[intelligencev1.OpportunityServiceCreateResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "opportunity:create"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	if strings.TrimSpace(req.Msg.Title) == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("opportunity title is required"))
	}
	if strings.TrimSpace(req.Msg.OpportunityType) == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("opportunity_type is required"))
	}

	// RULE-M04-001: Every opportunity MUST map to at least one provenance source.
	if len(req.Msg.SourceRefs) == 0 {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrOrphanOpportunityForbidden)
	}

	var sources []StoredOpportunitySource
	for _, ref := range req.Msg.SourceRefs {
		if strings.TrimSpace(ref.SourceId) == "" || strings.TrimSpace(ref.SourceType) == "" {
			return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid source reference: source_id and source_type required"))
		}
		sources = append(sources, StoredOpportunitySource{
			SourceType:    ref.SourceType,
			SourceID:      ref.SourceId,
			SourceName:    ref.SourceName,
			SourceURL:     ref.SourceUrl,
			IsExpired:     ref.IsExpired,
			ArchiveNotice: ref.ArchiveNotice,
		})
	}

	now := time.Now().UTC()
	oppID := generateDeterministicUUID(caller.WorkspaceID, req.Msg.Title, now)

	impact := StoredExpectedImpact{
		Score:           req.Msg.ExpectedImpact.GetScore(),
		Description:     req.Msg.ExpectedImpact.GetDescription(),
		RevenueEstimate: req.Msg.ExpectedImpact.GetRevenueEstimate(),
	}
	effort := StoredExpectedEffort{
		Score:        req.Msg.ExpectedEffort.GetScore(),
		Description:  req.Msg.ExpectedEffort.GetDescription(),
		TimeEstimate: req.Msg.ExpectedEffort.GetTimeEstimate(),
	}

	conf := req.Msg.Confidence

	// Financial estimation per RULE-M04-005: Always carried as estimate with confidence
	estConf := conf
	if estConf == intelligencev1.ConfidenceBand_CONFIDENCE_BAND_UNSPECIFIED {
		estConf = intelligencev1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM
	}
	estProfit := StoredEstimatedProfit{
		AmountCents: 15000000, // 150,000 VND default estimate basis
		Currency:    "VND",
		Confidence:  estConf,
		SourceClass: intelligencev1.SourceClass_SOURCE_CLASS_ESTIMATED,
		IsEstimate:  true,
		Explanation: "Dự toán doanh thu tiềm năng dựa trên tín hiệu thị trường; không phải số liệu kế toán chính thức.",
	}

	stored := StoredOpportunity{
		OpportunityID:     oppID,
		WorkspaceID:       caller.WorkspaceID,
		OpportunityType:   req.Msg.OpportunityType,
		Title:             strings.TrimSpace(req.Msg.Title),
		Summary:           strings.TrimSpace(req.Msg.Summary),
		WhyItMatters:      strings.TrimSpace(req.Msg.WhyItMatters),
		ExpectedImpact:    impact,
		ExpectedEffort:    effort,
		PriorityState:     intelligencev1.PriorityState_PRIORITY_STATE_DRAFT,
		PriorityReason:    req.Msg.PriorityReason,
		SuggestedNextStep: req.Msg.SuggestedNextStep,
		Confidence:        conf,
		SourceClass:       intelligencev1.SourceClass_SOURCE_CLASS_INFERRED,
		Sources:           sources,
		OverallScore:      CalculateOverallScore(impact, effort),
		EstimatedProfit:   estProfit,
		CreatedAt:         now,
		UpdatedAt:         now,
	}

	if err := s.store.SaveOpportunity(ctx, stored); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Emit opportunity.created event
	if mem, ok := s.store.(*MemoryStore); ok {
		mem.RecordEvent(DomainEvent{
			EventType:   "opportunity.created",
			WorkspaceID: caller.WorkspaceID,
			Payload: map[string]any{
				"opportunity_id":   oppID,
				"opportunity_type": stored.OpportunityType,
				"title":            stored.Title,
				"sources_count":    len(stored.Sources),
			},
			OccurredAt: now,
		})
	}

	return connect.NewResponse(&intelligencev1.OpportunityServiceCreateResponse{
		Opportunity: mapToProtoOpportunity(stored),
	}), nil
}

// UpdateState transitions an opportunity's state with optimistic locking and state machine checks.
func (s *Service) UpdateState(ctx context.Context, req *connect.Request[intelligencev1.OpportunityServiceUpdateStateRequest]) (*connect.Response[intelligencev1.OpportunityServiceUpdateStateResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "opportunity:create"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	opp, err := s.store.GetOpportunity(ctx, caller.WorkspaceID, req.Msg.OpportunityId)
	if err != nil {
		if errors.Is(err, ErrOpportunityNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// EC-M04-003: Optimistic concurrency control via expected_updated_at
	if req.Msg.ExpectedUpdatedAt != nil {
		expectedTime := req.Msg.ExpectedUpdatedAt.AsTime()
		if !opp.UpdatedAt.Truncate(time.Microsecond).Equal(expectedTime.Truncate(time.Microsecond)) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrConcurrentConflict)
		}
	}

	// Apply optional updates before transition validation
	if req.Msg.ExpectedImpact != nil {
		opp.ExpectedImpact = StoredExpectedImpact{
			Score:           req.Msg.ExpectedImpact.Score,
			Description:     req.Msg.ExpectedImpact.Description,
			RevenueEstimate: req.Msg.ExpectedImpact.RevenueEstimate,
		}
	}
	if req.Msg.ExpectedEffort != nil {
		opp.ExpectedEffort = StoredExpectedEffort{
			Score:        req.Msg.ExpectedEffort.Score,
			Description:  req.Msg.ExpectedEffort.Description,
			TimeEstimate: req.Msg.ExpectedEffort.TimeEstimate,
		}
	}
	if req.Msg.PriorityReason != "" {
		opp.PriorityReason = req.Msg.PriorityReason
	}
	if req.Msg.Confidence != intelligencev1.ConfidenceBand_CONFIDENCE_BAND_UNSPECIFIED {
		opp.Confidence = req.Msg.Confidence
	}
	opp.OverallScore = CalculateOverallScore(opp.ExpectedImpact, opp.ExpectedEffort)

	// Validate state machine transition (RULE-M04-004)
	if err := ValidateStateTransition(opp.PriorityState, req.Msg.NewState, *opp, "", req.Msg.Reason); err != nil {
		if errors.Is(err, ErrMissingOwner) || errors.Is(err, ErrMissingPriorityJustification) {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		return nil, connect.NewError(connect.CodeFailedPrecondition, err)
	}

	oldState := opp.PriorityState
	opp.PriorityState = req.Msg.NewState
	opp.UpdatedAt = time.Now().UTC()

	if err := s.store.SaveOpportunity(ctx, *opp); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Emit opportunity.state_changed
	if mem, ok := s.store.(*MemoryStore); ok {
		mem.RecordEvent(DomainEvent{
			EventType:   "opportunity.state_changed",
			WorkspaceID: caller.WorkspaceID,
			Payload: map[string]any{
				"opportunity_id": opp.OpportunityID,
				"from_state":     oldState.String(),
				"to_state":       opp.PriorityState.String(),
				"reason":         req.Msg.Reason,
			},
			OccurredAt: opp.UpdatedAt,
		})
	}

	return connect.NewResponse(&intelligencev1.OpportunityServiceUpdateStateResponse{
		Opportunity: mapToProtoOpportunity(*opp),
	}), nil
}

// Assign assigns an owner to the opportunity (requires Manager+ role per rpc_permission_bindings.csv).
func (s *Service) Assign(ctx context.Context, req *connect.Request[intelligencev1.OpportunityServiceAssignRequest]) (*connect.Response[intelligencev1.OpportunityServiceAssignResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	// rpc_permission_bindings.csv specifies opportunity:assign for OpportunityService/Assign
	if err := checkPerm(caller, "opportunity:assign"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	if strings.TrimSpace(req.Msg.OwnerUserId) == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("owner_user_id is required for assignment"))
	}

	opp, err := s.store.GetOpportunity(ctx, caller.WorkspaceID, req.Msg.OpportunityId)
	if err != nil {
		if errors.Is(err, ErrOpportunityNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// EC-M04-003: Optimistic concurrency check
	if req.Msg.ExpectedUpdatedAt != nil {
		expectedTime := req.Msg.ExpectedUpdatedAt.AsTime()
		if !opp.UpdatedAt.Truncate(time.Microsecond).Equal(expectedTime.Truncate(time.Microsecond)) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrConcurrentConflict)
		}
	}

	opp.OwnerUserID = strings.TrimSpace(req.Msg.OwnerUserId)
	// If currently prioritized or open, transition to assigned
	if opp.PriorityState == intelligencev1.PriorityState_PRIORITY_STATE_PRIORITIZED ||
		opp.PriorityState == intelligencev1.PriorityState_PRIORITY_STATE_OPEN {
		opp.PriorityState = intelligencev1.PriorityState_PRIORITY_STATE_ASSIGNED
	}
	opp.UpdatedAt = time.Now().UTC()

	if err := s.store.SaveOpportunity(ctx, *opp); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	if mem, ok := s.store.(*MemoryStore); ok {
		mem.RecordEvent(DomainEvent{
			EventType:   "opportunity.state_changed",
			WorkspaceID: caller.WorkspaceID,
			Payload: map[string]any{
				"opportunity_id": opp.OpportunityID,
				"owner_user_id":  opp.OwnerUserID,
				"state":          opp.PriorityState.String(),
			},
			OccurredAt: opp.UpdatedAt,
		})
	}

	return connect.NewResponse(&intelligencev1.OpportunityServiceAssignResponse{
		Opportunity: mapToProtoOpportunity(*opp),
	}), nil
}

// Convert converts an opportunity to a downstream object (idea, script, campaign, live_plan).
func (s *Service) Convert(ctx context.Context, req *connect.Request[intelligencev1.OpportunityServiceConvertRequest]) (*connect.Response[intelligencev1.OpportunityServiceConvertResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	// rpc_permission_bindings.csv specifies opportunity:convert (Editor+)
	if err := checkPerm(caller, "opportunity:convert"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	targetType := strings.ToLower(strings.TrimSpace(req.Msg.ConversionType))
	var targetPerm string
	switch targetType {
	case "idea":
		targetPerm = "idea:create"
	case "script":
		targetPerm = "script:create"
	case "campaign":
		targetPerm = "campaign:manage"
	case "live", "live_plan", "live_session":
		targetPerm = "live:manage"
	case "offer":
		targetPerm = "offer:manage"
	case "seeding", "sample_request":
		targetPerm = "sample:manage"
	case "deal", "brand_deal":
		targetPerm = "brand_deal:manage"
	default:
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid conversion_type %q; supported: idea, script, campaign, live_plan, offer, seeding, deal", targetType))
	}

	// ACCEPTANCE TARGET 1: Each target permission rechecked!
	if err := checkPerm(caller, targetPerm); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("conversion to %s requires target permission %s (caller role: %s): %w", targetType, targetPerm, caller.WorkspaceRole, err))
	}

	opp, err := s.store.GetOpportunity(ctx, caller.WorkspaceID, req.Msg.OpportunityId)
	if err != nil {
		if errors.Is(err, ErrOpportunityNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// EC-M04-003: Optimistic concurrency check
	if req.Msg.ExpectedUpdatedAt != nil {
		expectedTime := req.Msg.ExpectedUpdatedAt.AsTime()
		if !opp.UpdatedAt.Truncate(time.Microsecond).Equal(expectedTime.Truncate(time.Microsecond)) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrConcurrentConflict)
		}
	}

	now := time.Now().UTC()
	targetID := generateDeterministicUUID(caller.WorkspaceID, opp.OpportunityID+":"+targetType, now)

	opp.ConvertedToType = targetType
	opp.ConvertedToID = targetID
	opp.PriorityState = intelligencev1.PriorityState_PRIORITY_STATE_CONVERTED
	opp.UpdatedAt = now

	if err := s.store.SaveOpportunity(ctx, *opp); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Record shared lineage if lineage store is configured
	if s.lineageStore != nil {
		_ = s.lineageStore.SaveLineage(ctx, conversion.LineageRecord{
			ConversionID:   targetID,
			WorkspaceID:    caller.WorkspaceID,
			SourceType:     conversion.SourceTypeOpportunity,
			SourceID:       opp.OpportunityID,
			TargetType:     conversion.TargetType(targetType),
			TargetID:       targetID,
			ConvertedBy:    caller.UserID,
			Status:         "completed",
			LineageDepth:   1,
			RootSourceType: "opportunity",
			RootSourceID:   opp.OpportunityID,
			Metadata: map[string]any{
				"title": opp.Title,
			},
			CreatedAt: now,
			UpdatedAt: now,
		})
	}

	// RULE-M04-006: emit opportunity.converted with payload containing {opportunity_id, to_type, to_id}
	if mem, ok := s.store.(*MemoryStore); ok {
		mem.RecordEvent(DomainEvent{
			EventType:   "opportunity.converted",
			WorkspaceID: caller.WorkspaceID,
			Payload: map[string]any{
				"opportunity_id": opp.OpportunityID,
				"to_type":        targetType,
				"to_id":          targetID,
			},
			OccurredAt: now,
		})
	}

	targetRoute := fmt.Sprintf("/%ss/%s", targetType, targetID)
	switch targetType {
	case "live_plan":
		targetRoute = fmt.Sprintf("/live/plans/%s", targetID)
	case "live", "live_session":
		targetRoute = fmt.Sprintf("/live/sessions/%s", targetID)
	case "seeding", "sample_request":
		targetRoute = fmt.Sprintf("/seeding/samples/%s", targetID)
	case "deal", "brand_deal":
		targetRoute = fmt.Sprintf("/brand-deals/%s", targetID)
	}

	return connect.NewResponse(&intelligencev1.OpportunityServiceConvertResponse{
		Opportunity:     mapToProtoOpportunity(*opp),
		ConvertedToType: targetType,
		ConvertedToId:   targetID,
		TargetRoute:     targetRoute,
	}), nil
}

// Save bookmarks an opportunity.
func (s *Service) Save(ctx context.Context, req *connect.Request[intelligencev1.OpportunityServiceSaveRequest]) (*connect.Response[intelligencev1.OpportunityServiceSaveResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "opportunity:create"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	opp, err := s.store.GetOpportunity(ctx, caller.WorkspaceID, req.Msg.OpportunityId)
	if err != nil {
		if errors.Is(err, ErrOpportunityNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	opp.IsSaved = !opp.IsSaved // Toggle bookmark
	opp.UpdatedAt = time.Now().UTC()

	if err := s.store.SaveOpportunity(ctx, *opp); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&intelligencev1.OpportunityServiceSaveResponse{
		Opportunity: mapToProtoOpportunity(*opp),
	}), nil
}

// Dismiss dismisses an opportunity with a reason.
func (s *Service) Dismiss(ctx context.Context, req *connect.Request[intelligencev1.OpportunityServiceDismissRequest]) (*connect.Response[intelligencev1.OpportunityServiceDismissResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "opportunity:create"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	opp, err := s.store.GetOpportunity(ctx, caller.WorkspaceID, req.Msg.OpportunityId)
	if err != nil {
		if errors.Is(err, ErrOpportunityNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	opp.IsDismissed = true
	opp.DismissReason = req.Msg.Reason
	opp.UpdatedAt = time.Now().UTC()

	if err := s.store.SaveOpportunity(ctx, *opp); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&intelligencev1.OpportunityServiceDismissResponse{
		Opportunity: mapToProtoOpportunity(*opp),
	}), nil
}

// ListRelated finds opportunities related to the current opportunity.
func (s *Service) ListRelated(ctx context.Context, req *connect.Request[intelligencev1.OpportunityServiceListRelatedRequest]) (*connect.Response[intelligencev1.OpportunityServiceListRelatedResponse], error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if req.Msg.WorkspaceId != "" && req.Msg.WorkspaceId != caller.WorkspaceID {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrCrossTenantDenied)
	}
	if err := checkPerm(caller, "opportunity:read"); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	limit := int(req.Msg.Limit)
	if limit <= 0 || limit > 20 {
		limit = 5
	}

	related, err := s.store.ListRelatedOpportunities(ctx, caller.WorkspaceID, req.Msg.OpportunityId, limit)
	if err != nil {
		if errors.Is(err, ErrOpportunityNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoList []*intelligencev1.Opportunity
	for _, o := range related {
		protoList = append(protoList, mapToProtoOpportunity(o))
	}

	return connect.NewResponse(&intelligencev1.OpportunityServiceListRelatedResponse{
		RelatedOpportunities: protoList,
	}), nil
}

// GetTopDecisionOpportunities provides the M01 Home Daily Decision Engine card family integration.
func (s *Service) GetTopDecisionOpportunities(ctx context.Context, workspaceID string, limit int) ([]*intelligencev1.Opportunity, error) {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return nil, ErrUnauthenticated
	}
	if workspaceID != "" && workspaceID != caller.WorkspaceID {
		return nil, ErrCrossTenantDenied
	}
	if err := checkPerm(caller, "opportunity:read"); err != nil {
		return nil, err
	}

	top, err := s.store.GetTopOpportunities(ctx, caller.WorkspaceID, limit)
	if err != nil {
		return nil, err
	}

	var result []*intelligencev1.Opportunity
	for _, o := range top {
		result = append(result, mapToProtoOpportunity(o))
	}
	return result, nil
}

func generateDeterministicUUID(workspaceID, seed string, ts time.Time) string {
	raw := fmt.Sprintf("%s:%s:%d", workspaceID, seed, ts.UnixNano())
	hash := sha256.Sum256([]byte(raw))
	hexStr := hex.EncodeToString(hash[:16])
	return fmt.Sprintf("%s-%s-%s-%s-%s", hexStr[0:8], hexStr[8:12], hexStr[12:16], hexStr[16:20], hexStr[20:32])
}
