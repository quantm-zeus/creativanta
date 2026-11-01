package transportauth

import (
	"context"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"connectrpc.com/connect"
	fixturev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/transport/test/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/transport/test/v1/transporttestv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportfixture"
)

func TestRealHTTPConnectHandlerUsesVerifiedWorkspace(t *testing.T) {
	i := intercept(t, ModeAPI, verified())
	path, handler := transporttestv1connect.NewTransportFixtureServiceHandler(transportfixture.MustNew(), connect.WithInterceptors(i))
	mux := http.NewServeMux()
	mux.Handle(path, handler)
	server := httptest.NewServer(mux)
	defer server.Close()
	client := transporttestv1connect.NewTransportFixtureServiceClient(server.Client(), server.URL)
	makeRequest := func(workspace, token string) *connect.Request[fixturev1.EchoRequest] {
		req := connect.NewRequest(&fixturev1.EchoRequest{Text: "three-language transport", WorkspaceId: workspace})
		req.Header().Set("x-workspace-id", workspace)
		req.Header().Set("x-request-id", suppliedID)
		if token != "" {
			req.Header().Set("Authorization", "Bearer "+token)
		}
		return req
	}
	res, err := client.Echo(context.Background(), makeRequest(wsUUID, "valid"))
	if err != nil {
		t.Fatalf("real Connect handler refused verified request: %v", err)
	}
	if res.Msg.GetWorkspaceId() != wsUUID || res.Msg.GetText() != "three-language transport" {
		t.Fatalf("unexpected verified response: %v", res.Msg)
	}
	if res.Header().Get("x-correlation-id") != suppliedID {
		t.Fatalf("missing correlation: %v", res.Header())
	}
	// This request matches the fixture's untrusted header/body pair; only the
	// production interceptor catches that the verified session is foreign.
	_, err = client.Echo(context.Background(), makeRequest(foreignUUID, "valid"))
	requireError(t, err, connect.CodeNotFound, "SYSTEM_NOTFOUND_001")
	_, err = client.Echo(context.Background(), makeRequest(wsUUID, ""))
	requireError(t, err, connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001")
	_, err = client.Echo(context.Background(), makeRequest(wsUUID, "wrong"))
	requireError(t, err, connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001")
}

func TestRealHTTPConnectHandlerDeniesNilVerifier(t *testing.T) {
	i := intercept(t, ModeAPI, nil)
	path, handler := transporttestv1connect.NewTransportFixtureServiceHandler(transportfixture.MustNew(), connect.WithInterceptors(i))
	mux := http.NewServeMux()
	mux.Handle(path, handler)
	server := httptest.NewServer(mux)
	defer server.Close()
	client := transporttestv1connect.NewTransportFixtureServiceClient(server.Client(), server.URL)
	req := connect.NewRequest(&fixturev1.EchoRequest{Text: "never visible", WorkspaceId: wsUUID})
	req.Header().Set("x-request-id", suppliedID)
	req.Header().Set("x-workspace-id", wsUUID)
	req.Header().Set("Authorization", "Bearer valid")
	_, err := client.Echo(context.Background(), req)
	if err == nil {
		t.Fatal("no verifier accepted request")
	}
	var ce *connect.Error
	if !errors.As(err, &ce) {
		t.Fatalf("want Connect error: %v", err)
	}
	requireError(t, err, connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001")
}
