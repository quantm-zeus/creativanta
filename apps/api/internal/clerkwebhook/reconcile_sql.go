package clerkwebhook

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"time"
)

var (
	// ErrUnknownOrganization is returned when a webhook references a Clerk
	// organization ID that does not map to an existing active workspace.
	// Per docs/02_features/platform/auth.md, webhooks must never auto-create
	// an arbitrary workspace from an unrecognized organization ID.
	ErrUnknownOrganization = errors.New("clerkwebhook: unrecognized clerk_organization_id")
	// ErrUnknownUser is returned when a membership or invitation webhook
	// references a user that does not exist or is not active in canonical users.
	ErrUnknownUser = errors.New("clerkwebhook: unrecognized or inactive clerk user")
	// ErrOwnerProtected is returned when a webhook attempts to remove or demote
	// the workspace's active owner or create a second active owner without an
	// atomic owner-transfer command (database_schema.md §26.14).
	ErrOwnerProtected = errors.New("clerkwebhook: workspace owner invariant protected")
	// ErrGlobalDedupeUnavailable is returned when processing a global user or
	// session webhook without a durable global delivery claimer (webhook_events
	// in database_schema.md §18.4C requires a non-null workspace_id; P0-04/P0-05
	// own migration/inbox readiness).
	ErrGlobalDedupeUnavailable = fmt.Errorf("%w: durable global webhook deduplication not configured", ErrNotConfigured)
)

// SQLRunner is satisfied by *sql.DB and *sql.Tx.
type SQLRunner interface {
	ExecContext(ctx context.Context, query string, args ...any) (sql.Result, error)
	QueryRowContext(ctx context.Context, query string, args ...any) *sql.Row
}

// AuthoritativeMembershipState represents live provider membership state fetched
// when webhook update/deletion ordering is ambiguous.
type AuthoritativeMembershipState struct {
	Active          bool
	Role            string
	SourceUpdatedAt time.Time
}

// AuthoritativeMembershipChecker queries Clerk's authoritative organization
// membership state when out-of-order or equal-timestamp events are ambiguous.
type AuthoritativeMembershipChecker interface {
	FetchMembershipState(ctx context.Context, clerkOrgID, clerkUserID string) (AuthoritativeMembershipState, error)
}

// GlobalDeliveryClaimer atomically claims a global (non-workspace) webhook
// delivery ID in durable SQL storage. Never implement this with an ephemeral
// in-memory map in production.
type GlobalDeliveryClaimer interface {
	ClaimGlobalDelivery(ctx context.Context, db SQLRunner, evt VerifiedEvent) (claimed bool, err error)
}

// GlobalDeliveryReleaser optionally releases a previously claimed global delivery
// when downstream event processing fails so the delivery remains retryable.
type GlobalDeliveryReleaser interface {
	ReleaseGlobalDelivery(ctx context.Context, db SQLRunner, evt VerifiedEvent) error
}

// SQLTxBeginner is implemented by *sql.DB to wrap webhook deduplication and
// state reconciliation in an atomic database transaction.
type SQLTxBeginner interface {
	BeginTx(ctx context.Context, opts *sql.TxOptions) (*sql.Tx, error)
}

// SessionRevocationRecorder records provider session termination events
// (session.ended, session.revoked) so active session verifiers immediately
// reject terminated sessions even before short-lived JWT expiry.
type SessionRevocationRecorder interface {
	RevokeSession(subject, sessionID string)
}

// SQLReconciler reconciles verified Clerk webhook events against canonical
// PostgreSQL tables (users, workspaces, workspace_members, webhook_events).
type SQLReconciler struct {
	DB                      SQLRunner
	GlobalDeliveries        GlobalDeliveryClaimer
	AuthoritativeMembership AuthoritativeMembershipChecker
	SessionRevocations      SessionRevocationRecorder
}

const (
	resolveWorkspaceByClerkOrgQuery = `
SELECT workspace_id::text, owner_user_id::text
FROM workspaces
WHERE clerk_organization_id = $1
  AND status = 'active'
  AND deleted_at IS NULL
LIMIT 1`

	claimWorkspaceWebhookDeliveryQuery = `
INSERT INTO webhook_events (
  workspace_id,
  provider,
  direction,
  external_event_id,
  idempotency_key,
  payload,
  processing_status,
  received_at,
  processed_at
) VALUES (
  $1::uuid,
  'clerk',
  'inbound',
  $2,
  $2,
  $3::jsonb,
  'processed',
  $4,
  NOW()
)
ON CONFLICT (provider, idempotency_key) DO NOTHING
RETURNING webhook_event_id::text`

	unclaimWorkspaceWebhookDeliveryQuery = `
DELETE FROM webhook_events
WHERE workspace_id = $1::uuid
  AND provider = 'clerk'
  AND idempotency_key = $2`

	resolveActiveUserByClerkIDQuery = `
SELECT user_id::text
FROM users
WHERE clerk_id = $1
  AND status = 'active'
LIMIT 1`

	resolveActiveUserByEmailQuery = `
SELECT user_id::text, clerk_id
FROM users
WHERE lower(email) = lower($1)
  AND status = 'active'
LIMIT 1`

	selectExistingMembershipQuery = `
SELECT status, role, source_updated_at
FROM workspace_members
WHERE workspace_id = $1::uuid
  AND user_id = $2::uuid
LIMIT 1`

	insertWorkspaceMemberQuery = `
INSERT INTO workspace_members (
  clerk_membership_id,
  source_updated_at,
  workspace_id,
  user_id,
  role,
  status,
  joined_at,
  created_at,
  updated_at
) VALUES (
  NULLIF($1, ''),
  $2,
  $3::uuid,
  $4::uuid,
  $5,
  'active',
  NOW(),
  NOW(),
  NOW()
)
ON CONFLICT (workspace_id, user_id) DO UPDATE SET
  clerk_membership_id = COALESCE(EXCLUDED.clerk_membership_id, workspace_members.clerk_membership_id),
  role = EXCLUDED.role,
  status = 'active',
  source_updated_at = EXCLUDED.source_updated_at,
  updated_at = NOW()
WHERE workspace_members.status NOT IN ('revoked', 'suspended')
  AND (workspace_members.source_updated_at IS NULL OR workspace_members.source_updated_at <= EXCLUDED.source_updated_at)`

	markWorkspaceMemberRemovedQuery = `
UPDATE workspace_members
SET status = 'removed',
    clerk_membership_id = COALESCE(NULLIF($3, ''), clerk_membership_id),
    source_updated_at = $4,
    updated_at = NOW()
WHERE workspace_id = $1::uuid
  AND user_id = $2::uuid
  AND status NOT IN ('revoked', 'suspended')
  AND (source_updated_at IS NULL OR source_updated_at <= $4)`

	upsertCanonicalUserQuery = `
INSERT INTO users (
  clerk_id,
  source_updated_at,
  email,
  display_name,
  avatar_url,
  status,
  updated_at
) VALUES (
  $1,
  $2,
  $3,
  NULLIF($4, ''),
  NULLIF($5, ''),
  'active',
  NOW()
)
ON CONFLICT (clerk_id) DO UPDATE SET
  email = CASE
    WHEN users.source_updated_at IS NULL OR users.source_updated_at <= EXCLUDED.source_updated_at
    THEN EXCLUDED.email
    ELSE users.email
  END,
  display_name = CASE
    WHEN users.source_updated_at IS NULL OR users.source_updated_at <= EXCLUDED.source_updated_at
    THEN COALESCE(EXCLUDED.display_name, users.display_name)
    ELSE users.display_name
  END,
  avatar_url = CASE
    WHEN users.source_updated_at IS NULL OR users.source_updated_at <= EXCLUDED.source_updated_at
    THEN COALESCE(EXCLUDED.avatar_url, users.avatar_url)
    ELSE users.avatar_url
  END,
  source_updated_at = CASE
    WHEN users.source_updated_at IS NULL OR users.source_updated_at <= EXCLUDED.source_updated_at
    THEN EXCLUDED.source_updated_at
    ELSE users.source_updated_at
  END,
  updated_at = CASE
    WHEN users.source_updated_at IS NULL OR users.source_updated_at <= EXCLUDED.source_updated_at
    THEN NOW()
    ELSE users.updated_at
  END
WHERE users.status = 'active'
RETURNING user_id::text`

	suspendUserFromProviderQuery = `
UPDATE users
SET status = 'suspended',
    source_updated_at = $2,
    updated_at = NOW()
WHERE clerk_id = $1
  AND status != 'deleted'
  AND (source_updated_at IS NULL OR source_updated_at <= $2)`

	deleteUserFromProviderQuery = `
UPDATE users
SET status = 'deleted',
    source_updated_at = $2,
    updated_at = NOW()
WHERE clerk_id = $1
  AND (source_updated_at IS NULL OR source_updated_at <= $2)`

	updateUserLastLoginQuery = `
UPDATE users
SET last_login_at = GREATEST(COALESCE(last_login_at, $2), $2),
    updated_at = NOW()
WHERE clerk_id = $1
  AND status = 'active'`
)

// ProcessVerifiedEvent deduplicates and reconciles a verified Clerk event.
func (r *SQLReconciler) ProcessVerifiedEvent(ctx context.Context, evt VerifiedEvent) (ProcessResult, error) {
	if r == nil || r.DB == nil {
		return ProcessResult{}, ErrNotConfigured
	}
	if ctx == nil {
		return ProcessResult{}, ErrInvalidPayload
	}
	if err := ctx.Err(); err != nil {
		return ProcessResult{}, err
	}
	if !isValidClerkID(evt.DeliveryID, "msg_") || len(evt.RawPayload) == 0 {
		return ProcessResult{}, ErrInvalidPayload
	}

	if beginner, ok := r.DB.(SQLTxBeginner); ok {
		tx, err := beginner.BeginTx(ctx, nil)
		if err != nil {
			return ProcessResult{}, err
		}
		committed := false
		defer func() {
			if !committed {
				_ = tx.Rollback()
			}
		}()

		txReconciler := *r
		txReconciler.DB = tx
		res, err := txReconciler.processVerifiedEventWithRunner(ctx, evt)
		if err != nil {
			return ProcessResult{}, err
		}
		if err := tx.Commit(); err != nil {
			return ProcessResult{}, err
		}
		committed = true
		return res, nil
	}

	return r.processVerifiedEventWithRunner(ctx, evt)
}

func (r *SQLReconciler) processVerifiedEventWithRunner(ctx context.Context, evt VerifiedEvent) (ProcessResult, error) {
	switch evt.Type {
	case EventOrgMembershipCreated, EventOrgMembershipUpdated, EventOrgMembershipDeleted:
		if evt.Membership == nil {
			return ProcessResult{}, ErrInvalidPayload
		}
		return r.processMembershipEvent(ctx, evt, *evt.Membership)
	case EventOrgInvitationAccepted:
		if evt.Invitation == nil {
			return ProcessResult{}, ErrInvalidPayload
		}
		return r.processInvitationAcceptedEvent(ctx, evt, *evt.Invitation)
	case EventUserCreated, EventUserUpdated, EventUserDeleted:
		if evt.User == nil {
			return ProcessResult{}, ErrInvalidPayload
		}
		return r.processUserEvent(ctx, evt, *evt.User)
	case EventSessionCreated, EventSessionEnded, EventSessionRevoked:
		if evt.Session == nil {
			return ProcessResult{}, ErrInvalidPayload
		}
		return r.processSessionEvent(ctx, evt, *evt.Session)
	default:
		return ProcessResult{}, ErrUnsupportedEventType
	}
}

func (r *SQLReconciler) processMembershipEvent(ctx context.Context, evt VerifiedEvent, mem MembershipEventData) (ProcessResult, error) {
	workspaceID, ownerUserID, err := r.resolveWorkspaceByClerkOrg(ctx, mem.ClerkOrganizationID)
	if err != nil {
		return ProcessResult{}, err
	}

	claimed, err := r.claimWorkspaceDelivery(ctx, workspaceID, evt)
	if err != nil {
		return ProcessResult{}, err
	}
	if !claimed {
		return ProcessResult{Duplicate: true}, nil
	}

	userID, err := r.resolveActiveUserByClerkID(ctx, mem.ClerkUserID)
	if err != nil {
		_ = r.unclaimWorkspaceDelivery(ctx, workspaceID, evt.DeliveryID)
		return ProcessResult{}, err
	}

	if err := r.reconcileMembershipRow(ctx, evt.Type, workspaceID, ownerUserID, userID, mem); err != nil {
		_ = r.unclaimWorkspaceDelivery(ctx, workspaceID, evt.DeliveryID)
		return ProcessResult{}, err
	}
	return ProcessResult{}, nil
}

func (r *SQLReconciler) processInvitationAcceptedEvent(ctx context.Context, evt VerifiedEvent, inv InvitationEventData) (ProcessResult, error) {
	workspaceID, ownerUserID, err := r.resolveWorkspaceByClerkOrg(ctx, inv.ClerkOrganizationID)
	if err != nil {
		return ProcessResult{}, err
	}

	claimed, err := r.claimWorkspaceDelivery(ctx, workspaceID, evt)
	if err != nil {
		return ProcessResult{}, err
	}
	if !claimed {
		return ProcessResult{Duplicate: true}, nil
	}

	var userID, clerkUserID string
	err = r.DB.QueryRowContext(ctx, resolveActiveUserByEmailQuery, inv.Email).Scan(&userID, &clerkUserID)
	if errors.Is(err, sql.ErrNoRows) {
		_ = r.unclaimWorkspaceDelivery(ctx, workspaceID, evt.DeliveryID)
		return ProcessResult{}, ErrUnknownUser
	}
	if err != nil {
		_ = r.unclaimWorkspaceDelivery(ctx, workspaceID, evt.DeliveryID)
		return ProcessResult{}, err
	}

	mem := MembershipEventData{
		ClerkMembershipID:   "",
		ClerkOrganizationID: inv.ClerkOrganizationID,
		ClerkUserID:         clerkUserID,
		Role:                inv.Role,
		SourceUpdatedAt:     inv.SourceUpdatedAt,
	}
	if err := r.reconcileMembershipRow(ctx, EventOrgMembershipCreated, workspaceID, ownerUserID, userID, mem); err != nil {
		_ = r.unclaimWorkspaceDelivery(ctx, workspaceID, evt.DeliveryID)
		return ProcessResult{}, err
	}
	return ProcessResult{}, nil
}

func (r *SQLReconciler) reconcileMembershipRow(
	ctx context.Context,
	evtType EventType,
	workspaceID, ownerUserID, userID string,
	mem MembershipEventData,
) error {
	var existingStatus, existingRole string
	var existingUpdated sql.NullTime

	err := r.DB.QueryRowContext(ctx, selectExistingMembershipQuery, workspaceID, userID).
		Scan(&existingStatus, &existingRole, &existingUpdated)
	hasExisting := true
	if errors.Is(err, sql.ErrNoRows) {
		hasExisting = false
	} else if err != nil {
		return err
	}

	return r.reconcileMembershipRowState(ctx, evtType, workspaceID, ownerUserID, userID, hasExisting, existingStatus, existingRole, existingUpdated, mem)
}

func (r *SQLReconciler) reconcileMembershipRowState(
	ctx context.Context,
	evtType EventType,
	workspaceID, ownerUserID, userID string,
	hasExisting bool,
	existingStatus, existingRole string,
	existingUpdated sql.NullTime,
	mem MembershipEventData,
) error {
	// Locally revoked or suspended memberships are authoritative local security controls
	// and must never be reactivated by delayed or subsequent Clerk webhooks (AUTH-04).
	if hasExisting && (existingStatus == "revoked" || existingStatus == "suspended") {
		if evtType == EventOrgMembershipDeleted && (userID == ownerUserID || existingRole == "owner") {
			return ErrOwnerProtected
		}
		return nil
	}

	if hasExisting && existingStatus == "removed" && evtType == EventOrgMembershipUpdated {
		return nil
	}

	// Out-of-order / ambiguous timestamp handling (docs/02_features/platform/auth.md):
	// 1. Strictly older events are ignored as stale and never overwrite newer state.
	// 2. Removed members are never resurrected by older events or by update events.
	// 3. When deletion/update order is ambiguous, consult authoritative provider state if configured.
	if hasExisting && existingUpdated.Valid {
		if mem.SourceUpdatedAt.Before(existingUpdated.Time) {
			return nil
		}
		if existingStatus == "removed" && evtType != EventOrgMembershipDeleted {
			// Equal timestamp between delete and create is ambiguous; require
			// strictly newer create timestamp AND authoritative provider check if configured.
			if !mem.SourceUpdatedAt.After(existingUpdated.Time) {
				if r.AuthoritativeMembership == nil {
					return nil
				}
				authState, err := r.AuthoritativeMembership.FetchMembershipState(ctx, mem.ClerkOrganizationID, mem.ClerkUserID)
				if err != nil || !authState.Active {
					return nil
				}
				normalizedRole, ok := NormalizeWorkspaceRole(authState.Role)
				if !ok {
					return ErrInvalidPayload
				}
				mem.Role = normalizedRole
			} else if r.AuthoritativeMembership != nil {
				authState, err := r.AuthoritativeMembership.FetchMembershipState(ctx, mem.ClerkOrganizationID, mem.ClerkUserID)
				if err != nil || !authState.Active {
					return nil
				}
				normalizedRole, ok := NormalizeWorkspaceRole(authState.Role)
				if !ok {
					return ErrInvalidPayload
				}
				mem.Role = normalizedRole
			}
		}
	}

	if evtType == EventOrgMembershipDeleted {
		if userID == ownerUserID || (hasExisting && existingStatus == "active" && existingRole == "owner") {
			return ErrOwnerProtected
		}
		if !hasExisting {
			return nil
		}
		_, err := r.DB.ExecContext(ctx, markWorkspaceMemberRemovedQuery, workspaceID, userID, mem.ClerkMembershipID, mem.SourceUpdatedAt)
		return err
	}

	// Protect workspace owner invariant (database_schema.md §26.14).
	if userID == ownerUserID && mem.Role != "owner" {
		return ErrOwnerProtected
	}
	if userID != ownerUserID && mem.Role == "owner" {
		return ErrOwnerProtected
	}

	_, err := r.DB.ExecContext(ctx, insertWorkspaceMemberQuery, mem.ClerkMembershipID, mem.SourceUpdatedAt, workspaceID, userID, mem.Role)
	return err
}

func (r *SQLReconciler) processUserEvent(ctx context.Context, evt VerifiedEvent, u UserEventData) (ProcessResult, error) {
	if r.GlobalDeliveries == nil {
		return ProcessResult{}, ErrGlobalDedupeUnavailable
	}
	claimed, err := r.GlobalDeliveries.ClaimGlobalDelivery(ctx, r.DB, evt)
	if err != nil {
		return ProcessResult{}, err
	}
	if !claimed {
		return ProcessResult{Duplicate: true}, nil
	}

	var procErr error
	switch evt.Type {
	case EventUserCreated, EventUserUpdated:
		procErr = ReconcileCanonicalUserUpsert(ctx, r.DB, u)
	case EventUserDeleted:
		procErr = ReconcileCanonicalUserDeleted(ctx, r.DB, u)
	default:
		procErr = ErrUnsupportedEventType
	}
	if procErr != nil {
		r.releaseGlobalDelivery(ctx, evt)
		return ProcessResult{}, procErr
	}
	return ProcessResult{}, nil
}

func (r *SQLReconciler) processSessionEvent(ctx context.Context, evt VerifiedEvent, sess SessionEventData) (ProcessResult, error) {
	if r.GlobalDeliveries == nil {
		return ProcessResult{}, ErrGlobalDedupeUnavailable
	}
	claimed, err := r.GlobalDeliveries.ClaimGlobalDelivery(ctx, r.DB, evt)
	if err != nil {
		return ProcessResult{}, err
	}
	if !claimed {
		return ProcessResult{Duplicate: true}, nil
	}

	if evt.Type == EventSessionCreated {
		if _, err := r.DB.ExecContext(ctx, updateUserLastLoginQuery, sess.ClerkUserID, sess.SourceUpdatedAt); err != nil {
			r.releaseGlobalDelivery(ctx, evt)
			return ProcessResult{}, err
		}
		return ProcessResult{}, nil
	}
	if (evt.Type == EventSessionEnded || evt.Type == EventSessionRevoked) && r.SessionRevocations != nil {
		r.SessionRevocations.RevokeSession(sess.ClerkUserID, sess.SessionID)
	}
	return ProcessResult{}, nil
}

// ReconcileCanonicalUserUpsert idempotently inserts or updates a verified Clerk
// user in canonical users while enforcing source_updated_at monotonicity and
// never reactivating suspended or deleted accounts.
func ReconcileCanonicalUserUpsert(ctx context.Context, db SQLRunner, u UserEventData) error {
	if db == nil {
		return ErrNotConfigured
	}
	if !isValidClerkID(u.ClerkUserID, "user_") || u.SourceUpdatedAt.IsZero() {
		return ErrInvalidPayload
	}
	if u.Banned || u.Locked {
		_, err := db.ExecContext(ctx, suspendUserFromProviderQuery, u.ClerkUserID, u.SourceUpdatedAt)
		return err
	}
	if !u.EmailVerified || !isValidEmail(u.Email) {
		return ErrInvalidPayload
	}

	var userID string
	err := db.QueryRowContext(
		ctx,
		upsertCanonicalUserQuery,
		u.ClerkUserID,
		u.SourceUpdatedAt,
		u.Email,
		u.DisplayName,
		u.AvatarURL,
	).Scan(&userID)
	if errors.Is(err, sql.ErrNoRows) {
		// Existing row has status != 'active' (e.g. suspended or deleted);
		// webhook reconciliation must never silently reactivate it.
		return nil
	}
	return err
}

// ReconcileCanonicalUserDeleted marks a user as deleted if the event timestamp
// is at or after the stored source_updated_at.
func ReconcileCanonicalUserDeleted(ctx context.Context, db SQLRunner, u UserEventData) error {
	if db == nil {
		return ErrNotConfigured
	}
	if !isValidClerkID(u.ClerkUserID, "user_") || !u.Deleted || u.SourceUpdatedAt.IsZero() {
		return ErrInvalidPayload
	}
	_, err := db.ExecContext(ctx, deleteUserFromProviderQuery, u.ClerkUserID, u.SourceUpdatedAt)
	return err
}

func (r *SQLReconciler) resolveWorkspaceByClerkOrg(ctx context.Context, clerkOrgID string) (workspaceID, ownerUserID string, err error) {
	if !isValidClerkID(clerkOrgID, "org_") {
		return "", "", ErrInvalidPayload
	}
	err = r.DB.QueryRowContext(ctx, resolveWorkspaceByClerkOrgQuery, clerkOrgID).Scan(&workspaceID, &ownerUserID)
	if errors.Is(err, sql.ErrNoRows) {
		return "", "", ErrUnknownOrganization
	}
	if err != nil {
		return "", "", err
	}
	return workspaceID, ownerUserID, nil
}

func (r *SQLReconciler) resolveActiveUserByClerkID(ctx context.Context, clerkUserID string) (string, error) {
	if !isValidClerkID(clerkUserID, "user_") {
		return "", ErrInvalidPayload
	}
	var userID string
	err := r.DB.QueryRowContext(ctx, resolveActiveUserByClerkIDQuery, clerkUserID).Scan(&userID)
	if errors.Is(err, sql.ErrNoRows) {
		return "", ErrUnknownUser
	}
	if err != nil {
		return "", err
	}
	return userID, nil
}

func (r *SQLReconciler) claimWorkspaceDelivery(ctx context.Context, workspaceID string, evt VerifiedEvent) (bool, error) {
	var webhookEventID string
	err := r.DB.QueryRowContext(
		ctx,
		claimWorkspaceWebhookDeliveryQuery,
		workspaceID,
		evt.DeliveryID,
		string(evt.RawPayload),
		evt.WebhookTimestamp,
	).Scan(&webhookEventID)
	if errors.Is(err, sql.ErrNoRows) {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	return webhookEventID != "", nil
}

func (r *SQLReconciler) unclaimWorkspaceDelivery(ctx context.Context, workspaceID, deliveryID string) error {
	_, err := r.DB.ExecContext(ctx, unclaimWorkspaceWebhookDeliveryQuery, workspaceID, deliveryID)
	return err
}

func (r *SQLReconciler) releaseGlobalDelivery(ctx context.Context, evt VerifiedEvent) {
	if releaser, ok := r.GlobalDeliveries.(GlobalDeliveryReleaser); ok {
		_ = releaser.ReleaseGlobalDelivery(ctx, r.DB, evt)
	}
}
