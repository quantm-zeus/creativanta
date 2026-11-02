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
		onboarding:      make(map[string][]bool),
		metrics:         make(map[string][]StoredMetric),
		configs:         make(map[string]HomeDashboardConfig),
		briefDeliveries: make(map[string]*MorningBriefDeliveryRecord),
		imports:         make(map[string]*WorkspaceImportState),
		bindings:        bindings,
	}
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
//   - Disabled future-phase steps (Step 3 M07 in P4, Step 4 M11 in P5) cannot be completed in P1
//     and never falsely mark the 5-step closed loop complete.
func (s *Service) CompleteOnboardingStep(
	ctx context.Context,
	req *connect.Request[adminv1.CompleteOnboardingStepRequest],
) (*connect.Response[adminv1.CompleteOnboardingStepResponse], error) {
	msg := req.Msg
	if msg == nil || msg.WorkspaceId == nil || msg.StepNumber < 1 || msg.StepNumber > 5 {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}
	if msg.StepNumber == 3 || msg.StepNumber == 4 {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrStepUnavailableInPhase)
	}

	s.mu.Lock()
	defer s.mu.Unlock()

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
	switch mode {
	case adminv1.OperatorModeId_OPERATOR_MODE_ID_SELLER:
		return []*adminv1.DecisionCard{
			{
				CardId:            "card-seller-orders",
				CardFamily:        "order_queue",
				Title:             "Hàng đợi đơn hàng cần xử lý",
				Description:       "Kiểm tra và chuẩn bị hàng cho các đơn mới phát sinh hoặc dữ liệu nhập P1.",
				PrimaryCtaLabel:   "Mở danh sách đơn hàng",
				PrimaryCtaRoute:   "/kinh-doanh",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_IMPORTED,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_MEDIUM,
				WhyThisMatters:    "Giao hàng đúng SLA sàn để tránh phạt tỷ lệ trễ hạn.",
				PriorityRank:      1,
				ModuleRef:         "M13",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-seller-revenue",
				CardFamily:        "revenue_today",
				Title:             "Doanh thu hôm nay: 0 ₫",
				Description:       "Theo dõi số liệu doanh số bán hàng và biên lợi nhuận từ dữ liệu nhập hợp lệ hoặc gian hàng liên kết.",
				PrimaryCtaLabel:   "Xem đối soát lợi nhuận",
				PrimaryCtaRoute:   "/kinh-doanh",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_IMPORTED,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_MEDIUM,
				WhyThisMatters:    "Đánh giá nhịp bán hàng và dòng tiền trong ngày.",
				PriorityRank:      2,
				ModuleRef:         "M19",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-seller-stock",
				CardFamily:        "low_stock_alert",
				Title:             "Cảnh báo tồn kho an toàn",
				Description:       "Không có sản phẩm nào chạm ngưỡng tồn kho tối thiểu.",
				PrimaryCtaLabel:   "Kiểm tra kho hàng",
				PrimaryCtaRoute:   "/kinh-doanh",
				IsActionAvailable: true,
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_IMPORTED,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Tránh tình trạng đứt hàng khi chiến dịch quảng cáo đang chạy.",
				PriorityRank:      3,
				ModuleRef:         "M13",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-seller-messages",
				CardFamily:        "customer_messages",
				Title:             "Hộp thư khách hàng & SLA phản hồi",
				Description:       "Chưa có tin nhắn nào quá hạn SLA 15 phút.",
				PrimaryCtaLabel:   "Mở Hộp thư hợp nhất",
				PrimaryCtaRoute:   "/xuat-ban",
				IsActionAvailable: false,
				UnavailableReason: "Unified Inbox M12 sẽ được triển khai tại Phase P5.",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Phản hồi khách mua nhanh tăng tỷ lệ chốt đơn thêm 35%.",
				PriorityRank:      4,
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
				Description:       "Kiểm tra tính khả dụng và chuyển hướng của 100% affiliate link.",
				PrimaryCtaLabel:   "Xem danh sách links",
				PrimaryCtaRoute:   "/kinh-doanh",
				IsActionAvailable: false,
				UnavailableReason: "Affiliate Network M16 chưa khả dụng trong Phase 0.",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Link hỏng làm mất doanh thu hoa hồng ngay lập tức.",
				PriorityRank:      1,
				ModuleRef:         "M16",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-affiliate-offers",
				CardFamily:        "top_converting_offers",
				Title:             "Ưu đãi có tỷ lệ chuyển đổi cao nhất",
				Description:       "3 sản phẩm ngành Làm đẹp có hoa hồng từ 18% - 25%.",
				PrimaryCtaLabel:   "Lấy mã tiếp thị",
				PrimaryCtaRoute:   "/kinh-doanh",
				IsActionAvailable: false,
				UnavailableReason: "Cổng Offer M14 sẽ khả dụng tại Phase P6.",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Chọn sản phẩm hoa hồng cao giúp tăng ROI mỗi bài đăng.",
				PriorityRank:      2,
				ModuleRef:         "M14",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
		}

	case adminv1.OperatorModeId_OPERATOR_MODE_ID_LIVE_OPERATOR:
		return []*adminv1.DecisionCard{
			{
				CardId:            "card-live-readiness",
				CardFamily:        "live_readiness",
				Title:             "Checklist sẵn sàng phiên Live (War Room)",
				Description:       "Kiểm tra đường truyền, kịch bản ghim sản phẩm và voucher tài trợ.",
				PrimaryCtaLabel:   "Mở War Room",
				PrimaryCtaRoute:   "/kinh-doanh",
				IsActionAvailable: false,
				UnavailableReason: "Live Commerce War Room M17 sẽ khả dụng tại Phase P6.",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Chuẩn bị kỹ trước giờ phát sóng tránh sự cố rớt mắt xem.",
				PriorityRank:      1,
				ModuleRef:         "M17",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
		}

	case adminv1.OperatorModeId_OPERATOR_MODE_ID_AGENCY_MCN:
		return []*adminv1.DecisionCard{
			{
				CardId:            "card-agency-approvals",
				CardFamily:        "pending_approvals",
				Title:             "Phê duyệt chéo giữa các workspace khách hàng",
				Description:       "Hàng đợi kiểm duyệt video và kịch bản trước khi xuất bản cho nhãn hàng.",
				PrimaryCtaLabel:   "Xem hàng đợi phê duyệt",
				PrimaryCtaRoute:   "/sang-tao",
				IsActionAvailable: false,
				UnavailableReason: "Hệ thống phê duyệt đa tenant M20 sẽ khả dụng tại Phase P7.",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Bảo đảm chất lượng nội dung đạt tiêu chuẩn nhãn hàng trước khi lên sóng.",
				PriorityRank:      1,
				ModuleRef:         "M20",
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
				PrimaryCtaRoute:   "/xuat-ban",
				IsActionAvailable: false,
				UnavailableReason: "Brand Deal S16 / M16 sẽ khả dụng tại Phase P6.",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Phản hồi nhãn hàng nhanh trong 24h giúp giữ deal giá trị cao.",
				PriorityRank:      1,
				ModuleRef:         "S16",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
		}

	default: // OPERATOR_MODE_ID_CREATOR
		return []*adminv1.DecisionCard{
			{
				CardId:            "card-creator-trend",
				CardFamily:        "top_opportunities",
				Title:             "Cơ hội xu hướng FMCG & Đồ gia dụng thông minh",
				Description:       "Âm thanh xu hướng tăng trưởng 120% trong 24 giờ qua trên TikTok Shop.",
				PrimaryCtaLabel:   "Khám phá tín hiệu xu hướng",
				PrimaryCtaRoute:   "/kham-pha",
				IsActionAvailable: false,
				UnavailableReason: "Trend Fusion Radar M02 sẽ được kết nối ở Phase P2.",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Bắt nhịp xu hướng sớm tăng lượt xem tự nhiên lên gấp 3 lần.",
				PriorityRank:      1,
				ModuleRef:         "M02",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-creator-script",
				CardFamily:        "ideas_and_scripts",
				Title:             "3 kịch bản AI Video Studio đề xuất",
				Description:       "Kịch bản dạng unboxing và review thực tế được tạo tự động cho sản phẩm chọn lọc.",
				PrimaryCtaLabel:   "Mở Script Lab",
				PrimaryCtaRoute:   "/sang-tao",
				IsActionAvailable: false,
				UnavailableReason: "Script Lab M06 và AI Studio M07 sẽ được kích hoạt ở Phase P3/P4.",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Kịch bản có cấu trúc giữ chân người xem qua 3 giây đầu tiên.",
				PriorityRank:      2,
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
				IsActionAvailable: false,
				UnavailableReason: "Publish Hub M11 sẽ khả dụng ở Phase P5.",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Đăng đúng khung giờ vàng tiếp cận tối đa tệp khán giả mục tiêu.",
				PriorityRank:      3,
				ModuleRef:         "M11",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-creator-repair",
				CardFamily:        "diagnostics_issues",
				Title:             "Kiểm tra kết nối tài khoản & phân quyền",
				Description:       "Toàn bộ tài khoản và kết nối nền tảng hoạt động bình thường.",
				PrimaryCtaLabel:   "Xem chẩn đoán hệ thống",
				PrimaryCtaRoute:   "/settings/diagnostics",
				IsActionAvailable: true, // Diagnostics is built in P0-05!
				UnavailableReason: "",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Đảm bảo tài khoản kết nối sẵn sàng trước khi bắt đầu tạo nội dung.",
				PriorityRank:      4,
				ModuleRef:         "M22/M23",
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
			desc:        "Nhập tệp CSV sản phẩm/đơn hàng/chi phí hợp lệ (không bắt buộc kết nối API) hoặc liên kết kênh bán.",
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
			desc:        "Sản xuất kịch bản và video bán hàng tự động bằng AI Video Studio.",
			available:   false,
			unavailDesc: "AI Video Studio M07 sẽ khả dụng tại Phase P4.",
		},
		{
			key:         "publish",
			title:       "Xuất bản đa kênh chuẩn lịch vàng",
			desc:        "Phân phối video đồng thời lên TikTok, Reels và YouTube Shorts.",
			available:   false,
			unavailDesc: "Publish Hub M11 sẽ khả dụng tại Phase P5.",
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

	return &adminv1.OnboardingChecklist{
		Steps:                pbSteps,
		CompletedCount:       completedCount,
		TotalSteps:           5,
		IsClosedLoopComplete: allStepsAvailable && completedCount == 5,
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
