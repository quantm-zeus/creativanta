// Package transportfixture is a TEST-ONLY Connect and gRPC cross-language fixture.
// Never register this handler in production cmd/api or cmd/admin-api.
package transportfixture

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"net/http"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	fixturev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/transport/test/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/transport/test/v1/transporttestv1connect"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/protobuf/proto"
)

var canonicalUUID = regexp.MustCompile(`^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$`)

type Server struct {
	mu          sync.Mutex
	idempotency map[string]string // Test-only memory. Never an economic idempotency store.
	hmacSecret  []byte
	sem         chan struct{}
}

var _ transporttestv1connect.TransportFixtureServiceHandler = (*Server)(nil)

func New() (*Server, error) {
	secret := make([]byte, 32)
	if _, err := rand.Read(secret); err != nil {
		return nil, fmt.Errorf("secure cursor secret: %w", err)
	}
	return &Server{hmacSecret: secret, idempotency: make(map[string]string), sem: make(chan struct{}, 100)}, nil
}

func MustNew() *Server {
	s, err := New()
	if err != nil {
		panic(err)
	}
	return s
}

func Handler(s *Server) http.Handler {
	if s == nil {
		panic("transport fixture server required")
	}
	mux := http.NewServeMux()
	path, h := transporttestv1connect.NewTransportFixtureServiceHandler(s)
	mux.Handle(path, h)
	bounded := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		select {
		case s.sem <- struct{}{}:
			defer func() { <-s.sem }()
			mux.ServeHTTP(w, r)
		case <-r.Context().Done():
			http.Error(w, "cancelled", http.StatusRequestTimeout)
		}
	})
	return h2c.NewHandler(bounded, &http2.Server{})
}

func (s *Server) Handler() http.Handler                 { return Handler(s) }
func NewTestHandler() http.Handler                      { return Handler(MustNew()) }
func NewTestHandlerWithServer() (*Server, http.Handler) { s := MustNew(); return s, Handler(s) }

func validateMetadata(h http.Header, bodyWorkspace string) (string, string, error) {
	ws := h.Get("x-workspace-id")
	requestID := h.Get("x-request-id")
	if ws == "" || requestID == "" {
		return "", "", connect.NewError(connect.CodeUnauthenticated, errors.New("missing test identity metadata"))
	}
	if len(requestID) > 128 {
		return "", "", connect.NewError(connect.CodeInvalidArgument, errors.New("request-id length > 128"))
	}
	if !canonicalUUID.MatchString(ws) {
		return "", "", connect.NewError(connect.CodeInvalidArgument, errors.New("invalid workspace UUID"))
	}
	if bodyWorkspace != "" && bodyWorkspace != ws {
		return "", "", connect.NewError(connect.CodePermissionDenied, errors.New("workspace mismatch"))
	}
	return ws, requestID, nil
}

func (s *Server) Echo(ctx context.Context, req *connect.Request[fixturev1.EchoRequest]) (*connect.Response[fixturev1.EchoResponse], error) {
	ws, rid, err := validateMetadata(req.Header(), req.Msg.GetWorkspaceId())
	if err != nil {
		return nil, err
	}
	text := req.Msg.GetText()
	if len(text) < 1 || len(text) > 1000 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("text required (max 1000)"))
	}
	if delay := req.Header().Get("x-test-delay-ms"); delay != "" {
		n, err := strconv.Atoi(delay)
		if err != nil || n < 0 || n > 2000 {
			return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid test delay"))
		}
		if n > 0 {
			timer := time.NewTimer(time.Duration(n) * time.Millisecond)
			defer timer.Stop()
			select {
			case <-timer.C:
			case <-ctx.Done():
				return nil, connect.NewError(connect.CodeOf(ctx.Err()), ctx.Err())
			}
		}
	}
	res := connect.NewResponse(&fixturev1.EchoResponse{Text: text, WorkspaceId: ws})
	res.Header().Set("x-correlation-id", rid)
	return res, nil
}

func (s *Server) Execute(ctx context.Context, req *connect.Request[fixturev1.ExecuteRequest]) (*connect.Response[fixturev1.ExecuteResponse], error) {
	envelope := req.Msg.GetContext()
	if envelope == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("command context required"))
	}
	ws, rid, err := validateMetadata(req.Header(), envelope.GetWorkspaceId().GetValue())
	if err != nil {
		return nil, err
	}
	key := envelope.GetIdempotencyKey()
	if len(key) < 1 || len(key) > 255 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid idempotency key"))
	}
	payload := req.Msg.GetPayload()
	if len(payload) < 1 || len(payload) > 4096 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("payload required (max 4096)"))
	}
	hash := sha256.Sum256([]byte(payload))
	recordKey := ws + "/" + key
	s.mu.Lock()
	before, exists := s.idempotency[recordKey]
	if !exists {
		s.idempotency[recordKey] = hex.EncodeToString(hash[:])
	}
	s.mu.Unlock()
	if exists && before != hex.EncodeToString(hash[:]) {
		return nil, connect.NewError(connect.CodeAlreadyExists, errors.New("SYSTEM_CONFLICT_001"))
	}
	res := connect.NewResponse(&fixturev1.ExecuteResponse{Payload: payload, Replayed: exists})
	res.Header().Set("x-correlation-id", rid)
	return res, nil
}

func (s *Server) List(ctx context.Context, req *connect.Request[fixturev1.ListRequest]) (*connect.Response[fixturev1.ListResponse], error) {
	ws, rid, err := validateMetadata(req.Header(), req.Msg.GetWorkspaceId())
	if err != nil {
		return nil, err
	}
	filter, order := req.Msg.GetFilter(), req.Msg.GetSort()
	if len(filter) > 255 || len(order) > 128 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid query bounds"))
	}
	if order != "" && order != "asc" && order != "desc" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid sort"))
	}
	pageSize := int32(20)
	token := ""
	if p := req.Msg.GetPagination(); p != nil {
		pageSize = p.GetPageSize()
		token = p.GetPageToken()
		if pageSize == 0 {
			pageSize = 20
		}
	}
	if pageSize < 1 || pageSize > 100 || len(token) > 512 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid pagination parameters"))
	}
	offset := 0
	if token != "" {
		payload, err := s.VerifyCursor(token, ws, filter, order)
		if err != nil {
			return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("invalid pagination cursor"))
		}
		offset = payload.Offset
	}
	items := []string{"alpha", "beta", "gamma", "delta", "epsilon"}
	var filtered []string
	for _, item := range items {
		if strings.Contains(strings.ToLower(item), strings.ToLower(filter)) {
			filtered = append(filtered, item)
		}
	}
	sort.Strings(filtered)
	if order == "desc" {
		sort.Sort(sort.Reverse(sort.StringSlice(filtered)))
	}
	count := len(filtered)
	if offset > count {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("cursor offset out of bounds"))
	}
	end := offset + int(pageSize)
	if end > count {
		end = count
	}
	next := ""
	hasMore := end < count
	if hasMore {
		next, err = s.SignCursor(ws, filter, order, end)
		if err != nil {
			return nil, connect.NewError(connect.CodeInternal, errors.New("cursor signing unavailable"))
		}
	}
	res := connect.NewResponse(&fixturev1.ListResponse{Items: filtered[offset:end], Pagination: &commonv1.PaginatedResponse{
		NextPageToken: next, TotalCount: proto.Int64(int64(count)), HasMore: hasMore,
	}})
	res.Header().Set("x-correlation-id", rid)
	return res, nil
}

func (s *Server) Watch(ctx context.Context, req *connect.Request[fixturev1.WatchRequest], stream *connect.ServerStream[fixturev1.WatchResponse]) error {
	_, rid, err := validateMetadata(req.Header(), "")
	if err != nil {
		return err
	}
	max := req.Msg.GetMaxEvents()
	if max < 1 || max > 10 {
		return connect.NewError(connect.CodeInvalidArgument, errors.New("invalid max_events"))
	}
	stream.ResponseHeader().Set("x-correlation-id", rid)
	ticker := time.NewTicker(65 * time.Millisecond)
	defer ticker.Stop()
	for i := int32(1); i <= max; i++ {
		select {
		case <-ctx.Done():
			return connect.NewError(connect.CodeOf(ctx.Err()), ctx.Err())
		case <-ticker.C:
			if err := stream.Send(&fixturev1.WatchResponse{Sequence: i, Message: fmt.Sprintf("event-%d", i)}); err != nil {
				return err
			}
		}
	}
	return nil
}
