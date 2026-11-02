package identity

import (
	"bytes"
	"context"
	"crypto/sha256"
	"database/sql"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"sort"
	"strings"
)

const (
	OnboardingStepConnectOrImport   = 1
	OnboardingStepProductOrOffer    = 2
	OnboardingStepIdeaScriptAsset   = 3
	OnboardingStepPublishOrFallback = 4
	OnboardingStepTrackOutcome      = 5
)

var (
	ErrInvalidOnboardingStep      = errors.New("identity: completed_step must be between 1 and 5")
	ErrInvalidCommandContext      = errors.New("identity: invalid command context or forbidden field")
	ErrOnboardingStepUnavailable  = errors.New("identity: onboarding step unavailable in current phase")
	ErrOnboardingStepNotVerified  = errors.New("identity: linked domain action for onboarding step is not verified")
	ErrDemoFixtureNotCounted      = errors.New("identity: demo fixtures never count toward personal onboarding completion")
	ErrIdempotencyConflict        = errors.New("identity: SYSTEM_CONFLICT_001 idempotency key reused with different payload")
	ErrWorkspaceMutationForbidden = errors.New("identity: personal onboarding cannot mutate workspace settings")
)

// CompleteOnboardingCommand models WorkspaceService/CompleteOnboarding
// per docs/04_contracts/api_behavior_contracts.md §8 and PRIV-2026-02.
// No caller-supplied user_id, role, or workspace settings fields are permitted.
type CompleteOnboardingCommand struct {
	IdempotencyKey string `json:"idempotency_key"`
	WorkspaceID    string `json:"workspace_id,omitempty"`
	Reason         string `json:"reason,omitempty"`
	CompletedStep  int    `json:"completed_step"`
}

// OnboardingProgressDocument is the canonical JSONB shape stored in
// user_preferences.onboarding_progress (database_schema.md §18.9, §27.1).
type OnboardingProgressDocument struct {
	CompletedSteps []int `json:"completed_steps"`
}

// OnboardingProgressResult is returned by WorkspaceService/CompleteOnboarding.
type OnboardingProgressResult struct {
	CompletedSteps []int `json:"completed_steps"`
	Completed      bool  `json:"completed"`
	Replayed       bool  `json:"replayed"`
}

// HomeOnboardingProjection is the transport-only projection embedded in
// DashboardService/GetMobileHome and Home projections (api_behavior_contracts.md §8).
type HomeOnboardingProjection struct {
	CompletedSteps []int  `json:"completed_steps"`
	NextStep       *int   `json:"next_step,omitempty"`
	Available      bool   `json:"available"`
	Reason         string `json:"reason,omitempty"`
}

// StepVerification reports server-side verification of an onboarding step
// under the authenticated user and workspace context.
type StepVerification struct {
	Available         bool
	Verified          bool
	IsDemoFixture     bool
	UnavailableReason string
}

// OnboardingStepVerifier checks whether a step (1..5) is available in the
// current phase and has a verified underlying domain action.
type OnboardingStepVerifier interface {
	VerifyStep(ctx context.Context, userID, workspaceID string, step int) (StepVerification, error)
}

// OnboardingStore persists and reads per-user, per-workspace onboarding
// progress in user_preferences without ever mutating workspaces or
// home_dashboard_config.
type OnboardingStore interface {
	GetUserProgress(ctx context.Context, userID, workspaceID string) ([]int, bool, error)
	SaveUserStep(ctx context.Context, userID, workspaceID, idempotencyKey, requestHash string, step int) (OnboardingProgressResult, error)
}

// DecodeCompleteOnboardingStrict parses a JSON request body for
// WorkspaceService/CompleteOnboarding and rejects any unknown or forbidden
// privilege/workspace-mutation fields (user_id, role, settings,
// default_operator_mode, onboarding_completed, completed_steps, etc.).
func DecodeCompleteOnboardingStrict(rawJSON []byte) (CompleteOnboardingCommand, error) {
	trimmed := bytes.TrimSpace(rawJSON)
	if len(trimmed) == 0 || len(trimmed) > 16_384 {
		return CompleteOnboardingCommand{}, ErrInvalidCommandContext
	}

	var rawMap map[string]json.RawMessage
	if err := json.Unmarshal(trimmed, &rawMap); err != nil {
		return CompleteOnboardingCommand{}, ErrInvalidCommandContext
	}
	for key := range rawMap {
		switch key {
		case "idempotency_key", "workspace_id", "reason", "completed_step":
		case "user_id", "role", "settings", "default_operator_mode", "display_name",
			"onboarding_completed", "completed_steps", "ai_credits_remaining", "rewards":
			return CompleteOnboardingCommand{}, fmt.Errorf("%w: forbidden field %q", ErrWorkspaceMutationForbidden, key)
		default:
			return CompleteOnboardingCommand{}, fmt.Errorf("%w: unknown field %q", ErrInvalidCommandContext, key)
		}
	}

	dec := json.NewDecoder(bytes.NewReader(trimmed))
	dec.DisallowUnknownFields()
	var cmd CompleteOnboardingCommand
	if err := dec.Decode(&cmd); err != nil {
		return CompleteOnboardingCommand{}, ErrInvalidCommandContext
	}
	var trailing any
	if err := dec.Decode(&trailing); !errors.Is(err, io.EOF) {
		return CompleteOnboardingCommand{}, ErrInvalidCommandContext
	}
	if err := ValidateCompleteOnboardingCommand(cmd); err != nil {
		return CompleteOnboardingCommand{}, err
	}
	return cmd, nil
}

// ValidateCompleteOnboardingCommand validates CommandContext and step bounds.
func ValidateCompleteOnboardingCommand(cmd CompleteOnboardingCommand) error {
	key := strings.TrimSpace(cmd.IdempotencyKey)
	if key == "" || key != cmd.IdempotencyKey || len(key) > 255 || strings.ContainsAny(key, " \t\r\n") {
		return ErrInvalidCommandContext
	}
	if cmd.WorkspaceID != "" {
		if !workspaceIDPattern.MatchString(cmd.WorkspaceID) || cmd.WorkspaceID == zeroUUID {
			return ErrInvalidCommandContext
		}
	}
	if len(cmd.Reason) > 2000 {
		return ErrInvalidCommandContext
	}
	if cmd.CompletedStep < OnboardingStepConnectOrImport || cmd.CompletedStep > OnboardingStepTrackOutcome {
		return ErrInvalidOnboardingStep
	}
	return nil
}

// OnboardingCoordinator coordinates verified session resolution, server-side
// step verification, idempotency, and self-scoped user_preferences persistence.
type OnboardingCoordinator struct {
	Resolver     Resolver
	StepVerifier OnboardingStepVerifier
	Store        OnboardingStore
}

// CompleteStep executes WorkspaceService/CompleteOnboarding for the
// authenticated user in selectedWorkspaceID. It enforces:
// 1. Verified JWT + active Clerk session + active workspace membership (any role).
// 2. CommandContext workspace_id compatibility check (if provided).
// 3. Server-side verification of the completed step (rejecting demo fixtures and unavailable future steps).
// 4. Self-scoped persistence strictly to user_preferences(user_id, workspace_id).
func (c OnboardingCoordinator) CompleteStep(
	ctx context.Context,
	token string,
	selectedWorkspaceID string,
	cmd CompleteOnboardingCommand,
) (OnboardingProgressResult, error) {
	if ctx == nil {
		return OnboardingProgressResult{}, ErrUnauthorized
	}
	if err := ctx.Err(); err != nil {
		return OnboardingProgressResult{}, err
	}
	if c.StepVerifier == nil || c.Store == nil {
		return OnboardingProgressResult{}, ErrNotConfigured
	}
	if err := ValidateCompleteOnboardingCommand(cmd); err != nil {
		return OnboardingProgressResult{}, err
	}
	if cmd.WorkspaceID != "" && cmd.WorkspaceID != selectedWorkspaceID {
		return OnboardingProgressResult{}, ErrNoMembership
	}

	session, err := c.Resolver.VerifyWorkspace(ctx, token, selectedWorkspaceID)
	if err != nil {
		return OnboardingProgressResult{}, err
	}

	verification, err := c.StepVerifier.VerifyStep(ctx, session.UserID, session.WorkspaceID, cmd.CompletedStep)
	if err != nil {
		return OnboardingProgressResult{}, err
	}
	if verification.IsDemoFixture {
		return OnboardingProgressResult{}, ErrDemoFixtureNotCounted
	}
	if !verification.Available {
		return OnboardingProgressResult{}, ErrOnboardingStepUnavailable
	}
	if !verification.Verified {
		return OnboardingProgressResult{}, ErrOnboardingStepNotVerified
	}

	reqHash := hashOnboardingCommand(session.UserID, session.WorkspaceID, cmd.CompletedStep)
	return c.Store.SaveUserStep(ctx, session.UserID, session.WorkspaceID, cmd.IdempotencyKey, reqHash, cmd.CompletedStep)
}

// GetHomeProjection builds the authenticated user's HomeOnboardingProjection
// without counting unavailable future steps as complete or including demo data.
func (c OnboardingCoordinator) GetHomeProjection(
	ctx context.Context,
	token string,
	selectedWorkspaceID string,
) (HomeOnboardingProjection, error) {
	if ctx == nil {
		return HomeOnboardingProjection{}, ErrUnauthorized
	}
	if err := ctx.Err(); err != nil {
		return HomeOnboardingProjection{}, err
	}
	if c.StepVerifier == nil || c.Store == nil {
		return HomeOnboardingProjection{}, ErrNotConfigured
	}

	session, err := c.Resolver.VerifyWorkspace(ctx, token, selectedWorkspaceID)
	if err != nil {
		return HomeOnboardingProjection{}, err
	}

	steps, _, err := c.Store.GetUserProgress(ctx, session.UserID, session.WorkspaceID)
	if err != nil {
		return HomeOnboardingProjection{}, err
	}
	normalized := NormalizeCompletedSteps(steps)

	doneSet := make(map[int]bool, len(normalized))
	for _, s := range normalized {
		doneSet[s] = true
	}

	for step := OnboardingStepConnectOrImport; step <= OnboardingStepTrackOutcome; step++ {
		if !doneSet[step] {
			next := step
			v, err := c.StepVerifier.VerifyStep(ctx, session.UserID, session.WorkspaceID, next)
			if err != nil {
				return HomeOnboardingProjection{}, err
			}
			reason := ""
			if !v.Available {
				reason = strings.TrimSpace(v.UnavailableReason)
				if reason == "" {
					reason = fmt.Sprintf("Step %d is scheduled for a later phase", next)
				}
			}
			return HomeOnboardingProjection{
				CompletedSteps: normalized,
				NextStep:       &next,
				Available:      v.Available,
				Reason:         reason,
			}, nil
		}
	}

	return HomeOnboardingProjection{
		CompletedSteps: normalized,
		NextStep:       nil,
		Available:      true,
	}, nil
}

// NormalizeCompletedSteps filters and deduplicates steps to sorted distinct integers 1..5.
func NormalizeCompletedSteps(steps []int) []int {
	seen := make(map[int]struct{}, 5)
	out := make([]int, 0, len(steps))
	for _, s := range steps {
		if s >= OnboardingStepConnectOrImport && s <= OnboardingStepTrackOutcome {
			if _, exists := seen[s]; !exists {
				seen[s] = struct{}{}
				out = append(out, s)
			}
		}
	}
	sort.Ints(out)
	return out
}

func hashOnboardingCommand(userID, workspaceID string, step int) string {
	sum := sha256.Sum256([]byte(fmt.Sprintf("%s|%s|step=%d", userID, workspaceID, step)))
	return hex.EncodeToString(sum[:])
}

// SQLOnboardingRunner is satisfied by *sql.DB and *sql.Tx.
type SQLOnboardingRunner interface {
	ExecContext(ctx context.Context, query string, args ...any) (sql.Result, error)
	QueryRowContext(ctx context.Context, query string, args ...any) *sql.Row
}

// SQLOnboardingStore persists self-scoped personal onboarding progress in
// canonical user_preferences (database_schema.md §18.9) and optional
// api_idempotency_records. It never writes to workspaces or home_dashboard_config.
type SQLOnboardingStore struct {
	DB SQLOnboardingRunner
}

const (
	selectUserOnboardingQuery = `
SELECT onboarding_progress::text, onboarding_completed
FROM user_preferences
WHERE user_id = $1::uuid
  AND workspace_id = $2::uuid
LIMIT 1`

	upsertUserOnboardingQuery = `
INSERT INTO user_preferences (
  user_id,
  workspace_id,
  onboarding_progress,
  onboarding_completed,
  created_at,
  updated_at
) VALUES (
  $1::uuid,
  $2::uuid,
  $3::jsonb,
  $4,
  NOW(),
  NOW()
)
ON CONFLICT (user_id, workspace_id) DO UPDATE SET
  onboarding_progress = EXCLUDED.onboarding_progress,
  onboarding_completed = EXCLUDED.onboarding_completed,
  updated_at = NOW()
WHERE user_preferences.user_id = $1::uuid
  AND user_preferences.workspace_id = $2::uuid
RETURNING onboarding_progress::text, onboarding_completed`

	selectOnboardingIdempotencyQuery = `
SELECT request_hash, response_body::text
FROM api_idempotency_records
WHERE workspace_id = $1::uuid
  AND actor_user_id = $2::uuid
  AND idempotency_key = $3
LIMIT 1`

	insertOnboardingIdempotencyQuery = `
INSERT INTO api_idempotency_records (
  workspace_id,
  actor_user_id,
  idempotency_key,
  rpc_name,
  request_hash,
  response_body,
  created_at
) VALUES (
  $1::uuid,
  $2::uuid,
  $3,
  'WorkspaceService/CompleteOnboarding',
  $4,
  $5::jsonb,
  NOW()
)`
)

// GetUserProgress reads the authenticated user's personal onboarding progress
// for the specified workspace. If no user_preferences row exists yet, it
// returns an empty slice and false.
func (s SQLOnboardingStore) GetUserProgress(ctx context.Context, userID, workspaceID string) ([]int, bool, error) {
	if s.DB == nil {
		return nil, false, ErrNotConfigured
	}
	if !workspaceIDPattern.MatchString(userID) || userID == zeroUUID ||
		!workspaceIDPattern.MatchString(workspaceID) || workspaceID == zeroUUID {
		return nil, false, ErrUnauthorized
	}

	var rawJSON string
	var completed bool
	err := s.DB.QueryRowContext(ctx, selectUserOnboardingQuery, userID, workspaceID).Scan(&rawJSON, &completed)
	if errors.Is(err, sql.ErrNoRows) {
		return []int{}, false, nil
	}
	if err != nil {
		return nil, false, err
	}

	var doc OnboardingProgressDocument
	if err := json.Unmarshal([]byte(rawJSON), &doc); err != nil {
		return nil, false, err
	}
	steps := NormalizeCompletedSteps(doc.CompletedSteps)
	return steps, completed && len(steps) == 5, nil
}

// SaveUserStep idempotently records a verified onboarding step in
// user_preferences for (userID, workspaceID) without touching workspace settings.
func (s SQLOnboardingStore) SaveUserStep(
	ctx context.Context,
	userID, workspaceID, idempotencyKey, requestHash string,
	step int,
) (OnboardingProgressResult, error) {
	if s.DB == nil {
		return OnboardingProgressResult{}, ErrNotConfigured
	}
	if !workspaceIDPattern.MatchString(userID) || userID == zeroUUID ||
		!workspaceIDPattern.MatchString(workspaceID) || workspaceID == zeroUUID {
		return OnboardingProgressResult{}, ErrUnauthorized
	}
	if step < OnboardingStepConnectOrImport || step > OnboardingStepTrackOutcome {
		return OnboardingProgressResult{}, ErrInvalidOnboardingStep
	}

	// Check existing idempotency record first.
	var existingHash, existingResp string
	err := s.DB.QueryRowContext(ctx, selectOnboardingIdempotencyQuery, workspaceID, userID, idempotencyKey).
		Scan(&existingHash, &existingResp)
	if err == nil {
		if existingHash != requestHash {
			return OnboardingProgressResult{}, ErrIdempotencyConflict
		}
		var cached OnboardingProgressResult
		if err := json.Unmarshal([]byte(existingResp), &cached); err != nil {
			return OnboardingProgressResult{}, err
		}
		cached.CompletedSteps = NormalizeCompletedSteps(cached.CompletedSteps)
		cached.Replayed = true
		return cached, nil
	} else if !errors.Is(err, sql.ErrNoRows) {
		return OnboardingProgressResult{}, err
	}

	currentSteps, _, err := s.GetUserProgress(ctx, userID, workspaceID)
	if err != nil {
		return OnboardingProgressResult{}, err
	}

	merged := NormalizeCompletedSteps(append(currentSteps, step))
	allCompleted := len(merged) == 5

	docBytes, err := json.Marshal(OnboardingProgressDocument{CompletedSteps: merged})
	if err != nil {
		return OnboardingProgressResult{}, err
	}

	var storedJSON string
	var storedCompleted bool
	if err := s.DB.QueryRowContext(
		ctx,
		upsertUserOnboardingQuery,
		userID,
		workspaceID,
		string(docBytes),
		allCompleted,
	).Scan(&storedJSON, &storedCompleted); err != nil {
		return OnboardingProgressResult{}, err
	}

	var storedDoc OnboardingProgressDocument
	if err := json.Unmarshal([]byte(storedJSON), &storedDoc); err != nil {
		return OnboardingProgressResult{}, err
	}
	finalSteps := NormalizeCompletedSteps(storedDoc.CompletedSteps)
	result := OnboardingProgressResult{
		CompletedSteps: finalSteps,
		Completed:      storedCompleted && len(finalSteps) == 5,
		Replayed:       false,
	}

	respBytes, err := json.Marshal(result)
	if err != nil {
		return OnboardingProgressResult{}, err
	}
	if _, err := s.DB.ExecContext(
		ctx,
		insertOnboardingIdempotencyQuery,
		workspaceID,
		userID,
		idempotencyKey,
		requestHash,
		string(respBytes),
	); err != nil {
		return OnboardingProgressResult{}, err
	}

	return result, nil
}
