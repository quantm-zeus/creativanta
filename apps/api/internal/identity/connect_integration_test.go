package identity

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"connectrpc.com/connect"
	fixturev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/transport/test/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/transport/test/v1/transporttestv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportfixture"
)

// Tests a real HTTP Connect request from signed JWT through current session
// and membership checks to a harmless fixture service. No production route.
func TestEndToEndJWTSessionMembershipOnConnect(t *testing.T) {
	f := newClerkTestFixture(t)
	tokenVerifier, err := NewSessionTokenVerifier(f.config())
	if err != nil {
		t.Fatal(err)
	}
	sessions := &fixedStatus{active: true}
	members := &fixedMembership{active: true, workspace: testWorkspace}
	identity := Resolver{Tokens: tokenVerifier, Sessions: sessions, Memberships: members}
	intercept, err := transportauth.NewServerInterceptor(transportauth.Options{Mode: transportauth.ModeAPI, Verifier: identity})
	if err != nil {
		t.Fatal(err)
	}
	path, handler := transporttestv1connect.NewTransportFixtureServiceHandler(transportfixture.MustNew(), connect.WithInterceptors(intercept))
	mux := http.NewServeMux()
	mux.Handle(path, handler)
	server := httptest.NewServer(mux)
	defer server.Close()
	client := transporttestv1connect.NewTransportFixtureServiceClient(server.Client(), server.URL)

	call := func(token, workspace string) *connect.Request[fixturev1.EchoRequest] {
		req := connect.NewRequest(&fixturev1.EchoRequest{Text: "secure identity fixture", WorkspaceId: workspace})
		req.Header().Set("Authorization", "Bearer "+token)
		req.Header().Set("x-request-id", testUserUUID)
		if workspace != "" {
			req.Header().Set("x-workspace-id", workspace)
		}
		return req
	}
	baseClaims := f.claims()
	baseClaims["sub"] = "user_verified"
	baseClaims["sid"] = "sess_verified"
	signed := f.signed(t, baseClaims)
	if _, directErr := identity.VerifyWorkspace(context.Background(), signed, testWorkspace); directErr != nil {
		t.Fatalf("direct resolver denied signed token: %v", directErr)
	}
	sessions.calls, members.calls = 0, 0
	result, err := client.Echo(context.Background(), call(signed, testWorkspace))
	if err != nil || result.Msg.GetText() != "secure identity fixture" {
		t.Fatalf("verified request rejected: %v", err)
	}
	if sessions.calls != 1 || members.calls != 1 {
		t.Fatal("expected session and DB check")
	}
	_, err = client.Echo(context.Background(), call(signed, testForeignWorkspace))
	if connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("foreign workspace must deny without data leakage: %v", err)
	}
	sessions.active = false
	_, err = client.Echo(context.Background(), call(signed, testWorkspace))
	if connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("revoked provider session accepted: %v", err)
	}
	sessions.active = true
	bad := baseClaims
	bad["azp"] = "https://foreign.example.test"
	_, err = client.Echo(context.Background(), call(f.signed(t, bad), testWorkspace))
	if connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("invalid azp accepted: %v", err)
	}
	_, err = client.Echo(context.Background(), call(signed, ""))
	if connect.CodeOf(err) != connect.CodeNotFound {
		t.Fatalf("missing workspace header accepted: %v", err)
	}
	if members.calls != 2 {
		t.Fatalf("unexpected membership invocation count: %d", members.calls)
	}
}
