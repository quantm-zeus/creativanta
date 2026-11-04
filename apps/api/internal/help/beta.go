package help

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"time"
)

var (
	ErrBetaTierIneligible = errors.New("help: beta program is available only to paid tiers (Starter+)")
	ErrBetaInvalidRating  = errors.New("help: feedback rating must be between 1 and 5")
	ErrBetaNotEnrolled    = errors.New("help: workspace is not enrolled in the beta program")
)

var canonicalBetaFlags = []string{
	"beta_video_continuity",
	"beta_live_radar",
	"beta_recipe_v2",
	"beta_copilot_voice",
}

// BetaEnrollmentRecord models beta_enrollments (§4.1).
type BetaEnrollmentRecord struct {
	WorkspaceID         string
	UserID              string
	Tier                string
	Status              string // "active", "opted_out"
	BonusCreditsGranted bool
	BonusCreditsAmount  int32
	EnrolledAt          time.Time
	OptedOutAt          *time.Time
	UpdatedAt           time.Time
}

// BetaFeedbackRecord models beta_feedbacks (§4.3).
type BetaFeedbackRecord struct {
	FeedbackID    string
	WorkspaceID   string
	UserID        string
	FeatureKey    string
	Rating        int32 // 1-5
	FeedbackText  string
	IsBugReport   bool
	ClientContext map[string]any
	CreatedAt     time.Time
}

// EnrollBetaResult represents the outcome of a beta enrollment.
type EnrollBetaResult struct {
	Enrollment     *BetaEnrollmentRecord
	CreditsAwarded int32
	AlreadyGranted bool
	EnabledFlags   []string
}

// GraduationEvaluation models the feature graduation criteria (§4.2).
type GraduationEvaluation struct {
	FeatureKey          string
	StabilityDays       int
	PositiveRatingRatio float64
	ActiveBugs          int
	CanGraduate         bool
	EvaluationNotes     string
}

func isPaidTier(tier string) bool {
	t := strings.ToLower(strings.TrimSpace(tier))
	switch t {
	case "starter", "pro", "business", "enterprise":
		return true
	default:
		return false
	}
}

// EnrollBeta enrolls a workspace into the Beta program (§4.1).
// ACCEPTANCE TARGET 2: "Beta grant once"
// - Only paid tiers (Starter+) are eligible; Free tier is rejected with ErrBetaTierIneligible.
// - 50 bonus credits are awarded EXACTLY ONCE upon initial enrollment.
// - If a user opts out and later re-enrolls, beta feature flags are restored, but 0 bonus credits are granted.
func (s *Service) EnrollBeta(
	ctx context.Context,
	workspaceID, userID, tier string,
) (*EnrollBetaResult, error) {
	if strings.TrimSpace(workspaceID) == "" || strings.TrimSpace(userID) == "" {
		return nil, ErrInvalidInput
	}
	if !isPaidTier(tier) {
		return nil, ErrBetaTierIneligible
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	now := time.Now().UTC()
	existing, found := s.store.betaEnrollments[workspaceID]

	if !found {
		// First-time enrollment: grant 50 bonus credits once!
		record := &BetaEnrollmentRecord{
			WorkspaceID:         workspaceID,
			UserID:              userID,
			Tier:                strings.ToLower(strings.TrimSpace(tier)),
			Status:              "active",
			BonusCreditsGranted: true,
			BonusCreditsAmount:  50,
			EnrolledAt:          now,
			UpdatedAt:           now,
		}
		s.store.betaEnrollments[workspaceID] = record
		s.store.workspaceBetaFlags[workspaceID] = append([]string(nil), canonicalBetaFlags...)

		return &EnrollBetaResult{
			Enrollment:     record,
			CreditsAwarded: 50,
			AlreadyGranted: false,
			EnabledFlags:   canonicalBetaFlags,
		}, nil
	}

	// Workspace was previously enrolled.
	// Ensure idempotent grant-once: Do NOT grant bonus credits a second time!
	existing.Status = "active"
	existing.OptedOutAt = nil
	existing.UpdatedAt = now
	existing.Tier = strings.ToLower(strings.TrimSpace(tier))
	s.store.workspaceBetaFlags[workspaceID] = append([]string(nil), canonicalBetaFlags...)

	return &EnrollBetaResult{
		Enrollment:     existing,
		CreditsAwarded: 0, // 0 credits on re-enrollment!
		AlreadyGranted: true,
		EnabledFlags:   canonicalBetaFlags,
	}, nil
}

// OptOutBeta opts a workspace out of the beta program (§4.1).
func (s *Service) OptOutBeta(
	ctx context.Context,
	workspaceID, userID string,
) (*BetaEnrollmentRecord, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, ErrInvalidInput
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	existing, found := s.store.betaEnrollments[workspaceID]
	if !found {
		return nil, ErrBetaNotEnrolled
	}

	now := time.Now().UTC()
	existing.Status = "opted_out"
	existing.OptedOutAt = &now
	existing.UpdatedAt = now

	// Disable beta feature flags for the opted-out workspace
	delete(s.store.workspaceBetaFlags, workspaceID)

	return existing, nil
}

// GetBetaStatus returns the beta program status and enabled flags for a workspace.
func (s *Service) GetBetaStatus(
	ctx context.Context,
	workspaceID string,
) (*BetaEnrollmentRecord, []string, error) {
	s.store.mu.RLock()
	defer s.store.mu.RUnlock()

	existing, found := s.store.betaEnrollments[workspaceID]
	if !found {
		return nil, nil, nil
	}

	flags := s.store.workspaceBetaFlags[workspaceID]
	cp := *existing
	return &cp, flags, nil
}

// SubmitBetaFeedback submits user feedback or bug reports for a beta feature (§4.3).
func (s *Service) SubmitBetaFeedback(
	ctx context.Context,
	workspaceID, userID, featureKey string,
	rating int32,
	feedbackText string,
	isBugReport bool,
	clientContext map[string]any,
) (*BetaFeedbackRecord, error) {
	if rating < 1 || rating > 5 {
		return nil, ErrBetaInvalidRating
	}
	if strings.TrimSpace(featureKey) == "" {
		return nil, ErrInvalidInput
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	fb := &BetaFeedbackRecord{
		FeedbackID:    generateUUID(),
		WorkspaceID:   workspaceID,
		UserID:        userID,
		FeatureKey:    featureKey,
		Rating:        rating,
		FeedbackText:  strings.TrimSpace(feedbackText),
		IsBugReport:   isBugReport,
		ClientContext: clientContext,
		CreatedAt:     time.Now().UTC(),
	}

	s.store.betaFeedbacks = append(s.store.betaFeedbacks, fb)
	return fb, nil
}

// EvaluateBetaGraduation checks graduation criteria for a beta feature (§4.2).
// Graduation requirements:
// 1. Minimum 2 weeks (14 days) stable in beta.
// 2. >80% positive feedback (rating >= 4).
// 3. 0 active P0/P1 bugs.
func (s *Service) EvaluateBetaGraduation(
	ctx context.Context,
	featureKey string,
	deployedAt time.Time,
	activeBugs int,
) (GraduationEvaluation, error) {
	s.store.mu.RLock()
	defer s.store.mu.RUnlock()

	now := time.Now().UTC()
	stabilityDays := int(now.Sub(deployedAt).Hours() / 24)

	var totalRatings int
	var positiveRatings int

	for _, fb := range s.store.betaFeedbacks {
		if fb.FeatureKey == featureKey {
			totalRatings++
			if fb.Rating >= 4 {
				positiveRatings++
			}
		}
	}

	ratio := 0.0
	if totalRatings > 0 {
		ratio = float64(positiveRatings) / float64(totalRatings)
	}

	meetsStability := stabilityDays >= 14
	meetsFeedback := totalRatings >= 5 && ratio >= 0.80
	meetsBugs := activeBugs == 0

	canGraduate := meetsStability && meetsFeedback && meetsBugs

	var notes []string
	if !meetsStability {
		notes = append(notes, fmt.Sprintf("Requires 14 days in beta (current: %d days)", stabilityDays))
	}
	if totalRatings < 5 {
		notes = append(notes, fmt.Sprintf("Requires at least 5 ratings (current: %d)", totalRatings))
	} else if !meetsFeedback {
		notes = append(notes, fmt.Sprintf("Positive feedback ratio %.1f%% below 80%% threshold", ratio*100))
	}
	if !meetsBugs {
		notes = append(notes, fmt.Sprintf("Blocked by %d active P0/P1 bugs", activeBugs))
	}

	noteStr := "Criteria satisfied; ready for General Availability (GA)."
	if len(notes) > 0 {
		noteStr = strings.Join(notes, "; ")
	}

	return GraduationEvaluation{
		FeatureKey:          featureKey,
		StabilityDays:       stabilityDays,
		PositiveRatingRatio: ratio,
		ActiveBugs:          activeBugs,
		CanGraduate:         canGraduate,
		EvaluationNotes:     noteStr,
	}, nil
}
