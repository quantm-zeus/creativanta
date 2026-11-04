package gamification

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

var (
	ErrChallengeNotEnrolling   = errors.New("gamification: challenge is not in enrolling status")
	ErrChallengeAlreadyJoined  = errors.New("gamification: user already joined this challenge")
	ErrInvalidStatusTransition = errors.New("gamification: invalid challenge status transition")
)

// CreditDepositor abstracts idempotent credit deposit to avoid direct RPC dependency (RULE-GAM-007).
type CreditDepositor interface {
	DepositCredits(ctx context.Context, workspaceID, userID string, amount tenantdb.ExactDecimal, reason, idempotencyKey string) error
}

// MockCreditDepositor records credit deposits for testing.
type MockCreditDepositor struct {
	mu       sync.Mutex
	Deposits []CreditDepositRecord
}

type CreditDepositRecord struct {
	WorkspaceID    string
	UserID         string
	Amount         tenantdb.ExactDecimal
	Reason         string
	IdempotencyKey string
	DepositedAt    time.Time
}

func (m *MockCreditDepositor) DepositCredits(ctx context.Context, workspaceID, userID string, amount tenantdb.ExactDecimal, reason, idempotencyKey string) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.Deposits = append(m.Deposits, CreditDepositRecord{
		WorkspaceID:    workspaceID,
		UserID:         userID,
		Amount:         amount,
		Reason:         reason,
		IdempotencyKey: idempotencyKey,
		DepositedAt:    time.Now().UTC(),
	})
	return nil
}

// EventEmitter emits canonical domain events.
type EventEmitter func(ctx context.Context, eventType string, payload any) error

// Engine coordinates gamification logic, streaks, XP, achievements, and challenges.
type Engine struct {
	store     Store
	depositor CreditDepositor
	emitter   EventEmitter
	nowFunc   func() time.Time
	mu        sync.Mutex // lock for concurrency safety across progress updates
}

func NewEngine(store Store, depositor CreditDepositor) *Engine {
	if depositor == nil {
		depositor = &MockCreditDepositor{}
	}
	return &Engine{
		store:     store,
		depositor: depositor,
		emitter: func(ctx context.Context, eventType string, payload any) error {
			return nil
		},
		nowFunc: func() time.Time {
			return time.Now().UTC()
		},
	}
}

func (e *Engine) SetEventEmitter(emitter EventEmitter) {
	e.emitter = emitter
}

func (e *Engine) SetNowFunc(f func() time.Time) {
	e.nowFunc = f
}

func generateID() string {
	b := make([]byte, 16)
	_, _ = rand.Read(b)
	return hex.EncodeToString(b)
}

// GetOrCreateProgress retrieves or initializes per-user creator progress (Acceptance Target 1).
func (e *Engine) GetOrCreateProgress(ctx context.Context, workspaceID, userID string) (*CreatorProgress, error) {
	p, err := e.store.GetProgress(ctx, workspaceID, userID)
	if err == nil {
		return p, nil
	}
	if !errors.Is(err, ErrNotFound) {
		return nil, fmt.Errorf("lookup progress: %w", err)
	}

	now := e.nowFunc()
	p = &CreatorProgress{
		ProgressID:             "prog-" + generateID(),
		WorkspaceID:            workspaceID,
		UserID:                 userID,
		Level:                  1,
		XP:                     0,
		XPToNextLevel:          25,
		StreakDays:             0,
		StreakLastActivityDate: "",
		CreatorScore:           0.0,
		TotalAchievements:      0,
		CreatedAt:              now,
		UpdatedAt:              now,
	}

	if err := e.store.UpsertProgress(ctx, p); err != nil {
		return nil, fmt.Errorf("create progress: %w", err)
	}
	return p, nil
}

// DepositRewardOnce idempotently deposits rewards once (Acceptance Target 2).
// Repeat/replay calls return the existing record and perform ZERO duplicate credit/XP awards.
func (e *Engine) DepositRewardOnce(ctx context.Context, workspaceID, userID, eventKey, eventType string, credits int, xp int, idempotencyKey string) (*RewardEvent, bool, error) {
	e.mu.Lock()
	defer e.mu.Unlock()

	// Check if already processed
	existing, err := e.store.GetRewardEvent(ctx, workspaceID, userID, eventKey)
	if err == nil && existing != nil {
		// Event replay detected: return existing record, skipped award
		return existing, false, nil
	}

	now := e.nowFunc()
	creditsDec := tenantdb.NewExactDecimalFromInt64(int64(credits))
	event := &RewardEvent{
		EventID:        "revt-" + generateID(),
		WorkspaceID:    workspaceID,
		UserID:         userID,
		EventKey:       eventKey,
		EventType:      eventType,
		CreditsAwarded: creditsDec,
		XPAwarded:      xp,
		IdempotencyKey: idempotencyKey,
		Status:         "awarded",
		ProcessedAt:    now,
	}

	// 1. Persist reward event
	if err := e.store.CreateRewardEvent(ctx, event); err != nil {
		if errors.Is(err, ErrAlreadyExists) {
			// Concurrent replay won race
			existing, _ := e.store.GetRewardEvent(ctx, workspaceID, userID, eventKey)
			return existing, false, nil
		}
		return nil, false, fmt.Errorf("persist reward event: %w", err)
	}

	// 2. Deposit credits through internal credit accounting (RULE-GAM-007)
	if credits > 0 && e.depositor != nil {
		_ = e.depositor.DepositCredits(ctx, workspaceID, userID, creditsDec, eventType, idempotencyKey)
	}

	return event, true, nil
}

// RecordActivity registers an action for a user, updates streaks and XP, and checks triggers (Acceptance Target 1).
func (e *Engine) RecordActivity(ctx context.Context, workspaceID, userID, activityType string, payload map[string]any) (*CreatorProgress, []string, error) {
	e.mu.Lock()
	defer e.mu.Unlock()

	p, err := e.store.GetProgress(ctx, workspaceID, userID)
	now := e.nowFunc()
	if errors.Is(err, ErrNotFound) {
		p = &CreatorProgress{
			ProgressID:             "prog-" + generateID(),
			WorkspaceID:            workspaceID,
			UserID:                 userID,
			Level:                  1,
			XP:                     0,
			XPToNextLevel:          25,
			StreakDays:             0,
			StreakLastActivityDate: "",
			CreatedAt:              now,
			UpdatedAt:              now,
		}
	} else if err != nil {
		return nil, nil, fmt.Errorf("get progress: %w", err)
	}

	todayStr := now.Format("2006-01-02")

	// Streak calculation (RULE-GAM-003, EC-GAM-001)
	if p.StreakLastActivityDate == "" {
		p.StreakDays = 1
		p.StreakLastActivityDate = todayStr
	} else if p.StreakLastActivityDate == todayStr {
		// Same day: streak already counted for today, do not increment streak days
	} else {
		yesterdayStr := now.AddDate(0, 0, -1).Format("2006-01-02")
		if p.StreakLastActivityDate == yesterdayStr {
			p.StreakDays++
			p.StreakLastActivityDate = todayStr
		} else {
			// Check grace period (EC-GAM-001)
			inGracePeriod := false
			if p.StreakGraceUntil != nil && now.Before(*p.StreakGraceUntil) {
				inGracePeriod = true
			}

			if inGracePeriod {
				// Retain and increment streak due to active grace period
				p.StreakDays++
			} else {
				// Missed day -> reset streak to 1
				p.StreakDays = 1
			}
			p.StreakLastActivityDate = todayStr
		}
	}

	// Calculate XP addition based on EF-11 and canonical events
	xpGain := 5
	switch activityType {
	case "clip.viral.10k":
		xpGain = 20
	case "production.remix.generation_completed", "remix.completed":
		xpGain = 15
	case "asset.generation_completed", "production.video_edit_job.completed":
		xpGain = 10
	case "publish.completed", "video.published":
		xpGain = 5
	}

	p.XP += xpGain
	oldLevel := p.Level
	newLevel, xpToNext := CalculateLevel(p.XP)
	p.Level = newLevel
	p.XPToNextLevel = xpToNext
	p.UpdatedAt = now

	// Save progress
	if err := e.store.UpsertProgress(ctx, p); err != nil {
		return nil, nil, fmt.Errorf("upsert progress: %w", err)
	}

	// Emit xp.earned canonical event (§14)
	if e.emitter != nil {
		_ = e.emitter(ctx, "xp.earned", map[string]any{
			"workspace_id": workspaceID,
			"user_id":      userID,
			"xp_amount":    xpGain,
			"source":       activityType,
		})
	}

	// Check level up event
	if newLevel > oldLevel && e.emitter != nil {
		_ = e.emitter(ctx, "gamification.level.up", map[string]any{
			"workspace_id": workspaceID,
			"user_id":      userID,
			"new_level":    newLevel,
		})
	}

	// Check streak milestone rewards (RULE-GAM-004)
	rewardCredits, milestoneCode := StreakMilestoneReward(p.StreakDays)
	if rewardCredits > 0 {
		eventKey := fmt.Sprintf("streak:%d", p.StreakDays)
		idempKey := fmt.Sprintf("gamif:streak:%s:%s:%d", workspaceID, userID, p.StreakDays)
		_, newlyAwarded, _ := e.depositRewardInternal(ctx, workspaceID, userID, eventKey, "streak.milestone", rewardCredits, 0, idempKey)
		if newlyAwarded && e.emitter != nil {
			_ = e.emitter(ctx, "streak.milestone", map[string]any{
				"workspace_id":   workspaceID,
				"user_id":        userID,
				"streak_days":    p.StreakDays,
				"milestone_type": milestoneCode,
				"credits":        rewardCredits,
			})
		}
	}

	// Evaluate achievements unlock
	unlockedCodes := e.evaluateAchievementsInternal(ctx, p, activityType, payload)

	return p, unlockedCodes, nil
}

// depositRewardInternal handles reward deposit with mutex already held.
func (e *Engine) depositRewardInternal(ctx context.Context, workspaceID, userID, eventKey, eventType string, credits int, xp int, idempotencyKey string) (*RewardEvent, bool, error) {
	existing, err := e.store.GetRewardEvent(ctx, workspaceID, userID, eventKey)
	if err == nil && existing != nil {
		return existing, false, nil
	}

	now := e.nowFunc()
	creditsDec := tenantdb.NewExactDecimalFromInt64(int64(credits))
	event := &RewardEvent{
		EventID:        "revt-" + generateID(),
		WorkspaceID:    workspaceID,
		UserID:         userID,
		EventKey:       eventKey,
		EventType:      eventType,
		CreditsAwarded: creditsDec,
		XPAwarded:      xp,
		IdempotencyKey: idempotencyKey,
		Status:         "awarded",
		ProcessedAt:    now,
	}

	if err := e.store.CreateRewardEvent(ctx, event); err != nil {
		if errors.Is(err, ErrAlreadyExists) {
			existing, _ := e.store.GetRewardEvent(ctx, workspaceID, userID, eventKey)
			return existing, false, nil
		}
		return nil, false, err
	}

	if credits > 0 && e.depositor != nil {
		_ = e.depositor.DepositCredits(ctx, workspaceID, userID, creditsDec, eventType, idempotencyKey)
	}

	return event, true, nil
}

// evaluateAchievementsInternal tests triggers and unlocks achievements.
func (e *Engine) evaluateAchievementsInternal(ctx context.Context, p *CreatorProgress, activityType string, payload map[string]any) []string {
	var candidates []string

	switch activityType {
	case "asset.generation_completed", "production.video_edit_job.completed":
		candidates = append(candidates, "first_video_generated")
	case "production.remix.generation_completed", "remix.completed":
		candidates = append(candidates, "first_video_generated", "remix_pioneer")
	case "clip.extracted", "production.clip_factory.clips_proposed":
		candidates = append(candidates, "first_video_generated", "clip_master")
	case "publish.completed", "video.published":
		candidates = append(candidates, "first_video_published")
	case "clip.viral.10k":
		candidates = append(candidates, "viral_clip_10k")
	}

	if p.StreakDays >= 7 {
		candidates = append(candidates, "streak_7_day")
	}

	var newlyUnlocked []string
	now := e.nowFunc()

	for _, code := range candidates {
		def, err := e.store.GetAchievementDefinition(ctx, code)
		if err != nil || !def.Active {
			continue
		}

		// Check if already unlocked
		_, err = e.store.GetAchievementRecord(ctx, p.WorkspaceID, p.UserID, def.AchievementID)
		if err == nil {
			// Already earned
			continue
		}

		// Award achievement record
		creditsDec := tenantdb.NewExactDecimalFromInt64(int64(def.RewardCredits))
		rec := &AchievementRecord{
			RecordID:        "arec-" + generateID(),
			WorkspaceID:     p.WorkspaceID,
			UserID:          p.UserID,
			AchievementID:   def.AchievementID,
			AchievementCode: def.Code,
			EarnedAt:        now,
			CreditsAwarded:  creditsDec,
		}

		if err := e.store.CreateAchievementRecord(ctx, rec); err != nil {
			continue
		}

		// Auto-deposit credits idempotently (RULE-GAM-007, Acceptance Target 2)
		eventKey := "achievement:" + def.Code
		idempKey := fmt.Sprintf("gamif:ach:%s:%s:%s", p.WorkspaceID, p.UserID, def.Code)
		_, _, _ = e.depositRewardInternal(ctx, p.WorkspaceID, p.UserID, eventKey, "achievement.unlocked", def.RewardCredits, 0, idempKey)

		// Increment total achievements
		p.TotalAchievements++
		_ = e.store.UpsertProgress(ctx, p)

		newlyUnlocked = append(newlyUnlocked, def.Code)

		// Emit canonical achievement.unlocked event (RULE-GAM-008, §14)
		if e.emitter != nil {
			_ = e.emitter(ctx, "achievement.unlocked", map[string]any{
				"workspace_id":     p.WorkspaceID,
				"user_id":          p.UserID,
				"achievement_code": def.Code,
				"credits":          def.RewardCredits,
			})
		}
	}

	return newlyUnlocked
}

// BackfillAchievements retroactively unlocks achievements based on historical counts (EC-GAM-002).
func (e *Engine) BackfillAchievements(ctx context.Context, workspaceID, userID string, historicalCounts map[string]int) ([]string, error) {
	e.mu.Lock()
	defer e.mu.Unlock()

	p, err := e.store.GetProgress(ctx, workspaceID, userID)
	if err != nil {
		return nil, err
	}

	defs, err := e.store.ListAchievementDefinitions(ctx, "", true)
	if err != nil {
		return nil, err
	}

	now := e.nowFunc()
	var unlocked []string

	for _, def := range defs {
		// Check existing record
		_, err := e.store.GetAchievementRecord(ctx, workspaceID, userID, def.AchievementID)
		if err == nil {
			continue
		}

		// Parse condition
		var cond map[string]any
		if err := json.Unmarshal([]byte(def.TriggerCondition), &cond); err != nil {
			continue
		}

		shouldUnlock := false
		if evt, ok := cond["event"].(string); ok {
			countReq := 1
			if reqVal, ok := cond["count"].(float64); ok {
				countReq = int(reqVal)
			}
			if historicalCounts[evt] >= countReq {
				shouldUnlock = true
			}
		}

		if shouldUnlock {
			creditsDec := tenantdb.NewExactDecimalFromInt64(int64(def.RewardCredits))
			rec := &AchievementRecord{
				RecordID:        "arec-" + generateID(),
				WorkspaceID:     workspaceID,
				UserID:          userID,
				AchievementID:   def.AchievementID,
				AchievementCode: def.Code,
				EarnedAt:        now,
				CreditsAwarded:  creditsDec,
			}
			if err := e.store.CreateAchievementRecord(ctx, rec); err != nil {
				continue
			}

			eventKey := "achievement:" + def.Code
			idempKey := fmt.Sprintf("gamif:ach:%s:%s:%s", workspaceID, userID, def.Code)
			_, _, _ = e.depositRewardInternal(ctx, workspaceID, userID, eventKey, "achievement.unlocked", def.RewardCredits, 0, idempKey)

			p.TotalAchievements++
			unlocked = append(unlocked, def.Code)

			if e.emitter != nil {
				_ = e.emitter(ctx, "achievement.unlocked", map[string]any{
					"workspace_id":     workspaceID,
					"user_id":          userID,
					"achievement_code": def.Code,
					"credits":          def.RewardCredits,
					"backfilled":       true,
				})
			}
		}
	}

	if len(unlocked) > 0 {
		_ = e.store.UpsertProgress(ctx, p)
	}

	return unlocked, nil
}

// JoinChallenge enrolls a user into an enrolling or active challenge (RULE-GAM-006).
func (e *Engine) JoinChallenge(ctx context.Context, workspaceID, userID, challengeID string) (*ChallengeProgress, error) {
	e.mu.Lock()
	defer e.mu.Unlock()

	c, err := e.store.GetChallenge(ctx, challengeID)
	if err != nil {
		return nil, err
	}
	if c.Status != "enrolling" && c.Status != "active" {
		return nil, ErrChallengeNotEnrolling
	}

	// Check if already enrolled
	existing, err := e.store.GetChallengeProgress(ctx, workspaceID, userID, challengeID)
	if err == nil && existing != nil {
		return nil, ErrChallengeAlreadyJoined
	}

	now := e.nowFunc()
	cp := &ChallengeProgress{
		ProgressID:     "chp-" + generateID(),
		WorkspaceID:    workspaceID,
		UserID:         userID,
		ChallengeID:    challengeID,
		CurrentValue:   0,
		TargetValue:    c.TargetValue,
		Completed:      false,
		RewardCredited: false,
		CreatedAt:      now,
		UpdatedAt:      now,
	}

	if err := e.store.UpsertChallengeProgress(ctx, cp); err != nil {
		return nil, fmt.Errorf("create challenge progress: %w", err)
	}
	return cp, nil
}

// UpdateChallengeProgress advances progress on a challenge and distributes rewards when target met.
func (e *Engine) UpdateChallengeProgress(ctx context.Context, workspaceID, userID, challengeID string, increment int) (*ChallengeProgress, bool, error) {
	e.mu.Lock()
	defer e.mu.Unlock()

	cp, err := e.store.GetChallengeProgress(ctx, workspaceID, userID, challengeID)
	if err != nil {
		return nil, false, err
	}

	c, err := e.store.GetChallenge(ctx, challengeID)
	if err != nil {
		return nil, false, err
	}

	cp.CurrentValue += increment
	now := e.nowFunc()
	cp.UpdatedAt = now

	newlyCompleted := false
	if !cp.Completed && cp.CurrentValue >= cp.TargetValue {
		cp.Completed = true
		cp.CompletedAt = &now
		newlyCompleted = true

		// Idempotent reward deposit (RULE-GAM-007, Acceptance Target 2)
		eventKey := "challenge:" + challengeID
		idempKey := fmt.Sprintf("gamif:chal:%s:%s:%s", workspaceID, userID, challengeID)
		_, awarded, _ := e.depositRewardInternal(ctx, workspaceID, userID, eventKey, "challenge.completed", c.RewardCredits, 0, idempKey)
		if awarded {
			cp.RewardCredited = true
		}

		if e.emitter != nil {
			_ = e.emitter(ctx, "challenge.completed", map[string]any{
				"workspace_id":   workspaceID,
				"user_id":        userID,
				"challenge_id":   challengeID,
				"reward_credits": c.RewardCredits,
			})
		}
	}

	if err := e.store.UpsertChallengeProgress(ctx, cp); err != nil {
		return nil, false, fmt.Errorf("upsert challenge progress: %w", err)
	}

	return cp, newlyCompleted, nil
}

// CloseChallengeEnrollment closes enrollment and handles zero participant cancellation (EC-GAM-003).
func (e *Engine) CloseChallengeEnrollment(ctx context.Context, challengeID string) (string, error) {
	e.mu.Lock()
	defer e.mu.Unlock()

	c, err := e.store.GetChallenge(ctx, challengeID)
	if err != nil {
		return "", err
	}
	if c.Status != "enrolling" {
		return c.Status, fmt.Errorf("%w: cannot close enrollment from status %s", ErrInvalidStatusTransition, c.Status)
	}

	count, err := e.store.CountChallengeParticipants(ctx, challengeID)
	if err != nil {
		return "", err
	}

	if count == 0 {
		// EC-GAM-003: Challenge with 0 participants transitions to cancelled!
		if err := e.store.UpdateChallengeStatus(ctx, challengeID, "cancelled"); err != nil {
			return "", err
		}
		if e.emitter != nil {
			_ = e.emitter(ctx, "challenge.cancelled", map[string]any{
				"challenge_id": challengeID,
				"reason":       "zero_participants",
			})
		}
		return "cancelled", nil
	}

	// Min participants met -> transition to active
	if err := e.store.UpdateChallengeStatus(ctx, challengeID, "active"); err != nil {
		return "", err
	}
	if e.emitter != nil {
		_ = e.emitter(ctx, "gamification.challenge.started", map[string]any{
			"challenge_id": challengeID,
			"start_date":   c.StartDate,
			"end_date":     c.EndDate,
			"participants": count,
		})
	}
	return "active", nil
}

// AdminRestoreStreak manually restores streak after platform downtime (EC-GAM-001).
func (e *Engine) AdminRestoreStreak(ctx context.Context, workspaceID, targetUserID string, restoredStreakDays int, reason string) (*CreatorProgress, error) {
	e.mu.Lock()
	defer e.mu.Unlock()

	p, err := e.store.GetProgress(ctx, workspaceID, targetUserID)
	if err != nil {
		return nil, err
	}

	now := e.nowFunc()
	p.StreakDays = restoredStreakDays
	p.StreakLastActivityDate = now.Format("2006-01-02")
	// Extend grace period by 48 hours
	grace := now.Add(48 * time.Hour)
	p.StreakGraceUntil = &grace
	p.UpdatedAt = now

	if err := e.store.UpsertProgress(ctx, p); err != nil {
		return nil, fmt.Errorf("update restored progress: %w", err)
	}

	if e.emitter != nil {
		_ = e.emitter(ctx, "gamification.streak.restored", map[string]any{
			"workspace_id":         workspaceID,
			"target_user_id":       targetUserID,
			"restored_streak_days": restoredStreakDays,
			"reason":               reason,
		})
	}

	return p, nil
}
