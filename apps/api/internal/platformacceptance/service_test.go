package platformacceptance

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
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

	// 1. Valid signoff across canonical modes when onboarding steps are completed
	for _, mode := range CanonicalOperatorModes {
		signoff, err := svc.EvaluateWorkspaceSignoff(ctxOwner, WorkspaceSignoffRequest{
			WorkspaceID:                "ws-acme",
			OperatorMode:               mode.ModeID,
			CompletedOnboardingStepIDs: []string{"select_operator_mode", "complete_first_value"},
			Notes:                      "Ready for operator mode rehearsal",
		})
		if err != nil {
			t.Fatalf("failed signoff for mode %s: %v", mode.ModeID, err)
		}
		if !signoff.SixModesVerified {
			t.Errorf("expected SixModesVerified=true")
		}
		if !signoff.OnboardingLoopCompleted {
			t.Errorf("expected OnboardingLoopCompleted=true when onboarding steps provided")
		}
		if len(signoff.SignoffDigest) != 64 {
			t.Errorf("expected 64-char signoff digest, got %q", signoff.SignoffDigest)
		}
	}

	// 1b. Incomplete onboarding steps must NOT claim OnboardingLoopCompleted=true
	incompleteSignoff, err := svc.EvaluateWorkspaceSignoff(ctxOwner, WorkspaceSignoffRequest{
		WorkspaceID:  "ws-acme",
		OperatorMode: "creator",
		Notes:        "Onboarding skipped",
	})
	if err != nil {
		t.Fatalf("unexpected error on incomplete onboarding signoff: %v", err)
	}
	if incompleteSignoff.OnboardingLoopCompleted {
		t.Errorf("expected OnboardingLoopCompleted=false when CompletedOnboardingStepIDs is empty")
	}
	if incompleteSignoff.Status != "onboarding_incomplete" {
		t.Errorf("expected status=onboarding_incomplete, got %q", incompleteSignoff.Status)
	}

	// 2. Non-canonical mode rejected (RULE-M01-006: never collapse to fewer than 6)
	_, err = svc.EvaluateWorkspaceSignoff(ctxOwner, WorkspaceSignoffRequest{
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
	for _, mod := range missingReport.Modules {
		if mod.Verified {
			t.Errorf("Missing Path module %s must not be marked Verified when manifests are missing", mod.ModuleID)
		}
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

func buildSyntheticRepoWith60Manifests(t *testing.T) (string, map[string]string) {
	t.Helper()
	repoRoot := t.TempDir()
	buildRoot := filepath.Join(repoRoot, "build")
	manifestPaths := make(map[string]string, len(Canonical60Tasks))

	for taskID, spec := range Canonical60Tasks {
		sliceDir := filepath.Join(buildRoot, "phase-"+spec.Phase, taskID)
		evidDir := filepath.Join(sliceDir, "evidence")
		if err := os.MkdirAll(evidDir, 0o755); err != nil {
			t.Fatalf("mkdir %s: %v", evidDir, err)
		}
		evidRel := filepath.ToSlash(filepath.Join("build", "phase-"+spec.Phase, taskID, "evidence", "test.log"))
		if err := os.WriteFile(filepath.Join(repoRoot, filepath.FromSlash(evidRel)), []byte("PASS\n"), 0o644); err != nil {
			t.Fatalf("write evidence: %v", err)
		}

		srcRel := filepath.ToSlash(filepath.Join("src", spec.Phase, taskID+".go"))
		srcFull := filepath.Join(repoRoot, filepath.FromSlash(srcRel))
		if err := os.MkdirAll(filepath.Dir(srcFull), 0o755); err != nil {
			t.Fatalf("mkdir src: %v", err)
		}
		srcContent := []byte(fmt.Sprintf("package %s // task %s\n", spec.Phase, taskID))
		if err := os.WriteFile(srcFull, srcContent, 0o644); err != nil {
			t.Fatalf("write src: %v", err)
		}
		sum := sha256.Sum256(srcContent)
		srcHash := hex.EncodeToString(sum[:])

		pkt := map[string]any{
			"task_id":           taskID,
			"phase":             spec.Phase,
			"slice":             taskID,
			"title":             "Synthetic task " + taskID,
			"status":            "LOCAL_IMPLEMENTED",
			"subslice_status":   "IMPLEMENTED_LOCAL_TESTED",
			"acceptance_status": "PENDING",
			"remaining_scope":   []any{},
			"source_files": map[string]string{
				srcRel: srcHash,
			},
			"checks": []map[string]any{
				{
					"command":       "go test ./...",
					"exit_code":     0,
					"evidence_path": evidRel,
				},
			},
		}
		if taskID == "P8-09" {
			pkt["external_gates"] = []map[string]any{
				{
					"gate_id": "LEG-H-001",
					"status":  "OPEN_EXTERNAL_HUMAN_GATE",
				},
			}
		}

		raw, err := json.MarshalIndent(pkt, "", "  ")
		if err != nil {
			t.Fatalf("marshal manifest %s: %v", taskID, err)
		}
		mPath := filepath.Join(sliceDir, "manifest.json")
		if err := os.WriteFile(mPath, raw, 0o644); err != nil {
			t.Fatalf("write manifest %s: %v", taskID, err)
		}
		manifestPaths[taskID] = mPath
	}
	return buildRoot, manifestPaths
}

func TestReconcileFullScope_NegativeIntegrityAndGateChecks(t *testing.T) {
	ctxAdmin := WithCallerContext(context.Background(), CallerContext{
		UserID:    "super-1",
		IsAdmin:   true,
		AdminRole: "super_admin",
	})

	// 1. Baseline synthetic 60-task repo passes
	buildRoot, _ := buildSyntheticRepoWith60Manifests(t)
	svc := NewService(buildRoot)
	rep, err := svc.ReconcileFullScope(ctxAdmin, ReconcileFullScopeRequest{})
	if err != nil {
		t.Fatalf("baseline synthetic repo failed: %v", err)
	}
	if !rep.AllManifestsVerified || rep.AcceptanceStatus != "PENDING" {
		t.Fatalf("unexpected baseline report state: verified=%v acceptance=%s", rep.AllManifestsVerified, rep.AcceptanceStatus)
	}

	// 2. Duplicate task_id (60 manifest files on disk, but P4-03 claims task_id P4-02) must fail closed
	buildRootDup, pathsDup := buildSyntheticRepoWith60Manifests(t)
	p402Bytes, _ := os.ReadFile(pathsDup["P4-02"])
	if err := os.WriteFile(pathsDup["P4-03"], p402Bytes, 0o644); err != nil {
		t.Fatalf("overwrite P4-03 with duplicate P4-02: %v", err)
	}
	_, err = NewService(buildRootDup).ReconcileFullScope(ctxAdmin, ReconcileFullScopeRequest{})
	if !errors.Is(err, ErrTamperedManifestChecksum) {
		t.Fatalf("expected ErrTamperedManifestChecksum for duplicate task_id, got: %v", err)
	}

	// 3. Missing canonical task manifest (59 manifests) must fail closed with ErrManifestNotFound
	buildRootMissingTask, pathsMissing := buildSyntheticRepoWith60Manifests(t)
	if err := os.Remove(pathsMissing["P6-04"]); err != nil {
		t.Fatalf("remove P6-04: %v", err)
	}
	_, err = NewService(buildRootMissingTask).ReconcileFullScope(ctxAdmin, ReconcileFullScopeRequest{})
	if !errors.Is(err, ErrManifestNotFound) {
		t.Fatalf("expected ErrManifestNotFound when P6-04 is missing, got: %v", err)
	}

	// 4. Tampered source file on disk (hash mismatch against manifest) must fail closed
	buildRootTamperedSrc, _ := buildSyntheticRepoWith60Manifests(t)
	tamperedSrcFile := filepath.Join(filepath.Dir(buildRootTamperedSrc), "src", "P2", "P2-01.go")
	if err := os.WriteFile(tamperedSrcFile, []byte("package P2 // TAMPERED\n"), 0o644); err != nil {
		t.Fatalf("tamper source file: %v", err)
	}
	_, err = NewService(buildRootTamperedSrc).ReconcileFullScope(ctxAdmin, ReconcileFullScopeRequest{})
	if !errors.Is(err, ErrTamperedManifestChecksum) {
		t.Fatalf("expected ErrTamperedManifestChecksum when source file content drifts from manifest hash, got: %v", err)
	}

	// 5. Unverified task status ("PENDING") must fail closed
	buildRootPending, pathsPending := buildSyntheticRepoWith60Manifests(t)
	var mP301 map[string]any
	rawP301, _ := os.ReadFile(pathsPending["P3-01"])
	_ = json.Unmarshal(rawP301, &mP301)
	mP301["status"] = "PENDING"
	updatedP301, _ := json.Marshal(mP301)
	_ = os.WriteFile(pathsPending["P3-01"], updatedP301, 0o644)
	_, err = NewService(buildRootPending).ReconcileFullScope(ctxAdmin, ReconcileFullScopeRequest{})
	if !errors.Is(err, ErrTamperedManifestChecksum) {
		t.Fatalf("expected ErrTamperedManifestChecksum for status=PENDING on P3-01, got: %v", err)
	}

	// 6. P8-09 falsely claiming acceptance_status="ACCEPTED" while external gates are open must fail closed
	buildRootFakeAcc, pathsFakeAcc := buildSyntheticRepoWith60Manifests(t)
	var mP809 map[string]any
	rawP809, _ := os.ReadFile(pathsFakeAcc["P8-09"])
	_ = json.Unmarshal(rawP809, &mP809)
	mP809["acceptance_status"] = "ACCEPTED"
	updatedP809, _ := json.Marshal(mP809)
	_ = os.WriteFile(pathsFakeAcc["P8-09"], updatedP809, 0o644)
	_, err = NewService(buildRootFakeAcc).ReconcileFullScope(ctxAdmin, ReconcileFullScopeRequest{})
	if !errors.Is(err, ErrExternalGatesUnsatisfied) {
		t.Fatalf("expected ErrExternalGatesUnsatisfied when P8-09 claims acceptance_status=ACCEPTED, got: %v", err)
	}

	// 7. Non-empty remaining_scope in P8-08 blocks release decision
	buildRootRemScope, pathsRemScope := buildSyntheticRepoWith60Manifests(t)
	var mP808 map[string]any
	rawP808, _ := os.ReadFile(pathsRemScope["P8-08"])
	_ = json.Unmarshal(rawP808, &mP808)
	mP808["remaining_scope"] = []any{"Unfinished DR item"}
	updatedP808, _ := json.Marshal(mP808)
	_ = os.WriteFile(pathsRemScope["P8-08"], updatedP808, 0o644)
	repBlocked, err := NewService(buildRootRemScope).ReconcileFullScope(ctxAdmin, ReconcileFullScopeRequest{})
	if err != nil {
		t.Fatalf("unexpected error on P8-08 remaining_scope check: %v", err)
	}
	if repBlocked.ZeroUntrackedScope || repBlocked.ReleaseDecision != DecisionReleaseBlocked {
		t.Fatalf("expected ZeroUntrackedScope=false and RELEASE_BLOCKED when P8-08 has remaining_scope, got %+v", repBlocked.ReleaseDecision)
	}

	// 8. Check with non-zero exit_code must fail closed
	buildRootFailedCheck, pathsFailedCheck := buildSyntheticRepoWith60Manifests(t)
	var mP101 map[string]any
	rawP101, _ := os.ReadFile(pathsFailedCheck["P1-01"])
	_ = json.Unmarshal(rawP101, &mP101)
	mP101["checks"] = []map[string]any{
		{"command": "go test ./...", "exit_code": 1},
	}
	updatedP101, _ := json.Marshal(mP101)
	_ = os.WriteFile(pathsFailedCheck["P1-01"], updatedP101, 0o644)
	_, err = NewService(buildRootFailedCheck).ReconcileFullScope(ctxAdmin, ReconcileFullScopeRequest{})
	if !errors.Is(err, ErrTamperedManifestChecksum) {
		t.Fatalf("expected ErrTamperedManifestChecksum for non-zero check exit_code, got: %v", err)
	}
}
