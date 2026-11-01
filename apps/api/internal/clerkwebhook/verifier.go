// Package clerkwebhook implements fail-closed Svix signature verification,
// replay/timestamp validation, event allowlisting, and canonical SQL
// reconciliation for Clerk provider webhooks (POST /webhooks/clerk).
//
// Security posture: The webhook HTTP handler remains unmounted from the live
// API bootstrap until P0-04 (migrations, RLS, runtime role grants) and P0-05
// (durable webhook inbox/retry queues) are complete.
package clerkwebhook

import (
	"bytes"
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"strconv"
	"strings"
	"time"
)

const (
	// DefaultMaxBodyBytes bounds webhook request bodies to 64 KiB by default.
	DefaultMaxBodyBytes = 64 * 1024
	// MaxAllowedBodyBytes is the hard ceiling for configured webhook body size (256 KiB).
	MaxAllowedBodyBytes = 256 * 1024
	// DefaultTimestampTolerance is the standard Svix 5-minute replay window.
	DefaultTimestampTolerance = 5 * time.Minute
	// MaxTimestampTolerance is the hard ceiling for configured timestamp tolerance.
	MaxTimestampTolerance = 15 * time.Minute

	secretPrefix           = "whsec_"
	minDecodedSecretBytes  = 24
	maxDecodedSecretBytes  = 64
	maxSignatureHeaderLen  = 2048
	maxSignatureCandidates = 16
)

// EventType enumerates the pinned Clerk webhook event catalog permitted by
// docs/02_features/platform/auth.md.
type EventType string

const (
	EventUserCreated           EventType = "user.created"
	EventUserUpdated           EventType = "user.updated"
	EventUserDeleted           EventType = "user.deleted"
	EventSessionCreated        EventType = "session.created"
	EventSessionEnded          EventType = "session.ended"
	EventSessionRevoked        EventType = "session.revoked"
	EventOrgMembershipCreated  EventType = "organizationMembership.created"
	EventOrgMembershipUpdated  EventType = "organizationMembership.updated"
	EventOrgMembershipDeleted  EventType = "organizationMembership.deleted"
	EventOrgInvitationAccepted EventType = "organizationInvitation.accepted"
)

var pinnedAllowedEvents = map[EventType]struct{}{
	EventUserCreated:           {},
	EventUserUpdated:           {},
	EventUserDeleted:           {},
	EventSessionCreated:        {},
	EventSessionEnded:          {},
	EventSessionRevoked:        {},
	EventOrgMembershipCreated:  {},
	EventOrgMembershipUpdated:  {},
	EventOrgMembershipDeleted:  {},
	EventOrgInvitationAccepted: {},
}

var (
	ErrInvalidConfig        = errors.New("clerkwebhook: invalid verifier configuration")
	ErrNotConfigured        = errors.New("clerkwebhook: verifier or processor not configured")
	ErrMethodNotAllowed     = errors.New("clerkwebhook: method not allowed")
	ErrBodyTooLarge         = errors.New("clerkwebhook: request body exceeds maximum size")
	ErrEmptyBody            = errors.New("clerkwebhook: request body must not be empty")
	ErrMissingHeaders       = errors.New("clerkwebhook: missing required svix headers")
	ErrDuplicateHeaders     = errors.New("clerkwebhook: duplicate svix headers forbidden")
	ErrInvalidMessageID     = errors.New("clerkwebhook: invalid svix-id header")
	ErrInvalidTimestamp     = errors.New("clerkwebhook: invalid svix-timestamp header")
	ErrExpiredTimestamp     = errors.New("clerkwebhook: webhook timestamp expired")
	ErrFutureTimestamp      = errors.New("clerkwebhook: webhook timestamp too far in the future")
	ErrInvalidSignature     = errors.New("clerkwebhook: invalid svix-signature")
	ErrUnsupportedEventType = errors.New("clerkwebhook: unsupported or unallowed clerk event type")
	ErrInvalidPayload       = errors.New("clerkwebhook: invalid or incomplete verified event payload")
)

// Config configures the Clerk Svix webhook verifier.
type Config struct {
	// SigningSecret is the fixed trusted Clerk Svix secret (whsec_<base64>).
	SigningSecret string
	// MaxBodyBytes bounds the HTTP request payload (defaults to 64 KiB, max 256 KiB).
	MaxBodyBytes int64
	// TimestampTolerance bounds replay and clock skew (defaults to 5m, max 15m).
	TimestampTolerance time.Duration
	// Clock supplies the current UTC time; defaults to time.Now.
	Clock func() time.Time
	// AllowedEvents optionally restricts accepted events to a subset of the
	// pinned Clerk event catalog. Any event outside the pinned catalog is rejected.
	AllowedEvents []EventType
}

// Verifier verifies Svix headers, HMAC-SHA256 signatures, replay windows, and
// pinned Clerk event schemas before trusting any webhook payload data.
type Verifier struct {
	secret       []byte
	maxBodyBytes int64
	tolerance    time.Duration
	now          func() time.Time
	allowed      map[EventType]struct{}
}

// VerifiedEvent is returned only after Svix cryptographic verification,
// timestamp window validation, event allowlist checks, and typed schema parsing.
type VerifiedEvent struct {
	DeliveryID       string
	WebhookTimestamp time.Time
	SourceUpdatedAt  time.Time
	Type             EventType
	RawPayload       []byte
	User             *UserEventData
	Session          *SessionEventData
	Membership       *MembershipEventData
	Invitation       *InvitationEventData
}

// UserEventData holds verified Clerk user lifecycle fields.
type UserEventData struct {
	ClerkUserID     string
	Email           string
	EmailVerified   bool
	DisplayName     string
	AvatarURL       string
	Banned          bool
	Locked          bool
	Deleted         bool
	SourceUpdatedAt time.Time
}

// SessionEventData holds verified Clerk session lifecycle fields.
type SessionEventData struct {
	SessionID       string
	ClerkUserID     string
	Status          string
	SourceUpdatedAt time.Time
}

// MembershipEventData holds verified Clerk organization membership fields.
type MembershipEventData struct {
	ClerkMembershipID   string
	ClerkOrganizationID string
	ClerkUserID         string
	Role                string
	SourceUpdatedAt     time.Time
}

// InvitationEventData holds verified Clerk organization invitation fields.
type InvitationEventData struct {
	ClerkInvitationID   string
	ClerkOrganizationID string
	Email               string
	Role                string
	Status              string
	SourceUpdatedAt     time.Time
}

// NewVerifier validates configuration and decodes the trusted whsec_ signing secret.
// Signing secret contents are never included in returned errors.
func NewVerifier(cfg Config) (*Verifier, error) {
	if cfg.SigningSecret == "" ||
		strings.TrimSpace(cfg.SigningSecret) != cfg.SigningSecret ||
		strings.ContainsAny(cfg.SigningSecret, " \t\r\n") ||
		!strings.HasPrefix(cfg.SigningSecret, secretPrefix) {
		return nil, ErrInvalidConfig
	}
	encodedSecret := strings.TrimPrefix(cfg.SigningSecret, secretPrefix)
	if encodedSecret == "" {
		return nil, ErrInvalidConfig
	}
	decodedSecret, err := base64.StdEncoding.DecodeString(encodedSecret)
	if err != nil || len(decodedSecret) < minDecodedSecretBytes || len(decodedSecret) > maxDecodedSecretBytes {
		return nil, ErrInvalidConfig
	}

	maxBody := cfg.MaxBodyBytes
	if maxBody == 0 {
		maxBody = DefaultMaxBodyBytes
	}
	if maxBody < 1024 || maxBody > MaxAllowedBodyBytes {
		return nil, ErrInvalidConfig
	}

	tolerance := cfg.TimestampTolerance
	if tolerance == 0 {
		tolerance = DefaultTimestampTolerance
	}
	if tolerance < time.Second || tolerance > MaxTimestampTolerance {
		return nil, ErrInvalidConfig
	}

	clock := cfg.Clock
	if clock == nil {
		clock = time.Now
	}

	allowed := make(map[EventType]struct{}, len(pinnedAllowedEvents))
	if len(cfg.AllowedEvents) == 0 {
		for evt := range pinnedAllowedEvents {
			allowed[evt] = struct{}{}
		}
	} else {
		for _, evt := range cfg.AllowedEvents {
			if _, ok := pinnedAllowedEvents[evt]; !ok {
				return nil, ErrInvalidConfig
			}
			if _, dup := allowed[evt]; dup {
				return nil, ErrInvalidConfig
			}
			allowed[evt] = struct{}{}
		}
	}

	secretCopy := make([]byte, len(decodedSecret))
	copy(secretCopy, decodedSecret)

	return &Verifier{
		secret:       secretCopy,
		maxBodyBytes: maxBody,
		tolerance:    tolerance,
		now:          clock,
		allowed:      allowed,
	}, nil
}

// VerifyRequest validates the HTTP method, reads a bounded request body, and
// verifies the Svix headers, signature, replay window, and Clerk event payload.
func (v *Verifier) VerifyRequest(ctx context.Context, r *http.Request) (VerifiedEvent, error) {
	if v == nil || len(v.secret) == 0 {
		return VerifiedEvent{}, ErrNotConfigured
	}
	if ctx == nil {
		return VerifiedEvent{}, ErrInvalidPayload
	}
	if err := ctx.Err(); err != nil {
		return VerifiedEvent{}, err
	}
	if r == nil {
		return VerifiedEvent{}, ErrInvalidPayload
	}
	if r.Method != http.MethodPost {
		return VerifiedEvent{}, ErrMethodNotAllowed
	}
	if r.Body == nil {
		return VerifiedEvent{}, ErrEmptyBody
	}
	if r.ContentLength > v.maxBodyBytes {
		return VerifiedEvent{}, ErrBodyTooLarge
	}

	limited := io.LimitReader(r.Body, v.maxBodyBytes+1)
	rawBody, err := io.ReadAll(limited)
	if err != nil {
		return VerifiedEvent{}, err
	}
	if int64(len(rawBody)) > v.maxBodyBytes {
		return VerifiedEvent{}, ErrBodyTooLarge
	}
	if len(rawBody) == 0 {
		return VerifiedEvent{}, ErrEmptyBody
	}

	return v.Verify(ctx, r.Header, rawBody)
}

// Verify checks Svix headers, timestamp tolerance, and HMAC-SHA256 signatures
// over rawBody before parsing and validating the Clerk event payload.
func (v *Verifier) Verify(ctx context.Context, headers http.Header, rawBody []byte) (VerifiedEvent, error) {
	if v == nil || len(v.secret) == 0 {
		return VerifiedEvent{}, ErrNotConfigured
	}
	if ctx == nil {
		return VerifiedEvent{}, ErrInvalidPayload
	}
	if err := ctx.Err(); err != nil {
		return VerifiedEvent{}, err
	}
	if int64(len(rawBody)) > v.maxBodyBytes {
		return VerifiedEvent{}, ErrBodyTooLarge
	}
	if len(bytes.TrimSpace(rawBody)) == 0 {
		return VerifiedEvent{}, ErrEmptyBody
	}

	svixID, tsStr, sigHeader, err := extractSingleSvixHeaders(headers)
	if err != nil {
		return VerifiedEvent{}, err
	}
	if !isValidClerkID(svixID, "msg_") {
		return VerifiedEvent{}, ErrInvalidMessageID
	}

	webhookTime, err := v.verifyTimestamp(tsStr)
	if err != nil {
		return VerifiedEvent{}, err
	}

	if err := v.verifySignature(svixID, tsStr, rawBody, sigHeader); err != nil {
		return VerifiedEvent{}, err
	}

	if err := ctx.Err(); err != nil {
		return VerifiedEvent{}, err
	}

	return v.parseVerifiedEvent(svixID, webhookTime, rawBody)
}

func extractSingleSvixHeaders(headers http.Header) (svixID, svixTimestamp, svixSignature string, err error) {
	if headers == nil {
		return "", "", "", ErrMissingHeaders
	}
	ids := headers.Values("svix-id")
	timestamps := headers.Values("svix-timestamp")
	signatures := headers.Values("svix-signature")

	if len(ids) == 0 || len(timestamps) == 0 || len(signatures) == 0 {
		return "", "", "", ErrMissingHeaders
	}
	if len(ids) > 1 || len(timestamps) > 1 || len(signatures) > 1 {
		return "", "", "", ErrDuplicateHeaders
	}

	svixID = ids[0]
	svixTimestamp = timestamps[0]
	svixSignature = signatures[0]

	if svixID == "" || svixTimestamp == "" || svixSignature == "" {
		return "", "", "", ErrMissingHeaders
	}
	if strings.TrimSpace(svixID) != svixID ||
		strings.TrimSpace(svixTimestamp) != svixTimestamp ||
		strings.TrimSpace(svixSignature) != svixSignature {
		return "", "", "", ErrInvalidSignature
	}
	return svixID, svixTimestamp, svixSignature, nil
}

func (v *Verifier) verifyTimestamp(tsStr string) (time.Time, error) {
	if len(tsStr) == 0 || len(tsStr) > 20 {
		return time.Time{}, ErrInvalidTimestamp
	}
	for i := 0; i < len(tsStr); i++ {
		if tsStr[i] < '0' || tsStr[i] > '9' {
			return time.Time{}, ErrInvalidTimestamp
		}
	}
	sec, err := strconv.ParseInt(tsStr, 10, 64)
	if err != nil || sec <= 0 {
		return time.Time{}, ErrInvalidTimestamp
	}
	sentAt := time.Unix(sec, 0).UTC()
	now := v.now().UTC()

	if now.Sub(sentAt) > v.tolerance {
		return time.Time{}, ErrExpiredTimestamp
	}
	if sentAt.Sub(now) > v.tolerance {
		return time.Time{}, ErrFutureTimestamp
	}
	return sentAt, nil
}

func (v *Verifier) verifySignature(svixID, tsStr string, rawBody []byte, sigHeader string) error {
	if len(sigHeader) == 0 || len(sigHeader) > maxSignatureHeaderLen {
		return ErrInvalidSignature
	}
	parts := strings.Split(sigHeader, " ")
	if len(parts) == 0 || len(parts) > maxSignatureCandidates {
		return ErrInvalidSignature
	}

	mac := hmac.New(sha256.New, v.secret)
	_, _ = mac.Write([]byte(svixID))
	_, _ = mac.Write([]byte("."))
	_, _ = mac.Write([]byte(tsStr))
	_, _ = mac.Write([]byte("."))
	_, _ = mac.Write(rawBody)
	expectedMAC := mac.Sum(nil)

	matched := false
	for _, part := range parts {
		version, b64Sig, ok := strings.Cut(part, ",")
		if !ok || version == "" || b64Sig == "" {
			return ErrInvalidSignature
		}
		if version != "v1" {
			continue
		}
		candidateMAC, err := base64.StdEncoding.DecodeString(b64Sig)
		if err != nil || len(candidateMAC) != sha256.Size {
			return ErrInvalidSignature
		}
		eq := hmac.Equal(expectedMAC, candidateMAC)
		matched = matched || eq
	}
	if !matched {
		return ErrInvalidSignature
	}
	return nil
}

type rawWebhookEnvelope struct {
	Type      string          `json:"type"`
	Data      json.RawMessage `json:"data"`
	Timestamp int64           `json:"timestamp"`
}

func (v *Verifier) parseVerifiedEvent(svixID string, webhookTime time.Time, rawBody []byte) (VerifiedEvent, error) {
	var env rawWebhookEnvelope
	if err := json.Unmarshal(rawBody, &env); err != nil {
		return VerifiedEvent{}, ErrInvalidPayload
	}
	evtType := EventType(env.Type)
	if _, ok := v.allowed[evtType]; !ok {
		return VerifiedEvent{}, ErrUnsupportedEventType
	}
	if len(bytes.TrimSpace(env.Data)) == 0 || string(bytes.TrimSpace(env.Data)) == "null" {
		return VerifiedEvent{}, ErrInvalidPayload
	}

	bodyCopy := make([]byte, len(rawBody))
	copy(bodyCopy, rawBody)

	out := VerifiedEvent{
		DeliveryID:       svixID,
		WebhookTimestamp: webhookTime,
		Type:             evtType,
		RawPayload:       bodyCopy,
	}

	switch evtType {
	case EventUserCreated, EventUserUpdated:
		user, err := parseUserUpsertPayload(env.Data, env.Timestamp)
		if err != nil {
			return VerifiedEvent{}, err
		}
		out.User = &user
		out.SourceUpdatedAt = user.SourceUpdatedAt
	case EventUserDeleted:
		user, err := parseUserDeletedPayload(env.Data, env.Timestamp, webhookTime)
		if err != nil {
			return VerifiedEvent{}, err
		}
		out.User = &user
		out.SourceUpdatedAt = user.SourceUpdatedAt
	case EventSessionCreated, EventSessionEnded, EventSessionRevoked:
		sess, err := parseSessionPayload(env.Data, env.Timestamp)
		if err != nil {
			return VerifiedEvent{}, err
		}
		out.Session = &sess
		out.SourceUpdatedAt = sess.SourceUpdatedAt
	case EventOrgMembershipCreated, EventOrgMembershipUpdated, EventOrgMembershipDeleted:
		mem, err := parseMembershipPayload(env.Data, env.Timestamp)
		if err != nil {
			return VerifiedEvent{}, err
		}
		out.Membership = &mem
		out.SourceUpdatedAt = mem.SourceUpdatedAt
	case EventOrgInvitationAccepted:
		inv, err := parseInvitationPayload(env.Data, env.Timestamp)
		if err != nil {
			return VerifiedEvent{}, err
		}
		out.Invitation = &inv
		out.SourceUpdatedAt = inv.SourceUpdatedAt
	default:
		return VerifiedEvent{}, ErrUnsupportedEventType
	}

	return out, nil
}

type rawUserPayload struct {
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

func parseUserUpsertPayload(data json.RawMessage, envTimestampMS int64) (UserEventData, error) {
	var raw rawUserPayload
	if err := json.Unmarshal(data, &raw); err != nil {
		return UserEventData{}, ErrInvalidPayload
	}
	if !isValidClerkID(raw.ID, "user_") {
		return UserEventData{}, ErrInvalidPayload
	}
	if raw.PrimaryEmailAddressID == "" || len(raw.EmailAddresses) == 0 {
		return UserEventData{}, ErrInvalidPayload
	}

	var primaryEmail string
	var emailVerified bool
	for _, entry := range raw.EmailAddresses {
		if entry.ID == raw.PrimaryEmailAddressID {
			primaryEmail = strings.TrimSpace(entry.EmailAddress)
			if entry.Verification != nil && entry.Verification.Status == "verified" {
				emailVerified = true
			}
			break
		}
	}
	if !isValidEmail(primaryEmail) || !emailVerified {
		return UserEventData{}, ErrInvalidPayload
	}

	tsMS := firstPositiveTimestamp(raw.UpdatedAt, raw.CreatedAt, envTimestampMS)
	if tsMS <= 0 {
		return UserEventData{}, ErrInvalidPayload
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
		return UserEventData{}, ErrInvalidPayload
	}

	return UserEventData{
		ClerkUserID:     raw.ID,
		Email:           primaryEmail,
		EmailVerified:   true,
		DisplayName:     displayName,
		AvatarURL:       avatarURL,
		Banned:          raw.Banned,
		Locked:          raw.Locked,
		SourceUpdatedAt: time.UnixMilli(tsMS).UTC(),
	}, nil
}

func parseUserDeletedPayload(data json.RawMessage, envTimestampMS int64, webhookTime time.Time) (UserEventData, error) {
	var raw struct {
		ID        string `json:"id"`
		Deleted   bool   `json:"deleted"`
		UpdatedAt int64  `json:"updated_at"`
	}
	if err := json.Unmarshal(data, &raw); err != nil {
		return UserEventData{}, ErrInvalidPayload
	}
	if !isValidClerkID(raw.ID, "user_") || !raw.Deleted {
		return UserEventData{}, ErrInvalidPayload
	}
	tsMS := firstPositiveTimestamp(raw.UpdatedAt, envTimestampMS)
	sourceTime := webhookTime
	if tsMS > 0 {
		sourceTime = time.UnixMilli(tsMS).UTC()
	}
	return UserEventData{
		ClerkUserID:     raw.ID,
		Deleted:         true,
		SourceUpdatedAt: sourceTime,
	}, nil
}

func parseSessionPayload(data json.RawMessage, envTimestampMS int64) (SessionEventData, error) {
	var raw struct {
		ID        string `json:"id"`
		UserID    string `json:"user_id"`
		Status    string `json:"status"`
		UpdatedAt int64  `json:"updated_at"`
		CreatedAt int64  `json:"created_at"`
	}
	if err := json.Unmarshal(data, &raw); err != nil {
		return SessionEventData{}, ErrInvalidPayload
	}
	if !isValidClerkID(raw.ID, "sess_") || !isValidClerkID(raw.UserID, "user_") {
		return SessionEventData{}, ErrInvalidPayload
	}
	status := strings.TrimSpace(raw.Status)
	switch status {
	case "active", "ended", "revoked", "expired", "removed", "abandoned":
	default:
		return SessionEventData{}, ErrInvalidPayload
	}
	tsMS := firstPositiveTimestamp(raw.UpdatedAt, raw.CreatedAt, envTimestampMS)
	if tsMS <= 0 {
		return SessionEventData{}, ErrInvalidPayload
	}
	return SessionEventData{
		SessionID:       raw.ID,
		ClerkUserID:     raw.UserID,
		Status:          status,
		SourceUpdatedAt: time.UnixMilli(tsMS).UTC(),
	}, nil
}

func parseMembershipPayload(data json.RawMessage, envTimestampMS int64) (MembershipEventData, error) {
	var raw struct {
		ID           string `json:"id"`
		Role         string `json:"role"`
		Organization struct {
			ID string `json:"id"`
		} `json:"organization"`
		PublicUserData struct {
			UserID string `json:"user_id"`
		} `json:"public_user_data"`
		UpdatedAt int64 `json:"updated_at"`
		CreatedAt int64 `json:"created_at"`
	}
	if err := json.Unmarshal(data, &raw); err != nil {
		return MembershipEventData{}, ErrInvalidPayload
	}
	if !isValidClerkID(raw.ID, "orgmem_") ||
		!isValidClerkID(raw.Organization.ID, "org_") ||
		!isValidClerkID(raw.PublicUserData.UserID, "user_") {
		return MembershipEventData{}, ErrInvalidPayload
	}
	role, ok := NormalizeWorkspaceRole(raw.Role)
	if !ok {
		return MembershipEventData{}, ErrInvalidPayload
	}
	tsMS := firstPositiveTimestamp(raw.UpdatedAt, raw.CreatedAt, envTimestampMS)
	if tsMS <= 0 {
		return MembershipEventData{}, ErrInvalidPayload
	}
	return MembershipEventData{
		ClerkMembershipID:   raw.ID,
		ClerkOrganizationID: raw.Organization.ID,
		ClerkUserID:         raw.PublicUserData.UserID,
		Role:                role,
		SourceUpdatedAt:     time.UnixMilli(tsMS).UTC(),
	}, nil
}

func parseInvitationPayload(data json.RawMessage, envTimestampMS int64) (InvitationEventData, error) {
	var raw struct {
		ID             string `json:"id"`
		OrganizationID string `json:"organization_id"`
		EmailAddress   string `json:"email_address"`
		Role           string `json:"role"`
		Status         string `json:"status"`
		UpdatedAt      int64  `json:"updated_at"`
		CreatedAt      int64  `json:"created_at"`
	}
	if err := json.Unmarshal(data, &raw); err != nil {
		return InvitationEventData{}, ErrInvalidPayload
	}
	if !isValidClerkID(raw.ID, "orginv_") || !isValidClerkID(raw.OrganizationID, "org_") {
		return InvitationEventData{}, ErrInvalidPayload
	}
	email := strings.TrimSpace(raw.EmailAddress)
	if !isValidEmail(email) {
		return InvitationEventData{}, ErrInvalidPayload
	}
	role, ok := NormalizeWorkspaceRole(raw.Role)
	// Invitations cannot grant the owner role (api_behavior_contracts.md §4).
	if !ok || role == "owner" {
		return InvitationEventData{}, ErrInvalidPayload
	}
	if raw.Status != "accepted" {
		return InvitationEventData{}, ErrInvalidPayload
	}
	tsMS := firstPositiveTimestamp(raw.UpdatedAt, raw.CreatedAt, envTimestampMS)
	if tsMS <= 0 {
		return InvitationEventData{}, ErrInvalidPayload
	}
	return InvitationEventData{
		ClerkInvitationID:   raw.ID,
		ClerkOrganizationID: raw.OrganizationID,
		Email:               email,
		Role:                role,
		Status:              raw.Status,
		SourceUpdatedAt:     time.UnixMilli(tsMS).UTC(),
	}, nil
}

// NormalizeWorkspaceRole maps Clerk organization role keys to Creativanta's 7
// canonical workspace roles (docs/04_contracts/rbac_permission_matrix.md).
func NormalizeWorkspaceRole(raw string) (string, bool) {
	switch strings.TrimSpace(raw) {
	case "org:owner", "owner":
		return "owner", true
	case "org:admin", "admin":
		return "admin", true
	case "org:manager", "manager":
		return "manager", true
	case "org:editor", "editor":
		return "editor", true
	case "org:contributor", "contributor":
		return "contributor", true
	case "org:viewer", "viewer", "org:member", "basic_member":
		return "viewer", true
	case "org:external", "external":
		return "external", true
	default:
		return "", false
	}
}

func isValidClerkID(id, prefix string) bool {
	if !strings.HasPrefix(id, prefix) || len(id) <= len(prefix) || len(id) > 255 {
		return false
	}
	for i := 0; i < len(id); i++ {
		c := id[i]
		if (c < 'a' || c > 'z') && (c < 'A' || c > 'Z') && (c < '0' || c > '9') && c != '_' && c != '-' {
			return false
		}
	}
	return true
}

func isValidEmail(email string) bool {
	if len(email) < 3 || len(email) > 255 || strings.ContainsAny(email, " \t\r\n") {
		return false
	}
	at := strings.IndexByte(email, '@')
	return at > 0 && at < len(email)-1 && !strings.Contains(email[at+1:], "@")
}

func firstPositiveTimestamp(values ...int64) int64 {
	for _, v := range values {
		if v > 0 {
			return v
		}
	}
	return 0
}
