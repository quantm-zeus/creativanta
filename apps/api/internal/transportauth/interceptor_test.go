package transportauth

import (
	"context"
	"errors"
	"fmt"
	"io"
	"net/http"
	"strings"
	"testing"
	"time"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
)

const userUUID = "019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a"
const wsUUID = "019a3a6c-2fa4-76d5-8ccd-d6f3a2f2a2f1"
const foreignUUID = "019a3a6c-2fa4-75db-bcdf-66eac7dbcb03"
const suppliedID = "019a3a6c-2fa4-7abc-8ef1-49e105cc9251"

type fixedVerifier struct {
	sess  Session
	err   error
	calls int
}

func (v *fixedVerifier) Verify(_ context.Context, token string) (Session, error) {
	v.calls++
	if token != "valid" {
		return Session{}, errors.New("invalid token with private diagnostic")
	}
	return v.sess, v.err
}
func verified() *fixedVerifier {
	return &fixedVerifier{sess: Session{UserID: userUUID, WorkspaceID: wsUUID}}
}
func reqWith(headers map[string]string) *connect.Request[commonv1.UUID] {
	r := connect.NewRequest(&commonv1.UUID{Value: wsUUID})
	for k, v := range headers {
		r.Header().Set(k, v)
	}
	return r
}
func authHeader() map[string]string { return map[string]string{"Authorization": "Bearer valid"} }
func intercept(t *testing.T, mode Mode, v Verifier) connect.Interceptor {
	t.Helper()
	i, err := NewServerInterceptor(Options{Mode: mode, Verifier: v})
	if err != nil {
		t.Fatal(err)
	}
	return i
}
func call(i connect.Interceptor, r *connect.Request[commonv1.UUID], handler connect.UnaryFunc) (connect.AnyResponse, error) {
	return i.WrapUnary(handler)(context.Background(), r)
}
func success(_ context.Context, _ connect.AnyRequest) (connect.AnyResponse, error) {
	return connect.NewResponse(&commonv1.UUID{Value: userUUID}), nil
}
func requireError(t *testing.T, err error, want connect.Code, wantDomain string) string {
	t.Helper()
	if err == nil {
		t.Fatal("expected error")
	}
	if got := connect.CodeOf(err); got != want {
		t.Fatalf("code=%v want %v: %v", got, want, err)
	}
	var ce *connect.Error
	if !errors.As(err, &ce) {
		t.Fatalf("no Connect error: %v", err)
	}
	id := ce.Meta().Get("x-correlation-id")
	if !uuidPattern.MatchString(id) {
		t.Fatalf("missing/invalid correlation ID: %q", id)
	}
	if len(ce.Details()) != 1 {
		t.Fatalf("want exactly one detail, got %d", len(ce.Details()))
	}
	value, parseErr := ce.Details()[0].Value()
	if parseErr != nil {
		t.Fatal(parseErr)
	}
	d, ok := value.(*commonv1.ErrorDetail)
	if !ok {
		t.Fatalf("bad detail type %T", value)
	}
	if d.GetCode() != wantDomain || d.GetCorrelationId().GetValue() != id {
		t.Fatalf("detail not consistent: %+v metadata=%s", d, id)
	}
	return id
}
func TestInvalidModeRejected(t *testing.T) {
	if _, err := NewServerInterceptor(Options{Mode: "invalid"}); !errors.Is(err, ErrInvalidMode) {
		t.Fatal(err)
	}
}
func TestFailClosedNilVerifierAndInvalidAuthorization(t *testing.T) {
	for _, tc := range []struct {
		name string
		v    Verifier
		head map[string]string
	}{
		{"nil-verifier", nil, authHeader()},
		{"missing-authorization", verified(), map[string]string{}},
		{"wrong-scheme", verified(), map[string]string{"Authorization": "Basic valid"}},
		{"blank-token", verified(), map[string]string{"Authorization": "Bearer "}},
		{"extra-space", verified(), map[string]string{"Authorization": "Bearer valid second"}},
		{"expired-token", verified(), map[string]string{"Authorization": "Bearer expired"}},
	} {
		t.Run(tc.name, func(t *testing.T) {
			called := false
			_, err := call(intercept(t, ModeAPI, tc.v), reqWith(tc.head), func(context.Context, connect.AnyRequest) (connect.AnyResponse, error) {
				called = true
				return success(context.Background(), nil)
			})
			requireError(t, err, connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001")
			if called {
				t.Fatal("handler bypassed failed authentication")
			}
		})
	}
}
func TestDuplicateIdentityHeadersRejected(t *testing.T) {
	v := verified()
	r := reqWith(authHeader())
	r.Header().Add("Authorization", "Bearer valid")
	_, err := call(intercept(t, ModeAPI, v), r, success)
	requireError(t, err, connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001")
	if v.calls != 0 {
		t.Fatal("duplicate token reached verifier")
	}
	r = reqWith(authHeader())
	r.Header().Set("x-workspace-id", wsUUID)
	r.Header().Add("x-workspace-id", foreignUUID)
	_, err = call(intercept(t, ModeAPI, v), r, success)
	requireError(t, err, connect.CodeNotFound, "SYSTEM_NOTFOUND_001")
}

func TestSessionWorkspaceCannotBeSpoofed(t *testing.T) {
	v := verified()
	h := authHeader()
	h["x-workspace-id"] = foreignUUID
	called := false
	_, err := call(intercept(t, ModeAPI, v), reqWith(h), func(context.Context, connect.AnyRequest) (connect.AnyResponse, error) {
		called = true
		return connect.NewResponse(&commonv1.UUID{}), nil
	})
	requireError(t, err, connect.CodeNotFound, "SYSTEM_NOTFOUND_001")
	if called {
		t.Fatal("foreign workspace passed")
	}
}
func TestVerifiedSessionAndCorrelationPropagation(t *testing.T) {
	for _, tc := range []struct {
		name      string
		id        string
		want      string
		workspace string
	}{
		{"supplied-UUID", suppliedID, suppliedID, wsUUID},
		{"invalid-injected-ID", "a log \n injection", "", wsUUID},
		{"missing-ID", "", "", ""},
	} {
		t.Run(tc.name, func(t *testing.T) {
			h := authHeader()
			if tc.id != "" {
				h["x-correlation-id"] = tc.id
			}
			if tc.workspace != "" {
				h["x-workspace-id"] = tc.workspace
			}
			invoked := false
			res, err := call(intercept(t, ModeAPI, verified()), reqWith(h), func(ctx context.Context, _ connect.AnyRequest) (connect.AnyResponse, error) {
				invoked = true
				p, ok := PrincipalFromContext(ctx)
				if !ok || p.UserID != userUUID || p.WorkspaceID != wsUUID || p.InternalAdmin {
					t.Fatalf("untrusted identity: %+v", p)
				}
				rid := CorrelationIDFromContext(ctx)
				if !uuidPattern.MatchString(rid) {
					t.Fatalf("bad rid: %s", rid)
				}
				if tc.want != "" && tc.want != rid {
					t.Fatalf("changed valid caller ID: %s", rid)
				}
				return success(ctx, nil)
			})
			if err != nil {
				t.Fatal(err)
			}
			if !invoked {
				t.Fatal("handler not invoked")
			}
			id := res.Header().Get("x-correlation-id")
			if !uuidPattern.MatchString(id) {
				t.Fatalf("invalid correlation header: %s", id)
			}
			if tc.want != "" && id != tc.want {
				t.Fatalf("expected %s, got %s", tc.want, id)
			}
		})
	}
}
func TestBadVerifierAndAdminIsolation(t *testing.T) {
	bad := &fixedVerifier{sess: Session{UserID: "not-uuid", WorkspaceID: wsUUID}}
	_, err := call(intercept(t, ModeAPI, bad), reqWith(authHeader()), success)
	requireError(t, err, connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001")
	_, err = call(intercept(t, ModeAdminAPI, verified()), reqWith(authHeader()), success)
	requireError(t, err, connect.CodePermissionDenied, "ADMIN_FORBIDDEN_001")
	admin := &fixedVerifier{sess: Session{UserID: userUUID, InternalAdmin: true}}
	h := authHeader()
	h["x-workspace-id"] = wsUUID
	_, err = call(intercept(t, ModeAdminAPI, admin), reqWith(h), success)
	requireError(t, err, connect.CodeNotFound, "SYSTEM_NOTFOUND_001")
	res, err := call(intercept(t, ModeAdminAPI, admin), reqWith(authHeader()), func(ctx context.Context, _ connect.AnyRequest) (connect.AnyResponse, error) {
		p, ok := PrincipalFromContext(ctx)
		if !ok || !p.InternalAdmin {
			t.Fatal("expected admin identity")
		}
		return connect.NewResponse(&commonv1.UUID{}), nil
	})
	if err != nil || res == nil {
		t.Fatalf("admin verified test only: %v", err)
	}
}
func TestInternalErrorsRedactSecretsAndPreserveCorrelation(t *testing.T) {
	h := authHeader()
	h["x-request-id"] = suppliedID
	_, err := call(intercept(t, ModeAPI, verified()), reqWith(h), func(context.Context, connect.AnyRequest) (connect.AnyResponse, error) {
		return nil, errors.New("sql: user_password=super-secret /etc/ssl/private/data")
	})
	id := requireError(t, err, connect.CodeInternal, "SYSTEM_INTERNAL_001")
	if id != suppliedID {
		t.Fatalf("wrong error correlation: %s", id)
	}
	if strings.Contains(err.Error(), "super-secret") || strings.Contains(err.Error(), "/etc") {
		t.Fatal("sensitive error leaked")
	}
}
func TestKnownConnectErrorsMappedToCatalog(t *testing.T) {
	for _, tc := range []struct {
		input   error
		code    connect.Code
		catalog string
	}{
		{connect.NewError(connect.CodeInvalidArgument, errors.New("malicious input")), connect.CodeInvalidArgument, "SYSTEM_INVALID_001"},
		{connect.NewError(connect.CodeNotFound, errors.New("foreign row 42")), connect.CodeNotFound, "SYSTEM_NOTFOUND_001"},
		{connect.NewError(connect.CodeResourceExhausted, errors.New("burst key")), connect.CodeResourceExhausted, "SYSTEM_LIMIT_001"},
		{context.DeadlineExceeded, connect.CodeDeadlineExceeded, "SYSTEM_TIMEOUT_001"},
		{context.Canceled, connect.CodeCanceled, "SYSTEM_CANCELED_001"},
	} {
		_, err := call(intercept(t, ModeAPI, verified()), reqWith(authHeader()), func(context.Context, connect.AnyRequest) (connect.AnyResponse, error) { return nil, tc.input })
		requireError(t, err, tc.code, tc.catalog)
	}
}

type fakeStream struct {
	req     http.Header
	resp    http.Header
	trailer http.Header
}

func newStream(h map[string]string) *fakeStream {
	s := &fakeStream{req: http.Header{}, resp: http.Header{}, trailer: http.Header{}}
	for k, v := range h {
		s.req.Set(k, v)
	}
	return s
}
func (s *fakeStream) Spec() connect.Spec           { return connect.Spec{} }
func (s *fakeStream) Peer() connect.Peer           { return connect.Peer{} }
func (s *fakeStream) Receive(_ any) error          { return io.EOF }
func (s *fakeStream) RequestHeader() http.Header   { return s.req }
func (s *fakeStream) Send(_ any) error             { return nil }
func (s *fakeStream) ResponseHeader() http.Header  { return s.resp }
func (s *fakeStream) ResponseTrailer() http.Header { return s.trailer }
func TestStreamingRejectsAuthAndSanitizesDeadline(t *testing.T) {
	interceptor := intercept(t, ModeAPI, verified())
	called := false
	stream := newStream(map[string]string{})
	err := interceptor.WrapStreamingHandler(func(context.Context, connect.StreamingHandlerConn) error {
		called = true
		return nil
	})(context.Background(), stream)
	requireError(t, err, connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001")
	if called {
		t.Fatal("unauthorized stream invoked")
	}
	h := authHeader()
	h["x-correlation-id"] = suppliedID
	stream = newStream(h)
	err = interceptor.WrapStreamingHandler(func(ctx context.Context, _ connect.StreamingHandlerConn) error {
		p, ok := PrincipalFromContext(ctx)
		if !ok || p.WorkspaceID != wsUUID {
			t.Fatal("stream context not bound")
		}
		return fmtDeadline()
	})(context.Background(), stream)
	requireError(t, err, connect.CodeDeadlineExceeded, "SYSTEM_TIMEOUT_001")
	if got := stream.resp.Get("x-correlation-id"); got != suppliedID {
		t.Fatalf("stream correlation header %s", got)
	}
}
func fmtDeadline() error       { return fmtError(context.DeadlineExceeded) }
func fmtError(err error) error { return fmt.Errorf("wrapped: %w", err) }
func TestDeadlineContextFromVerifier(t *testing.T) {
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	_, err := callWithContext(ctx, intercept(t, ModeAPI, verified()), reqWith(authHeader()), success)
	// Even if a test verifier incorrectly ignores cancellation, the
	// interceptor must reject a cancelled RPC before calling the handler.
	requireError(t, err, connect.CodeCanceled, "SYSTEM_CANCELED_001")
}
func callWithContext(ctx context.Context, i connect.Interceptor, r *connect.Request[commonv1.UUID], handler connect.UnaryFunc) (connect.AnyResponse, error) {
	return i.WrapUnary(handler)(ctx, r)
}
func TestContextCancellationPassedThrough(t *testing.T) {
	v := verified()
	ctx, cancel := context.WithTimeout(context.Background(), time.Nanosecond)
	defer cancel()
	<-ctx.Done()
	_, err := callWithContext(ctx, intercept(t, ModeAPI, v), reqWith(authHeader()), func(ctx context.Context, _ connect.AnyRequest) (connect.AnyResponse, error) {
		return nil, ctx.Err()
	})
	requireError(t, err, connect.CodeDeadlineExceeded, "SYSTEM_TIMEOUT_001")
}

func TestEmptyWorkspaceHeaderAndNilUUIDFailClosed(t *testing.T) {
	for _, mode := range []Mode{ModeAPI, ModeAdminAPI} {
		verifier := verified()
		if mode == ModeAdminAPI {
			verifier.sess = Session{UserID: userUUID, InternalAdmin: true}
		}
		req := reqWith(authHeader())
		req.Header().Set("x-workspace-id", "")
		_, err := call(intercept(t, mode, verifier), req, success)
		requireError(t, err, connect.CodeNotFound, "SYSTEM_NOTFOUND_001")
	}
	for _, tc := range []Session{
		{UserID: nilUUID, WorkspaceID: wsUUID},
		{UserID: userUUID, WorkspaceID: nilUUID},
	} {
		verifier := &fixedVerifier{sess: tc}
		_, err := call(intercept(t, ModeAPI, verifier), reqWith(authHeader()), success)
		requireError(t, err, connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001")
	}
}
func TestAdminResidualTenantRejected(t *testing.T) {
	verifier := &fixedVerifier{sess: Session{UserID: userUUID, WorkspaceID: wsUUID, InternalAdmin: true}}
	_, err := call(intercept(t, ModeAdminAPI, verifier), reqWith(authHeader()), success)
	requireError(t, err, connect.CodePermissionDenied, "ADMIN_FORBIDDEN_001")
}
func TestAmbiguousCorrelationHeadersAreNotTrusted(t *testing.T) {
	for _, tc := range []struct {
		name                 string
		correlation, request string
		duplicate            bool
	}{
		{"duplicate-correlation", suppliedID, "", true},
		{"conflicting-trace", suppliedID, foreignUUID, false},
		{"invalid-correlation-and-valid-request", "broken", suppliedID, false},
	} {
		t.Run(tc.name, func(t *testing.T) {
			req := reqWith(authHeader())
			req.Header().Set("x-correlation-id", tc.correlation)
			if tc.request != "" {
				req.Header().Set("x-request-id", tc.request)
			}
			if tc.duplicate {
				req.Header().Add("x-correlation-id", foreignUUID)
			}
			orig := append([]string(nil), req.Header().Values("x-correlation-id")...)
			res, err := call(intercept(t, ModeAPI, verified()), req, func(ctx context.Context, r connect.AnyRequest) (connect.AnyResponse, error) {
				id := CorrelationIDFromContext(ctx)
				if !validUUID(id) || id == suppliedID || id == foreignUUID {
					t.Fatalf("ambiguous caller trace trusted: %s", id)
				}
				principal, ok := PrincipalFromContext(ctx)
				if !ok || principal.WorkspaceID != wsUUID {
					t.Fatal("verified principal missing from context")
				}
				if len(r.Header().Values("x-correlation-id")) != len(orig) {
					t.Fatal("mutated caller-owned http.Header")
				}
				return connect.NewResponse(&commonv1.UUID{Value: id}), nil
			})
			if err != nil {
				t.Fatal(err)
			}
			if res.Header().Get("x-correlation-id") != res.Any().(*commonv1.UUID).GetValue() {
				t.Fatal("response correlation does not match context")
			}
		})
	}
}
func TestDuplicateWorkspaceDoesNotDiscloseBeforeAuthentication(t *testing.T) {
	v := verified()
	req := reqWith(map[string]string{})
	req.Header().Add("x-workspace-id", wsUUID)
	req.Header().Add("x-workspace-id", foreignUUID)
	_, err := call(intercept(t, ModeAPI, v), req, success)
	requireError(t, err, connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001")
	if v.calls != 0 {
		t.Fatal("invalid token reached verifier")
	}
}
func TestVerifierChildTimeoutMapsCorrectly(t *testing.T) {
	v := &fixedVerifier{sess: Session{UserID: userUUID, WorkspaceID: wsUUID}, err: fmt.Errorf("JWKS transport timeout: %w", context.DeadlineExceeded)}
	_, err := call(intercept(t, ModeAPI, v), reqWith(authHeader()), success)
	requireError(t, err, connect.CodeDeadlineExceeded, "SYSTEM_TIMEOUT_001")
	if strings.Contains(err.Error(), "JWKS transport") {
		t.Fatal("verifier error leaked")
	}
}
func TestRequestCancellationOverridesDownstreamError(t *testing.T) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	_, err := callWithContext(ctx, intercept(t, ModeAPI, verified()), reqWith(authHeader()), func(context.Context, connect.AnyRequest) (connect.AnyResponse, error) {
		cancel()
		return nil, errors.New("sql connection error")
	})
	requireError(t, err, connect.CodeCanceled, "SYSTEM_CANCELED_001")
	if strings.Contains(err.Error(), "sql") {
		t.Fatal("database failure string leaked")
	}
}

func TestCanceledBeforeVerificationDoesNotReachHandler(t *testing.T) {
	v := verified()
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	called := false
	_, err := callWithContext(ctx, intercept(t, ModeAPI, v), reqWith(authHeader()), func(context.Context, connect.AnyRequest) (connect.AnyResponse, error) {
		called = true
		return connect.NewResponse(&commonv1.UUID{}), nil
	})
	requireError(t, err, connect.CodeCanceled, "SYSTEM_CANCELED_001")
	if called || v.calls != 0 {
		t.Fatal("canceled request crossed authentication boundary")
	}
}
func TestWrappedConnectInternalDoesNotBecomeClientTimeout(t *testing.T) {
	_, err := call(intercept(t, ModeAPI, verified()), reqWith(authHeader()), func(context.Context, connect.AnyRequest) (connect.AnyResponse, error) {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("SQL socket timeout: %w", context.DeadlineExceeded))
	})
	requireError(t, err, connect.CodeInternal, "SYSTEM_INTERNAL_001")
	if strings.Contains(err.Error(), "SQL socket") {
		t.Fatal("internal error leaked")
	}
}
func TestStreamingCancellationBeforeHandler(t *testing.T) {
	v := verified()
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	called := false
	err := intercept(t, ModeAPI, v).WrapStreamingHandler(func(context.Context, connect.StreamingHandlerConn) error { called = true; return nil })(ctx, newStream(authHeader()))
	requireError(t, err, connect.CodeCanceled, "SYSTEM_CANCELED_001")
	if called || v.calls != 0 {
		t.Fatal("stream executed with canceled context")
	}
}
