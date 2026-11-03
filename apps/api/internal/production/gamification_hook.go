package production

import (
	"fmt"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// CreatorProgressRecord mirrors database_schema.md §14.1.
type CreatorProgressRecord struct {
	ProgressID             string    `json:"progress_id"`
	WorkspaceID            string    `json:"workspace_id"`
	UserID                 string    `json:"user_id"`
	Level                  int       `json:"level"`
	XP                     int       `json:"xp"`
	XPToNextLevel          int       `json:"xp_to_next_level"`
	StreakDays             int       `json:"streak_days"`
	StreakLastActivityDate string    `json:"streak_last_activity_date"` // YYYY-MM-DD
	CreatorScore           float64   `json:"creator_score"`
	TotalAchievements      int       `json:"total_achievements"`
	SeasonID               string    `json:"season_id,omitempty"`
	CreatedAt              time.Time `json:"created_at"`
	UpdatedAt              time.Time `json:"updated_at"`
}

// AchievementDefinitionRecord mirrors database_schema.md §14.2.
type AchievementDefinitionRecord struct {
	AchievementID    string `json:"achievement_id"`
	Code             string `json:"code"`
	Title            string `json:"title"`
	Description      string `json:"description"`
	TriggerCondition string `json:"trigger_condition"`
	RewardCredits    int    `json:"reward_credits"`
	Category         string `json:"category"`
	Active           bool   `json:"active"`
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

// GamificationHook coordinates streak progression, XP calculation,
// and achievement unlocks triggered by durable production domain events.
// Conforms to docs/02_features/platform/gamification.md (RULE-GAM-001..008)
// and ACCEPTANCE_TESTS.md (AC-GAMIF-001, AC-GAMIF-002, AC-M07-016).
type GamificationHook struct {
	mu                 sync.RWMutex
	service            *Service
	progress           map[string]*CreatorProgressRecord       // "wsID:userID" -> record
	definitions        map[string]*AchievementDefinitionRecord // code -> definition
	achievements       map[string]*AchievementRecord           // "wsID:userID:code" -> record
	userActivity       map[string]int                          // "wsID:userID:eventType" -> count
	AutoDepositCredits bool                                    // when true, auto-deposits credit rewards to workspace balance
}

// NewGamificationHook initializes the gamification hook and standard achievement definitions.
func NewGamificationHook(svc *Service) *GamificationHook {
	h := &GamificationHook{
		service:      svc,
		progress:     make(map[string]*CreatorProgressRecord),
		definitions:  make(map[string]*AchievementDefinitionRecord),
		achievements: make(map[string]*AchievementRecord),
		userActivity: make(map[string]int),
	}

	// Seed canonical achievement definitions (§14.2)
	h.definitions["first_video_generated"] = &AchievementDefinitionRecord{
		AchievementID: "ach-first-video",
		Code:          "first_video_generated",
		Title:         "Khởi Đầu Sáng Tạo",
		Description:   "Tạo video AI đầu tiên thành công trong hệ thống",
		RewardCredits: 10,
		Category:      "milestone",
		Active:        true,
	}
	h.definitions["remix_pioneer"] = &AchievementDefinitionRecord{
		AchievementID: "ach-remix-pioneer",
		Code:          "remix_pioneer",
		Title:         "Bậc Thầy Chuyển Thể",
		Description:   "Tạo video AI Remix đạt kiểm tra tính nguyên bản <30%",
		RewardCredits: 15,
		Category:      "content",
		Active:        true,
	}
	h.definitions["clip_master"] = &AchievementDefinitionRecord{
		AchievementID: "ach-clip-master",
		Code:          "clip_master",
		Title:         "Chuyên Gia Viral Clips",
		Description:   "Trích xuất và đề xuất clips thành công từ Clip Factory",
		RewardCredits: 15,
		Category:      "content",
		Active:        true,
	}
	h.definitions["streak_7_day"] = &AchievementDefinitionRecord{
		AchievementID: "ach-streak-7-day",
		Code:          "streak_7_day",
		Title:         "Sáng Tạo Kiên Trì",
		Description:   "Duy trì chuỗi hoạt động 7 ngày liên tiếp",
		RewardCredits: 50,
		Category:      "streak",
		Active:        true,
	}
	h.definitions["first_video_published"] = &AchievementDefinitionRecord{
		AchievementID: "ach-first-publish",
		Code:          "first_video_published",
		Title:         "Bước Ra Thế Giới",
		Description:   "Xuất bản video đầu tiên lên mạng xã hội",
		RewardCredits: 10,
		Category:      "milestone",
		Active:        true,
	}

	return h
}

// GetOrCreateProgress retrieves or initializes creator progress for a user in a workspace.
func (h *GamificationHook) GetOrCreateProgress(wsID, userID string) *CreatorProgressRecord {
	h.mu.Lock()
	defer h.mu.Unlock()

	key := fmt.Sprintf("%s:%s", wsID, userID)
	if p, ok := h.progress[key]; ok {
		return p
	}

	now := time.Now().UTC()
	p := &CreatorProgressRecord{
		ProgressID:        fmt.Sprintf("prog-%s-%s", wsID, userID),
		WorkspaceID:       wsID,
		UserID:            userID,
		Level:             1,
		XP:                0,
		XPToNextLevel:     100,
		StreakDays:        0,
		CreatorScore:      0.0,
		TotalAchievements: 0,
		CreatedAt:         now,
		UpdatedAt:         now,
	}
	h.progress[key] = p
	return p
}

// RecordActivity registers an action for a user and updates streak & XP (AC-GAMIF-001, AC-M07-016).
func (h *GamificationHook) RecordActivity(wsID, userID, activityType string) (*CreatorProgressRecord, []string) {
	h.mu.Lock()
	key := fmt.Sprintf("%s:%s", wsID, userID)
	p, ok := h.progress[key]
	now := time.Now().UTC()
	todayStr := now.Format("2006-01-02")

	if !ok {
		p = &CreatorProgressRecord{
			ProgressID:        fmt.Sprintf("prog-%s-%s", wsID, userID),
			WorkspaceID:       wsID,
			UserID:            userID,
			Level:             1,
			XP:                0,
			XPToNextLevel:     100,
			StreakDays:        0,
			CreatorScore:      0.0,
			TotalAchievements: 0,
			CreatedAt:         now,
			UpdatedAt:         now,
		}
		h.progress[key] = p
	}

	// Update activity count
	actKey := fmt.Sprintf("%s:%s:%s", wsID, userID, activityType)
	h.userActivity[actKey]++

	// Streak calculation (RULE-GAM-003, AC-GAMIF-001)
	if p.StreakLastActivityDate == "" {
		p.StreakDays = 1
		p.StreakLastActivityDate = todayStr
	} else if p.StreakLastActivityDate == todayStr {
		// Same day, streak already counted for today
	} else {
		// Parse previous date
		lastDate, err := time.Parse("2006-01-02", p.StreakLastActivityDate)
		if err == nil {
			yesterdayStr := now.AddDate(0, 0, -1).Format("2006-01-02")
			if p.StreakLastActivityDate == yesterdayStr {
				// Consecutive day
				p.StreakDays++
			} else if lastDate.Before(now.AddDate(0, 0, -1)) {
				// Missed day -> reset streak to 1
				p.StreakDays = 1
			}
		} else {
			p.StreakDays = 1
		}
		p.StreakLastActivityDate = todayStr
	}

	// Base XP for creative activity (PRD §23.7, AC-M07-016)
	baseXP := 20
	p.XP += baseXP
	p.Level = 1 + (p.XP / 100)
	p.XPToNextLevel = 100 - (p.XP % 100)
	p.UpdatedAt = now
	h.mu.Unlock()

	// Check achievements
	unlocked := h.evaluateAchievements(wsID, userID, activityType)
	return p, unlocked
}

// evaluateAchievements tests whether achievements should unlock and awards rewards idempotently.
func (h *GamificationHook) evaluateAchievements(wsID, userID, triggerEvent string) []string {
	var newlyUnlocked []string

	toCheck := []string{}
	switch triggerEvent {
	case "asset.generation_completed", "production.video_edit_job.completed":
		toCheck = append(toCheck, "first_video_generated")
	case "remix.completed", "production.remix.generation_completed":
		toCheck = append(toCheck, "first_video_generated", "remix_pioneer")
	case "clip.extracted", "production.clip_factory.clips_proposed":
		toCheck = append(toCheck, "first_video_generated", "clip_master")
	case "asset.approved", "publish.completed":
		toCheck = append(toCheck, "first_video_published")
	}

	// Always check streak achievement
	h.mu.RLock()
	key := fmt.Sprintf("%s:%s", wsID, userID)
	p := h.progress[key]
	var streakDays int
	if p != nil {
		streakDays = p.StreakDays
	}
	h.mu.RUnlock()

	if streakDays >= 7 {
		toCheck = append(toCheck, "streak_7_day")
	}

	for _, code := range toCheck {
		if h.unlockAchievement(wsID, userID, code) {
			newlyUnlocked = append(newlyUnlocked, code)
		}
	}

	return newlyUnlocked
}

// unlockAchievement awards an achievement once (GAMIF_CONFLICT_001).
// Emits canonical achievement.unlocked event (RULE-GAM-008, domain_event_catalog.md §14).
func (h *GamificationHook) unlockAchievement(wsID, userID, code string) bool {
	h.mu.Lock()
	achKey := fmt.Sprintf("%s:%s:%s", wsID, userID, code)
	if _, exists := h.achievements[achKey]; exists {
		h.mu.Unlock()
		return false // Already unlocked, idempotent no double award
	}

	def, found := h.definitions[code]
	if !found {
		h.mu.Unlock()
		return false
	}

	now := time.Now().UTC()
	creditReward := tenantdb.MustParseExactDecimal(fmt.Sprintf("%d.000000", def.RewardCredits))
	rec := &AchievementRecord{
		RecordID:        fmt.Sprintf("ar-%s-%s-%s", wsID, userID, code),
		WorkspaceID:     wsID,
		UserID:          userID,
		AchievementID:   def.AchievementID,
		AchievementCode: code,
		EarnedAt:        now,
		CreditsAwarded:  creditReward,
	}
	h.achievements[achKey] = rec

	// Update progress XP and total achievements
	progKey := fmt.Sprintf("%s:%s", wsID, userID)
	if p, ok := h.progress[progKey]; ok {
		p.TotalAchievements++
		// Bonus XP for achievement
		p.XP += 50
		p.Level = 1 + (p.XP / 100)
		p.XPToNextLevel = 100 - (p.XP % 100)
		p.UpdatedAt = now
	}
	h.mu.Unlock()

	// Auto-deposit credits into workspace if enabled (RULE-GAM-007)
	if h.AutoDepositCredits && h.service != nil && def.RewardCredits > 0 {
		h.service.refundCredits(wsID, creditReward)
	}

	// Emit canonical achievement.unlocked domain event (RULE-GAM-008, AC-GAMIF-002)
	if h.service != nil {
		h.service.RecordEvent(DomainEvent{
			EventType:   "achievement.unlocked",
			WorkspaceID: wsID,
			Payload: map[string]any{
				"workspace_id":     wsID,
				"user_id":          userID,
				"achievement_code": code,
				"title":            def.Title,
				"credits":          def.RewardCredits,
				"earned_at":        now,
			},
			OccurredAt: now,
		})
	}

	return true
}

// HandleEvent receives a domain event from production and triggers gamification progression.
func (h *GamificationHook) HandleEvent(e DomainEvent) {
	wsID := e.WorkspaceID
	if wsID == "" {
		if rawWs, ok := e.Payload["workspace_id"].(string); ok {
			wsID = rawWs
		}
	}
	if wsID == "" {
		return
	}

	userID := "default-creator"
	if rawUser, ok := e.Payload["user_id"].(string); ok && rawUser != "" {
		userID = rawUser
	} else if rawUser, ok := e.Payload["approved_by"].(string); ok && rawUser != "" {
		userID = rawUser
	}

	// Process activity
	switch e.EventType {
	case "asset.generation_completed",
		"production.video_edit_job.completed",
		"remix.completed",
		"production.remix.generation_completed",
		"clip.extracted",
		"production.clip_factory.clips_proposed",
		"asset.approved":
		h.RecordActivity(wsID, userID, e.EventType)
	}
}

// GetUserAchievements returns list of unlocked achievements for user.
func (h *GamificationHook) GetUserAchievements(wsID, userID string) []*AchievementRecord {
	h.mu.RLock()
	defer h.mu.RUnlock()

	var result []*AchievementRecord
	prefix := fmt.Sprintf("%s:%s:", wsID, userID)
	for k, v := range h.achievements {
		if len(k) >= len(prefix) && k[:len(prefix)] == prefix {
			result = append(result, v)
		}
	}
	return result
}

// SetUserStreak allows testing specific streak days (e.g. simulating 7-day streak).
func (h *GamificationHook) SetUserStreak(wsID, userID string, streakDays int, lastActivityDate string) {
	h.mu.Lock()
	defer h.mu.Unlock()

	key := fmt.Sprintf("%s:%s", wsID, userID)
	p, ok := h.progress[key]
	if !ok {
		now := time.Now().UTC()
		p = &CreatorProgressRecord{
			ProgressID:  fmt.Sprintf("prog-%s-%s", wsID, userID),
			WorkspaceID: wsID,
			UserID:      userID,
			Level:       1,
			CreatedAt:   now,
			UpdatedAt:   now,
		}
		h.progress[key] = p
	}
	p.StreakDays = streakDays
	p.StreakLastActivityDate = lastActivityDate
}
