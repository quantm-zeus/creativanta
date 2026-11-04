package idea

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/conversion"
)

const (
	testWorkspaceA  = "11111111-1111-4111-8111-111111111111"
	testWorkspaceB  = "22222222-2222-4222-8222-222222222222"
	testUserOwner   = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
	testUserEditor  = "cccccccc-cccc-4ccc-8ccc-cccccccccccc"
	testUserMember  = "dddddddd-dddd-4ddd-8ddd-dddddddddddd"
	testUserContrib = "eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee"
)

func newTestService() *Service {
	return NewService(ServiceConfig{
		Store: NewMemoryStore(),
	})
}

// ============================================================================
// Acceptance Target 1: Duplicate idea warns without silent merge
// ============================================================================

func TestAcceptanceTarget1_DuplicateIdeaWarnsWithoutSilentMerge(t *testing.T) {
	svc := newTestService()
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserContrib,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "contributor",
	})

	// 1. Create original idea
	firstTitle := "Hướng dẫn skincare mùa hè"
	resp1, err := svc.Create(ctx, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId:     testWorkspaceA,
		Title:           firstTitle,
		Description:     "Các bước dưỡng ẩm và chống nắng mùa nóng",
		SuggestedFormat: "short_form",
	}))
	if err != nil {
		t.Fatalf("first idea creation failed: %v", err)
	}
	if !resp1.Msg.Created {
		t.Fatalf("expected first idea to be created")
	}
	firstID := resp1.Msg.Idea.IdeaId

	// 2. Attempt to create a similar idea: "5 cách chăm sóc da mùa hè"
	// (calculates similarity > 0.85 with "skincare mùa hè" or substring containment)
	similarTitle := "Hướng dẫn skincare mùa hè cho da dầu"
	resp2, err := svc.Create(ctx, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId:      testWorkspaceA,
		Title:            similarTitle,
		ConfirmDuplicate: false, // Default: user hasn't explicitly confirmed
	}))
	if err != nil {
		t.Fatalf("similar idea creation request failed: %v", err)
	}

	// Must NOT be created silently or auto-merged
	if resp2.Msg.Created {
		t.Fatalf("expected similar idea NOT to be created without confirmation")
	}
	if resp2.Msg.DuplicateWarning == nil || !resp2.Msg.DuplicateWarning.IsDuplicate {
		t.Fatalf("expected DuplicateWarning with is_duplicate=true")
	}
	if resp2.Msg.DuplicateWarning.SimilarityScore < 0.85 {
		t.Fatalf("expected similarity >= 0.85, got %f", resp2.Msg.DuplicateWarning.SimilarityScore)
	}
	if resp2.Msg.DuplicateWarning.ExistingIdeaId != firstID {
		t.Fatalf("expected existing idea ID %s, got %s", firstID, resp2.Msg.DuplicateWarning.ExistingIdeaId)
	}

	// 3. User chooses to proceed anyway (ConfirmDuplicate = true)
	resp3, err := svc.Create(ctx, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId:      testWorkspaceA,
		Title:            similarTitle,
		ConfirmDuplicate: true, // User chooses to proceed
	}))
	if err != nil {
		t.Fatalf("confirmed duplicate creation failed: %v", err)
	}
	if !resp3.Msg.Created {
		t.Fatalf("expected idea to be created when confirmed")
	}
	secondID := resp3.Msg.Idea.IdeaId

	// 4. Verify both ideas exist independently without silent merge
	get1, err := svc.Get(ctx, connect.NewRequest(&contentv1.IdeaServiceGetRequest{
		WorkspaceId: testWorkspaceA,
		IdeaId:      firstID,
	}))
	if err != nil {
		t.Fatalf("get first idea failed: %v", err)
	}
	if get1.Msg.Idea.Title != firstTitle {
		t.Fatalf("expected first idea title %q, got %q", firstTitle, get1.Msg.Idea.Title)
	}

	get2, err := svc.Get(ctx, connect.NewRequest(&contentv1.IdeaServiceGetRequest{
		WorkspaceId: testWorkspaceA,
		IdeaId:      secondID,
	}))
	if err != nil {
		t.Fatalf("get second idea failed: %v", err)
	}
	if get2.Msg.Idea.Title != similarTitle {
		t.Fatalf("expected second idea title %q, got %q", similarTitle, get2.Msg.Idea.Title)
	}
	if firstID == secondID {
		t.Fatalf("ideas should have distinct IDs; got collision")
	}
}

// ============================================================================
// Acceptance Target 2: Source lineage retained
// ============================================================================

func TestAcceptanceTarget2_SourceLineageRetained(t *testing.T) {
	svc := newTestService()
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserContrib,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "contributor",
	})

	// 1. Create idea with trend source
	trendID := "trend-skincare-2026"
	trendTitle := "Xu hướng tối giản Skincare Routine"
	respTrend, err := svc.Create(ctx, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId: testWorkspaceA,
		Title:       "Quy trình skincare tối giản 3 bước",
		SourceRefs: []*contentv1.IdeaSourceRef{
			{
				SourceType:  "trend",
				SourceId:    trendID,
				SourceTitle: trendTitle,
				SourceUrl:   "https://creativanta.app/trends/" + trendID,
			},
		},
	}))
	if err != nil {
		t.Fatalf("create trend idea failed: %v", err)
	}
	if len(respTrend.Msg.Idea.Sources) != 1 {
		t.Fatalf("expected 1 source ref, got %d", len(respTrend.Msg.Idea.Sources))
	}
	src := respTrend.Msg.Idea.Sources[0]
	if src.SourceType != "trend" || src.SourceId != trendID || src.SourceTitle != trendTitle {
		t.Fatalf("unexpected source values: %+v", src)
	}

	// 2. EC-M05-002: Source object deleted or expired
	// Expected behavior: Idea remains valid with intact idea_sources entry and archive notice.
	respExpired, err := svc.Create(ctx, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId: testWorkspaceA,
		Title:       "Đánh giá thành phần kem chống nắng",
		SourceRefs: []*contentv1.IdeaSourceRef{
			{
				SourceType:    "trend",
				SourceId:      "trend-expired-123",
				SourceTitle:   "Cơn sốt chống nắng vật lý",
				IsArchived:    true,
				ArchiveNotice: "Source trend has expired — view archived data",
			},
		},
	}))
	if err != nil {
		t.Fatalf("create expired trend idea failed: %v", err)
	}
	if len(respExpired.Msg.Idea.Sources) != 1 {
		t.Fatalf("expected 1 source ref")
	}
	expiredSrc := respExpired.Msg.Idea.Sources[0]
	if !expiredSrc.IsArchived || expiredSrc.ArchiveNotice == "" {
		t.Fatalf("expected archived source flag and notice to be preserved, got %+v", expiredSrc)
	}

	// 3. Manual entry fallback per RULE-M05-001
	respManual, err := svc.Create(ctx, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId: testWorkspaceA,
		Title:       "Ý tưởng tự phát từ brainstorm",
	}))
	if err != nil {
		t.Fatalf("create manual idea failed: %v", err)
	}
	if len(respManual.Msg.Idea.Sources) != 1 {
		t.Fatalf("expected manual idea to have fallback source ref")
	}
	manualSrc := respManual.Msg.Idea.Sources[0]
	if manualSrc.SourceType != "manual" || manualSrc.SourceId != testUserContrib {
		t.Fatalf("expected source_type='manual' and source_id=user_id, got %+v", manualSrc)
	}
}

// ============================================================================
// Acceptance Target 3: Mobile title-only draft works
// ============================================================================

func TestAcceptanceTarget3_MobileTitleOnlyDraftWorks(t *testing.T) {
	svc := newTestService()
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserContrib,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "contributor",
	})

	// User on mobile enters only title, taps save
	title := "Review son dưỡng môi chống khô nẻ"
	resp, err := svc.Create(ctx, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId:          testWorkspaceA,
		Title:                title,
		IsMobileQuickCapture: true,
	}))
	if err != nil {
		t.Fatalf("mobile quick capture failed: %v", err)
	}

	idea := resp.Msg.Idea
	if idea.Title != title {
		t.Fatalf("expected title %q, got %q", title, idea.Title)
	}
	if idea.Status != contentv1.IdeaStatus_IDEA_STATUS_DRAFT {
		t.Fatalf("expected status DRAFT, got %s", idea.Status)
	}
	if idea.Description != "" {
		t.Fatalf("expected empty description for title-only draft, got %q", idea.Description)
	}
	if idea.SuggestedFormat != "" {
		t.Fatalf("expected empty suggested_format for title-only draft, got %q", idea.SuggestedFormat)
	}
	if len(idea.Sources) == 0 {
		t.Fatalf("expected mobile capture to have lineage source link")
	}
}

// ============================================================================
// Canonical State Machine Progression & State Skipping Prohibition (RULE-M05-002)
// ============================================================================

func TestStateMachineProgressionAndForbiddenSkips(t *testing.T) {
	svc := newTestService()
	ctxEditor := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserEditor,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "editor",
	})

	// 1. Create draft
	respCreate, err := svc.Create(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId:     testWorkspaceA,
		Title:           "Chiến lược bán hàng affiliate livestream",
		Description:     "Kịch bản chốt đơn 100 deal trong 30 phút",
		SuggestedFormat: "live",
	}))
	if err != nil {
		t.Fatalf("create failed: %v", err)
	}
	ideaID := respCreate.Msg.Idea.IdeaId

	// 2. Forbidden state skip: Draft -> Converted must fail!
	_, errSkip1 := svc.UpdateStatus(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceUpdateStatusRequest{
		WorkspaceId:  testWorkspaceA,
		IdeaId:       ideaID,
		TargetStatus: contentv1.IdeaStatus_IDEA_STATUS_CONVERTED,
	}))
	if errSkip1 == nil {
		t.Fatalf("expected state skip draft -> converted to fail")
	}

	// 3. Forbidden state skip: Draft -> Selected must fail!
	_, errSkip2 := svc.UpdateStatus(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceUpdateStatusRequest{
		WorkspaceId:  testWorkspaceA,
		IdeaId:       ideaID,
		TargetStatus: contentv1.IdeaStatus_IDEA_STATUS_SELECTED,
	}))
	if errSkip2 == nil {
		t.Fatalf("expected state skip draft -> selected to fail")
	}

	// 4. Valid progression: Draft -> Candidate
	respCand, err := svc.UpdateStatus(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceUpdateStatusRequest{
		WorkspaceId:  testWorkspaceA,
		IdeaId:       ideaID,
		TargetStatus: contentv1.IdeaStatus_IDEA_STATUS_CANDIDATE,
	}))
	if err != nil {
		t.Fatalf("transition to candidate failed: %v", err)
	}
	if respCand.Msg.Idea.Status != contentv1.IdeaStatus_IDEA_STATUS_CANDIDATE {
		t.Fatalf("expected status CANDIDATE")
	}

	// 5. Valid progression: Candidate -> Selected
	respSel, err := svc.UpdateStatus(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceUpdateStatusRequest{
		WorkspaceId:  testWorkspaceA,
		IdeaId:       ideaID,
		TargetStatus: contentv1.IdeaStatus_IDEA_STATUS_SELECTED,
	}))
	if err != nil {
		t.Fatalf("transition to selected failed: %v", err)
	}
	if respSel.Msg.Idea.Status != contentv1.IdeaStatus_IDEA_STATUS_SELECTED {
		t.Fatalf("expected status SELECTED")
	}

	// 6. Valid conversion: Selected -> Converted via Convert API
	respConv, err := svc.Convert(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceConvertRequest{
		WorkspaceId:    testWorkspaceA,
		IdeaId:         ideaID,
		ConversionType: "script",
	}))
	if err != nil {
		t.Fatalf("convert to script failed: %v", err)
	}
	if respConv.Msg.Idea.Status != contentv1.IdeaStatus_IDEA_STATUS_CONVERTED {
		t.Fatalf("expected status CONVERTED")
	}
	if respConv.Msg.ConvertedToType != "script" || respConv.Msg.ScriptId == "" {
		t.Fatalf("expected script conversion reference, got type=%s id=%s", respConv.Msg.ConvertedToType, respConv.Msg.ScriptId)
	}
}

// ============================================================================
// EC-M05-004: Converting Idea Without Required Fields
// ============================================================================

func TestConvertingIdeaWithoutRequiredFieldsFails(t *testing.T) {
	svc := newTestService()
	ctxEditor := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserEditor,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "editor",
	})

	// Create draft idea with only title (no description, no suggested_format)
	resp, err := svc.Create(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId: testWorkspaceA,
		Title:       "Ý tưởng chưa điền mô tả",
	}))
	if err != nil {
		t.Fatalf("create failed: %v", err)
	}

	// Convert without required fields must be blocked with validation error
	_, errConv := svc.Convert(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceConvertRequest{
		WorkspaceId:    testWorkspaceA,
		IdeaId:         resp.Msg.Idea.IdeaId,
		ConversionType: "script",
	}))
	if errConv == nil {
		t.Fatalf("expected conversion without description/format to fail")
	}
	if !errors.Is(errConv, ErrConversionValidationFailed) && !strings.Contains(errConv.Error(), "description and suggested format") {
		t.Fatalf("expected ErrConversionValidationFailed, got %v", errConv)
	}
}

// ============================================================================
// EC-M05-003: AI Generation Rate Limiting (max 20/hr per workspace)
// ============================================================================

func TestAIGenerationRateLimiting(t *testing.T) {
	svc := newTestService()
	ctxEditor := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserEditor,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "editor",
	})

	// Pre-fill 20 generations in the last 10 minutes
	memStore := svc.store.(*MemoryStore)
	now := time.Now().UTC()
	for i := 0; i < 20; i++ {
		_ = memStore.RecordAIGeneration(context.Background(), testWorkspaceA, now.Add(-time.Duration(i)*time.Minute))
	}

	// 21st generation must fail with ErrHourlyRateLimitExceeded
	_, err := svc.Generate(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceGenerateRequest{
		WorkspaceId:    testWorkspaceA,
		Prompt:         "Affiliate marketing hooks for headphones",
		TargetAudience: "Tech enthusiasts",
		Count:          3,
	}))
	if err == nil {
		t.Fatalf("expected 21st AI generation to exceed hourly rate limit")
	}
	if !errors.Is(err, ErrHourlyRateLimitExceeded) && !strings.Contains(err.Error(), "rate limit exceeded") {
		t.Fatalf("expected rate limit error, got %v", err)
	}
}

// ============================================================================
// Concurrency & Thread-Safety (Zero Data Races)
// ============================================================================

func TestConcurrentIdeaOperationsNoRace(t *testing.T) {
	svc := newTestService()
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserEditor,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "editor",
	})

	var wg sync.WaitGroup
	errCh := make(chan error, 50)

	for i := 0; i < 25; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			title := fmt.Sprintf("Unique Topic Alpha %d Beta %d", idx, idx*100)
			resp, err := svc.Create(ctx, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
				WorkspaceId:      testWorkspaceA,
				Title:            title,
				Description:      "Concurrent test payload",
				SuggestedFormat:  "short_form",
				InitialHooks:     []string{fmt.Sprintf("Hook for #%d", idx)},
				ConfirmDuplicate: true,
			}))
			if err != nil {
				errCh <- err
				return
			}
			if resp.Msg.Idea == nil {
				errCh <- fmt.Errorf("expected idea in response for index %d", idx)
				return
			}
			// Concurrently read
			_, err = svc.Get(ctx, connect.NewRequest(&contentv1.IdeaServiceGetRequest{
				WorkspaceId: testWorkspaceA,
				IdeaId:      resp.Msg.Idea.IdeaId,
			}))
			if err != nil {
				errCh <- err
			}
		}(i)
	}

	wg.Wait()
	close(errCh)

	for err := range errCh {
		t.Fatalf("concurrent idea operation error: %v", err)
	}
}

// ============================================================================
// Multi-Tenant Isolation
// ============================================================================

func TestMultiTenantIsolation(t *testing.T) {
	svc := newTestService()
	ctxA := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserEditor,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "editor",
	})
	ctxB := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserEditor,
		WorkspaceID:   testWorkspaceB,
		WorkspaceRole: "editor",
	})

	// Create idea in workspace A
	respA, err := svc.Create(ctxA, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId: testWorkspaceA,
		Title:       "Workspace A Private Idea",
	}))
	if err != nil {
		t.Fatalf("create in workspace A failed: %v", err)
	}
	idA := respA.Msg.Idea.IdeaId

	// Caller in workspace B attempts to get workspace A idea -> cross-tenant denied
	_, errCross := svc.Get(ctxB, connect.NewRequest(&contentv1.IdeaServiceGetRequest{
		WorkspaceId: testWorkspaceA, // attempting to pass foreign workspace ID
		IdeaId:      idA,
	}))
	if errCross == nil {
		t.Fatalf("expected cross-tenant access to be denied")
	}

	// Caller in workspace B attempting to get with workspace B id -> not found
	_, errNotFound := svc.Get(ctxB, connect.NewRequest(&contentv1.IdeaServiceGetRequest{
		WorkspaceId: testWorkspaceB,
		IdeaId:      idA,
	}))
	if errNotFound == nil {
		t.Fatalf("expected foreign idea in workspace B to be not found")
	}
}

// ============================================================================
// RBAC Permission Gating (idea:create, idea:read, idea:convert)
// ============================================================================

func TestRBACPermissionGating(t *testing.T) {
	svc := newTestService()

	ctxViewer := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserMember,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "viewer",
	})
	ctxContrib := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserContrib,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "contributor",
	})
	ctxEditor := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserEditor,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "editor",
	})

	// 1. Viewer cannot create idea (needs Contributor+)
	_, errViewerCreate := svc.Create(ctxViewer, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId: testWorkspaceA,
		Title:       "Viewer Attempt",
	}))
	if errViewerCreate == nil {
		t.Fatalf("expected Viewer creation to be denied by RBAC")
	}

	// 2. Contributor can create idea
	respContrib, errContribCreate := svc.Create(ctxContrib, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId:     testWorkspaceA,
		Title:           "Contributor Idea",
		Description:     "Ready for conversion",
		SuggestedFormat: "short_form",
	}))
	if errContribCreate != nil {
		t.Fatalf("contributor create should succeed, got %v", errContribCreate)
	}

	// 3. Contributor CANNOT convert idea (needs Editor+)
	_, errContribConvert := svc.Convert(ctxContrib, connect.NewRequest(&contentv1.IdeaServiceConvertRequest{
		WorkspaceId:    testWorkspaceA,
		IdeaId:         respContrib.Msg.Idea.IdeaId,
		ConversionType: "script",
	}))
	if errContribConvert == nil {
		t.Fatalf("expected Contributor conversion to be denied by RBAC (Editor+ required)")
	}

	// 4. Editor CAN convert idea
	_, errEditorConvert := svc.Convert(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceConvertRequest{
		WorkspaceId:    testWorkspaceA,
		IdeaId:         respContrib.Msg.Idea.IdeaId,
		ConversionType: "script",
	}))
	if errEditorConvert != nil {
		t.Fatalf("editor convert should succeed, got %v", errEditorConvert)
	}

	// 5. Viewer CAN read ideas
	_, errViewerRead := svc.List(ctxViewer, connect.NewRequest(&contentv1.IdeaServiceListRequest{
		WorkspaceId: testWorkspaceA,
	}))
	if errViewerRead != nil {
		t.Fatalf("viewer should have idea:read permission, got %v", errViewerRead)
	}
}

func TestP608_CrossDomainIdeaConversionsWithPermissionCheck(t *testing.T) {
	ctx := context.Background()
	svc := newTestService()
	lineageStore := conversion.NewMemoryLineageStore()
	svc.SetLineageStore(lineageStore)

	ctxEditor := WithCallerContext(ctx, CallerContext{
		UserID:        testUserEditor,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "editor",
	})
	ctxManager := WithCallerContext(ctx, CallerContext{
		UserID:        testUserOwner,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "manager",
	})

	// Create test idea
	createResp, err := svc.Create(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId:     testWorkspaceA,
		Title:           "Sữa rửa mặt dịu nhẹ cho da mụn",
		Description:     "Đánh giá thành phần và trải nghiệm thực tế",
		SuggestedFormat: "short_form_review",
	}))
	if err != nil {
		t.Fatalf("Create idea failed: %v", err)
	}
	ideaID := createResp.Msg.Idea.IdeaId

	// 1. Target Permission Recheck: Editor converting to deal must be DENIED (brand_deal:manage is Manager+)
	_, errDealEditor := svc.Convert(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceConvertRequest{
		WorkspaceId:    testWorkspaceA,
		IdeaId:         ideaID,
		ConversionType: "deal",
	}))
	if errDealEditor == nil {
		t.Fatalf("expected editor conversion to deal to fail target permission recheck")
	}

	// 2. Editor converting to campaign (campaign:manage) -> SUCCEEDS
	convResp, err := svc.Convert(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceConvertRequest{
		WorkspaceId:    testWorkspaceA,
		IdeaId:         ideaID,
		ConversionType: "campaign",
	}))
	if err != nil {
		t.Fatalf("expected editor conversion to campaign to succeed, got: %v", err)
	}
	if convResp.Msg.ConvertedToType != "campaign" {
		t.Errorf("expected converted_to_type campaign, got %s", convResp.Msg.ConvertedToType)
	}

	// 3. Verify shared lineage recorded in LineageStore
	lineageRecs, err := lineageStore.ListLineageBySource(ctx, testWorkspaceA, conversion.SourceTypeIdea, ideaID)
	if err != nil || len(lineageRecs) == 0 {
		t.Fatalf("expected shared lineage record for idea conversion, got len=%d err=%v", len(lineageRecs), err)
	}
	if lineageRecs[0].TargetType != conversion.TargetTypeCampaign {
		t.Errorf("expected lineage target_type campaign, got %s", lineageRecs[0].TargetType)
	}

	// 4. Source Survives Conversion: querying idea confirms it is intact and queryable
	getResp, err := svc.Get(ctxEditor, connect.NewRequest(&contentv1.IdeaServiceGetRequest{
		WorkspaceId: testWorkspaceA,
		IdeaId:      ideaID,
	}))
	if err != nil {
		t.Fatalf("expected idea to survive and be retrievable, got: %v", err)
	}
	if getResp.Msg.Idea.Status != contentv1.IdeaStatus_IDEA_STATUS_CONVERTED {
		t.Errorf("expected idea status CONVERTED, got %v", getResp.Msg.Idea.Status)
	}
	if getResp.Msg.Idea.ConvertedToType != "campaign" {
		t.Errorf("expected idea ConvertedToType campaign, got %s", getResp.Msg.Idea.ConvertedToType)
	}

	// 5. Manager converting to brand deal succeeds
	createResp2, _ := svc.Create(ctxManager, connect.NewRequest(&contentv1.IdeaServiceCreateRequest{
		WorkspaceId:     testWorkspaceA,
		Title:           "Ý tưởng hợp tác thương hiệu thời trang",
		Description:     "Bộ phối đồ phong cách thu đông",
		SuggestedFormat: "carousel",
	}))
	_, errMgrDeal := svc.Convert(ctxManager, connect.NewRequest(&contentv1.IdeaServiceConvertRequest{
		WorkspaceId:    testWorkspaceA,
		IdeaId:         createResp2.Msg.Idea.IdeaId,
		ConversionType: "deal",
	}))
	if errMgrDeal != nil {
		t.Fatalf("manager converting idea to deal should succeed, got: %v", errMgrDeal)
	}
}
