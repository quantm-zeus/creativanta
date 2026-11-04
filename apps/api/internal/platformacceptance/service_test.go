package platformacceptance

import (
	"context"
	"errors"
	"os"
	"path/filepath"
	"testing"
)

func findBuildRoot() string {
	// Try standard relative paths from internal/platformacceptance
	candidates := []string{
		filepath.Join("..", "..", "..", "..", "build"),
		filepath.Join("..", "..", "..", "build"),
		filepath.Join("..", "..", "build"),
		"build",
	}
	for _, c := range candidates {
		if fi, err := os.Stat(c); err == nil && fi.IsDir() {
			return c
		}
	}
	return "../../../../build"
}

func TestFullScopeReconciliation_All31ModulesAndSixModes(t *testing.T) {
	svc := NewService(findBuildRoot())
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:        "admin-usr-1",
		WorkspaceID:   "ws-1",
		WorkspaceRole: "owner",
	})

	report, err := svc.ReconcileFullScope(ctx, ReconcileFullScopeRequest{
		Environment:             "local",
		ReleaseCandidateVersion: "v1.0.0-rc.p8.09",
	})
	if err != nil {
		t.Fatalf("ReconcileFullScope failed: %v", err)
	}

	// 1. Verify 31 modules
	if report.TotalModules != 31 {
		t.Fatalf("expected 31 modules, got %d", report.TotalModules)
	}
	if len(report.Modules) != 31 {
		t.Fatalf("expected 31 module results, got %d", len(report.Modules))
	}
	domainMap := make(map[string]int)
	for _, m := range report.Modules {
		if !m.Verified {
			t.Errorf("module %s is not verified", m.ModuleID)
		}
		domainMap[m.Domain]++
	}
	expectedDomains := []string{"platform", "intelligence", "content", "production", "publish", "engagement", "commerce", "finance", "automation"}
	for _, d := range expectedDomains {
		if domainMap[d] == 0 {
			t.Errorf("expected domain %s to be represented among 31 modules, but got 0", d)
		}
	}

	// 2. Verify 6 operator modes
	if report.TotalOperatorModes != 6 {
		t.Fatalf("expected 6 operator modes, got %d", report.TotalOperatorModes)
	}
	if len(report.OperatorModes) != 6 {
		t.Fatalf("expected 6 mode results, got %d", len(report.OperatorModes))
	}
	for _, m := range report.OperatorModes {
		if !m.Verified {
			t.Errorf("mode %s is not verified", m.ModeID)
		}
		if m.DecisionCardCount <= 0 {
			t.Errorf("mode %s has invalid card count: %d", m.ModeID, m.DecisionCardCount)
		}
		if len(m.AvailableRoutes) == 0 {
			t.Errorf("mode %s has no available routes", m.ModeID)
		}
	}

	// 3. Invariants
	if report.TotalRequirementUnits < 1333 {
		t.Errorf("expected >= 1333 requirement units, got %d", report.TotalRequirementUnits)
	}
	if report.TotalScreenAssignments < 245 {
		t.Errorf("expected >= 245 screen assignments, got %d", report.TotalScreenAssignments)
	}
	if report.TotalRpcBindings < 1188 {
		t.Errorf("expected >= 1188 rpc bindings, got %d", report.TotalRpcBindings)
	}
	if report.TotalTenantTables < 140 {
		t.Errorf("expected >= 140 tenant tables, got %d", report.TotalTenantTables)
	}
	if len(report.IntegritySha256) != 64 {
		t.Errorf("expected 64-char sha256 digest, got %q", report.IntegritySha256)
	}
}

func TestFullScopeReconciliation_AllTasksAndManifests(t *testing.T) {
	svc := NewService(findBuildRoot())
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:    "internal-admin-1",
		IsAdmin:   true,
		AdminRole: "super_admin",
	})

	report, err := svc.ReconcileFullScope(ctx, ReconcileFullScopeRequest{})
	if err != nil {
		t.Fatalf("ReconcileFullScope failed: %v", err)
	}

	if !report.AllManifestsVerified {
		t.Fatalf("expected all previous manifests verified, got false")
	}
	if len(report.TaskManifests) < 59 {
		t.Fatalf("expected at least 59 task manifests scanned, got %d", len(report.TaskManifests))
	}

	// Verify task ID presence across phases
	taskIDs := make(map[string]bool)
	for _, tsk := range report.TaskManifests {
		taskIDs[tsk.TaskID] = true
	}
	requiredKeyTasks := []string{"P0-01", "P0-09", "P1-05", "P2-04", "P3-05", "P4-09", "P5-05", "P6-09", "P7-05", "P8-01", "P8-08"}
	for _, req := range requiredKeyTasks {
		if !taskIDs[req] {
			t.Errorf("missing manifest scan for critical milestone task %s", req)
		}
	}
}

func TestReleaseDecision_UnmetExternalGatesEnforced(t *testing.T) {
	svc := NewService(findBuildRoot())
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:    "auditor-1",
		IsAdmin:   true,
		AdminRole: "auditor",
	})

	report, err := svc.ReconcileFullScope(ctx, ReconcileFullScopeRequest{
		Environment: "local",
	})
	if err != nil {
		t.Fatalf("ReconcileFullScope failed: %v", err)
	}

	// Must be CONDITIONAL_READY_LOCAL, NEVER LAUNCH_APPROVED
	if report.ReleaseDecision != DecisionConditionalReadyLocal {
		t.Fatalf("expected decision %s, got %s", DecisionConditionalReadyLocal, report.ReleaseDecision)
	}
	if report.ProductionLaunchApproved {
		t.Fatalf("productionLaunchApproved must be false when external gates remain open")
	}
	if report.UnmetExternalGatesCount <= 0 {
		t.Fatalf("expected unmet external gates count > 0, got %d", report.UnmetExternalGatesCount)
	}

	// Verify specific canonical gates are tracked
	gateIDs := make(map[string]bool)
	for _, g := range report.ExternalGates {
		gateIDs[g.GateID] = true
	}
	if !gateIDs["LEG-H-001"] {
		t.Errorf("missing mandatory external gate LEG-H-001")
	}
	if !gateIDs["EXT-GATE-LIVE-PROVIDER-AND-CONNECTOR-VERIFICATION"] {
		t.Errorf("missing mandatory external gate EXT-GATE-LIVE-PROVIDER-AND-CONNECTOR-VERIFICATION")
	}
	if !gateIDs["EXT-GATE-STAGING-LOAD-AND-DR-REHEARSAL"] {
		t.Errorf("missing mandatory external gate EXT-GATE-STAGING-LOAD-AND-DR-REHEARSAL")
	}
}

func TestReleaseDecision_FakeLaunchClaimFailsClosed(t *testing.T) {
	svc := NewService(findBuildRoot())
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:    "admin-usr-1",
		IsAdmin:   true,
		AdminRole: "super_admin",
	})

	// Asserting production launch without satisfying external gates must fail closed
	_, err := svc.ReconcileFullScope(ctx, ReconcileFullScopeRequest{
		Environment:            "production",
		AssertProductionLaunch: true,
	})
	if err == nil {
		t.Fatalf("expected ErrExternalGatesUnsatisfied when AssertProductionLaunch=true and gates unmet, got nil")
	}
	if !errors.Is(err, ErrExternalGatesUnsatisfied) {
		t.Fatalf("expected error wrapping ErrExternalGatesUnsatisfied, got: %v", err)
	}
}

func TestRBACPermissionChecks(t *testing.T) {
	svc := NewService(findBuildRoot())

	// 1. Unauthenticated request
	_, err := svc.ReconcileFullScope(context.Background(), ReconcileFullScopeRequest{})
	if !errors.Is(err, ErrUnauthenticated) {
		t.Errorf("expected ErrUnauthenticated for missing context, got: %v", err)
	}

	// 2. Viewer role denied
	ctxViewer := WithCallerContext(context.Background(), CallerContext{
		UserID:        "user-viewer",
		WorkspaceID:   "ws-1",
		WorkspaceRole: "viewer",
	})
	_, err = svc.ReconcileFullScope(ctxViewer, ReconcileFullScopeRequest{})
	if !errors.Is(err, ErrPermissionDenied) {
		t.Errorf("expected ErrPermissionDenied for viewer role, got: %v", err)
	}

	// 3. Contributor role denied
	ctxContrib := WithCallerContext(context.Background(), CallerContext{
		UserID:        "user-contrib",
		WorkspaceID:   "ws-1",
		WorkspaceRole: "contributor",
	})
	_, err = svc.ReconcileFullScope(ctxContrib, ReconcileFullScopeRequest{})
	if !errors.Is(err, ErrPermissionDenied) {
		t.Errorf("expected ErrPermissionDenied for contributor role, got: %v", err)
	}

	// 4. Unauthorized internal admin role denied (e.g. content_admin)
	ctxContentAdmin := WithCallerContext(context.Background(), CallerContext{
		UserID:    "admin-content",
		IsAdmin:   true,
		AdminRole: "content_admin",
	})
	_, err = svc.ReconcileFullScope(ctxContentAdmin, ReconcileFullScopeRequest{})
	if !errors.Is(err, ErrPermissionDenied) {
		t.Errorf("expected ErrPermissionDenied for content_admin, got: %v", err)
	}

	// 5. Manager role allowed
	ctxManager := WithCallerContext(context.Background(), CallerContext{
		UserID:        "user-mgr",
		WorkspaceID:   "ws-1",
		WorkspaceRole: "manager",
	})
	_, err = svc.ReconcileFullScope(ctxManager, ReconcileFullScopeRequest{})
	if err != nil {
		t.Errorf("expected manager to be permitted, got error: %v", err)
	}
}

func TestWorkspaceAcceptanceSignoff(t *testing.T) {
	svc := NewService(findBuildRoot())
	ctxOwner := WithCallerContext(context.Background(), CallerContext{
		UserID:        "owner-1",
		WorkspaceID:   "ws-acme",
		WorkspaceRole: "owner",
	})

	// 1. Valid signoff across canonical modes
	for _, mode := range CanonicalOperatorModes {
		signoff, err := svc.EvaluateWorkspaceSignoff(ctxOwner, WorkspaceSignoffRequest{
			WorkspaceID:  "ws-acme",
			OperatorMode: mode.ModeID,
			Notes:        "Ready for operator mode rehearsal",
		})
		if err != nil {
			t.Fatalf("failed signoff for mode %s: %v", mode.ModeID, err)
		}
		if !signoff.SixModesVerified {
			t.Errorf("expected SixModesVerified=true")
		}
		if len(signoff.SignoffDigest) != 64 {
			t.Errorf("expected 64-char signoff digest, got %q", signoff.SignoffDigest)
		}
	}

	// 2. Non-canonical mode rejected (RULE-M01-006: never collapse to fewer than 6)
	_, err := svc.EvaluateWorkspaceSignoff(ctxOwner, WorkspaceSignoffRequest{
		WorkspaceID:  "ws-acme",
		OperatorMode: "generic_creator",
	})
	if !errors.Is(err, ErrInvalidOperatorMode) {
		t.Errorf("expected ErrInvalidOperatorMode for non-canonical mode, got: %v", err)
	}

	// 3. Cross-tenant signoff denied
	ctxForeign := WithCallerContext(context.Background(), CallerContext{
		UserID:        "user-foreign",
		WorkspaceID:   "ws-other",
		WorkspaceRole: "owner",
	})
	_, err = svc.EvaluateWorkspaceSignoff(ctxForeign, WorkspaceSignoffRequest{
		WorkspaceID:  "ws-acme",
		OperatorMode: "creator",
	})
	if !errors.Is(err, ErrPermissionDenied) {
		t.Errorf("expected cross-tenant denial, got: %v", err)
	}
}

func TestReplayIdempotencyAndDigest(t *testing.T) {
	svc := NewService(findBuildRoot())
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:    "tech-admin-1",
		IsAdmin:   true,
		AdminRole: "tech_admin",
	})

	rep1, err := svc.ReconcileFullScope(ctx, ReconcileFullScopeRequest{
		ReleaseCandidateVersion: "v1.0.0-rc.p8.09",
	})
	if err != nil {
		t.Fatalf("rep1 failed: %v", err)
	}

	rep2, err := svc.ReconcileFullScope(ctx, ReconcileFullScopeRequest{
		ReleaseCandidateVersion: "v1.0.0-rc.p8.09",
	})
	if err != nil {
		t.Fatalf("rep2 failed: %v", err)
	}

	if rep1.TotalModules != rep2.TotalModules || rep1.ReleaseDecision != rep2.ReleaseDecision {
		t.Errorf("non-deterministic report evaluation")
	}
	if len(svc.recordedRuns) != 2 {
		t.Errorf("expected 2 recorded runs in audit trail, got %d", len(svc.recordedRuns))
	}
}

func TestFivePathAcceptance(t *testing.T) {
	svc := NewService(findBuildRoot())
	ctxAdmin := WithCallerContext(context.Background(), CallerContext{
		UserID:    "super-1",
		IsAdmin:   true,
		AdminRole: "super_admin",
	})

	// Path 1: Happy Path
	happyReport, err := svc.ReconcileFullScope(ctxAdmin, ReconcileFullScopeRequest{
		Environment: "local",
	})
	if err != nil {
		t.Fatalf("Happy Path failed: %v", err)
	}
	if happyReport.ReleaseDecision != DecisionConditionalReadyLocal {
		t.Errorf("Happy Path expected CONDITIONAL_READY_LOCAL, got %s", happyReport.ReleaseDecision)
	}

	// Path 2: Degraded Path (external partner approvals pending)
	if happyReport.UnmetExternalGatesCount == 0 {
		t.Errorf("Degraded Path expected unmet gates to be present, got 0")
	}

	// Path 3: Missing Path (missing build dir)
	svcMissing := NewService("/nonexistent/build/path")
	missingReport, err := svcMissing.ReconcileFullScope(ctxAdmin, ReconcileFullScopeRequest{})
	if err != nil {
		t.Fatalf("Missing Path unexpected error: %v", err)
	}
	if missingReport.ReleaseDecision != DecisionReleaseBlocked {
		t.Errorf("Missing Path expected RELEASE_BLOCKED, got %s", missingReport.ReleaseDecision)
	}

	// Path 4: Broken Path (caller claims production launch without clearing gates)
	_, err = svc.ReconcileFullScope(ctxAdmin, ReconcileFullScopeRequest{
		AssertProductionLaunch: true,
	})
	if !errors.Is(err, ErrExternalGatesUnsatisfied) {
		t.Errorf("Broken Path expected ErrExternalGatesUnsatisfied, got: %v", err)
	}

	// Path 5: Audit Path (immutable ledger & digest)
	auditReport, err := svc.ReconcileFullScope(ctxAdmin, ReconcileFullScopeRequest{
		Environment: "rehearsal",
	})
	if err != nil {
		t.Fatalf("Audit Path unexpected error: %v", err)
	}
	if len(svc.recordedRuns) < 2 {
		t.Errorf("Audit Path expected at least 2 recorded runs in memory, got %d", len(svc.recordedRuns))
	}
	lastRun := svc.recordedRuns[len(svc.recordedRuns)-1]
	if lastRun.EvaluatedByAdminID != "super-1" {
		t.Errorf("Audit Path expected EvaluatedByAdminID=super-1, got %s", lastRun.EvaluatedByAdminID)
	}
	if auditReport.IntegritySha256 != lastRun.IntegritySha256 {
		t.Errorf("expected audit report integrity sha256 to match last run")
	}
}
