package identity

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"strings"
	"time"
)

const clerkUsersAPI = "https://api.clerk.com/v1/users/"

// VerifiedUserProfile holds provider-verified identity attributes from Clerk.
// Only verified primary emails may be synchronized as active canonical users.
type VerifiedUserProfile struct {
	ClerkID         string
	Email           string
	DisplayName     string
	AvatarURL       string
	SourceUpdatedAt time.Time
}

// SyncedUser represents the canonical local users record after synchronous
// idempotent upsert during login or onboarding.
type SyncedUser struct {
	UserID      string
	ClerkID     string
	Email       string
	DisplayName string
	Status      string
}

// VerifiedUserReader fetches authoritative, verified user identity from Clerk.
type VerifiedUserReader interface {
	FetchVerifiedUser(ctx context.Context, clerkUserID string) (VerifiedUserProfile, error)
}

// VerifiedUserUpserter synchronously idempotent-upserts a verified user into
// the canonical local users table.
type VerifiedUserUpserter interface {
	UpsertVerifiedUser(ctx context.Context, profile VerifiedUserProfile) (SyncedUser, error)
}

// ClerkUserDirectory queries Clerk's Backend API GET /v1/users/{user_id} to
// verify account status and primary email verification before synchronous upsert.
type ClerkUserDirectory struct {
	endpoint      string
	authorization string
	client        *http.Client
}

// NewClerkUserDirectory validates the runtime Clerk secret key and configures
// a redirect-refusing HTTP client.
func NewClerkUserDirectory(secret string) (*ClerkUserDirectory, error) {
	if len(secret) < 12 || !strings.HasPrefix(secret, "sk_") || strings.ContainsAny(secret, " \t\r\n") {
		return nil, ErrNotConfigured
	}
	return &ClerkUserDirectory{
		endpoint:      clerkUsersAPI,
		authorization: "Bearer " + secret,
		client: &http.Client{
			Timeout: 4 * time.Second,
			CheckRedirect: func(*http.Request, []*http.Request) error {
				return errors.New("user lookup redirect forbidden")
			},
		},
	}, nil
}

// FetchVerifiedUser retrieves and validates an active Clerk user with a
// verified primary email address.
func (d *ClerkUserDirectory) FetchVerifiedUser(ctx context.Context, clerkUserID string) (VerifiedUserProfile, error) {
	if d == nil || d.client == nil || d.authorization == "" || ctx == nil {
		return VerifiedUserProfile{}, ErrNotConfigured
	}
	if err := ctx.Err(); err != nil {
		return VerifiedUserProfile{}, err
	}
	if !isSafeClerkTokenID(clerkUserID, "user_") {
		return VerifiedUserProfile{}, ErrUnauthorized
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, d.endpoint+clerkUserID, nil)
	if err != nil {
		return VerifiedUserProfile{}, ErrUnauthorized
	}
	req.Header.Set("Authorization", d.authorization)
	req.Header.Set("Accept", "application/json")

	resp, err := d.client.Do(req)
	if err != nil {
		return VerifiedUserProfile{}, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return VerifiedUserProfile{}, ErrUnauthorized
	}

	b, err := io.ReadAll(io.LimitReader(resp.Body, 32_769))
	if err != nil {
		return VerifiedUserProfile{}, err
	}
	if len(b) > 32_768 {
		return VerifiedUserProfile{}, ErrUnauthorized
	}

	var raw struct {
		ID                    string `json:"id"`
		PrimaryEmailAddressID string `json:"primary_email_address_id"`
		EmailAddresses        []struct {
			ID           string `json:"id"`
			EmailAddress string `json:"email_address"`
			Verification *struct {
				Status string `json:"status"`
			} `json:"verification"`
		} `json:"email_addresses"`
		FirstName string `json:"first_name"`
		LastName  string `json:"last_name"`
		Username  string `json:"username"`
		ImageURL  string `json:"image_url"`
		Banned    bool   `json:"banned"`
		Locked    bool   `json:"locked"`
		Deleted   bool   `json:"deleted"`
		UpdatedAt int64  `json:"updated_at"`
		CreatedAt int64  `json:"created_at"`
	}
	if err := json.Unmarshal(b, &raw); err != nil {
		return VerifiedUserProfile{}, ErrUnauthorized
	}
	if raw.ID != clerkUserID || raw.Banned || raw.Locked || raw.Deleted {
		return VerifiedUserProfile{}, ErrUnauthorized
	}
	if raw.PrimaryEmailAddressID == "" || len(raw.EmailAddresses) == 0 {
		return VerifiedUserProfile{}, ErrUnauthorized
	}

	var primaryEmail string
	var verified bool
	for _, entry := range raw.EmailAddresses {
		if entry.ID == raw.PrimaryEmailAddressID {
			primaryEmail = strings.TrimSpace(entry.EmailAddress)
			if entry.Verification != nil && entry.Verification.Status == "verified" {
				verified = true
			}
			break
		}
	}
	if !verified || !isSafeEmail(primaryEmail) {
		return VerifiedUserProfile{}, ErrUnauthorized
	}

	tsMS := raw.UpdatedAt
	if tsMS <= 0 {
		tsMS = raw.CreatedAt
	}
	if tsMS <= 0 {
		return VerifiedUserProfile{}, ErrUnauthorized
	}

	displayName := strings.TrimSpace(strings.TrimSpace(raw.FirstName) + " " + strings.TrimSpace(raw.LastName))
	if displayName == "" {
		displayName = strings.TrimSpace(raw.Username)
	}
	if len(displayName) > 255 {
		displayName = displayName[:255]
	}

	avatarURL := strings.TrimSpace(raw.ImageURL)
	if len(avatarURL) > 2048 {
		return VerifiedUserProfile{}, ErrUnauthorized
	}

	return VerifiedUserProfile{
		ClerkID:         raw.ID,
		Email:           primaryEmail,
		DisplayName:     displayName,
		AvatarURL:       avatarURL,
		SourceUpdatedAt: time.UnixMilli(tsMS).UTC(),
	}, nil
}

// SQLUserUpserter performs synchronous idempotent upserts into canonical users
// (docs/04_contracts/database_schema.md §4.2).
type SQLUserUpserter struct {
	Queries SQLQueryer
}

const syncUpsertUserQuery = `
INSERT INTO users (
  clerk_id,
  source_updated_at,
  email,
  display_name,
  avatar_url,
  status,
  last_login_at,
  updated_at
) VALUES (
  $1,
  $2,
  $3,
  NULLIF($4, ''),
  NULLIF($5, ''),
  'active',
  NOW(),
  NOW()
)
ON CONFLICT (clerk_id) DO UPDATE SET
  email = CASE
    WHEN users.source_updated_at IS NULL OR users.source_updated_at <= EXCLUDED.source_updated_at
    THEN EXCLUDED.email
    ELSE users.email
  END,
  display_name = CASE
    WHEN users.source_updated_at IS NULL OR users.source_updated_at <= EXCLUDED.source_updated_at
    THEN COALESCE(EXCLUDED.display_name, users.display_name)
    ELSE users.display_name
  END,
  avatar_url = CASE
    WHEN users.source_updated_at IS NULL OR users.source_updated_at <= EXCLUDED.source_updated_at
    THEN COALESCE(EXCLUDED.avatar_url, users.avatar_url)
    ELSE users.avatar_url
  END,
  source_updated_at = CASE
    WHEN users.source_updated_at IS NULL OR users.source_updated_at <= EXCLUDED.source_updated_at
    THEN EXCLUDED.source_updated_at
    ELSE users.source_updated_at
  END,
  last_login_at = NOW(),
  updated_at = NOW()
WHERE users.status = 'active'
RETURNING user_id::text, clerk_id, email, COALESCE(display_name, ''), status`

// UpsertVerifiedUser synchronously idempotent-upserts a verified user and
// enforces source_updated_at ordering so delayed webhooks cannot regress state.
func (u SQLUserUpserter) UpsertVerifiedUser(ctx context.Context, profile VerifiedUserProfile) (SyncedUser, error) {
	if u.Queries == nil {
		return SyncedUser{}, ErrNotConfigured
	}
	if ctx == nil {
		return SyncedUser{}, ErrUnauthorized
	}
	if err := ctx.Err(); err != nil {
		return SyncedUser{}, err
	}
	if !isSafeClerkTokenID(profile.ClerkID, "user_") ||
		!isSafeEmail(profile.Email) ||
		profile.SourceUpdatedAt.IsZero() {
		return SyncedUser{}, ErrUnauthorized
	}

	var out SyncedUser
	err := u.Queries.QueryRowContext(
		ctx,
		syncUpsertUserQuery,
		profile.ClerkID,
		profile.SourceUpdatedAt,
		profile.Email,
		profile.DisplayName,
		profile.AvatarURL,
	).Scan(&out.UserID, &out.ClerkID, &out.Email, &out.DisplayName, &out.Status)
	if errors.Is(err, sql.ErrNoRows) {
		// Suspended or deleted local user must never be reactivated on login.
		return SyncedUser{}, ErrUnauthorized
	}
	if err != nil {
		return SyncedUser{}, err
	}
	if !workspaceIDPattern.MatchString(out.UserID) || out.UserID == zeroUUID || out.Status != "active" {
		return SyncedUser{}, ErrUnauthorized
	}
	return out, nil
}

// SyncVerifiedUser verifies the session JWT and active Clerk session, fetches
// the verified user profile, and synchronously upserts the local canonical user
// so login/onboarding never waits on delayed user.created webhook delivery.
func (r Resolver) SyncVerifiedUser(
	ctx context.Context,
	token string,
	users VerifiedUserReader,
	upserter VerifiedUserUpserter,
) (SyncedUser, error) {
	if ctx == nil {
		return SyncedUser{}, ErrUnauthorized
	}
	if err := ctx.Err(); err != nil {
		return SyncedUser{}, err
	}
	if r.Tokens == nil || r.Sessions == nil || users == nil || upserter == nil {
		return SyncedUser{}, ErrNotConfigured
	}
	if token == "" || strings.TrimSpace(token) != token {
		return SyncedUser{}, ErrUnauthorized
	}

	verified, err := r.Tokens.VerifyToken(ctx, token)
	if ctxErr := ctx.Err(); ctxErr != nil {
		return SyncedUser{}, ctxErr
	}
	if err != nil || verified.Subject == "" || verified.SessionID == "" {
		return SyncedUser{}, ErrUnauthorized
	}

	active, err := r.Sessions.Active(ctx, verified.Subject, verified.SessionID)
	if ctxErr := ctx.Err(); ctxErr != nil {
		return SyncedUser{}, ctxErr
	}
	if err != nil || !active {
		return SyncedUser{}, ErrUnauthorized
	}

	profile, err := users.FetchVerifiedUser(ctx, verified.Subject)
	if ctxErr := ctx.Err(); ctxErr != nil {
		return SyncedUser{}, ctxErr
	}
	if err != nil || profile.ClerkID != verified.Subject {
		return SyncedUser{}, ErrUnauthorized
	}

	synced, err := upserter.UpsertVerifiedUser(ctx, profile)
	if ctxErr := ctx.Err(); ctxErr != nil {
		return SyncedUser{}, ctxErr
	}
	if err != nil {
		return SyncedUser{}, err
	}
	return synced, nil
}

func isSafeClerkTokenID(id, prefix string) bool {
	if !strings.HasPrefix(id, prefix) || len(id) <= len(prefix) || len(id) > 255 {
		return false
	}
	for _, r := range id {
		if (r < 'a' || r > 'z') && (r < 'A' || r > 'Z') && (r < '0' || r > '9') && r != '_' && r != '-' {
			return false
		}
	}
	return true
}

func isSafeEmail(email string) bool {
	if len(email) < 3 || len(email) > 255 || strings.ContainsAny(email, " \t\r\n") {
		return false
	}
	at := strings.IndexByte(email, '@')
	return at > 0 && at < len(email)-1 && !strings.Contains(email[at+1:], "@")
}
