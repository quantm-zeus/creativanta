package opportunity

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	intelligencev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/intelligence/v1"
)

const (
	testWorkspaceA  = "11111111-1111-4111-8111-111111111111"
	testWorkspaceB  = "22222222-2222-4222-8222-222222222222"
	testUserOwner   = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
	testUserManager = "bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb"
	testUserEditor  = "cccccccc-cccc-4ccc-8ccc-cccccccccccc"
	testUserMember  = "dddddddd-dddd-4ddd-8ddd-dddddddddddd"
)

func newTestService() *Service {
	return NewService(ServiceConfig{
		Store: NewMemoryStore(),
	})
}

// ============================================================================
// Acceptance Target 1: Unassigned open items remain repairable
// ============================================================================

func TestAcceptanceTarget1_UnassignedOpenItemsRemainRepairable(t *testing.T) {
	svc := newTestService()
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserEditor,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "editor",
	})

	// 1. Create an opportunity without priority justification or owner
	createResp, err := svc.Create(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceCreateRequest{
		WorkspaceId:     testWorkspaceA,
		OpportunityType: "content",
		Title:           "Morning skincare routine - viral gap",
		Summary:         "High interest among 18-25 female audience",
		SourceRefs: []*intelligencev1.OpportunitySourceRef{
			{
				SourceType: "trend",
				SourceId:   "trend-101",
				SourceName: "morning routine",
			},
		},
		ExpectedImpact: &intelligencev1.ExpectedImpact{
			Score:       85,
			Description: "High reach potential",
		},
		ExpectedEffort: &intelligencev1.ExpectedEffort{
			Score:        30,
			Description:  "Fast 30s video format",
			TimeEstimate: "2 hours",
		},
	}))
	if err != nil {
		t.Fatalf("create failed: %v", err)
	}
	oppID := createResp.Msg.Opportunity.OpportunityId

	// Transition from DRAFT to OPEN
	openResp, err := svc.UpdateState(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceUpdateStateRequest{
		WorkspaceId:   testWorkspaceA,
		OpportunityId: oppID,
		NewState:      intelligencev1.PriorityState_PRIORITY_STATE_OPEN,
	}))
	if err != nil {
		t.Fatalf("transition draft -> open failed: %v", err)
	}

	// Verify open item awaiting assignment is flagged as repairable with repair reasons
	if !openResp.Msg.Opportunity.IsRepairable {
		t.Fatalf("expected unassigned open opportunity to be is_repairable=true")
	}
	if len(openResp.Msg.Opportunity.RepairReasons) == 0 {
		t.Fatalf("expected repair_reasons to be populated for unassigned open item")
	}
	t.Logf("Open unassigned repair reasons: %v", openResp.Msg.Opportunity.RepairReasons)

	// Attempt to prioritize without priority justification fails with ErrMissingPriorityJustification
	_, err = svc.UpdateState(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceUpdateStateRequest{
		WorkspaceId:   testWorkspaceA,
		OpportunityId: oppID,
		NewState:      intelligencev1.PriorityState_PRIORITY_STATE_PRIORITIZED,
	}))
	if err == nil {
		t.Fatalf("expected failure when prioritizing without priority reason or confidence")
	}

	// 2. Repair item: Supply priority reason and confidence
	prioritizeResp, err := svc.UpdateState(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceUpdateStateRequest{
		WorkspaceId:    testWorkspaceA,
		OpportunityId:  oppID,
		NewState:       intelligencev1.PriorityState_PRIORITY_STATE_PRIORITIZED,
		PriorityReason: "Audience match 92% and low competition on VN TikTok",
		Confidence:     intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH,
	}))
	if err != nil {
		t.Fatalf("repair priority context failed: %v", err)
	}
	if prioritizeResp.Msg.Opportunity.PriorityState != intelligencev1.PriorityState_PRIORITY_STATE_PRIORITIZED {
		t.Fatalf("expected prioritized state, got %v", prioritizeResp.Msg.Opportunity.PriorityState)
	}

	// Item is in prioritized state, still lacks owner -> still repairable with unassigned prompt
	if !prioritizeResp.Msg.Opportunity.IsRepairable {
		t.Fatalf("expected prioritized item without owner to remain repairable")
	}

	// Attempting to transition to ASSIGNED without owner fails (RULE-M04-002)
	_, err = svc.UpdateState(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceUpdateStateRequest{
		WorkspaceId:   testWorkspaceA,
		OpportunityId: oppID,
		NewState:      intelligencev1.PriorityState_PRIORITY_STATE_ASSIGNED,
	}))
	if err == nil {
		t.Fatalf("expected failure when transitioning to assigned without owner")
	}

	// 3. Assign owner via Manager role
	mgrCtx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserManager,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "manager",
	})
	assignResp, err := svc.Assign(mgrCtx, connect.NewRequest(&intelligencev1.OpportunityServiceAssignRequest{
		WorkspaceId:   testWorkspaceA,
		OpportunityId: oppID,
		OwnerUserId:   testUserOwner,
	}))
	if err != nil {
		t.Fatalf("assign owner failed: %v", err)
	}
	if assignResp.Msg.Opportunity.OwnerUserId != testUserOwner {
		t.Fatalf("expected owner %s, got %s", testUserOwner, assignResp.Msg.Opportunity.OwnerUserId)
	}
	if assignResp.Msg.Opportunity.PriorityState != intelligencev1.PriorityState_PRIORITY_STATE_ASSIGNED {
		t.Fatalf("expected assigned state, got %v", assignResp.Msg.Opportunity.PriorityState)
	}

	// Fully repaired item with owner, justification, and summary is no longer repairable
	if assignResp.Msg.Opportunity.IsRepairable {
		t.Fatalf("expected fully assigned and justified opportunity to have is_repairable=false, got reasons %v", assignResp.Msg.Opportunity.RepairReasons)
	}
}

// ============================================================================
// Acceptance Target 2: Concurrent assign/convert conflicts & State Machine
// ============================================================================

func TestAcceptanceTarget2_ConcurrentAssignConvertConflicts(t *testing.T) {
	svc := newTestService()
	editorCtx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserEditor,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "editor",
	})
	mgrCtx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserManager,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "manager",
	})

	// 1. Create and advance opportunity to in_progress
	createResp, err := svc.Create(editorCtx, connect.NewRequest(&intelligencev1.OpportunityServiceCreateRequest{
		WorkspaceId:     testWorkspaceA,
		OpportunityType: "content",
		Title:           "Review serum retinol - competitor weakness",
		Summary:         "Top competitor reduced posting frequency",
		PriorityReason:  "Competitor stopped posting; search volume +120%",
		Confidence:      intelligencev1.ConfidenceBand_CONFIDENCE_BAND_HIGH,
		SourceRefs: []*intelligencev1.OpportunitySourceRef{
			{SourceType: "competitor", SourceId: "comp-99", SourceName: "@skincare_queen"},
		},
		ExpectedImpact: &intelligencev1.ExpectedImpact{Score: 80},
		ExpectedEffort: &intelligencev1.ExpectedEffort{Score: 40},
	}))
	if err != nil {
		t.Fatalf("create failed: %v", err)
	}
	oppID := createResp.Msg.Opportunity.OpportunityId

	// Transition DRAFT -> OPEN
	_, err = svc.UpdateState(editorCtx, connect.NewRequest(&intelligencev1.OpportunityServiceUpdateStateRequest{
		WorkspaceId:   testWorkspaceA,
		OpportunityId: oppID,
		NewState:      intelligencev1.PriorityState_PRIORITY_STATE_OPEN,
	}))
	if err != nil {
		t.Fatalf("draft->open failed: %v", err)
	}

	// Transition OPEN -> PRIORITIZED
	_, err = svc.UpdateState(editorCtx, connect.NewRequest(&intelligencev1.OpportunityServiceUpdateStateRequest{
		WorkspaceId:   testWorkspaceA,
		OpportunityId: oppID,
		NewState:      intelligencev1.PriorityState_PRIORITY_STATE_PRIORITIZED,
	}))
	if err != nil {
		t.Fatalf("open->prioritized failed: %v", err)
	}

	// Assign owner -> ASSIGNED
	_, err = svc.Assign(mgrCtx, connect.NewRequest(&intelligencev1.OpportunityServiceAssignRequest{
		WorkspaceId:   testWorkspaceA,
		OpportunityId: oppID,
		OwnerUserId:   testUserOwner,
	}))
	if err != nil {
		t.Fatalf("assign failed: %v", err)
	}

	// Transition ASSIGNED -> IN_PROGRESS
	inProgResp, err := svc.UpdateState(editorCtx, connect.NewRequest(&intelligencev1.OpportunityServiceUpdateStateRequest{
		WorkspaceId:   testWorkspaceA,
		OpportunityId: oppID,
		NewState:      intelligencev1.PriorityState_PRIORITY_STATE_IN_PROGRESS,
	}))
	if err != nil {
		t.Fatalf("assigned->in_progress failed: %v", err)
	}

	// Capture timestamp before race
	snapshotTimestamp := inProgResp.Msg.Opportunity.UpdatedAt

	// 2. Simulate concurrent operations:
	// User 1 (Manager) updates assignment while User 2 (Editor) attempts to convert
	// Advance clock slightly to simulate realistic network delay
	time.Sleep(5 * time.Millisecond)

	// User 1 finishes first:
	newAssignResp, err := svc.Assign(mgrCtx, connect.NewRequest(&intelligencev1.OpportunityServiceAssignRequest{
		WorkspaceId:       testWorkspaceA,
		OpportunityId:     oppID,
		OwnerUserId:       testUserManager,
		ExpectedUpdatedAt: snapshotTimestamp,
	}))
	if err != nil {
		t.Fatalf("first concurrent operation (Assign) should succeed: %v", err)
	}
	if newAssignResp.Msg.Opportunity.OwnerUserId != testUserManager {
		t.Fatalf("expected new owner %s", testUserManager)
	}

	// User 2 (Editor) attempts to convert using stale snapshotTimestamp:
	_, err = svc.Convert(editorCtx, connect.NewRequest(&intelligencev1.OpportunityServiceConvertRequest{
		WorkspaceId:       testWorkspaceA,
		OpportunityId:     oppID,
		ExpectedUpdatedAt: snapshotTimestamp, // STALE!
		ConversionType:    "idea",
		Title:             "Retinol 101 video script idea",
	}))
	if err == nil {
		t.Fatalf("expected concurrent conflict (409 FailedPrecondition), got success")
	}

	var connErr *connect.Error
	if !errors.As(err, &connErr) {
		t.Fatalf("expected connect.Error, got %T: %v", err, err)
	}
	if connErr.Code() != connect.CodeFailedPrecondition {
		t.Fatalf("expected connect.CodeFailedPrecondition (409 Conflict), got %v", connErr.Code())
	}
	if !strings.Contains(connErr.Message(), "concurrent modification detected") {
		t.Fatalf("expected concurrent conflict message, got: %s", connErr.Message())
	}
	t.Logf("PASS: Stale concurrent convert correctly rejected with: %v", connErr.Message())

	// Refresh and retry with latest timestamp succeeds
	latestOpp, err := svc.Get(editorCtx, connect.NewRequest(&intelligencev1.OpportunityServiceGetRequest{
		WorkspaceId:   testWorkspaceA,
		OpportunityId: oppID,
	}))
	if err != nil {
		t.Fatalf("get latest failed: %v", err)
	}

	convertResp, err := svc.Convert(editorCtx, connect.NewRequest(&intelligencev1.OpportunityServiceConvertRequest{
		WorkspaceId:       testWorkspaceA,
		OpportunityId:     oppID,
		ExpectedUpdatedAt: latestOpp.Msg.Opportunity.UpdatedAt,
		ConversionType:    "idea",
		Title:             "Retinol 101 video script idea",
	}))
	if err != nil {
		t.Fatalf("retry with fresh timestamp failed: %v", err)
	}
	if convertResp.Msg.ConvertedToType != "idea" {
		t.Fatalf("expected converted_to_type idea, got %s", convertResp.Msg.ConvertedToType)
	}
	if convertResp.Msg.Opportunity.PriorityState != intelligencev1.PriorityState_PRIORITY_STATE_CONVERTED {
		t.Fatalf("expected state converted, got %v", convertResp.Msg.Opportunity.PriorityState)
	}
}

// ============================================================================
// Acceptance Target 3: No orphan opportunity & Source Provenance
// ============================================================================

func TestAcceptanceTarget3_NoOrphanOpportunity(t *testing.T) {
	svc := newTestService()
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserEditor,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "editor",
	})

	// 1. Attempt to create opportunity with empty source_refs fails immediately
	_, err := svc.Create(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceCreateRequest{
		WorkspaceId:     testWorkspaceA,
		OpportunityType: "content",
		Title:           "Orphan opportunity without provenance",
		Summary:         "No source attached",
		SourceRefs:      []*intelligencev1.OpportunitySourceRef{}, // EMPTY!
	}))
	if err == nil {
		t.Fatalf("expected ErrOrphanOpportunityForbidden on empty source_refs, got success")
	}

	var connErr *connect.Error
	if !errors.As(err, &connErr) {
		t.Fatalf("expected connect.Error, got %T: %v", err, err)
	}
	if connErr.Code() != connect.CodeInvalidArgument {
		t.Fatalf("expected connect.CodeInvalidArgument, got %v", connErr.Code())
	}
	if !strings.Contains(connErr.Message(), "provenance source") {
		t.Fatalf("expected orphan forbidden message, got: %s", connErr.Message())
	}

	// 2. Create opportunity with multiple sources (trend + competitor) succeeds
	resp, err := svc.Create(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceCreateRequest{
		WorkspaceId:     testWorkspaceA,
		OpportunityType: "product",
		Title:           "Multi-source opportunity",
		Summary:         "Triggered by trend spike and competitor gap",
		SourceRefs: []*intelligencev1.OpportunitySourceRef{
			{
				SourceType: "trend",
				SourceId:   "trend-42",
				SourceName: "SPF 50 Cushion",
				SourceUrl:  "https://tiktok.com/tag/cushionspf",
			},
			{
				SourceType: "competitor",
				SourceId:   "comp-12",
				SourceName: "@glow_master",
			},
		},
		ExpectedImpact: &intelligencev1.ExpectedImpact{Score: 90},
		ExpectedEffort: &intelligencev1.ExpectedEffort{Score: 50},
	}))
	if err != nil {
		t.Fatalf("create multi-source failed: %v", err)
	}

	if len(resp.Msg.Opportunity.Sources) != 2 {
		t.Fatalf("expected 2 sources, got %d", len(resp.Msg.Opportunity.Sources))
	}

	// 3. Expired source retention (EC-M04-001)
	respExpired, err := svc.Create(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceCreateRequest{
		WorkspaceId:     testWorkspaceA,
		OpportunityType: "content",
		Title:           "Opportunity referencing expired trend",
		Summary:         "Trend expired but historical data remains available",
		SourceRefs: []*intelligencev1.OpportunitySourceRef{
			{
				SourceType:    "trend",
				SourceId:      "trend-expired-1",
				SourceName:    "summer glow trend",
				IsExpired:     true,
				ArchiveNotice: "Source trend has expired — historical data available",
			},
		},
	}))
	if err != nil {
		t.Fatalf("create with expired source failed: %v", err)
	}
	if !respExpired.Msg.Opportunity.Sources[0].IsExpired {
		t.Fatalf("expected is_expired=true on archived trend reference")
	}
	if respExpired.Msg.Opportunity.Sources[0].ArchiveNotice == "" {
		t.Fatalf("expected non-empty archive_notice")
	}
}

// ============================================================================
// RBAC Permissions Matrix Test
// ============================================================================

func TestRBACPermissions(t *testing.T) {
	svc := newTestService()

	// Seed an opportunity using Owner role
	ownerCtx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserOwner,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "owner",
	})
	seedResp, err := svc.Create(ownerCtx, connect.NewRequest(&intelligencev1.OpportunityServiceCreateRequest{
		WorkspaceId:     testWorkspaceA,
		OpportunityType: "content",
		Title:           "RBAC test opportunity",
		Summary:         "Testing role permissions",
		SourceRefs: []*intelligencev1.OpportunitySourceRef{
			{SourceType: "trend", SourceId: "t-1"},
		},
	}))
	if err != nil {
		t.Fatalf("seed failed: %v", err)
	}
	oppID := seedResp.Msg.Opportunity.OpportunityId

	// Advance to in_progress so convert can be tested
	_, _ = svc.UpdateState(ownerCtx, connect.NewRequest(&intelligencev1.OpportunityServiceUpdateStateRequest{
		WorkspaceId:   testWorkspaceA,
		OpportunityId: oppID,
		NewState:      intelligencev1.PriorityState_PRIORITY_STATE_OPEN,
	}))
	_, _ = svc.UpdateState(ownerCtx, connect.NewRequest(&intelligencev1.OpportunityServiceUpdateStateRequest{
		WorkspaceId:    testWorkspaceA,
		OpportunityId:  oppID,
		NewState:       intelligencev1.PriorityState_PRIORITY_STATE_PRIORITIZED,
		PriorityReason: "High relevance",
	}))
	_, _ = svc.Assign(ownerCtx, connect.NewRequest(&intelligencev1.OpportunityServiceAssignRequest{
		WorkspaceId:   testWorkspaceA,
		OpportunityId: oppID,
		OwnerUserId:   testUserOwner,
	}))
	_, _ = svc.UpdateState(ownerCtx, connect.NewRequest(&intelligencev1.OpportunityServiceUpdateStateRequest{
		WorkspaceId:   testWorkspaceA,
		OpportunityId: oppID,
		NewState:      intelligencev1.PriorityState_PRIORITY_STATE_IN_PROGRESS,
	}))

	cases := []struct {
		role       string
		canRead    bool
		canCreate  bool
		canAssign  bool
		canConvert bool
	}{
		{role: "owner", canRead: true, canCreate: true, canAssign: true, canConvert: true},
		{role: "admin", canRead: true, canCreate: true, canAssign: true, canConvert: true},
		{role: "manager", canRead: true, canCreate: true, canAssign: true, canConvert: true},
		{role: "editor", canRead: true, canCreate: true, canAssign: false, canConvert: true},
		{role: "contributor", canRead: true, canCreate: true, canAssign: false, canConvert: false},
		{role: "viewer", canRead: true, canCreate: false, canAssign: false, canConvert: false},
		{role: "external", canRead: false, canCreate: false, canAssign: false, canConvert: false},
	}

	for _, tc := range cases {
		t.Run(tc.role, func(t *testing.T) {
			ctx := WithCallerContext(context.Background(), CallerContext{
				UserID:        "user-" + tc.role,
				WorkspaceID:   testWorkspaceA,
				WorkspaceRole: tc.role,
			})

			// 1. Read (List)
			_, readErr := svc.List(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceListRequest{
				WorkspaceId: testWorkspaceA,
			}))
			if tc.canRead && readErr != nil {
				t.Errorf("[%s] expected read allowed, got: %v", tc.role, readErr)
			}
			if !tc.canRead && readErr == nil {
				t.Errorf("[%s] expected read denied, got success", tc.role)
			}

			// 2. Create
			_, createErr := svc.Create(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceCreateRequest{
				WorkspaceId:     testWorkspaceA,
				OpportunityType: "content",
				Title:           "Test " + tc.role,
				SourceRefs: []*intelligencev1.OpportunitySourceRef{
					{SourceType: "signal", SourceId: "s-1"},
				},
			}))
			if tc.canCreate && createErr != nil {
				t.Errorf("[%s] expected create allowed, got: %v", tc.role, createErr)
			}
			if !tc.canCreate && createErr == nil {
				t.Errorf("[%s] expected create denied, got success", tc.role)
			}

			// 3. Assign
			_, assignErr := svc.Assign(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceAssignRequest{
				WorkspaceId:   testWorkspaceA,
				OpportunityId: oppID,
				OwnerUserId:   "user-assigned",
			}))
			if tc.canAssign && assignErr != nil {
				t.Errorf("[%s] expected assign allowed, got: %v", tc.role, assignErr)
			}
			if !tc.canAssign && assignErr == nil {
				t.Errorf("[%s] expected assign denied, got success", tc.role)
			}

			// 4. Convert
			_, convErr := svc.Convert(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceConvertRequest{
				WorkspaceId:    testWorkspaceA,
				OpportunityId:  oppID,
				ConversionType: "idea",
				Title:          "Idea for " + tc.role,
			}))
			if tc.canConvert && convErr != nil {
				t.Errorf("[%s] expected convert allowed, got: %v", tc.role, convErr)
			}
			if !tc.canConvert && convErr == nil {
				t.Errorf("[%s] expected convert denied, got success", tc.role)
			}
		})
	}
}

// ============================================================================
// Multi-Tenant Isolation Test
// ============================================================================

func TestMultiTenantIsolation(t *testing.T) {
	svc := newTestService()
	ctxA := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserOwner,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "owner",
	})
	ctxB := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserOwner,
		WorkspaceID:   testWorkspaceB,
		WorkspaceRole: "owner",
	})

	// Create opportunity in Workspace A
	respA, err := svc.Create(ctxA, connect.NewRequest(&intelligencev1.OpportunityServiceCreateRequest{
		WorkspaceId:     testWorkspaceA,
		OpportunityType: "content",
		Title:           "Workspace A secret opportunity",
		SourceRefs: []*intelligencev1.OpportunitySourceRef{
			{SourceType: "trend", SourceId: "trend-a"},
		},
	}))
	if err != nil {
		t.Fatalf("create A failed: %v", err)
	}
	oppIDA := respA.Msg.Opportunity.OpportunityId

	// Workspace B cannot get Workspace A opportunity
	_, err = svc.Get(ctxB, connect.NewRequest(&intelligencev1.OpportunityServiceGetRequest{
		WorkspaceId:   testWorkspaceB,
		OpportunityId: oppIDA,
	}))
	if err == nil {
		t.Fatalf("expected not found or cross-tenant denied for Workspace B reading Workspace A")
	}

	// Cross-tenant explicit mismatch denied
	_, err = svc.Get(ctxB, connect.NewRequest(&intelligencev1.OpportunityServiceGetRequest{
		WorkspaceId:   testWorkspaceA, // Mismatch with ctxB WorkspaceID!
		OpportunityId: oppIDA,
	}))
	if err == nil {
		t.Fatalf("expected cross-tenant permission denied")
	}
}

// ============================================================================
// Financial Non-Conflation Test (RULE-M04-005)
// ============================================================================

func TestFinancialNonConflation(t *testing.T) {
	svc := newTestService()
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserEditor,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "editor",
	})

	resp, err := svc.Create(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceCreateRequest{
		WorkspaceId:     testWorkspaceA,
		OpportunityType: "product",
		Title:           "New skincare product line",
		SourceRefs: []*intelligencev1.OpportunitySourceRef{
			{SourceType: "trend", SourceId: "t-1"},
		},
	}))
	if err != nil {
		t.Fatalf("create failed: %v", err)
	}

	opp := resp.Msg.Opportunity
	if opp.EstimatedProfit == nil {
		t.Fatalf("expected estimated_profit to be present")
	}
	if !opp.EstimatedProfit.IsEstimate {
		t.Fatalf("expected is_estimate=true on opportunity estimated profit")
	}
	if opp.EstimatedProfit.SourceClass != intelligencev1.SourceClass_SOURCE_CLASS_ESTIMATED {
		t.Fatalf("expected source_class ESTIMATED, got %v", opp.EstimatedProfit.SourceClass)
	}
	if opp.EstimatedProfit.Explanation == "" {
		t.Fatalf("expected explanation on profit estimate")
	}
}

// ============================================================================
// Home Intelligence Decision Card Integration Test (M01 / M04)
// ============================================================================

func TestHomeIntelligenceIntegration(t *testing.T) {
	svc := newTestService()
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserMember,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "viewer",
	})
	ownerCtx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserOwner,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "owner",
	})

	// Seed 3 opportunities with different scores
	for i := 1; i <= 3; i++ {
		_, err := svc.Create(ownerCtx, connect.NewRequest(&intelligencev1.OpportunityServiceCreateRequest{
			WorkspaceId:     testWorkspaceA,
			OpportunityType: "content",
			Title:           fmt.Sprintf("Top Opp #%d", i),
			SourceRefs: []*intelligencev1.OpportunitySourceRef{
				{SourceType: "trend", SourceId: fmt.Sprintf("t-%d", i)},
			},
			ExpectedImpact: &intelligencev1.ExpectedImpact{Score: int32(50 + (i * 15))},
			ExpectedEffort: &intelligencev1.ExpectedEffort{Score: 20},
		}))
		if err != nil {
			t.Fatalf("seed %d failed: %v", i, err)
		}
	}

	topOpps, err := svc.GetTopDecisionOpportunities(ctx, testWorkspaceA, 2)
	if err != nil {
		t.Fatalf("GetTopDecisionOpportunities failed: %v", err)
	}
	if len(topOpps) != 2 {
		t.Fatalf("expected 2 top opportunities, got %d", len(topOpps))
	}
	if topOpps[0].OverallScore < topOpps[1].OverallScore {
		t.Fatalf("expected descending overall score sort")
	}
}

// ============================================================================
// Concurrency & Thread Safety Test
// ============================================================================

func TestConcurrentOperationsNoRace(t *testing.T) {
	svc := newTestService()
	ctx := WithCallerContext(context.Background(), CallerContext{
		UserID:        testUserEditor,
		WorkspaceID:   testWorkspaceA,
		WorkspaceRole: "editor",
	})

	var wg sync.WaitGroup
	errCh := make(chan error, 20)

	for i := 0; i < 20; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			_, err := svc.Create(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceCreateRequest{
				WorkspaceId:     testWorkspaceA,
				OpportunityType: "content",
				Title:           fmt.Sprintf("Concurrent Opp %d", idx),
				SourceRefs: []*intelligencev1.OpportunitySourceRef{
					{SourceType: "trend", SourceId: fmt.Sprintf("tr-%d", idx)},
				},
				ExpectedImpact: &intelligencev1.ExpectedImpact{Score: int32(40 + (idx % 50))},
				ExpectedEffort: &intelligencev1.ExpectedEffort{Score: 30},
			}))
			if err != nil {
				errCh <- err
			}
		}(i)
	}

	wg.Wait()
	close(errCh)

	for err := range errCh {
		t.Fatalf("concurrent create failed: %v", err)
	}

	// Verify count
	listResp, err := svc.List(ctx, connect.NewRequest(&intelligencev1.OpportunityServiceListRequest{
		WorkspaceId: testWorkspaceA,
		PageSize:    50,
	}))
	if err != nil {
		t.Fatalf("list failed: %v", err)
	}
	if listResp.Msg.TotalCount != 20 {
		t.Fatalf("expected 20 opportunities, got %d", listResp.Msg.TotalCount)
	}
}
