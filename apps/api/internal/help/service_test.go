package help_test

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"testing"
	"time"

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

// -----------------------------------------------------------------------------
// P8-04 ACCEPTANCE TARGET 1: Stale Article Review & Quality Queue
// -----------------------------------------------------------------------------

func TestStaleArticleReviewWorkflow(t *testing.T) {
	svc := help.NewService(nil)
	adminSvc := svc.Admin()
	ctx := context.Background()

	ctxAdmin := help.WithCallerContext(ctx, help.CallerContext{
		UserID:    "admin-support-01",
		IsAdmin:   true,
		AdminRole: "support_admin",
	})
	ctxMember := help.WithCallerContext(ctx, help.CallerContext{
		UserID:        "user-regular-01",
		WorkspaceID:   "ws-01",
		WorkspaceRole: "owner",
		IsAdmin:       false,
	})

	artID := "art-m22-token-expired"

	// 1. Initial state: art-m22-token-expired was seeded with LastReviewedAt = 95 days ago -> Stale!
	initArt, err := svc.GetArticle(ctx, connect.NewRequest(&adminv1.GetArticleRequest{
		SlugOrId: artID,
	}))
	if err != nil {
		t.Fatalf("GetArticle failed: %v", err)
	}
	if !initArt.Msg.Article.Summary.IsStaleForReview {
		t.Fatalf("expected art-m22-token-expired to be stale for review initially")
	}

	// 2. Non-admin caller attempting ReviewArticle is denied
	_, err = adminSvc.ReviewArticle(ctxMember, artID, "Unauthorized review attempt")
	if err == nil {
		t.Fatalf("expected permission error when non-admin calls ReviewArticle")
	}

	// 3. Admin calls ReviewArticle with review notes
	reviewNote := "Reviewed OAuth token reconnect procedures for TikTok Shop and Shopee; verified still current."
	reviewedArt, err := adminSvc.ReviewArticle(ctxAdmin, artID, reviewNote)
	if err != nil {
		t.Fatalf("ReviewArticle failed: %v", err)
	}
	if reviewedArt.LastReviewedBy != "admin-support-01" {
		t.Errorf("expected LastReviewedBy = admin-support-01, got %q", reviewedArt.LastReviewedBy)
	}
	if reviewedArt.ReviewNotes != reviewNote {
		t.Errorf("expected ReviewNotes = %q, got %q", reviewNote, reviewedArt.ReviewNotes)
	}

	// 4. Verify version history records the review note
	history, err := adminSvc.GetVersionHistory(ctxAdmin, artID)
	if err != nil {
		t.Fatalf("GetVersionHistory failed: %v", err)
	}
	if len(history) == 0 {
		t.Fatalf("expected at least 1 version in history after review")
	}
	lastVer := history[len(history)-1]
	if !strings.Contains(lastVer.ChangeNote, "admin-support-01") {
		t.Errorf("expected change note to record reviewer ID, got %q", lastVer.ChangeNote)
	}

	// 5. User-facing GetArticle now reports IsStaleForReview = false!
	postArt, err := svc.GetArticle(ctx, connect.NewRequest(&adminv1.GetArticleRequest{
		SlugOrId: artID,
	}))
	if err != nil {
		t.Fatalf("GetArticle after review failed: %v", err)
	}
	if postArt.Msg.Article.Summary.IsStaleForReview {
		t.Errorf("expected article to NO LONGER be stale after review completed")
	}

	// 6. Admin ListStaleArticles now reports 0 stales
	staleList, err := adminSvc.ListStaleArticles(ctxAdmin, connect.NewRequest(&adminv1.ListStaleArticlesRequest{
		DaysThreshold: 90,
	}))
	if err != nil {
		t.Fatalf("ListStaleArticles failed: %v", err)
	}
	for _, a := range staleList.Msg.StaleArticles {
		if a.ArticleId.Value == artID {
			t.Errorf("reviewed article should no longer appear in ListStaleArticles")
		}
	}
}

func TestQualityQueueLowRatingDetection(t *testing.T) {
	svc := help.NewService(nil)
	adminSvc := svc.Admin()
	ctxAdmin := help.WithCallerContext(context.Background(), help.CallerContext{
		UserID:    "admin-content-01",
		IsAdmin:   true,
		AdminRole: "content_admin",
	})

	// art-m13-inventory-sync was seeded with 2 helpful / 8 unhelpful = 20% (< 60% threshold)
	queue, err := adminSvc.ListQualityQueue(ctxAdmin, 3, 0.60)
	if err != nil {
		t.Fatalf("ListQualityQueue failed: %v", err)
	}
	if len(queue) == 0 {
		t.Fatalf("expected at least 1 article in quality rewrite queue, got 0")
	}

	found := false
	for _, item := range queue {
		if item.Article.ArticleID == "art-m13-inventory-sync" {
			found = true
			if item.HelpfulRatio != 0.20 {
				t.Errorf("expected helpful ratio 0.20, got %f", item.HelpfulRatio)
			}
			if item.TotalVotes != 10 {
				t.Errorf("expected total votes 10, got %d", item.TotalVotes)
			}
			break
		}
	}
	if !found {
		t.Errorf("expected art-m13-inventory-sync to be detected in quality rewrite queue")
	}
}

func TestContextualHelpIntegration(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	// Contextual help request from M07 AI Video Studio
	resp, err := svc.GetContextualHelp(ctx, "M07", "creator", "/studio/ai-video")
	if err != nil {
		t.Fatalf("GetContextualHelp failed: %v", err)
	}

	if resp.PrimaryArticle == nil {
		t.Fatalf("expected primary article for M07 contextual help, got nil")
	}
	if resp.PrimaryArticle.ArticleId.Value != "art-m07-ai-studio" {
		t.Errorf("expected art-m07-ai-studio, got %s", resp.PrimaryArticle.ArticleId.Value)
	}
	if !strings.Contains(resp.PrimaryArticle.Title, "AI Video Studio") {
		t.Errorf("unexpected article title: %s", resp.PrimaryArticle.Title)
	}
	if resp.EmptyStateGuide == "" {
		t.Errorf("expected empty state guide to be populated")
	}
	if resp.TroubleshootingTip == "" {
		t.Errorf("expected troubleshooting tip to be populated")
	}
}

// -----------------------------------------------------------------------------
// P8-04 ACCEPTANCE TARGET 2: Beta Program ("Beta grant once")
// -----------------------------------------------------------------------------

func TestBetaEnrollmentAndGrantOnce(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	wsID := "ws-beta-creator-1"
	userID := "user-creator-1"

	// 1. Free tier is strictly ineligible
	_, err := svc.EnrollBeta(ctx, wsID, userID, "free")
	if err == nil || !strings.Contains(err.Error(), "paid tiers") {
		t.Fatalf("expected ErrBetaTierIneligible for free tier, got %v", err)
	}

	// 2. Initial enrollment on Starter paid tier
	res1, err := svc.EnrollBeta(ctx, wsID, userID, "starter")
	if err != nil {
		t.Fatalf("EnrollBeta for starter failed: %v", err)
	}
	if res1.CreditsAwarded != 50 {
		t.Errorf("expected 50 bonus credits on first enrollment, got %d", res1.CreditsAwarded)
	}
	if res1.AlreadyGranted {
		t.Errorf("expected AlreadyGranted = false on first enrollment")
	}
	if res1.Enrollment.Status != "active" {
		t.Errorf("expected status active, got %s", res1.Enrollment.Status)
	}
	if len(res1.EnabledFlags) == 0 {
		t.Errorf("expected beta feature flags to be enabled")
	}

	// Verify status query
	stRec, flags, err := svc.GetBetaStatus(ctx, wsID)
	if err != nil || stRec == nil {
		t.Fatalf("GetBetaStatus failed: %v", err)
	}
	if stRec.Status != "active" || !stRec.BonusCreditsGranted {
		t.Errorf("unexpected beta status record: %+v", stRec)
	}
	if len(flags) == 0 {
		t.Errorf("expected active beta flags")
	}

	// 3. User opts out
	optOutRec, err := svc.OptOutBeta(ctx, wsID, userID)
	if err != nil {
		t.Fatalf("OptOutBeta failed: %v", err)
	}
	if optOutRec.Status != "opted_out" {
		t.Errorf("expected status opted_out, got %s", optOutRec.Status)
	}
	if optOutRec.OptedOutAt == nil {
		t.Errorf("expected OptedOutAt to be set")
	}

	// Flags should be disabled
	_, flagsAfterOptOut, _ := svc.GetBetaStatus(ctx, wsID)
	if len(flagsAfterOptOut) != 0 {
		t.Errorf("expected 0 beta flags after opt out, got %v", flagsAfterOptOut)
	}

	// 4. User re-enrolls later (ACCEPTANCE TARGET 2: "Beta grant once")
	res2, err := svc.EnrollBeta(ctx, wsID, userID, "pro")
	if err != nil {
		t.Fatalf("Re-enrollment failed: %v", err)
	}
	if res2.Enrollment.Status != "active" {
		t.Errorf("expected status reactivated, got %s", res2.Enrollment.Status)
	}
	// CRITICAL CHECK: 0 credits awarded on re-enrollment!
	if res2.CreditsAwarded != 0 {
		t.Fatalf("VIOLATION OF BETA GRANT ONCE: awarded %d credits on re-enrollment! Expected 0.", res2.CreditsAwarded)
	}
	if !res2.AlreadyGranted {
		t.Errorf("expected AlreadyGranted = true on re-enrollment")
	}
	if len(res2.EnabledFlags) == 0 {
		t.Errorf("expected beta flags to be re-enabled on re-enrollment")
	}
}

func TestBetaFeedbackAndGraduationCriteria(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	wsID := "ws-feedback-1"
	userID := "user-feedback-1"
	featKey := "beta_video_continuity"

	// Invalid rating (<1 or >5) rejected
	_, err := svc.SubmitBetaFeedback(ctx, wsID, userID, featKey, 0, "Bad rating", false, nil)
	if err == nil {
		t.Errorf("expected error for rating 0")
	}
	_, err = svc.SubmitBetaFeedback(ctx, wsID, userID, featKey, 6, "Bad rating", false, nil)
	if err == nil {
		t.Errorf("expected error for rating 6")
	}

	// Submit 5 valid ratings (all 5-star)
	for i := 0; i < 5; i++ {
		_, err := svc.SubmitBetaFeedback(ctx, wsID, fmt.Sprintf("u-%d", i), featKey, 5, "Tuyệt vời!", false, map[string]any{
			"browser": "Chrome",
			"route":   "/studio/ai-video",
		})
		if err != nil {
			t.Fatalf("SubmitBetaFeedback failed: %v", err)
		}
	}

	// 1. Evaluate graduation when deployed 20 days ago, 0 bugs -> CanGraduate = true
	deployed20DaysAgo := time.Now().UTC().Add(-20 * 24 * time.Hour)
	eval1, err := svc.EvaluateBetaGraduation(ctx, featKey, deployed20DaysAgo, 0)
	if err != nil {
		t.Fatalf("EvaluateBetaGraduation failed: %v", err)
	}
	if !eval1.CanGraduate {
		t.Errorf("expected CanGraduate = true, notes: %s", eval1.EvaluationNotes)
	}
	if eval1.PositiveRatingRatio != 1.0 {
		t.Errorf("expected 100%% positive ratio, got %f", eval1.PositiveRatingRatio)
	}

	// 2. Blocked by active P0/P1 bugs
	eval2, err := svc.EvaluateBetaGraduation(ctx, featKey, deployed20DaysAgo, 1)
	if err != nil {
		t.Fatalf("EvaluateBetaGraduation failed: %v", err)
	}
	if eval2.CanGraduate {
		t.Errorf("expected CanGraduate = false when active bugs exist")
	}
	if !strings.Contains(eval2.EvaluationNotes, "active P0/P1 bugs") {
		t.Errorf("expected note about active bugs, got %s", eval2.EvaluationNotes)
	}
}

// -----------------------------------------------------------------------------
// P8-04 ACCEPTANCE TARGET 3: Incident Notifications & Subscription Privacy
// -----------------------------------------------------------------------------

func TestPublicStatusSubscriptionPrivacy(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	// 1. Subscribe 2 users (email + webhook)
	emailSecret := "creator-secret@privatemail.com"
	webhookSecret := "https://private-webhook.agency.vn/listener"

	sub1, err := svc.SubscribeStatus(ctx, "email", emailSecret, []string{"ai_services", "platform_connectors"})
	if err != nil {
		t.Fatalf("SubscribeStatus email failed: %v", err)
	}
	if sub1.PrivacyToken == "" {
		t.Fatalf("expected non-empty privacy token returned to subscriber")
	}

	sub2, err := svc.SubscribeStatus(ctx, "webhook", webhookSecret, nil)
	if err != nil {
		t.Fatalf("SubscribeStatus webhook failed: %v", err)
	}
	if sub2.PrivacyToken == "" {
		t.Fatalf("expected non-empty privacy token for webhook subscriber")
	}

	// 2. Query Public Status Page
	pubStatus, err := svc.GetPublicStatus(ctx)
	if err != nil {
		t.Fatalf("GetPublicStatus failed: %v", err)
	}
	if len(pubStatus.Components) != 8 {
		t.Errorf("expected 8 monitored components per §5.1, got %d", len(pubStatus.Components))
	}
	if pubStatus.TotalSubscribersCount != 2 {
		t.Errorf("expected TotalSubscribersCount = 2, got %d", pubStatus.TotalSubscribersCount)
	}

	// 3. ACCEPTANCE TARGET 3 CRITICAL: Subscription Privacy check
	// Serialize the entire public status payload to JSON string and verify NO secret contact details leak!
	rawJSON, err := json.Marshal(pubStatus)
	if err != nil {
		t.Fatalf("json.Marshal failed: %v", err)
	}
	jsonStr := string(rawJSON)

	if strings.Contains(jsonStr, emailSecret) {
		t.Fatalf("CRITICAL PRIVACY VIOLATION: subscriber email %q leaked in public status response: %s", emailSecret, jsonStr)
	}
	if strings.Contains(jsonStr, webhookSecret) {
		t.Fatalf("CRITICAL PRIVACY VIOLATION: webhook URL %q leaked in public status response: %s", webhookSecret, jsonStr)
	}
	if strings.Contains(jsonStr, sub1.PrivacyToken) || strings.Contains(jsonStr, sub2.PrivacyToken) {
		t.Fatalf("CRITICAL PRIVACY VIOLATION: subscriber privacy token leaked in public status response!")
	}

	// 4. Unsubscribe with private token
	unsubSuccess, err := svc.UnsubscribeStatus(ctx, sub1.PrivacyToken)
	if err != nil || !unsubSuccess {
		t.Fatalf("UnsubscribeStatus failed: %v", err)
	}

	// Verify subscriber count drops to 1
	pubStatus2, _ := svc.GetPublicStatus(ctx)
	if pubStatus2.TotalSubscribersCount != 1 {
		t.Errorf("expected 1 active subscriber after unsubscribe, got %d", pubStatus2.TotalSubscribersCount)
	}

	// Unsubscribe with bogus token fails
	_, err = svc.UnsubscribeStatus(ctx, "bogus-random-token-12345")
	if err == nil {
		t.Errorf("expected error when unsubscribing with bogus token")
	}
}

func TestIncidentCommunicationSLAsAndNotifications(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	// Subscribe an active email subscriber
	_, _ = svc.SubscribeStatus(ctx, "email", "subscriber-ops@brand.com", []string{"ai_services"})

	// 1. Create a P0 incident
	inc, err := svc.CreateIncident(ctx,
		"Sự cố gián đoạn AI Video Studio",
		"P0_critical",
		[]string{"ai_services"},
		"Đang điều tra lỗi kết nối cụm máy chủ render AI.",
	)
	if err != nil {
		t.Fatalf("CreateIncident failed: %v", err)
	}

	// Verify communication deadlines per §5.2
	// P0: initial update <= 15m, ongoing update <= 30m
	if inc.InitialUpdateDueAt.Sub(inc.DetectedAt) > 15*time.Minute {
		t.Errorf("expected initial update due within 15m for P0, got %v", inc.InitialUpdateDueAt.Sub(inc.DetectedAt))
	}
	if inc.OngoingUpdateDueAt.Sub(inc.DetectedAt) > 30*time.Minute {
		t.Errorf("expected ongoing update due within 30m for P0, got %v", inc.OngoingUpdateDueAt.Sub(inc.DetectedAt))
	}

	// Check status page reflects major outage on ai_services
	st, _ := svc.GetPublicStatus(ctx)
	if st.OverallStatus != "major_outage" {
		t.Errorf("expected overall status major_outage, got %s", st.OverallStatus)
	}

	// 2. Dispatch Incident Notification
	dispatch, err := svc.DispatchIncidentNotification(ctx, inc.IncidentID, "Đã khoanh vùng sự cố phần cứng tại node GPU.", "P0_critical")
	if err != nil {
		t.Fatalf("DispatchIncidentNotification failed: %v", err)
	}
	if dispatch.RecipientCount != 1 {
		t.Errorf("expected 1 recipient notified, got %d", dispatch.RecipientCount)
	}

	// 3. Mitigate incident -> component status becomes degraded_performance
	_, err = svc.UpdateIncident(ctx, inc.IncidentID, "mitigated", "Đã định tuyến lại sang cụm dự phòng.")
	if err != nil {
		t.Fatalf("UpdateIncident mitigated failed: %v", err)
	}
	stMitigated, _ := svc.GetPublicStatus(ctx)
	if stMitigated.OverallStatus != "degraded_performance" {
		t.Errorf("expected overall status degraded_performance after mitigation, got %s", stMitigated.OverallStatus)
	}

	// 4. Resolve incident -> component status returns to operational
	_, err = svc.UpdateIncident(ctx, inc.IncidentID, "resolved", "Hệ thống đã hoạt động bình thường 100%.")
	if err != nil {
		t.Fatalf("UpdateIncident resolved failed: %v", err)
	}
	stResolved, _ := svc.GetPublicStatus(ctx)
	if stResolved.OverallStatus != "operational" {
		t.Errorf("expected overall status operational after resolve, got %s", stResolved.OverallStatus)
	}
}

// -----------------------------------------------------------------------------
// P8-04 Customer Support Desk SLAs & Internal Note Isolation
// -----------------------------------------------------------------------------

func TestSupportSLAPerPlanTier(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	now := time.Now().UTC()

	// Free plan: 48h response / 120h resolution
	tFree, _, err := svc.CreateSupportTicket(ctx, "ws-free", "u-free", "free", "Lỗi tạo bài viết", "normal", "content", "Nội dung", nil)
	if err != nil {
		t.Fatalf("CreateSupportTicket Free failed: %v", err)
	}
	if tFree.SLAResponseDueAt.Sub(now) < 47*time.Hour || tFree.SLAResponseDueAt.Sub(now) > 49*time.Hour {
		t.Errorf("expected ~48h response SLA for Free plan, got %v", tFree.SLAResponseDueAt.Sub(now))
	}
	if tFree.SLAResolutionDueAt.Sub(now) < 119*time.Hour || tFree.SLAResolutionDueAt.Sub(now) > 121*time.Hour {
		t.Errorf("expected ~120h resolution SLA for Free plan, got %v", tFree.SLAResolutionDueAt.Sub(now))
	}

	// Pro plan: 8h response / 24h resolution
	tPro, _, err := svc.CreateSupportTicket(ctx, "ws-pro", "u-pro", "pro", "Hỗ trợ gói cước", "high", "billing", "Chi tiết", nil)
	if err != nil {
		t.Fatalf("CreateSupportTicket Pro failed: %v", err)
	}
	if tPro.SLAResponseDueAt.Sub(now) < 7*time.Hour || tPro.SLAResponseDueAt.Sub(now) > 9*time.Hour {
		t.Errorf("expected ~8h response SLA for Pro plan, got %v", tPro.SLAResponseDueAt.Sub(now))
	}
	if tPro.SLAResolutionDueAt.Sub(now) < 23*time.Hour || tPro.SLAResolutionDueAt.Sub(now) > 25*time.Hour {
		t.Errorf("expected ~24h resolution SLA for Pro plan, got %v", tPro.SLAResolutionDueAt.Sub(now))
	}

	// Enterprise plan: 1h response / 4h resolution
	tEnt, _, err := svc.CreateSupportTicket(ctx, "ws-ent", "u-ent", "enterprise", "Hỗ trợ khẩn cấp", "urgent", "technical", "Chi tiết", nil)
	if err != nil {
		t.Fatalf("CreateSupportTicket Enterprise failed: %v", err)
	}
	if tEnt.SLAResponseDueAt.Sub(now) < 50*time.Minute || tEnt.SLAResponseDueAt.Sub(now) > 70*time.Minute {
		t.Errorf("expected ~1h response SLA for Enterprise plan, got %v", tEnt.SLAResponseDueAt.Sub(now))
	}
	if tEnt.SLAResolutionDueAt.Sub(now) < 230*time.Minute || tEnt.SLAResolutionDueAt.Sub(now) > 250*time.Minute {
		t.Errorf("expected ~4h resolution SLA for Enterprise plan, got %v", tEnt.SLAResolutionDueAt.Sub(now))
	}
}

func TestSupportSLABreachDetection(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	// Create ticket with past due dates
	ticket, _, err := svc.CreateSupportTicket(ctx, "ws-breach", "u-breach", "enterprise", "Cần hỗ trợ", "urgent", "technical", "Message", nil)
	if err != nil {
		t.Fatalf("CreateSupportTicket failed: %v", err)
	}

	// Simulate current time 3 hours in the future (past 1h response SLA!)
	futureTime := time.Now().UTC().Add(3 * time.Hour)
	breaches := svc.CheckSLABreaches(futureTime)
	if len(breaches) == 0 {
		t.Fatalf("expected SLA breach to be detected after 3 hours")
	}

	found := false
	for _, b := range breaches {
		if b.TicketID == ticket.TicketID && b.BreachType == "first_response_breach" {
			found = true
			break
		}
	}
	if !found {
		t.Errorf("expected first_response_breach for ticket %s", ticket.TicketID)
	}
}

func TestInternalNoteIsolation(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	wsID := "ws-note-isolation"
	userID := "user-creator"

	ticket, _, err := svc.CreateSupportTicket(ctx, wsID, userID, "starter", "Lỗi đồng bộ Shopee", "normal", "technical", "Không nhận đơn hàng", nil)
	if err != nil {
		t.Fatalf("CreateSupportTicket failed: %v", err)
	}

	// 1. Workspace user attempting to write an internal note is rejected!
	_, err = svc.ReplySupportTicket(ctx, ticket.TicketID, wsID, "user", userID, "Ghi chú nội bộ bí mật", true, false)
	if err != help.ErrInternalNoteForbidden {
		t.Fatalf("expected ErrInternalNoteForbidden when workspace caller sets isInternalNote=true, got %v", err)
	}

	// 2. Admin adds an internal note
	internalNoteText := "[INTERNAL NOTE] Khách hàng đã đạt hạn mức API; cần kiểm tra cấu hình tenant."
	_, err = svc.ReplySupportTicket(ctx, ticket.TicketID, wsID, "admin", "admin-support-01", internalNoteText, true, true)
	if err != nil {
		t.Fatalf("admin ReplySupportTicket internal note failed: %v", err)
	}

	// 3. Admin adds a regular customer-facing reply
	customerReplyText := "Chào bạn, chúng tôi đang kiểm tra kết nối với sàn Shopee."
	_, err = svc.ReplySupportTicket(ctx, ticket.TicketID, wsID, "admin", "admin-support-01", customerReplyText, false, true)
	if err != nil {
		t.Fatalf("admin ReplySupportTicket public reply failed: %v", err)
	}

	// 4. Workspace user retrieves ticket (isInternalAdmin = false)
	_, userMessages, err := svc.GetSupportTicket(ctx, ticket.TicketID, wsID, false)
	if err != nil {
		t.Fatalf("GetSupportTicket for workspace user failed: %v", err)
	}
	for _, m := range userMessages {
		if m.IsInternalNote || strings.Contains(m.Body, "Ghi chú nội bộ") {
			t.Fatalf("CRITICAL SECURITY LEAK: internal note was returned to workspace user! Body: %q", m.Body)
		}
	}

	// 5. Admin retrieves ticket (isInternalAdmin = true)
	_, adminMessages, err := svc.GetSupportTicket(ctx, ticket.TicketID, wsID, true)
	if err != nil {
		t.Fatalf("GetSupportTicket for admin failed: %v", err)
	}
	foundInternalNote := false
	for _, m := range adminMessages {
		if m.IsInternalNote && strings.Contains(m.Body, "cấu hình tenant") {
			foundInternalNote = true
			break
		}
	}
	if !foundInternalNote {
		t.Errorf("expected internal note to be visible to internal admin")
	}
}

func TestTicketCloseAndCSAT(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	ticket, _, err := svc.CreateSupportTicket(ctx, "ws-csat", "u-csat", "pro", "Vấn đề tài chính", "normal", "billing", "Hỏi về số dư", nil)
	if err != nil {
		t.Fatalf("CreateSupportTicket failed: %v", err)
	}

	// Invalid CSAT (score 0 or 6) rejected
	_, err = svc.CloseSupportTicket(ctx, ticket.TicketID, "ws-csat", 0, "Too low", false)
	if err != help.ErrInvalidCSATScore {
		t.Errorf("expected ErrInvalidCSATScore for score 0, got %v", err)
	}
	_, err = svc.CloseSupportTicket(ctx, ticket.TicketID, "ws-csat", 6, "Too high", false)
	if err != help.ErrInvalidCSATScore {
		t.Errorf("expected ErrInvalidCSATScore for score 6, got %v", err)
	}

	// Valid close with 5-star CSAT
	closedTicket, err := svc.CloseSupportTicket(ctx, ticket.TicketID, "ws-csat", 5, "Hỗ trợ rất nhanh và nhiệt tình!", false)
	if err != nil {
		t.Fatalf("CloseSupportTicket failed: %v", err)
	}
	if closedTicket.Status != "closed" {
		t.Errorf("expected status closed, got %s", closedTicket.Status)
	}
	if closedTicket.CSATScore != 5 {
		t.Errorf("expected CSAT score 5, got %d", closedTicket.CSATScore)
	}
	if closedTicket.ResolvedAt == nil {
		t.Errorf("expected ResolvedAt to be set")
	}
}

// -----------------------------------------------------------------------------
// P8-04 In-App Announcements & Changelog
// -----------------------------------------------------------------------------

func TestInAppAnnouncementTargetingAndSessionDismissal(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	uFree := "user-free-01"
	uPro := "user-pro-01"
	uEnt := "user-ent-01"

	// 1. Free user in session 0 -> receives improvement announcement (targeted to all). Does NOT receive Pro launch.
	freeAnn, err := svc.GetActiveAnnouncementsForUser(ctx, uFree, "ws-free", "free", "creator", "vi-vn", 0)
	if err != nil {
		t.Fatalf("GetActiveAnnouncementsForUser free failed: %v", err)
	}
	if len(freeAnn) != 1 {
		t.Fatalf("expected 1 announcement for free user, got %d", len(freeAnn))
	}
	if freeAnn[0].AnnouncementID != "ann-platform-speed" {
		t.Errorf("expected ann-platform-speed for free user, got %s", freeAnn[0].AnnouncementID)
	}

	// 2. Pro user in session 0 -> receives Pro feature launch modal (Priority 3 > 2)
	proAnn, err := svc.GetActiveAnnouncementsForUser(ctx, uPro, "ws-pro", "pro", "creator", "vi-vn", 0)
	if err != nil {
		t.Fatalf("GetActiveAnnouncementsForUser pro failed: %v", err)
	}
	if len(proAnn) != 1 {
		t.Fatalf("expected 1 announcement for pro user, got %d", len(proAnn))
	}
	if proAnn[0].AnnouncementID != "ann-beta-pro-launch" {
		t.Errorf("expected ann-beta-pro-launch for pro user, got %s", proAnn[0].AnnouncementID)
	}

	// 3. Pro user in session 1 (sessionSeenCount = 1) -> receives NOTHING (Max 1 per session rule!)
	proAnnSession1, err := svc.GetActiveAnnouncementsForUser(ctx, uPro, "ws-pro", "pro", "creator", "vi-vn", 1)
	if err != nil {
		t.Fatalf("session 1 call failed: %v", err)
	}
	if len(proAnnSession1) != 0 {
		t.Fatalf("expected 0 announcements for session 1 (max 1 per session), got %d", len(proAnnSession1))
	}

	// 4. Pro user dismisses announcement
	err = svc.DismissAnnouncement(ctx, uPro, "ws-pro", "ann-beta-pro-launch")
	if err != nil {
		t.Fatalf("DismissAnnouncement failed: %v", err)
	}

	// In next session (sessionSeenCount = 0), dismissed announcement is NOT returned; next priority announcement is returned!
	proAnnNextSession, err := svc.GetActiveAnnouncementsForUser(ctx, uPro, "ws-pro", "pro", "creator", "vi-vn", 0)
	if err != nil {
		t.Fatalf("next session call failed: %v", err)
	}
	if len(proAnnNextSession) != 1 {
		t.Fatalf("expected next priority announcement, got %d", len(proAnnNextSession))
	}
	if proAnnNextSession[0].AnnouncementID != "ann-platform-speed" {
		t.Errorf("expected fallback to ann-platform-speed after dismissing first, got %s", proAnnNextSession[0].AnnouncementID)
	}

	// 5. Enterprise user receives breaking change blocking modal (Priority 4)
	entAnn, err := svc.GetActiveAnnouncementsForUser(ctx, uEnt, "ws-ent", "enterprise", "seller", "vi-vn", 0)
	if err != nil {
		t.Fatalf("ent call failed: %v", err)
	}
	if len(entAnn) != 1 {
		t.Fatalf("expected 1 announcement for enterprise user, got %d", len(entAnn))
	}
	if entAnn[0].AnnouncementID != "ann-breaking-api-v1" {
		t.Errorf("expected ann-breaking-api-v1 (Priority 4), got %s", entAnn[0].AnnouncementID)
	}
	if entAnn[0].DisplayMode != "blocking_modal" {
		t.Errorf("expected display_mode blocking_modal, got %s", entAnn[0].DisplayMode)
	}
}

func TestChangelogListing(t *testing.T) {
	svc := help.NewService(nil)
	ctx := context.Background()

	// All entries
	entries, err := svc.ListChangelog(ctx, "")
	if err != nil {
		t.Fatalf("ListChangelog failed: %v", err)
	}
	if len(entries) < 2 {
		t.Errorf("expected at least 2 changelog entries, got %d", len(entries))
	}

	// Filter by category
	featureEntries, err := svc.ListChangelog(ctx, "feature")
	if err != nil {
		t.Fatalf("ListChangelog feature failed: %v", err)
	}
	if len(featureEntries) == 0 {
		t.Errorf("expected at least 1 feature changelog entry")
	}
	for _, fe := range featureEntries {
		if !strings.EqualFold(fe.Category, "feature") {
			t.Errorf("expected feature category, got %s", fe.Category)
		}
	}
}
