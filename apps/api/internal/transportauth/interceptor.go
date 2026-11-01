// Package transportauth provides fail-closed Connect server interception.
// P0-03 supplies Clerk verification; P0-04/05 supply durable tenant state.
// No RPC is exposed or mounted in production by this package.
package transportauth

import (
	"context"
	"crypto/rand"
	"errors"
	"fmt"
	"net/http"
	"regexp"
	"strings"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
)

const nilUUID = "00000000-0000-0000-0000-000000000000"

func validUUID(value string) bool {
	return value != nilUUID && uuidPattern.MatchString(value)
}

type Mode string

const (
	ModeAPI      Mode = "api"
	ModeAdminAPI Mode = "admin-api"
)

var (
	ErrInvalidMode = errors.New("transportauth: invalid mode")
	uuidPattern    = regexp.MustCompile("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$")
)

// Session must come from a verified identity token, never a client header.
// UserID is Creativanta's internal UUID, not an unverified Clerk subject.
type Session struct {
	UserID        string
	WorkspaceID   string
	InternalAdmin bool
}
type Verifier interface {
	Verify(ctx context.Context, bearerToken string) (Session, error)
}
type Options struct {
	Mode     Mode
	Verifier Verifier
}
type principalContextKey struct{}
type correlationContextKey struct{}

func PrincipalFromContext(ctx context.Context) (Session, bool) {
	p, ok := ctx.Value(principalContextKey{}).(Session)
	return p, ok
}
func CorrelationIDFromContext(ctx context.Context) string {
	v, _ := ctx.Value(correlationContextKey{}).(string)
	return v
}

// A nil verifier is permitted at construction but all calls FAIL CLOSED.
func NewServerInterceptor(opts Options) (connect.Interceptor, error) {
	if opts.Mode != ModeAPI && opts.Mode != ModeAdminAPI {
		return nil, ErrInvalidMode
	}
	return &serverInterceptor{opts: opts}, nil
}

type serverInterceptor struct{ opts Options }

func (s *serverInterceptor) WrapUnary(next connect.UnaryFunc) connect.UnaryFunc {
	return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		id, err := correlation(req.Header())
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, errors.New(publicErrors["SYSTEM_INTERNAL_001"]))
		}
		ctx, err = s.authenticate(ctx, req.Header(), id)
		if err != nil {
			return nil, err
		}
		if err = ctx.Err(); err != nil {
			return nil, sanitize(err, id, s.opts.Mode)
		}
		res, err := next(ctx, req)
		if err != nil {
			return nil, sanitize(err, id, s.opts.Mode)
		}
		if err = ctx.Err(); err != nil {
			return nil, sanitize(err, id, s.opts.Mode)
		}
		if res == nil {
			return nil, safeError(connect.CodeInternal, "SYSTEM_INTERNAL_001", id)
		}
		res.Header().Set("x-correlation-id", id)
		return res, nil
	}
}
func (s *serverInterceptor) WrapStreamingClient(next connect.StreamingClientFunc) connect.StreamingClientFunc {
	return next
}
func (s *serverInterceptor) WrapStreamingHandler(next connect.StreamingHandlerFunc) connect.StreamingHandlerFunc {
	return func(ctx context.Context, conn connect.StreamingHandlerConn) error {
		id, err := correlation(conn.RequestHeader())
		if err != nil {
			return connect.NewError(connect.CodeInternal, errors.New(publicErrors["SYSTEM_INTERNAL_001"]))
		}
		conn.ResponseHeader().Set("x-correlation-id", id)
		ctx, err = s.authenticate(ctx, conn.RequestHeader(), id)
		if err != nil {
			return err
		}
		if err = ctx.Err(); err != nil {
			return sanitize(err, id, s.opts.Mode)
		}
		if err = next(ctx, conn); err != nil {
			return sanitize(err, id, s.opts.Mode)
		}
		if err = ctx.Err(); err != nil {
			return sanitize(err, id, s.opts.Mode)
		}
		return nil
	}
}
func (s *serverInterceptor) authenticate(ctx context.Context, h http.Header, id string) (context.Context, error) {
	if err := ctx.Err(); err != nil {
		return nil, sanitize(err, id, s.opts.Mode)
	}
	if s.opts.Verifier == nil || len(h.Values("Authorization")) != 1 {
		return nil, safeError(connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001", id)
	}
	workspaceHeaders := h.Values("x-workspace-id")
	if len(workspaceHeaders) > 1 {
		return nil, safeError(connect.CodeNotFound, "SYSTEM_NOTFOUND_001", id)
	}
	authorization := h.Get("Authorization")
	if len(authorization) < 8 || len(authorization) > 8199 || !strings.HasPrefix(authorization, "Bearer ") {
		return nil, safeError(connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001", id)
	}
	token := strings.TrimPrefix(authorization, "Bearer ")
	if token == "" || strings.TrimSpace(token) != token || strings.ContainsAny(token, " \t\r\n") {
		return nil, safeError(connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001", id)
	}
	principal, err := s.opts.Verifier.Verify(ctx, token)
	if ctxErr := ctx.Err(); ctxErr != nil {
		return nil, sanitize(ctxErr, id, s.opts.Mode)
	}
	if err != nil || !validUUID(principal.UserID) {
		return nil, safeError(connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001", id)
	}
	if s.opts.Mode == ModeAdminAPI {
		if !principal.InternalAdmin || principal.WorkspaceID != "" {
			return nil, safeError(connect.CodePermissionDenied, "ADMIN_FORBIDDEN_001", id)
		}
		// Admin must use separately authorized typed targets, not x-workspace-id.
		if len(workspaceHeaders) != 0 {
			return nil, safeError(connect.CodeNotFound, "SYSTEM_NOTFOUND_001", id)
		}
	} else {
		if principal.InternalAdmin || !validUUID(principal.WorkspaceID) {
			return nil, safeError(connect.CodeUnauthenticated, "AUTH_FORBIDDEN_001", id)
		}
		if len(workspaceHeaders) == 1 && workspaceHeaders[0] != principal.WorkspaceID {
			return nil, safeError(connect.CodeNotFound, "SYSTEM_NOTFOUND_001", id)
		}
	}
	// Normalize metadata seen by downstream handlers to the verified identity.
	// Domain handlers must still use PrincipalFromContext for authorization.
	if s.opts.Mode == ModeAPI {
		h.Set("x-workspace-id", principal.WorkspaceID)
	} else {
		h.Del("x-workspace-id")
	}
	ctx = context.WithValue(ctx, principalContextKey{}, principal)
	ctx = context.WithValue(ctx, correlationContextKey{}, id)
	return ctx, nil
}
func correlation(h http.Header) (string, error) {
	var id string
	for _, key := range []string{"x-correlation-id", "x-request-id"} {
		values := h.Values(key)
		if len(values) > 1 {
			break
		} // ambiguous caller trace headers are not trustworthy
		if len(values) == 1 && validUUID(values[0]) {
			id = values[0]
			break
		}
	}
	if id == "" {
		var raw [16]byte
		if _, err := rand.Read(raw[:]); err != nil {
			return "", fmt.Errorf("correlation entropy unavailable: %w", err)
		}
		raw[6] = raw[6]&0x0f | 0x40
		raw[8] = raw[8]&0x3f | 0x80
		id = fmt.Sprintf("%x-%x-%x-%x-%x", raw[:4], raw[4:6], raw[6:8], raw[8:10], raw[10:])
	}
	// Canonicalize the headers visible to downstream Connect handlers.
	h.Set("x-correlation-id", id)
	h.Set("x-request-id", id)
	return id, nil
}

var publicErrors = map[string]string{
	"AUTH_FORBIDDEN_001":   "Phiên đăng nhập chưa hợp lệ.",
	"ADMIN_FORBIDDEN_001":  "Bạn không có quyền quản trị cho thao tác này.",
	"SYSTEM_INVALID_001":   "Dữ liệu yêu cầu không hợp lệ.",
	"SYSTEM_NOTFOUND_001":  "Không tìm thấy tài nguyên.",
	"SYSTEM_FORBIDDEN_001": "Bạn không có quyền truy cập.",
	"SYSTEM_INTERNAL_001":  "Lỗi hệ thống. Vui lòng thử lại sau.",
	"SYSTEM_TIMEOUT_001":   "Yêu cầu hết thời gian chờ.",
	"SYSTEM_CANCELED_001":  "Yêu cầu đã bị hủy.",
	"SYSTEM_LIMIT_001":     "Quá nhiều yêu cầu. Vui lòng chờ.",
	"SYSTEM_CONFLICT_001":  "Mã yêu cầu đã dùng cho nội dung khác. Vui lòng tải lại.",
}

func safeError(code connect.Code, key, id string) *connect.Error {
	message, ok := publicErrors[key]
	if !ok {
		code = connect.CodeInternal
		key = "SYSTEM_INTERNAL_001"
		message = publicErrors[key]
	}
	e := connect.NewError(code, errors.New(message))
	e.Meta().Set("x-correlation-id", id)
	detail, err := connect.NewErrorDetail(&commonv1.ErrorDetail{Code: key, Message: message, CorrelationId: &commonv1.UUID{Value: id}})
	if err == nil {
		e.AddDetail(detail)
	}
	return e
}
func sanitize(err error, id string, mode Mode) error {
	if err == nil {
		return nil
	}
	code := connect.CodeOf(err)
	if code == connect.CodeUnknown {
		if errors.Is(err, context.Canceled) {
			return safeError(connect.CodeCanceled, "SYSTEM_CANCELED_001", id)
		}
		if errors.Is(err, context.DeadlineExceeded) {
			return safeError(connect.CodeDeadlineExceeded, "SYSTEM_TIMEOUT_001", id)
		}
	}
	switch code {
	case connect.CodeUnauthenticated:
		return safeError(code, "AUTH_FORBIDDEN_001", id)
	case connect.CodePermissionDenied:
		if mode == ModeAdminAPI {
			return safeError(code, "ADMIN_FORBIDDEN_001", id)
		}
		return safeError(code, "SYSTEM_FORBIDDEN_001", id)
	case connect.CodeNotFound:
		return safeError(code, "SYSTEM_NOTFOUND_001", id)
	case connect.CodeInvalidArgument:
		return safeError(code, "SYSTEM_INVALID_001", id)
	case connect.CodeDeadlineExceeded:
		return safeError(code, "SYSTEM_TIMEOUT_001", id)
	case connect.CodeCanceled:
		return safeError(code, "SYSTEM_CANCELED_001", id)
	case connect.CodeResourceExhausted:
		return safeError(code, "SYSTEM_LIMIT_001", id)
	case connect.CodeAlreadyExists:
		return safeError(code, "SYSTEM_CONFLICT_001", id)
	default:
		return safeError(connect.CodeInternal, "SYSTEM_INTERNAL_001", id)
	}
}
