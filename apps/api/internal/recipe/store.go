package recipe

import (
	"context"
	"crypto/rand"
	"errors"
	"fmt"
	"sync"
	"time"
)

func newUUID() string {
	var b [16]byte
	_, _ = rand.Read(b[:])
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

var (
	ErrRecipeNotFound       = errors.New("recipe: recipe not found")
	ErrInstallationNotFound = errors.New("recipe: installation not found")
	ErrReviewNotFound       = errors.New("recipe: review not found")
	ErrReviewAlreadyExists  = errors.New("recipe: user already submitted a review for this recipe")
	ErrSubmissionNotFound   = errors.New("recipe: submission not found")
	ErrRevenueShareNotFound = errors.New("recipe: revenue share record not found")
	ErrTenantAccessDenied   = errors.New("recipe: unauthorized tenant access")
	ErrSystemRecipeReadOnly = errors.New("recipe: system recipes are globally read-only")
)

// Store defines persistence operations for recipe templates and marketplace entities.
type Store interface {
	GetRecipe(ctx context.Context, recipeID string) (*RecipeTemplate, error)
	ListRecipes(ctx context.Context, workspaceID, category, statusFilter string, includeSystem bool, limit, offset int) ([]*RecipeTemplate, int, error)
	CreateRecipe(ctx context.Context, recipe *RecipeTemplate) (*RecipeTemplate, error)
	UpdateRecipe(ctx context.Context, recipe *RecipeTemplate) (*RecipeTemplate, error)
	DeleteRecipe(ctx context.Context, workspaceID, recipeID string) error
	IncrementInstallCount(ctx context.Context, recipeID string) error

	GetInstallation(ctx context.Context, workspaceID, installationID string) (*RecipeInstallation, error)
	GetInstallationByRecipe(ctx context.Context, workspaceID, recipeID string) (*RecipeInstallation, error)
	ListInstallations(ctx context.Context, workspaceID string, limit, offset int) ([]*RecipeInstallation, int, error)
	CreateInstallation(ctx context.Context, inst *RecipeInstallation) (*RecipeInstallation, error)
	UpdateInstallation(ctx context.Context, inst *RecipeInstallation) (*RecipeInstallation, error)
	DeleteInstallation(ctx context.Context, workspaceID, installationID string) error

	CreateReview(ctx context.Context, review *RecipeReview) (*RecipeReview, error)
	ListReviews(ctx context.Context, recipeID string, limit, offset int) ([]*RecipeReview, int, error)
	GetReviewByUser(ctx context.Context, recipeID, workspaceID, userID string) (*RecipeReview, error)

	CreateSubmission(ctx context.Context, sub *RecipeSubmission) (*RecipeSubmission, error)
	GetSubmission(ctx context.Context, submissionID string) (*RecipeSubmission, error)
	UpdateSubmission(ctx context.Context, sub *RecipeSubmission) (*RecipeSubmission, error)
	ListSubmissions(ctx context.Context, authorWorkspaceID, status string, limit, offset int) ([]*RecipeSubmission, int, error)

	CreateRevenueShare(ctx context.Context, revShare *RecipeRevenueShare) (*RecipeRevenueShare, error)
	GetRevenueShare(ctx context.Context, revShareID string) (*RecipeRevenueShare, error)
	ListRevenueShares(ctx context.Context, workspaceID string, limit, offset int) ([]*RecipeRevenueShare, int, error)
	UpdateRevenueShare(ctx context.Context, revShare *RecipeRevenueShare) (*RecipeRevenueShare, error)
}

// MemoryStore provides a thread-safe in-memory implementation of Store.
type MemoryStore struct {
	mu            sync.RWMutex
	recipes       map[string]*RecipeTemplate
	installations map[string]*RecipeInstallation
	reviews       map[string]*RecipeReview
	submissions   map[string]*RecipeSubmission
	revenueShares map[string]*RecipeRevenueShare
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		recipes:       make(map[string]*RecipeTemplate),
		installations: make(map[string]*RecipeInstallation),
		reviews:       make(map[string]*RecipeReview),
		submissions:   make(map[string]*RecipeSubmission),
		revenueShares: make(map[string]*RecipeRevenueShare),
	}
}

var _ Store = (*MemoryStore)(nil)

// Recipe Operations

func (m *MemoryStore) GetRecipe(ctx context.Context, recipeID string) (*RecipeTemplate, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	r, exists := m.recipes[recipeID]
	if !exists || r.DeletedAt != nil {
		return nil, ErrRecipeNotFound
	}
	cp := *r
	return &cp, nil
}

func (m *MemoryStore) ListRecipes(ctx context.Context, workspaceID, category, statusFilter string, includeSystem bool, limit, offset int) ([]*RecipeTemplate, int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matches []*RecipeTemplate
	for _, r := range m.recipes {
		if r.DeletedAt != nil {
			continue
		}
		// System recipe vs tenant recipe isolation check
		isSystem := r.WorkspaceID == nil
		isTenant := r.WorkspaceID != nil && *r.WorkspaceID == workspaceID

		if isSystem && (!includeSystem || r.Status != "published") {
			continue
		}
		if !isSystem && !isTenant {
			continue
		}

		if category != "" && r.Category != category {
			continue
		}
		if statusFilter != "" && r.Status != statusFilter {
			continue
		}

		cp := *r
		matches = append(matches, &cp)
	}

	total := len(matches)
	if offset > total {
		return []*RecipeTemplate{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > total {
		end = total
	}
	return matches[offset:end], total, nil
}

func (m *MemoryStore) CreateRecipe(ctx context.Context, recipe *RecipeTemplate) (*RecipeTemplate, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	if recipe.RecipeID == "" {
		recipe.RecipeID = newUUID()
	}
	now := time.Now().UTC()
	if recipe.CreatedAt.IsZero() {
		recipe.CreatedAt = now
	}
	recipe.UpdatedAt = now
	if recipe.PriceUSD == "" {
		recipe.PriceUSD = "0.000000"
	}

	cp := *recipe
	m.recipes[recipe.RecipeID] = &cp
	return &cp, nil
}

func (m *MemoryStore) UpdateRecipe(ctx context.Context, recipe *RecipeTemplate) (*RecipeTemplate, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, exists := m.recipes[recipe.RecipeID]
	if !exists || existing.DeletedAt != nil {
		return nil, ErrRecipeNotFound
	}
	recipe.UpdatedAt = time.Now().UTC()
	cp := *recipe
	m.recipes[recipe.RecipeID] = &cp
	return &cp, nil
}

func (m *MemoryStore) DeleteRecipe(ctx context.Context, workspaceID, recipeID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, exists := m.recipes[recipeID]
	if !exists || existing.DeletedAt != nil {
		return ErrRecipeNotFound
	}
	if existing.WorkspaceID == nil {
		return ErrSystemRecipeReadOnly
	}
	if *existing.WorkspaceID != workspaceID {
		return ErrTenantAccessDenied
	}
	now := time.Now().UTC()
	existing.DeletedAt = &now
	existing.UpdatedAt = now
	return nil
}

func (m *MemoryStore) IncrementInstallCount(ctx context.Context, recipeID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	r, exists := m.recipes[recipeID]
	if !exists || r.DeletedAt != nil {
		return ErrRecipeNotFound
	}
	r.InstallCount++
	r.UpdatedAt = time.Now().UTC()
	return nil
}

// Installation Operations

func (m *MemoryStore) GetInstallation(ctx context.Context, workspaceID, installationID string) (*RecipeInstallation, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	inst, exists := m.installations[installationID]
	if !exists || inst.DeletedAt != nil {
		return nil, ErrInstallationNotFound
	}
	if inst.WorkspaceID != workspaceID {
		return nil, ErrTenantAccessDenied
	}
	cp := *inst
	return &cp, nil
}

func (m *MemoryStore) GetInstallationByRecipe(ctx context.Context, workspaceID, recipeID string) (*RecipeInstallation, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	for _, inst := range m.installations {
		if inst.DeletedAt != nil {
			continue
		}
		if inst.WorkspaceID == workspaceID && inst.RecipeID == recipeID {
			cp := *inst
			return &cp, nil
		}
	}
	return nil, ErrInstallationNotFound
}

func (m *MemoryStore) ListInstallations(ctx context.Context, workspaceID string, limit, offset int) ([]*RecipeInstallation, int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matches []*RecipeInstallation
	for _, inst := range m.installations {
		if inst.DeletedAt != nil || inst.WorkspaceID != workspaceID {
			continue
		}
		cp := *inst
		matches = append(matches, &cp)
	}

	total := len(matches)
	if offset > total {
		return []*RecipeInstallation{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > total {
		end = total
	}
	return matches[offset:end], total, nil
}

func (m *MemoryStore) CreateInstallation(ctx context.Context, inst *RecipeInstallation) (*RecipeInstallation, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	if inst.InstallationID == "" {
		inst.InstallationID = newUUID()
	}
	now := time.Now().UTC()
	if inst.CreatedAt.IsZero() {
		inst.CreatedAt = now
	}
	inst.UpdatedAt = now

	cp := *inst
	m.installations[inst.InstallationID] = &cp
	return &cp, nil
}

func (m *MemoryStore) UpdateInstallation(ctx context.Context, inst *RecipeInstallation) (*RecipeInstallation, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, exists := m.installations[inst.InstallationID]
	if !exists || existing.DeletedAt != nil {
		return nil, ErrInstallationNotFound
	}
	if existing.WorkspaceID != inst.WorkspaceID {
		return nil, ErrTenantAccessDenied
	}
	inst.UpdatedAt = time.Now().UTC()
	cp := *inst
	m.installations[inst.InstallationID] = &cp
	return &cp, nil
}

func (m *MemoryStore) DeleteInstallation(ctx context.Context, workspaceID, installationID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	existing, exists := m.installations[installationID]
	if !exists || existing.DeletedAt != nil {
		return ErrInstallationNotFound
	}
	if existing.WorkspaceID != workspaceID {
		return ErrTenantAccessDenied
	}
	now := time.Now().UTC()
	existing.DeletedAt = &now
	existing.UpdatedAt = now
	return nil
}

// Review Operations

func (m *MemoryStore) CreateReview(ctx context.Context, review *RecipeReview) (*RecipeReview, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	for _, r := range m.reviews {
		if r.RecipeID == review.RecipeID && r.WorkspaceID == review.WorkspaceID && r.UserID == review.UserID {
			return nil, ErrReviewAlreadyExists
		}
	}

	if review.ReviewID == "" {
		review.ReviewID = newUUID()
	}
	now := time.Now().UTC()
	if review.CreatedAt.IsZero() {
		review.CreatedAt = now
	}
	review.UpdatedAt = now

	cp := *review
	m.reviews[review.ReviewID] = &cp

	// Recompute rating_avg and review_count on template
	if tmpl, ok := m.recipes[review.RecipeID]; ok {
		var totalRating int
		var count int
		for _, r := range m.reviews {
			if r.RecipeID == review.RecipeID {
				totalRating += r.Rating
				count++
			}
		}
		if count > 0 {
			tmpl.RatingAvg = float32(totalRating) / float32(count)
			tmpl.ReviewCount = count
			tmpl.UpdatedAt = now
		}
	}

	return &cp, nil
}

func (m *MemoryStore) ListReviews(ctx context.Context, recipeID string, limit, offset int) ([]*RecipeReview, int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matches []*RecipeReview
	for _, r := range m.reviews {
		if r.RecipeID == recipeID {
			cp := *r
			matches = append(matches, &cp)
		}
	}

	total := len(matches)
	if offset > total {
		return []*RecipeReview{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > total {
		end = total
	}
	return matches[offset:end], total, nil
}

func (m *MemoryStore) GetReviewByUser(ctx context.Context, recipeID, workspaceID, userID string) (*RecipeReview, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	for _, r := range m.reviews {
		if r.RecipeID == recipeID && r.WorkspaceID == workspaceID && r.UserID == userID {
			cp := *r
			return &cp, nil
		}
	}
	return nil, ErrReviewNotFound
}

// Submission Operations

func (m *MemoryStore) CreateSubmission(ctx context.Context, sub *RecipeSubmission) (*RecipeSubmission, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	if sub.SubmissionID == "" {
		sub.SubmissionID = newUUID()
	}
	now := time.Now().UTC()
	if sub.CreatedAt.IsZero() {
		sub.CreatedAt = now
	}
	sub.UpdatedAt = now

	cp := *sub
	m.submissions[sub.SubmissionID] = &cp
	return &cp, nil
}

func (m *MemoryStore) GetSubmission(ctx context.Context, submissionID string) (*RecipeSubmission, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	sub, exists := m.submissions[submissionID]
	if !exists {
		return nil, ErrSubmissionNotFound
	}
	cp := *sub
	return &cp, nil
}

func (m *MemoryStore) UpdateSubmission(ctx context.Context, sub *RecipeSubmission) (*RecipeSubmission, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	if _, exists := m.submissions[sub.SubmissionID]; !exists {
		return nil, ErrSubmissionNotFound
	}
	sub.UpdatedAt = time.Now().UTC()
	cp := *sub
	m.submissions[sub.SubmissionID] = &cp
	return &cp, nil
}

func (m *MemoryStore) ListSubmissions(ctx context.Context, authorWorkspaceID, status string, limit, offset int) ([]*RecipeSubmission, int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matches []*RecipeSubmission
	for _, sub := range m.submissions {
		if authorWorkspaceID != "" && sub.AuthorWorkspaceID != authorWorkspaceID {
			continue
		}
		if status != "" && sub.Status != status {
			continue
		}
		cp := *sub
		matches = append(matches, &cp)
	}

	total := len(matches)
	if offset > total {
		return []*RecipeSubmission{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > total {
		end = total
	}
	return matches[offset:end], total, nil
}

// Revenue Share Operations

func (m *MemoryStore) CreateRevenueShare(ctx context.Context, revShare *RecipeRevenueShare) (*RecipeRevenueShare, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	if revShare.RevenueShareID == "" {
		revShare.RevenueShareID = newUUID()
	}
	now := time.Now().UTC()
	if revShare.CreatedAt.IsZero() {
		revShare.CreatedAt = now
	}
	revShare.UpdatedAt = now
	if revShare.RefundEligibleUntil.IsZero() {
		revShare.RefundEligibleUntil = now.Add(7 * 24 * time.Hour) // 7-day refund window (Pack 06 S22)
	}

	cp := *revShare
	m.revenueShares[revShare.RevenueShareID] = &cp
	return &cp, nil
}

func (m *MemoryStore) GetRevenueShare(ctx context.Context, revShareID string) (*RecipeRevenueShare, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	rev, exists := m.revenueShares[revShareID]
	if !exists {
		return nil, ErrRevenueShareNotFound
	}
	cp := *rev
	return &cp, nil
}

func (m *MemoryStore) ListRevenueShares(ctx context.Context, workspaceID string, limit, offset int) ([]*RecipeRevenueShare, int, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var matches []*RecipeRevenueShare
	for _, rev := range m.revenueShares {
		if rev.AuthorWorkspaceID == workspaceID || rev.PurchaserWorkspaceID == workspaceID {
			cp := *rev
			matches = append(matches, &cp)
		}
	}

	total := len(matches)
	if offset > total {
		return []*RecipeRevenueShare{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > total {
		end = total
	}
	return matches[offset:end], total, nil
}

func (m *MemoryStore) UpdateRevenueShare(ctx context.Context, revShare *RecipeRevenueShare) (*RecipeRevenueShare, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	if _, exists := m.revenueShares[revShare.RevenueShareID]; !exists {
		return nil, ErrRevenueShareNotFound
	}
	revShare.UpdatedAt = time.Now().UTC()
	cp := *revShare
	m.revenueShares[revShare.RevenueShareID] = &cp
	return &cp, nil
}
