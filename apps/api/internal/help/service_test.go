package help_test

import (
	"context"
	"testing"

	"connectrpc.com/connect"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/help"
)

func TestSearchContextualModuleFilter(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	// Scenario 1: User on M07 (AI Video Studio) clicks help icon -> filter to M07
	resp, err := svc.Search(ctx, connect.NewRequest(&adminv1.SearchRequest{
		ModuleFilter: "M07",
	}))
	if err != nil {
		t.Fatalf("Search failed: %v", err)
	}
	if len(resp.Msg.Articles) == 0 {
		t.Fatalf("expected at least 1 article for M07, got 0")
	}
	for _, a := range resp.Msg.Articles {
		foundM07 := false
		for _, m := range a.TargetModules {
			if m == "M07" {
				foundM07 = true
				break
			}
		}
		if !foundM07 {
			t.Errorf("article %s does not target M07", a.Title)
		}
	}

	// Scenario 2: Search by query "TikTok"
	respTT, err := svc.Search(ctx, connect.NewRequest(&adminv1.SearchRequest{
		Query: "TikTok",
	}))
	if err != nil {
		t.Fatalf("Search failed: %v", err)
	}
	if len(respTT.Msg.Articles) == 0 {
		t.Fatalf("expected articles for TikTok query, got 0")
	}
}

func TestStaleArticleDetection(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	// art-m22-token-expired was seeded with LastReviewedAt = 95 days ago
	resp, err := svc.GetArticle(ctx, connect.NewRequest(&adminv1.GetArticleRequest{
		SlugOrId: "art-m22-token-expired",
	}))
	if err != nil {
		t.Fatalf("GetArticle failed: %v", err)
	}
	if !resp.Msg.Article.Summary.IsStaleForReview {
		t.Errorf("expected article art-m22-token-expired to be flagged is_stale_for_review = true (AC 2)")
	}
}

func TestHelpfulVotingUpdates(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	artID := "art-m01-getting-started"
	u1 := "user-vote-1"

	// Initial get
	initResp, err := svc.GetArticle(ctx, connect.NewRequest(&adminv1.GetArticleRequest{
		SlugOrId: artID,
	}))
	if err != nil {
		t.Fatalf("GetArticle failed: %v", err)
	}
	initHelpful := initResp.Msg.Article.Summary.HelpfulVotes

	// Vote helpful
	rateResp, err := svc.RateArticle(ctx, connect.NewRequest(&adminv1.RateArticleRequest{
		ArticleId:    &commonv1.UUID{Value: artID},
		UserId:       &commonv1.UUID{Value: u1},
		Helpful:      true,
		FeedbackText: "Rất chi tiết và dễ hiểu!",
	}))
	if err != nil {
		t.Fatalf("RateArticle failed: %v", err)
	}
	if rateResp.Msg.HelpfulVotes != initHelpful+1 {
		t.Errorf("expected helpful votes %d, got %d", initHelpful+1, rateResp.Msg.HelpfulVotes)
	}

	// Change vote to unhelpful
	rateResp2, err := svc.RateArticle(ctx, connect.NewRequest(&adminv1.RateArticleRequest{
		ArticleId:    &commonv1.UUID{Value: artID},
		UserId:       &commonv1.UUID{Value: u1},
		Helpful:      false,
		FeedbackText: "Cần thêm ví dụ cho Shopee",
	}))
	if err != nil {
		t.Fatalf("RateArticle change failed: %v", err)
	}
	if rateResp2.Msg.HelpfulVotes != initHelpful {
		t.Errorf("expected helpful votes restored to %d, got %d", initHelpful, rateResp2.Msg.HelpfulVotes)
	}
	if rateResp2.Msg.UnhelpfulVotes < 1 {
		t.Errorf("expected unhelpful votes >= 1, got %d", rateResp2.Msg.UnhelpfulVotes)
	}
}

func TestKBAdminIsolation(t *testing.T) {
	svc := help.NewService(nil)
	adminSvc := svc.Admin()

	// 1. Workspace member caller (non-admin) denied from KBAdminService
	ctxMember := help.WithCallerContext(context.Background(), help.CallerContext{
		UserID:        "user-member-1",
		WorkspaceID:   "ws-1",
		WorkspaceRole: "owner", // Workspace Owner is NOT Internal Admin!
		IsAdmin:       false,
	})
	_, err := adminSvc.ListArticles(ctxMember, connect.NewRequest(&adminv1.ListArticlesRequest{}))
	if err == nil || connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected PermissionDenied for workspace role calling KBAdminService, got %v", err)
	}

	// 2. Internal Admin caller permitted
	ctxAdmin := help.WithCallerContext(context.Background(), help.CallerContext{
		UserID:    "admin-support-1",
		IsAdmin:   true,
		AdminRole: "support_admin",
	})
	adminResp, err := adminSvc.ListArticles(ctxAdmin, connect.NewRequest(&adminv1.ListArticlesRequest{}))
	if err != nil {
		t.Fatalf("ListArticles for admin failed: %v", err)
	}
	if len(adminResp.Msg.Articles) < 3 {
		t.Errorf("expected at least 3 articles in admin view, got %d", len(adminResp.Msg.Articles))
	}
	if adminResp.Msg.TotalStaleCount < 1 {
		t.Errorf("expected at least 1 stale article detected (>90d), got %d", adminResp.Msg.TotalStaleCount)
	}

	// 3. Stale review filter
	staleResp, err := adminSvc.ListStaleArticles(ctxAdmin, connect.NewRequest(&adminv1.ListStaleArticlesRequest{
		DaysThreshold: 90,
	}))
	if err != nil {
		t.Fatalf("ListStaleArticles failed: %v", err)
	}
	if staleResp.Msg.StaleCount == 0 {
		t.Errorf("expected at least 1 stale article returned, got 0")
	}

	// 4. Admin creates, updates, and publishes a new article draft
	createResp, err := adminSvc.CreateArticle(ctxAdmin, connect.NewRequest(&adminv1.CreateArticleRequest{
		CategoryId:           &commonv1.UUID{Value: "cat-getting-started"},
		Slug:                 "tinh-nang-moi-p0-08",
		Locale:               "vi-VN",
		Title:                "Thông báo cập nhật hệ thống P0-08",
		Summary:              "Bổ sung hệ thống thông báo và trung tâm trợ giúp.",
		BodyMarkdown:         "## P0-08 Shells & Help\nChi tiết bài viết.",
		ArticleType:          adminv1.KBArticleType_KB_ARTICLE_TYPE_CHANGELOG,
		TargetModules:        []string{"M01", "M23"},
		EstimatedReadMinutes: 2,
	}))
	if err != nil {
		t.Fatalf("CreateArticle failed: %v", err)
	}
	newID := createResp.Msg.Article.Summary.ArticleId.Value

	// Verify draft is not yet visible in user search
	userSearch, _ := svc.Search(context.Background(), connect.NewRequest(&adminv1.SearchRequest{
		Query: "P0-08",
	}))
	if len(userSearch.Msg.Articles) > 0 {
		t.Errorf("draft article should not be visible in user search before publish")
	}

	// Admin publishes article
	pubResp, err := adminSvc.PublishArticle(ctxAdmin, connect.NewRequest(&adminv1.PublishArticleRequest{
		ArticleId: &commonv1.UUID{Value: newID},
	}))
	if err != nil {
		t.Fatalf("PublishArticle failed: %v", err)
	}
	if pubResp.Msg.Article.Summary.Status != adminv1.KBArticleStatus_KB_ARTICLE_STATUS_PUBLISHED {
		t.Errorf("expected published status, got %v", pubResp.Msg.Article.Summary.Status)
	}

	// Now visible in user search
	userSearch2, _ := svc.Search(context.Background(), connect.NewRequest(&adminv1.SearchRequest{
		Query: "P0-08",
	}))
	if len(userSearch2.Msg.Articles) == 0 {
		t.Errorf("published article should now be visible in user search")
	}
}
