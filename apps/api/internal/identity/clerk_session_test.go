package identity

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"
)

func TestSessionCheckerConfiguration(t *testing.T) {
	if _, err := NewClerkSessionStatus(""); !errors.Is(err, ErrNotConfigured) {
		t.Fatal("missing credentials accepted")
	}
	c, err := NewClerkSessionStatus("sk_" + strings.Repeat("x", 20))
	if err != nil || c.endpoint != clerkSessionAPI {
		t.Fatal("not fixed to provider API", err)
	}
}

func TestFreshSessionStateAndRevocation(t *testing.T) {
	state := "active"
	user := "user_fixture"
	id := "sess_fixture"
	expire := int64(0)
	calls := 0
	srv := httptest.NewTLSServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		calls++
		if r.Method != "GET" || r.URL.Path != "/v1/sessions/sess_fixture" || r.Header.Get("Authorization") != "Bearer fixture" {
			t.Errorf("invalid request")
		}
		if state == "404" {
			w.WriteHeader(404)
			return
		}
		if state == "error" {
			w.WriteHeader(503)
			return
		}
		if state == "malformed" {
			_, _ = w.Write([]byte("{"))
			return
		}
		_ = json.NewEncoder(w).Encode(map[string]any{"id": id, "user_id": user, "status": state, "expire_at": expire})
	}))
	defer srv.Close()
	checker := &ClerkSessionStatus{endpoint: srv.URL + "/v1/sessions/", authorization: "Bearer fixture", client: srv.Client()}
	for _, tc := range []struct {
		name, st, who, sid  string
		expire              int64
		good, errorExpected bool
	}{
		{"active", "active", "user_fixture", "sess_fixture", 0, true, false},
		{"revoked", "revoked", "user_fixture", "sess_fixture", 0, false, false},
		{"expired", "expired", "user_fixture", "sess_fixture", 0, false, false},
		{"foreign_user", "active", "user_foreign", "sess_fixture", 0, false, false},
		{"other_session", "active", "user_fixture", "sess_other", 0, false, false},
		{"expired_at", "active", "user_fixture", "sess_fixture", time.Now().Add(-time.Minute).UnixMilli(), false, false},
		{"missing", "404", "user_fixture", "sess_fixture", 0, false, false},
		{"upstream_503", "error", "user_fixture", "sess_fixture", 0, false, true},
		{"broken_payload", "malformed", "user_fixture", "sess_fixture", 0, false, true},
	} {
		t.Run(tc.name, func(t *testing.T) {
			state = tc.st
			user = tc.who
			id = tc.sid
			expire = tc.expire
			got, err := checker.Active(context.Background(), "user_fixture", "sess_fixture")
			if got != tc.good || (err != nil) != tc.errorExpected {
				t.Errorf("expected %t err=%t, got %t %v", tc.good, tc.errorExpected, got, err)
			}
		})
	}
	if calls != 9 {
		t.Fatalf("provider must be consulted on every request, got %d", calls)
	}
}
func TestSessionStatusRejectsInvalidIDAndCancellation(t *testing.T) {
	checker := &ClerkSessionStatus{endpoint: clerkSessionAPI, authorization: "Bearer fixture", client: &http.Client{Timeout: time.Second}}
	for _, id := range []string{"sess_bad input", "sess_%2f", "sess_?x=1"} {
		ok, err := checker.Active(context.Background(), "user_fixture", id)
		if ok || !errors.Is(err, ErrUnauthorized) {
			t.Errorf("unsafe input was not denied: %q %v", id, err)
		}
	}
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	ok, err := checker.Active(ctx, "user_fixture", "sess_fixture")
	if ok || err == nil {
		t.Errorf("cancelled lookup must be denied")
	}
}
