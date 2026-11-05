package tenantdb

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
)

var (
	// ErrLastOwnerProtected is returned when an operation attempts to demote or remove the last active Owner.
	ErrLastOwnerProtected = errors.New("tenantdb: cannot remove or demote the last active workspace owner")
	// ErrOwnerTransferRequiresOwner is returned when a non-owner attempts to transfer workspace ownership.
	ErrOwnerTransferRequiresOwner = errors.New("tenantdb: only the current active owner can transfer workspace ownership")
)

// WorkspaceRow models a canonical workspaces row with exact decimal credit fields.
type WorkspaceRow struct {
	WorkspaceID           string
	Name                  string
	DisplayName           string
	Slug                  string
	OwnerUserID           string
	SubscriptionTier      string
	DefaultMode           string
	DefaultOperatorMode   string
	EnabledModes          []string
	AICreditsRemaining    ExactDecimal
	AICreditsMonthlyLimit ExactDecimal
	StorageUsedBytes      int64
	StorageLimitBytes     int64
	SettingsJSON          []byte
	Locale                string
	Timezone              string
	Status                string
	CreatedAt             time.Time
	UpdatedAt             time.Time
}

// CreateWorkspaceParams defines parameters for creating a workspace and its initial Owner membership.
type CreateWorkspaceParams struct {
	WorkspaceID    string
	Name           string
	Slug           string
	OwnerUserID    string
	DefaultMode    string
	EnabledModes   []string
	Locale         string
	Timezone       string
	InitialCredits ExactDecimal
	MonthlyLimit   ExactDecimal
	OwnerMemberID  string
}

const createWorkspaceSQL = `
INSERT INTO workspaces (
  workspace_id, name, display_name, slug, owner_user_id, subscription_tier,
  default_mode, default_operator_mode, enabled_modes, ai_credits_remaining, ai_credits_monthly_limit,
  locale, timezone, status
) VALUES (
  $1::uuid, $2, $2, $3, $4::uuid, 'free',
  $5::operator_mode, $5, $6::operator_mode[], $7, $8,
  $9, $10, 'active'
)
RETURNING
  workspace_id::text, COALESCE(NULLIF(display_name, ''), name), slug, owner_user_id::text, subscription_tier,
  default_operator_mode::text, enabled_modes::text[], ai_credits_remaining, ai_credits_monthly_limit,
  storage_used_bytes, storage_limit_bytes, settings, locale, timezone, status,
  created_at, updated_at
`

const createInitialOwnerMemberSQL = `
INSERT INTO workspace_members (
  member_id, workspace_id, user_id, role, status
) VALUES (
  $1::uuid, $2::uuid, $3::uuid, 'owner', 'active'
)
`

// CreateWorkspace inserts a new workspace and its active Owner row atomically inside a bootstrap or tenant transaction.
func (q *Queries) CreateWorkspace(ctx context.Context, arg CreateWorkspaceParams) (WorkspaceRow, error) {
	sc, err := q.requireBootstrapOrTenantTx(ctx, arg.OwnerUserID)
	if err != nil {
		return WorkspaceRow{}, err
	}
	if !IsValidNonZeroUUID(arg.WorkspaceID) || !IsValidNonZeroUUID(arg.OwnerMemberID) {
		return WorkspaceRow{}, ErrInvalidTenantScope
	}
	if sc.UserID != arg.OwnerUserID {
		return WorkspaceRow{}, ErrScopeMismatch
	}

	mode := arg.DefaultMode
	if mode == "" {
		mode = "creator"
	}
	enabled := arg.EnabledModes
	if len(enabled) == 0 {
		enabled = []string{mode}
	}
	locale := arg.Locale
	if locale == "" {
		locale = "vi-VN"
	}
	tz := arg.Timezone
	if tz == "" {
		tz = "Asia/Ho_Chi_Minh"
	}

	var row WorkspaceRow
	var remNum, limNum pgtype.Numeric
	err = q.db.QueryRow(
		ctx,
		createWorkspaceSQL,
		arg.WorkspaceID,
		arg.Name,
		arg.Slug,
		arg.OwnerUserID,
		mode,
		enabled,
		arg.InitialCredits.ToPgNumeric(),
		arg.MonthlyLimit.ToPgNumeric(),
		locale,
		tz,
	).Scan(
		&row.WorkspaceID,
		&row.Name,
		&row.Slug,
		&row.OwnerUserID,
		&row.SubscriptionTier,
		&row.DefaultMode,
		&row.EnabledModes,
		&remNum,
		&limNum,
		&row.StorageUsedBytes,
		&row.StorageLimitBytes,
		&row.SettingsJSON,
		&row.Locale,
		&row.Timezone,
		&row.Status,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	if err != nil {
		return WorkspaceRow{}, err
	}
	row.DisplayName = row.Name
	row.DefaultOperatorMode = row.DefaultMode
	row.AICreditsRemaining, err = FromPgNumeric(remNum)
	if err != nil {
		return WorkspaceRow{}, err
	}
	row.AICreditsMonthlyLimit, err = FromPgNumeric(limNum)
	if err != nil {
		return WorkspaceRow{}, err
	}

	if _, err := q.db.Exec(ctx, createInitialOwnerMemberSQL, arg.OwnerMemberID, arg.WorkspaceID, arg.OwnerUserID); err != nil {
		return WorkspaceRow{}, err
	}
	return row, nil
}

const getWorkspaceSQL = `
SELECT
  workspace_id::text, COALESCE(NULLIF(display_name, ''), name), slug, owner_user_id::text, subscription_tier,
  default_operator_mode::text, enabled_modes::text[], ai_credits_remaining, ai_credits_monthly_limit,
  storage_used_bytes, storage_limit_bytes, settings, locale, timezone, status,
  created_at, updated_at
FROM workspaces
WHERE workspace_id = $1::uuid
`

// GetWorkspace fetches the current tenant's workspace row inside WithTx.
func (q *Queries) GetWorkspace(ctx context.Context, workspaceID string) (WorkspaceRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return WorkspaceRow{}, err
	}
	var row WorkspaceRow
	var remNum, limNum pgtype.Numeric
	err := q.db.QueryRow(ctx, getWorkspaceSQL, workspaceID).Scan(
		&row.WorkspaceID,
		&row.Name,
		&row.Slug,
		&row.OwnerUserID,
		&row.SubscriptionTier,
		&row.DefaultMode,
		&row.EnabledModes,
		&remNum,
		&limNum,
		&row.StorageUsedBytes,
		&row.StorageLimitBytes,
		&row.SettingsJSON,
		&row.Locale,
		&row.Timezone,
		&row.Status,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	if err != nil {
		return WorkspaceRow{}, err
	}
	row.DisplayName = row.Name
	row.DefaultOperatorMode = row.DefaultMode
	row.AICreditsRemaining, err = FromPgNumeric(remNum)
	if err != nil {
		return WorkspaceRow{}, err
	}
	row.AICreditsMonthlyLimit, err = FromPgNumeric(limNum)
	if err != nil {
		return WorkspaceRow{}, err
	}
	return row, nil
}

// UpdateWorkspaceParams defines updatable workspace fields.
type UpdateWorkspaceParams struct {
	WorkspaceID  string
	Name         string
	DefaultMode  string
	Locale       string
	Timezone     string
	SettingsJSON []byte
}

const updateWorkspaceSQL = `
UPDATE workspaces
SET
  name = $2,
  display_name = $2,
  default_mode = $3::operator_mode,
  default_operator_mode = $3,
  locale = $4,
  timezone = $5,
  settings = $6::jsonb,
  updated_at = NOW()
WHERE workspace_id = $1::uuid
RETURNING
  workspace_id::text, COALESCE(NULLIF(display_name, ''), name), slug, owner_user_id::text, subscription_tier,
  default_operator_mode::text, enabled_modes::text[], ai_credits_remaining, ai_credits_monthly_limit,
  storage_used_bytes, storage_limit_bytes, settings, locale, timezone, status,
  created_at, updated_at
`

// UpdateWorkspace updates the current workspace settings inside WithTx.
func (q *Queries) UpdateWorkspace(ctx context.Context, arg UpdateWorkspaceParams) (WorkspaceRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return WorkspaceRow{}, err
	}
	settings := arg.SettingsJSON
	if len(settings) == 0 {
		settings = []byte(`{}`)
	}
	var row WorkspaceRow
	var remNum, limNum pgtype.Numeric
	err := q.db.QueryRow(
		ctx,
		updateWorkspaceSQL,
		arg.WorkspaceID,
		arg.Name,
		arg.DefaultMode,
		arg.Locale,
		arg.Timezone,
		settings,
	).Scan(
		&row.WorkspaceID,
		&row.Name,
		&row.Slug,
		&row.OwnerUserID,
		&row.SubscriptionTier,
		&row.DefaultMode,
		&row.EnabledModes,
		&remNum,
		&limNum,
		&row.StorageUsedBytes,
		&row.StorageLimitBytes,
		&row.SettingsJSON,
		&row.Locale,
		&row.Timezone,
		&row.Status,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	if err != nil {
		return WorkspaceRow{}, err
	}
	row.DisplayName = row.Name
	row.DefaultOperatorMode = row.DefaultMode
	row.AICreditsRemaining, err = FromPgNumeric(remNum)
	if err != nil {
		return WorkspaceRow{}, err
	}
	row.AICreditsMonthlyLimit, err = FromPgNumeric(limNum)
	if err != nil {
		return WorkspaceRow{}, err
	}
	return row, nil
}

// WorkspaceMemberRow models a workspace member joined with safe user profile fields.
type WorkspaceMemberRow struct {
	MemberID    string
	WorkspaceID string
	UserID      string
	Email       string
	DisplayName string
	AvatarURL   string
	Role        string
	Status      string
	InvitedBy   string
	JoinedAt    time.Time
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

const listWorkspaceMembersSQL = `
SELECT
  wm.member_id::text,
  wm.workspace_id::text,
  wm.user_id::text,
  COALESCE(u.email, ''),
  COALESCE(u.display_name, ''),
  COALESCE(u.avatar_url, ''),
  wm.role,
  wm.status,
  COALESCE(wm.invited_by::text, ''),
  COALESCE(wm.joined_at, wm.created_at),
  wm.created_at,
  wm.updated_at
FROM workspace_members wm
LEFT JOIN users u ON u.user_id = wm.user_id
WHERE wm.workspace_id = $1::uuid
ORDER BY wm.created_at ASC, wm.member_id ASC
`

// ListWorkspaceMembers lists members in the active tenant workspace inside WithTx.
func (q *Queries) ListWorkspaceMembers(ctx context.Context, workspaceID string) ([]WorkspaceMemberRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return nil, err
	}
	rows, err := q.db.Query(ctx, listWorkspaceMembersSQL, workspaceID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var members []WorkspaceMemberRow
	for rows.Next() {
		var m WorkspaceMemberRow
		if err := rows.Scan(
			&m.MemberID,
			&m.WorkspaceID,
			&m.UserID,
			&m.Email,
			&m.DisplayName,
			&m.AvatarURL,
			&m.Role,
			&m.Status,
			&m.InvitedBy,
			&m.JoinedAt,
			&m.CreatedAt,
			&m.UpdatedAt,
		); err != nil {
			return nil, err
		}
		members = append(members, m)
	}
	return members, rows.Err()
}

const getWorkspaceMemberForUpdateSQL = `
SELECT
  member_id::text, workspace_id::text, user_id::text, role, status,
  COALESCE(invited_by::text, ''), COALESCE(joined_at, created_at), created_at, updated_at
FROM workspace_members
WHERE workspace_id = $1::uuid
  AND member_id = $2::uuid
FOR UPDATE
`

// GetWorkspaceMemberForUpdate locks and returns a workspace_members row by member_id inside WithTx.
func (q *Queries) GetWorkspaceMemberForUpdate(ctx context.Context, workspaceID, memberID string) (WorkspaceMemberRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return WorkspaceMemberRow{}, err
	}
	var m WorkspaceMemberRow
	err := q.db.QueryRow(ctx, getWorkspaceMemberForUpdateSQL, workspaceID, memberID).Scan(
		&m.MemberID,
		&m.WorkspaceID,
		&m.UserID,
		&m.Role,
		&m.Status,
		&m.InvitedBy,
		&m.JoinedAt,
		&m.CreatedAt,
		&m.UpdatedAt,
	)
	return m, err
}

const countActiveWorkspaceOwnersSQL = `
SELECT COUNT(1)
FROM workspace_members
WHERE workspace_id = $1::uuid
  AND role = 'owner'
  AND status = 'active'
`

// CountActiveWorkspaceOwners returns the count of active owners in the workspace inside WithTx.
func (q *Queries) CountActiveWorkspaceOwners(ctx context.Context, workspaceID string) (int, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return 0, err
	}
	var count int
	err := q.db.QueryRow(ctx, countActiveWorkspaceOwnersSQL, workspaceID).Scan(&count)
	return count, err
}

const updateWorkspaceMemberRoleSQL = `
UPDATE workspace_members
SET role = $3,
    source_updated_at = GREATEST(COALESCE(source_updated_at, NOW()), NOW()),
    updated_at = NOW()
WHERE workspace_id = $1::uuid
  AND member_id = $2::uuid
  AND status = 'active'
RETURNING
  member_id::text, workspace_id::text, user_id::text, role, status,
  COALESCE(invited_by::text, ''), COALESCE(joined_at, created_at), created_at, updated_at
`

// UpdateWorkspaceMemberRole updates a non-owner member's role inside WithTx, enforcing last-owner protection.
func (q *Queries) UpdateWorkspaceMemberRole(ctx context.Context, workspaceID, memberID, newRole string) (WorkspaceMemberRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return WorkspaceMemberRow{}, err
	}
	target, err := q.GetWorkspaceMemberForUpdate(ctx, workspaceID, memberID)
	if err != nil {
		return WorkspaceMemberRow{}, err
	}
	if target.Role == "owner" && newRole != "owner" {
		owners, err := q.CountActiveWorkspaceOwners(ctx, workspaceID)
		if err != nil {
			return WorkspaceMemberRow{}, err
		}
		if owners <= 1 {
			return WorkspaceMemberRow{}, ErrLastOwnerProtected
		}
	}

	var updated WorkspaceMemberRow
	err = q.db.QueryRow(ctx, updateWorkspaceMemberRoleSQL, workspaceID, memberID, newRole).Scan(
		&updated.MemberID,
		&updated.WorkspaceID,
		&updated.UserID,
		&updated.Role,
		&updated.Status,
		&updated.InvitedBy,
		&updated.JoinedAt,
		&updated.CreatedAt,
		&updated.UpdatedAt,
	)
	return updated, err
}

// TransferWorkspaceOwnership atomically transfers ownership from the current active Owner
// to another active workspace member in a single transaction, updating `workspaces.owner_user_id`
// and both `workspace_members` rows without ever violating `idx_one_active_workspace_owner`.
func (q *Queries) TransferWorkspaceOwnership(ctx context.Context, workspaceID, currentOwnerUserID, targetMemberID, demotedOwnerRole string) (WorkspaceMemberRow, error) {
	sc, err := q.requireTenantTx(ctx, workspaceID)
	if err != nil {
		return WorkspaceMemberRow{}, err
	}
	if sc.UserID != currentOwnerUserID || sc.Role != "owner" {
		return WorkspaceMemberRow{}, ErrOwnerTransferRequiresOwner
	}
	if demotedOwnerRole == "" || demotedOwnerRole == "owner" {
		demotedOwnerRole = "admin"
	}

	target, err := q.GetWorkspaceMemberForUpdate(ctx, workspaceID, targetMemberID)
	if err != nil {
		return WorkspaceMemberRow{}, err
	}
	if target.Status != "active" {
		return WorkspaceMemberRow{}, ErrMembershipRevokedOrMissing
	}
	if target.UserID == currentOwnerUserID {
		return target, nil
	}

	// Step 1: Demote current owner first so idx_one_active_workspace_owner is satisfied when promoting target.
	tag, err := q.db.Exec(ctx, `
		UPDATE workspace_members
		SET role = $3,
		    source_updated_at = GREATEST(COALESCE(source_updated_at, NOW()), NOW()),
		    updated_at = NOW()
		WHERE workspace_id = $1::uuid
		  AND user_id = $2::uuid
		  AND role = 'owner'
		  AND status = 'active'
	`, workspaceID, currentOwnerUserID, demotedOwnerRole)
	if err != nil {
		return WorkspaceMemberRow{}, err
	}
	if tag.RowsAffected() != 1 {
		return WorkspaceMemberRow{}, ErrOwnerTransferRequiresOwner
	}

	// Step 2: Promote target member to owner.
	var promoted WorkspaceMemberRow
	err = q.db.QueryRow(ctx, updateWorkspaceMemberRoleSQL, workspaceID, targetMemberID, "owner").Scan(
		&promoted.MemberID,
		&promoted.WorkspaceID,
		&promoted.UserID,
		&promoted.Role,
		&promoted.Status,
		&promoted.InvitedBy,
		&promoted.JoinedAt,
		&promoted.CreatedAt,
		&promoted.UpdatedAt,
	)
	if err != nil {
		return WorkspaceMemberRow{}, err
	}

	// Step 3: Update workspaces.owner_user_id in the same transaction (§26.14).
	if _, err := q.db.Exec(ctx, `
		UPDATE workspaces
		SET owner_user_id = $2::uuid, updated_at = NOW()
		WHERE workspace_id = $1::uuid
	`, workspaceID, promoted.UserID); err != nil {
		return WorkspaceMemberRow{}, err
	}

	return promoted, nil
}

const revokeWorkspaceMemberSQL = `
UPDATE workspace_members
SET status = 'revoked',
    source_updated_at = GREATEST(COALESCE(source_updated_at, NOW()), NOW()),
    updated_at = NOW()
WHERE workspace_id = $1::uuid
  AND member_id = $2::uuid
  AND status <> 'revoked'
RETURNING
  member_id::text, workspace_id::text, user_id::text, role, status,
  COALESCE(invited_by::text, ''), COALESCE(joined_at, created_at), created_at, updated_at
`

// RevokeWorkspaceMember revokes a member's access immediately inside WithTx,
// refusing to remove the last active Owner.
func (q *Queries) RevokeWorkspaceMember(ctx context.Context, workspaceID, memberID string) (WorkspaceMemberRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return WorkspaceMemberRow{}, err
	}
	target, err := q.GetWorkspaceMemberForUpdate(ctx, workspaceID, memberID)
	if err != nil {
		return WorkspaceMemberRow{}, err
	}
	if target.Role == "owner" && target.Status == "active" {
		owners, err := q.CountActiveWorkspaceOwners(ctx, workspaceID)
		if err != nil {
			return WorkspaceMemberRow{}, err
		}
		if owners <= 1 {
			return WorkspaceMemberRow{}, ErrLastOwnerProtected
		}
	}

	var revoked WorkspaceMemberRow
	err = q.db.QueryRow(ctx, revokeWorkspaceMemberSQL, workspaceID, memberID).Scan(
		&revoked.MemberID,
		&revoked.WorkspaceID,
		&revoked.UserID,
		&revoked.Role,
		&revoked.Status,
		&revoked.InvitedBy,
		&revoked.JoinedAt,
		&revoked.CreatedAt,
		&revoked.UpdatedAt,
	)
	return revoked, err
}

// AuditEventParams defines fields for inserting an immutable audit_events row.
type AuditEventParams struct {
	AuditEventID string
	WorkspaceID  string
	ActorUserID  string
	ActorType    string
	Action       string
	ResourceType string
	ResourceID   string
	ChangesJSON  []byte
	Reason       string
}

const insertAuditEventSQL = `
INSERT INTO audit_events (
  audit_event_id, workspace_id, actor_user_id, actor_type,
  action, resource_type, resource_id, changes, reason
) VALUES (
  $1::uuid, $2::uuid, $3::uuid, $4,
  $5, $6, $7::uuid, $8::jsonb, $9
)
`

// InsertAuditEvent appends an immutable audit event in the current tenant transaction.
func (q *Queries) InsertAuditEvent(ctx context.Context, arg AuditEventParams) error {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return err
	}
	actorType := arg.ActorType
	if actorType == "" {
		actorType = "user"
	}
	changes := arg.ChangesJSON
	if len(changes) == 0 {
		changes = []byte(`{}`)
	}
	_, err := q.db.Exec(
		ctx,
		insertAuditEventSQL,
		arg.AuditEventID,
		arg.WorkspaceID,
		arg.ActorUserID,
		actorType,
		arg.Action,
		arg.ResourceType,
		arg.ResourceID,
		changes,
		arg.Reason,
	)
	return err
}

// OutboxEventParams defines fields for inserting a transactional event_outbox row.
type OutboxEventParams struct {
	EventID       string
	EventType     string
	TargetStream  string
	AggregateType string
	AggregateID   string
	WorkspaceID   string
	PayloadJSON   []byte
	MetadataJSON  []byte
}

const insertOutboxEventSQL = `
INSERT INTO event_outbox (
  event_id, event_type, target_stream, aggregate_type, aggregate_id,
  workspace_id, payload, metadata
) VALUES (
  $1::uuid, $2, $3, $4, $5::uuid,
  $6::uuid, $7::jsonb, $8::jsonb
)
`

// InsertOutboxEvent appends a domain event to event_outbox inside the current tenant transaction.
func (q *Queries) InsertOutboxEvent(ctx context.Context, arg OutboxEventParams) error {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return err
	}
	payload := arg.PayloadJSON
	if len(payload) == 0 {
		payload = []byte(`{}`)
	}
	meta := arg.MetadataJSON
	if len(meta) == 0 {
		meta = []byte(`{}`)
	}
	_, err := q.db.Exec(
		ctx,
		insertOutboxEventSQL,
		arg.EventID,
		arg.EventType,
		arg.TargetStream,
		arg.AggregateType,
		arg.AggregateID,
		arg.WorkspaceID,
		payload,
		meta,
	)
	return err
}

// IdempotencyRecord models a row in api_idempotency_records.
type IdempotencyRecord struct {
	RecordID        string
	WorkspaceID     string
	ActorID         string
	RPC             string
	IdempotencyKey  string
	RequestHash     string
	Status          string
	ResponsePayload []byte
	ResponseCode    int
	ExpiresAt       time.Time
}

const getIdempotencyRecordSQL = `
SELECT
  record_id::text, workspace_id::text, actor_id::text, rpc,
  idempotency_key, request_hash, status, COALESCE(response_payload, '{}'::jsonb),
  COALESCE(response_code, 200), expires_at
FROM api_idempotency_records
WHERE workspace_id = $1::uuid
  AND actor_id = $2::uuid
  AND rpc = $3
  AND idempotency_key = $4
FOR UPDATE
`

// GetIdempotencyRecord looks up an existing idempotency record inside WithTx.
func (q *Queries) GetIdempotencyRecord(ctx context.Context, workspaceID, actorID, rpc, idempotencyKey string) (IdempotencyRecord, bool, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return IdempotencyRecord{}, false, err
	}
	var rec IdempotencyRecord
	err := q.db.QueryRow(ctx, getIdempotencyRecordSQL, workspaceID, actorID, rpc, idempotencyKey).Scan(
		&rec.RecordID,
		&rec.WorkspaceID,
		&rec.ActorID,
		&rec.RPC,
		&rec.IdempotencyKey,
		&rec.RequestHash,
		&rec.Status,
		&rec.ResponsePayload,
		&rec.ResponseCode,
		&rec.ExpiresAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return IdempotencyRecord{}, false, nil
		}
		return IdempotencyRecord{}, false, err
	}
	return rec, true, nil
}

const upsertCompletedIdempotencyRecordSQL = `
INSERT INTO api_idempotency_records (
  record_id, workspace_id, actor_id, rpc, idempotency_key,
  request_hash, status, response_payload, response_code, expires_at
) VALUES (
  $1::uuid, $2::uuid, $3::uuid, $4, $5,
  $6, 'completed', $7::jsonb, $8, $9
)
`

// SaveCompletedIdempotencyRecord stores a completed command response inside WithTx.
func (q *Queries) SaveCompletedIdempotencyRecord(ctx context.Context, rec IdempotencyRecord) error {
	if _, err := q.requireTenantTx(ctx, rec.WorkspaceID); err != nil {
		return err
	}
	payload := rec.ResponsePayload
	if len(payload) == 0 {
		payload = []byte(`{}`)
	}
	_, err := q.db.Exec(
		ctx,
		upsertCompletedIdempotencyRecordSQL,
		rec.RecordID,
		rec.WorkspaceID,
		rec.ActorID,
		rec.RPC,
		rec.IdempotencyKey,
		rec.RequestHash,
		payload,
		rec.ResponseCode,
		rec.ExpiresAt,
	)
	return err
}

// SupportTicketMessageRow models a tenant-visible support ticket message.
// Internal admin notes (`is_internal_note = true`) are excluded by both RLS and projection query.
type SupportTicketMessageRow struct {
	WorkspaceID    string
	MessageID      string
	TicketID       string
	AuthorType     string
	AuthorID       string
	Body           string
	Attachments    json.RawMessage
	IsInternalNote bool
	CreatedAt      time.Time
}

const listSupportTicketMessagesTenantSafeSQL = `
SELECT
  workspace_id::text, message_id::text, ticket_id::text,
  author_type, COALESCE(author_id::text, ''), body,
  COALESCE(attachments, '[]'::jsonb), is_internal_note, created_at
FROM support_ticket_messages
WHERE workspace_id = $1::uuid
  AND ticket_id = $2::uuid
  AND is_internal_note = false
ORDER BY created_at ASC, message_id ASC
`

// ListSupportTicketMessages returns non-internal support ticket messages for a tenant ticket inside WithTx.
func (q *Queries) ListSupportTicketMessages(ctx context.Context, workspaceID, ticketID string) ([]SupportTicketMessageRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return nil, err
	}
	rows, err := q.db.Query(ctx, listSupportTicketMessagesTenantSafeSQL, workspaceID, ticketID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []SupportTicketMessageRow
	for rows.Next() {
		var r SupportTicketMessageRow
		if err := rows.Scan(
			&r.WorkspaceID,
			&r.MessageID,
			&r.TicketID,
			&r.AuthorType,
			&r.AuthorID,
			&r.Body,
			&r.Attachments,
			&r.IsInternalNote,
			&r.CreatedAt,
		); err != nil {
			return nil, err
		}
		if r.IsInternalNote {
			return nil, fmt.Errorf("tenantdb: internal note leaked in tenant query")
		}
		out = append(out, r)
	}
	return out, rows.Err()
}

// InsertTrendSignal inserts a direct-junction trend_signals row inside WithTx.
func (q *Queries) InsertTrendSignal(ctx context.Context, workspaceID, trendID, signalID string) error {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return err
	}
	_, err := q.db.Exec(ctx, `
		INSERT INTO trend_signals (workspace_id, trend_id, signal_id)
		VALUES ($1::uuid, $2::uuid, $3::uuid)
	`, workspaceID, trendID, signalID)
	return err
}

// InsertOpportunitySource inserts a direct-junction opportunity_sources row inside WithTx.
func (q *Queries) InsertOpportunitySource(ctx context.Context, workspaceID, opportunityID, sourceType, sourceID string) error {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return err
	}
	_, err := q.db.Exec(ctx, `
		INSERT INTO opportunity_sources (workspace_id, opportunity_id, source_type, source_id)
		VALUES ($1::uuid, $2::uuid, $3, $4::uuid)
	`, workspaceID, opportunityID, sourceType, sourceID)
	return err
}

// InsertIdeaSource inserts a direct-junction idea_sources row inside WithTx.
func (q *Queries) InsertIdeaSource(ctx context.Context, workspaceID, ideaID, sourceType, sourceID string) error {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return err
	}
	_, err := q.db.Exec(ctx, `
		INSERT INTO idea_sources (workspace_id, idea_id, source_type, source_id)
		VALUES ($1::uuid, $2::uuid, $3, $4::uuid)
	`, workspaceID, ideaID, sourceType, sourceID)
	return err
}

// InsertTaggable inserts a direct-junction taggables row inside WithTx.
func (q *Queries) InsertTaggable(ctx context.Context, workspaceID, tagID, taggableType, taggableID string) error {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return err
	}
	_, err := q.db.Exec(ctx, `
		INSERT INTO taggables (workspace_id, tag_id, taggable_type, taggable_id)
		VALUES ($1::uuid, $2::uuid, $3, $4::uuid)
	`, workspaceID, tagID, taggableType, taggableID)
	return err
}

// InsertBundleItem inserts a direct-junction bundle_items row inside WithTx.
func (q *Queries) InsertBundleItem(ctx context.Context, workspaceID, bundleID, productID string, quantity int) error {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return err
	}
	_, err := q.db.Exec(ctx, `
		INSERT INTO bundle_items (workspace_id, bundle_id, product_id, quantity)
		VALUES ($1::uuid, $2::uuid, $3::uuid, $4)
	`, workspaceID, bundleID, productID, quantity)
	return err
}

// =============================================================================
// P0-05: Outbox, Consumer Inbox, External Effects, Diagnostics & DLQ Queries
// =============================================================================

// EnqueueOutboxEventParams defines parameters for appending a canonical DomainEvent to event_outbox.
type EnqueueOutboxEventParams struct {
	EventID       string
	EventType     string
	TargetStream  string
	AggregateType string
	AggregateID   string
	WorkspaceID   string
	Payload       []byte
	Metadata      []byte
}

const enqueueOutboxEventSQL = `
INSERT INTO event_outbox (
  event_id, event_type, target_stream, aggregate_type, aggregate_id,
  workspace_id, payload, metadata
) VALUES (
  $1::uuid, $2, $3, $4, $5::uuid,
  $6::uuid, $7::jsonb, $8::jsonb
)
`

// EnqueueOutboxEvent appends an unpublished event to event_outbox inside the current tenant transaction.
// Note: app_user has INSERT (and sequence USAGE/SELECT) on event_outbox, never SELECT/UPDATE/DELETE.
func (q *Queries) EnqueueOutboxEvent(ctx context.Context, arg EnqueueOutboxEventParams) error {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return err
	}
	if !IsValidNonZeroUUID(arg.EventID) || !IsValidNonZeroUUID(arg.AggregateID) {
		return ErrInvalidTenantScope
	}
	payload := arg.Payload
	if len(payload) == 0 {
		payload = []byte(`{}`)
	}
	meta := arg.Metadata
	if len(meta) == 0 {
		meta = []byte(`{}`)
	}
	_, err := q.db.Exec(
		ctx,
		enqueueOutboxEventSQL,
		arg.EventID,
		arg.EventType,
		arg.TargetStream,
		arg.AggregateType,
		arg.AggregateID,
		arg.WorkspaceID,
		payload,
		meta,
	)
	return err
}

const tryInsertConsumerInboxSQL = `
INSERT INTO consumer_inbox (
  inbox_id, workspace_id, consumer_name, event_id
) VALUES (
  $1::uuid, $2::uuid, $3, $4::uuid
)
ON CONFLICT (workspace_id, consumer_name, event_id) DO NOTHING
`

// TryInsertConsumerInbox atomically records consumer inbox processing inside WithTx.
// Returns (true, nil) when the event is newly claimed, or (false, nil) if already processed.
func (q *Queries) TryInsertConsumerInbox(ctx context.Context, inboxID, workspaceID, consumerName, eventID string) (bool, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return false, err
	}
	if !IsValidNonZeroUUID(inboxID) || !IsValidNonZeroUUID(eventID) {
		return false, ErrInvalidTenantScope
	}
	tag, err := q.db.Exec(ctx, tryInsertConsumerInboxSQL, inboxID, workspaceID, consumerName, eventID)
	if err != nil {
		return false, err
	}
	return tag.RowsAffected() == 1, nil
}

// ExternalEffectRow models a row in external_effects (§26.8).
type ExternalEffectRow struct {
	EffectID           string
	WorkspaceID        string
	OperationKey       string
	Provider           string
	ConnectedAccountID string
	AggregateType      string
	AggregateID        string
	ProviderRequestID  string
	Status             string
	ResultPayload      json.RawMessage
	LastCheckedAt      *time.Time
	CreatedAt          time.Time
	UpdatedAt          time.Time
}

// PrepareExternalEffectParams defines parameters for preparing an external effect row.
type PrepareExternalEffectParams struct {
	EffectID           string
	WorkspaceID        string
	OperationKey       string
	Provider           string
	ConnectedAccountID string
	AggregateType      string
	AggregateID        string
}

const getExternalEffectByOperationKeyForUpdateSQL = `
SELECT
  effect_id::text, workspace_id::text, operation_key, provider,
  COALESCE(connected_account_id::text, ''), aggregate_type, aggregate_id::text,
  COALESCE(provider_request_id, ''), status, COALESCE(result_payload, '{}'::jsonb),
  last_checked_at, created_at, updated_at
FROM external_effects
WHERE workspace_id = $1::uuid
  AND operation_key = $2
FOR UPDATE
`

// GetExternalEffectForUpdate locks and returns an external_effects row by operation_key inside WithTx.
func (q *Queries) GetExternalEffectForUpdate(ctx context.Context, workspaceID, operationKey string) (ExternalEffectRow, bool, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return ExternalEffectRow{}, false, err
	}
	var row ExternalEffectRow
	err := q.db.QueryRow(ctx, getExternalEffectByOperationKeyForUpdateSQL, workspaceID, operationKey).Scan(
		&row.EffectID,
		&row.WorkspaceID,
		&row.OperationKey,
		&row.Provider,
		&row.ConnectedAccountID,
		&row.AggregateType,
		&row.AggregateID,
		&row.ProviderRequestID,
		&row.Status,
		&row.ResultPayload,
		&row.LastCheckedAt,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return ExternalEffectRow{}, false, nil
		}
		return ExternalEffectRow{}, false, err
	}
	return row, true, nil
}

const insertExternalEffectSQL = `
INSERT INTO external_effects (
  effect_id, workspace_id, operation_key, provider, connected_account_id,
  aggregate_type, aggregate_id, status, result_payload
) VALUES (
  $1::uuid, $2::uuid, $3, $4, NULLIF($5, '')::uuid,
  $6, $7::uuid, 'prepared', '{}'::jsonb
)
RETURNING
  effect_id::text, workspace_id::text, operation_key, provider,
  COALESCE(connected_account_id::text, ''), aggregate_type, aggregate_id::text,
  COALESCE(provider_request_id, ''), status, COALESCE(result_payload, '{}'::jsonb),
  last_checked_at, created_at, updated_at
`

// InsertPreparedExternalEffect inserts a new 'prepared' external_effects row inside WithTx.
func (q *Queries) InsertPreparedExternalEffect(ctx context.Context, arg PrepareExternalEffectParams) (ExternalEffectRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return ExternalEffectRow{}, err
	}
	if !IsValidNonZeroUUID(arg.EffectID) || !IsValidNonZeroUUID(arg.AggregateID) {
		return ExternalEffectRow{}, ErrInvalidTenantScope
	}
	var row ExternalEffectRow
	err := q.db.QueryRow(
		ctx,
		insertExternalEffectSQL,
		arg.EffectID,
		arg.WorkspaceID,
		arg.OperationKey,
		arg.Provider,
		arg.ConnectedAccountID,
		arg.AggregateType,
		arg.AggregateID,
	).Scan(
		&row.EffectID,
		&row.WorkspaceID,
		&row.OperationKey,
		&row.Provider,
		&row.ConnectedAccountID,
		&row.AggregateType,
		&row.AggregateID,
		&row.ProviderRequestID,
		&row.Status,
		&row.ResultPayload,
		&row.LastCheckedAt,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	return row, err
}

// UpdateExternalEffectStatusParams defines parameters for transitioning an external_effects row.
type UpdateExternalEffectStatusParams struct {
	WorkspaceID       string
	OperationKey      string
	Status            string
	ProviderRequestID string
	ResultPayload     []byte
}

const updateExternalEffectStatusSQL = `
UPDATE external_effects
SET
  status = $3,
  provider_request_id = COALESCE(NULLIF($4, ''), provider_request_id),
  result_payload = COALESCE($5::jsonb, result_payload),
  last_checked_at = NOW(),
  updated_at = NOW()
WHERE workspace_id = $1::uuid
  AND operation_key = $2
RETURNING
  effect_id::text, workspace_id::text, operation_key, provider,
  COALESCE(connected_account_id::text, ''), aggregate_type, aggregate_id::text,
  COALESCE(provider_request_id, ''), status, COALESCE(result_payload, '{}'::jsonb),
  last_checked_at, created_at, updated_at
`

// UpdateExternalEffectStatus updates an external_effects row inside WithTx.
func (q *Queries) UpdateExternalEffectStatus(ctx context.Context, arg UpdateExternalEffectStatusParams) (ExternalEffectRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return ExternalEffectRow{}, err
	}
	payload := arg.ResultPayload
	if len(payload) == 0 {
		payload = []byte(`{}`)
	}
	var row ExternalEffectRow
	err := q.db.QueryRow(
		ctx,
		updateExternalEffectStatusSQL,
		arg.WorkspaceID,
		arg.OperationKey,
		arg.Status,
		arg.ProviderRequestID,
		payload,
	).Scan(
		&row.EffectID,
		&row.WorkspaceID,
		&row.OperationKey,
		&row.Provider,
		&row.ConnectedAccountID,
		&row.AggregateType,
		&row.AggregateID,
		&row.ProviderRequestID,
		&row.Status,
		&row.ResultPayload,
		&row.LastCheckedAt,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	return row, err
}

// DiagnosticRecordRow models a row in diagnostics_records (§13.4).
type DiagnosticRecordRow struct {
	DiagnosticsID         string
	WorkspaceID           string
	ScopeType             string
	ScopeID               string
	ErrorType             string
	Severity              string
	UserFacingExplanation string
	OperatorExplanation   string
	LikelyCauses          []string
	SuggestedActions      []string
	RepairPath            string
	Status                string
	DetectedAt            time.Time
	ResolvedAt            *time.Time
	CreatedAt             time.Time
	UpdatedAt             time.Time
}

// InsertDiagnosticRecordParams defines parameters for inserting a diagnostics_records row.
type InsertDiagnosticRecordParams struct {
	DiagnosticsID         string
	WorkspaceID           string
	ScopeType             string
	ScopeID               string
	ErrorType             string
	Severity              string
	UserFacingExplanation string
	OperatorExplanation   string
	LikelyCauses          []string
	SuggestedActions      []string
	RepairPath            string
	Status                string
}

const insertDiagnosticRecordSQL = `
INSERT INTO diagnostics_records (
  diagnostics_id, workspace_id, scope_type, scope_id, error_type,
  severity, user_facing_explanation, operator_explanation,
  likely_causes, suggested_actions, repair_path, status
) VALUES (
  $1::uuid, $2::uuid, $3, NULLIF($4, '')::uuid, $5,
  $6, $7, $8,
  $9::jsonb, $10::jsonb, $11, $12
)
RETURNING
  diagnostics_id::text, workspace_id::text, scope_type, COALESCE(scope_id::text, ''),
  error_type, severity, user_facing_explanation, COALESCE(operator_explanation, ''),
  COALESCE(likely_causes, '[]'::jsonb), COALESCE(suggested_actions, '[]'::jsonb),
  COALESCE(repair_path, ''), status, detected_at, resolved_at, created_at, updated_at
`

// InsertDiagnosticRecord inserts a diagnostics_records row inside WithTx.
func (q *Queries) InsertDiagnosticRecord(ctx context.Context, arg InsertDiagnosticRecordParams) (DiagnosticRecordRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return DiagnosticRecordRow{}, err
	}
	if !IsValidNonZeroUUID(arg.DiagnosticsID) {
		return DiagnosticRecordRow{}, ErrInvalidTenantScope
	}
	causesJSON, err := json.Marshal(arg.LikelyCauses)
	if err != nil || len(arg.LikelyCauses) == 0 {
		causesJSON = []byte(`[]`)
	}
	actionsJSON, err := json.Marshal(arg.SuggestedActions)
	if err != nil || len(arg.SuggestedActions) == 0 {
		actionsJSON = []byte(`[]`)
	}
	status := arg.Status
	if status == "" {
		status = "open"
	}
	var row DiagnosticRecordRow
	var rawCauses, rawActions []byte
	err = q.db.QueryRow(
		ctx,
		insertDiagnosticRecordSQL,
		arg.DiagnosticsID,
		arg.WorkspaceID,
		arg.ScopeType,
		arg.ScopeID,
		arg.ErrorType,
		arg.Severity,
		arg.UserFacingExplanation,
		arg.OperatorExplanation,
		causesJSON,
		actionsJSON,
		arg.RepairPath,
		status,
	).Scan(
		&row.DiagnosticsID,
		&row.WorkspaceID,
		&row.ScopeType,
		&row.ScopeID,
		&row.ErrorType,
		&row.Severity,
		&row.UserFacingExplanation,
		&row.OperatorExplanation,
		&rawCauses,
		&rawActions,
		&row.RepairPath,
		&row.Status,
		&row.DetectedAt,
		&row.ResolvedAt,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	if err != nil {
		return DiagnosticRecordRow{}, err
	}
	_ = json.Unmarshal(rawCauses, &row.LikelyCauses)
	_ = json.Unmarshal(rawActions, &row.SuggestedActions)
	return row, nil
}

const listDiagnosticRecordsSQL = `
SELECT
  diagnostics_id::text, workspace_id::text, scope_type, COALESCE(scope_id::text, ''),
  error_type, severity, user_facing_explanation, COALESCE(operator_explanation, ''),
  COALESCE(likely_causes, '[]'::jsonb), COALESCE(suggested_actions, '[]'::jsonb),
  COALESCE(repair_path, ''), status, detected_at, resolved_at, created_at, updated_at
FROM diagnostics_records
WHERE workspace_id = $1::uuid
ORDER BY detected_at DESC, diagnostics_id ASC
`

// ListDiagnosticRecords lists diagnostics_records for a tenant workspace inside WithTx.
func (q *Queries) ListDiagnosticRecords(ctx context.Context, workspaceID string) ([]DiagnosticRecordRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return nil, err
	}
	rows, err := q.db.Query(ctx, listDiagnosticRecordsSQL, workspaceID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []DiagnosticRecordRow
	for rows.Next() {
		var row DiagnosticRecordRow
		var rawCauses, rawActions []byte
		if err := rows.Scan(
			&row.DiagnosticsID,
			&row.WorkspaceID,
			&row.ScopeType,
			&row.ScopeID,
			&row.ErrorType,
			&row.Severity,
			&row.UserFacingExplanation,
			&row.OperatorExplanation,
			&rawCauses,
			&rawActions,
			&row.RepairPath,
			&row.Status,
			&row.DetectedAt,
			&row.ResolvedAt,
			&row.CreatedAt,
			&row.UpdatedAt,
		); err != nil {
			return nil, err
		}
		_ = json.Unmarshal(rawCauses, &row.LikelyCauses)
		_ = json.Unmarshal(rawActions, &row.SuggestedActions)
		out = append(out, row)
	}
	return out, rows.Err()
}

const updateDiagnosticRecordStatusSQL = `
UPDATE diagnostics_records
SET
  status = $3,
  resolved_at = CASE WHEN $3 IN ('resolved', 'closed') THEN NOW() ELSE resolved_at END,
  updated_at = NOW()
WHERE workspace_id = $1::uuid
  AND diagnostics_id = $2::uuid
RETURNING
  diagnostics_id::text, workspace_id::text, scope_type, COALESCE(scope_id::text, ''),
  error_type, severity, user_facing_explanation, COALESCE(operator_explanation, ''),
  COALESCE(likely_causes, '[]'::jsonb), COALESCE(suggested_actions, '[]'::jsonb),
  COALESCE(repair_path, ''), status, detected_at, resolved_at, created_at, updated_at
`

// UpdateDiagnosticRecordStatus updates the status of a diagnostics_records row inside WithTx.
func (q *Queries) UpdateDiagnosticRecordStatus(ctx context.Context, workspaceID, diagnosticsID, status string) (DiagnosticRecordRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return DiagnosticRecordRow{}, err
	}
	var row DiagnosticRecordRow
	var rawCauses, rawActions []byte
	err := q.db.QueryRow(ctx, updateDiagnosticRecordStatusSQL, workspaceID, diagnosticsID, status).Scan(
		&row.DiagnosticsID,
		&row.WorkspaceID,
		&row.ScopeType,
		&row.ScopeID,
		&row.ErrorType,
		&row.Severity,
		&row.UserFacingExplanation,
		&row.OperatorExplanation,
		&rawCauses,
		&rawActions,
		&row.RepairPath,
		&row.Status,
		&row.DetectedAt,
		&row.ResolvedAt,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	if err != nil {
		return DiagnosticRecordRow{}, err
	}
	_ = json.Unmarshal(rawCauses, &row.LikelyCauses)
	_ = json.Unmarshal(rawActions, &row.SuggestedActions)
	return row, nil
}

// =============================================================================
// P0-07: Capability Snapshots, Policy Notes, Fallback Paths & Health Scores
// =============================================================================

// CapabilitySnapshotRow models a row in capability_snapshots (§18.2).
type CapabilitySnapshotRow struct {
	SnapshotID           string
	WorkspaceID          string
	Platform             string
	CapabilityKey        string
	State                string
	Reason               string
	FallbackType         string
	FallbackInstructions string
	PolicyNote           string
	CheckedAt            time.Time
	ValidUntil           *time.Time
	CreatedAt            time.Time
}

// InsertCapabilitySnapshotParams defines parameters for inserting a capability_snapshots row.
type InsertCapabilitySnapshotParams struct {
	SnapshotID           string
	WorkspaceID          string
	Platform             string
	CapabilityKey        string
	State                string
	Reason               string
	FallbackType         string
	FallbackInstructions string
	PolicyNote           string
	CheckedAt            time.Time
	ValidUntil           *time.Time
}

const insertCapabilitySnapshotSQL = `
INSERT INTO capability_snapshots (
  snapshot_id, workspace_id, platform, capability_key, state,
  reason, fallback_type, fallback_instructions, policy_note,
  checked_at, valid_until
) VALUES (
  $1::uuid, $2::uuid, $3, $4, $5::capability_state,
  $6, $7, $8, $9,
  $10, $11
)
RETURNING
  snapshot_id::text, workspace_id::text, platform, capability_key, state::text,
  COALESCE(reason, ''), COALESCE(fallback_type, ''), COALESCE(fallback_instructions, ''),
  COALESCE(policy_note, ''), checked_at, valid_until, created_at
`

// InsertCapabilitySnapshot inserts a capability_snapshots row inside WithTx.
func (q *Queries) InsertCapabilitySnapshot(ctx context.Context, arg InsertCapabilitySnapshotParams) (CapabilitySnapshotRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return CapabilitySnapshotRow{}, err
	}
	if !IsValidNonZeroUUID(arg.SnapshotID) {
		return CapabilitySnapshotRow{}, ErrInvalidTenantScope
	}
	checkedAt := arg.CheckedAt
	if checkedAt.IsZero() {
		checkedAt = time.Now().UTC()
	}
	var row CapabilitySnapshotRow
	err := q.db.QueryRow(
		ctx,
		insertCapabilitySnapshotSQL,
		arg.SnapshotID,
		arg.WorkspaceID,
		arg.Platform,
		arg.CapabilityKey,
		arg.State,
		arg.Reason,
		arg.FallbackType,
		arg.FallbackInstructions,
		arg.PolicyNote,
		checkedAt,
		arg.ValidUntil,
	).Scan(
		&row.SnapshotID,
		&row.WorkspaceID,
		&row.Platform,
		&row.CapabilityKey,
		&row.State,
		&row.Reason,
		&row.FallbackType,
		&row.FallbackInstructions,
		&row.PolicyNote,
		&row.CheckedAt,
		&row.ValidUntil,
		&row.CreatedAt,
	)
	return row, err
}

// PolicyNoteRow models a row in policy_notes (§18.2B).
type PolicyNoteRow struct {
	PolicyNoteID  string
	WorkspaceID   string
	Platform      string
	CapabilityKey string
	Summary       string
	Detail        string
	SourceURL     string
	EffectiveDate *time.Time
	UpdatedAt     time.Time
	CreatedAt     time.Time
}

// InsertPolicyNoteParams defines parameters for inserting a policy_notes row.
type InsertPolicyNoteParams struct {
	PolicyNoteID  string
	WorkspaceID   string
	Platform      string
	CapabilityKey string
	Summary       string
	Detail        string
	SourceURL     string
	EffectiveDate *time.Time
}

const insertPolicyNoteSQL = `
INSERT INTO policy_notes (
  policy_note_id, workspace_id, platform, capability_key,
  summary, detail, source_url, effective_date
) VALUES (
  $1::uuid, $2::uuid, $3, $4,
  $5, $6, $7, $8
)
RETURNING
  policy_note_id::text, workspace_id::text, platform, capability_key,
  summary, COALESCE(detail, ''), COALESCE(source_url, ''), effective_date,
  updated_at, created_at
`

// InsertPolicyNote inserts a policy_notes row inside WithTx.
func (q *Queries) InsertPolicyNote(ctx context.Context, arg InsertPolicyNoteParams) (PolicyNoteRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return PolicyNoteRow{}, err
	}
	if !IsValidNonZeroUUID(arg.PolicyNoteID) {
		return PolicyNoteRow{}, ErrInvalidTenantScope
	}
	var row PolicyNoteRow
	err := q.db.QueryRow(
		ctx,
		insertPolicyNoteSQL,
		arg.PolicyNoteID,
		arg.WorkspaceID,
		arg.Platform,
		arg.CapabilityKey,
		arg.Summary,
		arg.Detail,
		arg.SourceURL,
		arg.EffectiveDate,
	).Scan(
		&row.PolicyNoteID,
		&row.WorkspaceID,
		&row.Platform,
		&row.CapabilityKey,
		&row.Summary,
		&row.Detail,
		&row.SourceURL,
		&row.EffectiveDate,
		&row.UpdatedAt,
		&row.CreatedAt,
	)
	return row, err
}

// FallbackPathRow models a row in fallback_paths (§18.2C).
type FallbackPathRow struct {
	FallbackPathID      string
	WorkspaceID         string
	Platform            string
	CapabilityKey       string
	FallbackType        string
	Instructions        string
	EstimatedEffort     string
	RelatedPolicyNoteID string
	IsActive            bool
	CreatedAt           time.Time
	UpdatedAt           time.Time
}

// InsertFallbackPathParams defines parameters for inserting a fallback_paths row.
type InsertFallbackPathParams struct {
	FallbackPathID      string
	WorkspaceID         string
	Platform            string
	CapabilityKey       string
	FallbackType        string
	Instructions        string
	EstimatedEffort     string
	RelatedPolicyNoteID string
	IsActive            bool
}

const insertFallbackPathSQL = `
INSERT INTO fallback_paths (
  fallback_path_id, workspace_id, platform, capability_key,
  fallback_type, instructions, estimated_effort, related_policy_note_id, is_active
) VALUES (
  $1::uuid, $2::uuid, $3, $4,
  $5, $6, $7, NULLIF($8, '')::uuid, $9
)
RETURNING
  fallback_path_id::text, workspace_id::text, platform, capability_key,
  fallback_type, instructions, COALESCE(estimated_effort, ''),
  COALESCE(related_policy_note_id::text, ''), is_active, created_at, updated_at
`

// InsertFallbackPath inserts a fallback_paths row inside WithTx.
func (q *Queries) InsertFallbackPath(ctx context.Context, arg InsertFallbackPathParams) (FallbackPathRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return FallbackPathRow{}, err
	}
	if !IsValidNonZeroUUID(arg.FallbackPathID) {
		return FallbackPathRow{}, ErrInvalidTenantScope
	}
	var row FallbackPathRow
	err := q.db.QueryRow(
		ctx,
		insertFallbackPathSQL,
		arg.FallbackPathID,
		arg.WorkspaceID,
		arg.Platform,
		arg.CapabilityKey,
		arg.FallbackType,
		arg.Instructions,
		arg.EstimatedEffort,
		arg.RelatedPolicyNoteID,
		arg.IsActive,
	).Scan(
		&row.FallbackPathID,
		&row.WorkspaceID,
		&row.Platform,
		&row.CapabilityKey,
		&row.FallbackType,
		&row.Instructions,
		&row.EstimatedEffort,
		&row.RelatedPolicyNoteID,
		&row.IsActive,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	return row, err
}

// PlatformHealthScoreRow models a row in platform_health_scores (§22.15).
type PlatformHealthScoreRow struct {
	HealthScoreID      string
	WorkspaceID        string
	ConnectedAccountID string
	Platform           string
	OverallScore       int
	Dimensions         json.RawMessage
	RiskFlags          json.RawMessage
	Recommendations    json.RawMessage
	SnapshotDate       time.Time
	CreatedAt          time.Time
}

// UpsertPlatformHealthScoreParams defines parameters for upserting a platform_health_scores row.
type UpsertPlatformHealthScoreParams struct {
	HealthScoreID      string
	WorkspaceID        string
	ConnectedAccountID string
	Platform           string
	OverallScore       int
	Dimensions         json.RawMessage
	RiskFlags          json.RawMessage
	Recommendations    json.RawMessage
	SnapshotDate       time.Time
}

const upsertPlatformHealthScoreSQL = `
INSERT INTO platform_health_scores (
  health_score_id, workspace_id, connected_account_id, platform,
  overall_score, dimensions, risk_flags, recommendations, snapshot_date
) VALUES (
  $1::uuid, $2::uuid, $3::uuid, $4,
  $5, $6::jsonb, $7::jsonb, $8::jsonb, $9::date
)
ON CONFLICT (connected_account_id, snapshot_date) DO UPDATE SET
  overall_score = EXCLUDED.overall_score,
  dimensions = EXCLUDED.dimensions,
  risk_flags = EXCLUDED.risk_flags,
  recommendations = EXCLUDED.recommendations
RETURNING
  health_score_id::text, workspace_id::text, connected_account_id::text, platform,
  overall_score, COALESCE(dimensions, '{}'::jsonb), COALESCE(risk_flags, '[]'::jsonb),
  COALESCE(recommendations, '[]'::jsonb), snapshot_date, created_at
`

// UpsertPlatformHealthScore inserts or updates a daily platform_health_scores row inside WithTx.
func (q *Queries) UpsertPlatformHealthScore(ctx context.Context, arg UpsertPlatformHealthScoreParams) (PlatformHealthScoreRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return PlatformHealthScoreRow{}, err
	}
	if !IsValidNonZeroUUID(arg.HealthScoreID) || !IsValidNonZeroUUID(arg.ConnectedAccountID) {
		return PlatformHealthScoreRow{}, ErrInvalidTenantScope
	}
	dims := arg.Dimensions
	if len(dims) == 0 {
		dims = []byte(`{}`)
	}
	flags := arg.RiskFlags
	if len(flags) == 0 {
		flags = []byte(`[]`)
	}
	recs := arg.Recommendations
	if len(recs) == 0 {
		recs = []byte(`[]`)
	}
	snapDate := arg.SnapshotDate
	if snapDate.IsZero() {
		snapDate = time.Now().UTC()
	}
	var row PlatformHealthScoreRow
	err := q.db.QueryRow(
		ctx,
		upsertPlatformHealthScoreSQL,
		arg.HealthScoreID,
		arg.WorkspaceID,
		arg.ConnectedAccountID,
		arg.Platform,
		arg.OverallScore,
		dims,
		flags,
		recs,
		snapDate.Format("2006-01-02"),
	).Scan(
		&row.HealthScoreID,
		&row.WorkspaceID,
		&row.ConnectedAccountID,
		&row.Platform,
		&row.OverallScore,
		&row.Dimensions,
		&row.RiskFlags,
		&row.Recommendations,
		&row.SnapshotDate,
		&row.CreatedAt,
	)
	return row, err
}
