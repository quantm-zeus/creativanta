package gamification

import (
	"context"
	"fmt"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	platformv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/platform/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
)

// Acceptance Target 1: Per-user progress
// Progress must be isolated per user and per workspace.
func TestAcceptanceTarget1_PerUserProgress(t *testing.T) {
	store := NewMemStore()
	depositor := &MockCreditDepositor{}
	engine := NewEngine(store, depositor)
	ctx := context.Background()

	wsID := "ws-target1"
	userA := "user-alice"
	userB := "user-bob"

	// Alice records video publishing (+5 XP)
	progA1, unlockedA1, err := engine.RecordActivity(ctx, wsID, userA, "publish.completed", nil)
	if err != nil {
		t.Fatalf("RecordActivity Alice failed: %v", err)
	}
	if progA1.XP != 5 {
		t.Fatalf("expected Alice XP=5, got %d", progA1.XP)
	}
	if progA1.Level != 1 {
		t.Fatalf("expected Alice level=1, got %d", progA1.Level)
	}
	if len(unlockedA1) != 1 || unlockedA1[0] != "first_video_published" {
		t.Fatalf("expected Alice to unlock first_video_published, got %v", unlockedA1)
	}

	// Bob has not performed any actions yet -> his progress must be isolated and at 0
	progB, err := engine.GetOrCreateProgress(ctx, wsID, userB)
	if err != nil {
		t.Fatalf("GetOrCreateProgress Bob failed: %v", err)
	}
	if progB.XP != 0 {
		t.Fatalf("expected Bob XP=0, got %d", progB.XP)
	}
	if progB.StreakDays != 0 {
		t.Fatalf("expected Bob StreakDays=0, got %d", progB.StreakDays)
	}
	if progB.TotalAchievements != 0 {
		t.Fatalf("expected Bob TotalAchievements=0, got %d", progB.TotalAchievements)
	}

	// Bob records viral clip (+20 XP)
	progB1, unlockedB1, err := engine.RecordActivity(ctx, wsID, userB, "clip.viral.10k", nil)
	if err != nil {
		t.Fatalf("RecordActivity Bob failed: %v", err)
	}
	if progB1.XP != 20 {
		t.Fatalf("expected Bob XP=20, got %d", progB1.XP)
	}
	if len(unlockedB1) != 1 || unlockedB1[0] != "viral_clip_10k" {
		t.Fatalf("expected Bob to unlock viral_clip_10k, got %v", unlockedB1)
	}

	// Re-verify Alice's progress remains untouched by Bob's actions
	progA2, err := store.GetProgress(ctx, wsID, userA)
	if err != nil {
		t.Fatalf("GetProgress Alice failed: %v", err)
	}
	if progA2.XP != 5 {
		t.Fatalf("expected Alice XP to still be 5, got %d", progA2.XP)
	}
	if progA2.TotalAchievements != 1 {
		t.Fatalf("expected Alice TotalAchievements=1, got %d", progA2.TotalAchievements)
	}
}

// Acceptance Target 2: Reward event replay once
// Duplicate reward event delivery or replay must execute reward deposit exactly once.
func TestAcceptanceTarget2_RewardEventReplayOnce(t *testing.T) {
	store := NewMemStore()
	depositor := &MockCreditDepositor{}
	engine := NewEngine(store, depositor)
	ctx := context.Background()

	wsID := "ws-target2"
	userID := "user-charlie"
	eventKey := "achievement:debut_creator"
	eventType := "achievement.unlocked"
	credits := 25
	xp := 50
	idempKey := "idemp-charlie-debut"

	// First execution: should award credits
	event1, newlyAwarded1, err := engine.DepositRewardOnce(ctx, wsID, userID, eventKey, eventType, credits, xp, idempKey)
	if err != nil {
		t.Fatalf("First DepositRewardOnce failed: %v", err)
	}
	if !newlyAwarded1 {
		t.Fatalf("expected first deposit to be newly awarded")
	}
	if event1.Status != "awarded" {
		t.Fatalf("expected event status 'awarded', got %s", event1.Status)
	}
	if event1.CreditsAwarded.Fixed6String() != "25.000000" {
		t.Fatalf("expected credits awarded '25.000000', got %s", event1.CreditsAwarded.Fixed6String())
	}
	if len(depositor.Deposits) != 1 {
		t.Fatalf("expected 1 deposit in ledger, got %d", len(depositor.Deposits))
	}

	// Replay 1 (identical event key and idempotency key)
	event2, newlyAwarded2, err := engine.DepositRewardOnce(ctx, wsID, userID, eventKey, eventType, credits, xp, idempKey)
	if err != nil {
		t.Fatalf("Replay DepositRewardOnce failed: %v", err)
	}
	if newlyAwarded2 {
		t.Fatalf("expected replay deposit to NOT be newly awarded")
	}
	if event2.EventID != event1.EventID {
		t.Fatalf("expected replay to return original EventID %s, got %s", event1.EventID, event2.EventID)
	}
	// Zero duplicate deposits!
	if len(depositor.Deposits) != 1 {
		t.Fatalf("expected strictly 1 deposit in ledger after replay, got %d", len(depositor.Deposits))
	}

	// Replay 2 (multiple duplicate calls simulate at-least-once queue replay)
	for i := 0; i < 5; i++ {
		_, awarded, err := engine.DepositRewardOnce(ctx, wsID, userID, eventKey, eventType, credits, xp, idempKey)
		if err != nil {
			t.Fatalf("Queue replay iteration %d failed: %v", i, err)
		}
		if awarded {
			t.Fatalf("Queue replay iteration %d wrongly awarded duplicate credits!", i)
		}
	}
	if len(depositor.Deposits) != 1 {
		t.Fatalf("expected still exactly 1 deposit after 5 replays, got %d", len(depositor.Deposits))
	}
}

// EF-11 Level thresholds: L1=0, L5=100, L10=500, L20=2000, L50=25000
func TestLevelProgressionThresholds(t *testing.T) {
	testCases := []struct {
		xp            int
		expectedLevel int
	}{
		{xp: 0, expectedLevel: 1},
		{xp: 24, expectedLevel: 1},
		{xp: 25, expectedLevel: 2},
		{xp: 100, expectedLevel: 5},
		{xp: 200, expectedLevel: 6},
		{xp: 500, expectedLevel: 10},
		{xp: 2000, expectedLevel: 20},
		{xp: 25000, expectedLevel: 50},
		{xp: 30000, expectedLevel: 50}, // Cap at 50
	}

	for _, tc := range testCases {
		lvl, xpToNext := CalculateLevel(tc.xp)
		if lvl != tc.expectedLevel {
			t.Errorf("CalculateLevel(%d XP): expected level %d, got %d (xpToNext=%d)", tc.xp, tc.expectedLevel, lvl, xpToNext)
		}
	}
}

// Streak milestone rewards per RULE-GAM-004 & EF-11:
// 7-day = 10 credits, 30-day = 50 credits, 90-day = 200 credits.
func TestStreakProgressionAndMilestoneRewards(t *testing.T) {
	store := NewMemStore()
	depositor := &MockCreditDepositor{}
	engine := NewEngine(store, depositor)
	ctx := context.Background()

	wsID := "ws-streak"
	userID := "user-streak"

	simulatedDate := time.Date(2026, 11, 1, 10, 0, 0, 0, time.UTC)
	engine.SetNowFunc(func() time.Time { return simulatedDate })

	// Day 1
	p, _, err := engine.RecordActivity(ctx, wsID, userID, "asset.generation_completed", nil)
	if err != nil {
		t.Fatalf("Day 1 failed: %v", err)
	}
	if p.StreakDays != 1 {
		t.Fatalf("expected streak=1, got %d", p.StreakDays)
	}

	// Same day again: streak days must NOT increment
	p, _, _ = engine.RecordActivity(ctx, wsID, userID, "asset.generation_completed", nil)
	if p.StreakDays != 1 {
		t.Fatalf("expected streak to remain 1 on same day, got %d", p.StreakDays)
	}

	// Consecutive days 2..7
	for day := 2; day <= 7; day++ {
		simulatedDate = simulatedDate.AddDate(0, 0, 1)
		p, _, err = engine.RecordActivity(ctx, wsID, userID, "publish.completed", nil)
		if err != nil {
			t.Fatalf("Day %d failed: %v", day, err)
		}
		if p.StreakDays != day {
			t.Fatalf("expected streak=%d on day %d, got %d", day, day, p.StreakDays)
		}
	}

	// At day 7: streak milestone reward must have been deposited (10 credits)
	if len(depositor.Deposits) < 1 {
		t.Fatalf("expected streak milestone deposit, got none")
	}
	found7DayDeposit := false
	for _, d := range depositor.Deposits {
		if d.Reason == "streak.milestone" && d.Amount.Fixed6String() == "10.000000" {
			found7DayDeposit = true
			break
		}
	}
	if !found7DayDeposit {
		t.Fatalf("expected 10 credit deposit for 7-day streak milestone")
	}

	// EC-GAM-001: Platform downtime grace period
	// Simulate skipping 2 days, but admin restores streak
	simulatedDate = simulatedDate.AddDate(0, 0, 3) // skipped days
	restoredP, err := engine.AdminRestoreStreak(ctx, wsID, userID, 7, "Platform maintenance downtime")
	if err != nil {
		t.Fatalf("AdminRestoreStreak failed: %v", err)
	}
	if restoredP.StreakDays != 7 {
		t.Fatalf("expected restored streak 7, got %d", restoredP.StreakDays)
	}
	if restoredP.StreakGraceUntil == nil {
		t.Fatalf("expected grace period to be active after admin restore")
	}
}

// Challenge lifecycle and zero participant cancellation (EC-GAM-003)
func TestChallengeLifecycleAndZeroParticipantCancellation(t *testing.T) {
	store := NewMemStore()
	depositor := &MockCreditDepositor{}
	engine := NewEngine(store, depositor)
	ctx := context.Background()

	// 1. Create challenge
	c := &ChallengeDefinition{
		ChallengeID:   "chal-zero-part",
		Title:         "Thử Thách Tuần Lễ",
		Description:   "Xuất bản 5 video trong tuần",
		ChallengeType: "publish_count",
		TargetValue:   5,
		RewardCredits: 50,
		StartDate:     "2026-11-01",
		EndDate:       "2026-11-07",
		Status:        "enrolling",
		IsActive:      true,
		CreatedAt:     time.Now().UTC(),
	}
	if err := store.CreateChallenge(ctx, c); err != nil {
		t.Fatalf("CreateChallenge failed: %v", err)
	}

	// 2. Enrollment ends with 0 participants -> EC-GAM-003 transitions to cancelled!
	finalStatus, err := engine.CloseChallengeEnrollment(ctx, c.ChallengeID)
	if err != nil {
		t.Fatalf("CloseChallengeEnrollment failed: %v", err)
	}
	if finalStatus != "cancelled" {
		t.Fatalf("expected challenge to transition to 'cancelled', got '%s'", finalStatus)
	}

	// 3. Challenge with active participants transitions to 'active'
	c2 := &ChallengeDefinition{
		ChallengeID:   "chal-active-part",
		Title:         "Thử Thách Có Người Tham Gia",
		ChallengeType: "publish_count",
		TargetValue:   3,
		RewardCredits: 30,
		StartDate:     "2026-11-01",
		EndDate:       "2026-11-07",
		Status:        "enrolling",
		IsActive:      true,
		CreatedAt:     time.Now().UTC(),
	}
	_ = store.CreateChallenge(ctx, c2)

	// User joins
	wsID := "ws-chal"
	userID := "user-joiner"
	cp, err := engine.JoinChallenge(ctx, wsID, userID, c2.ChallengeID)
	if err != nil {
		t.Fatalf("JoinChallenge failed: %v", err)
	}
	if cp.CurrentValue != 0 || cp.TargetValue != 3 {
		t.Fatalf("unexpected challenge progress: %+v", cp)
	}

	// Enrollment closes with 1 participant -> transitions to active
	status2, err := engine.CloseChallengeEnrollment(ctx, c2.ChallengeID)
	if err != nil {
		t.Fatalf("CloseChallengeEnrollment c2 failed: %v", err)
	}
	if status2 != "active" {
		t.Fatalf("expected c2 status 'active', got '%s'", status2)
	}

	// Progress updates to target
	cpUpdated, completed, err := engine.UpdateChallengeProgress(ctx, wsID, userID, c2.ChallengeID, 3)
	if err != nil {
		t.Fatalf("UpdateChallengeProgress failed: %v", err)
	}
	if !completed || !cpUpdated.Completed {
		t.Fatalf("expected challenge to be completed")
	}
	if !cpUpdated.RewardCredited {
		t.Fatalf("expected challenge reward to be credited")
	}

	// Verify reward deposited once (30 credits)
	foundDeposit := false
	for _, d := range depositor.Deposits {
		if d.Reason == "challenge.completed" && d.Amount.Fixed6String() == "30.000000" {
			foundDeposit = true
			break
		}
	}
	if !foundDeposit {
		t.Fatalf("expected 30 credit deposit for challenge completion")
	}
}

// Retroactive achievement unlock backfill (EC-GAM-002)
func TestRetroactiveAchievementBackfill(t *testing.T) {
	store := NewMemStore()
	depositor := &MockCreditDepositor{}
	engine := NewEngine(store, depositor)
	ctx := context.Background()

	wsID := "ws-backfill"
	userID := "user-backfill"

	// Create user progress with zero achievements
	_, _ = engine.GetOrCreateProgress(ctx, wsID, userID)

	// Simulate user already having 150 published videos
	historical := map[string]int{
		"publish.completed": 150,
	}

	unlocked, err := engine.BackfillAchievements(ctx, wsID, userID, historical)
	if err != nil {
		t.Fatalf("BackfillAchievements failed: %v", err)
	}
	if len(unlocked) == 0 {
		t.Fatalf("expected at least 1 achievement unlocked retroactively")
	}
	if unlocked[0] != "first_video_published" {
		t.Fatalf("expected first_video_published, got %v", unlocked)
	}

	// Second backfill run is strictly idempotent: unlocks 0 new achievements
	unlocked2, err := engine.BackfillAchievements(ctx, wsID, userID, historical)
	if err != nil {
		t.Fatalf("Second BackfillAchievements failed: %v", err)
	}
	if len(unlocked2) != 0 {
		t.Fatalf("expected 0 new achievements on second backfill, got %v", unlocked2)
	}
}

// Concurrency race test with -race
func TestConcurrentGamificationActivityRaceSafety(t *testing.T) {
	store := NewMemStore()
	depositor := &MockCreditDepositor{}
	engine := NewEngine(store, depositor)
	ctx := context.Background()

	wsID := "ws-race"
	const numUsers = 5
	const numEventsPerUser = 20

	var wg sync.WaitGroup
	for u := 0; u < numUsers; u++ {
		userID := fmt.Sprintf("user-race-%d", u)
		for e := 0; e < numEventsPerUser; e++ {
			wg.Add(1)
			go func(user string, eventNum int) {
				defer wg.Done()
				evt := "video.published"
				if eventNum%2 == 0 {
					evt = "asset.generation_completed"
				}
				_, _, _ = engine.RecordActivity(ctx, wsID, user, evt, nil)
			}(userID, e)
		}
	}
	wg.Wait()

	// Verify all users have consistent, isolated XP
	for u := 0; u < numUsers; u++ {
		userID := fmt.Sprintf("user-race-%d", u)
		p, err := store.GetProgress(ctx, wsID, userID)
		if err != nil {
			t.Fatalf("GetProgress for %s failed: %v", userID, err)
		}
		// 10 events of 5 XP + 10 events of 10 XP = 150 XP
		expectedXP := 10*5 + 10*10
		if p.XP != expectedXP {
			t.Errorf("User %s: expected XP %d, got %d", userID, expectedXP, p.XP)
		}
		if p.Level < 5 {
			t.Errorf("User %s: expected Level >= 5, got %d", userID, p.Level)
		}
	}
}

// Connect RPC Roundtrip & RBAC Permissions
func TestGamificationConnectRPCRoundtrip(t *testing.T) {
	store := NewMemStore()
	depositor := &MockCreditDepositor{}
	engine := NewEngine(store, depositor)
	svc := NewService(engine, store, nil)
	ctx := context.Background()

	wsID := "ws-connect"
	userID := "user-connect"

	// Authenticate context with Contributor role
	pctx := rbac.PolicyContext{
		ActorUserID: userID,
		WorkspaceID: wsID,
		Role:        rbac.RoleContributor,
	}
	authCtx := rbac.WithPolicyContext(ctx, pctx)

	// 1. GetProgress
	resProg, err := svc.GetProgress(authCtx, connect.NewRequest(&platformv1.GetProgressRequest{
		WorkspaceId: &commonv1.UUID{Value: wsID},
		UserId:      userID,
	}))
	if err != nil {
		t.Fatalf("GetProgress RPC failed: %v", err)
	}
	if resProg.Msg.GetProgress().GetLevel() != 1 {
		t.Fatalf("expected level 1, got %d", resProg.Msg.GetProgress().GetLevel())
	}

	// 2. ListAchievements
	resAch, err := svc.ListAchievements(authCtx, connect.NewRequest(&platformv1.ListAchievementsRequest{
		WorkspaceId: &commonv1.UUID{Value: wsID},
		UserId:      userID,
	}))
	if err != nil {
		t.Fatalf("ListAchievements RPC failed: %v", err)
	}
	if len(resAch.Msg.GetAchievements()) == 0 {
		t.Fatalf("expected achievements list to be non-empty")
	}

	// 3. GetDashboard
	resDash, err := svc.GetDashboard(authCtx, connect.NewRequest(&platformv1.GamificationServiceGetDashboardRequest{
		WorkspaceId: &commonv1.UUID{Value: wsID},
		UserId:      userID,
	}))
	if err != nil {
		t.Fatalf("GetDashboard RPC failed: %v", err)
	}
	if resDash.Msg.GetProgress() == nil {
		t.Fatalf("expected dashboard progress to be non-nil")
	}

	// 4. ShareAchievement
	resShare, err := svc.ShareAchievement(authCtx, connect.NewRequest(&platformv1.ShareAchievementRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		AchievementCode: "first_video_published",
		TargetChannel:   "twitter",
	}))
	if err != nil {
		t.Fatalf("ShareAchievement RPC failed: %v", err)
	}
	if !resShare.Msg.GetSuccess() || resShare.Msg.GetShareUrl() == "" {
		t.Fatalf("expected share success with non-empty URL")
	}

	// 5. GetStreak
	resStreak, err := svc.GetStreak(authCtx, connect.NewRequest(&platformv1.GetStreakRequest{
		WorkspaceId: &commonv1.UUID{Value: wsID},
		UserId:      userID,
	}))
	if err != nil {
		t.Fatalf("GetStreak RPC failed: %v", err)
	}
	if resStreak.Msg.GetNextMilestoneDays() != 7 {
		t.Fatalf("expected next milestone 7 days, got %d", resStreak.Msg.GetNextMilestoneDays())
	}
}
