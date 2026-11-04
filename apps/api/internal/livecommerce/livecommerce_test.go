package livecommerce_test

import (
	"context"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/livecommerce"
	"github.com/quantm-zeus/creativanta/apps/api/internal/production"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

const (
	testWorkspaceA = "019086a1-7c3e-7000-8000-000000000001"
	testWorkspaceB = "019086a1-7c3e-7000-8000-000000000002"
)

func setupTestService(t *testing.T) (*livecommerce.Service, *livecommerce.MemoryStore, *livecommerce.RecordingEventEmitter) {
	store := livecommerce.NewMemoryStore()
	events := &livecommerce.RecordingEventEmitter{}

	// Setup M09 derivative manager with in-memory store for real M07/M09 derivative registration testing
	prodStore := production.NewMemoryStore()
	// Seed a source asset in workspace A to serve as the live recording
	ctx := context.Background()
	sourceAsset := &production.Asset{
		AssetID:         "source-live-recording-001",
		WorkspaceID:     testWorkspaceA,
		Title:           "Live Stream Recording - Summer Sale 2026",
		AssetType:       "video",
		GenerationState: "generated",
		QualityState:    "approved",
		CreatedAt:       time.Now().UTC(),
		UpdatedAt:       time.Now().UTC(),
	}
	_ = prodStore.CreateAsset(ctx, sourceAsset)

	derivMgr := production.NewDerivativeManager(prodStore)
	bridge := livecommerce.NewDefaultDerivativeBridge(derivMgr)

	svc := livecommerce.NewService(store, events, bridge)
	return svc, store, events
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: Reconnect does not duplicate commands
// ----------------------------------------------------------------------------

func TestReconnectDoesNotDuplicateCommands(t *testing.T) {
	ctx := context.Background()
	svc, store, events := setupTestService(t)

	// Step 1: Create session with idempotency key
	idempCreate := "idemp-session-create-001"
	session, isDup, err := svc.CreateSession(ctx, testWorkspaceA, idempCreate, "Mega Live Sale", "tiktok_live", "acc-01", nil, nil, nil)
	if err != nil || session == nil || isDup {
		t.Fatalf("CreateSession failed: err=%v, isDup=%v", err, isDup)
	}

	// Reconnect and replay CreateSession with same idempotency key
	sessionDup, isDup2, err := svc.CreateSession(ctx, testWorkspaceA, idempCreate, "Mega Live Sale", "tiktok_live", "acc-01", nil, nil, nil)
	if err != nil || !isDup2 || sessionDup.SessionID != session.SessionID {
		t.Fatalf("Expected duplicate CreateSession to be detected: isDup=%v, id1=%s, id2=%s", isDup2, session.SessionID, sessionDup.SessionID)
	}

	// Verify only 1 session was stored
	sessions, total, err := store.ListSessions(ctx, testWorkspaceA, "", "", 10, 0)
	if err != nil || total != 1 || len(sessions) != 1 {
		t.Fatalf("Expected exactly 1 session in store, got %d", total)
	}

	// Step 2: Start session with idempotency key
	idempStart := "idemp-session-start-001"
	started, isDup, err := svc.StartSession(ctx, testWorkspaceA, session.SessionID, idempStart)
	if err != nil || isDup || started.Status != livecommerce.SessionStatusLive {
		t.Fatalf("StartSession failed: err=%v, isDup=%v, status=%s", err, isDup, started.Status)
	}

	startEventCount := 0
	for _, ev := range events.Events {
		if ev.Type == "live.session_started" {
			startEventCount++
		}
	}
	if startEventCount != 1 {
		t.Fatalf("Expected 1 live.session_started event, got %d", startEventCount)
	}

	// Simulate client network drop and reconnect replaying StartSession
	startedDup, isDup, err := svc.StartSession(ctx, testWorkspaceA, session.SessionID, idempStart)
	if err != nil || !isDup || startedDup.Status != livecommerce.SessionStatusLive {
		t.Fatalf("Expected duplicate StartSession to return live session safely: err=%v, isDup=%v", err, isDup)
	}

	// Verify no second live.session_started event was fired
	startEventCount2 := 0
	for _, ev := range events.Events {
		if ev.Type == "live.session_started" {
			startEventCount2++
		}
	}
	if startEventCount2 != 1 {
		t.Fatalf("Expected start event count to remain 1 after replay, got %d", startEventCount2)
	}

	// Step 3: AddCue with idempotency key
	idempCue := "idemp-cue-001"
	cue, isDup, err := svc.AddCue(ctx, testWorkspaceA, session.SessionID, idempCue, "product_highlight", "Highlight Serum HA", "Mention 20% discount code", "prod-01", "offer-01", 1)
	if err != nil || isDup || cue == nil {
		t.Fatalf("AddCue failed: err=%v, isDup=%v", err, isDup)
	}

	// Reconnect and replay AddCue
	cueDup, isDup, err := svc.AddCue(ctx, testWorkspaceA, session.SessionID, idempCue, "product_highlight", "Highlight Serum HA", "Mention 20% discount code", "prod-01", "offer-01", 1)
	if err != nil || !isDup || cueDup.CueCardID != cue.CueCardID {
		t.Fatalf("Expected duplicate cue card: isDup=%v, cue1=%s, cue2=%s", isDup, cue.CueCardID, cueDup.CueCardID)
	}

	// Verify exactly 1 cue card in store
	cues, _ := store.ListCueCards(ctx, testWorkspaceA, session.SessionID)
	if len(cues) != 1 {
		t.Fatalf("Expected exactly 1 cue card in store, got %d", len(cues))
	}

	// Step 4: TriggerCue with idempotency key
	idempTrigger := "idemp-cue-trig-001"
	trigCue, isDup, err := svc.TriggerCue(ctx, testWorkspaceA, session.SessionID, cue.CueCardID, idempTrigger)
	if err != nil || isDup || trigCue.Status != livecommerce.CueStatusUsed {
		t.Fatalf("TriggerCue failed: err=%v, isDup=%v, status=%s", err, isDup, trigCue.Status)
	}

	// Replay TriggerCue after reconnect
	trigCueDup, isDup, err := svc.TriggerCue(ctx, testWorkspaceA, session.SessionID, cue.CueCardID, idempTrigger)
	if err != nil || !isDup || trigCueDup.Status != livecommerce.CueStatusUsed {
		t.Fatalf("Expected duplicate TriggerCue to be safely handled: isDup=%v", isDup)
	}

	// Step 5: HighlightProduct pin with idempotency key
	idempPin := "idemp-pin-001"
	isDup, err = svc.HighlightProduct(ctx, testWorkspaceA, session.SessionID, "prod-01", "offer-01", idempPin, true, 120)
	if err != nil || isDup {
		t.Fatalf("HighlightProduct failed: err=%v, isDup=%v", err, isDup)
	}

	// Replay HighlightProduct
	isDup, err = svc.HighlightProduct(ctx, testWorkspaceA, session.SessionID, "prod-01", "offer-01", idempPin, true, 120)
	if err != nil || !isDup {
		t.Fatalf("Expected duplicate HighlightProduct: isDup=%v", isDup)
	}

	// Step 6: CreateHighlight with idempotency key
	idempHl := "idemp-hl-001"
	hl, isDup, err := svc.CreateHighlight(ctx, testWorkspaceA, session.SessionID, idempHl, "Viral Sales Spike", "viral_moment", "Audience spike on flash sale", "offer-01", "prod-01", 120, 180, false, 95.5)
	if err != nil || isDup || hl == nil {
		t.Fatalf("CreateHighlight failed: err=%v, isDup=%v", err, isDup)
	}

	// Replay CreateHighlight after connection drop
	hlDup, isDup, err := svc.CreateHighlight(ctx, testWorkspaceA, session.SessionID, idempHl, "Viral Sales Spike", "viral_moment", "Audience spike on flash sale", "offer-01", "prod-01", 120, 180, false, 95.5)
	if err != nil || !isDup || hlDup.HighlightID != hl.HighlightID {
		t.Fatalf("Expected duplicate CreateHighlight: isDup=%v, hl1=%s, hl2=%s", isDup, hl.HighlightID, hlDup.HighlightID)
	}

	// Verify exactly 1 highlight in store
	hls, _ := store.ListHighlights(ctx, testWorkspaceA, session.SessionID)
	if len(hls) != 1 {
		t.Fatalf("Expected exactly 1 highlight in store, got %d", len(hls))
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: M07 extracts, M09 registers clips
// ----------------------------------------------------------------------------

func TestM07ExtractsAndM09RegistersClips(t *testing.T) {
	ctx := context.Background()
	svc, store, events := setupTestService(t)

	// Create and start session
	session, _, err := svc.CreateSession(ctx, testWorkspaceA, "idemp-01", "Skincare Live Launch", "tiktok_live", "acc-01", nil, nil, nil)
	if err != nil {
		t.Fatalf("CreateSession failed: %v", err)
	}
	_, _, err = svc.StartSession(ctx, testWorkspaceA, session.SessionID, "idemp-02")
	if err != nil {
		t.Fatalf("StartSession failed: %v", err)
	}

	// Mark 3 highlights during the live session
	hl1, _, err := svc.CreateHighlight(ctx, testWorkspaceA, session.SessionID, "hl-01", "Product Demo: Serum", "product_demo", "Demonstrating application", "", "prod-01", 60, 120, false, 88.0)
	if err != nil {
		t.Fatalf("CreateHighlight 1 failed: %v", err)
	}
	hl2, _, err := svc.CreateHighlight(ctx, testWorkspaceA, session.SessionID, "hl-02", "Flash Sale Deal Drop", "best_sale", "Flash sale announced", "offer-01", "prod-01", 300, 360, false, 96.0)
	if err != nil {
		t.Fatalf("CreateHighlight 2 failed: %v", err)
	}
	hl3, _, err := svc.CreateHighlight(ctx, testWorkspaceA, session.SessionID, "hl-03", "Audience Q&A Peak", "qa_prompt", "Answered sensitive skin question", "", "prod-01", 600, 660, false, 85.0)
	if err != nil {
		t.Fatalf("CreateHighlight 3 failed: %v", err)
	}

	// Highlights initially do not have extracted asset clips
	if hl1.AssetID != "" || hl2.AssetID != "" || hl3.AssetID != "" {
		t.Fatalf("Highlights should not have asset_id before extraction")
	}

	// Execute extraction with source recording asset (Acceptance Target 2)
	sourceAssetID := "source-live-recording-001"
	count, updatedHls, registeredAssets, isDup, err := svc.ExtractHighlights(ctx, testWorkspaceA, session.SessionID, sourceAssetID, "extract-01", nil)
	if err != nil || isDup {
		t.Fatalf("ExtractHighlights failed: %v", err)
	}

	if count != 3 || len(registeredAssets) != 3 || len(updatedHls) != 3 {
		t.Fatalf("Expected 3 extracted highlights, got count=%d, assets=%d, updated=%d", count, len(registeredAssets), len(updatedHls))
	}

	// Verify all highlights now link back to registered derivative clips in M09
	for _, h := range updatedHls {
		if h.AssetID == "" {
			t.Fatalf("Expected highlight %s to have asset_id set after extraction", h.HighlightID)
		}
		// Check that highlight record in store was updated with asset_id
		storedHl, err := store.GetHighlight(ctx, testWorkspaceA, h.HighlightID)
		if err != nil || storedHl.AssetID != h.AssetID {
			t.Fatalf("Store highlight asset_id mismatch: %v, stored=%s, want=%s", err, storedHl.AssetID, h.AssetID)
		}
	}

	// Verify clip.extracted domain events were emitted for all 3
	clipEvents := 0
	for _, ev := range events.Events {
		if ev.Type == "clip.extracted" {
			clipEvents++
		}
	}
	if clipEvents != 3 {
		t.Fatalf("Expected 3 clip.extracted domain events, got %d", clipEvents)
	}

	// Missing recording asset returns ErrMissingRecording
	_, _, _, _, err = svc.ExtractHighlights(ctx, testWorkspaceA, session.SessionID, "", "extract-bad", nil)
	if err == nil {
		t.Fatalf("Expected error when sourceAssetID is missing")
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Revenue traceable and labeled
// ----------------------------------------------------------------------------

func TestRevenueTraceableAndLabeled(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := setupTestService(t)

	// Create and start session
	session, _, err := svc.CreateSession(ctx, testWorkspaceA, "idemp-rev-01", "Black Friday Live", "tiktok_live", "acc-01", nil, nil, nil)
	if err != nil {
		t.Fatalf("CreateSession failed: %v", err)
	}
	_, _, err = svc.StartSession(ctx, testWorkspaceA, session.SessionID, "idemp-rev-02")
	if err != nil {
		t.Fatalf("StartSession failed: %v", err)
	}

	// Mark a highlight during live
	_, _, _ = svc.CreateHighlight(ctx, testWorkspaceA, session.SessionID, "hl-01", "Serum Demo", "product_demo", "", "offer-01", "prod-01", 100, 150, false, 90.0)

	// Simulate orders arriving during the live session with live_session_id attached
	// Order 1: 250,000 VND
	err = svc.AttachOrder(ctx, testWorkspaceA, session.SessionID, "order-001", "prod-01", "offer-01", "cust-01", "250000.000000", "VND")
	if err != nil {
		t.Fatalf("AttachOrder 1 failed: %v", err)
	}
	// Order 2: 450,000 VND
	err = svc.AttachOrder(ctx, testWorkspaceA, session.SessionID, "order-002", "prod-02", "offer-02", "cust-02", "450000.000000", "VND")
	if err != nil {
		t.Fatalf("AttachOrder 2 failed: %v", err)
	}
	// Order 3: 300,000 VND
	err = svc.AttachOrder(ctx, testWorkspaceA, session.SessionID, "order-003", "prod-01", "offer-01", "cust-03", "300000.000000", "VND")
	if err != nil {
		t.Fatalf("AttachOrder 3 failed: %v", err)
	}

	// Query live analytics during live
	metrics, traceableOrders, err := svc.GetAnalytics(ctx, testWorkspaceA, session.SessionID)
	if err != nil {
		t.Fatalf("GetAnalytics failed: %v", err)
	}

	if metrics.OrdersDuringLive != 3 {
		t.Fatalf("Expected 3 orders, got %d", metrics.OrdersDuringLive)
	}
	// Total expected: 250,000 + 450,000 + 300,000 = 1,000,000.000000
	expectedTotal, _ := tenantdb.ParseExactDecimal("1000000.000000")
	if metrics.RevenueDuringLive.String() != expectedTotal.String() {
		t.Fatalf("Expected total revenue %s, got %s", expectedTotal.String(), metrics.RevenueDuringLive.String())
	}
	if len(traceableOrders) != 3 {
		t.Fatalf("Expected 3 traceable orders, got %d", len(traceableOrders))
	}

	// Verify each order is traceable in the chain: Product -> Offer -> Order -> Revenue
	for _, o := range traceableOrders {
		if o.OrderID == "" || o.ProductID == "" || o.OfferID == "" || o.Amount.String() == "" {
			t.Fatalf("Order trace link broken: %+v", o)
		}
	}

	// Operator ends live session -> Post-live proof summary generated automatically
	endedSession, summary, _, err := svc.EndSession(ctx, testWorkspaceA, session.SessionID, "idemp-end-01")
	if err != nil {
		t.Fatalf("EndSession failed: %v", err)
	}

	if endedSession.Status != livecommerce.SessionStatusPostLiveProcessing {
		t.Fatalf("Expected session status post_live_processing, got %s", endedSession.Status)
	}

	if summary == nil {
		t.Fatalf("Expected non-nil post-live proof summary")
	}

	// Verify Proof Document attributes (RULE-M17-003, RULE-M17-004)
	if summary.SourceClass != "live_attributed" {
		t.Fatalf("Expected source_class 'live_attributed', got %q", summary.SourceClass)
	}
	if summary.TotalRevenue.String() != expectedTotal.String() {
		t.Fatalf("Summary total revenue mismatch: got %s, want %s", summary.TotalRevenue.String(), expectedTotal.String())
	}
	if summary.ProofBundleID == "" {
		t.Fatalf("Expected non-empty proof_bundle_id for M19 integration")
	}
	if len(summary.Orders) != 3 {
		t.Fatalf("Expected 3 orders in proof summary, got %d", len(summary.Orders))
	}

	// Verify stored proof document can be retrieved
	retrievedSummary, err := svc.GetProofSummary(ctx, testWorkspaceA, session.SessionID)
	if err != nil || retrievedSummary.SummaryID != summary.SummaryID {
		t.Fatalf("GetProofSummary failed: %v", err)
	}

	// Edge Case EC-M17-002: Late orders arrive after session ends
	err = svc.AttachOrder(ctx, testWorkspaceA, session.SessionID, "order-004-late", "prod-01", "offer-01", "cust-04", "100000.000000", "VND")
	if err != nil {
		t.Fatalf("Attach late order failed: %v", err)
	}

	// Re-generating proof summary includes late orders
	updatedSummary, err := svc.GenerateProofSummary(ctx, testWorkspaceA, session.SessionID)
	if err != nil {
		t.Fatalf("Re-generating summary failed: %v", err)
	}
	expectedWithLate, _ := tenantdb.ParseExactDecimal("1100000.000000")
	if updatedSummary.TotalRevenue.String() != expectedWithLate.String() {
		t.Fatalf("Updated summary total revenue with late orders mismatch: got %s, want %s", updatedSummary.TotalRevenue.String(), expectedWithLate.String())
	}
	if len(updatedSummary.Orders) != 4 {
		t.Fatalf("Expected 4 orders in updated summary, got %d", len(updatedSummary.Orders))
	}
}

// ----------------------------------------------------------------------------
// Lifecycle State Machine & Multi-Tenant Isolation
// ----------------------------------------------------------------------------

func TestLifecycleTransitionsAndTenantIsolation(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := setupTestService(t)

	// Create session in workspace A
	sessA, _, err := svc.CreateSession(ctx, testWorkspaceA, "", "Workspace A Session", "tiktok_live", "", nil, nil, nil)
	if err != nil {
		t.Fatalf("CreateSession A failed: %v", err)
	}

	// Cannot pause or end before starting
	_, _, err = svc.PauseSession(ctx, testWorkspaceA, sessA.SessionID, "")
	if err == nil {
		t.Fatalf("Expected error pausing planned session")
	}

	// Start session -> live
	_, _, err = svc.StartSession(ctx, testWorkspaceA, sessA.SessionID, "")
	if err != nil {
		t.Fatalf("StartSession failed: %v", err)
	}

	// Pause session -> paused
	paused, _, err := svc.PauseSession(ctx, testWorkspaceA, sessA.SessionID, "")
	if err != nil || paused.Status != livecommerce.SessionStatusPaused {
		t.Fatalf("PauseSession failed: %v, status=%s", err, paused.Status)
	}

	// Resume session -> live
	resumed, _, err := svc.ResumeSession(ctx, testWorkspaceA, sessA.SessionID, "")
	if err != nil || resumed.Status != livecommerce.SessionStatusLive {
		t.Fatalf("ResumeSession failed: %v, status=%s", err, resumed.Status)
	}

	// Multi-tenant isolation: Workspace B cannot access or modify Workspace A session
	_, _, _, err = svc.GetSession(ctx, testWorkspaceB, sessA.SessionID)
	if err == nil {
		t.Fatalf("Expected error when Workspace B accesses Workspace A session")
	}
	_, _, err = svc.StartSession(ctx, testWorkspaceB, sessA.SessionID, "")
	if err == nil {
		t.Fatalf("Expected error when Workspace B attempts to start Workspace A session")
	}
	_, _, err = svc.AddCue(ctx, testWorkspaceB, sessA.SessionID, "", "cta", "Buy now", "", "", "", 1)
	if err == nil {
		t.Fatalf("Expected error when Workspace B adds cue to Workspace A session")
	}
}
