package store

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// Store defines persistence operations for Module M15 (Creator Store / Memberships / Bundles).
type Store interface {
	// Store Pages
	CreatePage(ctx context.Context, page *StorePage) error
	GetPage(ctx context.Context, workspaceID, pageID, slug string) (*StorePage, error)
	ListPages(ctx context.Context, workspaceID string, status StorePageStatus) ([]StorePage, error)
	UpdatePage(ctx context.Context, page *StorePage) error
	DeletePage(ctx context.Context, workspaceID, pageID string) error
	GetPageStats(ctx context.Context, workspaceID, pageID string) (*PageStats, error)
	RecordPageView(ctx context.Context, workspaceID, pageID string) error
	GetThemes(ctx context.Context, workspaceID string) ([]StoreTheme, error)

	// Membership Plans
	CreatePlan(ctx context.Context, plan *MembershipPlan) error
	GetPlan(ctx context.Context, workspaceID, planID string) (*MembershipPlan, error)
	ListPlans(ctx context.Context, workspaceID string, status MembershipPlanStatus) ([]MembershipPlan, error)
	UpdatePlan(ctx context.Context, plan *MembershipPlan) error
	DeletePlan(ctx context.Context, workspaceID, planID string) error

	// Membership Subscriptions
	CreateSubscription(ctx context.Context, sub *MembershipSubscription) error
	GetSubscription(ctx context.Context, workspaceID, subID string) (*MembershipSubscription, error)
	GetSubscriptionByProviderID(ctx context.Context, workspaceID, providerSubID string) (*MembershipSubscription, error)
	ListSubscriptionsByCustomer(ctx context.Context, workspaceID, customerEntityID string) ([]MembershipSubscription, error)
	UpdateSubscription(ctx context.Context, sub *MembershipSubscription) error

	// Bundles
	CreateBundle(ctx context.Context, bundle *Bundle) error
	GetBundle(ctx context.Context, workspaceID, bundleID string) (*Bundle, error)
	ListBundles(ctx context.Context, workspaceID string) ([]Bundle, error)
	UpdateBundle(ctx context.Context, bundle *Bundle) error

	// Component Stock Tracking & Atomic Reservation (Acceptance Target 1)
	GetProductStock(ctx context.Context, workspaceID, productID string) (int32, error)
	SetProductStock(ctx context.Context, workspaceID, productID string, stock int32) error
	AtomicallyReserveBundleStock(ctx context.Context, workspaceID, bundleID string, quantity int32) error

	// Payment Replay & Digital Delivery Tracking (Acceptance Target 2)
	GetCheckoutResultByIdempotency(ctx context.Context, workspaceID, idempotencyKey string) (*CheckoutResult, error)
	SaveCheckoutResult(ctx context.Context, workspaceID, idempotencyKey string, res *CheckoutResult) error
	CreateDigitalDelivery(ctx context.Context, delivery *DigitalDelivery) error
	ListDeliveriesByCustomer(ctx context.Context, workspaceID, customerEntityID string) ([]DigitalDelivery, error)
	RecordFinancialPosting(ctx context.Context, posting *FinancialPosting) error
	ListFinancialPostings(ctx context.Context, workspaceID string) ([]FinancialPosting, error)
}

// MemoryStore provides a thread-safe in-memory store for unit and concurrency test suites.
type MemoryStore struct {
	mu            sync.RWMutex
	pages         map[string]*StorePage              // key: pageID
	pageSlugs     map[string]string                  // key: workspaceID + ":" + slug -> pageID
	pageViews     map[string]int64                   // key: pageID -> count
	pageOrders    map[string]int64                   // key: pageID -> count
	pageRevenue   map[string]tenantdb.ExactDecimal   // key: pageID -> amount
	plans         map[string]*MembershipPlan         // key: planID
	subscriptions map[string]*MembershipSubscription // key: subID
	subByProvider map[string]string                  // key: workspaceID + ":" + providerSubID -> subID
	bundles       map[string]*Bundle                 // key: bundleID
	productStock  map[string]int32                   // key: workspaceID + ":" + productID -> stock
	deliveries    map[string]*DigitalDelivery        // key: deliveryID
	checkouts     map[string]*CheckoutResult         // key: workspaceID + ":" + idempotencyKey -> result
	postings      []FinancialPosting
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		pages:         make(map[string]*StorePage),
		pageSlugs:     make(map[string]string),
		pageViews:     make(map[string]int64),
		pageOrders:    make(map[string]int64),
		pageRevenue:   make(map[string]tenantdb.ExactDecimal),
		plans:         make(map[string]*MembershipPlan),
		subscriptions: make(map[string]*MembershipSubscription),
		subByProvider: make(map[string]string),
		bundles:       make(map[string]*Bundle),
		productStock:  make(map[string]int32),
		deliveries:    make(map[string]*DigitalDelivery),
		checkouts:     make(map[string]*CheckoutResult),
		postings:      make([]FinancialPosting, 0),
	}
}

// ----------------------------------------------------------------------------
// Store Pages Implementation
// ----------------------------------------------------------------------------

func (m *MemoryStore) CreatePage(_ context.Context, page *StorePage) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	slugKey := page.WorkspaceID + ":" + page.Slug
	if _, exists := m.pageSlugs[slugKey]; exists {
		return ErrDuplicatePageSlug
	}
	if page.StorePageID == "" {
		page.StorePageID = newUUID()
	}
	if page.CreatedAt.IsZero() {
		page.CreatedAt = time.Now().UTC()
	}
	page.UpdatedAt = page.CreatedAt

	m.pages[page.StorePageID] = page
	m.pageSlugs[slugKey] = page.StorePageID
	return nil
}

func (m *MemoryStore) GetPage(_ context.Context, workspaceID, pageID, slug string) (*StorePage, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	if pageID != "" {
		p, ok := m.pages[pageID]
		if !ok || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
			return nil, ErrPageNotFound
		}
		return p, nil
	}
	if slug != "" {
		targetID, ok := m.pageSlugs[workspaceID+":"+slug]
		if !ok {
			return nil, ErrPageNotFound
		}
		p, ok2 := m.pages[targetID]
		if !ok2 || p.DeletedAt != nil {
			return nil, ErrPageNotFound
		}
		return p, nil
	}
	return nil, ErrPageNotFound
}

func (m *MemoryStore) ListPages(_ context.Context, workspaceID string, status StorePageStatus) ([]StorePage, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []StorePage
	for _, p := range m.pages {
		if p.WorkspaceID == workspaceID && p.DeletedAt == nil {
			if status != "" && p.Status != status {
				continue
			}
			result = append(result, *p)
		}
	}
	return result, nil
}

func (m *MemoryStore) UpdatePage(_ context.Context, page *StorePage) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.pages[page.StorePageID]
	if !ok || existing.WorkspaceID != page.WorkspaceID || existing.DeletedAt != nil {
		return ErrPageNotFound
	}
	if existing.Slug != page.Slug {
		delete(m.pageSlugs, existing.WorkspaceID+":"+existing.Slug)
		m.pageSlugs[page.WorkspaceID+":"+page.Slug] = page.StorePageID
	}
	page.UpdatedAt = time.Now().UTC()
	m.pages[page.StorePageID] = page
	return nil
}

func (m *MemoryStore) DeletePage(_ context.Context, workspaceID, pageID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.pages[pageID]
	if !ok || existing.WorkspaceID != workspaceID || existing.DeletedAt != nil {
		return ErrPageNotFound
	}
	now := time.Now().UTC()
	existing.DeletedAt = &now
	delete(m.pageSlugs, existing.WorkspaceID+":"+existing.Slug)
	return nil
}

func (m *MemoryStore) GetPageStats(_ context.Context, workspaceID, pageID string) (*PageStats, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	p, ok := m.pages[pageID]
	if !ok || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return nil, ErrPageNotFound
	}
	views := m.pageViews[pageID]
	orders := m.pageOrders[pageID]
	var cvr float64
	if views > 0 {
		cvr = (float64(orders) / float64(views)) * 100.0
	}
	rev, hasRev := m.pageRevenue[pageID]
	if !hasRev {
		rev = tenantdb.ZeroDecimal()
	}

	return &PageStats{
		StorePageID:    pageID,
		Views:          views,
		Orders:         orders,
		ConversionRate: cvr,
		Revenue:        rev,
		Currency:       "VND",
	}, nil
}

func (m *MemoryStore) RecordPageView(_ context.Context, workspaceID, pageID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	p, ok := m.pages[pageID]
	if !ok || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return ErrPageNotFound
	}
	m.pageViews[pageID]++
	return nil
}

func (m *MemoryStore) GetThemes(_ context.Context, _ string) ([]StoreTheme, error) {
	return []StoreTheme{
		{
			ThemeID:      "theme_modern_default",
			Name:         "Modern Minimal",
			PrimaryColor: "#3B82F6",
			FontFamily:   "Inter, sans-serif",
			BorderRadius: "8px",
			IsDefault:    true,
		},
		{
			ThemeID:      "theme_creator_bold",
			Name:         "Creator Bold",
			PrimaryColor: "#F43F5E",
			FontFamily:   "Poppins, sans-serif",
			BorderRadius: "16px",
			IsDefault:    false,
		},
		{
			ThemeID:      "theme_luxury_dark",
			Name:         "Midnight Luxury",
			PrimaryColor: "#F59E0B",
			FontFamily:   "Playfair Display, serif",
			BorderRadius: "4px",
			IsDefault:    false,
		},
	}, nil
}

// ----------------------------------------------------------------------------
// Membership Plans Implementation
// ----------------------------------------------------------------------------

func (m *MemoryStore) CreatePlan(_ context.Context, plan *MembershipPlan) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if plan.PlanID == "" {
		plan.PlanID = newUUID()
	}
	if plan.CreatedAt.IsZero() {
		plan.CreatedAt = time.Now().UTC()
	}
	plan.UpdatedAt = plan.CreatedAt
	m.plans[plan.PlanID] = plan
	return nil
}

func (m *MemoryStore) GetPlan(_ context.Context, workspaceID, planID string) (*MembershipPlan, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	p, ok := m.plans[planID]
	if !ok || p.WorkspaceID != workspaceID || p.DeletedAt != nil {
		return nil, ErrPlanNotFound
	}
	return p, nil
}

func (m *MemoryStore) ListPlans(_ context.Context, workspaceID string, status MembershipPlanStatus) ([]MembershipPlan, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []MembershipPlan
	for _, p := range m.plans {
		if p.WorkspaceID == workspaceID && p.DeletedAt == nil {
			if status != "" && p.Status != status {
				continue
			}
			result = append(result, *p)
		}
	}
	return result, nil
}

func (m *MemoryStore) UpdatePlan(_ context.Context, plan *MembershipPlan) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.plans[plan.PlanID]
	if !ok || existing.WorkspaceID != plan.WorkspaceID || existing.DeletedAt != nil {
		return ErrPlanNotFound
	}
	plan.UpdatedAt = time.Now().UTC()
	m.plans[plan.PlanID] = plan
	return nil
}

func (m *MemoryStore) DeletePlan(_ context.Context, workspaceID, planID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.plans[planID]
	if !ok || existing.WorkspaceID != workspaceID || existing.DeletedAt != nil {
		return ErrPlanNotFound
	}
	now := time.Now().UTC()
	existing.DeletedAt = &now
	return nil
}

// ----------------------------------------------------------------------------
// Membership Subscriptions Implementation
// ----------------------------------------------------------------------------

func (m *MemoryStore) CreateSubscription(_ context.Context, sub *MembershipSubscription) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if sub.MembershipID == "" {
		sub.MembershipID = newUUID()
	}
	if sub.CreatedAt.IsZero() {
		sub.CreatedAt = time.Now().UTC()
	}
	sub.UpdatedAt = sub.CreatedAt

	m.subscriptions[sub.MembershipID] = sub
	if sub.ProviderSubscriptionID != "" {
		m.subByProvider[sub.WorkspaceID+":"+sub.ProviderSubscriptionID] = sub.MembershipID
	}
	// Increment subscriber count on plan
	if p, ok := m.plans[sub.PlanID]; ok {
		p.SubscriberCount++
	}
	return nil
}

func (m *MemoryStore) GetSubscription(_ context.Context, workspaceID, subID string) (*MembershipSubscription, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	s, ok := m.subscriptions[subID]
	if !ok || s.WorkspaceID != workspaceID {
		return nil, ErrSubscriptionNotFound
	}
	return s, nil
}

func (m *MemoryStore) GetSubscriptionByProviderID(_ context.Context, workspaceID, providerSubID string) (*MembershipSubscription, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	id, ok := m.subByProvider[workspaceID+":"+providerSubID]
	if !ok {
		return nil, ErrSubscriptionNotFound
	}
	s, ok2 := m.subscriptions[id]
	if !ok2 {
		return nil, ErrSubscriptionNotFound
	}
	return s, nil
}

func (m *MemoryStore) ListSubscriptionsByCustomer(_ context.Context, workspaceID, customerEntityID string) ([]MembershipSubscription, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []MembershipSubscription
	for _, s := range m.subscriptions {
		if s.WorkspaceID == workspaceID && s.CustomerEntityID == customerEntityID {
			result = append(result, *s)
		}
	}
	return result, nil
}

func (m *MemoryStore) UpdateSubscription(_ context.Context, sub *MembershipSubscription) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.subscriptions[sub.MembershipID]
	if !ok || existing.WorkspaceID != sub.WorkspaceID {
		return ErrSubscriptionNotFound
	}
	sub.UpdatedAt = time.Now().UTC()
	m.subscriptions[sub.MembershipID] = sub
	return nil
}

// ----------------------------------------------------------------------------
// Bundles Implementation
// ----------------------------------------------------------------------------

func (m *MemoryStore) CreateBundle(_ context.Context, bundle *Bundle) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if bundle.BundleID == "" {
		bundle.BundleID = newUUID()
	}
	if bundle.CreatedAt.IsZero() {
		bundle.CreatedAt = time.Now().UTC()
	}
	m.bundles[bundle.BundleID] = bundle
	return nil
}

func (m *MemoryStore) GetBundle(_ context.Context, workspaceID, bundleID string) (*Bundle, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	b, ok := m.bundles[bundleID]
	if !ok || b.WorkspaceID != workspaceID {
		return nil, ErrBundleNotFound
	}
	// Enrich component availability
	bundleCopy := *b
	bundleCopy.Items = make([]BundleItem, len(b.Items))
	isAvailable := true
	var unavailableReason string

	for i, item := range b.Items {
		stockKey := workspaceID + ":" + item.ProductID
		currentStock := m.productStock[stockKey]
		itemCopy := item
		itemCopy.AvailableStock = currentStock
		bundleCopy.Items[i] = itemCopy

		if currentStock < item.Quantity {
			isAvailable = false
			if unavailableReason == "" {
				title := item.ProductTitle
				if title == "" {
					title = fmt.Sprintf("Product %s", item.ProductID)
				}
				unavailableReason = fmt.Sprintf("Temporarily unavailable — %s out of stock", title)
			}
		}
	}
	bundleCopy.IsAvailable = isAvailable
	bundleCopy.UnavailableReason = unavailableReason
	return &bundleCopy, nil
}

func (m *MemoryStore) ListBundles(_ context.Context, workspaceID string) ([]Bundle, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []Bundle
	for _, b := range m.bundles {
		if b.WorkspaceID == workspaceID {
			bundleCopy := *b
			isAvailable := true
			var unavailableReason string
			bundleCopy.Items = make([]BundleItem, len(b.Items))
			for i, item := range b.Items {
				stockKey := workspaceID + ":" + item.ProductID
				currentStock := m.productStock[stockKey]
				itemCopy := item
				itemCopy.AvailableStock = currentStock
				bundleCopy.Items[i] = itemCopy
				if currentStock < item.Quantity {
					isAvailable = false
					if unavailableReason == "" {
						title := item.ProductTitle
						if title == "" {
							title = fmt.Sprintf("Product %s", item.ProductID)
						}
						unavailableReason = fmt.Sprintf("Temporarily unavailable — %s out of stock", title)
					}
				}
			}
			bundleCopy.IsAvailable = isAvailable
			bundleCopy.UnavailableReason = unavailableReason
			result = append(result, bundleCopy)
		}
	}
	return result, nil
}

func (m *MemoryStore) UpdateBundle(_ context.Context, bundle *Bundle) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, ok := m.bundles[bundle.BundleID]
	if !ok || existing.WorkspaceID != bundle.WorkspaceID {
		return ErrBundleNotFound
	}
	m.bundles[bundle.BundleID] = bundle
	return nil
}

// ----------------------------------------------------------------------------
// Component Stock Tracking & Atomic Reservation (Acceptance Target 1)
// ----------------------------------------------------------------------------

func (m *MemoryStore) GetProductStock(_ context.Context, workspaceID, productID string) (int32, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	return m.productStock[workspaceID+":"+productID], nil
}

func (m *MemoryStore) SetProductStock(_ context.Context, workspaceID, productID string, stock int32) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.productStock[workspaceID+":"+productID] = stock
	return nil
}

// AtomicallyReserveBundleStock verifies all components have sufficient stock and decrements
// each component atomically. If ANY component is insufficient, all are left untouched and
// ErrBundleComponentOutOfStock is returned with no partial deductions or leaks.
func (m *MemoryStore) AtomicallyReserveBundleStock(_ context.Context, workspaceID, bundleID string, quantity int32) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	bundle, ok := m.bundles[bundleID]
	if !ok || bundle.WorkspaceID != workspaceID {
		return ErrBundleNotFound
	}

	// 1. Verify ALL components have sufficient stock
	for _, item := range bundle.Items {
		required := item.Quantity * quantity
		stockKey := workspaceID + ":" + item.ProductID
		currentStock := m.productStock[stockKey]
		if currentStock < required {
			title := item.ProductTitle
			if title == "" {
				title = fmt.Sprintf("Product %s", item.ProductID)
			}
			return fmt.Errorf("%w: %s (stock=%d, required=%d)", ErrBundleComponentOutOfStock, title, currentStock, required)
		}
	}

	// 2. All components confirmed sufficient: atomically decrement each component
	for _, item := range bundle.Items {
		required := item.Quantity * quantity
		stockKey := workspaceID + ":" + item.ProductID
		m.productStock[stockKey] -= required
	}

	return nil
}

// ----------------------------------------------------------------------------
// Payment Replay & Digital Delivery Tracking (Acceptance Target 2)
// ----------------------------------------------------------------------------

func (m *MemoryStore) GetCheckoutResultByIdempotency(_ context.Context, workspaceID, idempotencyKey string) (*CheckoutResult, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	if res, ok := m.checkouts[workspaceID+":"+idempotencyKey]; ok {
		// Return copy with IsReplayed flag set to true
		cp := *res
		cp.IsReplayed = true
		return &cp, nil
	}
	return nil, nil
}

func (m *MemoryStore) SaveCheckoutResult(_ context.Context, workspaceID, idempotencyKey string, res *CheckoutResult) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.checkouts[workspaceID+":"+idempotencyKey] = res
	return nil
}

func (m *MemoryStore) CreateDigitalDelivery(_ context.Context, delivery *DigitalDelivery) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if delivery.DeliveryID == "" {
		delivery.DeliveryID = newUUID()
	}
	if delivery.CreatedAt.IsZero() {
		delivery.CreatedAt = time.Now().UTC()
	}
	m.deliveries[delivery.DeliveryID] = delivery
	return nil
}

func (m *MemoryStore) ListDeliveriesByCustomer(_ context.Context, workspaceID, customerEntityID string) ([]DigitalDelivery, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []DigitalDelivery
	for _, d := range m.deliveries {
		if d.WorkspaceID == workspaceID && d.CustomerEntityID == customerEntityID {
			result = append(result, *d)
		}
	}
	return result, nil
}

func (m *MemoryStore) RecordFinancialPosting(_ context.Context, posting *FinancialPosting) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if posting.PostingID == "" {
		posting.PostingID = newUUID()
	}
	if posting.CreatedAt.IsZero() {
		posting.CreatedAt = time.Now().UTC()
	}
	m.postings = append(m.postings, *posting)
	return nil
}

func (m *MemoryStore) ListFinancialPostings(_ context.Context, workspaceID string) ([]FinancialPosting, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []FinancialPosting
	for _, p := range m.postings {
		if p.WorkspaceID == workspaceID {
			result = append(result, p)
		}
	}
	return result, nil
}
