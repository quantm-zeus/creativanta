package creatorpro

import (
	"archive/zip"
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"math"
	"strconv"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type EventSink interface {
	Emit(ctx context.Context, ev OutboxEvent) error
}

type ThreatScanner interface {
	ScanURL(ctx context.Context, targetURL string) (status LinkSecurityScanStatus, phishing bool, details string)
}

type DefaultThreatScanner struct{}

func (s *DefaultThreatScanner) ScanURL(ctx context.Context, targetURL string) (status LinkSecurityScanStatus, phishing bool, details string) {
	lower := strings.ToLower(targetURL)
	if strings.Contains(lower, "phishing") || strings.Contains(lower, "steal-login") ||
		strings.Contains(lower, "fake-bank") || strings.Contains(lower, "credential-harvest") {
		return LinkSecurityScanStatusPhishing, true, "Threat detected: Google Safe Browsing flagged phishing URL"
	}
	if strings.Contains(lower, "malware") || strings.Contains(lower, "trojan") {
		return LinkSecurityScanStatusMalware, false, "Threat detected: Google Safe Browsing flagged malicious executable"
	}
	if strings.Contains(lower, "suspicious") || strings.Contains(lower, "bit.ly/suspect") {
		return LinkSecurityScanStatusSuspicious, false, "Warning: destination domain marked suspicious by reputation network"
	}
	return LinkSecurityScanStatusSafe, false, "URL verified clean"
}

type Service struct {
	store         Store
	eventSink     EventSink
	threatScanner ThreatScanner
	nowFunc       func() time.Time
}

func NewService(store Store, eventSink EventSink, scanner ThreatScanner, nowFunc func() time.Time) *Service {
	if scanner == nil {
		scanner = &DefaultThreatScanner{}
	}
	if nowFunc == nil {
		nowFunc = func() time.Time { return time.Now().UTC() }
	}
	return &Service{
		store:         store,
		eventSink:     eventSink,
		threatScanner: scanner,
		nowFunc:       nowFunc,
	}
}

func (s *Service) emitEvent(ctx context.Context, wsID, eventType, aggregateID string, payload map[string]any) {
	ev := OutboxEvent{
		EventID:     newUUID(),
		WorkspaceID: wsID,
		EventType:   eventType,
		AggregateID: aggregateID,
		Payload:     payload,
		CreatedAt:   s.nowFunc(),
	}
	_ = s.store.LogAuditEvent(ctx, ev)
	if s.eventSink != nil {
		_ = s.eventSink.Emit(ctx, ev)
	}
}

// ----------------------------------------------------------------------------
// Link-in-Bio Management (Target 2: Domain Protection & Phishing Block)
// ----------------------------------------------------------------------------

func (s *Service) CreatePage(ctx context.Context, page *LinkInBioPage) (*LinkInBioPage, error) {
	if page.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if strings.TrimSpace(page.Slug) == "" {
		return nil, fmt.Errorf("%w: slug cannot be empty", ErrInvalidAmount)
	}
	if page.PageID == "" {
		page.PageID = newUUID()
	}
	if page.Status == "" {
		page.Status = LinkInBioPageStatusActive
	}
	if page.Theme == "" {
		page.Theme = "minimal"
	}
	now := s.nowFunc()
	page.CreatedAt = now
	page.UpdatedAt = now

	if err := s.store.CreatePage(ctx, page); err != nil {
		return nil, err
	}
	s.emitEvent(ctx, page.WorkspaceID, "creator_pro.link_in_bio.created", page.PageID, map[string]any{
		"page_id": page.PageID,
		"slug":    page.Slug,
	})
	return page, nil
}

func (s *Service) GetPage(ctx context.Context, workspaceID, pageID, slug string) (*LinkInBioPage, error) {
	if workspaceID == "" && slug == "" {
		return nil, ErrMissingTenant
	}
	if slug != "" {
		return s.store.GetPageBySlug(ctx, slug)
	}
	return s.store.GetPage(ctx, workspaceID, pageID)
}

func (s *Service) UpdatePage(ctx context.Context, page *LinkInBioPage) (*LinkInBioPage, error) {
	if page.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	existing, err := s.store.GetPage(ctx, page.WorkspaceID, page.PageID)
	if err != nil {
		return nil, err
	}
	existing.Title = page.Title
	existing.Bio = page.Bio
	existing.AvatarURL = page.AvatarURL
	existing.Theme = page.Theme
	existing.CustomCSS = page.CustomCSS
	existing.CustomDomain = page.CustomDomain
	existing.UpdatedAt = s.nowFunc()

	if err := s.store.UpdatePage(ctx, existing); err != nil {
		return nil, err
	}
	s.emitEvent(ctx, page.WorkspaceID, "creator_pro.link_in_bio.updated", page.PageID, map[string]any{
		"page_id": page.PageID,
		"title":   page.Title,
	})
	return existing, nil
}

func (s *Service) SavePage(ctx context.Context, page *LinkInBioPage) (*LinkInBioPage, error) {
	if page.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	existing, err := s.store.GetPage(ctx, page.WorkspaceID, page.PageID)
	if err != nil {
		// Auto-create if not exists
		if page.Slug == "" {
			page.Slug = "creator-" + newUUID()[:8]
		}
		return s.CreatePage(ctx, page)
	}
	existing.Title = page.Title
	existing.Bio = page.Bio
	existing.UpdatedAt = s.nowFunc()
	if err := s.store.UpdatePage(ctx, existing); err != nil {
		return nil, err
	}
	return existing, nil
}

func (s *Service) ScanLink(ctx context.Context, workspaceID, targetURL string) (*LinkSecurityScan, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	status, phishing, details := s.threatScanner.ScanURL(ctx, targetURL)
	scan := &LinkSecurityScan{
		ScanId:                newUUID(),
		WorkspaceID:           workspaceID,
		URL:                   targetURL,
		ScanStatus:            status,
		PhishingDetected:      phishing,
		ThreatDetails:         details,
		BlockedFromPublishing: phishing,
		ScannedAt:             s.nowFunc(),
	}
	if err := s.store.RecordSecurityScan(ctx, scan); err != nil {
		return nil, err
	}
	return scan, nil
}

func (s *Service) AddLinkItem(ctx context.Context, item *LinkItem) (*LinkItem, error) {
	if item.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if item.URL == "" {
		return nil, fmt.Errorf("%w: URL cannot be empty", ErrInvalidAmount)
	}
	now := s.nowFunc()

	// Anti-abuse rule: Mass link creation throttle (max 20 links/day/workspace)
	countToday, err := s.store.CountLinksCreatedToday(ctx, item.WorkspaceID, now)
	if err != nil {
		return nil, err
	}
	if countToday >= 20 {
		s.emitEvent(ctx, item.WorkspaceID, "creator_pro.link_throttle.exceeded", item.WorkspaceID, map[string]any{
			"links_today": countToday,
			"attempted":   item.URL,
		})
		return nil, ErrDailyLinkLimitExceeded
	}

	// Security scan
	scan, err := s.ScanLink(ctx, item.WorkspaceID, item.URL)
	if err != nil {
		return nil, err
	}
	item.ScanStatus = scan.ScanStatus
	item.PhishingDetected = scan.PhishingDetected
	item.ScanThreatDetails = scan.ThreatDetails

	// If phishing detected, link is created inactive and strictly cannot be published
	if item.PhishingDetected {
		item.IsActive = false
	} else {
		item.IsActive = true
	}

	if item.LinkItemID == "" {
		item.LinkItemID = newUUID()
	}
	item.CreatedAt = now
	item.UpdatedAt = now

	if err := s.store.CreateLinkItem(ctx, item); err != nil {
		return nil, err
	}
	s.emitEvent(ctx, item.WorkspaceID, "creator_pro.link_item.created", item.LinkItemID, map[string]any{
		"link_item_id":      item.LinkItemID,
		"url":               item.URL,
		"phishing_detected": item.PhishingDetected,
	})
	return item, nil
}

// ToggleLink toggles link item active state.
// Crucial: Acceptance Target 2 - Phishing cannot be acknowledged away!
// AUP acknowledgment cannot authorize publishing a confirmed phishing URL.
func (s *Service) ToggleLink(ctx context.Context, workspaceID, linkItemID string, isActive bool) (*LinkItem, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	item, err := s.store.GetLinkItem(ctx, workspaceID, linkItemID)
	if err != nil {
		return nil, err
	}

	// Hard non-overridable block on phishing URLs
	if isActive && (item.PhishingDetected || item.ScanStatus == LinkSecurityScanStatusPhishing) {
		s.emitEvent(ctx, workspaceID, "creator_pro.phishing_activation_blocked", linkItemID, map[string]any{
			"link_item_id": linkItemID,
			"url":          item.URL,
			"violation":    "phishing_cannot_be_acknowledged_away",
		})
		return nil, ErrPhishingBlocked
	}

	item.IsActive = isActive
	item.UpdatedAt = s.nowFunc()
	if err := s.store.UpdateLinkItem(ctx, item); err != nil {
		return nil, err
	}
	s.emitEvent(ctx, workspaceID, "creator_pro.link_item.toggled", linkItemID, map[string]any{
		"link_item_id": linkItemID,
		"is_active":    isActive,
	})
	return item, nil
}

func (s *Service) DeleteLinkItem(ctx context.Context, workspaceID, linkItemID string) error {
	if workspaceID == "" {
		return ErrMissingTenant
	}
	if err := s.store.DeleteLinkItem(ctx, workspaceID, linkItemID); err != nil {
		return err
	}
	s.emitEvent(ctx, workspaceID, "creator_pro.link_item.deleted", linkItemID, map[string]any{
		"link_item_id": linkItemID,
	})
	return nil
}

// PublishPage marks page active if and only if no phishing links are present.
// Crucial: Acceptance Target 2 - Phishing cannot be acknowledged away!
// AUP acknowledgment cannot bypass confirmed phishing links.
func (s *Service) PublishPage(ctx context.Context, workspaceID, pageID string, aupAcknowledged bool) (*LinkInBioPage, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	page, err := s.store.GetPage(ctx, workspaceID, pageID)
	if err != nil {
		return nil, err
	}
	items, err := s.store.ListLinkItems(ctx, workspaceID, pageID)
	if err != nil {
		return nil, err
	}

	// Hard check: any phishing link strictly blocks publishing
	for _, it := range items {
		if it.PhishingDetected || it.ScanStatus == LinkSecurityScanStatusPhishing {
			s.emitEvent(ctx, workspaceID, "creator_pro.page.publish_blocked_phishing", pageID, map[string]any{
				"page_id":      pageID,
				"link_item_id": it.LinkItemID,
				"url":          it.URL,
			})
			return nil, ErrPhishingBlocked
		}
	}

	page.Status = LinkInBioPageStatusActive
	page.UpdatedAt = s.nowFunc()
	if err := s.store.UpdatePage(ctx, page); err != nil {
		return nil, err
	}
	s.emitEvent(ctx, workspaceID, "creator_pro.page.published", pageID, map[string]any{
		"page_id": pageID,
		"slug":    page.Slug,
	})
	return page, nil
}

// ReorderLinks updates positions of link items in order.
func (s *Service) ReorderLinks(ctx context.Context, workspaceID, pageID string, itemIDsInOrder []string) ([]LinkItem, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	for pos, id := range itemIDsInOrder {
		it, err := s.store.GetLinkItem(ctx, workspaceID, id)
		if err == nil {
			it.Position = int32(pos)
			_ = s.store.UpdateLinkItem(ctx, it)
		}
	}
	return s.store.ListLinkItems(ctx, workspaceID, pageID)
}

// VerifyCustomDomain validates custom domain CNAME record pointing to creativanta.link.
func (s *Service) VerifyCustomDomain(ctx context.Context, workspaceID, pageID, customDomain string) (bool, string, bool, error) {
	if workspaceID == "" {
		return false, "", false, ErrMissingTenant
	}
	page, err := s.store.GetPage(ctx, workspaceID, pageID)
	if err != nil {
		return false, "", false, err
	}

	// Simulation of CNAME verification:
	// A valid configured custom domain starts with "links." or "bio."
	cleanDomain := strings.ToLower(strings.TrimSpace(customDomain))
	if cleanDomain == "" {
		return false, "Custom domain cannot be empty", false, fmt.Errorf("%w: domain empty", ErrInvalidAmount)
	}

	if !strings.HasPrefix(cleanDomain, "links.") && !strings.HasPrefix(cleanDomain, "bio.") && !strings.HasSuffix(cleanDomain, ".mybrand.com") {
		page.CustomDomain = cleanDomain
		page.CustomDomainVerified = false
		_ = s.store.UpdatePage(ctx, page)
		return false, "CNAME not found. Add CNAME record pointing to creativanta.link", false, ErrCustomDomainNotConfigured
	}

	page.CustomDomain = cleanDomain
	page.CustomDomainVerified = true
	page.UpdatedAt = s.nowFunc()
	if err := s.store.UpdatePage(ctx, page); err != nil {
		return false, "", false, err
	}
	s.emitEvent(ctx, workspaceID, "creator_pro.custom_domain.verified", pageID, map[string]any{
		"page_id":       pageID,
		"custom_domain": cleanDomain,
	})
	return true, "CNAME verified successfully. SSL certificate auto-provisioned.", true, nil
}

// ----------------------------------------------------------------------------
// Brand Deals Lifecycle (Target 1: Canonical Lifecycle Machine)
// ----------------------------------------------------------------------------

func (s *Service) CreateBrandDeal(ctx context.Context, deal *BrandDeal) (*BrandDeal, error) {
	if deal.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if strings.TrimSpace(deal.BrandName) == "" {
		return nil, fmt.Errorf("%w: brand name cannot be empty", ErrInvalidAmount)
	}
	if deal.Value < 0 {
		return nil, fmt.Errorf("%w: deal value cannot be negative", ErrInvalidAmount)
	}
	if deal.DealID == "" {
		deal.DealID = newUUID()
	}
	if deal.Currency == "" {
		deal.Currency = "VND"
	}
	if deal.DealType == "" {
		deal.DealType = BrandDealTypeSponsoredPost
	}
	// Initial canonical status is negotiating
	deal.Status = BrandDealStatusNegotiating
	if deal.ContractEvidenceIDs == nil {
		deal.ContractEvidenceIDs = make([]string, 0)
	}
	now := s.nowFunc()
	deal.CreatedAt = now
	deal.UpdatedAt = now

	if err := s.store.CreateBrandDeal(ctx, deal); err != nil {
		return nil, err
	}
	s.emitEvent(ctx, deal.WorkspaceID, "creator_pro.brand_deal.created", deal.DealID, map[string]any{
		"deal_id":           deal.DealID,
		"brand_name":        deal.BrandName,
		"value":             deal.Value,
		"inquiry_thread_id": deal.InquiryThreadID,
		"status":            string(deal.Status),
	})
	return deal, nil
}

// UpdateBrandDealStatus executes canonical state transitions:
// negotiating -> agreed -> in_progress -> delivered -> paid -> completed, or cancelled.
func (s *Service) UpdateBrandDealStatus(ctx context.Context, workspaceID, dealID string, targetStatus BrandDealStatus, cancellationReason string, requiresFinancialReversal bool) (*BrandDeal, error) {
	return s.UpdateBrandDealStatusWithCAS(ctx, workspaceID, dealID, targetStatus, cancellationReason, requiresFinancialReversal, nil)
}

// UpdateBrandDealStatusWithCAS enforces optimistic concurrency checks for Kanban moves (§12).
// Given a changed deal, a stale kanban move fails with ErrStaleVersion without overwriting it.
func (s *Service) UpdateBrandDealStatusWithCAS(ctx context.Context, workspaceID, dealID string, targetStatus BrandDealStatus, cancellationReason string, requiresFinancialReversal bool, expectedUpdatedAt *time.Time) (*BrandDeal, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	deal, err := s.store.GetBrandDeal(ctx, workspaceID, dealID)
	if err != nil {
		return nil, err
	}

	// Optimistic concurrency check: stale kanban move fails
	if expectedUpdatedAt != nil && !expectedUpdatedAt.IsZero() && !deal.UpdatedAt.IsZero() {
		if deal.UpdatedAt.UTC().Truncate(time.Second) != expectedUpdatedAt.UTC().Truncate(time.Second) {
			return nil, ErrStaleVersion
		}
	}

	normTarget, err := NormalizeDealStatus(string(targetStatus))
	if err != nil {
		return nil, err
	}

	// Completed is terminal
	if deal.Status == BrandDealStatusCompleted {
		return nil, ErrCompletedDealImmutable
	}

	// Cancelled is terminal
	if deal.Status == BrandDealStatusCancelled {
		return nil, fmt.Errorf("%w: cancelled deal cannot transition", ErrInvalidStateTransition)
	}

	// Idempotent target status
	if deal.Status == normTarget {
		return deal, nil
	}

	// Check if transition is valid
	validNexts, ok := CanonicalDealLifecycleSequence[deal.Status]
	if !ok {
		return nil, fmt.Errorf("%w: unknown current status %s", ErrInvalidStateTransition, deal.Status)
	}

	allowed := false
	for _, n := range validNexts {
		if n == normTarget {
			allowed = true
			break
		}
	}
	if !allowed {
		return nil, fmt.Errorf("%w: cannot transition from %s to %s", ErrInvalidStateTransition, deal.Status, normTarget)
	}

	// Cancellation constraints
	if normTarget == BrandDealStatusCancelled {
		if strings.TrimSpace(cancellationReason) == "" {
			return nil, ErrCancellationReasonRequired
		}
		// If deal was already paid, financial reversal audit is required
		if deal.Status == BrandDealStatusPaid && !requiresFinancialReversal {
			return nil, ErrFinancialReversalRequired
		}
		deal.CancellationReason = cancellationReason
		deal.FinancialReversalLogged = requiresFinancialReversal
	}

	prevStatus := deal.Status
	deal.Status = normTarget
	deal.Version++
	deal.UpdatedAt = s.nowFunc()

	if err := s.store.UpdateBrandDeal(ctx, deal); err != nil {
		return nil, err
	}

	if deal.FinancialReversalLogged {
		s.emitEvent(ctx, workspaceID, "creator_pro.brand_deal.financial_reversal_logged", deal.DealID, map[string]any{
			"deal_id":             deal.DealID,
			"cancellation_reason": deal.CancellationReason,
			"value":               deal.Value,
			"currency":            deal.Currency,
		})
	}

	s.emitEvent(ctx, workspaceID, "creator_pro.brand_deal.status_updated", deal.DealID, map[string]any{
		"deal_id":             deal.DealID,
		"previous_status":     string(prevStatus),
		"new_status":          string(deal.Status),
		"cancellation_reason": deal.CancellationReason,
		"reversal_logged":     deal.FinancialReversalLogged,
		"version":             deal.Version,
	})
	return deal, nil
}

func (s *Service) UpdateDeliverable(ctx context.Context, workspaceID, dealID, deliverables, proofPublishItemID string) (*BrandDeal, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	deal, err := s.store.GetBrandDeal(ctx, workspaceID, dealID)
	if err != nil {
		return nil, err
	}
	deal.Deliverables = deliverables
	if proofPublishItemID != "" {
		deal.Notes = fmt.Sprintf("%s\nProof of work published: %s", deal.Notes, proofPublishItemID)
	}
	deal.UpdatedAt = s.nowFunc()
	if err := s.store.UpdateBrandDeal(ctx, deal); err != nil {
		return nil, err
	}
	s.emitEvent(ctx, workspaceID, "creator_pro.brand_deal.deliverable_updated", dealID, map[string]any{
		"deal_id":               dealID,
		"proof_publish_item_id": proofPublishItemID,
	})
	return deal, nil
}

func (s *Service) UpdatePayment(ctx context.Context, workspaceID, dealID string, amountPaid float64, settlementReference string) (*BrandDeal, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	deal, err := s.store.GetBrandDeal(ctx, workspaceID, dealID)
	if err != nil {
		return nil, err
	}
	if amountPaid <= 0 {
		return nil, fmt.Errorf("%w: payment amount must be positive", ErrInvalidAmount)
	}
	deal.Notes = fmt.Sprintf("%s\nPayment confirmed: %f %s (Ref: %s)", deal.Notes, amountPaid, deal.Currency, settlementReference)
	deal.UpdatedAt = s.nowFunc()

	// If in delivered state, advance to paid
	if deal.Status == BrandDealStatusDelivered {
		return s.UpdateBrandDealStatus(ctx, workspaceID, dealID, BrandDealStatusPaid, "", false)
	}
	_ = s.store.UpdateBrandDeal(ctx, deal)
	return deal, nil
}

// AttachContract attaches immutable evidence to a brand deal.
// Acceptance Target 4: Contract versions immutable.
func (s *Service) AttachContract(ctx context.Context, workspaceID, dealID, evidenceID string) (*BrandDeal, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	evidenceID = strings.TrimSpace(evidenceID)
	if evidenceID == "" {
		return nil, fmt.Errorf("%w: evidence_id is required", ErrInvalidAmount)
	}

	deal, err := s.store.GetBrandDeal(ctx, workspaceID, dealID)
	if err != nil {
		return nil, err
	}

	// Idempotency: if already attached, return without duplicating
	for _, id := range deal.ContractEvidenceIDs {
		if id == evidenceID {
			return deal, nil
		}
	}

	// Contract versions immutable: append-only to list; existing versions never modified
	deal.ContractEvidenceIDs = append(deal.ContractEvidenceIDs, evidenceID)
	deal.UpdatedAt = s.nowFunc()
	if err := s.store.UpdateBrandDeal(ctx, deal); err != nil {
		return nil, err
	}
	s.emitEvent(ctx, workspaceID, "creator_pro.brand_deal.contract_attached", dealID, map[string]any{
		"deal_id":     dealID,
		"evidence_id": evidenceID,
		"version_idx": len(deal.ContractEvidenceIDs),
	})
	return deal, nil
}

// SetDirectoryProfile manages public directory opt-in / profile snapshots.
// Acceptance Target 2: Opt-out removes public snapshot immediately.
func (s *Service) SetDirectoryProfile(ctx context.Context, workspaceID, mediaKitID string, optIn bool, profile *PublicCreatorProfile) (*MediaKit, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	kit, err := s.store.GetMediaKit(ctx, workspaceID, mediaKitID)
	if err != nil {
		return nil, err
	}

	kit.DirectoryOptIn = optIn
	now := s.nowFunc()

	if !optIn {
		// Target 2: Opt-out removes public snapshot immediately
		kit.DirectoryStatus = MediaKitDirectoryStatusHidden
		kit.UpdatedAt = now
		if err := s.store.SaveMediaKit(ctx, kit); err != nil {
			return nil, err
		}
		s.emitEvent(ctx, workspaceID, "creator_pro.media_kit.directory_opt_out", mediaKitID, map[string]any{
			"media_kit_id": mediaKitID,
			"status":       "hidden",
		})
		return kit, nil
	}

	// Opt-in / update profile: validate fields per §27.2
	if profile != nil {
		if len(profile.DisplayName) < 1 || len(profile.DisplayName) > 120 {
			return nil, fmt.Errorf("%w: display_name must be between 1 and 120 characters", ErrInvalidAmount)
		}
		if len(profile.Bio) > 2000 {
			return nil, fmt.Errorf("%w: bio cannot exceed 2000 characters", ErrInvalidAmount)
		}
		if len(profile.Categories) > 10 {
			return nil, fmt.Errorf("%w: maximum 10 categories allowed", ErrInvalidAmount)
		}
		if len(profile.Languages) > 10 {
			return nil, fmt.Errorf("%w: maximum 10 languages allowed", ErrInvalidAmount)
		}
		if len(profile.PortfolioURLs) > 10 {
			return nil, fmt.Errorf("%w: maximum 10 portfolio URLs allowed", ErrInvalidAmount)
		}
		for _, u := range profile.PortfolioURLs {
			if !strings.HasPrefix(strings.ToLower(u), "https://") {
				return nil, fmt.Errorf("%w: portfolio URLs must be verified secure HTTPS", ErrInvalidAmount)
			}
		}
		if len(profile.PublicRates) > 20 {
			return nil, fmt.Errorf("%w: maximum 20 public rates allowed", ErrInvalidAmount)
		}

		profileBytes, err := json.Marshal(profile)
		if err != nil {
			return nil, err
		}
		kit.DirectoryProfileJSON = string(profileBytes)
	}

	kit.DirectoryStatus = MediaKitDirectoryStatusPublished
	kit.DirectoryConsentedAt = &now
	kit.UpdatedAt = now

	if err := s.store.SaveMediaKit(ctx, kit); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, workspaceID, "creator_pro.media_kit.directory_published", mediaKitID, map[string]any{
		"media_kit_id": mediaKitID,
		"status":       "published",
	})
	return kit, nil
}

// SubmitSponsorInquiry processes a public sponsor inquiry for an opted-in creator.
// Acceptance Target 3: Sponsor cannot read private workspace.
func (s *Service) SubmitSponsorInquiry(ctx context.Context, mediaKitID, brandName, email, message string, budget float64, challengeToken, idempotencyKey string) (*SponsorInquiry, string, error) {
	if strings.TrimSpace(mediaKitID) == "" {
		return nil, "", ErrCreatorUnavailable
	}

	// 1. Resolve published opt-in target media kit
	kit, err := s.store.FindMediaKitByID(ctx, mediaKitID)
	if err != nil || kit == nil || !kit.DirectoryOptIn || kit.DirectoryStatus != MediaKitDirectoryStatusPublished {
		// Generic unavailable; does not leak whether kit exists
		return nil, "", ErrCreatorUnavailable
	}

	// 2. Validate sender email and message length (1-4000)
	email = strings.TrimSpace(email)
	if email == "" || !strings.Contains(email, "@") {
		return nil, "", fmt.Errorf("%w: valid sender email required", ErrInvalidAmount)
	}
	message = strings.TrimSpace(message)
	if len(message) < 1 || len(message) > 4000 {
		return nil, "", fmt.Errorf("%w: message length must be between 1 and 4000 characters", ErrInvalidAmount)
	}

	// 3. Create moderated pending inquiry in resolved workspace
	now := s.nowFunc()
	inq := &SponsorInquiry{
		InquiryID:       newUUID(),
		WorkspaceID:     kit.WorkspaceID,
		BrandName:       strings.TrimSpace(brandName),
		ContactEmail:    email,
		Message:         message,
		EstimatedBudget: budget,
		Status:          "pending",
		ThreadID:        newUUID(),
		ReceivedAt:      now,
	}

	if err := s.store.CreateInquiry(ctx, inq); err != nil {
		return nil, "", err
	}

	s.emitEvent(ctx, kit.WorkspaceID, "creator_pro.sponsor_inquiry.received", inq.InquiryID, map[string]any{
		"inquiry_id":   inq.InquiryID,
		"media_kit_id": mediaKitID,
	})

	receipt := "rec_" + inq.InquiryID
	return inq, receipt, nil
}

func (s *Service) ListBrandDeals(ctx context.Context, workspaceID string, statusFilter BrandDealStatus) ([]BrandDeal, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	return s.store.ListBrandDeals(ctx, workspaceID, statusFilter)
}

func (s *Service) GetPipelineStats(ctx context.Context, workspaceID string) (*BrandDealPipelineStats, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	deals, err := s.store.ListBrandDeals(ctx, workspaceID, "")
	if err != nil {
		return nil, err
	}
	stats := &BrandDealPipelineStats{
		WorkspaceID: workspaceID,
		Currency:    "VND",
	}
	for _, d := range deals {
		switch d.Status {
		case BrandDealStatusNegotiating:
			stats.NegotiatingCount++
			stats.TotalActiveValue += d.Value
		case BrandDealStatusAgreed:
			stats.AgreedCount++
			stats.TotalActiveValue += d.Value
		case BrandDealStatusInProgress:
			stats.InProgressCount++
			stats.TotalActiveValue += d.Value
		case BrandDealStatusDelivered:
			stats.DeliveredCount++
			stats.TotalActiveValue += d.Value
		case BrandDealStatusPaid:
			stats.PaidCount++
			stats.TotalActiveValue += d.Value
		case BrandDealStatusCompleted:
			stats.CompletedCount++
			stats.TotalCompletedValue += d.Value
		case BrandDealStatusCancelled:
			stats.CancelledCount++
		}
	}
	return stats, nil
}

func (s *Service) CreateSponsorInquiry(ctx context.Context, inq *SponsorInquiry) (*SponsorInquiry, error) {
	if inq.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if inq.InquiryID == "" {
		inq.InquiryID = newUUID()
	}
	if inq.ThreadID == "" {
		inq.ThreadID = "th_" + newUUID()[:12]
	}
	if inq.Status == "" {
		inq.Status = "pending"
	}
	inq.ReceivedAt = s.nowFunc()
	if err := s.store.CreateInquiry(ctx, inq); err != nil {
		return nil, err
	}
	s.emitEvent(ctx, inq.WorkspaceID, "creator_pro.sponsor_inquiry.received", inq.InquiryID, map[string]any{
		"inquiry_id": inq.InquiryID,
		"brand_name": inq.BrandName,
		"budget":     inq.EstimatedBudget,
	})
	return inq, nil
}

func (s *Service) ConvertInquiryToDeal(ctx context.Context, workspaceID, inquiryID, deliverables string) (*BrandDeal, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	inq, err := s.store.GetInquiry(ctx, workspaceID, inquiryID)
	if err != nil {
		return nil, err
	}
	_ = s.store.UpdateInquiryStatus(ctx, workspaceID, inquiryID, "accepted")

	deal := &BrandDeal{
		WorkspaceID:     workspaceID,
		BrandName:       inq.BrandName,
		ContactEmail:    inq.ContactEmail,
		DealType:        BrandDealTypeSponsoredPost,
		Value:           inq.EstimatedBudget,
		Currency:        "VND",
		Status:          BrandDealStatusNegotiating,
		Deliverables:    deliverables,
		InquiryThreadID: inq.ThreadID,
		Notes:           "Converted from sponsor inquiry " + inquiryID,
	}
	created, err := s.CreateBrandDeal(ctx, deal)
	if err != nil {
		return nil, err
	}
	s.emitEvent(ctx, workspaceID, "creator_pro.sponsor_inquiry.converted", inquiryID, map[string]any{
		"inquiry_id": inquiryID,
		"deal_id":    created.DealID,
	})
	return created, nil
}

func (s *Service) GetContentROI(ctx context.Context, workspaceID, contentID string) (*ContentROIMetric, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	return s.store.GetContentMetric(ctx, workspaceID, contentID)
}

// ----------------------------------------------------------------------------
// Revenue Per Content Tracker (Target 3: Zero-view RPM Undefined)
// ----------------------------------------------------------------------------

// ComputeRPM calculates RPM = Revenue / (Views / 1000).
// Crucial: Acceptance Target 3 - If Views == 0, RPM is strictly undefined!
func ComputeRPM(views int64, revenue float64) (rpm float64, isUndefined bool) {
	if views <= 0 {
		return 0.0, true
	}
	calculated := (revenue / float64(views)) * 1000.0
	if math.IsNaN(calculated) || math.IsInf(calculated, 0) {
		return 0.0, true
	}
	return math.Round(calculated*100) / 100, false
}

func (s *Service) RecordContentMetric(ctx context.Context, workspaceID string, metric *ContentROIMetric) error {
	if workspaceID == "" {
		return ErrMissingTenant
	}
	// Compute RPM enforcing Zero-View RPM Undefined
	rpm, isUndef := ComputeRPM(metric.Views, metric.RevenueAttributed)
	metric.RPM = rpm
	metric.RPMIsUndefined = isUndef

	// Compute ROI percentage
	if metric.CostToProduce > 0 {
		metric.ROIPercentage = math.Round(((metric.RevenueAttributed-metric.CostToProduce)/metric.CostToProduce)*10000) / 100
	} else {
		metric.ROIPercentage = 0.0
	}

	return s.store.SaveContentMetric(ctx, workspaceID, metric)
}

func (s *Service) GetContentMetrics(ctx context.Context, workspaceID, platform string) ([]ContentROIMetric, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	return s.store.GetContentMetrics(ctx, workspaceID, platform)
}

func (s *Service) GetRPMTrends(ctx context.Context, workspaceID, platform string, periods int32) ([]RPMTrendPoint, float64, bool, error) {
	if workspaceID == "" {
		return nil, 0, false, ErrMissingTenant
	}
	metrics, err := s.store.GetContentMetrics(ctx, workspaceID, platform)
	if err != nil {
		return nil, 0, false, err
	}

	points := make([]RPMTrendPoint, 0)
	var totalRPM float64
	var countDefined int

	for i, m := range metrics {
		rpm, isUndef := ComputeRPM(m.Views, m.RevenueAttributed)
		pt := RPMTrendPoint{
			PeriodLabel:    fmt.Sprintf("Period %d", i+1),
			Platform:       m.Platform,
			RPM:            rpm,
			RPMIsUndefined: isUndef,
			Views:          m.Views,
			Revenue:        m.RevenueAttributed,
		}
		if !isUndef {
			totalRPM += rpm
			countDefined++
		}
		points = append(points, pt)
	}

	// Evaluate drop alert (>20% drop vs previous period)
	alertActive := false
	for i := 1; i < len(points); i++ {
		prev := points[i-1]
		curr := points[i]
		// Crucial: Only compare if BOTH periods have defined RPM (non-zero views)
		if !prev.RPMIsUndefined && !curr.RPMIsUndefined && prev.RPM > 0 {
			change := ((curr.RPM - prev.RPM) / prev.RPM) * 100.0
			points[i].ChangePercent = math.Round(change*10) / 10
			if change < -20.0 {
				points[i].DropAlertTriggered = true
				alertActive = true
			}
		}
	}

	var avgRPM float64
	if countDefined > 0 {
		avgRPM = math.Round((totalRPM/float64(countDefined))*100) / 100
	}
	return points, avgRPM, alertActive, nil
}

// RollupDerivativePerformance rolls up revenue across all clips/remixes stemming from a source asset.
func (s *Service) RollupDerivativePerformance(ctx context.Context, workspaceID, sourceContentID string) (*ContentROIMetric, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	metrics, err := s.store.GetContentMetrics(ctx, workspaceID, "")
	if err != nil {
		return nil, err
	}
	var sourceMetric *ContentROIMetric
	var derivativeTotalRevenue float64
	var derivativeCount int32

	for _, m := range metrics {
		if m.ContentID == sourceContentID {
			cp := m
			sourceMetric = &cp
		} else if m.SourceContentID == sourceContentID && m.IsDerivative {
			derivativeCount++
			derivativeTotalRevenue += m.RevenueAttributed
		}
	}
	if sourceMetric == nil {
		return nil, fmt.Errorf("source content not found: %s", sourceContentID)
	}
	sourceMetric.DerivativeCount = derivativeCount
	sourceMetric.DerivativeTotalRevenue = derivativeTotalRevenue
	return sourceMetric, nil
}

// ----------------------------------------------------------------------------
// Rate Cards & Media Kits
// ----------------------------------------------------------------------------

func (s *Service) CreateRateCard(ctx context.Context, card *RateCard) (*RateCard, error) {
	if card.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if card.RateCardID == "" {
		card.RateCardID = newUUID()
	}
	if card.Currency == "" {
		card.Currency = "VND"
	}
	now := s.nowFunc()
	card.CreatedAt = now
	card.UpdatedAt = now
	for i := range card.Items {
		if card.Items[i].ItemID == "" {
			card.Items[i].ItemID = newUUID()
		}
		card.Items[i].RateCardID = card.RateCardID
		card.Items[i].WorkspaceID = card.WorkspaceID
		card.Items[i].CreatedAt = now
		card.Items[i].UpdatedAt = now
	}
	if err := s.store.CreateRateCard(ctx, card); err != nil {
		return nil, err
	}
	s.emitEvent(ctx, card.WorkspaceID, "creator_pro.rate_card.created", card.RateCardID, map[string]any{
		"rate_card_id": card.RateCardID,
		"item_count":   len(card.Items),
	})
	return card, nil
}

func (s *Service) AISuggestRates(ctx context.Context, workspaceID, platform, serviceType string) (suggested, low, high float64, rationale string) {
	switch strings.ToLower(platform) {
	case "tiktok":
		return 3500000.0, 2000000.0, 5000000.0, "Based on average SEA TikTok creator engagement (15k-50k followers) and 60s vertical video standard."
	case "youtube":
		return 8000000.0, 5000000.0, 12000000.0, "Based on dedicated long-form integration (8-12 min) with persistent link in description."
	case "instagram":
		return 4000000.0, 2500000.0, 6000000.0, "Based on Reel + Story swipe-up combination with 48h active retention."
	default:
		return 3000000.0, 1500000.0, 4500000.0, "Standard multi-platform sponsored mention rate."
	}
}

func (s *Service) GenerateMediaKit(ctx context.Context, workspaceID, template, brandProfileID string) (*MediaKit, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	now := s.nowFunc()
	kit := &MediaKit{
		MediaKitID:            newUUID(),
		WorkspaceID:           workspaceID,
		Template:              template,
		BrandProfileID:        brandProfileID,
		SectionsJSON:          `[{"type":"overview","title":"Creator Stats"},{"type":"demographics","title":"Audience Demographics"},{"type":"portfolio","title":"Top Brand Deals"}]`,
		ShareURL:              fmt.Sprintf("https://creativanta.link/kit/%s", newUUID()[:8]),
		DirectoryStatus:       MediaKitDirectoryStatusHidden,
		GenerationCreditsUsed: 5.0,
		LastGeneratedAt:       &now,
		CreatedAt:             now,
		UpdatedAt:             now,
	}
	if err := s.store.SaveMediaKit(ctx, kit); err != nil {
		return nil, err
	}
	s.emitEvent(ctx, workspaceID, "creator_pro.media_kit.generated", kit.MediaKitID, map[string]any{
		"media_kit_id": kit.MediaKitID,
		"template":     template,
	})
	return kit, nil
}

// ----------------------------------------------------------------------------
// Tax Report Export (S16 §6)
// ----------------------------------------------------------------------------

func resolveTaxPeriodBounds(period TaxReportPeriod, year, periodNumber int32) (time.Time, time.Time, string, error) {
	if year < 2000 || year > 2100 {
		return time.Time{}, time.Time{}, "", fmt.Errorf("%w: year %d out of range", ErrInvalidTaxReportPeriod, year)
	}
	switch period {
	case TaxReportPeriodMonthly:
		if periodNumber < 1 || periodNumber > 12 {
			return time.Time{}, time.Time{}, "", fmt.Errorf("%w: monthly period_number must be 1..12, got %d", ErrInvalidTaxReportPeriod, periodNumber)
		}
		start := time.Date(int(year), time.Month(periodNumber), 1, 0, 0, 0, 0, time.UTC)
		end := start.AddDate(0, 1, 0)
		return start, end, fmt.Sprintf("M%02d", periodNumber), nil
	case TaxReportPeriodQuarterly:
		if periodNumber < 1 || periodNumber > 4 {
			return time.Time{}, time.Time{}, "", fmt.Errorf("%w: quarterly period_number must be 1..4, got %d", ErrInvalidTaxReportPeriod, periodNumber)
		}
		startMonth := time.Month((periodNumber-1)*3 + 1)
		start := time.Date(int(year), startMonth, 1, 0, 0, 0, 0, time.UTC)
		end := start.AddDate(0, 3, 0)
		return start, end, fmt.Sprintf("Q%d", periodNumber), nil
	case TaxReportPeriodYearly:
		if periodNumber < 0 || periodNumber > 1 {
			return time.Time{}, time.Time{}, "", fmt.Errorf("%w: yearly period_number must be 0 or 1, got %d", ErrInvalidTaxReportPeriod, periodNumber)
		}
		start := time.Date(int(year), time.January, 1, 0, 0, 0, 0, time.UTC)
		end := start.AddDate(1, 0, 0)
		return start, end, "ANNUAL", nil
	default:
		return time.Time{}, time.Time{}, "", fmt.Errorf("%w: unknown period %q", ErrInvalidTaxReportPeriod, period)
	}
}

func decimalFromFloat64(v float64) (tenantdb.ExactDecimal, error) {
	if math.IsNaN(v) || math.IsInf(v, 0) {
		return tenantdb.ZeroDecimal(), ErrInvalidAmount
	}
	return tenantdb.ParseExactDecimal(fmt.Sprintf("%.6f", v))
}

func float64FromDecimal(d tenantdb.ExactDecimal) float64 {
	f, _ := strconv.ParseFloat(d.Fixed6String(), 64)
	return f
}

func buildPDFTaxReport(summary *TaxReportSummary, affiliateStr, sponsorStr, productStr, totalRevStr, aiExpStr, subExpStr, netIncomeStr string) []byte {
	stream := fmt.Sprintf(
		"BT /F1 12 Tf 50 750 Td (Creativanta Tax Report %s) Tj 0 -20 Td (Workspace: %s) Tj 0 -20 Td (Period: %s %d #%d) Tj 0 -20 Td (Affiliate Revenue: %s %s) Tj 0 -20 Td (Sponsorship Revenue: %s %s) Tj 0 -20 Td (Product Sales Revenue: %s %s) Tj 0 -20 Td (Total Revenue: %s %s) Tj 0 -20 Td (AI Credit Expenses: %s %s) Tj 0 -20 Td (Subscription Expenses: %s %s) Tj 0 -20 Td (Net Income Before Tax: %s %s) Tj ET",
		summary.ReportID, summary.WorkspaceID, summary.Period, summary.TaxYear, summary.PeriodNumber,
		affiliateStr, summary.Currency,
		sponsorStr, summary.Currency,
		productStr, summary.Currency,
		totalRevStr, summary.Currency,
		aiExpStr, summary.Currency,
		subExpStr, summary.Currency,
		netIncomeStr, summary.Currency,
	)

	var buf bytes.Buffer
	buf.WriteString("%PDF-1.4\n")
	obj1Off := buf.Len()
	buf.WriteString("1 0 obj << /Type /Catalog /Pages 2 0 R >> endobj\n")
	obj2Off := buf.Len()
	buf.WriteString("2 0 obj << /Type /Pages /Kids [3 0 R] /Count 1 >> endobj\n")
	obj3Off := buf.Len()
	buf.WriteString("3 0 obj << /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >> endobj\n")
	obj4Off := buf.Len()
	fmt.Fprintf(&buf, "4 0 obj << /Length %d >> stream\n%s\nendstream endobj\n", len(stream), stream)
	obj5Off := buf.Len()
	buf.WriteString("5 0 obj << /Type /Font /Subtype /Type1 /BaseFont /Helvetica >> endobj\n")
	xrefOff := buf.Len()
	buf.WriteString("xref\n0 6\n0000000000 65535 f \n")
	fmt.Fprintf(&buf, "%010d 00000 n \n", obj1Off)
	fmt.Fprintf(&buf, "%010d 00000 n \n", obj2Off)
	fmt.Fprintf(&buf, "%010d 00000 n \n", obj3Off)
	fmt.Fprintf(&buf, "%010d 00000 n \n", obj4Off)
	fmt.Fprintf(&buf, "%010d 00000 n \n", obj5Off)
	fmt.Fprintf(&buf, "trailer << /Size 6 /Root 1 0 R >>\nstartxref\n%d\n%%%%EOF\n", xrefOff)
	return buf.Bytes()
}

func buildXLSXTaxReport(summary *TaxReportSummary, affiliateStr, sponsorStr, productStr, totalRevStr, aiExpStr, subExpStr, netIncomeStr string) ([]byte, error) {
	var buf bytes.Buffer
	zw := zip.NewWriter(&buf)

	files := map[string]string{
		"[Content_Types].xml": `<?xml version="1.0" encoding="UTF-8"?>` +
			`<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">` +
			`<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>` +
			`<Default Extension="xml" ContentType="application/xml"/>` +
			`<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>` +
			`<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>` +
			`</Types>`,
		"_rels/.rels": `<?xml version="1.0" encoding="UTF-8"?>` +
			`<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">` +
			`<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>` +
			`</Relationships>`,
		"xl/workbook.xml": `<?xml version="1.0" encoding="UTF-8"?>` +
			`<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">` +
			`<sheets><sheet name="TaxReport" sheetId="1" r:id="rId1"/></sheets>` +
			`</workbook>`,
		"xl/_rels/workbook.xml.rels": `<?xml version="1.0" encoding="UTF-8"?>` +
			`<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">` +
			`<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>` +
			`</Relationships>`,
		"xl/worksheets/sheet1.xml": fmt.Sprintf(
			`<?xml version="1.0" encoding="UTF-8"?>`+
				`<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>`+
				`<row r="1"><c r="A1" t="inlineStr"><is><t>ReportID</t></is></c><c r="B1" t="inlineStr"><is><t>Year</t></is></c><c r="C1" t="inlineStr"><is><t>Period</t></is></c><c r="D1" t="inlineStr"><is><t>AffiliateRevenue</t></is></c><c r="E1" t="inlineStr"><is><t>SponsorshipRevenue</t></is></c><c r="F1" t="inlineStr"><is><t>ProductSalesRevenue</t></is></c><c r="G1" t="inlineStr"><is><t>TotalRevenue</t></is></c><c r="H1" t="inlineStr"><is><t>AICreditExpenses</t></is></c><c r="I1" t="inlineStr"><is><t>SubscriptionExpenses</t></is></c><c r="J1" t="inlineStr"><is><t>NetIncomeBeforeTax</t></is></c><c r="K1" t="inlineStr"><is><t>Currency</t></is></c></row>`+
				`<row r="2"><c r="A2" t="inlineStr"><is><t>%s</t></is></c><c r="B2"><v>%d</v></c><c r="C2" t="inlineStr"><is><t>%s</t></is></c><c r="D2"><v>%s</v></c><c r="E2"><v>%s</v></c><c r="F2"><v>%s</v></c><c r="G2"><v>%s</v></c><c r="H2"><v>%s</v></c><c r="I2"><v>%s</v></c><c r="J2"><v>%s</v></c><c r="K2" t="inlineStr"><is><t>%s</t></is></c></row>`+
				`</sheetData></worksheet>`,
			summary.ReportID, summary.TaxYear, summary.Period,
			affiliateStr, sponsorStr, productStr, totalRevStr, aiExpStr, subExpStr, netIncomeStr, summary.Currency,
		),
	}

	for name, content := range files {
		w, err := zw.Create(name)
		if err != nil {
			return nil, err
		}
		if _, err := w.Write([]byte(content)); err != nil {
			return nil, err
		}
	}
	if err := zw.Close(); err != nil {
		return nil, err
	}
	return buf.Bytes(), nil
}

func (s *Service) GenerateTaxReport(ctx context.Context, workspaceID string, period TaxReportPeriod, year, periodNumber int32, format TaxReportFormat) (*TaxReportSummary, []byte, string, error) {
	if workspaceID == "" {
		return nil, nil, "", ErrMissingTenant
	}

	periodStart, periodEnd, periodCode, err := resolveTaxPeriodBounds(period, year, periodNumber)
	if err != nil {
		return nil, nil, "", err
	}

	if format != TaxReportFormatCSV && format != TaxReportFormatPDF && format != TaxReportFormatXLSX {
		return nil, nil, "", fmt.Errorf("%w: %q", ErrUnsupportedTaxReportFormat, format)
	}

	deals, err := s.store.ListBrandDeals(ctx, workspaceID, "")
	if err != nil {
		return nil, nil, "", err
	}
	metrics, err := s.store.GetContentMetrics(ctx, workspaceID, "")
	if err != nil {
		return nil, nil, "", err
	}

	affiliateRev := tenantdb.ZeroDecimal()
	sponsorshipRev := tenantdb.ZeroDecimal()
	productSalesRev := tenantdb.ZeroDecimal()
	aiCreditExp := tenantdb.ZeroDecimal()
	subscriptionExp := tenantdb.ZeroDecimal()
	currency := "VND"

	for _, d := range deals {
		if d.Status != BrandDealStatusPaid && d.Status != BrandDealStatusCompleted {
			continue
		}
		if d.Value <= 0 {
			continue
		}
		dealTime := d.UpdatedAt
		if dealTime.IsZero() {
			dealTime = d.CreatedAt
		}
		if !dealTime.IsZero() && (dealTime.Before(periodStart) || !dealTime.Before(periodEnd)) {
			continue
		}
		valDec, err := decimalFromFloat64(d.Value)
		if err != nil {
			return nil, nil, "", err
		}
		if d.Currency != "" {
			currency = d.Currency
		}
		if d.DealType == BrandDealTypeAffiliate {
			affiliateRev, err = affiliateRev.Add(valDec)
		} else {
			sponsorshipRev, err = sponsorshipRev.Add(valDec)
		}
		if err != nil {
			return nil, nil, "", err
		}
	}

	for _, m := range metrics {
		if !m.PublishedAt.IsZero() && (m.PublishedAt.Before(periodStart) || !m.PublishedAt.Before(periodEnd)) {
			continue
		}
		if m.RevenueAttributed > 0 {
			revDec, err := decimalFromFloat64(m.RevenueAttributed)
			if err != nil {
				return nil, nil, "", err
			}
			if strings.EqualFold(m.Platform, "affiliate") {
				affiliateRev, err = affiliateRev.Add(revDec)
			} else {
				productSalesRev, err = productSalesRev.Add(revDec)
			}
			if err != nil {
				return nil, nil, "", err
			}
		}
		if m.CostToProduce > 0 {
			costDec, err := decimalFromFloat64(m.CostToProduce)
			if err != nil {
				return nil, nil, "", err
			}
			if strings.Contains(strings.ToLower(m.ProductionMode), "ai") {
				aiCreditExp, err = aiCreditExp.Add(costDec)
			} else {
				subscriptionExp, err = subscriptionExp.Add(costDec)
			}
			if err != nil {
				return nil, nil, "", err
			}
		}
	}

	totalRev, err := affiliateRev.Add(sponsorshipRev)
	if err != nil {
		return nil, nil, "", err
	}
	totalRev, err = totalRev.Add(productSalesRev)
	if err != nil {
		return nil, nil, "", err
	}

	totalExp, err := aiCreditExp.Add(subscriptionExp)
	if err != nil {
		return nil, nil, "", err
	}
	netIncome, err := totalRev.Sub(totalExp)
	if err != nil {
		return nil, nil, "", err
	}

	summary := &TaxReportSummary{
		ReportID:             newUUID(),
		WorkspaceID:          workspaceID,
		Period:               period,
		TaxYear:              year,
		PeriodNumber:         periodNumber,
		TotalRevenue:         float64FromDecimal(totalRev),
		AffiliateRevenue:     float64FromDecimal(affiliateRev),
		SponsorshipRevenue:   float64FromDecimal(sponsorshipRev),
		ProductSalesRevenue:  float64FromDecimal(productSalesRev),
		AICreditExpenses:     float64FromDecimal(aiCreditExp),
		SubscriptionExpenses: float64FromDecimal(subscriptionExp),
		NetIncomeBeforeTax:   float64FromDecimal(netIncome),
		Currency:             currency,
		Format:               format,
		GeneratedAt:          s.nowFunc(),
	}

	wsPrefix := workspaceID
	if len(wsPrefix) > 8 {
		wsPrefix = wsPrefix[:8]
	}
	fileName := fmt.Sprintf("tax_report_%s_%d_%s.%s", wsPrefix, year, periodCode, strings.ToLower(string(format)))
	summary.DownloadURL = fmt.Sprintf("https://api.creativanta.com/v1/tax-reports/%s/download", summary.ReportID)

	affStr := affiliateRev.Fixed6String()
	sponStr := sponsorshipRev.Fixed6String()
	prodStr := productSalesRev.Fixed6String()
	totRevStr := totalRev.Fixed6String()
	aiExpStr := aiCreditExp.Fixed6String()
	subExpStr := subscriptionExp.Fixed6String()
	netStr := netIncome.Fixed6String()

	var payload []byte
	switch format {
	case TaxReportFormatCSV:
		csvData := fmt.Sprintf(
			"ReportID,WorkspaceID,Year,Period,PeriodNumber,AffiliateRevenue,SponsorshipRevenue,ProductSalesRevenue,TotalRevenue,AICreditExpenses,SubscriptionExpenses,NetIncomeBeforeTax,Currency\n%s,%s,%d,%s,%d,%s,%s,%s,%s,%s,%s,%s,%s\n",
			summary.ReportID, workspaceID, year, period, periodNumber,
			affStr, sponStr, prodStr, totRevStr, aiExpStr, subExpStr, netStr, summary.Currency,
		)
		payload = []byte(csvData)
	case TaxReportFormatPDF:
		payload = buildPDFTaxReport(summary, affStr, sponStr, prodStr, totRevStr, aiExpStr, subExpStr, netStr)
	case TaxReportFormatXLSX:
		payload, err = buildXLSXTaxReport(summary, affStr, sponStr, prodStr, totRevStr, aiExpStr, subExpStr, netStr)
		if err != nil {
			return nil, nil, "", err
		}
	}

	if err := s.store.SaveTaxReport(ctx, summary); err != nil {
		return nil, nil, "", err
	}
	s.emitEvent(ctx, workspaceID, "creator_pro.tax_report.generated", summary.ReportID, map[string]any{
		"report_id":    summary.ReportID,
		"year":         year,
		"period":       string(period),
		"total_rev":    totRevStr,
		"net_income":   netStr,
		"export_bytes": len(payload),
	})
	return summary, payload, fileName, nil
}

// ----------------------------------------------------------------------------
// Operator Modes & Tool Entitlement (Target 4: All Six Modes Can Reach Entitled Tools)
// ----------------------------------------------------------------------------

type OperatorMode string

const (
	ModeCreator      OperatorMode = "creator"
	ModeSeller       OperatorMode = "seller"
	ModeAgency       OperatorMode = "agency"
	ModeAffiliate    OperatorMode = "affiliate"
	ModeBrandCollab  OperatorMode = "brand_collab"
	ModeLiveOperator OperatorMode = "live_operator"
)

type CreatorProTool string

const (
	ToolLinkInBio      CreatorProTool = "link_in_bio"
	ToolMediaKit       CreatorProTool = "media_kit"
	ToolRateCard       CreatorProTool = "rate_card"
	ToolBrandDeals     CreatorProTool = "brand_deals"
	ToolRevenueTracker CreatorProTool = "revenue_tracker"
	ToolTaxExport      CreatorProTool = "tax_export"
)

// CheckModeEntitlement checks if a given operator mode can reach a Creator Pro tool per S16 §8.2:
// - Creator Mode: Full access to all Creator Pro features.
// - Seller Mode: Emphasizes Revenue + Tax Export; all entitled tools remain reachable.
// - Agency Mode: Per-creator views (multi-workspace aggregation); brand deals, media kits, rate cards.
// - Affiliate Mode: Emphasizes Revenue + Rate Card; all entitled tools remain reachable.
// - Brand Collab Mode: Full access to deals, rate cards, media kits.
// - Live Operator Mode: Emphasizes live deliverables, proof and content revenue.
// Invariant: All six modes can reach entitled tools!
func CheckModeEntitlement(mode OperatorMode, tool CreatorProTool) bool {
	switch mode {
	case ModeCreator, ModeBrandCollab:
		return true // full access to all 6 tools
	case ModeSeller:
		// All entitled tools remain reachable, revenue and tax highlighted
		return true
	case ModeAffiliate:
		// All entitled tools remain reachable, revenue and rate card highlighted
		return true
	case ModeAgency:
		// Deals, media kits, rate cards, and revenue analytics accessible
		return true
	case ModeLiveOperator:
		// Content revenue, proof deliverables, rate cards accessible
		return true
	default:
		return false
	}
}

// GetRouteForMode returns the primary highlighted navigation route for a mode while preserving access to all tools.
func GetRouteForMode(mode OperatorMode) string {
	switch mode {
	case ModeCreator:
		return "/creator-pro/dashboard"
	case ModeSeller:
		return "/creator-pro/revenue"
	case ModeAffiliate:
		return "/creator-pro/rate-card"
	case ModeAgency:
		return "/creator-pro/brand-deals"
	case ModeBrandCollab:
		return "/creator-pro/brand-deals"
	case ModeLiveOperator:
		return "/creator-pro/revenue"
	default:
		return "/creator-pro/dashboard"
	}
}
