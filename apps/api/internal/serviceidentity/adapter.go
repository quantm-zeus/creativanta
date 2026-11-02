package serviceidentity

import (
	"context"
	"errors"
	"strings"

	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

var (
	ErrWorkspaceMismatch = errors.New("serviceidentity: requested workspace does not match api key workspace")
	ErrUnsupportedToken  = errors.New("serviceidentity: token is not a recognized api key")
)

// APIKeyVerifierAdapter adapts Service to transportauth.Verifier and transportauth.WorkspaceVerifier.
type APIKeyVerifierAdapter struct {
	service *Service
}

// NewAPIKeyVerifierAdapter creates a new verifier adapter for ConnectRPC interceptor integration.
func NewAPIKeyVerifierAdapter(service *Service) *APIKeyVerifierAdapter {
	return &APIKeyVerifierAdapter{service: service}
}

// Verify authenticates an API key bearer token without a candidate workspace header.
func (a *APIKeyVerifierAdapter) Verify(ctx context.Context, bearerToken string) (transportauth.Session, error) {
	return a.VerifyWorkspace(ctx, bearerToken, "")
}

// VerifyWorkspace authenticates an API key bearer token and ensures the candidate workspace matches.
func (a *APIKeyVerifierAdapter) VerifyWorkspace(ctx context.Context, bearerToken, requestedWorkspaceID string) (transportauth.Session, error) {
	if !ValidateKeyFormat(bearerToken) {
		return transportauth.Session{}, ErrUnsupportedToken
	}

	authCtx, _, err := a.service.Authenticate(ctx, bearerToken, false, "")
	if err != nil {
		return transportauth.Session{}, err
	}

	if requestedWorkspaceID != "" && requestedWorkspaceID != authCtx.WorkspaceID {
		return transportauth.Session{}, ErrWorkspaceMismatch
	}

	return transportauth.Session{
		UserID:        authCtx.APIKeyID,
		WorkspaceID:   authCtx.WorkspaceID,
		InternalAdmin: false,
	}, nil
}

// CompositeVerifier dispatches verification to APIKeyVerifierAdapter if token is an API key (crk_*),
// or delegates to the user session verifier (Clerk JWT) otherwise.
type CompositeVerifier struct {
	userVerifier   transportauth.Verifier
	apiKeyVerifier *APIKeyVerifierAdapter
}

// NewCompositeVerifier constructs a verifier capable of authenticating both Clerk users and API keys.
func NewCompositeVerifier(userVerifier transportauth.Verifier, apiKeyVerifier *APIKeyVerifierAdapter) *CompositeVerifier {
	return &CompositeVerifier{
		userVerifier:   userVerifier,
		apiKeyVerifier: apiKeyVerifier,
	}
}

func (c *CompositeVerifier) Verify(ctx context.Context, token string) (transportauth.Session, error) {
	if strings.HasPrefix(token, PrefixLive) || strings.HasPrefix(token, PrefixTest) {
		if c.apiKeyVerifier == nil {
			return transportauth.Session{}, ErrUnsupportedToken
		}
		return c.apiKeyVerifier.Verify(ctx, token)
	}
	if c.userVerifier == nil {
		return transportauth.Session{}, errors.New("serviceidentity: user verifier not configured")
	}
	return c.userVerifier.Verify(ctx, token)
}

func (c *CompositeVerifier) VerifyWorkspace(ctx context.Context, token, requestedWorkspaceID string) (transportauth.Session, error) {
	if strings.HasPrefix(token, PrefixLive) || strings.HasPrefix(token, PrefixTest) {
		if c.apiKeyVerifier == nil {
			return transportauth.Session{}, ErrUnsupportedToken
		}
		return c.apiKeyVerifier.VerifyWorkspace(ctx, token, requestedWorkspaceID)
	}
	if wsVerifier, ok := c.userVerifier.(transportauth.WorkspaceVerifier); ok {
		return wsVerifier.VerifyWorkspace(ctx, token, requestedWorkspaceID)
	}
	if c.userVerifier == nil {
		return transportauth.Session{}, errors.New("serviceidentity: user verifier not configured")
	}
	sess, err := c.userVerifier.Verify(ctx, token)
	if err != nil {
		return transportauth.Session{}, err
	}
	if requestedWorkspaceID != "" && sess.WorkspaceID != requestedWorkspaceID {
		return transportauth.Session{}, ErrWorkspaceMismatch
	}
	return sess, nil
}
