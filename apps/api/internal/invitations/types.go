package invitations

import (
	"bytes"
	"crypto/rand"
	"encoding/binary"
	"encoding/json"
	"fmt"
	"io"
	"net/mail"
	"regexp"
	"strings"
	"time"
)

const (
	// MaxInvitationAge is the mandatory 7-day ceiling on workspace invitation links
	// per docs/02_features/platform/auth.md RULE-AUTH-005, EC-AUTH-004, AC-5, line 192,
	// and docs/04_contracts/api_behavior_contracts.md §4.
	MaxInvitationAge = 7 * 24 * time.Hour

	// MinIdempotencyTTL is the minimum 7-day request deduplication retention window
	// per docs/04_contracts/api_behavior_contracts.md §5.
	MinIdempotencyTTL = 7 * 24 * time.Hour

	// MaxClockSkew bounds acceptable provider CreatedAt clock drift ahead of local UTC clock.
	MaxClockSkew = 2 * time.Minute

	nilUUID = "00000000-0000-0000-0000-000000000000"
)

// Canonical RPC identifiers from docs/04_contracts/api_endpoint_map.md §2.1 & §10.1
// and docs/04_contracts/rpc_permission_bindings.csv.
const (
	RPCInviteMember  = "WorkspaceService/InviteMember"
	RPCAcceptInvite  = "WorkspaceService/AcceptInvite"
	RPCDeclineInvite = "WorkspaceService/DeclineInvite"
	RPCCancelInvite  = "WorkspaceService/CancelInvite"
	RPCResendInvite  = "WorkspaceService/ResendInvite"
)

// Canonical domain event names from docs/04_contracts/domain_event_catalog.md §2.
// Clerk webhook names (organizationMembership.*, organizationInvitation.accepted)
// are provider webhook events, NEVER emitted as Creativanta domain events.
const (
	EventWorkspaceMemberInvited = "workspace.member_invited"
	EventUserRegistered         = "user.registered"
)

// WorkspaceStatus mirrors chk_workspaces_status in docs/04_contracts/database_schema.md §4.1.
type WorkspaceStatus string

const (
	WorkspaceStatusActive    WorkspaceStatus = "active"
	WorkspaceStatusSuspended WorkspaceStatus = "suspended"
	WorkspaceStatusDeleted   WorkspaceStatus = "deleted"
)

// UserStatus mirrors docs/02_features/platform/auth.md §State Machine and
// docs/04_contracts/database_schema.md §4.2.
type UserStatus string

const (
	UserStatusPendingVerification UserStatus = "pending_verification"
	UserStatusActive              UserStatus = "active"
	UserStatusSuspended           UserStatus = "suspended"
	UserStatusDeleted             UserStatus = "deleted"
)

// MembershipStatus mirrors workspace_members.status in docs/04_contracts/database_schema.md §4.3.
type MembershipStatus string

const (
	MembershipStatusActive  MembershipStatus = "active"
	MembershipStatusRemoved MembershipStatus = "removed"
)

// IdempotencyStatus mirrors api_idempotency_records.status in
// docs/04_contracts/database_schema.md §26.7.
type IdempotencyStatus string

const (
	IdempotencyStatusProcessing IdempotencyStatus = "processing"
	IdempotencyStatusCompleted  IdempotencyStatus = "completed"
	IdempotencyStatusFailed     IdempotencyStatus = "failed"
)

// ProviderInvitationStatus represents Clerk-owned invitation states
// (docs/02_features/platform/auth.md line 192).
type ProviderInvitationStatus string

const (
	ProviderInvitationPending  ProviderInvitationStatus = "pending"
	ProviderInvitationAccepted ProviderInvitationStatus = "accepted"
	ProviderInvitationRevoked  ProviderInvitationStatus = "revoked"
	ProviderInvitationExpired  ProviderInvitationStatus = "expired"
	ProviderInvitationDeclined ProviderInvitationStatus = "declined"
)

// IdentityFlow distinguishes existing Clerk/Creativanta users from newly
// registered users and unauthenticated/unverified visitors per
// docs/02_features/platform/auth.md RULE-AUTH-001, RULE-AUTH-005, §Invite Acceptance, AC-5.
type IdentityFlow string

const (
	IdentityFlowExistingUser                       IdentityFlow = "existing_user"
	IdentityFlowNewUser                            IdentityFlow = "new_user"
	IdentityFlowRegistrationOrVerificationRequired IdentityFlow = "registration_or_verification_required"
)

// WorkspaceRecord mirrors persisted columns of workspaces in
// docs/04_contracts/database_schema.md §4.1.
type WorkspaceRecord struct {
	WorkspaceID         string          `json:"workspace_id"`
	ClerkOrganizationID string          `json:"clerk_organization_id"`
	DisplayName         string          `json:"display_name"`
	Slug                string          `json:"slug"`
	Status              WorkspaceStatus `json:"status"`
	OwnerUserID         string          `json:"owner_user_id"`
	DeletedAt           *time.Time      `json:"deleted_at,omitempty"`
}

// UserRecord mirrors persisted columns of users in
// docs/04_contracts/database_schema.md §4.2.
type UserRecord struct {
	UserID          string     `json:"user_id"`
	ClerkID         string     `json:"clerk_id"`
	SourceUpdatedAt *time.Time `json:"source_updated_at,omitempty"`
	Email           string     `json:"email"`
	DisplayName     string     `json:"display_name,omitempty"`
	AvatarURL       string     `json:"avatar_url,omitempty"`
	Locale          string     `json:"locale,omitempty"`
	Timezone        string     `json:"timezone,omitempty"`
	Status          UserStatus `json:"status"`
	LastLoginAt     *time.Time `json:"last_login_at,omitempty"`
	CreatedAt       time.Time  `json:"created_at"`
	UpdatedAt       time.Time  `json:"updated_at"`
}

// WorkspaceMemberRecord mirrors persisted columns of workspace_members in
// docs/04_contracts/database_schema.md §4.3.
type WorkspaceMemberRecord struct {
	WorkspaceMemberID string           `json:"workspace_member_id"`
	ClerkMembershipID string           `json:"clerk_membership_id,omitempty"`
	SourceUpdatedAt   *time.Time       `json:"source_updated_at,omitempty"`
	WorkspaceID       string           `json:"workspace_id"`
	UserID            string           `json:"user_id"`
	Role              WorkspaceRole    `json:"role"`
	Status            MembershipStatus `json:"status"`
	InvitedBy         string           `json:"invited_by,omitempty"`
	JoinedAt          time.Time        `json:"joined_at"`
	CreatedAt         time.Time        `json:"created_at"`
	UpdatedAt         time.Time        `json:"updated_at"`
}

// AuditEventRecord mirrors persisted columns of audit_events in
// docs/04_contracts/database_schema.md §13.3.
type AuditEventRecord struct {
	AuditEventID string         `json:"audit_event_id"`
	WorkspaceID  string         `json:"workspace_id"`
	ActorUserID  string         `json:"actor_user_id,omitempty"`
	ActorType    string         `json:"actor_type"`
	Action       string         `json:"action"`
	ResourceType string         `json:"resource_type"`
	ResourceID   string         `json:"resource_id,omitempty"`
	Changes      map[string]any `json:"changes,omitempty"`
	Reason       string         `json:"reason,omitempty"`
	CreatedAt    time.Time      `json:"created_at"`
}

// IdempotencyRecord mirrors persisted columns of api_idempotency_records in
// docs/04_contracts/database_schema.md §26.7.
type IdempotencyRecord struct {
	RecordID        string            `json:"record_id"`
	WorkspaceID     string            `json:"workspace_id"`
	ActorID         string            `json:"actor_id"`
	RPC             string            `json:"rpc"`
	IdempotencyKey  string            `json:"idempotency_key"`
	RequestHash     string            `json:"request_hash"`
	Status          IdempotencyStatus `json:"status"`
	ResponsePayload []byte            `json:"response_payload,omitempty"`
	ResponseCode    int               `json:"response_code"`
	ExpiresAt       time.Time         `json:"expires_at"`
	CreatedAt       time.Time         `json:"created_at"`
}

// DomainEventRecord mirrors the canonical DomainEvent envelope in
// docs/04_contracts/domain_event_catalog.md §1.
type DomainEventRecord struct {
	EventID       string    `json:"event_id"`
	EventType     string    `json:"event_type"`
	AggregateType string    `json:"aggregate_type"`
	AggregateID   string    `json:"aggregate_id"`
	WorkspaceID   string    `json:"workspace_id"`
	ActorID       string    `json:"actor_id,omitempty"`
	ActorType     string    `json:"actor_type"`
	Payload       []byte    `json:"payload"`
	CorrelationID string    `json:"correlation_id"`
	OccurredAt    time.Time `json:"occurred_at"`
	Version       uint32    `json:"version"`
}

// WorkspaceMemberInvitedPayload matches docs/04_contracts/domain_event_catalog.md §2
// (`workspace.member_invited`: `{workspace_id, invitee_email, invited_by, role}`).
type WorkspaceMemberInvitedPayload struct {
	WorkspaceID  string        `json:"workspace_id"`
	InviteeEmail string        `json:"invitee_email"`
	InvitedBy    string        `json:"invited_by"`
	Role         WorkspaceRole `json:"role"`
}

// UserRegisteredPayload matches docs/04_contracts/domain_event_catalog.md §2
// (`user.registered`: `{user_id, email, registration_method}`).
type UserRegisteredPayload struct {
	UserID             string `json:"user_id"`
	Email              string `json:"email"`
	RegistrationMethod string `json:"registration_method"`
}

// VerifiedClerkActor represents a cryptographically and session-verified Clerk
// identity returned by IdentityVerifier (never constructed from raw client claims).
type VerifiedClerkActor struct {
	ClerkID            string
	SessionID          string
	SessionActive      bool
	Email              string
	EmailVerified      bool
	DisplayName        string
	AvatarURL          string
	RegistrationMethod string
	SourceUpdatedAt    time.Time
}

// ProviderInvitation models a pending or resolved invitation record owned by
// Clerk Organizations API (docs/02_features/platform/auth.md line 192).
// It is a provider transport model, not a local database table.
type ProviderInvitation struct {
	ProviderInvitationID string
	ClerkOrganizationID  string
	WorkspaceID          string
	InviteeEmail         string
	Role                 WorkspaceRole
	InviterUserID        string
	Status               ProviderInvitationStatus
	CreatedAt            time.Time
	ExpiresAt            time.Time
	AcceptedByClerkID    string
	ClerkMembershipID    string
	SourceUpdatedAt      time.Time
}

// EffectiveExpiry returns min(ExpiresAt, CreatedAt + 7 days) per
// docs/02_features/platform/auth.md line 192 ("The application enforces a
// seven-day maximum invitation age or the provider's shorter expiry").
func (p ProviderInvitation) EffectiveExpiry() time.Time {
	maxExpiry := p.CreatedAt.UTC().Add(MaxInvitationAge)
	if p.ExpiresAt.IsZero() || p.ExpiresAt.After(maxExpiry) {
		return maxExpiry
	}
	return p.ExpiresAt.UTC()
}

// CommandContext mirrors docs/04_contracts/api_behavior_contracts.md §2.
type CommandContext struct {
	IdempotencyKey    string     `json:"idempotency_key"`
	ExpectedUpdatedAt *time.Time `json:"expected_updated_at,omitempty"`
	Reason            string     `json:"reason,omitempty"`
	WorkspaceID       string     `json:"workspace_id,omitempty"`
	CorrelationID     string     `json:"correlation_id,omitempty"`
}

// IssueInvitationCommand models WorkspaceService/InviteMember
// (docs/04_contracts/api_behavior_contracts.md §4).
type IssueInvitationCommand struct {
	BearerToken string
	WorkspaceID string
	Command     CommandContext
	Email       string
	Role        WorkspaceRole
	TTL         time.Duration // optional; 0 defaults to MaxInvitationAge (7d), >7d is rejected
}

// IssueInvitationResult is the authorized projection returned by IssueInvitation.
type IssueInvitationResult struct {
	ProviderInvitationID string        `json:"provider_invitation_id"`
	WorkspaceID          string        `json:"workspace_id"`
	InviteeEmail         string        `json:"invitee_email"`
	Role                 WorkspaceRole `json:"role"`
	InvitedBy            string        `json:"invited_by"`
	ExpiresAt            time.Time     `json:"expires_at"`
	AuditEventID         string        `json:"audit_event_id"`
	Replayed             bool          `json:"replayed"`
}

// PreviewInvitationQuery inspects an invitation link to determine validity and
// whether the visitor follows the new-user registration+verification path or
// the existing-user direct acceptance path (auth.md §Invite Acceptance, AC-5).
type PreviewInvitationQuery struct {
	BearerToken         string
	InvitationToken     string
	ExpectedWorkspaceID string
}

// InvitationPreview returns non-sensitive invitation metadata for UI routing.
type InvitationPreview struct {
	ProviderInvitationID      string        `json:"provider_invitation_id"`
	WorkspaceID               string        `json:"workspace_id"`
	WorkspaceDisplayName      string        `json:"workspace_display_name"`
	Role                      WorkspaceRole `json:"role"`
	ExpiresAt                 time.Time     `json:"expires_at"`
	IdentityFlow              IdentityFlow  `json:"identity_flow"`
	EmailVerificationRequired bool          `json:"email_verification_required"`
	OnboardingRequired        bool          `json:"onboarding_required"`
}

// AcceptInvitationCommand models invitation acceptance.
// Notice there is NO client-supplied Role, UserID, or InviterID field: role and
// workspace authority come strictly from the server-verified provider record and
// local workspace_members verification.
type AcceptInvitationCommand struct {
	BearerToken     string         `json:"-"`
	InvitationToken string         `json:"invitation_token"`
	Command         CommandContext `json:"command"`
}

// AcceptInvitationResult returns the synchronized canonical membership and user
// context after verified invitation acceptance.
type AcceptInvitationResult struct {
	Member             WorkspaceMemberRecord `json:"member"`
	User               UserRecord            `json:"user"`
	IdentityFlow       IdentityFlow          `json:"identity_flow"`
	UserProvisionedNow bool                  `json:"user_provisioned_now"`
	OnboardingRequired bool                  `json:"onboarding_required"`
	AuditEventID       string                `json:"audit_event_id"`
	Replayed           bool                  `json:"replayed"`
}

// DeclineInvitationCommand models WorkspaceService/DeclineInvite for an invited user.
type DeclineInvitationCommand struct {
	BearerToken     string
	InvitationToken string
	Command         CommandContext
}

// DeclineInvitationResult reports idempotent invitation decline completion.
type DeclineInvitationResult struct {
	ProviderInvitationID string `json:"provider_invitation_id"`
	WorkspaceID          string `json:"workspace_id"`
	Status               string `json:"status"`
	AuditEventID         string `json:"audit_event_id"`
	Replayed             bool   `json:"replayed"`
}

// RevokeInvitationCommand models WorkspaceService/CancelInvite.
type RevokeInvitationCommand struct {
	BearerToken          string
	WorkspaceID          string
	ProviderInvitationID string
	Command              CommandContext
}

// RevokeInvitationResult reports idempotent invitation cancellation completion.
type RevokeInvitationResult struct {
	ProviderInvitationID string `json:"provider_invitation_id"`
	WorkspaceID          string `json:"workspace_id"`
	Status               string `json:"status"`
	AuditEventID         string `json:"audit_event_id"`
	Replayed             bool   `json:"replayed"`
}

// ResendInvitationCommand models WorkspaceService/ResendInvite for expired invitations
// per docs/02_features/platform/auth.md RULE-AUTH-005 ("Expired invites can be
// re-sent by workspace Admin+").
type ResendInvitationCommand struct {
	BearerToken          string
	WorkspaceID          string
	ProviderInvitationID string
	Command              CommandContext
	TTL                  time.Duration
}

// ProviderMembershipEventType enumerates the Clerk organization/invitation
// lifecycle webhook event types reconciled by ReconcileProviderMembership
// (docs/02_features/platform/auth.md RULE-AUTH-008 & lines 190-196).
type ProviderMembershipEventType string

const (
	ProviderEventMembershipCreated  ProviderMembershipEventType = "organizationMembership.created"
	ProviderEventMembershipUpdated  ProviderMembershipEventType = "organizationMembership.updated"
	ProviderEventMembershipDeleted  ProviderMembershipEventType = "organizationMembership.deleted"
	ProviderEventInvitationAccepted ProviderMembershipEventType = "organizationInvitation.accepted"
)

// ProviderMembershipEvent models a Svix-verified Clerk organization membership
// or invitation acceptance webhook payload handed to domain reconciliation.
type ProviderMembershipEvent struct {
	ExternalEventID      string
	EventType            ProviderMembershipEventType
	ClerkOrganizationID  string
	ClerkMembershipID    string
	ClerkUserID          string
	Email                string
	EmailVerified        bool
	DisplayName          string
	Role                 WorkspaceRole
	InviterUserID        string
	ProviderInvitationID string
	SourceUpdatedAt      time.Time
}

// ReconcileResult reports the outcome of provider membership webhook reconciliation.
type ReconcileResult struct {
	Applied  bool                   `json:"applied"`
	Replayed bool                   `json:"replayed"`
	Ignored  bool                   `json:"ignored"`
	Reason   string                 `json:"reason,omitempty"`
	Member   *WorkspaceMemberRecord `json:"member,omitempty"`
}

var (
	uuidRegex = regexp.MustCompile("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$")

	forbiddenPrivilegeFields = map[string]bool{
		"role":              true,
		"roles":             true,
		"permissions":       true,
		"permission":        true,
		"user_id":           true,
		"clerk_id":          true,
		"invited_by":        true,
		"inviter_user_id":   true,
		"owner_user_id":     true,
		"is_owner":          true,
		"is_admin":          true,
		"internal_admin":    true,
		"email_verified":    true,
		"subscription_tier": true,
	}
)

// DecodeAcceptCommandStrict decodes a JSON AcceptInvitationCommand payload while
// rejecting any unknown or client-injected privilege fields (such as "role",
// "permissions", "user_id", "invited_by") fail-closed per
// docs/04_contracts/api_behavior_contracts.md §3 ("unknown fields rejected",
// "never grant permissions on client data").
func DecodeAcceptCommandStrict(bearerToken string, rawJSON []byte) (AcceptInvitationCommand, error) {
	if len(bytes.TrimSpace(rawJSON)) == 0 || len(rawJSON) > 16384 {
		return AcceptInvitationCommand{}, newValidationError("body", "empty or oversized JSON command body")
	}
	var rawMap map[string]json.RawMessage
	if err := json.Unmarshal(rawJSON, &rawMap); err == nil {
		for key := range rawMap {
			if forbiddenPrivilegeFields[strings.ToLower(strings.TrimSpace(key))] {
				return AcceptInvitationCommand{}, newDomainError(
					ErrRoleElevationDenied,
					ErrCodeSystemForbidden001,
					StatusPermissionDenied,
					"Không được phép tự gán quyền hoặc định danh từ phía client.",
					"Client-supplied role or identity fields are forbidden.",
				)
			}
		}
	}

	dec := json.NewDecoder(bytes.NewReader(rawJSON))
	dec.DisallowUnknownFields()
	var cmd AcceptInvitationCommand
	if err := dec.Decode(&cmd); err != nil {
		return AcceptInvitationCommand{}, newValidationError("body", "malformed JSON or unknown command field")
	}
	var trailing any
	if err := dec.Decode(&trailing); err != io.EOF {
		return AcceptInvitationCommand{}, newValidationError("body", "unexpected trailing JSON data")
	}
	cmd.BearerToken = bearerToken
	return cmd, nil
}

// NewUUIDv7 generates an RFC 9562 version-7 time-ordered UUID per ADR-015 and
// docs/04_contracts/database_schema.md §2. Fails closed if OS CSPRNG fails.
func NewUUIDv7(now time.Time) (string, error) {
	var b [16]byte
	if _, err := rand.Read(b[:]); err != nil {
		return "", fmt.Errorf("uuidv7 entropy unavailable: %w", err)
	}
	ms := uint64(now.UTC().UnixMilli())
	var ts [8]byte
	binary.BigEndian.PutUint64(ts[:], ms)
	copy(b[0:6], ts[2:8])
	b[6] = (b[6] & 0x0f) | 0x70 // version 7
	b[8] = (b[8] & 0x3f) | 0x80 // RFC 4122/9562 variant 10xx
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16]), nil
}

func validUUID(v string) bool {
	return v != nilUUID && uuidRegex.MatchString(v)
}

func normalizeEmail(raw string) (string, bool) {
	trimmed := strings.TrimSpace(raw)
	if trimmed == "" || len(trimmed) > 254 || strings.ContainsAny(trimmed, " \t\r\n") {
		return "", false
	}
	addr, err := mail.ParseAddress(trimmed)
	if err != nil || addr.Address != trimmed {
		return "", false
	}
	at := strings.LastIndexByte(addr.Address, '@')
	if at <= 0 || at >= len(addr.Address)-1 {
		return "", false
	}
	domain := addr.Address[at+1:]
	if !strings.Contains(domain, ".") || strings.HasPrefix(domain, ".") || strings.HasSuffix(domain, ".") {
		return "", false
	}
	return strings.ToLower(addr.Address), true
}

func validOpaqueToken(raw string, minLen, maxLen int) bool {
	if len(raw) < minLen || len(raw) > maxLen {
		return false
	}
	if strings.TrimSpace(raw) != raw {
		return false
	}
	for _, r := range raw {
		if r <= 0x20 || r == 0x7f {
			return false
		}
	}
	return true
}

func validIdempotencyKey(raw string) bool {
	if len(raw) < 1 || len(raw) > 255 {
		return false
	}
	if strings.TrimSpace(raw) != raw {
		return false
	}
	for _, r := range raw {
		if r < 0x20 || r == 0x7f {
			return false
		}
	}
	return true
}
