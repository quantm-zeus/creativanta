package workflow

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

type Store interface {
	CreateWorkflow(ctx context.Context, w *Workflow) error
	GetWorkflow(ctx context.Context, workspaceID, workflowID string) (*Workflow, error)
	ListWorkflows(ctx context.Context, workspaceID string, status string, limit, offset int) ([]Workflow, int, error)
	UpdateWorkflow(ctx context.Context, w *Workflow) error
	DeleteWorkflow(ctx context.Context, workspaceID, workflowID string) error

	CreateWorkflowRun(ctx context.Context, run *WorkflowRun) error
	GetWorkflowRun(ctx context.Context, workspaceID, runID string) (*WorkflowRun, error)
	ListWorkflowRuns(ctx context.Context, workspaceID, workflowID, status string, limit, offset int) ([]WorkflowRun, int, error)
	UpdateWorkflowRun(ctx context.Context, run *WorkflowRun) error

	CreateWorkflowRunStep(ctx context.Context, step *WorkflowRunStep) error
	ListWorkflowRunSteps(ctx context.Context, workspaceID, runID string) ([]WorkflowRunStep, error)
	UpdateWorkflowRunStep(ctx context.Context, step *WorkflowRunStep) error

	// Approvals (§18.1)
	CreateApprovalRequest(ctx context.Context, req *ApprovalRequest) error
	GetApprovalRequest(ctx context.Context, workspaceID, requestID string) (*ApprovalRequest, error)
	ListApprovalRequests(ctx context.Context, workspaceID string, filter ApprovalFilter) ([]ApprovalRequest, int, error)
	UpdateApprovalRequest(ctx context.Context, req *ApprovalRequest) error
	FindPendingApprovalsByWorkflow(ctx context.Context, workspaceID, workflowID string) ([]ApprovalRequest, error)
	FindPendingApprovalsByRun(ctx context.Context, workspaceID, runID string) ([]ApprovalRequest, error)

	// Dead-Letter Queue (§18.4G)
	CreateDLQItem(ctx context.Context, item *DLQItem) error
	GetDLQItem(ctx context.Context, workspaceID, dlqID string) (*DLQItem, error)
	ListDLQItems(ctx context.Context, workspaceID string, status string, limit, offset int) ([]DLQItem, int, error)
	UpdateDLQItem(ctx context.Context, item *DLQItem) error
}

// WorkspaceMembershipStore provides authoritative live membership resolution for a workspace member.
type WorkspaceMembershipStore interface {
	ResolveWorkspaceMemberRole(ctx context.Context, workspaceID, userID string) (role string, active bool, found bool, err error)
}

// WorkspaceMembershipMutator allows tests and administrative reconciliation to update workspace membership in a store.
type WorkspaceMembershipMutator interface {
	SetMemberRole(workspaceID, userID, role string, active bool)
	RevokeMemberAccess(workspaceID, userID string)
}

// ----------------------------------------------------------------------------
// MemoryStore (Thread-safe in-memory store for unit tests and deterministic fixtures)
// ----------------------------------------------------------------------------

type MemoryStore struct {
	mu        sync.RWMutex
	workflows map[string]*Workflow             // key: workspaceID:workflowID
	runs      map[string]*WorkflowRun          // key: workspaceID:runID
	steps     map[string]*WorkflowRunStep      // key: workspaceID:stepID
	approvals map[string]*ApprovalRequest      // key: workspaceID:requestID
	dlqItems  map[string]*DLQItem              // key: workspaceID:dlqID
	members   map[string]memberMembershipState // key: workspaceID:userID
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		workflows: make(map[string]*Workflow),
		runs:      make(map[string]*WorkflowRun),
		steps:     make(map[string]*WorkflowRunStep),
		approvals: make(map[string]*ApprovalRequest),
		dlqItems:  make(map[string]*DLQItem),
		members:   make(map[string]memberMembershipState),
	}
}

var _ Store = (*MemoryStore)(nil)
var _ WorkspaceMembershipStore = (*MemoryStore)(nil)
var _ WorkspaceMembershipMutator = (*MemoryStore)(nil)

func (s *MemoryStore) SetMemberRole(workspaceID, userID, role string, active bool) {
	ws := strings.TrimSpace(workspaceID)
	uid := strings.TrimSpace(userID)
	if ws == "" || uid == "" {
		return
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.members == nil {
		s.members = make(map[string]memberMembershipState)
	}
	s.members[ws+":"+uid] = memberMembershipState{
		role:   strings.TrimSpace(role),
		active: active,
	}
}

func (s *MemoryStore) RevokeMemberAccess(workspaceID, userID string) {
	s.SetMemberRole(workspaceID, userID, "", false)
}

func (s *MemoryStore) ResolveWorkspaceMemberRole(ctx context.Context, workspaceID, userID string) (string, bool, bool, error) {
	ws := strings.TrimSpace(workspaceID)
	uid := strings.TrimSpace(userID)
	if ws == "" || uid == "" {
		return "", false, false, nil
	}
	s.mu.RLock()
	defer s.mu.RUnlock()
	st, ok := s.members[ws+":"+uid]
	if !ok {
		return "", false, false, nil
	}
	return st.role, st.active, true, nil
}

func (s *MemoryStore) CreateWorkflow(ctx context.Context, w *Workflow) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	key := fmt.Sprintf("%s:%s", w.WorkspaceID, w.WorkflowID)
	if _, exists := s.workflows[key]; exists {
		return fmt.Errorf("workflow already exists")
	}
	clone := *w
	s.workflows[key] = &clone
	return nil
}

func (s *MemoryStore) GetWorkflow(ctx context.Context, workspaceID, workflowID string) (*Workflow, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	key := fmt.Sprintf("%s:%s", workspaceID, workflowID)
	w, ok := s.workflows[key]
	if !ok || w.DeletedAt != nil {
		return nil, ErrWorkflowNotFound
	}
	clone := *w
	return &clone, nil
}

func (s *MemoryStore) ListWorkflows(ctx context.Context, workspaceID string, status string, limit, offset int) ([]Workflow, int, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matched []Workflow
	for _, w := range s.workflows {
		if w.WorkspaceID == workspaceID && w.DeletedAt == nil {
			if status == "" || string(w.Status) == status {
				matched = append(matched, *w)
			}
		}
	}
	total := len(matched)
	if offset >= total {
		return []Workflow{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > total {
		end = total
	}
	return matched[offset:end], total, nil
}

func (s *MemoryStore) UpdateWorkflow(ctx context.Context, w *Workflow) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	key := fmt.Sprintf("%s:%s", w.WorkspaceID, w.WorkflowID)
	existing, ok := s.workflows[key]
	if !ok || existing.DeletedAt != nil {
		return ErrWorkflowNotFound
	}
	clone := *w
	s.workflows[key] = &clone
	return nil
}

func (s *MemoryStore) DeleteWorkflow(ctx context.Context, workspaceID, workflowID string) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	key := fmt.Sprintf("%s:%s", workspaceID, workflowID)
	w, ok := s.workflows[key]
	if !ok || w.DeletedAt != nil {
		return ErrWorkflowNotFound
	}
	now := time.Now().UTC()
	w.DeletedAt = &now
	return nil
}

func (s *MemoryStore) CreateWorkflowRun(ctx context.Context, run *WorkflowRun) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	key := fmt.Sprintf("%s:%s", run.WorkspaceID, run.RunID)
	clone := *run
	s.runs[key] = &clone
	return nil
}

func (s *MemoryStore) GetWorkflowRun(ctx context.Context, workspaceID, runID string) (*WorkflowRun, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	key := fmt.Sprintf("%s:%s", workspaceID, runID)
	r, ok := s.runs[key]
	if !ok || r.DeletedAt != nil {
		return nil, ErrWorkflowRunNotFound
	}
	clone := *r
	return &clone, nil
}

func (s *MemoryStore) ListWorkflowRuns(ctx context.Context, workspaceID, workflowID, status string, limit, offset int) ([]WorkflowRun, int, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matched []WorkflowRun
	for _, r := range s.runs {
		if r.WorkspaceID == workspaceID && r.DeletedAt == nil {
			if workflowID != "" && r.WorkflowID != workflowID {
				continue
			}
			if status != "" && string(r.Status) != status {
				continue
			}
			matched = append(matched, *r)
		}
	}
	total := len(matched)
	if offset >= total {
		return []WorkflowRun{}, total, nil
	}
	end := offset + limit
	if limit <= 0 || end > total {
		end = total
	}
	return matched[offset:end], total, nil
}

func (s *MemoryStore) UpdateWorkflowRun(ctx context.Context, run *WorkflowRun) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	key := fmt.Sprintf("%s:%s", run.WorkspaceID, run.RunID)
	existing, ok := s.runs[key]
	if !ok || existing.DeletedAt != nil {
		return ErrWorkflowRunNotFound
	}
	clone := *run
	s.runs[key] = &clone
	return nil
}

func (s *MemoryStore) CreateWorkflowRunStep(ctx context.Context, step *WorkflowRunStep) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	key := fmt.Sprintf("%s:%s", step.WorkspaceID, step.StepID)
	clone := *step
	s.steps[key] = &clone
	return nil
}

func (s *MemoryStore) ListWorkflowRunSteps(ctx context.Context, workspaceID, runID string) ([]WorkflowRunStep, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matched []WorkflowRunStep
	for _, st := range s.steps {
		if st.WorkspaceID == workspaceID && st.RunID == runID && st.DeletedAt == nil {
			matched = append(matched, *st)
		}
	}
	return matched, nil
}

func (s *MemoryStore) UpdateWorkflowRunStep(ctx context.Context, step *WorkflowRunStep) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	key := fmt.Sprintf("%s:%s", step.WorkspaceID, step.StepID)
	clone := *step
	s.steps[key] = &clone
	return nil
}

// ----------------------------------------------------------------------------
// Approvals & DLQ in MemoryStore
// ----------------------------------------------------------------------------

func (s *MemoryStore) CreateApprovalRequest(ctx context.Context, req *ApprovalRequest) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	key := fmt.Sprintf("%s:%s", req.WorkspaceID, req.RequestID)
	clone := *req
	s.approvals[key] = &clone
	return nil
}

func (s *MemoryStore) GetApprovalRequest(ctx context.Context, workspaceID, requestID string) (*ApprovalRequest, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	key := fmt.Sprintf("%s:%s", workspaceID, requestID)
	req, ok := s.approvals[key]
	if !ok {
		return nil, ErrApprovalNotFound
	}
	clone := *req
	return &clone, nil
}

func (s *MemoryStore) ListApprovalRequests(ctx context.Context, workspaceID string, filter ApprovalFilter) ([]ApprovalRequest, int, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matched []ApprovalRequest
	for _, req := range s.approvals {
		if req.WorkspaceID != workspaceID {
			continue
		}
		if filter.Status != "" && req.Status != filter.Status {
			continue
		}
		if filter.WorkflowID != "" && req.WorkflowID != filter.WorkflowID {
			continue
		}
		if filter.RunID != "" && req.ObjectID != filter.RunID {
			continue
		}
		matched = append(matched, *req)
	}

	total := len(matched)
	if filter.Offset > 0 {
		if filter.Offset >= total {
			return []ApprovalRequest{}, total, nil
		}
		matched = matched[filter.Offset:]
	}
	if filter.Limit > 0 && len(matched) > filter.Limit {
		matched = matched[:filter.Limit]
	}
	return matched, total, nil
}

func (s *MemoryStore) UpdateApprovalRequest(ctx context.Context, req *ApprovalRequest) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	key := fmt.Sprintf("%s:%s", req.WorkspaceID, req.RequestID)
	clone := *req
	s.approvals[key] = &clone
	return nil
}

func (s *MemoryStore) FindPendingApprovalsByWorkflow(ctx context.Context, workspaceID, workflowID string) ([]ApprovalRequest, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []ApprovalRequest
	for _, req := range s.approvals {
		if req.WorkspaceID == workspaceID && req.WorkflowID == workflowID && req.Status == "pending_approval" {
			result = append(result, *req)
		}
	}
	return result, nil
}

func (s *MemoryStore) FindPendingApprovalsByRun(ctx context.Context, workspaceID, runID string) ([]ApprovalRequest, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []ApprovalRequest
	for _, req := range s.approvals {
		if req.WorkspaceID == workspaceID && req.ObjectID == runID && req.Status == "pending_approval" {
			result = append(result, *req)
		}
	}
	return result, nil
}

func (s *MemoryStore) CreateDLQItem(ctx context.Context, item *DLQItem) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	key := fmt.Sprintf("%s:%s", item.WorkspaceID, item.DLQID)
	clone := *item
	s.dlqItems[key] = &clone
	return nil
}

func (s *MemoryStore) GetDLQItem(ctx context.Context, workspaceID, dlqID string) (*DLQItem, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	key := fmt.Sprintf("%s:%s", workspaceID, dlqID)
	item, ok := s.dlqItems[key]
	if !ok {
		return nil, ErrDLQNotFound
	}
	clone := *item
	return &clone, nil
}

func (s *MemoryStore) ListDLQItems(ctx context.Context, workspaceID string, status string, limit, offset int) ([]DLQItem, int, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var matched []DLQItem
	for _, item := range s.dlqItems {
		if item.WorkspaceID != workspaceID {
			continue
		}
		if status != "" && item.Status != status {
			continue
		}
		matched = append(matched, *item)
	}

	total := len(matched)
	if offset > 0 {
		if offset >= total {
			return []DLQItem{}, total, nil
		}
		matched = matched[offset:]
	}
	if limit > 0 && len(matched) > limit {
		matched = matched[:limit]
	}
	return matched, total, nil
}

func (s *MemoryStore) UpdateDLQItem(ctx context.Context, item *DLQItem) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	key := fmt.Sprintf("%s:%s", item.WorkspaceID, item.DLQID)
	clone := *item
	s.dlqItems[key] = &clone
	return nil
}

// ----------------------------------------------------------------------------
// PostgresStore (PostgreSQL persistence using tenantdb and RLS)
// ----------------------------------------------------------------------------

const defaultSystemActorUUID = "00000000-0000-4000-8000-000000000001"

type storeActorUserIDKey struct{}

// WithStoreActorUserID attaches a caller UserID hint to ctx for PostgresStore tenantdb.WithTx transactions.
func WithStoreActorUserID(ctx context.Context, userID string) context.Context {
	if ctx == nil || userID == "" {
		return ctx
	}
	return context.WithValue(ctx, storeActorUserIDKey{}, userID)
}

func resolveStoreActorUserID(ctx context.Context, fallbackUserID string) string {
	if sc, ok := tenantdb.ScopeFromContext(ctx); ok && tenantdb.IsValidNonZeroUUID(sc.UserID) {
		return sc.UserID
	}
	if session, ok := transportauth.PrincipalFromContext(ctx); ok && tenantdb.IsValidNonZeroUUID(session.UserID) {
		return session.UserID
	}
	if ctx != nil {
		if uid, ok := ctx.Value(storeActorUserIDKey{}).(string); ok && tenantdb.IsValidNonZeroUUID(uid) {
			return uid
		}
	}
	if tenantdb.IsValidNonZeroUUID(fallbackUserID) {
		return fallbackUserID
	}
	return defaultSystemActorUUID
}

type txCaptureBeginner struct {
	inner tenantdb.TxBeginner
	tx    pgx.Tx
}

func (b *txCaptureBeginner) Begin(ctx context.Context) (pgx.Tx, error) {
	tx, err := b.inner.Begin(ctx)
	if err != nil {
		return nil, err
	}
	b.tx = tx
	return tx, nil
}

type PostgresStore struct {
	pool     *pgxpool.Pool
	beginner tenantdb.TxBeginner
}

func NewPostgresStore(pool *pgxpool.Pool) *PostgresStore {
	var beginner tenantdb.TxBeginner
	if pool != nil {
		beginner = pool
	}
	return &PostgresStore{pool: pool, beginner: beginner}
}

func NewPostgresStoreWithBeginner(beginner tenantdb.TxBeginner) *PostgresStore {
	return &PostgresStore{beginner: beginner}
}

func (p *PostgresStore) withTenantTx(ctx context.Context, workspaceID, actorHint string, fn func(txCtx context.Context, tx pgx.Tx) error) error {
	if p == nil || p.beginner == nil {
		return tenantdb.ErrNilBeginner
	}
	cap := &txCaptureBeginner{inner: p.beginner}
	scope := tenantdb.Scope{
		WorkspaceID: workspaceID,
		UserID:      resolveStoreActorUserID(ctx, actorHint),
	}
	return tenantdb.WithTx(ctx, cap, scope, func(txCtx context.Context, _ *tenantdb.Queries) error {
		return fn(txCtx, cap.tx)
	})
}

var _ Store = (*PostgresStore)(nil)
var _ WorkspaceMembershipStore = (*PostgresStore)(nil)

func (p *PostgresStore) ResolveWorkspaceMemberRole(ctx context.Context, workspaceID, userID string) (string, bool, bool, error) {
	ws := strings.TrimSpace(workspaceID)
	uid := strings.TrimSpace(userID)
	if ws == "" || uid == "" {
		return "", false, true, nil
	}
	var role, status string
	err := p.withTenantTx(ctx, ws, uid, func(txCtx context.Context, tx pgx.Tx) error {
		return tx.QueryRow(txCtx, `
			SELECT COALESCE(role, ''), COALESCE(status, '')
			FROM workspace_members
			WHERE workspace_id = $1 AND user_id = $2
		`, ws, uid).Scan(&role, &status)
	})
	if err != nil {
		if err == pgx.ErrNoRows {
			return "", false, true, nil
		}
		return "", false, true, err
	}
	active := strings.EqualFold(strings.TrimSpace(status), "active")
	return strings.TrimSpace(role), active, true, nil
}

func (p *PostgresStore) CreateWorkflow(ctx context.Context, w *Workflow) error {
	triggerJSON, err := json.Marshal(w.TriggerConfig)
	if err != nil {
		return err
	}
	actionJSON, err := json.Marshal(w.ActionChain)
	if err != nil {
		return err
	}
	approvalsJSON, err := json.Marshal(w.ApprovalRequirements)
	if err != nil {
		return err
	}

	query := `
		INSERT INTO workflows (
			workflow_id, workspace_id, title, workflow_type,
			trigger_config, action_chain, approval_requirements,
			status, version, activepieces_flow_id, tier_limit_check,
			run_count, created_by, created_at, updated_at
		) VALUES (
			$1, $2, $3, $4,
			$5, $6, $7,
			$8, $9, $10, $11,
			$12, NULLIF($13, '')::uuid, $14, $15
		)
	`
	return p.withTenantTx(ctx, w.WorkspaceID, w.CreatedBy, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			w.WorkflowID, w.WorkspaceID, w.Title, w.WorkflowType,
			triggerJSON, actionJSON, approvalsJSON,
			w.Status, w.Version, w.ActivepiecesFlowID, w.TierLimitCheck,
			w.RunCount, w.CreatedBy, w.CreatedAt, w.UpdatedAt,
		)
		return err
	})
}

func (p *PostgresStore) GetWorkflow(ctx context.Context, workspaceID, workflowID string) (*Workflow, error) {
	query := `
		SELECT
			workflow_id, workspace_id, title, workflow_type,
			trigger_config, action_chain, approval_requirements,
			status, version, COALESCE(activepieces_flow_id, ''),
			tier_limit_check, run_count, COALESCE(created_by::text, ''),
			created_at, updated_at, deleted_at
		FROM workflows
		WHERE workspace_id = $1 AND workflow_id = $2 AND deleted_at IS NULL
	`
	var w Workflow
	err := p.withTenantTx(ctx, workspaceID, "", func(txCtx context.Context, tx pgx.Tx) error {
		row := tx.QueryRow(txCtx, query, workspaceID, workflowID)
		var triggerRaw, actionRaw, approvalsRaw []byte
		var deletedAt *time.Time

		err := row.Scan(
			&w.WorkflowID, &w.WorkspaceID, &w.Title, &w.WorkflowType,
			&triggerRaw, &actionRaw, &approvalsRaw,
			&w.Status, &w.Version, &w.ActivepiecesFlowID,
			&w.TierLimitCheck, &w.RunCount, &w.CreatedBy,
			&w.CreatedAt, &w.UpdatedAt, &deletedAt,
		)
		if err != nil {
			if err == pgx.ErrNoRows {
				return ErrWorkflowNotFound
			}
			return err
		}
		w.DeletedAt = deletedAt
		_ = json.Unmarshal(triggerRaw, &w.TriggerConfig)
		_ = json.Unmarshal(actionRaw, &w.ActionChain)
		_ = json.Unmarshal(approvalsRaw, &w.ApprovalRequirements)
		return nil
	})
	if err != nil {
		return nil, err
	}
	return &w, nil
}

func (p *PostgresStore) ListWorkflows(ctx context.Context, workspaceID string, status string, limit, offset int) ([]Workflow, int, error) {
	var result []Workflow
	var total int
	err := p.withTenantTx(ctx, workspaceID, "", func(txCtx context.Context, tx pgx.Tx) error {
		countQuery := `SELECT COUNT(*) FROM workflows WHERE workspace_id = $1 AND deleted_at IS NULL`
		args := []any{workspaceID}
		if status != "" {
			countQuery += ` AND status = $2`
			args = append(args, status)
		}
		if err := tx.QueryRow(txCtx, countQuery, args...).Scan(&total); err != nil {
			return err
		}

		query := `
			SELECT
				workflow_id, workspace_id, title, workflow_type,
				trigger_config, action_chain, approval_requirements,
				status, version, COALESCE(activepieces_flow_id, ''),
				tier_limit_check, run_count, COALESCE(created_by::text, ''),
				created_at, updated_at
			FROM workflows
			WHERE workspace_id = $1 AND deleted_at IS NULL
		`
		queryArgs := []any{workspaceID}
		if status != "" {
			query += ` AND status = $2`
			queryArgs = append(queryArgs, status)
		}
		query += ` ORDER BY created_at DESC`
		if limit > 0 {
			query += fmt.Sprintf(` LIMIT %d OFFSET %d`, limit, offset)
		}

		rows, err := tx.Query(txCtx, query, queryArgs...)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			var w Workflow
			var triggerRaw, actionRaw, approvalsRaw []byte
			if err := rows.Scan(
				&w.WorkflowID, &w.WorkspaceID, &w.Title, &w.WorkflowType,
				&triggerRaw, &actionRaw, &approvalsRaw,
				&w.Status, &w.Version, &w.ActivepiecesFlowID,
				&w.TierLimitCheck, &w.RunCount, &w.CreatedBy,
				&w.CreatedAt, &w.UpdatedAt,
			); err != nil {
				return err
			}
			_ = json.Unmarshal(triggerRaw, &w.TriggerConfig)
			_ = json.Unmarshal(actionRaw, &w.ActionChain)
			_ = json.Unmarshal(approvalsRaw, &w.ApprovalRequirements)
			result = append(result, w)
		}
		return rows.Err()
	})
	return result, total, err
}

func (p *PostgresStore) UpdateWorkflow(ctx context.Context, w *Workflow) error {
	triggerJSON, err := json.Marshal(w.TriggerConfig)
	if err != nil {
		return err
	}
	actionJSON, err := json.Marshal(w.ActionChain)
	if err != nil {
		return err
	}
	approvalsJSON, err := json.Marshal(w.ApprovalRequirements)
	if err != nil {
		return err
	}

	query := `
		UPDATE workflows SET
			title = $1,
			trigger_config = $2,
			action_chain = $3,
			approval_requirements = $4,
			status = $5,
			version = $6,
			activepieces_flow_id = $7,
			tier_limit_check = $8,
			run_count = $9,
			updated_at = $10
		WHERE workspace_id = $11 AND workflow_id = $12 AND deleted_at IS NULL
	`
	return p.withTenantTx(ctx, w.WorkspaceID, w.CreatedBy, func(txCtx context.Context, tx pgx.Tx) error {
		cmd, err := tx.Exec(txCtx, query,
			w.Title, triggerJSON, actionJSON, approvalsJSON,
			w.Status, w.Version, w.ActivepiecesFlowID, w.TierLimitCheck,
			w.RunCount, w.UpdatedAt, w.WorkspaceID, w.WorkflowID,
		)
		if err != nil {
			return err
		}
		if cmd.RowsAffected() == 0 {
			return ErrWorkflowNotFound
		}
		return nil
	})
}

func (p *PostgresStore) DeleteWorkflow(ctx context.Context, workspaceID, workflowID string) error {
	query := `
		UPDATE workflows SET
			deleted_at = NOW(),
			status = 'archived'
		WHERE workspace_id = $1 AND workflow_id = $2 AND deleted_at IS NULL
	`
	return p.withTenantTx(ctx, workspaceID, "", func(txCtx context.Context, tx pgx.Tx) error {
		cmd, err := tx.Exec(txCtx, query, workspaceID, workflowID)
		if err != nil {
			return err
		}
		if cmd.RowsAffected() == 0 {
			return ErrWorkflowNotFound
		}
		return nil
	})
}

func (p *PostgresStore) CreateWorkflowRun(ctx context.Context, run *WorkflowRun) error {
	triggerJSON, _ := json.Marshal(run.TriggerEvent)
	resultJSON, _ := json.Marshal(run.ResultSummary)
	logJSON, _ := json.Marshal(run.ExecutionLog)
	affectedJSON, _ := json.Marshal(run.AffectedObjectRefs)
	sideEffectsJSON, _ := json.Marshal(run.SideEffectsSummary)

	query := `
		INSERT INTO workflow_runs (
			run_id, workspace_id, workflow_id, trigger_event,
			status, current_node, result_summary, execution_log,
			affected_object_refs, side_effects_summary, activepieces_run_id,
			started_at, completed_at, created_at, updated_at
		) VALUES (
			$1, $2, $3, $4,
			$5, $6, $7, $8,
			$9, $10, $11,
			$12, $13, $14, $15
		)
	`
	return p.withTenantTx(ctx, run.WorkspaceID, run.InitiatedByUserID, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			run.RunID, run.WorkspaceID, run.WorkflowID, triggerJSON,
			run.Status, run.CurrentNode, resultJSON, logJSON,
			affectedJSON, sideEffectsJSON, run.ActivepiecesRunID,
			run.StartedAt, run.CompletedAt, run.CreatedAt, run.UpdatedAt,
		)
		return err
	})
}

func (p *PostgresStore) GetWorkflowRun(ctx context.Context, workspaceID, runID string) (*WorkflowRun, error) {
	query := `
		SELECT
			run_id, workspace_id, workflow_id, trigger_event,
			status, COALESCE(current_node, ''), result_summary, execution_log,
			affected_object_refs, side_effects_summary, COALESCE(activepieces_run_id, ''),
			started_at, completed_at, created_at, updated_at, deleted_at
		FROM workflow_runs
		WHERE workspace_id = $1 AND run_id = $2 AND deleted_at IS NULL
	`
	var r WorkflowRun
	err := p.withTenantTx(ctx, workspaceID, "", func(txCtx context.Context, tx pgx.Tx) error {
		row := tx.QueryRow(txCtx, query, workspaceID, runID)
		var trigRaw, resRaw, logRaw, affRaw, sideRaw []byte
		var deletedAt *time.Time

		err := row.Scan(
			&r.RunID, &r.WorkspaceID, &r.WorkflowID, &trigRaw,
			&r.Status, &r.CurrentNode, &resRaw, &logRaw,
			&affRaw, &sideRaw, &r.ActivepiecesRunID,
			&r.StartedAt, &r.CompletedAt, &r.CreatedAt, &r.UpdatedAt, &deletedAt,
		)
		if err != nil {
			if err == pgx.ErrNoRows {
				return ErrWorkflowRunNotFound
			}
			return err
		}
		r.DeletedAt = deletedAt
		_ = json.Unmarshal(trigRaw, &r.TriggerEvent)
		_ = json.Unmarshal(resRaw, &r.ResultSummary)
		_ = json.Unmarshal(logRaw, &r.ExecutionLog)
		_ = json.Unmarshal(affRaw, &r.AffectedObjectRefs)
		_ = json.Unmarshal(sideRaw, &r.SideEffectsSummary)
		if r.TriggerEvent != nil {
			if uid, ok := r.TriggerEvent["_actor_user_id"].(string); ok {
				r.InitiatedByUserID = uid
			}
			if role, ok := r.TriggerEvent["_actor_role"].(string); ok {
				r.InitiatedByRole = role
			}
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return &r, nil
}

func (p *PostgresStore) ListWorkflowRuns(ctx context.Context, workspaceID, workflowID, status string, limit, offset int) ([]WorkflowRun, int, error) {
	var result []WorkflowRun
	var total int
	err := p.withTenantTx(ctx, workspaceID, "", func(txCtx context.Context, tx pgx.Tx) error {
		countQuery := `SELECT COUNT(*) FROM workflow_runs WHERE workspace_id = $1 AND deleted_at IS NULL`
		queryArgs := []any{workspaceID}
		idx := 2
		if workflowID != "" {
			countQuery += fmt.Sprintf(` AND workflow_id = $%d`, idx)
			queryArgs = append(queryArgs, workflowID)
			idx++
		}
		if status != "" {
			countQuery += fmt.Sprintf(` AND status = $%d`, idx)
			queryArgs = append(queryArgs, status)
			idx++
		}
		if err := tx.QueryRow(txCtx, countQuery, queryArgs...).Scan(&total); err != nil {
			return err
		}

		query := `
			SELECT
				run_id, workspace_id, workflow_id, trigger_event,
				status, COALESCE(current_node, ''), result_summary, execution_log,
				affected_object_refs, side_effects_summary, COALESCE(activepieces_run_id, ''),
				started_at, completed_at, created_at, updated_at
			FROM workflow_runs
			WHERE workspace_id = $1 AND deleted_at IS NULL
		`
		selectArgs := []any{workspaceID}
		sIdx := 2
		if workflowID != "" {
			query += fmt.Sprintf(` AND workflow_id = $%d`, sIdx)
			selectArgs = append(selectArgs, workflowID)
			sIdx++
		}
		if status != "" {
			query += fmt.Sprintf(` AND status = $%d`, sIdx)
			selectArgs = append(selectArgs, status)
			sIdx++
		}
		query += ` ORDER BY created_at DESC`
		if limit > 0 {
			query += fmt.Sprintf(` LIMIT %d OFFSET %d`, limit, offset)
		}

		rows, err := tx.Query(txCtx, query, selectArgs...)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			var r WorkflowRun
			var trigRaw, resRaw, logRaw, affRaw, sideRaw []byte
			if err := rows.Scan(
				&r.RunID, &r.WorkspaceID, &r.WorkflowID, &trigRaw,
				&r.Status, &r.CurrentNode, &resRaw, &logRaw,
				&affRaw, &sideRaw, &r.ActivepiecesRunID,
				&r.StartedAt, &r.CompletedAt, &r.CreatedAt, &r.UpdatedAt,
			); err != nil {
				return err
			}
			_ = json.Unmarshal(trigRaw, &r.TriggerEvent)
			_ = json.Unmarshal(resRaw, &r.ResultSummary)
			_ = json.Unmarshal(logRaw, &r.ExecutionLog)
			_ = json.Unmarshal(affRaw, &r.AffectedObjectRefs)
			_ = json.Unmarshal(sideRaw, &r.SideEffectsSummary)
			if r.TriggerEvent != nil {
				if uid, ok := r.TriggerEvent["_actor_user_id"].(string); ok {
					r.InitiatedByUserID = uid
				}
				if role, ok := r.TriggerEvent["_actor_role"].(string); ok {
					r.InitiatedByRole = role
				}
			}
			result = append(result, r)
		}
		return rows.Err()
	})
	return result, total, err
}

func (p *PostgresStore) UpdateWorkflowRun(ctx context.Context, run *WorkflowRun) error {
	resultJSON, _ := json.Marshal(run.ResultSummary)
	logJSON, _ := json.Marshal(run.ExecutionLog)
	affJSON, _ := json.Marshal(run.AffectedObjectRefs)
	sideJSON, _ := json.Marshal(run.SideEffectsSummary)

	query := `
		UPDATE workflow_runs SET
			status = $1,
			current_node = $2,
			result_summary = $3,
			execution_log = $4,
			affected_object_refs = $5,
			side_effects_summary = $6,
			started_at = $7,
			completed_at = $8,
			updated_at = $9
		WHERE workspace_id = $10 AND run_id = $11 AND deleted_at IS NULL
	`
	return p.withTenantTx(ctx, run.WorkspaceID, run.InitiatedByUserID, func(txCtx context.Context, tx pgx.Tx) error {
		cmd, err := tx.Exec(txCtx, query,
			run.Status, run.CurrentNode, resultJSON, logJSON,
			affJSON, sideJSON, run.StartedAt, run.CompletedAt, run.UpdatedAt,
			run.WorkspaceID, run.RunID,
		)
		if err != nil {
			return err
		}
		if cmd.RowsAffected() == 0 {
			return ErrWorkflowRunNotFound
		}
		return nil
	})
}

func (p *PostgresStore) CreateWorkflowRunStep(ctx context.Context, step *WorkflowRunStep) error {
	sideEffectsJSON, _ := json.Marshal(step.SideEffectRefs)
	query := `
		INSERT INTO workflow_run_steps (
			step_id, workspace_id, run_id, node_id, node_type,
			step_order, status, input_snapshot, output_snapshot,
			diagnostics_ref, side_effect_refs, started_at, completed_at,
			created_at, updated_at
		) VALUES (
			$1, $2, $3, $4, $5,
			$6, $7, $8::jsonb, $9::jsonb,
			NULLIF($10, '')::uuid, $11, $12, $13,
			$14, $15
		)
	`
	return p.withTenantTx(ctx, step.WorkspaceID, "", func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			step.StepID, step.WorkspaceID, step.RunID, step.NodeID, step.NodeType,
			step.StepOrder, step.Status, step.InputSnapshot, step.OutputSnapshot,
			step.DiagnosticsRef, sideEffectsJSON, step.StartedAt, step.CompletedAt,
			step.CreatedAt, step.UpdatedAt,
		)
		return err
	})
}

func (p *PostgresStore) ListWorkflowRunSteps(ctx context.Context, workspaceID, runID string) ([]WorkflowRunStep, error) {
	query := `
		SELECT
			step_id, workspace_id, run_id, node_id, node_type,
			step_order, status, input_snapshot::text, output_snapshot::text,
			COALESCE(diagnostics_ref::text, ''), side_effect_refs,
			started_at, completed_at, created_at, updated_at
		FROM workflow_run_steps
		WHERE workspace_id = $1 AND run_id = $2 AND deleted_at IS NULL
		ORDER BY step_order ASC
	`
	var result []WorkflowRunStep
	err := p.withTenantTx(ctx, workspaceID, "", func(txCtx context.Context, tx pgx.Tx) error {
		rows, err := tx.Query(txCtx, query, workspaceID, runID)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			var s WorkflowRunStep
			var sideEffectsRaw []byte
			if err := rows.Scan(
				&s.StepID, &s.WorkspaceID, &s.RunID, &s.NodeID, &s.NodeType,
				&s.StepOrder, &s.Status, &s.InputSnapshot, &s.OutputSnapshot,
				&s.DiagnosticsRef, &sideEffectsRaw,
				&s.StartedAt, &s.CompletedAt, &s.CreatedAt, &s.UpdatedAt,
			); err != nil {
				return err
			}
			_ = json.Unmarshal(sideEffectsRaw, &s.SideEffectRefs)
			result = append(result, s)
		}
		return rows.Err()
	})
	return result, err
}

func (p *PostgresStore) UpdateWorkflowRunStep(ctx context.Context, step *WorkflowRunStep) error {
	sideEffectsJSON, _ := json.Marshal(step.SideEffectRefs)
	query := `
		UPDATE workflow_run_steps SET
			status = $1,
			output_snapshot = $2::jsonb,
			diagnostics_ref = NULLIF($3, '')::uuid,
			side_effect_refs = $4,
			started_at = $5,
			completed_at = $6,
			updated_at = $7
		WHERE workspace_id = $8 AND step_id = $9 AND deleted_at IS NULL
	`
	return p.withTenantTx(ctx, step.WorkspaceID, "", func(txCtx context.Context, tx pgx.Tx) error {
		cmd, err := tx.Exec(txCtx, query,
			step.Status, step.OutputSnapshot, step.DiagnosticsRef, sideEffectsJSON,
			step.StartedAt, step.CompletedAt, step.UpdatedAt,
			step.WorkspaceID, step.StepID,
		)
		if err != nil {
			return err
		}
		if cmd.RowsAffected() == 0 {
			return fmt.Errorf("step not found")
		}
		return nil
	})
}

// ----------------------------------------------------------------------------
// Approvals in PostgresStore (§18.1)
// ----------------------------------------------------------------------------

func (p *PostgresStore) CreateApprovalRequest(ctx context.Context, req *ApprovalRequest) error {
	query := `
		INSERT INTO approval_requests (
			request_id, workspace_id, request_type, object_type, object_id,
			requested_by, approved_by, status, reason, rejection_reason,
			expires_at, created_at, updated_at
		) VALUES (
			$1, $2, $3, $4, $5,
			NULLIF($6, '')::uuid, NULLIF($7, '')::uuid, $8, $9, $10,
			$11, $12, $13
		)
	`
	return p.withTenantTx(ctx, req.WorkspaceID, req.RequestedBy, func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			req.RequestID, req.WorkspaceID, req.RequestType, req.ObjectType, req.ObjectID,
			req.RequestedBy, req.ApprovedBy, req.Status, req.Reason, req.RejectionReason,
			req.ExpiresAt, req.CreatedAt, req.UpdatedAt,
		)
		return err
	})
}

func (p *PostgresStore) GetApprovalRequest(ctx context.Context, workspaceID, requestID string) (*ApprovalRequest, error) {
	query := `
		SELECT
			request_id, workspace_id, request_type, object_type, object_id,
			COALESCE(requested_by::text, ''), COALESCE(approved_by::text, ''),
			status, COALESCE(reason, ''), COALESCE(rejection_reason, ''),
			expires_at, created_at, updated_at
		FROM approval_requests
		WHERE workspace_id = $1 AND request_id = $2
	`
	var req ApprovalRequest
	err := p.withTenantTx(ctx, workspaceID, "", func(txCtx context.Context, tx pgx.Tx) error {
		if err := tx.QueryRow(txCtx, query, workspaceID, requestID).Scan(
			&req.RequestID, &req.WorkspaceID, &req.RequestType, &req.ObjectType, &req.ObjectID,
			&req.RequestedBy, &req.ApprovedBy, &req.Status, &req.Reason, &req.RejectionReason,
			&req.ExpiresAt, &req.CreatedAt, &req.UpdatedAt,
		); err != nil {
			if err == pgx.ErrNoRows {
				return ErrApprovalNotFound
			}
			return err
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	hydrateApprovalMetadata(&req)
	return &req, nil
}

func (p *PostgresStore) ListApprovalRequests(ctx context.Context, workspaceID string, filter ApprovalFilter) ([]ApprovalRequest, int, error) {
	var result []ApprovalRequest
	var total int
	err := p.withTenantTx(ctx, workspaceID, "", func(txCtx context.Context, tx pgx.Tx) error {
		countQuery := `SELECT COUNT(*) FROM approval_requests WHERE workspace_id = $1`
		args := []any{workspaceID}
		if filter.Status != "" {
			countQuery += ` AND status = $2`
			args = append(args, filter.Status)
		}
		if filter.RunID != "" {
			countQuery += fmt.Sprintf(` AND object_id = $%d`, len(args)+1)
			args = append(args, filter.RunID)
		}

		if err := tx.QueryRow(txCtx, countQuery, args...).Scan(&total); err != nil {
			return err
		}

		query := `
			SELECT
				request_id, workspace_id, request_type, object_type, object_id,
				COALESCE(requested_by::text, ''), COALESCE(approved_by::text, ''),
				status, COALESCE(reason, ''), COALESCE(rejection_reason, ''),
				expires_at, created_at, updated_at
			FROM approval_requests
			WHERE workspace_id = $1
		`
		queryArgs := []any{workspaceID}
		if filter.Status != "" {
			query += ` AND status = $2`
			queryArgs = append(queryArgs, filter.Status)
		}
		if filter.RunID != "" {
			query += fmt.Sprintf(` AND object_id = $%d`, len(queryArgs)+1)
			queryArgs = append(queryArgs, filter.RunID)
		}
		query += ` ORDER BY created_at DESC`
		if filter.Limit > 0 {
			query += fmt.Sprintf(` LIMIT %d OFFSET %d`, filter.Limit, filter.Offset)
		}

		rows, err := tx.Query(txCtx, query, queryArgs...)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			var req ApprovalRequest
			if err := rows.Scan(
				&req.RequestID, &req.WorkspaceID, &req.RequestType, &req.ObjectType, &req.ObjectID,
				&req.RequestedBy, &req.ApprovedBy, &req.Status, &req.Reason, &req.RejectionReason,
				&req.ExpiresAt, &req.CreatedAt, &req.UpdatedAt,
			); err != nil {
				return err
			}
			hydrateApprovalMetadata(&req)
			result = append(result, req)
		}
		return rows.Err()
	})
	return result, total, err
}

func (p *PostgresStore) UpdateApprovalRequest(ctx context.Context, req *ApprovalRequest) error {
	query := `
		UPDATE approval_requests SET
			status = $1,
			approved_by = NULLIF($2, '')::uuid,
			rejection_reason = $3,
			reason = $4,
			updated_at = $5
		WHERE workspace_id = $6 AND request_id = $7
	`
	return p.withTenantTx(ctx, req.WorkspaceID, req.ApprovedBy, func(txCtx context.Context, tx pgx.Tx) error {
		cmd, err := tx.Exec(txCtx, query,
			req.Status, req.ApprovedBy, req.RejectionReason, req.Reason,
			req.UpdatedAt, req.WorkspaceID, req.RequestID,
		)
		if err != nil {
			return err
		}
		if cmd.RowsAffected() == 0 {
			return ErrApprovalNotFound
		}
		return nil
	})
}

func (p *PostgresStore) FindPendingApprovalsByWorkflow(ctx context.Context, workspaceID, workflowID string) ([]ApprovalRequest, error) {
	// Query pending approval requests matching workspace
	filter := ApprovalFilter{Status: "pending_approval", Limit: 1000}
	allPending, _, err := p.ListApprovalRequests(ctx, workspaceID, filter)
	if err != nil {
		return nil, err
	}
	var matched []ApprovalRequest
	for _, req := range allPending {
		if req.WorkflowID == workflowID {
			matched = append(matched, req)
		}
	}
	return matched, nil
}

func (p *PostgresStore) FindPendingApprovalsByRun(ctx context.Context, workspaceID, runID string) ([]ApprovalRequest, error) {
	filter := ApprovalFilter{Status: "pending_approval", RunID: runID, Limit: 100}
	res, _, err := p.ListApprovalRequests(ctx, workspaceID, filter)
	return res, err
}

// ----------------------------------------------------------------------------
// Dead-Letter Queue in PostgresStore (§18.4G)
// ----------------------------------------------------------------------------

func (p *PostgresStore) CreateDLQItem(ctx context.Context, item *DLQItem) error {
	payloadJSON, _ := json.Marshal(item.Payload)
	historyJSON, _ := json.Marshal(item.RetryHistory)

	query := `
		INSERT INTO dead_letter_queue (
			dlq_id, queue_name, original_message_id, payload,
			error_class, error_message, last_error_at, attempt_count,
			retry_history, workspace_id, status, resolution_notes,
			created_at
		) VALUES (
			$1, $2, $3, $4::jsonb,
			$5, $6, $7, $8,
			$9::jsonb, $10, $11, $12,
			$13
		)
	`
	return p.withTenantTx(ctx, item.WorkspaceID, "", func(txCtx context.Context, tx pgx.Tx) error {
		_, err := tx.Exec(txCtx, query,
			item.DLQID, item.QueueName, item.OriginalMessageID, payloadJSON,
			item.ErrorClass, item.ErrorMessage, item.LastErrorAt, item.AttemptCount,
			historyJSON, item.WorkspaceID, item.Status, item.ResolutionNotes,
			item.CreatedAt,
		)
		return err
	})
}

func (p *PostgresStore) GetDLQItem(ctx context.Context, workspaceID, dlqID string) (*DLQItem, error) {
	query := `
		SELECT
			dlq_id, queue_name, original_message_id, payload::text,
			error_class, COALESCE(error_message, ''), last_error_at, attempt_count,
			retry_history::text, COALESCE(workspace_id::text, ''), status,
			resolved_at, COALESCE(resolved_by::text, ''), COALESCE(resolution_notes, ''),
			created_at
		FROM dead_letter_queue
		WHERE workspace_id = $1 AND dlq_id = $2
	`
	var item DLQItem
	err := p.withTenantTx(ctx, workspaceID, "", func(txCtx context.Context, tx pgx.Tx) error {
		var payloadRaw, historyRaw string
		if err := tx.QueryRow(txCtx, query, workspaceID, dlqID).Scan(
			&item.DLQID, &item.QueueName, &item.OriginalMessageID, &payloadRaw,
			&item.ErrorClass, &item.ErrorMessage, &item.LastErrorAt, &item.AttemptCount,
			&historyRaw, &item.WorkspaceID, &item.Status,
			&item.ResolvedAt, &item.ResolvedBy, &item.ResolutionNotes,
			&item.CreatedAt,
		); err != nil {
			if err == pgx.ErrNoRows {
				return ErrDLQNotFound
			}
			return err
		}
		_ = json.Unmarshal([]byte(payloadRaw), &item.Payload)
		_ = json.Unmarshal([]byte(historyRaw), &item.RetryHistory)
		return nil
	})
	if err != nil {
		return nil, err
	}
	return &item, nil
}

func (p *PostgresStore) ListDLQItems(ctx context.Context, workspaceID string, status string, limit, offset int) ([]DLQItem, int, error) {
	var result []DLQItem
	var total int
	err := p.withTenantTx(ctx, workspaceID, "", func(txCtx context.Context, tx pgx.Tx) error {
		countQuery := `SELECT COUNT(*) FROM dead_letter_queue WHERE workspace_id = $1`
		args := []any{workspaceID}
		if status != "" {
			countQuery += ` AND status = $2`
			args = append(args, status)
		}
		if err := tx.QueryRow(txCtx, countQuery, args...).Scan(&total); err != nil {
			return err
		}

		query := `
			SELECT
				dlq_id, queue_name, original_message_id, payload::text,
				error_class, COALESCE(error_message, ''), last_error_at, attempt_count,
				retry_history::text, COALESCE(workspace_id::text, ''), status,
				resolved_at, COALESCE(resolved_by::text, ''), COALESCE(resolution_notes, ''),
				created_at
			FROM dead_letter_queue
			WHERE workspace_id = $1
		`
		queryArgs := []any{workspaceID}
		if status != "" {
			query += ` AND status = $2`
			queryArgs = append(queryArgs, status)
		}
		query += ` ORDER BY last_error_at DESC`
		if limit > 0 {
			query += fmt.Sprintf(` LIMIT %d OFFSET %d`, limit, offset)
		}

		rows, err := tx.Query(txCtx, query, queryArgs...)
		if err != nil {
			return err
		}
		defer rows.Close()

		for rows.Next() {
			var item DLQItem
			var payloadRaw, historyRaw string
			if err := rows.Scan(
				&item.DLQID, &item.QueueName, &item.OriginalMessageID, &payloadRaw,
				&item.ErrorClass, &item.ErrorMessage, &item.LastErrorAt, &item.AttemptCount,
				&historyRaw, &item.WorkspaceID, &item.Status,
				&item.ResolvedAt, &item.ResolvedBy, &item.ResolutionNotes,
				&item.CreatedAt,
			); err != nil {
				return err
			}
			_ = json.Unmarshal([]byte(payloadRaw), &item.Payload)
			_ = json.Unmarshal([]byte(historyRaw), &item.RetryHistory)
			result = append(result, item)
		}
		return rows.Err()
	})
	return result, total, err
}

func (p *PostgresStore) UpdateDLQItem(ctx context.Context, item *DLQItem) error {
	historyJSON, _ := json.Marshal(item.RetryHistory)
	query := `
		UPDATE dead_letter_queue SET
			status = $1,
			attempt_count = $2,
			retry_history = $3::jsonb,
			resolved_at = $4,
			resolved_by = NULLIF($5, '')::uuid,
			resolution_notes = $6
		WHERE workspace_id = $7 AND dlq_id = $8
	`
	return p.withTenantTx(ctx, item.WorkspaceID, item.ResolvedBy, func(txCtx context.Context, tx pgx.Tx) error {
		cmd, err := tx.Exec(txCtx, query,
			item.Status, item.AttemptCount, historyJSON,
			item.ResolvedAt, item.ResolvedBy, item.ResolutionNotes,
			item.WorkspaceID, item.DLQID,
		)
		if err != nil {
			return err
		}
		if cmd.RowsAffected() == 0 {
			return ErrDLQNotFound
		}
		return nil
	})
}
