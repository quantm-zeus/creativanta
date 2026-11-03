package production

import (
	"context"
	"net/url"
	"strings"
	"testing"

	"connectrpc.com/connect"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func setupShowcaseTestService(t *testing.T) (*Service, string) {
	t.Helper()
	wsID := "22222222-2222-2222-2222-222222222201"
	store := NewMemoryStore()
	svc := NewService(ServiceConfig{
		Store: store,
		InitialBalances: map[string]tenantdb.ExactDecimal{
			wsID: tenantdb.MustParseExactDecimal("500.000000"),
		},
	})
	return svc, wsID
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: All listed styles & options
// ----------------------------------------------------------------------------

func TestAcceptanceTarget1_AllListedStylesAndOptions(t *testing.T) {
	svc, wsID := setupShowcaseTestService(t)
	ctxEditor := contextWithRole("Editor", "user-test-01")

	t.Run("EF-01: All 8 Showcase styles supported with credit quotes", func(t *testing.T) {
		styles := []productionv1.ShowcaseStyle{
			productionv1.ShowcaseStyle_SHOWCASE_STYLE_360_SPIN,
			productionv1.ShowcaseStyle_SHOWCASE_STYLE_TABLETOP_DEMO,
			productionv1.ShowcaseStyle_SHOWCASE_STYLE_FLIP_REVEAL,
			productionv1.ShowcaseStyle_SHOWCASE_STYLE_VIRTUAL_TRY_ON,
			productionv1.ShowcaseStyle_SHOWCASE_STYLE_LIFESTYLE_CONTEXT,
			productionv1.ShowcaseStyle_SHOWCASE_STYLE_UNBOXING_SIMULATION,
			productionv1.ShowcaseStyle_SHOWCASE_STYLE_BEFORE_AFTER,
			productionv1.ShowcaseStyle_SHOWCASE_STYLE_REVIEW_STYLE,
		}

		canonicalNames := []string{
			"360_spin", "tabletop_demo", "flip_reveal", "virtual_try_on",
			"lifestyle_context", "unboxing_simulation", "before_after", "review_style",
		}

		for i, st := range styles {
			name := CanonicalShowcaseStyleName(st)
			if name != canonicalNames[i] {
				t.Fatalf("style %v expected name %q, got %q", st, canonicalNames[i], name)
			}

			credits := EstimateShowcaseCredits(st)
			// Credits must be in range 8-40 per spec
			if credits.Cmp(tenantdb.MustParseExactDecimal("8.000000")) < 0 || credits.Cmp(tenantdb.MustParseExactDecimal("40.000000")) > 0 {
				t.Fatalf("style %v credits %s out of allowed range [8, 40]", st, credits.String())
			}

			// Test creating showcase for each style with valid images
			images := []string{
				"https://cdn.example.com/p1.jpg", "https://cdn.example.com/p2.jpg",
				"https://cdn.example.com/p3.jpg", "https://cdn.example.com/p4.jpg",
				"https://cdn.example.com/p5.jpg", "https://cdn.example.com/p6.jpg",
				"https://cdn.example.com/p7.jpg", "https://cdn.example.com/p8.jpg",
			}

			req := connect.NewRequest(&productionv1.ProductShowcaseServiceCreateRequest{
				Context: &commonv1.CommandContext{
					WorkspaceId: &commonv1.UUID{Value: wsID},
				},
				ProductId:         "prod-001",
				Style:             st,
				ManualImageUrls:   images,
				ManualDescription: "Kem dưỡng ẩm chuyên sâu",
				Customization: &productionv1.ShowcaseCustomization{
					Background:       "studio_white",
					Duration:         30,
					Music:            "auto",
					Voice:            "mila",
					Headline:         "Kem dưỡng ẩm 24h",
					AspectRatio:      "9:16",
					Pacing:           "medium",
					ColorGrade:       "natural",
					RemoveBackground: true,
				},
			})

			res, err := svc.ProductShowcase.Create(ctxEditor, req)
			if err != nil {
				t.Fatalf("ProductShowcaseService/Create failed for style %v: %v", st, err)
			}
			if res.Msg.GetJob().GetShowcaseJobId() == "" {
				t.Fatalf("expected showcase job id for style %v", st)
			}
			if res.Msg.GetJob().GetStatus() != "queued" {
				t.Fatalf("expected job status 'queued', got %q", res.Msg.GetJob().GetStatus())
			}
		}
	})

	t.Run("EF-02: Image-to-Video 6 motion styles + presets, durations 3-15s, loop and tiers", func(t *testing.T) {
		styles := []productionv1.ImageMotionStyle{
			productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_CINEMATIC_PAN,
			productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_PRODUCT_ROTATE,
			productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_PARALLAX_3D,
			productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_SUBTLE_MOVEMENT,
			productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_ZOOM_IN,
			productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_CUSTOM_PROMPT,
			productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_KEN_BURNS,
			productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_MORPH,
			productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_RANDOM,
		}

		for _, ms := range styles {
			name := MotionStyleName(ms)
			if name == "" {
				t.Fatalf("expected motion style name for %v", ms)
			}
		}

		// Credit calculation: 5-25 credits
		draftCost := EstimateImageToVideoCredits("draft", false).String()
		stdCost := EstimateImageToVideoCredits("standard", false).String()
		premCost := EstimateImageToVideoCredits("premium", true).String()

		if draftCost != "5" || stdCost != "10" || premCost != "30" {
			t.Fatalf("unexpected credit tier calculation: draft=%s, std=%s, prem=%s", draftCost, stdCost, premCost)
		}

		// Duration and config validation
		cfgValid := &productionv1.ImageToVideoConfig{
			ImageUrls: []string{
				"https://cdn.example.com/img1.jpg",
				"https://cdn.example.com/img2.jpg",
				"https://cdn.example.com/img3.jpg",
			},
			DefaultMotionStyle: productionv1.ImageMotionStyle_IMAGE_MOTION_STYLE_PARALLAX_3D,
			DurationSeconds:    10,
			LoopFriendly:       true,
			AutoMusicSync:      true,
			TransitionType:     "fade",
			TransitionDuration: 0.5,
			BackgroundMusic:    "auto_match",
			MusicVolume:        70,
			VoiceOverCharacter: "mila",
			AspectRatio:        "9:16",
			QualityTier:        "standard",
		}

		warnings, err := ValidateImageToVideoConfig(cfgValid)
		if err != nil {
			t.Fatalf("expected valid config, got error: %v", err)
		}
		if len(warnings) != 0 {
			t.Fatalf("expected no warnings for valid config, got: %v", warnings)
		}
	})

	t.Run("EF-03: Thumbnail Studio 5 template styles & 5-factor CTR mathematical breakdown", func(t *testing.T) {
		styles := []productionv1.ThumbnailTemplateStyle{
			productionv1.ThumbnailTemplateStyle_THUMBNAIL_TEMPLATE_STYLE_EMOTION,
			productionv1.ThumbnailTemplateStyle_THUMBNAIL_TEMPLATE_STYLE_YOUTUBE,
			productionv1.ThumbnailTemplateStyle_THUMBNAIL_TEMPLATE_STYLE_SPLIT,
			productionv1.ThumbnailTemplateStyle_THUMBNAIL_TEMPLATE_STYLE_CLICKBAIT,
			productionv1.ThumbnailTemplateStyle_THUMBNAIL_TEMPLATE_STYLE_CLEAN,
		}

		// Test exact formula: face(30%) + text(25%) + color(20%) + comp(15%) + trend(10%)
		// Example: 90*0.3 + 80*0.25 + 70*0.2 + 80*0.15 + 90*0.1 = 27 + 20 + 14 + 12 + 9 = 82.0 (High)
		b := CalculateCTRBreakdown(90, 80, 70, 80, 90)
		if b.TotalPredictedCtr != 82.0 {
			t.Fatalf("expected CTR score 82.0, got %.2f", b.TotalPredictedCtr)
		}
		if b.Level != "high" {
			t.Fatalf("expected level 'high', got %q", b.Level)
		}

		// Test medium level: 50*0.3 + 60*0.25 + 50*0.2 + 50*0.15 + 60*0.1 = 15 + 15 + 10 + 7.5 + 6 = 53.5
		bMed := CalculateCTRBreakdown(50, 60, 50, 50, 60)
		if bMed.Level != "medium" {
			t.Fatalf("expected level 'medium', got %q", bMed.Level)
		}

		// Test low level: 30*0.3 + 30*0.25 + 30*0.2 + 30*0.15 + 30*0.1 = 30.0
		bLow := CalculateCTRBreakdown(30, 30, 30, 30, 30)
		if bLow.Level != "low" {
			t.Fatalf("expected level 'low', got %q", bLow.Level)
		}

		for _, st := range styles {
			req := connect.NewRequest(&productionv1.GenerateThumbnailsRequest{
				Context: &commonv1.CommandContext{
					WorkspaceId: &commonv1.UUID{Value: wsID},
				},
				SourceImageUrl: "https://cdn.example.com/face_model.jpg",
				TemplateStyle:  st,
				VariantCount:   3,
				TextOverlay: &productionv1.TextOverlayConfig{
					Headline:   "5 SAI LẦM KHI CHĂM SÓC DA",
					FontFamily: "Bold Sans",
					FontSize:   48,
					FontColor:  "#FFFFFF",
					Position:   "center",
					Outline:    true,
					Shadow:     true,
				},
			})

			res, err := svc.AIService.GenerateThumbnails(ctxEditor, req)
			if err != nil {
				t.Fatalf("GenerateThumbnails failed for style %v: %v", st, err)
			}
			if len(res.Msg.GetVariants()) != 3 {
				t.Fatalf("expected 3 variants, got %d", len(res.Msg.GetVariants()))
			}
			for idx, v := range res.Msg.GetVariants() {
				if v.GetCtrBreakdown() == nil {
					t.Fatalf("variant %d missing CTR breakdown", idx)
				}
				if v.GetCtrBreakdown().GetTotalPredictedCtr() <= 0 {
					t.Fatalf("variant %d has invalid CTR score: %.2f", idx, v.GetCtrBreakdown().GetTotalPredictedCtr())
				}
			}
		}
	})

	t.Run("EF-04: Link-to-Video 5 script templates generation", func(t *testing.T) {
		templates := []productionv1.ScriptTemplate{
			productionv1.ScriptTemplate_SCRIPT_TEMPLATE_PROBLEM_SOLUTION,
			productionv1.ScriptTemplate_SCRIPT_TEMPLATE_LISTICLE_REVIEW,
			productionv1.ScriptTemplate_SCRIPT_TEMPLATE_TESTIMONIAL,
			productionv1.ScriptTemplate_SCRIPT_TEMPLATE_FLASH_SALE,
			productionv1.ScriptTemplate_SCRIPT_TEMPLATE_COMPARISON,
		}

		data := &productionv1.ScrapedProductData{
			Name:  "Tai nghe chống ồn Sony XM5",
			Price: "7.990.000 đ",
		}

		for _, tmpl := range templates {
			script := GenerateScriptFromTemplate(tmpl, data)
			if !strings.Contains(script, "Tai nghe chống ồn Sony XM5") {
				t.Fatalf("script for template %v does not contain product name: %s", tmpl, script)
			}
			if !strings.Contains(script, "[HOOK]") || !strings.Contains(script, "[CTA]") {
				t.Fatalf("script for template %v missing required [HOOK] or [CTA] markers: %s", tmpl, script)
			}
		}
	})
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: SSRF and unsafe source blocked
// ----------------------------------------------------------------------------

func TestAcceptanceTarget2_SSRFAndUnsafeSourceBlocked(t *testing.T) {
	svc, wsID := setupShowcaseTestService(t)
	ctxEditor := contextWithRole("Editor", "user-test-01")

	t.Run("SSRF IP and Scheme Rejections", func(t *testing.T) {
		unsafeURLs := []struct {
			url         string
			expectedErr error
			desc        string
		}{
			{"http://127.0.0.1/admin", ErrSSRFBlocked, "IPv4 loopback"},
			{"http://127.0.0.2:8080/metrics", ErrSSRFBlocked, "IPv4 loopback range"},
			{"http://localhost:3000/api", ErrSSRFBlocked, "localhost hostname"},
			{"http://sub.localhost/test", ErrSSRFBlocked, "subdomain of localhost"},
			{"http://10.0.0.1/secret", ErrSSRFBlocked, "RFC 1918 10/8 private network"},
			{"http://172.16.0.5/internal", ErrSSRFBlocked, "RFC 1918 172.16/12 private network"},
			{"http://192.168.1.1/router", ErrSSRFBlocked, "RFC 1918 192.168/16 private network"},
			{"http://169.254.169.254/latest/meta-data/", ErrSSRFBlocked, "AWS/GCP/Azure Cloud Metadata Service"},
			{"http://169.254.10.20/link-local", ErrSSRFBlocked, "Link-local unicast range"},
			{"http://0.0.0.0:8000/", ErrSSRFBlocked, "Current network 0.0.0.0/8"},
			{"http://100.64.0.1/cgnat", ErrSSRFBlocked, "Carrier-grade NAT"},
			{"http://255.255.255.255/broadcast", ErrSSRFBlocked, "Broadcast address"},
			{"http://metadata.google.internal/computeMetadata/v1/", ErrSSRFBlocked, "GCP internal metadata host"},
			{"http://[::1]/debug", ErrSSRFBlocked, "IPv6 loopback"},
			{"file:///etc/passwd", ErrInvalidURL, "Disallowed file scheme"},
			{"ftp://ftp.example.com/file", ErrInvalidURL, "Disallowed ftp scheme"},
			{"gopher://gopher.example.com/", ErrInvalidURL, "Disallowed gopher scheme"},
			{"javascript:alert(1)", ErrInvalidURL, "Disallowed javascript scheme"},
		}

		for _, tc := range unsafeURLs {
			_, err := ValidateSafeURL(tc.url)
			if err == nil {
				t.Fatalf("expected rejection for %s (%s), but got nil error", tc.url, tc.desc)
			}
			if tc.expectedErr != nil && !strings.Contains(err.Error(), tc.expectedErr.Error()) && err != tc.expectedErr {
				t.Fatalf("expected error containing %v for %s, got %v", tc.expectedErr, tc.url, err)
			}

			// Verify ConnectRPC Scrape call returns structured SSRF block
			req := connect.NewRequest(&productionv1.LinkToVideoServiceScrapeRequest{
				Context: &commonv1.CommandContext{
					WorkspaceId: &commonv1.UUID{Value: wsID},
				},
				Url: tc.url,
			})

			res, err := svc.LinkToVideo.Scrape(ctxEditor, req)
			if err != nil {
				t.Fatalf("Scrape unexpected transport failure for %s: %v", tc.url, err)
			}
			if res.Msg.GetSuccess() {
				t.Fatalf("Scrape should not succeed for unsafe URL: %s", tc.url)
			}
			if res.Msg.GetErrorCode() != "ERR_SSRF_BLOCKED" {
				t.Fatalf("expected ERR_SSRF_BLOCKED for %s, got code %q", tc.url, res.Msg.GetErrorCode())
			}
		}
	})

	t.Run("DRM and Geo-blocking Detection (EC-M07-R01)", func(t *testing.T) {
		drmURLs := []string{
			"https://www.netflix.com/title/80018499",
			"https://www.disneyplus.com/movies/sample/123",
			"https://hulu.com/watch/456",
		}

		for _, uStr := range drmURLs {
			parsed, _ := url.Parse(uStr)
			err := CheckDRMOrGeoBlocked(parsed)
			if err == nil || !strings.Contains(err.Error(), "DRM") {
				t.Fatalf("expected DRM detection for %s, got %v", uStr, err)
			}

			req := connect.NewRequest(&productionv1.LinkToVideoServiceScrapeRequest{
				Context: &commonv1.CommandContext{
					WorkspaceId: &commonv1.UUID{Value: wsID},
				},
				Url: uStr,
			})
			res, _ := svc.LinkToVideo.Scrape(ctxEditor, req)
			if res.Msg.GetSuccess() {
				t.Fatalf("DRM source should not succeed: %s", uStr)
			}
			if res.Msg.GetErrorCode() != "ERR_DRM_PROTECTED" {
				t.Fatalf("expected ERR_DRM_PROTECTED, got %q", res.Msg.GetErrorCode())
			}
			// Exact user message from EC-M07-R01
			expectedCopy := "Cannot access video at this URL. [Upload video file instead] or [Try different URL]."
			if res.Msg.GetErrorMessage() != expectedCopy {
				t.Fatalf("expected error message %q, got %q", expectedCopy, res.Msg.GetErrorMessage())
			}
		}
	})
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Missing product attributes explained
// ----------------------------------------------------------------------------

func TestAcceptanceTarget3_MissingProductAttributesExplained(t *testing.T) {
	svc, wsID := setupShowcaseTestService(t)
	ctxEditor := contextWithRole("Editor", "user-test-01")

	t.Run("Showcase: Missing photos, 360 spin with < 8 images, and missing description", func(t *testing.T) {
		// Case A: 0 images -> hard blocking
		ex0, blocked0 := ValidateProductAttributes(productionv1.ShowcaseStyle_SHOWCASE_STYLE_TABLETOP_DEMO, 0, "Mô tả", 100)
		if !blocked0 || len(ex0) == 0 || ex0[0].GetLevel() != "blocking" {
			t.Fatalf("expected 0 images to be blocking")
		}

		// Case B: 360 Spin with only 2 images -> blocking error requiring 8+ images
		ex360, blocked360 := ValidateProductAttributes(productionv1.ShowcaseStyle_SHOWCASE_STYLE_360_SPIN, 2, "Mô tả", 100)
		if !blocked360 {
			t.Fatalf("expected 360 spin with 2 images to be blocked")
		}
		found360Msg := false
		for _, e := range ex360 {
			if strings.Contains(e.GetMessage(), "Cần 8+ ảnh cho chế độ 360°") {
				found360Msg = true
			}
		}
		if !found360Msg {
			t.Fatalf("expected 'Cần 8+ ảnh cho chế độ 360°' explanation, got: %+v", ex360)
		}

		// Case C: 1 image -> warning to upload at least 4 photos
		ex1, blocked1 := ValidateProductAttributes(productionv1.ShowcaseStyle_SHOWCASE_STYLE_TABLETOP_DEMO, 1, "Mô tả", 100)
		if blocked1 {
			t.Fatalf("1 image should not hard-block standard demo style")
		}
		found4ImgWarn := false
		for _, e := range ex1 {
			if strings.Contains(e.GetMessage(), "Nên có ít nhất 4 ảnh cho showcase tốt nhất") {
				found4ImgWarn = true
			}
		}
		if !found4ImgWarn {
			t.Fatalf("expected 4-image recommendation warning, got %+v", ex1)
		}

		// Case D: Missing description -> explain auto-script disabled, prompt manual script
		exDesc, _ := ValidateProductAttributes(productionv1.ShowcaseStyle_SHOWCASE_STYLE_TABLETOP_DEMO, 4, "", 100)
		foundDescWarn := false
		for _, e := range exDesc {
			if strings.Contains(e.GetMessage(), "Sản phẩm chưa có mô tả chi tiết") {
				foundDescWarn = true
			}
		}
		if !foundDescWarn {
			t.Fatalf("expected missing description explanation, got %+v", exDesc)
		}

		// Case E: Missing/zero price -> explain price badge disabled
		exPrice, _ := ValidateProductAttributes(productionv1.ShowcaseStyle_SHOWCASE_STYLE_TABLETOP_DEMO, 4, "Mô tả", 0)
		foundPriceWarn := false
		for _, e := range exPrice {
			if strings.Contains(e.GetMessage(), "Chưa có thông tin giá sản phẩm") {
				foundPriceWarn = true
			}
		}
		if !foundPriceWarn {
			t.Fatalf("expected missing price explanation, got %+v", exPrice)
		}
	})

	t.Run("Batch Mode: 20-product batch with 1 invalid row allows confirming valid rows only", func(t *testing.T) {
		var batchItems []*productionv1.ProductShowcaseBatchItem

		// Create 20 items: 19 valid, 1 invalid (item 5 has 360 spin with only 2 images)
		for i := 0; i < 20; i++ {
			st := productionv1.ShowcaseStyle_SHOWCASE_STYLE_TABLETOP_DEMO
			imgs := []string{"https://cdn.example.com/p1.jpg", "https://cdn.example.com/p2.jpg"}
			if i == 5 {
				// Invalid item
				st = productionv1.ShowcaseStyle_SHOWCASE_STYLE_360_SPIN
				imgs = []string{"https://cdn.example.com/p1.jpg", "https://cdn.example.com/p2.jpg"}
			}
			batchItems = append(batchItems, &productionv1.ProductShowcaseBatchItem{
				ProductId:       "prod-batch",
				Style:           st,
				ManualImageUrls: imgs,
			})
		}

		// Preflight dry run
		reqDryRun := connect.NewRequest(&productionv1.ProductShowcaseServiceCreateBatchRequest{
			Context: &commonv1.CommandContext{
				WorkspaceId: &commonv1.UUID{Value: wsID},
			},
			Items:  batchItems,
			DryRun: true,
		})

		resDry, err := svc.ProductShowcase.CreateBatch(ctxEditor, reqDryRun)
		if err != nil {
			t.Fatalf("batch dry run failed: %v", err)
		}

		if resDry.Msg.GetTotalItems() != 20 {
			t.Fatalf("expected 20 total items, got %d", resDry.Msg.GetTotalItems())
		}
		if resDry.Msg.GetValidItems() != 19 {
			t.Fatalf("expected 19 valid items, got %d", resDry.Msg.GetValidItems())
		}
		if resDry.Msg.GetInvalidItems() != 1 {
			t.Fatalf("expected 1 invalid item, got %d", resDry.Msg.GetInvalidItems())
		}

		// Invalid row identified at index 5 with explanation
		item5 := resDry.Msg.GetResults()[5]
		if item5.GetValid() {
			t.Fatalf("item 5 should be invalid")
		}
		if !strings.Contains(item5.GetRejectionReason(), "Cần 8+ ảnh cho chế độ 360°") {
			t.Fatalf("item 5 rejection reason unexpected: %s", item5.GetRejectionReason())
		}
		if item5.GetCreditsRequired() != "0.000000" {
			t.Fatalf("invalid item must not be charged credits; got %s", item5.GetCreditsRequired())
		}
	})

	t.Run("Link-to-Video: Scraped product missing attributes explanation", func(t *testing.T) {
		testURL, _ := url.Parse("https://shopee.vn/product-skincare-serum-no-desc")
		scraped, missing := ExtractProductData(testURL, productionv1.LinkPlatform_LINK_PLATFORM_SHOPEE)

		if scraped.GetName() == "" {
			t.Fatalf("expected product name extracted")
		}
		if len(missing) == 0 {
			t.Fatalf("expected missing attributes detected for no-desc URL")
		}

		foundDescMsg := false
		for _, m := range missing {
			if m.GetAttribute() == "description" {
				foundDescMsg = true
			}
		}
		if !foundDescMsg {
			t.Fatalf("expected description missing attribute explanation")
		}
	})
}

// ----------------------------------------------------------------------------
// Permissions & Tenant Isolation
// ----------------------------------------------------------------------------

func TestShowcaseAndLinkToVideoPermissionsAndIsolation(t *testing.T) {
	svc, wsID := setupShowcaseTestService(t)
	ctxViewer := contextWithRole("Viewer", "user-test-02")
	ctxOtherTenant := contextWithRole("Editor", "user-test-03")

	t.Run("Viewer role cannot create showcase (Editor+ required)", func(t *testing.T) {
		req := connect.NewRequest(&productionv1.ProductShowcaseServiceCreateRequest{
			Context: &commonv1.CommandContext{
				WorkspaceId: &commonv1.UUID{Value: wsID},
			},
			ProductId: "prod-001",
		})
		_, err := svc.ProductShowcase.Create(ctxViewer, req)
		if err == nil {
			t.Fatalf("expected permission denied for Viewer role")
		}
	})

	t.Run("Viewer role cannot scrape link-to-video (Editor+ required)", func(t *testing.T) {
		req := connect.NewRequest(&productionv1.LinkToVideoServiceScrapeRequest{
			Context: &commonv1.CommandContext{
				WorkspaceId: &commonv1.UUID{Value: wsID},
			},
			Url: "https://shopee.vn/product/123",
		})
		_, err := svc.LinkToVideo.Scrape(ctxViewer, req)
		if err == nil {
			t.Fatalf("expected permission denied for Viewer role on Scrape")
		}
	})

	t.Run("Cross-tenant isolation: Cannot read jobs from another workspace", func(t *testing.T) {
		// Create job in wsID
		rec := &ProductShowcaseJobRecord{
			ShowcaseJobID: "psj-isolated-01",
			WorkspaceID:   wsID,
			Style:         "tabletop_demo",
			Status:        "queued",
			CreditsUsed:   tenantdb.MustParseExactDecimal("15.000000"),
		}
		_ = svc.store.CreateShowcaseJob(context.Background(), rec)

		// Try to read from other tenant
		reqGet := connect.NewRequest(&productionv1.ProductShowcaseServiceGetRequest{
			WorkspaceId:   &commonv1.UUID{Value: "99999999-9999-9999-9999-999999999999"},
			ShowcaseJobId: "psj-isolated-01",
		})
		_, err := svc.ProductShowcase.Get(ctxOtherTenant, reqGet)
		if err == nil {
			t.Fatalf("expected cross-tenant access to be blocked with NotFound or Denied")
		}
	})
}
