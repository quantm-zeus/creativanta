package tenantdb

import (
	"context"
	"errors"
	"fmt"
	"regexp"
	"strings"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
)

var (
	// ErrNilContext is returned when a nil context is passed to a transaction runner.
	ErrNilContext = errors.New("tenantdb: context must not be nil")
	// ErrNilBeginner is returned when a nil transaction beginner or callback is passed.
	ErrNilBeginner = errors.New("tenantdb: transaction beginner and callback must not be nil")
	// ErrInvalidTenantScope is returned when WorkspaceID or UserID is missing or not a canonical RFC 9562 UUID.
	ErrInvalidTenantScope = errors.New("tenantdb: invalid tenant or user UUID in transaction scope")
	// ErrUntrustedTransaction is returned when a tenant query is invoked outside a WithTx boundary.
	ErrUntrustedTransaction = errors.New("tenantdb: tenant query invoked outside WithTx transaction boundary")
	// ErrScopeMismatch is returned when a query's arguments contradict the active WithTx tenant scope.
	ErrScopeMismatch = errors.New("tenantdb: query workspace_id or user_id mismatches active WithTx scope")
	// ErrMembershipRevokedOrMissing is returned when the user is not an active member of the requested workspace.
	ErrMembershipRevokedOrMissing = errors.New("tenantdb: active workspace membership required (missing, suspended, or revoked)")
)

var uuidRegex = regexp.MustCompile(`^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$`)

const zeroUUID = "00000000-0000-0000-0000-000000000000"

// IsValidNonZeroUUID validates that s is a canonical lowercase RFC 9562 UUID and not the nil UUID.
func IsValidNonZeroUUID(s string) bool {
	return s != zeroUUID && uuidRegex.MatchString(s)
}

// DBTX is the canonical sqlc-compatible database execution interface.
type DBTX interface {
	Exec(ctx context.Context, sql string, arguments ...any) (pgconn.CommandTag, error)
	Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error)
	QueryRow(ctx context.Context, sql string, args ...any) pgx.Row
}

// TxBeginner abstracts pgxpool.Pool / pgx.Conn for starting transactions.
type TxBeginner interface {
	Begin(ctx context.Context) (pgx.Tx, error)
}

// Scope defines the validated tenant and user identity bound to a WithTx transaction.
type Scope struct {
	WorkspaceID             string
	UserID                  string
	RequireActiveMembership bool
}

// ActiveScope holds the verified transaction-local scope attached to context inside WithTx.
type ActiveScope struct {
	WorkspaceID string
	UserID      string
	MemberID    string
	Role        string
	Bootstrap   bool
}

type scopeContextKey struct{}

// ScopeFromContext extracts the verified ActiveScope set by WithTx or WithUserBootstrapTx.
func ScopeFromContext(ctx context.Context) (ActiveScope, bool) {
	if ctx == nil {
		return ActiveScope{}, false
	}
	sc, ok := ctx.Value(scopeContextKey{}).(ActiveScope)
	return sc, ok
}

// Queries wraps a sqlc-compatible DBTX and enforces that every tenant query executes
// inside a WithTx transaction with transaction-local RLS context set.
type Queries struct {
	db      DBTX
	inTx    bool
	txScope ActiveScope
}

// New constructs a root Queries instance. Calling tenant queries directly on a non-tx
// Queries instance fails closed with ErrUntrustedTransaction; callers must use WithTx.
func New(db DBTX) *Queries {
	return &Queries{db: db}
}

// WithTx binds Queries to an active pgx.Tx (the standard sqlc Queries.WithTx pattern).
func (q *Queries) WithTx(tx pgx.Tx) *Queries {
	return &Queries{
		db:      tx,
		inTx:    true,
		txScope: q.txScope,
	}
}

func (q *Queries) requireTenantTx(ctx context.Context, expectedWorkspaceID string) (ActiveScope, error) {
	if ctx == nil {
		return ActiveScope{}, ErrNilContext
	}
	if err := ctx.Err(); err != nil {
		return ActiveScope{}, err
	}
	if q == nil || q.db == nil || !q.inTx {
		return ActiveScope{}, ErrUntrustedTransaction
	}
	sc, ok := ScopeFromContext(ctx)
	if !ok {
		return ActiveScope{}, ErrUntrustedTransaction
	}
	if !sc.Bootstrap {
		if !IsValidNonZeroUUID(sc.WorkspaceID) || !IsValidNonZeroUUID(sc.UserID) {
			return ActiveScope{}, ErrUntrustedTransaction
		}
		if sc.WorkspaceID != q.txScope.WorkspaceID || sc.UserID != q.txScope.UserID {
			return ActiveScope{}, ErrScopeMismatch
		}
		if expectedWorkspaceID != "" && expectedWorkspaceID != sc.WorkspaceID {
			return ActiveScope{}, ErrScopeMismatch
		}
	}
	return sc, nil
}

func (q *Queries) requireBootstrapOrTenantTx(ctx context.Context, expectedUserID string) (ActiveScope, error) {
	if ctx == nil {
		return ActiveScope{}, ErrNilContext
	}
	if err := ctx.Err(); err != nil {
		return ActiveScope{}, err
	}
	if q == nil || q.db == nil || !q.inTx {
		return ActiveScope{}, ErrUntrustedTransaction
	}
	sc, ok := ScopeFromContext(ctx)
	if !ok || !IsValidNonZeroUUID(sc.UserID) {
		return ActiveScope{}, ErrUntrustedTransaction
	}
	if sc.UserID != q.txScope.UserID {
		return ActiveScope{}, ErrScopeMismatch
	}
	if expectedUserID != "" && expectedUserID != sc.UserID {
		return ActiveScope{}, ErrScopeMismatch
	}
	return sc, nil
}

const setLocalTenantContextSQL = `
SELECT
  set_config('app.current_tenant_id', $1, true),
  set_config('app.current_user_id', $2, true)
`

const verifyActiveMembershipInTxSQL = `
SELECT wm.member_id::text, wm.role
FROM workspace_members wm
JOIN workspaces w ON w.workspace_id = wm.workspace_id
JOIN users u ON u.user_id = wm.user_id
WHERE wm.workspace_id = $1::uuid
  AND wm.user_id = $2::uuid
  AND wm.status = 'active'
  AND w.status = 'active'
  AND u.status = 'active'
LIMIT 1
`

// WithTx executes fn inside an atomic PostgreSQL transaction scoped to (WorkspaceID, UserID).
//
// Guarantees:
//  1. Validates non-nil, non-cancelled context and canonical non-zero UUIDs for WorkspaceID and UserID.
//  2. Sets transaction-local (`is_local = true`) `app.current_tenant_id` and `app.current_user_id`
//     via `set_config`, which PostgreSQL automatically clears on COMMIT/ROLLBACK so connection
//     pools are never polluted across requests.
//  3. When Scope.RequireActiveMembership is true, verifies inside the same transaction that the
//     user has an active membership in `workspace_members` and both `workspaces` and `users` are
//     `active` before invoking `fn`.
//  4. Rolls back on any error returned by `fn`, context cancellation, or panic (re-raising the panic).
func WithTx(ctx context.Context, beginner TxBeginner, scope Scope, fn func(ctx context.Context, q *Queries) error) (retErr error) {
	if ctx == nil {
		return ErrNilContext
	}
	if err := ctx.Err(); err != nil {
		return err
	}
	if beginner == nil || fn == nil {
		return ErrNilBeginner
	}
	wsID := strings.TrimSpace(scope.WorkspaceID)
	userID := strings.TrimSpace(scope.UserID)
	if !IsValidNonZeroUUID(wsID) || !IsValidNonZeroUUID(userID) {
		return fmt.Errorf("%w: workspace=%q user=%q", ErrInvalidTenantScope, scope.WorkspaceID, scope.UserID)
	}

	tx, err := beginner.Begin(ctx)
	if err != nil {
		return fmt.Errorf("tenantdb: begin transaction: %w", err)
	}

	committed := false
	defer func() {
		if p := recover(); p != nil {
			_ = tx.Rollback(context.Background())
			panic(p)
		}
		if !committed {
			_ = tx.Rollback(context.Background())
		}
	}()

	var configuredTenant, configuredUser string
	if err := tx.QueryRow(ctx, setLocalTenantContextSQL, wsID, userID).Scan(&configuredTenant, &configuredUser); err != nil {
		return fmt.Errorf("tenantdb: set local tenant context: %w", err)
	}
	if configuredTenant != wsID || configuredUser != userID {
		return fmt.Errorf("%w: set_config verification mismatch", ErrInvalidTenantScope)
	}

	activeScope := ActiveScope{
		WorkspaceID: wsID,
		UserID:      userID,
	}

	if scope.RequireActiveMembership {
		var memberID, role string
		err := tx.QueryRow(ctx, verifyActiveMembershipInTxSQL, wsID, userID).Scan(&memberID, &role)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return ErrMembershipRevokedOrMissing
			}
			return fmt.Errorf("tenantdb: verify active membership: %w", err)
		}
		activeScope.MemberID = memberID
		activeScope.Role = role
	}

	txCtx := context.WithValue(ctx, scopeContextKey{}, activeScope)
	q := (&Queries{txScope: activeScope}).WithTx(tx)

	if err := fn(txCtx, q); err != nil {
		return err
	}
	if err := ctx.Err(); err != nil {
		return err
	}
	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("tenantdb: commit transaction: %w", err)
	}
	committed = true
	return nil
}

// WithUserBootstrapTx executes fn inside an atomic PostgreSQL transaction with
// `app.current_user_id` set (and `app.current_tenant_id` explicitly cleared to ”)
// for pre-tenant bootstrap operations such as WorkspaceService/Create or workspace discovery.
func WithUserBootstrapTx(ctx context.Context, beginner TxBeginner, userID string, fn func(ctx context.Context, q *Queries) error) (retErr error) {
	if ctx == nil {
		return ErrNilContext
	}
	if err := ctx.Err(); err != nil {
		return err
	}
	if beginner == nil || fn == nil {
		return ErrNilBeginner
	}
	uid := strings.TrimSpace(userID)
	if !IsValidNonZeroUUID(uid) {
		return fmt.Errorf("%w: user=%q", ErrInvalidTenantScope, userID)
	}

	tx, err := beginner.Begin(ctx)
	if err != nil {
		return fmt.Errorf("tenantdb: begin bootstrap transaction: %w", err)
	}

	committed := false
	defer func() {
		if p := recover(); p != nil {
			_ = tx.Rollback(context.Background())
			panic(p)
		}
		if !committed {
			_ = tx.Rollback(context.Background())
		}
	}()

	var configuredTenant, configuredUser string
	if err := tx.QueryRow(ctx, setLocalTenantContextSQL, "", uid).Scan(&configuredTenant, &configuredUser); err != nil {
		return fmt.Errorf("tenantdb: set local user bootstrap context: %w", err)
	}
	if configuredTenant != "" || configuredUser != uid {
		return fmt.Errorf("%w: bootstrap set_config verification mismatch", ErrInvalidTenantScope)
	}

	activeScope := ActiveScope{
		UserID:    uid,
		Bootstrap: true,
	}
	txCtx := context.WithValue(ctx, scopeContextKey{}, activeScope)
	q := (&Queries{txScope: activeScope}).WithTx(tx)

	if err := fn(txCtx, q); err != nil {
		return err
	}
	if err := ctx.Err(); err != nil {
		return err
	}
	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("tenantdb: commit bootstrap transaction: %w", err)
	}
	committed = true
	return nil
}
