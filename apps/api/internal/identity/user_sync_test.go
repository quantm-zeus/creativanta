package identity

import (
	"context"
	"database/sql"
	"errors"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
	"time"

	_ "github.com/jackc/pgx/v5/stdlib"
)

func TestClerkUserDirectoryRejectsUnverifiedBannedOrMalformedProfiles(t *testing.T) {
	if _, err := NewClerkUserDirectory("bad_secret"); !errors.Is(err, ErrNotConfigured) {
		t.Fatalf("expected ErrNotConfigured for invalid secret, got %v", err)
	}

	cases := []struct {
		name       string
		statusCode int
		body       string
		wantOK     bool
	}{
		{
			name:       "verified_active_user",
			statusCode: http.StatusOK,
			body:       `{"id":"user_verified1","primary_email_address_id":"idn_1","email_addresses":[{"id":"idn_1","email_address":"linh@example.com","verification":{"status":"verified"}}],"first_name":"Linh","last_name":"Tran","updated_at":1793548800000}`,
			wantOK:     true,
		},
		{
			name:       "unverified_primary_email",
			statusCode: http.StatusOK,
			body:       `{"id":"user_verified1","primary_email_address_id":"idn_1","email_addresses":[{"id":"idn_1","email_address":"linh@example.com","verification":{"status":"unverified"}}],"updated_at":1793548800000}`,
			wantOK:     false,
		},
		{
			name:       "banned_user",
			statusCode: http.StatusOK,
			body:       `{"id":"user_verified1","banned":true,"primary_email_address_id":"idn_1","email_addresses":[{"id":"idn_1","email_address":"linh@example.com","verification":{"status":"verified"}}],"updated_at":1793548800000}`,
			wantOK:     false,
		},
		{
			name:       "mismatched_user_id",
			statusCode: http.StatusOK,
			body:       `{"id":"user_other999","primary_email_address_id":"idn_1","email_addresses":[{"id":"idn_1","email_address":"linh@example.com","verification":{"status":"verified"}}],"updated_at":1793548800000}`,
			wantOK:     false,
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				if r.Header.Get("Authorization") != "Bearer sk_test_valid_secret_key" {
					w.WriteHeader(http.StatusUnauthorized)
					return
				}
				w.Header().Set("Content-Type", "application/json")
				w.WriteHeader(tc.statusCode)
				_, _ = w.Write([]byte(tc.body))
			}))
			defer srv.Close()

			dir, err := NewClerkUserDirectory("sk_test_valid_secret_key")
			if err != nil {
				t.Fatal(err)
			}
			dir.endpoint = srv.URL + "/v1/users/"

			prof, err := dir.FetchVerifiedUser(context.Background(), "user_verified1")
			if tc.wantOK {
				if err != nil || prof.Email != "linh@example.com" || prof.DisplayName != "Linh Tran" {
					t.Fatalf("expected valid profile, got prof=%+v err=%v", prof, err)
				}
			} else if err == nil {
				t.Fatalf("expected error for %s, got prof=%+v", tc.name, prof)
			}
		})
	}
}

type stubUserReader struct {
	profile VerifiedUserProfile
	err     error
	calls   int
}

func (s *stubUserReader) FetchVerifiedUser(_ context.Context, clerkUserID string) (VerifiedUserProfile, error) {
	s.calls++
	if s.err != nil {
		return VerifiedUserProfile{}, s.err
	}
	if clerkUserID != s.profile.ClerkID {
		return VerifiedUserProfile{}, ErrUnauthorized
	}
	return s.profile, nil
}

type stubUserUpserter struct {
	synced SyncedUser
	err    error
	calls  int
}

func (s *stubUserUpserter) UpsertVerifiedUser(_ context.Context, p VerifiedUserProfile) (SyncedUser, error) {
	s.calls++
	if s.err != nil {
		return SyncedUser{}, s.err
	}
	return SyncedUser{
		UserID:      s.synced.UserID,
		ClerkID:     p.ClerkID,
		Email:       p.Email,
		DisplayName: p.DisplayName,
		Status:      "active",
	}, nil
}

func TestSyncVerifiedUserRequiresTokenSessionAndVerifiedProfile(t *testing.T) {
	tokenCalls := 0
	sessions := &fixedStatus{active: true}
	reader := &stubUserReader{
		profile: VerifiedUserProfile{
			ClerkID:         "user_verified",
			Email:           "verified@example.com",
			DisplayName:     "Verified User",
			SourceUpdatedAt: time.Date(2026, 11, 1, 16, 0, 0, 0, time.UTC),
		},
	}
	upserter := &stubUserUpserter{
		synced: SyncedUser{UserID: testUserUUID},
	}

	r := Resolver{
		Tokens:   tokenStub{identity: Identity{Subject: "user_verified", SessionID: "sess_verified"}, calls: &tokenCalls},
		Sessions: sessions,
	}

	synced, err := r.SyncVerifiedUser(context.Background(), "valid_jwt", reader, upserter)
	if err != nil || synced.UserID != testUserUUID || synced.Email != "verified@example.com" {
		t.Fatalf("SyncVerifiedUser failed: synced=%+v err=%v", synced, err)
	}
	if tokenCalls != 1 || sessions.calls != 1 || reader.calls != 1 || upserter.calls != 1 {
		t.Fatalf("unexpected call counts: tokens=%d sessions=%d reader=%d upserter=%d", tokenCalls, sessions.calls, reader.calls, upserter.calls)
	}

	// Revoked session must never reach user reader or SQL upserter.
	sessions.active = false
	if _, err := r.SyncVerifiedUser(context.Background(), "valid_jwt", reader, upserter); !errors.Is(err, ErrUnauthorized) {
		t.Fatalf("expected ErrUnauthorized for revoked session, got %v", err)
	}
	if reader.calls != 1 || upserter.calls != 1 {
		t.Fatal("revoked session proceeded to user fetch or upsert")
	}

	// Nil dependency fails closed with ErrNotConfigured.
	if _, err := r.SyncVerifiedUser(context.Background(), "valid_jwt", nil, upserter); !errors.Is(err, ErrNotConfigured) {
		t.Fatalf("expected ErrNotConfigured on nil user reader, got %v", err)
	}
}

func TestPostgresSynchronousUserUpsertSurvivesDelayedWebhook(t *testing.T) {
	dsn := os.Getenv("CREATIVANTA_TEST_POSTGRES_DSN")
	if dsn == "" {
		t.Skip("set CREATIVANTA_TEST_POSTGRES_DSN to run real PostgreSQL user sync test")
	}

	db, err := sql.Open("pgx", dsn)
	if err != nil {
		t.Fatal(err)
	}
	defer db.Close()

	ctx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()

	tx, err := db.BeginTx(ctx, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer tx.Rollback()

	if _, err := tx.ExecContext(ctx, `
		CREATE TEMP TABLE users (
			user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
			clerk_id VARCHAR(255) UNIQUE NOT NULL,
			source_updated_at TIMESTAMPTZ,
			email VARCHAR(255) NOT NULL,
			display_name VARCHAR(255),
			avatar_url TEXT,
			status VARCHAR(20) NOT NULL DEFAULT 'active',
			last_login_at TIMESTAMPTZ,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		) ON COMMIT DROP`); err != nil {
		t.Fatal(err)
	}

	upserter := SQLUserUpserter{Queries: tx}
	tOnboarding := time.Date(2026, 11, 1, 16, 5, 0, 0, time.UTC)

	// 1. Synchronous login/onboarding upserts user before user.created webhook arrives.
	first, err := upserter.UpsertVerifiedUser(ctx, VerifiedUserProfile{
		ClerkID:         "user_onboard1",
		Email:           "current@example.com",
		DisplayName:     "Current Name",
		SourceUpdatedAt: tOnboarding,
	})
	if err != nil || first.UserID == "" || first.Email != "current@example.com" {
		t.Fatalf("first synchronous upsert failed: %+v %v", first, err)
	}

	// 2. Delayed user.created webhook arrives with an older source_updated_at:
	// must return the same canonical user_id without overwriting newer email/name.
	second, err := upserter.UpsertVerifiedUser(ctx, VerifiedUserProfile{
		ClerkID:         "user_onboard1",
		Email:           "stale-initial@example.com",
		DisplayName:     "Stale Name",
		SourceUpdatedAt: tOnboarding.Add(-2 * time.Minute),
	})
	if err != nil || second.UserID != first.UserID || second.Email != "current@example.com" || second.DisplayName != "Current Name" {
		t.Fatalf("delayed older upsert regressed user state: got %+v err=%v", second, err)
	}

	// 3. Suspended user cannot be reactivated by login upsert.
	if _, err := tx.ExecContext(ctx, `UPDATE users SET status = 'suspended' WHERE clerk_id = 'user_onboard1'`); err != nil {
		t.Fatal(err)
	}
	if _, err := upserter.UpsertVerifiedUser(ctx, VerifiedUserProfile{
		ClerkID:         "user_onboard1",
		Email:           "current@example.com",
		DisplayName:     "Current Name",
		SourceUpdatedAt: tOnboarding.Add(time.Minute),
	}); !errors.Is(err, ErrUnauthorized) {
		t.Fatalf("expected ErrUnauthorized for suspended user, got %v", err)
	}
}
