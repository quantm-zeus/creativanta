// Package identity verifies Clerk's RS256 session JWTs and independently
// resolves current account/session/workspace state. No provider token is trusted
// as an app user UUID or a statement of workspace membership.
package identity

import (
	"context"
	"crypto/rsa"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"math/big"
	"net/http"
	"net/url"
	"strings"
	"sync"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

var ErrInvalidToken = errors.New("identity: invalid session token")
var ErrInvalidJWTConfig = errors.New("identity: invalid JWT verifier configuration")

// JWTConfig requires a single pinned Clerk instance (no arbitrary caller URL).
// The issuer endpoint is also the HTTPS JWKS origin, not derived from JWT claims.
type JWTConfig struct {
	Issuer            string
	Audience          string
	AuthorizedParties []string
	HTTPClient        *http.Client
	CacheTTL          time.Duration
	Clock             func() time.Time
}

type SessionTokenVerifier struct {
	cfg         JWTConfig
	client      *http.Client
	now         func() time.Time
	jwksURL     string
	ttl         time.Duration
	mu          sync.RWMutex
	fetchMu     sync.Mutex
	keys        map[string]*rsa.PublicKey
	expires     time.Time
	lastRefresh time.Time
}

type clerkClaims struct {
	jwt.RegisteredClaims
	AuthorizedParty string `json:"azp"`
	SessionID       string `json:"sid"`
}

// NewSessionTokenVerifier requires the issuer/audience/origin allowlists,
// rejects HTTP or redirect-based JWKS, and does not embed Clerk secret keys.
func NewSessionTokenVerifier(cfg JWTConfig) (*SessionTokenVerifier, error) {
	u, err := url.Parse(cfg.Issuer)
	if err != nil || u.Scheme != "https" || u.Host == "" || u.User != nil || (u.Path != "" && u.Path != "/") || u.RawQuery != "" || u.Fragment != "" {
		return nil, ErrInvalidJWTConfig
	}
	if cfg.Audience == "" || len(cfg.AuthorizedParties) == 0 {
		return nil, ErrInvalidJWTConfig
	}
	parties := make(map[string]struct{}, len(cfg.AuthorizedParties))
	for _, part := range cfg.AuthorizedParties {
		p, err := url.Parse(part)
		if err != nil || (p.Scheme != "https" && p.Scheme != "http") || p.Host == "" || p.User != nil || p.RawQuery != "" || p.Fragment != "" || (p.Path != "" && p.Path != "/") {
			return nil, ErrInvalidJWTConfig
		}
		if p.Scheme == "http" && p.Hostname() != "localhost" && p.Hostname() != "127.0.0.1" && p.Hostname() != "::1" {
			return nil, ErrInvalidJWTConfig
		}
		if _, duplicate := parties[part]; duplicate {
			return nil, ErrInvalidJWTConfig
		}
		parties[part] = struct{}{}
	}
	cfg.AuthorizedParties = append([]string(nil), cfg.AuthorizedParties...)
	if cfg.Clock == nil {
		cfg.Clock = time.Now
	}
	ttl := cfg.CacheTTL
	if ttl == 0 {
		ttl = 10 * time.Minute
	}
	if ttl < time.Second || ttl > time.Hour {
		return nil, ErrInvalidJWTConfig
	}
	client := cfg.HTTPClient
	if client == nil {
		client = &http.Client{}
	}
	clone := *client
	// Clerk JWKS must never be fetched from a redirect target.
	clone.CheckRedirect = func(*http.Request, []*http.Request) error { return errors.New("JWKS redirects forbidden") }
	if clone.Timeout <= 0 || clone.Timeout > 5*time.Second {
		clone.Timeout = 5 * time.Second
	}
	return &SessionTokenVerifier{cfg: cfg, client: &clone, now: cfg.Clock, jwksURL: strings.TrimSuffix(cfg.Issuer, "/") + "/.well-known/jwks.json", ttl: ttl, keys: map[string]*rsa.PublicKey{}}, nil
}

func (v *SessionTokenVerifier) VerifyToken(ctx context.Context, raw string) (Identity, error) {
	if ctx == nil || ctx.Err() != nil || len(raw) < 20 || len(raw) > 8192 || strings.Count(raw, ".") != 2 {
		return Identity{}, ErrInvalidToken
	}
	claims := &clerkClaims{}
	opts := []jwt.ParserOption{
		jwt.WithValidMethods([]string{jwt.SigningMethodRS256.Alg()}),
		jwt.WithIssuer(v.cfg.Issuer),
		jwt.WithAudience(v.cfg.Audience),
		jwt.WithExpirationRequired(),
		jwt.WithNotBeforeRequired(),
		jwt.WithIssuedAt(),
		jwt.WithLeeway(5 * time.Second),
		jwt.WithTimeFunc(v.now),
		jwt.WithStrictDecoding(),
	}
	token, err := jwt.ParseWithClaims(raw, claims, func(t *jwt.Token) (any, error) {
		if t.Method.Alg() != "RS256" {
			return nil, ErrInvalidToken
		}
		if typ, ok := t.Header["typ"].(string); ok && typ != "JWT" {
			return nil, ErrInvalidToken
		}
		kid, ok := t.Header["kid"].(string)
		if !ok || len(kid) < 1 || len(kid) > 150 {
			return nil, ErrInvalidToken
		}
		return v.keyFor(ctx, kid)
	}, opts...)
	if err != nil || !token.Valid || claims.IssuedAt == nil || claims.NotBefore == nil ||
		!strings.HasPrefix(claims.Subject, "user_") || len(claims.Subject) > 255 ||
		!strings.HasPrefix(claims.SessionID, "sess_") || len(claims.SessionID) > 255 {
		return Identity{}, ErrInvalidToken
	}
	partyOK := false
	for _, party := range v.cfg.AuthorizedParties {
		if party == claims.AuthorizedParty {
			partyOK = true
			break
		}
	}
	if !partyOK {
		return Identity{}, ErrInvalidToken
	}
	if claims.ExpiresAt == nil || !claims.ExpiresAt.After(claims.IssuedAt.Time) {
		return Identity{}, ErrInvalidToken
	}
	if ctx.Err() != nil {
		return Identity{}, ErrInvalidToken
	}
	return Identity{Subject: claims.Subject, SessionID: claims.SessionID}, nil
}

// Hot cached keys use a read lock; JWKS fetch uses a separate nonblocking
// single-flight mutex and never blocks the valid-key fast path.
func (v *SessionTokenVerifier) keyFor(ctx context.Context, kid string) (*rsa.PublicKey, error) {
	if ctx.Err() != nil {
		return nil, ErrInvalidToken
	}
	now := v.now()
	v.mu.RLock()
	key := v.keys[kid]
	expires, last := v.expires, v.lastRefresh
	v.mu.RUnlock()
	if key != nil && now.Before(expires) {
		return key, nil
	}
	if now.Sub(last) < time.Second {
		return nil, ErrInvalidToken
	}
	if !v.fetchMu.TryLock() {
		return nil, ErrInvalidToken
	}
	defer v.fetchMu.Unlock()
	now = v.now()
	v.mu.RLock()
	key = v.keys[kid]
	expires, last = v.expires, v.lastRefresh
	v.mu.RUnlock()
	if key != nil && now.Before(expires) {
		return key, nil
	}
	if now.Sub(last) < time.Second {
		return nil, ErrInvalidToken
	}
	// One hostile disconnect cannot cancel the shared bounded refresh.
	detached, cancel := context.WithTimeout(context.WithoutCancel(ctx), 4*time.Second)
	defer cancel()
	keys, err := v.fetchKeys(detached)
	v.mu.Lock()
	v.lastRefresh = v.now()
	if err == nil {
		v.keys = keys
		v.expires = v.lastRefresh.Add(v.ttl)
	}
	v.mu.Unlock()
	if err != nil {
		return nil, ErrInvalidToken
	}
	if key = keys[kid]; key != nil {
		return key, nil
	}
	return nil, ErrInvalidToken
}

type jwkDocument struct {
	Keys []struct {
		Kty string `json:"kty"`
		Kid string `json:"kid"`
		Alg string `json:"alg"`
		Use string `json:"use"`
		N   string `json:"n"`
		E   string `json:"e"`
	} `json:"keys"`
}

func (v *SessionTokenVerifier) fetchKeys(ctx context.Context) (map[string]*rsa.PublicKey, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, v.jwksURL, nil)
	if err != nil {
		return nil, err
	}
	resp, err := v.client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("JWKS request failed: %d", resp.StatusCode)
	}
	limited := io.LimitReader(resp.Body, 65_537)
	b, err := io.ReadAll(limited)
	if err != nil || len(b) > 65_536 {
		return nil, ErrInvalidToken
	}
	var doc jwkDocument
	if err = json.Unmarshal(b, &doc); err != nil || len(doc.Keys) == 0 || len(doc.Keys) > 24 {
		return nil, ErrInvalidToken
	}
	keys := make(map[string]*rsa.PublicKey, len(doc.Keys))
	for _, entry := range doc.Keys {
		if entry.Kty != "RSA" || entry.Kid == "" || entry.Alg != "RS256" || (entry.Use != "" && entry.Use != "sig") || len(entry.Kid) > 150 {
			return nil, ErrInvalidToken
		}
		if _, exists := keys[entry.Kid]; exists {
			return nil, ErrInvalidToken
		}
		n, err := base64.RawURLEncoding.DecodeString(entry.N)
		if err != nil || len(n) < 256 || len(n) > 1024 {
			return nil, ErrInvalidToken
		}
		exponent, err := base64.RawURLEncoding.DecodeString(entry.E)
		if err != nil || len(exponent) == 0 || len(exponent) > 4 {
			return nil, ErrInvalidToken
		}
		e := new(big.Int).SetBytes(exponent)
		if !e.IsInt64() || e.Int64() < 3 || e.Int64() > 65537 || e.Int64()%2 == 0 {
			return nil, ErrInvalidToken
		}
		key := &rsa.PublicKey{N: new(big.Int).SetBytes(n), E: int(e.Int64())}
		if key.N.BitLen() < 2048 || key.N.BitLen() > 8192 || key.N.Bit(0) == 0 {
			return nil, ErrInvalidToken
		}
		keys[entry.Kid] = key
	}
	return keys, nil
}
