package recipe_test

import (
	"context"
	"fmt"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	automationv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/recipe"
	"github.com/quantm-zeus/creativanta/apps/api/internal/workflow"
)

// Helper: construct mock recipe template with a canonical workflow graph.
func createTestRecipe(recipeID string, isSystem bool, status string, caps []string) *recipe.RecipeTemplate {
	var wsID *string
	if !isSystem {
		id := "tenant-workspace-001"
		wsID = &id
	}

	graph := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes: []workflow.WorkflowNode{
			{
				NodeID:   "trigger-1",
				NodeType: workflow.NodeTypeTrigger,
				Config: map[string]any{
					"type":       "event",
					"event_type": "order.created",
				},
			},
			{
				NodeID:   "condition-1",
				NodeType: workflow.NodeTypeCondition,
				Config: map[string]any{
					"field":    "order_amount",
					"operator": "gt",
					"value":    100,
				},
			},
			{
				NodeID:   "action-1",
				NodeType: workflow.NodeTypeAction,
				Config: map[string]any{
					"service":  "MessagingService",
					"action":   "SendWelcome",
					"template": "{{welcome_message}}",
				},
			},
			{
				NodeID:   "terminal-1",
				NodeType: workflow.NodeTypeTerminal,
				Config:   map[string]any{},
			},
		},
		Edges: []workflow.WorkflowEdge{
			{FromNodeID: "trigger-1", ToNodeID: "condition-1"},
			{FromNodeID: "condition-1", ToNodeID: "action-1", Branch: workflow.EdgeBranchTrue},
			{FromNodeID: "action-1", ToNodeID: "terminal-1"},
		},
	}

	return &recipe.RecipeTemplate{
		RecipeID:        recipeID,
		WorkspaceID:     wsID,
		Title:           "Order Welcome Pipeline",
		Description:     "Automatically send welcome messages on new orders above $100",
		Category:        "commerce",
		TemplateKind:    "workflow",
		TemplateVersion: 1,
		TemplatePayload: recipe.PortableSnapshot{SchemaVersion: 1, Graph: graph, LicenseNotice: "MIT"},
		Parameters: []recipe.RecipeParameter{
			{Name: "welcome_message", Type: "string", DefaultValue: "Thank you for your order!", Required: true},
		},
		RequiredCapabilities: caps,
		InstallCount:         0,
		RatingAvg:            0,
		ReviewCount:          0,
		PriceUSD:             "0.000000",
		Status:               status,
	}
}

// ----------------------------------------------------------------------------
// Target 1: Install preserves canonical graph (RULE-M21-001)
// ----------------------------------------------------------------------------
func TestTarget1_InstallPreservesCanonicalGraph(t *testing.T) {
	ctx := context.Background()
	store := recipe.NewMemoryStore()
	wfStore := workflow.NewMemoryStore()
	capProvider := workflow.NewDefaultCapabilityProvider()
	capProvider.SetStatus("tiktok", "supported")
	capChecker := recipe.NewCapabilityChecker(capProvider)
	svc := recipe.NewService(store, wfStore, capChecker)

	var emittedEvents []string
	svc.SetEventEmitter(func(ctx context.Context, eventType string, payload any) error {
		emittedEvents = append(emittedEvents, eventType)
		return nil
	})

	// Seed published system recipe
	tmpl := createTestRecipe("rec-sys-001", true, "published", []string{"tiktok.publish"})
	_, err := store.CreateRecipe(ctx, tmpl)
	if err != nil {
		t.Fatalf("seed recipe: %v", err)
	}

	caller := recipe.CallerContext{
		UserID:        "user-editor-01",
		WorkspaceID:   "ws-dest-100",
		WorkspaceRole: "editor",
	}

	paramJSON := `{"welcome_message": "Welcome to our exclusive store!"}`
	inst, createdWf, missing, err := svc.InstallRecipe(ctx, caller, tmpl.RecipeID, paramJSON, "Customized Order Pipeline")
	if err != nil {
		t.Fatalf("InstallRecipe failed: %v", err)
	}
	if len(missing) > 0 {
		t.Fatalf("unexpected missing capabilities: %v", missing)
	}
	if inst == nil || createdWf == nil {
		t.Fatalf("expected non-nil installation and workflow")
	}

	// 1. Verify canonical workflow created in destination workspace
	if createdWf.WorkspaceID != caller.WorkspaceID {
		t.Errorf("expected workflow workspace %q, got %q", caller.WorkspaceID, createdWf.WorkspaceID)
	}
	if createdWf.WorkflowType != "recipe_installed" {
		t.Errorf("expected workflow_type 'recipe_installed', got %q", createdWf.WorkflowType)
	}
	if createdWf.Status != workflow.WorkflowStatusDraft {
		t.Errorf("expected status 'draft', got %q", createdWf.Status)
	}
	if createdWf.Title != "Customized Order Pipeline" {
		t.Errorf("expected title override 'Customized Order Pipeline', got %q", createdWf.Title)
	}

	// 2. Verify graph structure is preserved (4 nodes, 3 edges)
	if len(createdWf.ActionChain.Nodes) != 4 {
		t.Errorf("expected 4 nodes, got %d", len(createdWf.ActionChain.Nodes))
	}
	if len(createdWf.ActionChain.Edges) != 3 {
		t.Errorf("expected 3 edges, got %d", len(createdWf.ActionChain.Edges))
	}

	// 3. Verify parameter placeholder substitution in action node
	actionNode := createdWf.ActionChain.Nodes[2]
	if actionNode.Config["template"] != "Welcome to our exclusive store!" {
		t.Errorf("expected substituted parameter, got %v", actionNode.Config["template"])
	}

	// 4. Verify workflow is fully editable (not locked)
	createdWf.Title = "Edited Pipeline Title"
	createdWf.ActionChain.Nodes = append(createdWf.ActionChain.Nodes, workflow.WorkflowNode{
		NodeID:   "action-log",
		NodeType: workflow.NodeTypeAction,
		Config:   map[string]any{"action": "LogMetric"},
	})
	if err := wfStore.UpdateWorkflow(ctx, createdWf); err != nil {
		t.Errorf("expected installed workflow to be fully editable: %v", err)
	}
	fetchedWf, _ := wfStore.GetWorkflow(ctx, caller.WorkspaceID, createdWf.WorkflowID)
	if len(fetchedWf.ActionChain.Nodes) != 5 {
		t.Errorf("expected updated 5 nodes after editing, got %d", len(fetchedWf.ActionChain.Nodes))
	}

	// 5. Verify install count incremented and domain event emitted
	updatedTmpl, _ := store.GetRecipe(ctx, tmpl.RecipeID)
	if updatedTmpl.InstallCount != 1 {
		t.Errorf("expected install count 1, got %d", updatedTmpl.InstallCount)
	}

	if len(emittedEvents) == 0 || emittedEvents[0] != "recipe.installed" {
		t.Errorf("expected 'recipe.installed' domain event emitted, got %v", emittedEvents)
	}
}

// ----------------------------------------------------------------------------
// Target 2: Missing capability explained (AC-M21-003, Alternate Flow A1)
// ----------------------------------------------------------------------------
func TestTarget2_MissingCapabilityExplained(t *testing.T) {
	ctx := context.Background()
	store := recipe.NewMemoryStore()
	wfStore := workflow.NewMemoryStore()
	capProvider := workflow.NewDefaultCapabilityProvider()

	// Simulate Shopee connector missing / degraded
	capProvider.SetStatus("shopee", "unsupported")

	capChecker := recipe.NewCapabilityChecker(capProvider)
	svc := recipe.NewService(store, wfStore, capChecker)

	// Seed recipe requiring Shopee order sync
	tmpl := createTestRecipe("rec-shopee-001", true, "published", []string{"shopee.order.sync"})
	_, err := store.CreateRecipe(ctx, tmpl)
	if err != nil {
		t.Fatalf("seed recipe: %v", err)
	}

	caller := recipe.CallerContext{
		UserID:        "user-editor-01",
		WorkspaceID:   "ws-no-shopee",
		WorkspaceRole: "editor",
	}

	// Attempt install without connected Shopee
	inst, wf, missing, err := svc.InstallRecipe(ctx, caller, tmpl.RecipeID, "", "")
	if err == nil {
		t.Fatalf("expected InstallRecipe to be blocked for missing capability, got nil error")
	}
	if inst != nil || wf != nil {
		t.Errorf("expected zero installation and workflow created when missing capability")
	}

	// Verify structured explanation
	if len(missing) != 1 {
		t.Fatalf("expected 1 missing capability explanation, got %d", len(missing))
	}
	explanation := missing[0]
	if explanation.CapabilityKey != "shopee.order.sync" {
		t.Errorf("expected capability key 'shopee.order.sync', got %q", explanation.CapabilityKey)
	}
	if explanation.Platform != "shopee" {
		t.Errorf("expected platform 'shopee', got %q", explanation.Platform)
	}
	if explanation.Reason == "" || explanation.ResolutionGuidance == "" {
		t.Errorf("expected non-empty reason and resolution guidance: %+v", explanation)
	}
	if explanation.ConnectURL != "/settings/integrations/shopee" {
		t.Errorf("expected connect URL '/settings/integrations/shopee', got %q", explanation.ConnectURL)
	}

	// Verify workflow store remains clean
	workflows, total, _ := wfStore.ListWorkflows(ctx, caller.WorkspaceID, "", 10, 0)
	if total != 0 || len(workflows) != 0 {
		t.Errorf("expected 0 workflows in store, got %d", total)
	}
}

// ----------------------------------------------------------------------------
// Target 3: Tenant & System template isolation (database_schema.md §12.3B, §27.4)
// ----------------------------------------------------------------------------
func TestTarget3_TenantAndSystemTemplateIsolation(t *testing.T) {
	ctx := context.Background()
	store := recipe.NewMemoryStore()
	wfStore := workflow.NewMemoryStore()
	capProvider := workflow.NewDefaultCapabilityProvider()
	capProvider.SetStatus("tiktok", "supported")
	capChecker := recipe.NewCapabilityChecker(capProvider)
	svc := recipe.NewService(store, wfStore, capChecker)

	// 1. Seed system template (workspace_id == nil)
	sysTmpl := createTestRecipe("rec-global-01", true, "published", nil)
	_, _ = store.CreateRecipe(ctx, sysTmpl)

	// 2. Seed tenant A custom private draft template (workspace_id == "ws-tenant-A")
	tenantTmpl := createTestRecipe("rec-tenant-A-01", false, "draft", nil)
	_, _ = store.CreateRecipe(ctx, tenantTmpl)

	callerTenantA := recipe.CallerContext{
		UserID:        "user-A",
		WorkspaceID:   "tenant-workspace-001",
		WorkspaceRole: "editor",
	}
	callerTenantB := recipe.CallerContext{
		UserID:        "user-B",
		WorkspaceID:   "tenant-workspace-002",
		WorkspaceRole: "editor",
	}

	// Tenant B cannot see or get Tenant A's private template
	_, _, _, err := svc.GetRecipe(ctx, callerTenantB, tenantTmpl.RecipeID)
	if err == nil {
		t.Errorf("expected tenant B access to tenant A template to be denied")
	}

	// Tenant A CAN view their own template
	rA, _, _, err := svc.GetRecipe(ctx, callerTenantA, tenantTmpl.RecipeID)
	if err != nil || rA == nil {
		t.Errorf("tenant A should view own template: %v", err)
	}

	// Both Tenant A and Tenant B can view published system template
	rSysA, _, _, err := svc.GetRecipe(ctx, callerTenantA, sysTmpl.RecipeID)
	if err != nil || rSysA == nil {
		t.Errorf("tenant A should view system template: %v", err)
	}
	rSysB, _, _, err := svc.GetRecipe(ctx, callerTenantB, sysTmpl.RecipeID)
	if err != nil || rSysB == nil {
		t.Errorf("tenant B should view system template: %v", err)
	}

	// Tenant A cannot delete system template (read-only)
	err = store.DeleteRecipe(ctx, callerTenantA.WorkspaceID, sysTmpl.RecipeID)
	if err != recipe.ErrSystemRecipeReadOnly {
		t.Errorf("expected ErrSystemRecipeReadOnly, got %v", err)
	}
}

// ----------------------------------------------------------------------------
// Review & Rating Aggregation
// ----------------------------------------------------------------------------
func TestReviewAndRating_FullLifecycle(t *testing.T) {
	ctx := context.Background()
	store := recipe.NewMemoryStore()
	wfStore := workflow.NewMemoryStore()
	svc := recipe.NewService(store, wfStore, recipe.NewCapabilityChecker(nil))

	tmpl := createTestRecipe("rec-rate-01", true, "published", nil)
	_, _ = store.CreateRecipe(ctx, tmpl)

	caller1 := recipe.CallerContext{UserID: "u1", WorkspaceID: "ws1", WorkspaceRole: "contributor"}
	caller2 := recipe.CallerContext{UserID: "u2", WorkspaceID: "ws2", WorkspaceRole: "contributor"}

	// Valid reviews: 5 stars and 4 stars
	rev1, err := svc.SubmitReview(ctx, caller1, tmpl.RecipeID, 5, "Amazing automation!", "Alice")
	if err != nil || rev1.Rating != 5 {
		t.Fatalf("submit review 1 failed: %v", err)
	}
	rev2, err := svc.SubmitReview(ctx, caller2, tmpl.RecipeID, 4, "Good workflow, easy to customize.", "Bob")
	if err != nil || rev2.Rating != 4 {
		t.Fatalf("submit review 2 failed: %v", err)
	}

	// Verify template rating aggregation: (5 + 4) / 2 = 4.5
	updatedTmpl, _ := store.GetRecipe(ctx, tmpl.RecipeID)
	if updatedTmpl.ReviewCount != 2 {
		t.Errorf("expected 2 reviews, got %d", updatedTmpl.ReviewCount)
	}
	if updatedTmpl.RatingAvg < 4.49 || updatedTmpl.RatingAvg > 4.51 {
		t.Errorf("expected rating ~4.5, got %f", updatedTmpl.RatingAvg)
	}

	// Duplicate review from same user is rejected
	_, err = svc.SubmitReview(ctx, caller1, tmpl.RecipeID, 5, "Duplicate review", "Alice")
	if err != recipe.ErrReviewAlreadyExists {
		t.Errorf("expected ErrReviewAlreadyExists, got %v", err)
	}

	// Invalid ratings rejected
	_, err = svc.SubmitReview(ctx, recipe.CallerContext{UserID: "u3", WorkspaceID: "ws3", WorkspaceRole: "contributor"}, tmpl.RecipeID, 6, "Invalid", "Charlie")
	if err != recipe.ErrInvalidRating {
		t.Errorf("expected ErrInvalidRating for 6 stars, got %v", err)
	}
}

// ----------------------------------------------------------------------------
// Governance: Submission, 3-Day SLA, Review & 48h Takedown (Pack 06 S22)
// ----------------------------------------------------------------------------
func TestGovernance_SubmissionAnd48hTakedown(t *testing.T) {
	ctx := context.Background()
	store := recipe.NewMemoryStore()
	wfStore := workflow.NewMemoryStore()
	svc := recipe.NewService(store, wfStore, recipe.NewCapabilityChecker(nil))

	authorCaller := recipe.CallerContext{UserID: "creator-01", WorkspaceID: "ws-creator", WorkspaceRole: "editor"}
	adminCaller := recipe.CallerContext{UserID: "admin-01", WorkspaceID: "ws-admin", WorkspaceRole: "super_admin"}

	// Creator creates draft recipe
	tmpl := &recipe.RecipeTemplate{
		RecipeID:        "rec-gov-01",
		WorkspaceID:     &authorCaller.WorkspaceID,
		Title:           "Viral Clip Generator",
		Category:        "content",
		TemplateVersion: 1,
		Status:          "draft",
	}
	_, _ = store.CreateRecipe(ctx, tmpl)

	// 1. Submit for review (3-business-day SLA)
	sub, err := svc.SubmitForReview(ctx, authorCaller, tmpl.RecipeID)
	if err != nil {
		t.Fatalf("submit for review: %v", err)
	}
	if sub.Status != "pending" {
		t.Errorf("expected pending submission status, got %q", sub.Status)
	}

	recipeInStore, _ := store.GetRecipe(ctx, tmpl.RecipeID)
	if recipeInStore.Status != "review_required" {
		t.Errorf("expected status 'review_required', got %q", recipeInStore.Status)
	}

	// 2. Admin approves submission -> published
	approvedSub, err := svc.ReviewSubmission(ctx, adminCaller, sub.SubmissionID, true, "Approved for marketplace.")
	if err != nil || approvedSub.Status != "approved" {
		t.Fatalf("review submission failed: %v", err)
	}
	recipeInStore, _ = store.GetRecipe(ctx, tmpl.RecipeID)
	if recipeInStore.Status != "published" {
		t.Errorf("expected published status, got %q", recipeInStore.Status)
	}

	// 3. User installs published recipe
	userCaller := recipe.CallerContext{UserID: "user-buyer", WorkspaceID: "ws-buyer", WorkspaceRole: "editor"}
	inst, _, _, err := svc.InstallRecipe(ctx, userCaller, tmpl.RecipeID, "", "")
	if err != nil {
		t.Fatalf("install published recipe failed: %v", err)
	}

	// 4. DMCA / Content policy takedown within 48h SLA
	takedownRecipe, err := svc.TakedownRecipe(ctx, adminCaller, tmpl.RecipeID, "Copyright violation in prompt templates", "TICKET-DMCA-2026-009")
	if err != nil {
		t.Fatalf("takedown failed: %v", err)
	}
	if takedownRecipe.Status != "taken_down" {
		t.Errorf("expected status 'taken_down', got %q", takedownRecipe.Status)
	}

	// Installed instance is NOT destroyed, preserves canonical graph for buyer
	instRecord, err := store.GetInstallation(ctx, userCaller.WorkspaceID, inst.InstallationID)
	if err != nil || instRecord == nil {
		t.Errorf("installed instance must survive takedown: %v", err)
	}
}

// ----------------------------------------------------------------------------
// Revenue Share: 70/30 Split and 7-Day Refund Window (RULE-M21-006, DB-H-001)
// ----------------------------------------------------------------------------
func TestRevenueShare_70_30SplitAnd7DayRefund(t *testing.T) {
	ctx := context.Background()
	store := recipe.NewMemoryStore()
	wfStore := workflow.NewMemoryStore()
	svc := recipe.NewService(store, wfStore, recipe.NewCapabilityChecker(nil))

	authorWsID := "ws-creator-pro"
	tmpl := &recipe.RecipeTemplate{
		RecipeID:          "rec-paid-01",
		WorkspaceID:       &authorWsID,
		AuthorWorkspaceID: &authorWsID,
		Title:             "Premium E-Commerce Automator",
		PriceUSD:          "100.000000", // $100.00 exact decimal
		Status:            "published",
	}
	_, _ = store.CreateRecipe(ctx, tmpl)

	// Process revenue share on $100 purchase
	purchaserWsID := "ws-buyer-store"
	revShare, err := svc.ProcessRevenueShare(ctx, tmpl, purchaserWsID, tmpl.PriceUSD)
	if err != nil {
		t.Fatalf("ProcessRevenueShare failed: %v", err)
	}

	// 1. Verify exact 70/30 split
	if revShare.GrossAmount != "100.000000" {
		t.Errorf("expected gross 100.000000, got %s", revShare.GrossAmount)
	}
	if revShare.CreatorAmount != "70.000000" {
		t.Errorf("expected 70%% creator amount 70.000000, got %s", revShare.CreatorAmount)
	}
	if revShare.PlatformAmount != "30.000000" {
		t.Errorf("expected 30%% platform amount 30.000000, got %s", revShare.PlatformAmount)
	}

	// 2. Verify 7-day refund window
	expectedRefundDeadline := revShare.CreatedAt.Add(7 * 24 * time.Hour)
	diff := revShare.RefundEligibleUntil.Sub(expectedRefundDeadline)
	if diff < -time.Second || diff > time.Second {
		t.Errorf("expected refund deadline in 7 days, got %v", revShare.RefundEligibleUntil)
	}

	// 3. Refund within window succeeds
	buyerCaller := recipe.CallerContext{UserID: "buyer-user", WorkspaceID: purchaserWsID, WorkspaceRole: "admin"}
	refunded, err := svc.RefundPurchase(ctx, buyerCaller, revShare.RevenueShareID, "Not as described")
	if err != nil {
		t.Fatalf("refund within window failed: %v", err)
	}
	if refunded.Status != "refunded" {
		t.Errorf("expected status 'refunded', got %s", refunded.Status)
	}

	// 4. Duplicate refund fails
	_, err = svc.RefundPurchase(ctx, buyerCaller, revShare.RevenueShareID, "Second attempt")
	if err != recipe.ErrAlreadyRefunded {
		t.Errorf("expected ErrAlreadyRefunded, got %v", err)
	}

	// 5. Expired refund window rejected
	expiredRevShare := &recipe.RecipeRevenueShare{
		RevenueShareID:       "rev-expired-01",
		RecipeID:             tmpl.RecipeID,
		AuthorWorkspaceID:    authorWsID,
		PurchaserWorkspaceID: purchaserWsID,
		GrossAmount:          "50.000000",
		Status:               "settled",
		RefundEligibleUntil:  time.Now().UTC().Add(-24 * time.Hour), // Expired yesterday
	}
	_, _ = store.CreateRevenueShare(ctx, expiredRevShare)
	_, err = svc.RefundPurchase(ctx, buyerCaller, expiredRevShare.RevenueShareID, "Too late")
	if err != recipe.ErrRefundWindowExpired {
		t.Errorf("expected ErrRefundWindowExpired, got %v", err)
	}
}

// ----------------------------------------------------------------------------
// ConnectRPC Handlers & RBAC Verification
// ----------------------------------------------------------------------------
func TestConnectRPCHandlers_FullSurface(t *testing.T) {
	ctx := context.Background()
	store := recipe.NewMemoryStore()
	wfStore := workflow.NewMemoryStore()
	svc := recipe.NewService(store, wfStore, recipe.NewCapabilityChecker(nil))

	recipeHandler := recipe.NewRecipeHandler(svc)
	tmplHandler := recipe.NewTemplateHandler(svc)

	tmpl := createTestRecipe("rec-rpc-01", true, "published", nil)
	_, _ = store.CreateRecipe(ctx, tmpl)

	// 1. TemplateService/ListTemplates
	listReq := connect.NewRequest(&automationv1.TemplateServiceListTemplatesRequest{
		WorkspaceId: "ws-client",
		Category:    "commerce",
	})
	listResp, err := tmplHandler.ListTemplates(ctx, listReq)
	if err != nil {
		t.Fatalf("ListTemplates failed: %v", err)
	}
	if listResp.Msg.TotalCount != 1 {
		t.Errorf("expected total_count 1, got %d", listResp.Msg.TotalCount)
	}

	// 2. TemplateService/Deploy
	deployReq := connect.NewRequest(&automationv1.TemplateServiceDeployRequest{
		WorkspaceId: "ws-client",
		TemplateId:  tmpl.RecipeID,
	})
	deployResp, err := tmplHandler.Deploy(ctx, deployReq)
	if err != nil || !deployResp.Msg.Success {
		t.Fatalf("Deploy failed: %v", err)
	}
	if deployResp.Msg.WorkflowId == "" || deployResp.Msg.InstallationId == "" {
		t.Errorf("expected valid workflow_id and installation_id")
	}

	// 3. RecipeService/Configure
	confReq := connect.NewRequest(&automationv1.RecipeServiceConfigureRequest{
		WorkspaceId:         "ws-client",
		InstallationId:      deployResp.Msg.InstallationId,
		ParameterValuesJson: `{"threshold": 200}`,
		PinnedVersion:       1,
	})
	confResp, err := recipeHandler.Configure(ctx, confReq)
	if err != nil {
		t.Fatalf("Configure failed: %v", err)
	}
	if confResp.Msg.Installation.Status != automationv1.RecipeInstallationStatus_RECIPE_INSTALLATION_STATUS_PINNED {
		t.Errorf("expected pinned status, got %v", confResp.Msg.Installation.Status)
	}

	// 4. TemplateService/GetFeatured
	featReq := connect.NewRequest(&automationv1.TemplateServiceGetFeaturedRequest{
		WorkspaceId: "ws-client",
	})
	featResp, err := tmplHandler.GetFeatured(ctx, featReq)
	if err != nil {
		t.Fatalf("GetFeatured failed: %v", err)
	}
	if len(featResp.Msg.FeaturedTemplates) == 0 {
		t.Errorf("expected featured templates")
	}

	// 5. TemplateService/SearchTemplates
	searchReq := connect.NewRequest(&automationv1.TemplateServiceSearchTemplatesRequest{
		WorkspaceId: "ws-client",
		Query:       "welcome",
	})
	searchResp, err := tmplHandler.SearchTemplates(ctx, searchReq)
	if err != nil {
		t.Fatalf("SearchTemplates failed: %v", err)
	}
	if len(searchResp.Msg.Templates) != 1 {
		t.Errorf("expected 1 match for 'welcome', got %d", len(searchResp.Msg.Templates))
	}
}

// ----------------------------------------------------------------------------
// Thread Concurrency & Race Detector
// ----------------------------------------------------------------------------
func TestConcurrentRecipeOperations_RaceDetector(t *testing.T) {
	ctx := context.Background()
	store := recipe.NewMemoryStore()
	wfStore := workflow.NewMemoryStore()
	svc := recipe.NewService(store, wfStore, recipe.NewCapabilityChecker(nil))

	tmpl := createTestRecipe("rec-concurrent-01", true, "published", nil)
	_, _ = store.CreateRecipe(ctx, tmpl)

	var wg sync.WaitGroup
	workers := 16

	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func(workerID int) {
			defer wg.Done()
			caller := recipe.CallerContext{
				UserID:        fmt.Sprintf("user-worker-%d", workerID),
				WorkspaceID:   fmt.Sprintf("ws-worker-%d", workerID),
				WorkspaceRole: "editor",
			}

			// Concurrent install
			inst, _, _, err := svc.InstallRecipe(ctx, caller, tmpl.RecipeID, "", "")
			if err != nil {
				t.Errorf("worker %d install failed: %v", workerID, err)
				return
			}

			// Concurrent review
			_, _ = svc.SubmitReview(ctx, caller, tmpl.RecipeID, (workerID%5)+1, "Great!", caller.UserID)

			// Concurrent configure
			_, _ = svc.Configure(ctx, caller, inst.InstallationID, "", 1, true)

			// Concurrent list
			_, _, _, _ = svc.ListRecipes(ctx, caller, "", "", true, 10, 0)
		}(i)
	}

	wg.Wait()

	updatedTmpl, _ := store.GetRecipe(ctx, tmpl.RecipeID)
	if updatedTmpl.InstallCount != workers {
		t.Errorf("expected %d installs, got %d", workers, updatedTmpl.InstallCount)
	}
	if updatedTmpl.ReviewCount != workers {
		t.Errorf("expected %d reviews, got %d", workers, updatedTmpl.ReviewCount)
	}
}
