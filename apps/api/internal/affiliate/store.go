package affiliate

import (
	"context"
	"sort"
	"strings"
	"sync"
	"time"
)

type Store interface {
	// Link operations
	CreateLink(ctx context.Context, link *AffiliateLink) error
	GetLink(ctx context.Context, workspaceID, linkID string) (*AffiliateLink, error)
	ListLinks(ctx context.Context, workspaceID string, campaignID, platform *string, state *LinkLifecycleState, limit, offset int) ([]*AffiliateLink, int, error)
	UpdateLink(ctx context.Context, link *AffiliateLink) error
	DeleteLink(ctx context.Context, workspaceID, linkID string) error

	// Assignment operations
	CreateAssignment(ctx context.Context, assignment *CreatorAssignment) error
	GetAssignment(ctx context.Context, workspaceID, assignmentID string) (*CreatorAssignment, error)
	ListAssignments(ctx context.Context, workspaceID string, campaignID, creatorID *string, limit, offset int) ([]*CreatorAssignment, error)
	UpdateAssignment(ctx context.Context, assignment *CreatorAssignment) error

	// Attribution operations
	CreateAttribution(ctx context.Context, attr *AttributionRecord) error
	ListAttributions(ctx context.Context, workspaceID string, linkID *string) ([]*AttributionRecord, error)

	// Commission operations
	CreateCommission(ctx context.Context, comm *AffiliateCommission) error
	GetCommission(ctx context.Context, workspaceID, commissionID string) (*AffiliateCommission, error)
	ListCommissions(ctx context.Context, workspaceID string, linkID *string, status *CommissionState, limit, offset int) ([]*AffiliateCommission, error)
	UpdateCommission(ctx context.Context, comm *AffiliateCommission) error

	// Payout operations
	CreatePayout(ctx context.Context, payout *AffiliatePayout) error
	GetPayout(ctx context.Context, workspaceID, payoutID string) (*AffiliatePayout, error)
	ListPayouts(ctx context.Context, workspaceID string, creatorID *string) ([]*AffiliatePayout, error)
	UpdatePayout(ctx context.Context, payout *AffiliatePayout) error

	// Statement operations
	CreateStatement(ctx context.Context, stmt *AffiliateStatement, items []*AffiliateStatementItem) error
	GetStatement(ctx context.Context, workspaceID, statementID string) (*AffiliateStatement, []*AffiliateStatementItem, error)
	UpdateStatement(ctx context.Context, stmt *AffiliateStatement, items []*AffiliateStatementItem) error

	// Health operations
	CreateHealthRecord(ctx context.Context, hr *LinkHealthRecord) error
	GetLatestHealthRecord(ctx context.Context, workspaceID, linkID string) (*LinkHealthRecord, error)
	ListHealthRecords(ctx context.Context, workspaceID string) ([]*LinkHealthRecord, error)
}

type MemoryStore struct {
	mu             sync.RWMutex
	links          map[string]*AffiliateLink
	assignments    map[string]*CreatorAssignment
	attributions   map[string]*AttributionRecord
	commissions    map[string]*AffiliateCommission
	payouts        map[string]*AffiliatePayout
	statements     map[string]*AffiliateStatement
	statementItems map[string][]*AffiliateStatementItem
	healthRecords  map[string][]*LinkHealthRecord // link_id -> records (sorted newest first)
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		links:          make(map[string]*AffiliateLink),
		assignments:    make(map[string]*CreatorAssignment),
		attributions:   make(map[string]*AttributionRecord),
		commissions:    make(map[string]*AffiliateCommission),
		payouts:        make(map[string]*AffiliatePayout),
		statements:     make(map[string]*AffiliateStatement),
		statementItems: make(map[string][]*AffiliateStatementItem),
		healthRecords:  make(map[string][]*LinkHealthRecord),
	}
}

// ----------------------------------------------------------------------------
// Link implementations
// ----------------------------------------------------------------------------

func (s *MemoryStore) CreateLink(_ context.Context, link *AffiliateLink) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key := link.WorkspaceID + ":" + link.AffiliateLinkID
	cp := *link
	s.links[key] = &cp
	return nil
}

func (s *MemoryStore) GetLink(_ context.Context, workspaceID, linkID string) (*AffiliateLink, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	key := workspaceID + ":" + linkID
	l, ok := s.links[key]
	if !ok || l.DeletedAt != nil {
		return nil, ErrLinkNotFound
	}
	cp := *l
	return &cp, nil
}

func (s *MemoryStore) ListLinks(_ context.Context, workspaceID string, campaignID, platform *string, state *LinkLifecycleState, limit, offset int) ([]*AffiliateLink, int, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matches []*AffiliateLink
	for _, l := range s.links {
		if l.WorkspaceID != workspaceID || l.DeletedAt != nil {
			continue
		}
		if campaignID != nil && (l.CampaignID == nil || *l.CampaignID != *campaignID) {
			continue
		}
		if platform != nil && !strings.EqualFold(l.Platform, *platform) {
			continue
		}
		if state != nil && l.LifecycleState != *state {
			continue
		}
		cp := *l
		matches = append(matches, &cp)
	}

	sort.Slice(matches, func(i, j int) bool {
		return matches[i].CreatedAt.After(matches[j].CreatedAt)
	})

	total := len(matches)
	if offset >= total {
		return []*AffiliateLink{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > total {
		end = total
	}
	return matches[offset:end], total, nil
}

func (s *MemoryStore) UpdateLink(_ context.Context, link *AffiliateLink) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key := link.WorkspaceID + ":" + link.AffiliateLinkID
	if _, ok := s.links[key]; !ok {
		return ErrLinkNotFound
	}
	cp := *link
	s.links[key] = &cp
	return nil
}

func (s *MemoryStore) DeleteLink(_ context.Context, workspaceID, linkID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key := workspaceID + ":" + linkID
	l, ok := s.links[key]
	if !ok || l.DeletedAt != nil {
		return ErrLinkNotFound
	}
	now := time.Now().UTC()
	l.DeletedAt = &now
	return nil
}

// ----------------------------------------------------------------------------
// Assignment implementations
// ----------------------------------------------------------------------------

func (s *MemoryStore) CreateAssignment(_ context.Context, assignment *CreatorAssignment) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key := assignment.WorkspaceID + ":" + assignment.AssignmentID
	cp := *assignment
	s.assignments[key] = &cp
	return nil
}

func (s *MemoryStore) GetAssignment(_ context.Context, workspaceID, assignmentID string) (*CreatorAssignment, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	key := workspaceID + ":" + assignmentID
	a, ok := s.assignments[key]
	if !ok || a.DeletedAt != nil {
		return nil, ErrAssignmentNotFound
	}
	cp := *a
	return &cp, nil
}

func (s *MemoryStore) ListAssignments(_ context.Context, workspaceID string, campaignID, creatorID *string, limit, offset int) ([]*CreatorAssignment, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matches []*CreatorAssignment
	for _, a := range s.assignments {
		if a.WorkspaceID != workspaceID || a.DeletedAt != nil {
			continue
		}
		if campaignID != nil && (a.CampaignID == nil || *a.CampaignID != *campaignID) {
			continue
		}
		if creatorID != nil && a.CreatorEntityID != *creatorID {
			continue
		}
		cp := *a
		matches = append(matches, &cp)
	}

	sort.Slice(matches, func(i, j int) bool {
		return matches[i].CreatedAt.After(matches[j].CreatedAt)
	})

	if offset >= len(matches) {
		return []*CreatorAssignment{}, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(matches) {
		end = len(matches)
	}
	return matches[offset:end], nil
}

func (s *MemoryStore) UpdateAssignment(_ context.Context, assignment *CreatorAssignment) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key := assignment.WorkspaceID + ":" + assignment.AssignmentID
	if _, ok := s.assignments[key]; !ok {
		return ErrAssignmentNotFound
	}
	cp := *assignment
	s.assignments[key] = &cp
	return nil
}

// ----------------------------------------------------------------------------
// Attribution implementations
// ----------------------------------------------------------------------------

func (s *MemoryStore) CreateAttribution(_ context.Context, attr *AttributionRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key := attr.WorkspaceID + ":" + attr.AttributionID
	cp := *attr
	s.attributions[key] = &cp
	return nil
}

func (s *MemoryStore) ListAttributions(_ context.Context, workspaceID string, linkID *string) ([]*AttributionRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matches []*AttributionRecord
	for _, a := range s.attributions {
		if a.WorkspaceID != workspaceID {
			continue
		}
		if linkID != nil && a.AffiliateLinkID != *linkID {
			continue
		}
		cp := *a
		matches = append(matches, &cp)
	}

	sort.Slice(matches, func(i, j int) bool {
		return matches[i].CreatedAt.After(matches[j].CreatedAt)
	})
	return matches, nil
}

// ----------------------------------------------------------------------------
// Commission implementations
// ----------------------------------------------------------------------------

func (s *MemoryStore) CreateCommission(_ context.Context, comm *AffiliateCommission) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key := comm.WorkspaceID + ":" + comm.CommissionID
	cp := *comm
	s.commissions[key] = &cp
	return nil
}

func (s *MemoryStore) GetCommission(_ context.Context, workspaceID, commissionID string) (*AffiliateCommission, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	key := workspaceID + ":" + commissionID
	c, ok := s.commissions[key]
	if !ok {
		return nil, ErrCommissionNotFound
	}
	cp := *c
	return &cp, nil
}

func (s *MemoryStore) ListCommissions(_ context.Context, workspaceID string, linkID *string, status *CommissionState, limit, offset int) ([]*AffiliateCommission, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matches []*AffiliateCommission
	for _, c := range s.commissions {
		if c.WorkspaceID != workspaceID {
			continue
		}
		if linkID != nil && c.AffiliateLinkID != *linkID {
			continue
		}
		if status != nil && c.Status != *status {
			continue
		}
		cp := *c
		matches = append(matches, &cp)
	}

	sort.Slice(matches, func(i, j int) bool {
		return matches[i].CreatedAt.After(matches[j].CreatedAt)
	})

	if offset >= len(matches) {
		return []*AffiliateCommission{}, nil
	}
	end := offset + limit
	if limit <= 0 || end > len(matches) {
		end = len(matches)
	}
	return matches[offset:end], nil
}

func (s *MemoryStore) UpdateCommission(_ context.Context, comm *AffiliateCommission) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key := comm.WorkspaceID + ":" + comm.CommissionID
	if _, ok := s.commissions[key]; !ok {
		return ErrCommissionNotFound
	}
	cp := *comm
	s.commissions[key] = &cp
	return nil
}

// ----------------------------------------------------------------------------
// Payout implementations
// ----------------------------------------------------------------------------

func (s *MemoryStore) CreatePayout(_ context.Context, payout *AffiliatePayout) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key := payout.WorkspaceID + ":" + payout.PayoutID
	cp := *payout
	s.payouts[key] = &cp
	return nil
}

func (s *MemoryStore) GetPayout(_ context.Context, workspaceID, payoutID string) (*AffiliatePayout, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	key := workspaceID + ":" + payoutID
	p, ok := s.payouts[key]
	if !ok {
		return nil, ErrPayoutNotFound
	}
	cp := *p
	return &cp, nil
}

func (s *MemoryStore) ListPayouts(_ context.Context, workspaceID string, creatorID *string) ([]*AffiliatePayout, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matches []*AffiliatePayout
	for _, p := range s.payouts {
		if p.WorkspaceID != workspaceID {
			continue
		}
		if creatorID != nil && p.CreatorEntityID != *creatorID {
			continue
		}
		cp := *p
		matches = append(matches, &cp)
	}

	sort.Slice(matches, func(i, j int) bool {
		return matches[i].CreatedAt.After(matches[j].CreatedAt)
	})
	return matches, nil
}

func (s *MemoryStore) UpdatePayout(_ context.Context, payout *AffiliatePayout) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key := payout.WorkspaceID + ":" + payout.PayoutID
	if _, ok := s.payouts[key]; !ok {
		return ErrPayoutNotFound
	}
	cp := *payout
	s.payouts[key] = &cp
	return nil
}

// ----------------------------------------------------------------------------
// Statement implementations
// ----------------------------------------------------------------------------

func (s *MemoryStore) CreateStatement(_ context.Context, stmt *AffiliateStatement, items []*AffiliateStatementItem) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key := stmt.WorkspaceID + ":" + stmt.StatementID
	cp := *stmt
	s.statements[key] = &cp

	var cpItems []*AffiliateStatementItem
	for _, it := range items {
		c := *it
		cpItems = append(cpItems, &c)
	}
	s.statementItems[stmt.StatementID] = cpItems
	return nil
}

func (s *MemoryStore) GetStatement(_ context.Context, workspaceID, statementID string) (*AffiliateStatement, []*AffiliateStatementItem, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	key := workspaceID + ":" + statementID
	st, ok := s.statements[key]
	if !ok {
		return nil, nil, ErrStatementNotFound
	}
	cp := *st
	items := s.statementItems[statementID]
	var outItems []*AffiliateStatementItem
	for _, it := range items {
		c := *it
		outItems = append(outItems, &c)
	}
	return &cp, outItems, nil
}

func (s *MemoryStore) UpdateStatement(_ context.Context, stmt *AffiliateStatement, items []*AffiliateStatementItem) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	key := stmt.WorkspaceID + ":" + stmt.StatementID
	if _, ok := s.statements[key]; !ok {
		return ErrStatementNotFound
	}
	cp := *stmt
	s.statements[key] = &cp

	var cpItems []*AffiliateStatementItem
	for _, it := range items {
		c := *it
		cpItems = append(cpItems, &c)
	}
	s.statementItems[stmt.StatementID] = cpItems
	return nil
}

// ----------------------------------------------------------------------------
// Health implementations
// ----------------------------------------------------------------------------

func (s *MemoryStore) CreateHealthRecord(_ context.Context, hr *LinkHealthRecord) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	cp := *hr
	records := s.healthRecords[hr.AffiliateLinkID]
	records = append([]*LinkHealthRecord{&cp}, records...) // newest first
	s.healthRecords[hr.AffiliateLinkID] = records
	return nil
}

func (s *MemoryStore) GetLatestHealthRecord(_ context.Context, workspaceID, linkID string) (*LinkHealthRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	records, ok := s.healthRecords[linkID]
	if !ok || len(records) == 0 {
		return nil, ErrHealthRecordNotFound
	}
	for _, r := range records {
		if r.WorkspaceID == workspaceID {
			cp := *r
			return &cp, nil
		}
	}
	return nil, ErrHealthRecordNotFound
}

func (s *MemoryStore) ListHealthRecords(_ context.Context, workspaceID string) ([]*LinkHealthRecord, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matches []*LinkHealthRecord
	for _, records := range s.healthRecords {
		for _, r := range records {
			if r.WorkspaceID == workspaceID {
				cp := *r
				matches = append(matches, &cp)
				break // newest per link
			}
		}
	}
	return matches, nil
}
