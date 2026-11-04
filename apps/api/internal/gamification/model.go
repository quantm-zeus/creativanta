package gamification

import (
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// Level milestones per EF-11 (docs/02_features/production/ai_video_studio.md):
// L1=0, L5=100, L10=500, L20=2000, L50=25000.
var levelThresholds = []struct {
	level int
	xp    int
}{
	{level: 1, xp: 0},
	{level: 2, xp: 25},
	{level: 3, xp: 50},
	{level: 4, xp: 75},
	{level: 5, xp: 100},
	{level: 6, xp: 180},
	{level: 7, xp: 260},
	{level: 8, xp: 340},
	{level: 9, xp: 420},
	{level: 10, xp: 500},
	{level: 15, xp: 1200},
	{level: 20, xp: 2000},
	{level: 30, xp: 6000},
	{level: 40, xp: 14000},
	{level: 50, xp: 25000},
}

// CalculateLevel computes creator level (1..50) and XP to next level given total XP.
func CalculateLevel(xp int) (level int, xpToNext int) {
	if xp <= 0 {
		return 1, 25
	}
	if xp >= 25000 {
		return 50, 0
	}

	for i := len(levelThresholds) - 1; i >= 0; i-- {
		t := levelThresholds[i]
		if xp >= t.xp {
			if i == len(levelThresholds)-1 {
				return 50, 0
			}
			nextThreshold := levelThresholds[i+1]
			// Interpolate level between milestone anchors
			steps := nextThreshold.level - t.level
			xpDelta := nextThreshold.xp - t.xp
			xpStep := xpDelta / steps

			progressInBracket := xp - t.xp
			subLevel := progressInBracket / xpStep
			calcLevel := t.level + subLevel
			if calcLevel >= nextThreshold.level {
				calcLevel = nextThreshold.level - 1
			}

			// XP to next level
			nextLevelXP := t.xp + (subLevel+1)*xpStep
			if nextLevelXP > nextThreshold.xp {
				nextLevelXP = nextThreshold.xp
			}
			return calcLevel, nextLevelXP - xp
		}
	}
	return 1, 25
}

// Streak milestone rewards per RULE-GAM-004 & EF-11:
// 7-day = 10 credits, 30-day = 50 credits, 90-day = 200 credits.
func StreakMilestoneReward(streakDays int) (rewardCredits int, milestoneCode string) {
	switch streakDays {
	case 7:
		return 10, "streak_7_day"
	case 30:
		return 50, "streak_30_day"
	case 90:
		return 200, "streak_90_day"
	default:
		return 0, ""
	}
}

// NextStreakMilestone returns the next target streak days and credits.
func NextStreakMilestone(currentStreak int) (targetDays int, credits int) {
	if currentStreak < 7 {
		return 7, 10
	} else if currentStreak < 30 {
		return 30, 50
	} else if currentStreak < 90 {
		return 90, 200
	}
	return ((currentStreak / 100) + 1) * 100, 200
}

// CreatorProgress mirrors database_schema.md §14.1.
type CreatorProgress struct {
	ProgressID             string     `json:"progress_id"`
	WorkspaceID            string     `json:"workspace_id"`
	UserID                 string     `json:"user_id"`
	Level                  int        `json:"level"`
	XP                     int        `json:"xp"`
	XPToNextLevel          int        `json:"xp_to_next_level"`
	StreakDays             int        `json:"streak_days"`
	StreakLastActivityDate string     `json:"streak_last_activity_date"` // YYYY-MM-DD
	StreakGraceUntil       *time.Time `json:"streak_grace_until,omitempty"`
	CreatorScore           float64    `json:"creator_score"`
	TotalAchievements      int        `json:"total_achievements"`
	SeasonID               string     `json:"season_id,omitempty"`
	CreatedAt              time.Time  `json:"created_at"`
	UpdatedAt              time.Time  `json:"updated_at"`
}

// AchievementDefinition mirrors database_schema.md §14.2.
type AchievementDefinition struct {
	AchievementID    string    `json:"achievement_id"`
	Code             string    `json:"code"`
	Title            string    `json:"title"`
	Description      string    `json:"description"`
	TriggerCondition string    `json:"trigger_condition"`
	RewardCredits    int       `json:"reward_credits"`
	BadgeImageURL    string    `json:"badge_image_url"`
	Category         string    `json:"category"`
	SortOrder        int       `json:"sort_order"`
	Active           bool      `json:"active"`
	CreatedAt        time.Time `json:"created_at"`
	UpdatedAt        time.Time `json:"updated_at"`
}

// AchievementRecord mirrors database_schema.md §14.2.
type AchievementRecord struct {
	RecordID        string                `json:"record_id"`
	WorkspaceID     string                `json:"workspace_id"`
	UserID          string                `json:"user_id"`
	AchievementID   string                `json:"achievement_id"`
	AchievementCode string                `json:"achievement_code"`
	EarnedAt        time.Time             `json:"earned_at"`
	CreditsAwarded  tenantdb.ExactDecimal `json:"credits_awarded"`
}

// ChallengeDefinition mirrors database_schema.md §22.10.
type ChallengeDefinition struct {
	ChallengeID   string    `json:"challenge_id"`
	Title         string    `json:"title"`
	Description   string    `json:"description"`
	ChallengeType string    `json:"challenge_type"` // publish_count, revenue_target, engagement_target, streak, custom
	TargetValue   int       `json:"target_value"`
	RewardCredits int       `json:"reward_credits"`
	StartDate     string    `json:"start_date"` // YYYY-MM-DD
	EndDate       string    `json:"end_date"`   // YYYY-MM-DD
	Status        string    `json:"status"`     // draft, enrolling, active, completed, rewarded, cancelled
	IsActive      bool      `json:"is_active"`
	SortOrder     int       `json:"sort_order"`
	CreatedAt     time.Time `json:"created_at"`
}

// ChallengeProgress mirrors database_schema.md §22.11.
type ChallengeProgress struct {
	ProgressID          string     `json:"progress_id"`
	WorkspaceID         string     `json:"workspace_id"`
	UserID              string     `json:"user_id"`
	ChallengeID         string     `json:"challenge_id"`
	CurrentValue        int        `json:"current_value"`
	TargetValue         int        `json:"target_value"`
	Completed           bool       `json:"completed"`
	CompletedAt         *time.Time `json:"completed_at,omitempty"`
	RewardCredited      bool       `json:"reward_credited"`
	RewardTransactionID string     `json:"reward_transaction_id,omitempty"`
	CreatedAt           time.Time  `json:"created_at"`
	UpdatedAt           time.Time  `json:"updated_at"`
}

// RewardEvent records idempotent reward grants (Acceptance Target 2).
type RewardEvent struct {
	EventID        string                `json:"event_id"`
	WorkspaceID    string                `json:"workspace_id"`
	UserID         string                `json:"user_id"`
	EventKey       string                `json:"event_key"`
	EventType      string                `json:"event_type"`
	CreditsAwarded tenantdb.ExactDecimal `json:"credits_awarded"`
	XPAwarded      int                   `json:"xp_awarded"`
	IdempotencyKey string                `json:"idempotency_key"`
	Status         string                `json:"status"` // awarded, skipped, reversed
	ProcessedAt    time.Time             `json:"processed_at"`
	Metadata       map[string]any        `json:"metadata,omitempty"`
}

// LeaderboardEntry presents rank within workspace or challenge.
type LeaderboardEntry struct {
	Rank       int    `json:"rank"`
	UserID     string `json:"user_id"`
	UserName   string `json:"user_name"`
	AvatarURL  string `json:"avatar_url"`
	Score      int    `json:"score"`
	Level      int    `json:"level"`
	StreakDays int    `json:"streak_days"`
}
