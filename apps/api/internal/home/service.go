// Package home implements the Daily Decision Engine (M01) and DashboardService
// per docs/02_features/platform/home_decision_engine.md and Pack 01 §S05.1.
package home

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1/adminv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	ErrUnauthenticated        = errors.New("home: unauthenticated request")
	ErrInvalidInput           = errors.New("home: invalid input parameters")
	ErrPermissionDenied       = errors.New("home: caller role is not authorized for this action")
	ErrStepUnavailableInPhase = errors.New("home: onboarding step belongs to an unshipped future phase and cannot be completed in P1")
	ErrDemoFixtureNotAllowed  = errors.New("home: demo fixtures cannot contribute to customer profit, activation, or proof")
)

// CallerContext models the authenticated caller context.
type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string
}

type callerCtxKey struct{}

// WithCallerContext attaches CallerContext to ctx.
func WithCallerContext(ctx context.Context, caller CallerContext) context.Context {
	return context.WithValue(ctx, callerCtxKey{}, caller)
}

// CallerFromContext extracts CallerContext from ctx.
func CallerFromContext(ctx context.Context) (CallerContext, bool) {
	if ctx == nil {
		return CallerContext{}, false
	}
	c, ok := ctx.Value(callerCtxKey{}).(CallerContext)
	return c, ok
}

// StoredMetric holds a financial/operational KPI with provenance and demo flag.
type StoredMetric struct {
	MetricKey          string
	DisplayName        string
	AmountCents        int64
	Currency           string
	DataSource         adminv1.DataSourceBadge
	Confidence         adminv1.ConfidenceLevel
	LastSyncedAt       time.Time
	DataOrigins        []string
	MissingDataCaveats []string
	RecommendedSteps   []string
	IsDemoFixture      bool
}

// DataRepairGap represents an active data/evidence gap surfaced on Home in P1
// per docs/02_features/platform/home_decision_engine.md (§Progressive first value and data-repair actions)
// and docs/02_features/finance/operating_ledger.md (§Evidence coverage and repair queue).
type DataRepairGap struct {
	GapID       string // e.g. "gap-missing-cogs-sku-1", "gap-unmatched-settlement-1"
	GapKind     string // "missing_cogs", "missing_evidence", "unmatched_settlement", "stale_connector"
	Title       string
	Reason      string // visible reason explaining why the number/proof is incomplete
	RepairCTA   string // single repair CTA label
	RepairRoute string // e.g. "/kinh-doanh"
	AmountCents int64  // optional affected amount (hidden from viewers lacking finance permission)
	Currency    string
	Resolved    bool
}

// WorkspaceImportState tracks a workspace's P1 authorized imported/connected state
// without requiring native platform API connectors (Acceptance Target #1).
type WorkspaceImportState struct {
	WorkspaceID                string
	ConnectedAccountsCount     int
	AuthorizedProductsCount    int
	AuthorizedOrdersCount      int
	AuthorizedCostsCount       int
	AuthorizedSettlementsCount int
	GrossRevenueCents          int64
	KnownCostsCents            int64
	Currency                   string
	SourceBadge                adminv1.DataSourceBadge
	RepairGaps                 []DataRepairGap
	LastImportedAt             time.Time
}

// AuthorizedImportRequest specifies an authorized P1 product/order/cost/settlement import batch
// that requires ZERO connected accounts.
type AuthorizedImportRequest struct {
	WorkspaceID            string
	ConnectedAccountsCount int // 0 is explicitly valid in P1 ("No connector required for authorized import")
	ProductsCount          int
	OrdersCount            int
	CostsCount             int
	SettlementsCount       int
	GrossRevenueCents      int64
	KnownCostsCents        int64
	Currency               string
	RepairGaps             []DataRepairGap
	IsDemoFixture          bool
	ImportedAt             time.Time
}

// AuthorizedImportProjection returns the labeled P1 profit view, active repair checklist,
// and the authenticated caller's updated personal onboarding checklist.
type AuthorizedImportProjection struct {
	WorkspaceID                    string
	ConnectedAccountsCount         int
	RequiresNativeConnector        bool
	FormattedGrossRevenue          string
	FormattedNetProfit             string
	SourceBadge                    adminv1.DataSourceBadge
	Confidence                     adminv1.ConfidenceLevel
	IsIncomplete                   bool
	UnknownRequiredComponentsCount int
	ActiveRepairCards              []*adminv1.DecisionCard
	PersonalOnboarding             *adminv1.OnboardingChecklist
}

// Service implements DashboardServiceHandler (M01).
type Service struct {
	adminv1connect.UnimplementedDashboardServiceHandler
	mu                sync.RWMutex
	phase             string                                 // active build phase, defaults to "P8"
	onboarding        map[string][]bool                      // key: workspaceID:userID -> array of 5 booleans
	metrics           map[string][]StoredMetric              // key: workspaceID
	configs           map[string]HomeDashboardConfig         // key: workspaceID
	briefDeliveries   map[string]*MorningBriefDeliveryRecord // key: morning_brief:<workspaceID>:<YYYY-MM-DD>
	imports           map[string]*WorkspaceImportState       // key: workspaceID
	pilotObservations []PilotObservation
	bindings          *rbac.Registry
}

// NewService creates a new DashboardService instance.
func NewService(bindings *rbac.Registry) *Service {
	return &Service{
		phase:           "P8",
		onboarding:      make(map[string][]bool),
		metrics:         make(map[string][]StoredMetric),
		configs:         make(map[string]HomeDashboardConfig),
		briefDeliveries: make(map[string]*MorningBriefDeliveryRecord),
		imports:         make(map[string]*WorkspaceImportState),
		bindings:        bindings,
	}
}

// SetPhase configures the active build phase on the service (e.g. "P0", "P1", "P8").
func (s *Service) SetPhase(phase string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.phase = phase
}

func (s *Service) getPhaseLocked() string {
	if s.phase == "" {
		return "P8"
	}
	return s.phase
}

func callerUserID(ctx context.Context) string {
	if caller, ok := CallerFromContext(ctx); ok && strings.TrimSpace(caller.UserID) != "" {
		return strings.TrimSpace(caller.UserID)
	}
	return "default-user"
}

func isViewerRole(ctx context.Context) bool {
	caller, ok := CallerFromContext(ctx)
	if !ok {
		return false
	}
	role := strings.ToLower(strings.TrimSpace(caller.WorkspaceRole))
	return role == "viewer" || role == strings.ToLower(rbac.RoleViewer)
}

// SeedWorkspaceMetric records a financial/operational KPI for a workspace.
func (s *Service) SeedWorkspaceMetric(workspaceID string, m StoredMetric) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.metrics[workspaceID] = append(s.metrics[workspaceID], m)
}

// IngestAuthorizedImport accepts an authorized product/order/cost/settlement import in P1
// with ZERO connected accounts required (Acceptance Target #1: "No connector required for authorized import").
//   - Rejects demo fixtures from contributing to customer profit, activation, or proof.
//   - Computes a labeled profit projection (with source_class=IMPORTED and confidence_band=LOW when gaps exist).
//   - Populates data-repair cards with 1 repair CTA and visible reason.
//   - Updates ONLY the authenticated user's personal onboarding progress for available P1 steps (1, 2, 5)
//     while keeping future-phase steps (3, 4) unavailable and IsClosedLoopComplete=false.
func (s *Service) IngestAuthorizedImport(ctx context.Context, req AuthorizedImportRequest) (AuthorizedImportProjection, error) {
	wsID := strings.TrimSpace(req.WorkspaceID)
	if wsID == "" {
		return AuthorizedImportProjection{}, ErrInvalidInput
	}
	if isViewerRole(ctx) {
		return AuthorizedImportProjection{}, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}
	if req.IsDemoFixture {
		return AuthorizedImportProjection{}, ErrDemoFixtureNotAllowed
	}
	if req.ProductsCount == 0 && req.OrdersCount == 0 && req.CostsCount == 0 && req.SettlementsCount == 0 {
		return AuthorizedImportProjection{}, fmt.Errorf("%w: import batch must contain at least one product, order, cost, or settlement record", ErrInvalidInput)
	}

	now := req.ImportedAt
	if now.IsZero() {
		now = time.Now().UTC()
	}
	currency := strings.TrimSpace(req.Currency)
	if currency == "" {
		currency = "VND"
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	badge := adminv1.DataSourceBadge_DATA_SOURCE_BADGE_IMPORTED
	if req.ConnectedAccountsCount > 0 {
		badge = adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL
	}

	gapsCopy := make([]DataRepairGap, len(req.RepairGaps))
	copy(gapsCopy, req.RepairGaps)

	st := &WorkspaceImportState{
		WorkspaceID:                wsID,
		ConnectedAccountsCount:     req.ConnectedAccountsCount,
		AuthorizedProductsCount:    req.ProductsCount,
		AuthorizedOrdersCount:      req.OrdersCount,
		AuthorizedCostsCount:       req.CostsCount,
		AuthorizedSettlementsCount: req.SettlementsCount,
		GrossRevenueCents:          req.GrossRevenueCents,
		KnownCostsCents:            req.KnownCostsCents,
		Currency:                   currency,
		SourceBadge:                badge,
		RepairGaps:                 gapsCopy,
		LastImportedAt:             now,
	}
	s.imports[wsID] = st
	s.recomputeImportedRevenueMetricLocked(wsID, st)

	// Derive personal onboarding progress for the authenticated user without mutating another user's progress.
	uID := callerUserID(ctx)
	obKey := wsID + ":" + uID
	steps, exists := s.onboarding[obKey]
	if !exists {
		steps = make([]bool, 5)
	}
	// Step 1 (connect_data): satisfied by authorized imported dataset even when ConnectedAccountsCount == 0!
	steps[0] = true
	// Step 2 (select_offer / M13): satisfied when catalog or order items are present.
	if req.ProductsCount > 0 || req.OrdersCount > 0 {
		steps[1] = true
	}
	// Step 5 (track_outcome / M19): satisfied when labeled profit snapshot & repair checklist are computed.
	if req.OrdersCount > 0 || req.CostsCount > 0 || req.SettlementsCount > 0 {
		steps[4] = true
	}
	// Steps 3 (create_content, P4) and 4 (publish, P5) remain false in P1.
	s.onboarding[obKey] = steps

	return s.buildImportProjectionLocked(wsID, uID), nil
}

// ResolveUnderlyingDataRepair marks an underlying finance/reconciliation repair gap as completed
// in the domain state and dynamically recomputes/removes the corresponding Home data-repair card
// (rather than marking it fixed locally in UI state).
func (s *Service) ResolveUnderlyingDataRepair(ctx context.Context, workspaceID, gapID string, addedKnownCostCents int64) (AuthorizedImportProjection, error) {
	wsID := strings.TrimSpace(workspaceID)
	gID := strings.TrimSpace(gapID)
	if wsID == "" || gID == "" {
		return AuthorizedImportProjection{}, ErrInvalidInput
	}
	if isViewerRole(ctx) {
		return AuthorizedImportProjection{}, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	st, ok := s.imports[wsID]
	if !ok {
		return AuthorizedImportProjection{}, fmt.Errorf("%w: no import state found for workspace %q", ErrInvalidInput, wsID)
	}

	found := false
	for i := range st.RepairGaps {
		if st.RepairGaps[i].GapID == gID && !st.RepairGaps[i].Resolved {
			st.RepairGaps[i].Resolved = true
			found = true
			break
		}
	}
	if !found {
		return AuthorizedImportProjection{}, fmt.Errorf("%w: active repair gap %q not found", ErrInvalidInput, gID)
	}
	if addedKnownCostCents > 0 {
		st.KnownCostsCents += addedKnownCostCents
		st.AuthorizedCostsCount++
	}
	st.LastImportedAt = time.Now().UTC()
	s.recomputeImportedRevenueMetricLocked(wsID, st)

	return s.buildImportProjectionLocked(wsID, callerUserID(ctx)), nil
}

func (s *Service) recomputeImportedRevenueMetricLocked(workspaceID string, st *WorkspaceImportState) {
	var caveats []string
	var nextSteps []string
	unresolvedCount := 0
	for _, g := range st.RepairGaps {
		if !g.Resolved {
			unresolvedCount++
			caveats = append(caveats, g.Reason)
			nextSteps = append(nextSteps, g.RepairCTA)
		}
	}
	conf := adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_MEDIUM
	if unresolvedCount > 0 {
		conf = adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_LOW
	} else if st.SourceBadge == adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL {
		conf = adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH
	}

	origin := "Dữ liệu nhập CSV được ủy quyền (không yêu cầu kết nối API nền tảng)"
	if st.ConnectedAccountsCount > 0 {
		origin = "Đồng bộ từ tài khoản kết nối và dữ liệu nhập đối soát"
	}

	newMetric := StoredMetric{
		MetricKey:          "imported_revenue_p1",
		DisplayName:        "Doanh thu dữ liệu nhập P1",
		AmountCents:        st.GrossRevenueCents,
		Currency:           st.Currency,
		DataSource:         st.SourceBadge,
		Confidence:         conf,
		LastSyncedAt:       st.LastImportedAt,
		DataOrigins:        []string{origin},
		MissingDataCaveats: caveats,
		RecommendedSteps:   nextSteps,
		IsDemoFixture:      false,
	}

	metrics := s.metrics[workspaceID]
	replaced := false
	for i := range metrics {
		if metrics[i].MetricKey == "imported_revenue_p1" {
			metrics[i] = newMetric
			replaced = true
			break
		}
	}
	if !replaced {
		metrics = append(metrics, newMetric)
	}
	s.metrics[workspaceID] = metrics
}

func (s *Service) buildImportProjectionLocked(workspaceID, userID string) AuthorizedImportProjection {
	st := s.imports[workspaceID]
	steps := s.onboarding[workspaceID+":"+userID]
	if len(steps) == 0 {
		steps = make([]bool, 5)
	}
	checklist := s.buildOnboardingChecklistFromSteps(steps)

	if st == nil {
		return AuthorizedImportProjection{
			WorkspaceID:             workspaceID,
			RequiresNativeConnector: false,
			FormattedGrossRevenue:   formatMoney(0, "VND"),
			FormattedNetProfit:      formatMoney(0, "VND"),
			SourceBadge:             adminv1.DataSourceBadge_DATA_SOURCE_BADGE_IMPORTED,
			Confidence:              adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_LOW,
			IsIncomplete:            true,
			PersonalOnboarding:      checklist,
		}
	}

	repairCards := s.buildDataRepairCardsLocked(workspaceID)
	unresolved := len(repairCards)
	conf := adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_MEDIUM
	if unresolved > 0 {
		conf = adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_LOW
	} else if st.SourceBadge == adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL {
		conf = adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH
	}

	netProfit := st.GrossRevenueCents - st.KnownCostsCents
	return AuthorizedImportProjection{
		WorkspaceID:                    workspaceID,
		ConnectedAccountsCount:         st.ConnectedAccountsCount,
		RequiresNativeConnector:        false, // P1 never requires a native platform connector for authorized import
		FormattedGrossRevenue:          formatMoney(st.GrossRevenueCents, st.Currency),
		FormattedNetProfit:             formatMoney(netProfit, st.Currency),
		SourceBadge:                    st.SourceBadge,
		Confidence:                     conf,
		IsIncomplete:                   unresolved > 0,
		UnknownRequiredComponentsCount: unresolved,
		ActiveRepairCards:              repairCards,
		PersonalOnboarding:             checklist,
	}
}

func (s *Service) buildDataRepairCardsLocked(workspaceID string) []*adminv1.DecisionCard {
	st, ok := s.imports[workspaceID]
	if !ok || st == nil {
		return nil
	}
	var cards []*adminv1.DecisionCard
	rank := int32(10)
	for _, g := range st.RepairGaps {
		if g.Resolved {
			continue
		}
		cta := strings.TrimSpace(g.RepairCTA)
		if cta == "" {
			cta = "Bổ sung dữ liệu & chứng từ"
		}
		route := strings.TrimSpace(g.RepairRoute)
		if route == "" {
			route = "/kinh-doanh"
		}
		desc := g.Reason
		if g.AmountCents > 0 {
			desc = fmt.Sprintf("%s (Giá trị ảnh hưởng: %s)", g.Reason, formatMoney(g.AmountCents, st.Currency))
		}
		cards = append(cards, &adminv1.DecisionCard{
			CardId:             "card-repair-" + g.GapID,
			CardFamily:         "data_repair",
			Title:              g.Title,
			Description:        desc,
			PrimaryCtaLabel:    cta,
			PrimaryCtaRoute:    route,
			IsActionAvailable:  true,
			UnavailableReason:  "",
			DataSource:         st.SourceBadge,
			Confidence:         adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_LOW,
			WhyThisMatters:     g.Reason,
			PriorityRank:       rank,
			ModuleRef:          "M19",
			StateType:          adminv1.UIStateType_UI_STATE_TYPE_REPAIR,
			RepairInstructions: g.Reason,
		})
		rank++
	}
	return cards
}

// GetMobileHome implements DashboardService/GetMobileHome.
func (s *Service) GetMobileHome(
	ctx context.Context,
	req *connect.Request[adminv1.GetMobileHomeRequest],
) (*connect.Response[adminv1.GetMobileHomeResponse], error) {
	msg := req.Msg
	if msg == nil || msg.WorkspaceId == nil || msg.WorkspaceId.Value == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	mode := msg.ActiveMode
	if mode == adminv1.OperatorModeId_OPERATOR_MODE_ID_UNSPECIFIED {
		mode = adminv1.OperatorModeId_OPERATOR_MODE_ID_CREATOR
	}

	s.mu.RLock()
	cards := s.buildWorkspaceDecisionCardsLocked(msg.WorkspaceId.Value, mode)
	s.mu.RUnlock()

	caller, hasCaller := CallerFromContext(ctx)
	isViewer := hasCaller && (caller.WorkspaceRole == "viewer" || caller.WorkspaceRole == rbac.RoleViewer)
	if isViewer {
		cards = filterCardsForRole(cards, caller.WorkspaceRole)
	}

	checklist := s.getOnboardingChecklist(msg.WorkspaceId.Value, callerUserID(ctx))
	verifiedRevenue, sourceBadge := s.computeCustomerVerifiedTotalRevenue(msg.WorkspaceId.Value)
	if isViewer {
		verifiedRevenue = ""
		sourceBadge = adminv1.DataSourceBadge_DATA_SOURCE_BADGE_UNSPECIFIED
	}

	resp := &adminv1.GetMobileHomeResponse{
		WorkspaceId:                  msg.WorkspaceId,
		ActiveMode:                   mode,
		MorningBriefHeadline:         s.getMorningBriefHeadline(mode),
		DecisionCards:                cards,
		Onboarding:                   checklist,
		UnreadNotificationCount:      0,
		CustomerVerifiedTotalRevenue: verifiedRevenue,
		RevenueSourceBadge:           sourceBadge,
		GeneratedAt:                  timestamppb.New(time.Now().UTC()),
	}

	return connect.NewResponse(resp), nil
}

// GetPipeline implements DashboardService/GetPipeline.
func (s *Service) GetPipeline(
	ctx context.Context,
	req *connect.Request[adminv1.GetPipelineRequest],
) (*connect.Response[adminv1.GetPipelineResponse], error) {
	msg := req.Msg
	if msg == nil || msg.WorkspaceId == nil || msg.WorkspaceId.Value == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	// P0/P1 Pipeline stub - honest counts without fake live activity
	return connect.NewResponse(&adminv1.GetPipelineResponse{
		WorkspaceId:           msg.WorkspaceId,
		IdeasCount:            0,
		ScriptsCount:          0,
		AssetsGeneratingCount: 0,
		QueuedPublishCount:    0,
		PendingApprovalsCount: 0,
	}), nil
}

// GetDecisionCards implements DashboardService/GetDecisionCards.
func (s *Service) GetDecisionCards(
	ctx context.Context,
	req *connect.Request[adminv1.GetDecisionCardsRequest],
) (*connect.Response[adminv1.GetDecisionCardsResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	mode := msg.OperatorMode
	if mode == adminv1.OperatorModeId_OPERATOR_MODE_ID_UNSPECIFIED {
		mode = adminv1.OperatorModeId_OPERATOR_MODE_ID_CREATOR
	}

	wsID := ""
	if msg.WorkspaceId != nil {
		wsID = msg.WorkspaceId.Value
	}

	s.mu.RLock()
	cards := s.buildWorkspaceDecisionCardsLocked(wsID, mode)
	s.mu.RUnlock()

	if caller, ok := CallerFromContext(ctx); ok && (caller.WorkspaceRole == "viewer" || caller.WorkspaceRole == rbac.RoleViewer) {
		cards = filterCardsForRole(cards, caller.WorkspaceRole)
	}
	return connect.NewResponse(&adminv1.GetDecisionCardsResponse{
		OperatorMode: mode,
		Cards:        cards,
		AsOf:         timestamppb.New(time.Now().UTC()),
	}), nil
}

func (s *Service) buildWorkspaceDecisionCardsLocked(workspaceID string, mode adminv1.OperatorModeId) []*adminv1.DecisionCard {
	baseCards := s.buildDecisionCardsForMode(mode)
	if strings.TrimSpace(workspaceID) == "" {
		return baseCards
	}
	repairCards := s.buildDataRepairCardsLocked(workspaceID)
	if len(repairCards) == 0 {
		return baseCards
	}
	combined := make([]*adminv1.DecisionCard, 0, len(baseCards)+len(repairCards))
	combined = append(combined, baseCards...)
	combined = append(combined, repairCards...)
	return combined
}

func filterCardsForRole(cards []*adminv1.DecisionCard, role string) []*adminv1.DecisionCard {
	if role != "viewer" && role != rbac.RoleViewer {
		return cards
	}
	var filtered []*adminv1.DecisionCard
	for _, c := range cards {
		if c.ModuleRef == "M19" || c.CardFamily == "revenue_today" || c.CardFamily == "profit_anomalies" || c.CardFamily == "data_repair" {
			continue
		}
		filtered = append(filtered, c)
	}
	return filtered
}

// GetWhyThisNumber implements DashboardService/GetWhyThisNumber (RULE-M01-004, RULE-M01-007).
func (s *Service) GetWhyThisNumber(
	ctx context.Context,
	req *connect.Request[adminv1.GetWhyThisNumberRequest],
) (*connect.Response[adminv1.GetWhyThisNumberResponse], error) {
	msg := req.Msg
	if msg == nil || msg.WorkspaceId == nil || msg.MetricKey == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	if caller, ok := CallerFromContext(ctx); ok && (caller.WorkspaceRole == "viewer" || caller.WorkspaceRole == rbac.RoleViewer) {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("home: viewer role is not authorized to view financial metric drilldowns"))
	}

	s.mu.RLock()
	defer s.mu.RUnlock()

	wsMetrics := s.metrics[msg.WorkspaceId.Value]
	var found *StoredMetric
	for _, m := range wsMetrics {
		if m.MetricKey == msg.MetricKey {
			found = &m
			break
		}
	}

	now := time.Now().UTC()
	if found == nil {
		// Default transparent breakdown when no metrics yet
		return connect.NewResponse(&adminv1.GetWhyThisNumberResponse{
			Details: &adminv1.WhyThisNumberDetails{
				MetricKey:            msg.MetricKey,
				DisplayName:          "Doanh thu hôm nay (Chưa có phát sinh)",
				FormattedValue:       "0 ₫",
				DataSource:           adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:           adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				LastSyncedAt:         timestamppb.New(now),
				DataOrigins:          []string{"Chưa có đơn hàng hoặc dữ liệu đối soát phát sinh."},
				MissingDataCaveats:   []string{"Có thể nhập tệp CSV đơn hàng/chi phí hoặc kết nối TikTok Shop / Shopee."},
				RecommendedNextSteps: []string{"Vào Kinh doanh > Nhập dữ liệu CSV hoặc Cài đặt > Kết nối nền tảng."},
				ContainsDemoData:     false,
			},
		}), nil
	}

	return connect.NewResponse(&adminv1.GetWhyThisNumberResponse{
		Details: &adminv1.WhyThisNumberDetails{
			MetricKey:            found.MetricKey,
			DisplayName:          found.DisplayName,
			FormattedValue:       formatMoney(found.AmountCents, found.Currency),
			DataSource:           found.DataSource,
			Confidence:           found.Confidence,
			LastSyncedAt:         timestamppb.New(found.LastSyncedAt),
			DataOrigins:          found.DataOrigins,
			MissingDataCaveats:   found.MissingDataCaveats,
			RecommendedNextSteps: found.RecommendedSteps,
			ContainsDemoData:     found.IsDemoFixture,
		},
	}), nil
}

// CompleteOnboardingStep implements DashboardService/CompleteOnboardingStep.
// Scoped per (workspace_id, user_id) per database_schema.md §27.1 and home_decision_engine.md:
//   - Completing a personal checklist step never changes workspace settings or another user's progress.
//   - In Phase P8, all 5 steps (1: connect_data, 2: select_offer, 3: create_content, 4: publish, 5: track_outcome)
//     are available and can be completed.
//   - First-value (step 1 / data import) and full-loop completion (5/5 steps) remain strictly distinct.
func (s *Service) CompleteOnboardingStep(
	ctx context.Context,
	req *connect.Request[adminv1.CompleteOnboardingStepRequest],
) (*connect.Response[adminv1.CompleteOnboardingStepResponse], error) {
	msg := req.Msg
	if msg == nil || msg.WorkspaceId == nil || msg.StepNumber < 1 || msg.StepNumber > 5 {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	phase := s.getPhaseLocked()
	if (phase == "P0" || phase == "P1") && (msg.StepNumber == 3 || msg.StepNumber == 4) {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrStepUnavailableInPhase)
	}

	key := msg.WorkspaceId.Value + ":" + callerUserID(ctx)
	steps, exists := s.onboarding[key]
	if !exists {
		steps = make([]bool, 5)
	}
	steps[msg.StepNumber-1] = true
	s.onboarding[key] = steps

	checklist := s.buildOnboardingChecklistFromSteps(steps)
	return connect.NewResponse(&adminv1.CompleteOnboardingStepResponse{
		UpdatedChecklist: checklist,
	}), nil
}

// -----------------------------------------------------------------------------
// Decision Cards Priority Matrix Per Operator Mode (Pack 01 §S05.1 & RULE-M01-002)
// -----------------------------------------------------------------------------

func (s *Service) buildDecisionCardsForMode(mode adminv1.OperatorModeId) []*adminv1.DecisionCard {
	phase := s.getPhaseLocked()
	isP0OrP1 := phase == "P0" || phase == "P1"

	switch mode {
	case adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER:
		return []*adminv1.DecisionCard{
			{
				CardId:            "card-seller-orders",
				CardFamily:        "order_queue",
				Title:             "Hàng đợi đơn hàng cần xử lý",
				Description:       "Kiểm tra và chuẩn bị hàng cho các đơn mới phát sinh để đáp ứng SLA sàn.",
				PrimaryCtaLabel:   "Mở danh sách đơn hàng",
				PrimaryCtaRoute:   "/kinh-doanh",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_IMPORTED,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Giao hàng đúng SLA sàn để tránh phạt tỷ lệ trễ hạn.",
				PriorityRank:      1,
				ModuleRef:         "M13",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-seller-revenue",
				CardFamily:        "revenue_today",
				Title:             "Doanh thu bán hàng hôm nay",
				Description:       "Theo dõi số liệu doanh số bán hàng và biên lợi nhuận từ các kênh liên kết.",
				PrimaryCtaLabel:   "Xem đối soát lợi nhuận",
				PrimaryCtaRoute:   "/finance",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Đánh giá nhịp bán hàng và dòng tiền trong ngày.",
				PriorityRank:      2,
				ModuleRef:         "M19",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-seller-stock",
				CardFamily:        "low_stock_alert",
				Title:             "Cảnh báo tồn kho an toàn",
				Description:       "Kiểm tra lượng tồn kho khả dụng và dự báo điểm đặt hàng lại cho các SKU bán chạy.",
				PrimaryCtaLabel:   "Kiểm tra kho hàng",
				PrimaryCtaRoute:   "/kinh-doanh",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Tránh tình trạng đứt hàng khi chiến dịch quảng cáo đang chạy.",
				PriorityRank:      3,
				ModuleRef:         "M13",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-seller-profit",
				CardFamily:        "profit_anomalies",
				Title:             "Đối soát biên lợi nhuận & chi phí sàn",
				Description:       "Phát hiện chênh lệch phí vận chuyển hoặc chiết khấu chưa khớp giữa sàn và sổ cái.",
				PrimaryCtaLabel:   "Xem phân tích lợi nhuận",
				PrimaryCtaRoute:   "/finance",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Bảo vệ biên lợi nhuận ròng trước các loại phí sàn phát sinh bất ngờ.",
				PriorityRank:      4,
				ModuleRef:         "M19",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-seller-messages",
				CardFamily:        "customer_messages",
				Title:             "Hộp thư khách hàng & SLA phản hồi",
				Description:       "Xử lý tin nhắn hỏi mua, đổi trả và tư vấn sản phẩm trước thời hạn SLA 15 phút.",
				PrimaryCtaLabel:   "Mở Hộp thư hợp nhất",
				PrimaryCtaRoute:   "/inbox",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Phản hồi khách mua nhanh tăng tỷ lệ chốt đơn thêm 35%.",
				PriorityRank:      5,
				ModuleRef:         "M12",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
		}

	case adminv1.OperatorModeId_OPERATOR_MODE_ID_AFFILIATE_OPERATOR:
		return []*adminv1.DecisionCard{
			{
				CardId:            "card-affiliate-links",
				CardFamily:        "link_health",
				Title:             "Tình trạng liên kết tiếp thị (Link Health)",
				Description:       "Kiểm tra tính khả dụng và chuyển hướng của 100% affiliate links đã phân phối.",
				PrimaryCtaLabel:   "Xem danh sách links",
				PrimaryCtaRoute:   "/affiliates",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Link hỏng làm mất doanh thu hoa hồng ngay lập tức khi video lên xu hướng.",
				PriorityRank:      1,
				ModuleRef:         "M16",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-affiliate-opportunities",
				CardFamily:        "top_opportunities",
				Title:             "Cơ hội sản phẩm có độ khớp cao (High-Fit)",
				Description:       "5 sản phẩm xu hướng có hoa hồng 18-25% phù hợp với tệp khán giả kênh.",
				PrimaryCtaLabel:   "Khám phá cơ hội",
				PrimaryCtaRoute:   "/kham-pha",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Lựa chọn sản phẩm có chuyển đổi cao tối ưu hóa doanh thu trên mỗi lượt xem.",
				PriorityRank:      2,
				ModuleRef:         "M04",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-affiliate-offers",
				CardFamily:        "top_converting_offers",
				Title:             "Ưu đãi có tỷ lệ chuyển đổi cao nhất",
				Description:       "3 ưu đãi độc quyền kèm coupon giảm giá đặc biệt đang hoạt động hiệu quả.",
				PrimaryCtaLabel:   "Lấy mã ưu đãi",
				PrimaryCtaRoute:   "/offers",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Gắn ưu đãi độc quyền tăng tỷ lệ nhấp và chuyển đổi đơn hàng.",
				PriorityRank:      3,
				ModuleRef:         "M14",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-affiliate-coupons",
				CardFamily:        "coupon_health",
				Title:             "Mã giảm giá sắp hết hạn (Expiring Coupons)",
				Description:       "2 coupon tài trợ sẽ hết hạn trong 48 giờ tới, cần nhắc nhở người xem sử dụng.",
				PrimaryCtaLabel:   "Quản lý mã giảm giá",
				PrimaryCtaRoute:   "/coupons",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Tạo cảm giác gấp gáp để thúc đẩy quyết định mua hàng chốt sale.",
				PriorityRank:      4,
				ModuleRef:         "M14",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-affiliate-attribution",
				CardFamily:        "attributed_revenue",
				Title:             "Doanh thu hoa hồng ghi nhận (Attributed Revenue)",
				Description:       "Theo dõi số dư hoa hồng đã đối soát và sẵn sàng thanh toán.",
				PrimaryCtaLabel:   "Xem phân bổ hoa hồng",
				PrimaryCtaRoute:   "/attribution",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Kiểm tra minh bạch dòng tiền hoa hồng đối soát từ các mạng tiếp thị.",
				PriorityRank:      5,
				ModuleRef:         "M16",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
		}

	case adminv1.OperatorModeId_OPERATOR_MODE_ID_LIVE_OPERATOR:
		return []*adminv1.DecisionCard{
			{
				CardId:            "card-live-readiness",
				CardFamily:        "live_readiness",
				Title:             "Checklist sẵn sàng phiên Live (War Room)",
				Description:       "Kiểm tra đường truyền, kịch bản ghim sản phẩm và voucher tài trợ trước giờ live.",
				PrimaryCtaLabel:   "Mở War Room",
				PrimaryCtaRoute:   "/live",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Chuẩn bị kỹ trước giờ phát sóng tránh sự cố kỹ thuật và tối ưu GMV phiên live.",
				PriorityRank:      1,
				ModuleRef:         "M17",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-live-cue",
				CardFamily:        "cue_cards",
				Title:             "Thẻ kịch bản & thứ tự ghim sản phẩm (Cue Cards)",
				Description:       "Lịch trình 15 sản phẩm kèm thời điểm tung deal chớp nhoáng (Flash Sale) trong phiên live.",
				PrimaryCtaLabel:   "Xem kịch bản live",
				PrimaryCtaRoute:   "/live",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Giữ nhịp điệu phiên live liền mạch và kích thích người xem đặt hàng đúng thời điểm.",
				PriorityRank:      2,
				ModuleRef:         "M17",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-live-offers",
				CardFamily:        "pinned_offers",
				Title:             "Sản phẩm ghim & Voucher độc quyền phiên live",
				Description:       "Cấu hình số lượng tồn kho và mức giảm giá đặc biệt chỉ áp dụng trong livestream.",
				PrimaryCtaLabel:   "Thiết lập ưu đãi live",
				PrimaryCtaRoute:   "/offers",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Ưu đãi độc quyền livestream là yếu tố quyết định chuyển đổi trực tiếp.",
				PriorityRank:      3,
				ModuleRef:         "M14",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-live-comments",
				CardFamily:        "comment_surge",
				Title:             "Điều phối bình luận & câu hỏi trực tiếp",
				Description:       "Hàng đợi câu hỏi về size/màu sắc từ người xem cần người dẫn hoặc trợ lý giải đáp ngay.",
				PrimaryCtaLabel:   "Xem bình luận live",
				PrimaryCtaRoute:   "/inbox",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Trả lời câu hỏi người xem ngay lập tức trên sóng tăng tỷ lệ chốt đơn.",
				PriorityRank:      4,
				ModuleRef:         "M12",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-live-highlights",
				CardFamily:        "post_live_summary",
				Title:             "Cắt khoảnh khắc nổi bật (Highlights) & Đánh giá sau live",
				Description:       "Tự động trích xuất các khoảnh khắc nổ đơn cao điểm để tạo video ngắn phân phối lại.",
				PrimaryCtaLabel:   "Tạo clip nổi bật",
				PrimaryCtaRoute:   "/studio",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Tái sử dụng nội dung live thành video ngắn kéo đơn hàng dài hạn sau buổi live.",
				PriorityRank:      5,
				ModuleRef:         "M09",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
		}

	case adminv1.OperatorModeId_OPERATOR_MODE_ID_AGENCY_MCN:
		return []*adminv1.DecisionCard{
			{
				CardId:            "card-agency-approvals",
				CardFamily:        "pending_approvals",
				Title:             "Hàng đợi phê duyệt kịch bản & video đối tác",
				Description:       "4 kịch bản và 2 video từ các creator trong mạng lưới đang chờ khách hàng duyệt.",
				PrimaryCtaLabel:   "Xem hàng đợi phê duyệt",
				PrimaryCtaRoute:   "/workflows",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Bảo đảm chất lượng nội dung và đúng cam kết thương hiệu trước khi đăng tải.",
				PriorityRank:      1,
				ModuleRef:         "M20",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-agency-diagnostics",
				CardFamily:        "diagnostics_issues",
				Title:             "Chẩn đoán tình trạng đa workspace & Token",
				Description:       "Kiểm tra trạng thái kết nối và phân quyền của 12 workspace khách hàng được quản lý.",
				PrimaryCtaLabel:   "Xem chẩn đoán hệ thống",
				PrimaryCtaRoute:   "/settings/diagnostics",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Phát hiện sớm lỗi mất kết nối token để tránh gián đoạn tiến độ chiến dịch.",
				PriorityRank:      2,
				ModuleRef:         "M22",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-agency-creators",
				CardFamily:        "creator_scorecards",
				Title:             "Bảng điểm hiệu suất creator (Scorecards)",
				Description:       "Đánh giá mức độ hoàn thành KPI, tỷ lệ đúng hạn và điểm chất lượng nội dung.",
				PrimaryCtaLabel:   "Xem danh sách creator",
				PrimaryCtaRoute:   "/workspaces",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Phân bổ hợp đồng và ngân sách cho creator có hiệu suất cao nhất.",
				PriorityRank:      3,
				ModuleRef:         "M22",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-agency-deliverables",
				CardFamily:        "at_risk_deliverables",
				Title:             "Hạng mục bàn giao có rủi ro trễ hạn",
				Description:       "1 video tài trợ cần giao khách hàng trong vòng 24 giờ tới đang ở khâu dựng.",
				PrimaryCtaLabel:   "Xử lý tiến độ bàn giao",
				PrimaryCtaRoute:   "/campaigns",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Đảm bảo SLA bàn giao với nhãn hàng để duy trì quan hệ đối tác lâu dài.",
				PriorityRank:      4,
				ModuleRef:         "M14",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-agency-reports",
				CardFamily:        "report_deadlines",
				Title:             "Báo cáo định kỳ cho khách hàng & nhãn hàng",
				Description:       "Tổng hợp số liệu tiếp cận, lượt xem và chuyển đổi cho báo cáo tuần của chiến dịch.",
				PrimaryCtaLabel:   "Xuất báo cáo đối tác",
				PrimaryCtaRoute:   "/creator-pro",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Minh bạch số liệu hiệu quả giúp gia hạn hợp đồng quản lý với khách hàng.",
				PriorityRank:      5,
				ModuleRef:         "S16",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
		}

	case adminv1.OperatorModeId_OPERATOR_MODE_ID_BRAND_COLLABORATION:
		return []*adminv1.DecisionCard{
			{
				CardId:            "card-brand-inquiries",
				CardFamily:        "sponsor_inquiries",
				Title:             "Yêu cầu hợp tác & booking tài trợ mới",
				Description:       "Kiểm tra các lời mời hợp tác từ nhãn hàng gửi vào hộp thư.",
				PrimaryCtaLabel:   "Mở danh sách booking",
				PrimaryCtaRoute:   "/creator-pro",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Phản hồi nhãn hàng nhanh trong 24h giúp giữ deal giá trị cao.",
				PriorityRank:      1,
				ModuleRef:         "S16",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-brand-deliverables",
				CardFamily:        "deliverable_deadlines",
				Title:             "Hạn chót bàn giao nội dung tài trợ (Deadlines)",
				Description:       "2 bài đăng sponsored post đã được duyệt, chuẩn bị lên sóng theo lịch cam kết.",
				PrimaryCtaLabel:   "Kiểm tra lịch phát sóng",
				PrimaryCtaRoute:   "/xuat-ban",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Tuân thủ đúng khung giờ cam kết trong hợp đồng tài trợ thương hiệu.",
				PriorityRank:      2,
				ModuleRef:         "M11",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-brand-proof",
				CardFamily:        "proof_bundles",
				Title:             "Gói chứng nhận kết quả nghiệm thu (Proof Bundles)",
				Description:       "Tập hợp ảnh chụp màn hình chỉ số, link bài đăng và xác nhận đối soát lượt xem.",
				PrimaryCtaLabel:   "Tạo gói nghiệm thu",
				PrimaryCtaRoute:   "/seeding",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Bằng chứng nghiệm thu đầy đủ giúp giải ngân hợp đồng tài trợ nhanh chóng.",
				PriorityRank:      3,
				ModuleRef:         "M18",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-brand-invoices",
				CardFamily:        "payout_tracking",
				Title:             "Theo dõi thanh toán hợp đồng & Giải ngân (Payouts)",
				Description:       "1 hóa đơn thanh toán đợt 2 của nhãn hàng đang chờ đối soát tài khoản.",
				PrimaryCtaLabel:   "Kiểm tra tiến độ thanh toán",
				PrimaryCtaRoute:   "/finance",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Đảm bảo đối soát chính xác các đợt thanh toán từ đối tác thương hiệu.",
				PriorityRank:      4,
				ModuleRef:         "M19",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-brand-evidence",
				CardFamily:        "performance_evidence",
				Title:             "Bằng chứng chuyển đổi & ROI chiến dịch",
				Description:       "Báo cáo phân bổ đơn hàng và tỷ lệ chuyển đổi mã giảm giá tài trợ độc quyền.",
				PrimaryCtaLabel:   "Xem bằng chứng ROI",
				PrimaryCtaRoute:   "/attribution",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Chứng minh ROI thực tế là chìa khóa để ký hợp đồng tài trợ dài hạn.",
				PriorityRank:      5,
				ModuleRef:         "M16",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
		}

	default: // OPERATOR_MODE_ID_CREATOR
		creatorScriptAvailable := !isP0OrP1
		creatorScriptReason := ""
		if isP0OrP1 {
			creatorScriptReason = "Script Lab M06 và AI Studio M07 sẽ được kích hoạt ở Phase P3/P4."
		}
		return []*adminv1.DecisionCard{
			{
				CardId:            "card-creator-trend",
				CardFamily:        "top_opportunities",
				Title:             "Cơ hội xu hướng FMCG & Đồ gia dụng thông minh",
				Description:       "Âm thanh và chủ đề xu hướng tăng trưởng 120% trong 24 giờ qua trên TikTok Shop.",
				PrimaryCtaLabel:   "Khám phá tín hiệu xu hướng",
				PrimaryCtaRoute:   "/kham-pha",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Bắt nhịp xu hướng sớm tăng lượt xem tự nhiên lên gấp 3 lần.",
				PriorityRank:      1,
				ModuleRef:         "M02",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-creator-ideas",
				CardFamily:        "ideas_and_scripts",
				Title:             "5 ý tưởng video mới từ Trend Radar",
				Description:       "Ý tưởng nội dung kèm 3 góc hook đã sẵn sàng để phát triển thành kịch bản hoàn chỉnh.",
				PrimaryCtaLabel:   "Mở Idea Engine",
				PrimaryCtaRoute:   "/ideas",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Chuyển hóa tín hiệu xu hướng thành nội dung cụ thể trong vòng 24h.",
				PriorityRank:      2,
				ModuleRef:         "M05",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-creator-script",
				CardFamily:        "ideas_and_scripts",
				Title:             "3 kịch bản AI Video Studio đề xuất",
				Description:       "Kịch bản dạng unboxing và review thực tế được tạo tự động cho sản phẩm chọn lọc.",
				PrimaryCtaLabel:   "Mở Script Lab",
				PrimaryCtaRoute:   "/scripts",
				IsActionAvailable: creatorScriptAvailable,
				UnavailableReason: creatorScriptReason,
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Kịch bản có cấu trúc giữ chân người xem qua 3 giây đầu tiên.",
				PriorityRank:      3,
				ModuleRef:         "M06",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-creator-publish",
				CardFamily:        "publish_schedule",
				Title:             "Lịch đăng bài khung giờ vàng (19:30 - 21:00)",
				Description:       "Lên lịch sẵn bài đăng đa kênh TikTok, Reels và YouTube Shorts.",
				PrimaryCtaLabel:   "Mở Publish Hub",
				PrimaryCtaRoute:   "/xuat-ban",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Đăng đúng khung giờ vàng tiếp cận tối đa tệp khán giả mục tiêu.",
				PriorityRank:      4,
				ModuleRef:         "M11",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-creator-comments",
				CardFamily:        "customer_messages",
				Title:             "Bình luận cần phản hồi & tương tác khán giả",
				Description:       "12 bình luận hỏi mua và quan tâm nội dung đang chờ tương tác trong Hộp thư.",
				PrimaryCtaLabel:   "Mở Unified Inbox",
				PrimaryCtaRoute:   "/inbox",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Tương tác nhanh trong 1 giờ đầu giúp đẩy video vào luồng phân phối.",
				PriorityRank:      5,
				ModuleRef:         "M12",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-creator-earnings",
				CardFamily:        "revenue_today",
				Title:             "Thu nhập & hoa hồng ước tính hôm nay",
				Description:       "Theo dõi doanh thu hoa hồng affiliate và thưởng hiệu suất từ các video đang phân phối.",
				PrimaryCtaLabel:   "Xem Sổ cái lợi nhuận",
				PrimaryCtaRoute:   "/finance",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Nắm bắt thu nhập thực tế đã đối soát để tối ưu hóa nguồn lực sáng tạo.",
				PriorityRank:      6,
				ModuleRef:         "M19",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-creator-repair",
				CardFamily:        "diagnostics_issues",
				Title:             "Kiểm tra kết nối tài khoản & phân quyền",
				Description:       "Toàn bộ tài khoản và kết nối nền tảng hoạt động bình thường.",
				PrimaryCtaLabel:   "Xem chẩn đoán hệ thống",
				PrimaryCtaRoute:   "/settings/diagnostics",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Đảm bảo token kết nối luôn hợp lệ để không gián đoạn lịch đăng.",
				PriorityRank:      7,
				ModuleRef:         "M22",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
		}
	}
}

func (s *Service) getMorningBriefHeadline(mode adminv1.OperatorModeId) string {
	switch mode {
	case adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER:
		return "Chào buổi sáng, Nhà bán hàng! Hôm nay tập trung xử lý đơn hàng và đối soát biên lợi nhuận."
	case adminv1.OperatorModeId_OPERATOR_MODE_ID_AFFILIATE_OPERATOR:
		return "Chào buổi sáng! 3 chiến dịch hoa hồng cao đang mở thưởng cho affiliate hôm nay."
	case adminv1.OperatorModeId_OPERATOR_MODE_ID_LIVE_OPERATOR:
		return "Chào buổi sáng! Chuẩn bị kịch bản và ghim sản phẩm cho phiên Live lúc 20:00."
	case adminv1.OperatorModeId_OPERATOR_MODE_ID_AGENCY_MCN:
		return "Chào buổi sáng! 5 nội dung đang chờ phê duyệt chéo giữa các workspace khách hàng."
	case adminv1.OperatorModeId_OPERATOR_MODE_ID_BRAND_COLLABORATION:
		return "Chào buổi sáng! 2 nhãn hàng mới gửi yêu cầu hợp tác trong vòng 12 giờ qua."
	default:
		return "Chào buổi sáng, Nhà sáng tạo! Nắm bắt 1 xu hướng nổi bật và tạo video bán hàng hôm nay."
	}
}

// computeCustomerVerifiedTotalRevenue guarantees that DEMO fixtures are NEVER added to customer totals.
func (s *Service) computeCustomerVerifiedTotalRevenue(workspaceID string) (string, adminv1.DataSourceBadge) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return s.computeCustomerVerifiedTotalRevenueLocked(workspaceID)
}

func (s *Service) computeCustomerVerifiedTotalRevenueLocked(workspaceID string) (string, adminv1.DataSourceBadge) {
	wsMetrics := s.metrics[workspaceID]
	totalCents := int64(0)
	hasOfficial := false
	hasImported := false

	for _, m := range wsMetrics {
		// HARD RULE: Zero demo data in customer totals
		if m.IsDemoFixture || m.DataSource == adminv1.DataSourceBadge_DATA_SOURCE_BADGE_DEMO {
			continue
		}
		totalCents += m.AmountCents
		if m.DataSource == adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL {
			hasOfficial = true
		} else if m.DataSource == adminv1.DataSourceBadge_DATA_SOURCE_BADGE_IMPORTED {
			hasImported = true
		}
	}

	badge := adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL
	if !hasOfficial && hasImported {
		badge = adminv1.DataSourceBadge_DATA_SOURCE_BADGE_IMPORTED
	}

	return formatMoney(totalCents, "VND"), badge
}

func (s *Service) getOnboardingChecklist(workspaceID, userID string) *adminv1.OnboardingChecklist {
	s.mu.RLock()
	defer s.mu.RUnlock()

	key := workspaceID + ":" + userID
	steps, exists := s.onboarding[key]
	if !exists {
		steps = make([]bool, 5)
	}
	return s.buildOnboardingChecklistFromSteps(steps)
}

func (s *Service) buildOnboardingChecklistFromSteps(steps []bool) *adminv1.OnboardingChecklist {
	phase := s.getPhaseLocked()
	isP0OrP1 := phase == "P0" || phase == "P1"

	createContentDesc := ""
	publishDesc := ""
	if isP0OrP1 {
		createContentDesc = "AI Video Studio M07 sẽ khả dụng tại Phase P4."
		publishDesc = "Publish Hub M11 sẽ khả dụng tại Phase P5."
	}

	stepDefs := []struct {
		key         string
		title       string
		desc        string
		available   bool
		unavailDesc string
	}{
		{
			key:         "connect_data",
			title:       "Kết nối tài khoản hoặc nhập dữ liệu mẫu",
			desc:        "Nhập tệp CSV sản phẩm/đơn hàng/chi phí hợp lệ hoặc liên kết kênh bán qua OAuth.",
			available:   true,
			unavailDesc: "",
		},
		{
			key:         "select_offer",
			title:       "Tạo hoặc chọn sản phẩm kinh doanh",
			desc:        "Thiết lập danh mục sản phẩm, biến thể SKU và tồn kho trong Product Hub (M13).",
			available:   true,
			unavailDesc: "",
		},
		{
			key:         "create_content",
			title:       "Tạo kịch bản và tài sản video AI",
			desc:        "Sản xuất kịch bản và video bán hàng tự động bằng Script Lab (M06) & AI Video Studio (M07).",
			available:   !isP0OrP1,
			unavailDesc: createContentDesc,
		},
		{
			key:         "publish",
			title:       "Xuất bản đa kênh chuẩn lịch vàng",
			desc:        "Phân phối video đồng thời lên TikTok, Reels và YouTube Shorts qua Publish Hub (M11).",
			available:   !isP0OrP1,
			unavailDesc: publishDesc,
		},
		{
			key:         "track_outcome",
			title:       "Đo lường doanh thu và lợi nhuận thực tế",
			desc:        "Xem đối soát chi phí, chứng từ và biên lợi nhuận ròng trên Sổ cái (M19).",
			available:   true,
			unavailDesc: "",
		},
	}

	completedCount := int32(0)
	allStepsAvailable := true
	var pbSteps []*adminv1.OnboardingStepProgress
	for i, d := range stepDefs {
		if !d.available {
			allStepsAvailable = false
		}
		completed := false
		if d.available && i < len(steps) {
			completed = steps[i]
		}
		if completed {
			completedCount++
		}
		pbSteps = append(pbSteps, &adminv1.OnboardingStepProgress{
			StepNumber:        int32(i + 1),
			StepKey:           d.key,
			Title:             d.title,
			Description:       d.desc,
			IsCompleted:       completed,
			IsAvailable:       d.available,
			UnavailableReason: d.unavailDesc,
		})
	}

	firstValueComplete := false
	if len(steps) > 0 && steps[0] {
		firstValueComplete = true
	}

	return &adminv1.OnboardingChecklist{
		Steps:                pbSteps,
		CompletedCount:       completedCount,
		TotalSteps:           5,
		IsClosedLoopComplete: allStepsAvailable && completedCount == 5,
		IsFirstValueComplete: firstValueComplete,
	}
}

func formatMoney(cents int64, currency string) string {
	if currency == "" {
		currency = "VND"
	}
	neg := cents < 0
	absCents := cents
	if neg {
		absCents = -cents
	}
	prefix := ""
	if neg {
		prefix = "-"
	}
	// For VND, amount in whole units (1,000,000 đ)
	if currency == "VND" {
		raw := fmt.Sprintf("%d", absCents)
		var parts []string
		for len(raw) > 3 {
			parts = append([]string{raw[len(raw)-3:]}, parts...)
			raw = raw[:len(raw)-3]
		}
		if len(raw) > 0 {
			parts = append([]string{raw}, parts...)
		}
		return prefix + strings.Join(parts, ".") + " ₫"
	}
	dollars := absCents / 100
	remainder := absCents % 100
	return fmt.Sprintf("%s$%d.%02d", prefix, dollars, remainder)
}
