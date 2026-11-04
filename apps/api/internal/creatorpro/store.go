package creatorpro

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"sort"
	"strings"
	"sync"
	"time"
)

// Store defines persistence operations for Creator Pro Tools (S16 & M16).
type Store interface {
	// Link-in-Bio Pages
	CreatePage(ctx context.Context, page *LinkInBioPage) error
	GetPage(ctx context.Context, workspaceID, pageID string) (*LinkInBioPage, error)
	GetPageBySlug(ctx context.Context, slug string) (*LinkInBioPage, error)
	UpdatePage(ctx context.Context, page *LinkInBioPage) error
	ListPages(ctx context.Context, workspaceID string) ([]LinkInBioPage, error)

	// Link-in-Bio Items & Security Scanning
	CreateLinkItem(ctx context.Context, item *LinkItem) error
	GetLinkItem(ctx context.Context, workspaceID, itemID string) (*LinkItem, error)
	ListLinkItems(ctx context.Context, workspaceID, pageID string) ([]LinkItem, error)
	UpdateLinkItem(ctx context.Context, item *LinkItem) error
	DeleteLinkItem(ctx context.Context, workspaceID, itemID string) error
	CountLinksCreatedToday(ctx context.Context, workspaceID string, now time.Time) (int, error)
	RecordSecurityScan(ctx context.Context, scan *LinkSecurityScan) error
	GetLatestSecurityScan(ctx context.Context, workspaceID, url string) (*LinkSecurityScan, error)

	// Media Kits
	SaveMediaKit(ctx context.Context, kit *MediaKit) error
	GetMediaKit(ctx context.Context, workspaceID, mediaKitID string) (*MediaKit, error)
	FindMediaKitByID(ctx context.Context, mediaKitID string) (*MediaKit, error)

	// Creator Directory (Public & Consented per §27.2)
	SearchDirectory(ctx context.Context, query string, categories, languages []string, limit int, pageToken string) ([]CreatorDirectoryEntry, string, bool, int64, error)
	GetDirectoryEntry(ctx context.Context, mediaKitID string) (*CreatorDirectoryEntry, error)

	// Contract Templates & Evidence
	ListContractTemplates(ctx context.Context) ([]ContractTemplate, error)
	GetContractTemplate(ctx context.Context, templateID string) (*ContractTemplate, error)

	// Rate Cards & Items
	CreateRateCard(ctx context.Context, card *RateCard) error
	GetRateCard(ctx context.Context, workspaceID, rateCardID string) (*RateCard, error)
	ListRateCards(ctx context.Context, workspaceID string) ([]RateCard, error)
	UpdateRateCard(ctx context.Context, card *RateCard) error
	SaveRateCardItems(ctx context.Context, workspaceID, rateCardID string, items []RateCardItem) error
	DeleteRateCardItem(ctx context.Context, workspaceID, itemID string) error

	// Brand Deals
	CreateBrandDeal(ctx context.Context, deal *BrandDeal) error
	GetBrandDeal(ctx context.Context, workspaceID, dealID string) (*BrandDeal, error)
	ListBrandDeals(ctx context.Context, workspaceID string, statusFilter BrandDealStatus) ([]BrandDeal, error)
	UpdateBrandDeal(ctx context.Context, deal *BrandDeal) error

	// Sponsor Inquiries
	CreateInquiry(ctx context.Context, inq *SponsorInquiry) error
	GetInquiry(ctx context.Context, workspaceID, inquiryID string) (*SponsorInquiry, error)
	ListInquiries(ctx context.Context, workspaceID string) ([]SponsorInquiry, error)
	UpdateInquiryStatus(ctx context.Context, workspaceID, inquiryID, status string) error

	// Content ROI & Metrics
	SaveContentMetric(ctx context.Context, workspaceID string, metric *ContentROIMetric) error
	GetContentMetrics(ctx context.Context, workspaceID, platform string) ([]ContentROIMetric, error)
	GetContentMetric(ctx context.Context, workspaceID, contentID string) (*ContentROIMetric, error)

	// Tax Reports
	SaveTaxReport(ctx context.Context, report *TaxReportSummary) error
	GetTaxReport(ctx context.Context, workspaceID string, period TaxReportPeriod, year, periodNumber int32) (*TaxReportSummary, error)

	// Audit Logging
	LogAuditEvent(ctx context.Context, event OutboxEvent) error
	ListAuditEvents(ctx context.Context, workspaceID string) ([]OutboxEvent, error)
}

// MemoryStore implements Store in-memory with thread-safety and tenant isolation.
type MemoryStore struct {
	mu          sync.RWMutex
	pages       map[string]*LinkInBioPage    // key: pageID
	pagesBySlug map[string]string            // key: slug -> pageID
	items       map[string]*LinkItem         // key: itemID
	scans       map[string]*LinkSecurityScan // key: scanId
	mediaKits   map[string]*MediaKit         // key: mediaKitID
	rateCards   map[string]*RateCard         // key: rateCardID
	rateItems   map[string]*RateCardItem     // key: itemID
	deals       map[string]*BrandDeal        // key: dealID
	inquiries   map[string]*SponsorInquiry   // key: inquiryID
	metrics     map[string]*ContentROIMetric // key: contentID
	taxReports  map[string]*TaxReportSummary // key: "wsID:period:year:num"
	auditEvents []OutboxEvent
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		pages:       make(map[string]*LinkInBioPage),
		pagesBySlug: make(map[string]string),
		items:       make(map[string]*LinkItem),
		scans:       make(map[string]*LinkSecurityScan),
		mediaKits:   make(map[string]*MediaKit),
		rateCards:   make(map[string]*RateCard),
		rateItems:   make(map[string]*RateCardItem),
		deals:       make(map[string]*BrandDeal),
		inquiries:   make(map[string]*SponsorInquiry),
		metrics:     make(map[string]*ContentROIMetric),
		taxReports:  make(map[string]*TaxReportSummary),
		auditEvents: make([]OutboxEvent, 0),
	}
}

// ----------------------------------------------------------------------------
// Link-in-Bio Pages
// ----------------------------------------------------------------------------

func (m *MemoryStore) CreatePage(ctx context.Context, page *LinkInBioPage) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if _, exists := m.pagesBySlug[page.Slug]; exists {
		return ErrDuplicatePageSlug
	}
	cp := *page
	m.pages[page.PageID] = &cp
	m.pagesBySlug[page.Slug] = page.PageID
	return nil
}

func (m *MemoryStore) GetPage(ctx context.Context, workspaceID, pageID string) (*LinkInBioPage, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	p, ok := m.pages[pageID]
	if !ok || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return nil, ErrPageNotFound
	}
	cp := *p
	// Populate items
	items := make([]LinkItem, 0)
	for _, it := range m.items {
		if it.PageID == pageID && it.WorkspaceID == workspaceID && it.DeletedAt == nil {
			items = append(items, *it)
		}
	}
	sort.Slice(items, func(i, j int) bool {
		return items[i].Position < items[j].Position
	})
	cp.Items = items
	return &cp, nil
}

func (m *MemoryStore) GetPageBySlug(ctx context.Context, slug string) (*LinkInBioPage, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	pageID, ok := m.pagesBySlug[slug]
	if !ok {
		return nil, ErrPageNotFound
	}
	p, ok := m.pages[pageID]
	if !ok || p.DeletedAt != nil {
		return nil, ErrPageNotFound
	}
	cp := *p
	items := make([]LinkItem, 0)
	for _, it := range m.items {
		if it.PageID == pageID && it.DeletedAt == nil {
			items = append(items, *it)
		}
	}
	sort.Slice(items, func(i, j int) bool {
		return items[i].Position < items[j].Position
	})
	cp.Items = items
	return &cp, nil
}

func (m *MemoryStore) UpdatePage(ctx context.Context, page *LinkInBioPage) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.pages[page.PageID]
	if !ok || existing.WorkspaceID != page.WorkspaceID || existing.DeletedAt != nil {
		return ErrPageNotFound
	}
	cp := *page
	m.pages[page.PageID] = &cp
	return nil
}

func (m *MemoryStore) ListPages(ctx context.Context, workspaceID string) ([]LinkInBioPage, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	res := make([]LinkInBioPage, 0)
	for _, p := range m.pages {
		if p.WorkspaceID == workspaceID && p.DeletedAt == nil {
			res = append(res, *p)
		}
	}
	return res, nil
}

// ----------------------------------------------------------------------------
// Link Items & Security Scanning
// ----------------------------------------------------------------------------

func (m *MemoryStore) CreateLinkItem(ctx context.Context, item *LinkItem) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	cp := *item
	m.items[item.LinkItemID] = &cp
	return nil
}

func (m *MemoryStore) GetLinkItem(ctx context.Context, workspaceID, itemID string) (*LinkItem, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	it, ok := m.items[itemID]
	if !ok || it.WorkspaceID != workspaceID || it.DeletedAt != nil {
		return nil, ErrLinkItemNotFound
	}
	cp := *it
	return &cp, nil
}

func (m *MemoryStore) ListLinkItems(ctx context.Context, workspaceID, pageID string) ([]LinkItem, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	res := make([]LinkItem, 0)
	for _, it := range m.items {
		if it.WorkspaceID == workspaceID && it.PageID == pageID && it.DeletedAt == nil {
			res = append(res, *it)
		}
	}
	sort.Slice(res, func(i, j int) bool {
		return res[i].Position < res[j].Position
	})
	return res, nil
}

func (m *MemoryStore) UpdateLinkItem(ctx context.Context, item *LinkItem) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.items[item.LinkItemID]
	if !ok || existing.WorkspaceID != item.WorkspaceID || existing.DeletedAt != nil {
		return ErrLinkItemNotFound
	}
	cp := *item
	m.items[item.LinkItemID] = &cp
	return nil
}

func (m *MemoryStore) DeleteLinkItem(ctx context.Context, workspaceID, itemID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.items[itemID]
	if !ok || existing.WorkspaceID != workspaceID || existing.DeletedAt != nil {
		return ErrLinkItemNotFound
	}
	now := time.Now().UTC()
	existing.DeletedAt = &now
	return nil
}

func (m *MemoryStore) CountLinksCreatedToday(ctx context.Context, workspaceID string, now time.Time) (int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	startOfDay := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, time.UTC)
	count := 0
	for _, it := range m.items {
		if it.WorkspaceID == workspaceID && it.CreatedAt.After(startOfDay) {
			count++
		}
	}
	return count, nil
}

func (m *MemoryStore) RecordSecurityScan(ctx context.Context, scan *LinkSecurityScan) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	cp := *scan
	m.scans[scan.ScanId] = &cp
	return nil
}

func (m *MemoryStore) GetLatestSecurityScan(ctx context.Context, workspaceID, url string) (*LinkSecurityScan, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var latest *LinkSecurityScan
	for _, s := range m.scans {
		if s.WorkspaceID == workspaceID && s.URL == url {
			if latest == nil || s.ScannedAt.After(latest.ScannedAt) {
				cp := *s
				latest = &cp
			}
		}
	}
	return latest, nil
}

// ----------------------------------------------------------------------------
// Media Kits
// ----------------------------------------------------------------------------

func (m *MemoryStore) SaveMediaKit(ctx context.Context, kit *MediaKit) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	cp := *kit
	m.mediaKits[kit.MediaKitID] = &cp
	return nil
}

func (m *MemoryStore) GetMediaKit(ctx context.Context, workspaceID, mediaKitID string) (*MediaKit, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	k, ok := m.mediaKits[mediaKitID]
	if !ok || k.WorkspaceID != workspaceID || k.DeletedAt != nil {
		return nil, ErrMediaKitNotFound
	}
	cp := *k
	return &cp, nil
}

func (m *MemoryStore) FindMediaKitByID(ctx context.Context, mediaKitID string) (*MediaKit, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	k, ok := m.mediaKits[mediaKitID]
	if !ok || k.DeletedAt != nil {
		return nil, ErrMediaKitNotFound
	}
	cp := *k
	return &cp, nil
}

func (m *MemoryStore) SearchDirectory(ctx context.Context, query string, categories, languages []string, limit int, pageToken string) ([]CreatorDirectoryEntry, string, bool, int64, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	if limit <= 0 {
		limit = 20
	}
	if limit > 20 {
		limit = 20
	}

	normQuery := strings.ToLower(strings.TrimSpace(query))
	var entries []CreatorDirectoryEntry

	for _, k := range m.mediaKits {
		// Strict public projection invariant: only explicitly opted in and published kits
		if k.DeletedAt != nil || !k.DirectoryOptIn || k.DirectoryStatus != MediaKitDirectoryStatusPublished {
			continue
		}

		var profile PublicCreatorProfile
		if k.DirectoryProfileJSON != "" {
			_ = json.Unmarshal([]byte(k.DirectoryProfileJSON), &profile)
		}
		if profile.DisplayName == "" {
			continue
		}

		// Filter query
		if normQuery != "" {
			match := strings.Contains(strings.ToLower(profile.DisplayName), normQuery) ||
				strings.Contains(strings.ToLower(profile.Bio), normQuery)
			if !match {
				for _, cat := range profile.Categories {
					if strings.Contains(strings.ToLower(cat), normQuery) {
						match = true
						break
					}
				}
			}
			if !match {
				continue
			}
		}

		// Filter categories
		if len(categories) > 0 {
			catMatch := false
			for _, reqCat := range categories {
				for _, pCat := range profile.Categories {
					if strings.EqualFold(reqCat, pCat) {
						catMatch = true
						break
					}
				}
				if catMatch {
					break
				}
			}
			if !catMatch {
				continue
			}
		}

		// Filter languages
		if len(languages) > 0 {
			langMatch := false
			for _, reqLang := range languages {
				for _, pLang := range profile.Languages {
					if strings.EqualFold(reqLang, pLang) {
						langMatch = true
						break
					}
				}
				if langMatch {
					break
				}
			}
			if !langMatch {
				continue
			}
		}

		pubAt := k.UpdatedAt
		if k.DirectoryConsentedAt != nil {
			pubAt = *k.DirectoryConsentedAt
		}
		entries = append(entries, CreatorDirectoryEntry{
			MediaKitID:  k.MediaKitID,
			Profile:     profile,
			PublishedAt: pubAt,
		})
	}

	// Sort deterministically
	sort.Slice(entries, func(i, j int) bool {
		return entries[i].MediaKitID < entries[j].MediaKitID
	})

	totalCount := int64(len(entries))
	startIdx := 0
	if pageToken != "" {
		for i, e := range entries {
			if e.MediaKitID > pageToken {
				startIdx = i
				break
			}
			if i == len(entries)-1 {
				startIdx = len(entries)
			}
		}
	}

	endIdx := startIdx + limit
	hasMore := false
	var nextToken string
	if endIdx < len(entries) {
		hasMore = true
		nextToken = entries[endIdx-1].MediaKitID
	} else {
		endIdx = len(entries)
	}

	pageEntries := entries[startIdx:endIdx]
	return pageEntries, nextToken, hasMore, totalCount, nil
}

func (m *MemoryStore) GetDirectoryEntry(ctx context.Context, mediaKitID string) (*CreatorDirectoryEntry, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	k, ok := m.mediaKits[mediaKitID]
	if !ok || k.DeletedAt != nil || !k.DirectoryOptIn || k.DirectoryStatus != MediaKitDirectoryStatusPublished {
		return nil, ErrCreatorUnavailable
	}

	var profile PublicCreatorProfile
	if k.DirectoryProfileJSON != "" {
		_ = json.Unmarshal([]byte(k.DirectoryProfileJSON), &profile)
	}

	pubAt := k.UpdatedAt
	if k.DirectoryConsentedAt != nil {
		pubAt = *k.DirectoryConsentedAt
	}

	return &CreatorDirectoryEntry{
		MediaKitID:  k.MediaKitID,
		Profile:     profile,
		PublishedAt: pubAt,
	}, nil
}

var DefaultContractTemplates = []ContractTemplate{
	{
		TemplateID:      "tmpl-standard-sponsored",
		Title:           "Standard Sponsored Video Agreement",
		Description:     "Standard 1-video deliverable with 30-day usage rights.",
		DefaultTerms:    "50% upfront deposit, 50% upon delivery. 1 revision included.",
		Version:         "1.0.0",
		SourceArticleID: "kb-art-contract-001",
		BodyMarkdown:    "## Hợp đồng tài trợ video tiêu chuẩn\n\n1. Phạm vi công việc: 01 video TikTok/Reels thời lượng 60s.\n2. Quyền sử dụng hình ảnh: 30 ngày trên các kênh chính thức của Nhãn hàng.\n3. Thanh toán: Tạm ứng 50% khi ký hợp đồng, 50% còn lại trong vòng 7 ngày làm việc sau khi nghiệm thu video.\n4. Sửa đổi: Tối đa 01 lần chỉnh sửa kịch bản và 01 lần chỉnh sửa hậu kỳ trước khi đăng tải chính thức.",
		Disclaimer:      "Tài liệu mẫu mang tính chất tham khảo dự thảo hợp đồng. Creativanta không cung cấp tư vấn pháp lý hay dịch vụ chữ ký số điện tử. Vui lòng tham khảo ý kiến luật sư trước khi ký kết.",
	},
	{
		TemplateID:      "tmpl-brand-ambassador",
		Title:           "Brand Ambassador Agreement (3-month)",
		Description:     "Recurring deliverables with exclusivity clause.",
		DefaultTerms:    "Monthly retainer payable on 1st of month. Category exclusivity.",
		Version:         "1.1.0",
		SourceArticleID: "kb-art-contract-002",
		BodyMarkdown:    "## Thỏa thuận đại sứ thương hiệu 3 tháng\n\n1. Thời hạn: 03 tháng kể từ ngày ký.\n2. Hạng mục bàn giao: 02 bài đăng/tháng kèm 04 story tương tác.\n3. Độc quyền ngành hàng: Bên được tài trợ cam kết không quảng bá sản phẩm cạnh tranh trực tiếp trong thời hạn thỏa thuận.\n4. Thù lao: Chi trả định kỳ vào ngày 01 hàng tháng.",
		Disclaimer:      "Tài liệu mẫu mang tính chất tham khảo dự thảo hợp đồng. Creativanta không cung cấp tư vấn pháp lý hay dịch vụ chữ ký số điện tử. Vui lòng tham khảo ý kiến luật sư trước khi ký kết.",
	},
}

func (m *MemoryStore) ListContractTemplates(ctx context.Context) ([]ContractTemplate, error) {
	return DefaultContractTemplates, nil
}

func (m *MemoryStore) GetContractTemplate(ctx context.Context, templateID string) (*ContractTemplate, error) {
	for _, tmpl := range DefaultContractTemplates {
		if tmpl.TemplateID == templateID {
			cp := tmpl
			return &cp, nil
		}
	}
	return nil, errors.New("contract template not found")
}

// ----------------------------------------------------------------------------
// Rate Cards & Items
// ----------------------------------------------------------------------------

func (m *MemoryStore) CreateRateCard(ctx context.Context, card *RateCard) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	cp := *card
	m.rateCards[card.RateCardID] = &cp
	for _, it := range card.Items {
		itemCopy := it
		m.rateItems[it.ItemID] = &itemCopy
	}
	return nil
}

func (m *MemoryStore) GetRateCard(ctx context.Context, workspaceID, rateCardID string) (*RateCard, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	c, ok := m.rateCards[rateCardID]
	if !ok || c.WorkspaceID != workspaceID || c.DeletedAt != nil {
		return nil, ErrRateCardNotFound
	}
	cp := *c
	items := make([]RateCardItem, 0)
	for _, it := range m.rateItems {
		if it.RateCardID == rateCardID && it.WorkspaceID == workspaceID {
			items = append(items, *it)
		}
	}
	sort.Slice(items, func(i, j int) bool {
		return items[i].Position < items[j].Position
	})
	cp.Items = items
	return &cp, nil
}

func (m *MemoryStore) ListRateCards(ctx context.Context, workspaceID string) ([]RateCard, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	res := make([]RateCard, 0)
	for _, c := range m.rateCards {
		if c.WorkspaceID == workspaceID && c.DeletedAt == nil {
			cp := *c
			items := make([]RateCardItem, 0)
			for _, it := range m.rateItems {
				if it.RateCardID == c.RateCardID && it.WorkspaceID == workspaceID {
					items = append(items, *it)
				}
			}
			sort.Slice(items, func(i, j int) bool {
				return items[i].Position < items[j].Position
			})
			cp.Items = items
			res = append(res, cp)
		}
	}
	return res, nil
}

func (m *MemoryStore) UpdateRateCard(ctx context.Context, card *RateCard) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.rateCards[card.RateCardID]
	if !ok || existing.WorkspaceID != card.WorkspaceID || existing.DeletedAt != nil {
		return ErrRateCardNotFound
	}
	cp := *card
	m.rateCards[card.RateCardID] = &cp
	return nil
}

func (m *MemoryStore) SaveRateCardItems(ctx context.Context, workspaceID, rateCardID string, items []RateCardItem) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	for _, it := range items {
		cp := it
		cp.RateCardID = rateCardID
		cp.WorkspaceID = workspaceID
		m.rateItems[it.ItemID] = &cp
	}
	return nil
}

func (m *MemoryStore) DeleteRateCardItem(ctx context.Context, workspaceID, itemID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	it, ok := m.rateItems[itemID]
	if !ok || it.WorkspaceID != workspaceID {
		return ErrRateCardItemNotFound
	}
	delete(m.rateItems, itemID)
	return nil
}

// ----------------------------------------------------------------------------
// Brand Deals
// ----------------------------------------------------------------------------

func (m *MemoryStore) CreateBrandDeal(ctx context.Context, deal *BrandDeal) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	cp := *deal
	m.deals[deal.DealID] = &cp
	return nil
}

func (m *MemoryStore) GetBrandDeal(ctx context.Context, workspaceID, dealID string) (*BrandDeal, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	d, ok := m.deals[dealID]
	if !ok || d.WorkspaceID != workspaceID || d.DeletedAt != nil {
		return nil, ErrBrandDealNotFound
	}
	cp := *d
	return &cp, nil
}

func (m *MemoryStore) ListBrandDeals(ctx context.Context, workspaceID string, statusFilter BrandDealStatus) ([]BrandDeal, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	res := make([]BrandDeal, 0)
	for _, d := range m.deals {
		if d.WorkspaceID == workspaceID && d.DeletedAt == nil {
			if statusFilter == "" || d.Status == statusFilter {
				res = append(res, *d)
			}
		}
	}
	sort.Slice(res, func(i, j int) bool {
		return res[i].CreatedAt.After(res[j].CreatedAt)
	})
	return res, nil
}

func (m *MemoryStore) UpdateBrandDeal(ctx context.Context, deal *BrandDeal) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.deals[deal.DealID]
	if !ok || existing.WorkspaceID != deal.WorkspaceID || existing.DeletedAt != nil {
		return ErrBrandDealNotFound
	}
	cp := *deal
	m.deals[deal.DealID] = &cp
	return nil
}

// ----------------------------------------------------------------------------
// Sponsor Inquiries
// ----------------------------------------------------------------------------

func (m *MemoryStore) CreateInquiry(ctx context.Context, inq *SponsorInquiry) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	cp := *inq
	m.inquiries[inq.InquiryID] = &cp
	return nil
}

func (m *MemoryStore) GetInquiry(ctx context.Context, workspaceID, inquiryID string) (*SponsorInquiry, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	inq, ok := m.inquiries[inquiryID]
	if !ok || inq.WorkspaceID != workspaceID {
		return nil, ErrSponsorInquiryNotFound
	}
	cp := *inq
	return &cp, nil
}

func (m *MemoryStore) ListInquiries(ctx context.Context, workspaceID string) ([]SponsorInquiry, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	res := make([]SponsorInquiry, 0)
	for _, inq := range m.inquiries {
		if inq.WorkspaceID == workspaceID {
			res = append(res, *inq)
		}
	}
	sort.Slice(res, func(i, j int) bool {
		return res[i].ReceivedAt.After(res[j].ReceivedAt)
	})
	return res, nil
}

func (m *MemoryStore) UpdateInquiryStatus(ctx context.Context, workspaceID, inquiryID, status string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	inq, ok := m.inquiries[inquiryID]
	if !ok || inq.WorkspaceID != workspaceID {
		return ErrSponsorInquiryNotFound
	}
	inq.Status = status
	return nil
}

// ----------------------------------------------------------------------------
// Content ROI & Metrics
// ----------------------------------------------------------------------------

func (m *MemoryStore) SaveContentMetric(ctx context.Context, workspaceID string, metric *ContentROIMetric) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	cp := *metric
	if cp.WorkspaceID == "" {
		cp.WorkspaceID = workspaceID
	}
	m.metrics[metric.ContentID] = &cp
	return nil
}

func (m *MemoryStore) GetContentMetrics(ctx context.Context, workspaceID, platform string) ([]ContentROIMetric, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	res := make([]ContentROIMetric, 0)
	for _, met := range m.metrics {
		if met.WorkspaceID != "" && met.WorkspaceID != workspaceID {
			continue
		}
		if platform == "" || strings.EqualFold(met.Platform, platform) {
			res = append(res, *met)
		}
	}
	sort.Slice(res, func(i, j int) bool {
		return res[i].PublishedAt.Before(res[j].PublishedAt)
	})
	return res, nil
}

func (m *MemoryStore) GetContentMetric(ctx context.Context, workspaceID, contentID string) (*ContentROIMetric, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	met, ok := m.metrics[contentID]
	if !ok {
		return nil, fmt.Errorf("content metric not found: %s", contentID)
	}
	cp := *met
	return &cp, nil
}

// ----------------------------------------------------------------------------
// Tax Reports
// ----------------------------------------------------------------------------

func (m *MemoryStore) SaveTaxReport(ctx context.Context, report *TaxReportSummary) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	key := fmt.Sprintf("%s:%s:%d:%d", report.WorkspaceID, report.Period, report.TaxYear, report.PeriodNumber)
	cp := *report
	m.taxReports[key] = &cp
	return nil
}

func (m *MemoryStore) GetTaxReport(ctx context.Context, workspaceID string, period TaxReportPeriod, year, periodNumber int32) (*TaxReportSummary, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	key := fmt.Sprintf("%s:%s:%d:%d", workspaceID, period, year, periodNumber)
	rep, ok := m.taxReports[key]
	if !ok {
		return nil, fmt.Errorf("tax report not found for period %s year %d", period, year)
	}
	cp := *rep
	return &cp, nil
}

// ----------------------------------------------------------------------------
// Audit Events
// ----------------------------------------------------------------------------

func (m *MemoryStore) LogAuditEvent(ctx context.Context, event OutboxEvent) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.auditEvents = append(m.auditEvents, event)
	return nil
}

func (m *MemoryStore) ListAuditEvents(ctx context.Context, workspaceID string) ([]OutboxEvent, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	res := make([]OutboxEvent, 0)
	for _, ev := range m.auditEvents {
		if ev.WorkspaceID == workspaceID {
			res = append(res, ev)
		}
	}
	return res, nil
}
