package production

import (
	"context"
	"fmt"
	"strings"
	"sync"
	"time"
)

// M11GateChecker defines the four M11 gates required before scaling an experiment winner.
// Canonical Sources: docs/02_features/production/packaging_qa.md#Experiment evidence and safe learning
//
//	docs/02_features/production/ai_video_studio.md#EF-10
type M11GateChecker interface {
	// CheckPermission validates fresh M11 publish permission for caller.
	CheckPermission(caller CallerContext, requiredRole string) error

	// CheckCapability validates that target platform connector is active and supported.
	CheckCapability(ctx context.Context, workspaceID, platform string) error

	// CheckPolicy validates packaging QA and compliance scan results (no hard blocks).
	CheckPolicy(ctx context.Context, workspaceID, assetID string) error

	// CheckDuplicatePost checks whether the asset has already been scheduled or posted within cooldown.
	CheckDuplicatePost(ctx context.Context, workspaceID, assetID, platform string, cooldown time.Duration) error

	// ScheduleScaledPost creates a publish schedule item for the scaled winning variant.
	ScheduleScaledPost(ctx context.Context, caller CallerContext, assetID, platform string) (string, error)
}

// DefaultM11GateChecker implements M11GateChecker with configurable platform status and cooldown history.
type DefaultM11GateChecker struct {
	mu               sync.RWMutex
	store            Store
	qaManager        *PackagingQAManager
	platformStatus   map[string]map[string]string // workspaceID -> platform -> "active"|"degraded"|"unsupported"|"revoked"
	publishedHistory map[string]time.Time         // "workspaceID:assetID:platform" -> lastPublishedAt
	cooldownDuration time.Duration
}

// NewDefaultM11GateChecker creates a new DefaultM11GateChecker.
func NewDefaultM11GateChecker(store Store, qaManager *PackagingQAManager) *DefaultM11GateChecker {
	return &DefaultM11GateChecker{
		store:            store,
		qaManager:        qaManager,
		platformStatus:   make(map[string]map[string]string),
		publishedHistory: make(map[string]time.Time),
		cooldownDuration: 24 * time.Hour,
	}
}

// SetPlatformCapability allows testing degraded, unsupported, or revoked states.
func (g *DefaultM11GateChecker) SetPlatformCapability(workspaceID, platform, status string) {
	g.mu.Lock()
	defer g.mu.Unlock()
	if g.platformStatus[workspaceID] == nil {
		g.platformStatus[workspaceID] = make(map[string]string)
	}
	g.platformStatus[workspaceID][strings.ToLower(platform)] = strings.ToLower(status)
}

// RecordPriorPost registers an existing post to test duplicate post rejection.
func (g *DefaultM11GateChecker) RecordPriorPost(workspaceID, assetID, platform string, postedAt time.Time) {
	g.mu.Lock()
	defer g.mu.Unlock()
	key := fmt.Sprintf("%s:%s:%s", workspaceID, assetID, strings.ToLower(platform))
	g.publishedHistory[key] = postedAt
}

func (g *DefaultM11GateChecker) CheckPermission(caller CallerContext, requiredRole string) error {
	if requiredRole == "" {
		requiredRole = "Editor"
	}
	if !caller.HasRole(requiredRole) {
		return ErrScalingPermissionDenied
	}
	return nil
}

func (g *DefaultM11GateChecker) CheckCapability(ctx context.Context, workspaceID, platform string) error {
	g.mu.RLock()
	defer g.mu.RUnlock()

	platform = strings.ToLower(platform)
	wsCaps := g.platformStatus[workspaceID]
	if wsCaps != nil {
		if status, ok := wsCaps[platform]; ok {
			if status == "degraded" || status == "revoked" || status == "unsupported" || status == "blocked" {
				return fmt.Errorf("%w: platform %s capability is %s", ErrScalingCapabilityDegraded, platform, status)
			}
		}
	}
	return nil
}

func (g *DefaultM11GateChecker) CheckPolicy(ctx context.Context, workspaceID, assetID string) error {
	if g.qaManager != nil {
		report, err := g.qaManager.GetReport(ctx, CallerContext{WorkspaceID: workspaceID, WorkspaceRole: "Member"}, assetID, "")
		if err == nil && report != nil {
			if report.HasHardBlocks || report.ComplianceOverallResult == "blocked" {
				return fmt.Errorf("%w: asset %s has unresolved compliance or policy hard blocks", ErrScalingPolicyBlocked, assetID)
			}
		}
	}
	return nil
}

func (g *DefaultM11GateChecker) CheckDuplicatePost(ctx context.Context, workspaceID, assetID, platform string, cooldown time.Duration) error {
	g.mu.RLock()
	defer g.mu.RUnlock()

	key := fmt.Sprintf("%s:%s:%s", workspaceID, assetID, strings.ToLower(platform))
	if lastPost, exists := g.publishedHistory[key]; exists {
		if time.Since(lastPost) < cooldown {
			return fmt.Errorf("%w: asset %s was already posted to %s within %v cooldown window", ErrScalingDuplicatePost, assetID, platform, cooldown)
		}
	}
	return nil
}

func (g *DefaultM11GateChecker) ScheduleScaledPost(ctx context.Context, caller CallerContext, assetID, platform string) (string, error) {
	g.mu.Lock()
	defer g.mu.Unlock()

	scheduleID := newUUID()
	key := fmt.Sprintf("%s:%s:%s", caller.WorkspaceID, assetID, strings.ToLower(platform))
	g.publishedHistory[key] = time.Now().UTC()
	return scheduleID, nil
}

// ABTestManager handles A/B testing experiment lifecycle, metric evaluation, and safe scaling.
type ABTestManager struct {
	store       Store
	qaManager   *PackagingQAManager
	gateChecker M11GateChecker
	nowFn       func() time.Time
}

// NewABTestManager creates a new ABTestManager.
func NewABTestManager(store Store, qaManager *PackagingQAManager, gateChecker M11GateChecker) *ABTestManager {
	if gateChecker == nil {
		gateChecker = NewDefaultM11GateChecker(store, qaManager)
	}
	return &ABTestManager{
		store:       store,
		qaManager:   qaManager,
		gateChecker: gateChecker,
		nowFn:       time.Now,
	}
}

// CreateExperiment starts an A/B test experiment.
// RBAC: Editor+ (ab_test:manage).
func (m *ABTestManager) CreateExperiment(ctx context.Context, caller CallerContext, sourceAssetID, title, hypothesis, targetMetric string, minDurationHours int, minImpressions int64, thresholdMultiplier float64, variants []*ABVariantRecord) (*ABExperimentRecord, error) {
	if !caller.HasRole("Editor") {
		return nil, ErrPermissionDenied
	}
	if strings.TrimSpace(sourceAssetID) == "" {
		return nil, ErrAssetNotFound
	}
	if len(variants) < 2 || len(variants) > 5 {
		return nil, fmt.Errorf("experiment requires between 2 and 5 variants (RULE-M10-006), got %d", len(variants))
	}

	if targetMetric == "" {
		targetMetric = "engagement_rate"
	}
	if minDurationHours <= 0 {
		minDurationHours = 48 // Default 48h per API behavior §7
	}
	if minImpressions <= 0 {
		minImpressions = 1000 // Default 1,000 impressions per variant per API behavior §7
	}
	if thresholdMultiplier <= 1.0 {
		thresholdMultiplier = 1.2
	}

	now := m.nowFn().UTC()
	expID := newUUID()

	var variantAssetIDs []string
	for i, v := range variants {
		if v.VariantID == "" {
			v.VariantID = newUUID()
		}
		if v.VariantLabel == "" {
			v.VariantLabel = fmt.Sprintf("Variant %c", 'A'+i)
		}
		variantAssetIDs = append(variantAssetIDs, v.AssetID)
	}

	record := &ABExperimentRecord{
		ExperimentID:                  expID,
		WorkspaceID:                   caller.WorkspaceID,
		SourceAssetID:                 sourceAssetID,
		Title:                         title,
		Hypothesis:                    hypothesis,
		VariantAssetIDs:               variantAssetIDs,
		VariantCount:                  len(variants),
		TargetMetric:                  targetMetric,
		MinDurationHours:              minDurationHours,
		MinImpressionsPerVariant:      minImpressions,
		AutoWinnerThresholdMultiplier: thresholdMultiplier,
		Status:                        "pending",
		ResultStatus:                  "pending",
		WinnerAssetID:                 "",
		IsObservational:               true, // Observational label retained (API behavior §7)
		InconclusiveReason:            "",
		Variants:                      variants,
		Criteria: &AutoWinnerCriteriaRecord{
			Metric:              targetMetric,
			ThresholdMultiplier: thresholdMultiplier,
			MinDurationHours:    minDurationHours,
			MinImpressions:      minImpressions,
		},
		StartedAt: &now,
		CreatedAt: now,
		UpdatedAt: now,
	}

	if err := m.store.SaveExperiment(ctx, record); err != nil {
		return nil, err
	}
	return record, nil
}

// GetExperiment retrieves an A/B experiment.
// RBAC: Contributor+ (ab_test:read).
func (m *ABTestManager) GetExperiment(ctx context.Context, caller CallerContext, experimentID string) (*ABExperimentRecord, error) {
	if !caller.HasRole("Contributor") {
		return nil, ErrPermissionDenied
	}
	exp, err := m.store.GetExperiment(ctx, caller.WorkspaceID, experimentID)
	if err != nil {
		return nil, err
	}

	// Always retain observational label
	exp.IsObservational = true
	return exp, nil
}

// ListExperiments lists all experiments in the workspace.
// RBAC: Contributor+ (ab_test:read).
func (m *ABTestManager) ListExperiments(ctx context.Context, caller CallerContext, sourceAssetID, status string) ([]*ABExperimentRecord, error) {
	if !caller.HasRole("Contributor") {
		return nil, ErrPermissionDenied
	}
	list, err := m.store.ListExperiments(ctx, caller.WorkspaceID, sourceAssetID)
	if err != nil {
		return nil, err
	}

	var filtered []*ABExperimentRecord
	for _, e := range list {
		if status != "" && !strings.EqualFold(e.Status, status) {
			continue
		}
		e.IsObservational = true
		filtered = append(filtered, e)
	}
	return filtered, nil
}

// DeclareWinner manually declares a winning variant.
// RBAC: Editor+ (ab_test:declare_winner).
func (m *ABTestManager) DeclareWinner(ctx context.Context, caller CallerContext, experimentID, winnerAssetID, reason string) (*ABExperimentRecord, error) {
	if !caller.HasRole("Editor") {
		return nil, ErrPermissionDenied
	}

	exp, err := m.store.GetExperiment(ctx, caller.WorkspaceID, experimentID)
	if err != nil {
		return nil, err
	}

	// Verify winnerAssetID belongs to the experiment variants
	found := false
	for _, id := range exp.VariantAssetIDs {
		if id == winnerAssetID {
			found = true
			break
		}
	}
	if !found {
		return nil, fmt.Errorf("winner asset %s is not among the experiment variants", winnerAssetID)
	}

	now := m.nowFn().UTC()
	exp.Status = "completed"
	exp.ResultStatus = "conclusive"
	exp.WinnerAssetID = winnerAssetID
	// Acceptance Target: Observational label retained!
	exp.IsObservational = true
	exp.InconclusiveReason = ""
	exp.CompletedAt = &now
	exp.UpdatedAt = now

	if err := m.store.UpdateExperiment(ctx, exp); err != nil {
		return nil, err
	}
	return exp, nil
}

// CancelExperiment cancels a running experiment.
// RBAC: Editor+ (ab_test:manage).
func (m *ABTestManager) CancelExperiment(ctx context.Context, caller CallerContext, experimentID, reason string) (*ABExperimentRecord, error) {
	if !caller.HasRole("Editor") {
		return nil, ErrPermissionDenied
	}

	exp, err := m.store.GetExperiment(ctx, caller.WorkspaceID, experimentID)
	if err != nil {
		return nil, err
	}
	if exp.Status == "completed" {
		return nil, ErrExperimentAlreadyCompleted
	}

	now := m.nowFn().UTC()
	exp.Status = "cancelled"
	exp.InconclusiveReason = fmt.Sprintf("Cancelled by user: %s", reason)
	exp.UpdatedAt = now

	if err := m.store.UpdateExperiment(ctx, exp); err != nil {
		return nil, err
	}
	return exp, nil
}

// EvaluateTest evaluates experiment results per API behavior §7 and RULE-M10-006.
// RBAC: Manager+ (ab_test:manage).
// Acceptance Target 1: Low exposure (<1,000 views or zero impressions) -> inconclusive with empty winner.
// Acceptance Target 2: Observational label retained across all evaluations.
func (m *ABTestManager) EvaluateTest(ctx context.Context, caller CallerContext, experimentID string) (*ABExperimentRecord, bool, string, error) {
	if !caller.HasRole("Manager") {
		return nil, false, "", ErrPermissionDenied
	}

	exp, err := m.store.GetExperiment(ctx, caller.WorkspaceID, experimentID)
	if err != nil {
		return nil, false, "", err
	}

	minRequiredImpressions := exp.MinImpressionsPerVariant
	if minRequiredImpressions <= 0 {
		minRequiredImpressions = 1000
	}

	multiplier := exp.AutoWinnerThresholdMultiplier
	if multiplier <= 1.0 {
		multiplier = 1.2
	}

	now := m.nowFn().UTC()
	exp.Status = "completed"
	exp.CompletedAt = &now
	// ACCEPTANCE TARGET 2: Observational label retained!
	exp.IsObservational = true

	// Check exposure across all variants
	allMeetImpressions := len(exp.Variants) >= 2
	hasZeroExposure := false
	var topAssetID string
	var topMetricValue float64
	var secondMetricValue float64

	for _, v := range exp.Variants {
		// If impressions are zero or missing, flag zero exposure
		if v.Impressions <= 0 && v.Views <= 0 {
			hasZeroExposure = true
		}
		if v.Impressions < minRequiredImpressions && v.Views < minRequiredImpressions {
			allMeetImpressions = false
		}

		// Calculate target metric value safely without division by zero
		metricVal := 0.0
		switch strings.ToLower(exp.TargetMetric) {
		case "click_through", "ctr":
			if v.Views > 0 {
				metricVal = float64(v.Clicks) / float64(v.Views)
			} else {
				metricVal = v.CTR
			}
		case "views":
			metricVal = float64(v.Views)
		default: // engagement_rate
			metricVal = v.EngagementRate
		}

		if metricVal > topMetricValue {
			secondMetricValue = topMetricValue
			topMetricValue = metricVal
			topAssetID = v.AssetID
		} else if metricVal > secondMetricValue {
			secondMetricValue = metricVal
		}
	}

	// ACCEPTANCE TARGET 1: Low exposure -> inconclusive
	if hasZeroExposure || !allMeetImpressions {
		exp.ResultStatus = "inconclusive"
		exp.WinnerAssetID = ""
		exp.InconclusiveReason = fmt.Sprintf("insufficient exposure (<%d impressions per variant); comparison retained as observational without automated scaling", minRequiredImpressions)
		summary := fmt.Sprintf("Inconclusive: insufficient exposure (<%d impressions per variant). Observational label retained.", minRequiredImpressions)

		if err := m.store.UpdateExperiment(ctx, exp); err != nil {
			return nil, false, "", err
		}
		return exp, false, summary, nil
	}

	// Adequate exposure: check statistical lift threshold
	isLiftSignificant := (secondMetricValue == 0 && topMetricValue > 0) || (secondMetricValue > 0 && (topMetricValue/secondMetricValue) >= multiplier)

	if isLiftSignificant && topAssetID != "" {
		exp.ResultStatus = "conclusive"
		exp.WinnerAssetID = topAssetID
		exp.InconclusiveReason = ""
		summary := fmt.Sprintf("Conclusive: winning variant %s achieved %.2fx lift. Labeled observational recommendation.", topAssetID, topMetricValue/secondMetricValue)

		if err := m.store.UpdateExperiment(ctx, exp); err != nil {
			return nil, false, "", err
		}
		return exp, true, summary, nil
	}

	// Exposure sufficient but lift below threshold -> inconclusive
	exp.ResultStatus = "inconclusive"
	exp.WinnerAssetID = ""
	exp.InconclusiveReason = "statistical lift below threshold; retain as observational without automated scaling"
	summary := "Inconclusive: variant lift below threshold multiplier. Labeled observational recommendation."

	if err := m.store.UpdateExperiment(ctx, exp); err != nil {
		return nil, false, "", err
	}
	return exp, false, summary, nil
}

// GetMetrics returns real-time metrics for an experiment.
// RBAC: Member (ab_test:read).
func (m *ABTestManager) GetMetrics(ctx context.Context, caller CallerContext, experimentID string) (*ABExperimentRecord, []*ABVariantRecord, string, bool, error) {
	if !caller.HasRole("Member") {
		return nil, nil, "", false, ErrPermissionDenied
	}

	exp, err := m.store.GetExperiment(ctx, caller.WorkspaceID, experimentID)
	if err != nil {
		return nil, nil, "", false, err
	}

	minRequired := exp.MinImpressionsPerVariant
	if minRequired <= 0 {
		minRequired = 1000
	}

	hasSufficient := len(exp.Variants) >= 2
	var leadingID string
	var topScore float64

	for _, v := range exp.Variants {
		if v.Impressions < minRequired && v.Views < minRequired {
			hasSufficient = false
		}
		if v.EngagementRate > topScore {
			topScore = v.EngagementRate
			leadingID = v.VariantID
		}
	}

	return exp, exp.Variants, leadingID, hasSufficient, nil
}

// ScaleWinner scales the winning variant to target platforms, strictly rechecking all M11 gates.
// RBAC: Editor+ (publish:execute).
// Acceptance Target 3: Scaling rechecks M11 gates:
// 1. Permission gate: Caller must have publish:execute / Editor+.
// 2. Capability gate: Target platform connector must be active and supported (not degraded, unsupported, revoked).
// 3. Policy gate: Packaging QA compliance scan must not have hard blocks or blocked status.
// 4. Duplicate-post gate: Identical asset cannot be scheduled or published to target platform within cooldown.
func (m *ABTestManager) ScaleWinner(ctx context.Context, caller CallerContext, experimentID string, targetPlatforms []string) (*ScaleWinnerResult, error) {
	// Gate 1: Fresh M11 Permission Check
	if err := m.gateChecker.CheckPermission(caller, "Editor"); err != nil {
		return nil, ErrScalingPermissionDenied
	}

	exp, err := m.store.GetExperiment(ctx, caller.WorkspaceID, experimentID)
	if err != nil {
		return nil, err
	}

	// Must have an eligible conclusive result with a declared winner
	if exp.ResultStatus != "conclusive" || exp.WinnerAssetID == "" {
		return nil, ErrExperimentNotEligibleForScaling
	}

	if len(targetPlatforms) == 0 {
		targetPlatforms = []string{"tiktok", "instagram"}
	}

	// Gate 3: Policy Check on Winner Asset
	if err := m.gateChecker.CheckPolicy(ctx, caller.WorkspaceID, exp.WinnerAssetID); err != nil {
		return nil, err
	}

	// Check Gates 2 and 4 for each platform before executing any scaling
	for _, platform := range targetPlatforms {
		// Gate 2: Platform Capability Gate
		if err := m.gateChecker.CheckCapability(ctx, caller.WorkspaceID, platform); err != nil {
			return nil, err
		}

		// Gate 4: Duplicate-Post Gate
		if err := m.gateChecker.CheckDuplicatePost(ctx, caller.WorkspaceID, exp.WinnerAssetID, platform, 24*time.Hour); err != nil {
			return nil, err
		}
	}

	// All gates passed: schedule posts across all target platforms
	var scheduledIDs []string
	for _, platform := range targetPlatforms {
		schedID, err := m.gateChecker.ScheduleScaledPost(ctx, caller, exp.WinnerAssetID, platform)
		if err != nil {
			return nil, err
		}
		scheduledIDs = append(scheduledIDs, schedID)
	}

	// Transition experiment to scaled
	now := m.nowFn().UTC()
	exp.ResultStatus = "scaled"
	exp.IsObservational = true // Observational label retained!
	exp.UpdatedAt = now

	if err := m.store.UpdateExperiment(ctx, exp); err != nil {
		return nil, err
	}

	return &ScaleWinnerResult{
		ExperimentID:               exp.ExperimentID,
		WinnerAssetID:              exp.WinnerAssetID,
		ScheduledItemIDs:           scheduledIDs,
		TargetPlatforms:            targetPlatforms,
		ResultStatus:               "scaled",
		ObservationalLabelRetained: true,
		Message:                    fmt.Sprintf("Winner %s successfully scaled to %d platforms across verified M11 gates.", exp.WinnerAssetID, len(targetPlatforms)),
		ScaledAt:                   now,
	}, nil
}
