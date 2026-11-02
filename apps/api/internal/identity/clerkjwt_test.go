package identity

import (
	"context"
	"crypto/rand"
	"crypto/rsa"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"math/big"
	"net/http"
	"net/http/httptest"
	"sync/atomic"
	"testing"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

const allowedOrigin = "https://creator.example.test"
const audience = "creativanta-api"

type clerkTestFixture struct {
	private *rsa.PrivateKey
	kid     string
	clock   *atomic.Int64
	now     time.Time
	server  *httptest.Server
	status  atomic.Int64
	hits    atomic.Int64
	delayMs atomic.Int64
}

func newClerkTestFixture(t *testing.T) *clerkTestFixture {
	t.Helper()
	key, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		t.Fatal(err)
	}
	now := time.Now().UTC().Truncate(time.Second)
	f := &clerkTestFixture{private: key, kid: "test-kid-1", clock: &atomic.Int64{}, now: now}
	f.clock.Store(now.Unix())
	f.status.Store(200)
	f.server = httptest.NewTLSServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		f.hits.Add(1)
		if delay := f.delayMs.Load(); delay > 0 {
			time.Sleep(time.Duration(delay) * time.Millisecond)
		}
		if r.URL.Path != "/.well-known/jwks.json" {
			http.NotFound(w, r)
			return
		}
		if f.status.Load() != 200 {
			http.Error(w, "temporarily unavailable", 503)
			return
		}
		n := base64.RawURLEncoding.EncodeToString(f.private.PublicKey.N.Bytes())
		e := base64.RawURLEncoding.EncodeToString(big.NewInt(int64(f.private.PublicKey.E)).Bytes())
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]any{"keys": []any{map[string]string{"kid": f.kid, "kty": "RSA", "use": "sig", "alg": "RS256", "n": n, "e": e}}})
	}))
	t.Cleanup(f.server.Close)
	return f
}
func (f *clerkTestFixture) config() JWTConfig {
	return JWTConfig{Issuer: f.server.URL, Audience: audience, AuthorizedParties: []string{allowedOrigin}, HTTPClient: f.server.Client(), CacheTTL: time.Second, Clock: func() time.Time { return time.Unix(f.clock.Load(), 0) }}
}
func (f *clerkTestFixture) claims() jwt.MapClaims {
	now := f.clock.Load()
	return jwt.MapClaims{"iss": f.server.URL, "aud": audience, "azp": allowedOrigin, "sub": "user_verified_example", "sid": "sess_active_example", "iat": now - 10, "nbf": now - 5, "exp": now + 60}
}
func (f *clerkTestFixture) signed(t *testing.T, c jwt.MapClaims) string {
	t.Helper()
	token := jwt.NewWithClaims(jwt.SigningMethodRS256, c)
	token.Header["kid"] = f.kid
	s, err := token.SignedString(f.private)
	if err != nil {
		t.Fatal(err)
	}
	return s
}
func TestClerkJWTVerifiedClaimsAndCache(t *testing.T) {
	f := newClerkTestFixture(t)
	v, err := NewSessionTokenVerifier(f.config())
	if err != nil {
		t.Fatal(err)
	}
	token := f.signed(t, f.claims())
	for i := 0; i < 3; i++ {
		identity, err := v.VerifyToken(context.Background(), token)
		if err != nil || identity.Subject != "user_verified_example" || identity.SessionID != "sess_active_example" {
			t.Fatalf("verify: %#v %v", identity, err)
		}
	}
	if f.hits.Load() != 1 {
		t.Errorf("expected one JWKS fetch, got %d", f.hits.Load())
	}
}

func TestClerkJWTRejectsUntrustedClaims(t *testing.T) {
	f := newClerkTestFixture(t)
	v, err := NewSessionTokenVerifier(f.config())
	if err != nil {
		t.Fatal(err)
	}
	for name, change := range map[string]func(jwt.MapClaims){
		"wrong_issuer":       func(c jwt.MapClaims) { c["iss"] = "https://attacker.invalid" },
		"wrong_audience":     func(c jwt.MapClaims) { c["aud"] = "different-api" },
		"missing_audience":   func(c jwt.MapClaims) { delete(c, "aud") },
		"wrong_azp":          func(c jwt.MapClaims) { c["azp"] = "https://attacker.invalid" },
		"missing_azp":        func(c jwt.MapClaims) { delete(c, "azp") },
		"missing_subject":    func(c jwt.MapClaims) { delete(c, "sub") },
		"missing_session":    func(c jwt.MapClaims) { delete(c, "sid") },
		"missing_expiry":     func(c jwt.MapClaims) { delete(c, "exp") },
		"missing_issued_at":  func(c jwt.MapClaims) { delete(c, "iat") },
		"missing_not_before": func(c jwt.MapClaims) { delete(c, "nbf") },
		"expired":            func(c jwt.MapClaims) { c["exp"] = f.clock.Load() - 50 },
		"not_yet_valid":      func(c jwt.MapClaims) { c["nbf"] = f.clock.Load() + 40 },
		"issued_in_future":   func(c jwt.MapClaims) { c["iat"] = f.clock.Load() + 40 },
		"bad_subject":        func(c jwt.MapClaims) { c["sub"] = "not_clerk_user" },
		"bad_session":        func(c jwt.MapClaims) { c["sid"] = "not_clerk_session" },
	} {
		t.Run(name, func(t *testing.T) {
			c := f.claims()
			change(c)
			_, err := v.VerifyToken(context.Background(), f.signed(t, c))
			if !errors.Is(err, ErrInvalidToken) {
				t.Errorf("expected denial for %s, got %v", name, err)
			}
		})
	}
}

func TestClerkJWTWrongSignatureNeverAccepted(t *testing.T) {
	f := newClerkTestFixture(t)
	v, _ := NewSessionTokenVerifier(f.config())
	other, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		t.Fatal(err)
	}
	forged := jwt.NewWithClaims(jwt.SigningMethodRS256, f.claims())
	forged.Header["kid"] = f.kid
	raw, err := forged.SignedString(other)
	if err != nil {
		t.Fatal(err)
	}
	_, err = v.VerifyToken(context.Background(), raw)
	if !errors.Is(err, ErrInvalidToken) {
		t.Fatalf("wrong signature accepted: %v", err)
	}
}

func TestClerkJWTRotationAndStaleRejection(t *testing.T) {
	f := newClerkTestFixture(t)
	v, _ := NewSessionTokenVerifier(f.config())
	a := f.signed(t, f.claims())
	if _, err := v.VerifyToken(context.Background(), a); err != nil {
		t.Fatal(err)
	}
	rotated, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		t.Fatal(err)
	}
	f.private = rotated
	f.kid = "test-kid-2"
	b := f.signed(t, f.claims())
	f.clock.Add(2)
	if _, err := v.VerifyToken(context.Background(), b); err != nil {
		t.Fatalf("rotation should refresh: %v", err)
	}
	if _, err := v.VerifyToken(context.Background(), a); !errors.Is(err, ErrInvalidToken) {
		t.Fatalf("old key remained trusted: %v", err)
	}
	f.status.Store(503)
	f.clock.Add(2)
	if _, err := v.VerifyToken(context.Background(), b); !errors.Is(err, ErrInvalidToken) {
		t.Fatalf("stale JWKS accepted after refresh failure: %v", err)
	}
}
func TestClerkJWTRejectsMalformedConfigsAndTokens(t *testing.T) {
	for name, cfg := range map[string]JWTConfig{
		"http_issuer":          {Issuer: "http://invalid.test", Audience: audience, AuthorizedParties: []string{allowedOrigin}},
		"missing_audience":     {Issuer: "https://clerk.example.test", AuthorizedParties: []string{allowedOrigin}},
		"missing_origins":      {Issuer: "https://clerk.example.test", Audience: audience},
		"ssrf_userinfo":        {Issuer: "https://attacker@clerk.example.test", Audience: audience, AuthorizedParties: []string{allowedOrigin}},
		"arbitrary_path":       {Issuer: "https://clerk.example.test/internal", Audience: audience, AuthorizedParties: []string{allowedOrigin}},
		"origin_http_insecure": {Issuer: "https://clerk.example.test", Audience: audience, AuthorizedParties: []string{"http://attacker.test"}},
	} {
		t.Run(name, func(t *testing.T) {
			if _, err := NewSessionTokenVerifier(cfg); !errors.Is(err, ErrInvalidJWTConfig) {
				t.Fatalf("accepted invalid config %v", err)
			}
		})
	}
	f := newClerkTestFixture(t)
	v, _ := NewSessionTokenVerifier(f.config())
	for _, raw := range []string{"abc", "a.b.c", fmt.Sprintf("%s.%s.%s", "x", "y", "z")} {
		if _, err := v.VerifyToken(context.Background(), raw); !errors.Is(err, ErrInvalidToken) {
			t.Fatalf("accepted malformed JWT: %v", err)
		}
	}
	ctx, cancel := context.WithCancel(context.Background())
	cancel()
	if _, err := v.VerifyToken(ctx, f.signed(t, f.claims())); !errors.Is(err, ErrInvalidToken) {
		t.Fatalf("accepted canceled request: %v", err)
	}
}
