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

func (m SQLMembershipLookup) ResolveActive(ctx context.Context, subject, workspaceID string) (string, bool, error) {
	if m.Queries == nil {
		return "", false, ErrNotConfigured
	}
	if !workspaceIDPattern.MatchString(workspaceID) || workspaceID == zeroUUID || subject == "" {
		return "", false, ErrNoMembership
	}
	var userID string
	err := m.Queries.QueryRowContext(ctx, activeMembershipQuery, subject, workspaceID).Scan(&userID)
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
