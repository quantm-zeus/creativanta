package clerkwebhook

import (
	"context"
	"database/sql"
	"errors"
	"os"
	"testing"
	"time"

	_ "github.com/jackc/pgx/v5/stdlib"
)

type fixedAuthMembershipChecker struct {
	state AuthoritativeMembershipState
	err   error
	calls int
}

func (f *fixedAuthMembershipChecker) FetchMembershipState(_ context.Context, _, _ string) (AuthoritativeMembershipState, error) {
	f.calls++
	return f.state, f.err
}

func TestSQLReconcilerFailsClosedOnNilDependenciesAndMissingGlobalClaimer(t *testing.T) {
	var nilReconciler *SQLReconciler
	if _, err := nilReconciler.ProcessVerifiedEvent(context.Background(), VerifiedEvent{}); !errors.Is(err, ErrNotConfigured) {
		t.Fatalf("expected ErrNotConfigured on nil reconciler, got %v", err)
	}

	r := &SQLReconciler{}
	if _, err := r.ProcessVerifiedEvent(context.Background(), VerifiedEvent{}); !errors.Is(err, ErrNotConfigured) {
		t.Fatalf("expected ErrNotConfigured on nil DB, got %v", err)
	}
}

func TestPostgresClerkWebhookMembershipAndUserReconciliation(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_POSTGRES_DSN")
	if dsn == "" {
		t.Skip("set CREATIVANTA_TEST_POSTGRES_DSN to run real PostgreSQL webhook reconciliation tests")
	}

	db, err := sql.Open("pgx", dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()

	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()

	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer tx.Rollback()

	schemaSQL := []string{
		`CREATE TEMP TABLE users (
			user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			clerk_id VARCHAR(255) UNIQUE NOT NULL,
			source_updated_at TIMESTAMPTZ,
			email VARCHAR(255) NOT NULL,
			display_name VARCHAR(255),
			avatar_url TEXT,
			status VARCHAR(20) NOT NULL DEFAULT 'active',
			last_login_at TIMESTAMPTZ,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		) ON COMMIT DROP`,
		`CREATE TEMP TABLE workspaces (
			workspace_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			clerk_organization_id VARCHAR(255) UNIQUE,
			display_name VARCHAR(255) NOT NULL,
			status VARCHAR(20) NOT NULL DEFAULT 'active',
			owner_user_id UUID NOT NULL,
			deleted_at TIMESTAMPTZ
		) ON COMMIT DROP`,
		`CREATE TEMP TABLE workspace_members (
			workspace_member_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			clerk_membership_id VARCHAR(255) UNIQUE,
			source_updated_at TIMESTAMPTZ,
			workspace_id UUID NOT NULL,
			user_id UUID NOT NULL,
			role VARCHAR(30) NOT NULL DEFAULT 'viewer',
			status VARCHAR(20) NOT NULL DEFAULT 'active',
			joined_at TIMESTAMPTZ DEFAULT NOW(),
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			UNIQUE(workspace_id, user_id)
		) ON COMMIT DROP`,
		`CREATE TEMP TABLE webhook_events (
			webhook_event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			workspace_id UUID NOT NULL,
			provider VARCHAR(50) NOT NULL,
			direction VARCHAR(20) NOT NULL,
			external_event_id VARCHAR(255),
			idempotency_key VARCHAR(255) NOT NULL,
			payload JSONB NOT NULL,
			processing_status VARCHAR(30) NOT NULL DEFAULT 'received',
			received_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			processed_at TIMESTAMPTZ,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			UNIQUE(provider, idempotency_key)
		) ON COMMIT DROP`,
		`INSERT INTO users (user_id, clerk_id, email, status, source_updated_at) VALUES
			('019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a', 'user_owner1', 'owner@example.com', 'active', '2026-11-01T15:00:00Z'),
			('019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1b', 'user_collab2', 'collab@example.com', 'active', '2026-11-01T15:00:00Z')`,
		`INSERT INTO workspaces (workspace_id, clerk_organization_id, display_name, status, owner_user_id) VALUES
			('019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1', 'org_alpha123', 'Alpha Workspace', 'active', '019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a')`,
		`INSERT INTO workspace_members (workspace_id, user_id, role, status, source_updated_at) VALUES
			('019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1', '019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a', 'owner', 'active', '2026-11-01T15:00:00Z')`,
	}
	for _, stmt := range schemaSQL {
		if _, err := tx.ExecContext(ctx, stmt); err != nil {
			t.Fatalf("setup SQL failed: %v", err)
		}
	}

	authChecker := &fixedAuthMembershipChecker{
		state: AuthoritativeMembershipState{Active: false},
	}
	reconciler := &SQLReconciler{
		DB:                      tx,
		AuthoritativeMembership: authChecker,
	}

	// 1. Global user event without GlobalDeliveries must fail closed (no in-memory dedupe).
	_, err = reconciler.ProcessVerifiedEvent(ctx, VerifiedEvent{
		DeliveryID:       "msg_globaluser1",
		WebhookTimestamp: fixedFixtureTime,
		SourceUpdatedAt:  fixedFixtureTime,
		Type:             EventUserCreated,
		RawPayload:       []byte(knownValidUserCreatedBody),
		User: &UserEventData{
			ClerkUserID:     "user_new999",
			Email:           "new@example.com",
			EmailVerified:   true,
			SourceUpdatedAt: fixedFixtureTime,
		},
	})
	if !errors.Is(err, ErrGlobalDedupeUnavailable) {
		t.Fatalf("expected ErrGlobalDedupeUnavailable when GlobalDeliveries is nil, got %v", err)
	}

	// 2. Unrecognized Clerk organization ID is rejected without creating a workspace.
	_, err = reconciler.ProcessVerifiedEvent(ctx, VerifiedEvent{
		DeliveryID:       "msg_unknownorg1",
		WebhookTimestamp: fixedFixtureTime,
		SourceUpdatedAt:  fixedFixtureTime,
		Type:             EventOrgMembershipCreated,
		RawPayload:       []byte(`{"type":"organizationMembership.created"}`),
		Membership: &MembershipEventData{
			ClerkMembershipID:   "orgmem_1",
			ClerkOrganizationID: "org_unrecognized999",
			ClerkUserID:         "user_collab2",
			Role:                "editor",
			SourceUpdatedAt:     fixedFixtureTime,
		},
	})
	if !errors.Is(err, ErrUnknownOrganization) {
		t.Fatalf("expected ErrUnknownOrganization, got %v", err)
	}

	// 3. Valid membership creation + duplicate delivery ID deduplication in webhook_events.
	t1 := fixedFixtureTime
	createEvt := VerifiedEvent{
		DeliveryID:       "msg_memcreate1",
		WebhookTimestamp: t1,
		SourceUpdatedAt:  t1,
		Type:             EventOrgMembershipCreated,
		RawPayload:       []byte(`{"type":"organizationMembership.created","id":"msg_memcreate1"}`),
		Membership: &MembershipEventData{
			ClerkMembershipID:   "orgmem_collab1",
			ClerkOrganizationID: "org_alpha123",
			ClerkUserID:         "user_collab2",
			Role:                "editor",
			SourceUpdatedAt:     t1,
		},
	}
	res, err := reconciler.ProcessVerifiedEvent(ctx, createEvt)
	if err != nil || res.Duplicate {
		t.Fatalf("first membership create failed: res=%+v err=%v", res, err)
	}
	// Replay same delivery ID with altered role in struct to prove duplicate is a no-op:
	dupEvt := createEvt
	dupMem := *createEvt.Membership
	dupMem.Role = "admin"
	dupEvt.Membership = &dupMem
	res, err = reconciler.ProcessVerifiedEvent(ctx, dupEvt)
	if err != nil || !res.Duplicate {
		t.Fatalf("duplicate delivery should return Duplicate=true, got res=%+v err=%v", res, err)
	}

	assertMemberState := func(wantStatus, wantRole string) {
		t.Helper()
		var gotStatus, gotRole string
		err := tx.QueryRowContext(
			ctx,
			`SELECT status, role FROM workspace_members WHERE workspace_id = '019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1' AND user_id = '019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1b'`,
		).Scan(&gotStatus, &gotRole)
		if err != nil {
			t.Fatalf("query workspace_members: %v", err)
		}
		if gotStatus != wantStatus || gotRole != wantRole {
			t.Fatalf("member state = (%s, %s), want (%s, %s)", gotStatus, gotRole, wantStatus, wantRole)
		}
	}
	assertMemberState("active", "editor")

	// 4. Out-of-order membership updates compare source_updated_at.
	t2 := t1.Add(20 * time.Second)
	_, err = reconciler.ProcessVerifiedEvent(ctx, VerifiedEvent{
		DeliveryID:       "msg_memupdate_newer",
		WebhookTimestamp: t2,
		SourceUpdatedAt:  t2,
		Type:             EventOrgMembershipUpdated,
		RawPayload:       []byte(`{"type":"organizationMembership.updated"}`),
		Membership: &MembershipEventData{
			ClerkMembershipID:   "orgmem_collab1",
			ClerkOrganizationID: "org_alpha123",
			ClerkUserID:         "user_collab2",
			Role:                "manager",
			SourceUpdatedAt:     t2,
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	assertMemberState("active", "manager")

	// Older update (t1 + 10s) arrives late and must not downgrade role to viewer.
	tOlder := t1.Add(10 * time.Second)
	_, err = reconciler.ProcessVerifiedEvent(ctx, VerifiedEvent{
		DeliveryID:       "msg_memupdate_stale",
		WebhookTimestamp: t2,
		SourceUpdatedAt:  tOlder,
		Type:             EventOrgMembershipUpdated,
		RawPayload:       []byte(`{"type":"organizationMembership.updated"}`),
		Membership: &MembershipEventData{
			ClerkMembershipID:   "orgmem_collab1",
			ClerkOrganizationID: "org_alpha123",
			ClerkUserID:         "user_collab2",
			Role:                "viewer",
			SourceUpdatedAt:     tOlder,
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	assertMemberState("active", "manager")

	// 5. Membership deleted at t3 = t1 + 30s; older create/update or ambiguous
	// equal-timestamp create must never resurrect the removed member.
	t3 := t1.Add(30 * time.Second)
	_, err = reconciler.ProcessVerifiedEvent(ctx, VerifiedEvent{
		DeliveryID:       "msg_memdelete1",
		WebhookTimestamp: t3,
		SourceUpdatedAt:  t3,
		Type:             EventOrgMembershipDeleted,
		RawPayload:       []byte(`{"type":"organizationMembership.deleted"}`),
		Membership: &MembershipEventData{
			ClerkMembershipID:   "orgmem_collab1",
			ClerkOrganizationID: "org_alpha123",
			ClerkUserID:         "user_collab2",
			Role:                "manager",
			SourceUpdatedAt:     t3,
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	assertMemberState("removed", "manager")

	// Stale create (t1 + 25s) and even newer update (t1 + 40s) must not resurrect removed member.
	_, err = reconciler.ProcessVerifiedEvent(ctx, VerifiedEvent{
		DeliveryID:       "msg_memcreate_stale_after_delete",
		WebhookTimestamp: t3,
		SourceUpdatedAt:  t1.Add(25 * time.Second),
		Type:             EventOrgMembershipCreated,
		RawPayload:       []byte(`{"type":"organizationMembership.created"}`),
		Membership: &MembershipEventData{
			ClerkMembershipID:   "orgmem_collab1",
			ClerkOrganizationID: "org_alpha123",
			ClerkUserID:         "user_collab2",
			Role:                "editor",
			SourceUpdatedAt:     t1.Add(25 * time.Second),
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	assertMemberState("removed", "manager")

	_, err = reconciler.ProcessVerifiedEvent(ctx, VerifiedEvent{
		DeliveryID:       "msg_memupdate_after_delete",
		WebhookTimestamp: t3.Add(10 * time.Second),
		SourceUpdatedAt:  t3.Add(10 * time.Second),
		Type:             EventOrgMembershipUpdated,
		RawPayload:       []byte(`{"type":"organizationMembership.updated"}`),
		Membership: &MembershipEventData{
			ClerkMembershipID:   "orgmem_collab1",
			ClerkOrganizationID: "org_alpha123",
			ClerkUserID:         "user_collab2",
			Role:                "admin",
			SourceUpdatedAt:     t3.Add(10 * time.Second),
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	assertMemberState("removed", "manager")

	// Ambiguous equal timestamp create (t3) triggers authoritative provider check;
	// since authChecker reports Active=false, member remains removed.
	_, err = reconciler.ProcessVerifiedEvent(ctx, VerifiedEvent{
		DeliveryID:       "msg_memcreate_ambiguous_equal_ts",
		WebhookTimestamp: t3,
		SourceUpdatedAt:  t3,
		Type:             EventOrgMembershipCreated,
		RawPayload:       []byte(`{"type":"organizationMembership.created"}`),
		Membership: &MembershipEventData{
			ClerkMembershipID:   "orgmem_collab1",
			ClerkOrganizationID: "org_alpha123",
			ClerkUserID:         "user_collab2",
			Role:                "editor",
			SourceUpdatedAt:     t3,
		},
	})
	if err != nil {
		t.Fatal(err)
	}
	if authChecker.calls != 1 {
		t.Fatalf("expected authoritative membership checker call on ambiguous order, got %d", authChecker.calls)
	}
	assertMemberState("removed", "manager")

	// 6. Workspace owner cannot be removed via membership delete webhook.
	_, err = reconciler.ProcessVerifiedEvent(ctx, VerifiedEvent{
		DeliveryID:       "msg_owner_delete_attempt",
		WebhookTimestamp: t3,
		SourceUpdatedAt:  t3.Add(time.Minute),
		Type:             EventOrgMembershipDeleted,
		RawPayload:       []byte(`{"type":"organizationMembership.deleted"}`),
		Membership: &MembershipEventData{
			ClerkMembershipID:   "orgmem_owner1",
			ClerkOrganizationID: "org_alpha123",
			ClerkUserID:         "user_owner1",
			Role:                "owner",
			SourceUpdatedAt:     t3.Add(time.Minute),
		},
	})
	if !errors.Is(err, ErrOwnerProtected) {
		t.Fatalf("expected ErrOwnerProtected when attempting to remove workspace owner, got %v", err)
	}

	// 7. Canonical users upsert and out-of-order source_updated_at reconciliation.
	newerUserTime := fixedFixtureTime.Add(5 * time.Minute)
	if err := ReconcileCanonicalUserUpsert(ctx, tx, UserEventData{
		ClerkUserID:     "user_sync_target",
		Email:           "new-email@example.com",
		EmailVerified:   true,
		DisplayName:     "Updated Name",
		SourceUpdatedAt: newerUserTime,
	}); err != nil {
		t.Fatalf("ReconcileCanonicalUserUpsert newer failed: %v", err)
	}
	// Delayed user.created with older source_updated_at must not overwrite newer email/name.
	if err := ReconcileCanonicalUserUpsert(ctx, tx, UserEventData{
		ClerkUserID:     "user_sync_target",
		Email:           "old-email@example.com",
		EmailVerified:   true,
		DisplayName:     "Old Name",
		SourceUpdatedAt: fixedFixtureTime,
	}); err != nil {
		t.Fatalf("ReconcileCanonicalUserUpsert older failed: %v", err)
	}
	var gotEmail, gotName, gotUserStatus string
	if err := tx.QueryRowContext(
		ctx,
		`SELECT email, display_name, status FROM users WHERE clerk_id = 'user_sync_target'`,
	).Scan(&gotEmail, &gotName, &gotUserStatus); err != nil {
		t.Fatal(err)
	}
	if gotEmail != "new-email@example.com" || gotName != "Updated Name" || gotUserStatus != "active" {
		t.Fatalf("stale user webhook overwrote newer user fields: email=%q name=%q status=%q", gotEmail, gotName, gotUserStatus)
	}

	// Deleted user cannot be silently reactivated by a subsequent user.updated event.
	if err := ReconcileCanonicalUserDeleted(ctx, tx, UserEventData{
		ClerkUserID:     "user_sync_target",
		Deleted:         true,
		SourceUpdatedAt: newerUserTime.Add(time.Minute),
	}); err != nil {
		t.Fatal(err)
	}
	if err := ReconcileCanonicalUserUpsert(ctx, tx, UserEventData{
		ClerkUserID:     "user_sync_target",
		Email:           "resurrect@example.com",
		EmailVerified:   true,
		DisplayName:     "Resurrect",
		SourceUpdatedAt: newerUserTime.Add(2 * time.Minute),
	}); err != nil {
		t.Fatal(err)
	}
	if err := tx.QueryRowContext(
		ctx,
		`SELECT status FROM users WHERE clerk_id = 'user_sync_target'`,
	).Scan(&gotUserStatus); err != nil {
		t.Fatal(err)
	}
	if gotUserStatus != "deleted" {
		t.Fatalf("deleted user was reactivated: status=%q", gotUserStatus)
	}
}
