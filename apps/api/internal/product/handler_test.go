package product_test

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"connectrpc.com/connect"
	commercev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/product"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
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
	fixedTime := time.Now().UTC().Truncate(time.Microsecond)
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
	fixedTime := time.Now().UTC().Truncate(time.Microsecond)
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

type failingIdempotencyStore struct {
	product.Store
	failSaveCount int32
}

func (f *failingIdempotencyStore) SaveIdempotencyRecord(ctx context.Context, rec product.IdempotencyRecord) error {
	if atomic.AddInt32(&f.failSaveCount, -1) >= 0 {
		return errors.New("simulated idempotency persistence failure")
	}
	return f.Store.SaveIdempotencyRecord(ctx, rec)
}

func TestSecondPass_DataF1_AtomicIdempotencyRollbackAndValidation(t *testing.T) {
	baseCtx := context.Background()
	memStore := product.NewMemoryStore()
	wrapStore := &failingIdempotencyStore{Store: memStore, failSaveCount: 1}
	sink := product.NewMemoryEventSink()
	fixedNow := time.Date(2026, 11, 7, 10, 0, 0, 0, time.UTC)
	svc := product.NewService(wrapStore, sink, func() time.Time { return fixedNow })
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	// 1. Validate idempotency_key > 255 chars and reason > 2000 chars fail closed with CodeInvalidArgument
	longKey := strings.Repeat("k", 256)
	_, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", longKey),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Invalid Key Length",
		BasePrice:   &commonv1.Money{Amount: "10.000000", Currency: "USD"},
	}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument for >255 char idempotency_key, got %v", err)
	}

	longReasonCtx := testCmdCtx("", "idem-f1-reason-too-long")
	longReasonCtx.Reason = strings.Repeat("r", 2001)
	_, err = h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     longReasonCtx,
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Invalid Reason Length",
		BasePrice:   &commonv1.Money{Amount: "10.000000", Currency: "USD"},
	}))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument for >2000 char reason, got %v", err)
	}

	// 2. First attempt: SaveIdempotencyRecord fails -> mutation and events MUST roll back atomically
	createReq := &commercev1.CreateRequest{
		Context:          testCmdCtx("", "idem-f1-atomic-create"),
		ProductType:      commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:            "Atomic Idempotent Product",
		BasePrice:        &commonv1.Money{Amount: "100.000000", Currency: "USD"},
		Currency:         "USD",
		InventoryEnabled: true,
		InitialSkus: []*commercev1.ProductSku{
			{
				SkuCode:       "SKU-F1-ATOMIC",
				Currency:      "USD",
				StockQuantity: 10,
				IsActive:      true,
			},
		},
	}
	if _, err := h.Create(ctxOwner, connect.NewRequest(createReq)); err == nil {
		t.Fatal("expected first Create to fail when SaveIdempotencyRecord fails")
	}

	// Verify store has 0 products and 0 emitted events after rollback
	listAfterFail, err := h.List(ctxOwner, connect.NewRequest(&commercev1.ListRequest{}))
	if err != nil {
		t.Fatalf("List failed: %v", err)
	}
	if len(listAfterFail.Msg.Products) != 0 {
		t.Fatalf("expected 0 products after SaveIdempotencyRecord failure rollback, got %d", len(listAfterFail.Msg.Products))
	}
	if len(sink.Events()) != 0 {
		t.Fatalf("expected 0 events after SaveIdempotencyRecord failure rollback, got %d", len(sink.Events()))
	}

	// 3. Retry with same idempotency_key -> succeeds once, emits 1 event, and sets 7-day TTL
	createResp, err := h.Create(ctxOwner, connect.NewRequest(createReq))
	if err != nil {
		t.Fatalf("retry Create after transient idempotency failure failed: %v", err)
	}
	skuID := createResp.Msg.Product.Skus[0].SkuId
	if len(sink.Events()) != 1 {
		t.Fatalf("expected 1 event after successful retry, got %d", len(sink.Events()))
	}
	rec, err := memStore.GetIdempotencyRecord(baseCtx, testWorkspaceID1, "idem-f1-atomic-create")
	if err != nil || rec == nil {
		t.Fatalf("expected saved idempotency record, got rec=%v err=%v", rec, err)
	}
	expectedExpiry := fixedNow.Add(7 * 24 * time.Hour)
	if !rec.ExpiresAt.Equal(expectedExpiry) {
		t.Fatalf("expected 7-day idempotency TTL (%v), got %v", expectedExpiry, rec.ExpiresAt)
	}

	// 4. Now test UpdateStock rollback when SaveIdempotencyRecord fails: stock must NOT double-increment on retry!
	if _, err := h.UpdateStock(ctxOwner, connect.NewRequest(&commercev1.UpdateStockRequest{
		Context:       testCmdCtx("", "idem-f1-stock-init"),
		SkuId:         skuID,
		DeltaQuantity: 10,
		Reason:        "initial_receipt",
	})); err != nil {
		t.Fatalf("initial UpdateStock failed: %v", err)
	}

	atomic.StoreInt32(&wrapStore.failSaveCount, 1)
	stockReq := &commercev1.UpdateStockRequest{
		Context:       testCmdCtx("", "idem-f1-stock-retry"),
		SkuId:         skuID,
		DeltaQuantity: 5,
		Reason:        "restock_after_transient_error",
	}
	if _, err := h.UpdateStock(ctxOwner, connect.NewRequest(stockReq)); err == nil {
		t.Fatal("expected UpdateStock to fail when SaveIdempotencyRecord fails")
	}

	// Retry the same UpdateStock(+5) command: stock must be 10 + 5 = 15, NOT 10 + 5 + 5 = 20!
	stockResp, err := h.UpdateStock(ctxOwner, connect.NewRequest(stockReq))
	if err != nil {
		t.Fatalf("retry UpdateStock failed: %v", err)
	}
	if stockResp.Msg.NewStockQuantity != 15 {
		t.Fatalf("expected stock=15 after rolled-back attempt + retry, got %d (double-increment bug!)", stockResp.Msg.NewStockQuantity)
	}

	// 5. Concurrent replay across two distinct Service/Handler instances sharing the same store
	svc2 := product.NewService(wrapStore, sink, func() time.Time { return fixedNow })
	h2 := product.NewHandler(svc2)
	const workers = 8
	var wg sync.WaitGroup
	errs := make(chan error, workers)
	qtys := make(chan int32, workers)
	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			targetH := h
			if idx%2 == 1 {
				targetH = h2
			}
			resp, callErr := targetH.UpdateStock(ctxOwner, connect.NewRequest(&commercev1.UpdateStockRequest{
				Context:       testCmdCtx("", "idem-f1-multi-instance-concurrent"),
				SkuId:         skuID,
				DeltaQuantity: 7,
				Reason:        "concurrent_replay",
			}))
			if callErr != nil {
				errs <- callErr
				return
			}
			qtys <- resp.Msg.NewStockQuantity
		}(i)
	}
	wg.Wait()
	close(errs)
	close(qtys)
	for callErr := range errs {
		t.Fatalf("concurrent multi-instance UpdateStock error: %v", callErr)
	}
	for q := range qtys {
		if q != 22 {
			t.Fatalf("expected NewStockQuantity=22 (15+7) across all concurrent callers, got %d", q)
		}
	}
}

func TestSecondPass_DataF2_MultiLocationStockUpdateNoDoubleCountAndOpeningBalance(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	svc := product.NewService(store, sink, nil)
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	// 1. Verify CreateSku with StockQuantity > 0 seeds opening_balance at default location
	defaultLoc := "00000000-0000-4000-8000-000000000001"
	locA := "00000000-0000-4000-8000-00000000000a"
	store.SetDefaultLocation(testWorkspaceID1, defaultLoc)

	pWithOpening := &product.Product{
		WorkspaceID:      testWorkspaceID1,
		ProductType:      product.TypePhysical,
		Title:            "Opening Stock Product",
		Currency:         "VND",
		CatalogStatus:    product.StatusActive,
		InventoryEnabled: true,
		SKUs: []product.ProductSku{
			{
				SkuCode:       "SKU-OPENING-10",
				Currency:      "VND",
				StockQuantity: 10,
				IsActive:      true,
			},
		},
	}
	createdOpening, err := svc.CreateProduct(baseCtx, pWithOpening)
	if err != nil {
		t.Fatalf("CreateProduct with opening stock failed: %v", err)
	}
	openingSkuID := createdOpening.SKUs[0].SkuID
	if got, _ := store.GetLocationBalance(testWorkspaceID1, openingSkuID, defaultLoc); got != 10 {
		t.Fatalf("expected default location balance=10 from opening stock, got %d", got)
	}

	// 2. Now simulate multi-location: Location A holds 10 units, while default location has NO row yet (0 units)
	pMulti := &product.Product{
		WorkspaceID:      testWorkspaceID1,
		ProductType:      product.TypePhysical,
		Title:            "Multi-Location Product",
		Currency:         "VND",
		CatalogStatus:    product.StatusActive,
		InventoryEnabled: true,
		SKUs: []product.ProductSku{
			{
				SkuCode:       "SKU-MULTILOC-1",
				Currency:      "VND",
				StockQuantity: 0,
				IsActive:      true,
			},
		},
	}
	createdMulti, err := svc.CreateProduct(baseCtx, pMulti)
	if err != nil {
		t.Fatalf("CreateProduct multi-loc failed: %v", err)
	}
	multiSkuID := createdMulti.SKUs[0].SkuID

	// Seed 10 units in Location A; defaultLoc remains uninitialized (0 units)
	store.SetLocationBalance(testWorkspaceID1, multiSkuID, locA, 10, 0)

	// Adjust stock by +5 via UpdateStock (which applies to defaultLoc)
	// Previously (Data F2 bug): defaultLoc was initialized from aggregate SKU stock (10 + 5 = 15) and summed with locA (10 + 15 = 25)!
	updResp, err := h.UpdateStock(ctxOwner, connect.NewRequest(&commercev1.UpdateStockRequest{
		Context:       testCmdCtx("", "idem-f2-multiloc-plus5"),
		SkuId:         multiSkuID,
		DeltaQuantity: 5,
		Reason:        "receive_at_default_loc",
	}))
	if err != nil {
		t.Fatalf("UpdateStock(+5) failed: %v", err)
	}
	if updResp.Msg.NewStockQuantity != 15 {
		t.Fatalf("Data F2 regression: expected total stock 15 (10 at locA + 5 at defaultLoc), got %d", updResp.Msg.NewStockQuantity)
	}
	if gotLocA, _ := store.GetLocationBalance(testWorkspaceID1, multiSkuID, locA); gotLocA != 10 {
		t.Fatalf("expected locA balance to remain 10, got %d", gotLocA)
	}
	if gotDef, _ := store.GetLocationBalance(testWorkspaceID1, multiSkuID, defaultLoc); gotDef != 5 {
		t.Fatalf("expected defaultLoc balance to be 5, got %d", gotDef)
	}

	// Subtracting 6 from defaultLoc (which only has 5) must fail with ErrInsufficientStock (CodeFailedPrecondition)
	_, err = h.UpdateStock(ctxOwner, connect.NewRequest(&commercev1.UpdateStockRequest{
		Context:       testCmdCtx("", "idem-f2-multiloc-minus6"),
		SkuId:         multiSkuID,
		DeltaQuantity: -6,
		Reason:        "overdraw_default_loc",
	}))
	if connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected CodeFailedPrecondition when deducting 6 from defaultLoc (balance=5), got %v", err)
	}
}

func TestSecondPass_DataF6_ProportionalPartialRefundAllocation(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	fixedNow := time.Date(2026, 11, 7, 12, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return fixedNow })
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	pA, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f6-pa"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Product A (100 USD)",
		BasePrice:   &commonv1.Money{Amount: "100.000000", Currency: "USD"},
		Cogs:        &commonv1.Money{Amount: "40.000000", Currency: "USD"},
		Currency:    "USD",
	}))
	if err != nil {
		t.Fatalf("create Product A failed: %v", err)
	}
	pB, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f6-pb"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Product B (300 USD)",
		BasePrice:   &commonv1.Money{Amount: "300.000000", Currency: "USD"},
		Cogs:        &commonv1.Money{Amount: "100.000000", Currency: "USD"},
		Currency:    "USD",
	}))
	if err != nil {
		t.Fatalf("create Product B failed: %v", err)
	}

	dec100, _ := tenantdb.ParseExactDecimal("100.000000")
	dec300, _ := tenantdb.ParseExactDecimal("300.000000")
	dec400, _ := tenantdb.ParseExactDecimal("400.000000")
	dec40, _ := tenantdb.ParseExactDecimal("40.000000")
	dec20, _ := tenantdb.ParseExactDecimal("20.000000")
	dec60, _ := tenantdb.ParseExactDecimal("60.000000")

	orderID := "00000000-0000-4000-8000-000000f60001"
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        orderID,
		WorkspaceID:    testWorkspaceID1,
		Amount:         dec400,
		Currency:       "USD",
		LifecycleState: "partially_refunded",
		OrderedAt:      fixedNow.Add(-2 * time.Hour),
		Items: []product.AnalyticsOrderLine{
			{
				ProductID: pA.Msg.Product.ProductId,
				Quantity:  1,
				UnitPrice: &dec100,
				Total:     &dec100,
				UnitCOGS:  &dec40,
			},
			{
				ProductID: pB.Msg.Product.ProductId,
				Quantity:  1,
				UnitPrice: &dec300,
				Total:     &dec300,
				UnitCOGS:  &dec100,
			},
		},
	})
	// Two partial refunds totaling 80 USD (20% of the 400 USD order)
	store.SeedRefund(product.AnalyticsRefund{
		RefundID:       "ref-f6-1",
		WorkspaceID:    testWorkspaceID1,
		OrderID:        orderID,
		Amount:         dec20,
		Currency:       "USD",
		LifecycleState: "succeeded",
		CreatedAt:      fixedNow.Add(-time.Hour),
	})
	store.SeedRefund(product.AnalyticsRefund{
		RefundID:       "ref-f6-2",
		WorkspaceID:    testWorkspaceID1,
		OrderID:        orderID,
		Amount:         dec60,
		Currency:       "USD",
		LifecycleState: "completed",
		CreatedAt:      fixedNow.Add(-30 * time.Minute),
	})

	statsA, err := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{
		ProductId: pA.Msg.Product.ProductId,
	}))
	if err != nil {
		t.Fatalf("GetSalesStats Product A failed: %v", err)
	}
	statsB, err := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{
		ProductId: pB.Msg.Product.ProductId,
	}))
	if err != nil {
		t.Fatalf("GetSalesStats Product B failed: %v", err)
	}

	// Product A (25% of order) gets 20 USD of the 80 USD refund -> NetSales = 80 USD
	if statsA.Msg.GrossSales.Amount != "100" || statsA.Msg.NetSales.Amount != "80" || statsA.Msg.RefundCount != 2 {
		t.Fatalf("unexpected Product A sales stats: gross=%s net=%s refunds=%d",
			statsA.Msg.GrossSales.Amount, statsA.Msg.NetSales.Amount, statsA.Msg.RefundCount)
	}
	// Product B (75% of order) gets 60 USD of the 80 USD refund -> NetSales = 240 USD
	if statsB.Msg.GrossSales.Amount != "300" || statsB.Msg.NetSales.Amount != "240" || statsB.Msg.RefundCount != 2 {
		t.Fatalf("unexpected Product B sales stats: gross=%s net=%s refunds=%d",
			statsB.Msg.GrossSales.Amount, statsB.Msg.NetSales.Amount, statsB.Msg.RefundCount)
	}
}

func TestSecondPass_DataF7_MultiCurrencyAnalyticsConversionAndFailClosed(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	fixedNow := time.Date(2026, 11, 7, 12, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return fixedNow })
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	pVND, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f7-pvnd"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "VND Catalog Product",
		BasePrice:   &commonv1.Money{Amount: "250000.000000", Currency: "VND"},
		Cogs:        &commonv1.Money{Amount: "100000.000000", Currency: "VND"},
		Currency:    "VND",
	}))
	if err != nil {
		t.Fatalf("create pVND failed: %v", err)
	}

	dec250k, _ := tenantdb.ParseExactDecimal("250000.000000")
	dec100k, _ := tenantdb.ParseExactDecimal("100000.000000")
	dec10, _ := tenantdb.ParseExactDecimal("10.000000")
	dec4, _ := tenantdb.ParseExactDecimal("4.000000")

	// Seed 1 VND order and 1 USD order WITHOUT exchange_rate_snapshot
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        "ord-f7-vnd",
		WorkspaceID:    testWorkspaceID1,
		Amount:         dec250k,
		Currency:       "VND",
		LifecycleState: "completed",
		OrderedAt:      fixedNow.Add(-2 * time.Hour),
		Items: []product.AnalyticsOrderLine{
			{
				ProductID: pVND.Msg.Product.ProductId,
				Quantity:  1,
				UnitPrice: &dec250k,
				Total:     &dec250k,
				UnitCOGS:  &dec100k,
			},
		},
	})
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        "ord-f7-usd",
		WorkspaceID:    testWorkspaceID1,
		Amount:         dec10,
		Currency:       "USD",
		LifecycleState: "completed",
		OrderedAt:      fixedNow.Add(-time.Hour),
		Items: []product.AnalyticsOrderLine{
			{
				ProductID: pVND.Msg.Product.ProductId,
				Quantity:  1,
				UnitPrice: &dec10,
				Total:     &dec10,
				UnitCOGS:  &dec4,
			},
		},
	})

	// 1. Without exchange_rate_snapshot, GetSalesStats, GetSalesChart, and GetRank MUST fail closed with CodeFailedPrecondition
	if _, err := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{ProductId: pVND.Msg.Product.ProductId})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected CodeFailedPrecondition on unconvertible multi-currency GetSalesStats, got %v", err)
	}
	if _, err := h.GetSalesChart(ctxOwner, connect.NewRequest(&commercev1.GetSalesChartRequest{ProductId: pVND.Msg.Product.ProductId})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected CodeFailedPrecondition on unconvertible multi-currency GetSalesChart, got %v", err)
	}
	if _, err := h.GetRank(ctxOwner, connect.NewRequest(&commercev1.GetRankRequest{ProductId: pVND.Msg.Product.ProductId})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected CodeFailedPrecondition on unconvertible multi-currency GetRank, got %v", err)
	}

	// 2. Now attach valid exchange_rate_snapshot (1 USD = 25000 VND) to the USD order
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        "ord-f7-usd",
		WorkspaceID:    testWorkspaceID1,
		Amount:         dec10,
		Currency:       "USD",
		LifecycleState: "completed",
		OrderedAt:      fixedNow.Add(-time.Hour),
		ExchangeRateSnapshot: &product.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "USD",
			RateToBase:    "25000.000000",
		},
		Items: []product.AnalyticsOrderLine{
			{
				ProductID: pVND.Msg.Product.ProductId,
				Quantity:  1,
				UnitPrice: &dec10,
				Total:     &dec10,
				UnitCOGS:  &dec4,
			},
		},
	})

	statsResp, err := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{ProductId: pVND.Msg.Product.ProductId}))
	if err != nil {
		t.Fatalf("GetSalesStats with exchange_rate_snapshot failed: %v", err)
	}
	// 250,000 VND + (10 USD * 25,000) = 500,000 VND
	if statsResp.Msg.GrossSales.Amount != "500000" || statsResp.Msg.GrossSales.Currency != "VND" {
		t.Fatalf("expected converted GrossSales=500000 VND, got %s %s", statsResp.Msg.GrossSales.Amount, statsResp.Msg.GrossSales.Currency)
	}
	chartResp, err := h.GetSalesChart(ctxOwner, connect.NewRequest(&commercev1.GetSalesChartRequest{ProductId: pVND.Msg.Product.ProductId}))
	if err != nil || len(chartResp.Msg.DataPoints) != 1 || chartResp.Msg.DataPoints[0].Amount.Amount != "500000" {
		t.Fatalf("unexpected converted chart response: %+v (err=%v)", chartResp, err)
	}
}

func TestSecondPass_DataF8_GetSalesStatsHonorsPeriodFilter(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	fixedNow := time.Date(2026, 11, 7, 12, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return fixedNow })
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	p, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f8-prod"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Period Filtered Product",
		BasePrice:   &commonv1.Money{Amount: "100.000000", Currency: "USD"},
		Currency:    "USD",
	}))
	if err != nil {
		t.Fatalf("create product failed: %v", err)
	}
	pid := p.Msg.Product.ProductId

	dec100, _ := tenantdb.ParseExactDecimal("100.000000")
	dec200, _ := tenantdb.ParseExactDecimal("200.000000")
	dec400, _ := tenantdb.ParseExactDecimal("400.000000")
	dec10, _ := tenantdb.ParseExactDecimal("10.000000")

	// Order 1: 3 days ago (100 USD, 1 unit) + 10 USD partial refund 2 days ago
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        "ord-f8-3d",
		WorkspaceID:    testWorkspaceID1,
		Amount:         dec100,
		Currency:       "USD",
		LifecycleState: "partially_refunded",
		OrderedAt:      fixedNow.Add(-3 * 24 * time.Hour),
		Items: []product.AnalyticsOrderLine{
			{ProductID: pid, Quantity: 1, UnitPrice: &dec100, Total: &dec100},
		},
	})
	store.SeedRefund(product.AnalyticsRefund{
		RefundID:       "ref-f8-2d",
		WorkspaceID:    testWorkspaceID1,
		OrderID:        "ord-f8-3d",
		Amount:         dec10,
		Currency:       "USD",
		LifecycleState: "succeeded",
		CreatedAt:      fixedNow.Add(-2 * 24 * time.Hour),
	})

	// Order 2: 20 days ago (200 USD, 2 units)
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        "ord-f8-20d",
		WorkspaceID:    testWorkspaceID1,
		Amount:         dec200,
		Currency:       "USD",
		LifecycleState: "completed",
		OrderedAt:      fixedNow.Add(-20 * 24 * time.Hour),
		Items: []product.AnalyticsOrderLine{
			{ProductID: pid, Quantity: 2, UnitPrice: &dec100, Total: &dec200},
		},
	})

	// Order 3: 45 days ago (400 USD, 4 units)
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        "ord-f8-45d",
		WorkspaceID:    testWorkspaceID1,
		Amount:         dec400,
		Currency:       "USD",
		LifecycleState: "completed",
		OrderedAt:      fixedNow.Add(-45 * 24 * time.Hour),
		Items: []product.AnalyticsOrderLine{
			{ProductID: pid, Quantity: 4, UnitPrice: &dec100, Total: &dec400},
		},
	})

	// 7d period -> only Order 1
	s7d, err := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{
		ProductId: pid,
		Period:    "7d",
	}))
	if err != nil {
		t.Fatalf("GetSalesStats 7d failed: %v", err)
	}
	if s7d.Msg.UnitsSold != 1 || s7d.Msg.GrossSales.Amount != "100" || s7d.Msg.NetSales.Amount != "90" || s7d.Msg.RefundCount != 1 {
		t.Fatalf("unexpected 7d stats: units=%d gross=%s net=%s refunds=%d",
			s7d.Msg.UnitsSold, s7d.Msg.GrossSales.Amount, s7d.Msg.NetSales.Amount, s7d.Msg.RefundCount)
	}

	// 30d period -> Order 1 + Order 2
	s30d, err := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{
		ProductId: pid,
		Period:    "30d",
	}))
	if err != nil {
		t.Fatalf("GetSalesStats 30d failed: %v", err)
	}
	if s30d.Msg.UnitsSold != 3 || s30d.Msg.GrossSales.Amount != "300" || s30d.Msg.NetSales.Amount != "290" || s30d.Msg.RefundCount != 1 {
		t.Fatalf("unexpected 30d stats: units=%d gross=%s net=%s refunds=%d",
			s30d.Msg.UnitsSold, s30d.Msg.GrossSales.Amount, s30d.Msg.NetSales.Amount, s30d.Msg.RefundCount)
	}

	// 90d period -> Order 1 + Order 2 + Order 3
	s90d, err := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{
		ProductId: pid,
		Period:    "90d",
	}))
	if err != nil {
		t.Fatalf("GetSalesStats 90d failed: %v", err)
	}
	if s90d.Msg.UnitsSold != 7 || s90d.Msg.GrossSales.Amount != "700" || s90d.Msg.NetSales.Amount != "690" || s90d.Msg.RefundCount != 1 {
		t.Fatalf("unexpected 90d stats: units=%d gross=%s net=%s refunds=%d",
			s90d.Msg.UnitsSold, s90d.Msg.GrossSales.Amount, s90d.Msg.NetSales.Amount, s90d.Msg.RefundCount)
	}

	// Invalid period -> CodeInvalidArgument
	if _, err := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{
		ProductId: pid,
		Period:    "invalid_window",
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument for invalid period, got %v", err)
	}
}

func TestSecondPass_DataF10_ArchiveAndDeleteAtomicCASInsideTransaction(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	currentTime := time.Date(2026, 11, 7, 14, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return currentTime })
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	created, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f10-create"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "CAS Protected Product",
		BasePrice:   &commonv1.Money{Amount: "50.000000", Currency: "USD"},
		Currency:    "USD",
	}))
	if err != nil {
		t.Fatalf("Create failed: %v", err)
	}
	pid := created.Msg.Product.ProductId
	t0 := created.Msg.Product.UpdatedAt.AsTime()

	// Concurrent update advances UpdatedAt to t1
	currentTime = currentTime.Add(time.Minute)
	newTitle := "CAS Updated Title"
	if _, err := h.Update(ctxOwner, connect.NewRequest(&commercev1.UpdateRequest{
		Context:   testCmdCtx("", "idem-f10-update"),
		ProductId: pid,
		Title:     &newTitle,
	})); err != nil {
		t.Fatalf("Update failed: %v", err)
	}
	eventsBeforeStale := len(sink.Events())

	// 1. Stale Archive via Handler -> fails with CodeFailedPrecondition and emits NO event
	staleArchiveCtx := testCmdCtx("", "idem-f10-stale-archive")
	staleArchiveCtx.ExpectedUpdatedAt = timestamppb.New(t0)
	if _, err := h.Archive(ctxOwner, connect.NewRequest(&commercev1.ArchiveRequest{
		Context:   staleArchiveCtx,
		ProductId: pid,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected CodeFailedPrecondition on stale Archive, got %v", err)
	}
	if len(sink.Events()) != eventsBeforeStale {
		t.Fatalf("stale Archive emitted domain event! before=%d after=%d", eventsBeforeStale, len(sink.Events()))
	}

	// 2. Stale Delete via Handler -> fails with CodeFailedPrecondition
	staleDeleteCtx := testCmdCtx("", "idem-f10-stale-delete")
	staleDeleteCtx.ExpectedUpdatedAt = timestamppb.New(t0)
	if _, err := h.Delete(ctxOwner, connect.NewRequest(&commercev1.DeleteRequest{
		Context:   staleDeleteCtx,
		ProductId: pid,
	})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("expected CodeFailedPrecondition on stale Delete, got %v", err)
	}

	// 3. Direct store-level CAS check (proving CAS is enforced inside Store.ArchiveProduct and Store.DeleteProduct)
	storeStaleCtx := product.WithExpectedUpdatedAt(baseCtx, &t0)
	if err := store.ArchiveProduct(storeStaleCtx, testWorkspaceID1, pid); !errors.Is(err, product.ErrConcurrencyConflict) {
		t.Fatalf("expected ErrConcurrencyConflict from Store.ArchiveProduct with stale ExpectedUpdatedAt, got %v", err)
	}
	if err := store.DeleteProduct(storeStaleCtx, testWorkspaceID1, pid); !errors.Is(err, product.ErrConcurrencyConflict) {
		t.Fatalf("expected ErrConcurrencyConflict from Store.DeleteProduct with stale ExpectedUpdatedAt, got %v", err)
	}
}

func TestSecondPass_DataF11_UpdateHonorsInventoryEnabledAndClearFields(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	svc := product.NewService(store, sink, nil)
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	created, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:          testCmdCtx("", "idem-f11-create"),
		ProductType:      commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:            "Full Featured Product",
		Description:      "Non-empty description",
		Category:         "Electronics",
		BasePrice:        &commonv1.Money{Amount: "199.000000", Currency: "USD"},
		Currency:         "USD",
		InventoryEnabled: true,
		MetadataJson:     `{"badge":"featured"}`,
	}))
	if err != nil {
		t.Fatalf("Create failed: %v", err)
	}
	pid := created.Msg.Product.ProductId
	if !created.Msg.Product.InventoryEnabled {
		t.Fatal("expected initial InventoryEnabled=true")
	}

	// Update: disable inventory_enabled=false and clear description="", category="", metadata_json="{}"
	emptyStr := ""
	emptyMeta := "{}"
	invFalse := false
	updResp, err := h.Update(ctxOwner, connect.NewRequest(&commercev1.UpdateRequest{
		Context:          testCmdCtx("", "idem-f11-update-clear"),
		ProductId:        pid,
		Description:      &emptyStr,
		Category:         &emptyStr,
		InventoryEnabled: &invFalse,
		MetadataJson:     &emptyMeta,
	}))
	if err != nil {
		t.Fatalf("Update failed: %v", err)
	}
	if updResp.Msg.Product.InventoryEnabled {
		t.Fatal("Data F11 regression: expected InventoryEnabled=false after Update, got true")
	}
	if updResp.Msg.Product.Description != "" {
		t.Fatalf("Data F11 regression: expected cleared Description=\"\", got %q", updResp.Msg.Product.Description)
	}
	if updResp.Msg.Product.Category != "" {
		t.Fatalf("Data F11 regression: expected cleared Category=\"\", got %q", updResp.Msg.Product.Category)
	}
	if updResp.Msg.Product.MetadataJson != "{}" {
		t.Fatalf("Data F11 regression: expected cleared MetadataJson=\"{}\", got %q", updResp.Msg.Product.MetadataJson)
	}

	// Verify idempotency hash includes inventory_enabled: replaying same key with inventory_enabled=true must conflict!
	invTrue := true
	_, err = h.Update(ctxOwner, connect.NewRequest(&commercev1.UpdateRequest{
		Context:          testCmdCtx("", "idem-f11-update-clear"),
		ProductId:        pid,
		Description:      &emptyStr,
		Category:         &emptyStr,
		InventoryEnabled: &invTrue,
		MetadataJson:     &emptyMeta,
	}))
	if connect.CodeOf(err) != connect.CodeAlreadyExists {
		t.Fatalf("expected CodeAlreadyExists when replaying Update idempotency_key with different inventory_enabled, got %v", err)
	}
}

func TestSecondPass_DataF13_PriceAndCogsCurrencyValidationAndMismatchRejected(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	svc := product.NewService(store, sink, nil)
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	// 1. Create with mismatched Product.Currency ("VND") vs BasePrice.Currency ("USD") -> CodeInvalidArgument
	if _, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f13-create-mismatch-base"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Mismatched BasePrice Currency",
		BasePrice:   &commonv1.Money{Amount: "100.000000", Currency: "USD"},
		Currency:    "VND",
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("F13 regression: expected CodeInvalidArgument when Create Currency=VND but BasePrice.Currency=USD, got %v", err)
	}

	// 2. Create with mismatched Cogs.Currency ("EUR") -> CodeInvalidArgument
	if _, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f13-create-mismatch-cogs"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Mismatched COGS Currency",
		BasePrice:   &commonv1.Money{Amount: "100000.000000", Currency: "VND"},
		Cogs:        &commonv1.Money{Amount: "40.000000", Currency: "EUR"},
		Currency:    "VND",
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("F13 regression: expected CodeInvalidArgument when Create Currency=VND but Cogs.Currency=EUR, got %v", err)
	}

	// 3. Create with invalid SKU PriceOverride (bad decimal or mismatched currency) -> CodeInvalidArgument
	if _, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f13-create-bad-sku-price"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Invalid SKU Override",
		BasePrice:   &commonv1.Money{Amount: "100000.000000", Currency: "VND"},
		Currency:    "VND",
		InitialSkus: []*commercev1.ProductSku{
			{
				SkuCode:       "SKU-BAD-CURR",
				PriceOverride: &commonv1.Money{Amount: "10.000000", Currency: "USD"},
			},
		},
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("F13 regression: expected CodeInvalidArgument for SKU PriceOverride currency mismatch, got %v", err)
	}

	if _, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f13-create-bad-sku-dec"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Malformed SKU Override Decimal",
		BasePrice:   &commonv1.Money{Amount: "100000.000000", Currency: "VND"},
		Currency:    "VND",
		InitialSkus: []*commercev1.ProductSku{
			{
				SkuCode:       "SKU-BAD-DEC",
				PriceOverride: &commonv1.Money{Amount: "not-a-number", Currency: "VND"},
			},
		},
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("F13 regression: expected CodeInvalidArgument for malformed SKU PriceOverride amount, got %v", err)
	}

	// 4. Create valid VND product
	created, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f13-create-valid"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Valid VND Product",
		BasePrice:   &commonv1.Money{Amount: "100000.000000", Currency: "VND"},
		Cogs:        &commonv1.Money{Amount: "40000.000000", Currency: "VND"},
		Currency:    "VND",
	}))
	if err != nil {
		t.Fatalf("Create valid product failed: %v", err)
	}
	pid := created.Msg.Product.ProductId

	// 5. Update BasePrice with USD on a VND product -> must fail with CodeInvalidArgument and NOT overwrite price!
	if _, err := h.Update(ctxOwner, connect.NewRequest(&commercev1.UpdateRequest{
		Context:   testCmdCtx("", "idem-f13-update-usd-base"),
		ProductId: pid,
		BasePrice: &commonv1.Money{Amount: "10.000000", Currency: "USD"},
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("F13 regression: expected CodeInvalidArgument when updating VND product with USD BasePrice, got %v", err)
	}

	// 6. Update Cogs with USD on a VND product -> must fail with CodeInvalidArgument!
	if _, err := h.Update(ctxOwner, connect.NewRequest(&commercev1.UpdateRequest{
		Context:   testCmdCtx("", "idem-f13-update-usd-cogs"),
		ProductId: pid,
		Cogs:      &commonv1.Money{Amount: "5.000000", Currency: "USD"},
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("F13 regression: expected CodeInvalidArgument when updating VND product with USD Cogs, got %v", err)
	}

	// 7. Update BasePrice with empty Currency -> must fail with CodeInvalidArgument!
	if _, err := h.Update(ctxOwner, connect.NewRequest(&commercev1.UpdateRequest{
		Context:   testCmdCtx("", "idem-f13-update-empty-curr"),
		ProductId: pid,
		BasePrice: &commonv1.Money{Amount: "120000.000000", Currency: ""},
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("F13 regression: expected CodeInvalidArgument when updating BasePrice with empty currency, got %v", err)
	}

	// Verify stored product still has original 100000 VND BasePrice and 40000 VND Cogs
	fetched, err := h.Get(ctxOwner, connect.NewRequest(&commercev1.GetRequest{ProductId: pid}))
	if err != nil {
		t.Fatalf("Get failed: %v", err)
	}
	if fetched.Msg.Product.BasePrice.Amount != "100000" || fetched.Msg.Product.BasePrice.Currency != "VND" {
		t.Fatalf("F13 regression: stored BasePrice corrupted to %+v", fetched.Msg.Product.BasePrice)
	}
	if fetched.Msg.Product.Cogs.Amount != "40000" || fetched.Msg.Product.Cogs.Currency != "VND" {
		t.Fatalf("F13 regression: stored Cogs corrupted to %+v", fetched.Msg.Product.Cogs)
	}
}

func TestSecondPass_DataF15_LongSearchAndCategoryFilterCursorRoundTripWithin512Limit(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	currentTime := time.Date(2026, 11, 7, 15, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return currentTime })
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	longCategory := "Danh-Mục-Sản-Phẩm-Cao-Cấp-" + strings.Repeat("ChínhHãng", 20)
	longSearch := "Kem dưỡng ẩm chuyên sâu phục hồi da ban đêm " + strings.Repeat("UltraRepair", 16)

	for i := 1; i <= 2; i++ {
		currentTime = currentTime.Add(time.Second)
		if _, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
			Context:     testCmdCtx("", fmt.Sprintf("idem-f15-create-%d", i)),
			ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
			Title:       fmt.Sprintf("%s #%d", longSearch, i),
			Category:    longCategory,
			BasePrice:   &commonv1.Money{Amount: "150000.000000", Currency: "VND"},
			Currency:    "VND",
		})); err != nil {
			t.Fatalf("Create %d failed: %v", i, err)
		}
	}

	// 1. List page 1 with long CategoryFilter and SearchQuery
	listP1, err := h.List(ctxOwner, connect.NewRequest(&commercev1.ListRequest{
		Pagination:     &commonv1.Pagination{PageSize: 1},
		CategoryFilter: longCategory,
		SearchQuery:    longSearch,
	}))
	if err != nil {
		t.Fatalf("List page 1 failed: %v", err)
	}
	if !listP1.Msg.Pagination.GetHasMore() {
		t.Fatal("expected has_more=true on List page 1")
	}
	listToken := listP1.Msg.Pagination.GetNextPageToken()
	if len(listToken) > 512 {
		t.Fatalf("F15 regression: server emitted List next_page_token of length %d (> 512 limit)", len(listToken))
	}

	// List page 2 must decode token cleanly and return second product
	listP2, err := h.List(ctxOwner, connect.NewRequest(&commercev1.ListRequest{
		Pagination:     &commonv1.Pagination{PageSize: 1, PageToken: listToken},
		CategoryFilter: longCategory,
		SearchQuery:    longSearch,
	}))
	if err != nil {
		t.Fatalf("F15 regression: List page 2 rejected server-emitted token (len=%d): %v", len(listToken), err)
	}
	if len(listP2.Msg.Products) != 1 || listP2.Msg.Products[0].ProductId == listP1.Msg.Products[0].ProductId {
		t.Fatalf("unexpected List page 2 products: %+v", listP2.Msg.Products)
	}

	// Changing SearchQuery by 1 char with same token must fail closed with CodeInvalidArgument
	if _, err := h.List(ctxOwner, connect.NewRequest(&commercev1.ListRequest{
		Pagination:     &commonv1.Pagination{PageSize: 1, PageToken: listToken},
		CategoryFilter: longCategory,
		SearchQuery:    longSearch + "X",
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("expected CodeInvalidArgument when reusing List cursor with modified SearchQuery, got %v", err)
	}

	// 2. Search page 1 & page 2 with long Query
	searchP1, err := h.Search(ctxOwner, connect.NewRequest(&commercev1.SearchRequest{
		Query:      longSearch,
		Pagination: &commonv1.Pagination{PageSize: 1},
	}))
	if err != nil {
		t.Fatalf("Search page 1 failed: %v", err)
	}
	searchToken := searchP1.Msg.Pagination.GetNextPageToken()
	if len(searchToken) > 512 {
		t.Fatalf("F15 regression: server emitted Search next_page_token of length %d (> 512 limit)", len(searchToken))
	}
	searchP2, err := h.Search(ctxOwner, connect.NewRequest(&commercev1.SearchRequest{
		Query:      longSearch,
		Pagination: &commonv1.Pagination{PageSize: 1, PageToken: searchToken},
	}))
	if err != nil {
		t.Fatalf("F15 regression: Search page 2 rejected server-emitted token (len=%d): %v", len(searchToken), err)
	}
	if len(searchP2.Msg.Products) != 1 {
		t.Fatalf("expected 1 product on Search page 2, got %d", len(searchP2.Msg.Products))
	}
}

func TestSecondPass_DataF1_F6_F7_F8_F11_EdgeCaseRegressions(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	// Use a simulated clock in 2020 (well in the past relative to wall clock) to verify F1 clock consistency
	simNow := time.Date(2020, 5, 10, 12, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return simNow })
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	// --- F1: Idempotency record must respect Service clock, not wall-clock time.Now() ---
	p1Resp, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f1-simclock-p1"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Product A",
		Category:    "Skincare",
		BasePrice:   &commonv1.Money{Amount: "100.000000", Currency: "USD"},
		Currency:    "USD",
	}))
	if err != nil {
		t.Fatalf("Create p1 failed: %v", err)
	}
	simNow = simNow.Add(5 * time.Minute)
	p1Replay, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f1-simclock-p1"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Product A",
		Category:    "Skincare",
		BasePrice:   &commonv1.Money{Amount: "100.000000", Currency: "USD"},
		Currency:    "USD",
	}))
	if err != nil {
		t.Fatalf("Replay p1 failed: %v", err)
	}
	if p1Replay.Msg.Product.ProductId != p1Resp.Msg.Product.ProductId {
		t.Fatalf("F1 clock regression: idempotency replay created duplicate product %s != %s",
			p1Replay.Msg.Product.ProductId, p1Resp.Msg.Product.ProductId)
	}

	p2Resp, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f1-simclock-p2"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Product B",
		Category:    "Skincare",
		BasePrice:   &commonv1.Money{Amount: "100.000000", Currency: "USD"},
		Currency:    "USD",
	}))
	if err != nil {
		t.Fatalf("Create p2 failed: %v", err)
	}
	p3Resp, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f1-simclock-p3"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "Product C",
		Category:    "Skincare",
		BasePrice:   &commonv1.Money{Amount: "100.000000", Currency: "USD"},
		Currency:    "USD",
	}))
	if err != nil {
		t.Fatalf("Create p3 failed: %v", err)
	}

	p1ID := p1Resp.Msg.Product.ProductId
	p2ID := p2Resp.Msg.Product.ProductId
	p3ID := p3Resp.Msg.Product.ProductId

	dec20, _ := tenantdb.ParseExactDecimal("20.000000")
	dec100, _ := tenantdb.ParseExactDecimal("100.000000")
	dec140, _ := tenantdb.ParseExactDecimal("140.000000")
	dec250, _ := tenantdb.ParseExactDecimal("250.000000")
	dec300, _ := tenantdb.ParseExactDecimal("300.000000")

	// --- F6: Multi-product order where Order.Amount (250) > sum of line gross (200) + 3-way remainder ---
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        "ord-f6-shipping",
		WorkspaceID:    testWorkspaceID1,
		LifecycleState: "delivered",
		Currency:       "USD",
		Amount:         dec250, // includes 50 shipping
		OrderedAt:      simNow.Add(-24 * time.Hour),
		Items: []product.AnalyticsOrderLine{
			{ProductID: p1ID, Quantity: 1, UnitPrice: &dec100, Total: &dec100},
			{ProductID: p2ID, Quantity: 1, UnitPrice: &dec100, Total: &dec100},
		},
	})
	store.SeedRefund(product.AnalyticsRefund{
		RefundID:       "ref-f6-shipping-20",
		WorkspaceID:    testWorkspaceID1,
		OrderID:        "ord-f6-shipping",
		LifecycleState: "completed",
		Currency:       "USD",
		Amount:         dec20,
		CreatedAt:      simNow.Add(-12 * time.Hour),
	})

	s1, err := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{ProductId: p1ID}))
	if err != nil {
		t.Fatalf("GetSalesStats p1 failed: %v", err)
	}
	s2, err := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{ProductId: p2ID}))
	if err != nil {
		t.Fatalf("GetSalesStats p2 failed: %v", err)
	}
	if s1.Msg.NetSales.Amount != "90" || s2.Msg.NetSales.Amount != "90" {
		t.Fatalf("F6 shipping denominator regression: expected NetSales 90 + 90 = 180, got p1=%s p2=%s",
			s1.Msg.NetSales.Amount, s2.Msg.NetSales.Amount)
	}

	// 3-way split of 100.000000 refund across 3 products of 100.000000 each -> sum of NetSales must be 200.000000
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        "ord-f6-threeway",
		WorkspaceID:    testWorkspaceID1,
		LifecycleState: "delivered",
		Currency:       "USD",
		Amount:         dec300,
		OrderedAt:      simNow.Add(-20 * time.Hour),
		Items: []product.AnalyticsOrderLine{
			{ProductID: p1ID, Quantity: 1, UnitPrice: &dec100, Total: &dec100},
			{ProductID: p2ID, Quantity: 1, UnitPrice: &dec100, Total: &dec100},
			{ProductID: p3ID, Quantity: 1, UnitPrice: &dec100, Total: &dec100},
		},
	})
	store.SeedRefund(product.AnalyticsRefund{
		RefundID:       "ref-f6-threeway-100",
		WorkspaceID:    testWorkspaceID1,
		OrderID:        "ord-f6-threeway",
		LifecycleState: "completed",
		Currency:       "USD",
		Amount:         dec100,
		CreatedAt:      simNow.Add(-10 * time.Hour),
	})

	s1After, _ := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{ProductId: p1ID}))
	s2After, _ := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{ProductId: p2ID}))
	s3After, _ := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{ProductId: p3ID}))
	// Total NetSales across p1, p2, p3 should be 180 (from ord 1) + 200 (from ord 2) = 380.000000
	net1, _ := tenantdb.ParseExactDecimal(s1After.Msg.NetSales.Amount)
	net2, _ := tenantdb.ParseExactDecimal(s2After.Msg.NetSales.Amount)
	net3, _ := tenantdb.ParseExactDecimal(s3After.Msg.NetSales.Amount)
	sum12, _ := net1.Add(net2)
	totalNet, _ := sum12.Add(net3)
	if totalNet.String() != "380" {
		t.Fatalf("F6 3-way remainder regression: expected total NetSales across products = 380, got %s (%s + %s + %s)",
			totalNet.String(), net1.String(), net2.String(), net3.String())
	}

	// --- F8: Zero OrderedAt and future OrderedAt must be excluded from period stats and chart ---
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        "ord-f8-zero-time",
		WorkspaceID:    testWorkspaceID1,
		LifecycleState: "delivered",
		Currency:       "USD",
		Amount:         dec100,
		OrderedAt:      time.Time{}, // zero timestamp!
		Items: []product.AnalyticsOrderLine{
			{ProductID: p3ID, Quantity: 5, UnitPrice: &dec20, Total: &dec100},
		},
	})
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        "ord-f8-future-time",
		WorkspaceID:    testWorkspaceID1,
		LifecycleState: "delivered",
		Currency:       "USD",
		Amount:         dec140,
		OrderedAt:      simNow.Add(48 * time.Hour), // future timestamp!
		Items: []product.AnalyticsOrderLine{
			{ProductID: p3ID, Quantity: 7, UnitPrice: &dec20, Total: &dec140},
		},
	})

	s3Period7d, err := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{
		ProductId: p3ID,
		Period:    "7d",
	}))
	if err != nil {
		t.Fatalf("GetSalesStats p3 7d failed: %v", err)
	}
	if s3Period7d.Msg.UnitsSold != 1 {
		t.Fatalf("F8 regression: zero/future timestamp order leaked into 7d period stats: units=%d (want 1)", s3Period7d.Msg.UnitsSold)
	}

	chartP3, err := h.GetSalesChart(ctxOwner, connect.NewRequest(&commercev1.GetSalesChartRequest{
		ProductId: p3ID,
		Interval:  "7d",
	}))
	if err != nil {
		t.Fatalf("GetSalesChart p3 7d failed: %v", err)
	}
	if len(chartP3.Msg.DataPoints) != 1 || chartP3.Msg.DataPoints[0].Amount.Amount != "100" {
		t.Fatalf("F8 regression: zero/future timestamp order leaked into 7d sales chart: points=%+v (want 1 point of 100)", chartP3.Msg.DataPoints)
	}

	// Invalid chart interval -> CodeInvalidArgument
	if _, err := h.GetSalesChart(ctxOwner, connect.NewRequest(&commercev1.GetSalesChartRequest{
		ProductId: p3ID,
		Interval:  "invalid_interval",
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("F8 regression: expected CodeInvalidArgument for invalid chart interval, got %v", err)
	}

	// --- F11: Malformed metadata_json and invalid CatalogStatus in Update must fail closed ---
	badMeta := "{malformed-json"
	if _, err := h.Update(ctxOwner, connect.NewRequest(&commercev1.UpdateRequest{
		Context:      testCmdCtx("", "idem-f11-bad-meta"),
		ProductId:    p1ID,
		MetadataJson: &badMeta,
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("F11 regression: expected CodeInvalidArgument for malformed metadata_json in Update, got %v", err)
	}

	unspecStatus := commercev1.CatalogStatus_CATALOG_STATUS_UNSPECIFIED
	if _, err := h.Update(ctxOwner, connect.NewRequest(&commercev1.UpdateRequest{
		Context:       testCmdCtx("", "idem-f11-unspec-status"),
		ProductId:     p1ID,
		CatalogStatus: &unspecStatus,
	})); connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("F11 regression: expected CodeInvalidArgument for explicit CATALOG_STATUS_UNSPECIFIED in Update, got %v", err)
	}
}

func TestSecondPass_DataF7_MixedCurrencyRankAndInvalidSameCurrencyFXRejected(t *testing.T) {
	baseCtx := context.Background()
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	now := time.Date(2026, 11, 7, 16, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return now })
	h := product.NewHandler(svc)

	ctxOwner := product.WithCaller(baseCtx, testWorkspaceID1, "user-owner-1", rbac.RoleOwner)

	p1, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f7-edge-p1"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "VND Product 1",
		Category:    "Audio",
		BasePrice:   &commonv1.Money{Amount: "500000.000000", Currency: "VND"},
		Currency:    "VND",
	}))
	if err != nil {
		t.Fatalf("Create p1 failed: %v", err)
	}
	p2, err := h.Create(ctxOwner, connect.NewRequest(&commercev1.CreateRequest{
		Context:     testCmdCtx("", "idem-f7-edge-p2"),
		ProductType: commercev1.ProductType_PRODUCT_TYPE_PHYSICAL,
		Title:       "VND Product 2",
		Category:    "Audio",
		BasePrice:   &commonv1.Money{Amount: "500000.000000", Currency: "VND"},
		Currency:    "VND",
	}))
	if err != nil {
		t.Fatalf("Create p2 failed: %v", err)
	}

	p1ID := p1.Msg.Product.ProductId
	p2ID := p2.Msg.Product.ProductId
	dec500k, _ := tenantdb.ParseExactDecimal("500000.000000")
	dec1M, _ := tenantdb.ParseExactDecimal("1000000.000000")

	// Order 1: Same-currency VND order for P1 (no FX snapshot)
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        "ord-f7-edge-vnd-native",
		WorkspaceID:    testWorkspaceID1,
		LifecycleState: "delivered",
		Currency:       "VND",
		Amount:         dec500k,
		OrderedAt:      now.Add(-2 * time.Hour),
		Items: []product.AnalyticsOrderLine{
			{ProductID: p1ID, Quantity: 1, UnitPrice: &dec500k, Total: &dec500k},
		},
	})
	// Order 2: VND order for P2 that happens to carry an FX snapshot with BaseCurrency="USD" (rate 0.000040)
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        "ord-f7-edge-vnd-with-usd-base-snap",
		WorkspaceID:    testWorkspaceID1,
		LifecycleState: "delivered",
		Currency:       "VND",
		Amount:         dec1M,
		OrderedAt:      now.Add(-1 * time.Hour),
		ExchangeRateSnapshot: &product.ExchangeRateSnapshot{
			BaseCurrency:  "USD",
			QuoteCurrency: "VND",
			RateToBase:    "0.000040",
		},
		Items: []product.AnalyticsOrderLine{
			{ProductID: p2ID, Quantity: 2, UnitPrice: &dec500k, Total: &dec1M},
		},
	})

	// GetRank for P1 (VND) must succeed because both Order 1 and Order 2 are in VND (target.Currency="VND")!
	rank1, err := h.GetRank(ctxOwner, connect.NewRequest(&commercev1.GetRankRequest{ProductId: p1ID}))
	if err != nil {
		t.Fatalf("F7 rank regression: GetRank failed when another VND order had BaseCurrency=USD snapshot: %v", err)
	}
	if rank1.Msg.RankInWorkspace != 2 {
		t.Fatalf("expected P1 rank=2 (500k vs 1M VND), got %d", rank1.Msg.RankInWorkspace)
	}

	// Same-currency order with corrupted ExchangeRateSnapshot (RateToBase="2.5" instead of "1") must fail closed!
	store.SeedOrder(product.AnalyticsOrder{
		OrderID:        "ord-f7-edge-corrupt-same-curr-fx",
		WorkspaceID:    testWorkspaceID1,
		LifecycleState: "delivered",
		Currency:       "VND",
		Amount:         dec500k,
		OrderedAt:      now.Add(-30 * time.Minute),
		ExchangeRateSnapshot: &product.ExchangeRateSnapshot{
			BaseCurrency:  "VND",
			QuoteCurrency: "VND",
			RateToBase:    "2.500000", // invalid non-unit rate for same currency!
		},
		Items: []product.AnalyticsOrderLine{
			{ProductID: p1ID, Quantity: 1, UnitPrice: &dec500k, Total: &dec500k},
		},
	})
	if _, err := h.GetSalesStats(ctxOwner, connect.NewRequest(&commercev1.GetSalesStatsRequest{ProductId: p1ID})); connect.CodeOf(err) != connect.CodeFailedPrecondition {
		t.Fatalf("F7 regression: expected CodeFailedPrecondition for same-currency order with RateToBase=2.5, got %v", err)
	}
}
