package product_test

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/product"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func testCmdCtx(wsID, idemKey string) *commonv1.CommandContext {
	ctx := &commonv1.CommandContext{
		IdempotencyKey: idemKey,
	}
	if wsID != "" {
		ctx.WorkspaceId = &commonv1.UUID{Value: wsID}
	}
	return ctx
}

func TestHandlerConnectRPCEndpoints(t *testing.T) {
	ctx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	fixedTime := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return fixedTime })
	h := product.NewHandler(svc)

	// 1. Create Product RPC
	createReq := connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx(testWorkspaceID1, "idem-hnd-create-1"),
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
	_ = listReq

	// 4. Import RPC via Connect Handler (Preview Mode)
	csvData := `external_id,title,price,currency
PROD-HND-1,Cốc giữ nhiệt cà phê,149000,VND`

	importPreviewReq := connect.NewRequest(&commercev1.ImportRequest{
		Context:        testCmdCtx(testWorkspaceID1, "idem-hnd-import-preview-1"),
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
		Context:        testCmdCtx(testWorkspaceID1, "idem-hnd-import-commit-1"),
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
		Context:     testCmdCtx(testWorkspaceID1, "idem-hnd-link-1"),
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
			Context:     testCmdCtx("", fmt.Sprintf("idem-r12-ws1-%d", i)),
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
			Context:     testCmdCtx("", fmt.Sprintf("idem-r12-ws2-%d", i)),
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
		Context:     testCmdCtx("", "idem-r02-create-b"),
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
		Context:     testCmdCtx("", "idem-r02-create-a"),
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
	forgedCtx := testCmdCtx(testWorkspaceID2, "idem-forged-ws")
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
		Context:     testCmdCtx("", "idem-viewer-create"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Viewer Forbidden",
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when viewer calls Create, got %v", err)
	}
	if _, err := h.Archive(ctxViewerA, connect.NewRequest(&commercev1.ArchiveRequest{
		Context:   testCmdCtx("", "idem-viewer-archive"),
		ProductId: prodAID,
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when viewer calls Archive, got %v", err)
	}
	// Editor cannot BulkArchive (Manager+), Delete (Admin+), or Import (Admin+)
	if _, err := h.BulkArchive(ctxEditorA, connect.NewRequest(&commercev1.BulkArchiveRequest{
		Context:    testCmdCtx("", "idem-editor-bulk"),
		ProductIds: []string{prodAID},
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when editor calls BulkArchive (Manager+), got %v", err)
	}
	if _, err := h.Delete(ctxEditorA, connect.NewRequest(&commercev1.DeleteRequest{
		Context:   testCmdCtx("", "idem-editor-del"),
		ProductId: prodAID,
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when editor calls Delete (Admin+), got %v", err)
	}
	if _, err := h.Import(ctxEditorA, connect.NewRequest(&commercev1.ImportRequest{
		SourcePlatform: "csv",
		RawData:        "external_id,title,price,currency\n1,A,10,VND",
		PreviewOnly:    true,
	})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected CodePermissionDenied when editor calls Import (Admin+), got %v", err)
	}
}

func TestRemediation_F01_UpdateStockAppendsStockMovementAndEnforcesLedgerInvariants(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	fixedTime := time.Date(2026, 11, 6, 10, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return fixedTime })
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	created, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f01-create"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Bàn phím cơ không dây",
		BasePrice:   &commonv1.Money{Amount: "1500000.000000", Currency: "VND"},
		Currency:    "VND",
	}))
	if err != nil {
		t.Fatalf("create failed: %v", err)
	}
	skuID := created.Msg.Product.Skus[0].SkuId

	// 1. Missing reason must fail with CodeInvalidArgument
	if _, err := h.UpdateStock(ctxOwner, connect.NewRequest(&commercev1.UpdateStockRequest{
		Context:       testCmdCtx("", "idem-f01-empty-reason"),
		SkuId:         skuID,
		DeltaQuantity: 10,
		Reason:        "   ",
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument for empty reason, got %v", err)
	}

	// 2. Zero delta must fail with CodeInvalidArgument
	if _, err := h.UpdateStock(ctxOwner, connect.NewRequest(&commercev1.UpdateStockRequest{
		Context:       testCmdCtx("", "idem-f01-zero-delta"),
		SkuId:         skuID,
		DeltaQuantity: 0,
		Reason:        "recount",
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument for zero delta, got %v", err)
	}

	// 3. Valid stock adjustment (+25) appends stock_movement and emits inventory.stock_moved
	stockResp, err := h.UpdateStock(ctxOwner, connect.NewRequest(&commercev1.UpdateStockRequest{
		Context:       testCmdCtx("", "idem-f01-add-25"),
		SkuId:         skuID,
		DeltaQuantity: 25,
		Reason:        "initial_warehouse_receipt",
	}))
	if err != nil {
		t.Fatalf("UpdateStock +25 failed: %v", err)
	}
	if stockResp.Msg.NewStockQuantity != 25 {
		t.Fatalf("expected new_stock_quantity 25, got %d", stockResp.Msg.NewStockQuantity)
	}

	movements := store.ListStockMovements(testWorkspaceID1, skuID)
	if len(movements) != 1 {
		t.Fatalf("expected 1 stock_movements ledger row, got %d", len(movements))
	}
	if movements[0].MovementType != "adjustment" || movements[0].Quantity != 25 || movements[0].Reason != "initial_warehouse_receipt" {
		t.Fatalf("unexpected stock movement record: %+v", movements[0])
	}

	var foundStockMoved bool
	for _, ev := range sink.Events() {
		if ev.EventType == "inventory.stock_moved" && ev.AggregateID == skuID {
			foundStockMoved = true
			break
		}
	}
	if !foundStockMoved {
		t.Fatal("expected inventory.stock_moved event to be emitted on UpdateStock")
	}

	// 4. Negative stock violation (-30 from 25) rejected with CodeFailedPrecondition, no movement appended
	if _, err := h.UpdateStock(ctxOwner, connect.NewRequest(&commercev1.UpdateStockRequest{
		Context:       testCmdCtx("", "idem-f01-sub-30"),
		SkuId:         skuID,
		DeltaQuantity: -30,
		Reason:        "damaged",
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected CodeFailedPrecondition when adjustment drops stock below 0, got %v", err)
	}
	if len(store.ListStockMovements(testWorkspaceID1, skuID)) != 1 {
		t.Fatal("failed stock adjustment must not append stock_movements row")
	}
}

func TestRemediation_DataReview6_MutatingCommandsEnforceIdempotencyKeyReplayAndConflict(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	fixedTime := time.Date(2026, 11, 6, 11, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return fixedTime })
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	// 1. Missing idempotency_key on mutating RPCs is rejected with CodeInvalidArgument
	if _, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Missing Idempotency Key",
		BasePrice:   &commonv1.Money{Amount: "100000.000000", Currency: "VND"},
		Currency:    "VND",
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument when idempotency_key is missing, got %v", err)
	}

	// 2. Create with idempotency_key and replay identical request -> returns same ProductId without creating duplicate
	createReq := &commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-dr6-create-1"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Máy ảnh Mirrorless",
		BasePrice:   &commonv1.Money{Amount: "15000000.000000", Currency: "VND"},
		Currency:    "VND",
	}
	resp1, err := h.Create(ctxOwner, connect.NewRequest(createReq))
	if err != nil {
		t.Fatalf("first Create failed: %v", err)
	}
	resp2, err := h.Create(ctxOwner, connect.NewRequest(createReq))
	if err != nil {
		t.Fatalf("idempotent replay of Create failed: %v", err)
	}
	if resp1.Msg.Product.ProductId != resp2.Msg.Product.ProductId {
		t.Fatalf("expected identical product_id on replay, got %s vs %s", resp1.Msg.Product.ProductId, resp2.Msg.Product.ProductId)
	}

	// 3. Reusing same idempotency_key with different payload fails with CodeAlreadyExists (SYSTEM_CONFLICT_001)
	conflictReq := &commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-dr6-create-1"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Máy ảnh Khác Payload",
		BasePrice:   &commonv1.Money{Amount: "15000000.000000", Currency: "VND"},
		Currency:    "VND",
	}
	_, err = h.Create(ctxOwner, connect.NewRequest(conflictReq))
	if connect.CodeOf(err) != connect.CodeAlreadyExists || !strings.Contains(err.Error(), "SYSTEM_CONFLICT_001") {
		t.Fatalf("expected CodeAlreadyExists with SYSTEM_CONFLICT_001 on conflicting idempotency replay, got %v", err)
	}

	// 4. UpdateStock replay with same idempotency_key does not double-increment stock
	skuID := resp1.Msg.Product.Skus[0].SkuId
	stockReq := &commercev1.UpdateStockRequest{
		Context:       testCmdCtx("", "idem-dr6-stock-1"),
		SkuId:         skuID,
		DeltaQuantity: 10,
		Reason:        "restock",
	}
	st1, err := h.UpdateStock(ctxOwner, connect.NewRequest(stockReq))
	if err != nil {
		t.Fatalf("first UpdateStock failed: %v", err)
	}
	st2, err := h.UpdateStock(ctxOwner, connect.NewRequest(stockReq))
	if err != nil {
		t.Fatalf("replay UpdateStock failed: %v", err)
	}
	if st1.Msg.NewStockQuantity != 10 || st2.Msg.NewStockQuantity != 10 {
		t.Fatalf("expected stock to remain 10 on replay, got %d and %d", st1.Msg.NewStockQuantity, st2.Msg.NewStockQuantity)
	}
	if len(store.ListStockMovements(testWorkspaceID1, skuID)) != 1 {
		t.Fatalf("expected exactly 1 stock movement after replay, got %d", len(store.ListStockMovements(testWorkspaceID1, skuID)))
	}
}

func TestRemediation_DataReview8_ExpectedUpdatedAtAndConcurrentPartialUpdates(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	svc := product.NewService(store, sink, nil)
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	created, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-dr8-create"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Original Title",
		Description: "Original Description",
		Category:    "Original Category",
		BasePrice:   &commonv1.Money{Amount: "200000.000000", Currency: "VND"},
		Currency:    "VND",
	}))
	if err != nil {
		t.Fatalf("create failed: %v", err)
	}
	prod := created.Msg.Product
	initialUpdatedAt := prod.UpdatedAt

	// 1. Concurrent partial updates (one updates Title, one updates Description) must both be preserved
	var wg sync.WaitGroup
	wg.Add(2)
	var errTitle, errDesc error
	newTitle := "Concurrent Updated Title"
	newDesc := "Concurrent Updated Description"

	go func() {
		defer wg.Done()
		_, errTitle = h.Update(ctxOwner, connect.NewRequest(&commercev1.UpdateRequest{
			Context:   testCmdCtx("", "idem-dr8-upd-title"),
			ProductId: prod.ProductId,
			Title:     &newTitle,
		}))
	}()
	go func() {
		defer wg.Done()
		_, errDesc = h.Update(ctxOwner, connect.NewRequest(&commercev1.UpdateRequest{
			Context:     testCmdCtx("", "idem-dr8-upd-desc"),
			ProductId:   prod.ProductId,
			Description: &newDesc,
		}))
	}()
	wg.Wait()

	if errTitle != nil || errDesc != nil {
		t.Fatalf("concurrent updates failed: errTitle=%v, errDesc=%v", errTitle, errDesc)
	}

	got, err := h.Get(ctxOwner, connect.NewRequest(&commercev1.GetRequest{ProductId: prod.ProductId}))
	if err != nil {
		t.Fatalf("Get failed: %v", err)
	}
	if got.Msg.Product.Title != newTitle || got.Msg.Product.Description != newDesc {
		t.Fatalf("lost update detected: title=%q (want %q), desc=%q (want %q)",
			got.Msg.Product.Title, newTitle, got.Msg.Product.Description, newDesc)
	}

	// Verify non-status updates did NOT emit product.catalog_status_changed
	for _, ev := range sink.Events() {
		if ev.EventType == "product.catalog_status_changed" {
			t.Fatalf("unexpected product.catalog_status_changed event when catalog_status did not change: %+v", ev)
		}
	}

	// 2. Stale expected_updated_at must be rejected with CodeFailedPrecondition (SYSTEM_CONFLICT_001)
	staleTitle := "Should Fail Stale Write"
	staleCtx := testCmdCtx("", "idem-dr8-stale")
	staleCtx.ExpectedUpdatedAt = initialUpdatedAt
	_, err = h.Update(ctxOwner, connect.NewRequest(&commercev1.UpdateRequest{
		Context:   staleCtx,
		ProductId: prod.ProductId,
		Title:     &staleTitle,
	}))
	if connect.CodeOf(err) != connect.CodeFailedPrecondition || !strings.Contains(err.Error(), "SYSTEM_CONFLICT_001") {
		t.Fatalf("expected CodeFailedPrecondition with SYSTEM_CONFLICT_001 on stale expected_updated_at, got %v", err)
	}

	// 3. Matching expected_updated_at succeeds
	freshTitle := "Fresh CAS Update"
	freshCtx := testCmdCtx("", "idem-dr8-fresh")
	freshCtx.ExpectedUpdatedAt = timestamppb.New(got.Msg.Product.UpdatedAt.AsTime())
	freshResp, err := h.Update(ctxOwner, connect.NewRequest(&commercev1.UpdateRequest{
		Context:   freshCtx,
		ProductId: prod.ProductId,
		Title:     &freshTitle,
	}))
	if err != nil {
		t.Fatalf("expected update with matching expected_updated_at to succeed, got %v", err)
	}
	if freshResp.Msg.Product.Title != freshTitle {
		t.Fatalf("expected title %q, got %q", freshTitle, freshResp.Msg.Product.Title)
	}
}

func TestRemediation_DataReview11_ImportDryRunDoesNotPersistData(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	svc := product.NewService(store, sink, nil)
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	csvData := `external_id,title,price,currency
DRY-RUN-1,Sản phẩm chạy thử DryRun,250000,VND`

	resp, err := h.Import(ctxOwner, connect.NewRequest(&commercev1.ImportRequest{
		Context:        testCmdCtx("", "idem-dr11-dryrun"),
		SourcePlatform: "csv",
		RawData:        csvData,
		PreviewOnly:    false,
		DryRun:         true,
	}))
	if err != nil {
		t.Fatalf("Import with dry_run=true failed: %v", err)
	}
	if !resp.Msg.IsPreview {
		t.Fatal("expected IsPreview=true when dry_run=true")
	}
	if resp.Msg.PreviewToken == "" {
		t.Fatal("expected non-empty preview_token when dry_run=true")
	}
	if len(resp.Msg.CreatedProducts) != 0 {
		t.Fatalf("expected 0 committed products in dry_run response, got %d", len(resp.Msg.CreatedProducts))
	}

	// Verify store remains empty and no product.created event was emitted
	listResp, err := h.List(ctxOwner, connect.NewRequest(&commercev1.ListRequest{}))
	if err != nil {
		t.Fatalf("List failed: %v", err)
	}
	if len(listResp.Msg.Products) != 0 {
		t.Fatalf("dry_run=true persisted %d products into store!", len(listResp.Msg.Products))
	}
	if len(sink.Events()) != 0 {
		t.Fatalf("dry_run=true emitted %d domain events!", len(sink.Events()))
	}
}

type failingUpdateStore struct {
	product.Store
	failUpdateErr error
}

func (f *failingUpdateStore) UpdateProduct(ctx context.Context, p *product.Product) error {
	if f.failUpdateErr != nil {
		return f.failUpdateErr
	}
	return f.Store.UpdateProduct(ctx, p)
}

func TestRemediation_DataReview12_ImportUpdateFailureReportedAsErrorRow(t *testing.T) {
	baseCtx := context.Background()
	memStore := product.NewMemoryStore()
	wrapStore := &failingUpdateStore{Store: memStore}
	sink := product.NewMemoryEventSink()
	svc := product.NewService(wrapStore, sink, nil)

	csvInitial := `external_id,title,price,currency
EXT-UPD-1,Original Imported Title,100000,VND`

	preview1, err := svc.Import(baseCtx, testWorkspaceID1, "csv", "acc-1", csvInitial, nil, "VND", true, "")
	if err != nil {
		t.Fatalf("preview1 failed: %v", err)
	}
	if _, err := svc.Import(baseCtx, testWorkspaceID1, "csv", "acc-1", csvInitial, nil, "VND", false, preview1.PreviewToken); err != nil {
		t.Fatalf("commit1 failed: %v", err)
	}

	// Now import an updated title while UpdateProduct fails in the DB store
	csvUpdated := `external_id,title,price,currency
EXT-UPD-1,Updated Imported Title,120000,VND`

	preview2, err := svc.Import(baseCtx, testWorkspaceID1, "csv", "acc-1", csvUpdated, nil, "VND", true, "")
	if err != nil {
		t.Fatalf("preview2 failed: %v", err)
	}

	wrapStore.failUpdateErr = errors.New("simulated database write failure")
	commit2, err := svc.Import(baseCtx, testWorkspaceID1, "csv", "acc-1", csvUpdated, nil, "VND", false, preview2.PreviewToken)
	if err != nil {
		t.Fatalf("commit2 returned unexpected top-level error: %v", err)
	}
	if commit2.UpdateCount != 0 {
		t.Fatalf("expected UpdateCount=0 when DB update fails, got %d", commit2.UpdateCount)
	}
	if commit2.ErrorCount != 1 {
		t.Fatalf("expected ErrorCount=1 when DB update fails, got %d", commit2.ErrorCount)
	}
	if len(commit2.Rows) != 1 || commit2.Rows[0].Action != "error" {
		t.Fatalf("expected row action='error', got %+v", commit2.Rows)
	}
	if !strings.Contains(commit2.DownloadableErrorCSV, "simulated database write failure") {
		t.Fatalf("expected DownloadableErrorCSV to include DB failure, got %q", commit2.DownloadableErrorCSV)
	}
}

func TestRemediation_DataReview13_KeysetCursorNoDuplicatesOrSkipsUnderConcurrentInsertAndDelete(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()

	currentTime := time.Date(2026, 11, 6, 12, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return currentTime })
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	// Create 4 products P1..P4 with ascending timestamps (so descending order is P4, P3, P2, P1)
	var ids []string
	for i := 1; i <= 4; i++ {
		currentTime = time.Date(2026, 11, 6, 12, i, 0, 0, time.UTC)
		resp, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
			Context:     testCmdCtx("", fmt.Sprintf("idem-dr13-p%d", i)),
			ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
			Title:       fmt.Sprintf("Keyset Product P%d", i),
			BasePrice:   &commonv1.Money{Amount: "100000.000000", Currency: "VND"},
			Currency:    "VND",
		}))
		if err != nil {
			t.Fatalf("create P%d failed: %v", i, err)
		}
		ids = append(ids, resp.Msg.Product.ProductId)
	}
	// Descending order: ids[3] (P4), ids[2] (P3), ids[1] (P2), ids[0] (P1)

	// Fetch page 1 (size 2) -> returns [P4, P3]
	page1, err := h.List(ctxOwner, connect.NewRequest(&commercev1.ListRequest{
		Pagination: &commonv1.Pagination{PageSize: 2},
	}))
	if err != nil {
		t.Fatalf("List page 1 failed: %v", err)
	}
	if len(page1.Msg.Products) != 2 || page1.Msg.Products[0].ProductId != ids[3] || page1.Msg.Products[1].ProductId != ids[2] {
		t.Fatalf("unexpected page 1 items: got [%s, %s], want [%s, %s]",
			page1.Msg.Products[0].ProductId, page1.Msg.Products[1].ProductId, ids[3], ids[2])
	}
	token := page1.Msg.Pagination.GetNextPageToken()

	// Before fetching page 2:
	// 1) Insert a brand-new product P5 at the top of the list (12:10)
	// With naive OFFSET pagination, inserting P5 would shift P3 into offset 2 and cause page 2 to duplicate P3!
	currentTime = time.Date(2026, 11, 6, 12, 10, 0, 0, time.UTC)
	if _, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-dr13-p5"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Keyset Product P5",
		BasePrice:   &commonv1.Money{Amount: "100000.000000", Currency: "VND"},
		Currency:    "VND",
	})); err != nil {
		t.Fatalf("create P5 failed: %v", err)
	}

	// Fetch page 2 using keyset token -> must return [P2, P1] with NO duplicate of P3!
	page2, err := h.List(ctxOwner, connect.NewRequest(&commercev1.ListRequest{
		Pagination: &commonv1.Pagination{PageSize: 2, PageToken: token},
	}))
	if err != nil {
		t.Fatalf("List page 2 failed: %v", err)
	}
	if len(page2.Msg.Products) != 2 || page2.Msg.Products[0].ProductId != ids[1] || page2.Msg.Products[1].ProductId != ids[0] {
		t.Fatalf("keyset pagination failed after concurrent insert: got [%s, %s], want [%s, %s]",
			page2.Msg.Products[0].ProductId, page2.Msg.Products[1].ProductId, ids[1], ids[0])
	}
	if page2.Msg.Pagination.GetHasMore() {
		t.Fatal("expected has_more=false on page 2 after reaching P1")
	}
}

func TestRemediation_DataReview20_ProductStatsRankAndCurrencyReflectActualData(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	currentTime := time.Date(2026, 11, 6, 13, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return currentTime })
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	// Create 2 USD products in the same category at different timestamps
	p1, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-dr20-p1"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_DIGITAL,
		Title:       "Creator Preset Pack #1",
		Category:    "Presets",
		BasePrice:   &commonv1.Money{Amount: "29.990000", Currency: "USD"},
		Currency:    "USD",
	}))
	if err != nil {
		t.Fatalf("create p1 failed: %v", err)
	}

	currentTime = currentTime.Add(time.Minute)
	p2, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-dr20-p2"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_DIGITAL,
		Title:       "Creator Preset Pack #2",
		Category:    "Presets",
		BasePrice:   &commonv1.Money{Amount: "49.990000", Currency: "USD"},
		Currency:    "USD",
	}))
	if err != nil {
		t.Fatalf("create p2 failed: %v", err)
	}

	// Verify GetStats and GetSalesStats return product's actual currency ("USD"), not hardcoded "VND"
	stats1, err := h.GetStats(ctxOwner, connect.NewRequest(&commercev1.GetStatsRequest{ProductId: p1.Msg.Product.ProductId}))
	if err != nil {
		t.Fatalf("GetStats failed: %v", err)
	}
	if stats1.Msg.TotalRevenue.Currency != "USD" {
		t.Fatalf("expected GetStats currency 'USD', got %q", stats1.Msg.TotalRevenue.Currency)
	}

	sales1, err := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{ProductId: p1.Msg.Product.ProductId}))
	if err != nil {
		t.Fatalf("GetSalesStats failed: %v", err)
	}
	if sales1.Msg.GrossSales.Currency != "USD" || sales1.Msg.NetSales.Currency != "USD" {
		t.Fatalf("expected GetSalesStats currency 'USD', got gross=%q net=%q", sales1.Msg.GrossSales.Currency, sales1.Msg.NetSales.Currency)
	}

	// Verify GetRank returns distinct ranks for p1 (rank 1) and p2 (rank 2), not static 1 for every product
	rank1, err := h.GetRank(ctxOwner, connect.NewRequest(&commercev1.GetRankRequest{ProductId: p1.Msg.Product.ProductId}))
	if err != nil {
		t.Fatalf("GetRank p1 failed: %v", err)
	}
	rank2, err := h.GetRank(ctxOwner, connect.NewRequest(&commercev1.GetRankRequest{ProductId: p2.Msg.Product.ProductId}))
	if err != nil {
		t.Fatalf("GetRank p2 failed: %v", err)
	}
	if rank1.Msg.RankInWorkspace != 1 || rank1.Msg.RankInCategory != 1 {
		t.Fatalf("expected p1 rank (1, 1), got (%d, %d)", rank1.Msg.RankInWorkspace, rank1.Msg.RankInCategory)
	}
	if rank2.Msg.RankInWorkspace != 2 || rank2.Msg.RankInCategory != 2 {
		t.Fatalf("expected p2 rank (2, 2), got (%d, %d)", rank2.Msg.RankInWorkspace, rank2.Msg.RankInCategory)
	}
}
