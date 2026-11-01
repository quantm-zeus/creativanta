package identity

import (
	"context"
	"errors"
	"github.com/golang-jwt/jwt/v5"
	"testing"
	"time"
)

func TestUnknownKIDRefreshDoesNotBlockKnownValidToken(t *testing.T) {
	f := newClerkTestFixture(t)
	cfg := f.config()
	cfg.CacheTTL = 10 * time.Minute
	verifier, err := NewSessionTokenVerifier(cfg)
	if err != nil {
		t.Fatal(err)
	}
	valid := f.signed(t, f.claims())
	if _, err := verifier.VerifyToken(context.Background(), valid); err != nil {
		t.Fatal(err)
	}
	f.clock.Add(2)
	f.delayMs.Store(500)
	unknown := jwt.NewWithClaims(jwt.SigningMethodRS256, f.claims())
	unknown.Header["kid"] = "untrusted-unknown-kid"
	bogus, err := unknown.SignedString(f.private)
	if err != nil {
		t.Fatal(err)
	}
	done := make(chan error, 1)
	go func() { _, err := verifier.VerifyToken(context.Background(), bogus); done <- err }()
	deadline := time.After(2 * time.Second)
	for f.hits.Load() < 2 {
		select {
		case <-deadline:
			t.Fatal("unknown kid did not trigger test fetch")
		default:
			time.Sleep(time.Millisecond)
		}
	}
	start := time.Now()
	who, err := verifier.VerifyToken(context.Background(), valid)
	elapsed := time.Since(start)
	if err != nil || who.Subject == "" {
		t.Fatalf("cached valid key denied: %v", err)
	}
	if elapsed > 200*time.Millisecond {
		t.Fatalf("unknown-kid network blocked hot cache for %v", elapsed)
	}
	select {
	case err := <-done:
		if !errors.Is(err, ErrInvalidToken) {
			t.Fatalf("unknown kid accepted: %v", err)
		}
	case <-time.After(3 * time.Second):
		t.Fatal("unknown kid lookup stuck")
	}
}

func TestExpiredJWKSOutageIsRateLimited(t *testing.T) {
	f := newClerkTestFixture(t)
	v, err := NewSessionTokenVerifier(f.config())
	if err != nil {
		t.Fatal(err)
	}
	token := f.signed(t, f.claims())
	if _, err := v.VerifyToken(context.Background(), token); err != nil {
		t.Fatal(err)
	}
	f.status.Store(503)
	f.clock.Add(3)
	for i := 0; i < 5; i++ {
		if _, err := v.VerifyToken(context.Background(), token); !errors.Is(err, ErrInvalidToken) {
			t.Fatalf("stale key accepted at %d: %v", i, err)
		}
	}
	if f.hits.Load() != 2 {
		t.Fatalf("outage stampede: expected 1 fresh attempt, got %d fetches", f.hits.Load())
	}
}
