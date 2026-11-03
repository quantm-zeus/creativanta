package copilot_test

import (
	"context"
	"strings"
	"sync"
	"testing"

	"connectrpc.com/connect"
	copilotv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/copilot/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/copilot"
)

func ctxWithUser(userID, workspaceID, role string) context.Context {
	return copilot.WithCallerContext(context.Background(), copilot.CallerContext{
		UserID:        userID,
		WorkspaceID:   workspaceID,
		WorkspaceRole: role,
	})
}

func setupService() (*copilot.Service, *copilot.MemoryStore) {
	memStore := copilot.NewMemoryStore()
	svc := copilot.NewService(copilot.ServiceConfig{Store: memStore})
	return svc, memStore
}

// ---------------------------------------------------------------------------
// Acceptance Target 1: Contributor cannot delete product
// ---------------------------------------------------------------------------

func TestAcceptanceTarget1_ContributorCannotDeleteProduct(t *testing.T) {
	svc, store := setupService()
	contributorCtx := ctxWithUser("user-contrib-1", "ws-tenant-alpha", "contributor")

	// 1. Contributor asks Copilot to delete a product via Query
	resp, err := svc.Query(contributorCtx, connect.NewRequest(&copilotv1.CopilotServiceQueryRequest{
		WorkspaceId: "ws-tenant-alpha",
		Query:       "Xóa sản phẩm SKU-999 ngay lập tức khỏi gian hàng",
		Mode:        copilotv1.CopilotMode_COPILOT_MODE_CREATIVE,
	}))
	if err != nil {
		t.Fatalf("Query failed: %v", err)
	}

	// Verify RBAC denial response
	if !resp.Msg.Message.PermissionDenied {
		t.Fatalf("Expected PermissionDenied to be true, got false")
	}
	expectedDenial := "Bạn không có quyền xóa sản phẩm. Cần Admin+ role (product:delete)."
	if !strings.Contains(resp.Msg.Message.Content, expectedDenial) {
		t.Fatalf("Expected denial message %q, got %q", expectedDenial, resp.Msg.Message.Content)
	}
	if resp.Msg.Message.DenialReason != expectedDenial {
		t.Fatalf("Expected DenialReason %q, got %q", expectedDenial, resp.Msg.Message.DenialReason)
	}

	// Verify in persistence: product was NOT deleted
	if store.IsProductDeleted(context.Background(), "ws-tenant-alpha", "SKU-999") {
		t.Fatalf("Product SKU-999 was deleted despite Contributor lack of permissions!")
	}

	// 2. Also test English query "Delete product SKU-888" via SendMessage
	smResp, err := svc.SendMessage(contributorCtx, connect.NewRequest(&copilotv1.CopilotServiceSendMessageRequest{
		WorkspaceId: "ws-tenant-alpha",
		SessionId:   resp.Msg.Session.SessionId,
		Content:     "Please delete product SKU-888 from our catalog",
	}))
	if err != nil {
		t.Fatalf("SendMessage failed: %v", err)
	}
	if !smResp.Msg.Reply.PermissionDenied {
		t.Fatalf("Expected PermissionDenied on SendMessage delete product")
	}
	if store.IsProductDeleted(context.Background(), "ws-tenant-alpha", "SKU-888") {
		t.Fatalf("Product SKU-888 was deleted!")
	}

	// 3. Verify Admin role CAN request administrative operations without this denial
	adminCtx := ctxWithUser("user-admin-1", "ws-tenant-alpha", "admin")
	adminResp, err := svc.Query(adminCtx, connect.NewRequest(&copilotv1.CopilotServiceQueryRequest{
		WorkspaceId: "ws-tenant-alpha",
		Query:       "Xóa sản phẩm SKU-999",
	}))
	if err != nil {
		t.Fatalf("Admin query failed: %v", err)
	}
	if adminResp.Msg.Message.PermissionDenied {
		t.Fatalf("Admin should not have been denied product deletion")
	}
}

// ---------------------------------------------------------------------------
// Acceptance Target 2: Read query cannot expose finance
// ---------------------------------------------------------------------------

func TestAcceptanceTarget2_ReadQueryCannotExposeFinance(t *testing.T) {
	svc, _ := setupService()
	contributorCtx := ctxWithUser("user-contrib-1", "ws-tenant-alpha", "contributor")
	viewerCtx := ctxWithUser("user-viewer-1", "ws-tenant-alpha", "viewer")
	managerCtx := ctxWithUser("user-manager-1", "ws-tenant-alpha", "manager")

	financialQueries := []string{
		"Doanh thu hôm nay bao nhiêu?",
		"Cho tôi xem báo cáo lợi nhuận tháng này",
		"What is our total profit and margin this week?",
		"Chi phí quảng cáo và đối soát gần nhất",
	}

	// 1. Contributor asks financial questions -> MUST be redacted, NO finance exposed
	for _, q := range financialQueries {
		resp, err := svc.Query(contributorCtx, connect.NewRequest(&copilotv1.CopilotServiceQueryRequest{
			WorkspaceId: "ws-tenant-alpha",
			Query:       q,
		}))
		if err != nil {
			t.Fatalf("Query %q failed: %v", q, err)
		}
		if !resp.Msg.IsFinancialQuery {
			t.Fatalf("Expected IsFinancialQuery to be true for %q", q)
		}
		if !resp.Msg.FinancialDataRedacted {
			t.Fatalf("Expected FinancialDataRedacted to be true for Contributor querying %q", q)
		}
		expectedRefusal := "Bạn không có quyền truy cập dữ liệu tài chính của workspace."
		if !strings.Contains(resp.Msg.Message.Content, expectedRefusal) {
			t.Fatalf("Expected refusal text %q in content, got %q", expectedRefusal, resp.Msg.Message.Content)
		}

		// Check data cards: must be marked redacted with no sensitive amounts
		for _, dc := range resp.Msg.Message.DataCards {
			if dc.IsFinancial && !dc.IsRedacted {
				t.Fatalf("DataCard for %q exposed financial data to Contributor!", q)
			}
			if strings.Contains(dc.Summary, "45.200.000") || strings.Contains(dc.Summary, "32.5%") {
				t.Fatalf("Sensitive figures leaked in summary: %s", dc.Summary)
			}
		}
	}

	// 2. Viewer asking finance insight -> Redacted
	vResp, err := svc.FinanceInsight(viewerCtx, connect.NewRequest(&copilotv1.CopilotServiceFinanceInsightRequest{
		WorkspaceId: "ws-tenant-alpha",
		Period:      "30d",
	}))
	if err != nil {
		t.Fatalf("FinanceInsight failed: %v", err)
	}
	if !vResp.Msg.IsRedacted {
		t.Fatalf("Expected Viewer FinanceInsight to be redacted, got false")
	}

	// 3. Manager asking financial questions -> Authorized, numbers visible
	mResp, err := svc.Query(managerCtx, connect.NewRequest(&copilotv1.CopilotServiceQueryRequest{
		WorkspaceId: "ws-tenant-alpha",
		Query:       "Doanh thu hôm nay bao nhiêu?",
	}))
	if err != nil {
		t.Fatalf("Manager query failed: %v", err)
	}
	if !mResp.Msg.IsFinancialQuery {
		t.Fatalf("Expected IsFinancialQuery to be true for Manager")
	}
	if mResp.Msg.FinancialDataRedacted {
		t.Fatalf("Manager should have access to financial data, but was redacted")
	}
	if !strings.Contains(mResp.Msg.Message.Content, "45.200.000 VND") {
		t.Fatalf("Expected financial data in Manager response, got: %s", mResp.Msg.Message.Content)
	}
}

// ---------------------------------------------------------------------------
// Acceptance Target 3: Generated script needs quote confirmation
// ---------------------------------------------------------------------------

func TestAcceptanceTarget3_GeneratedScriptNeedsQuoteConfirmation(t *testing.T) {
	svc, store := setupService()
	editorCtx := ctxWithUser("user-editor-1", "ws-tenant-alpha", "editor")

	// 1. User asks Copilot to generate a script
	req1 := &copilotv1.CopilotServiceQueryRequest{
		WorkspaceId: "ws-tenant-alpha",
		Query:       "Tạo script bán hàng cho sản phẩm Serum Collagen",
	}
	resp1, err := svc.Query(editorCtx, connect.NewRequest(req1))
	if err != nil {
		t.Fatalf("Query for script generation failed: %v", err)
	}

	// Must require quote confirmation
	if !resp1.Msg.RequiresQuoteConfirmation {
		t.Fatalf("Expected RequiresQuoteConfirmation to be true before confirmation, got false")
	}
	if resp1.Msg.Quote == nil {
		t.Fatalf("Expected ActionQuote to be present in preview response")
	}
	if resp1.Msg.Quote.QuotedCredits != 5 {
		t.Fatalf("Expected 5 quoted credits, got %d", resp1.Msg.Quote.QuotedCredits)
	}
	quoteID := resp1.Msg.Quote.QuoteId
	sessionID := resp1.Msg.Session.SessionId

	// Verify credits in session have NOT been deducted yet
	sessionBefore, err := store.GetSession(context.Background(), "ws-tenant-alpha", sessionID)
	if err != nil {
		t.Fatalf("GetSession failed: %v", err)
	}
	if sessionBefore.TotalCreditsUsed != "0.000000" {
		t.Fatalf("Credits deducted before confirmation! Found: %s", sessionBefore.TotalCreditsUsed)
	}

	// Verify no script draft has been saved yet
	quoteObj, err := store.GetQuote(context.Background(), "ws-tenant-alpha", quoteID)
	if err != nil {
		t.Fatalf("GetQuote failed: %v", err)
	}
	if quoteObj.Status != "pending" {
		t.Fatalf("Expected quote status 'pending', got %q", quoteObj.Status)
	}

	// 2. User confirms the quote by providing ConfirmedQuoteId
	req2 := &copilotv1.CopilotServiceQueryRequest{
		WorkspaceId:      "ws-tenant-alpha",
		SessionId:        sessionID,
		ConfirmedQuoteId: quoteID,
	}
	resp2, err := svc.Query(editorCtx, connect.NewRequest(req2))
	if err != nil {
		t.Fatalf("Query confirming quote failed: %v", err)
	}

	// After confirmation, script should be created and confirmation flag false
	if resp2.Msg.RequiresQuoteConfirmation {
		t.Fatalf("Expected RequiresQuoteConfirmation to be false after confirmation")
	}
	if !strings.Contains(resp2.Msg.Message.Content, "Script đã tạo xong trong Script Lab") {
		t.Fatalf("Expected success message about script generation, got: %s", resp2.Msg.Message.Content)
	}

	// Verify session credits: exactly 5 credits deducted
	sessionAfter, err := store.GetSession(context.Background(), "ws-tenant-alpha", sessionID)
	if err != nil {
		t.Fatalf("GetSession after confirmation failed: %v", err)
	}
	if sessionAfter.TotalCreditsUsed != "5.000000" {
		t.Fatalf("Expected TotalCreditsUsed = 5.000000, got %s", sessionAfter.TotalCreditsUsed)
	}

	// Verify quote status in store is now confirmed
	quoteObjAfter, err := store.GetQuote(context.Background(), "ws-tenant-alpha", quoteID)
	if err != nil {
		t.Fatalf("GetQuote failed: %v", err)
	}
	if quoteObjAfter.Status != "confirmed" {
		t.Fatalf("Expected quote status 'confirmed', got %q", quoteObjAfter.Status)
	}

	// 3. Replay attack: attempting to confirm the same quote a second time MUST fail
	_, err = svc.Query(editorCtx, connect.NewRequest(req2))
	if err == nil {
		t.Fatalf("Expected replay of confirmed quote to fail, but it succeeded")
	}
	if !strings.Contains(err.Error(), "already been consumed") {
		t.Fatalf("Expected ErrQuoteAlreadyConsumed error message, got: %v", err)
	}
}

// ---------------------------------------------------------------------------
// Multi-Tenant Isolation & Error Guards
// ---------------------------------------------------------------------------

func TestMultiTenantIsolationAndAccessGuards(t *testing.T) {
	svc, _ := setupService()
	tenantAlphaCtx := ctxWithUser("user-1", "ws-tenant-alpha", "editor")

	// 1. Create a session in tenant Alpha
	respAlpha, err := svc.Query(tenantAlphaCtx, connect.NewRequest(&copilotv1.CopilotServiceQueryRequest{
		WorkspaceId: "ws-tenant-alpha",
		Query:       "Gợi ý việc cần làm hôm nay",
	}))
	if err != nil {
		t.Fatalf("Query tenant alpha failed: %v", err)
	}
	sessionID := respAlpha.Msg.Session.SessionId

	// 2. Tenant Beta attempts to access Tenant Alpha's session -> MUST FAIL
	tenantBetaCtx := ctxWithUser("user-2", "ws-tenant-beta", "editor")
	_, err = svc.GetSession(tenantBetaCtx, connect.NewRequest(&copilotv1.CopilotServiceGetSessionRequest{
		WorkspaceId: "ws-tenant-alpha", // mismatch with caller's ws-tenant-beta
		SessionId:   sessionID,
	}))
	if err == nil {
		t.Fatal("Expected cross-tenant access to fail, but succeeded")
	}
	if !strings.Contains(err.Error(), "cross-tenant") {
		t.Fatalf("Expected cross-tenant error, got: %v", err)
	}

	// 3. Unauthenticated call -> MUST FAIL
	_, err = svc.Query(context.Background(), connect.NewRequest(&copilotv1.CopilotServiceQueryRequest{
		WorkspaceId: "ws-tenant-alpha",
		Query:       "Test",
	}))
	if err == nil {
		t.Fatal("Expected unauthenticated call to fail")
	}
}

// ---------------------------------------------------------------------------
// Concurrency & Race Detector Test
// ---------------------------------------------------------------------------

func TestConcurrentQueriesNoRace(t *testing.T) {
	svc, _ := setupService()
	ctx := ctxWithUser("user-concurrent", "ws-tenant-race", "editor")

	var wg sync.WaitGroup
	for i := 0; i < 20; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			_, err := svc.Query(ctx, connect.NewRequest(&copilotv1.CopilotServiceQueryRequest{
				WorkspaceId: "ws-tenant-race",
				Query:       "Gợi ý ý tưởng nội dung",
			}))
			if err != nil {
				t.Errorf("Concurrent query %d failed: %v", idx, err)
			}
		}(i)
	}
	wg.Wait()
}
