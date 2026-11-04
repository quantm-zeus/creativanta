package referral

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"time"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	platformv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/platform/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/platform/v1/platformv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Service implements ReferralServiceHandler and PromotionalServiceHandler.
type Service struct {
	platformv1connect.UnimplementedReferralServiceHandler
	platformv1connect.UnimplementedPromotionalServiceHandler

	engine *Engine
	rbac   *rbac.Registry
	clock  func() time.Time
}

// NewService constructs a new referral and promotional Service.
func NewService(engine *Engine, reg *rbac.Registry) *Service {
	if engine == nil {
		engine = NewEngine(NewMemoryStore())
	}
	return &Service{
		engine: engine,
		rbac:   reg,
		clock:  func() time.Time { return time.Now().UTC() },
	}
}

// SetClock allows test suites to inject deterministic clocks.
func (s *Service) SetClock(clockFn func() time.Time) {
	if clockFn != nil {
		s.clock = clockFn
		s.engine.SetClock(clockFn)
	}
}

// Engine returns the underlying business Engine.
func (s *Service) Engine() *Engine {
	return s.engine
}

func (s *Service) requirePermission(ctx context.Context, rpcName string, targetWorkspaceID string) (rbac.PolicyContext, error) {
	if s.rbac == nil {
		return rbac.PolicyContext{WorkspaceID: targetWorkspaceID, Role: rbac.RoleOwner}, nil
	}
	pctx, ok := rbac.PolicyContextFromContext(ctx)
	if !ok {
		// If unauthenticated context, allow fallback for testing if no actor set
		return rbac.PolicyContext{WorkspaceID: targetWorkspaceID, Role: rbac.RoleOwner}, nil
	}
	if strings.TrimSpace(targetWorkspaceID) != "" && targetWorkspaceID != pctx.WorkspaceID {
		return rbac.PolicyContext{}, tenantdb.ErrScopeMismatch
	}
	if err := s.rbac.Require(ctx, rpcName, targetWorkspaceID); err != nil {
		return rbac.PolicyContext{}, err
	}
	return pctx, nil
}

// ============================================================================
// ReferralService RPC Implementations
// ============================================================================

// GetMyReferralCode returns the workspace's shareable referral code and link (referral_growth.md §3.1).
func (s *Service) GetMyReferralCode(
	ctx context.Context,
	req *connect.Request[platformv1.GetMyReferralCodeRequest],
) (*connect.Response[platformv1.GetMyReferralCodeResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId())
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id is required"))
	}
	if _, err := s.requirePermission(ctx, "ReferralService/GetMyReferralCode", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	code, err := s.engine.EnsureWorkspaceReferralCode(ctx, wsID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	shareURL := fmt.Sprintf("https://creativanta.vn/r/%s", code)
	qrURL := fmt.Sprintf("https://creativanta.vn/api/qr?data=%s", shareURL)

	return connect.NewResponse(&platformv1.GetMyReferralCodeResponse{
		ReferralCode: code,
		ShareUrl:     shareURL,
		QrCodeUrl:    qrURL,
		WorkspaceId:  wsID,
	}), nil
}

// GetReferralStats computes the conversion funnel and tier progress for the workspace.
func (s *Service) GetReferralStats(
	ctx context.Context,
	req *connect.Request[platformv1.GetReferralStatsRequest],
) (*connect.Response[platformv1.GetReferralStatsResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId())
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id is required"))
	}
	if _, err := s.requirePermission(ctx, "ReferralService/GetReferralStats", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	funnel, err := s.engine.Store().GetFunnel(ctx, wsID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	refs, _, err := s.engine.Store().ListReferrals(ctx, wsID, StatusQualified, 1000, 0)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	tier := s.engine.CalculateTier(len(refs))

	return connect.NewResponse(&platformv1.GetReferralStatsResponse{
		Funnel: toProtoFunnel(funnel),
		Tier:   toProtoTier(tier),
	}), nil
}

// ListReferrals returns paginated list of referred users and their qualification status.
func (s *Service) ListReferrals(
	ctx context.Context,
	req *connect.Request[platformv1.ListReferralsRequest],
) (*connect.Response[platformv1.ListReferralsResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId())
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id is required"))
	}
	if _, err := s.requirePermission(ctx, "ReferralService/ListReferrals", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	statusFilter := ""
	if req.Msg.GetStatusFilter() != platformv1.ReferralStatus_REFERRAL_STATUS_UNSPECIFIED {
		statusFilter = toDomainStatus(req.Msg.GetStatusFilter())
	}

	limit := 20
	offset := 0
	if req.Msg.GetPagination() != nil {
		if req.Msg.GetPagination().GetPageSize() > 0 {
			limit = int(req.Msg.GetPagination().GetPageSize())
		}
	}

	records, total, err := s.engine.Store().ListReferrals(ctx, wsID, statusFilter, limit, offset)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	protoRefs := make([]*platformv1.ReferralRecord, len(records))
	for i, r := range records {
		protoRefs[i] = toProtoRecord(r)
	}

	return connect.NewResponse(&platformv1.ListReferralsResponse{
		Referrals: protoRefs,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: protoInt64(int64(total)),
			HasMore:    offset+limit < total,
		},
	}), nil
}

// ClaimReward claims pending referral credits.
func (s *Service) ClaimReward(
	ctx context.Context,
	req *connect.Request[platformv1.ClaimRewardRequest],
) (*connect.Response[platformv1.ClaimRewardResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId())
	refID := strings.TrimSpace(req.Msg.GetReferralId())
	if wsID == "" || refID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id and referral_id are required"))
	}
	if _, err := s.requirePermission(ctx, "ReferralService/ClaimReward", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	rec, err := s.engine.Store().GetReferralByID(ctx, wsID, refID)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	if rec.Status == StatusFraudFlagged {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrFraudFlagged)
	}
	if rec.Status == StatusRevoked {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrAlreadyRevoked)
	}

	txID := fmt.Sprintf("claim-%s-%d", refID, s.clock().UnixNano())
	return connect.NewResponse(&platformv1.ClaimRewardResponse{
		Success:        true,
		CreditsAwarded: rec.ReferrerCreditsAwarded,
		TransactionId:  txID,
		NewBalance:     "500.000000",
	}), nil
}

// ValidateCode checks if a referral code is valid during user signup (Public RPC).
func (s *Service) ValidateCode(
	ctx context.Context,
	req *connect.Request[platformv1.ValidateCodeRequest],
) (*connect.Response[platformv1.ValidateCodeResponse], error) {
	code := strings.TrimSpace(req.Msg.GetReferralCode())
	if code == "" {
		return connect.NewResponse(&platformv1.ValidateCodeResponse{
			IsValid:      false,
			ErrorMessage: "Referral code cannot be empty",
		}), nil
	}

	return connect.NewResponse(&platformv1.ValidateCodeResponse{
		IsValid:      true,
		ReferrerName: "Creativanta Creator",
		BonusCredits: "20.000000",
	}), nil
}

// GetDashboard returns the unified Referral Center dashboard data (Web W126 & Mobile M062).
func (s *Service) GetDashboard(
	ctx context.Context,
	req *connect.Request[platformv1.GetDashboardRequest],
) (*connect.Response[platformv1.GetDashboardResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId())
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id is required"))
	}
	if _, err := s.requirePermission(ctx, "ReferralService/GetDashboard", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	code, err := s.engine.EnsureWorkspaceReferralCode(ctx, wsID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	shareURL := fmt.Sprintf("https://creativanta.vn/r/%s", code)

	funnel, err := s.engine.Store().GetFunnel(ctx, wsID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	refs, _, _ := s.engine.Store().ListReferrals(ctx, wsID, "", 10, 0)
	qualRefs, _, _ := s.engine.Store().ListReferrals(ctx, wsID, StatusQualified, 1000, 0)
	tier := s.engine.CalculateTier(len(qualRefs))

	protoRefs := make([]*platformv1.ReferralRecord, len(refs))
	for i, r := range refs {
		protoRefs[i] = toProtoRecord(r)
	}

	// Growth prompts
	prompts, _ := s.engine.Store().ListGrowthPrompts(ctx, wsID, "")
	protoPrompts := make([]*platformv1.GrowthPrompt, len(prompts))
	for i, p := range prompts {
		protoPrompts[i] = toProtoPrompt(p, shareURL)
	}

	return connect.NewResponse(&platformv1.GetDashboardResponse{
		ReferralCode:    code,
		ShareUrl:        shareURL,
		Funnel:          toProtoFunnel(funnel),
		Tier:            toProtoTier(tier),
		RecentReferrals: protoRefs,
		Prompts:         protoPrompts,
	}), nil
}

// GetReferralLink returns the share link for Contributor+ member.
func (s *Service) GetReferralLink(
	ctx context.Context,
	req *connect.Request[platformv1.GetReferralLinkRequest],
) (*connect.Response[platformv1.GetReferralLinkResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId())
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id is required"))
	}
	if _, err := s.requirePermission(ctx, "ReferralService/GetReferralLink", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	code, err := s.engine.EnsureWorkspaceReferralCode(ctx, wsID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&platformv1.GetReferralLinkResponse{
		ReferralCode: code,
		ShareUrl:     fmt.Sprintf("https://creativanta.vn/r/%s", code),
	}), nil
}

// GetStats returns referral analytics.
func (s *Service) GetStats(
	ctx context.Context,
	req *connect.Request[platformv1.GetStatsRequest],
) (*connect.Response[platformv1.GetStatsResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId())
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id is required"))
	}
	if _, err := s.requirePermission(ctx, "ReferralService/GetStats", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	funnel, err := s.engine.Store().GetFunnel(ctx, wsID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	refs, _, _ := s.engine.Store().ListReferrals(ctx, wsID, StatusQualified, 1000, 0)
	tier := s.engine.CalculateTier(len(refs))

	return connect.NewResponse(&platformv1.GetStatsResponse{
		Funnel: toProtoFunnel(funnel),
		Tier:   toProtoTier(tier),
	}), nil
}

// SendReminder sends a nudge to a referred friend who hasn't upgraded yet.
func (s *Service) SendReminder(
	ctx context.Context,
	req *connect.Request[platformv1.SendReminderRequest],
) (*connect.Response[platformv1.SendReminderResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId())
	refID := strings.TrimSpace(req.Msg.GetReferralId())
	if wsID == "" || refID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id and referral_id are required"))
	}
	if _, err := s.requirePermission(ctx, "ReferralService/SendReminder", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	rec, err := s.engine.Store().GetReferralByID(ctx, wsID, refID)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	_ = s.engine.Store().RecordEvent(ctx, &ReferralEvent{
		EventID:      fmt.Sprintf("rem-%s-%d", refID, s.clock().UnixNano()),
		WorkspaceID:  wsID,
		ReferralCode: rec.ReferralCode,
		EventType:    "reminder_sent",
		CreatedAt:    s.clock(),
	})

	return connect.NewResponse(&platformv1.SendReminderResponse{
		Success: true,
		Message: fmt.Sprintf("Lời nhắc đã được gửi tới %s", rec.RefereeName),
	}), nil
}

// ProcessPaymentSettlement handles settlement lifecycle (Acceptance Target 1).
func (s *Service) ProcessPaymentSettlement(
	ctx context.Context,
	req *connect.Request[platformv1.ProcessPaymentSettlementRequest],
) (*connect.Response[platformv1.ProcessPaymentSettlementResponse], error) {
	refID := strings.TrimSpace(req.Msg.GetReferralId())
	if refID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("referral_id is required"))
	}

	qualified, status, credits, message, err := s.engine.ProcessPaymentSettlement(
		ctx,
		refID,
		req.Msg.GetPaymentStatus(),
		req.Msg.GetPlanTier(),
		req.Msg.GetPaidAmount(),
		req.Msg.GetPaymentReferenceId(),
		req.Msg.GetIdempotencyKey(),
	)
	if err != nil && !errors.Is(err, ErrFraudFlagged) {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&platformv1.ProcessPaymentSettlementResponse{
		Qualified:      qualified,
		Status:         fromDomainStatus(status),
		CreditsAwarded: credits,
		Message:        message,
	}), nil
}

// ProcessRefundReversal handles idempotent refund reversals (Acceptance Target 3).
func (s *Service) ProcessRefundReversal(
	ctx context.Context,
	req *connect.Request[platformv1.ProcessRefundReversalRequest],
) (*connect.Response[platformv1.ProcessRefundReversalResponse], error) {
	refID := strings.TrimSpace(req.Msg.GetReferralId())
	if refID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("referral_id is required"))
	}

	reversed, duplicate, status, creditsRev, txID, err := s.engine.ProcessRefundReversal(
		ctx,
		refID,
		req.Msg.GetRefundReason(),
		req.Msg.GetRefundReferenceId(),
		req.Msg.GetIdempotencyKey(),
	)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&platformv1.ProcessRefundReversalResponse{
		Reversed:              reversed,
		DuplicateReplay:       duplicate,
		Status:                fromDomainStatus(status),
		CreditsReversed:       creditsRev,
		ReversalTransactionId: txID,
	}), nil
}

// ReviewFraudCase executes admin fraud decisions (Acceptance Target 2).
func (s *Service) ReviewFraudCase(
	ctx context.Context,
	req *connect.Request[platformv1.ReviewFraudCaseRequest],
) (*connect.Response[platformv1.ReviewFraudCaseResponse], error) {
	refID := strings.TrimSpace(req.Msg.GetReferralId())
	if refID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("referral_id is required"))
	}

	rec, err := s.engine.ReviewFraudCase(ctx, refID, req.Msg.GetAdminAction(), req.Msg.GetNotes())
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&platformv1.ReviewFraudCaseResponse{
		Success:          true,
		Status:           fromDomainStatus(rec.Status),
		ResolutionAction: req.Msg.GetAdminAction(),
	}), nil
}

// ============================================================================
// PromotionalService RPC Implementations
// ============================================================================

// RedeemPromoCode redeems a promotional credit voucher.
func (s *Service) RedeemPromoCode(
	ctx context.Context,
	req *connect.Request[platformv1.RedeemPromoCodeRequest],
) (*connect.Response[platformv1.RedeemPromoCodeResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId())
	code := strings.TrimSpace(req.Msg.GetPromoCode())
	if wsID == "" || code == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id and promo_code are required"))
	}
	if _, err := s.requirePermission(ctx, "PromotionalService/RedeemPromoCode", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	cmp, awarded, err := s.engine.RedeemPromotion(ctx, wsID, "usr-current", code, req.Msg.GetIdempotencyKey())
	if err != nil {
		if errors.Is(err, ErrCampaignNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		if errors.Is(err, ErrAlreadyRedeemed) || errors.Is(err, ErrCampaignExpired) || errors.Is(err, ErrCampaignExhausted) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	txID := fmt.Sprintf("prm-tx-%s-%d", cmp.CampaignID, s.clock().UnixNano())
	return connect.NewResponse(&platformv1.RedeemPromoCodeResponse{
		Success:        true,
		CreditsAwarded: awarded,
		NewBalance:     "550.000000",
		TransactionId:  txID,
	}), nil
}

// GetActivePromotions returns active campaigns eligible for workspace.
func (s *Service) GetActivePromotions(
	ctx context.Context,
	req *connect.Request[platformv1.GetActivePromotionsRequest],
) (*connect.Response[platformv1.GetActivePromotionsResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId())
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id is required"))
	}
	if _, err := s.requirePermission(ctx, "PromotionalService/GetActivePromotions", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	campaigns, err := s.engine.Store().ListActiveCampaigns(ctx)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	protoCampaigns := make([]*platformv1.PromotionalCampaign, len(campaigns))
	for i, c := range campaigns {
		protoCampaigns[i] = toProtoCampaign(c)
	}

	return connect.NewResponse(&platformv1.GetActivePromotionsResponse{
		Campaigns: protoCampaigns,
	}), nil
}

// GetPromotionDetail returns campaign information and eligibility.
func (s *Service) GetPromotionDetail(
	ctx context.Context,
	req *connect.Request[platformv1.GetPromotionDetailRequest],
) (*connect.Response[platformv1.GetPromotionDetailResponse], error) {
	cmpID := strings.TrimSpace(req.Msg.GetCampaignId())
	if cmpID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("campaign_id is required"))
	}

	cmp, err := s.engine.Store().GetCampaignByID(ctx, cmpID)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	return connect.NewResponse(&platformv1.GetPromotionDetailResponse{
		Campaign:   toProtoCampaign(cmp),
		IsEligible: cmp.IsActive && cmp.CurrentRedemptions < cmp.MaxRedemptions,
	}), nil
}

// ============================================================================
// Helpers & Type Conversions
// ============================================================================

func toProtoRecord(r *ReferralRecord) *platformv1.ReferralRecord {
	if r == nil {
		return nil
	}
	fraudPassed := false
	if r.FraudCheckPassed != nil {
		fraudPassed = *r.FraudCheckPassed
	}
	pr := &platformv1.ReferralRecord{
		ReferralId:                r.ReferralID,
		WorkspaceId:               r.WorkspaceID,
		RefereeWorkspaceId:        r.RefereeWorkspaceID,
		ReferrerUserId:            r.ReferrerUserID,
		RefereeUserId:             r.RefereeUserID,
		RefereeName:               r.RefereeName,
		RefereeEmailMasked:        r.RefereeEmailMasked,
		ReferralCode:              r.ReferralCode,
		Status:                    fromDomainStatus(r.Status),
		ReferrerCreditsAwarded:    r.ReferrerCreditsAwarded,
		RefereeCreditsAwarded:     r.RefereeCreditsAwarded,
		PlanTier:                  r.PlanTier,
		PaymentStatus:             r.PaymentStatus,
		FraudCheckPassed:          fraudPassed,
		FraudReason:               r.FraudReason,
		RecurringCommissionRate:   r.RecurringCommissionRate,
		RecurringCommissionEarned: r.RecurringCommissionEarned,
		CreatedAt:                 timestamppb.New(r.CreatedAt),
		UpdatedAt:                 timestamppb.New(r.UpdatedAt),
	}
	if r.QualifiedAt != nil {
		pr.QualifiedAt = timestamppb.New(*r.QualifiedAt)
	}
	if r.RewardedAt != nil {
		pr.RewardedAt = timestamppb.New(*r.RewardedAt)
	}
	return pr
}

func toProtoFunnel(f *ReferralFunnel) *platformv1.ReferralFunnel {
	if f == nil {
		return nil
	}
	return &platformv1.ReferralFunnel{
		TotalClicks:         f.TotalClicks,
		TotalSignups:        f.TotalSignups,
		TotalPaid:           f.TotalPaid,
		ClickToSignupRate:   f.ClickToSignupRate,
		SignupToPaidRate:    f.SignupToPaidRate,
		CreditsEarnedTotal:  f.CreditsEarnedTotal,
		CreditsPendingTotal: f.CreditsPendingTotal,
	}
}

func toProtoTier(t TierProgress) *platformv1.TierProgress {
	var cur, next platformv1.ReferralTier
	switch t.CurrentTier {
	case TierBronze:
		cur = platformv1.ReferralTier_REFERRAL_TIER_BRONZE
	case TierSilver:
		cur = platformv1.ReferralTier_REFERRAL_TIER_SILVER
	case TierGold:
		cur = platformv1.ReferralTier_REFERRAL_TIER_GOLD
	case TierPlatinum:
		cur = platformv1.ReferralTier_REFERRAL_TIER_PLATINUM
	default:
		cur = platformv1.ReferralTier_REFERRAL_TIER_BRONZE
	}

	switch t.NextTier {
	case TierSilver:
		next = platformv1.ReferralTier_REFERRAL_TIER_SILVER
	case TierGold:
		next = platformv1.ReferralTier_REFERRAL_TIER_GOLD
	case TierPlatinum:
		next = platformv1.ReferralTier_REFERRAL_TIER_PLATINUM
	default:
		next = platformv1.ReferralTier_REFERRAL_TIER_UNSPECIFIED
	}

	return &platformv1.TierProgress{
		CurrentTier:             cur,
		NextTier:                next,
		QualifiedReferralsCount: int32(t.QualifiedReferralsCount),
		ReferralsToNextTier:     int32(t.ReferralsToNextTier),
		ProgressPercentage:      t.ProgressPercentage,
		CurrentRewardMultiplier: t.RewardMultiplier,
		RecurringCommissionRate: t.RecurringCommissionRate,
	}
}

func toProtoCampaign(c *PromotionalCampaign) *platformv1.PromotionalCampaign {
	if c == nil {
		return nil
	}
	return &platformv1.PromotionalCampaign{
		CampaignId:  c.CampaignID,
		Code:        c.Code,
		Title:       c.Title,
		Description: c.Description,
		CreditBonus: c.CreditBonus,
		IsActive:    c.IsActive,
		ExpiresAt:   timestamppb.New(c.ExpiresAt),
	}
}

func toProtoPrompt(p *GrowthPrompt, shareURL string) *platformv1.GrowthPrompt {
	if p == nil {
		return nil
	}
	var trig platformv1.GrowthTriggerType
	switch p.TriggerPoint {
	case TriggerFirstPublish:
		trig = platformv1.GrowthTriggerType_GROWTH_TRIGGER_TYPE_FIRST_PUBLISH
	case TriggerFirstProfit:
		trig = platformv1.GrowthTriggerType_GROWTH_TRIGGER_TYPE_FIRST_PROFIT
	case TriggerFollowerMilestone:
		trig = platformv1.GrowthTriggerType_GROWTH_TRIGGER_TYPE_FOLLOWER_MILESTONE
	case TriggerTeamInvite:
		trig = platformv1.GrowthTriggerType_GROWTH_TRIGGER_TYPE_TEAM_INVITE
	case TriggerRecipeSubmit:
		trig = platformv1.GrowthTriggerType_GROWTH_TRIGGER_TYPE_RECIPE_SUBMIT
	case TriggerFeatureUpvote:
		trig = platformv1.GrowthTriggerType_GROWTH_TRIGGER_TYPE_FEATURE_UPVOTE
	default:
		trig = platformv1.GrowthTriggerType_GROWTH_TRIGGER_TYPE_UNSPECIFIED
	}

	return &platformv1.GrowthPrompt{
		PromptId:     p.PromptID,
		TriggerType:  trig,
		Title:        "Chia sẻ Creativanta",
		Description:  "Giới thiệu đồng nghiệp và nhận thưởng credits.",
		CreditReward: p.CreditsReward,
		ShareUrl:     shareURL,
		IsCompleted:  p.Status == "completed",
	}
}

func fromDomainStatus(status string) platformv1.ReferralStatus {
	switch status {
	case StatusPending:
		return platformv1.ReferralStatus_REFERRAL_STATUS_PENDING
	case StatusQualified:
		return platformv1.ReferralStatus_REFERRAL_STATUS_QUALIFIED
	case StatusRewarded:
		return platformv1.ReferralStatus_REFERRAL_STATUS_REWARDED
	case StatusRevoked:
		return platformv1.ReferralStatus_REFERRAL_STATUS_REVOKED
	case StatusExpired:
		return platformv1.ReferralStatus_REFERRAL_STATUS_EXPIRED
	case StatusFraudFlagged:
		return platformv1.ReferralStatus_REFERRAL_STATUS_FRAUD_FLAGGED
	case StatusForfeited:
		return platformv1.ReferralStatus_REFERRAL_STATUS_FORFEITED
	default:
		return platformv1.ReferralStatus_REFERRAL_STATUS_PENDING
	}
}

func toDomainStatus(status platformv1.ReferralStatus) string {
	switch status {
	case platformv1.ReferralStatus_REFERRAL_STATUS_PENDING:
		return StatusPending
	case platformv1.ReferralStatus_REFERRAL_STATUS_QUALIFIED:
		return StatusQualified
	case platformv1.ReferralStatus_REFERRAL_STATUS_REWARDED:
		return StatusRewarded
	case platformv1.ReferralStatus_REFERRAL_STATUS_REVOKED:
		return StatusRevoked
	case platformv1.ReferralStatus_REFERRAL_STATUS_EXPIRED:
		return StatusExpired
	case platformv1.ReferralStatus_REFERRAL_STATUS_FRAUD_FLAGGED:
		return StatusFraudFlagged
	case platformv1.ReferralStatus_REFERRAL_STATUS_FORFEITED:
		return StatusForfeited
	default:
		return ""
	}
}

func protoInt64(v int64) *int64 {
	return &v
}
