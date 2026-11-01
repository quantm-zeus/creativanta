package transportfixture_test

import (
	"context"
	"net/http/httptest"
	"strings"
	"sync"
	"testing"
	"time"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	fixturev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/transport/test/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/transport/test/v1/transporttestv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportfixture"
)

const workspace = "018f7a31-2233-7444-8555-667788990011"
const foreign = "018f7a31-2233-7444-8555-667788990022"

func client(t *testing.T) (transporttestv1connect.TransportFixtureServiceClient, func()) {
	t.Helper()
	ts := httptest.NewServer(transportfixture.NewTestHandler())
	return transporttestv1connect.NewTransportFixtureServiceClient(ts.Client(), ts.URL), ts.Close
}
func metadata[T any](msg *T, id, ws string) *connect.Request[T] {
	req := connect.NewRequest(msg)
	req.Header().Set("x-workspace-id", ws)
	req.Header().Set("x-request-id", id)
	return req
}

func TestEcho(t *testing.T) {
	c, closeFn := client(t)
	defer closeFn()
	req := metadata(&fixturev1.EchoRequest{Text: "hello typed", WorkspaceId: workspace}, "test-echo", workspace)
	resp, err := c.Echo(context.Background(), req)
	if err != nil {
		t.Fatal(err)
	}
	if resp.Msg.GetText() != "hello typed" || resp.Msg.GetWorkspaceId() != workspace {
		t.Fatalf("unexpected response: %v", resp.Msg)
	}
	if resp.Header().Get("x-correlation-id") != "test-echo" {
		t.Fatalf("correlation ID missing: %v", resp.Header())
	}
}
func TestEchoMetadataFailures(t *testing.T) {
	c, closeFn := client(t)
	defer closeFn()
	_, err := c.Echo(context.Background(), connect.NewRequest(&fixturev1.EchoRequest{Text: "x", WorkspaceId: workspace}))
	if connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("missing metadata must be unauthenticated: %v", err)
	}
	_, err = c.Echo(context.Background(), metadata(&fixturev1.EchoRequest{Text: "x", WorkspaceId: foreign}, "test-foreign", workspace))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("foreign workspace must be denied: %v", err)
	}
	_, err = c.Echo(context.Background(), metadata(&fixturev1.EchoRequest{Text: "x", WorkspaceId: "not-an-id"}, "test-bad", workspace))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("body workspace mismatch must be denied: %v", err)
	}
}
func TestIdempotencyReplayConflict(t *testing.T) {
	c, closeFn := client(t)
	defer closeFn()
	ctx := &commonv1.CommandContext{IdempotencyKey: "same-key", WorkspaceId: &commonv1.UUID{Value: workspace}}
	mk := func(payload, id string) *connect.Request[fixturev1.ExecuteRequest] {
		return metadata(&fixturev1.ExecuteRequest{Context: ctx, Payload: payload}, id, workspace)
	}
	first, err := c.Execute(context.Background(), mk("payload", "test-e1"))
	if err != nil {
		t.Fatal(err)
	}
	if first.Msg.GetReplayed() {
		t.Fatal("first write claimed replay")
	}
	second, err := c.Execute(context.Background(), mk("payload", "test-e2"))
	if err != nil {
		t.Fatal(err)
	}
	if !second.Msg.GetReplayed() {
		t.Fatal("second identical write did not replay")
	}
	_, err = c.Execute(context.Background(), mk("changed", "test-e3"))
	if connect.CodeOf(err) != connect.CodeAlreadyExists || !strings.Contains(err.Error(), "SYSTEM_CONFLICT_001") {
		t.Fatalf("changed payload must conflict: %v", err)
	}
}

func TestConcurrentIdempotencyOneNew(t *testing.T) {
	c, closeFn := client(t)
	defer closeFn()
	var wg sync.WaitGroup
	replays := make(chan bool, 24)
	errs := make(chan error, 24)
	for i := 0; i < 24; i++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			req := metadata(&fixturev1.ExecuteRequest{
				Context: &commonv1.CommandContext{IdempotencyKey: "concurrent", WorkspaceId: &commonv1.UUID{Value: workspace}}, Payload: "same",
			}, "test-concurrent", workspace)
			res, err := c.Execute(context.Background(), req)
			if err != nil {
				errs <- err
				return
			}
			replays <- res.Msg.GetReplayed()
		}()
	}
	wg.Wait()
	close(replays)
	close(errs)
	for err := range errs {
		t.Error(err)
	}
	falseCount := 0
	for replay := range replays {
		if !replay {
			falseCount++
		}
	}
	if falseCount != 1 {
		t.Fatalf("exactly one first write expected, got %d", falseCount)
	}
}
func TestForeignAndTamperedCursorDenied(t *testing.T) {
	fixture, handler := transportfixture.NewTestHandlerWithServer()
	ts := httptest.NewServer(handler)
	defer ts.Close()
	c := transporttestv1connect.NewTransportFixtureServiceClient(ts.Client(), ts.URL)
	first, err := c.List(context.Background(), metadata(&fixturev1.ListRequest{
		WorkspaceId: workspace, Pagination: &commonv1.Pagination{PageSize: 2},
	}, "test-list1", workspace))
	if err != nil {
		t.Fatal(err)
	}
	if len(first.Msg.GetItems()) != 2 || !first.Msg.GetPagination().GetHasMore() {
		t.Fatalf("first page wrong: %v", first.Msg)
	}
	token := first.Msg.GetPagination().GetNextPageToken()
	if len(token) < 20 {
		t.Fatal("missing signed cursor")
	}
	_, err = c.List(context.Background(), metadata(&fixturev1.ListRequest{
		WorkspaceId: foreign, Pagination: &commonv1.Pagination{PageSize: 2, PageToken: token},
	}, "test-list2", foreign))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("foreign workspace cursor accepted: %v", err)
	}
	_, err = c.List(context.Background(), metadata(&fixturev1.ListRequest{
		WorkspaceId: workspace, Pagination: &commonv1.Pagination{PageSize: 2, PageToken: token + "X"},
	}, "test-list3", workspace))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("tampered cursor accepted: %v", err)
	}
	_, err = c.List(context.Background(), metadata(&fixturev1.ListRequest{
		WorkspaceId: workspace, Pagination: &commonv1.Pagination{PageSize: 2, PageToken: token}, Filter: "beta",
	}, "test-list4", workspace))
	if connect.CodeOf(err) != connect.CodeInvalidArgument {
		t.Fatalf("changed filter cursor accepted: %v", err)
	}
	_, err = fixture.VerifyCursor(token, foreign, "", "")
	if err == nil {
		t.Fatal("foreign signed cursor passed verification")
	}
}
func TestDeadlineAndStreamCancel(t *testing.T) {
	c, closeFn := client(t)
	defer closeFn()
	req := metadata(&fixturev1.EchoRequest{Text: "slow", WorkspaceId: workspace}, "test-slow", workspace)
	req.Header().Set("x-test-delay-ms", "500")
	ctx, cancel := context.WithTimeout(context.Background(), 35*time.Millisecond)
	defer cancel()
	_, err := c.Echo(ctx, req)
	if err == nil {
		t.Fatal("deadline ignored")
	}
	streamCtx, stop := context.WithCancel(context.Background())
	defer stop()
	stream, err := c.Watch(streamCtx, metadata(&fixturev1.WatchRequest{MaxEvents: 10}, "test-watch", workspace))
	if err != nil {
		t.Fatal(err)
	}
	if !stream.Receive() {
		t.Fatalf("no stream event, err=%v", stream.Err())
	}
	if stream.Msg().GetSequence() != 1 {
		t.Fatalf("first stream sequence invalid: %v", stream.Msg())
	}
	stop()
	for stream.Receive() {
	}
	if stream.Err() == nil {
		t.Fatal("cancelled stream returned success")
	}
}
