package production

import (
	"context"
	"fmt"
	"testing"
	"time"

	"connectrpc.com/connect"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
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

	// Verify credit debit occurred exactly ONCE (No Double Charge)
	// Quoted credits for 15s @ $0.04/s = $0.60 -> 80 credits. Initial balance 100 -> remaining 20.
	remainingBal := svc.GetWorkspaceBalance(wsID)
	if remainingBal.IsNegative() {
		t.Fatalf("double charge occurred! balance went negative: %s", remainingBal.String())
	}
	if remainingBal.Cmp(tenantdb.MustParseExactDecimal("20")) != 0 {
		t.Errorf("expected remaining balance 20 credits, got %s", remainingBal.String())
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
