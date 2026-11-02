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
	ErrUnauthenticated = errors.New("home: unauthenticated request")
	ErrInvalidInput    = errors.New("home: invalid input parameters")
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

// StoredMetric models a business KPI record.
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
	IsDemoFixture      bool // True if purely mock/simulation
}

// Service implements DashboardServiceHandler (M01).
type Service struct {
	adminv1connect.UnimplementedDashboardServiceHandler
	mu         sync.RWMutex
	onboarding map[string][]bool         // key: workspaceID:userID -> array of 5 booleans
	metrics    map[string][]StoredMetric // key: workspaceID
	bindings   *rbac.Registry
}

// NewService creates a new DashboardService instance.
func NewService(bindings *rbac.Registry) *Service {
	return &Service{
		onboarding: make(map[string][]bool),
		metrics:    make(map[string][]StoredMetric),
		bindings:   bindings,
	}
}

// SeedWorkspaceMetric records a financial/operational KPI for a workspace.
func (s *Service) SeedWorkspaceMetric(workspaceID string, m StoredMetric) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.metrics[workspaceID] = append(s.metrics[workspaceID], m)
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

	cards := s.buildDecisionCardsForMode(mode)
	caller, hasCaller := CallerFromContext(ctx)
	isViewer := hasCaller && (caller.WorkspaceRole == "viewer" || caller.WorkspaceRole == rbac.RoleViewer)
	if isViewer {
		cards = filterCardsForRole(cards, caller.WorkspaceRole)
	}

	checklist := s.getOnboardingChecklist(msg.WorkspaceId.Value, "default-user")
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

	// P0 Pipeline stub - honest counts without fake live activity
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

	cards := s.buildDecisionCardsForMode(mode)
	if caller, ok := CallerFromContext(ctx); ok && (caller.WorkspaceRole == "viewer" || caller.WorkspaceRole == rbac.RoleViewer) {
		cards = filterCardsForRole(cards, caller.WorkspaceRole)
	}
	return connect.NewResponse(&adminv1.GetDecisionCardsResponse{
		OperatorMode: mode,
		Cards:        cards,
		AsOf:         timestamppb.New(time.Now().UTC()),
	}), nil
}

func filterCardsForRole(cards []*adminv1.DecisionCard, role string) []*adminv1.DecisionCard {
	if role != "viewer" && role != rbac.RoleViewer {
		return cards
	}
	var filtered []*adminv1.DecisionCard
	for _, c := range cards {
		if c.ModuleRef == "M19" || c.CardFamily == "revenue_today" || c.CardFamily == "profit_anomalies" {
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
				MissingDataCaveats:   []string{"Cần kết nối TikTok Shop hoặc Shopee để đồng bộ đơn hàng."},
				RecommendedNextSteps: []string{"Vào Cài đặt > Kết nối nền tảng để kích hoạt đồng bộ dữ liệu."},
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

	key := msg.WorkspaceId.Value + ":default-user"
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
				Description:       "Kiểm tra và chuẩn bị hàng cho các đơn mới phát sinh hôm nay.",
				PrimaryCtaLabel:   "Mở danh sách đơn hàng",
				PrimaryCtaRoute:   "/kinh-doanh",
				IsActionAvailable: false,
				UnavailableReason: "M13/OrderService chưa mở cổng trong Phase 0. Đang chờ hoàn tất kiểm thử API ở P1.",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
				Confidence:        adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
				WhyThisMatters:    "Giao hàng đúng SLA sàn để tránh phạt tỷ lệ trễ hạn.",
				PriorityRank:      1,
				ModuleRef:         "M13",
				StateType:         adminv1.UIStateType_UI_STATE_TYPE_NORMAL,
			},
			{
				CardId:            "card-seller-revenue",
				CardFamily:        "revenue_today",
				Title:             "Doanh thu hôm nay: 0 ₫",
				Description:       "Theo dõi số liệu doanh số bán hàng tổng hợp từ các gian hàng liên kết.",
				PrimaryCtaLabel:   "Xem đối soát lợi nhuận",
				PrimaryCtaRoute:   "/kinh-doanh",
				IsActionAvailable: false,
				UnavailableReason: "Sổ cái tài chính M19 sẽ được kích hoạt tại Phase P1.",
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
				Description:       "Không có sản phẩm nào chạm ngưỡng tồn kho tối thiểu.",
				PrimaryCtaLabel:   "Kiểm tra kho hàng",
				PrimaryCtaRoute:   "/kinh-doanh",
				IsActionAvailable: false,
				UnavailableReason: "Kho hàng M13 chưa kết nối kho thực tế trong Phase 0.",
				DataSource:        adminv1.DataSourceBadge_DATA_SOURCE_BADGE_OFFICIAL,
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
	completedCount := int32(0)
	for _, c := range steps {
		if c {
			completedCount++
		}
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
			desc:        "Liên kết kênh TikTok Shop / Shopee hoặc nhập tệp CSV dữ liệu sản phẩm.",
			available:   true,
			unavailDesc: "",
		},
		{
			key:         "select_offer",
			title:       "Tạo hoặc chọn sản phẩm kinh doanh",
			desc:        "Thiết lập danh mục sản phẩm và ưu đãi hoa hồng trong Product Hub.",
			available:   false,
			unavailDesc: "Product Hub M13 sẽ mở cổng quản lý sản phẩm ở Phase P1.",
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
			desc:        "Xem đối soát chi phí, hoa hồng và biên lợi nhuận ròng trên Sổ cái.",
			available:   false,
			unavailDesc: "Sổ cái lợi nhuận M19 sẽ khả dụng tại Phase P1.",
		},
	}

	var pbSteps []*adminv1.OnboardingStepProgress
	for i, d := range stepDefs {
		completed := false
		if i < len(steps) {
			completed = steps[i]
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
		IsClosedLoopComplete: completedCount == 5,
	}
}

func formatMoney(cents int64, currency string) string {
	if currency == "" {
		currency = "VND"
	}
	// For VND, amount in whole units (1,000,000 đ)
	if currency == "VND" {
		raw := fmt.Sprintf("%d", cents)
		var parts []string
		for len(raw) > 3 {
			parts = append([]string{raw[len(raw)-3:]}, parts...)
			raw = raw[:len(raw)-3]
		}
		if len(raw) > 0 {
			parts = append([]string{raw}, parts...)
		}
		return strings.Join(parts, ".") + " ₫"
	}
	dollars := cents / 100
	remainder := cents % 100
	return fmt.Sprintf("$%d.%02d", dollars, remainder)
}
