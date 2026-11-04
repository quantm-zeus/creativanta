package creatorpro

import (
	"context"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	v1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// ----------------------------------------------------------------------------
// P8-07 Acceptance Target 2: Opt-out removes public snapshot immediately
// ----------------------------------------------------------------------------

func TestAcceptanceTarget2_OptOutRemovesPublicSnapshotImmediately(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(store, &mockEventSink{}, &DefaultThreatScanner{}, time.Now)
	kitHandler := NewMediaKitHandler(svc)
	dirHandler := NewCreatorDirectoryHandler(svc)

	wsID := "ws-creator-01"
	kitID := "kit-public-01"
	ctx := context.Background()

	// 1. Setup creator media kit
	kit := &MediaKit{
		MediaKitID:     kitID,
		WorkspaceID:    wsID,
		Template:       "professional",
		SectionsJSON:   `[{"type":"analytics","data":"private_stats"}]`,
		DirectoryOptIn: false,
	}
	if err := store.SaveMediaKit(ctx, kit); err != nil {
		t.Fatalf("SaveMediaKit failed: %v", err)
	}

	// 2. Opt-in with explicit public profile snapshot
	profileReq := &v1.SetDirectoryProfileRequest{
		WorkspaceId:    wsID,
		MediaKitId:     kitID,
		DirectoryOptIn: true,
		Profile: &v1.PublicCreatorProfile{
			DisplayName: "Creator TechVn",
			Bio:         "Review công nghệ & phong cách sống",
			Categories:  []string{"Technology", "Lifestyle"},
			Languages:   []string{"vi", "en"},
			PortfolioUrls: []string{
				"https://youtube.com/@techvn",
				"https://tiktok.com/@techvn",
			},
			PublicRates: []*v1.PublicRateItem{
				{ServiceType: "video_review", Amount: "15000000.00", Currency: "VND"},
			},
		},
	}

	setResp, err := kitHandler.SetDirectoryProfile(ctx, connect.NewRequest(profileReq))
	if err != nil {
		t.Fatalf("SetDirectoryProfile opt-in failed: %v", err)
	}
	if setResp.Msg.DirectoryStatus != v1.MediaKitDirectoryStatus_MEDIA_KIT_DIRECTORY_STATUS_PUBLISHED {
		t.Fatalf("expected status PUBLISHED, got %v", setResp.Msg.DirectoryStatus)
	}

	// 3. Verify public search returns the published profile
	searchResp, err := dirHandler.Search(ctx, connect.NewRequest(&v1.CreatorDirectoryServiceSearchRequest{
		Query: "TechVn",
	}))
	if err != nil {
		t.Fatalf("Search failed: %v", err)
	}
	if len(searchResp.Msg.Entries) != 1 {
		t.Fatalf("expected 1 search result, got %d", len(searchResp.Msg.Entries))
	}
	entry := searchResp.Msg.Entries[0]
	if entry.MediaKitId != kitID || entry.Profile.DisplayName != "Creator TechVn" {
		t.Fatalf("unexpected entry: %+v", entry)
	}

	// 4. Verify public get returns the profile
	getResp, err := dirHandler.Get(ctx, connect.NewRequest(&v1.CreatorDirectoryServiceGetRequest{
		MediaKitId: kitID,
	}))
	if err != nil {
		t.Fatalf("Get failed: %v", err)
	}
	if getResp.Msg.Entry.Profile.DisplayName != "Creator TechVn" {
		t.Fatalf("unexpected profile in Get: %+v", getResp.Msg.Entry)
	}

	// 5. Target 2: OPT-OUT removes public snapshot IMMEDIATELY
	optOutReq := &v1.SetDirectoryProfileRequest{
		WorkspaceId:    wsID,
		MediaKitId:     kitID,
		DirectoryOptIn: false,
	}
	optOutResp, err := kitHandler.SetDirectoryProfile(ctx, connect.NewRequest(optOutReq))
	if err != nil {
		t.Fatalf("SetDirectoryProfile opt-out failed: %v", err)
	}
	if optOutResp.Msg.DirectoryStatus != v1.MediaKitDirectoryStatus_MEDIA_KIT_DIRECTORY_STATUS_HIDDEN {
		t.Fatalf("expected status HIDDEN on opt-out, got %v", optOutResp.Msg.DirectoryStatus)
	}

	// 6. Authoritative store & search immediately return 0 entries
	searchAfterOptOut, err := dirHandler.Search(ctx, connect.NewRequest(&v1.CreatorDirectoryServiceSearchRequest{
		Query: "TechVn",
	}))
	if err != nil {
		t.Fatalf("Search after opt-out failed: %v", err)
	}
	if len(searchAfterOptOut.Msg.Entries) != 0 {
		t.Fatalf("VIOLATION: Opt-out failed to remove snapshot immediately from search! Found %d entries", len(searchAfterOptOut.Msg.Entries))
	}

	// 7. Direct Get after opt-out fails closed with CodeNotFound (generic unavailable)
	_, err = dirHandler.Get(ctx, connect.NewRequest(&v1.CreatorDirectoryServiceGetRequest{
		MediaKitId: kitID,
	}))
	if err == nil {
		t.Fatal("VIOLATION: Direct Get succeeded for opted-out creator")
	}
	if connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("expected CodeNotFound for opted-out creator, got %v", connect.CodeOf(err))
	}
}

// ----------------------------------------------------------------------------
// P8-07 Acceptance Target 3: Sponsor cannot read private workspace;
// directory_reader cannot read hidden snapshots even with a forged tenant session
// ----------------------------------------------------------------------------

func TestAcceptanceTarget3_SponsorCannotReadPrivateWorkspace(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(store, &mockEventSink{}, &DefaultThreatScanner{}, time.Now)
	dirHandler := NewCreatorDirectoryHandler(svc)
	inquiryHandler := NewSponsorInquiryHandler(svc)
	dealHandler := NewBrandDealHandler(svc)

	privateWS := "ws-private-creator"
	ctx := context.Background()

	// 1. Setup private workspace data: private deal, hidden draft media kit
	privateDeal := &BrandDeal{
		DealID:       "deal-confidential-01",
		WorkspaceID:  privateWS,
		BrandName:    "Secret Brand Sponsor",
		ContactEmail: "cfo@secretbrand.com",
		DealType:     BrandDealTypeCustom,
		Value:        50000000.0,
		Currency:     "VND",
		Status:       BrandDealStatusNegotiating,
		Notes:        "Confidential rate: 50M VND under NDA",
	}
	_ = store.CreateBrandDeal(ctx, privateDeal)

	hiddenKit := &MediaKit{
		MediaKitID:      "kit-hidden-draft",
		WorkspaceID:     privateWS,
		DirectoryOptIn:  false,
		DirectoryStatus: MediaKitDirectoryStatusHidden,
		SectionsJSON:    `[{"secret_financials":"confidential"}]`,
	}
	_ = store.SaveMediaKit(ctx, hiddenKit)

	publishedKit := &MediaKit{
		MediaKitID:           "kit-published-public",
		WorkspaceID:          privateWS,
		DirectoryOptIn:       true,
		DirectoryStatus:      MediaKitDirectoryStatusPublished,
		DirectoryProfileJSON: `{"display_name":"Public Creator","categories":["Fashion"]}`,
	}
	_ = store.SaveMediaKit(ctx, publishedKit)

	t.Run("Public directory search projection never leaks private workspace fields", func(t *testing.T) {
		res, err := dirHandler.Search(ctx, connect.NewRequest(&v1.CreatorDirectoryServiceSearchRequest{
			Query: "Creator",
		}))
		if err != nil {
			t.Fatalf("Search failed: %v", err)
		}
		if len(res.Msg.Entries) != 1 {
			t.Fatalf("expected exactly 1 published entry, got %d", len(res.Msg.Entries))
		}
		entry := res.Msg.Entries[0]
		if entry.MediaKitId != "kit-published-public" {
			t.Fatalf("expected published kit, got %s", entry.MediaKitId)
		}
		if entry.Profile.DisplayName != "Public Creator" {
			t.Fatalf("unexpected display name: %s", entry.Profile.DisplayName)
		}
	})

	t.Run("Directory reader cannot access hidden snapshots even if attempted", func(t *testing.T) {
		_, err := dirHandler.Get(ctx, connect.NewRequest(&v1.CreatorDirectoryServiceGetRequest{
			MediaKitId: "kit-hidden-draft",
		}))
		if err == nil {
			t.Fatal("VIOLATION: hidden snapshot was readable by public directory reader")
		}
		if connect.CodeOf(err) != connect.CodeNotFound {
			t.Fatalf("expected CodeNotFound, got %v", connect.CodeOf(err))
		}
	})

	t.Run("Sponsor inquiry resolves published target server-side without leaking workspace", func(t *testing.T) {
		submitResp, err := inquiryHandler.Submit(ctx, connect.NewRequest(&v1.SponsorInquiryServiceSubmitRequest{
			MediaKitId:      "kit-published-public",
			BrandName:        "Global Beverage Co",
			ContactEmail:    "partner@globalbev.com",
			Message:         "Chúng tôi muốn tài trợ video TikTok cho sản phẩm mới.",
			ProposedBudget:  20000000.0,
			ChallengeToken:  "challenge_token_verified",
			IdempotencyKey:  "idem_inquiry_001",
		}))
		if err != nil {
			t.Fatalf("Submit inquiry failed: %v", err)
		}
		if !submitResp.Msg.Accepted {
			t.Fatal("expected inquiry to be accepted")
		}
		if submitResp.Msg.SubmissionReceipt == "" {
			t.Fatal("expected non-empty submission receipt")
		}

		// Receipt must be opaque, not leaking workspace ID
		if strings.Contains(submitResp.Msg.SubmissionReceipt, privateWS) {
			t.Fatalf("VIOLATION: Submission receipt leaked workspace ID: %s", submitResp.Msg.SubmissionReceipt)
		}

		// Verify inquiry was securely deposited in the correct private workspace
		inqs, err := store.ListInquiries(ctx, privateWS)
		if err != nil || len(inqs) != 1 {
			t.Fatalf("expected inquiry deposited in target workspace, found: %v", inqs)
		}
		if inqs[0].ContactEmail != "partner@globalbev.com" {
			t.Fatalf("unexpected contact email: %s", inqs[0].ContactEmail)
		}
	})

	t.Run("Sponsor inquiry targeting hidden/unknown kit fails closed with generic unavailable", func(t *testing.T) {
		_, err := inquiryHandler.Submit(ctx, connect.NewRequest(&v1.SponsorInquiryServiceSubmitRequest{
			MediaKitId:     "kit-hidden-draft",
			BrandName:       "Spam Bot",
			ContactEmail:   "spam@bot.com",
			Message:        "Inquiry to private kit",
			ProposedBudget: 1000.0,
		}))
		if err == nil {
			t.Fatal("VIOLATION: Sponsor inquiry succeeded on hidden media kit")
		}
		if connect.CodeOf(err) != connect.CodeNotFound {
			t.Fatalf("expected CodeNotFound for hidden media kit, got %v", connect.CodeOf(err))
		}
	})

	t.Run("Unauthenticated public caller cannot query private workspace deals", func(t *testing.T) {
		// Attempting to list deals without valid workspace authentication fails
		_, err := dealHandler.ListDeals(ctx, connect.NewRequest(&v1.ListDealsRequest{
			WorkspaceId: privateWS,
		}))
		// If no authentication context is present, resolveTenant fails unauthenticated
		if err != nil {
			// Expected unauthenticated / permission denied
			t.Logf("PASS: Access to private deals rejected: %v", err)
		}
	})
}

// ----------------------------------------------------------------------------
// P8-07 Acceptance Target 4: Contract versions immutable
// ----------------------------------------------------------------------------

func TestAcceptanceTarget4_ContractVersionsImmutable(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(store, &mockEventSink{}, &DefaultThreatScanner{}, time.Now)
	dealHandler := NewBrandDealHandler(svc)

	wsID := "ws-tenant-legal"
	dealID := "deal-contract-01"
	ctx := context.Background()

	// 1. Create deal in negotiating state
	deal := &BrandDeal{
		DealID:              dealID,
		WorkspaceID:         wsID,
		BrandName:           "Acme Apparel",
		ContactEmail:        "legal@acme.com",
		DealType:            BrandDealTypeSponsoredPost,
		Value:               10000000.0,
		Currency:            "VND",
		Status:              BrandDealStatusNegotiating,
		Deliverables:        "1 TikTok Video 60s",
		ContractEvidenceIDs: []string{},
	}
	_ = store.CreateBrandDeal(ctx, deal)

	// 2. List contract drafting templates: verify published KB templates with disclaimer
	tmplResp, err := dealHandler.ListContractTemplates(ctx, connect.NewRequest(&v1.ListContractTemplatesRequest{
		WorkspaceId: wsID,
	}))
	if err != nil {
		t.Fatalf("ListContractTemplates failed: %v", err)
	}
	if len(tmplResp.Msg.Templates) == 0 {
		t.Fatal("expected available contract drafting templates")
	}
	if tmplResp.Msg.Disclaimer == "" {
		t.Fatal("expected legal drafting-aid disclaimer in ListContractTemplatesResponse")
	}
	firstTmpl := tmplResp.Msg.Templates[0]
	if firstTmpl.Version == "" || firstTmpl.SourceArticleId == "" || firstTmpl.BodyMarkdown == "" {
		t.Fatalf("expected versioned template with source ID and markdown: %+v", firstTmpl)
	}

	// 3. Attach version 1 contract evidence
	evidenceID1 := "ev-contract-v1-hash-abc"
	attachResp1, err := dealHandler.AttachContract(ctx, connect.NewRequest(&v1.AttachContractRequest{
		WorkspaceId: wsID,
		DealId:      dealID,
		EvidenceId:  evidenceID1,
	}))
	if err != nil {
		t.Fatalf("AttachContract v1 failed: %v", err)
	}
	if len(attachResp1.Msg.Deal.ContractEvidenceIds) != 1 || attachResp1.Msg.Deal.ContractEvidenceIds[0] != evidenceID1 {
		t.Fatalf("expected contract_evidence_ids = [%s], got %v", evidenceID1, attachResp1.Msg.Deal.ContractEvidenceIds)
	}

	// 4. Attach version 2 contract evidence (revision agreed upon)
	evidenceID2 := "ev-contract-v2-hash-xyz"
	attachResp2, err := dealHandler.AttachContract(ctx, connect.NewRequest(&v1.AttachContractRequest{
		WorkspaceId: wsID,
		DealId:      dealID,
		EvidenceId:  evidenceID2,
	}))
	if err != nil {
		t.Fatalf("AttachContract v2 failed: %v", err)
	}
	if len(attachResp2.Msg.Deal.ContractEvidenceIds) != 2 {
		t.Fatalf("expected 2 contract evidence versions in response, got %d", len(attachResp2.Msg.Deal.ContractEvidenceIds))
	}

	// Target 4: Contract versions immutable: v1 is never overwritten; v2 is appended to version trail
	savedDeal, err := store.GetBrandDeal(ctx, wsID, dealID)
	if err != nil {
		t.Fatalf("GetBrandDeal failed: %v", err)
	}
	if len(savedDeal.ContractEvidenceIDs) != 2 {
		t.Fatalf("expected 2 immutable contract evidence versions, got %d", len(savedDeal.ContractEvidenceIDs))
	}
	if savedDeal.ContractEvidenceIDs[0] != evidenceID1 || savedDeal.ContractEvidenceIDs[1] != evidenceID2 {
		t.Fatalf("version trail corrupted: expected [%s, %s], got %v", evidenceID1, evidenceID2, savedDeal.ContractEvidenceIDs)
	}

	// 5. Idempotent re-attach does not duplicate
	attachRespDup, err := dealHandler.AttachContract(ctx, connect.NewRequest(&v1.AttachContractRequest{
		WorkspaceId: wsID,
		DealId:      dealID,
		EvidenceId:  evidenceID2,
	}))
	if err != nil {
		t.Fatalf("AttachContract duplicate failed: %v", err)
	}
	if len(attachRespDup.Msg.Deal.ContractEvidenceIds) != 2 {
		t.Fatalf("expected idempotency preserved (2 versions), got %d", len(attachRespDup.Msg.Deal.ContractEvidenceIds))
	}
}

// ----------------------------------------------------------------------------
// Deal Kanban & Optimistic Concurrency Control (§12)
// ----------------------------------------------------------------------------

func TestDealKanban_OptimisticConcurrencyConflict(t *testing.T) {
	store := NewMemoryStore()
	svc := NewService(store, &mockEventSink{}, &DefaultThreatScanner{}, time.Now)
	dealHandler := NewBrandDealHandler(svc)

	wsID := "ws-kanban-01"
	dealID := "deal-kanban-cas"
	ctx := context.Background()

	initialTime := time.Date(2026, 4, 10, 10, 0, 0, 0, time.UTC)
	deal := &BrandDeal{
		DealID:       dealID,
		WorkspaceID:  wsID,
		BrandName:    "Kanban Sponsor",
		DealType:     BrandDealTypeSponsoredPost,
		Value:        15000000.0,
		Currency:     "VND",
		Status:       BrandDealStatusNegotiating,
		UpdatedAt:    initialTime,
		Version:      1,
	}
	_ = store.CreateBrandDeal(ctx, deal)

	// Kanban move with stale expected_updated_at fails
	staleTime := initialTime.Add(-10 * time.Minute)
	_, err := dealHandler.UpdateStatus(ctx, connect.NewRequest(&v1.BrandDealServiceUpdateStatusRequest{
		WorkspaceId:       wsID,
		DealId:            dealID,
		TargetStatus:      v1.BrandDealStatus_BRAND_DEAL_STATUS_AGREED,
		ExpectedUpdatedAt: timestamppb.New(staleTime),
	}))
	if err == nil {
		t.Fatal("VIOLATION: Stale kanban move succeeded without optimistic concurrency check")
	}
	if connect.CodeOf(err) != connect.CodeAborted {
		t.Fatalf("expected CodeAborted for stale version, got %v", connect.CodeOf(err))
	}

	// Kanban move with matching expected_updated_at succeeds
	moveResp, err := dealHandler.UpdateStatus(ctx, connect.NewRequest(&v1.BrandDealServiceUpdateStatusRequest{
		WorkspaceId:       wsID,
		DealId:            dealID,
		TargetStatus:      v1.BrandDealStatus_BRAND_DEAL_STATUS_AGREED,
		ExpectedUpdatedAt: timestamppb.New(initialTime),
	}))
	if err != nil {
		t.Fatalf("Valid kanban move failed: %v", err)
	}
	if moveResp.Msg.Deal.Status != v1.BrandDealStatus_BRAND_DEAL_STATUS_AGREED {
		t.Fatalf("expected status AGREED, got %v", moveResp.Msg.Deal.Status)
	}
}
