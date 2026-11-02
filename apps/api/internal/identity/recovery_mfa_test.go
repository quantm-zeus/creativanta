package identity

import (
	"context"
	"errors"
	"sync"
	"testing"
	"time"
)

type fakeProviderRecoveryVerifier struct {
	mu         sync.Mutex
	challenges map[string]RecoveryChallenge
	validCodes map[string]string
}

func (f *fakeProviderRecoveryVerifier) VerifyAndApplyPasswordReset(
	_ context.Context,
	challengeID, clerkUserID, code, _ string,
) (RecoveryChallenge, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	ch, ok := f.challenges[challengeID]
	if !ok || ch.ClerkUserID != clerkUserID {
		return RecoveryChallenge{}, ErrUnauthorized
	}
	expectedCode := f.validCodes[challengeID]
	ch.Verified = code == expectedCode && expectedCode != ""
	return ch, nil
}

type fakeSessionRevoker struct {
	mu       sync.Mutex
	sessions map[string][]string
}

func (f *fakeSessionRevoker) RevokeAllUserSessions(_ context.Context, clerkUserID string) ([]string, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	list := append([]string(nil), f.sessions[clerkUserID]...)
	f.sessions[clerkUserID] = nil
	return list, nil
}

type fakeSecurityNotifier struct {
	mu                 sync.Mutex
	passwordResetNotes []string
	newDeviceLogins    []string
}

func (f *fakeSecurityNotifier) NotifyPasswordChanged(_ context.Context, clerkUserID, email, message string) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.passwordResetNotes = append(f.passwordResetNotes, clerkUserID+"|"+email+"|"+message)
	return nil
}

func (f *fakeSecurityNotifier) NotifyNewDeviceLogin(_ context.Context, clerkUserID, email, deviceFingerprint, ipAddress string) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.newDeviceLogins = append(f.newDeviceLogins, clerkUserID+"|"+email+"|"+deviceFingerprint+"|"+ipAddress)
	return nil
}

type dualLookupAndDiscoveryStub struct {
	userID     string
	workspaces []WorkspaceSummary
}

func (d dualLookupAndDiscoveryStub) ResolveActive(_ context.Context, subject, workspaceID string) (string, bool, error) {
	if subject == "user_recover1" && workspaceID == testWorkspace {
		return d.userID, true, nil
	}
	return "", false, nil
}

func (d dualLookupAndDiscoveryStub) Discover(_ context.Context, subject string) ([]WorkspaceSummary, error) {
	if subject == "user_recover1" {
		return d.workspaces, nil
	}
	return nil, nil
}

func TestRecoveryRevokesAllActiveSessionsAndRejectsExpiredOrReplayedChallenge(t *testing.T) {
	ctx := context.Background()
	now := time.Date(2026, 11, 2, 4, 0, 0, 0, time.UTC)

	upstreamSessions := multiUserSessionStub{
		active: map[string]bool{
			"user_recover1|sess_web1":    true,
			"user_recover1|sess_mobile2": true,
			"user_recover1|sess_fresh3":  true,
		},
	}
	tracker := NewRevocationAwareSessionStatus(upstreamSessions)

	resolver := Resolver{
		Tokens: multiUserTokenStub{
			tokens: map[string]Identity{
				"jwt_web1":    {Subject: "user_recover1", SessionID: "sess_web1"},
				"jwt_mobile2": {Subject: "user_recover1", SessionID: "sess_mobile2"},
				"jwt_fresh3":  {Subject: "user_recover1", SessionID: "sess_fresh3"},
			},
		},
		Sessions: tracker,
		Memberships: dualLookupAndDiscoveryStub{
			userID: "019a3a6c-2fa4-7c5e-9de3-66f4ad9a3f1a",
			workspaces: []WorkspaceSummary{
				{ID: testWorkspace, Name: "Creator Studio", Role: "editor"},
			},
		},
	}

	// Both web and mobile sessions are active before password recovery.
	if _, err := resolver.VerifyWorkspace(ctx, "jwt_web1", testWorkspace); err != nil {
		t.Fatalf("expected jwt_web1 active before reset, got %v", err)
	}
	if _, err := resolver.VerifyWorkspace(ctx, "jwt_mobile2", testWorkspace); err != nil {
		t.Fatalf("expected jwt_mobile2 active before reset, got %v", err)
	}

	verifier := &fakeProviderRecoveryVerifier{
		challenges: map[string]RecoveryChallenge{
			"chal_expired_15m": {
				ChallengeID:       "chal_expired_15m",
				ClerkUserID:       "user_recover1",
				Email:             "recover@example.com",
				ProviderExpiresAt: now.Add(-1 * time.Second), // provider reported expiry elapsed
			},
			"chal_valid_10m": {
				ChallengeID:       "chal_valid_10m",
				ClerkUserID:       "user_recover1",
				Email:             "recover@example.com",
				ProviderExpiresAt: now.Add(10 * time.Minute),
			},
		},
		validCodes: map[string]string{
			"chal_expired_15m": "111222",
			"chal_valid_10m":   "654321",
		},
	}
	revoker := &fakeSessionRevoker{
		sessions: map[string][]string{
			"user_recover1": {"sess_web1", "sess_mobile2"},
		},
	}
	notifier := &fakeSecurityNotifier{}

	coord := NewRecoveryAndMFACoordinator(verifier, revoker, tracker, notifier)
	coord.Now = func() time.Time { return now }

	// 1. Expired challenge must report "Recovery expired" + ReRequestAllowed=true and keep sessions intact.
	expiredOutcome, err := coord.CompletePasswordRecovery(ctx, "chal_expired_15m", "user_recover1", "111222", "StrongNewPass123!")
	if !errors.Is(err, ErrRecoveryExpired) {
		t.Fatalf("expected ErrRecoveryExpired, got %v", err)
	}
	if !expiredOutcome.Expired || !expiredOutcome.ReRequestAllowed || expiredOutcome.StatusMessage != RecoveryExpiredNotice {
		t.Fatalf("unexpected expired outcome: %+v", expiredOutcome)
	}
	if _, err := resolver.VerifyWorkspace(ctx, "jwt_web1", testWorkspace); err != nil {
		t.Fatalf("expired recovery attempt should not revoke active session: %v", err)
	}

	// 2. Valid challenge before expiry updates password, revokes ALL sessions, and sends security email.
	outcome, err := coord.CompletePasswordRecovery(ctx, "chal_valid_10m", "user_recover1", "654321", "StrongNewPass123!")
	if err != nil {
		t.Fatalf("CompletePasswordRecovery failed: %v", err)
	}
	if !outcome.PasswordUpdated || !outcome.AllSessionsRevoked || outcome.RevokedSessionCount != 2 || !outcome.SecurityEmailDispatched {
		t.Fatalf("unexpected recovery outcome: %+v", outcome)
	}
	if len(notifier.passwordResetNotes) != 1 {
		t.Fatalf("expected 1 security email notification, got %d", len(notifier.passwordResetNotes))
	}

	// 3. Both existing sessions (even with unexpired 60s JWTs) are IMMEDIATELY rejected on VerifyWorkspace and DiscoverWorkspaces.
	if _, err := resolver.VerifyWorkspace(ctx, "jwt_web1", testWorkspace); !errors.Is(err, ErrUnauthorized) {
		t.Fatalf("expected jwt_web1 to be revoked after recovery, got %v", err)
	}
	if _, err := resolver.VerifyWorkspace(ctx, "jwt_mobile2", testWorkspace); !errors.Is(err, ErrUnauthorized) {
		t.Fatalf("expected jwt_mobile2 to be revoked after recovery, got %v", err)
	}
	if _, err := resolver.DiscoverWorkspaces(ctx, "jwt_web1"); !errors.Is(err, ErrUnauthorized) {
		t.Fatalf("expected DiscoverWorkspaces(jwt_web1) to be denied after recovery, got %v", err)
	}

	// 4. Single-use verification: replaying the consumed challenge is rejected.
	if _, err := coord.CompletePasswordRecovery(ctx, "chal_valid_10m", "user_recover1", "654321", "AnotherPass123!"); !errors.Is(err, ErrRecoveryChallengeUsed) {
		t.Fatalf("expected ErrRecoveryChallengeUsed on replay, got %v", err)
	}

	// 5. Fresh login session after password reset is permitted once established.
	if err := coord.EvaluateLoginSecurity(ctx, LoginSecurityCheckInput{
		ClerkUserID:       "user_recover1",
		Email:             "recover@example.com",
		SessionID:         "sess_fresh3",
		CredentialsValid:  true,
		MFAEnabled:        false,
		IsNewDevice:       false,
		DeviceFingerprint: "dev_macbook",
		IPAddress:         "203.0.113.10",
	}); err != nil {
		t.Fatalf("EvaluateLoginSecurity for fresh session failed: %v", err)
	}
	if _, err := resolver.VerifyWorkspace(ctx, "jwt_fresh3", testWorkspace); err != nil {
		t.Fatalf("expected fresh session jwt_fresh3 to succeed after re-login, got %v", err)
	}
	// Pre-reset sessions remain permanently revoked even after fresh login.
	if _, err := resolver.VerifyWorkspace(ctx, "jwt_web1", testWorkspace); !errors.Is(err, ErrUnauthorized) {
		t.Fatalf("expected pre-reset jwt_web1 to remain revoked, got %v", err)
	}
}

func TestRecoveryAndLoginBruteForceLockoutAndMFATOTPPolicy(t *testing.T) {
	ctx := context.Background()
	now := time.Date(2026, 11, 2, 4, 0, 0, 0, time.UTC)

	verifier := &fakeProviderRecoveryVerifier{
		challenges: map[string]RecoveryChallenge{
			"chal_lock": {
				ChallengeID:       "chal_lock",
				ClerkUserID:       "user_lock1",
				Email:             "lock@example.com",
				ProviderExpiresAt: now.Add(45 * time.Minute),
			},
		},
		validCodes: map[string]string{
			"chal_lock": "999888",
		},
	}
	revoker := &fakeSessionRevoker{sessions: map[string][]string{}}
	notifier := &fakeSecurityNotifier{}
	coord := NewRecoveryAndMFACoordinator(verifier, revoker, nil, notifier)
	coord.Now = func() time.Time { return now }

	// 1. Recovery lockout: >5 failed attempts in 1h locks for 30 minutes (RULE-AUTH-004).
	for i := 1; i <= 5; i++ {
		_, err := coord.CompletePasswordRecovery(ctx, "chal_lock", "user_lock1", "000000", "ValidNewPass123!")
		if !errors.Is(err, ErrUnauthorized) {
			t.Fatalf("attempt %d: expected ErrUnauthorized, got %v", i, err)
		}
	}
	// 6th failed attempt triggers 30-minute lock.
	if _, err := coord.CompletePasswordRecovery(ctx, "chal_lock", "user_lock1", "000000", "ValidNewPass123!"); !errors.Is(err, ErrRecoveryLocked) {
		t.Fatalf("expected ErrRecoveryLocked on 6th failure, got %v", err)
	}
	// Even with the correct code, recovery remains locked before 30 minutes elapse.
	now = now.Add(29 * time.Minute)
	if _, err := coord.CompletePasswordRecovery(ctx, "chal_lock", "user_lock1", "999888", "ValidNewPass123!"); !errors.Is(err, ErrRecoveryLocked) {
		t.Fatalf("expected ErrRecoveryLocked at 29m, got %v", err)
	}
	// After 30 minutes, valid recovery succeeds.
	now = now.Add(2 * time.Minute)
	if _, err := coord.CompletePasswordRecovery(ctx, "chal_lock", "user_lock1", "999888", "ValidNewPass123!"); err != nil {
		t.Fatalf("expected recovery to succeed after 30m lockout window, got %v", err)
	}

	// 2. Login brute-force lockout: >10 failed attempts in 5m locks for 30 minutes (RULE-AUTH-007).
	for i := 1; i <= 10; i++ {
		err := coord.EvaluateLoginSecurity(ctx, LoginSecurityCheckInput{
			ClerkUserID:      "user_brute1",
			Email:            "brute@example.com",
			CredentialsValid: false,
		})
		if !errors.Is(err, ErrUnauthorized) {
			t.Fatalf("login attempt %d: expected ErrUnauthorized, got %v", i, err)
		}
	}
	if err := coord.EvaluateLoginSecurity(ctx, LoginSecurityCheckInput{
		ClerkUserID:      "user_brute1",
		Email:            "brute@example.com",
		CredentialsValid: false,
	}); !errors.Is(err, ErrLoginLocked) {
		t.Fatalf("expected ErrLoginLocked on 11th failed login in 5m, got %v", err)
	}

	// 3. MFA Policy (RULE-AUTH-006): SMS is forbidden; TOTP is required on new devices when enabled.
	if err := ValidateMFAConfiguration("sms"); !errors.Is(err, ErrUnsupportedMFAMethod) {
		t.Fatalf("expected SMS MFA to be rejected, got %v", err)
	}
	if err := ValidateMFAConfiguration("totp"); err != nil {
		t.Fatalf("expected TOTP MFA to be allowed, got %v", err)
	}

	// New device with MFA enabled but TOTP not verified is rejected.
	if err := coord.EvaluateLoginSecurity(ctx, LoginSecurityCheckInput{
		ClerkUserID:       "user_mfa1",
		Email:             "mfa@example.com",
		SessionID:         "sess_mfa1",
		CredentialsValid:  true,
		MFAEnabled:        true,
		MFAMethod:         "totp",
		TOTPVerified:      false,
		IsNewDevice:       true,
		DeviceFingerprint: "iphone_16",
		IPAddress:         "198.51.100.42",
	}); !errors.Is(err, ErrMFARequired) {
		t.Fatalf("expected ErrMFARequired on unverified new-device MFA login, got %v", err)
	}

	// New device with verified TOTP succeeds and dispatches new-device email notification.
	if err := coord.EvaluateLoginSecurity(ctx, LoginSecurityCheckInput{
		ClerkUserID:       "user_mfa1",
		Email:             "mfa@example.com",
		SessionID:         "sess_mfa1",
		CredentialsValid:  true,
		MFAEnabled:        true,
		MFAMethod:         "totp",
		TOTPVerified:      true,
		IsNewDevice:       true,
		DeviceFingerprint: "iphone_16",
		IPAddress:         "198.51.100.42",
	}); err != nil {
		t.Fatalf("expected verified TOTP login to succeed, got %v", err)
	}
	if len(notifier.newDeviceLogins) != 1 {
		t.Fatalf("expected 1 new-device notification, got %d", len(notifier.newDeviceLogins))
	}
}
