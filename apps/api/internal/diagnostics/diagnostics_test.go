package diagnostics

import (
	"context"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/outbox"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
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
