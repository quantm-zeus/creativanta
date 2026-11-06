package identity

import (
	"context"
	"database/sql"
	"errors"
)

// SQLQueryer needs a narrowly scoped identity reader. P0-04 must install and
// verify database roles, grants and RLS; no privileged DB connection is used.
type SQLQueryer interface {
	QueryRowContext(ctx context.Context, query string, args ...any) *sql.Row
}

type SQLMembershipLookup struct{ Queries SQLQueryer }

// This lookup uses only canonical local state, never JWT workspace/role claims.
const activeMembershipQuery = `
SELECT u.user_id::text
FROM users AS u
JOIN workspace_members AS m ON m.user_id = u.user_id
JOIN workspaces AS w ON w.workspace_id = m.workspace_id
WHERE u.clerk_id = $1
  AND m.workspace_id = $2::uuid
  AND u.status = 'active'
  AND m.status = 'active'
  AND w.status = 'active'
  AND w.deleted_at IS NULL
LIMIT 1`

func bootstrapMembershipRLSScope(ctx context.Context, execDB sqlExecRowQueryer, subject, workspaceID string) (bool, error) {
	if _, err := execDB.ExecContext(
		ctx,
		"SELECT set_config('app.current_clerk_id', $1, true), set_config('app.current_user_id', '', true), set_config('app.current_tenant_id', $2, true)",
		subject,
		workspaceID,
	); err != nil {
		return false, err
	}
	var resolvedUserID string
	err := execDB.QueryRowContext(ctx, resolveActiveUserByClerkIDQuery, subject).Scan(&resolvedUserID)
	if errors.Is(err, sql.ErrNoRows) {
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
		"SELECT set_config('app.current_user_id', $1, true), set_config('app.current_tenant_id', $2, true)",
		resolvedUserID,
		workspaceID,
	); err != nil {
		return false, err
	}
	return true, nil
}

func (m SQLMembershipLookup) ResolveActive(ctx context.Context, subject, workspaceID string) (string, bool, error) {
	if m.Queries == nil {
		return "", false, ErrNotConfigured
	}
	if !workspaceIDPattern.MatchString(workspaceID) || workspaceID == zeroUUID || subject == "" {
		return "", false, ErrNoMembership
	}

	var userID string
	var err error

	if txBeginner, ok := m.Queries.(sqlTxBeginner); ok {
		tx, beginErr := txBeginner.BeginTx(ctx, nil)
		if beginErr != nil {
			return "", false, beginErr
		}
		defer func() { _ = tx.Rollback() }()
		foundUser, bootErr := bootstrapMembershipRLSScope(ctx, tx, subject, workspaceID)
		if bootErr != nil {
			return "", false, bootErr
		}
		if !foundUser {
			return "", false, nil
		}
		err = tx.QueryRowContext(ctx, activeMembershipQuery, subject, workspaceID).Scan(&userID)
		if err == nil {
			if commitErr := tx.Commit(); commitErr != nil {
				return "", false, commitErr
			}
		}
	} else if execDB, ok := m.Queries.(sqlExecRowQueryer); ok {
		foundUser, bootErr := bootstrapMembershipRLSScope(ctx, execDB, subject, workspaceID)
		if bootErr != nil {
			return "", false, bootErr
		}
		if !foundUser {
			return "", false, nil
		}
		err = execDB.QueryRowContext(ctx, activeMembershipQuery, subject, workspaceID).Scan(&userID)
	} else {
		err = m.Queries.QueryRowContext(ctx, activeMembershipQuery, subject, workspaceID).Scan(&userID)
	}

	if errors.Is(err, sql.ErrNoRows) {
		return "", false, nil
	}
	if err != nil {
		return "", false, err
	}
	if !workspaceIDPattern.MatchString(userID) || userID == zeroUUID {
		return "", false, ErrNoMembership
	}
	return userID, true, nil
}
