package home

import (
	"fmt"
	"strconv"
	"strings"
	"time"

	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
)

// MorningBriefStatus represents the distinct lifecycle states of a workspace Morning Brief
// per docs/02_features/platform/home_decision_engine.md and docs/05_system/queue_retry_design.md (§7).
const (
	MorningBriefStatusGenerated = "generated"
	MorningBriefStatusDelivered = "delivered"
	MorningBriefStatusFailed    = "failed"
)

// MaxMorningBriefLateness is the maximum window after configured local morning_brief_time
// during which a scheduled run may generate and deliver that local date's brief.
// Missing a run beyond this window must NOT resend a stale brief (queue_retry_design.md §7).
const MaxMorningBriefLateness = 15 * time.Minute

// HomeDashboardConfig models the workspace-level configuration table home_dashboard_config (§22.14)
// joined with workspaces.timezone.
type HomeDashboardConfig struct {
	ConfigID             string
	WorkspaceID          string
	OperatorMode         adminv1.OperatorModeId
	Timezone             string   // IANA timezone, e.g. "Asia/Ho_Chi_Minh", "America/New_York"
	MorningBriefEnabled  bool     // default true
	MorningBriefTime     string   // local HH:MM, default "07:00"
	MorningBriefChannels []string // default ["push", "email"]
	UpdatedAt            time.Time
}

// DefaultHomeDashboardConfig returns the canonical default configuration for a workspace.
func DefaultHomeDashboardConfig(workspaceID string) HomeDashboardConfig {
	return HomeDashboardConfig{
		ConfigID:             "hdc_" + workspaceID,
		WorkspaceID:          workspaceID,
		OperatorMode:         adminv1.OperatorModeId_OPERATOR_MODE_ID_CREATOR,
		Timezone:             "Asia/Ho_Chi_Minh",
		MorningBriefEnabled:  true,
		MorningBriefTime:     "07:00",
		MorningBriefChannels: []string{"push", "email"},
	}
}

// MorningBriefItem represents one of the up-to-5 items in a Morning Brief
// (top 3 actions + 1 opportunity + 1 metric highlight).
type MorningBriefItem struct {
	Kind       string // "action", "opportunity", "metric_highlight"
	Title      string
	Summary    string
	Route      string
	Source     adminv1.DataSourceBadge
	Confidence adminv1.ConfidenceLevel
}

// MorningBriefAuditEntry records each generation/delivery attempt or retry for auditability.
type MorningBriefAuditEntry struct {
	AttemptNumber int
	Outcome       string // "generated", "delivered", "failed", "duplicate_suppressed", "skipped_stale"
	Reason        string
	LocalDate     string
	Timezone      string
	RecordedAt    time.Time
}

// MorningBriefDeliveryRecord tracks the unique (workspace_id, local_date) Morning Brief state.
// Unique identity: DeliveryKey = morning_brief:<workspace_id>:<YYYY-MM-DD>.
type MorningBriefDeliveryRecord struct {
	DeliveryKey  string
	WorkspaceID  string
	LocalDate    string // YYYY-MM-DD in workspace local timezone at generation time
	Timezone     string
	ConfiguredAt string // HH:MM
	Status       string // "generated", "delivered", "failed"
	Headline     string
	Items        []MorningBriefItem
	Channels     []string
	GeneratedAt  *time.Time
	DeliveredAt  *time.Time
	FailedAt     *time.Time
	FailureError string
	RetryCount   int
	AuditTrail   []MorningBriefAuditEntry
}

// MorningBriefEvalInput provides optional failure injection or explicit retry flags for testing and worker execution.
type MorningBriefEvalInput struct {
	WorkspaceID          string
	NowUTC               time.Time
	ForceGenerationError error
	ForceDeliveryError   error
	IsExplicitRetry      bool
}

// MorningBriefEvalResult reports the outcome of evaluating a workspace's Morning Brief schedule at NowUTC.
type MorningBriefEvalResult struct {
	Decision                     string // "delivered", "failed", "already_delivered_local_date", "already_failed_no_stale_resend", "not_yet_due", "skipped_stale_window", "disabled", "ineligible_no_authorized_data"
	AlreadyProcessedForLocalDate bool
	LocalDate                    string
	LocalTimeHHMM                string
	Record                       *MorningBriefDeliveryRecord
}

func parseBriefTimeHHMM(hhmm string) (int, int, error) {
	trimmed := strings.TrimSpace(hhmm)
	if trimmed == "" {
		return 7, 0, nil
	}
	parts := strings.Split(trimmed, ":")
	if len(parts) < 2 || len(parts) > 3 {
		return 0, 0, fmt.Errorf("%w: invalid morning_brief_time %q (expected HH:MM)", ErrInvalidInput, hhmm)
	}
	hour, err := strconv.Atoi(parts[0])
	if err != nil || hour < 0 || hour > 23 {
		return 0, 0, fmt.Errorf("%w: invalid hour in morning_brief_time %q", ErrInvalidInput, hhmm)
	}
	min, err := strconv.Atoi(parts[1])
	if err != nil || min < 0 || min > 59 {
		return 0, 0, fmt.Errorf("%w: invalid minute in morning_brief_time %q", ErrInvalidInput, hhmm)
	}
	return hour, min, nil
}

// ConfigureWorkspaceDashboard sets or updates a workspace's HomeDashboardConfig (including IANA timezone and local morning_brief_time).
func (s *Service) ConfigureWorkspaceDashboard(cfg HomeDashboardConfig) (HomeDashboardConfig, error) {
	if strings.TrimSpace(cfg.WorkspaceID) == "" {
		return HomeDashboardConfig{}, ErrInvalidInput
	}
	if strings.TrimSpace(cfg.Timezone) == "" {
		cfg.Timezone = "Asia/Ho_Chi_Minh"
	}
	if _, err := time.LoadLocation(cfg.Timezone); err != nil {
		return HomeDashboardConfig{}, fmt.Errorf("%w: invalid IANA timezone %q: %v", ErrInvalidInput, cfg.Timezone, err)
	}
	if strings.TrimSpace(cfg.MorningBriefTime) == "" {
		cfg.MorningBriefTime = "07:00"
	}
	h, m, err := parseBriefTimeHHMM(cfg.MorningBriefTime)
	if err != nil {
		return HomeDashboardConfig{}, err
	}
	cfg.MorningBriefTime = fmt.Sprintf("%02d:%02d", h, m)
	if len(cfg.MorningBriefChannels) == 0 {
		cfg.MorningBriefChannels = []string{"push", "email"}
	}
	if cfg.OperatorMode == adminv1.OperatorModeId_OPERATOR_MODE_ID_UNSPECIFIED {
		cfg.OperatorMode = adminv1.OperatorModeId_OPERATOR_MODE_ID_CREATOR
	}
	if cfg.ConfigID == "" {
		cfg.ConfigID = "hdc_" + cfg.WorkspaceID
	}
	cfg.UpdatedAt = time.Now().UTC()

	s.mu.Lock()
	defer s.mu.Unlock()
	s.configs[cfg.WorkspaceID] = cfg
	return cfg, nil
}

// GetWorkspaceDashboardConfig returns the current HomeDashboardConfig for a workspace.
func (s *Service) GetWorkspaceDashboardConfig(workspaceID string) HomeDashboardConfig {
	s.mu.RLock()
	defer s.mu.RUnlock()
	if cfg, ok := s.configs[workspaceID]; ok {
		return cfg
	}
	return DefaultHomeDashboardConfig(workspaceID)
}

// hasAuthorizedEligibleDataLocked reports whether the workspace has either connected accounts
// OR authorized imported/manual data (products, orders, settlements, cost items, or non-demo metrics).
// Demo fixtures NEVER make a workspace eligible for Morning Brief delivery.
func (s *Service) hasAuthorizedEligibleDataLocked(workspaceID string) bool {
	if st, ok := s.imports[workspaceID]; ok {
		if st.ConnectedAccountsCount > 0 || st.AuthorizedProductsCount > 0 || st.AuthorizedOrdersCount > 0 || st.AuthorizedCostsCount > 0 || st.AuthorizedSettlementsCount > 0 {
			return true
		}
	}
	for _, m := range s.metrics[workspaceID] {
		if !m.IsDemoFixture && m.DataSource != adminv1.DataSourceBadge_DATA_SOURCE_BADGE_DEMO {
			return true
		}
	}
	return false
}

// EvaluateAndDeliverMorningBrief evaluates the workspace's configured local morning_brief_time
// in its IANA timezone and generates/delivers at most one Morning Brief per (workspace_id, local_date).
//
// Enforces P1-05 Acceptance Target #2 ("DST/timezone cannot double-deliver brief"):
//   - Unique delivery identity per (workspace_id, local_date) ("YYYY-MM-DD").
//   - Timezone changes or DST fall-back / spring-forward transitions cannot deliver twice for one local date.
//   - Missing a run beyond MaxMorningBriefLateness does not resend a stale brief.
//   - Keeps generated, delivered, and failed outcomes separate and audits retries.
//   - Workspaces with authorized imported/manual data (even with 0 connected accounts) are eligible.
func (s *Service) EvaluateAndDeliverMorningBrief(in MorningBriefEvalInput) (MorningBriefEvalResult, error) {
	wsID := strings.TrimSpace(in.WorkspaceID)
	if wsID == "" {
		return MorningBriefEvalResult{}, ErrInvalidInput
	}
	nowUTC := in.NowUTC
	if nowUTC.IsZero() {
		nowUTC = time.Now().UTC()
	} else {
		nowUTC = nowUTC.UTC()
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	cfg, ok := s.configs[wsID]
	if !ok {
		cfg = DefaultHomeDashboardConfig(wsID)
	}
	loc, err := time.LoadLocation(cfg.Timezone)
	if err != nil {
		return MorningBriefEvalResult{}, fmt.Errorf("%w: invalid workspace timezone %q: %v", ErrInvalidInput, cfg.Timezone, err)
	}

	localNow := nowUTC.In(loc)
	localDate := localNow.Format("2006-01-02")
	localHHMM := localNow.Format("15:04")
	deliveryKey := fmt.Sprintf("morning_brief:%s:%s", wsID, localDate)

	if !cfg.MorningBriefEnabled {
		return MorningBriefEvalResult{
			Decision:      "disabled",
			LocalDate:     localDate,
			LocalTimeHHMM: localHHMM,
		}, nil
	}

	// Check if a record for (workspace_id, local_date) already exists.
	// This guarantees that DST fall-back (repeated local hour) or a workspace timezone change
	// on the same local calendar date can NEVER double-deliver a brief.
	if existing, exists := s.briefDeliveries[deliveryKey]; exists {
		if existing.Status == MorningBriefStatusDelivered {
			existing.AuditTrail = append(existing.AuditTrail, MorningBriefAuditEntry{
				AttemptNumber: existing.RetryCount + 1,
				Outcome:       "duplicate_suppressed",
				Reason:        "brief already delivered for workspace local_date; DST/timezone duplicate suppressed",
				LocalDate:     localDate,
				Timezone:      cfg.Timezone,
				RecordedAt:    nowUTC,
			})
			recCopy := *existing
			return MorningBriefEvalResult{
				Decision:                     "already_delivered_local_date",
				AlreadyProcessedForLocalDate: true,
				LocalDate:                    localDate,
				LocalTimeHHMM:                localHHMM,
				Record:                       &recCopy,
			}, nil
		}

		// If previous run failed and this is NOT an explicit retry within the freshness window,
		// do not automatically resend a stale brief on later cron ticks.
		if existing.Status == MorningBriefStatusFailed && !in.IsExplicitRetry {
			existing.AuditTrail = append(existing.AuditTrail, MorningBriefAuditEntry{
				AttemptNumber: existing.RetryCount + 1,
				Outcome:       "skipped_stale",
				Reason:        "prior generation/delivery failed; automatic cron tick does not resend stale brief",
				LocalDate:     localDate,
				Timezone:      cfg.Timezone,
				RecordedAt:    nowUTC,
			})
			recCopy := *existing
			return MorningBriefEvalResult{
				Decision:                     "already_failed_no_stale_resend",
				AlreadyProcessedForLocalDate: true,
				LocalDate:                    localDate,
				LocalTimeHHMM:                localHHMM,
				Record:                       &recCopy,
			}, nil
		}
	}

	if !s.hasAuthorizedEligibleDataLocked(wsID) {
		return MorningBriefEvalResult{
			Decision:      "ineligible_no_authorized_data",
			LocalDate:     localDate,
			LocalTimeHHMM: localHHMM,
		}, nil
	}

	cfgHour, cfgMin, err := parseBriefTimeHHMM(cfg.MorningBriefTime)
	if err != nil {
		return MorningBriefEvalResult{}, err
	}

	// Compute elapsed local minutes since configured HH:MM on the current local calendar date.
	nowMinutes := localNow.Hour()*60 + localNow.Minute()
	targetMinutes := cfgHour*60 + cfgMin
	diffMinutes := nowMinutes - targetMinutes

	if diffMinutes < 0 {
		return MorningBriefEvalResult{
			Decision:      "not_yet_due",
			LocalDate:     localDate,
			LocalTimeHHMM: localHHMM,
		}, nil
	}
	if time.Duration(diffMinutes)*time.Minute > MaxMorningBriefLateness {
		return MorningBriefEvalResult{
			Decision:      "skipped_stale_window",
			LocalDate:     localDate,
			LocalTimeHHMM: localHHMM,
		}, nil
	}

	// Initialize or update the record for (workspace_id, local_date).
	rec, exists := s.briefDeliveries[deliveryKey]
	if !exists {
		rec = &MorningBriefDeliveryRecord{
			DeliveryKey:  deliveryKey,
			WorkspaceID:  wsID,
			LocalDate:    localDate,
			Timezone:     cfg.Timezone,
			ConfiguredAt: cfg.MorningBriefTime,
			Channels:     append([]string{}, cfg.MorningBriefChannels...),
		}
		s.briefDeliveries[deliveryKey] = rec
	} else {
		rec.RetryCount++
		rec.Timezone = cfg.Timezone
	}
	attemptNum := rec.RetryCount + 1

	// Step 1: Generation phase.
	if in.ForceGenerationError != nil {
		failedAt := nowUTC
		rec.Status = MorningBriefStatusFailed
		rec.FailedAt = &failedAt
		rec.FailureError = in.ForceGenerationError.Error()
		rec.AuditTrail = append(rec.AuditTrail, MorningBriefAuditEntry{
			AttemptNumber: attemptNum,
			Outcome:       MorningBriefStatusFailed,
			Reason:        "generation_failed: " + in.ForceGenerationError.Error(),
			LocalDate:     localDate,
			Timezone:      cfg.Timezone,
			RecordedAt:    nowUTC,
		})
		recCopy := *rec
		return MorningBriefEvalResult{
			Decision:      MorningBriefStatusFailed,
			LocalDate:     localDate,
			LocalTimeHHMM: localHHMM,
			Record:        &recCopy,
		}, nil
	}

	genAt := nowUTC
	rec.Status = MorningBriefStatusGenerated
	rec.GeneratedAt = &genAt
	rec.Headline = s.getMorningBriefHeadline(cfg.OperatorMode)
	rec.Items = s.buildMorningBriefItemsLocked(wsID, cfg.OperatorMode)
	rec.AuditTrail = append(rec.AuditTrail, MorningBriefAuditEntry{
		AttemptNumber: attemptNum,
		Outcome:       MorningBriefStatusGenerated,
		Reason:        "morning brief generated from authorized workspace state",
		LocalDate:     localDate,
		Timezone:      cfg.Timezone,
		RecordedAt:    nowUTC,
	})

	// Step 2: Delivery phase (kept distinct from generation outcome).
	if in.ForceDeliveryError != nil {
		failedAt := nowUTC
		rec.Status = MorningBriefStatusFailed
		rec.FailedAt = &failedAt
		rec.FailureError = in.ForceDeliveryError.Error()
		rec.AuditTrail = append(rec.AuditTrail, MorningBriefAuditEntry{
			AttemptNumber: attemptNum,
			Outcome:       MorningBriefStatusFailed,
			Reason:        "delivery_failed_after_generation: " + in.ForceDeliveryError.Error(),
			LocalDate:     localDate,
			Timezone:      cfg.Timezone,
			RecordedAt:    nowUTC,
		})
		recCopy := *rec
		return MorningBriefEvalResult{
			Decision:      MorningBriefStatusFailed,
			LocalDate:     localDate,
			LocalTimeHHMM: localHHMM,
			Record:        &recCopy,
		}, nil
	}

	delivAt := nowUTC
	rec.Status = MorningBriefStatusDelivered
	rec.DeliveredAt = &delivAt
	rec.FailedAt = nil
	rec.FailureError = ""
	rec.AuditTrail = append(rec.AuditTrail, MorningBriefAuditEntry{
		AttemptNumber: attemptNum,
		Outcome:       MorningBriefStatusDelivered,
		Reason:        "morning brief delivered once for local_date",
		LocalDate:     localDate,
		Timezone:      cfg.Timezone,
		RecordedAt:    nowUTC,
	})

	recCopy := *rec
	return MorningBriefEvalResult{
		Decision:                     MorningBriefStatusDelivered,
		AlreadyProcessedForLocalDate: false,
		LocalDate:                    localDate,
		LocalTimeHHMM:                localHHMM,
		Record:                       &recCopy,
	}, nil
}

func (s *Service) buildMorningBriefItemsLocked(workspaceID string, mode adminv1.OperatorModeId) []MorningBriefItem {
	var items []MorningBriefItem
	cards := s.buildWorkspaceDecisionCardsLocked(workspaceID, mode)
	actionCount := 0
	for _, c := range cards {
		if actionCount >= 3 {
			break
		}
		items = append(items, MorningBriefItem{
			Kind:       "action",
			Title:      c.Title,
			Summary:    c.Description,
			Route:      c.PrimaryCtaRoute,
			Source:     c.DataSource,
			Confidence: c.Confidence,
		})
		actionCount++
	}
	items = append(items, MorningBriefItem{
		Kind:       "opportunity",
		Title:      "Tối ưu biên lợi nhuận danh mục P1",
		Summary:    "Kiểm tra các SKU có tỷ lệ hoàn hàng hoặc thiếu giá vốn cần bổ sung chứng từ.",
		Route:      "/kinh-doanh",
		Source:     adminv1.DataSourceBadge_DATA_SOURCE_BADGE_IMPORTED,
		Confidence: adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_MEDIUM,
	})
	revFormatted, revBadge := s.computeCustomerVerifiedTotalRevenueLocked(workspaceID)
	items = append(items, MorningBriefItem{
		Kind:       "metric_highlight",
		Title:      "Doanh thu xác thực: " + revFormatted,
		Summary:    "Tổng hợp từ dữ liệu nhập hợp lệ / kết nối chính thức (không bao gồm dữ liệu demo).",
		Route:      "/kinh-doanh",
		Source:     revBadge,
		Confidence: adminv1.ConfidenceLevel_CONFIDENCE_LEVEL_HIGH,
	})
	if len(items) > 5 {
		items = items[:5]
	}
	return items
}
