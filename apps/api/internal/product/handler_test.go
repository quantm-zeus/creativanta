package product_test

import (
	"context"
	"fmt"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/product"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
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

func TestRemediation_R12_ProductPaginationCursorAndOrdering(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()

	currentTime := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return currentTime })
	h := product.NewHandler(svc)

	ctxWs1 := product.WithCaller(baseCtx, testWorkspaceID1, "user-ws1-owner", rbac.RoleOwner)
	ctxWs2 := product.WithCaller(baseCtx, testWorkspaceID2, "user-ws2-owner", rbac.RoleOwner)

	// Seed 5 products in Workspace 1 with controlled timestamps (including equal-timestamp tie-break)
	var createdIDs []string
	for i := 1; i <= 5; i++ {
		if i <= 3 {
			currentTime = time.Date(2026, 11, 2, 12, i, 0, 0, time.UTC)
		} else {
			// Products 4 and 5 share the exact same timestamp to exercise ProductID DESC tie-breaking
			currentTime = time.Date(2026, 11, 2, 12, 10, 0, 0, time.UTC)
		}
		resp, err := h.Create(ctxWs1, connect.NewRequest(&commercev1.CreateRequest{
			ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
			Title:       fmt.Sprintf("Sản phẩm Điện tử #%d", i),
			Description: "Thiết bị công nghệ chính hãng",
			Category:    "Điện tử",
			BasePrice:   &commonv1.Money{Amount: "100000.000000", Currency: "VND"},
			Currency:    "VND",
		}))
		if err != nil {
			t.Fatalf("Create product %d in ws1 failed: %v", i, err)
		}
		createdIDs = append(createdIDs, resp.Msg.Product.ProductId)
	}

	// Seed 2 products in Workspace 2 to ensure cursor and counts are strictly tenant-scoped
	for i := 1; i <= 2; i++ {
		if _, err := h.Create(ctxWs2, connect.NewRequest(&commercev1.CreateRequest{
			ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
			Title:       fmt.Sprintf("Sản phẩm Điện tử WS2 #%d", i),
			Description: "Thiết bị công nghệ WS2",
			Category:    "Điện tử",
			BasePrice:   &commonv1.Money{Amount: "200000.000000", Currency: "VND"},
			Currency:    "VND",
		})); err != nil {
			t.Fatalf("Create product %d in ws2 failed: %v", i, err)
		}
	}

	// 1. Traverse List pages with PageSize = 2
	page1, err := h.List(ctxWs1, connect.NewRequest(&commercev1.ListRequest{
		CategoryFilter: "Điện tử",
		Pagination:     &commonv1.Pagination{PageSize: 2},
	}))
	if err != nil {
		t.Fatalf("List page 1 failed: %v", err)
	}
	if len(page1.Msg.Products) != 2 {
		t.Fatalf("expected 2 products on page 1, got %d", len(page1.Msg.Products))
	}
	if page1.Msg.Pagination.GetTotalCount() != 5 {
		t.Fatalf("expected total_count 5 on page 1, got %d", page1.Msg.Pagination.GetTotalCount())
	}
	if !page1.Msg.Pagination.GetHasMore() {
		t.Fatal("expected has_more = true on page 1")
	}
	token1 := page1.Msg.Pagination.GetNextPageToken()
	if token1 == "" {
		t.Fatal("expected non-empty next_page_token on page 1")
	}

	page2, err := h.List(ctxWs1, connect.NewRequest(&commercev1.ListRequest{
		CategoryFilter: "Điện tử",
		Pagination:     &commonv1.Pagination{PageSize: 2, PageToken: token1},
	}))
	if err != nil {
		t.Fatalf("List page 2 failed: %v", err)
	}
	if len(page2.Msg.Products) != 2 {
		t.Fatalf("expected 2 products on page 2, got %d", len(page2.Msg.Products))
	}
	if !page2.Msg.Pagination.GetHasMore() {
		t.Fatal("expected has_more = true on page 2")
	}
	token2 := page2.Msg.Pagination.GetNextPageToken()
	if token2 == "" || token2 == token1 {
		t.Fatalf("expected distinct non-empty next_page_token on page 2, got %q", token2)
	}

	page3, err := h.List(ctxWs1, connect.NewRequest(&commercev1.ListRequest{
		CategoryFilter: "Điện tử",
		Pagination:     &commonv1.Pagination{PageSize: 2, PageToken: token2},
	}))
	if err != nil {
		t.Fatalf("List page 3 failed: %v", err)
	}
	if len(page3.Msg.Products) != 1 {
		t.Fatalf("expected 1 product on terminal page 3, got %d", len(page3.Msg.Products))
	}
	if page3.Msg.Pagination.GetHasMore() {
		t.Fatal("expected has_more = false on terminal page 3")
	}
	if page3.Msg.Pagination.GetNextPageToken() != "" {
		t.Fatalf("expected empty next_page_token on terminal page 3, got %q", page3.Msg.Pagination.GetNextPageToken())
	}

	// Verify all 5 products across pages are unique, belong to ws1, and follow CreatedAt DESC, ProductID DESC
	var allListed []*commercev1.Product
	allListed = append(allListed, page1.Msg.Products...)
	allListed = append(allListed, page2.Msg.Products...)
	allListed = append(allListed, page3.Msg.Products...)

	seen := make(map[string]bool)
	for idx, p := range allListed {
		if p.WorkspaceId != testWorkspaceID1 {
			t.Fatalf("cross-tenant leak at index %d: workspace %s", idx, p.WorkspaceId)
		}
		if seen[p.ProductId] {
			t.Fatalf("duplicate product %s returned across paginated pages", p.ProductId)
		}
		seen[p.ProductId] = true
		if idx > 0 {
			prev := allListed[idx-1]
			prevTime := prev.CreatedAt.AsTime()
			currTime := p.CreatedAt.AsTime()
			if currTime.After(prevTime) {
				t.Fatalf("ordering violation at index %d: %v > %v", idx, currTime, prevTime)
			}
			if currTime.Equal(prevTime) && p.ProductId >= prev.ProductId {
				t.Fatalf("tie-breaker ordering violation at index %d: %s >= %s", idx, p.ProductId, prev.ProductId)
			}
		}
	}
	if len(seen) != len(createdIDs) {
		t.Fatalf("expected %d unique products across pages, got %d", len(createdIDs), len(seen))
	}

	// 2. Traverse Search pages with PageSize = 2
	sPage1, err := h.Search(ctxWs1, connect.NewRequest(&commercev1.SearchRequest{
		Query:      "Sản phẩm Điện tử",
		Pagination: &commonv1.Pagination{PageSize: 2},
	}))
	if err != nil {
		t.Fatalf("Search page 1 failed: %v", err)
	}
	if len(sPage1.Msg.Products) != 2 || !sPage1.Msg.Pagination.GetHasMore() || sPage1.Msg.Pagination.GetNextPageToken() == "" {
		t.Fatalf("unexpected Search page 1 pagination: %+v", sPage1.Msg.Pagination)
	}
	sPage2, err := h.Search(ctxWs1, connect.NewRequest(&commercev1.SearchRequest{
		Query:      "Sản phẩm Điện tử",
		Pagination: &commonv1.Pagination{PageSize: 2, PageToken: sPage1.Msg.Pagination.GetNextPageToken()},
	}))
	if err != nil {
		t.Fatalf("Search page 2 failed: %v", err)
	}
	if len(sPage2.Msg.Products) != 2 || sPage2.Msg.Products[0].ProductId == sPage1.Msg.Products[0].ProductId {
		t.Fatal("Search page 2 did not advance offset")
	}

	// 3. Invalid cursor handling must fail closed with CodeInvalidArgument
	invalidTokens := []struct {
		name  string
		ctx   context.Context
		cat   string
		token string
	}{
		{name: "malformed_no_dot", ctx: ctxWs1, cat: "Điện tử", token: "malformed-cursor-token"},
		{name: "invalid_base64", ctx: ctxWs1, cat: "Điện tử", token: "%%%." + strings.Split(token1, ".")[1]},
		{name: "tampered_hmac_signature", ctx: ctxWs1, cat: "Điện tử", token: token1 + "ab"},
		{name: "cross_tenant_cursor_reuse", ctx: ctxWs2, cat: "Điện tử", token: token1},
		{name: "filter_mismatch_category", ctx: ctxWs1, cat: "Thời trang", token: token1},
		{name: "cross_rpc_cursor_reuse", ctx: ctxWs1, cat: "Điện tử", token: sPage1.Msg.Pagination.GetNextPageToken()},
	}
	for _, tc := range invalidTokens {
		_, err := h.List(tc.ctx, connect.NewRequest(&commercev1.ListRequest{
			CategoryFilter: tc.cat,
			Pagination:     &commonv1.Pagination{PageSize: 2, PageToken: tc.token},
		}))
		if connect.CodeOf(err) != connect.CodeInvalidArgument {
			t.Fatalf("case %s: expected CodeInvalidArgument, got %v", tc.name, err)
		}
	}

	// Negative page_size rejected
	if _, err := h.List(ctxWs1, connect.NewRequest(&commercev1.ListRequest{
		Pagination: &commonv1.Pagination{PageSize: -5},
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument for negative page_size, got %v", err)
	}
}

func TestRemediation_R02_ProductTenantIsolationAndRBAC(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	fixedTime := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return fixedTime })
	h := product.NewHandler(svc)

	ctxOwnerA := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-a", rbac.RoleOwner)
	ctxViewerA := product.WithCaller(baseCtx, testWorkspaceID1, "user-viewer-a", rbac.RoleViewer)
	ctxEditorA := product.WithCaller(baseCtx, testWorkspaceID1, "user-editor-a", rbac.RoleEditor)
	ctxOwnerB := product.WithCaller(baseCtx, testWorkspaceID2, "user-owner-b", rbac.RoleOwner)

	// Create product in Workspace B
	createB, err := h.Create(ctxOwnerB, connect.NewRequest(&commercev1.CreateRequest{
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Sản phẩm Nội bộ Tenant B",
		BasePrice:   &commonv1.Money{Amount: "500000.000000", Currency: "VND"},
		Currency:    "VND",
	}))
	if err != nil {
		t.Fatalf("createB failed: %v", err)
	}
	prodBID := createB.Msg.Product.ProductId

	// Create product in Workspace A
	createA, err := h.Create(ctxOwnerA, connect.NewRequest(&commercev1.CreateRequest{
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Sản phẩm Tenant A",
		BasePrice:   &commonv1.Money{Amount: "300000.000000", Currency: "VND"},
		Currency:    "VND",
	}))
	if err != nil {
		t.Fatalf("createA failed: %v", err)
	}
	prodAID := createA.Msg.Product.ProductId

	// 1. Unauthenticated calls to read endpoints fail with CodeUnauthenticated
	if _, err := h.GetSalesStats(baseCtx, connect.NewRequest(&commercev1.GetSalesStatsRequest{ProductId: prodAID})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated on GetSalesStats, got %v", err)
	}
	if _, err := h.GetSalesChart(baseCtx, connect.NewRequest(&commercev1.GetSalesChartRequest{ProductId: prodAID})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated on GetSalesChart, got %v", err)
	}
	if _, err := h.GetReviews(baseCtx, connect.NewRequest(&commercev1.GetReviewsRequest{ProductId: prodAID})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated on GetReviews, got %v", err)
	}
	if _, err := h.GetRank(baseCtx, connect.NewRequest(&commercev1.GetRankRequest{ProductId: prodAID})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected CodeUnauthenticated on GetRank, got %v", err)
	}

	// 2. Cross-tenant product access fails with CodeNotFound
	if _, err := h.Get(ctxOwnerA, connect.NewRequest(&commercev1.GetRequest{ProductId: prodBID})); connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound when Tenant A reads Tenant B product, got %v", err)
	}
	if _, err := h.GetSalesStats(ctxOwnerA, connect.NewRequest(&commercev1.GetSalesStatsRequest{ProductId: prodBID})); connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound when Tenant A reads Tenant B sales stats, got %v", err)
	}
	if _, err := h.GetSalesChart(ctxOwnerA, connect.NewRequest(&commercev1.GetSalesChartRequest{ProductId: prodBID})); connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound when Tenant A reads Tenant B sales chart, got %v", err)
	}
	if _, err := h.GetReviews(ctxOwnerA, connect.NewRequest(&commercev1.GetReviewsRequest{ProductId: prodBID})); connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound when Tenant A reads Tenant B reviews, got %v", err)
	}
	if _, err := h.GetRank(ctxOwnerA, connect.NewRequest(&commercev1.GetRankRequest{ProductId: prodBID})); connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound when Tenant A reads Tenant B rank, got %v", err)
	}

	// 3. Forged CommandContext.WorkspaceId mismatch rejected with CodePermissionDenied
	forgedCtx := &commonv1.CommandContext{WorkspaceId: &commonv1.UUID{Value: testWorkspaceID2}}
	if _, err := h.Create(ctxOwnerA, connect.NewRequest(&commercev1.CreateRequest{
		Context:     forgedCtx,
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Forged",
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied on forged workspace_id in Create, got %v", err)
	}

	// 4. Role envelope & permission checks
	// Viewer can read own workspace product
	if _, err := h.GetSalesStats(ctxViewerA, connect.NewRequest(&commercev1.GetSalesStatsRequest{ProductId: prodAID})); err != nil {
		t.Fatalf("viewer should be allowed GetSalesStats: %v", err)
	}
	// Viewer cannot Create or Archive (requires product:manage / Editor+)
	if _, err := h.Create(ctxViewerA, connect.NewRequest(&commercev1.CreateRequest{
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Viewer Forbidden",
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when viewer calls Create, got %v", err)
	}
	if _, err := h.Archive(ctxViewerA, connect.NewRequest(&commercev1.ArchiveRequest{ProductId: prodAID})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when viewer calls Archive, got %v", err)
	}
	// Editor cannot BulkArchive (Manager+), Delete (Admin+), or Import (Admin+)
	if _, err := h.BulkArchive(ctxEditorA, connect.NewRequest(&commercev1.BulkArchiveRequest{ProductIds: []string{prodAID}})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when editor calls BulkArchive (Manager+), got %v", err)
	}
	if _, err := h.Delete(ctxEditorA, connect.NewRequest(&commercev1.DeleteRequest{ProductId: prodAID})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when editor calls Delete (Admin+), got %v", err)
	}
	if _, err := h.Import(ctxEditorA, connect.NewRequest(&commercev1.ImportRequest{SourcePlatform: "csv", RawData: "external_id,title,price,currency\n1,A,10,VND", PreviewOnly: true})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when editor calls Import (Admin+), got %v", err)
	}
}
