package diagnostics

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"fmt"
	"net/url"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/outbox"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

const (
	diagTestWorkspaceA = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
	diagTestWorkspaceB = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb"
	diagTestAdminUser  = "11111111-1111-4111-8111-111111111111"
	diagTestViewerUser = "22222222-2222-4222-8222-222222222222"
	diagTestIssueID    = "d1111111-1111-4111-8111-111111111111"
	diagTestEffectID   = "e1111111-1111-4111-8111-111111111111"
	diagTestAggID      = "a1111111-1111-4111-8111-111111111111"
)

func loadCanonicalRBAC(t *testing.T) *rbac.Registry {
	t.Helper()
	repoRoot := filepath.Join("..", "..", "..", "..")
	reg, err := rbac.LoadCanonicalBindings(repoRoot)
	if err != nil {
		t.Fatalf("LoadCanonicalBindings(%q) failed: %v", repoRoot, err)
	}
	return reg
}

func TestDiagnosticsServiceRBACAndCrossTenantIsolation(t *testing.T) {
	reg := loadCanonicalRBAC(t)
	svc := NewService(reg, nil, nil)

	// 1. Unauthenticated caller denied.
	_, err := svc.GetOverview(context.Background(), connect.NewRequest(&adminv1.GetOverviewRequest{}))
	if connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated, got %v", err)
	}

	// 2. Viewer role denied on diagnostics:read and workspace:settings:manage.
	viewerCtx := WithActorContext(context.Background(), ActorContext{
		UserID:           diagTestViewerUser,
		WorkspaceID:      diagTestWorkspaceA,
		WorkspaceRole:    rbac.RoleViewer,
		WorkspaceActive:  true,
		MembershipActive: true,
	})
	if _, err := svc.GetOverview(viewerCtx, connect.NewRequest(&adminv1.GetOverviewRequest{})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected Viewer denied on GetOverview, got %v", err)
	}
	if _, err := svc.RunFullCheck(viewerCtx, connect.NewRequest(&adminv1.RunFullCheckRequest{
		Context: &commonv1.CommandContext{IdempotencyKey: "idem_viewer_1"},
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected Viewer denied on RunFullCheck, got %v", err)
	}

	// 3. Admin role permitted for own workspace, denied for foreign workspace_id.
	adminCtx := WithActorContext(context.Background(), ActorContext{
		UserID:           diagTestAdminUser,
		WorkspaceID:      diagTestWorkspaceA,
		WorkspaceRole:    rbac.RoleAdmin,
		WorkspaceActive:  true,
		MembershipActive: true,
	})
	if _, err := svc.GetOverview(adminCtx, connect.NewRequest(&adminv1.GetOverviewRequest{
		WorkspaceId: &commonv1.UUID{Value: diagTestWorkspaceB},
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected cross-tenant WorkspaceId request denied, got %v", err)
	}
}

func TestRuleM23A04SanitizationAndRepairWizardReconcilesUnknownExternalEffect(t *testing.T) {
	reg := loadCanonicalRBAC(t)
	guard := outbox.NewExternalEffectGuard()
	dlq := outbox.NewDLQManager(guard)
	svc := NewService(reg, guard, dlq)

	now := time.Date(2026, 11, 2, 6, 30, 0, 0, time.UTC)
	svc.Now = func() time.Time { return now }

	adminCtx := WithActorContext(context.Background(), ActorContext{
		UserID:           diagTestAdminUser,
		WorkspaceID:      diagTestWorkspaceA,
		WorkspaceRole:    rbac.RoleAdmin,
		WorkspaceActive:  true,
		MembershipActive: true,
	})

	// Create an 'unknown' external effect via timeout.
	const opKey = "publish:tiktok:post_001"
	if _, _, err := guard.BeginExecution(adminCtx, outbox.BeginEffectRequest{
		EffectID:      diagTestEffectID,
		WorkspaceID:   diagTestWorkspaceA,
		OperationKey:  opKey,
		Provider:      "tiktok",
		AggregateType: "publish_job",
		AggregateID:   diagTestAggID,
		Now:           now,
	}); err != nil {
		t.Fatal(err)
	}
	if _, err := guard.MarkSubmitted(adminCtx, diagTestWorkspaceA, opKey, "tt_req_123", now); err != nil {
		t.Fatal(err)
	}
	_, diagRow, err := guard.MarkUnknownOnTimeout(adminCtx, diagTestWorkspaceA, opKey, diagTestIssueID, "timeout", now)
	if err != nil {
		t.Fatal(err)
	}

	// Inject raw SQL into UserFacingExplanation to verify RULE-M23-A04 strips it before exposing to users!
	diagRow.UserFacingExplanation = "SELECT * FROM connected_accounts WHERE access_token = 'secret'"
	if _, err := svc.SeedIssue(adminCtx, diagRow); err != nil {
		t.Fatal(err)
	}

	listResp, err := svc.ListIssues(adminCtx, connect.NewRequest(&adminv1.ListIssuesRequest{}))
	if err != nil {
		t.Fatalf("ListIssues failed: %v", err)
	}
	if len(listResp.Msg.GetIssues()) != 1 {
		t.Fatalf("expected 1 issue, got %d", len(listResp.Msg.GetIssues()))
	}
	iss := listResp.Msg.GetIssues()[0]
	if strings.Contains(strings.ToLower(iss.GetUserFacingExplanation()), "select ") ||
		strings.Contains(strings.ToLower(iss.GetUserFacingExplanation()), "access_token") {
		t.Fatalf("RULE-M23-A04 VIOLATION: raw SQL or token leaked in user_facing_explanation: %q", iss.GetUserFacingExplanation())
	}
	if !iss.GetRequiresManualReconciliation() {
		t.Fatalf("expected RequiresManualReconciliation=true for unknown external effect issue")
	}

	// Check GetOverview & GetHealthGrid reflect the unknown external effect.
	ovResp, err := svc.GetOverview(adminCtx, connect.NewRequest(&adminv1.GetOverviewRequest{}))
	if err != nil {
		t.Fatal(err)
	}
	if ovResp.Msg.GetUnknownExternalEffectsCount() != 1 || ovResp.Msg.GetActiveIssuesCount() != 1 {
		t.Fatalf("expected 1 unknown effect and 1 active issue, got %+v", ovResp.Msg)
	}

	gridResp, err := svc.GetHealthGrid(adminCtx, connect.NewRequest(&adminv1.GetHealthGridRequest{}))
	if err != nil || len(gridResp.Msg.GetCategories()) != 8 {
		t.Fatalf("expected 8 categories in health grid, got %v (err=%v)", len(gridResp.Msg.GetCategories()), err)
	}

	// Execute 4-step Guided Repair Wizard:
	// Step 1: VERIFY
	step1, err := svc.ExecuteRepairStep(adminCtx, connect.NewRequest(&adminv1.ExecuteRepairStepRequest{
		Context:       &commonv1.CommandContext{IdempotencyKey: "wiz_step_1"},
		DiagnosticsId: &commonv1.UUID{Value: diagTestIssueID},
		Step:          adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_VERIFY,
	}))
	if err != nil || step1.Msg.GetNextStep() != adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_DIAGNOSE {
		t.Fatalf("Step 1 VERIFY failed: %+v err=%v", step1, err)
	}

	// Step 2: DIAGNOSE
	step2, err := svc.ExecuteRepairStep(adminCtx, connect.NewRequest(&adminv1.ExecuteRepairStepRequest{
		Context:       &commonv1.CommandContext{IdempotencyKey: "wiz_step_2"},
		DiagnosticsId: &commonv1.UUID{Value: diagTestIssueID},
		Step:          adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_DIAGNOSE,
	}))
	if err != nil || step2.Msg.GetNextStep() != adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_FIX {
		t.Fatalf("Step 2 DIAGNOSE failed: %+v err=%v", step2, err)
	}

	// Step 3: FIX WITHOUT verification_reference must fail with CodeFailedPrecondition!
	_, err = svc.ExecuteRepairStep(adminCtx, connect.NewRequest(&adminv1.ExecuteRepairStepRequest{
		Context:       &commonv1.CommandContext{IdempotencyKey: "wiz_step_3_missing_ref"},
		DiagnosticsId: &commonv1.UUID{Value: diagTestIssueID},
		Step:          adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_FIX,
	}))
	if connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected CodeFailedPrecondition when verification_reference is missing on unknown effect, got %v", err)
	}

	// Step 3: FIX WITH verification_reference reconciles the unknown external effect!
	step3, err := svc.ExecuteRepairStep(adminCtx, connect.NewRequest(&adminv1.ExecuteRepairStepRequest{
		Context:               &commonv1.CommandContext{IdempotencyKey: "wiz_step_3_ok"},
		DiagnosticsId:         &commonv1.UUID{Value: diagTestIssueID},
		Step:                  adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_FIX,
		ActionKey:             "confirm_succeeded",
		VerificationReference: "tiktok_post_verified_id_998877",
	}))
	if err != nil || step3.Msg.GetNextStep() != adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_CONFIRM {
		t.Fatalf("Step 3 FIX with proof failed: %+v err=%v", step3, err)
	}
	if guard.CountUnknownEffects(diagTestWorkspaceA) != 0 {
		t.Fatalf("expected 0 unknown external effects after Step 3 reconciliation")
	}

	// Step 4: CONFIRM resolves the issue!
	step4, err := svc.ExecuteRepairStep(adminCtx, connect.NewRequest(&adminv1.ExecuteRepairStepRequest{
		Context:       &commonv1.CommandContext{IdempotencyKey: "wiz_step_4"},
		DiagnosticsId: &commonv1.UUID{Value: diagTestIssueID},
		Step:          adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_CONFIRM,
	}))
	if err != nil || !step4.Msg.GetResolved() || step4.Msg.GetIssueStatus() != adminv1.DiagnosticIssueStatus_DIAGNOSTIC_ISSUE_STATUS_RESOLVED {
		t.Fatalf("Step 4 CONFIRM failed: %+v err=%v", step4, err)
	}

	// Idempotent replay of Step 4 returns Replayed=true; conflicting payload with same key returns CodeAborted!
	replay4, err := svc.ExecuteRepairStep(adminCtx, connect.NewRequest(&adminv1.ExecuteRepairStepRequest{
		Context:       &commonv1.CommandContext{IdempotencyKey: "wiz_step_4"},
		DiagnosticsId: &commonv1.UUID{Value: diagTestIssueID},
		Step:          adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_CONFIRM,
	}))
	if err != nil || !replay4.Msg.GetReplayed() {
		t.Fatalf("expected idempotent replay Replayed=true, got %+v err=%v", replay4, err)
	}
	_, err = svc.ExecuteRepairStep(adminCtx, connect.NewRequest(&adminv1.ExecuteRepairStepRequest{
		Context:       &commonv1.CommandContext{IdempotencyKey: "wiz_step_4"},
		DiagnosticsId: &commonv1.UUID{Value: diagTestIssueID},
		Step:          adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_VERIFY,
	}))
	if connect.CodeOf(err) != connect.CodeAborted {
		t.Fatalf("expected CodeAborted on idempotency conflict, got %v", err)
	}
}

type failingBeginner struct {
	err error
}

func (f failingBeginner) Begin(_ context.Context) (pgx.Tx, error) {
	return nil, f.err
}

func TestDiagnosticsServiceFailsClosedWhenDatabaseUnavailable(t *testing.T) {
	reg := loadCanonicalRBAC(t)
	svc := NewService(reg, nil, nil)
	svc.Beginner = failingBeginner{err: errors.New("simulated database outage")}

	adminCtx := WithActorContext(context.Background(), ActorContext{
		UserID:           diagTestAdminUser,
		WorkspaceID:      diagTestWorkspaceA,
		WorkspaceRole:    rbac.RoleAdmin,
		WorkspaceActive:  true,
		MembershipActive: true,
	})

	if _, err := svc.GetOverview(adminCtx, connect.NewRequest(&adminv1.GetOverviewRequest{})); connect.CodeOf(err) != connect.CodeUnavailable {
		t.Fatalf("expected GetOverview to fail closed with CodeUnavailable when DB fails, got %v", err)
	}
	if _, err := svc.GetHealthGrid(adminCtx, connect.NewRequest(&adminv1.GetHealthGridRequest{})); connect.CodeOf(err) != connect.CodeUnavailable {
		t.Fatalf("expected GetHealthGrid to fail closed with CodeUnavailable when DB fails, got %v", err)
	}
	if _, err := svc.ListIssues(adminCtx, connect.NewRequest(&adminv1.ListIssuesRequest{})); connect.CodeOf(err) != connect.CodeUnavailable {
		t.Fatalf("expected ListIssues to fail closed with CodeUnavailable when DB fails, got %v", err)
	}
	if _, err := svc.RunFullCheck(adminCtx, connect.NewRequest(&adminv1.RunFullCheckRequest{
		Context: &commonv1.CommandContext{IdempotencyKey: "idem_db_down_check"},
	})); connect.CodeOf(err) != connect.CodeUnavailable {
		t.Fatalf("expected RunFullCheck to fail closed with CodeUnavailable when DB fails, got %v", err)
	}
	if _, err := svc.ExecuteRepairStep(adminCtx, connect.NewRequest(&adminv1.ExecuteRepairStepRequest{
		Context:       &commonv1.CommandContext{IdempotencyKey: "idem_db_down_repair"},
		DiagnosticsId: &commonv1.UUID{Value: diagTestIssueID},
		Step:          adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_VERIFY,
	})); connect.CodeOf(err) != connect.CodeUnavailable {
		t.Fatalf("expected ExecuteRepairStep to fail closed with CodeUnavailable when DB fails, got %v", err)
	}
}

type appUserRoleBeginner struct {
	pool *pgxpool.Pool
}

func (b appUserRoleBeginner) Begin(ctx context.Context) (pgx.Tx, error) {
	tx, err := b.pool.Begin(ctx)
	if err != nil {
		return nil, err
	}
	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		_ = tx.Rollback(ctx)
		return nil, err
	}
	return tx, nil
}

func TestPostgresBackedDiagnosticsServiceReadsAndReconcilesDurableRecords(t *testing.T) {
	baseDSN := strings.TrimSpace(os.Getenv("CREATIVANTA_TEST_DATABASE_URL"))
	if baseDSN == "" {
		baseDSN = strings.TrimSpace(os.Getenv("CREATIVANTA_TEST_POSTGRES_DSN"))
	}
	if baseDSN == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; skipping live PostgreSQL diagnostics integration test")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	var randBytes [6]byte
	_, _ = rand.Read(randBytes[:])
	dbName := fmt.Sprintf("creativanta_diag_test_%d_%s", time.Now().UnixNano(), hex.EncodeToString(randBytes[:]))

	adminPool, err := pgxpool.New(ctx, baseDSN)
	if err != nil {
		t.Fatalf("connect admin pool: %v", err)
	}
	if _, err := adminPool.Exec(ctx, fmt.Sprintf("CREATE DATABASE %s", dbName)); err != nil {
		adminPool.Close()
		t.Fatalf("create disposable database %s: %v", dbName, err)
	}
	parsedURL, err := url.Parse(baseDSN)
	if err != nil {
		adminPool.Close()
		t.Fatalf("parse base DSN: %v", err)
	}
	parsedURL.Path = "/" + dbName
	disposableDSN := parsedURL.String()

	pool, err := pgxpool.New(ctx, disposableDSN)
	if err != nil {
		_, _ = adminPool.Exec(ctx, fmt.Sprintf("DROP DATABASE IF EXISTS %s WITH (FORCE)", dbName))
		adminPool.Close()
		t.Fatalf("connect disposable DB: %v", err)
	}
	t.Cleanup(func() {
		pool.Close()
		cleanCtx, cleanCancel := context.WithTimeout(context.Background(), 15*time.Second)
		defer cleanCancel()
		_, _ = adminPool.Exec(cleanCtx, fmt.Sprintf("DROP DATABASE IF EXISTS %s WITH (FORCE)", dbName))
		adminPool.Close()
	})

	migrationsDir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, pool, migrationsDir); err != nil {
		t.Fatalf("migrate.Up failed: %v", err)
	}

	seedSQL := fmt.Sprintf(`
		INSERT INTO users (user_id, clerk_id, email, display_name, status)
		VALUES
			('%s'::uuid, 'clerk_diag_admin', 'diag_admin@example.com', 'Diag Admin', 'active'),
			('%s'::uuid, 'clerk_diag_other', 'diag_other@example.com', 'Other Owner', 'active');

		INSERT INTO workspaces (
			workspace_id, name, slug, owner_user_id, subscription_tier,
			default_mode, enabled_modes, locale, timezone, status
		)
		VALUES
			('%s'::uuid, 'Diag Workspace A', 'diag-ws-a', '%s'::uuid, 'pro', 'seller'::operator_mode, ARRAY['seller']::operator_mode[], 'vi-VN', 'Asia/Ho_Chi_Minh', 'active'),
			('%s'::uuid, 'Diag Workspace B', 'diag-ws-b', '%s'::uuid, 'free', 'creator'::operator_mode, ARRAY['creator']::operator_mode[], 'en-US', 'UTC', 'active');

		INSERT INTO workspace_members (workspace_id, user_id, role, status)
		VALUES
			('%s'::uuid, '%s'::uuid, 'owner', 'active'),
			('%s'::uuid, '%s'::uuid, 'owner', 'active');
	`,
		diagTestAdminUser, diagTestViewerUser,
		diagTestWorkspaceA, diagTestAdminUser,
		diagTestWorkspaceB, diagTestViewerUser,
		diagTestWorkspaceA, diagTestAdminUser,
		diagTestWorkspaceB, diagTestViewerUser,
	)
	if _, err := pool.Exec(ctx, seedSQL); err != nil {
		t.Fatalf("seed workspace fixtures: %v", err)
	}

	beginner := appUserRoleBeginner{pool: pool}
	const opKey = "publish:shopee:order_sync_001"
	const dlqID = "f1111111-1111-4111-8111-111111111111"

	// Insert an unknown external_effect, a pending DLQ entry, and an open diagnostic_record directly into PostgreSQL
	// (simulating worker process output without touching any in-memory maps on DiagnosticsService).
	err = tenantdb.WithTx(ctx, beginner, tenantdb.Scope{
		WorkspaceID:             diagTestWorkspaceA,
		UserID:                  diagTestAdminUser,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		if _, err := q.InsertPreparedExternalEffect(txCtx, tenantdb.PrepareExternalEffectParams{
			EffectID:      diagTestEffectID,
			WorkspaceID:   diagTestWorkspaceA,
			OperationKey:  opKey,
			Provider:      "shopee",
			AggregateType: "publish_job",
			AggregateID:   diagTestAggID,
		}); err != nil {
			return err
		}
		if _, err := q.UpdateExternalEffectStatus(txCtx, tenantdb.UpdateExternalEffectStatusParams{
			WorkspaceID:       diagTestWorkspaceA,
			OperationKey:      opKey,
			Status:            "unknown",
			ProviderRequestID: "shopee_req_timeout_1",
			ResultPayload:     []byte(`{"error":"timeout waiting for shopee ack"}`),
		}); err != nil {
			return err
		}
		_, err := q.InsertDiagnosticRecord(txCtx, tenantdb.InsertDiagnosticRecordParams{
			DiagnosticsID:         diagTestIssueID,
			WorkspaceID:           diagTestWorkspaceA,
			ScopeType:             "publish_job",
			ScopeID:               diagTestAggID,
			ErrorType:             "external_effect_outcome_unknown",
			Severity:              "error",
			UserFacingExplanation: "SELECT * FROM connected_accounts WHERE access_token = 'leaked_secret'",
			OperatorExplanation:   "Shopee publish timeout left external_effect in unknown state",
			LikelyCauses:          []string{"Timeout kết nối đối tác Shopee"},
			SuggestedActions:      []string{"Đối chiếu mã vận đơn/đăng bài trên Shopee trước khi xác nhận"},
			RepairPath:            "reconcile_external_effect:" + opKey,
			Status:                "open",
		})
		return err
	})
	if err != nil {
		t.Fatalf("insert durable diagnostic/effect fixtures in PostgreSQL: %v", err)
	}

	if _, err := pool.Exec(ctx, `
		INSERT INTO dead_letter_queue (
			dlq_id, queue_name, original_message_id, payload, error_class,
			error_message, last_error_at, attempt_count, workspace_id, status
		) VALUES (
			$1::uuid, 'q.publish.jobs', $3, '{"job":1}'::jsonb, 'provider_timeout',
			'max retries exceeded', NOW(), 5, $2::uuid, 'pending'
		)
	`, dlqID, diagTestWorkspaceA, diagTestAggID); err != nil {
		t.Fatalf("insert DLQ row: %v", err)
	}

	// Construct a brand-new DiagnosticsService instance with empty in-memory maps wired to PostgreSQL.
	reg := loadCanonicalRBAC(t)
	svc := NewService(reg, nil, nil)
	svc.Beginner = beginner

	adminCtx := WithActorContext(ctx, ActorContext{
		UserID:           diagTestAdminUser,
		WorkspaceID:      diagTestWorkspaceA,
		WorkspaceRole:    rbac.RoleAdmin,
		WorkspaceActive:  true,
		MembershipActive: true,
	})

	// 1. GetOverview must read active issues, unknown external_effects, and pending DLQ counts from PostgreSQL.
	ovResp, err := svc.GetOverview(adminCtx, connect.NewRequest(&adminv1.GetOverviewRequest{}))
	if err != nil {
		t.Fatalf("GetOverview from PostgreSQL failed: %v", err)
	}
	if ovResp.Msg.GetActiveIssuesCount() != 1 ||
		ovResp.Msg.GetCriticalIssuesCount() != 1 ||
		ovResp.Msg.GetUnknownExternalEffectsCount() != 1 ||
		ovResp.Msg.GetPendingDlqCount() != 1 ||
		ovResp.Msg.GetOverallStatus() != adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_CRITICAL {
		t.Fatalf("unexpected GetOverview from PostgreSQL: %+v", ovResp.Msg)
	}

	// 2. ListIssues must read the durable issue from PostgreSQL and sanitize RULE-M23-A04 text.
	listResp, err := svc.ListIssues(adminCtx, connect.NewRequest(&adminv1.ListIssuesRequest{}))
	if err != nil {
		t.Fatalf("ListIssues from PostgreSQL failed: %v", err)
	}
	if len(listResp.Msg.GetIssues()) != 1 {
		t.Fatalf("expected 1 issue from PostgreSQL, got %d", len(listResp.Msg.GetIssues()))
	}
	if strings.Contains(strings.ToLower(listResp.Msg.GetIssues()[0].GetUserFacingExplanation()), "access_token") {
		t.Fatalf("RULE-M23-A04 sanitization failed on PostgreSQL issue: %q", listResp.Msg.GetIssues()[0].GetUserFacingExplanation())
	}

	// 3. RunFullCheck must reflect PostgreSQL state and write an audit_events record in PostgreSQL.
	fullCheckResp, err := svc.RunFullCheck(adminCtx, connect.NewRequest(&adminv1.RunFullCheckRequest{
		Context: &commonv1.CommandContext{
			IdempotencyKey: "pg_full_check_1",
			Reason:         "verify durable diagnostics state",
		},
	}))
	if err != nil {
		t.Fatalf("RunFullCheck against PostgreSQL failed: %v", err)
	}
	if fullCheckResp.Msg.GetIssuesDetected() < 1 || fullCheckResp.Msg.GetUnknownEffectsDetected() != 1 {
		t.Fatalf("unexpected RunFullCheck response from PostgreSQL: %+v", fullCheckResp.Msg)
	}

	// 4. ExecuteRepairStep on a fresh service instance (simulating stateless multi-instance API)
	//    must reconcile the unknown external_effect in PostgreSQL and resolve the diagnostics_records row!
	svc2 := NewService(reg, nil, nil)
	svc2.Beginner = beginner

	if _, err := svc2.ExecuteRepairStep(adminCtx, connect.NewRequest(&adminv1.ExecuteRepairStepRequest{
		Context:       &commonv1.CommandContext{IdempotencyKey: "pg_wiz_1"},
		DiagnosticsId: &commonv1.UUID{Value: diagTestIssueID},
		Step:          adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_VERIFY,
	})); err != nil {
		t.Fatalf("PostgreSQL ExecuteRepairStep VERIFY failed: %v", err)
	}
	if _, err := svc2.ExecuteRepairStep(adminCtx, connect.NewRequest(&adminv1.ExecuteRepairStepRequest{
		Context:               &commonv1.CommandContext{IdempotencyKey: "pg_wiz_3"},
		DiagnosticsId:         &commonv1.UUID{Value: diagTestIssueID},
		Step:                  adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_FIX,
		ActionKey:             "confirm_succeeded",
		VerificationReference: "shopee_verified_receipt_889900",
	})); err != nil {
		t.Fatalf("PostgreSQL ExecuteRepairStep FIX failed: %v", err)
	}
	step4, err := svc2.ExecuteRepairStep(adminCtx, connect.NewRequest(&adminv1.ExecuteRepairStepRequest{
		Context:       &commonv1.CommandContext{IdempotencyKey: "pg_wiz_4"},
		DiagnosticsId: &commonv1.UUID{Value: diagTestIssueID},
		Step:          adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_CONFIRM,
	}))
	if err != nil || !step4.Msg.GetResolved() {
		t.Fatalf("PostgreSQL ExecuteRepairStep CONFIRM failed: resp=%+v err=%v", step4, err)
	}

	// Verify PostgreSQL external_effects status is now 'succeeded' and diagnostics_records status is 'resolved'.
	var effectStatus, diagStatus string
	if err := pool.QueryRow(ctx, `SELECT status FROM external_effects WHERE workspace_id = $1::uuid AND operation_key = $2`, diagTestWorkspaceA, opKey).Scan(&effectStatus); err != nil {
		t.Fatalf("query reconciled external_effects: %v", err)
	}
	if effectStatus != "succeeded" {
		t.Fatalf("expected external_effects status='succeeded' in PostgreSQL after repair wizard, got %q", effectStatus)
	}
	if err := pool.QueryRow(ctx, `SELECT status FROM diagnostics_records WHERE workspace_id = $1::uuid AND diagnostics_id = $2::uuid`, diagTestWorkspaceA, diagTestIssueID).Scan(&diagStatus); err != nil {
		t.Fatalf("query resolved diagnostics_records: %v", err)
	}
	if diagStatus != "resolved" {
		t.Fatalf("expected diagnostics_records status='resolved' in PostgreSQL after repair wizard, got %q", diagStatus)
	}
}
