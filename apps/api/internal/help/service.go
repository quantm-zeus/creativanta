// Package help implements the Knowledge Base (M01/help) and Internal Admin Help Center (S26)
// services per docs/02_features/platform/help_center.md and database_schema.md §17.9A-§17.9D.
package help

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1/adminv1connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	ErrUnauthenticated  = errors.New("help: unauthenticated caller")
	ErrAdminRequired    = errors.New("help: internal admin authentication required (S26)")
	ErrArticleNotFound  = errors.New("help: article not found")
	ErrCategoryNotFound = errors.New("help: category not found")
	ErrInvalidInput     = errors.New("help: invalid input parameters")
)

// CallerContext models the authenticated caller context.
type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string
	IsAdmin       bool
	AdminRole     string
}

type callerCtxKey struct{}

// WithCallerContext attaches CallerContext to ctx.
func WithCallerContext(ctx context.Context, caller CallerContext) context.Context {
	return context.WithValue(ctx, callerCtxKey{}, caller)
}

// CallerFromContext extracts CallerContext from ctx.
func CallerFromContext(ctx context.Context) (CallerContext, bool) {
	if ctx == nil {
		return CallerContext{}, false
	}
	c, ok := ctx.Value(callerCtxKey{}).(CallerContext)
	return c, ok
}

// StoredCategory models kb_categories (§17.9A).
type StoredCategory struct {
	CategoryID  string
	Slug        string
	DisplayName string
	Description string
	IconKey     string
	SortOrder   int32
	IsActive    bool
}

// StoredArticle models kb_articles (§17.9B).
type StoredArticle struct {
	ArticleID            string
	CategoryID           string
	Slug                 string
	Locale               string
	Title                string
	Summary              string
	BodyMarkdown         string
	Status               adminv1.KBArticleStatus
	ArticleType          adminv1.KBArticleType
	TargetModules        []string
	TargetOperatorModes  []string
	TargetTiers          []string
	Tags                 []string
	RelatedArticleIDs    []string
	EstimatedReadMinutes int32
	HelpfulVotes         int32
	UnhelpfulVotes       int32
	ViewCount            int32
	LastReviewedAt       time.Time
	PublishedAt          *time.Time
	ArchivedAt           *time.Time
	Versions             []StoredArticleVersion
}

// StoredArticleVersion models kb_article_versions (§17.9C).
type StoredArticleVersion struct {
	VersionNumber int32
	Title         string
	Summary       string
	BodyMarkdown  string
	ChangeNote    string
	CreatedAt     time.Time
}

// StoredRating models article_ratings (§17.9D).
type StoredRating struct {
	RatingID     string
	ArticleID    string
	UserID       string
	Helpful      bool
	FeedbackText string
	CreatedAt    time.Time
}

// Store holds the shared in-memory data for KB articles and categories.
type Store struct {
	mu         sync.RWMutex
	categories map[string]*StoredCategory
	articles   map[string]*StoredArticle
	ratings    map[string]*StoredRating
}

func newStore() *Store {
	st := &Store{
		categories: make(map[string]*StoredCategory),
		articles:   make(map[string]*StoredArticle),
		ratings:    make(map[string]*StoredRating),
	}
	st.seedCanonicalKB()
	return st
}

func (st *Store) seedCanonicalKB() {
	catGettingStarted := &StoredCategory{
		CategoryID:  "cat-getting-started",
		Slug:        "getting-started",
		DisplayName: "Bắt đầu sử dụng",
		Description: "Hướng dẫn thiết lập ban đầu và quy trình 5 bước theo chế độ vận hành.",
		IconKey:     "rocket",
		SortOrder:   1,
		IsActive:    true,
	}
	catContent := &StoredCategory{
		CategoryID:  "cat-content-creation",
		Slug:        "content-creation",
		DisplayName: "Sáng tạo nội dung & AI Video",
		Description: "Hướng dẫn Script Lab, AI Video Studio, Continuity OS và đóng gói.",
		IconKey:     "video",
		SortOrder:   2,
		IsActive:    true,
	}
	catCommerce := &StoredCategory{
		CategoryID:  "cat-commerce-finance",
		Slug:        "commerce-finance",
		DisplayName: "Kinh doanh & Tài chính",
		Description: "Đơn hàng, đối soát lợi nhuận thực tế và quản lý lot tín dụng AI.",
		IconKey:     "currency-dollar",
		SortOrder:   3,
		IsActive:    true,
	}
	catTroubleshoot := &StoredCategory{
		CategoryID:  "cat-troubleshooting",
		Slug:        "troubleshooting",
		DisplayName: "Khắc phục sự cố",
		Description: "Chẩn đoán lỗi xuất bản, hết hạn token mạng xã hội và phục hồi luồng việc.",
		IconKey:     "wrench",
		SortOrder:   4,
		IsActive:    true,
	}

	st.categories[catGettingStarted.CategoryID] = catGettingStarted
	st.categories[catContent.CategoryID] = catContent
	st.categories[catCommerce.CategoryID] = catCommerce
	st.categories[catTroubleshoot.CategoryID] = catTroubleshoot

	now := time.Now().UTC()
	pubTime := now.Add(-10 * 24 * time.Hour)
	staleTime := now.Add(-95 * 24 * time.Hour) // >90 days ago for stale testing

	// Article 1: M01 Getting started
	art1 := &StoredArticle{
		ArticleID:            "art-m01-getting-started",
		CategoryID:           catGettingStarted.CategoryID,
		Slug:                 "huong-dan-5-buoc-khoi-dong",
		Locale:               "vi-VN",
		Title:                "Quy trình 5 bước khép kín vòng vận hành Creativanta",
		Summary:              "Kết nối dữ liệu, chọn sản phẩm, sáng tạo kịch bản/video, xuất bản và đo lường doanh thu.",
		BodyMarkdown:         "## Vòng lặp vận hành 5 bước\n1. Kết nối kênh hoặc nhập file CSV.\n2. Chọn sản phẩm kinh doanh.\n3. Tạo kịch bản và video AI.\n4. Xuất bản đa kênh.\n5. Đo lường doanh thu và lợi nhuận thực tế.",
		Status:               adminv1.KBArticleStatus_KB_ARTICLE_STATUS_PUBLISHED,
		ArticleType:          adminv1.KBArticleType_KB_ARTICLE_TYPE_GETTING_STARTED,
		TargetModules:        []string{"M01", "M22"},
		TargetOperatorModes:  []string{"creator", "seller", "affiliate_operator"},
		Tags:                 []string{"onboarding", "5-steps", "setup"},
		EstimatedReadMinutes: 4,
		HelpfulVotes:         15,
		UnhelpfulVotes:       1,
		ViewCount:            120,
		LastReviewedAt:       now.Add(-15 * 24 * time.Hour),
		PublishedAt:          &pubTime,
	}

	// Article 2: M07 AI Video Studio Guide
	art2 := &StoredArticle{
		ArticleID:            "art-m07-ai-studio",
		CategoryID:           catContent.CategoryID,
		Slug:                 "tao-video-ban-hang-voi-ai-video-studio",
		Locale:               "vi-VN",
		Title:                "Hướng dẫn tạo video bán hàng tự động bằng AI Video Studio (M07)",
		Summary:              "Sử dụng Continuity OS và mô hình AI để sản xuất hàng loạt video ngắn chuẩn sàn TMĐT.",
		BodyMarkdown:         "## Tạo video bán hàng\n- Bước 1: Chọn sản phẩm từ Product Hub.\n- Bước 2: Chọn phong cách kịch bản (review, unbox, kể chuyện).\n- Bước 3: Tạo và tinh chỉnh giọng đọc/hình ảnh với gói tính cách nhất quán (Continuity OS).",
		Status:               adminv1.KBArticleStatus_KB_ARTICLE_STATUS_PUBLISHED,
		ArticleType:          adminv1.KBArticleType_KB_ARTICLE_TYPE_HOW_TO,
		TargetModules:        []string{"M07", "M08"},
		TargetOperatorModes:  []string{"creator", "seller"},
		Tags:                 []string{"ai-video", "continuity", "m07"},
		EstimatedReadMinutes: 6,
		HelpfulVotes:         28,
		UnhelpfulVotes:       2,
		ViewCount:            340,
		LastReviewedAt:       now.Add(-20 * 24 * time.Hour),
		PublishedAt:          &pubTime,
	}

	// Article 3: Stale Article for 90-day review verification (AC 2 / help_center.md §2.4)
	art3 := &StoredArticle{
		ArticleID:            "art-m22-token-expired",
		CategoryID:           catTroubleshoot.CategoryID,
		Slug:                 "khac-phuc-loi-token-tiktok-shop-het-han",
		Locale:               "vi-VN",
		Title:                "Khắc phục lỗi mất kết nối Token TikTok Shop / Shopee",
		Summary:              "Hướng dẫn cấp lại quyền OAuth khi connector báo trạng thái degraded hoặc expired.",
		BodyMarkdown:         "## Khắc phục token hết hạn\nTruy cập Cài đặt > Kết nối nền tảng (Settings > Connections), bấm Kết nối lại để xác thực lại token OAuth.",
		Status:               adminv1.KBArticleStatus_KB_ARTICLE_STATUS_PUBLISHED,
		ArticleType:          adminv1.KBArticleType_KB_ARTICLE_TYPE_TROUBLESHOOTING,
		TargetModules:        []string{"M22", "M23"},
		TargetOperatorModes:  []string{"seller", "creator"},
		Tags:                 []string{"connector", "oauth", "repair"},
		EstimatedReadMinutes: 3,
		HelpfulVotes:         8,
		UnhelpfulVotes:       0,
		ViewCount:            95,
		LastReviewedAt:       staleTime, // 95 days ago -> STALE!
		PublishedAt:          &pubTime,
	}

	st.articles[art1.ArticleID] = art1
	st.articles[art2.ArticleID] = art2
	st.articles[art3.ArticleID] = art3
}

// Service implements user-facing KBServiceHandler.
type Service struct {
	adminv1connect.UnimplementedKBServiceHandler
	store    *Store
	admin    *AdminService
	bindings *rbac.Registry
}

// AdminService implements internal ops KBAdminServiceHandler.
type AdminService struct {
	adminv1connect.UnimplementedKBAdminServiceHandler
	store    *Store
	bindings *rbac.Registry
}

// NewService creates a new Help Center service pair.
func NewService(bindings *rbac.Registry) *Service {
	st := newStore()
	adminSvc := &AdminService{
		store:    st,
		bindings: bindings,
	}
	return &Service{
		store:    st,
		admin:    adminSvc,
		bindings: bindings,
	}
}

// Admin returns the corresponding KBAdminServiceHandler.
func (s *Service) Admin() *AdminService {
	return s.admin
}

// -----------------------------------------------------------------------------
// KBService (User Facing)
// -----------------------------------------------------------------------------

// Search implements KBService/Search.
func (s *Service) Search(
	ctx context.Context,
	req *connect.Request[adminv1.SearchRequest],
) (*connect.Response[adminv1.SearchResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	s.store.mu.RLock()
	defer s.store.mu.RUnlock()

	query := strings.ToLower(strings.TrimSpace(msg.Query))
	moduleFilter := strings.ToUpper(strings.TrimSpace(msg.ModuleFilter))
	modeFilter := strings.ToLower(strings.TrimSpace(msg.OperatorModeFilter))
	targetLocale := msg.Locale
	if targetLocale == "" {
		targetLocale = "vi-VN"
	}

	now := time.Now().UTC()
	var matched []*adminv1.KBArticleSummary

	for _, a := range s.store.articles {
		if a.Status != adminv1.KBArticleStatus_KB_ARTICLE_STATUS_PUBLISHED {
			continue
		}
		if msg.Locale != "" && a.Locale != targetLocale {
			continue
		}
		if msg.CategoryId != nil && msg.CategoryId.Value != "" && a.CategoryID != msg.CategoryId.Value {
			continue
		}

		if moduleFilter != "" {
			found := false
			for _, m := range a.TargetModules {
				if strings.ToUpper(m) == moduleFilter {
					found = true
					break
				}
			}
			if !found {
				continue
			}
		}

		if modeFilter != "" {
			found := false
			for _, om := range a.TargetOperatorModes {
				if strings.ToLower(om) == modeFilter {
					found = true
					break
				}
			}
			if !found {
				continue
			}
		}

		if query != "" {
			titleMatch := strings.Contains(strings.ToLower(a.Title), query)
			summaryMatch := strings.Contains(strings.ToLower(a.Summary), query)
			tagMatch := false
			for _, t := range a.Tags {
				if strings.Contains(strings.ToLower(t), query) {
					tagMatch = true
					break
				}
			}
			if !titleMatch && !summaryMatch && !tagMatch {
				continue
			}
		}

		isStale := now.Sub(a.LastReviewedAt) > 90*24*time.Hour
		summary := &adminv1.KBArticleSummary{
			ArticleId:            &commonv1.UUID{Value: a.ArticleID},
			CategoryId:           &commonv1.UUID{Value: a.CategoryID},
			Slug:                 a.Slug,
			Locale:               a.Locale,
			Title:                a.Title,
			Summary:              a.Summary,
			Status:               a.Status,
			ArticleType:          a.ArticleType,
			TargetModules:        a.TargetModules,
			TargetOperatorModes:  a.TargetOperatorModes,
			Tags:                 a.Tags,
			EstimatedReadMinutes: a.EstimatedReadMinutes,
			HelpfulVotes:         a.HelpfulVotes,
			UnhelpfulVotes:       a.UnhelpfulVotes,
			ViewCount:            a.ViewCount,
			LastReviewedAt:       timestamppb.New(a.LastReviewedAt),
			IsStaleForReview:     isStale,
		}
		if a.PublishedAt != nil {
			summary.PublishedAt = timestamppb.New(*a.PublishedAt)
		}
		matched = append(matched, summary)
	}

	return connect.NewResponse(&adminv1.SearchResponse{
		Articles: matched,
		Pagination: &commonv1.PaginatedResponse{
			HasMore: false,
		},
	}), nil
}

// GetCategories implements KBService/GetCategories.
func (s *Service) GetCategories(
	ctx context.Context,
	req *connect.Request[adminv1.GetCategoriesRequest],
) (*connect.Response[adminv1.GetCategoriesResponse], error) {
	s.store.mu.RLock()
	defer s.store.mu.RUnlock()

	var categories []*adminv1.KBCategory
	for _, c := range s.store.categories {
		if req.Msg != nil && req.Msg.ActiveOnly && !c.IsActive {
			continue
		}
		count := int32(0)
		for _, a := range s.store.articles {
			if a.CategoryID == c.CategoryID && a.Status == adminv1.KBArticleStatus_KB_ARTICLE_STATUS_PUBLISHED {
				count++
			}
		}
		categories = append(categories, &adminv1.KBCategory{
			CategoryId:   &commonv1.UUID{Value: c.CategoryID},
			Slug:         c.Slug,
			DisplayName:  c.DisplayName,
			Description:  c.Description,
			IconKey:      c.IconKey,
			SortOrder:    c.SortOrder,
			IsActive:     c.IsActive,
			ArticleCount: count,
		})
	}

	return connect.NewResponse(&adminv1.GetCategoriesResponse{
		Categories: categories,
	}), nil
}

// GetArticle implements KBService/GetArticle.
func (s *Service) GetArticle(
	ctx context.Context,
	req *connect.Request[adminv1.GetArticleRequest],
) (*connect.Response[adminv1.GetArticleResponse], error) {
	msg := req.Msg
	if msg == nil || msg.SlugOrId == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	var found *StoredArticle
	for _, a := range s.store.articles {
		if a.ArticleID == msg.SlugOrId || a.Slug == msg.SlugOrId {
			if msg.Locale == "" || a.Locale == msg.Locale {
				found = a
				break
			}
		}
	}

	if found == nil || found.Status != adminv1.KBArticleStatus_KB_ARTICLE_STATUS_PUBLISHED {
		return nil, connect.NewError(connect.CodeNotFound, ErrArticleNotFound)
	}

	found.ViewCount++

	isStale := time.Now().UTC().Sub(found.LastReviewedAt) > 90*24*time.Hour
	summary := &adminv1.KBArticleSummary{
		ArticleId:            &commonv1.UUID{Value: found.ArticleID},
		CategoryId:           &commonv1.UUID{Value: found.CategoryID},
		Slug:                 found.Slug,
		Locale:               found.Locale,
		Title:                found.Title,
		Summary:              found.Summary,
		Status:               found.Status,
		ArticleType:          found.ArticleType,
		TargetModules:        found.TargetModules,
		TargetOperatorModes:  found.TargetOperatorModes,
		Tags:                 found.Tags,
		EstimatedReadMinutes: found.EstimatedReadMinutes,
		HelpfulVotes:         found.HelpfulVotes,
		UnhelpfulVotes:       found.UnhelpfulVotes,
		ViewCount:            found.ViewCount,
		LastReviewedAt:       timestamppb.New(found.LastReviewedAt),
		IsStaleForReview:     isStale,
	}
	if found.PublishedAt != nil {
		summary.PublishedAt = timestamppb.New(*found.PublishedAt)
	}

	return connect.NewResponse(&adminv1.GetArticleResponse{
		Article: &adminv1.KBArticleDetail{
			Summary:      summary,
			BodyMarkdown: found.BodyMarkdown,
		},
	}), nil
}

// RateArticle implements KBService/RateArticle.
func (s *Service) RateArticle(
	ctx context.Context,
	req *connect.Request[adminv1.RateArticleRequest],
) (*connect.Response[adminv1.RateArticleResponse], error) {
	msg := req.Msg
	if msg == nil || msg.ArticleId == nil || msg.ArticleId.Value == "" || msg.UserId == nil || msg.UserId.Value == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	art, exists := s.store.articles[msg.ArticleId.Value]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrArticleNotFound)
	}

	key := msg.ArticleId.Value + ":" + msg.UserId.Value
	existing, alreadyRated := s.store.ratings[key]

	if alreadyRated {
		if existing.Helpful && !msg.Helpful {
			art.HelpfulVotes--
			art.UnhelpfulVotes++
		} else if !existing.Helpful && msg.Helpful {
			art.UnhelpfulVotes--
			art.HelpfulVotes++
		}
		existing.Helpful = msg.Helpful
		existing.FeedbackText = msg.FeedbackText
	} else {
		if msg.Helpful {
			art.HelpfulVotes++
		} else {
			art.UnhelpfulVotes++
		}
		s.store.ratings[key] = &StoredRating{
			RatingID:     generateUUID(),
			ArticleID:    msg.ArticleId.Value,
			UserID:       msg.UserId.Value,
			Helpful:      msg.Helpful,
			FeedbackText: msg.FeedbackText,
			CreatedAt:    time.Now().UTC(),
		}
	}

	return connect.NewResponse(&adminv1.RateArticleResponse{
		Success:        true,
		HelpfulVotes:   art.HelpfulVotes,
		UnhelpfulVotes: art.UnhelpfulVotes,
	}), nil
}

// ListRecent implements KBService/ListRecent.
func (s *Service) ListRecent(
	ctx context.Context,
	req *connect.Request[adminv1.ListRecentRequest],
) (*connect.Response[adminv1.ListRecentResponse], error) {
	s.store.mu.RLock()
	defer s.store.mu.RUnlock()

	limit := 5
	if req.Msg != nil && req.Msg.Limit > 0 {
		limit = int(req.Msg.Limit)
	}

	var published []*StoredArticle
	for _, a := range s.store.articles {
		if a.Status == adminv1.KBArticleStatus_KB_ARTICLE_STATUS_PUBLISHED {
			published = append(published, a)
		}
	}

	now := time.Now().UTC()
	var summaries []*adminv1.KBArticleSummary
	for i, a := range published {
		if i >= limit {
			break
		}
		isStale := now.Sub(a.LastReviewedAt) > 90*24*time.Hour
		summaries = append(summaries, &adminv1.KBArticleSummary{
			ArticleId:        &commonv1.UUID{Value: a.ArticleID},
			CategoryId:       &commonv1.UUID{Value: a.CategoryID},
			Slug:             a.Slug,
			Locale:           a.Locale,
			Title:            a.Title,
			Summary:          a.Summary,
			Status:           a.Status,
			ArticleType:      a.ArticleType,
			TargetModules:    a.TargetModules,
			HelpfulVotes:     a.HelpfulVotes,
			UnhelpfulVotes:   a.UnhelpfulVotes,
			ViewCount:        a.ViewCount,
			LastReviewedAt:   timestamppb.New(a.LastReviewedAt),
			IsStaleForReview: isStale,
		})
	}

	return connect.NewResponse(&adminv1.ListRecentResponse{
		Articles: summaries,
	}), nil
}

// -----------------------------------------------------------------------------
// KBAdminService (Internal Admin S26 Facing)
// -----------------------------------------------------------------------------

func (s *AdminService) validateAdminCaller(ctx context.Context) (CallerContext, error) {
	caller, ok := CallerFromContext(ctx)
	if !ok || !caller.IsAdmin {
		return CallerContext{}, connect.NewError(connect.CodePermissionDenied, ErrAdminRequired)
	}
	return caller, nil
}

// ListArticles implements KBAdminService/ListArticles.
func (s *AdminService) ListArticles(
	ctx context.Context,
	req *connect.Request[adminv1.ListArticlesRequest],
) (*connect.Response[adminv1.ListArticlesResponse], error) {
	if _, err := s.validateAdminCaller(ctx); err != nil {
		return nil, err
	}

	s.store.mu.RLock()
	defer s.store.mu.RUnlock()

	now := time.Now().UTC()
	var items []*adminv1.KBArticleSummary
	totalStale := int32(0)

	for _, a := range s.store.articles {
		isStale := now.Sub(a.LastReviewedAt) > 90*24*time.Hour
		if isStale {
			totalStale++
		}
		if req.Msg != nil {
			if req.Msg.StatusFilter != adminv1.KBArticleStatus_KB_ARTICLE_STATUS_UNSPECIFIED && a.Status != req.Msg.StatusFilter {
				continue
			}
			if req.Msg.TypeFilter != adminv1.KBArticleType_KB_ARTICLE_TYPE_UNSPECIFIED && a.ArticleType != req.Msg.TypeFilter {
				continue
			}
			if req.Msg.StaleOnly && !isStale {
				continue
			}
		}

		item := &adminv1.KBArticleSummary{
			ArticleId:        &commonv1.UUID{Value: a.ArticleID},
			CategoryId:       &commonv1.UUID{Value: a.CategoryID},
			Slug:             a.Slug,
			Locale:           a.Locale,
			Title:            a.Title,
			Summary:          a.Summary,
			Status:           a.Status,
			ArticleType:      a.ArticleType,
			TargetModules:    a.TargetModules,
			HelpfulVotes:     a.HelpfulVotes,
			UnhelpfulVotes:   a.UnhelpfulVotes,
			ViewCount:        a.ViewCount,
			LastReviewedAt:   timestamppb.New(a.LastReviewedAt),
			IsStaleForReview: isStale,
		}
		if a.PublishedAt != nil {
			item.PublishedAt = timestamppb.New(*a.PublishedAt)
		}
		items = append(items, item)
	}

	return connect.NewResponse(&adminv1.ListArticlesResponse{
		Articles:        items,
		TotalStaleCount: totalStale,
		Pagination: &commonv1.PaginatedResponse{
			HasMore: false,
		},
	}), nil
}

// GetArticle implements KBAdminService/GetArticle.
func (s *AdminService) GetArticle(
	ctx context.Context,
	req *connect.Request[adminv1.KBAdminServiceGetArticleRequest],
) (*connect.Response[adminv1.KBAdminServiceGetArticleResponse], error) {
	if _, err := s.validateAdminCaller(ctx); err != nil {
		return nil, err
	}
	if req.Msg == nil || req.Msg.ArticleId == nil || req.Msg.ArticleId.Value == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	s.store.mu.RLock()
	defer s.store.mu.RUnlock()

	art, exists := s.store.articles[req.Msg.ArticleId.Value]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrArticleNotFound)
	}

	isStale := time.Now().UTC().Sub(art.LastReviewedAt) > 90*24*time.Hour
	return connect.NewResponse(&adminv1.KBAdminServiceGetArticleResponse{
		Article: &adminv1.KBArticleDetail{
			Summary: &adminv1.KBArticleSummary{
				ArticleId:        &commonv1.UUID{Value: art.ArticleID},
				CategoryId:       &commonv1.UUID{Value: art.CategoryID},
				Slug:             art.Slug,
				Locale:           art.Locale,
				Title:            art.Title,
				Summary:          art.Summary,
				Status:           art.Status,
				ArticleType:      art.ArticleType,
				TargetModules:    art.TargetModules,
				HelpfulVotes:     art.HelpfulVotes,
				UnhelpfulVotes:   art.UnhelpfulVotes,
				ViewCount:        art.ViewCount,
				LastReviewedAt:   timestamppb.New(art.LastReviewedAt),
				IsStaleForReview: isStale,
			},
			BodyMarkdown: art.BodyMarkdown,
		},
	}), nil
}

// CreateArticle implements KBAdminService/CreateArticle.
func (s *AdminService) CreateArticle(
	ctx context.Context,
	req *connect.Request[adminv1.CreateArticleRequest],
) (*connect.Response[adminv1.CreateArticleResponse], error) {
	if _, err := s.validateAdminCaller(ctx); err != nil {
		return nil, err
	}
	msg := req.Msg
	if msg == nil || msg.Title == "" || msg.Slug == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	now := time.Now().UTC()
	id := generateUUID()

	art := &StoredArticle{
		ArticleID:            id,
		CategoryID:           msg.CategoryId.GetValue(),
		Slug:                 msg.Slug,
		Locale:               msg.Locale,
		Title:                msg.Title,
		Summary:              msg.Summary,
		BodyMarkdown:         msg.BodyMarkdown,
		Status:               adminv1.KBArticleStatus_KB_ARTICLE_STATUS_DRAFT,
		ArticleType:          msg.ArticleType,
		TargetModules:        msg.TargetModules,
		TargetOperatorModes:  msg.TargetOperatorModes,
		Tags:                 msg.Tags,
		EstimatedReadMinutes: msg.EstimatedReadMinutes,
		LastReviewedAt:       now,
	}

	s.store.mu.Lock()
	s.store.articles[id] = art
	s.store.mu.Unlock()

	return connect.NewResponse(&adminv1.CreateArticleResponse{
		Article: &adminv1.KBArticleDetail{
			Summary: &adminv1.KBArticleSummary{
				ArticleId:      &commonv1.UUID{Value: id},
				CategoryId:     msg.CategoryId,
				Slug:           art.Slug,
				Locale:         art.Locale,
				Title:          art.Title,
				Summary:        art.Summary,
				Status:         art.Status,
				ArticleType:    art.ArticleType,
				LastReviewedAt: timestamppb.New(now),
			},
			BodyMarkdown: art.BodyMarkdown,
		},
	}), nil
}

// UpdateArticle implements KBAdminService/UpdateArticle.
func (s *AdminService) UpdateArticle(
	ctx context.Context,
	req *connect.Request[adminv1.UpdateArticleRequest],
) (*connect.Response[adminv1.UpdateArticleResponse], error) {
	if _, err := s.validateAdminCaller(ctx); err != nil {
		return nil, err
	}
	msg := req.Msg
	if msg == nil || msg.ArticleId == nil || msg.ArticleId.Value == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	art, exists := s.store.articles[msg.ArticleId.Value]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrArticleNotFound)
	}

	now := time.Now().UTC()
	art.Versions = append(art.Versions, StoredArticleVersion{
		VersionNumber: int32(len(art.Versions) + 1),
		Title:         art.Title,
		Summary:       art.Summary,
		BodyMarkdown:  art.BodyMarkdown,
		ChangeNote:    msg.ChangeNote,
		CreatedAt:     now,
	})

	art.Title = msg.Title
	art.Summary = msg.Summary
	art.BodyMarkdown = msg.BodyMarkdown
	art.ArticleType = msg.ArticleType
	art.TargetModules = msg.TargetModules
	art.TargetOperatorModes = msg.TargetOperatorModes
	art.Tags = msg.Tags
	art.EstimatedReadMinutes = msg.EstimatedReadMinutes
	art.LastReviewedAt = now

	return connect.NewResponse(&adminv1.UpdateArticleResponse{
		Article: &adminv1.KBArticleDetail{
			Summary: &adminv1.KBArticleSummary{
				ArticleId:      msg.ArticleId,
				Slug:           art.Slug,
				Title:          art.Title,
				Summary:        art.Summary,
				Status:         art.Status,
				LastReviewedAt: timestamppb.New(now),
			},
			BodyMarkdown: art.BodyMarkdown,
		},
	}), nil
}

// PublishArticle implements KBAdminService/PublishArticle.
func (s *AdminService) PublishArticle(
	ctx context.Context,
	req *connect.Request[adminv1.PublishArticleRequest],
) (*connect.Response[adminv1.PublishArticleResponse], error) {
	if _, err := s.validateAdminCaller(ctx); err != nil {
		return nil, err
	}
	if req.Msg == nil || req.Msg.ArticleId == nil || req.Msg.ArticleId.Value == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	art, exists := s.store.articles[req.Msg.ArticleId.Value]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrArticleNotFound)
	}

	now := time.Now().UTC()
	art.Status = adminv1.KBArticleStatus_KB_ARTICLE_STATUS_PUBLISHED
	art.PublishedAt = &now
	art.LastReviewedAt = now

	return connect.NewResponse(&adminv1.PublishArticleResponse{
		Article: &adminv1.KBArticleDetail{
			Summary: &adminv1.KBArticleSummary{
				ArticleId:      req.Msg.ArticleId,
				Slug:           art.Slug,
				Title:          art.Title,
				Status:         art.Status,
				PublishedAt:    timestamppb.New(now),
				LastReviewedAt: timestamppb.New(now),
			},
			BodyMarkdown: art.BodyMarkdown,
		},
	}), nil
}

// ArchiveArticle implements KBAdminService/ArchiveArticle.
func (s *AdminService) ArchiveArticle(
	ctx context.Context,
	req *connect.Request[adminv1.ArchiveArticleRequest],
) (*connect.Response[adminv1.ArchiveArticleResponse], error) {
	if _, err := s.validateAdminCaller(ctx); err != nil {
		return nil, err
	}
	if req.Msg == nil || req.Msg.ArticleId == nil || req.Msg.ArticleId.Value == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	art, exists := s.store.articles[req.Msg.ArticleId.Value]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrArticleNotFound)
	}

	now := time.Now().UTC()
	art.Status = adminv1.KBArticleStatus_KB_ARTICLE_STATUS_ARCHIVED
	art.ArchivedAt = &now

	return connect.NewResponse(&adminv1.ArchiveArticleResponse{
		Success: true,
	}), nil
}

// ListStaleArticles implements KBAdminService/ListStaleArticles.
func (s *AdminService) ListStaleArticles(
	ctx context.Context,
	req *connect.Request[adminv1.ListStaleArticlesRequest],
) (*connect.Response[adminv1.ListStaleArticlesResponse], error) {
	if _, err := s.validateAdminCaller(ctx); err != nil {
		return nil, err
	}

	days := 90
	if req.Msg != nil && req.Msg.DaysThreshold > 0 {
		days = int(req.Msg.DaysThreshold)
	}

	s.store.mu.RLock()
	defer s.store.mu.RUnlock()

	cutoff := time.Now().UTC().Add(-time.Duration(days) * 24 * time.Hour)
	var stales []*adminv1.KBArticleSummary

	for _, a := range s.store.articles {
		if a.LastReviewedAt.Before(cutoff) {
			stales = append(stales, &adminv1.KBArticleSummary{
				ArticleId:        &commonv1.UUID{Value: a.ArticleID},
				CategoryId:       &commonv1.UUID{Value: a.CategoryID},
				Slug:             a.Slug,
				Locale:           a.Locale,
				Title:            a.Title,
				Summary:          a.Summary,
				Status:           a.Status,
				ArticleType:      a.ArticleType,
				TargetModules:    a.TargetModules,
				LastReviewedAt:   timestamppb.New(a.LastReviewedAt),
				IsStaleForReview: true,
			})
		}
	}

	return connect.NewResponse(&adminv1.ListStaleArticlesResponse{
		StaleArticles: stales,
		StaleCount:    int32(len(stales)),
		Pagination: &commonv1.PaginatedResponse{
			HasMore: false,
		},
	}), nil
}

func generateUUID() string {
	b := make([]byte, 16)
	_, _ = rand.Read(b)
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%s-%s-%s-%s-%s",
		hex.EncodeToString(b[0:4]),
		hex.EncodeToString(b[4:6]),
		hex.EncodeToString(b[6:8]),
		hex.EncodeToString(b[8:10]),
		hex.EncodeToString(b[10:16]),
	)
}
