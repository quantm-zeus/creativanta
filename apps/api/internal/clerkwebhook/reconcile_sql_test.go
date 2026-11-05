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

type noopSQLRunner struct{}

func (noopSQLRunner) ExecContext(_ context.Context, _ string, _ ...any) (sql.Result, error) {
	return nil, nil
}

func (noopSQLRunner) QueryRowContext(_ context.Context, _ string, _ ...any) *sql.Row {
	return nil
}

type memoryGlobalClaimer struct {
	seen map[string]bool
}

func (m *memoryGlobalClaimer) ClaimGlobalDelivery(_ context.Context, _ SQLRunner, evt VerifiedEvent) (bool, error) {
	if m.seen == nil {
		m.seen = make(map[string]bool)
	}
	if m.seen[evt.DeliveryID] {
		return false, nil
	}
	m.seen[evt.DeliveryID] = true
	return true, nil
}

type recordedSessionRevocation struct {
	subject   string
	sessionID string
}

type memorySessionRevocationRecorder struct {
	revocations []recordedSessionRevocation
}

func (m *memorySessionRevocationRecorder) RevokeSession(subject, sessionID string) {
	m.revocations = append(m.revocations, recordedSessionRevocation{
		subject:   subject,
		sessionID: sessionID,
	})
}

func TestSQLReconcilerSessionRevocationAndEndedEventsNotifyRecorder(t *testing.T) {
	recorder := &memorySessionRevocationRecorder{}
	reconciler := &SQLReconciler{
		DB:                 noopSQLRunner{},
		GlobalDeliveries:   &memoryGlobalClaimer{},
		SessionRevocations: recorder,
	}

	revokedEvt := VerifiedEvent{
		DeliveryID:       "msg_sess_revoked_1",
		WebhookTimestamp: fixedFixtureTime,
		SourceUpdatedAt:  fixedFixtureTime,
		Type:             EventSessionRevoked,
		RawPayload:       []byte(`{"type":"session.revoked"}`),
		Session: &SessionEventData{
			SessionID:       "sess_rev_01",
			ClerkUserID:     "user_recover_99",
			Status:          "revoked",
			SourceUpdatedAt: fixedFixtureTime,
		},
	}
	res, err := reconciler.ProcessVerifiedEvent(context.Background(), revokedEvt)
	if err != nil || res.Duplicate {
		t.Fatalf("expected session.revoked to succeed, got res=%+v err=%v", res, err)
	}

	// Duplicate delivery must not re-fire recorder
	res, err = reconciler.ProcessVerifiedEvent(context.Background(), revokedEvt)
	if err != nil || !res.Duplicate {
		t.Fatalf("expected duplicate session.revoked to return Duplicate=true, got res=%+v err=%v", res, err)
	}

	endedEvt := VerifiedEvent{
		DeliveryID:       "msg_sess_ended_1",
		WebhookTimestamp: fixedFixtureTime,
		SourceUpdatedAt:  fixedFixtureTime,
		Type:             EventSessionEnded,
		RawPayload:       []byte(`{"type":"session.ended"}`),
		Session: &SessionEventData{
			SessionID:       "sess_end_02",
			ClerkUserID:     "user_recover_99",
			Status:          "ended",
			SourceUpdatedAt: fixedFixtureTime,
		},
	}
	res, err = reconciler.ProcessVerifiedEvent(context.Background(), endedEvt)
	if err != nil || res.Duplicate {
		t.Fatalf("expected session.ended to succeed, got res=%+v err=%v", res, err)
	}

	if len(recorder.revocations) != 2 {
		t.Fatalf("expected 2 recorded session revocations, got %+v", recorder.revocations)
	}
	if recorder.revocations[0].subject != "user_recover_99" || recorder.revocations[0].sessionID != "sess_rev_01" {
		t.Fatalf("unexpected first revocation: %+v", recorder.revocations[0])
	}
	if recorder.revocations[1].subject != "user_recover_99" || recorder.revocations[1].sessionID != "sess_end_02" {
		t.Fatalf("unexpected second revocation: %+v", recorder.revocations[1])
	}
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

type retryableMemoryGlobalClaimer struct {
	seen       map[string]bool
	unclaimed  int
	claimCalls int
}

func (m *retryableMemoryGlobalClaimer) ClaimGlobalDelivery(_ context.Context, _ SQLRunner, evt VerifiedEvent) (bool, error) {
	m.claimCalls++
	if m.seen == nil {
		m.seen = make(map[string]bool)
	}
	if m.seen[evt.DeliveryID] {
		return false, nil
	}
	m.seen[evt.DeliveryID] = true
	return true, nil
}

func (m *retryableMemoryGlobalClaimer) ReleaseGlobalDelivery(_ context.Context, _ SQLRunner, evt VerifiedEvent) error {
	if m.seen != nil {
		delete(m.seen, evt.DeliveryID)
	}
	m.unclaimed++
	return nil
}

type flakeyUserDBRunner struct {
	failNextExec bool
	execCalls    int
}

func (f *flakeyUserDBRunner) ExecContext(_ context.Context, _ string, _ ...any) (sql.Result, error) {
	f.execCalls++
	if f.failNextExec {
		f.failNextExec = false
		return nil, errors.New("simulated transient database failure during reconciliation")
	}
	return nil, nil
}

func (f *flakeyUserDBRunner) QueryRowContext(_ context.Context, _ string, _ ...any) *sql.Row {
	return nil
}

func TestAUTH04_RevokedAndSuspendedMembershipsNeverReactivatedByDelayedWebhook(t *testing.T) {
	ctx := context.Background()
	tRevoked := fixedFixtureTime
	tDelayedWebhook := fixedFixtureTime.Add(10 * time.Minute)

	// Even if Clerk authoritative checker claims the membership is still active remotely,
	// a locally 'revoked' or 'suspended' workspace_members row must never be reactivated.
	execTracker := &flakeyUserDBRunner{}
	reconciler := &SQLReconciler{
		DB: execTracker,
		AuthoritativeMembership: &fixedAuthMembershipChecker{
			state: AuthoritativeMembershipState{
				Active:          true,
				Role:            "admin",
				SourceUpdatedAt: tDelayedWebhook,
			},
		},
	}

	for _, terminalLocalStatus := range []string{"revoked", "suspended"} {
		// Case 1: source_updated_at was NULL on the local row (legacy local revocation) and a newer Clerk update arrives.
		err := reconciler.reconcileMembershipRowState(
			ctx,
			EventOrgMembershipUpdated,
			"019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1",
			"019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a",
			"019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1b",
			true,
			terminalLocalStatus,
			"editor",
			sql.NullTime{Valid: false},
			MembershipEventData{
				ClerkMembershipID:   "orgmem_collab1",
				ClerkOrganizationID: "org_alpha123",
				ClerkUserID:         "user_collab2",
				Role:                "admin",
				SourceUpdatedAt:     tDelayedWebhook,
			},
		)
		if err != nil {
			t.Fatalf("unexpected error for status=%s (null source_updated_at): %v", terminalLocalStatus, err)
		}

		// Case 2: source_updated_at was stamped at tRevoked and a delayed Clerk create/update with newer timestamp arrives.
		for _, evtType := range []EventType{EventOrgMembershipUpdated, EventOrgMembershipCreated} {
			err := reconciler.reconcileMembershipRowState(
				ctx,
				evtType,
				"019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1",
				"019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a",
				"019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1b",
				true,
				terminalLocalStatus,
				"editor",
				sql.NullTime{Time: tRevoked, Valid: true},
				MembershipEventData{
					ClerkMembershipID:   "orgmem_collab1",
					ClerkOrganizationID: "org_alpha123",
					ClerkUserID:         "user_collab2",
					Role:                "admin",
					SourceUpdatedAt:     tDelayedWebhook,
				},
			)
			if err != nil {
				t.Fatalf("unexpected error for status=%s evtType=%s: %v", terminalLocalStatus, evtType, err)
			}
		}
	}
	if execTracker.execCalls != 0 {
		t.Fatalf("SECURITY VIOLATION (AUTH-04): reconcileMembershipRowState executed %d DB mutations on locally %q/suspended membership", execTracker.execCalls, "revoked")
	}
}

func TestWEBHOOK01_FailedWebhookDeliveryRemainsRetryableAndAtomic(t *testing.T) {
	ctx := context.Background()
	claimer := &retryableMemoryGlobalClaimer{}
	flakeyDB := &flakeyUserDBRunner{failNextExec: true}
	reconciler := &SQLReconciler{
		DB:               flakeyDB,
		GlobalDeliveries: claimer,
	}

	evt := VerifiedEvent{
		DeliveryID:       "msg_retry_atomic_01",
		WebhookTimestamp: fixedFixtureTime,
		SourceUpdatedAt:  fixedFixtureTime,
		Type:             EventUserUpdated,
		RawPayload:       []byte(knownValidUserCreatedBody),
		User: &UserEventData{
			ClerkUserID:     "user_retry_01",
			Email:           "retry@example.com",
			EmailVerified:   true,
			Banned:          true,
			DisplayName:     "Retry User",
			SourceUpdatedAt: fixedFixtureTime,
		},
	}

	// Attempt 1: Downstream reconciliation fails -> error returned AND delivery claim released.
	_, err := reconciler.ProcessVerifiedEvent(ctx, evt)
	if err == nil {
		t.Fatalf("expected error on first attempt when DB exec fails")
	}
	if claimer.unclaimed != 1 {
		t.Fatalf("expected failed delivery claim to be released (unclaimed=1), got %d", claimer.unclaimed)
	}

	// Attempt 2 (Retry): Must NOT be treated as a duplicate; must re-run and succeed.
	res, err := reconciler.ProcessVerifiedEvent(ctx, evt)
	if err != nil {
		t.Fatalf("expected retry attempt to succeed, got %v", err)
	}
	if res.Duplicate {
		t.Fatalf("SECURITY/RELIABILITY BUG: retry after failed webhook was skipped as Duplicate=true")
	}

	// Attempt 3: Subsequent replay after successful processing is deduplicated.
	res3, err := reconciler.ProcessVerifiedEvent(ctx, evt)
	if err != nil || !res3.Duplicate {
		t.Fatalf("expected third delivery after success to return Duplicate=true, got res=%+v err=%v", res3, err)
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
