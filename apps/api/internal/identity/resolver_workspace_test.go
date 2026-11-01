package identity

import (
	"context"
	"errors"
	"testing"

	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

const testWorkspace = "019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1"
const testUserUUID = "019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a"
const testForeignWorkspace = "019a3a6c-2fa4-75db-bcdf-66eac7dbcb03"

type fixedStatus struct {
	active bool
	err    error
	calls  int
}

func (s *fixedStatus) Active(_ context.Context, subject, sid string) (bool, error) {
	s.calls++
	if subject != "user_verified" || sid != "sess_verified" {
		return false, ErrUnauthorized
	}
	return s.active, s.err
}

type fixedMembership struct {
	active    bool
	err       error
	calls     int
	workspace string
}

func (m *fixedMembership) ResolveActive(_ context.Context, subject, workspace string) (string, bool, error) {
	m.calls++
	if subject != "user_verified" || workspace != m.workspace {
		return "", false, nil
	}
	return testUserUUID, m.active, m.err
}
func allowedResolver() (Resolver, *fixedStatus, *fixedMembership, *int) {
	tokenCalls := 0
	sessions := &fixedStatus{active: true}
	members := &fixedMembership{active: true, workspace: testWorkspace}
	return Resolver{
		Tokens:      tokenStub{identity: Identity{Subject: "user_verified", SessionID: "sess_verified"}, calls: &tokenCalls},
		Sessions:    sessions,
		Memberships: members,
	}, sessions, members, &tokenCalls
}
func TestWorkspaceResolutionRequiresThreeIndependentProofs(t *testing.T) {
	r, sessions, members, tokens := allowedResolver()
	result, err := r.VerifyWorkspace(context.Background(), "valid", testWorkspace)
	if err != nil {
		t.Fatal(err)
	}
	if result != (transportauth.Session{UserID: testUserUUID, WorkspaceID: testWorkspace}) {
		t.Fatalf("wrong session %#v", result)
	}
	if *tokens != 1 || sessions.calls != 1 || members.calls != 1 {
		t.Fatal("expected fresh checks")
	}
	_, err = r.VerifyWorkspace(context.Background(), "valid", testWorkspace)
	if err != nil || members.calls != 2 || sessions.calls != 2 {
		t.Fatal("must recheck active membership and session for each request")
	}
}
func TestRevocationAndForeignWorkspaceDenied(t *testing.T) {
	for _, scenario := range []string{"revoked", "foreign", "removed", "provider_down", "member_down", "no_sessions", "no_member_db", "invalid_workspace"} {
		t.Run(scenario, func(t *testing.T) {
			r, s, m, tokens := allowedResolver()
			workspace := testWorkspace
			switch scenario {
			case "revoked":
				s.active = false
			case "foreign":
				workspace = testForeignWorkspace
			case "removed":
				m.active = false
			case "provider_down":
				s.err = errors.New("provider outage")
			case "member_down":
				m.err = errors.New("database outage")
			case "no_sessions":
				r.Sessions = nil
			case "no_member_db":
				r.Memberships = nil
			case "invalid_workspace":
				workspace = zeroUUID
			}
			got, err := r.VerifyWorkspace(context.Background(), "valid", workspace)
			if err == nil || got != (transportauth.Session{}) {
				t.Fatalf("authorization bypass: %#v %v", got, err)
			}
			if scenario == "revoked" && m.calls != 0 {
				t.Fatal("revoked session proceeded to DB")
			}
			if scenario == "invalid_workspace" && *tokens != 0 {
				t.Fatal("invalid selector triggered token provider call")
			}
		})
	}
}
func TestWorkspaceResolverDoesNotProceedOnCancelledRequest(t *testing.T) {
	r, s, m, tokens := allowedResolver()
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	_, err := r.VerifyWorkspace(ctx, "valid", testWorkspace)
	if !errors.Is(err, context.Canceled) || *tokens != 0 || s.calls != 0 || m.calls != 0 {
		t.Errorf("should stop before lookup: %v", err)
	}
}
