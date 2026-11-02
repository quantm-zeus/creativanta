package product_test

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/product"
)

func TestHandlerConnectRPCEndpoints(t *testing.T) {
	ctx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	fixedTime := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return fixedTime })
	h := product.NewHandler(svc)

	cmdCtx := &commonv1.CommandContext{
		WorkspaceId: &commonv1.UUID{Value: testWorkspaceID1},
	}

	// 1. Create Product RPC
	createReq := connect.NewRequest(&commercev1.CreateRequest{
		Context:     cmdCtx,
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Tai nghe chống ồn Bluetooth",
		Description: "Pin 40 giờ, chống ồn chủ động ANC",
		Category:    "Điện tử",
		BasePrice:   &commonv1.Money{Amount: "1290000.000000", Currency: "VND"},
		Currency:    "VND",
		InitialSkus: []*commercev1.ProductSku{
			{
				SkuCode:           "TNC-BLK",
				VariantAttributes: map[string]string{"color": "black"},
				Currency:          "VND",
				LowStockThreshold: 5,
				IsActive:          true,
			},
		},
	})
	createResp, err := h.Create(ctx, createReq)
	if err != nil {
		t.Fatalf("Handler Create failed: %v", err)
	}
	prodID := createResp.Msg.Product.ProductId
	if prodID == "" {
		t.Fatal("expected product_id in Create response")
	}

	// 2. Get Product RPC
	getReq := connect.NewRequest(&commercev1.GetRequest{
		ProductId: prodID,
	})
	// Unauthenticated when no session or context
	_, err = h.Get(ctx, getReq)
	if err == nil {
		t.Fatal("expected unauthenticated error when workspace context missing")
	}

	// 3. List Products RPC with command context
	listReq := connect.NewRequest(&commercev1.ListRequest{
		Pagination: &commonv1.Pagination{PageSize: 10},
	})
	// With context in command context:
	// For queries that don't have CommandContext on wire, transportauth interceptor injects Session in production.
	// For testing, we can simulate by calling through service or testing handler error mapping.
	_ = listReq

	// 4. Import RPC via Connect Handler (Preview Mode)
	csvData := `external_id,title,price,currency
PROD-HND-1,Cốc giữ nhiệt cà phê,149000,VND`

	importPreviewReq := connect.NewRequest(&commercev1.ImportRequest{
		Context:        cmdCtx,
		SourcePlatform: "csv",
		RawData:        csvData,
		PreviewOnly:    true,
	})
	importPreviewResp, err := h.Import(ctx, importPreviewReq)
	if err != nil {
		t.Fatalf("Handler Import Preview failed: %v", err)
	}
	if !importPreviewResp.Msg.IsPreview {
		t.Fatal("expected IsPreview to be true")
	}
	if importPreviewResp.Msg.CreateCount != 1 {
		t.Fatalf("expected 1 create preview, got %d", importPreviewResp.Msg.CreateCount)
	}
	previewToken := importPreviewResp.Msg.PreviewToken

	// 5. Import RPC via Connect Handler (Commit Mode)
	importCommitReq := connect.NewRequest(&commercev1.ImportRequest{
		Context:        cmdCtx,
		SourcePlatform: "csv",
		RawData:        csvData,
		PreviewOnly:    false,
		PreviewToken:   previewToken,
	})
	importCommitResp, err := h.Import(ctx, importCommitReq)
	if err != nil {
		t.Fatalf("Handler Import Commit failed: %v", err)
	}
	if importCommitResp.Msg.IsPreview {
		t.Fatal("expected IsPreview to be false on commit")
	}
	if importCommitResp.Msg.CreateCount != 1 {
		t.Fatalf("expected 1 created product on commit, got %d", importCommitResp.Msg.CreateCount)
	}

	// 6. Link Content RPC
	linkReq := connect.NewRequest(&commercev1.LinkContentRequest{
		Context:     cmdCtx,
		ProductId:   prodID,
		ContentId:   "content-script-77",
		ContentType: "script",
		Title:       "Viral Short Video Script",
		Url:         "https://creativanta.test/scripts/77",
	})
	linkResp, err := h.LinkContent(ctx, linkReq)
	if err != nil {
		t.Fatalf("Handler LinkContent failed: %v", err)
	}
	if !linkResp.Msg.Success {
		t.Fatal("expected link success to be true")
	}
	if linkResp.Msg.LinkedContent.ContentId != "content-script-77" {
		t.Fatalf("unexpected content ID: %s", linkResp.Msg.LinkedContent.ContentId)
	}
}
