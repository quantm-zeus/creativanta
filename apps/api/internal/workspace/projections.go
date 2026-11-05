// Package workspace implements P0-04 workspace lifecycle, member/role management,
// last-owner protection, synchronous member revocation, and private projection filtering.
//
// Canonical contracts:
//   - docs/02_features/platform/auth.md
//   - docs/02_features/platform/reporting_admin_billing.md
//   - docs/02_features/platform/internal_admin.md
//   - docs/04_contracts/database_schema.md (§3, §4, §16, §17, §18, §26, §27.2)
//   - docs/04_contracts/rbac_permission_matrix.md
package workspace

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

var (
	// ErrInternalNoteForbidden is returned when a support ticket message with is_internal_note=true
	// is passed to a tenant-facing projection builder.
	ErrInternalNoteForbidden = errors.New("workspace: internal support note cannot be projected to tenant response")
	// ErrDirectoryProfileNotPublished is returned when an unconsented, draft, or deleted media_kit
	// is passed to the public directory projection builder.
	ErrDirectoryProfileNotPublished = errors.New("workspace: media kit is not opted-in and published for public directory")
	// ErrForbiddenFieldSerialized is returned when structural response inspection detects a secret or private field.
	ErrForbiddenFieldSerialized = errors.New("workspace: forbidden secret or private field detected in serialized payload")
)

var forbiddenSerializedKeys = map[string]bool{
	"access_token_encrypted":  true,
	"refresh_token_encrypted": true,
	"access_token":            true,
	"refresh_token":           true,
	"key_hash":                true,
	"signing_secret_hash":     true,
	"signing_secret":          true,
	"password_hash":           true,
	"mfa_secret_encrypted":    true,
	"mfa_secret":              true,
	"session_token_hash":      true,
	"private_notes":           true,
	"internal_note":           true,
}

// WorkspaceProjection is the safe tenant response representation of a workspace.
// Credit fields are serialized strictly as canonical base-10 decimal strings (never float).
type WorkspaceProjection struct {
	WorkspaceID           string   `json:"workspace_id"`
	Name                  string   `json:"name"`
	DisplayName           string   `json:"display_name"`
	Slug                  string   `json:"slug"`
	OwnerUserID           string   `json:"owner_user_id"`
	SubscriptionTier      string   `json:"subscription_tier"`
	DefaultMode           string   `json:"default_mode"`
	DefaultOperatorMode   string   `json:"default_operator_mode"`
	EnabledModes          []string `json:"enabled_modes"`
	AICreditsRemaining    string   `json:"ai_credits_remaining"`
	AICreditsMonthlyLimit string   `json:"ai_credits_monthly_limit"`
	StorageUsedBytes      int64    `json:"storage_used_bytes"`
	StorageLimitBytes     int64    `json:"storage_limit_bytes"`
	Locale                string   `json:"locale"`
	Timezone              string   `json:"timezone"`
	Status                string   `json:"status"`
	CreatedAt             string   `json:"created_at"`
	UpdatedAt             string   `json:"updated_at"`
}

// ProjectWorkspace converts a canonical WorkspaceRow into a safe WorkspaceProjection.
func ProjectWorkspace(row tenantdb.WorkspaceRow) WorkspaceProjection {
	modes := make([]string, len(row.EnabledModes))
	copy(modes, row.EnabledModes)
	displayName := row.DisplayName
	if displayName == "" {
		displayName = row.Name
	}
	name := row.Name
	if name == "" {
		name = displayName
	}
	defaultOperatorMode := row.DefaultOperatorMode
	if defaultOperatorMode == "" {
		defaultOperatorMode = row.DefaultMode
	}
	defaultMode := row.DefaultMode
	if defaultMode == "" {
		defaultMode = defaultOperatorMode
	}
	return WorkspaceProjection{
		WorkspaceID:           row.WorkspaceID,
		Name:                  name,
		DisplayName:           displayName,
		Slug:                  row.Slug,
		OwnerUserID:           row.OwnerUserID,
		SubscriptionTier:      row.SubscriptionTier,
		DefaultMode:           defaultMode,
		DefaultOperatorMode:   defaultOperatorMode,
		EnabledModes:          modes,
		AICreditsRemaining:    row.AICreditsRemaining.String(),
		AICreditsMonthlyLimit: row.AICreditsMonthlyLimit.String(),
		StorageUsedBytes:      row.StorageUsedBytes,
		StorageLimitBytes:     row.StorageLimitBytes,
		Locale:                row.Locale,
		Timezone:              row.Timezone,
		Status:                row.Status,
		CreatedAt:             row.CreatedAt.UTC().Format(time.RFC3339),
		UpdatedAt:             row.UpdatedAt.UTC().Format(time.RFC3339),
	}
}

// WorkspaceMemberProjection is the safe response representation of a workspace member.
type WorkspaceMemberProjection struct {
	MemberID    string `json:"member_id"`
	WorkspaceID string `json:"workspace_id"`
	UserID      string `json:"user_id"`
	Email       string `json:"email"`
	DisplayName string `json:"display_name"`
	AvatarURL   string `json:"avatar_url,omitempty"`
	Role        string `json:"role"`
	Status      string `json:"status"`
	JoinedAt    string `json:"joined_at"`
	UpdatedAt   string `json:"updated_at"`
}

// ProjectWorkspaceMember converts a WorkspaceMemberRow into a safe WorkspaceMemberProjection.
func ProjectWorkspaceMember(row tenantdb.WorkspaceMemberRow) WorkspaceMemberProjection {
	return WorkspaceMemberProjection{
		MemberID:    row.MemberID,
		WorkspaceID: row.WorkspaceID,
		UserID:      row.UserID,
		Email:       row.Email,
		DisplayName: row.DisplayName,
		AvatarURL:   row.AvatarURL,
		Role:        row.Role,
		Status:      row.Status,
		JoinedAt:    row.JoinedAt.UTC().Format(time.RFC3339),
		UpdatedAt:   row.UpdatedAt.UTC().Format(time.RFC3339),
	}
}

// ConnectedAccountRecord represents a full database row from connected_accounts including encrypted tokens.
type ConnectedAccountRecord struct {
	ConnectedAccountID    string
	WorkspaceID           string
	Platform              string
	AccountType           string
	ExternalAccountID     string
	DisplayName           string
	AvatarURL             string
	AccessTokenEncrypted  []byte
	RefreshTokenEncrypted []byte
	TokenExpiresAt        *time.Time
	GrantedScopes         []string
	ConnectionState       string
	LastSyncedAt          *time.Time
}

// ConnectedAccountProjection is the safe response projection of connected_accounts.
// Encrypted OAuth tokens (access_token_encrypted, refresh_token_encrypted) are never included.
type ConnectedAccountProjection struct {
	ConnectedAccountID string   `json:"connected_account_id"`
	WorkspaceID        string   `json:"workspace_id"`
	Platform           string   `json:"platform"`
	AccountType        string   `json:"account_type"`
	ExternalAccountID  string   `json:"external_account_id"`
	DisplayName        string   `json:"display_name,omitempty"`
	AvatarURL          string   `json:"avatar_url,omitempty"`
	TokenExpiresAt     string   `json:"token_expires_at,omitempty"`
	GrantedScopes      []string `json:"granted_scopes"`
	ConnectionState    string   `json:"connection_state"`
	LastSyncedAt       string   `json:"last_synced_at,omitempty"`
}

// ProjectConnectedAccount strips encrypted token bytes and returns a safe projection.
func ProjectConnectedAccount(rec ConnectedAccountRecord) ConnectedAccountProjection {
	scopes := make([]string, len(rec.GrantedScopes))
	copy(scopes, rec.GrantedScopes)
	proj := ConnectedAccountProjection{
		ConnectedAccountID: rec.ConnectedAccountID,
		WorkspaceID:        rec.WorkspaceID,
		Platform:           rec.Platform,
		AccountType:        rec.AccountType,
		ExternalAccountID:  rec.ExternalAccountID,
		DisplayName:        rec.DisplayName,
		AvatarURL:          rec.AvatarURL,
		GrantedScopes:      scopes,
		ConnectionState:    rec.ConnectionState,
	}
	if rec.TokenExpiresAt != nil {
		proj.TokenExpiresAt = rec.TokenExpiresAt.UTC().Format(time.RFC3339)
	}
	if rec.LastSyncedAt != nil {
		proj.LastSyncedAt = rec.LastSyncedAt.UTC().Format(time.RFC3339)
	}
	return proj
}

// APIKeyRecord represents a full database row from api_keys including key_hash.
type APIKeyRecord struct {
	APIKeyID     string
	WorkspaceID  string
	KeyPrefix    string
	KeyHash      string
	Name         string
	Scopes       []string
	Status       string
	RequestCount int64
	CreatedAt    time.Time
}

// APIKeyProjection is the safe response projection of api_keys (never includes key_hash).
type APIKeyProjection struct {
	APIKeyID     string   `json:"api_key_id"`
	WorkspaceID  string   `json:"workspace_id"`
	KeyPrefix    string   `json:"key_prefix"`
	Name         string   `json:"name"`
	Scopes       []string `json:"scopes"`
	Status       string   `json:"status"`
	RequestCount int64    `json:"request_count"`
	CreatedAt    string   `json:"created_at"`
}

// ProjectAPIKey strips key_hash and returns a safe APIKeyProjection.
func ProjectAPIKey(rec APIKeyRecord) APIKeyProjection {
	scopes := make([]string, len(rec.Scopes))
	copy(scopes, rec.Scopes)
	return APIKeyProjection{
		APIKeyID:     rec.APIKeyID,
		WorkspaceID:  rec.WorkspaceID,
		KeyPrefix:    rec.KeyPrefix,
		Name:         rec.Name,
		Scopes:       scopes,
		Status:       rec.Status,
		RequestCount: rec.RequestCount,
		CreatedAt:    rec.CreatedAt.UTC().Format(time.RFC3339),
	}
}

// WebhookSubscriptionRecord represents a full database row from api_webhook_subscriptions.
type WebhookSubscriptionRecord struct {
	WebhookSubscriptionID   string
	WorkspaceID             string
	APIKeyID                string
	TargetURL               string
	EventTypes              []string
	SigningSecretHash       string
	Status                  string
	ConsecutiveFailureCount int
}

// WebhookSubscriptionProjection is the safe response projection of api_webhook_subscriptions
// (never includes signing_secret_hash).
type WebhookSubscriptionProjection struct {
	WebhookSubscriptionID   string   `json:"webhook_subscription_id"`
	WorkspaceID             string   `json:"workspace_id"`
	APIKeyID                string   `json:"api_key_id,omitempty"`
	TargetURL               string   `json:"target_url"`
	EventTypes              []string `json:"event_types"`
	Status                  string   `json:"status"`
	ConsecutiveFailureCount int      `json:"consecutive_failure_count"`
}

// ProjectWebhookSubscription strips signing_secret_hash and returns a safe projection.
func ProjectWebhookSubscription(rec WebhookSubscriptionRecord) WebhookSubscriptionProjection {
	events := make([]string, len(rec.EventTypes))
	copy(events, rec.EventTypes)
	return WebhookSubscriptionProjection{
		WebhookSubscriptionID:   rec.WebhookSubscriptionID,
		WorkspaceID:             rec.WorkspaceID,
		APIKeyID:                rec.APIKeyID,
		TargetURL:               rec.TargetURL,
		EventTypes:              events,
		Status:                  rec.Status,
		ConsecutiveFailureCount: rec.ConsecutiveFailureCount,
	}
}

// SupportTicketMessageProjection is the tenant-safe representation of a support ticket message.
// Internal admin notes (`is_internal_note = true`) are strictly excluded.
type SupportTicketMessageProjection struct {
	MessageID   string          `json:"message_id"`
	TicketID    string          `json:"ticket_id"`
	WorkspaceID string          `json:"workspace_id"`
	AuthorType  string          `json:"author_type"`
	AuthorID    string          `json:"author_id,omitempty"`
	Body        string          `json:"body"`
	Attachments json.RawMessage `json:"attachments"`
	CreatedAt   string          `json:"created_at"`
}

// ProjectSupportTicketMessage converts a SupportTicketMessageRow into a tenant-safe projection,
// failing closed if IsInternalNote is true.
func ProjectSupportTicketMessage(row tenantdb.SupportTicketMessageRow) (SupportTicketMessageProjection, error) {
	if row.IsInternalNote {
		return SupportTicketMessageProjection{}, ErrInternalNoteForbidden
	}
	att := row.Attachments
	if len(att) == 0 {
		att = json.RawMessage(`[]`)
	}
	return SupportTicketMessageProjection{
		MessageID:   row.MessageID,
		TicketID:    row.TicketID,
		WorkspaceID: row.WorkspaceID,
		AuthorType:  row.AuthorType,
		AuthorID:    row.AuthorID,
		Body:        row.Body,
		Attachments: att,
		CreatedAt:   row.CreatedAt.UTC().Format(time.RFC3339),
	}, nil
}

// ProjectSupportTicketMessages filters and projects a slice of support ticket messages for tenant responses,
// silently dropping any internal note if present in raw slices so internal notes are never serialized.
func ProjectSupportTicketMessages(rows []tenantdb.SupportTicketMessageRow) []SupportTicketMessageProjection {
	out := make([]SupportTicketMessageProjection, 0, len(rows))
	for _, r := range rows {
		if r.IsInternalNote {
			continue
		}
		proj, err := ProjectSupportTicketMessage(r)
		if err == nil {
			out = append(out, proj)
		}
	}
	return out
}

// MediaKitRecord represents a media_kits row including private draft sections.
type MediaKitRecord struct {
	MediaKitID          string
	WorkspaceID         string
	Template            string
	SectionsJSON        []byte // Private draft/internal sections; never exposed in public directory
	BrandProfileID      string
	ShareURL            string
	DirectoryOptIn      bool
	DirectoryStatus     string
	DirectoryProfileRaw []byte // Allowlisted PublicCreatorProfile JSON (§27.2)
	DeletedAt           *time.Time
}

// PublicStartingRate represents the optional starting_rate in PublicCreatorProfile (§27.2).
type PublicStartingRate struct {
	Amount   string `json:"amount"`
	Currency string `json:"currency"`
}

// PublicCreatorProfileProjection enforces the exact allowlist of §27.2 PublicCreatorProfile.
// Private media_kits.sections, workspace_id, brand_profile_id, and unconsented fields are never included.
type PublicCreatorProfileProjection struct {
	MediaKitID           string              `json:"media_kit_id"`
	DisplayName          string              `json:"display_name"`
	Handle               string              `json:"handle"`
	AvatarURL            string              `json:"avatar_url,omitempty"`
	Bio                  string              `json:"bio,omitempty"`
	Categories           []string            `json:"categories"`
	Platforms            []string            `json:"platforms"`
	VerifiedMetrics      json.RawMessage     `json:"verified_metrics,omitempty"`
	CollaborationFormats []string            `json:"collaboration_formats,omitempty"`
	StartingRate         *PublicStartingRate `json:"starting_rate,omitempty"`
	AcceptsInquiries     bool                `json:"accepts_inquiries"`
}

// ProjectPublicCreatorDirectory builds a PublicCreatorProfileProjection strictly from an
// opted-in, published, non-deleted MediaKitRecord (§27.2).
func ProjectPublicCreatorDirectory(rec MediaKitRecord) (PublicCreatorProfileProjection, error) {
	if !rec.DirectoryOptIn || rec.DirectoryStatus != "published" || rec.DeletedAt != nil {
		return PublicCreatorProfileProjection{}, ErrDirectoryProfileNotPublished
	}
	var raw struct {
		DisplayName          string              `json:"display_name"`
		Handle               string              `json:"handle"`
		AvatarURL            string              `json:"avatar_url"`
		Bio                  string              `json:"bio"`
		Categories           []string            `json:"categories"`
		Platforms            []string            `json:"platforms"`
		VerifiedMetrics      json.RawMessage     `json:"verified_metrics"`
		CollaborationFormats []string            `json:"collaboration_formats"`
		StartingRate         *PublicStartingRate `json:"starting_rate"`
		AcceptsInquiries     bool                `json:"accepts_inquiries"`
	}
	if len(rec.DirectoryProfileRaw) > 0 {
		if err := json.Unmarshal(rec.DirectoryProfileRaw, &raw); err != nil {
			return PublicCreatorProfileProjection{}, fmt.Errorf("workspace: invalid directory_profile JSON: %w", err)
		}
	}
	if strings.TrimSpace(raw.DisplayName) == "" || strings.TrimSpace(raw.Handle) == "" {
		return PublicCreatorProfileProjection{}, fmt.Errorf("%w: missing display_name or handle", ErrDirectoryProfileNotPublished)
	}
	if raw.StartingRate != nil {
		// Validate exact decimal amount (no float) per DB-H-001 & §27.2.
		if _, err := tenantdb.ParseExactDecimal(raw.StartingRate.Amount); err != nil {
			return PublicCreatorProfileProjection{}, err
		}
	}
	return PublicCreatorProfileProjection{
		MediaKitID:           rec.MediaKitID,
		DisplayName:          raw.DisplayName,
		Handle:               raw.Handle,
		AvatarURL:            raw.AvatarURL,
		Bio:                  raw.Bio,
		Categories:           raw.Categories,
		Platforms:            raw.Platforms,
		VerifiedMetrics:      raw.VerifiedMetrics,
		CollaborationFormats: raw.CollaborationFormats,
		StartingRate:         raw.StartingRate,
		AcceptsInquiries:     raw.AcceptsInquiries,
	}, nil
}

// MarshalSafeJSON serializes v to JSON and verifies that no forbidden secret or private note key
// exists anywhere in the serialized JSON tree.
func MarshalSafeJSON(v any) ([]byte, error) {
	data, err := json.Marshal(v)
	if err != nil {
		return nil, err
	}
	if err := AssertNoSecretsOrPrivateNotesSerialized(data); err != nil {
		return nil, err
	}
	return data, nil
}

// AssertNoSecretsOrPrivateNotesSerialized parses a JSON payload and recursively rejects
// any object containing a forbidden secret key (`access_token_encrypted`, `key_hash`, etc.),
// `is_internal_note: true`, or internal admin password/MFA hashes.
func AssertNoSecretsOrPrivateNotesSerialized(payload []byte) error {
	trimmed := bytes.TrimSpace(payload)
	if len(trimmed) == 0 {
		return nil
	}
	var root any
	dec := json.NewDecoder(bytes.NewReader(trimmed))
	dec.UseNumber()
	if err := dec.Decode(&root); err != nil {
		return fmt.Errorf("workspace: invalid JSON payload for safety check: %w", err)
	}
	return inspectJSONNode(root)
}

func inspectJSONNode(node any) error {
	switch val := node.(type) {
	case map[string]any:
		for k, child := range val {
			lowerKey := strings.ToLower(strings.TrimSpace(k))
			if forbiddenSerializedKeys[lowerKey] {
				return fmt.Errorf("%w: key %q", ErrForbiddenFieldSerialized, k)
			}
			if lowerKey == "is_internal_note" {
				if b, ok := child.(bool); ok && b {
					return fmt.Errorf("%w: is_internal_note=true", ErrForbiddenFieldSerialized)
				}
			}
			if err := inspectJSONNode(child); err != nil {
				return err
			}
		}
	case []any:
		for _, item := range val {
			if err := inspectJSONNode(item); err != nil {
				return err
			}
		}
	}
	return nil
}
