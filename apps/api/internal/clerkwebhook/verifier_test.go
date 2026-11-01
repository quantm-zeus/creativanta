package clerkwebhook

import (
	"bytes"
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"errors"
	"net/http"
	"net/http/httptest"
	"strconv"
	"strings"
	"testing"
	"time"
)

// Deterministic test-only Svix signing secrets (32 decoded bytes each).
// Never use real Clerk secrets in fixtures.
const (
	testWebhookSecret      = "whsec_MfKQ9r8GKYqrTwjUPD8ILPZIo2LaLaSw"
	testSpoofWebhookSecret = "whsec_99999999999999999999999999999999"
)

var fixedFixtureTime = time.Date(2026, 11, 1, 16, 0, 0, 0, time.UTC)

const knownValidUserCreatedBody = `{"type":"user.created","timestamp":1793548800000,"data":{"id":"user_2abcDEF123456","primary_email_address_id":"idn_email1","email_addresses":[{"id":"idn_email1","email_address":"creator@example.com","verification":{"status":"verified"}}],"first_name":"Linh","last_name":"Nguyen","image_url":"https://img.clerk.com/avatar.png","updated_at":1793548800000,"created_at":1793548790000}}`

func signSvixPayload(t *testing.T, secret, msgID, tsStr string, body []byte) string {
	t.Helper()
	rawKey, err := base64.StdEncoding.DecodeString(strings.TrimPrefix(secret, "whsec_"))
	if err != nil {
		t.Fatalf("decode test secret: %v", err)
	}
	mac := hmac.New(sha256.New, rawKey)
	_, _ = mac.Write([]byte(msgID + "." + tsStr + "."))
	_, _ = mac.Write(body)
	return "v1," + base64.StdEncoding.EncodeToString(mac.Sum(nil))
}

func TestKnownValidSignedFixture(t *testing.T) {
	// Known deterministic vector for testWebhookSecret, msg_2pO7a9X1zbcDEF, ts=1793548800:
	msgID := "msg_2pO7a9X1zbcDEF"
	tsStr := strconv.FormatInt(fixedFixtureTime.Unix(), 10)
	expectedSig := signSvixPayload(t, testWebhookSecret, msgID, tsStr, []byte(knownValidUserCreatedBody))

	v, err := NewVerifier(Config{
		SigningSecret: testWebhookSecret,
		Clock:         func() time.Time { return fixedFixtureTime },
	})
	if err != nil {
		t.Fatalf("NewVerifier failed: %v", err)
	}

	headers := http.Header{}
	headers.Set("svix-id", msgID)
	headers.Set("svix-timestamp", tsStr)
	headers.Set("svix-signature", expectedSig)

	evt, err := v.Verify(context.Background(), headers, []byte(knownValidUserCreatedBody))
	if err != nil {
		t.Fatalf("Verify rejected known valid fixture: %v", err)
	}
	if evt.DeliveryID != msgID || evt.Type != EventUserCreated || evt.User == nil {
		t.Fatalf("unexpected verified event: %+v", evt)
	}
	if evt.User.ClerkUserID != "user_2abcDEF123456" ||
		evt.User.Email != "creator@example.com" ||
		!evt.User.EmailVerified ||
		evt.User.DisplayName != "Linh Nguyen" ||
		!evt.SourceUpdatedAt.Equal(fixedFixtureTime) {
		t.Fatalf("unexpected parsed user data: %+v", evt.User)
	}
}

func TestMultiSignatureRotationAcceptsMatchingV1(t *testing.T) {
	msgID := "msg_rotation12345"
	tsStr := strconv.FormatInt(fixedFixtureTime.Unix(), 10)
	spoofSig := signSvixPayload(t, testSpoofWebhookSecret, msgID, tsStr, []byte(knownValidUserCreatedBody))
	validSig := signSvixPayload(t, testWebhookSecret, msgID, tsStr, []byte(knownValidUserCreatedBody))

	v, err := NewVerifier(Config{
		SigningSecret: testWebhookSecret,
		Clock:         func() time.Time { return fixedFixtureTime },
	})
	if err != nil {
		t.Fatal(err)
	}

	headers := http.Header{}
	headers.Set("svix-id", msgID)
	headers.Set("svix-timestamp", tsStr)
	headers.Set("svix-signature", spoofSig+" v2,futureversion "+validSig)

	evt, err := v.Verify(context.Background(), headers, []byte(knownValidUserCreatedBody))
	if err != nil || evt.DeliveryID != msgID {
		t.Fatalf("expected rotated multi-signature header to pass, got err=%v", err)
	}
}

func TestInvalidSpoofedExpiredFutureAndTamperedSignatures(t *testing.T) {
	v, err := NewVerifier(Config{
		SigningSecret: testWebhookSecret,
		Clock:         func() time.Time { return fixedFixtureTime },
	})
	if err != nil {
		t.Fatal(err)
	}

	validMsgID := "msg_valid123456"
	validTS := strconv.FormatInt(fixedFixtureTime.Unix(), 10)
	validSig := signSvixPayload(t, testWebhookSecret, validMsgID, validTS, []byte(knownValidUserCreatedBody))

	expiredTS := strconv.FormatInt(fixedFixtureTime.Add(-6*time.Minute).Unix(), 10)
	expiredSig := signSvixPayload(t, testWebhookSecret, validMsgID, expiredTS, []byte(knownValidUserCreatedBody))

	futureTS := strconv.FormatInt(fixedFixtureTime.Add(6*time.Minute).Unix(), 10)
	futureSig := signSvixPayload(t, testWebhookSecret, validMsgID, futureTS, []byte(knownValidUserCreatedBody))

	spoofedSig := signSvixPayload(t, testSpoofWebhookSecret, validMsgID, validTS, []byte(knownValidUserCreatedBody))

	cases := []struct {
		name    string
		mutate  func(h http.Header, body *[]byte)
		wantErr error
	}{
		{
			name: "spoofed_signing_key",
			mutate: func(h http.Header, _ *[]byte) {
				h.Set("svix-signature", spoofedSig)
			},
			wantErr: ErrInvalidSignature,
		},
		{
			name: "tampered_body",
			mutate: func(_ http.Header, body *[]byte) {
				*body = []byte(strings.Replace(string(*body), "creator@example.com", "attacker@example.com", 1))
			},
			wantErr: ErrInvalidSignature,
		},
		{
			name: "tampered_svix_id",
			mutate: func(h http.Header, _ *[]byte) {
				h.Set("svix-id", "msg_other999999")
			},
			wantErr: ErrInvalidSignature,
		},
		{
			name: "expired_replayed_timestamp",
			mutate: func(h http.Header, _ *[]byte) {
				h.Set("svix-timestamp", expiredTS)
				h.Set("svix-signature", expiredSig)
			},
			wantErr: ErrExpiredTimestamp,
		},
		{
			name: "future_timestamp",
			mutate: func(h http.Header, _ *[]byte) {
				h.Set("svix-timestamp", futureTS)
				h.Set("svix-signature", futureSig)
			},
			wantErr: ErrFutureTimestamp,
		},
		{
			name: "duplicate_svix_signature_headers",
			mutate: func(h http.Header, _ *[]byte) {
				h.Add("svix-signature", validSig)
			},
			wantErr: ErrDuplicateHeaders,
		},
		{
			name: "duplicate_svix_id_headers",
			mutate: func(h http.Header, _ *[]byte) {
				h.Add("svix-id", validMsgID)
			},
			wantErr: ErrDuplicateHeaders,
		},
		{
			name: "missing_svix_signature",
			mutate: func(h http.Header, _ *[]byte) {
				h.Del("svix-signature")
			},
			wantErr: ErrMissingHeaders,
		},
		{
			name: "invalid_message_id_prefix",
			mutate: func(h http.Header, _ *[]byte) {
				h.Set("svix-id", "evt_not_svix")
			},
			wantErr: ErrInvalidMessageID,
		},
		{
			name: "non_numeric_timestamp",
			mutate: func(h http.Header, _ *[]byte) {
				h.Set("svix-timestamp", "+1793548800")
			},
			wantErr: ErrInvalidTimestamp,
		},
		{
			name: "malformed_signature_entry",
			mutate: func(h http.Header, _ *[]byte) {
				h.Set("svix-signature", "v1_missing_comma")
			},
			wantErr: ErrInvalidSignature,
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			h := http.Header{}
			h.Set("svix-id", validMsgID)
			h.Set("svix-timestamp", validTS)
			h.Set("svix-signature", validSig)
			body := []byte(knownValidUserCreatedBody)
			tc.mutate(h, &body)

			_, err := v.Verify(context.Background(), h, body)
			if !errors.Is(err, tc.wantErr) {
				t.Fatalf("got err=%v, want %v", err, tc.wantErr)
			}
		})
	}
}

func TestEventAllowlistAndUnsignedOrUnverifiedDataRejected(t *testing.T) {
	v, err := NewVerifier(Config{
		SigningSecret: testWebhookSecret,
		Clock:         func() time.Time { return fixedFixtureTime },
	})
	if err != nil {
		t.Fatal(err)
	}

	tsStr := strconv.FormatInt(fixedFixtureTime.Unix(), 10)

	cases := []struct {
		name    string
		payload string
		wantErr error
	}{
		{
			name:    "unknown_event_type",
			payload: `{"type":"user.impersonated","timestamp":1793548800000,"data":{"id":"user_123456"}}`,
			wantErr: ErrUnsupportedEventType,
		},
		{
			name:    "organization_created_disallowed_to_prevent_auto_workspace",
			payload: `{"type":"organization.created","timestamp":1793548800000,"data":{"id":"org_123456","name":"Untrusted Org"}}`,
			wantErr: ErrUnsupportedEventType,
		},
		{
			name:    "unverified_primary_email_rejected",
			payload: `{"type":"user.created","timestamp":1793548800000,"data":{"id":"user_2abcDEF123456","primary_email_address_id":"idn_email1","email_addresses":[{"id":"idn_email1","email_address":"unverified@example.com","verification":{"status":"unverified"}}],"updated_at":1793548800000}}`,
			wantErr: ErrInvalidPayload,
		},
		{
			name:    "invalid_membership_role_rejected",
			payload: `{"type":"organizationMembership.created","timestamp":1793548800000,"data":{"id":"orgmem_123456","role":"org:super_root","organization":{"id":"org_123456"},"public_user_data":{"user_id":"user_123456"},"updated_at":1793548800000}}`,
			wantErr: ErrInvalidPayload,
		},
		{
			name:    "invitation_accepted_owner_role_rejected",
			payload: `{"type":"organizationInvitation.accepted","timestamp":1793548800000,"data":{"id":"orginv_123456","organization_id":"org_123456","email_address":"invitee@example.com","role":"org:owner","status":"accepted","updated_at":1793548800000}}`,
			wantErr: ErrInvalidPayload,
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			msgID := "msg_case123456"
			sig := signSvixPayload(t, testWebhookSecret, msgID, tsStr, []byte(tc.payload))
			h := http.Header{}
			h.Set("svix-id", msgID)
			h.Set("svix-timestamp", tsStr)
			h.Set("svix-signature", sig)

			_, err := v.Verify(context.Background(), h, []byte(tc.payload))
			if !errors.Is(err, tc.wantErr) {
				t.Fatalf("got err=%v, want %v", err, tc.wantErr)
			}
		})
	}
}

type recordingProcessor struct {
	events    []VerifiedEvent
	seenIDs   map[string]bool
	returnErr error
}

func (p *recordingProcessor) ProcessVerifiedEvent(_ context.Context, evt VerifiedEvent) (ProcessResult, error) {
	if p.returnErr != nil {
		return ProcessResult{}, p.returnErr
	}
	if p.seenIDs == nil {
		p.seenIDs = make(map[string]bool)
	}
	if p.seenIDs[evt.DeliveryID] {
		return ProcessResult{Duplicate: true}, nil
	}
	p.seenIDs[evt.DeliveryID] = true
	p.events = append(p.events, evt)
	return ProcessResult{}, nil
}

func TestHandlerNilDependenciesBoundedBodyAndDuplicateDelivery(t *testing.T) {
	v, err := NewVerifier(Config{
		SigningSecret: testWebhookSecret,
		MaxBodyBytes:  2048,
		Clock:         func() time.Time { return fixedFixtureTime },
	})
	if err != nil {
		t.Fatal(err)
	}

	if _, err := NewHandler(nil, &recordingProcessor{}); !errors.Is(err, ErrNotConfigured) {
		t.Fatalf("expected ErrNotConfigured for nil verifier, got %v", err)
	}
	if _, err := NewHandler(v, nil); !errors.Is(err, ErrNotConfigured) {
		t.Fatalf("expected ErrNotConfigured for nil processor, got %v", err)
	}

	// Direct zero-value Handler must also fail closed with 503.
	zeroRec := httptest.NewRecorder()
	(&Handler{}).ServeHTTP(zeroRec, httptest.NewRequest(http.MethodPost, "/webhooks/clerk", strings.NewReader("{}")))
	if zeroRec.Code != http.StatusServiceUnavailable {
		t.Fatalf("zero handler status=%d, want 503", zeroRec.Code)
	}

	proc := &recordingProcessor{}
	h, err := NewHandler(v, proc)
	if err != nil {
		t.Fatal(err)
	}

	// Non-POST rejected with 405.
	getRec := httptest.NewRecorder()
	h.ServeHTTP(getRec, httptest.NewRequest(http.MethodGet, "/webhooks/clerk", nil))
	if getRec.Code != http.StatusMethodNotAllowed {
		t.Fatalf("GET status=%d, want 405", getRec.Code)
	}

	// Oversized body rejected with 413 before reaching processor.
	oversized := bytes.Repeat([]byte("a"), 2049)
	largeReq := httptest.NewRequest(http.MethodPost, "/webhooks/clerk", bytes.NewReader(oversized))
	largeRec := httptest.NewRecorder()
	h.ServeHTTP(largeRec, largeReq)
	if largeRec.Code != http.StatusRequestEntityTooLarge || len(proc.events) != 0 {
		t.Fatalf("oversized status=%d, events=%d", largeRec.Code, len(proc.events))
	}

	// Valid delivery followed by duplicate delivery ID:
	msgID := "msg_dupcheck123"
	tsStr := strconv.FormatInt(fixedFixtureTime.Unix(), 10)
	sig := signSvixPayload(t, testWebhookSecret, msgID, tsStr, []byte(knownValidUserCreatedBody))

	for i := 0; i < 2; i++ {
		req := httptest.NewRequest(http.MethodPost, "/webhooks/clerk", strings.NewReader(knownValidUserCreatedBody))
		req.Header.Set("svix-id", msgID)
		req.Header.Set("svix-timestamp", tsStr)
		req.Header.Set("svix-signature", sig)
		rec := httptest.NewRecorder()
		h.ServeHTTP(rec, req)
		if rec.Code != http.StatusOK {
			t.Fatalf("attempt %d status=%d body=%s", i, rec.Code, rec.Body.String())
		}
		if i == 1 && !strings.Contains(rec.Body.String(), "duplicate_ignored") {
			t.Fatalf("second delivery expected duplicate_ignored, got %s", rec.Body.String())
		}
	}
	if len(proc.events) != 1 {
		t.Fatalf("expected exactly 1 processed event, got %d", len(proc.events))
	}
}

func TestNewVerifierRejectsWeakOrMalformedConfigs(t *testing.T) {
	badConfigs := []Config{
		{},
		{SigningSecret: "not_whsec_prefix"},
		{SigningSecret: "whsec_not_base64!!!"},
		{SigningSecret: "whsec_" + base64.StdEncoding.EncodeToString([]byte("too_short_16byte"))},
		{SigningSecret: " " + testWebhookSecret},
		{SigningSecret: testWebhookSecret, MaxBodyBytes: 512},
		{SigningSecret: testWebhookSecret, MaxBodyBytes: MaxAllowedBodyBytes + 1},
		{SigningSecret: testWebhookSecret, TimestampTolerance: MaxTimestampTolerance + time.Second},
		{SigningSecret: testWebhookSecret, AllowedEvents: []EventType{"organization.created"}},
		{SigningSecret: testWebhookSecret, AllowedEvents: []EventType{EventUserCreated, EventUserCreated}},
	}
	for i, cfg := range badConfigs {
		if _, err := NewVerifier(cfg); !errors.Is(err, ErrInvalidConfig) {
			t.Fatalf("case %d (%+v): expected ErrInvalidConfig, got %v", i, cfg, err)
		}
	}
}
