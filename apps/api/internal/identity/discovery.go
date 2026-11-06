package identity

import (
	"context"
	"database/sql"
	"strings"
)

// WorkspaceSummary contains only minimally needed workspace picker fields.
type WorkspaceSummary struct {
	ID                  string `json:"workspace_id"`
	Name                string `json:"name"`
	DisplayName         string `json:"display_name"`
	Role                string `json:"role"`
	DefaultMode         string `json:"default_mode,omitempty"`
	DefaultOperatorMode string `json:"default_operator_mode,omitempty"`
}

type SQLRowsQueryer interface {
	QueryContext(ctx context.Context, query string, args ...any) (*sql.Rows, error)
}

type sqlTxBeginner interface {
	BeginTx(ctx context.Context, opts *sql.TxOptions) (*sql.Tx, error)
}

type sqlExecRowQueryer interface {
	ExecContext(ctx context.Context, query string, args ...any) (sql.Result, error)
	QueryRowContext(ctx context.Context, query string, args ...any) *sql.Row
	QueryContext(ctx context.Context, query string, args ...any) (*sql.Rows, error)
}

type WorkspaceDiscovery interface {
	Discover(ctx context.Context, providerSubject string) ([]WorkspaceSummary, error)
}

const resolveActiveUserByClerkIDQuery = `
SELECT u.user_id::text
FROM users AS u
WHERE u.clerk_id = $1
  AND u.status = 'active'
LIMIT 1`

// Preselection discovery requires P0-04 to provide the restricted role/grants;
// this method never claims such a role already exists.
const activeDiscoveryQuery = `
SELECT
  w.workspace_id::text,
  COALESCE(NULLIF(w.display_name, ''), NULLIF(to_jsonb(w)->>'name', ''), '') AS display_name,
  m.role,
  COALESCE(NULLIF(to_jsonb(w)->>'default_operator_mode', ''), NULLIF(to_jsonb(w)->>'default_mode', ''), 'creator') AS default_operator_mode
FROM users AS u
JOIN workspace_members AS m ON m.user_id=u.user_id
JOIN workspaces AS w ON w.workspace_id=m.workspace_id
WHERE u.clerk_id=$1 AND u.status='active'
 AND m.status='active' AND w.status='active' AND w.deleted_at IS NULL
ORDER BY COALESCE(NULLIF(w.display_name, ''), NULLIF(to_jsonb(w)->>'name', ''), ''), w.workspace_id
LIMIT 100`

func bootstrapDiscoveryRLSScope(ctx context.Context, execDB sqlExecRowQueryer, subject string) (bool, error) {
	if _, err := execDB.ExecContext(
		ctx,
		"SELECT set_config('app.current_clerk_id', $1, true), set_config('app.current_user_id', '', true), set_config('app.current_tenant_id', '', true)",
		subject,
	); err != nil {
		return false, err
	}
	var resolvedUserID string
	err := execDB.QueryRowContext(ctx, resolveActiveUserByClerkIDQuery, subject).Scan(&resolvedUserID)
	if err == sql.ErrNoRows {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	if !workspaceIDPattern.MatchString(resolvedUserID) || resolvedUserID == zeroUUID {
		return false, nil
	}
	if _, err := execDB.ExecContext(
		ctx,
		"SELECT set_config('app.current_user_id', $1, true), set_config('app.current_tenant_id', '', true)",
		resolvedUserID,
	); err != nil {
		return false, err
	}
	return true, nil
}

func (m SQLMembershipLookup) Discover(ctx context.Context, subject string) ([]WorkspaceSummary, error) {
	if m.Queries == nil {
		return nil, ErrNotConfigured
	}
	db, ok := m.Queries.(SQLRowsQueryer)
	if !ok {
		return nil, ErrNotConfigured
	}
	if subject == "" || len(subject) > 255 || strings.TrimSpace(subject) != subject {
		return nil, ErrUnauthorized
	}

	var rows *sql.Rows
	var err error
	var txToCommit *sql.Tx

	if txBeginner, ok := m.Queries.(sqlTxBeginner); ok {
		tx, beginErr := txBeginner.BeginTx(ctx, nil)
		if beginErr != nil {
			return nil, beginErr
		}
		defer func() { _ = tx.Rollback() }()
		foundUser, bootErr := bootstrapDiscoveryRLSScope(ctx, tx, subject)
		if bootErr != nil {
			return nil, bootErr
		}
		if !foundUser {
			return []WorkspaceSummary{}, nil
		}
		txToCommit = tx
		rows, err = tx.QueryContext(ctx, activeDiscoveryQuery, subject)
	} else if execDB, ok := m.Queries.(sqlExecRowQueryer); ok {
		foundUser, bootErr := bootstrapDiscoveryRLSScope(ctx, execDB, subject)
		if bootErr != nil {
			return nil, bootErr
		}
		if !foundUser {
			return []WorkspaceSummary{}, nil
		}
		rows, err = execDB.QueryContext(ctx, activeDiscoveryQuery, subject)
	} else {
		rows, err = db.QueryContext(ctx, activeDiscoveryQuery, subject)
	}
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	result := make([]WorkspaceSummary, 0)
	for rows.Next() {
		var item WorkspaceSummary
		if err := rows.Scan(&item.ID, &item.Name, &item.Role, &item.DefaultOperatorMode); err != nil {
			return nil, err
		}
		item.DisplayName = item.Name
		item.DefaultMode = item.DefaultOperatorMode
		if !workspaceIDPattern.MatchString(item.ID) || item.ID == zeroUUID {
			return nil, ErrNoMembership
		}
		result = append(result, item)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	rows.Close()
	if txToCommit != nil {
		if err := txToCommit.Commit(); err != nil {
			return nil, err
		}
	}
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	return result, nil
}

// DiscoverWorkspaces requires a verified JWT and an actively valid provider
// session before querying LOCAL current membership, including for non-owners.
func (r Resolver) DiscoverWorkspaces(ctx context.Context, token string) ([]WorkspaceSummary, error) {
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	if token == "" || strings.TrimSpace(token) != token {
		return nil, ErrUnauthorized
	}
	if r.Tokens == nil || r.Sessions == nil || r.Memberships == nil {
		return nil, ErrNotConfigured
	}
	discovery, ok := r.Memberships.(WorkspaceDiscovery)
	if !ok {
		return nil, ErrNotConfigured
	}
	identity, err := r.Tokens.VerifyToken(ctx, token)
	if err != nil || identity.Subject == "" || identity.SessionID == "" {
		return nil, ErrUnauthorized
	}
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	active, err := r.Sessions.Active(ctx, identity.Subject, identity.SessionID)
	if err != nil || !active {
		return nil, ErrUnauthorized
	}
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	items, err := discovery.Discover(ctx, identity.Subject)
	if err != nil {
		return nil, err
	}
	for i := range items {
		if items[i].DisplayName == "" {
			items[i].DisplayName = items[i].Name
		}
		if items[i].Name == "" {
			items[i].Name = items[i].DisplayName
		}
		if items[i].DefaultOperatorMode == "" && items[i].DefaultMode != "" {
			items[i].DefaultOperatorMode = items[i].DefaultMode
		}
		if items[i].DefaultMode == "" && items[i].DefaultOperatorMode != "" {
			items[i].DefaultMode = items[i].DefaultOperatorMode
		}
	}
	if err := ctx.Err(); err != nil {
		return nil, err
	}
	return items, nil
}
