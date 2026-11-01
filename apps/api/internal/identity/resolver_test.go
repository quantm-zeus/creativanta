package identity

import (
	"context"
	"errors"
	"testing"
)

type tokenStub struct {
	identity Identity
	err      error
	calls    *int
}

func (s tokenStub) VerifyToken(ctx context.Context, token string) (Identity, error) {
	*s.calls++
	return s.identity, s.err
}

type membershipStub struct{ calls *int }

func (s membershipStub) ResolveActive(ctx context.Context, subject, workspace string) (string, bool, error) {
	*s.calls++
	return "", false, errors.New("must not be called before workspace selector contract")
}

func TestResolverFailsClosedWhenUnconfigured(t *testing.T) {
	_, err := (Resolver{}).Verify(context.Background(), "header.payload.signature")
	if !errors.Is(err, ErrNotConfigured) {
		t.Fatalf("expected ErrNotConfigured; got %v", err)
	}
}
func TestResolverDoesNotTrustUnverifiedToken(t *testing.T) {
	calls, mcalls := 0, 0
	r := Resolver{Tokens: tokenStub{err: errors.New("bad signature"), calls: &calls}, Memberships: membershipStub{calls: &mcalls}}
	_, err := r.Verify(context.Background(), "invalid")
	if !errors.Is(err, ErrUnauthorized) || calls != 1 || mcalls != 0 {
		t.Fatalf("should deny unverified token without membership lookup: %v %d %d", err, calls, mcalls)
	}
}
func TestVerifiedTokenAloneCannotGrantWorkspaceAccess(t *testing.T) {
	calls, mcalls := 0, 0
	r := Resolver{Tokens: tokenStub{identity: Identity{Subject: "user_clerk_verified"}, calls: &calls}, Memberships: membershipStub{calls: &mcalls}}
	result, err := r.Verify(context.Background(), "verified")
	if !errors.Is(err, ErrNoMembership) || result.UserID != "" || result.WorkspaceID != "" || result.InternalAdmin || mcalls != 0 {
		t.Fatalf("provider identity alone must not grant tenant access: %#v %v", result, err)
	}
}
func TestResolverRespectsCancelledContext(t *testing.T) {
	calls, mcalls := 0, 0
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	r := Resolver{Tokens: tokenStub{calls: &calls}, Memberships: membershipStub{calls: &mcalls}}
	_, err := r.Verify(ctx, "anything")
	if !errors.Is(err, context.Canceled) || calls != 0 {
		t.Fatalf("cancelled request should do no lookups: %v", err)
	}
}
