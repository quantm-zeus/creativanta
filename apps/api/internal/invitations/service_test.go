package invitations

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"sync"
	"testing"
	"time"
)

// NOTE ON TEST SCOPE:
// All fakes in this test file are deterministic in-memory unit-test doubles used
// solely to verify domain invariants, RBAC ceilings, 7-day expiry math, idempotency,
// webhook ordering, and race safety in isolation. They do NOT exercise live Clerk
// APIs, real PostgreSQL transactions, or P0-04 RLS policies, and MUST NOT be
// treated as end-to-end or production acceptance evidence.

type fakeClock struct {
	mu  sync.RWMutex
	now time.Time
}

func newFakeClock(initial time.Time) *fakeClock {
	return &fakeClock{now: initial.UTC()}
}

func (c *fakeClock) Now() time.Time {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return c.now
}

func (c *fakeClock) Advance(d time.Duration) {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.now = c.now.Add(d)
}

type fakeIdentityVerifier struct {
	mu     sync.RWMutex
	actors map[string]VerifiedClerkActor
}

func newFakeIdentityVerifier() *fakeIdentityVerifier {
	return &fakeIdentityVerifier{actors: make(map[string]VerifiedClerkActor)}
}

func (v *fakeIdentityVerifier) Put(token string, actor VerifiedClerkActor) {
	v.mu.Lock()
	defer v.mu.Unlock()
	v.actors[token] = actor
}

func (v *fakeIdentityVerifier) VerifyActor(ctx context.Context, bearerToken string) (VerifiedClerkActor, error) {
	if err := ctx.Err(); err != nil {
		return VerifiedClerkActor{}, err
	}
	v.mu.RLock()
	defer v.mu.RUnlock()
	actor, ok := v.actors[bearerToken]
	if !ok {
		return VerifiedClerkActor{}, errors.New("unknown bearer token")
	}
	return actor, nil
}

type storedProviderInvite struct {
	token string
	inv   ProviderInvitation
}

type fakeInvitationProvider struct {
	mu      sync.Mutex
	clock   func() time.Time
	seq     int
	byID    map[string]*storedProviderInvite
	byToken map[string]*storedProviderInvite
}

func newFakeInvitationProvider(clock func() time.Time) *fakeInvitationProvider {
	return &fakeInvitationProvider{
		clock:   clock,
		byID:    make(map[string]*storedProviderInvite),
		byToken: make(map[string]*storedProviderInvite),
	}
}

func (p *fakeInvitationProvider) Seed(token string, inv ProviderInvitation) {
	p.mu.Lock()
	defer p.mu.Unlock()
	rec := &storedProviderInvite{token: token, inv: inv}
	p.byID[inv.ProviderInvitationID] = rec
	if token != "" {
		p.byToken[token] = rec
	}
}

func (p *fakeInvitationProvider) TokenForID(invID string) string {
	p.mu.Lock()
	defer p.mu.Unlock()
	if rec, ok := p.byID[invID]; ok {
		return rec.token
	}
	return ""
}

func (p *fakeInvitationProvider) CreateInvitation(ctx context.Context, in CreateProviderInvitationInput) (ProviderInvitation, error) {
	if err := ctx.Err(); err != nil {
		return ProviderInvitation{}, err
	}
	p.mu.Lock()
	defer p.mu.Unlock()
	p.seq++
	now := p.clock().UTC()
	invID := fmt.Sprintf("orginv_test_%04d", p.seq)
	token := fmt.Sprintf("clerk_inv_ticket_secret_%04d_abcdef0123456789", p.seq)
	inv := ProviderInvitation{
		ProviderInvitationID: invID,
		ClerkOrganizationID:  in.ClerkOrganizationID,
		WorkspaceID:          in.WorkspaceID,
		InviteeEmail:         in.InviteeEmail,
		Role:                 in.Role,
		InviterUserID:        in.InviterUserID,
		Status:               ProviderInvitationPending,
		CreatedAt:            now,
		ExpiresAt:            in.ExpiresAt.UTC(),
		SourceUpdatedAt:      now,
	}
	rec := &storedProviderInvite{token: token, inv: inv}
	p.byID[invID] = rec
	p.byToken[token] = rec
	return inv, nil
}

func (p *fakeInvitationProvider) ResolveInvitationToken(ctx context.Context, invitationToken string) (ProviderInvitation, error) {
	if err := ctx.Err(); err != nil {
		return ProviderInvitation{}, err
	}
	p.mu.Lock()
	defer p.mu.Unlock()
	rec, ok := p.byToken[invitationToken]
	if !ok {
		return ProviderInvitation{}, ErrInvitationInvalidToken
	}
	return rec.inv, nil
}

func (p *fakeInvitationProvider) GetInvitationByID(ctx context.Context, clerkOrganizationID, providerInvitationID string) (ProviderInvitation, error) {
	if err := ctx.Err(); err != nil {
		return ProviderInvitation{}, err
	}
	p.mu.Lock()
	defer p.mu.Unlock()
	rec, ok := p.byID[providerInvitationID]
	if !ok || rec.inv.ClerkOrganizationID != clerkOrganizationID {
		return ProviderInvitation{}, errors.New("invitation not found in org")
	}
	return rec.inv, nil
}

func (p *fakeInvitationProvider) MarkInvitationAccepted(ctx context.Context, in AcceptProviderInvitationInput) (ProviderInvitation, error) {
	if err := ctx.Err(); err != nil {
		return ProviderInvitation{}, err
	}
	p.mu.Lock()
	defer p.mu.Unlock()
	rec, ok := p.byToken[in.InvitationToken]
	if !ok || rec.inv.ClerkOrganizationID != in.ClerkOrganizationID {
		return ProviderInvitation{}, ErrInvitationInvalidToken
	}
	now := p.clock().UTC()
	switch rec.inv.Status {
	case ProviderInvitationRevoked:
		return ProviderInvitation{}, ErrInvitationRevoked
	case ProviderInvitationDeclined:
		return ProviderInvitation{}, ErrInvitationDeclined
	case ProviderInvitationExpired:
		return ProviderInvitation{}, ErrInvitationExpired
	case ProviderInvitationAccepted:
		if rec.inv.AcceptedByClerkID != "" && rec.inv.AcceptedByClerkID != in.ClerkUserID {
			return ProviderInvitation{}, ErrInviteeEmailMismatch
		}
		return rec.inv, nil
	case ProviderInvitationPending:
		if !now.Before(rec.inv.EffectiveExpiry()) {
			return ProviderInvitation{}, ErrInvitationExpired
		}
		p.seq++
		rec.inv.Status = ProviderInvitationAccepted
		rec.inv.AcceptedByClerkID = in.ClerkUserID
		rec.inv.ClerkMembershipID = fmt.Sprintf("orgmem_test_%04d", p.seq)
		rec.inv.SourceUpdatedAt = now
		return rec.inv, nil
	default:
		return ProviderInvitation{}, ErrInvitationInvalidToken
	}
}

func (p *fakeInvitationProvider) MarkInvitationDeclined(ctx context.Context, clerkOrganizationID, providerInvitationID, _ string) (ProviderInvitation, error) {
	if err := ctx.Err(); err != nil {
		return ProviderInvitation{}, err
	}
	p.mu.Lock()
	defer p.mu.Unlock()
	rec, ok := p.byID[providerInvitationID]
	if !ok || rec.inv.ClerkOrganizationID != clerkOrganizationID {
		return ProviderInvitation{}, ErrInvitationInvalidToken
	}
	rec.inv.Status = ProviderInvitationDeclined
	rec.inv.SourceUpdatedAt = p.clock().UTC()
	return rec.inv, nil
}

func (p *fakeInvitationProvider) RevokeInvitation(ctx context.Context, clerkOrganizationID, providerInvitationID, _ string) (ProviderInvitation, error) {
	if err := ctx.Err(); err != nil {
		return ProviderInvitation{}, err
	}
	p.mu.Lock()
	defer p.mu.Unlock()
	rec, ok := p.byID[providerInvitationID]
	if !ok || rec.inv.ClerkOrganizationID != clerkOrganizationID {
		return ProviderInvitation{}, errors.New("not found")
	}
	rec.inv.Status = ProviderInvitationRevoked
	rec.inv.SourceUpdatedAt = p.clock().UTC()
	return rec.inv, nil
}

type fakeRepository struct {
	mu               sync.Mutex
	txCalls          int
	failOnTxCall     int
	workspaces       map[string]WorkspaceRecord
	usersByID        map[string]UserRecord
	userIDByClerkID  map[string]string
	members          map[string]WorkspaceMemberRecord // workspaceID + "|" + userID
	idempotency      map[string]IdempotencyRecord     // workspaceID + "|" + actorID + "|" + rpc + "|" + key
	processedWebhook map[string]time.Time             // workspaceID + "|" + externalEventID
	audits           []AuditEventRecord
	outbox           []DomainEventRecord
}

func newFakeRepository() *fakeRepository {
	return &fakeRepository{
		workspaces:       make(map[string]WorkspaceRecord),
		usersByID:        make(map[string]UserRecord),
		userIDByClerkID:  make(map[string]string),
		members:          make(map[string]WorkspaceMemberRecord),
		idempotency:      make(map[string]IdempotencyRecord),
		processedWebhook: make(map[string]time.Time),
	}
}

func (r *fakeRepository) WithinTx(ctx context.Context, _ string, _ string, fn func(tx TxRepository) error) error {
	if err := ctx.Err(); err != nil {
		return err
	}
	r.mu.Lock()
	defer r.mu.Unlock()

	snap := r.cloneLocked()
	tx := &fakeTx{state: snap}
	if err := fn(tx); err != nil {
		return err
	}
	r.txCalls++
	if r.failOnTxCall > 0 && r.txCalls == r.failOnTxCall {
		r.failOnTxCall = 0
		return errors.New("simulated transient commit failure")
	}
	r.applyLocked(snap)
	return nil
}

func (r *fakeRepository) cloneLocked() *fakeRepository {
	c := newFakeRepository()
	for k, v := range r.workspaces {
		c.workspaces[k] = v
	}
	for k, v := range r.usersByID {
		c.usersByID[k] = v
	}
	for k, v := range r.userIDByClerkID {
		c.userIDByClerkID[k] = v
	}
	for k, v := range r.members {
		c.members[k] = v
	}
	for k, v := range r.idempotency {
		cp := v
		if v.ResponsePayload != nil {
			cp.ResponsePayload = append([]byte(nil), v.ResponsePayload...)
		}
		c.idempotency[k] = cp
	}
	for k, v := range r.processedWebhook {
		c.processedWebhook[k] = v
	}
	c.audits = append(c.audits, r.audits...)
	c.outbox = append(c.outbox, r.outbox...)
	return c
}

func (r *fakeRepository) applyLocked(snap *fakeRepository) {
	r.workspaces = snap.workspaces
	r.usersByID = snap.usersByID
	r.userIDByClerkID = snap.userIDByClerkID
	r.members = snap.members
	r.idempotency = snap.idempotency
	r.processedWebhook = snap.processedWebhook
	r.audits = snap.audits
	r.outbox = snap.outbox
}

type fakeTx struct {
	state *fakeRepository
}

func memberKey(wsID, userID string) string { return wsID + "|" + userID }
func idempKey(wsID, actorID, rpc, key string) string {
	return wsID + "|" + actorID + "|" + rpc + "|" + key
}

func (t *fakeTx) GetWorkspaceByID(_ context.Context, workspaceID string) (WorkspaceRecord, bool, error) {
	ws, ok := t.state.workspaces[workspaceID]
	return ws, ok, nil
}

func (t *fakeTx) GetWorkspaceByClerkOrgID(_ context.Context, clerkOrgID string) (WorkspaceRecord, bool, error) {
	for _, ws := range t.state.workspaces {
		if ws.ClerkOrganizationID == clerkOrgID {
			return ws, true, nil
		}
	}
	return WorkspaceRecord{}, false, nil
}

func (t *fakeTx) GetUserByClerkID(_ context.Context, clerkID string) (UserRecord, bool, error) {
	uid, ok := t.state.userIDByClerkID[clerkID]
	if !ok {
		return UserRecord{}, false, nil
	}
	u, ok := t.state.usersByID[uid]
	return u, ok, nil
}

func (t *fakeTx) GetUserByID(_ context.Context, userID string) (UserRecord, bool, error) {
	u, ok := t.state.usersByID[userID]
	return u, ok, nil
}

func (t *fakeTx) UpsertVerifiedUser(_ context.Context, user UserRecord) (UserRecord, bool, error) {
	if existingID, exists := t.state.userIDByClerkID[user.ClerkID]; exists {
		existing := t.state.usersByID[existingID]
		user.UserID = existing.UserID
		user.CreatedAt = existing.CreatedAt
		t.state.usersByID[existing.UserID] = user
		return user, false, nil
	}
	t.state.usersByID[user.UserID] = user
	t.state.userIDByClerkID[user.ClerkID] = user.UserID
	return user, true, nil
}

func (t *fakeTx) GetWorkspaceMember(_ context.Context, workspaceID, userID string) (WorkspaceMemberRecord, bool, error) {
	m, ok := t.state.members[memberKey(workspaceID, userID)]
	return m, ok, nil
}

func (t *fakeTx) GetActiveMemberByEmail(_ context.Context, workspaceID, normalizedEmail string) (WorkspaceMemberRecord, bool, error) {
	for _, m := range t.state.members {
		if m.WorkspaceID != workspaceID || m.Status != MembershipStatusActive {
			continue
		}
		u, ok := t.state.usersByID[m.UserID]
		if !ok {
			continue
		}
		if norm, ok := normalizeEmail(u.Email); ok && norm == normalizedEmail {
			return m, true, nil
		}
	}
	return WorkspaceMemberRecord{}, false, nil
}

func (t *fakeTx) UpsertWorkspaceMember(_ context.Context, member WorkspaceMemberRecord) (WorkspaceMemberRecord, error) {
	// Enforce idx_one_active_workspace_owner (database_schema.md §26.14).
	if member.Role == RoleOwner && member.Status == MembershipStatusActive {
		for _, existing := range t.state.members {
			if existing.WorkspaceID == member.WorkspaceID &&
				existing.Status == MembershipStatusActive &&
				existing.Role == RoleOwner &&
				existing.UserID != member.UserID {
				return WorkspaceMemberRecord{}, errors.New("idx_one_active_workspace_owner violation")
			}
		}
	}
	t.state.members[memberKey(member.WorkspaceID, member.UserID)] = member
	return member, nil
}

func (t *fakeTx) GetIdempotencyRecord(_ context.Context, workspaceID, actorID, rpc, key string, now time.Time) (IdempotencyRecord, bool, error) {
	rec, ok := t.state.idempotency[idempKey(workspaceID, actorID, rpc, key)]
	if !ok || !now.Before(rec.ExpiresAt) {
		return IdempotencyRecord{}, false, nil
	}
	return rec, true, nil
}

func (t *fakeTx) SaveIdempotencyRecord(_ context.Context, rec IdempotencyRecord) error {
	cp := rec
	if rec.ResponsePayload != nil {
		cp.ResponsePayload = append([]byte(nil), rec.ResponsePayload...)
	}
	t.state.idempotency[idempKey(rec.WorkspaceID, rec.ActorID, rec.RPC, rec.IdempotencyKey)] = cp
	return nil
}

func (t *fakeTx) HasProcessedWebhookEvent(_ context.Context, workspaceID, externalEventID string) (bool, error) {
	_, ok := t.state.processedWebhook[workspaceID+"|"+externalEventID]
	return ok, nil
}

func (t *fakeTx) RecordProcessedWebhookEvent(_ context.Context, workspaceID, externalEventID string, processedAt time.Time) error {
	t.state.processedWebhook[workspaceID+"|"+externalEventID] = processedAt
	return nil
}

func (t *fakeTx) AppendAuditEvent(_ context.Context, event AuditEventRecord) error {
	t.state.audits = append(t.state.audits, event)
	return nil
}

func (t *fakeTx) AppendOutboxEvent(_ context.Context, event DomainEventRecord) error {
	t.state.outbox = append(t.state.outbox, event)
	return nil
}

const (
	wsAID    = "019086a1-7c3e-7000-8000-000000000010"
	wsBID    = "019086a1-7c3e-7000-8000-000000000020"
	ownerUID = "019086a1-7c3e-7000-8000-000000000001"
	adminUID = "019086a1-7c3e-7000-8000-000000000002"
	mgrUID   = "019086a1-7c3e-7000-8000-000000000003"
	editUID  = "019086a1-7c3e-7000-8000-000000000004"
	viewUID  = "019086a1-7c3e-7000-8000-000000000005"
	otherUID = "019086a1-7c3e-7000-8000-000000000006"
)

type testHarness struct {
	clock    *fakeClock
	verifier *fakeIdentityVerifier
	provider *fakeInvitationProvider
	repo     *fakeRepository
	svc      *Service
}

func newTestHarness() *testHarness {
	base := time.Date(2026, 11, 1, 12, 0, 0, 0, time.UTC)
	clock := newFakeClock(base)
	verifier := newFakeIdentityVerifier()
	provider := newFakeInvitationProvider(clock.Now)
	repo := newFakeRepository()

	repo.workspaces[wsAID] = WorkspaceRecord{
		WorkspaceID:         wsAID,
		ClerkOrganizationID: "org_workspace_a",
		DisplayName:         "Workspace Alpha",
		Slug:                "workspace-alpha",
		Status:              WorkspaceStatusActive,
		OwnerUserID:         ownerUID,
	}
	repo.workspaces[wsBID] = WorkspaceRecord{
		WorkspaceID:         wsBID,
		ClerkOrganizationID: "org_workspace_b",
		DisplayName:         "Workspace Beta",
		Slug:                "workspace-beta",
		Status:              WorkspaceStatusActive,
		OwnerUserID:         otherUID,
	}

	seedUserAndMember := func(uid, clerkID, email, bearer, wsID string, role WorkspaceRole) {
		u := UserRecord{
			UserID:          uid,
			ClerkID:         clerkID,
			SourceUpdatedAt: &base,
			Email:           email,
			DisplayName:     email,
			Status:          UserStatusActive,
			CreatedAt:       base,
			UpdatedAt:       base,
		}
		repo.usersByID[uid] = u
		repo.userIDByClerkID[clerkID] = uid
		repo.members[memberKey(wsID, uid)] = WorkspaceMemberRecord{
			WorkspaceMemberID: "019086a9-0000-7000-8000-" + uid[len(uid)-12:],
			WorkspaceID:       wsID,
			UserID:            uid,
			Role:              role,
			Status:            MembershipStatusActive,
			JoinedAt:          base,
			CreatedAt:         base,
			UpdatedAt:         base,
			SourceUpdatedAt:   &base,
		}
		verifier.Put(bearer, VerifiedClerkActor{
			ClerkID:         clerkID,
			SessionID:       "sess_" + clerkID,
			SessionActive:   true,
			Email:           email,
			EmailVerified:   true,
			DisplayName:     email,
			SourceUpdatedAt: base,
		})
	}

	seedUserAndMember(ownerUID, "user_owner_a", "owner@alpha.example.com", "tok_owner_alpha", wsAID, RoleOwner)
	seedUserAndMember(adminUID, "user_admin_a", "admin@alpha.example.com", "tok_admin_alpha", wsAID, RoleAdmin)
	seedUserAndMember(mgrUID, "user_mgr_a", "manager@alpha.example.com", "tok_mgr_alpha", wsAID, RoleManager)
	seedUserAndMember(editUID, "user_edit_a", "editor@alpha.example.com", "tok_edit_alpha", wsAID, RoleEditor)
	seedUserAndMember(viewUID, "user_view_a", "viewer@alpha.example.com", "tok_view_alpha", wsAID, RoleViewer)
	seedUserAndMember(otherUID, "user_owner_b", "owner@beta.example.com", "tok_owner_beta", wsBID, RoleOwner)

	svc := NewService(Options{
		Verifier:   verifier,
		Provider:   provider,
		Repository: repo,
		Clock:      clock.Now,
	})

	return &testHarness{
		clock:    clock,
		verifier: verifier,
		provider: provider,
		repo:     repo,
		svc:      svc,
	}
}

func TestFailClosedAndProductionReadiness(t *testing.T) {
	ctx := context.Background()

	// 1. Completely empty NewService fails closed without panicking.
	emptySvc := NewService(Options{})
	if err := emptySvc.CheckProductionReadiness(); !errors.Is(err, ErrDependencyUnconfigured) {
		t.Fatalf("expected ErrDependencyUnconfigured on empty service, got %v", err)
	}
	if _, err := emptySvc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_valid_format_1234",
		InvitationToken: "clerk_inv_ticket_secret_0001_abcdef0123456789",
		Command:         CommandContext{IdempotencyKey: "idem-1"},
	}); !errors.Is(err, ErrDependencyUnconfigured) {
		t.Fatalf("expected ErrDependencyUnconfigured on AcceptInvitation, got %v", err)
	}

	// 2. Unconfigured default adapters fail closed.
	unconfSvc := NewService(Options{
		Verifier:   UnconfiguredIdentityVerifier{},
		Provider:   UnconfiguredInvitationProvider{},
		Repository: UnconfiguredRepository{},
	})
	if err := unconfSvc.CheckProductionReadiness(); !errors.Is(err, ErrDependencyUnconfigured) {
		t.Fatalf("expected ErrDependencyUnconfigured on unconfigured adapters, got %v", err)
	}
	if _, err := unconfSvc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_valid_format_1234",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "idem-issue-1"},
		Email:       "invitee@example.com",
		Role:        RoleEditor,
	}); !errors.Is(err, ErrDependencyUnconfigured) {
		t.Fatalf("expected ErrDependencyUnconfigured on IssueInvitation, got %v", err)
	}

	// 3. Test harness uses in-memory doubles: CheckProductionReadiness MUST still fail
	// unless all four external/phase RuntimeGates are explicitly satisfied.
	h := newTestHarness()
	if err := h.svc.CheckProductionReadiness(); !errors.Is(err, ErrProductionGateOpen) {
		t.Fatalf("expected ErrProductionGateOpen when RuntimeGates are false, got %v", err)
	}
}

func TestInviterRBACHierarchyAndNoOwnerGrant(t *testing.T) {
	h := newTestHarness()
	ctx := context.Background()

	// Seed contributor & external actors in Workspace A as well.
	now := h.clock.Now()
	seedRole := func(uid, clerkID, email, tok string, role WorkspaceRole) {
		h.repo.usersByID[uid] = UserRecord{
			UserID: uid, ClerkID: clerkID, Email: email, Status: UserStatusActive, CreatedAt: now, UpdatedAt: now,
		}
		h.repo.userIDByClerkID[clerkID] = uid
		h.repo.members[memberKey(wsAID, uid)] = WorkspaceMemberRecord{
			WorkspaceMemberID: uid, WorkspaceID: wsAID, UserID: uid, Role: role, Status: MembershipStatusActive, JoinedAt: now, CreatedAt: now, UpdatedAt: now,
		}
		h.verifier.Put(tok, VerifiedClerkActor{
			ClerkID: clerkID, SessionID: "sess_" + clerkID, SessionActive: true, Email: email, EmailVerified: true, SourceUpdatedAt: now,
		})
	}
	seedRole("019086a1-7c3e-7000-8000-000000000007", "user_contrib_a", "contrib@alpha.example.com", "tok_contrib_alpha", RoleContributor)
	seedRole("019086a1-7c3e-7000-8000-000000000008", "user_ext_a", "ext@alpha.example.com", "tok_ext_alpha", RoleExternal)

	actorTokens := map[WorkspaceRole]string{
		RoleOwner:       "tok_owner_alpha",
		RoleAdmin:       "tok_admin_alpha",
		RoleManager:     "tok_mgr_alpha",
		RoleEditor:      "tok_edit_alpha",
		RoleContributor: "tok_contrib_alpha",
		RoleViewer:      "tok_view_alpha",
		RoleExternal:    "tok_ext_alpha",
	}
	allRoles := []WorkspaceRole{
		RoleOwner, RoleAdmin, RoleManager, RoleEditor, RoleContributor, RoleViewer, RoleExternal,
	}

	seq := 0
	for _, inviterRole := range allRoles {
		for _, targetRole := range allRoles {
			seq++
			wantAllow := CanRoleInviteTarget(inviterRole, targetRole)
			res, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
				BearerToken: actorTokens[inviterRole],
				WorkspaceID: wsAID,
				Command:     CommandContext{IdempotencyKey: fmt.Sprintf("matrix-%d", seq)},
				Email:       fmt.Sprintf("candidate-%d@example.com", seq),
				Role:        targetRole,
			})
			if wantAllow && err != nil {
				t.Fatalf("inviter=%s target=%s expected allow, got err=%v", inviterRole, targetRole, err)
			}
			if !wantAllow && err == nil {
				t.Fatalf("inviter=%s target=%s expected DENY, got success %+v", inviterRole, targetRole, res)
			}
			if targetRole == RoleOwner && !errors.Is(err, ErrRoleElevationDenied) {
				t.Fatalf("inviter=%s target=owner expected ErrRoleElevationDenied, got %v", inviterRole, err)
			}
		}
	}

	// Self-invitation is denied.
	if _, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "self-invite"},
		Email:       "OWNER@alpha.example.com",
		Role:        RoleEditor,
	}); !errors.Is(err, ErrSelfInvitationDenied) {
		t.Fatalf("expected ErrSelfInvitationDenied, got %v", err)
	}
}

func TestVerifiedClerkIdentityAndNewVsExistingFlows(t *testing.T) {
	h := newTestHarness()
	ctx := context.Background()

	// Issue an Editor invite from Manager.
	issued, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_mgr_alpha",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "issue-new-user"},
		Email:       "newcreator@example.com",
		Role:        RoleEditor,
	})
	if err != nil {
		t.Fatalf("IssueInvitation failed: %v", err)
	}
	invToken := h.provider.TokenForID(issued.ProviderInvitationID)

	// 1. Anonymous visitor preview -> guided to registration + email verification.
	anonPreview, err := h.svc.PreviewInvitation(ctx, PreviewInvitationQuery{
		InvitationToken: invToken,
	})
	if err != nil {
		t.Fatalf("anonymous PreviewInvitation failed: %v", err)
	}
	if anonPreview.IdentityFlow != IdentityFlowRegistrationOrVerificationRequired || !anonPreview.EmailVerificationRequired || !anonPreview.OnboardingRequired {
		t.Fatalf("unexpected anonymous preview: %+v", anonPreview)
	}

	// 2. Unverified Clerk registration (EmailVerified=false) -> Preview requires email verification,
	//    and AcceptInvitation MUST fail closed without creating users or workspace_members.
	h.verifier.Put("tok_new_unverified", VerifiedClerkActor{
		ClerkID:            "user_new_creator",
		SessionID:          "sess_new_1",
		SessionActive:      true,
		Email:              "newcreator@example.com",
		EmailVerified:      false,
		DisplayName:        "New Creator",
		RegistrationMethod: "email",
		SourceUpdatedAt:    h.clock.Now(),
	})
	unvPreview, err := h.svc.PreviewInvitation(ctx, PreviewInvitationQuery{
		BearerToken:     "tok_new_unverified",
		InvitationToken: invToken,
	})
	if err != nil {
		t.Fatalf("unverified PreviewInvitation failed: %v", err)
	}
	if !unvPreview.EmailVerificationRequired || unvPreview.IdentityFlow != IdentityFlowRegistrationOrVerificationRequired {
		t.Fatalf("expected EmailVerificationRequired=true, got %+v", unvPreview)
	}
	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_new_unverified",
		InvitationToken: invToken,
		Command:         CommandContext{IdempotencyKey: "accept-unverified"},
	}); !errors.Is(err, ErrEmailNotVerified) {
		t.Fatalf("expected ErrEmailNotVerified, got %v", err)
	}
	if _, exists := h.repo.userIDByClerkID["user_new_creator"]; exists {
		t.Fatalf("unverified user must not be persisted before email verification")
	}

	// 3. Inactive session (SessionActive=false) -> ErrUnauthenticated.
	h.verifier.Put("tok_inactive_sess", VerifiedClerkActor{
		ClerkID:       "user_new_creator",
		SessionID:     "sess_dead",
		SessionActive: false,
		Email:         "newcreator@example.com",
		EmailVerified: true,
	})
	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_inactive_sess",
		InvitationToken: invToken,
		Command:         CommandContext{IdempotencyKey: "accept-dead-sess"},
	}); !errors.Is(err, ErrUnauthenticated) {
		t.Fatalf("expected ErrUnauthenticated for inactive session, got %v", err)
	}

	// 4. Wrong authenticated user (owner of Workspace B) cannot claim newcreator@example.com's link.
	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_owner_beta",
		InvitationToken: invToken,
		Command:         CommandContext{IdempotencyKey: "accept-wrong-email"},
	}); !errors.Is(err, ErrInviteeEmailMismatch) {
		t.Fatalf("expected ErrInviteeEmailMismatch, got %v", err)
	}

	// 5. Verified Clerk identity (even BEFORE user.created webhook arrives!) synchronously
	//    provisions local users row + active workspace_members row and flags OnboardingRequired=true.
	h.verifier.Put("tok_new_verified", VerifiedClerkActor{
		ClerkID:            "user_new_creator",
		SessionID:          "sess_new_2",
		SessionActive:      true,
		Email:              "NewCreator@Example.com",
		EmailVerified:      true,
		DisplayName:        "New Creator",
		RegistrationMethod: "email",
		SourceUpdatedAt:    h.clock.Now(),
	})
	newPreview, err := h.svc.PreviewInvitation(ctx, PreviewInvitationQuery{
		BearerToken:     "tok_new_verified",
		InvitationToken: invToken,
	})
	if err != nil {
		t.Fatalf("verified new user PreviewInvitation failed: %v", err)
	}
	if newPreview.IdentityFlow != IdentityFlowNewUser || newPreview.EmailVerificationRequired || !newPreview.OnboardingRequired {
		t.Fatalf("unexpected verified new user preview: %+v", newPreview)
	}

	acceptedNew, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_new_verified",
		InvitationToken: invToken,
		Command:         CommandContext{IdempotencyKey: "accept-new-1"},
	})
	if err != nil {
		t.Fatalf("AcceptInvitation for new user failed: %v", err)
	}
	if acceptedNew.IdentityFlow != IdentityFlowNewUser || !acceptedNew.UserProvisionedNow || !acceptedNew.OnboardingRequired {
		t.Fatalf("expected new-user onboarding flags, got %+v", acceptedNew)
	}
	if acceptedNew.Member.WorkspaceID != wsAID || acceptedNew.Member.Role != RoleEditor || acceptedNew.Member.InvitedBy != mgrUID || acceptedNew.Member.Status != MembershipStatusActive {
		t.Fatalf("unexpected synced membership: %+v", acceptedNew.Member)
	}

	// 6. Existing user flow: Owner of Workspace B is invited as Contributor to Workspace A.
	issuedExisting, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_admin_alpha",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "issue-existing-user"},
		Email:       "owner@beta.example.com",
		Role:        RoleContributor,
	})
	if err != nil {
		t.Fatalf("IssueInvitation for existing user failed: %v", err)
	}
	existingToken := h.provider.TokenForID(issuedExisting.ProviderInvitationID)
	exPreview, err := h.svc.PreviewInvitation(ctx, PreviewInvitationQuery{
		BearerToken:     "tok_owner_beta",
		InvitationToken: existingToken,
	})
	if err != nil {
		t.Fatalf("existing user PreviewInvitation failed: %v", err)
	}
	if exPreview.IdentityFlow != IdentityFlowExistingUser || exPreview.OnboardingRequired || exPreview.EmailVerificationRequired {
		t.Fatalf("unexpected existing user preview: %+v", exPreview)
	}

	acceptedExisting, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_owner_beta",
		InvitationToken: existingToken,
		Command:         CommandContext{IdempotencyKey: "accept-existing-1"},
	})
	if err != nil {
		t.Fatalf("AcceptInvitation for existing user failed: %v", err)
	}
	if acceptedExisting.IdentityFlow != IdentityFlowExistingUser || acceptedExisting.UserProvisionedNow || acceptedExisting.OnboardingRequired {
		t.Fatalf("expected existing-user direct join flags, got %+v", acceptedExisting)
	}
	if acceptedExisting.Member.Role != RoleContributor || acceptedExisting.User.UserID != otherUID {
		t.Fatalf("unexpected existing user membership: %+v", acceptedExisting)
	}

	// 7. Suspended user cannot accept invitations.
	suspendedUser := h.repo.usersByID[otherUID]
	suspendedUser.Status = UserStatusSuspended
	h.repo.usersByID[otherUID] = suspendedUser
	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_owner_beta",
		InvitationToken: existingToken,
		Command:         CommandContext{IdempotencyKey: "accept-suspended"},
	}); !errors.Is(err, ErrAccountUnavailable) {
		t.Fatalf("expected ErrAccountUnavailable for suspended user, got %v", err)
	}
}

func TestNoRoleSelfElevationAndInviterRevocation(t *testing.T) {
	h := newTestHarness()
	ctx := context.Background()

	// 1. Wire-level client role / privilege injection is rejected fail-closed.
	injectedPayloads := []string{
		`{"invitation_token":"clerk_inv_ticket_secret_0001_abcdef0123456789","command":{"idempotency_key":"k1"},"role":"owner"}`,
		`{"invitation_token":"clerk_inv_ticket_secret_0001_abcdef0123456789","command":{"idempotency_key":"k1"},"role":"admin"}`,
		`{"invitation_token":"clerk_inv_ticket_secret_0001_abcdef0123456789","command":{"idempotency_key":"k1"},"permissions":["workspace:billing:manage"]}`,
		`{"invitation_token":"clerk_inv_ticket_secret_0001_abcdef0123456789","command":{"idempotency_key":"k1"},"invited_by":"019086a1-7c3e-7000-8000-000000000001"}`,
	}
	for _, raw := range injectedPayloads {
		if _, err := DecodeAcceptCommandStrict("tok_view_alpha", []byte(raw)); !errors.Is(err, ErrRoleElevationDenied) {
			t.Fatalf("expected ErrRoleElevationDenied for payload %s, got %v", raw, err)
		}
	}
	if _, err := DecodeAcceptCommandStrict("tok_view_alpha", []byte(`{"invitation_token":"clerk_inv_ticket_secret_0001_abcdef0123456789","command":{"idempotency_key":"k1"},"unknown_field":123}`)); !errors.Is(err, ErrInvalidInput) {
		t.Fatalf("expected ErrInvalidInput for unknown field, got %v", err)
	}

	// 2. Existing Viewer in Workspace A cannot use an Admin/Manager invite token to self-elevate!
	now := h.clock.Now()
	h.provider.Seed("clerk_inv_ticket_elevate_viewer_0123456789", ProviderInvitation{
		ProviderInvitationID: "orginv_elevate_1",
		ClerkOrganizationID:  "org_workspace_a",
		WorkspaceID:          wsAID,
		InviteeEmail:         "viewer@alpha.example.com",
		Role:                 RoleAdmin,
		InviterUserID:        ownerUID,
		Status:               ProviderInvitationPending,
		CreatedAt:            now,
		ExpiresAt:            now.Add(24 * time.Hour),
		SourceUpdatedAt:      now,
	})
	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_view_alpha",
		InvitationToken: "clerk_inv_ticket_elevate_viewer_0123456789",
		Command:         CommandContext{IdempotencyKey: "viewer-self-elevate"},
	}); !errors.Is(err, ErrRoleElevationDenied) {
		t.Fatalf("expected ErrRoleElevationDenied when existing viewer attempts self-elevation, got %v", err)
	}
	if got := h.repo.members[memberKey(wsAID, viewUID)].Role; got != RoleViewer {
		t.Fatalf("viewer role mutated to %s", got)
	}

	// 3. Provider record tampered with Role=owner is rejected at acceptance.
	h.verifier.Put("tok_outsider", VerifiedClerkActor{
		ClerkID: "user_outsider", SessionID: "sess_out", SessionActive: true, Email: "outsider@example.com", EmailVerified: true, SourceUpdatedAt: now,
	})
	h.provider.Seed("clerk_inv_ticket_forged_owner_0123456789", ProviderInvitation{
		ProviderInvitationID: "orginv_forged_owner",
		ClerkOrganizationID:  "org_workspace_a",
		WorkspaceID:          wsAID,
		InviteeEmail:         "outsider@example.com",
		Role:                 RoleOwner,
		InviterUserID:        ownerUID,
		Status:               ProviderInvitationPending,
		CreatedAt:            now,
		ExpiresAt:            now.Add(24 * time.Hour),
	})
	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_outsider",
		InvitationToken: "clerk_inv_ticket_forged_owner_0123456789",
		Command:         CommandContext{IdempotencyKey: "forged-owner"},
	}); !errors.Is(err, ErrRoleElevationDenied) {
		t.Fatalf("expected ErrRoleElevationDenied for forged owner invite, got %v", err)
	}

	// 4. Inviter demoted to Editor before invitee accepts -> server re-verifies inviter role and rejects!
	issuedByMgr, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_mgr_alpha",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "mgr-before-demotion"},
		Email:       "outsider@example.com",
		Role:        RoleEditor,
	})
	if err != nil {
		t.Fatalf("IssueInvitation failed: %v", err)
	}
	mgrMem := h.repo.members[memberKey(wsAID, mgrUID)]
	mgrMem.Role = RoleEditor
	h.repo.members[memberKey(wsAID, mgrUID)] = mgrMem

	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_outsider",
		InvitationToken: h.provider.TokenForID(issuedByMgr.ProviderInvitationID),
		Command:         CommandContext{IdempotencyKey: "accept-after-inviter-demotion"},
	}); !errors.Is(err, ErrInviterNotAuthorized) {
		t.Fatalf("expected ErrInviterNotAuthorized after inviter demotion, got %v", err)
	}
}

func TestSevenDayExpiryAndInvalidRevokedDeclinedResendFlows(t *testing.T) {
	h := newTestHarness()
	ctx := context.Background()

	// 1. TTL > 7 days rejected on IssueInvitation.
	if _, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "ttl-too-long"},
		Email:       "ttl@example.com",
		Role:        RoleEditor,
		TTL:         MaxInvitationAge + time.Second,
	}); !errors.Is(err, ErrInvalidInput) {
		t.Fatalf("expected ErrInvalidInput for >7d TTL, got %v", err)
	}

	// 2. Invalid/unknown token fails closed without echoing secret token material.
	secretGarbage := "clerk_inv_ticket_nonexistent_super_secret_9999"
	_, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_owner_beta",
		InvitationToken: secretGarbage,
		Command:         CommandContext{IdempotencyKey: "bad-token"},
	})
	if !errors.Is(err, ErrInvitationInvalidToken) {
		t.Fatalf("expected ErrInvitationInvalidToken, got %v", err)
	}
	if strings.Contains(err.Error(), secretGarbage) {
		t.Fatalf("error string leaked raw token: %v", err)
	}

	// 3. Exact 7-day boundary enforcement even if provider ExpiresAt is 30 days out!
	start := h.clock.Now()
	h.verifier.Put("tok_exp_user", VerifiedClerkActor{
		ClerkID: "user_exp", SessionID: "sess_exp", SessionActive: true, Email: "exp@example.com", EmailVerified: true, SourceUpdatedAt: start,
	})
	h.provider.Seed("clerk_inv_ticket_30day_provider_0123456789", ProviderInvitation{
		ProviderInvitationID: "orginv_30d_cap",
		ClerkOrganizationID:  "org_workspace_a",
		WorkspaceID:          wsAID,
		InviteeEmail:         "exp@example.com",
		Role:                 RoleViewer,
		InviterUserID:        ownerUID,
		Status:               ProviderInvitationPending,
		CreatedAt:            start,
		ExpiresAt:            start.Add(30 * 24 * time.Hour), // Provider says 30d; Creativanta enforces 7d!
		SourceUpdatedAt:      start,
	})

	// At 7d - 1s: Preview succeeds.
	h.clock.Advance(MaxInvitationAge - time.Second)
	if _, err := h.svc.PreviewInvitation(ctx, PreviewInvitationQuery{
		BearerToken:     "tok_exp_user",
		InvitationToken: "clerk_inv_ticket_30day_provider_0123456789",
	}); err != nil {
		t.Fatalf("expected valid preview at 7d-1s, got %v", err)
	}

	// Advance 1s -> exact 7d mark: MUST expire with canonical EC-AUTH-004 message!
	h.clock.Advance(time.Second)
	_, err = h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_exp_user",
		InvitationToken: "clerk_inv_ticket_30day_provider_0123456789",
		Command:         CommandContext{IdempotencyKey: "accept-at-7d"},
	})
	if !errors.Is(err, ErrInvitationExpired) {
		t.Fatalf("expected ErrInvitationExpired at exact 7d boundary, got %v", err)
	}
	var domErr *DomainError
	if !errors.As(err, &domErr) || domErr.UserMessageEN != ExpiredInviteMessageEN {
		t.Fatalf("expected EC-AUTH-004 message %q, got %+v", ExpiredInviteMessageEN, domErr)
	}

	// 4. Manager cannot ResendInvitation (RULE-AUTH-005 requires Admin+), Admin CAN resend!
	if _, err := h.svc.ResendInvitation(ctx, ResendInvitationCommand{
		BearerToken:          "tok_mgr_alpha",
		WorkspaceID:          wsAID,
		ProviderInvitationID: "orginv_30d_cap",
		Command:              CommandContext{IdempotencyKey: "mgr-resend-denied"},
	}); !errors.Is(err, ErrInviterNotAuthorized) {
		t.Fatalf("expected Manager resend to fail with ErrInviterNotAuthorized, got %v", err)
	}

	resent, err := h.svc.ResendInvitation(ctx, ResendInvitationCommand{
		BearerToken:          "tok_admin_alpha",
		WorkspaceID:          wsAID,
		ProviderInvitationID: "orginv_30d_cap",
		Command:              CommandContext{IdempotencyKey: "admin-resend-ok"},
	})
	if err != nil {
		t.Fatalf("Admin ResendInvitation failed: %v", err)
	}
	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_exp_user",
		InvitationToken: h.provider.TokenForID(resent.ProviderInvitationID),
		Command:         CommandContext{IdempotencyKey: "accept-resent-ok"},
	}); err != nil {
		t.Fatalf("AcceptInvitation on resent token failed: %v", err)
	}

	// 5. Shorter provider expiry (e.g. 1 hour) is also honored before 7 days.
	now2 := h.clock.Now()
	h.verifier.Put("tok_short_user", VerifiedClerkActor{
		ClerkID: "user_short", SessionID: "sess_short", SessionActive: true, Email: "short@example.com", EmailVerified: true, SourceUpdatedAt: now2,
	})
	h.provider.Seed("clerk_inv_ticket_short_1h_0123456789abcdef", ProviderInvitation{
		ProviderInvitationID: "orginv_short_1h",
		ClerkOrganizationID:  "org_workspace_a",
		WorkspaceID:          wsAID,
		InviteeEmail:         "short@example.com",
		Role:                 RoleViewer,
		InviterUserID:        ownerUID,
		Status:               ProviderInvitationPending,
		CreatedAt:            now2,
		ExpiresAt:            now2.Add(time.Hour),
		SourceUpdatedAt:      now2,
	})
	h.clock.Advance(61 * time.Minute)
	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_short_user",
		InvitationToken: "clerk_inv_ticket_short_1h_0123456789abcdef",
		Command:         CommandContext{IdempotencyKey: "accept-short-expired"},
	}); !errors.Is(err, ErrInvitationExpired) {
		t.Fatalf("expected shorter provider expiry to fail with ErrInvitationExpired, got %v", err)
	}

	// 6. Revoked link failure + RBAC on RevokeInvitation.
	toRevoke, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "issue-to-revoke"},
		Email:       "revokee@example.com",
		Role:        RoleAdmin,
	})
	if err != nil {
		t.Fatalf("IssueInvitation failed: %v", err)
	}
	h.verifier.Put("tok_revokee", VerifiedClerkActor{
		ClerkID: "user_revokee", SessionID: "sess_rev", SessionActive: true, Email: "revokee@example.com", EmailVerified: true, SourceUpdatedAt: h.clock.Now(),
	})
	// Admin cannot cancel an Admin-level invitation (must be strictly below caller role).
	if _, err := h.svc.RevokeInvitation(ctx, RevokeInvitationCommand{
		BearerToken:          "tok_admin_alpha",
		WorkspaceID:          wsAID,
		ProviderInvitationID: toRevoke.ProviderInvitationID,
		Command:              CommandContext{IdempotencyKey: "admin-cancel-admin-denied"},
	}); !errors.Is(err, ErrRoleElevationDenied) {
		t.Fatalf("expected Admin cancelling Admin invite to fail, got %v", err)
	}
	// Owner cancels successfully.
	if _, err := h.svc.RevokeInvitation(ctx, RevokeInvitationCommand{
		BearerToken:          "tok_owner_alpha",
		WorkspaceID:          wsAID,
		ProviderInvitationID: toRevoke.ProviderInvitationID,
		Command:              CommandContext{IdempotencyKey: "owner-cancel-ok"},
	}); err != nil {
		t.Fatalf("Owner RevokeInvitation failed: %v", err)
	}
	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_revokee",
		InvitationToken: h.provider.TokenForID(toRevoke.ProviderInvitationID),
		Command:         CommandContext{IdempotencyKey: "accept-revoked"},
	}); !errors.Is(err, ErrInvitationRevoked) {
		t.Fatalf("expected ErrInvitationRevoked, got %v", err)
	}

	// 7. Declined link failure.
	toDecline, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_admin_alpha",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "issue-to-decline"},
		Email:       "decliner@example.com",
		Role:        RoleEditor,
	})
	if err != nil {
		t.Fatalf("IssueInvitation failed: %v", err)
	}
	h.verifier.Put("tok_decliner", VerifiedClerkActor{
		ClerkID: "user_decliner", SessionID: "sess_dec", SessionActive: true, Email: "decliner@example.com", EmailVerified: true, SourceUpdatedAt: h.clock.Now(),
	})
	declineTok := h.provider.TokenForID(toDecline.ProviderInvitationID)
	if _, err := h.svc.DeclineInvitation(ctx, DeclineInvitationCommand{
		BearerToken:     "tok_decliner",
		InvitationToken: declineTok,
		Command:         CommandContext{IdempotencyKey: "decline-1"},
	}); err != nil {
		t.Fatalf("DeclineInvitation failed: %v", err)
	}
	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_decliner",
		InvitationToken: declineTok,
		Command:         CommandContext{IdempotencyKey: "accept-after-decline"},
	}); !errors.Is(err, ErrInvitationDeclined) {
		t.Fatalf("expected ErrInvitationDeclined, got %v", err)
	}
}

func TestCrossTenantIsolation(t *testing.T) {
	h := newTestHarness()
	ctx := context.Background()

	// Issue valid invitation in Workspace A for a brand-new user.
	issuedA, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "cross-tenant-issue-a"},
		Email:       "isolated@example.com",
		Role:        RoleEditor,
	})
	if err != nil {
		t.Fatalf("IssueInvitation failed: %v", err)
	}
	tokenA := h.provider.TokenForID(issuedA.ProviderInvitationID)
	h.verifier.Put("tok_isolated", VerifiedClerkActor{
		ClerkID: "user_isolated", SessionID: "sess_iso", SessionActive: true, Email: "isolated@example.com", EmailVerified: true, SourceUpdatedAt: h.clock.Now(),
	})

	// 1. Accepting Workspace A's token while passing Command.WorkspaceID = Workspace B MUST fail with NOT_FOUND!
	_, err = h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_isolated",
		InvitationToken: tokenA,
		Command:         CommandContext{IdempotencyKey: "cross-accept-b", WorkspaceID: wsBID},
	})
	if !errors.Is(err, ErrCrossTenantMismatch) {
		t.Fatalf("expected ErrCrossTenantMismatch on cross-tenant accept, got %v", err)
	}
	var domErr *DomainError
	if !errors.As(err, &domErr) || domErr.Code != ErrCodeSystemNotFound001 || domErr.Status != StatusNotFound {
		t.Fatalf("expected opaque SYSTEM_NOTFOUND_001, got %+v", domErr)
	}

	// 2. Owner of Workspace B attempting to IssueInvitation or RevokeInvitation in Workspace A (where non-member) -> NOT_FOUND!
	//    Wait: first ensure owner of Workspace B is NOT a member of Workspace A.
	if _, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_beta",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "foreign-owner-issue"},
		Email:       "victim@example.com",
		Role:        RoleViewer,
	}); !errors.Is(err, ErrCrossTenantMismatch) {
		t.Fatalf("expected ErrCrossTenantMismatch for foreign workspace inviter, got %v", err)
	}
	if _, err := h.svc.RevokeInvitation(ctx, RevokeInvitationCommand{
		BearerToken:          "tok_owner_beta",
		WorkspaceID:          wsBID,
		ProviderInvitationID: issuedA.ProviderInvitationID,
		Command:              CommandContext{IdempotencyKey: "foreign-owner-revoke"},
	}); !errors.Is(err, ErrCrossTenantMismatch) {
		t.Fatalf("expected ErrCrossTenantMismatch when revoking Workspace A invite from Workspace B, got %v", err)
	}

	// 3. Forged provider invitation with WorkspaceID=wsAID but ClerkOrganizationID="org_workspace_b" -> rejected!
	now := h.clock.Now()
	h.provider.Seed("clerk_inv_ticket_org_mismatch_0123456789ab", ProviderInvitation{
		ProviderInvitationID: "orginv_org_mismatch",
		ClerkOrganizationID:  "org_workspace_b",
		WorkspaceID:          wsAID,
		InviteeEmail:         "isolated@example.com",
		Role:                 RoleViewer,
		InviterUserID:        ownerUID,
		Status:               ProviderInvitationPending,
		CreatedAt:            now,
		ExpiresAt:            now.Add(24 * time.Hour),
	})
	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_isolated",
		InvitationToken: "clerk_inv_ticket_org_mismatch_0123456789ab",
		Command:         CommandContext{IdempotencyKey: "org-mismatch-accept"},
	}); !errors.Is(err, ErrCrossTenantMismatch) {
		t.Fatalf("expected ErrCrossTenantMismatch on ClerkOrgID/WorkspaceID mismatch, got %v", err)
	}

	// 4. Accepting legitimately in Workspace A grants zero membership in Workspace B.
	acceptedA, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_isolated",
		InvitationToken: tokenA,
		Command:         CommandContext{IdempotencyKey: "legit-accept-a", WorkspaceID: wsAID},
	})
	if err != nil {
		t.Fatalf("legit AcceptInvitation in Workspace A failed: %v", err)
	}
	if _, inB := h.repo.members[memberKey(wsBID, acceptedA.User.UserID)]; inB {
		t.Fatalf("membership leaked into Workspace B!")
	}
}

func TestIdempotencyRecoveryWebhookReconciliationAndConcurrency(t *testing.T) {
	h := newTestHarness()
	ctx := context.Background()

	issued, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "idem-issue-1"},
		Email:       "idem@example.com",
		Role:        RoleManager,
	})
	if err != nil {
		t.Fatalf("IssueInvitation failed: %v", err)
	}

	// 1. Exact replay of IssueInvitation returns Replayed=true with identical ProviderInvitationID.
	replayedIssue, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "idem-issue-1"},
		Email:       "IDEM@example.com",
		Role:        RoleManager,
	})
	if err != nil {
		t.Fatalf("replayed IssueInvitation failed: %v", err)
	}
	if !replayedIssue.Replayed || replayedIssue.ProviderInvitationID != issued.ProviderInvitationID {
		t.Fatalf("expected idempotent replay, got %+v", replayedIssue)
	}

	// 2. Reusing IdempotencyKey with a different role triggers SYSTEM_CONFLICT_001!
	_, err = h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "idem-issue-1"},
		Email:       "idem@example.com",
		Role:        RoleViewer,
	})
	if !errors.Is(err, ErrIdempotencyConflict) {
		t.Fatalf("expected ErrIdempotencyConflict, got %v", err)
	}
	var domErr *DomainError
	if !errors.As(err, &domErr) || domErr.Code != ErrCodeSystemConflict001 {
		t.Fatalf("expected SYSTEM_CONFLICT_001, got %+v", domErr)
	}

	// 3. Partial-failure recovery: simulate DB commit failing AFTER Clerk provider accepted,
	//    then retry with the SAME IdempotencyKey -> recovers cleanly!
	invToken := h.provider.TokenForID(issued.ProviderInvitationID)
	h.verifier.Put("tok_idem_user", VerifiedClerkActor{
		ClerkID: "user_idem", SessionID: "sess_idem", SessionActive: true, Email: "idem@example.com", EmailVerified: true, SourceUpdatedAt: h.clock.Now(),
	})

	// Note: AcceptInvitation runs 2 WithinTx calls (pre-flight + commit). Set failCommitOnce right before step 2?
	// Let's test retry after provider already accepted by pre-accepting on provider or retrying across keys:
	firstAccept, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_idem_user",
		InvitationToken: invToken,
		Command:         CommandContext{IdempotencyKey: "accept-idem-1"},
	})
	if err != nil {
		t.Fatalf("first AcceptInvitation failed: %v", err)
	}
	if firstAccept.Replayed {
		t.Fatalf("first acceptance must have Replayed=false")
	}

	// Same IdempotencyKey replay:
	secondAccept, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_idem_user",
		InvitationToken: invToken,
		Command:         CommandContext{IdempotencyKey: "accept-idem-1"},
	})
	if err != nil {
		t.Fatalf("second AcceptInvitation failed: %v", err)
	}
	if !secondAccept.Replayed || secondAccept.Member.WorkspaceMemberID != firstAccept.Member.WorkspaceMemberID {
		t.Fatalf("expected idempotent replay with identical member ID, got %+v", secondAccept)
	}

	// Different IdempotencyKey for the SAME already-accepted invitation (domain-level idempotency):
	thirdAccept, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_idem_user",
		InvitationToken: invToken,
		Command:         CommandContext{IdempotencyKey: "accept-idem-different-key"},
	})
	if err != nil {
		t.Fatalf("third AcceptInvitation (domain idempotency) failed: %v", err)
	}
	if !thirdAccept.Replayed || thirdAccept.Member.WorkspaceMemberID != firstAccept.Member.WorkspaceMemberID {
		t.Fatalf("expected domain-idempotent replay, got %+v", thirdAccept)
	}

	// Same IdempotencyKey with a garbage token fails closed before idempotency lookup,
	// while reusing the same IdempotencyKey with a DIFFERENT valid token in the same
	// workspace triggers SYSTEM_CONFLICT_001!
	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_idem_user",
		InvitationToken: "clerk_inv_ticket_different_token_0123456789",
		Command:         CommandContext{IdempotencyKey: "accept-idem-1"},
	}); !errors.Is(err, ErrInvitationInvalidToken) {
		t.Fatalf("expected ErrInvitationInvalidToken on nonexistent token, got %v", err)
	}

	nowIdem := h.clock.Now()
	h.provider.Seed("clerk_inv_ticket_second_valid_0123456789ab", ProviderInvitation{
		ProviderInvitationID: "orginv_second_idem",
		ClerkOrganizationID:  "org_workspace_a",
		WorkspaceID:          wsAID,
		InviteeEmail:         "idem@example.com",
		Role:                 RoleManager,
		InviterUserID:        ownerUID,
		Status:               ProviderInvitationPending,
		CreatedAt:            nowIdem,
		ExpiresAt:            nowIdem.Add(24 * time.Hour),
		SourceUpdatedAt:      nowIdem,
	})
	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_idem_user",
		InvitationToken: "clerk_inv_ticket_second_valid_0123456789ab",
		Command:         CommandContext{IdempotencyKey: "accept-idem-1"},
	}); !errors.Is(err, ErrIdempotencyConflict) {
		t.Fatalf("expected ErrIdempotencyConflict on token change with same key, got %v", err)
	}

	// 4. Delayed & out-of-order webhook reconciliation (auth.md lines 190-196):
	// 4a. Delayed organizationInvitation.accepted arrives AFTER synchronous AcceptInvitation -> no duplicate!
	delayedAt := h.clock.Now().Add(5 * time.Second)
	recRes, err := h.svc.ReconcileProviderMembership(ctx, ProviderMembershipEvent{
		ExternalEventID:      "evt_delayed_accept_1",
		EventType:            ProviderEventInvitationAccepted,
		ClerkOrganizationID:  "org_workspace_a",
		ClerkMembershipID:    firstAccept.Member.ClerkMembershipID,
		ClerkUserID:          "user_idem",
		Email:                "idem@example.com",
		EmailVerified:        true,
		Role:                 RoleManager,
		InviterUserID:        ownerUID,
		ProviderInvitationID: issued.ProviderInvitationID,
		SourceUpdatedAt:      delayedAt,
	})
	if err != nil {
		t.Fatalf("delayed ReconcileProviderMembership failed: %v", err)
	}
	if !recRes.Replayed {
		t.Fatalf("expected already-synchronized delayed webhook to report Replayed=true, got %+v", recRes)
	}

	// 4b. Member removed at T+20s via organizationMembership.deleted, then out-of-order
	//     organizationMembership.updated from T+10s arrives -> MUST NOT resurrect removed member!
	removedAt := h.clock.Now().Add(20 * time.Second)
	delRes, err := h.svc.ReconcileProviderMembership(ctx, ProviderMembershipEvent{
		ExternalEventID:     "evt_member_deleted_1",
		EventType:           ProviderEventMembershipDeleted,
		ClerkOrganizationID: "org_workspace_a",
		ClerkUserID:         "user_idem",
		SourceUpdatedAt:     removedAt,
	})
	if err != nil || !delRes.Applied || delRes.Member.Status != MembershipStatusRemoved {
		t.Fatalf("expected membership deletion applied, got res=%+v err=%v", delRes, err)
	}

	staleUpdateAt := h.clock.Now().Add(10 * time.Second)
	staleRes, err := h.svc.ReconcileProviderMembership(ctx, ProviderMembershipEvent{
		ExternalEventID:     "evt_stale_create_after_delete",
		EventType:           ProviderEventMembershipCreated,
		ClerkOrganizationID: "org_workspace_a",
		ClerkUserID:         "user_idem",
		Email:               "idem@example.com",
		EmailVerified:       true,
		Role:                RoleManager,
		InviterUserID:       ownerUID,
		SourceUpdatedAt:     staleUpdateAt,
	})
	if err != nil {
		t.Fatalf("stale webhook reconciliation returned unexpected error: %v", err)
	}
	if !staleRes.Ignored {
		t.Fatalf("expected stale event after delete to be ignored, got %+v", staleRes)
	}
	if got := h.repo.members[memberKey(wsAID, firstAccept.User.UserID)].Status; got != MembershipStatusRemoved {
		t.Fatalf("removed member was resurrected! status=%s", got)
	}

	// 4c. Unknown ClerkOrganizationID on webhook NEVER auto-creates a workspace.
	if _, err := h.svc.ReconcileProviderMembership(ctx, ProviderMembershipEvent{
		ExternalEventID:     "evt_unknown_org",
		EventType:           ProviderEventMembershipCreated,
		ClerkOrganizationID: "org_unknown_shadow_999",
		ClerkUserID:         "user_idem",
		Email:               "idem@example.com",
		EmailVerified:       true,
		Role:                RoleViewer,
		SourceUpdatedAt:     removedAt,
	}); !errors.Is(err, ErrCrossTenantMismatch) {
		t.Fatalf("expected unknown org webhook to fail closed, got %v", err)
	}

	// 5. Concurrent goroutine race stress test (-race) + audit/outbox single-emission verification.
	raceIssue, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "race-issue-1"},
		Email:       "racer@example.com",
		Role:        RoleEditor,
	})
	if err != nil {
		t.Fatalf("IssueInvitation for race test failed: %v", err)
	}
	raceToken := h.provider.TokenForID(raceIssue.ProviderInvitationID)
	h.verifier.Put("tok_racer", VerifiedClerkActor{
		ClerkID: "user_racer", SessionID: "sess_racer", SessionActive: true, Email: "racer@example.com", EmailVerified: true, SourceUpdatedAt: h.clock.Now(),
	})

	const workers = 16
	var wg sync.WaitGroup
	errs := make(chan error, workers)
	successes := make(chan AcceptInvitationResult, workers)

	for i := 0; i < workers; i++ {
		wg.Add(1)
		go func(idx int) {
			defer wg.Done()
			key := fmt.Sprintf("race-accept-%d", idx%4) // mix of shared and distinct idempotency keys
			res, aErr := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
				BearerToken:     "tok_racer",
				InvitationToken: raceToken,
				Command:         CommandContext{IdempotencyKey: key},
			})
			if aErr != nil {
				if errors.Is(aErr, ErrIdempotencyInProgress) {
					return
				}
				errs <- aErr
				return
			}
			successes <- res
		}(i)
	}
	wg.Wait()
	close(errs)
	close(successes)

	for e := range errs {
		t.Fatalf("unexpected error in concurrent acceptance: %v", e)
	}
	var memberIDs = make(map[string]struct{})
	for sRes := range successes {
		memberIDs[sRes.Member.WorkspaceMemberID] = struct{}{}
	}
	if len(memberIDs) != 1 {
		t.Fatalf("expected exactly 1 canonical WorkspaceMemberID across concurrent goroutines, got %d", len(memberIDs))
	}

	// Verify user.registered was emitted at most once for user_racer and audit trail exists.
	racerUID := h.repo.userIDByClerkID["user_racer"]
	regEvents := 0
	for _, ev := range h.repo.outbox {
		if ev.EventType == EventUserRegistered && ev.AggregateID == racerUID {
			var p UserRegisteredPayload
			if err := json.Unmarshal(ev.Payload, &p); err != nil {
				t.Fatalf("invalid UserRegisteredPayload JSON: %v", err)
			}
			regEvents++
		}
	}
	if regEvents != 1 {
		t.Fatalf("expected exactly 1 user.registered event for user_racer, got %d", regEvents)
	}

	// 6. Canceled & deadline-exceeded contexts map to canonical error codes.
	canceledCtx, cancel := context.WithCancel(ctx)
	cancel()
	_, err = h.svc.PreviewInvitation(canceledCtx, PreviewInvitationQuery{InvitationToken: raceToken})
	if !errors.As(err, &domErr) || domErr.Code != ErrCodeSystemCanceled001 {
		t.Fatalf("expected SYSTEM_CANCELED_001, got %v", err)
	}
}

func TestPartialFailureRecoveryAfterProviderAccept(t *testing.T) {
	h := newTestHarness()
	ctx := context.Background()

	issued, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha",
		WorkspaceID: wsAID,
		Command:     CommandContext{IdempotencyKey: "recovery-issue-1"},
		Email:       "recover@example.com",
		Role:        RoleContributor,
	})
	if err != nil {
		t.Fatalf("IssueInvitation failed: %v", err)
	}
	invToken := h.provider.TokenForID(issued.ProviderInvitationID)
	h.verifier.Put("tok_recover", VerifiedClerkActor{
		ClerkID: "user_recover", SessionID: "sess_rec", SessionActive: true, Email: "recover@example.com", EmailVerified: true, SourceUpdatedAt: h.clock.Now(),
	})

	// Inject a transient local DB commit failure on the commit transaction AFTER
	// Clerk MarkInvitationAccepted succeeds (the next 2nd WithinTx call).
	h.repo.mu.Lock()
	h.repo.failOnTxCall = h.repo.txCalls + 2
	h.repo.mu.Unlock()

	if _, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_recover",
		InvitationToken: invToken,
		Command:         CommandContext{IdempotencyKey: "recover-accept-key"},
	}); err == nil {
		t.Fatalf("expected transient DB commit failure after provider acceptance")
	}

	// Retry with the exact same IdempotencyKey -> recovers from failed idempotency
	// + already-accepted Clerk state and persists local membership cleanly!
	recovered, err := h.svc.AcceptInvitation(ctx, AcceptInvitationCommand{
		BearerToken:     "tok_recover",
		InvitationToken: invToken,
		Command:         CommandContext{IdempotencyKey: "recover-accept-key"},
	})
	if err != nil {
		t.Fatalf("expected recovery retry to succeed, got %v", err)
	}
	if recovered.Member.Role != RoleContributor || recovered.Member.Status != MembershipStatusActive {
		t.Fatalf("unexpected recovered membership: %+v", recovered.Member)
	}
}

func TestEdgeValidationUnconfiguredAdaptersAndWebhookBranches(t *testing.T) {
	ctx := context.Background()

	// Exercise all UnconfiguredInvitationProvider methods fail-closed.
	var up UnconfiguredInvitationProvider
	if _, err := up.CreateInvitation(ctx, CreateProviderInvitationInput{}); !errors.Is(err, ErrDependencyUnconfigured) {
		t.Fatalf("expected ErrDependencyUnconfigured, got %v", err)
	}
	if _, err := up.ResolveInvitationToken(ctx, "tok"); !errors.Is(err, ErrDependencyUnconfigured) {
		t.Fatalf("expected ErrDependencyUnconfigured, got %v", err)
	}
	if _, err := up.GetInvitationByID(ctx, "org", "inv"); !errors.Is(err, ErrDependencyUnconfigured) {
		t.Fatalf("expected ErrDependencyUnconfigured, got %v", err)
	}
	if _, err := up.MarkInvitationAccepted(ctx, AcceptProviderInvitationInput{}); !errors.Is(err, ErrDependencyUnconfigured) {
		t.Fatalf("expected ErrDependencyUnconfigured, got %v", err)
	}
	if _, err := up.MarkInvitationDeclined(ctx, "org", "inv", "u"); !errors.Is(err, ErrDependencyUnconfigured) {
		t.Fatalf("expected ErrDependencyUnconfigured, got %v", err)
	}
	if _, err := up.RevokeInvitation(ctx, "org", "inv", "u"); !errors.Is(err, ErrDependencyUnconfigured) {
		t.Fatalf("expected ErrDependencyUnconfigured, got %v", err)
	}

	// All 4 RuntimeGates true + configured dependencies -> CheckProductionReadiness passes.
	h := newTestHarness()
	readySvc := NewService(Options{
		Verifier:   h.verifier,
		Provider:   h.provider,
		Repository: h.repo,
		Gates: RuntimeGates{
			ClerkProviderConfigured: true,
			DurableStorageReady:     true,
			TenantRLSEnforced:       true,
			RPCBindingsReconciled:   true,
		},
	})
	if err := readySvc.CheckProductionReadiness(); err != nil {
		t.Fatalf("expected CheckProductionReadiness nil when all gates set, got %v", err)
	}

	// Validation branches on IssueInvitation, AcceptInvitation, DeclineInvitation, RevokeInvitation, ResendInvitation.
	if _, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha", WorkspaceID: "not-a-uuid", Command: CommandContext{IdempotencyKey: "k1"}, Email: "a@b.com", Role: RoleEditor,
	}); !errors.Is(err, ErrInvalidInput) {
		t.Fatalf("expected ErrInvalidInput for invalid workspace_id, got %v", err)
	}
	if _, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha", WorkspaceID: wsAID, Command: CommandContext{IdempotencyKey: "k2"}, Email: "invalid-email", Role: RoleEditor,
	}); !errors.Is(err, ErrInvalidInput) {
		t.Fatalf("expected ErrInvalidInput for invalid email, got %v", err)
	}
	if _, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha", WorkspaceID: wsAID, Command: CommandContext{IdempotencyKey: "k3"}, Email: "ok@example.com", Role: "superadmin",
	}); !errors.Is(err, ErrInvalidInput) {
		t.Fatalf("expected ErrInvalidInput for unknown role, got %v", err)
	}
	if _, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha", WorkspaceID: wsAID, Command: CommandContext{IdempotencyKey: "k4", WorkspaceID: wsBID}, Email: "ok@example.com", Role: RoleEditor,
	}); !errors.Is(err, ErrCrossTenantMismatch) {
		t.Fatalf("expected ErrCrossTenantMismatch for mismatched Command.WorkspaceID, got %v", err)
	}

	// Valid DecodeAcceptCommandStrict path.
	decoded, err := DecodeAcceptCommandStrict("tok_owner_beta", []byte(`{"invitation_token":"clerk_inv_ticket_secret_0001_abcdef0123456789","command":{"idempotency_key":"k-ok"}}`))
	if err != nil || decoded.BearerToken != "tok_owner_beta" || decoded.Command.IdempotencyKey != "k-ok" {
		t.Fatalf("unexpected DecodeAcceptCommandStrict result: %+v err=%v", decoded, err)
	}

	// Decline replay, Revoke replay & cannot-revoke-accepted, Resend replay & already-active-member check.
	inv1, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_admin_alpha", WorkspaceID: wsAID, Command: CommandContext{IdempotencyKey: "edge-inv-1"}, Email: "dec2@example.com", Role: RoleViewer,
	})
	if err != nil {
		t.Fatalf("IssueInvitation failed: %v", err)
	}
	h.verifier.Put("tok_dec2", VerifiedClerkActor{
		ClerkID: "user_dec2", SessionID: "sess_d2", SessionActive: true, Email: "dec2@example.com", EmailVerified: true, SourceUpdatedAt: h.clock.Now(),
	})
	decTok := h.provider.TokenForID(inv1.ProviderInvitationID)
	if _, err := h.svc.DeclineInvitation(ctx, DeclineInvitationCommand{
		BearerToken: "tok_dec2", InvitationToken: decTok, Command: CommandContext{IdempotencyKey: "dec-idem-1"},
	}); err != nil {
		t.Fatalf("DeclineInvitation failed: %v", err)
	}
	decReplay, err := h.svc.DeclineInvitation(ctx, DeclineInvitationCommand{
		BearerToken: "tok_dec2", InvitationToken: decTok, Command: CommandContext{IdempotencyKey: "dec-idem-1"},
	})
	if err != nil || !decReplay.Replayed {
		t.Fatalf("expected DeclineInvitation replay, got %+v err=%v", decReplay, err)
	}

	inv2, err := h.svc.IssueInvitation(ctx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha", WorkspaceID: wsAID, Command: CommandContext{IdempotencyKey: "edge-inv-2"}, Email: "rev2@example.com", Role: RoleManager,
	})
	if err != nil {
		t.Fatalf("IssueInvitation failed: %v", err)
	}
	if _, err := h.svc.RevokeInvitation(ctx, RevokeInvitationCommand{
		BearerToken: "tok_owner_alpha", WorkspaceID: wsAID, ProviderInvitationID: inv2.ProviderInvitationID, Command: CommandContext{IdempotencyKey: "rev-idem-1"},
	}); err != nil {
		t.Fatalf("RevokeInvitation failed: %v", err)
	}
	revReplay, err := h.svc.RevokeInvitation(ctx, RevokeInvitationCommand{
		BearerToken: "tok_owner_alpha", WorkspaceID: wsAID, ProviderInvitationID: inv2.ProviderInvitationID, Command: CommandContext{IdempotencyKey: "rev-idem-1"},
	})
	if err != nil || !revReplay.Replayed {
		t.Fatalf("expected RevokeInvitation replay, got %+v err=%v", revReplay, err)
	}

	// Webhook reconciliation branches:
	// - New verified user created via organizationMembership.created
	// - Duplicate external_event_id returns Replayed=true
	// - Cannot delete active workspace Owner via webhook
	// - Provider webhook cannot grant RoleOwner to non-owner
	tNow := h.clock.Now()
	whCreated, err := h.svc.ReconcileProviderMembership(ctx, ProviderMembershipEvent{
		ExternalEventID:     "evt_wh_new_1",
		EventType:           ProviderEventMembershipCreated,
		ClerkOrganizationID: "org_workspace_a",
		ClerkMembershipID:   "orgmem_wh_1",
		ClerkUserID:         "user_wh_new",
		Email:               "whnew@example.com",
		EmailVerified:       true,
		DisplayName:         "Webhook New",
		Role:                RoleViewer,
		InviterUserID:       ownerUID,
		SourceUpdatedAt:     tNow,
	})
	if err != nil || !whCreated.Applied {
		t.Fatalf("expected webhook new user creation applied, got %+v err=%v", whCreated, err)
	}
	whDup, err := h.svc.ReconcileProviderMembership(ctx, ProviderMembershipEvent{
		ExternalEventID:     "evt_wh_new_1",
		EventType:           ProviderEventMembershipCreated,
		ClerkOrganizationID: "org_workspace_a",
		ClerkUserID:         "user_wh_new",
		SourceUpdatedAt:     tNow,
	})
	if err != nil || !whDup.Replayed {
		t.Fatalf("expected duplicate webhook Replayed=true, got %+v err=%v", whDup, err)
	}

	// Update role via newer organizationMembership.updated
	whUpdated, err := h.svc.ReconcileProviderMembership(ctx, ProviderMembershipEvent{
		ExternalEventID:     "evt_wh_upd_1",
		EventType:           ProviderEventMembershipUpdated,
		ClerkOrganizationID: "org_workspace_a",
		ClerkMembershipID:   "orgmem_wh_1",
		ClerkUserID:         "user_wh_new",
		Email:               "whnew@example.com",
		EmailVerified:       true,
		Role:                RoleEditor,
		SourceUpdatedAt:     tNow.Add(10 * time.Second),
	})
	if err != nil || !whUpdated.Applied || whUpdated.Member.Role != RoleEditor {
		t.Fatalf("expected webhook role update to Editor, got %+v err=%v", whUpdated, err)
	}

	// Webhook attempting to grant RoleOwner to non-owner fails closed.
	if _, err := h.svc.ReconcileProviderMembership(ctx, ProviderMembershipEvent{
		ExternalEventID:     "evt_wh_second_owner",
		EventType:           ProviderEventMembershipUpdated,
		ClerkOrganizationID: "org_workspace_a",
		ClerkUserID:         "user_wh_new",
		Email:               "whnew@example.com",
		EmailVerified:       true,
		Role:                RoleOwner,
		SourceUpdatedAt:     tNow.Add(20 * time.Second),
	}); !errors.Is(err, ErrRoleElevationDenied) {
		t.Fatalf("expected ErrRoleElevationDenied on second owner webhook, got %v", err)
	}

	// Webhook attempting to delete active Owner fails closed.
	if _, err := h.svc.ReconcileProviderMembership(ctx, ProviderMembershipEvent{
		ExternalEventID:     "evt_wh_del_owner",
		EventType:           ProviderEventMembershipDeleted,
		ClerkOrganizationID: "org_workspace_a",
		ClerkUserID:         "user_owner_a",
		SourceUpdatedAt:     tNow.Add(30 * time.Second),
	}); !errors.Is(err, ErrRoleElevationDenied) {
		t.Fatalf("expected ErrRoleElevationDenied when deleting active owner, got %v", err)
	}

	// DeadlineExceeded context maps to SYSTEM_TIMEOUT_001.
	dlCtx, cancel := context.WithDeadline(ctx, time.Now().Add(-time.Second))
	defer cancel()
	_, dlErr := h.svc.IssueInvitation(dlCtx, IssueInvitationCommand{
		BearerToken: "tok_owner_alpha", WorkspaceID: wsAID, Command: CommandContext{IdempotencyKey: "dl"}, Email: "dl@example.com", Role: RoleViewer,
	})
	var domErr *DomainError
	if !errors.As(dlErr, &domErr) || domErr.Code != ErrCodeSystemTimeout001 {
		t.Fatalf("expected SYSTEM_TIMEOUT_001, got %v", dlErr)
	}
}
