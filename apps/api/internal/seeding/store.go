package seeding

import (
	"context"
	"sort"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type Store interface {
	CreateRequest(ctx context.Context, req *SampleRequest) error
	GetRequest(ctx context.Context, workspaceID, requestID string) (*SampleRequest, error)
	ListRequests(ctx context.Context, workspaceID string, campaignID, productID, creatorID *string, status *SampleRequestStatus, outcomeStatus *SampleOutcomeStatus, followUpStatus *FollowUpStatus, limit, offset int) ([]*SampleRequest, int, error)
	UpdateRequest(ctx context.Context, req *SampleRequest) error
	DeleteRequest(ctx context.Context, workspaceID, requestID string) error

	CreateShipment(ctx context.Context, shipment *SampleShipment) error
	GetShipment(ctx context.Context, workspaceID, shipmentID string) (*SampleShipment, error)
	GetShipmentByRequest(ctx context.Context, workspaceID, requestID string) (*SampleShipment, error)
	UpdateShipment(ctx context.Context, shipment *SampleShipment) error
	ListShipments(ctx context.Context, workspaceID string, status *SampleShipmentStatus, limit, offset int) ([]*SampleShipment, int, error)

	GetProduct(ctx context.Context, workspaceID, productID string) (*ProductSummary, error)
	SetProduct(ctx context.Context, workspaceID string, prod *ProductSummary) error
	GetCreatorEntity(ctx context.Context, workspaceID, entityID string) (*CreatorSummary, error)
	SetCreatorEntity(ctx context.Context, workspaceID string, creator *CreatorSummary) error

	GetCostItemForRequest(ctx context.Context, workspaceID, requestID string) (*CostItemSummary, error)
	UpsertCostItemForRequest(ctx context.Context, cost *CostItemSummary) error

	CreateCampaign(ctx context.Context, camp *SeedingCampaign) error
	GetCampaign(ctx context.Context, workspaceID, campaignID string) (*SeedingCampaign, error)
	ListCampaigns(ctx context.Context, workspaceID, status string, limit, offset int) ([]*SeedingCampaign, int, error)
	UpdateCampaign(ctx context.Context, camp *SeedingCampaign) error

	CreateAssignment(ctx context.Context, workspaceID, campaignID, creatorID, productID, notes string) (string, error)
	RemoveAssignment(ctx context.Context, workspaceID, assignmentID string) error
	ListAssignments(ctx context.Context, workspaceID, campaignID string, limit, offset int) ([]*SampleRequest, int, error)

	CheckDuplicateRequest(ctx context.Context, workspaceID, creatorID, productID string) (bool, error)
}

type MemoryStore struct {
	mu          sync.RWMutex
	requests    map[string]*SampleRequest
	shipments   map[string]*SampleShipment
	products    map[string]*ProductSummary
	creators    map[string]*CreatorSummary
	costItems   map[string]*CostItemSummary // key: workspaceID + ":" + requestID
	campaigns   map[string]*SeedingCampaign
	assignments map[string]string // assignmentID -> requestID
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		requests:    make(map[string]*SampleRequest),
		shipments:   make(map[string]*SampleShipment),
		products:    make(map[string]*ProductSummary),
		creators:    make(map[string]*CreatorSummary),
		costItems:   make(map[string]*CostItemSummary),
		campaigns:   make(map[string]*SeedingCampaign),
		assignments: make(map[string]string),
	}
}

func (m *MemoryStore) CreateRequest(ctx context.Context, req *SampleRequest) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	if req.RequestID == "" {
		req.RequestID = newUUID()
	}
	now := time.Now().UTC()
	if req.CreatedAt.IsZero() {
		req.CreatedAt = now
	}
	req.UpdatedAt = now

	// Deep copy
	cp := *req
	m.requests[req.RequestID] = &cp
	return nil
}

func (m *MemoryStore) GetRequest(ctx context.Context, workspaceID, requestID string) (*SampleRequest, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	r, ok := m.requests[requestID]
	if !ok || r.WorkspaceID != workspaceID || r.DeletedAt != nil {
		return nil, ErrSampleRequestNotFound
	}
	cp := *r
	if ship, exists := m.findShipmentByRequestLocked(workspaceID, requestID); exists {
		shipCp := *ship
		cp.Shipment = &shipCp
	}
	if p, ok := m.products[cp.ProductID]; ok {
		cp.ProductTitle = p.Title
		cp.ProductCOGS = p.COGS
	}
	if c, ok := m.creators[cp.CreatorEntityID]; ok {
		cp.CreatorName = c.DisplayName
		cp.CreatorHandle = c.Handle
		cp.CreatorAvatarURL = c.AvatarURL
		cp.CreatorFollowers = c.Followers
		cp.CreatorPlatform = c.Platform
	}
	return &cp, nil
}

func (m *MemoryStore) findShipmentByRequestLocked(workspaceID, requestID string) (*SampleShipment, bool) {
	for _, s := range m.shipments {
		if s.WorkspaceID == workspaceID && s.RequestID == requestID {
			return s, true
		}
	}
	return nil, false
}

func (m *MemoryStore) ListRequests(ctx context.Context, workspaceID string, campaignID, productID, creatorID *string, status *SampleRequestStatus, outcomeStatus *SampleOutcomeStatus, followUpStatus *FollowUpStatus, limit, offset int) ([]*SampleRequest, int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []*SampleRequest
	for _, r := range m.requests {
		if r.WorkspaceID != workspaceID || r.DeletedAt != nil {
			continue
		}
		if campaignID != nil && *campaignID != "" {
			if r.CampaignID == nil || *r.CampaignID != *campaignID {
				continue
			}
		}
		if productID != nil && *productID != "" && r.ProductID != *productID {
			continue
		}
		if creatorID != nil && *creatorID != "" && r.CreatorEntityID != *creatorID {
			continue
		}
		if status != nil && r.Status != *status {
			continue
		}
		if outcomeStatus != nil && r.OutcomeStatus != *outcomeStatus {
			continue
		}
		if followUpStatus != nil && r.FollowUpStatus != *followUpStatus {
			continue
		}

		cp := *r
		if ship, exists := m.findShipmentByRequestLocked(workspaceID, r.RequestID); exists {
			shipCp := *ship
			cp.Shipment = &shipCp
		}
		if p, ok := m.products[cp.ProductID]; ok {
			cp.ProductTitle = p.Title
			cp.ProductCOGS = p.COGS
		}
		if c, ok := m.creators[cp.CreatorEntityID]; ok {
			cp.CreatorName = c.DisplayName
			cp.CreatorHandle = c.Handle
			cp.CreatorAvatarURL = c.AvatarURL
			cp.CreatorFollowers = c.Followers
			cp.CreatorPlatform = c.Platform
		}
		result = append(result, &cp)
	}

	sort.Slice(result, func(i, j int) bool {
		return result[i].CreatedAt.After(result[j].CreatedAt)
	})

	total := len(result)
	if offset > total {
		return []*SampleRequest{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > total {
		end = total
	}
	return result[offset:end], total, nil
}

func (m *MemoryStore) UpdateRequest(ctx context.Context, req *SampleRequest) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	r, ok := m.requests[req.RequestID]
	if !ok || r.WorkspaceID != req.WorkspaceID || r.DeletedAt != nil {
		return ErrSampleRequestNotFound
	}
	req.UpdatedAt = time.Now().UTC()
	cp := *req
	m.requests[req.RequestID] = &cp
	return nil
}

func (m *MemoryStore) DeleteRequest(ctx context.Context, workspaceID, requestID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	r, ok := m.requests[requestID]
	if !ok || r.WorkspaceID != workspaceID || r.DeletedAt != nil {
		return ErrSampleRequestNotFound
	}
	now := time.Now().UTC()
	r.DeletedAt = &now
	r.UpdatedAt = now
	return nil
}

func (m *MemoryStore) CreateShipment(ctx context.Context, shipment *SampleShipment) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	if shipment.ShipmentID == "" {
		shipment.ShipmentID = newUUID()
	}
	now := time.Now().UTC()
	if shipment.CreatedAt.IsZero() {
		shipment.CreatedAt = now
	}
	shipment.UpdatedAt = now

	cp := *shipment
	m.shipments[shipment.ShipmentID] = &cp
	return nil
}

func (m *MemoryStore) GetShipment(ctx context.Context, workspaceID, shipmentID string) (*SampleShipment, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	s, ok := m.shipments[shipmentID]
	if !ok || s.WorkspaceID != workspaceID {
		return nil, ErrSampleShipmentNotFound
	}
	cp := *s
	return &cp, nil
}

func (m *MemoryStore) GetShipmentByRequest(ctx context.Context, workspaceID, requestID string) (*SampleShipment, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	s, ok := m.findShipmentByRequestLocked(workspaceID, requestID)
	if !ok {
		return nil, ErrSampleShipmentNotFound
	}
	cp := *s
	return &cp, nil
}

func (m *MemoryStore) UpdateShipment(ctx context.Context, shipment *SampleShipment) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	s, ok := m.shipments[shipment.ShipmentID]
	if !ok || s.WorkspaceID != shipment.WorkspaceID {
		return ErrSampleShipmentNotFound
	}
	shipment.UpdatedAt = time.Now().UTC()
	cp := *shipment
	m.shipments[shipment.ShipmentID] = &cp
	return nil
}

func (m *MemoryStore) ListShipments(ctx context.Context, workspaceID string, status *SampleShipmentStatus, limit, offset int) ([]*SampleShipment, int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []*SampleShipment
	for _, s := range m.shipments {
		if s.WorkspaceID != workspaceID {
			continue
		}
		if status != nil && s.Status != *status {
			continue
		}
		cp := *s
		result = append(result, &cp)
	}

	sort.Slice(result, func(i, j int) bool {
		return result[i].CreatedAt.After(result[j].CreatedAt)
	})

	total := len(result)
	if offset > total {
		return []*SampleShipment{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > total {
		end = total
	}
	return result[offset:end], total, nil
}

func (m *MemoryStore) GetProduct(ctx context.Context, workspaceID, productID string) (*ProductSummary, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	p, ok := m.products[productID]
	if !ok {
		// Provide default summary if not explicitly mocked
		return &ProductSummary{
			ProductID: productID,
			Title:     "Sample Product",
			COGS:      tenantdb.ZeroDecimal(),
			Currency:  "VND",
		}, nil
	}
	cp := *p
	return &cp, nil
}

func (m *MemoryStore) SetProduct(ctx context.Context, workspaceID string, prod *ProductSummary) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	cp := *prod
	m.products[prod.ProductID] = &cp
	return nil
}

func (m *MemoryStore) GetCreatorEntity(ctx context.Context, workspaceID, entityID string) (*CreatorSummary, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	c, ok := m.creators[entityID]
	if !ok {
		return &CreatorSummary{
			EntityID:    entityID,
			DisplayName: "Creator " + entityID[:8],
			Handle:      "creator_" + entityID[:6],
			Platform:    "tiktok",
			Followers:   10000,
		}, nil
	}
	cp := *c
	return &cp, nil
}

func (m *MemoryStore) SetCreatorEntity(ctx context.Context, workspaceID string, creator *CreatorSummary) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	cp := *creator
	m.creators[creator.EntityID] = &cp
	return nil
}

func (m *MemoryStore) GetCostItemForRequest(ctx context.Context, workspaceID, requestID string) (*CostItemSummary, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	k := workspaceID + ":" + requestID
	c, ok := m.costItems[k]
	if !ok {
		return nil, nil
	}
	cp := *c
	return &cp, nil
}

func (m *MemoryStore) UpsertCostItemForRequest(ctx context.Context, cost *CostItemSummary) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	k := cost.WorkspaceID + ":" + cost.RelatedScopeID
	if cost.CostItemID == "" {
		cost.CostItemID = newUUID()
	}
	cp := *cost
	m.costItems[k] = &cp
	return nil
}

func (m *MemoryStore) CreateCampaign(ctx context.Context, camp *SeedingCampaign) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	if camp.CampaignID == "" {
		camp.CampaignID = newUUID()
	}
	now := time.Now().UTC()
	camp.CreatedAt = now
	camp.UpdatedAt = now
	cp := *camp
	m.campaigns[camp.CampaignID] = &cp
	return nil
}

func (m *MemoryStore) GetCampaign(ctx context.Context, workspaceID, campaignID string) (*SeedingCampaign, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	c, ok := m.campaigns[campaignID]
	if !ok || c.WorkspaceID != workspaceID {
		return nil, ErrCampaignNotFound
	}
	cp := *c
	return &cp, nil
}

func (m *MemoryStore) ListCampaigns(ctx context.Context, workspaceID, status string, limit, offset int) ([]*SeedingCampaign, int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	var result []*SeedingCampaign
	for _, c := range m.campaigns {
		if c.WorkspaceID != workspaceID {
			continue
		}
		if status != "" && c.Status != status {
			continue
		}
		cp := *c
		result = append(result, &cp)
	}
	sort.Slice(result, func(i, j int) bool {
		return result[i].CreatedAt.After(result[j].CreatedAt)
	})
	total := len(result)
	if offset > total {
		return []*SeedingCampaign{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > total {
		end = total
	}
	return result[offset:end], total, nil
}

func (m *MemoryStore) UpdateCampaign(ctx context.Context, camp *SeedingCampaign) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	c, ok := m.campaigns[camp.CampaignID]
	if !ok || c.WorkspaceID != camp.WorkspaceID {
		return ErrCampaignNotFound
	}
	camp.UpdatedAt = time.Now().UTC()
	cp := *camp
	m.campaigns[camp.CampaignID] = &cp
	return nil
}

func (m *MemoryStore) CreateAssignment(ctx context.Context, workspaceID, campaignID, creatorID, productID, notes string) (string, error) {
	m.mu.Lock()
	defer m.mu.Unlock()
	assignmentID := newUUID()
	reqID := newUUID()
	now := time.Now().UTC()

	var campIDPtr *string
	if campaignID != "" {
		campIDPtr = &campaignID
	}

	req := &SampleRequest{
		RequestID:       reqID,
		WorkspaceID:     workspaceID,
		CampaignID:      campIDPtr,
		ProductID:       productID,
		CreatorEntityID: creatorID,
		Status:          RequestStatusRequested,
		Quantity:        1,
		OutcomeStatus:   OutcomeStatusPending,
		FollowUpStatus:  FollowUpPending,
		Notes:           notes,
		CreatedAt:       now,
		UpdatedAt:       now,
	}
	m.requests[reqID] = req
	m.assignments[assignmentID] = reqID
	return assignmentID, nil
}

func (m *MemoryStore) RemoveAssignment(ctx context.Context, workspaceID, assignmentID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()
	reqID, ok := m.assignments[assignmentID]
	if !ok {
		return ErrAssignmentNotFound
	}
	if req, ok := m.requests[reqID]; ok && req.WorkspaceID == workspaceID {
		now := time.Now().UTC()
		req.DeletedAt = &now
		req.UpdatedAt = now
	}
	delete(m.assignments, assignmentID)
	return nil
}

func (m *MemoryStore) ListAssignments(ctx context.Context, workspaceID, campaignID string, limit, offset int) ([]*SampleRequest, int, error) {
	var campIDPtr *string
	if campaignID != "" {
		campIDPtr = &campaignID
	}
	return m.ListRequests(ctx, workspaceID, campIDPtr, nil, nil, nil, nil, nil, limit, offset)
}

func (m *MemoryStore) CheckDuplicateRequest(ctx context.Context, workspaceID, creatorID, productID string) (bool, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()
	for _, r := range m.requests {
		if r.WorkspaceID == workspaceID && r.CreatorEntityID == creatorID && r.ProductID == productID && r.DeletedAt == nil {
			if r.Status == RequestStatusRequested || r.Status == RequestStatusApproved {
				return true, nil
			}
		}
	}
	return false, nil
}
