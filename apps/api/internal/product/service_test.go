package product_test

import (
	"context"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/product"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

const (
	testWorkspaceID1 = "11111111-1111-4000-8000-000000000001"
	testWorkspaceID2 = "22222222-2222-4000-8000-000000000002"
)

func newTestService() (*product.Service, *product.MemoryStore, *product.MemoryEventSink) {
	store := product.NewMemoryStore()
	sink := product.NewMemoryEventSink()
	fixedTime := time.Date(2026, 11, 2, 12, 0, 0, 0, time.UTC)
	svc := product.NewService(store, sink, func() time.Time { return fixedTime })
	return svc, store, sink
}

func TestProductLifecycleCRUD(t *testing.T) {
	ctx := context.Background()
	svc, _, sink := newTestService()

	priceDec, err := tenantdb.ParseExactDecimal("150000.000000")
	if err != nil {
		t.Fatalf("parse price: %v", err)
	}
	cogsDec, err := tenantdb.ParseExactDecimal("85000.000000")
	if err != nil {
		t.Fatalf("parse cogs: %v", err)
	}

	// 1. Create Product
	newProd := &product.Product{
		WorkspaceID:      testWorkspaceID1,
		ProductType:      product.TypePhysical,
		Title:            "Áo Thun Nam Cotton 100%",
		Description:      "Áo thun phong cách basic năng động",
		Category:         "Thời trang nam",
		BasePrice:        &priceDec,
		Currency:         "VND",
		COGS:             &cogsDec,
		CatalogStatus:    product.StatusDraft,
		InventoryEnabled: true,
		Images:           []string{"https://assets.creativanta.test/ao-thun-1.jpg"},
		SKUs: []product.ProductSku{
			{
				SkuCode:           "ATN-BLK-M",
				VariantAttributes: map[string]string{"color": "black", "size": "M"},
				Currency:          "VND",
				LowStockThreshold: 10,
				IsActive:          true,
			},
			{
				SkuCode:           "ATN-BLK-L",
				VariantAttributes: map[string]string{"color": "black", "size": "L"},
				Currency:          "VND",
				LowStockThreshold: 10,
				IsActive:          true,
			},
		},
	}

	created, err := svc.CreateProduct(ctx, newProd)
	if err != nil {
		t.Fatalf("CreateProduct failed: %v", err)
	}
	if created.ProductID == "" {
		t.Fatal("expected non-empty ProductID")
	}
	if len(created.SKUs) != 2 {
		t.Fatalf("expected 2 SKUs, got %d", len(created.SKUs))
	}

	// Verify product.created event emitted
	events := sink.Events()
	if len(events) != 1 {
		t.Fatalf("expected 1 outbox event, got %d", len(events))
	}
	if events[0].EventType != "product.created" {
		t.Fatalf("expected event type product.created, got %s", events[0].EventType)
	}
	if events[0].AggregateID != created.ProductID {
		t.Fatalf("expected aggregate ID %s, got %s", created.ProductID, events[0].AggregateID)
	}

	// 2. Get Product
	fetched, err := svc.GetProduct(ctx, testWorkspaceID1, created.ProductID)
	if err != nil {
		t.Fatalf("GetProduct failed: %v", err)
	}
	if fetched.Title != newProd.Title {
		t.Fatalf("expected title %s, got %s", newProd.Title, fetched.Title)
	}

	// Cross-tenant access must return ErrProductNotFound
	_, err = svc.GetProduct(ctx, testWorkspaceID2, created.ProductID)
	if err != product.ErrProductNotFound {
		t.Fatalf("expected ErrProductNotFound for cross-tenant get, got %v", err)
	}

	// 3. Update Product
	updatedTitle := "Áo Thun Nam Cotton 100% Cao Cấp"
	updated, err := svc.UpdateProduct(ctx, &product.Product{
		ProductID:     created.ProductID,
		WorkspaceID:   testWorkspaceID1,
		Title:         updatedTitle,
		CatalogStatus: product.StatusActive,
	})
	if err != nil {
		t.Fatalf("UpdateProduct failed: %v", err)
	}
	if updated.Title != updatedTitle {
		t.Fatalf("expected title %s, got %s", updatedTitle, updated.Title)
	}
	if updated.CatalogStatus != product.StatusActive {
		t.Fatalf("expected status active, got %s", updated.CatalogStatus)
	}

	// Check catalog_status_changed event
	events = sink.Events()
	if len(events) != 2 {
		t.Fatalf("expected 2 outbox events, got %d", len(events))
	}
	if events[1].EventType != "product.catalog_status_changed" {
		t.Fatalf("expected event product.catalog_status_changed, got %s", events[1].EventType)
	}

	// 4. Archive Product
	archived, err := svc.ArchiveProduct(ctx, testWorkspaceID1, created.ProductID)
	if err != nil {
		t.Fatalf("ArchiveProduct failed: %v", err)
	}
	if archived.CatalogStatus != product.StatusArchived {
		t.Fatalf("expected status archived, got %s", archived.CatalogStatus)
	}

	// 5. Soft Delete Product
	if err := svc.DeleteProduct(ctx, testWorkspaceID1, created.ProductID); err != nil {
		t.Fatalf("DeleteProduct failed: %v", err)
	}
	_, err = svc.GetProduct(ctx, testWorkspaceID1, created.ProductID)
	if err != product.ErrProductNotFound {
		t.Fatalf("expected ErrProductNotFound after soft-delete, got %v", err)
	}
}

func TestProductValidationRules(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := newTestService()

	// Missing title
	_, err := svc.CreateProduct(ctx, &product.Product{
		WorkspaceID: testWorkspaceID1,
		ProductType: product.TypePhysical,
		Title:       "",
	})
	if err == nil {
		t.Fatal("expected error on missing title")
	}

	// Invalid product type
	_, err = svc.CreateProduct(ctx, &product.Product{
		WorkspaceID: testWorkspaceID1,
		ProductType: "spacecraft",
		Title:       "Test item",
	})
	if err == nil {
		t.Fatal("expected error on invalid product type")
	}

	// Negative price
	negPrice, _ := tenantdb.ParseExactDecimal("-10.000000")
	_, err = svc.CreateProduct(ctx, &product.Product{
		WorkspaceID: testWorkspaceID1,
		ProductType: product.TypePhysical,
		Title:       "Test item",
		BasePrice:   &negPrice,
	})
	if err == nil {
		t.Fatal("expected error on negative price")
	}
}

func TestProductContentLinking(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := newTestService()

	p, err := svc.CreateProduct(ctx, &product.Product{
		WorkspaceID: testWorkspaceID1,
		ProductType: product.TypePhysical,
		Title:       "Bình giữ nhiệt 500ml",
	})
	if err != nil {
		t.Fatalf("create product: %v", err)
	}

	// Link script content
	scriptRef := product.ContentRef{
		ContentID:   "script-uuid-101",
		ContentType: "script",
		Title:       "Kịch bản Review Bình Giữ Nhiệt TikTok",
		URL:         "https://creativanta.test/scripts/101",
		Metadata:    map[string]any{"hook": "Thử thách giữ đá 24h"},
	}
	linked, err := svc.LinkContent(ctx, testWorkspaceID1, p.ProductID, scriptRef)
	if err != nil {
		t.Fatalf("LinkContent failed: %v", err)
	}
	if linked.ContentID != scriptRef.ContentID {
		t.Fatalf("expected content ID %s, got %s", scriptRef.ContentID, linked.ContentID)
	}

	// Link video asset content
	assetRef := product.ContentRef{
		ContentID:   "asset-uuid-202",
		ContentType: "asset",
		Title:       "Video Hero Showcase 1080p",
		URL:         "https://creativanta.test/assets/202",
	}
	_, err = svc.LinkContent(ctx, testWorkspaceID1, p.ProductID, assetRef)
	if err != nil {
		t.Fatalf("LinkContent asset failed: %v", err)
	}

	// Retrieve linked content
	contents, err := svc.GetLinkedContent(ctx, testWorkspaceID1, p.ProductID)
	if err != nil {
		t.Fatalf("GetLinkedContent failed: %v", err)
	}
	if len(contents) != 2 {
		t.Fatalf("expected 2 linked contents, got %d", len(contents))
	}

	// Idempotent re-link updates without duplication
	updatedScriptRef := scriptRef
	updatedScriptRef.Title = "Kịch bản Review Updated"
	_, err = svc.LinkContent(ctx, testWorkspaceID1, p.ProductID, updatedScriptRef)
	if err != nil {
		t.Fatalf("re-link failed: %v", err)
	}
	contents, err = svc.GetLinkedContent(ctx, testWorkspaceID1, p.ProductID)
	if err != nil {
		t.Fatalf("GetLinkedContent after re-link failed: %v", err)
	}
	if len(contents) != 2 {
		t.Fatalf("expected still 2 linked contents after re-linking, got %d", len(contents))
	}
	if contents[0].Title != updatedScriptRef.Title {
		t.Fatalf("expected updated title %s, got %s", updatedScriptRef.Title, contents[0].Title)
	}
}

func TestStockAndThresholdManagement(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := newTestService()

	p, err := svc.CreateProduct(ctx, &product.Product{
		WorkspaceID: testWorkspaceID1,
		ProductType: product.TypePhysical,
		Title:       "Kem chống nắng SPF50+",
	})
	if err != nil {
		t.Fatalf("create product: %v", err)
	}
	skuID := p.SKUs[0].SkuID

	// Update stock
	newStock, err := svc.UpdateStock(ctx, testWorkspaceID1, skuID, 50, "initial restock")
	if err != nil {
		t.Fatalf("update stock failed: %v", err)
	}
	if newStock != 50 {
		t.Fatalf("expected 50, got %d", newStock)
	}

	// Delta reduction
	newStock, err = svc.UpdateStock(ctx, testWorkspaceID1, skuID, -20, "order sale")
	if err != nil {
		t.Fatalf("reduction failed: %v", err)
	}
	if newStock != 30 {
		t.Fatalf("expected 30, got %d", newStock)
	}

	// Set alert threshold
	if err := svc.SetAlertThreshold(ctx, testWorkspaceID1, skuID, 15); err != nil {
		t.Fatalf("set alert threshold failed: %v", err)
	}

	// Check stats projection
	_, _, activeSkus, onHand, _, err := svc.GetStats(ctx, testWorkspaceID1, p.ProductID)
	if err != nil {
		t.Fatalf("get stats failed: %v", err)
	}
	if activeSkus != 1 || onHand != 30 {
		t.Fatalf("expected 1 active SKU and 30 on hand, got %d skus and %d on hand", activeSkus, onHand)
	}
}

func TestBatchTaggingAndBulkArchive(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := newTestService()

	p1, _ := svc.CreateProduct(ctx, &product.Product{
		WorkspaceID: testWorkspaceID1,
		ProductType: product.TypePhysical,
		Title:       "Product Tag Test 1",
	})
	p2, _ := svc.CreateProduct(ctx, &product.Product{
		WorkspaceID: testWorkspaceID1,
		ProductType: product.TypePhysical,
		Title:       "Product Tag Test 2",
	})

	// Batch Tag
	count, err := svc.BatchTagProducts(ctx, testWorkspaceID1, []string{p1.ProductID, p2.ProductID}, []string{"fmcg", "summer2026"}, nil)
	if err != nil {
		t.Fatalf("batch tag failed: %v", err)
	}
	if count != 2 {
		t.Fatalf("expected 2 tagged products, got %d", count)
	}

	// Bulk Archive
	archivedCount, err := svc.BulkArchiveProducts(ctx, testWorkspaceID1, []string{p1.ProductID, p2.ProductID})
	if err != nil {
		t.Fatalf("bulk archive failed: %v", err)
	}
	if archivedCount != 2 {
		t.Fatalf("expected 2 archived products, got %d", archivedCount)
	}
}
