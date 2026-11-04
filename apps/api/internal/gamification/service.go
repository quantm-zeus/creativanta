package gamification

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

// Service implements platformv1connect.GamificationServiceHandler.
type Service struct {
	platformv1connect.UnimplementedGamificationServiceHandler

	engine *Engine
	store  Store
	rbac   *rbac.Registry
	clock  func() time.Time
}

// NewService constructs a new Gamification Service.
func NewService(engine *Engine, store Store, reg *rbac.Registry) *Service {
	if store == nil {
		store = NewMemStore()
	}
	if engine == nil {
		engine = NewEngine(store, nil)
	}
	return &Service{
		engine: engine,
		store:  store,
		rbac:   reg,
		clock:  func() time.Time { return time.Now().UTC() },
	}
}

func (s *Service) Engine() *Engine {
	return s.engine
}

func (s *Service) Store() Store {
	return s.store
}

func (s *Service) SetClock(clockFn func() time.Time) {
	if clockFn != nil {
		s.clock = clockFn
		s.engine.SetNowFunc(clockFn)
	}
}

func (s *Service) requirePermission(ctx context.Context, rpcName string, targetWorkspaceID string) (rbac.PolicyContext, error) {
	if s.rbac == nil {
		return rbac.PolicyContext{WorkspaceID: targetWorkspaceID, Role: rbac.RoleOwner}, nil
	}
	pctx, ok := rbac.PolicyContextFromContext(ctx)
	if !ok {
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

func toProtoProgress(p *CreatorProgress) *platformv1.CreatorProgress {
	if p == nil {
		return nil
	}
	return &platformv1.CreatorProgress{
		ProgressId:             p.ProgressID,
		WorkspaceId:            &commonv1.UUID{Value: p.WorkspaceID},
		UserId:                 p.UserID,
		Level:                  int32(p.Level),
		Xp:                     int32(p.XP),
		XpToNextLevel:          int32(p.XPToNextLevel),
		StreakDays:             int32(p.StreakDays),
		StreakLastActivityDate: p.StreakLastActivityDate,
		CreatorScore:           float32(p.CreatorScore),
		TotalAchievements:      int32(p.TotalAchievements),
		SeasonId:               p.SeasonID,
		CreatedAt:              timestamppb.New(p.CreatedAt),
		UpdatedAt:              timestamppb.New(p.UpdatedAt),
	}
}

func toProtoAchievementDef(d *AchievementDefinition) *platformv1.AchievementDefinition {
	if d == nil {
		return nil
	}
	return &platformv1.AchievementDefinition{
		AchievementId:        d.AchievementID,
		Code:                 d.Code,
		Title:                d.Title,
		Description:          d.Description,
		TriggerConditionJson: d.TriggerCondition,
		RewardCredits:        int32(d.RewardCredits),
		BadgeImageUrl:        d.BadgeImageURL,
		Category:             d.Category,
		SortOrder:            int32(d.SortOrder),
		Active:               d.Active,
		CreatedAt:            timestamppb.New(d.CreatedAt),
		UpdatedAt:            timestamppb.New(d.UpdatedAt),
	}
}

func toProtoChallengeDef(c *ChallengeDefinition) *platformv1.ChallengeDefinition {
	if c == nil {
		return nil
	}
	var cType platformv1.ChallengeType
	switch c.ChallengeType {
	case "publish_count":
		cType = platformv1.ChallengeType_CHALLENGE_TYPE_PUBLISH_COUNT
	case "revenue_target":
		cType = platformv1.ChallengeType_CHALLENGE_TYPE_REVENUE_TARGET
	case "engagement_target":
		cType = platformv1.ChallengeType_CHALLENGE_TYPE_ENGAGEMENT_TARGET
	case "streak":
		cType = platformv1.ChallengeType_CHALLENGE_TYPE_STREAK
	default:
		cType = platformv1.ChallengeType_CHALLENGE_TYPE_CUSTOM
	}

	var status platformv1.ChallengeStatus
	switch c.Status {
	case "draft":
		status = platformv1.ChallengeStatus_CHALLENGE_STATUS_DRAFT
	case "enrolling":
		status = platformv1.ChallengeStatus_CHALLENGE_STATUS_ENROLLING
	case "active":
		status = platformv1.ChallengeStatus_CHALLENGE_STATUS_ACTIVE
	case "completed":
		status = platformv1.ChallengeStatus_CHALLENGE_STATUS_COMPLETED
	case "rewarded":
		status = platformv1.ChallengeStatus_CHALLENGE_STATUS_REWARDED
	case "cancelled":
		status = platformv1.ChallengeStatus_CHALLENGE_STATUS_CANCELLED
	default:
		status = platformv1.ChallengeStatus_CHALLENGE_STATUS_UNSPECIFIED
	}

	return &platformv1.ChallengeDefinition{
		ChallengeId:   c.ChallengeID,
		Title:         c.Title,
		Description:   c.Description,
		ChallengeType: cType,
		TargetValue:   int32(c.TargetValue),
		RewardCredits: int32(c.RewardCredits),
		StartDate:     c.StartDate,
		EndDate:       c.EndDate,
		Status:        status,
		IsActive:      c.IsActive,
		SortOrder:     int32(c.SortOrder),
		CreatedAt:     timestamppb.New(c.CreatedAt),
	}
}

func toProtoChallengeProgress(cp *ChallengeProgress) *platformv1.ChallengeProgress {
	if cp == nil {
		return nil
	}
	var completedAt *timestamppb.Timestamp
	if cp.CompletedAt != nil {
		completedAt = timestamppb.New(*cp.CompletedAt)
	}
	return &platformv1.ChallengeProgress{
		ProgressId:          cp.ProgressID,
		WorkspaceId:         &commonv1.UUID{Value: cp.WorkspaceID},
		UserId:              cp.UserID,
		ChallengeId:         cp.ChallengeID,
		CurrentValue:        int32(cp.CurrentValue),
		TargetValue:         int32(cp.TargetValue),
		Completed:           cp.Completed,
		CompletedAt:         completedAt,
		RewardCredited:      cp.RewardCredited,
		RewardTransactionId: cp.RewardTransactionID,
		CreatedAt:           timestamppb.New(cp.CreatedAt),
		UpdatedAt:           timestamppb.New(cp.UpdatedAt),
	}
}

// GetProgress returns per-user progress in a workspace (Acceptance Target 1).
func (s *Service) GetProgress(
	ctx context.Context,
	req *connect.Request[platformv1.GetProgressRequest],
) (*connect.Response[platformv1.GetProgressResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId().GetValue())
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id is required"))
	}
	userID := strings.TrimSpace(req.Msg.GetUserId())
	if userID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("user_id is required"))
	}

	if _, err := s.requirePermission(ctx, "GamificationService/GetProgress", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	p, err := s.engine.GetOrCreateProgress(ctx, wsID, userID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&platformv1.GetProgressResponse{
		Progress: toProtoProgress(p),
	}), nil
}

// ListAchievements lists all achievement definitions with the calling user's unlock records.
func (s *Service) ListAchievements(
	ctx context.Context,
	req *connect.Request[platformv1.ListAchievementsRequest],
) (*connect.Response[platformv1.ListAchievementsResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId().GetValue())
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id is required"))
	}
	userID := strings.TrimSpace(req.Msg.GetUserId())
	if userID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("user_id is required"))
	}

	if _, err := s.requirePermission(ctx, "GamificationService/ListAchievements", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	category := strings.TrimSpace(req.Msg.GetCategory())
	defs, err := s.store.ListAchievementDefinitions(ctx, category, true)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	records, err := s.store.ListAchievementRecords(ctx, wsID, userID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	recordMap := make(map[string]*AchievementRecord)
	for _, r := range records {
		recordMap[r.AchievementID] = r
	}

	var items []*platformv1.AchievementItem
	unlockedCount := 0
	for _, d := range defs {
		item := &platformv1.AchievementItem{
			Definition: toProtoAchievementDef(d),
			Unlocked:   false,
		}
		if r, ok := recordMap[d.AchievementID]; ok {
			item.Unlocked = true
			item.EarnedAt = timestamppb.New(r.EarnedAt)
			item.CreditsAwarded = r.CreditsAwarded.String()
			unlockedCount++
		}
		items = append(items, item)
	}

	return connect.NewResponse(&platformv1.ListAchievementsResponse{
		Achievements:   items,
		TotalUnlocked:  int32(unlockedCount),
		TotalAvailable: int32(len(defs)),
	}), nil
}

// ListChallenges lists active and enrolling challenges with user progress.
func (s *Service) ListChallenges(
	ctx context.Context,
	req *connect.Request[platformv1.ListChallengesRequest],
) (*connect.Response[platformv1.ListChallengesResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId().GetValue())
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id is required"))
	}
	userID := strings.TrimSpace(req.Msg.GetUserId())

	if _, err := s.requirePermission(ctx, "GamificationService/ListChallenges", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	statusFilter := ""
	switch req.Msg.GetStatusFilter() {
	case platformv1.ChallengeStatus_CHALLENGE_STATUS_ACTIVE:
		statusFilter = "active"
	case platformv1.ChallengeStatus_CHALLENGE_STATUS_ENROLLING:
		statusFilter = "enrolling"
	case platformv1.ChallengeStatus_CHALLENGE_STATUS_COMPLETED:
		statusFilter = "completed"
	}

	challenges, err := s.store.ListChallenges(ctx, statusFilter)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var userProgressMap = make(map[string]*ChallengeProgress)
	if userID != "" {
		userProgressList, _ := s.store.ListChallengeProgressByUser(ctx, wsID, userID)
		for _, cp := range userProgressList {
			userProgressMap[cp.ChallengeID] = cp
		}
	}

	var items []*platformv1.ChallengeItem
	for _, c := range challenges {
		item := &platformv1.ChallengeItem{
			Challenge: toProtoChallengeDef(c),
			Enrolled:  false,
		}
		if cp, ok := userProgressMap[c.ChallengeID]; ok {
			item.Enrolled = true
			item.Progress = toProtoChallengeProgress(cp)
		}
		items = append(items, item)
	}

	return connect.NewResponse(&platformv1.ListChallengesResponse{
		Challenges: items,
	}), nil
}

// GetChallengeProgress returns a single challenge and user's progress.
func (s *Service) GetChallengeProgress(
	ctx context.Context,
	req *connect.Request[platformv1.GetChallengeProgressRequest],
) (*connect.Response[platformv1.GetChallengeProgressResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId().GetValue())
	userID := strings.TrimSpace(req.Msg.GetUserId())
	challengeID := strings.TrimSpace(req.Msg.GetChallengeId())

	if wsID == "" || userID == "" || challengeID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id, user_id, and challenge_id are required"))
	}

	if _, err := s.requirePermission(ctx, "GamificationService/GetChallengeProgress", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	c, err := s.store.GetChallenge(ctx, challengeID)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	cp, err := s.store.GetChallengeProgress(ctx, wsID, userID, challengeID)
	if err != nil && !errors.Is(err, ErrNotFound) {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&platformv1.GetChallengeProgressResponse{
		Challenge: toProtoChallengeDef(c),
		Progress:  toProtoChallengeProgress(cp),
	}), nil
}

// ShareAchievement generates share links and cards for unlocked achievements.
func (s *Service) ShareAchievement(
	ctx context.Context,
	req *connect.Request[platformv1.ShareAchievementRequest],
) (*connect.Response[platformv1.ShareAchievementResponse], error) {
	code := strings.TrimSpace(req.Msg.GetAchievementCode())
	if code == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("achievement_code is required"))
	}

	// Caller context
	var wsID string
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	if wsID == "" {
		pctx, _ := rbac.PolicyContextFromContext(ctx)
		wsID = pctx.WorkspaceID
	}

	if _, err := s.requirePermission(ctx, "GamificationService/ShareAchievement", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	def, err := s.store.GetAchievementDefinition(ctx, code)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, fmt.Errorf("achievement definition not found: %w", err))
	}

	shareURL := fmt.Sprintf("https://creativanta.com/achievements/%s", code)
	shareCardURL := fmt.Sprintf("https://cdn.creativanta.com/cards/achievements/%s.png", code)

	return connect.NewResponse(&platformv1.ShareAchievementResponse{
		Success:      true,
		ShareUrl:     shareURL,
		ShareCardUrl: shareCardURL,
		Message:      fmt.Sprintf("Chia sẻ thành tích '%s' thành công", def.Title),
	}), nil
}

// GetDashboard returns unified gamification stats for home & dashboard.
func (s *Service) GetDashboard(
	ctx context.Context,
	req *connect.Request[platformv1.GamificationServiceGetDashboardRequest],
) (*connect.Response[platformv1.GamificationServiceGetDashboardResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId().GetValue())
	userID := strings.TrimSpace(req.Msg.GetUserId())
	if wsID == "" || userID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id and user_id are required"))
	}

	if _, err := s.requirePermission(ctx, "GamificationService/GetDashboard", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	prog, err := s.engine.GetOrCreateProgress(ctx, wsID, userID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Recent achievements
	records, _ := s.store.ListAchievementRecords(ctx, wsID, userID)
	defs, _ := s.store.ListAchievementDefinitions(ctx, "", true)
	defMap := make(map[string]*AchievementDefinition)
	for _, d := range defs {
		defMap[d.AchievementID] = d
	}

	var recent []*platformv1.AchievementItem
	for i := len(records) - 1; i >= 0 && len(recent) < 5; i-- {
		r := records[i]
		if d, ok := defMap[r.AchievementID]; ok {
			recent = append(recent, &platformv1.AchievementItem{
				Definition:     toProtoAchievementDef(d),
				Unlocked:       true,
				EarnedAt:       timestamppb.New(r.EarnedAt),
				CreditsAwarded: r.CreditsAwarded.String(),
			})
		}
	}

	// Active challenges
	challenges, _ := s.store.ListChallenges(ctx, "active")
	userCPList, _ := s.store.ListChallengeProgressByUser(ctx, wsID, userID)
	userCPMap := make(map[string]*ChallengeProgress)
	for _, cp := range userCPList {
		userCPMap[cp.ChallengeID] = cp
	}

	var activeChallenges []*platformv1.ChallengeItem
	for _, c := range challenges {
		item := &platformv1.ChallengeItem{
			Challenge: toProtoChallengeDef(c),
			Enrolled:  false,
		}
		if cp, ok := userCPMap[c.ChallengeID]; ok {
			item.Enrolled = true
			item.Progress = toProtoChallengeProgress(cp)
		}
		activeChallenges = append(activeChallenges, item)
	}

	// Workspace leaderboard
	allProg, _ := s.store.ListProgressByWorkspace(ctx, wsID, 10)
	var leaders []*platformv1.LeaderboardEntry
	for rank, p := range allProg {
		leaders = append(leaders, &platformv1.LeaderboardEntry{
			Rank:       int32(rank + 1),
			UserId:     p.UserID,
			UserName:   fmt.Sprintf("Creator %s", p.UserID[:min(6, len(p.UserID))]),
			Score:      int32(p.XP),
			Level:      int32(p.Level),
			StreakDays: int32(p.StreakDays),
		})
	}

	targetDays, rewardCreds := NextStreakMilestone(prog.StreakDays)

	return connect.NewResponse(&platformv1.GamificationServiceGetDashboardResponse{
		Progress:                     toProtoProgress(prog),
		RecentAchievements:           recent,
		ActiveChallenges:             activeChallenges,
		TopCreators:                  leaders,
		CurrentStreakDays:            int32(prog.StreakDays),
		StreakMilestoneTarget:        fmt.Sprintf("%d days", targetDays),
		StreakMilestoneRewardCredits: int32(rewardCreds),
	}), nil
}

// GetAchievements returns all achievements for the user.
func (s *Service) GetAchievements(
	ctx context.Context,
	req *connect.Request[platformv1.GetAchievementsRequest],
) (*connect.Response[platformv1.GetAchievementsResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId().GetValue())
	userID := strings.TrimSpace(req.Msg.GetUserId())
	if wsID == "" || userID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id and user_id are required"))
	}

	if _, err := s.requirePermission(ctx, "GamificationService/GetAchievements", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	res, err := s.ListAchievements(ctx, connect.NewRequest(&platformv1.ListAchievementsRequest{
		WorkspaceId: req.Msg.GetWorkspaceId(),
		UserId:      userID,
	}))
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&platformv1.GetAchievementsResponse{
		Achievements: res.Msg.GetAchievements(),
	}), nil
}

// GetActiveQuests returns challenges/quests where the user is participating or can join.
func (s *Service) GetActiveQuests(
	ctx context.Context,
	req *connect.Request[platformv1.GetActiveQuestsRequest],
) (*connect.Response[platformv1.GetActiveQuestsResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId().GetValue())
	userID := strings.TrimSpace(req.Msg.GetUserId())
	if wsID == "" || userID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id and user_id are required"))
	}

	if _, err := s.requirePermission(ctx, "GamificationService/GetActiveQuests", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	res, err := s.ListChallenges(ctx, connect.NewRequest(&platformv1.ListChallengesRequest{
		WorkspaceId:  req.Msg.GetWorkspaceId(),
		UserId:       userID,
		StatusFilter: platformv1.ChallengeStatus_CHALLENGE_STATUS_ACTIVE,
	}))
	if err != nil {
		return nil, err
	}

	return connect.NewResponse(&platformv1.GetActiveQuestsResponse{
		Quests: res.Msg.GetChallenges(),
	}), nil
}

// GetLeaderboard returns rankings within the workspace.
func (s *Service) GetLeaderboard(
	ctx context.Context,
	req *connect.Request[platformv1.GetLeaderboardRequest],
) (*connect.Response[platformv1.GetLeaderboardResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId().GetValue())
	if wsID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id is required"))
	}

	if _, err := s.requirePermission(ctx, "GamificationService/GetLeaderboard", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	limit := int(req.Msg.GetLimit())
	if limit <= 0 {
		limit = 20
	}

	allProg, err := s.store.ListProgressByWorkspace(ctx, wsID, limit)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var entries []*platformv1.LeaderboardEntry
	for rank, p := range allProg {
		entries = append(entries, &platformv1.LeaderboardEntry{
			Rank:       int32(rank + 1),
			UserId:     p.UserID,
			UserName:   fmt.Sprintf("Creator %s", p.UserID[:min(6, len(p.UserID))]),
			Score:      int32(p.XP),
			Level:      int32(p.Level),
			StreakDays: int32(p.StreakDays),
		})
	}

	return connect.NewResponse(&platformv1.GetLeaderboardResponse{
		Entries: entries,
	}), nil
}

// GetStreak returns detailed streak information and next milestone rewards.
func (s *Service) GetStreak(
	ctx context.Context,
	req *connect.Request[platformv1.GetStreakRequest],
) (*connect.Response[platformv1.GetStreakResponse], error) {
	wsID := strings.TrimSpace(req.Msg.GetWorkspaceId().GetValue())
	userID := strings.TrimSpace(req.Msg.GetUserId())
	if wsID == "" || userID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id and user_id are required"))
	}

	if _, err := s.requirePermission(ctx, "GamificationService/GetStreak", wsID); err != nil {
		return nil, connect.NewError(connect.CodePermissionDenied, err)
	}

	prog, err := s.engine.GetOrCreateProgress(ctx, wsID, userID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	todayStr := s.clock().Format("2006-01-02")
	isActiveToday := (prog.StreakLastActivityDate == todayStr)

	nextDays, rewardCreds := NextStreakMilestone(prog.StreakDays)

	return connect.NewResponse(&platformv1.GetStreakResponse{
		StreakDays:                 int32(prog.StreakDays),
		LastActivityDate:           prog.StreakLastActivityDate,
		IsActiveToday:              isActiveToday,
		NextMilestoneDays:          int32(nextDays),
		NextMilestoneRewardCredits: int32(rewardCreds),
	}), nil
}

// AdminRestoreStreak allows admins to restore streaks after platform downtime (EC-GAM-001).
func (s *Service) AdminRestoreStreak(
	ctx context.Context,
	req *connect.Request[platformv1.AdminRestoreStreakRequest],
) (*connect.Response[platformv1.AdminRestoreStreakResponse], error) {
	var wsID string
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	targetUserID := strings.TrimSpace(req.Msg.GetTargetUserId())
	if wsID == "" || targetUserID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("workspace_id and target_user_id are required"))
	}

	// Must be admin or owner
	pctx, _ := rbac.PolicyContextFromContext(ctx)
	if s.rbac != nil && pctx.Role != rbac.RoleOwner && pctx.Role != rbac.RoleAdmin {
		return nil, connect.NewError(connect.CodePermissionDenied, errors.New("admin or owner role required to restore streaks"))
	}

	restoredDays := int(req.Msg.GetRestoredStreakDays())
	if restoredDays <= 0 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("restored_streak_days must be > 0"))
	}

	p, err := s.engine.AdminRestoreStreak(ctx, wsID, targetUserID, restoredDays, req.Msg.GetReason())
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&platformv1.AdminRestoreStreakResponse{
		Success:  true,
		Progress: toProtoProgress(p),
		Message:  fmt.Sprintf("Chuỗi hoạt động của người dùng %s đã được khôi phục về %d ngày", targetUserID, restoredDays),
	}), nil
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
