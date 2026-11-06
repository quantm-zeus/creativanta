package production

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"net/http/httptest"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"connectrpc.com/connect"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

func setupTestService(t *testing.T) (*Service, Store, *MockVeoProvider, *MockKlingProvider) {
	t.Helper()
	store := NewMemoryStore()
	veo := NewMockVeoProvider()
	kling := NewMockKlingProvider()
	limits := DefaultWorkerLimits()
	pp := NewPostProductionExecutor(limits)

	svc := NewService(ServiceConfig{
		Store:            store,
		PrimaryProvider:  veo,
		FallbackProvider: kling,
		PostProdExecutor: pp,
		InitialBalances: map[string]tenantdb.ExactDecimal{
			"ws-test-01": tenantdb.MustParseExactDecimal("100"),
			"ws-test-02": tenantdb.MustParseExactDecimal("10"), // Low balance
		},
	})
	return svc, store, veo, kling
}

func contextWithRole(role, userID string) context.Context {
	ctx := context.Background()
	ctx = context.WithValue(ctx, "caller_role", role)
	ctx = context.WithValue(ctx, "caller_user_id", userID)
	return ctx
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: Cancel/timeout/unknown-result recovery
// ----------------------------------------------------------------------------
func TestCancelAndRecovery(t *testing.T) {
	svc, store, _, _ := setupTestService(t)
	ctx := contextWithRole("Editor", "user-1")
	wsID := "ws-test-01"

	// 1. Create a job manually in processing state with 20 credits held
	now := time.Now().UTC()
	asset := &Asset{
		AssetID:         "asset-cancel-1",
		WorkspaceID:     wsID,
		AssetType:       "video",
		Title:           "Active Video",
		GenerationState: "generating",
		QualityState:    "draft",
		CreatedAt:       now,
		UpdatedAt:       now,
	}
	_ = store.CreateAsset(ctx, asset)

	job := &GenerationJob{
		JobID:            "job-cancel-1",
		WorkspaceID:      wsID,
		AssetID:          "asset-cancel-1",
		JobType:          "video_gen",
		Provider:         "veo",
		Status:           "processing",
		EstimatedCredits: tenantdb.MustParseExactDecimal("20"),
		CreatedAt:        now,
		UpdatedAt:        now,
	}
	_ = store.CreateJob(ctx, job)
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("80")) // 100 - 20 = 80

	// 2. Cancel the job
	cancelReq := connect.NewRequest(&productionv1.CancelRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		JobId: "job-cancel-1",
	})
	cancelResp, err := svc.Cancel(ctx, cancelReq)
	if err != nil {
		t.Fatalf("Cancel failed: %v", err)
	}

	if !cancelResp.Msg.GetCreditsRefunded() {
		t.Errorf("expected credits_refunded = true")
	}
	if cancelResp.Msg.GetRefundedCredits() != "20" {
		t.Errorf("expected refunded_credits = 20, got %s", cancelResp.Msg.GetRefundedCredits())
	}
	if cancelResp.Msg.GetJob().GetStatus() != productionv1.GenerationJobStatus_GENERATION_JOB_STATUS_CANCELLED {
		t.Errorf("expected job status CANCELLED, got %v", cancelResp.Msg.GetJob().GetStatus())
	}

	// Verify atomic sync with asset (RULE-M07-007)
	updatedAsset, err := store.GetAsset(ctx, wsID, "asset-cancel-1")
	if err != nil {
		t.Fatalf("GetAsset failed: %v", err)
	}
	if updatedAsset.GenerationState != "cancelled" {
		t.Errorf("expected asset state cancelled, got %s", updatedAsset.GenerationState)
	}

	// Balance restored: 80 + 20 = 100
	newBal := svc.GetWorkspaceBalance(wsID)
	if newBal.Cmp(tenantdb.MustParseExactDecimal("100")) != 0 {
		t.Errorf("expected balance restored to 100, got %s", newBal.String())
	}

	// 3. Repeat Cancel: Idempotent replay must NOT refund twice!
	cancelResp2, err := svc.Cancel(ctx, cancelReq)
	if err != nil {
		t.Fatalf("Repeat cancel failed: %v", err)
	}
	if cancelResp2.Msg.GetJob().GetStatus() != productionv1.GenerationJobStatus_GENERATION_JOB_STATUS_CANCELLED {
		t.Errorf("expected job status CANCELLED on replay")
	}
	balAfterReplay := svc.GetWorkspaceBalance(wsID)
	if balAfterReplay.Cmp(tenantdb.MustParseExactDecimal("100")) != 0 {
		t.Errorf("double refund bug! balance is %s, expected 100", balAfterReplay.String())
	}

	// 4. Cancel on completed job must fail with FailedPrecondition
	job.Status = "completed"
	_ = store.UpdateJob(ctx, job)
	_, err = svc.Cancel(ctx, cancelReq)
	if err == nil {
		t.Fatalf("expected error cancelling completed job, got nil")
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Fallback no double charge
// ----------------------------------------------------------------------------
func TestFallbackNoDoubleCharge(t *testing.T) {
	svc, store, veo, kling := setupTestService(t)
	ctx := contextWithRole("Editor", "user-1")
	wsID := "ws-test-01"

	// Configure Veo (primary) to simulate a definitive failure (503)
	veo.FailGeneration = true
	kling.FailGeneration = false // Kling fallback succeeds

	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("100"))

	genReq := connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Title:  "Fallback Product Video",
		Prompt: "Showcase luxury watch with dynamic camera pan",
		Mode:   productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE,
	})

	genResp, err := svc.Generate(ctx, genReq)
	if err != nil {
		t.Fatalf("Generate with fallback failed: %v", err)
	}

	jobID := genResp.Msg.GetJob().GetJobId()
	assetID := genResp.Msg.GetAsset().GetAssetId()

	// Verify job completed via fallback
	if genResp.Msg.GetJob().GetStatus() != productionv1.GenerationJobStatus_GENERATION_JOB_STATUS_COMPLETED {
		t.Errorf("expected job status COMPLETED, got %v", genResp.Msg.GetJob().GetStatus())
	}

	// Verify asset lineage records KLING as actual successful provider
	asset, err := store.GetAsset(ctx, wsID, assetID)
	if err != nil {
		t.Fatalf("GetAsset failed: %v", err)
	}
	if asset.SourceProvider != "kling" {
		t.Errorf("expected source_provider 'kling', got %s", asset.SourceProvider)
	}
	if len(asset.LineageRefs) == 0 {
		t.Fatalf("expected lineage_refs to be populated per RULE-M07-001")
	}
	if asset.LineageRefs[0].SourceProvider != "kling" {
		t.Errorf("expected lineage provider 'kling', got %s", asset.LineageRefs[0].SourceProvider)
	}

	// Verify credit debit occurred exactly ONCE (No Double Charge) and unused quote hold was refunded (F08):
	// Quoted ceiling for Veo (15s @ $0.04/s = $0.60) -> 80 credits reserved.
	// Actual execution via Kling fallback (15s @ $0.03/s = $0.45) -> 60 actual credits committed, 20 unused released.
	// Initial balance 100 - 60 actual = 40 remaining.
	remainingBal := svc.GetWorkspaceBalance(wsID)
	if remainingBal.IsNegative() {
		t.Fatalf("double charge occurred! balance went negative: %s", remainingBal.String())
	}
	if remainingBal.Cmp(tenantdb.MustParseExactDecimal("40")) != 0 {
		t.Errorf("expected remaining balance 40 credits after 60 actual commit (80 reserved - 20 unused released), got %s", remainingBal.String())
	}
	if genResp.Msg.GetJob().GetActualCredits() != "60" {
		t.Errorf("expected job actual_credits 60, got %s", genResp.Msg.GetJob().GetActualCredits())
	}

	_ = jobID
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Budget preview and partial batch input validation
// ----------------------------------------------------------------------------
func TestBudgetPreviewAndPartialBatchValidation(t *testing.T) {
	svc, _, _, _ := setupTestService(t)
	ctx := contextWithRole("Editor", "user-1")
	wsID := "ws-test-01"

	// Create a batch of 20 items: 18 valid, 2 invalid
	var batchItems []*productionv1.BatchGenerationItem
	for i := 0; i < 20; i++ {
		item := &productionv1.BatchGenerationItem{
			ItemId:   fmt.Sprintf("prod-%02d", i+1),
			ItemName: fmt.Sprintf("Product %02d", i+1),
			Prompt:   fmt.Sprintf("Showcase product %02d rotating in 3D studio light", i+1),
		}
		if i == 5 {
			// Invalid row 5: missing prompt & name
			item.ItemName = ""
			item.Prompt = ""
		}
		if i == 12 {
			// Invalid row 12: malformed reference URL
			item.ReferenceUrl = "htp://invalid-url-scheme"
		}
		batchItems = append(batchItems, item)
	}

	dryRunReq := connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Title:      "20 Product Showcase Batch",
		Mode:       productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE,
		DryRun:     true, // Budget preview mode
		BatchItems: batchItems,
	})

	resp, err := svc.Generate(ctx, dryRunReq)
	if err != nil {
		t.Fatalf("dry run Generate failed: %v", err)
	}

	if !resp.Msg.GetIsDryRun() {
		t.Fatalf("expected is_dry_run = true")
	}

	preview := resp.Msg.GetBudgetPreview()
	if preview == nil {
		t.Fatalf("expected non-nil BudgetPreview")
	}

	if preview.GetTotalItems() != 20 {
		t.Errorf("expected total_items = 20, got %d", preview.GetTotalItems())
	}
	if preview.GetValidItemsCount() != 18 {
		t.Errorf("expected valid_items_count = 18, got %d", preview.GetValidItemsCount())
	}
	if preview.GetInvalidItemsCount() != 2 {
		t.Errorf("expected invalid_items_count = 2, got %d", preview.GetInvalidItemsCount())
	}

	// Verify invalid items 5 and 12 are marked invalid with zero charge
	item5 := preview.GetItems()[5]
	if item5.GetIsValid() {
		t.Errorf("expected row 5 to be invalid")
	}
	if item5.GetEstimatedCredits() != "0" {
		t.Errorf("invalid row 5 charged credits! got %s", item5.GetEstimatedCredits())
	}
	if item5.GetValidationError() == "" {
		t.Errorf("expected validation error message for row 5")
	}

	item12 := preview.GetItems()[12]
	if item12.GetIsValid() {
		t.Errorf("expected row 12 to be invalid")
	}
	if item12.GetEstimatedCredits() != "0" {
		t.Errorf("invalid row 12 charged credits! got %s", item12.GetEstimatedCredits())
	}

	// Total cost must equal sum of ONLY the 18 valid rows
	// Each valid row: 15s * $0.04 = $0.60 -> 80 credits
	// 18 * 80 = 1440 credits
	expectedTotalCredits := tenantdb.MustParseExactDecimal("1440")
	actualTotalCredits, _ := tenantdb.ParseExactDecimal(preview.GetTotalEstimatedCredits())
	if actualTotalCredits.Cmp(expectedTotalCredits) != 0 {
		t.Errorf("expected total credits %s, got %s", expectedTotalCredits.String(), actualTotalCredits.String())
	}

	// Workspace has 100 credits, needs 1440 -> sufficient_credits must be false
	if preview.GetSufficientCredits() {
		t.Errorf("expected sufficient_credits = false for 1440 credits requirement on 100 balance")
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 4: Sandboxed post-production and FFmpeg/ffprobe security
// ----------------------------------------------------------------------------
func TestFFmpegAllowlistAndSecurity(t *testing.T) {
	// 1. Allowlisted arguments pass
	validArgs := []string{
		"-y", "-hide_banner", "-loglevel", "error",
		"-i", "input.mp4",
		"-af", "loudnorm=I=-14.0:LRA=11:TP=-1.5",
		"-c:v", "libx264", "-c:a", "aac",
		"output.mp4",
	}
	if err := ValidateFFmpegArgs(validArgs); err != nil {
		t.Errorf("expected valid args to pass allowlist, got %v", err)
	}

	// 2. Unallowlisted flag rejected
	badFlagArgs := []string{
		"-y", "-i", "input.mp4",
		"-filter_script", "/etc/passwd", // Dangerous flag
		"output.mp4",
	}
	if err := ValidateFFmpegArgs(badFlagArgs); err == nil {
		t.Errorf("expected -filter_script to be rejected by allowlist")
	}

	// 3. Shell injection characters rejected
	injectionArgs := []string{
		"-y", "-i", "input.mp4; rm -rf /",
		"-c:v", "copy",
		"output.mp4",
	}
	if err := ValidateFFmpegArgs(injectionArgs); err == nil {
		t.Errorf("expected semicolon injection to be rejected")
	}

	pipeArgs := []string{
		"-y", "-i", "pipe:0 | bash",
		"output.mp4",
	}
	if err := ValidateFFmpegArgs(pipeArgs); err == nil {
		t.Errorf("expected pipe protocol injection to be rejected")
	}

	// 4. Output validation before completion (RULE-M07-005)
	executor := NewPostProductionExecutor(DefaultWorkerLimits())

	// Compliant media passes
	compliantMeta := OutputMediaMetadata{
		Width:             1080,
		Height:            1920,
		DurationSecs:      15.0,
		HasVideoStream:    true,
		HasAudioStream:    true,
		AudioLoudnessLUFS: -14.0, // Exactly -14 LUFS target
		FileSizeBytes:     10 * 1024 * 1024,
	}
	if err := executor.ValidateOutputMedia(compliantMeta, "9:16", true); err != nil {
		t.Errorf("expected compliant media to pass validation, got %v", err)
	}

	// Non-compliant audio loudness fails
	tooLoudMeta := compliantMeta
	tooLoudMeta.AudioLoudnessLUFS = -6.0 // Way too loud (expected -14 LUFS)
	if err := executor.ValidateOutputMedia(tooLoudMeta, "9:16", true); err == nil {
		t.Errorf("expected too-loud media (-6 LUFS) to fail normalization check")
	}

	// Missing audio fails
	missingAudioMeta := compliantMeta
	missingAudioMeta.HasAudioStream = false
	if err := executor.ValidateOutputMedia(missingAudioMeta, "9:16", true); err == nil {
		t.Errorf("expected missing audio stream to fail validation")
	}

	// Aspect ratio mismatch fails
	badAspectMeta := compliantMeta
	badAspectMeta.Width = 1920 // 16:9 instead of requested 9:16
	badAspectMeta.Height = 1080
	if err := executor.ValidateOutputMedia(badAspectMeta, "9:16", true); err == nil {
		t.Errorf("expected 16:9 media to fail 9:16 aspect ratio validation")
	}
}

// ----------------------------------------------------------------------------
// RBAC Permission Tests
// ----------------------------------------------------------------------------
func TestRBACPermissionEnforcement(t *testing.T) {
	svc, _, _, _ := setupTestService(t)
	wsID := "ws-test-01"

	// Viewer attempts Generate -> Must fail with PermissionDenied
	viewerCtx := contextWithRole("Viewer", "user-viewer")
	genReq := connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Title:  "Viewer Video",
		Prompt: "Testing permission gate",
	})
	_, err := svc.Generate(viewerCtx, genReq)
	if err == nil || connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Errorf("expected PermissionDenied for Viewer on Generate, got %v", err)
	}

	// Member attempts Approve -> Must fail (requires Manager+)
	memberCtx := contextWithRole("Member", "user-member")
	appReq := connect.NewRequest(&productionv1.ApproveRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		AssetId: "asset-1",
	})
	_, err = svc.Approve(memberCtx, appReq)
	if err == nil || connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Errorf("expected PermissionDenied for Member on Approve, got %v", err)
	}

	// Member can read modes and active jobs
	modesReq := connect.NewRequest(&productionv1.GetModesRequest{
		WorkspaceId: &commonv1.UUID{Value: wsID},
	})
	modesResp, err := svc.GetModes(memberCtx, modesReq)
	if err != nil {
		t.Fatalf("Member GetModes failed: %v", err)
	}
	if len(modesResp.Msg.GetModes()) == 0 {
		t.Errorf("expected modes returned to Member")
	}
}

// ----------------------------------------------------------------------------
// Upload Safety Tests
// ----------------------------------------------------------------------------
func TestUploadSafety(t *testing.T) {
	svc, _, _, _ := setupTestService(t)
	ctx := contextWithRole("Editor", "user-1")
	wsID := "ws-test-01"

	// 1. Valid MP4 upload passes
	validUploadReq := connect.NewRequest(&productionv1.UploadRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		FileName:      "raw_footage.mp4",
		MimeType:      "video/mp4",
		FileSizeBytes: 1024 * 1024 * 5,
		FileContent:   []byte("fake video payload"),
		UploadPurpose: "asset",
	})
	upResp, err := svc.Upload(ctx, validUploadReq)
	if err != nil {
		t.Fatalf("valid upload failed: %v", err)
	}
	if upResp.Msg.GetVirusScanStatus() != "clean" {
		t.Errorf("expected virus_scan_status = clean")
	}

	// 2. Disallowed MIME type rejected
	badMimeReq := connect.NewRequest(&productionv1.UploadRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		FileName:      "payload.exe",
		MimeType:      "application/x-msdownload",
		FileSizeBytes: 1024,
		FileContent:   []byte("executable binary"),
	})
	_, err = svc.Upload(ctx, badMimeReq)
	if err == nil {
		t.Errorf("expected executable mime type to be rejected")
	}

	// 3. EICAR virus signature detected and blocked
	eicarReq := connect.NewRequest(&productionv1.UploadRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		FileName:      "test_virus.png",
		MimeType:      "image/png",
		FileSizeBytes: 68,
		FileContent:   []byte("X5O!P%@AP[4\\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*"),
	})
	_, err = svc.Upload(ctx, eicarReq)
	if err == nil {
		t.Errorf("expected EICAR virus signature to be detected and rejected")
	}
}

// ============================================================================
// Remediation Regression Tests: AI-03, AI-04, AI-05, AI-06, AI-07, AI-08
// ============================================================================

type testProductionAuthVerifier struct {
	session transportauth.Session
}

func (v testProductionAuthVerifier) Verify(_ context.Context, _ string) (transportauth.Session, error) {
	return v.session, nil
}

func contextWithVerifiedSession(t *testing.T, session transportauth.Session) context.Context {
	t.Helper()
	interceptor, err := transportauth.NewServerInterceptor(transportauth.Options{
		Mode:     transportauth.ModeAPI,
		Verifier: testProductionAuthVerifier{session: session},
	})
	if err != nil {
		t.Fatalf("NewServerInterceptor: %v", err)
	}
	var capturedCtx context.Context
	wrapped := interceptor.WrapUnary(func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		capturedCtx = ctx
		return connect.NewResponse(&productionv1.GetModesResponse{}), nil
	})
	req := connect.NewRequest(&productionv1.GetModesRequest{})
	req.Header().Set("Authorization", "Bearer valid-test-token")
	req.Header().Set("x-workspace-id", session.WorkspaceID)
	if _, err := wrapped(context.Background(), req); err != nil {
		t.Fatalf("wrapped auth interceptor call failed: %v", err)
	}
	return capturedCtx
}

func TestAI03_ProductionService_EnforcesTransportAuthAndTenantScope(t *testing.T) {
	svc, _, _, _ := setupTestService(t)
	wsID := "11111111-1111-4111-8111-111111111101"
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("100"))

	genReq := connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Title:  "Auth Check Video",
		Prompt: "Verify principal and tenant scope enforcement",
	})

	// 1. Cross-tenant transportauth.Session must be denied
	crossTenantPrincipalCtx := contextWithVerifiedSession(t, transportauth.Session{
		UserID:      "11111111-1111-4111-8111-111111111199",
		WorkspaceID: "22222222-2222-4222-8222-222222222202",
	})
	if _, err := svc.Generate(crossTenantPrincipalCtx, genReq); err == nil || connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected cross-tenant transportauth principal to be rejected with PermissionDenied, got: %v", err)
	}

	// 2. Principal with empty Role and no scope.Role must fail closed (Denied), NEVER default to Editor
	noRolePrincipalCtx := contextWithVerifiedSession(t, transportauth.Session{
		UserID:      "11111111-1111-4111-8111-111111111196",
		WorkspaceID: wsID,
		Role:        "",
	})
	if _, err := svc.Generate(noRolePrincipalCtx, genReq); err == nil || connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected principal without role to fail closed with PermissionDenied, got: %v", err)
	}

	// 3. Viewer role on transportauth.Session (where transportauth interceptor attaches tenantdb.Scope with empty ActorRole) must be denied on Generate
	viewerPrincipalCtx := contextWithVerifiedSession(t, transportauth.Session{
		UserID:      "11111111-1111-4111-8111-111111111198",
		WorkspaceID: wsID,
		Role:        "viewer",
	})
	if _, err := svc.Generate(viewerPrincipalCtx, genReq); err == nil || connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected viewer transportauth principal to be rejected with PermissionDenied, got: %v", err)
	}

	// 4. Contributor role on transportauth.Session must also be denied on Generate (requires Editor+)
	contributorPrincipalCtx := contextWithVerifiedSession(t, transportauth.Session{
		UserID:      "11111111-1111-4111-8111-111111111195",
		WorkspaceID: wsID,
		Role:        "contributor",
	})
	if _, err := svc.Generate(contributorPrincipalCtx, genReq); err == nil || connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected contributor transportauth principal to be rejected with PermissionDenied, got: %v", err)
	}

	// 5. Matching Editor transportauth.Session succeeds
	editorPrincipalCtx := contextWithVerifiedSession(t, transportauth.Session{
		UserID:      "11111111-1111-4111-8111-111111111197",
		WorkspaceID: wsID,
		Role:        "editor",
	})
	resp, err := svc.Generate(editorPrincipalCtx, genReq)
	if err != nil {
		t.Fatalf("expected matching editor principal to succeed, got: %v", err)
	}
	if resp.Msg.GetJob().GetStatus() != productionv1.GenerationJobStatus_GENERATION_JOB_STATUS_COMPLETED {
		t.Fatalf("expected job completed, got %v", resp.Msg.GetJob().GetStatus())
	}
}

func TestAI04_DefaultProductionService_FailsClosedWithoutProviders(t *testing.T) {
	store := NewMemoryStore()
	// Default NewService with no providers configured must NOT wire mock providers
	svc := NewService(ServiceConfig{
		Store: store,
		InitialBalances: map[string]tenantdb.ExactDecimal{
			"ws-unconf": tenantdb.MustParseExactDecimal("100"),
		},
	})
	ctx := contextWithRole("Editor", "user-1")

	genReq := connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: "ws-unconf"},
		},
		Title:  "Unconfigured Provider Video",
		Prompt: "Must fail closed without charging credits",
	})

	_, err := svc.Generate(ctx, genReq)
	if err == nil || connect.CodeOf(err) != connect.CodeFailedPrecondition || !errors.Is(err, ErrProviderNotConfigured) {
		t.Fatalf("expected ErrProviderNotConfigured with FailedPrecondition, got: %v", err)
	}

	// Verify 0 credits charged and 0 assets created
	bal := svc.GetWorkspaceBalance("ws-unconf")
	if bal.Cmp(tenantdb.MustParseExactDecimal("100")) != 0 {
		t.Fatalf("expected balance to remain 100 when provider is unconfigured, got %s", bal.String())
	}
	assets, total, _ := store.ListAssets(ctx, "ws-unconf", "", "", "", 10, 0)
	if total != 0 || len(assets) != 0 {
		t.Fatalf("expected 0 assets created when provider is unconfigured, got %d", total)
	}
}

func TestAI05_QuoteVerification_IdempotencyConflict_And_ConcurrentSingleBalanceSafety(t *testing.T) {
	svc, _, veo, _ := setupTestService(t)
	ctx := contextWithRole("Editor", "user-1")
	wsID := "ws-test-01"
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("200"))

	// 1. Dry-run generates a quote bound to workspace, request hash, and expiry
	dryReq := connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Title:  "Quoted Video",
		Prompt: "A cinematic drone shot over emerald mountains",
		Mode:   productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE,
		DryRun: true,
	})
	dryResp, err := svc.Generate(ctx, dryReq)
	if err != nil {
		t.Fatalf("dry-run Generate failed: %v", err)
	}
	quoteID := dryResp.Msg.GetBudgetPreview().GetQuoteId()
	quotedCredits := dryResp.Msg.GetBudgetPreview().GetTotalEstimatedCredits()
	if quoteID == "" || quotedCredits != "80" {
		t.Fatalf("unexpected quote %q or credits %s", quoteID, quotedCredits)
	}

	// 2. Quote from another workspace must be rejected with PermissionDenied
	otherWsReq := connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: "ws-test-02"},
		},
		Title:            "Quoted Video",
		Prompt:           "A cinematic drone shot over emerald mountains",
		Mode:             productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE,
		QuoteId:          quoteID,
		ConfirmedCredits: quotedCredits,
	})
	if _, err := svc.Generate(ctx, otherWsReq); err == nil || connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected cross-workspace quote reuse to fail with PermissionDenied, got: %v", err)
	}

	// 3. Mismatched prompt (request hash mismatch) against quote must be rejected
	tamperedReq := connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Title:            "Quoted Video",
		Prompt:           "Tampered prompt different from quoted request",
		Mode:             productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE,
		QuoteId:          quoteID,
		ConfirmedCredits: quotedCredits,
	})
	if _, err := svc.Generate(ctx, tamperedReq); err == nil || connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected tampered prompt against quote to fail with FailedPrecondition, got: %v", err)
	}

	// 4. ConfirmedCredits = "0" or mismatch must be rejected
	zeroConfirmedReq := connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Title:            "Quoted Video",
		Prompt:           "A cinematic drone shot over emerald mountains",
		Mode:             productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE,
		QuoteId:          quoteID,
		ConfirmedCredits: "0",
	})
	if _, err := svc.Generate(ctx, zeroConfirmedReq); err == nil || connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected ConfirmedCredits=0 to fail with FailedPrecondition, got: %v", err)
	}

	// 5. Expired quote must be rejected
	svc.RegisterQuote(CreditQuote{
		QuoteID:        "quote-expired-1",
		WorkspaceID:    wsID,
		RequestHash:    computeGenerateRequestHash(zeroConfirmedReq.Msg),
		QuotedCredits:  tenantdb.MustParseExactDecimal("80"),
		CostCeilingUSD: tenantdb.MustParseExactDecimal("0.600000"),
		ExpiresAt:      time.Now().Add(-1 * time.Minute).UTC(),
		CreatedAt:      time.Now().Add(-6 * time.Minute).UTC(),
	})
	expiredReq := connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Title:            "Quoted Video",
		Prompt:           "A cinematic drone shot over emerald mountains",
		Mode:             productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE,
		QuoteId:          "quote-expired-1",
		ConfirmedCredits: "80",
	})
	if _, err := svc.Generate(ctx, expiredReq); err == nil || connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected expired quote to fail with FailedPrecondition, got: %v", err)
	}

	// 6. Valid quote + Idempotency-Key succeeds once; replay returns same job without double debit;
	// reusing Idempotency-Key with different payload fails with AlreadyExists
	validLiveReq := connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-gen-001",
		},
		Title:            "Quoted Video",
		Prompt:           "A cinematic drone shot over emerald mountains",
		Mode:             productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE,
		QuoteId:          quoteID,
		ConfirmedCredits: quotedCredits,
	})
	liveResp1, err := svc.Generate(ctx, validLiveReq)
	if err != nil {
		t.Fatalf("valid Generate failed: %v", err)
	}
	balAfterFirst := svc.GetWorkspaceBalance(wsID)
	if balAfterFirst.Cmp(tenantdb.MustParseExactDecimal("120")) != 0 {
		t.Fatalf("expected balance 120 after 1st job (200 - 80), got %s", balAfterFirst.String())
	}

	// Replay with identical Idempotency-Key and payload
	liveResp2, err := svc.Generate(ctx, validLiveReq)
	if err != nil {
		t.Fatalf("idempotent replay failed: %v", err)
	}
	if liveResp2.Msg.GetJob().GetJobId() != liveResp1.Msg.GetJob().GetJobId() {
		t.Fatalf("expected idempotent replay to return same job ID %s, got %s",
			liveResp1.Msg.GetJob().GetJobId(), liveResp2.Msg.GetJob().GetJobId())
	}
	if svc.GetWorkspaceBalance(wsID).Cmp(tenantdb.MustParseExactDecimal("120")) != 0 {
		t.Fatalf("idempotent replay double-charged credits! balance=%s", svc.GetWorkspaceBalance(wsID).String())
	}
	if veo.GetGenerateCount() != 1 {
		t.Fatalf("expected provider Generate called once across idempotent replay, got %d", veo.GetGenerateCount())
	}

	// Reuse same Idempotency-Key with different prompt -> Must fail with AlreadyExists
	conflictIdemReq := connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: wsID},
			IdempotencyKey: "idem-gen-001",
		},
		Title:  "Quoted Video",
		Prompt: "Different prompt reusing the same idempotency key",
		Mode:   productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE,
	})
	if _, err := svc.Generate(ctx, conflictIdemReq); err == nil || connect.CodeOf(err) != connect.CodeAlreadyExists {
		t.Fatalf("expected idempotency key conflict to fail with AlreadyExists, got: %v", err)
	}

	// 7. Concurrent single-request balance safety:
	// Set balance to 80 (enough for exactly 1 job of 80 credits) and launch 10 concurrent goroutines.
	wsConcurrent := "ws-concurrent-80"
	svc.SetWorkspaceBalance(wsConcurrent, tenantdb.MustParseExactDecimal("80"))
	var (
		wg           sync.WaitGroup
		successCount int32
		failCount    int32
	)
	for i := 0; i < 10; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			req := connect.NewRequest(&productionv1.GenerateRequest{
				Context: &commonv1.CommandContext{
					WorkspaceId: &commonv1.UUID{Value: wsConcurrent},
				},
				Title:  fmt.Sprintf("Concurrent Job %d", idx),
				Prompt: fmt.Sprintf("Concurrent generation request number %d", idx),
				Mode:   productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE,
			})
			if _, gErr := svc.Generate(ctx, req); gErr == nil {
				atomic.AddInt32(&successCount, 1)
			} else {
				atomic.AddInt32(&failCount, 1)
			}
		}(i)
	}
	wg.Wait()

	if successCount != 1 || failCount != 9 {
		t.Fatalf("expected exactly 1 success and 9 insufficient-credit failures, got success=%d fail=%d", successCount, failCount)
	}
	finalConcurrentBal := svc.GetWorkspaceBalance(wsConcurrent)
	if finalConcurrentBal.Cmp(tenantdb.ZeroDecimal()) != 0 {
		t.Fatalf("expected final balance 0 after single allowed job, got %s", finalConcurrentBal.String())
	}
}

func TestAI06_PrimaryTimeout_DoesNotTriggerFallback_And_DoesNotRefundUncertainCredits(t *testing.T) {
	svc, store, veo, kling := setupTestService(t)
	ctx := contextWithRole("Editor", "user-1")
	wsID := "ws-test-01"
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("100"))

	// Primary provider times out on submission (unknown outcome)
	veo.TimeoutOnCall = true

	genReq := connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId: &commonv1.UUID{Value: wsID},
		},
		Title:  "Timeout Uncertainty Video",
		Prompt: "Test primary provider timeout handling",
		Mode:   productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE,
	})

	_, err := svc.Generate(ctx, genReq)
	if err == nil || connect.CodeOf(err) != connect.CodeDeadlineExceeded || !errors.Is(err, ErrOutcomeUnknown) {
		t.Fatalf("expected DeadlineExceeded with ErrOutcomeUnknown on primary timeout, got: %v", err)
	}

	// 1. Secondary fallback provider MUST NOT have been called when primary timed out!
	if kling.GetGenerateCount() != 0 {
		t.Fatalf("expected fallback provider NOT to be called on primary submission timeout, got %d calls", kling.GetGenerateCount())
	}

	// 2. Credits MUST remain held (100 - 80 = 20) pending reconciliation, NOT refunded as if definitively failed!
	bal := svc.GetWorkspaceBalance(wsID)
	if bal.Cmp(tenantdb.MustParseExactDecimal("20")) != 0 {
		t.Fatalf("expected 80 credits to remain held (balance 20) during unknown outcome reconciliation, got %s", bal.String())
	}

	// 3. Job must remain in 'processing' with PROVIDER_OUTCOME_UNKNOWN and reservation in 'reconciling'
	activeJobs, _ := store.ListActiveJobs(ctx, wsID)
	if len(activeJobs) != 1 {
		t.Fatalf("expected 1 active job in processing state for reconciliation, got %d", len(activeJobs))
	}
	if activeJobs[0].ErrorCode != "PROVIDER_OUTCOME_UNKNOWN" {
		t.Fatalf("expected ErrorCode PROVIDER_OUTCOME_UNKNOWN, got %q", activeJobs[0].ErrorCode)
	}
	resRec, ok := svc.GetReservationByJob(activeJobs[0].JobID)
	if !ok || resRec.Status != "reconciling" {
		t.Fatalf("expected reservation status 'reconciling', got %+v", resRec)
	}
}

func TestAI07_ProviderNonCompletedStatuses_NeverCreateCompletedAssets(t *testing.T) {
	svc, store, veo, _ := setupTestService(t)
	ctx := contextWithRole("Editor", "user-1")
	wsID := "ws-test-01"
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("300"))

	// Case 1: Provider returns "processing" (async execution) -> Job stays processing, Asset stays generating
	veo.CustomStatus = &ProviderGenStatus{
		Status:      "processing",
		ProgressPct: 45,
		ResultURL:   "",
	}
	procResp, err := svc.Generate(ctx, connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		Title:   "Async Processing Video",
		Prompt:  "Async provider still rendering video",
	}))
	if err != nil {
		t.Fatalf("expected processing status to return in-flight job without error, got: %v", err)
	}
	if procResp.Msg.GetJob().GetStatus() != productionv1.GenerationJobStatus_GENERATION_JOB_STATUS_PROCESSING {
		t.Fatalf("expected job status PROCESSING, got %v", procResp.Msg.GetJob().GetStatus())
	}
	if procResp.Msg.GetAsset().GetGenerationState() != productionv1.AssetGenerationState_ASSET_GENERATION_STATE_GENERATING {
		t.Fatalf("expected asset state GENERATING, got %v", procResp.Msg.GetAsset().GetGenerationState())
	}
	if procResp.Msg.GetAsset().GetFileUrl() != "" {
		t.Fatalf("expected empty FileUrl while processing, got %q", procResp.Msg.GetAsset().GetFileUrl())
	}

	// Case 2: Provider returns "failed" -> Job and Asset become failed, credits refunded
	balBeforeFail := svc.GetWorkspaceBalance(wsID)
	veo.CustomStatus = &ProviderGenStatus{
		Status:       "failed",
		ErrorCode:    "CONTENT_POLICY",
		ErrorMessage: "generation failed content safety filter",
	}
	_, err = svc.Generate(ctx, connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		Title:   "Failed Provider Status Video",
		Prompt:  "Provider status check returns failed",
	}))
	if err == nil {
		t.Fatalf("expected error when provider status is failed")
	}
	if svc.GetWorkspaceBalance(wsID).Cmp(balBeforeFail) != 0 {
		t.Fatalf("expected credits refunded on definitive provider failed status, got %s vs %s",
			svc.GetWorkspaceBalance(wsID).String(), balBeforeFail.String())
	}

	// Case 3: Provider returns "unknown" -> ErrOutcomeUnknown, credits held in reconciling, asset stays generating
	balBeforeUnknown := svc.GetWorkspaceBalance(wsID)
	veo.CustomStatus = &ProviderGenStatus{
		Status: "unknown",
	}
	_, err = svc.Generate(ctx, connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		Title:   "Unknown Provider Status Video",
		Prompt:  "Provider status check returns unknown",
	}))
	if err == nil || !errors.Is(err, ErrOutcomeUnknown) {
		t.Fatalf("expected ErrOutcomeUnknown when provider status is unknown, got: %v", err)
	}
	expectedHeldBal, _ := balBeforeUnknown.Sub(tenantdb.MustParseExactDecimal("80"))
	if svc.GetWorkspaceBalance(wsID).Cmp(expectedHeldBal) != 0 {
		t.Fatalf("expected credits held during unknown status, got %s", svc.GetWorkspaceBalance(wsID).String())
	}
	assets, _, _ := store.ListAssets(ctx, wsID, "", "generated", "", 10, 0)
	if len(assets) != 0 {
		t.Fatalf("expected 0 generated/completed assets across processing/failed/unknown statuses, got %d", len(assets))
	}
}

type failingProductionStore struct {
	*MemoryStore
	failCreateJob bool
	failSync      bool
}

func (f *failingProductionStore) CreateJob(ctx context.Context, job *GenerationJob) error {
	if f.failCreateJob {
		return fmt.Errorf("simulated DB error creating generation_job")
	}
	return f.MemoryStore.CreateJob(ctx, job)
}

func (f *failingProductionStore) SyncJobAndAsset(ctx context.Context, workspaceID, jobID, jobStatus, assetState, errorMsg, resultURL, actualCredits, actualCostUSD string) error {
	if f.failSync && jobStatus == "completed" {
		return fmt.Errorf("simulated DB error syncing completed job and asset")
	}
	return f.MemoryStore.SyncJobAndAsset(ctx, workspaceID, jobID, jobStatus, assetState, errorMsg, resultURL, actualCredits, actualCostUSD)
}

func TestAI08_StoreErrorPropagation_And_BoundedRetryWithPreservedPrompt(t *testing.T) {
	ctx := contextWithRole("Editor", "user-1")
	wsID := "ws-test-01"

	fStore := &failingProductionStore{MemoryStore: NewMemoryStore(), failCreateJob: true}
	veo := NewMockVeoProvider()
	kling := NewMockKlingProvider()
	svc := NewService(ServiceConfig{
		Store:            fStore,
		PrimaryProvider:  veo,
		FallbackProvider: kling,
		InitialBalances: map[string]tenantdb.ExactDecimal{
			wsID: tenantdb.MustParseExactDecimal("200"),
		},
	})

	// 1. Pre-dispatch CreateJob error must propagate and release reserved credits without calling provider
	_, err := svc.Generate(ctx, connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		Title:   "Store Failure Video",
		Prompt:  "Original cinematic coffee commercial",
		PostProduction: &productionv1.PostProductionConfig{
			AspectRatio: "16:9",
		},
	}))
	if err == nil || !strings.Contains(err.Error(), "persist generation job") {
		t.Fatalf("expected CreateJob store error to propagate, got: %v", err)
	}
	if veo.GetGenerateCount() != 0 {
		t.Fatalf("expected provider NOT to be called when pre-dispatch CreateJob fails")
	}
	if svc.GetWorkspaceBalance(wsID).Cmp(tenantdb.MustParseExactDecimal("200")) != 0 {
		t.Fatalf("expected reservation released when pre-dispatch CreateJob fails, got %s", svc.GetWorkspaceBalance(wsID).String())
	}

	// 2. Post-dispatch SyncJobAndAsset error must propagate and mark reservation reconciling
	fStore.failCreateJob = false
	fStore.failSync = true
	_, err = svc.Generate(ctx, connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		Title:   "Sync Failure Video",
		Prompt:  "Original cinematic coffee commercial",
	}))
	if err == nil || !strings.Contains(err.Error(), "sync completed job") {
		t.Fatalf("expected post-dispatch SyncJobAndAsset error to propagate, got: %v", err)
	}
	fStore.failSync = false

	// 3. Create a failed job with original prompt & 16:9 aspect ratio, then test bounded Retry & prompt preservation
	veo.FailGeneration = true
	kling.FailGeneration = true
	_, _ = svc.Generate(ctx, connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		Title:   "Retry Target Video",
		Prompt:  "Original cinematic coffee commercial",
		PostProduction: &productionv1.PostProductionConfig{
			AspectRatio: "16:9",
		},
	}))

	// Find the failed job
	var failedJobID string
	for id, j := range fStore.jobs[wsID] {
		if j.Status == "failed" {
			failedJobID = id
			break
		}
	}
	if failedJobID == "" {
		t.Fatalf("expected a failed job in store")
	}

	// Exhaust 3 retry attempts while providers fail -> attempt #4 must be rejected with ErrRetryLimitExceeded
	for attempt := 1; attempt <= 3; attempt++ {
		_, rErr := svc.Retry(ctx, connect.NewRequest(&productionv1.RetryRequest{
			Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
			JobId:   failedJobID,
		}))
		if rErr == nil {
			t.Fatalf("expected retry attempt %d to fail while providers are failing", attempt)
		}
	}
	_, err = svc.Retry(ctx, connect.NewRequest(&productionv1.RetryRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		JobId:   failedJobID,
	}))
	if err == nil || connect.CodeOf(err) != connect.CodeResourceExhausted || !errors.Is(err, ErrRetryLimitExceeded) {
		t.Fatalf("expected retry attempt 4 to fail with ResourceExhausted / ErrRetryLimitExceeded, got: %v", err)
	}

	// Reset RetryCount to 2 and restore provider + circuit breaker health to verify Retry preserves original Prompt & AspectRatio
	job, _ := fStore.GetJob(ctx, wsID, failedJobID)
	job.RetryCount = 2
	_ = fStore.UpdateJob(ctx, job)
	veo.FailGeneration = false
	svc.router.primaryCB.RecordSuccess()

	balBeforeRetry := svc.GetWorkspaceBalance(wsID)
	retryResp, err := svc.Retry(ctx, connect.NewRequest(&productionv1.RetryRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		JobId:   failedJobID,
	}))
	if err != nil {
		t.Fatalf("expected retry attempt 3 to succeed when provider recovers, got: %v", err)
	}
	if retryResp.Msg.GetJob().GetStatus() != productionv1.GenerationJobStatus_GENERATION_JOB_STATUS_COMPLETED {
		t.Fatalf("expected retried job status COMPLETED, got %v", retryResp.Msg.GetJob().GetStatus())
	}

	// Verify provider received original Prompt and AspectRatio (NOT jobID and hardcoded "9:16")!
	lastReq := veo.GetLastRequest()
	if lastReq.Prompt != "Original cinematic coffee commercial" {
		t.Fatalf("expected Retry to preserve original prompt %q, got %q", "Original cinematic coffee commercial", lastReq.Prompt)
	}
	if lastReq.AspectRatio != "16:9" {
		t.Fatalf("expected Retry to preserve original aspect ratio '16:9', got %q", lastReq.AspectRatio)
	}

	// Verify fresh credit reservation was deducted on retry
	expectedAfterRetry, _ := balBeforeRetry.Sub(tenantdb.MustParseExactDecimal("80"))
	if svc.GetWorkspaceBalance(wsID).Cmp(expectedAfterRetry) != 0 {
		t.Fatalf("expected fresh credit deduction on retry (balance %s), got %s",
			expectedAfterRetry.String(), svc.GetWorkspaceBalance(wsID).String())
	}
}

func TestVideoEngineProvider_AsyncRenderLifecycle_And_WebhookVerification(t *testing.T) {
	var pollCount int32
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Header.Get("X-API-Key") != "cve-test-key" {
			http.Error(w, `{"error":"unauthorized"}`, http.StatusUnauthorized)
			return
		}
		switch {
		case r.Method == http.MethodPost && r.URL.Path == "/v1/compositions":
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusCreated)
			_ = json.NewEncoder(w).Encode(map[string]any{
				"id":     "comp-001",
				"status": "ready",
			})
		case r.Method == http.MethodPost && r.URL.Path == "/v1/render-jobs":
			if r.Header.Get("Idempotency-Key") == "" {
				http.Error(w, `{"error":"missing Idempotency-Key"}`, http.StatusBadRequest)
				return
			}
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusAccepted)
			_ = json.NewEncoder(w).Encode(map[string]any{
				"id":     "cve-job-001",
				"status": "queued",
			})
		case r.Method == http.MethodGet && r.URL.Path == "/v1/jobs/cve-job-001":
			cnt := atomic.AddInt32(&pollCount, 1)
			w.Header().Set("Content-Type", "application/json")
			if cnt == 1 {
				_ = json.NewEncoder(w).Encode(map[string]any{
					"id":           "cve-job-001",
					"status":       "processing",
					"progress_pct": 50,
				})
				return
			}
			_ = json.NewEncoder(w).Encode(map[string]any{
				"id":               "cve-job-001",
				"status":           "completed",
				"progress_pct":     100,
				"output_url":       "https://cdn.creativanta.test/cve/cve-job-001.mp4",
				"duration_seconds": 15.0,
				"resolution":       "1080x1920",
			})
		default:
			http.NotFound(w, r)
		}
	}))
	defer server.Close()

	cveProvider := NewVideoEngineProvider(VideoEngineConfig{
		BaseURL:       server.URL,
		APIKey:        "cve-test-key",
		WebhookSecret: "whsec-test-secret",
	})

	store := NewMemoryStore()
	svc := NewService(ServiceConfig{
		Store:           store,
		PrimaryProvider: cveProvider,
		InitialBalances: map[string]tenantdb.ExactDecimal{
			"ws-cve": tenantdb.MustParseExactDecimal("100"),
		},
	})
	ctx := contextWithRole("Editor", "user-cve")

	// 1. Generate submits composition + render job; first status poll returns "processing",
	// so Generate returns an honest PROCESSING job and GENERATING asset (no fake immediate completion!)
	resp, err := svc.Generate(ctx, connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: "ws-cve"}},
		Title:   "CVE Async Render",
		Prompt:  "Render product showcase via Creativanta Video Engine",
	}))
	if err != nil {
		t.Fatalf("Generate with VideoEngineProvider failed: %v", err)
	}
	if resp.Msg.GetJob().GetStatus() != productionv1.GenerationJobStatus_GENERATION_JOB_STATUS_PROCESSING {
		t.Fatalf("expected async render job status PROCESSING, got %v", resp.Msg.GetJob().GetStatus())
	}
	if resp.Msg.GetAsset().GetGenerationState() != productionv1.AssetGenerationState_ASSET_GENERATION_STATE_GENERATING {
		t.Fatalf("expected async asset state GENERATING, got %v", resp.Msg.GetAsset().GetGenerationState())
	}

	// 2. Subsequent CheckStatus on provider observes "completed" with output URL
	st, err := cveProvider.CheckStatus(ctx, resp.Msg.GetJob().GetProviderJobId())
	if err != nil {
		t.Fatalf("CheckStatus failed: %v", err)
	}
	if st.Status != "completed" || st.ResultURL != "https://cdn.creativanta.test/cve/cve-job-001.mp4" {
		t.Fatalf("expected completed status with output URL on 2nd poll, got %+v", st)
	}

	// 3. Verify X-CVE-Signature webhook HMAC verification
	payload := []byte(`{"event":"job.completed","job_id":"cve-job-001"}`)
	mac := hmac.New(sha256.New, []byte("whsec-test-secret"))
	mac.Write(payload)
	validSig := "sha256=" + hex.EncodeToString(mac.Sum(nil))
	if !cveProvider.VerifyWebhookSignature(payload, validSig) {
		t.Fatalf("expected valid X-CVE-Signature to pass verification")
	}
	if cveProvider.VerifyWebhookSignature(payload, "sha256=deadbeef") {
		t.Fatalf("expected invalid X-CVE-Signature to fail verification")
	}
}

func TestR4_F07_CancelDoesNotReleaseCreditsOrAllowRetryWhileOutcomeUnknown(t *testing.T) {
	svc, store, veo, kling := setupTestService(t)
	ctx := contextWithRole("Editor", "user-1")
	wsID := "ws-test-01"
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("100"))

	// Primary provider times out -> job enters processing with PROVIDER_OUTCOME_UNKNOWN and reservation in "reconciling"
	veo.TimeoutOnCall = true
	_, err := svc.Generate(ctx, connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		Title:   "F07 Unknown Outcome Cancel Test",
		Prompt:  "Verify cancel does not release reconciling credits",
		Mode:    productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE,
	}))
	if err == nil || !errors.Is(err, ErrOutcomeUnknown) {
		t.Fatalf("expected ErrOutcomeUnknown on timeout, got %v", err)
	}

	activeJobs, _ := store.ListActiveJobs(ctx, wsID)
	if len(activeJobs) != 1 {
		t.Fatalf("expected 1 active job, got %d", len(activeJobs))
	}
	jobID := activeJobs[0].JobID

	// 1. Cancel while outcome is unknown MUST fail closed without releasing the 80 reserved credits
	_, cancelErr := svc.Cancel(ctx, connect.NewRequest(&productionv1.CancelRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		JobId:   jobID,
	}))
	if cancelErr == nil || connect.CodeOf(cancelErr) != connect.CodeFailedPrecondition || !errors.Is(cancelErr, ErrOutcomeUnknown) {
		t.Fatalf("expected Cancel on unknown outcome job to fail with FailedPrecondition/ErrOutcomeUnknown, got: %v", cancelErr)
	}

	if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(tenantdb.MustParseExactDecimal("20")) != 0 {
		t.Fatalf("F07 VIOLATION: Cancel released credits while provider outcome was unknown! Balance=%s, expected 20", bal.String())
	}
	resRec, ok := svc.GetReservationByJob(jobID)
	if !ok || resRec.Status != "reconciling" || !resRec.CancelRequested {
		t.Fatalf("expected reservation to stay 'reconciling' with CancelRequested=true, got %+v", resRec)
	}

	// 2. Retry while outcome is unknown MUST also fail closed with 0 new provider calls
	veo.TimeoutOnCall = false
	_, retryErr := svc.Retry(ctx, connect.NewRequest(&productionv1.RetryRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		JobId:   jobID,
	}))
	if retryErr == nil || connect.CodeOf(retryErr) != connect.CodeFailedPrecondition {
		t.Fatalf("expected Retry on reconciling job to fail with FailedPrecondition, got: %v", retryErr)
	}
	if veo.GetGenerateCount() != 1 || kling.GetGenerateCount() != 0 {
		t.Fatalf("expected no duplicate provider calls during unknown outcome, got veo=%d kling=%d", veo.GetGenerateCount(), kling.GetGenerateCount())
	}

	// 3. ReconcileJobOutcome confirming provider non-execution releases the held 80 credits and marks job cancelled
	if err := svc.ReconcileJobOutcome(ctx, wsID, jobID, "confirmed_not_executed", tenantdb.ZeroDecimal(), ""); err != nil {
		t.Fatalf("ReconcileJobOutcome failed: %v", err)
	}
	if bal := svc.GetWorkspaceBalance(wsID); bal.Cmp(tenantdb.MustParseExactDecimal("100")) != 0 {
		t.Fatalf("expected balance restored to 100 after confirmed non-execution reconciliation, got %s", bal.String())
	}
	reconciledJob, _ := store.GetJob(ctx, wsID, jobID)
	if reconciledJob.Status != "cancelled" {
		t.Fatalf("expected job status 'cancelled' after reconciliation of cancel-requested job, got %s", reconciledJob.Status)
	}
}

func TestR4_F08_CommitReservationRefundsUnusedQuoteHold(t *testing.T) {
	svc, _, veo, _ := setupTestService(t)
	ctx := contextWithRole("Editor", "user-1")
	wsID := "ws-test-01"
	svc.SetWorkspaceBalance(wsID, tenantdb.MustParseExactDecimal("100"))

	// Configure Veo to complete with lower actual cost ($0.30 -> 40 credits) against an 80-credit quote ceiling
	veo.CustomStatus = &ProviderGenStatus{
		Status:       "completed",
		ProgressPct:  100,
		ResultURL:    "https://cdn.creativanta.test/outputs/actual-40.mp4",
		DurationSecs: tenantdb.MustParseExactDecimal("7.500000"),
		Resolution:   "1080x1920",
		CostUSD:      tenantdb.MustParseExactDecimal("0.300000"),
	}

	resp, err := svc.Generate(ctx, connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: wsID}},
		Title:   "F08 Partial Actual Cost Video",
		Prompt:  "Verify commitReservation refunds unused reserved credits",
		Mode:    productionv1.ProductionMode_PRODUCTION_MODE_PRODUCT_SHOWCASE,
	}))
	if err != nil {
		t.Fatalf("Generate failed: %v", err)
	}
	if resp.Msg.GetJob().GetEstimatedCredits() != "80" {
		t.Fatalf("expected estimated_credits 80, got %s", resp.Msg.GetJob().GetEstimatedCredits())
	}
	if resp.Msg.GetJob().GetActualCredits() != "40" {
		t.Fatalf("expected actual_credits 40, got %s", resp.Msg.GetJob().GetActualCredits())
	}

	// Balance must be 100 - 40 actual = 60 (NOT 100 - 80 quote = 20!)
	bal := svc.GetWorkspaceBalance(wsID)
	if bal.Cmp(tenantdb.MustParseExactDecimal("60")) != 0 {
		t.Fatalf("F08 VIOLATION: expected workspace balance 60 after reserving 80 and committing 40 actual, got %s", bal.String())
	}
	resRec, ok := svc.GetReservationByJob(resp.Msg.GetJob().GetJobId())
	if !ok || resRec.Status != "committed" || resRec.ActualCredits.Cmp(tenantdb.MustParseExactDecimal("40")) != 0 {
		t.Fatalf("expected committed reservation with ActualCredits=40, got %+v", resRec)
	}
}

func TestR4_VideoEngineProvider_AmbiguousPostRenderJobsNeverTriggersFallback(t *testing.T) {
	var renderCalls int32
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		switch {
		case r.Method == http.MethodPost && r.URL.Path == "/v1/compositions":
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusCreated)
			_ = json.NewEncoder(w).Encode(map[string]any{"id": "comp-ambig-1", "status": "ready"})
		case r.Method == http.MethodPost && r.URL.Path == "/v1/render-jobs":
			atomic.AddInt32(&renderCalls, 1)
			// Server accepts the render job (202 Accepted) but returns truncated/corrupted JSON
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusAccepted)
			_, _ = w.Write([]byte(`{"id":`))
		default:
			http.NotFound(w, r)
		}
	}))
	defer server.Close()

	cveProvider := NewVideoEngineProvider(VideoEngineConfig{
		BaseURL: server.URL,
		APIKey:  "cve-test-key",
	})
	klingFallback := NewMockKlingProvider()
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{
		Store:            store,
		PrimaryProvider:  cveProvider,
		FallbackProvider: klingFallback,
		InitialBalances: map[string]tenantdb.ExactDecimal{
			"ws-ambig": tenantdb.MustParseExactDecimal("100"),
		},
	})

	ctx := contextWithRole("Editor", "user-1")
	_, err := svc.Generate(ctx, connect.NewRequest(&productionv1.GenerateRequest{
		Context: &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: "ws-ambig"}},
		Title:   "Ambiguous Render Job Response",
		Prompt:  "Primary accepted render job then dropped/truncated response",
	}))
	if err == nil || !errors.Is(err, ErrOutcomeUnknown) {
		t.Fatalf("expected ErrOutcomeUnknown when POST /v1/render-jobs returns corrupted 202 response, got: %v", err)
	}
	if atomic.LoadInt32(&renderCalls) != 1 {
		t.Fatalf("expected 1 primary render-job call, got %d", renderCalls)
	}
	if klingFallback.GetGenerateCount() != 0 {
		t.Fatalf("UNSAFE RETRY VIOLATION: fallback provider was called %d times after primary accepted render job!", klingFallback.GetGenerateCount())
	}
}
