package conversion

import (
	"context"
	"errors"
	"fmt"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/creatorpro"
	"github.com/quantm-zeus/creativanta/apps/api/internal/livecommerce"
	"github.com/quantm-zeus/creativanta/apps/api/internal/monetization"
	"github.com/quantm-zeus/creativanta/apps/api/internal/seeding"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// ============================================================================
// In-Memory Generic Source Store Adapter
// ============================================================================

// MemorySourceProvider is an in-memory SourceProvider for tests and isolated execution.
type MemorySourceProvider struct {
	mu      sync.RWMutex
	sources map[string]*SourceSnapshot // key: workspaceID + ":" + sourceID
}

func NewMemorySourceProvider() *MemorySourceProvider {
	return &MemorySourceProvider{
		sources: make(map[string]*SourceSnapshot),
	}
}

func (m *MemorySourceProvider) key(wsID, srcID string) string {
	return wsID + ":" + srcID
}

func (m *MemorySourceProvider) AddSource(snapshot SourceSnapshot) {
	m.mu.Lock()
	defer m.mu.Unlock()
	if snapshot.UpdatedAt.IsZero() {
		snapshot.UpdatedAt = time.Now().UTC()
	}
	cpy := snapshot
	m.sources[m.key(snapshot.WorkspaceID, snapshot.ID)] = &cpy
}

func (m *MemorySourceProvider) GetSnapshot(ctx context.Context, workspaceID, sourceID string) (*SourceSnapshot, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	s, ok := m.sources[m.key(workspaceID, sourceID)]
	if !ok {
		return nil, ErrSourceNotFound
	}
	cpy := *s
	return &cpy, nil
}

func (m *MemorySourceProvider) MarkConverted(ctx context.Context, workspaceID, sourceID string, targetType TargetType, targetID string, expectedUpdatedAt *time.Time) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	s, ok := m.sources[m.key(workspaceID, sourceID)]
	if !ok {
		return ErrSourceNotFound
	}

	if expectedUpdatedAt != nil {
		if !s.UpdatedAt.Truncate(time.Microsecond).Equal(expectedUpdatedAt.Truncate(time.Microsecond)) {
			return ErrConcurrentConflict
		}
	}

	s.ConvertedToType = string(targetType)
	s.ConvertedToID = targetID
	if s.Type == SourceTypeThread {
		s.Status = "converted_to_task"
	} else {
		s.Status = "converted"
	}
	s.UpdatedAt = time.Now().UTC()
	return nil
}

func (m *MemorySourceProvider) RollbackConversion(ctx context.Context, workspaceID, sourceID string, snapshot *SourceSnapshot) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if snapshot == nil {
		return errors.New("cannot rollback to nil snapshot")
	}
	cpy := *snapshot
	m.sources[m.key(workspaceID, sourceID)] = &cpy
	return nil
}

// ============================================================================
// In-Memory Generic Target Creator Adapter
// ============================================================================

// StoredTargetObject represents an object created in downstream commerce domain.
type StoredTargetObject struct {
	ID          string
	WorkspaceID string
	Type        TargetType
	Title       string
	Route       string
	Details     map[string]any
	SourceRef   map[string]any
	CreatedAt   time.Time
}

// MemoryTargetCreator provides in-memory creation and compensation for downstream commerce objects.
type MemoryTargetCreator struct {
	mu           sync.RWMutex
	targets      map[string]StoredTargetObject // key: workspaceID + ":" + targetType + ":" + targetID
	failOnCreate bool
	failErr      error
}

func NewMemoryTargetCreator() *MemoryTargetCreator {
	return &MemoryTargetCreator{
		targets: make(map[string]StoredTargetObject),
	}
}

func (m *MemoryTargetCreator) key(wsID string, tgtType TargetType, tgtID string) string {
	return wsID + ":" + string(tgtType) + ":" + tgtID
}

func (m *MemoryTargetCreator) SetFailOnCreate(fail bool, err error) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.failOnCreate = fail
	m.failErr = err
}

func (m *MemoryTargetCreator) CreateTarget(ctx context.Context, workspaceID string, caller CallerContext, targetType TargetType, targetID, title string, details map[string]any, sourceRef map[string]any) (string, any, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	if m.failOnCreate {
		err := m.failErr
		if err == nil {
			err = errors.New("simulated target creation failure")
		}
		return "", nil, err
	}

	var route string
	switch targetType {
	case TargetTypeCampaign:
		route = fmt.Sprintf("/campaigns/%s", targetID)
	case TargetTypeLive:
		route = fmt.Sprintf("/live/sessions/%s", targetID)
	case TargetTypeOffer:
		route = fmt.Sprintf("/offers/%s", targetID)
	case TargetTypeSeeding:
		route = fmt.Sprintf("/seeding/samples/%s", targetID)
	case TargetTypeDeal:
		route = fmt.Sprintf("/brand-deals/%s", targetID)
	case TargetTypeScript:
		route = fmt.Sprintf("/scripts/%s", targetID)
	default:
		route = fmt.Sprintf("/%ss/%s", targetType, targetID)
	}

	obj := StoredTargetObject{
		ID:          targetID,
		WorkspaceID: workspaceID,
		Type:        targetType,
		Title:       title,
		Route:       route,
		Details:     details,
		SourceRef:   sourceRef,
		CreatedAt:   time.Now().UTC(),
	}

	m.targets[m.key(workspaceID, targetType, targetID)] = obj
	return route, obj, nil
}

func (m *MemoryTargetCreator) DeleteTarget(ctx context.Context, workspaceID string, targetType TargetType, targetID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	delete(m.targets, m.key(workspaceID, targetType, targetID))
	return nil
}

func (m *MemoryTargetCreator) GetTarget(workspaceID string, targetType TargetType, targetID string) (*StoredTargetObject, bool) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	obj, ok := m.targets[m.key(workspaceID, targetType, targetID)]
	if !ok {
		return nil, false
	}
	return &obj, true
}

// ============================================================================
// Concrete Commerce Domain Adapters
// ============================================================================

// MonetizationCampaignAdapter creates canonical campaigns in monetization.Store.
type MonetizationCampaignAdapter struct {
	store monetization.Store
}

func NewMonetizationCampaignAdapter(store monetization.Store) *MonetizationCampaignAdapter {
	return &MonetizationCampaignAdapter{store: store}
}

func (a *MonetizationCampaignAdapter) CreateTarget(ctx context.Context, workspaceID string, caller CallerContext, targetType TargetType, targetID, title string, details map[string]any, sourceRef map[string]any) (string, any, error) {
	if a.store == nil {
		return "", nil, errors.New("monetization store not provided")
	}

	campType := monetization.CampaignTypeContent
	if t, ok := details["campaign_type"].(string); ok && t != "" {
		campType = monetization.CampaignType(t)
	}

	now := time.Now().UTC()
	campaign := &monetization.Campaign{
		CampaignID:   targetID,
		WorkspaceID:  workspaceID,
		CampaignType: campType,
		Title:        title,
		Status:       monetization.CampaignStatusPlanned,
		Metadata: map[string]any{
			"source_ref": sourceRef,
		},
		CreatedAt: now,
		UpdatedAt: now,
	}

	if budgetStr, ok := details["budget"].(string); ok && budgetStr != "" {
		if dec, err := tenantdb.ParseExactDecimal(budgetStr); err == nil {
			campaign.Budget = &dec
		}
	}

	if err := a.store.CreateCampaign(ctx, campaign); err != nil {
		return "", nil, err
	}

	route := fmt.Sprintf("/campaigns/%s", targetID)
	return route, campaign, nil
}

func (a *MonetizationCampaignAdapter) DeleteTarget(ctx context.Context, workspaceID string, targetType TargetType, targetID string) error {
	if a.store == nil {
		return nil
	}
	return a.store.DeleteCampaign(ctx, workspaceID, targetID)
}

// LiveCommerceAdapter creates live sessions in livecommerce.Store.
type LiveCommerceAdapter struct {
	store livecommerce.Store
}

func NewLiveCommerceAdapter(store livecommerce.Store) *LiveCommerceAdapter {
	return &LiveCommerceAdapter{store: store}
}

func (a *LiveCommerceAdapter) CreateTarget(ctx context.Context, workspaceID string, caller CallerContext, targetType TargetType, targetID, title string, details map[string]any, sourceRef map[string]any) (string, any, error) {
	if a.store == nil {
		return "", nil, errors.New("livecommerce store not provided")
	}

	platform := "tiktok_live"
	if p, ok := details["platform"].(string); ok && p != "" {
		platform = p
	}

	now := time.Now().UTC()
	session := &livecommerce.LiveSession{
		SessionID:   targetID,
		WorkspaceID: workspaceID,
		Title:       title,
		Platform:    platform,
		Status:      livecommerce.SessionStatusPlanned,
		Metadata: map[string]any{
			"source_ref": sourceRef,
		},
		CreatedAt: now,
		UpdatedAt: now,
	}

	if err := a.store.CreateSession(ctx, session); err != nil {
		return "", nil, err
	}

	route := fmt.Sprintf("/live/sessions/%s", targetID)
	return route, session, nil
}

func (a *LiveCommerceAdapter) DeleteTarget(ctx context.Context, workspaceID string, targetType TargetType, targetID string) error {
	if a.store == nil {
		return nil
	}
	session, err := a.store.GetSession(ctx, workspaceID, targetID)
	if err != nil {
		return nil
	}
	session.Status = livecommerce.SessionStatusClosed
	return a.store.UpdateSession(ctx, session)
}

// SeedingAdapter creates sample requests in seeding.Store.
type SeedingAdapter struct {
	store seeding.Store
}

func NewSeedingAdapter(store seeding.Store) *SeedingAdapter {
	return &SeedingAdapter{store: store}
}

func (a *SeedingAdapter) CreateTarget(ctx context.Context, workspaceID string, caller CallerContext, targetType TargetType, targetID, title string, details map[string]any, sourceRef map[string]any) (string, any, error) {
	if a.store == nil {
		return "", nil, errors.New("seeding store not provided")
	}

	var productID, creatorEntityID string
	if pid, ok := details["product_id"].(string); ok {
		productID = pid
	}
	if cid, ok := details["creator_entity_id"].(string); ok {
		creatorEntityID = cid
	}

	now := time.Now().UTC()
	req := &seeding.SampleRequest{
		RequestID:       targetID,
		WorkspaceID:     workspaceID,
		ProductID:       productID,
		CreatorEntityID: creatorEntityID,
		Status:          seeding.RequestStatusRequested,
		Quantity:        1,
		OutcomeStatus:   seeding.OutcomeStatusPending,
		FollowUpStatus:  seeding.FollowUpPending,
		Notes:           fmt.Sprintf("Converted from %s: %s", sourceRef["source_type"], title),
		CreatedAt:       now,
		UpdatedAt:       now,
	}

	if err := a.store.CreateRequest(ctx, req); err != nil {
		return "", nil, err
	}

	route := fmt.Sprintf("/seeding/samples/%s", targetID)
	return route, req, nil
}

func (a *SeedingAdapter) DeleteTarget(ctx context.Context, workspaceID string, targetType TargetType, targetID string) error {
	if a.store == nil {
		return nil
	}
	return a.store.DeleteRequest(ctx, workspaceID, targetID)
}

// BrandDealAdapter creates brand deals in creatorpro.Store.
type BrandDealAdapter struct {
	store creatorpro.Store
}

func NewBrandDealAdapter(store creatorpro.Store) *BrandDealAdapter {
	return &BrandDealAdapter{store: store}
}

func (a *BrandDealAdapter) CreateTarget(ctx context.Context, workspaceID string, caller CallerContext, targetType TargetType, targetID, title string, details map[string]any, sourceRef map[string]any) (string, any, error) {
	if a.store == nil {
		return "", nil, errors.New("creatorpro store not provided")
	}

	brandName := title
	if b, ok := details["brand_name"].(string); ok && b != "" {
		brandName = b
	}

	now := time.Now().UTC()
	deal := &creatorpro.BrandDeal{
		DealID:      targetID,
		WorkspaceID: workspaceID,
		BrandName:   brandName,
		Status:      creatorpro.BrandDealStatusNegotiating,
		DealType:    creatorpro.BrandDealTypeSponsoredPost,
		Notes:       fmt.Sprintf("Converted from %s: %s", sourceRef["source_type"], title),
		CreatedAt:   now,
		UpdatedAt:   now,
	}

	if err := a.store.CreateBrandDeal(ctx, deal); err != nil {
		return "", nil, err
	}

	route := fmt.Sprintf("/brand-deals/%s", targetID)
	return route, deal, nil
}

func (a *BrandDealAdapter) DeleteTarget(ctx context.Context, workspaceID string, targetType TargetType, targetID string) error {
	if a.store == nil {
		return nil
	}
	deal, err := a.store.GetBrandDeal(ctx, workspaceID, targetID)
	if err != nil {
		return nil
	}
	deal.Status = creatorpro.BrandDealStatusCancelled
	return a.store.UpdateBrandDeal(ctx, deal)
}
