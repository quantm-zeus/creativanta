package serviceidentity_test

import (
	"context"
	"errors"
	"net/http"
	"testing"

	"connectrpc.com/connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/serviceidentity"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

type dummyUserVerifier struct{}

func (d *dummyUserVerifier) Verify(_ context.Context, token string) (transportauth.Session, error) {
	if token == "valid-clerk-user-jwt" {
		return transportauth.Session{
			UserID:        "11111111-1111-1111-1111-111111111101",
			WorkspaceID:   "22222222-2222-2222-2222-222222222201",
			InternalAdmin: false,
		}, nil
	}
	return transportauth.Session{}, errors.New("invalid user token")
}

func (d *dummyUserVerifier) VerifyWorkspace(_ context.Context, token, requestedWS string) (transportauth.Session, error) {
	sess, err := d.Verify(context.Background(), token)
	if err != nil {
		return transportauth.Session{}, err
	}
	if requestedWS != "" && requestedWS != sess.WorkspaceID {
		return transportauth.Session{}, errors.New("workspace mismatch")
	}
	return sess, nil
}

func TestCompositeVerifierAndInterceptorIntegration(t *testing.T) {
	ctx := context.Background()
	store := serviceidentity.NewMemoryStore()
	svc := serviceidentity.NewService(store, nil, nil)

	const (
		workspaceID = "22222222-2222-2222-2222-222222222201"
		userID      = "11111111-1111-1111-1111-111111111101"
	)

	// Create an API key
	keyCreated, err := svc.CreateKey(ctx, serviceidentity.CreateKeyRequest{
		WorkspaceID: workspaceID,
		CreatedBy:   userID,
		Tier:        serviceidentity.TierPro,
		Name:        "Adapter Test Key",
		Scopes:      []string{serviceidentity.ScopeProductsRead},
		Live:        true,
	})
	if err != nil {
		t.Fatal(err)
	}

	adapter := serviceidentity.NewAPIKeyVerifierAdapter(svc)
	composite := serviceidentity.NewCompositeVerifier(&dummyUserVerifier{}, adapter)

	interceptor, err := transportauth.NewServerInterceptor(transportauth.Options{
		Mode:     transportauth.ModeAPI,
		Verifier: composite,
	})
	if err != nil {
		t.Fatalf("NewServerInterceptor: %v", err)
	}

	dummyHandler := func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		sess, ok := transportauth.PrincipalFromContext(ctx)
		if !ok {
			return nil, connect.NewError(connect.CodeInternal, nil)
		}
		if sess.WorkspaceID != workspaceID {
			return nil, connect.NewError(connect.CodePermissionDenied, nil)
		}
		return connect.NewResponse(&struct{}{}), nil
	}

	wrapped := interceptor.WrapUnary(dummyHandler)

	// Case 1: Authenticate with API Key
	reqKey := connect.NewRequest(&struct{}{})
	reqKey.Header().Set("Authorization", "Bearer "+keyCreated.PlainKey)
	reqKey.Header().Set("x-workspace-id", workspaceID)

	res, err := wrapped(ctx, reqKey)
	if err != nil {
		t.Fatalf("API key authentication failed through interceptor: %v", err)
	}
	if res == nil {
		t.Fatal("expected non-nil response")
	}

	// Case 2: Authenticate with Clerk User JWT
	reqUser := connect.NewRequest(&struct{}{})
	reqUser.Header().Set("Authorization", "Bearer valid-clerk-user-jwt")
	reqUser.Header().Set("x-workspace-id", workspaceID)

	res, err = wrapped(ctx, reqUser)
	if err != nil {
		t.Fatalf("User JWT authentication failed through interceptor: %v", err)
	}
	if res == nil {
		t.Fatal("expected non-nil response")
	}

	// Case 3: Foreign workspace header rejected
	reqBadWS := connect.NewRequest(&struct{}{})
	reqBadWS.Header().Set("Authorization", "Bearer "+keyCreated.PlainKey)
	reqBadWS.Header().Set("x-workspace-id", "22222222-2222-2222-2222-222222222203")

	_, err = wrapped(ctx, reqBadWS)
	if err == nil {
		t.Fatal("expected foreign workspace header to be rejected")
	}

	// Case 4: Invalid API key rejected
	reqInvalid := connect.NewRequest(&struct{}{})
	reqInvalid.Header().Set("Authorization", "Bearer crk_live_0000000000000000000000000000000000000000000000000000000000000000")
	reqInvalid.Header().Set("x-workspace-id", workspaceID)

	_, err = wrapped(ctx, reqInvalid)
	if err == nil {
		t.Fatal("expected invalid API key to be rejected")
	}
	if connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Errorf("expected CodeUnauthenticated, got %v", connect.CodeOf(err))
	}
}

func init() {
	// Silence unused warnings for testing
	_ = http.MethodGet
}
