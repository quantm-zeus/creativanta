package identity

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"os"
	"reflect"
	"sync"
	"testing"
	"time"

	_ "github.com/jackc/pgx/v5/stdlib"
)

type fixedStepVerifier struct {
	steps map[int]StepVerification
}

func (f fixedStepVerifier) VerifyStep(_ context.Context, _, _ string, step int) (StepVerification, error) {
	v, ok := f.steps[step]
	if !ok {
		return StepVerification{Available: false, UnavailableReason: "step not configured"}, nil
	}
	return v, nil
}

type inMemoryOnboardingStore struct {
	mu          sync.Mutex
	preferences map[string][]int
	idempotency map[string]struct {
		hash   string
		result OnboardingProgressResult
	}
	workspaceSettings   map[string]string
	workspaceMode       map[string]string
	homeDashboardConfig map[string]string
}

func newInMemoryOnboardingStore() *inMemoryOnboardingStore {
	return &inMemoryOnboardingStore{
		preferences: make(map[string][]int),
		idempotency: make(map[string]struct {
			hash   string
			result OnboardingProgressResult
		}),
		workspaceSettings:   make(map[string]string),
		workspaceMode:       make(map[string]string),
		homeDashboardConfig: make(map[string]string),
	}
}

func (m *inMemoryOnboardingStore) prefKey(userID, workspaceID string) string {
	return userID + "|" + workspaceID
}

func (m *inMemoryOnboardingStore) idemKey(userID, workspaceID, key string) string {
	return workspaceID + "|" + userID + "|" + key
}

func (m *inMemoryOnboardingStore) GetUserProgress(_ context.Context, userID, workspaceID string) ([]int, bool, error) {
	m.mu.Lock()
	defer m.mu.Unlock()
	steps := NormalizeCompletedSteps(m.preferences[m.prefKey(userID, workspaceID)])
	return steps, len(steps) == 5, nil
}

func (m *inMemoryOnboardingStore) SaveUserStep(
	_ context.Context,
	userID, workspaceID, idempotencyKey, requestHash string,
	step int,
) (OnboardingProgressResult, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	ik := m.idemKey(userID, workspaceID, idempotencyKey)
	if existing, ok := m.idempotency[ik]; ok {
		if existing.hash != requestHash {
			return OnboardingProgressResult{}, ErrIdempotencyConflict
		}
		res := existing.result
		res.Replayed = true
		return res, nil
	}

	pk := m.prefKey(userID, workspaceID)
	merged := NormalizeCompletedSteps(append(m.preferences[pk], step))
	m.preferences[pk] = merged
	res := OnboardingProgressResult{
		CompletedSteps: merged,
		Completed:      len(merged) == 5,
		Replayed:       false,
	}
	m.idempotency[ik] = struct {
		hash   string
		result OnboardingProgressResult
	}{
		hash:   requestHash,
		result: res,
	}
	return res, nil
}

type multiUserMembershipStub struct {
	members map[string]string // subject|workspace -> internalUserID
}

func (m multiUserMembershipStub) ResolveActive(_ context.Context, subject, workspaceID string) (string, bool, error) {
	uid, ok := m.members[subject+"|"+workspaceID]
	if !ok {
		return "", false, nil
	}
	return uid, true, nil
}

type multiUserTokenStub struct {
	tokens map[string]Identity
}

func (m multiUserTokenStub) VerifyToken(_ context.Context, token string) (Identity, error) {
	id, ok := m.tokens[token]
	if !ok {
		return Identity{}, ErrUnauthorized
	}
	return id, nil
}

type multiUserSessionStub struct {
	active map[string]bool
}

func (m multiUserSessionStub) Active(_ context.Context, subject, sessionID string) (bool, error) {
	return m.active[subject+"|"+sessionID], nil
}

func TestDecodeCompleteOnboardingStrictRejectsPrivilegeAndWorkspaceMutations(t *testing.T) {
	validJSON := []byte(`{"idempotency_key":"idem-step-1","workspace_id":"019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1","completed_step":1}`)
	cmd, err := DecodeCompleteOnboardingStrict(validJSON)
	if err != nil {
		t.Fatalf("expected valid command to decode, got %v", err)
	}
	if cmd.CompletedStep != 1 || cmd.IdempotencyKey != "idem-step-1" {
		t.Fatalf("unexpected decoded command: %+v", cmd)
	}

	forbiddenPayloads := []struct {
		name    string
		payload string
		wantErr error
	}{
		{
			name:    "caller_supplied_user_id",
			payload: `{"idempotency_key":"k1","completed_step":1,"user_id":"019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a"}`,
			wantErr: ErrWorkspaceMutationForbidden,
		},
		{
			name:    "workspace_settings_mutation",
			payload: `{"idempotency_key":"k1","completed_step":1,"settings":{"default_operator_mode":"seller"}}`,
			wantErr: ErrWorkspaceMutationForbidden,
		},
		{
			name:    "operator_mode_mutation",
			payload: `{"idempotency_key":"k1","completed_step":1,"default_operator_mode":"seller"}`,
			wantErr: ErrWorkspaceMutationForbidden,
		},
		{
			name:    "role_escalation",
			payload: `{"idempotency_key":"k1","completed_step":1,"role":"owner"}`,
			wantErr: ErrWorkspaceMutationForbidden,
		},
		{
			name:    "direct_completed_override",
			payload: `{"idempotency_key":"k1","completed_step":1,"onboarding_completed":true}`,
			wantErr: ErrWorkspaceMutationForbidden,
		},
		{
			name:    "credit_reward_injection",
			payload: `{"idempotency_key":"k1","completed_step":1,"ai_credits_remaining":"500.000000"}`,
			wantErr: ErrWorkspaceMutationForbidden,
		},
		{
			name:    "unknown_field",
			payload: `{"idempotency_key":"k1","completed_step":1,"extra":true}`,
			wantErr: ErrInvalidCommandContext,
		},
		{
			name:    "step_zero",
			payload: `{"idempotency_key":"k1","completed_step":0}`,
			wantErr: ErrInvalidOnboardingStep,
		},
		{
			name:    "step_six",
			payload: `{"idempotency_key":"k1","completed_step":6}`,
			wantErr: ErrInvalidOnboardingStep,
		},
		{
			name:    "missing_idempotency_key",
			payload: `{"completed_step":1}`,
			wantErr: ErrInvalidCommandContext,
		},
	}

	for _, tc := range forbiddenPayloads {
		t.Run(tc.name, func(t *testing.T) {
			_, err := DecodeCompleteOnboardingStrict([]byte(tc.payload))
			if !errors.Is(err, tc.wantErr) {
				t.Fatalf("expected error %v for %s, got %v", tc.wantErr, tc.name, err)
			}
		})
	}
}

func TestPersonalOnboardingCannotMutateWorkspaceSettingsOrOtherUsers(t *testing.T) {
	ctx := context.Background()
	ownerUID := "019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a"
	viewerUID := "019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1b"

	resolver := Resolver{
		Tokens: multiUserTokenStub{
			tokens: map[string]Identity{
				"tok_owner":  {Subject: "user_owner1", SessionID: "sess_owner1"},
				"tok_viewer": {Subject: "user_viewer2", SessionID: "sess_viewer2"},
			},
		},
		Sessions: multiUserSessionStub{
			active: map[string]bool{
				"user_owner1|sess_owner1":   true,
				"user_viewer2|sess_viewer2": true,
			},
		},
		Memberships: multiUserMembershipStub{
			members: map[string]string{
				"user_owner1|" + testWorkspace:  ownerUID,
				"user_viewer2|" + testWorkspace: viewerUID,
			},
		},
	}

	store := newInMemoryOnboardingStore()
	store.workspaceSettings[testWorkspace] = `{"timezone":"Asia/Ho_Chi_Minh"}`
	store.workspaceMode[testWorkspace] = "seller"
	store.homeDashboardConfig[testWorkspace] = `{"onboarding_completed":false,"step":0}`
	// Pre-populate owner with step 1 only.
	store.preferences[store.prefKey(ownerUID, testWorkspace)] = []int{1}

	verifier := fixedStepVerifier{
		steps: map[int]StepVerification{
			1: {Available: true, Verified: true},
			2: {Available: true, Verified: true},
			3: {Available: false, UnavailableReason: "Content & Script Lab available in P3"},
			4: {Available: true, Verified: false},
			5: {Available: true, Verified: true, IsDemoFixture: true},
		},
	}

	coord := OnboardingCoordinator{
		Resolver:     resolver,
		StepVerifier: verifier,
		Store:        store,
	}

	// 1. Viewer completes step 1 and step 2.
	res1, err := coord.CompleteStep(ctx, "tok_viewer", testWorkspace, CompleteOnboardingCommand{
		IdempotencyKey: "viewer-step-1",
		WorkspaceID:    testWorkspace,
		CompletedStep:  1,
	})
	if err != nil {
		t.Fatalf("viewer step 1 failed: %v", err)
	}
	if !reflect.DeepEqual(res1.CompletedSteps, []int{1}) || res1.Completed || res1.Replayed {
		t.Fatalf("unexpected step 1 result: %+v", res1)
	}

	// Idempotent replay with same key and step returns Replayed=true.
	replay1, err := coord.CompleteStep(ctx, "tok_viewer", testWorkspace, CompleteOnboardingCommand{
		IdempotencyKey: "viewer-step-1",
		WorkspaceID:    testWorkspace,
		CompletedStep:  1,
	})
	if err != nil || !replay1.Replayed || !reflect.DeepEqual(replay1.CompletedSteps, []int{1}) {
		t.Fatalf("expected idempotent replay, got %+v, err=%v", replay1, err)
	}

	// Same idempotency key with changed payload (step 2) fails closed with SYSTEM_CONFLICT_001.
	if _, err := coord.CompleteStep(ctx, "tok_viewer", testWorkspace, CompleteOnboardingCommand{
		IdempotencyKey: "viewer-step-1",
		WorkspaceID:    testWorkspace,
		CompletedStep:  2,
	}); !errors.Is(err, ErrIdempotencyConflict) {
		t.Fatalf("expected ErrIdempotencyConflict on payload change, got %v", err)
	}

	res2, err := coord.CompleteStep(ctx, "tok_viewer", testWorkspace, CompleteOnboardingCommand{
		IdempotencyKey: "viewer-step-2",
		CompletedStep:  2,
	})
	if err != nil || !reflect.DeepEqual(res2.CompletedSteps, []int{1, 2}) || res2.Completed {
		t.Fatalf("unexpected step 2 result: %+v, err=%v", res2, err)
	}

	// 2. Future unavailable step (step 3) is rejected without fake success.
	if _, err := coord.CompleteStep(ctx, "tok_viewer", testWorkspace, CompleteOnboardingCommand{
		IdempotencyKey: "viewer-step-3",
		CompletedStep:  3,
	}); !errors.Is(err, ErrOnboardingStepUnavailable) {
		t.Fatalf("expected ErrOnboardingStepUnavailable for step 3, got %v", err)
	}

	// 3. Unverified domain action (step 4) is rejected.
	if _, err := coord.CompleteStep(ctx, "tok_viewer", testWorkspace, CompleteOnboardingCommand{
		IdempotencyKey: "viewer-step-4",
		CompletedStep:  4,
	}); !errors.Is(err, ErrOnboardingStepNotVerified) {
		t.Fatalf("expected ErrOnboardingStepNotVerified for step 4, got %v", err)
	}

	// 4. Demo fixture (step 5) never counts toward real onboarding progress.
	if _, err := coord.CompleteStep(ctx, "tok_viewer", testWorkspace, CompleteOnboardingCommand{
		IdempotencyKey: "viewer-step-5-demo",
		CompletedStep:  5,
	}); !errors.Is(err, ErrDemoFixtureNotCounted) {
		t.Fatalf("expected ErrDemoFixtureNotCounted for demo step, got %v", err)
	}

	// 5. Home projection shows steps [1, 2], next_step = 3, available = false, with reason.
	proj, err := coord.GetHomeProjection(ctx, "tok_viewer", testWorkspace)
	if err != nil {
		t.Fatalf("GetHomeProjection failed: %v", err)
	}
	if !reflect.DeepEqual(proj.CompletedSteps, []int{1, 2}) || proj.NextStep == nil || *proj.NextStep != 3 || proj.Available || proj.Reason == "" {
		t.Fatalf("unexpected home projection: %+v", proj)
	}

	// 6. Now enable all 5 steps as verified non-demo actions and complete viewer's checklist.
	for s := 1; s <= 5; s++ {
		verifier.steps[s] = StepVerification{Available: true, Verified: true, IsDemoFixture: false}
	}
	for _, s := range []int{3, 4, 5} {
		res, err := coord.CompleteStep(ctx, "tok_viewer", testWorkspace, CompleteOnboardingCommand{
			IdempotencyKey: "viewer-complete-" + string(rune('0'+s)),
			CompletedStep:  s,
		})
		if err != nil {
			t.Fatalf("step %d failed: %v", s, err)
		}
		if s == 5 && (!res.Completed || !reflect.DeepEqual(res.CompletedSteps, []int{1, 2, 3, 4, 5})) {
			t.Fatalf("expected full completion on step 5, got %+v", res)
		}
	}

	// 7. Verify owner's progress and workspace settings were NOT changed by viewer's completion.
	ownerSteps, ownerDone, err := store.GetUserProgress(ctx, ownerUID, testWorkspace)
	if err != nil {
		t.Fatalf("GetUserProgress for owner failed: %v", err)
	}
	if !reflect.DeepEqual(ownerSteps, []int{1}) || ownerDone {
		t.Fatalf("owner progress was mutated by viewer: steps=%v done=%v", ownerSteps, ownerDone)
	}
	if store.workspaceSettings[testWorkspace] != `{"timezone":"Asia/Ho_Chi_Minh"}` ||
		store.workspaceMode[testWorkspace] != "seller" ||
		store.homeDashboardConfig[testWorkspace] != `{"onboarding_completed":false,"step":0}` {
		t.Fatalf("workspace settings or home_dashboard_config were mutated by personal onboarding")
	}

	// 8. Cross-workspace mismatch in CommandContext is denied fail-closed.
	if _, err := coord.CompleteStep(ctx, "tok_viewer", testWorkspace, CompleteOnboardingCommand{
		IdempotencyKey: "cross-ws-attempt",
		WorkspaceID:    testForeignWorkspace,
		CompletedStep:  1,
	}); !errors.Is(err, ErrNoMembership) {
		t.Fatalf("expected ErrNoMembership on mismatched CommandContext.WorkspaceID, got %v", err)
	}
}

func TestPostgresPersonalOnboardingCannotMutateWorkspaceSettings(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_POSTGRES_DSN")
	if dsn == "" {
		t.Skip("set CREATIVANTA_TEST_POSTGRES_DSN to run real PostgreSQL personal onboarding isolation tests")
	}

	db, err := sql.Open("pgx", dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()

	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()

	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer tx.Rollback()

	ownerUID := "019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a"
	viewerUID := "019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1b"

	setupSQL := []string{
		`CREATE TEMP TABLE users (
			user_id UUID PRIMARY KEY,
			clerk_id VARCHAR(255) UNIQUE NOT NULL,
			status VARCHAR(20) NOT NULL DEFAULT 'active'
		) ON COMMIT DROP`,
		`CREATE TEMP TABLE workspaces (
			workspace_id UUID PRIMARY KEY,
			display_name VARCHAR(255) NOT NULL,
			default_operator_mode VARCHAR(30) NOT NULL DEFAULT 'seller',
			ai_credits_remaining NUMERIC(18,6) NOT NULL DEFAULT 50.000000,
			owner_user_id UUID NOT NULL,
			settings JSONB NOT NULL DEFAULT '{"brand_locked":true}',
			status VARCHAR(20) NOT NULL DEFAULT 'active',
			deleted_at TIMESTAMPTZ
		) ON COMMIT DROP`,
		`CREATE TEMP TABLE workspace_members (
			workspace_id UUID NOT NULL,
			user_id UUID NOT NULL,
			role VARCHAR(30) NOT NULL,
			status VARCHAR(20) NOT NULL DEFAULT 'active',
			UNIQUE(workspace_id, user_id)
		) ON COMMIT DROP`,
		`CREATE TEMP TABLE user_preferences (
			preference_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			user_id UUID NOT NULL,
			workspace_id UUID NOT NULL,
			onboarding_completed BOOLEAN NOT NULL DEFAULT false,
			onboarding_progress JSONB NOT NULL DEFAULT '{"completed_steps": []}',
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			UNIQUE(user_id, workspace_id)
		) ON COMMIT DROP`,
		`CREATE TEMP TABLE home_dashboard_config (
			config_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			workspace_id UUID NOT NULL UNIQUE,
			operator_mode VARCHAR(30) NOT NULL DEFAULT 'seller',
			onboarding_completed BOOLEAN NOT NULL DEFAULT false,
			onboarding_progress JSONB NOT NULL DEFAULT '{"step": 0, "completed_steps": []}'
		) ON COMMIT DROP`,
		`CREATE TEMP TABLE api_idempotency_records (
			idempotency_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			workspace_id UUID NOT NULL,
			actor_user_id UUID NOT NULL,
			idempotency_key VARCHAR(255) NOT NULL,
			rpc_name VARCHAR(120) NOT NULL,
			request_hash VARCHAR(64) NOT NULL,
			response_body JSONB NOT NULL,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			UNIQUE(workspace_id, actor_user_id, idempotency_key)
		) ON COMMIT DROP`,
		`INSERT INTO users (user_id, clerk_id, status) VALUES
			('019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a', 'user_owner1', 'active'),
			('019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1b', 'user_viewer2', 'active')`,
		`INSERT INTO workspaces (workspace_id, display_name, default_operator_mode, ai_credits_remaining, owner_user_id, settings, status) VALUES
			('019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1', 'Seller HQ', 'seller', 50.000000, '019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a', '{"brand_locked":true}', 'active')`,
		`INSERT INTO workspace_members (workspace_id, user_id, role, status) VALUES
			('019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1', '019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a', 'owner', 'active'),
			('019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1', '019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1b', 'viewer', 'active')`,
		`INSERT INTO user_preferences (user_id, workspace_id, onboarding_completed, onboarding_progress) VALUES
			('019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a', '019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1', false, '{"completed_steps": [1]}')`,
		`INSERT INTO home_dashboard_config (workspace_id, operator_mode, onboarding_completed, onboarding_progress) VALUES
			('019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1', 'seller', false, '{"step": 0, "completed_steps": []}')`,
	}
	for _, q := range setupSQL {
		if _, err := tx.ExecContext(ctx, q); err != nil {
			t.Fatalf("setup SQL failed: %v", err)
		}
	}

	resolver := Resolver{
		Tokens: multiUserTokenStub{
			tokens: map[string]Identity{
				"tok_viewer": {Subject: "user_viewer2", SessionID: "sess_viewer2"},
			},
		},
		Sessions: multiUserSessionStub{
			active: map[string]bool{
				"user_viewer2|sess_viewer2": true,
			},
		},
		Memberships: SQLMembershipLookup{Queries: tx},
	}

	verifier := fixedStepVerifier{
		steps: map[int]StepVerification{
			1: {Available: true, Verified: true},
			2: {Available: true, Verified: true},
			3: {Available: true, Verified: true},
			4: {Available: true, Verified: true},
			5: {Available: true, Verified: true},
		},
	}

	sqlStore := SQLOnboardingStore{DB: tx}
	coord := OnboardingCoordinator{
		Resolver:     resolver,
		StepVerifier: verifier,
		Store:        sqlStore,
	}

	for step := 1; step <= 5; step++ {
		res, err := coord.CompleteStep(ctx, "tok_viewer", testWorkspace, CompleteOnboardingCommand{
			IdempotencyKey: "pg-viewer-step-" + string(rune('0'+step)),
			WorkspaceID:    testWorkspace,
			CompletedStep:  step,
		})
		if err != nil {
			t.Fatalf("SQL CompleteStep(%d) failed: %v", step, err)
		}
		if step < 5 && res.Completed {
			t.Fatalf("step %d prematurely marked onboarding completed", step)
		}
		if step == 5 && (!res.Completed || !reflect.DeepEqual(res.CompletedSteps, []int{1, 2, 3, 4, 5})) {
			t.Fatalf("expected step 5 to complete viewer onboarding, got %+v", res)
		}
	}

	// Verify replay from PostgreSQL api_idempotency_records.
	replayRes, err := coord.CompleteStep(ctx, "tok_viewer", testWorkspace, CompleteOnboardingCommand{
		IdempotencyKey: "pg-viewer-step-5",
		WorkspaceID:    testWorkspace,
		CompletedStep:  5,
	})
	if err != nil || !replayRes.Replayed || !replayRes.Completed {
		t.Fatalf("expected PostgreSQL idempotent replay on step 5, got %+v, err=%v", replayRes, err)
	}

	// Verify owner's user_preferences row was NOT modified.
	ownerSteps, ownerDone, err := sqlStore.GetUserProgress(ctx, ownerUID, testWorkspace)
	if err != nil {
		t.Fatalf("GetUserProgress(owner) failed: %v", err)
	}
	if !reflect.DeepEqual(ownerSteps, []int{1}) || ownerDone {
		t.Fatalf("owner user_preferences mutated: steps=%v done=%v", ownerSteps, ownerDone)
	}

	// Verify viewer's user_preferences row has all 5 steps and onboarding_completed=true.
	viewerSteps, viewerDone, err := sqlStore.GetUserProgress(ctx, viewerUID, testWorkspace)
	if err != nil {
		t.Fatalf("GetUserProgress(viewer) failed: %v", err)
	}
	if !reflect.DeepEqual(viewerSteps, []int{1, 2, 3, 4, 5}) || !viewerDone {
		t.Fatalf("unexpected viewer user_preferences: steps=%v done=%v", viewerSteps, viewerDone)
	}

	// Verify workspaces row and home_dashboard_config row were NOT modified.
	var wsName, wsMode, wsCredits, wsSettings string
	if err := tx.QueryRowContext(
		ctx,
		`SELECT display_name, default_operator_mode, ai_credits_remaining::text, settings::text FROM workspaces WHERE workspace_id = $1::uuid`,
		testWorkspace,
	).Scan(&wsName, &wsMode, &wsCredits, &wsSettings); err != nil {
		t.Fatalf("query workspaces failed: %v", err)
	}
	var settingsMap map[string]bool
	if err := json.Unmarshal([]byte(wsSettings), &settingsMap); err != nil || !settingsMap["brand_locked"] {
		t.Fatalf("workspaces.settings was mutated: %s", wsSettings)
	}
	if wsName != "Seller HQ" || wsMode != "seller" || wsCredits != "50.000000" {
		t.Fatalf("workspaces row was mutated: name=%q mode=%q credits=%q", wsName, wsMode, wsCredits)
	}

	var hdcCompleted bool
	var hdcMode string
	if err := tx.QueryRowContext(
		ctx,
		`SELECT operator_mode, onboarding_completed FROM home_dashboard_config WHERE workspace_id = $1::uuid`,
		testWorkspace,
	).Scan(&hdcMode, &hdcCompleted); err != nil {
		t.Fatalf("query home_dashboard_config failed: %v", err)
	}
	if hdcMode != "seller" || hdcCompleted {
		t.Fatalf("home_dashboard_config was mutated: mode=%q completed=%v", hdcMode, hdcCompleted)
	}
}
