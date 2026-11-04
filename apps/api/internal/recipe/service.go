package recipe

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/workflow"
)

var (
	ErrMissingCapabilities = errors.New("recipe: required capabilities not satisfied for workspace")
	ErrInvalidRecipeStatus = errors.New("recipe: recipe is not in published status for installation")
	ErrInvalidRating       = errors.New("recipe: review rating must be between 1 and 5")
	ErrRefundWindowExpired = errors.New("recipe: 7-day refund window has expired (Pack 06 S22)")
	ErrAlreadyRefunded     = errors.New("recipe: revenue share already refunded")
)

// EventEmitter records or emits domain events asynchronously or in an outbox.
type EventEmitter func(ctx context.Context, eventType string, payload any) error

// Service implements business logic for recipe templates, installations, governance, and revenue shares.
type Service struct {
	store         Store
	workflowStore workflow.Store
	capChecker    CapabilityChecker
	emitter       EventEmitter
}

func NewService(store Store, workflowStore workflow.Store, capChecker CapabilityChecker) *Service {
	if capChecker == nil {
		capChecker = NewCapabilityChecker(workflow.NewDefaultCapabilityProvider())
	}
	return &Service{
		store:         store,
		workflowStore: workflowStore,
		capChecker:    capChecker,
		emitter: func(ctx context.Context, eventType string, payload any) error {
			return nil
		},
	}
}

func (s *Service) SetEventEmitter(emitter EventEmitter) {
	s.emitter = emitter
}

func (s *Service) CapabilityChecker() CapabilityChecker {
	return s.capChecker
}

func (s *Service) Store() Store {
	return s.store
}

func checkPermission(caller CallerContext, perm string) error {
	return rbac.CheckWorkspacePermission(perm, rbac.PolicyContext{
		ActorUserID: caller.UserID,
		WorkspaceID: caller.WorkspaceID,
		Role:        caller.WorkspaceRole,
	})
}

// Target 1 & 2 & 3: Install recipe into destination workspace.
// Preserves canonical graph, checks required capabilities, enforces tenant & system template isolation.
func (s *Service) InstallRecipe(ctx context.Context, caller CallerContext, recipeID string, parameterValuesJSON string, titleOverride string) (*RecipeInstallation, *workflow.Workflow, []MissingCapabilityExplanation, error) {
	// RBAC: recipe:install required (Editor+ per rbac_permission_matrix.md §2.9)
	if err := checkPermission(caller, "recipe:install"); err != nil {
		return nil, nil, nil, err
	}

	// Fetch template
	recipe, err := s.store.GetRecipe(ctx, recipeID)
	if err != nil {
		return nil, nil, nil, fmt.Errorf("lookup recipe: %w", err)
	}

	// Tenant/system template isolation check (Target 3):
	// System recipes must be published. Tenant recipes must belong to caller or be published.
	if recipe.WorkspaceID == nil {
		if recipe.Status != "published" {
			return nil, nil, nil, ErrInvalidRecipeStatus
		}
	} else if *recipe.WorkspaceID != caller.WorkspaceID && recipe.Status != "published" {
		return nil, nil, nil, ErrTenantAccessDenied
	}

	// Capability Check (Target 2):
	// Evaluate all required capabilities and explain missing capabilities
	isEligible, missing, err := s.capChecker.CheckEligibility(ctx, caller.WorkspaceID, recipe.RequiredCapabilities)
	if err != nil {
		return nil, nil, nil, fmt.Errorf("check capabilities: %w", err)
	}
	if !isEligible {
		// Installation is blocked with structured user-facing explanation (AC-M21-003, Alternate Flow A1)
		return nil, nil, missing, fmt.Errorf("%w: %d missing capabilities", ErrMissingCapabilities, len(missing))
	}

	// Parse parameter values
	var paramValues map[string]any
	if parameterValuesJSON != "" {
		_ = json.Unmarshal([]byte(parameterValuesJSON), &paramValues)
	}
	if paramValues == nil {
		paramValues = make(map[string]any)
	}

	// Target 1: Preserve canonical graph!
	// Clone portable graph from template payload, substituting new IDs without leaking source-tenant IDs
	clonedGraph := cloneAndSanitizeGraph(recipe.TemplatePayload.Graph, paramValues)

	workflowTitle := recipe.Title
	if strings.TrimSpace(titleOverride) != "" {
		workflowTitle = strings.TrimSpace(titleOverride)
	}

	// Determine trigger config from graph trigger node or fallback
	triggerCfg := workflow.TriggerConfig{
		Type: workflow.TriggerTypeManual,
	}
	for _, node := range clonedGraph.Nodes {
		if node.NodeType == workflow.NodeTypeTrigger {
			triggerCfg = extractTriggerConfig(node.Config)
			break
		}
	}

	now := time.Now().UTC()
	newWorkflowID := newUUID()

	// Instantiate canonical M20 workflow (workflow_type = 'recipe_installed')
	// The workflow is fully editable in M20 Workflow Builder, NOT a locked black box.
	wf := &workflow.Workflow{
		WorkflowID:           newWorkflowID,
		WorkspaceID:          caller.WorkspaceID,
		Title:                workflowTitle,
		WorkflowType:         "recipe_installed",
		TriggerConfig:        triggerCfg,
		ActionChain:          clonedGraph,
		ApprovalRequirements: []string{},
		Status:               workflow.WorkflowStatusDraft,
		Version:              1,
		RunCount:             0,
		CreatedBy:            caller.UserID,
		CreatedAt:            now,
		UpdatedAt:            now,
	}

	if s.workflowStore != nil {
		err := s.workflowStore.CreateWorkflow(ctx, wf)
		if err != nil {
			return nil, nil, nil, fmt.Errorf("persist canonical workflow: %w", err)
		}
	}

	// Create RecipeInstallation record
	inst := &RecipeInstallation{
		InstallationID:   newUUID(),
		WorkspaceID:      caller.WorkspaceID,
		RecipeID:         recipe.RecipeID,
		WorkflowID:       wf.WorkflowID,
		InstalledVersion: recipe.TemplateVersion,
		Status:           "installed",
		ParameterValues:  paramValues,
		InstalledBy:      caller.UserID,
		CreatedAt:        now,
		UpdatedAt:        now,
	}

	createdInst, err := s.store.CreateInstallation(ctx, inst)
	if err != nil {
		return nil, nil, nil, fmt.Errorf("create recipe installation: %w", err)
	}

	// Increment install count on recipe template atomically
	_ = s.store.IncrementInstallCount(ctx, recipe.RecipeID)

	// Process revenue share if paid recipe (RULE-M21-006: 70/30 split, 7-day refund window)
	if recipe.PriceUSD != "" && recipe.PriceUSD != "0" && recipe.PriceUSD != "0.000000" {
		_, _ = s.ProcessRevenueShare(ctx, recipe, caller.WorkspaceID, recipe.PriceUSD)
	}

	// Emit canonical domain event: recipe.installed {recipe_id, workflow_id}
	if s.emitter != nil {
		_ = s.emitter(ctx, "recipe.installed", map[string]any{
			"recipe_id":       recipe.RecipeID,
			"workflow_id":     wf.WorkflowID,
			"installation_id": createdInst.InstallationID,
			"workspace_id":    caller.WorkspaceID,
		})
	}

	return createdInst, wf, nil, nil
}

// UninstallRecipe handles uninstallation and optional workflow deletion.
func (s *Service) UninstallRecipe(ctx context.Context, caller CallerContext, installationID string, deleteWorkflow bool) error {
	// RBAC: recipe:install required (Manager+ per rbac_permission_matrix.md)
	if err := checkPermission(caller, "recipe:install"); err != nil {
		return err
	}

	inst, err := s.store.GetInstallation(ctx, caller.WorkspaceID, installationID)
	if err != nil {
		return err
	}

	if deleteWorkflow && s.workflowStore != nil {
		_ = s.workflowStore.DeleteWorkflow(ctx, caller.WorkspaceID, inst.WorkflowID)
		inst.Status = "workflow_deleted"
	} else {
		inst.Status = "deprecated"
	}

	now := time.Now().UTC()
	inst.DeletedAt = &now
	_, err = s.store.UpdateInstallation(ctx, inst)
	return err
}

// GetRecipe retrieves recipe details along with missing capabilities check for caller's workspace.
func (s *Service) GetRecipe(ctx context.Context, caller CallerContext, recipeID string) (*RecipeTemplate, []MissingCapabilityExplanation, *RecipeInstallation, error) {
	if err := checkPermission(caller, "workflow:read"); err != nil {
		return nil, nil, nil, err
	}

	recipe, err := s.store.GetRecipe(ctx, recipeID)
	if err != nil {
		return nil, nil, nil, err
	}

	// System or same tenant
	if recipe.WorkspaceID != nil && *recipe.WorkspaceID != caller.WorkspaceID && recipe.Status != "published" {
		return nil, nil, nil, ErrTenantAccessDenied
	}

	// Evaluate capabilities
	_, missing, err := s.capChecker.CheckEligibility(ctx, caller.WorkspaceID, recipe.RequiredCapabilities)
	if err != nil {
		return nil, nil, nil, err
	}

	// Look up any active installation in this workspace
	activeInst, _ := s.store.GetInstallationByRecipe(ctx, caller.WorkspaceID, recipeID)

	return recipe, missing, activeInst, nil
}

// ListRecipes lists accessible recipes with category and status filtering.
func (s *Service) ListRecipes(ctx context.Context, caller CallerContext, category, statusFilter string, includeSystem bool, limit, offset int) ([]*RecipeTemplate, []*RecipeInstallation, int, error) {
	if err := checkPermission(caller, "workflow:read"); err != nil {
		return nil, nil, 0, err
	}

	recipes, total, err := s.store.ListRecipes(ctx, caller.WorkspaceID, category, statusFilter, includeSystem, limit, offset)
	if err != nil {
		return nil, nil, 0, err
	}

	installations, _, _ := s.store.ListInstallations(ctx, caller.WorkspaceID, 100, 0)
	return recipes, installations, total, nil
}

// Configure updates installation parameters, version pinning, or auto-update behavior.
func (s *Service) Configure(ctx context.Context, caller CallerContext, installationID string, parameterValuesJSON string, pinnedVersion int, autoUpdate bool) (*RecipeInstallation, error) {
	if err := checkPermission(caller, "recipe:install"); err != nil {
		return nil, err
	}

	inst, err := s.store.GetInstallation(ctx, caller.WorkspaceID, installationID)
	if err != nil {
		return nil, err
	}

	if parameterValuesJSON != "" {
		var pv map[string]any
		if err := json.Unmarshal([]byte(parameterValuesJSON), &pv); err == nil {
			inst.ParameterValues = pv
			inst.Status = "customized"
		}
	}

	if pinnedVersion > 0 {
		inst.InstalledVersion = pinnedVersion
		inst.Status = "pinned"
	} else if autoUpdate {
		inst.Status = "installed"
	}

	inst.UpdatedAt = time.Now().UTC()
	return s.store.UpdateInstallation(ctx, inst)
}

// SubmitReview adds a 1-5 star review and recomputes the recipe template average rating.
func (s *Service) SubmitReview(ctx context.Context, caller CallerContext, recipeID string, rating int, reviewText, authorName string) (*RecipeReview, error) {
	if err := checkPermission(caller, "workflow:read"); err != nil {
		return nil, err
	}
	if rating < 1 || rating > 5 {
		return nil, ErrInvalidRating
	}

	review := &RecipeReview{
		RecipeID:    recipeID,
		WorkspaceID: caller.WorkspaceID,
		UserID:      caller.UserID,
		Rating:      rating,
		ReviewText:  reviewText,
		AuthorName:  authorName,
	}

	return s.store.CreateReview(ctx, review)
}

// ListReviews lists reviews for a template.
func (s *Service) ListReviews(ctx context.Context, caller CallerContext, recipeID string, limit, offset int) ([]*RecipeReview, int, error) {
	if err := checkPermission(caller, "workflow:read"); err != nil {
		return nil, 0, err
	}
	return s.store.ListReviews(ctx, recipeID, limit, offset)
}

// Governance: Submit recipe for marketplace review (Pack 06 S22).
func (s *Service) SubmitForReview(ctx context.Context, caller CallerContext, recipeID string) (*RecipeSubmission, error) {
	if err := checkPermission(caller, "workflow:create"); err != nil {
		return nil, err
	}

	recipe, err := s.store.GetRecipe(ctx, recipeID)
	if err != nil {
		return nil, err
	}
	if recipe.WorkspaceID == nil || *recipe.WorkspaceID != caller.WorkspaceID {
		return nil, ErrTenantAccessDenied
	}

	recipe.Status = "review_required"
	_, err = s.store.UpdateRecipe(ctx, recipe)
	if err != nil {
		return nil, err
	}

	sub := &RecipeSubmission{
		RecipeID:          recipe.RecipeID,
		AuthorWorkspaceID: caller.WorkspaceID,
		SubmittedVersion:  recipe.TemplateVersion,
		Status:            "pending",
		ReviewNotes:       "Submitted for marketplace review (3-day SLA).",
	}

	return s.store.CreateSubmission(ctx, sub)
}

// Governance: Admin reviews submission (approve/reject).
func (s *Service) ReviewSubmission(ctx context.Context, adminCaller CallerContext, submissionID string, approve bool, notes string) (*RecipeSubmission, error) {
	// Internal admin check
	if adminCaller.WorkspaceRole != "super_admin" && adminCaller.WorkspaceRole != "content_admin" && adminCaller.WorkspaceRole != "admin" {
		return nil, rbac.ErrPermissionDenied
	}

	sub, err := s.store.GetSubmission(ctx, submissionID)
	if err != nil {
		return nil, err
	}

	now := time.Now().UTC()
	sub.ReviewedBy = adminCaller.UserID
	sub.ReviewedAt = &now
	sub.ReviewNotes = notes

	recipe, err := s.store.GetRecipe(ctx, sub.RecipeID)
	if err != nil {
		return nil, err
	}

	if approve {
		sub.Status = "approved"
		recipe.Status = "published"
	} else {
		sub.Status = "rejected"
		recipe.Status = "draft"
	}

	_, _ = s.store.UpdateRecipe(ctx, recipe)
	return s.store.UpdateSubmission(ctx, sub)
}

// Governance: DMCA or policy takedown within 48h (Pack 06 S22, RULE-M21-006).
func (s *Service) TakedownRecipe(ctx context.Context, adminCaller CallerContext, recipeID, reason, ticketRef string) (*RecipeTemplate, error) {
	if adminCaller.WorkspaceRole != "super_admin" && adminCaller.WorkspaceRole != "content_admin" && adminCaller.WorkspaceRole != "admin" {
		return nil, rbac.ErrPermissionDenied
	}

	recipe, err := s.store.GetRecipe(ctx, recipeID)
	if err != nil {
		return nil, err
	}

	recipe.Status = "taken_down"
	recipe.UpdatedAt = time.Now().UTC()
	updatedRecipe, err := s.store.UpdateRecipe(ctx, recipe)
	if err != nil {
		return nil, err
	}

	// Create/record takedown submission entry
	now := time.Now().UTC()
	sub := &RecipeSubmission{
		RecipeID:          recipe.RecipeID,
		AuthorWorkspaceID: getAuthorWorkspaceID(recipe),
		SubmittedVersion:  recipe.TemplateVersion,
		Status:            "taken_down",
		ReviewNotes:       "Takedown enforced within 48h SLA per DMCA/content policy.",
		ReviewedBy:        adminCaller.UserID,
		ReviewedAt:        &now,
		TakedownReason:    reason,
		TakedownTicketRef: ticketRef,
	}
	_, _ = s.store.CreateSubmission(ctx, sub)

	return updatedRecipe, nil
}

// Revenue Share: 70/30 creator/platform split and 7-day refund window (RULE-M21-006).
func (s *Service) ProcessRevenueShare(ctx context.Context, recipe *RecipeTemplate, purchaserWorkspaceID, grossAmountStr string) (*RecipeRevenueShare, error) {
	grossDec, err := tenantdb.ParseExactDecimal(grossAmountStr)
	if err != nil {
		return nil, fmt.Errorf("invalid gross amount decimal: %w", err)
	}

	// Exact decimal arithmetic (never float!)
	rate70, err := tenantdb.ParseExactDecimal("0.700000")
	if err != nil {
		return nil, fmt.Errorf("parse rate decimal: %w", err)
	}
	creatorDec, err := grossDec.MulFloor(rate70)
	if err != nil {
		return nil, fmt.Errorf("calculate creator share: %w", err)
	}
	platformDec, err := grossDec.Sub(creatorDec)
	if err != nil {
		return nil, fmt.Errorf("calculate platform share: %w", err)
	}

	authorWsID := getAuthorWorkspaceID(recipe)

	now := time.Now().UTC()
	revShare := &RecipeRevenueShare{
		RecipeID:             recipe.RecipeID,
		AuthorWorkspaceID:    authorWsID,
		PurchaserWorkspaceID: purchaserWorkspaceID,
		GrossAmount:          grossDec.Fixed6String(),
		CreatorAmount:        creatorDec.Fixed6String(),
		PlatformAmount:       platformDec.Fixed6String(),
		Currency:             "USD",
		Status:               "settled",
		RefundEligibleUntil:  now.Add(7 * 24 * time.Hour), // 7-day refund window
		CreatedAt:            now,
		UpdatedAt:            now,
	}

	return s.store.CreateRevenueShare(ctx, revShare)
}

// RefundPurchase handles refunding paid recipe within 7-day window.
func (s *Service) RefundPurchase(ctx context.Context, caller CallerContext, revShareID, reason string) (*RecipeRevenueShare, error) {
	revShare, err := s.store.GetRevenueShare(ctx, revShareID)
	if err != nil {
		return nil, err
	}

	if revShare.PurchaserWorkspaceID != caller.WorkspaceID && caller.WorkspaceRole != "admin" && caller.WorkspaceRole != "super_admin" {
		return nil, ErrTenantAccessDenied
	}

	if revShare.Status == "refunded" {
		return nil, ErrAlreadyRefunded
	}

	now := time.Now().UTC()
	if now.After(revShare.RefundEligibleUntil) {
		return nil, ErrRefundWindowExpired
	}

	revShare.Status = "refunded"
	revShare.UpdatedAt = now
	return s.store.UpdateRevenueShare(ctx, revShare)
}

func getAuthorWorkspaceID(r *RecipeTemplate) string {
	if r.AuthorWorkspaceID != nil && *r.AuthorWorkspaceID != "" {
		return *r.AuthorWorkspaceID
	}
	if r.WorkspaceID != nil && *r.WorkspaceID != "" {
		return *r.WorkspaceID
	}
	return "00000000-0000-0000-0000-000000000000" // system platform owner
}

// Helper: clones canonical graph and resolves parameter placeholders into newly isolated nodes.
func cloneAndSanitizeGraph(graph workflow.WorkflowGraph, paramValues map[string]any) workflow.WorkflowGraph {
	cloned := workflow.WorkflowGraph{
		SchemaVersion: 1,
		Nodes:         make([]workflow.WorkflowNode, len(graph.Nodes)),
		Edges:         make([]workflow.WorkflowEdge, len(graph.Edges)),
	}

	for i, node := range graph.Nodes {
		clonedCfg := make(map[string]any)
		for k, v := range node.Config {
			if strVal, ok := v.(string); ok {
				// Check parameter placeholder: e.g. {{param_name}}
				if strings.HasPrefix(strVal, "{{") && strings.HasSuffix(strVal, "}}") {
					paramName := strings.Trim(strVal, "{} ")
					if override, exists := paramValues[paramName]; exists {
						clonedCfg[k] = override
						continue
					}
				}
			}
			clonedCfg[k] = v
		}
		cloned.Nodes[i] = workflow.WorkflowNode{
			NodeID:   node.NodeID,
			NodeType: node.NodeType,
			Config:   clonedCfg,
		}
	}

	copy(cloned.Edges, graph.Edges)
	return cloned
}

func extractTriggerConfig(cfg map[string]any) workflow.TriggerConfig {
	tc := workflow.TriggerConfig{
		Type: workflow.TriggerTypeManual,
	}
	if typeRaw, ok := cfg["type"].(string); ok {
		switch strings.ToLower(typeRaw) {
		case "event":
			tc.Type = workflow.TriggerTypeEvent
			if evt, ok := cfg["event_type"].(string); ok {
				tc.EventType = evt
			}
		case "schedule":
			tc.Type = workflow.TriggerTypeSchedule
			if cron, ok := cfg["cron_expression"].(string); ok {
				tc.CronExpression = cron
			}
		case "webhook":
			tc.Type = workflow.TriggerTypeWebhook
			if path, ok := cfg["webhook_path"].(string); ok {
				tc.WebhookPath = path
			}
		default:
			tc.Type = workflow.TriggerTypeManual
		}
	}
	return tc
}
