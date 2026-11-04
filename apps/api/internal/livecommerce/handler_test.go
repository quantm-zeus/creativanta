package livecommerce_test

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/livecommerce"
	"github.com/quantm-zeus/creativanta/apps/api/internal/production"
)

func setupTestHandler(t *testing.T) (*livecommerce.LiveCommerceHandler, *livecommerce.Service) {
	store := livecommerce.NewMemoryStore()
	events := &livecommerce.RecordingEventEmitter{}
	prodStore := production.NewMemoryStore()
	ctx := context.Background()
	_ = prodStore.CreateAsset(ctx, &production.Asset{
		AssetID:         "source-rec-001",
		WorkspaceID:     testWorkspaceA,
		Title:           "Live Stream Source",
		AssetType:       "video",
		GenerationState: "generated",
		QualityState:    "approved",
		CreatedAt:       time.Now().UTC(),
		UpdatedAt:       time.Now().UTC(),
	})
	bridge := livecommerce.NewDefaultDerivativeBridge(production.NewDerivativeManager(prodStore))
	svc := livecommerce.NewService(store, events, bridge)
	handler := livecommerce.NewLiveCommerceHandler(svc)
	return handler, svc
}

func TestLiveCommerceHandler_FullLifecycle(t *testing.T) {
	ctx := context.Background()
	handler, svc := setupTestHandler(t)

	// 1. CreateSession
	createReq := connect.NewRequest(&commercev1.LiveCommerceServiceCreateSessionRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWorkspaceA},
			IdempotencyKey: "handler-create-001",
		},
		Title:    "Mega Sale Stream",
		Platform: "tiktok_live",
		RunOfShow: []*commercev1.RunOfShowItem{
			{TimeOffsetMin: 0, Type: "talking_point", Title: "Welcome Intro"},
			{TimeOffsetMin: 15, Type: "product_pin", Title: "Serum HA Pin", ProductId: "prod-101"},
		},
	})

	createResp, err := handler.CreateSession(ctx, createReq)
	if err != nil {
		t.Fatalf("CreateSession handler failed: %v", err)
	}
	session := createResp.Msg.Session
	if session == nil || session.SessionId == "" {
		t.Fatalf("Expected non-empty session returned")
	}
	if session.Status != commercev1.LiveSessionStatus_LIVE_SESSION_STATUS_PLANNED {
		t.Fatalf("Expected planned status, got %v", session.Status)
	}

	// 2. StartSession
	startReq := connect.NewRequest(&commercev1.LiveCommerceServiceStartSessionRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWorkspaceA},
			IdempotencyKey: "handler-start-001",
		},
		SessionId: session.SessionId,
	})
	startResp, err := handler.StartSession(ctx, startReq)
	if err != nil {
		t.Fatalf("StartSession handler failed: %v", err)
	}
	if startResp.Msg.Session.Status != commercev1.LiveSessionStatus_LIVE_SESSION_STATUS_LIVE {
		t.Fatalf("Expected live status, got %v", startResp.Msg.Session.Status)
	}

	// 3. AddCue
	addCueReq := connect.NewRequest(&commercev1.LiveCommerceServiceAddCueRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWorkspaceA},
			IdempotencyKey: "handler-addcue-001",
		},
		SessionId:       session.SessionId,
		CueType:         "talking_point",
		Title:           "Announce 50% discount",
		Body:            "Flash deal starts in 2 minutes!",
		PinnedProductId: "prod-101",
		DisplayOrder:    1,
	})
	addCueResp, err := handler.AddCue(ctx, addCueReq)
	if err != nil {
		t.Fatalf("AddCue handler failed: %v", err)
	}
	cue := addCueResp.Msg.CueCard
	if cue == nil || cue.CueCardId == "" {
		t.Fatalf("Expected non-empty cue card returned")
	}

	// 4. TriggerCue
	trigReq := connect.NewRequest(&commercev1.LiveCommerceServiceTriggerCueRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWorkspaceA},
			IdempotencyKey: "handler-trig-001",
		},
		SessionId: session.SessionId,
		CueCardId: cue.CueCardId,
	})
	trigResp, err := handler.TriggerCue(ctx, trigReq)
	if err != nil {
		t.Fatalf("TriggerCue handler failed: %v", err)
	}
	if trigResp.Msg.CueCard.Status != commercev1.CueCardStatus_CUE_CARD_STATUS_USED {
		t.Fatalf("Expected cue status used, got %v", trigResp.Msg.CueCard.Status)
	}

	// 5. HighlightProduct
	hlProdReq := connect.NewRequest(&commercev1.LiveCommerceServiceHighlightProductRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWorkspaceA},
			IdempotencyKey: "handler-hlprod-001",
		},
		SessionId:               session.SessionId,
		ProductId:               "prod-101",
		OfferId:                 "offer-202",
		IsPinned:                true,
		ActiveTimeOffsetSeconds: 120,
	})
	hlProdResp, err := handler.HighlightProduct(ctx, hlProdReq)
	if err != nil {
		t.Fatalf("HighlightProduct handler failed: %v", err)
	}
	if !hlProdResp.Msg.IsPinned {
		t.Fatalf("Expected is_pinned true")
	}

	// 6. CreateHighlight
	createHlReq := connect.NewRequest(&commercev1.LiveCommerceServiceCreateHighlightRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWorkspaceA},
			IdempotencyKey: "handler-createhl-001",
		},
		SessionId:          session.SessionId,
		Title:              "Flash Sale Frenzy",
		StartOffsetSeconds: 100,
		EndOffsetSeconds:   160,
		HighlightType:      "viral_moment",
		PinnedOfferId:      "offer-202",
		EngagementScore:    92.5,
	})
	createHlResp, err := handler.CreateHighlight(ctx, createHlReq)
	if err != nil {
		t.Fatalf("CreateHighlight handler failed: %v", err)
	}
	hl := createHlResp.Msg.Highlight
	if hl == nil || hl.HighlightId == "" {
		t.Fatalf("Expected non-empty highlight returned")
	}

	// 7. ExtractHighlights
	extReq := connect.NewRequest(&commercev1.LiveCommerceServiceExtractHighlightsRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWorkspaceA},
			IdempotencyKey: "handler-ext-001",
		},
		SessionId:     session.SessionId,
		SourceAssetId: "source-rec-001",
	})
	extResp, err := handler.ExtractHighlights(ctx, extReq)
	if err != nil {
		t.Fatalf("ExtractHighlights handler failed: %v", err)
	}
	if extResp.Msg.ExtractedCount != 1 || len(extResp.Msg.RegisteredDerivativeAssetIds) != 1 {
		t.Fatalf("Expected 1 extracted highlight clip, got %d", extResp.Msg.ExtractedCount)
	}

	// 8. Attach orders for revenue traceability and query GetAnalytics
	_ = svc.AttachOrder(ctx, testWorkspaceA, session.SessionId, "ord-1", "prod-101", "offer-202", "cust-1", "500000.000000", "VND")
	_ = svc.AttachOrder(ctx, testWorkspaceA, session.SessionId, "ord-2", "prod-101", "offer-202", "cust-2", "300000.000000", "VND")

	anaReq := connect.NewRequest(&commercev1.LiveCommerceServiceGetAnalyticsRequest{
		WorkspaceId: testWorkspaceA,
		SessionId:   session.SessionId,
	})
	anaResp, err := handler.GetAnalytics(ctx, anaReq)
	if err != nil {
		t.Fatalf("GetAnalytics handler failed: %v", err)
	}
	if anaResp.Msg.OrdersCount != 2 {
		t.Fatalf("Expected 2 orders, got %d", anaResp.Msg.OrdersCount)
	}
	if anaResp.Msg.TotalRevenue == nil || (anaResp.Msg.TotalRevenue.Amount != "800000" && anaResp.Msg.TotalRevenue.Amount != "800000.000000") {
		t.Fatalf("Expected total revenue 800000, got %v", anaResp.Msg.TotalRevenue)
	}

	// 9. EndSession & GetProofSummary
	endReq := connect.NewRequest(&commercev1.LiveCommerceServiceEndSessionRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: testWorkspaceA},
			IdempotencyKey: "handler-end-001",
		},
		SessionId: session.SessionId,
	})
	endResp, err := handler.EndSession(ctx, endReq)
	if err != nil {
		t.Fatalf("EndSession handler failed: %v", err)
	}
	if endResp.Msg.Summary == nil || endResp.Msg.Summary.SourceClass != "live_attributed" {
		t.Fatalf("Expected valid proof summary with source_class live_attributed, got %v", endResp.Msg.Summary)
	}
	if endResp.Msg.Summary.TotalRevenue == nil || (endResp.Msg.Summary.TotalRevenue.Amount != "800000" && endResp.Msg.Summary.TotalRevenue.Amount != "800000.000000") {
		t.Fatalf("Proof summary revenue mismatch: %v", endResp.Msg.Summary.TotalRevenue)
	}

	// 10. Get
	getReq := connect.NewRequest(&commercev1.LiveCommerceServiceGetRequest{
		WorkspaceId: testWorkspaceA,
		SessionId:   session.SessionId,
	})
	getResp, err := handler.Get(ctx, getReq)
	if err != nil {
		t.Fatalf("Get handler failed: %v", err)
	}
	if len(getResp.Msg.CueCards) != 1 || len(getResp.Msg.Highlights) != 1 {
		t.Fatalf("Expected 1 cue card and 1 highlight in session get response")
	}
}

func TestLiveCommerceHandler_NegativePaths(t *testing.T) {
	ctx := context.Background()
	handler, _ := setupTestHandler(t)

	// Missing tenant returns Unauthenticated
	req := connect.NewRequest(&commercev1.LiveCommerceServiceCreateSessionRequest{
		Title: "No Tenant Session",
	})
	_, err := handler.CreateSession(ctx, req)
	if err == nil {
		t.Fatalf("Expected error for missing tenant")
	}

	// Nonexistent session returns NotFound
	getReq := connect.NewRequest(&commercev1.LiveCommerceServiceGetRequest{
		WorkspaceId: testWorkspaceA,
		SessionId:   "nonexistent-session-id",
	})
	_, err = handler.Get(ctx, getReq)
	if err == nil {
		t.Fatalf("Expected error for nonexistent session")
	}
}
