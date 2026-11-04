package gamification

import (
	"context"
	"errors"
	"fmt"
	"sort"
	"sync"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

var (
	ErrNotFound      = errors.New("gamification: record not found")
	ErrAlreadyExists = errors.New("gamification: record already exists")
)

// Store defines persistence operations for the Gamification engine.
type Store interface {
	GetProgress(ctx context.Context, workspaceID, userID string) (*CreatorProgress, error)
	UpsertProgress(ctx context.Context, progress *CreatorProgress) error
	ListProgressByWorkspace(ctx context.Context, workspaceID string, limit int) ([]*CreatorProgress, error)

	GetAchievementDefinition(ctx context.Context, code string) (*AchievementDefinition, error)
	ListAchievementDefinitions(ctx context.Context, category string, activeOnly bool) ([]*AchievementDefinition, error)
	GetAchievementRecord(ctx context.Context, workspaceID, userID, achievementID string) (*AchievementRecord, error)
	CreateAchievementRecord(ctx context.Context, record *AchievementRecord) error
	ListAchievementRecords(ctx context.Context, workspaceID, userID string) ([]*AchievementRecord, error)

	GetChallenge(ctx context.Context, challengeID string) (*ChallengeDefinition, error)
	ListChallenges(ctx context.Context, status string) ([]*ChallengeDefinition, error)
	CreateChallenge(ctx context.Context, challenge *ChallengeDefinition) error
	UpdateChallengeStatus(ctx context.Context, challengeID, status string) error

	GetChallengeProgress(ctx context.Context, workspaceID, userID, challengeID string) (*ChallengeProgress, error)
	UpsertChallengeProgress(ctx context.Context, cp *ChallengeProgress) error
	ListChallengeProgressByUser(ctx context.Context, workspaceID, userID string) ([]*ChallengeProgress, error)
	CountChallengeParticipants(ctx context.Context, challengeID string) (int, error)

	GetRewardEvent(ctx context.Context, workspaceID, userID, eventKey string) (*RewardEvent, error)
	CreateRewardEvent(ctx context.Context, event *RewardEvent) error
}

// MemStore provides in-memory thread-safe storage for tests and fast unit verification.
type MemStore struct {
	mu           sync.RWMutex
	progress     map[string]*CreatorProgress       // "wsID:userID" -> CreatorProgress
	definitions  map[string]*AchievementDefinition // code -> AchievementDefinition
	records      map[string]*AchievementRecord     // "wsID:userID:achID" -> AchievementRecord
	challenges   map[string]*ChallengeDefinition   // challengeID -> ChallengeDefinition
	chalProgress map[string]*ChallengeProgress     // "wsID:userID:challengeID" -> ChallengeProgress
	rewardEvents map[string]*RewardEvent           // "wsID:userID:eventKey" -> RewardEvent
}

func NewMemStore() *MemStore {
	m := &MemStore{
		progress:     make(map[string]*CreatorProgress),
		definitions:  make(map[string]*AchievementDefinition),
		records:      make(map[string]*AchievementRecord),
		challenges:   make(map[string]*ChallengeDefinition),
		chalProgress: make(map[string]*ChallengeProgress),
		rewardEvents: make(map[string]*RewardEvent),
	}
	m.seedDefaultDefinitions()
	return m
}

func (m *MemStore) seedDefaultDefinitions() {
	defs := []*AchievementDefinition{
		{
			AchievementID:    "ach-first-video",
			Code:             "first_video_generated",
			Title:            "Khởi Đầu Sáng Tạo",
			Description:      "Tạo video AI đầu tiên thành công trong hệ thống",
			TriggerCondition: `{"event": "asset.generation_completed", "count": 1}`,
			RewardCredits:    10,
			Category:         "milestone",
			Active:           true,
			SortOrder:        1,
		},
		{
			AchievementID:    "ach-remix-pioneer",
			Code:             "remix_pioneer",
			Title:            "Bậc Thầy Chuyển Thể",
			Description:      "Tạo video AI Remix đạt kiểm tra tính nguyên bản <30%",
			TriggerCondition: `{"event": "production.remix.generation_completed", "count": 1}`,
			RewardCredits:    15,
			Category:         "content",
			Active:           true,
			SortOrder:        2,
		},
		{
			AchievementID:    "ach-clip-master",
			Code:             "clip_master",
			Title:            "Chuyên Gia Viral Clips",
			Description:      "Trích xuất và đề xuất clips thành công từ Clip Factory",
			TriggerCondition: `{"event": "clip.extracted", "count": 1}`,
			RewardCredits:    15,
			Category:         "content",
			Active:           true,
			SortOrder:        3,
		},
		{
			AchievementID:    "ach-streak-7-day",
			Code:             "streak_7_day",
			Title:            "Sáng Tạo Kiên Trì",
			Description:      "Duy trì chuỗi hoạt động 7 ngày liên tiếp",
			TriggerCondition: `{"streak_days": 7}`,
			RewardCredits:    10,
			Category:         "streak",
			Active:           true,
			SortOrder:        4,
		},
		{
			AchievementID:    "ach-first-publish",
			Code:             "first_video_published",
			Title:            "Bước Ra Thế Giới",
			Description:      "Xuất bản video đầu tiên lên mạng xã hội",
			TriggerCondition: `{"event": "publish.completed", "count": 1}`,
			RewardCredits:    10,
			Category:         "milestone",
			Active:           true,
			SortOrder:        5,
		},
		{
			AchievementID:    "ach-viral-10k",
			Code:             "viral_clip_10k",
			Title:            "Tác Phẩm Triệu View",
			Description:      "Đạt 10.000 lượt tương tác hoặc hiển thị trên clip",
			TriggerCondition: `{"event": "clip.viral.10k", "count": 1}`,
			RewardCredits:    25,
			Category:         "content",
			Active:           true,
			SortOrder:        6,
		},
	}
	now := time.Now().UTC()
	for _, d := range defs {
		d.CreatedAt = now
		d.UpdatedAt = now
		m.definitions[d.Code] = d
	}
}

func (m *MemStore) GetProgress(ctx context.Context, workspaceID, userID string) (*CreatorProgress, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	key := fmt.Sprintf("%s:%s", workspaceID, userID)
	p, ok := m.progress[key]
	if !ok {
		return nil, ErrNotFound
	}
	cp := *p
	return &cp, nil
}

func (m *MemStore) UpsertProgress(ctx context.Context, progress *CreatorProgress) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	key := fmt.Sprintf("%s:%s", progress.WorkspaceID, progress.UserID)
	cp := *progress
	cp.UpdatedAt = time.Now().UTC()
	m.progress[key] = &cp
	return nil
}

func (m *MemStore) ListProgressByWorkspace(ctx context.Context, workspaceID string, limit int) ([]*CreatorProgress, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	var res []*CreatorProgress
	for _, p := range m.progress {
		if p.WorkspaceID == workspaceID {
			cp := *p
			res = append(res, &cp)
		}
	}
	sort.Slice(res, func(i, j int) bool {
		if res[i].XP != res[j].XP {
			return res[i].XP > res[j].XP
		}
		return res[i].CreatorScore > res[j].CreatorScore
	})
	if limit > 0 && len(res) > limit {
		res = res[:limit]
	}
	return res, nil
}

func (m *MemStore) GetAchievementDefinition(ctx context.Context, code string) (*AchievementDefinition, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	d, ok := m.definitions[code]
	if !ok {
		return nil, ErrNotFound
	}
	cd := *d
	return &cd, nil
}

func (m *MemStore) ListAchievementDefinitions(ctx context.Context, category string, activeOnly bool) ([]*AchievementDefinition, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	var res []*AchievementDefinition
	for _, d := range m.definitions {
		if activeOnly && !d.Active {
			continue
		}
		if category != "" && d.Category != category {
			continue
		}
		cd := *d
		res = append(res, &cd)
	}
	sort.Slice(res, func(i, j int) bool {
		return res[i].SortOrder < res[j].SortOrder
	})
	return res, nil
}

func (m *MemStore) GetAchievementRecord(ctx context.Context, workspaceID, userID, achievementID string) (*AchievementRecord, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	key := fmt.Sprintf("%s:%s:%s", workspaceID, userID, achievementID)
	r, ok := m.records[key]
	if !ok {
		return nil, ErrNotFound
	}
	cr := *r
	return &cr, nil
}

func (m *MemStore) CreateAchievementRecord(ctx context.Context, record *AchievementRecord) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	key := fmt.Sprintf("%s:%s:%s", record.WorkspaceID, record.UserID, record.AchievementID)
	if _, exists := m.records[key]; exists {
		return ErrAlreadyExists
	}
	cr := *record
	m.records[key] = &cr
	return nil
}

func (m *MemStore) ListAchievementRecords(ctx context.Context, workspaceID, userID string) ([]*AchievementRecord, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	var res []*AchievementRecord
	for _, r := range m.records {
		if r.WorkspaceID == workspaceID && r.UserID == userID {
			cr := *r
			res = append(res, &cr)
		}
	}
	return res, nil
}

func (m *MemStore) GetChallenge(ctx context.Context, challengeID string) (*ChallengeDefinition, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	c, ok := m.challenges[challengeID]
	if !ok {
		return nil, ErrNotFound
	}
	cc := *c
	return &cc, nil
}

func (m *MemStore) ListChallenges(ctx context.Context, status string) ([]*ChallengeDefinition, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	var res []*ChallengeDefinition
	for _, c := range m.challenges {
		if status != "" && c.Status != status {
			continue
		}
		cc := *c
		res = append(res, &cc)
	}
	sort.Slice(res, func(i, j int) bool {
		return res[i].SortOrder < res[j].SortOrder
	})
	return res, nil
}

func (m *MemStore) CreateChallenge(ctx context.Context, challenge *ChallengeDefinition) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	if _, exists := m.challenges[challenge.ChallengeID]; exists {
		return ErrAlreadyExists
	}
	cc := *challenge
	m.challenges[challenge.ChallengeID] = &cc
	return nil
}

func (m *MemStore) UpdateChallengeStatus(ctx context.Context, challengeID, status string) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	c, ok := m.challenges[challengeID]
	if !ok {
		return ErrNotFound
	}
	c.Status = status
	c.IsActive = (status == "active" || status == "enrolling")
	return nil
}

func (m *MemStore) GetChallengeProgress(ctx context.Context, workspaceID, userID, challengeID string) (*ChallengeProgress, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	key := fmt.Sprintf("%s:%s:%s", workspaceID, userID, challengeID)
	cp, ok := m.chalProgress[key]
	if !ok {
		return nil, ErrNotFound
	}
	ccp := *cp
	return &ccp, nil
}

func (m *MemStore) UpsertChallengeProgress(ctx context.Context, cp *ChallengeProgress) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	key := fmt.Sprintf("%s:%s:%s", cp.WorkspaceID, cp.UserID, cp.ChallengeID)
	ccp := *cp
	ccp.UpdatedAt = time.Now().UTC()
	m.chalProgress[key] = &ccp
	return nil
}

func (m *MemStore) ListChallengeProgressByUser(ctx context.Context, workspaceID, userID string) ([]*ChallengeProgress, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	var res []*ChallengeProgress
	for _, cp := range m.chalProgress {
		if cp.WorkspaceID == workspaceID && cp.UserID == userID {
			ccp := *cp
			res = append(res, &ccp)
		}
	}
	return res, nil
}

func (m *MemStore) CountChallengeParticipants(ctx context.Context, challengeID string) (int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	count := 0
	for _, cp := range m.chalProgress {
		if cp.ChallengeID == challengeID {
			count++
		}
	}
	return count, nil
}

func (m *MemStore) GetRewardEvent(ctx context.Context, workspaceID, userID, eventKey string) (*RewardEvent, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	key := fmt.Sprintf("%s:%s:%s", workspaceID, userID, eventKey)
	e, ok := m.rewardEvents[key]
	if !ok {
		return nil, ErrNotFound
	}
	ce := *e
	return &ce, nil
}

func (m *MemStore) CreateRewardEvent(ctx context.Context, event *RewardEvent) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	key := fmt.Sprintf("%s:%s:%s", event.WorkspaceID, event.UserID, event.EventKey)
	if _, exists := m.rewardEvents[key]; exists {
		return ErrAlreadyExists
	}
	ce := *event
	m.rewardEvents[key] = &ce
	return nil
}

// PgStore implements Store using real PostgreSQL tenant connections.
type PgStore struct {
	pool *pgxpool.Pool
}

func NewPgStore(pool *pgxpool.Pool) *PgStore {
	return &PgStore{pool: pool}
}

func (p *PgStore) GetProgress(ctx context.Context, workspaceID, userID string) (*CreatorProgress, error) {
	row := p.pool.QueryRow(ctx, `
		SELECT progress_id, workspace_id, user_id, level, xp, xp_to_next_level, streak_days,
		       COALESCE(streak_last_activity_date::text, ''), streak_grace_until, creator_score,
		       total_achievements, COALESCE(season_id, ''), created_at, updated_at
		FROM creator_progress
		WHERE workspace_id = $1 AND user_id = $2
	`, workspaceID, userID)

	var prog CreatorProgress
	err := row.Scan(
		&prog.ProgressID, &prog.WorkspaceID, &prog.UserID, &prog.Level, &prog.XP, &prog.XPToNextLevel,
		&prog.StreakDays, &prog.StreakLastActivityDate, &prog.StreakGraceUntil, &prog.CreatorScore,
		&prog.TotalAchievements, &prog.SeasonID, &prog.CreatedAt, &prog.UpdatedAt,
	)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	return &prog, err
}

func (p *PgStore) UpsertProgress(ctx context.Context, prog *CreatorProgress) error {
	_, err := p.pool.Exec(ctx, `
		INSERT INTO creator_progress (
			progress_id, workspace_id, user_id, level, xp, xp_to_next_level,
			streak_days, streak_last_activity_date, streak_grace_until, creator_score,
			total_achievements, season_id, created_at, updated_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7, NULLIF($8, '')::date, $9, $10, $11, NULLIF($12, ''), $13, $14)
		ON CONFLICT (workspace_id, user_id) DO UPDATE SET
			level = EXCLUDED.level,
			xp = EXCLUDED.xp,
			xp_to_next_level = EXCLUDED.xp_to_next_level,
			streak_days = EXCLUDED.streak_days,
			streak_last_activity_date = EXCLUDED.streak_last_activity_date,
			streak_grace_until = EXCLUDED.streak_grace_until,
			creator_score = EXCLUDED.creator_score,
			total_achievements = EXCLUDED.total_achievements,
			season_id = EXCLUDED.season_id,
			updated_at = EXCLUDED.updated_at
	`, prog.ProgressID, prog.WorkspaceID, prog.UserID, prog.Level, prog.XP, prog.XPToNextLevel,
		prog.StreakDays, prog.StreakLastActivityDate, prog.StreakGraceUntil, prog.CreatorScore,
		prog.TotalAchievements, prog.SeasonID, prog.CreatedAt, prog.UpdatedAt)
	return err
}

func (p *PgStore) ListProgressByWorkspace(ctx context.Context, workspaceID string, limit int) ([]*CreatorProgress, error) {
	if limit <= 0 {
		limit = 50
	}
	rows, err := p.pool.Query(ctx, `
		SELECT progress_id, workspace_id, user_id, level, xp, xp_to_next_level, streak_days,
		       COALESCE(streak_last_activity_date::text, ''), streak_grace_until, creator_score,
		       total_achievements, COALESCE(season_id, ''), created_at, updated_at
		FROM creator_progress
		WHERE workspace_id = $1
		ORDER BY xp DESC, creator_score DESC
		LIMIT $2
	`, workspaceID, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []*CreatorProgress
	for rows.Next() {
		var prog CreatorProgress
		if err := rows.Scan(
			&prog.ProgressID, &prog.WorkspaceID, &prog.UserID, &prog.Level, &prog.XP, &prog.XPToNextLevel,
			&prog.StreakDays, &prog.StreakLastActivityDate, &prog.StreakGraceUntil, &prog.CreatorScore,
			&prog.TotalAchievements, &prog.SeasonID, &prog.CreatedAt, &prog.UpdatedAt,
		); err != nil {
			return nil, err
		}
		list = append(list, &prog)
	}
	return list, rows.Err()
}

func (p *PgStore) GetAchievementDefinition(ctx context.Context, code string) (*AchievementDefinition, error) {
	row := p.pool.QueryRow(ctx, `
		SELECT achievement_id, code, title, COALESCE(description, ''), trigger_condition::text,
		       reward_credits, COALESCE(badge_image_url, ''), COALESCE(category, ''), sort_order, active, created_at, updated_at
		FROM achievement_definitions
		WHERE code = $1
	`, code)
	var def AchievementDefinition
	err := row.Scan(&def.AchievementID, &def.Code, &def.Title, &def.Description, &def.TriggerCondition,
		&def.RewardCredits, &def.BadgeImageURL, &def.Category, &def.SortOrder, &def.Active, &def.CreatedAt, &def.UpdatedAt)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	return &def, err
}

func (p *PgStore) ListAchievementDefinitions(ctx context.Context, category string, activeOnly bool) ([]*AchievementDefinition, error) {
	query := `
		SELECT achievement_id, code, title, COALESCE(description, ''), trigger_condition::text,
		       reward_credits, COALESCE(badge_image_url, ''), COALESCE(category, ''), sort_order, active, created_at, updated_at
		FROM achievement_definitions
		WHERE ($1 = '' OR category = $1)
		  AND ($2 = false OR active = true)
		ORDER BY sort_order ASC
	`
	rows, err := p.pool.Query(ctx, query, category, activeOnly)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var defs []*AchievementDefinition
	for rows.Next() {
		var def AchievementDefinition
		if err := rows.Scan(&def.AchievementID, &def.Code, &def.Title, &def.Description, &def.TriggerCondition,
			&def.RewardCredits, &def.BadgeImageURL, &def.Category, &def.SortOrder, &def.Active, &def.CreatedAt, &def.UpdatedAt); err != nil {
			return nil, err
		}
		defs = append(defs, &def)
	}
	return defs, rows.Err()
}

func (p *PgStore) GetAchievementRecord(ctx context.Context, workspaceID, userID, achievementID string) (*AchievementRecord, error) {
	row := p.pool.QueryRow(ctx, `
		SELECT record_id, workspace_id, user_id, achievement_id, earned_at, credits_awarded
		FROM achievement_records
		WHERE workspace_id = $1 AND user_id = $2 AND achievement_id = $3
	`, workspaceID, userID, achievementID)
	var rec AchievementRecord
	var creditsStr string
	err := row.Scan(&rec.RecordID, &rec.WorkspaceID, &rec.UserID, &rec.AchievementID, &rec.EarnedAt, &creditsStr)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	dec, _ := tenantdb.ParseExactDecimal(creditsStr)
	rec.CreditsAwarded = dec
	return &rec, err
}

func (p *PgStore) CreateAchievementRecord(ctx context.Context, record *AchievementRecord) error {
	_, err := p.pool.Exec(ctx, `
		INSERT INTO achievement_records (record_id, workspace_id, user_id, achievement_id, earned_at, credits_awarded)
		VALUES ($1, $2, $3, $4, $5, $6::numeric)
	`, record.RecordID, record.WorkspaceID, record.UserID, record.AchievementID, record.EarnedAt, record.CreditsAwarded.Fixed6String())
	return err
}

func (p *PgStore) ListAchievementRecords(ctx context.Context, workspaceID, userID string) ([]*AchievementRecord, error) {
	rows, err := p.pool.Query(ctx, `
		SELECT record_id, workspace_id, user_id, achievement_id, earned_at, credits_awarded
		FROM achievement_records
		WHERE workspace_id = $1 AND user_id = $2
	`, workspaceID, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var records []*AchievementRecord
	for rows.Next() {
		var rec AchievementRecord
		var creditsStr string
		if err := rows.Scan(&rec.RecordID, &rec.WorkspaceID, &rec.UserID, &rec.AchievementID, &rec.EarnedAt, &creditsStr); err != nil {
			return nil, err
		}
		dec, _ := tenantdb.ParseExactDecimal(creditsStr)
		rec.CreditsAwarded = dec
		records = append(records, &rec)
	}
	return records, rows.Err()
}

func (p *PgStore) GetChallenge(ctx context.Context, challengeID string) (*ChallengeDefinition, error) {
	row := p.pool.QueryRow(ctx, `
		SELECT challenge_id, title, COALESCE(description, ''), challenge_type, target_value, reward_credits,
		       start_date::text, end_date::text, status, is_active, sort_order, created_at
		FROM challenge_definitions
		WHERE challenge_id = $1
	`, challengeID)
	var c ChallengeDefinition
	err := row.Scan(&c.ChallengeID, &c.Title, &c.Description, &c.ChallengeType, &c.TargetValue, &c.RewardCredits,
		&c.StartDate, &c.EndDate, &c.Status, &c.IsActive, &c.SortOrder, &c.CreatedAt)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	return &c, err
}

func (p *PgStore) ListChallenges(ctx context.Context, status string) ([]*ChallengeDefinition, error) {
	rows, err := p.pool.Query(ctx, `
		SELECT challenge_id, title, COALESCE(description, ''), challenge_type, target_value, reward_credits,
		       start_date::text, end_date::text, status, is_active, sort_order, created_at
		FROM challenge_definitions
		WHERE ($1 = '' OR status = $1)
		ORDER BY sort_order ASC, start_date ASC
	`, status)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []*ChallengeDefinition
	for rows.Next() {
		var c ChallengeDefinition
		if err := rows.Scan(&c.ChallengeID, &c.Title, &c.Description, &c.ChallengeType, &c.TargetValue, &c.RewardCredits,
			&c.StartDate, &c.EndDate, &c.Status, &c.IsActive, &c.SortOrder, &c.CreatedAt); err != nil {
			return nil, err
		}
		list = append(list, &c)
	}
	return list, rows.Err()
}

func (p *PgStore) CreateChallenge(ctx context.Context, c *ChallengeDefinition) error {
	_, err := p.pool.Exec(ctx, `
		INSERT INTO challenge_definitions (
			challenge_id, title, description, challenge_type, target_value, reward_credits,
			start_date, end_date, status, is_active, sort_order, created_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7::date, $8::date, $9, $10, $11, $12)
	`, c.ChallengeID, c.Title, c.Description, c.ChallengeType, c.TargetValue, c.RewardCredits,
		c.StartDate, c.EndDate, c.Status, c.IsActive, c.SortOrder, c.CreatedAt)
	return err
}

func (p *PgStore) UpdateChallengeStatus(ctx context.Context, challengeID, status string) error {
	isActive := (status == "active" || status == "enrolling")
	_, err := p.pool.Exec(ctx, `
		UPDATE challenge_definitions
		SET status = $2, is_active = $3
		WHERE challenge_id = $1
	`, challengeID, status, isActive)
	return err
}

func (p *PgStore) GetChallengeProgress(ctx context.Context, workspaceID, userID, challengeID string) (*ChallengeProgress, error) {
	row := p.pool.QueryRow(ctx, `
		SELECT progress_id, workspace_id, user_id, challenge_id, current_value, target_value,
		       completed, completed_at, reward_credited, COALESCE(reward_transaction_id::text, ''),
		       created_at, updated_at
		FROM challenge_progress
		WHERE workspace_id = $1 AND user_id = $2 AND challenge_id = $3
	`, workspaceID, userID, challengeID)
	var cp ChallengeProgress
	err := row.Scan(&cp.ProgressID, &cp.WorkspaceID, &cp.UserID, &cp.ChallengeID, &cp.CurrentValue, &cp.TargetValue,
		&cp.Completed, &cp.CompletedAt, &cp.RewardCredited, &cp.RewardTransactionID, &cp.CreatedAt, &cp.UpdatedAt)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	return &cp, err
}

func (p *PgStore) UpsertChallengeProgress(ctx context.Context, cp *ChallengeProgress) error {
	_, err := p.pool.Exec(ctx, `
		INSERT INTO challenge_progress (
			progress_id, workspace_id, user_id, challenge_id, current_value, target_value,
			completed, completed_at, reward_credited, reward_transaction_id, created_at, updated_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, NULLIF($10, '')::uuid, $11, $12)
		ON CONFLICT (workspace_id, user_id, challenge_id) DO UPDATE SET
			current_value = EXCLUDED.current_value,
			target_value = EXCLUDED.target_value,
			completed = EXCLUDED.completed,
			completed_at = EXCLUDED.completed_at,
			reward_credited = EXCLUDED.reward_credited,
			reward_transaction_id = EXCLUDED.reward_transaction_id,
			updated_at = EXCLUDED.updated_at
	`, cp.ProgressID, cp.WorkspaceID, cp.UserID, cp.ChallengeID, cp.CurrentValue, cp.TargetValue,
		cp.Completed, cp.CompletedAt, cp.RewardCredited, cp.RewardTransactionID, cp.CreatedAt, cp.UpdatedAt)
	return err
}

func (p *PgStore) ListChallengeProgressByUser(ctx context.Context, workspaceID, userID string) ([]*ChallengeProgress, error) {
	rows, err := p.pool.Query(ctx, `
		SELECT progress_id, workspace_id, user_id, challenge_id, current_value, target_value,
		       completed, completed_at, reward_credited, COALESCE(reward_transaction_id::text, ''),
		       created_at, updated_at
		FROM challenge_progress
		WHERE workspace_id = $1 AND user_id = $2
	`, workspaceID, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []*ChallengeProgress
	for rows.Next() {
		var cp ChallengeProgress
		if err := rows.Scan(&cp.ProgressID, &cp.WorkspaceID, &cp.UserID, &cp.ChallengeID, &cp.CurrentValue, &cp.TargetValue,
			&cp.Completed, &cp.CompletedAt, &cp.RewardCredited, &cp.RewardTransactionID, &cp.CreatedAt, &cp.UpdatedAt); err != nil {
			return nil, err
		}
		list = append(list, &cp)
	}
	return list, rows.Err()
}

func (p *PgStore) CountChallengeParticipants(ctx context.Context, challengeID string) (int, error) {
	row := p.pool.QueryRow(ctx, `
		SELECT COUNT(*) FROM challenge_progress WHERE challenge_id = $1
	`, challengeID)
	var count int
	err := row.Scan(&count)
	return count, err
}

func (p *PgStore) GetRewardEvent(ctx context.Context, workspaceID, userID, eventKey string) (*RewardEvent, error) {
	row := p.pool.QueryRow(ctx, `
		SELECT event_id, workspace_id, user_id, event_key, event_type, credits_awarded, xp_awarded,
		       idempotency_key, status, processed_at
		FROM gamification_reward_events
		WHERE workspace_id = $1 AND user_id = $2 AND event_key = $3
	`, workspaceID, userID, eventKey)
	var e RewardEvent
	var creditsStr string
	err := row.Scan(&e.EventID, &e.WorkspaceID, &e.UserID, &e.EventKey, &e.EventType, &creditsStr, &e.XPAwarded,
		&e.IdempotencyKey, &e.Status, &e.ProcessedAt)
	if errors.Is(err, pgx.ErrNoRows) {
		return nil, ErrNotFound
	}
	dec, _ := tenantdb.ParseExactDecimal(creditsStr)
	e.CreditsAwarded = dec
	return &e, err
}

func (p *PgStore) CreateRewardEvent(ctx context.Context, e *RewardEvent) error {
	_, err := p.pool.Exec(ctx, `
		INSERT INTO gamification_reward_events (
			event_id, workspace_id, user_id, event_key, event_type, credits_awarded, xp_awarded,
			idempotency_key, status, processed_at, metadata
		) VALUES ($1, $2, $3, $4, $5, $6::numeric, $7, $8, $9, $10, '{}'::jsonb)
	`, e.EventID, e.WorkspaceID, e.UserID, e.EventKey, e.EventType, e.CreditsAwarded.Fixed6String(), e.XPAwarded,
		e.IdempotencyKey, e.Status, e.ProcessedAt)
	return err
}
