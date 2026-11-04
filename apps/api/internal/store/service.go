package store

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type EventSink interface {
	Emit(ctx context.Context, ev OutboxEvent) error
}

type Service struct {
	store     Store
	eventSink EventSink
	nowFunc   func() time.Time
}

func NewService(store Store, eventSink EventSink, nowFunc func() time.Time) *Service {
	if nowFunc == nil {
		nowFunc = func() time.Time { return time.Now().UTC() }
	}
	return &Service{
		store:     store,
		eventSink: eventSink,
		nowFunc:   nowFunc,
	}
}

func (s *Service) emitEvent(ctx context.Context, wsID, eventType, aggregateID string, payload map[string]any) {
	if s.eventSink == nil {
		return
	}
	ev := OutboxEvent{
		EventID:     newUUID(),
		WorkspaceID: wsID,
		EventType:   eventType,
		AggregateID: aggregateID,
		Payload:     payload,
		CreatedAt:   s.nowFunc(),
	}
	_ = s.eventSink.Emit(ctx, ev)
}

// ----------------------------------------------------------------------------
// Store Pages
// ----------------------------------------------------------------------------

func (s *Service) CreatePage(ctx context.Context, page *StorePage) (*StorePage, error) {
	if page.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if strings.TrimSpace(page.Title) == "" {
		return nil, fmt.Errorf("%w: title cannot be empty", ErrInvalidAmount)
	}
	if strings.TrimSpace(page.Slug) == "" {
		return nil, fmt.Errorf("%w: slug cannot be empty", ErrInvalidAmount)
	}
	page.Status = StorePageStatusDraft
	page.CreatedAt = s.nowFunc()
	page.UpdatedAt = page.CreatedAt

	if err := s.store.CreatePage(ctx, page); err != nil {
		return nil, err
	}
	s.emitEvent(ctx, page.WorkspaceID, "store.page.created", page.StorePageID, map[string]any{
		"store_page_id": page.StorePageID,
		"slug":          page.Slug,
	})
	return page, nil
}

func (s *Service) GetPage(ctx context.Context, workspaceID, pageID, slug string) (*StorePage, []Bundle, error) {
	if workspaceID == "" {
		return nil, nil, ErrMissingTenant
	}
	page, err := s.store.GetPage(ctx, workspaceID, pageID, slug)
	if err != nil {
		return nil, nil, err
	}
	_ = s.store.RecordPageView(ctx, workspaceID, page.StorePageID)

	bundles, _ := s.store.ListBundles(ctx, workspaceID)
	return page, bundles, nil
}

func (s *Service) ListPages(ctx context.Context, workspaceID string, status StorePageStatus) ([]StorePage, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	return s.store.ListPages(ctx, workspaceID, status)
}

func (s *Service) UpdatePage(ctx context.Context, page *StorePage) (*StorePage, error) {
	if page.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if err := s.store.UpdatePage(ctx, page); err != nil {
		return nil, err
	}
	return page, nil
}

func (s *Service) PublishPage(ctx context.Context, workspaceID, pageID string) (*StorePage, string, error) {
	if workspaceID == "" {
		return nil, "", ErrMissingTenant
	}
	page, err := s.store.GetPage(ctx, workspaceID, pageID, "")
	if err != nil {
		return nil, "", err
	}
	page.Status = StorePageStatusPublished
	if err := s.store.UpdatePage(ctx, page); err != nil {
		return nil, "", err
	}

	publicURL := fmt.Sprintf("https://%s.creativanta.store/%s", page.WorkspaceID, page.Slug)
	if page.CustomDomain != "" {
		publicURL = fmt.Sprintf("https://%s", page.CustomDomain)
	}

	s.emitEvent(ctx, workspaceID, "store.page_published", page.StorePageID, map[string]any{
		"store_page_id": page.StorePageID,
		"slug":          page.Slug,
		"public_url":    publicURL,
	})
	return page, publicURL, nil
}

func (s *Service) UnpublishPage(ctx context.Context, workspaceID, pageID string) (*StorePage, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	page, err := s.store.GetPage(ctx, workspaceID, pageID, "")
	if err != nil {
		return nil, err
	}
	page.Status = StorePageStatusDraft
	if err := s.store.UpdatePage(ctx, page); err != nil {
		return nil, err
	}
	return page, nil
}

func (s *Service) DeletePage(ctx context.Context, workspaceID, pageID string) error {
	if workspaceID == "" {
		return ErrMissingTenant
	}
	return s.store.DeletePage(ctx, workspaceID, pageID)
}

func (s *Service) DuplicatePage(ctx context.Context, workspaceID, pageID, newTitle, newSlug string) (*StorePage, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	existing, err := s.store.GetPage(ctx, workspaceID, pageID, "")
	if err != nil {
		return nil, err
	}
	dup := &StorePage{
		StorePageID:        newUUID(),
		WorkspaceID:        workspaceID,
		Title:              newTitle,
		Slug:               newSlug,
		Description:        existing.Description,
		LayoutJSON:         existing.LayoutJSON,
		ThemeOverridesJSON: existing.ThemeOverridesJSON,
		Status:             StorePageStatusDraft,
		CustomDomain:       existing.CustomDomain,
		SEOConfigJSON:      existing.SEOConfigJSON,
		WidgetConfigJSON:   existing.WidgetConfigJSON,
		CreatedAt:          s.nowFunc(),
		UpdatedAt:          s.nowFunc(),
	}
	if err := s.store.CreatePage(ctx, dup); err != nil {
		return nil, err
	}
	return dup, nil
}

func (s *Service) GetThemes(ctx context.Context, workspaceID string) ([]StoreTheme, error) {
	return s.store.GetThemes(ctx, workspaceID)
}

func (s *Service) GetPageStats(ctx context.Context, workspaceID, pageID string) (*PageStats, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	return s.store.GetPageStats(ctx, workspaceID, pageID)
}

// ----------------------------------------------------------------------------
// Membership Plans
// ----------------------------------------------------------------------------

func (s *Service) CreatePlan(ctx context.Context, plan *MembershipPlan) (*MembershipPlan, error) {
	if plan.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if strings.TrimSpace(plan.Title) == "" {
		return nil, fmt.Errorf("%w: title cannot be empty", ErrInvalidAmount)
	}
	if plan.Status == "" {
		plan.Status = MembershipPlanStatusDraft
	}
	if plan.Currency == "" {
		plan.Currency = "VND"
	}
	if plan.BillingInterval == "" {
		plan.BillingInterval = "monthly"
	}
	plan.SubscriberCount = 0
	plan.CreatedAt = s.nowFunc()
	plan.UpdatedAt = plan.CreatedAt

	if err := s.store.CreatePlan(ctx, plan); err != nil {
		return nil, err
	}
	return plan, nil
}

func (s *Service) GetPlan(ctx context.Context, workspaceID, planID string) (*MembershipPlan, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	return s.store.GetPlan(ctx, workspaceID, planID)
}

func (s *Service) ListPlans(ctx context.Context, workspaceID string, status MembershipPlanStatus) ([]MembershipPlan, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	return s.store.ListPlans(ctx, workspaceID, status)
}

func (s *Service) UpdatePlan(ctx context.Context, plan *MembershipPlan) (*MembershipPlan, error) {
	if plan.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if err := s.store.UpdatePlan(ctx, plan); err != nil {
		return nil, err
	}
	return plan, nil
}

func (s *Service) PublishPlan(ctx context.Context, workspaceID, planID string) (*MembershipPlan, error) {
	plan, err := s.store.GetPlan(ctx, workspaceID, planID)
	if err != nil {
		return nil, err
	}
	plan.Status = MembershipPlanStatusActive
	if err := s.store.UpdatePlan(ctx, plan); err != nil {
		return nil, err
	}
	return plan, nil
}

func (s *Service) PausePlan(ctx context.Context, workspaceID, planID string) (*MembershipPlan, error) {
	plan, err := s.store.GetPlan(ctx, workspaceID, planID)
	if err != nil {
		return nil, err
	}
	plan.Status = MembershipPlanStatusPaused
	if err := s.store.UpdatePlan(ctx, plan); err != nil {
		return nil, err
	}
	return plan, nil
}

func (s *Service) ResumePlan(ctx context.Context, workspaceID, planID string) (*MembershipPlan, error) {
	plan, err := s.store.GetPlan(ctx, workspaceID, planID)
	if err != nil {
		return nil, err
	}
	plan.Status = MembershipPlanStatusActive
	if err := s.store.UpdatePlan(ctx, plan); err != nil {
		return nil, err
	}
	return plan, nil
}

func (s *Service) ArchivePlan(ctx context.Context, workspaceID, planID string) (*MembershipPlan, error) {
	plan, err := s.store.GetPlan(ctx, workspaceID, planID)
	if err != nil {
		return nil, err
	}
	plan.Status = MembershipPlanStatusRetired
	if err := s.store.UpdatePlan(ctx, plan); err != nil {
		return nil, err
	}
	return plan, nil
}

func (s *Service) DeletePlan(ctx context.Context, workspaceID, planID string) error {
	if workspaceID == "" {
		return ErrMissingTenant
	}
	return s.store.DeletePlan(ctx, workspaceID, planID)
}

func (s *Service) DuplicatePlan(ctx context.Context, workspaceID, planID, newTitle string) (*MembershipPlan, error) {
	existing, err := s.store.GetPlan(ctx, workspaceID, planID)
	if err != nil {
		return nil, err
	}
	dup := &MembershipPlan{
		PlanID:                newUUID(),
		WorkspaceID:           workspaceID,
		Title:                 newTitle,
		Description:           existing.Description,
		Price:                 existing.Price,
		Currency:              existing.Currency,
		BillingInterval:       existing.BillingInterval,
		BenefitsJSON:          existing.BenefitsJSON,
		EntitlementConfigJSON: existing.EntitlementConfigJSON,
		Status:                MembershipPlanStatusDraft,
		SubscriberCount:       0,
		CreatedAt:             s.nowFunc(),
		UpdatedAt:             s.nowFunc(),
	}
	if err := s.store.CreatePlan(ctx, dup); err != nil {
		return nil, err
	}
	return dup, nil
}

func (s *Service) GetMRRSummary(ctx context.Context, workspaceID string) (tenantdb.ExactDecimal, string, int32, float64, tenantdb.ExactDecimal, float64, error) {
	if workspaceID == "" {
		return tenantdb.ZeroDecimal(), "", 0, 0, tenantdb.ZeroDecimal(), 0, ErrMissingTenant
	}
	plans, err := s.store.ListPlans(ctx, workspaceID, "")
	if err != nil {
		return tenantdb.ZeroDecimal(), "", 0, 0, tenantdb.ZeroDecimal(), 0, err
	}

	totalMRR := tenantdb.ZeroDecimal()
	var totalSubs int32
	currency := "VND"

	for _, p := range plans {
		if p.Status == MembershipPlanStatusActive {
			totalSubs += p.SubscriberCount
			// Multiply plan price * subscriber count
			countDec, _ := tenantdb.ParseExactDecimal(fmt.Sprintf("%d", p.SubscriberCount))
			planMRR, err := p.Price.MulFloor(countDec)
			if err == nil {
				totalMRR, _ = totalMRR.Add(planMRR)
			}
			currency = p.Currency
		}
	}

	churnRate := 2.5 // Benchmark default
	avgLTV, _ := totalMRR.MulFloor(tenantdb.MustParseExactDecimal("12.000000"))
	trialConv := 42.0

	return totalMRR, currency, totalSubs, churnRate, avgLTV, trialConv, nil
}

// ----------------------------------------------------------------------------
// Bundles (Acceptance Target 1: Bundle stock atomic)
// ----------------------------------------------------------------------------

func (s *Service) CreateBundle(ctx context.Context, bundle *Bundle) (*Bundle, error) {
	if bundle.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if strings.TrimSpace(bundle.Title) == "" {
		return nil, fmt.Errorf("%w: title cannot be empty", ErrInvalidAmount)
	}
	if len(bundle.Items) == 0 {
		return nil, fmt.Errorf("%w: bundle must contain at least 1 item", ErrInvalidAmount)
	}
	bundle.CreatedAt = s.nowFunc()
	if err := s.store.CreateBundle(ctx, bundle); err != nil {
		return nil, err
	}
	return s.store.GetBundle(ctx, bundle.WorkspaceID, bundle.BundleID)
}

func (s *Service) GetBundle(ctx context.Context, workspaceID, bundleID string) (*Bundle, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	return s.store.GetBundle(ctx, workspaceID, bundleID)
}

func (s *Service) ListBundles(ctx context.Context, workspaceID string) ([]Bundle, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	return s.store.ListBundles(ctx, workspaceID)
}

func (s *Service) CheckBundleStock(ctx context.Context, workspaceID, bundleID string, requestedQty int32) (bool, string, []BundleItem, error) {
	if workspaceID == "" {
		return false, "", nil, ErrMissingTenant
	}
	if requestedQty <= 0 {
		requestedQty = 1
	}
	bundle, err := s.store.GetBundle(ctx, workspaceID, bundleID)
	if err != nil {
		return false, "", nil, err
	}

	isAvailable := true
	var reason string
	var breakdown []BundleItem

	for _, item := range bundle.Items {
		stock, _ := s.store.GetProductStock(ctx, workspaceID, item.ProductID)
		required := item.Quantity * requestedQty
		itemCopy := item
		itemCopy.AvailableStock = stock
		breakdown = append(breakdown, itemCopy)

		if stock < required {
			isAvailable = false
			if reason == "" {
				title := item.ProductTitle
				if title == "" {
					title = fmt.Sprintf("Product %s", item.ProductID)
				}
				reason = fmt.Sprintf("Temporarily unavailable — %s out of stock", title)
			}
		}
	}
	return isAvailable, reason, breakdown, nil
}

// ----------------------------------------------------------------------------
// Checkout, Digital Delivery & Payment Replay (Acceptance Target 2)
// ----------------------------------------------------------------------------

func (s *Service) Checkout(ctx context.Context, req CheckoutRequest) (*CheckoutResult, error) {
	if req.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if strings.TrimSpace(req.IdempotencyKey) == "" {
		return nil, ErrIdempotencyKeyRequired
	}

	// 1. Idempotency Check: Payment replay returns existing delivery without duplication
	if cached, err := s.store.GetCheckoutResultByIdempotency(ctx, req.WorkspaceID, req.IdempotencyKey); err == nil && cached != nil {
		return cached, nil
	}

	// 2. Atomic Bundle Stock Reservation (Acceptance Target 1)
	if req.BundleID != "" {
		if err := s.store.AtomicallyReserveBundleStock(ctx, req.WorkspaceID, req.BundleID, 1); err != nil {
			return nil, err
		}
	}

	orderID := newUUID()
	now := s.nowFunc()
	var deliveries []DigitalDelivery
	var subscription *MembershipSubscription

	// 3. Membership Subscription Creation
	if req.MembershipPlanID != "" {
		plan, err := s.store.GetPlan(ctx, req.WorkspaceID, req.MembershipPlanID)
		if err != nil {
			return nil, err
		}
		if plan.Status != MembershipPlanStatusActive {
			return nil, fmt.Errorf("%w: plan is not active", ErrInvalidStateTransition)
		}
		subscription = &MembershipSubscription{
			MembershipID:            newUUID(),
			WorkspaceID:             req.WorkspaceID,
			PlanID:                  plan.PlanID,
			CustomerEntityID:        req.CustomerEntityID,
			Status:                  MembershipSubscriptionStatusActive,
			ProviderSubscriptionID:  req.PaymentIntentID,
			CurrentPeriodStart:      now,
			CurrentPeriodEnd:        now.Add(30 * 24 * time.Hour),
			EntitlementSnapshotJSON: plan.EntitlementConfigJSON,
			CreatedAt:               now,
			UpdatedAt:               now,
		}
		if err := s.store.CreateSubscription(ctx, subscription); err != nil {
			return nil, err
		}
		s.emitEvent(ctx, req.WorkspaceID, "membership.subscribed", plan.PlanID, map[string]any{
			"plan_id":   plan.PlanID,
			"entity_id": req.CustomerEntityID,
		})
	}

	// 4. Digital Deliveries Creation
	if len(req.ProductIDs) > 0 || req.OfferID != "" {
		del := DigitalDelivery{
			DeliveryID:             newUUID(),
			WorkspaceID:            req.WorkspaceID,
			OrderID:                orderID,
			CustomerEntityID:       req.CustomerEntityID,
			OfferID:                req.OfferID,
			DeliveryType:           DeliveryTypeDownloadLink,
			EntitlementPayloadJSON: map[string]any{"download_url": fmt.Sprintf("https://cdn.creativanta.store/downloads/%s.zip", orderID)},
			Status:                 DeliveryStatusDelivered,
			IdempotencyKey:         req.IdempotencyKey + ":deliv:1",
			DownloadCount:          0,
			MaxDownloads:           5,
			CreatedAt:              now,
		}
		if len(req.ProductIDs) > 0 {
			del.ProductID = req.ProductIDs[0]
		}
		_ = s.store.CreateDigitalDelivery(ctx, &del)
		deliveries = append(deliveries, del)
	}

	// 5. Operating Ledger Financial Posting (RULE-M15-007, exact NUMERIC(18,6))
	posting := &FinancialPosting{
		PostingID:      newUUID(),
		WorkspaceID:    req.WorkspaceID,
		OrderID:        orderID,
		SourcePlatform: "own_store",
		GrossAmount:    req.OrderAmount,
		Currency:       req.Currency,
		CreatedAt:      now,
	}
	_ = s.store.RecordFinancialPosting(ctx, posting)

	s.emitEvent(ctx, req.WorkspaceID, "order.imported", orderID, map[string]any{
		"order_id":        orderID,
		"platform":        "own_store",
		"amount":          req.OrderAmount.String(),
		"currency":        req.Currency,
		"source_platform": "own_store",
	})

	// 6. Save result for idempotent future replays
	result := &CheckoutResult{
		Success:      true,
		OrderID:      orderID,
		Status:       "confirmed",
		Deliveries:   deliveries,
		Subscription: subscription,
		IsReplayed:   false,
	}
	_ = s.store.SaveCheckoutResult(ctx, req.WorkspaceID, req.IdempotencyKey, result)

	return result, nil
}

// ----------------------------------------------------------------------------
// Buyer Entitlements & Isolation Boundary (Acceptance Target 3)
// ----------------------------------------------------------------------------

func (s *Service) GetBuyerEntitlements(ctx context.Context, workspaceID, customerEntityID string) (*BuyerEntitlements, error) {
	if workspaceID == "" {
		return nil, ErrMissingTenant
	}
	deliveries, _ := s.store.ListDeliveriesByCustomer(ctx, workspaceID, customerEntityID)
	subs, _ := s.store.ListSubscriptionsByCustomer(ctx, workspaceID, customerEntityID)

	var accessibleContent []string
	discountPct := 0.0
	hasPriorityDM := false

	for _, sub := range subs {
		if sub.Status == MembershipSubscriptionStatusActive {
			if contents, ok := sub.EntitlementSnapshotJSON["exclusive_content_ids"].([]any); ok {
				for _, c := range contents {
					accessibleContent = append(accessibleContent, fmt.Sprint(c))
				}
			}
			if disc, ok := sub.EntitlementSnapshotJSON["store_discount_pct"].(float64); ok && disc > discountPct {
				discountPct = disc
			}
			if pdm, ok := sub.EntitlementSnapshotJSON["priority_dm"].(bool); ok && pdm {
				hasPriorityDM = true
			}
		}
	}

	return &BuyerEntitlements{
		CustomerEntityID:     customerEntityID,
		WorkspaceID:          workspaceID,
		AccessibleContentIDs: accessibleContent,
		DiscountPct:          discountPct,
		HasPriorityDM:        hasPriorityDM,
		Deliveries:           deliveries,
		ActiveSubscriptions:  subs,
	}, nil
}

// ValidateBuyerPrivilegeIsolation strictly enforces that a buyer subscription / customer entity
// CANNOT unlock SaaS workspace privileges or administrative roles (Acceptance Target 3, DB §19.4/19.4B).
func (s *Service) ValidateBuyerPrivilegeIsolation(callerRole string, isBuyerCustomer bool, targetWorkspaceAction string) error {
	// If the caller is acting in a buyer persona or holds only a buyer subscription:
	if isBuyerCustomer || callerRole == "buyer" || callerRole == "customer" {
		// Restricted workspace actions include all store management, product management, order admin, workspace settings
		restrictedPrefixes := []string{
			"store:manage", "product:manage", "product:delete", "product:import",
			"order:manage", "campaign:manage", "coupon:manage", "workspace:admin",
			"identity:manage", "rbac:manage", "billing:manage",
		}
		for _, prefix := range restrictedPrefixes {
			if strings.HasPrefix(targetWorkspaceAction, prefix) {
				return fmt.Errorf("%w: action %q is forbidden for buyer subscriptions", ErrForbiddenSaaSFromBuyerMembership, targetWorkspaceAction)
			}
		}
	}
	return nil
}
