// Package identity prepares P0-03 workspace resolution without assuming a
// verified Clerk JWT or inventing a privileged session.
package identity

import (
	"context"
	"errors"
	"strings"

	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

var ErrUnauthorized = errors.New("identity: unauthorized")
var ErrNoMembership = errors.New("identity: no active workspace membership")
var ErrNotConfigured = errors.New("identity: verifier or membership resolver not configured")

// Identity is returned ONLY by a signature/issuer/audience-verified token provider.
// Sub is the external provider subject, not an application UUID.
type Identity struct{ Subject string }

// TokenVerifier must implement production Clerk JWKS, issuer/audience, authorized
// party, expiry and rotation checks. No implementation is supplied by P0-03 prep.
type TokenVerifier interface {
	VerifyToken(ctx context.Context, token string) (Identity, error)
}

// MembershipLookup reads a fresh active user+workspace membership from the
// canonical database. It must not trust workspace role claims from the token.
type MembershipLookup interface {
	ResolveActive(ctx context.Context, providerSubject string, workspaceID string) (internalUserID string, active bool, err error)
}

type Resolver struct {
	Tokens      TokenVerifier
	Memberships MembershipLookup
}

// Verify implements transportauth.Verifier for the user-facing API only.
// It never grants an Admin session and rejects missing dependencies.
func (r Resolver) Verify(ctx context.Context, token string) (transportauth.Session, error) {
	if err := ctx.Err(); err != nil {
		return transportauth.Session{}, err
	}
	if r.Tokens == nil || r.Memberships == nil {
		return transportauth.Session{}, ErrNotConfigured
	}
	// Workspace selection is not yet passed through the token verifier contract.
	// Until a server-validated workspace selector exists, no workspace session
	// can be minted. Never substitute token claims or x-workspace-id here.
	if strings.TrimSpace(token) == "" {
		return transportauth.Session{}, ErrUnauthorized
	}
	verified, err := r.Tokens.VerifyToken(ctx, token)
	if err != nil || strings.TrimSpace(verified.Subject) == "" {
		return transportauth.Session{}, ErrUnauthorized
	}
	return transportauth.Session{}, ErrNoMembership
}
