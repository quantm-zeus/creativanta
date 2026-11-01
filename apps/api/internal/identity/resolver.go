// Package identity prepares P0-03 workspace resolution without assuming a
// verified Clerk JWT or inventing a privileged session.
package identity

import (
	"context"
	"errors"
	"regexp"
	"strings"

	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

var ErrUnauthorized = errors.New("identity: unauthorized")
var ErrNoMembership = errors.New("identity: no active workspace membership")
var ErrNotConfigured = errors.New("identity: token, session or membership checker not configured")
var workspaceIDPattern = regexp.MustCompile(`^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$`)

const zeroUUID = "00000000-0000-0000-0000-000000000000"

// Identity is returned ONLY by a signature/issuer/audience-verified token provider.
// Sub is the external provider subject, not an application UUID.
type Identity struct {
	Subject   string
	SessionID string
}

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

// SessionStatus is authoritative for whether a provider session is still
// active. It must reject revoked/suspended/reset sessions even when JWT exp
// has not elapsed. No local positive cache is used in this interface.
type SessionStatus interface {
	Active(ctx context.Context, subject, sessionID string) (bool, error)
}

type Resolver struct {
	Tokens      TokenVerifier
	Memberships MembershipLookup
	Sessions    SessionStatus
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

// VerifyWorkspace implements transportauth.WorkspaceVerifier. A workspace ID
// supplied by the caller is NEVER trusted as authorization: it is a candidate
// looked up against current local membership AFTER valid JWT and active
// provider session verification on every request.
func (r Resolver) VerifyWorkspace(ctx context.Context, token, requestedWorkspaceID string) (transportauth.Session, error) {
	if err := ctx.Err(); err != nil {
		return transportauth.Session{}, err
	}
	if r.Tokens == nil || r.Memberships == nil || r.Sessions == nil {
		return transportauth.Session{}, ErrNotConfigured
	}
	if !workspaceIDPattern.MatchString(requestedWorkspaceID) || requestedWorkspaceID == zeroUUID {
		return transportauth.Session{}, ErrNoMembership
	}
	if token == "" || strings.TrimSpace(token) != token {
		return transportauth.Session{}, ErrUnauthorized
	}
	verified, err := r.Tokens.VerifyToken(ctx, token)
	if ctxErr := ctx.Err(); ctxErr != nil {
		return transportauth.Session{}, ctxErr
	}
	if err != nil || verified.Subject == "" || verified.SessionID == "" {
		return transportauth.Session{}, ErrUnauthorized
	}
	active, err := r.Sessions.Active(ctx, verified.Subject, verified.SessionID)
	if ctxErr := ctx.Err(); ctxErr != nil {
		return transportauth.Session{}, ctxErr
	}
	if err != nil || !active {
		return transportauth.Session{}, ErrUnauthorized
	}
	userID, active, err := r.Memberships.ResolveActive(ctx, verified.Subject, requestedWorkspaceID)
	if ctxErr := ctx.Err(); ctxErr != nil {
		return transportauth.Session{}, ctxErr
	}
	if err != nil || !active || userID == zeroUUID || !workspaceIDPattern.MatchString(userID) {
		return transportauth.Session{}, ErrNoMembership
	}
	return transportauth.Session{UserID: userID, WorkspaceID: requestedWorkspaceID}, nil
}
