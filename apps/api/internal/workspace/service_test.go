package workspace

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/internal/migrate"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

const (
	wsTestID       = "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa"
	ownerUserID    = "11111111-1111-4111-8111-111111111111"
	adminUserID    = "22222222-2222-4222-8222-222222222222"
	editorUserID   = "33333333-3333-4333-8333-333333333333"
	ownerMemberID  = "99999999-9999-4999-8999-999999999991"
	adminMemberID  = "99999999-9999-4999-8999-999999999992"
	editorMemberID = "99999999-9999-4999-8999-999999999993"
	ticketTestID   = "77777777-7777-4777-8777-777777777777"
)

type inMemoryWorkspaceDB struct {
	mu          sync.Mutex
	ownerUserID string
	members     map[string]tenantdb.WorkspaceMemberRow
	idempotency map[string]tenantdb.IdempotencyRecord
	auditCount  int
	outboxCount int
}

func newInMemoryWorkspaceDB() *inMemoryWorkspaceDB {
	now := time.Date(2026, 10, 30, 12, 0, 0, 0, time.UTC)
	return &inMemoryWorkspaceDB{
		ownerUserID: ownerUserID,
		members: map[string]tenantdb.WorkspaceMemberRow{
			ownerMemberID: {
				MemberID:    ownerMemberID,
				WorkspaceID: wsTestID,
				UserID:      ownerUserID,
				Email:       "owner@example.com",
				DisplayName: "Workspace Owner",
				Role:        rbac.RoleOwner,
				Status:      "active",
				JoinedAt:    now,
				CreatedAt:   now,
				UpdatedAt:   now,
			},
			adminMemberID: {
				MemberID:    adminMemberID,
				WorkspaceID: wsTestID,
				UserID:      adminUserID,
				Email:       "admin@example.com",
				DisplayName: "Workspace Admin",
				Role:        rbac.RoleAdmin,
				Status:      "active",
				JoinedAt:    now,
				CreatedAt:   now,
				UpdatedAt:   now,
			},
			editorMemberID: {
				MemberID:    editorMemberID,
				WorkspaceID: wsTestID,
				UserID:      editorUserID,
				Email:       "editor@example.com",
				DisplayName: "Workspace Editor",
				Role:        rbac.RoleEditor,
				Status:      "active",
				JoinedAt:    now,
				CreatedAt:   now,
				UpdatedAt:   now,
			},
		},
		idempotency: make(map[string]tenantdb.IdempotencyRecord),
	}
}

func (db *inMemoryWorkspaceDB) Begin(ctx context.Context) (pgx.Tx, error) {
	db.mu.Lock()
	defer db.mu.Unlock()
	snapshotMembers := make(map[string]tenantdb.WorkspaceMemberRow, len(db.members))
	for k, v := range db.members {
		snapshotMembers[k] = v
	}
	snapshotIdem := make(map[string]tenantdb.IdempotencyRecord, len(db.idempotency))
	for k, v := range db.idempotency {
		snapshotIdem[k] = v
	}
	return &inMemoryWorkspaceTx{
		parent:      db,
		ownerUserID: db.ownerUserID,
		members:     snapshotMembers,
		idempotency: snapshotIdem,
		auditCount:  db.auditCount,
		outboxCount: db.outboxCount,
	}, nil
}

type inMemoryWorkspaceTx struct {
	parent      *inMemoryWorkspaceDB
	ownerUserID string
	members     map[string]tenantdb.WorkspaceMemberRow
	idempotency map[string]tenantdb.IdempotencyRecord
	auditCount  int
	outboxCount int
}

type fnRow struct {
	scan func(dest ...any) error
}

func (r fnRow) Scan(dest ...any) error { return r.scan(dest...) }

func (tx *inMemoryWorkspaceTx) Begin(ctx context.Context) (pgx.Tx, error) { return tx, nil }
func (tx *inMemoryWorkspaceTx) Commit(ctx context.Context) error {
	tx.parent.mu.Lock()
	defer tx.parent.mu.Unlock()
	tx.parent.ownerUserID = tx.ownerUserID
	tx.parent.members = tx.members
	tx.parent.idempotency = tx.idempotency
	tx.parent.auditCount = tx.auditCount
	tx.parent.outboxCount = tx.outboxCount
	return nil
}
func (tx *inMemoryWorkspaceTx) Rollback(ctx context.Context) error { return nil }
func (tx *inMemoryWorkspaceTx) CopyFrom(ctx context.Context, tableName pgx.Identifier, columnNames []string, rowSrc pgx.CopyFromSource) (int64, error) {
	return 0, nil
}
func (tx *inMemoryWorkspaceTx) SendBatch(ctx context.Context, b *pgx.Batch) pgx.BatchResults {
	return nil
}
func (tx *inMemoryWorkspaceTx) LargeObjects() pgx.LargeObjects { return pgx.LargeObjects{} }
func (tx *inMemoryWorkspaceTx) Prepare(ctx context.Context, name, sql string) (*pgconn.StatementDescription, error) {
	return nil, nil
}
func (tx *inMemoryWorkspaceTx) Conn() *pgx.Conn { return nil }

func (tx *inMemoryWorkspaceTx) Exec(ctx context.Context, sql string, args ...any) (pgconn.CommandTag, error) {
	switch {
	case strings.Contains(sql, "AND role = 'owner'") && strings.Contains(sql, "UPDATE workspace_members"):
		wsID := args[0].(string)
		uID := args[1].(string)
		newRole := args[2].(string)
		for k, m := range tx.members {
			if m.WorkspaceID == wsID && m.UserID == uID && m.Role == rbac.RoleOwner && m.Status == "active" {
				m.Role = newRole
				tx.members[k] = m
				return pgconn.NewCommandTag("UPDATE 1"), nil
			}
		}
		return pgconn.NewCommandTag("UPDATE 0"), nil
	case strings.Contains(sql, "UPDATE workspaces") && strings.Contains(sql, "SET owner_user_id"):
		tx.ownerUserID = args[1].(string)
		return pgconn.NewCommandTag("UPDATE 1"), nil
	case strings.Contains(sql, "INSERT INTO audit_events"):
		tx.auditCount++
		return pgconn.NewCommandTag("INSERT 0 1"), nil
	case strings.Contains(sql, "INSERT INTO event_outbox"):
		tx.outboxCount++
		return pgconn.NewCommandTag("INSERT 0 1"), nil
	case strings.Contains(sql, "INSERT INTO api_idempotency_records"):
		rec := tenantdb.IdempotencyRecord{
			RecordID:        args[0].(string),
			WorkspaceID:     args[1].(string),
			ActorID:         args[2].(string),
			RPC:             args[3].(string),
			IdempotencyKey:  args[4].(string),
			RequestHash:     args[5].(string),
			Status:          "completed",
			ResponsePayload: args[6].([]byte),
			ResponseCode:    args[7].(int),
			ExpiresAt:       args[8].(time.Time),
		}
		key := rec.WorkspaceID + "|" + rec.ActorID + "|" + rec.RPC + "|" + rec.IdempotencyKey
		tx.idempotency[key] = rec
		return pgconn.NewCommandTag("INSERT 0 1"), nil
	default:
		return pgconn.NewCommandTag("EXEC 1"), nil
	}
}

func (tx *inMemoryWorkspaceTx) Query(ctx context.Context, sql string, args ...any) (pgx.Rows, error) {
	return nil, nil
}

func (tx *inMemoryWorkspaceTx) QueryRow(ctx context.Context, sql string, args ...any) pgx.Row {
	switch {
	case strings.Contains(sql, "set_config('app.current_tenant_id'"):
		tID := args[0].(string)
		uID := args[1].(string)
		return fnRow{scan: func(dest ...any) error {
			*(dest[0].(*string)) = tID
			*(dest[1].(*string)) = uID
			return nil
		}}

	case strings.Contains(sql, "FROM workspace_members wm") && strings.Contains(sql, "JOIN workspaces w"):
		wsID := args[0].(string)
		uID := args[1].(string)
		for _, m := range tx.members {
			if m.WorkspaceID == wsID && m.UserID == uID && m.Status == "active" {
				return fnRow{scan: func(dest ...any) error {
					*(dest[0].(*string)) = m.MemberID
					*(dest[1].(*string)) = m.Role
					return nil
				}}
			}
		}
		return fnRow{scan: func(dest ...any) error { return pgx.ErrNoRows }}

	case strings.Contains(sql, "FROM api_idempotency_records"):
		key := args[0].(string) + "|" + args[1].(string) + "|" + args[2].(string) + "|" + args[3].(string)
		rec, ok := tx.idempotency[key]
		if !ok {
			return fnRow{scan: func(dest ...any) error { return pgx.ErrNoRows }}
		}
		return fnRow{scan: func(dest ...any) error {
			*(dest[0].(*string)) = rec.RecordID
			*(dest[1].(*string)) = rec.WorkspaceID
			*(dest[2].(*string)) = rec.ActorID
			*(dest[3].(*string)) = rec.RPC
			*(dest[4].(*string)) = rec.IdempotencyKey
			*(dest[5].(*string)) = rec.RequestHash
			*(dest[6].(*string)) = rec.Status
			*(dest[7].(*[]byte)) = rec.ResponsePayload
			*(dest[8].(*int)) = rec.ResponseCode
			*(dest[9].(*time.Time)) = rec.ExpiresAt
			return nil
		}}

	case strings.Contains(sql, "FROM workspace_members") && strings.Contains(sql, "FOR UPDATE"):
		wsID := args[0].(string)
		memID := args[1].(string)
		m, ok := tx.members[memID]
		if !ok || m.WorkspaceID != wsID {
			return fnRow{scan: func(dest ...any) error { return pgx.ErrNoRows }}
		}
		return fnRow{scan: func(dest ...any) error {
			*(dest[0].(*string)) = m.MemberID
			*(dest[1].(*string)) = m.WorkspaceID
			*(dest[2].(*string)) = m.UserID
			*(dest[3].(*string)) = m.Role
			*(dest[4].(*string)) = m.Status
			*(dest[5].(*string)) = m.InvitedBy
			*(dest[6].(*time.Time)) = m.JoinedAt
			*(dest[7].(*time.Time)) = m.CreatedAt
			*(dest[8].(*time.Time)) = m.UpdatedAt
			return nil
		}}

	case strings.Contains(sql, "SELECT COUNT(1)") && strings.Contains(sql, "role = 'owner'"):
		wsID := args[0].(string)
		count := 0
		for _, m := range tx.members {
			if m.WorkspaceID == wsID && m.Role == rbac.RoleOwner && m.Status == "active" {
				count++
			}
		}
		return fnRow{scan: func(dest ...any) error {
			*(dest[0].(*int)) = count
			return nil
		}}

	case strings.Contains(sql, "UPDATE workspace_members") && strings.Contains(sql, "SET role = $3"):
		wsID := args[0].(string)
		memID := args[1].(string)
		newRole := args[2].(string)
		m, ok := tx.members[memID]
		if !ok || m.WorkspaceID != wsID || m.Status != "active" {
			return fnRow{scan: func(dest ...any) error { return pgx.ErrNoRows }}
		}
		if newRole == rbac.RoleOwner {
			for k, other := range tx.members {
				if k != memID && other.WorkspaceID == wsID && other.Role == rbac.RoleOwner && other.Status == "active" {
					return fnRow{scan: func(dest ...any) error {
						return errors.New("idx_one_active_workspace_owner violation")
					}}
				}
			}
		}
		m.Role = newRole
		m.UpdatedAt = time.Now().UTC()
		tx.members[memID] = m
		return fnRow{scan: func(dest ...any) error {
			*(dest[0].(*string)) = m.MemberID
			*(dest[1].(*string)) = m.WorkspaceID
			*(dest[2].(*string)) = m.UserID
			*(dest[3].(*string)) = m.Role
			*(dest[4].(*string)) = m.Status
			*(dest[5].(*string)) = m.InvitedBy
			*(dest[6].(*time.Time)) = m.JoinedAt
			*(dest[7].(*time.Time)) = m.CreatedAt
			*(dest[8].(*time.Time)) = m.UpdatedAt
			return nil
		}}

	case strings.Contains(sql, "UPDATE workspace_members") && strings.Contains(sql, "SET status = 'revoked'"):
		wsID := args[0].(string)
		memID := args[1].(string)
		m, ok := tx.members[memID]
		if !ok || m.WorkspaceID != wsID || m.Status == "revoked" {
			return fnRow{scan: func(dest ...any) error { return pgx.ErrNoRows }}
		}
		m.Status = "revoked"
		m.UpdatedAt = time.Now().UTC()
		tx.members[memID] = m
		return fnRow{scan: func(dest ...any) error {
			*(dest[0].(*string)) = m.MemberID
			*(dest[1].(*string)) = m.WorkspaceID
			*(dest[2].(*string)) = m.UserID
			*(dest[3].(*string)) = m.Role
			*(dest[4].(*string)) = m.Status
			*(dest[5].(*string)) = m.InvitedBy
			*(dest[6].(*time.Time)) = m.JoinedAt
			*(dest[7].(*time.Time)) = m.CreatedAt
			*(dest[8].(*time.Time)) = m.UpdatedAt
			return nil
		}}
	}
	return fnRow{scan: func(dest ...any) error { return pgx.ErrNoRows }}
}

type recordingRevocationHook struct {
	mu          sync.Mutex
	revoked     []string
	roleUpdates []string
}

func (h *recordingRevocationHook) OnMemberRevoked(workspaceID, userID, memberID string) {
	h.mu.Lock()
	defer h.mu.Unlock()
	h.revoked = append(h.revoked, workspaceID+":"+userID+":"+memberID)
}

func (h *recordingRevocationHook) OnMemberRoleUpdated(workspaceID, userID, memberID, oldRole, newRole string) {
	h.mu.Lock()
	defer h.mu.Unlock()
	h.roleUpdates = append(h.roleUpdates, workspaceID+":"+userID+":"+oldRole+"->"+newRole)
}

func TestLastOwnerProtectionAndAtomicOwnershipTransfer(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(filepath.Join("..", "..", "..", ".."))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	db := newInMemoryWorkspaceDB()
	hook := &recordingRevocationHook{}
	svc := NewService(db, reg)
	svc.RevocationHook = hook
	ctx := context.Background()

	// 1. Owner cannot demote self when last owner.
	_, err = svc.UpdateRole(ctx, UpdateRoleRequest{
		WorkspaceID:    wsTestID,
		ActorUserID:    ownerUserID,
		IdempotencyKey: "idem-demote-self",
		TargetMemberID: ownerMemberID,
		NewRole:        rbac.RoleAdmin,
	})
	if !errors.Is(err, tenantdb.ErrLastOwnerProtected) {
		t.Fatalf("expected ErrLastOwnerProtected when Owner attempts to demote self, got %v", err)
	}

	// 2. Owner cannot remove self when last owner.
	_, err = svc.RemoveMember(ctx, RemoveMemberRequest{
		WorkspaceID:    wsTestID,
		ActorUserID:    ownerUserID,
		IdempotencyKey: "idem-remove-owner-self",
		TargetMemberID: ownerMemberID,
	})
	if !errors.Is(err, tenantdb.ErrLastOwnerProtected) {
		t.Fatalf("expected ErrLastOwnerProtected when Owner attempts to remove self, got %v", err)
	}

	// 3. Admin cannot demote or remove the Owner, nor promote anyone to Owner.
	_, err = svc.UpdateRole(ctx, UpdateRoleRequest{
		WorkspaceID:    wsTestID,
		ActorUserID:    adminUserID,
		IdempotencyKey: "idem-admin-demote-owner",
		TargetMemberID: ownerMemberID,
		NewRole:        rbac.RoleEditor,
	})
	if !errors.Is(err, ErrAdminCannotModifyOwner) {
		t.Fatalf("expected ErrAdminCannotModifyOwner when Admin modifies Owner, got %v", err)
	}

	_, err = svc.UpdateRole(ctx, UpdateRoleRequest{
		WorkspaceID:    wsTestID,
		ActorUserID:    adminUserID,
		IdempotencyKey: "idem-admin-promote-editor-to-owner",
		TargetMemberID: editorMemberID,
		NewRole:        rbac.RoleOwner,
	})
	if !errors.Is(err, ErrAdminCannotModifyOwner) {
		t.Fatalf("expected ErrAdminCannotModifyOwner when Admin promotes to Owner, got %v", err)
	}

	_, err = svc.RemoveMember(ctx, RemoveMemberRequest{
		WorkspaceID:    wsTestID,
		ActorUserID:    adminUserID,
		IdempotencyKey: "idem-admin-remove-owner",
		TargetMemberID: ownerMemberID,
	})
	if !errors.Is(err, ErrAdminCannotModifyOwner) {
		t.Fatalf("expected ErrAdminCannotModifyOwner when Admin removes Owner, got %v", err)
	}

	// 4. Owner transfers ownership to Admin atomically in a single transaction.
	transferRes, err := svc.UpdateRole(ctx, UpdateRoleRequest{
		WorkspaceID:    wsTestID,
		ActorUserID:    ownerUserID,
		IdempotencyKey: "idem-owner-transfer-1",
		TargetMemberID: adminMemberID,
		NewRole:        rbac.RoleOwner,
		Reason:         "Planned ownership handoff",
	})
	if err != nil {
		t.Fatalf("Owner ownership transfer failed: %v", err)
	}
	if transferRes.Member.Role != rbac.RoleOwner || transferRes.Replayed {
		t.Fatalf("expected promoted member role=owner and replayed=false, got %+v", transferRes)
	}
	if db.ownerUserID != adminUserID {
		t.Fatalf("expected workspaces.owner_user_id updated to %s, got %s", adminUserID, db.ownerUserID)
	}
	if db.members[ownerMemberID].Role != rbac.RoleAdmin {
		t.Fatalf("expected previous owner demoted to admin, got %s", db.members[ownerMemberID].Role)
	}

	// 5. Replay with same idempotency key returns identical result without re-executing.
	auditBefore := db.auditCount
	replayRes, err := svc.UpdateRole(ctx, UpdateRoleRequest{
		WorkspaceID:    wsTestID,
		ActorUserID:    ownerUserID,
		IdempotencyKey: "idem-owner-transfer-1",
		TargetMemberID: adminMemberID,
		NewRole:        rbac.RoleOwner,
		Reason:         "Planned ownership handoff",
	})
	if err != nil {
		t.Fatalf("idempotent replay failed: %v", err)
	}
	if !replayRes.Replayed || db.auditCount != auditBefore {
		t.Fatalf("expected Replayed=true and no duplicate audit event")
	}

	// 6. Reusing same idempotency key with different payload fails with ErrIdempotencyConflict.
	_, err = svc.UpdateRole(ctx, UpdateRoleRequest{
		WorkspaceID:    wsTestID,
		ActorUserID:    ownerUserID,
		IdempotencyKey: "idem-owner-transfer-1",
		TargetMemberID: editorMemberID,
		NewRole:        rbac.RoleManager,
	})
	if !errors.Is(err, ErrIdempotencyConflict) {
		t.Fatalf("expected ErrIdempotencyConflict on payload mismatch, got %v", err)
	}
}

func TestMemberRevocationEnforcedImmediatelyOnNextRequest(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(filepath.Join("..", "..", "..", ".."))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	db := newInMemoryWorkspaceDB()
	hook := &recordingRevocationHook{}
	svc := NewService(db, reg)
	svc.RevocationHook = hook
	ctx := context.Background()

	// Before revocation, Editor has active membership in WithTx.
	err = tenantdb.WithTx(ctx, db, tenantdb.Scope{
		WorkspaceID:             wsTestID,
		UserID:                  editorUserID,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		sc, _ := tenantdb.ScopeFromContext(txCtx)
		if sc.Role != rbac.RoleEditor {
			t.Fatalf("expected active role editor, got %s", sc.Role)
		}
		return nil
	})
	if err != nil {
		t.Fatalf("expected active editor membership before revocation: %v", err)
	}

	// Admin revokes Editor.
	remRes, err := svc.RemoveMember(ctx, RemoveMemberRequest{
		WorkspaceID:    wsTestID,
		ActorUserID:    adminUserID,
		IdempotencyKey: "idem-revoke-editor-1",
		TargetMemberID: editorMemberID,
		Reason:         "Contractor offboarded",
	})
	if err != nil {
		t.Fatalf("RemoveMember failed: %v", err)
	}
	if remRes.Member.Status != "revoked" {
		t.Fatalf("expected status=revoked, got %s", remRes.Member.Status)
	}
	if len(hook.revoked) != 1 || !strings.Contains(hook.revoked[0], editorUserID) {
		t.Fatalf("expected synchronous RevocationHook notification, got %v", hook.revoked)
	}

	// Immediately on the very next request (with unexpired JWT), Editor is denied!
	if _, err := svc.Get(ctx, wsTestID, editorUserID); !errors.Is(err, tenantdb.ErrMembershipRevokedOrMissing) {
		t.Fatalf("expected revoked member next Get request to fail with ErrMembershipRevokedOrMissing, got %v", err)
	}
	if _, err := svc.ListMembers(ctx, wsTestID, editorUserID); !errors.Is(err, tenantdb.ErrMembershipRevokedOrMissing) {
		t.Fatalf("expected revoked member next ListMembers request to fail with ErrMembershipRevokedOrMissing, got %v", err)
	}
}

func TestPrivateNotesAndSecretsNeverSerialized(t *testing.T) {
	now := time.Now().UTC()

	// 1. ConnectedAccountProjection strips access_token_encrypted & refresh_token_encrypted.
	caProj := ProjectConnectedAccount(ConnectedAccountRecord{
		ConnectedAccountID:    "ca-1",
		WorkspaceID:           wsTestID,
		Platform:              "tiktok",
		AccountType:           "creator",
		ExternalAccountID:     "ext-1",
		DisplayName:           "Creator TikTok",
		AccessTokenEncrypted:  []byte("SECRET_ACCESS_TOKEN_BYTES"),
		RefreshTokenEncrypted: []byte("SECRET_REFRESH_TOKEN_BYTES"),
		GrantedScopes:         []string{"video.Basic"},
		ConnectionState:       "connected",
	})
	caJSON, err := MarshalSafeJSON(caProj)
	if err != nil {
		t.Fatalf("MarshalSafeJSON(ConnectedAccountProjection) failed: %v", err)
	}
	if bytes.Contains(caJSON, []byte("SECRET_ACCESS_TOKEN_BYTES")) ||
		bytes.Contains(caJSON, []byte("access_token_encrypted")) ||
		bytes.Contains(caJSON, []byte("refresh_token_encrypted")) {
		t.Fatalf("secret token leaked in ConnectedAccountProjection JSON: %s", string(caJSON))
	}

	// 2. APIKeyProjection strips key_hash.
	akProj := ProjectAPIKey(APIKeyRecord{
		APIKeyID:     "ak-1",
		WorkspaceID:  wsTestID,
		KeyPrefix:    "cv_live_12",
		KeyHash:      "sha256_secret_key_hash_value",
		Name:         "ERP Integration",
		Scopes:       []string{"orders:read"},
		Status:       "active",
		RequestCount: 42,
		CreatedAt:    now,
	})
	akJSON, err := MarshalSafeJSON(akProj)
	if err != nil {
		t.Fatalf("MarshalSafeJSON(APIKeyProjection) failed: %v", err)
	}
	if bytes.Contains(akJSON, []byte("sha256_secret_key_hash_value")) ||
		bytes.Contains(akJSON, []byte("key_hash")) {
		t.Fatalf("secret key_hash leaked in APIKeyProjection JSON: %s", string(akJSON))
	}

	// 3. WebhookSubscriptionProjection strips signing_secret_hash.
	whProj := ProjectWebhookSubscription(WebhookSubscriptionRecord{
		WebhookSubscriptionID: "wh-1",
		WorkspaceID:           wsTestID,
		TargetURL:             "https://example.com/webhook",
		EventTypes:            []string{"commerce.order.created"},
		SigningSecretHash:     "whsec_super_secret_hash",
		Status:                "active",
	})
	whJSON, err := MarshalSafeJSON(whProj)
	if err != nil {
		t.Fatalf("MarshalSafeJSON(WebhookSubscriptionProjection) failed: %v", err)
	}
	if bytes.Contains(whJSON, []byte("whsec_super_secret_hash")) ||
		bytes.Contains(whJSON, []byte("signing_secret_hash")) {
		t.Fatalf("signing_secret_hash leaked in WebhookSubscriptionProjection JSON: %s", string(whJSON))
	}

	// 4. SupportTicketMessageProjection refuses internal admin notes (`is_internal_note = true`).
	internalRow := tenantdb.SupportTicketMessageRow{
		WorkspaceID:    wsTestID,
		MessageID:      "msg-internal",
		TicketID:       ticketTestID,
		AuthorType:     "admin",
		Body:           "CONFIDENTIAL INTERNAL ADMIN NOTE",
		IsInternalNote: true,
		CreatedAt:      now,
	}
	if _, err := ProjectSupportTicketMessage(internalRow); !errors.Is(err, ErrInternalNoteForbidden) {
		t.Fatalf("expected ErrInternalNoteForbidden on internal support note, got %v", err)
	}

	publicRow := tenantdb.SupportTicketMessageRow{
		WorkspaceID:    wsTestID,
		MessageID:      "msg-public",
		TicketID:       ticketTestID,
		AuthorType:     "user",
		Body:           "Customer visible message",
		IsInternalNote: false,
		CreatedAt:      now,
	}
	projectedList := ProjectSupportTicketMessages([]tenantdb.SupportTicketMessageRow{internalRow, publicRow})
	if len(projectedList) != 1 || projectedList[0].MessageID != "msg-public" {
		t.Fatalf("expected internal note filtered out of list, got %+v", projectedList)
	}
	listJSON, err := MarshalSafeJSON(projectedList)
	if err != nil {
		t.Fatalf("MarshalSafeJSON(SupportTicketMessageProjection list) failed: %v", err)
	}
	if bytes.Contains(listJSON, []byte("CONFIDENTIAL INTERNAL ADMIN NOTE")) {
		t.Fatalf("internal support note leaked in serialized JSON: %s", string(listJSON))
	}

	// 5. PublicCreatorDirectoryProjection rejects hidden/opt-out kits and never serializes private draft sections.
	if _, err := ProjectPublicCreatorDirectory(MediaKitRecord{
		MediaKitID:      "mk-hidden",
		WorkspaceID:     wsTestID,
		SectionsJSON:    []byte(`[{"private":"draft_rate_notes"}]`),
		DirectoryOptIn:  false,
		DirectoryStatus: "hidden",
	}); !errors.Is(err, ErrDirectoryProfileNotPublished) {
		t.Fatalf("expected ErrDirectoryProfileNotPublished on hidden media kit, got %v", err)
	}

	pubKit, err := ProjectPublicCreatorDirectory(MediaKitRecord{
		MediaKitID:          "mk-pub",
		WorkspaceID:         wsTestID,
		SectionsJSON:        []byte(`[{"private":"SECRET_DRAFT_SECTION_DO_NOT_LEAK"}]`),
		BrandProfileID:      "bp-private",
		ShareURL:            "https://private-share",
		DirectoryOptIn:      true,
		DirectoryStatus:     "published",
		DirectoryProfileRaw: []byte(`{"display_name":"Linh Creator","handle":"linh_vn","categories":["tech"],"platforms":["tiktok"],"starting_rate":{"amount":"2500000","currency":"VND"},"accepts_inquiries":true}`),
	})
	if err != nil {
		t.Fatalf("ProjectPublicCreatorDirectory on valid published kit failed: %v", err)
	}
	pubJSON, err := MarshalSafeJSON(pubKit)
	if err != nil {
		t.Fatalf("MarshalSafeJSON(PublicCreatorProfileProjection) failed: %v", err)
	}
	if bytes.Contains(pubJSON, []byte("SECRET_DRAFT_SECTION_DO_NOT_LEAK")) ||
		bytes.Contains(pubJSON, []byte(wsTestID)) ||
		bytes.Contains(pubJSON, []byte("bp-private")) {
		t.Fatalf("private media_kit fields leaked in public directory projection: %s", string(pubJSON))
	}

	// 6. AssertNoSecretsOrPrivateNotesSerialized catches forbidden keys in arbitrary maps.
	badPayloads := []string{
		`{"account":{"access_token_encrypted":"abc"}}`,
		`{"key":{"key_hash":"123"}}`,
		`{"admin":{"password_hash":"argon2id$..."}}`,
		`{"admin":{"mfa_secret_encrypted":"totp"}}`,
		`{"session":{"session_token_hash":"hash"}}`,
		`{"message":{"body":"secret","is_internal_note":true}}`,
	}
	for _, bp := range badPayloads {
		if err := AssertNoSecretsOrPrivateNotesSerialized([]byte(bp)); !errors.Is(err, ErrForbiddenFieldSerialized) {
			t.Fatalf("expected ErrForbiddenFieldSerialized on payload %s, got %v", bp, err)
		}
	}

	// 7. WorkspaceProjection (R05) populates both canonical and legacy name/mode fields.
	wsProj := ProjectWorkspace(tenantdb.WorkspaceRow{
		WorkspaceID:           wsTestID,
		Name:                  "Studio Alpha",
		Slug:                  "studio-alpha",
		OwnerUserID:           ownerUserID,
		SubscriptionTier:      "pro",
		Status:                "active",
		DefaultMode:           "seller",
		EnabledModes:          []string{"creator", "seller"},
		AICreditsRemaining:    tenantdb.MustParseExactDecimal("30"),
		AICreditsMonthlyLimit: tenantdb.MustParseExactDecimal("30"),
	})
	if wsProj.Name != "Studio Alpha" || wsProj.DisplayName != "Studio Alpha" {
		t.Fatalf("expected both Name and DisplayName populated, got %+v", wsProj)
	}
	if wsProj.DefaultMode != "seller" || wsProj.DefaultOperatorMode != "seller" {
		t.Fatalf("expected both DefaultMode and DefaultOperatorMode populated, got %+v", wsProj)
	}
	wsJSON, err := MarshalSafeJSON(wsProj)
	if err != nil {
		t.Fatalf("MarshalSafeJSON(WorkspaceProjection) failed: %v", err)
	}
	if !bytes.Contains(wsJSON, []byte(`"display_name":"Studio Alpha"`)) ||
		!bytes.Contains(wsJSON, []byte(`"default_operator_mode":"seller"`)) {
		t.Fatalf("expected display_name and default_operator_mode in WorkspaceProjection JSON: %s", string(wsJSON))
	}
}

func TestPostgresLiveWorkspaceOwnerProtectionRevocationAndProjections(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_DATABASE_URL")
	if dsn == "" {
		t.Skip("CREATIVANTA_TEST_DATABASE_URL not set; live PostgreSQL workspace service test executes in CI")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 45*time.Second)
	defer cancel()

	pool, err := pgxpool.New(ctx, dsn)
	if err != nil {
		t.Fatalf("pgxpool.New: %v", err)
	}
	defer pool.Close()

	dir := filepath.Join("..", "..", "..", "..", "infra", "migrations")
	if _, err := migrate.Up(ctx, pool, dir); err != nil {
		t.Fatalf("migrate.Up: %v", err)
	}

	reg, err := rbac.LoadCanonicalBindings(filepath.Join("..", "..", "..", ".."))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}

	const (
		uOwner  = "10000000-0000-4000-8000-000000000001"
		uAdmin  = "10000000-0000-4000-8000-000000000002"
		uEditor = "10000000-0000-4000-8000-000000000003"
		mAdmin  = "20000000-0000-4000-8000-000000000002"
		mEditor = "20000000-0000-4000-8000-000000000003"
	)

	_, err = pool.Exec(ctx, `
		INSERT INTO users (user_id, external_auth_id, email, display_name, status) VALUES
		  ($1::uuid, 'live_ws_owner', 'live_owner@example.com', 'Live Owner', 'active'),
		  ($2::uuid, 'live_ws_admin', 'live_admin@example.com', 'Live Admin', 'active'),
		  ($3::uuid, 'live_ws_editor', 'live_editor@example.com', 'Live Editor', 'active')
		ON CONFLICT (user_id) DO NOTHING
	`, uOwner, uAdmin, uEditor)
	if err != nil {
		t.Fatalf("seed users: %v", err)
	}

	svc := NewService(pool, reg)
	slug := "p004-live-" + strings.ReplaceAll(defaultUUIDv4()[:8], "-", "")
	createdWS, err := svc.Create(ctx, CreateWorkspaceRequest{
		ActorUserID:    uOwner,
		IdempotencyKey: "create-" + slug,
		Name:           "P0-04 Live Workspace",
		Slug:           slug,
		DefaultMode:    "creator",
		EnabledModes:   []string{"creator", "seller"},
	})
	if err != nil {
		t.Fatalf("svc.Create failed: %v", err)
	}

	// Seed Admin and Editor members into the created workspace.
	_, err = pool.Exec(ctx, `
		INSERT INTO workspace_members (member_id, workspace_id, user_id, role, status) VALUES
		  ($1::uuid, $3::uuid, $4::uuid, 'admin', 'active'),
		  ($2::uuid, $3::uuid, $5::uuid, 'editor', 'active')
	`, mAdmin, mEditor, createdWS.WorkspaceID, uAdmin, uEditor)
	if err != nil {
		t.Fatalf("seed members: %v", err)
	}

	members, err := svc.ListMembers(ctx, createdWS.WorkspaceID, uOwner)
	if err != nil || len(members) != 3 {
		t.Fatalf("ListMembers expected 3 members, got %d (err=%v)", len(members), err)
	}

	// Transfer ownership from uOwner to uAdmin on real PostgreSQL (verifies idx_one_active_workspace_owner).
	transferRes, err := svc.UpdateRole(ctx, UpdateRoleRequest{
		WorkspaceID:    createdWS.WorkspaceID,
		ActorUserID:    uOwner,
		IdempotencyKey: "live-transfer-1",
		TargetMemberID: mAdmin,
		NewRole:        rbac.RoleOwner,
		Reason:         "Live PG ownership transfer",
	})
	if err != nil {
		t.Fatalf("live ownership transfer failed: %v", err)
	}
	if transferRes.Member.Role != rbac.RoleOwner {
		t.Fatalf("expected new owner role, got %s", transferRes.Member.Role)
	}

	// Revoke uEditor and verify uEditor's next request fails closed immediately.
	if _, err := svc.RemoveMember(ctx, RemoveMemberRequest{
		WorkspaceID:    createdWS.WorkspaceID,
		ActorUserID:    uAdmin,
		IdempotencyKey: "live-revoke-editor-1",
		TargetMemberID: mEditor,
		Reason:         "Live PG member revocation",
	}); err != nil {
		t.Fatalf("live RemoveMember failed: %v", err)
	}
	if _, err := svc.Get(ctx, createdWS.WorkspaceID, uEditor); !errors.Is(err, tenantdb.ErrMembershipRevokedOrMissing) {
		t.Fatalf("expected revoked editor to be denied on live PG, got %v", err)
	}

	// Verify serialized JSON of workspace and members passes AssertNoSecretsOrPrivateNotesSerialized.
	rawJSON, err := json.Marshal(members)
	if err != nil {
		t.Fatal(err)
	}
	if err := AssertNoSecretsOrPrivateNotesSerialized(rawJSON); err != nil {
		t.Fatalf("AssertNoSecretsOrPrivateNotesSerialized failed: %v", err)
	}
}
