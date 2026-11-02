package identity

import (
	"context"
	"errors"
	"strings"
	"sync"
	"time"
)

const (
	MaxFailedRecoveryAttemptsPerHour = 5
	RecoveryLockoutDuration          = 30 * time.Minute
	RecoveryAttemptWindow            = 1 * time.Hour

	MaxFailedLoginAttemptsPer5Min = 10
	LoginLockoutDuration          = 30 * time.Minute
	LoginAttemptWindow            = 5 * time.Minute

	MFAMethodTOTP = "totp"
	MFAMethodSMS  = "sms"

	PasswordChangedNotice = "Your password was changed. If this wasn't you, contact support."
	RecoveryExpiredNotice = "Recovery expired"
)

var (
	ErrRecoveryExpired        = errors.New("identity: Recovery expired")
	ErrRecoveryChallengeUsed  = errors.New("identity: recovery challenge already used")
	ErrRecoveryLocked         = errors.New("identity: recovery temporarily locked for 30 minutes after >5 failed attempts in 1h")
	ErrLoginLocked            = errors.New("identity: login temporarily blocked for 30 minutes after >10 failed attempts in 5m")
	ErrUnsupportedMFAMethod   = errors.New("identity: SMS-based MFA is not supported; use TOTP authenticator app")
	ErrMFARequired            = errors.New("identity: TOTP verification required on login from new device")
	ErrInvalidMFACode         = errors.New("identity: invalid TOTP code")
	ErrInvalidRecoveryRequest = errors.New("identity: invalid recovery request")
)

// RecoveryChallenge represents a Clerk-issued password recovery challenge with
// provider-reported expiry and single-use verification (RULE-AUTH-004, AC-3).
type RecoveryChallenge struct {
	ChallengeID       string
	ClerkUserID       string
	Email             string
	ProviderExpiresAt time.Time
	Verified          bool
}

// RecoveryOutcome describes the result of a password reset challenge attempt.
type RecoveryOutcome struct {
	ClerkUserID             string
	Email                   string
	PasswordUpdated         bool
	AllSessionsRevoked      bool
	RevokedSessionCount     int
	SecurityEmailDispatched bool
	Expired                 bool
	ReRequestAllowed        bool
	StatusMessage           string
}

// ProviderRecoveryVerifier verifies a single-use Clerk recovery challenge and
// applies the new password at the identity provider.
type ProviderRecoveryVerifier interface {
	VerifyAndApplyPasswordReset(ctx context.Context, challengeID, clerkUserID, code, newPasswordVerifier string) (RecoveryChallenge, error)
}

// SessionRevoker revokes all active provider sessions for a user on password
// reset or suspected account compromise (RULE-AUTH-004, RULE-AUTH-007, AC-3).
type SessionRevoker interface {
	RevokeAllUserSessions(ctx context.Context, clerkUserID string) (revokedSessionIDs []string, err error)
}

// SecurityNotifier sends transactional security notifications (RULE-AUTH-004, RULE-AUTH-007).
type SecurityNotifier interface {
	NotifyPasswordChanged(ctx context.Context, clerkUserID, email, message string) error
	NotifyNewDeviceLogin(ctx context.Context, clerkUserID, email, deviceFingerprint, ipAddress string) error
}

// RevocationAwareSessionStatus wraps an upstream SessionStatus (such as
// ClerkSessionStatus) with synchronous local session revocation tracking so
// that any session revoked by password reset, logout, or webhook is immediately
// denied even if a short-lived 60s JWT has not yet expired.
type RevocationAwareSessionStatus struct {
	Upstream SessionStatus

	mu              sync.RWMutex
	revokedSessions map[string]struct{}            // subject|sessionID
	revokedUsers    map[string]map[string]struct{} // subject -> allowed new sessions after reset
}

// NewRevocationAwareSessionStatus creates a fail-closed session status wrapper.
func NewRevocationAwareSessionStatus(upstream SessionStatus) *RevocationAwareSessionStatus {
	return &RevocationAwareSessionStatus{
		Upstream:        upstream,
		revokedSessions: make(map[string]struct{}),
		revokedUsers:    make(map[string]map[string]struct{}),
	}
}

// RevokeSession marks a single (subject, sessionID) pair as revoked immediately.
func (r *RevocationAwareSessionStatus) RevokeSession(subject, sessionID string) {
	if r == nil || subject == "" || sessionID == "" {
		return
	}
	r.mu.Lock()
	defer r.mu.Unlock()
	r.revokedSessions[subject+"|"+sessionID] = struct{}{}
	if allowed, ok := r.revokedUsers[subject]; ok {
		delete(allowed, sessionID)
	}
}

// RevokeAllSessionsForUser invalidates all existing sessions for subject. Any
// session ID not explicitly registered via AllowFreshSession after this call is
// denied immediately.
func (r *RevocationAwareSessionStatus) RevokeAllSessionsForUser(subject string, revokedSessionIDs []string) {
	if r == nil || subject == "" {
		return
	}
	r.mu.Lock()
	defer r.mu.Unlock()
	for _, sid := range revokedSessionIDs {
		if sid != "" {
			r.revokedSessions[subject+"|"+sid] = struct{}{}
		}
	}
	r.revokedUsers[subject] = make(map[string]struct{})
}

// AllowFreshSession records a newly established post-reset session for subject
// while keeping all pre-reset sessions invalidated.
func (r *RevocationAwareSessionStatus) AllowFreshSession(subject, sessionID string) {
	if r == nil || subject == "" || sessionID == "" {
		return
	}
	r.mu.Lock()
	defer r.mu.Unlock()
	if _, wasRevoked := r.revokedSessions[subject+"|"+sessionID]; wasRevoked {
		return
	}
	if allowed, ok := r.revokedUsers[subject]; ok {
		allowed[sessionID] = struct{}{}
	}
}

// Active implements SessionStatus. It fails closed if the session or user was
// revoked locally, and otherwise delegates to Upstream.Active.
func (r *RevocationAwareSessionStatus) Active(ctx context.Context, subject, sessionID string) (bool, error) {
	if r == nil || r.Upstream == nil {
		return false, ErrNotConfigured
	}
	if err := ctx.Err(); err != nil {
		return false, err
	}
	if subject == "" || sessionID == "" {
		return false, ErrUnauthorized
	}

	r.mu.RLock()
	_, explicitlyRevoked := r.revokedSessions[subject+"|"+sessionID]
	allowedAfterUserReset, userHadGlobalReset := r.revokedUsers[subject]
	var allowedPostReset bool
	if userHadGlobalReset {
		_, allowedPostReset = allowedAfterUserReset[sessionID]
	}
	r.mu.RUnlock()

	if explicitlyRevoked {
		return false, nil
	}
	if userHadGlobalReset && !allowedPostReset {
		return false, nil
	}

	return r.Upstream.Active(ctx, subject, sessionID)
}

type attemptState struct {
	failures    []time.Time
	lockedUntil time.Time
}

// RecoveryAndMFACoordinator enforces RULE-AUTH-004 (password recovery with
// provider-reported expiry, single-use challenge, session invalidation, and >5/1h
// lockout), RULE-AUTH-006 (TOTP-only MFA, mandatory on new device when enabled),
// and RULE-AUTH-007 (>10/5m brute-force lockout and new-device alerts).
type RecoveryAndMFACoordinator struct {
	RecoveryVerifier ProviderRecoveryVerifier
	SessionRevoker   SessionRevoker
	SessionTracker   *RevocationAwareSessionStatus
	Notifier         SecurityNotifier
	Now              func() time.Time

	mu                 sync.Mutex
	consumedChallenges map[string]struct{}
	recoveryAttempts   map[string]*attemptState
	loginAttempts      map[string]*attemptState
}

// NewRecoveryAndMFACoordinator initializes a coordinator with deterministic clock support.
func NewRecoveryAndMFACoordinator(
	verifier ProviderRecoveryVerifier,
	revoker SessionRevoker,
	tracker *RevocationAwareSessionStatus,
	notifier SecurityNotifier,
) *RecoveryAndMFACoordinator {
	return &RecoveryAndMFACoordinator{
		RecoveryVerifier:   verifier,
		SessionRevoker:     revoker,
		SessionTracker:     tracker,
		Notifier:           notifier,
		Now:                func() time.Time { return time.Now().UTC() },
		consumedChallenges: make(map[string]struct{}),
		recoveryAttempts:   make(map[string]*attemptState),
		loginAttempts:      make(map[string]*attemptState),
	}
}

func (c *RecoveryAndMFACoordinator) nowUTC() time.Time {
	if c != nil && c.Now != nil {
		return c.Now().UTC()
	}
	return time.Now().UTC()
}

// CompletePasswordRecovery verifies a single-use Clerk recovery challenge before
// its provider-reported expiry, revokes ALL existing sessions for the user, and
// sends the security notification email (RULE-AUTH-004, AC-3).
func (c *RecoveryAndMFACoordinator) CompletePasswordRecovery(
	ctx context.Context,
	challengeID, clerkUserID, code, newPasswordVerifier string,
) (RecoveryOutcome, error) {
	if ctx == nil {
		return RecoveryOutcome{}, ErrUnauthorized
	}
	if err := ctx.Err(); err != nil {
		return RecoveryOutcome{}, err
	}
	if c == nil || c.RecoveryVerifier == nil || c.SessionRevoker == nil || c.Notifier == nil {
		return RecoveryOutcome{}, ErrNotConfigured
	}

	challengeID = strings.TrimSpace(challengeID)
	clerkUserID = strings.TrimSpace(clerkUserID)
	code = strings.TrimSpace(code)
	if challengeID == "" || !isSafeClerkTokenID(clerkUserID, "user_") || code == "" || len(newPasswordVerifier) < 8 {
		return RecoveryOutcome{}, ErrInvalidRecoveryRequest
	}

	now := c.nowUTC()

	c.mu.Lock()
	if c.isRecoveryLockedLocked(clerkUserID, now) {
		c.mu.Unlock()
		return RecoveryOutcome{}, ErrRecoveryLocked
	}
	if _, used := c.consumedChallenges[challengeID]; used {
		c.recordRecoveryFailureLocked(clerkUserID, now)
		c.mu.Unlock()
		return RecoveryOutcome{}, ErrRecoveryChallengeUsed
	}
	c.mu.Unlock()

	challenge, err := c.RecoveryVerifier.VerifyAndApplyPasswordReset(ctx, challengeID, clerkUserID, code, newPasswordVerifier)
	if err != nil {
		c.mu.Lock()
		c.recordRecoveryFailureLocked(clerkUserID, now)
		locked := c.isRecoveryLockedLocked(clerkUserID, now)
		c.mu.Unlock()
		if locked {
			return RecoveryOutcome{}, ErrRecoveryLocked
		}
		return RecoveryOutcome{}, err
	}

	if challenge.ClerkUserID != clerkUserID || !isSafeEmail(challenge.Email) || challenge.ProviderExpiresAt.IsZero() {
		return RecoveryOutcome{}, ErrInvalidRecoveryRequest
	}

	// Check provider-reported expiry (AC-3: never assume a fixed 1-hour custom token;
	// if expired, return "Recovery expired" with a re-request option).
	if !now.Before(challenge.ProviderExpiresAt) {
		return RecoveryOutcome{
			ClerkUserID:      clerkUserID,
			Email:            challenge.Email,
			Expired:          true,
			ReRequestAllowed: true,
			StatusMessage:    RecoveryExpiredNotice,
		}, ErrRecoveryExpired
	}

	if !challenge.Verified {
		c.mu.Lock()
		c.recordRecoveryFailureLocked(clerkUserID, now)
		locked := c.isRecoveryLockedLocked(clerkUserID, now)
		c.mu.Unlock()
		if locked {
			return RecoveryOutcome{}, ErrRecoveryLocked
		}
		return RecoveryOutcome{}, ErrUnauthorized
	}

	c.mu.Lock()
	if _, used := c.consumedChallenges[challengeID]; used {
		c.mu.Unlock()
		return RecoveryOutcome{}, ErrRecoveryChallengeUsed
	}
	c.consumedChallenges[challengeID] = struct{}{}
	delete(c.recoveryAttempts, clerkUserID)
	c.mu.Unlock()

	revokedIDs, err := c.SessionRevoker.RevokeAllUserSessions(ctx, clerkUserID)
	if err != nil {
		return RecoveryOutcome{}, err
	}
	if c.SessionTracker != nil {
		c.SessionTracker.RevokeAllSessionsForUser(clerkUserID, revokedIDs)
	}

	if err := c.Notifier.NotifyPasswordChanged(ctx, clerkUserID, challenge.Email, PasswordChangedNotice); err != nil {
		return RecoveryOutcome{}, err
	}

	return RecoveryOutcome{
		ClerkUserID:             clerkUserID,
		Email:                   challenge.Email,
		PasswordUpdated:         true,
		AllSessionsRevoked:      true,
		RevokedSessionCount:     len(revokedIDs),
		SecurityEmailDispatched: true,
		Expired:                 false,
		ReRequestAllowed:        false,
		StatusMessage:           PasswordChangedNotice,
	}, nil
}

// ValidateMFAConfiguration enforces RULE-AUTH-006: TOTP authenticator apps are
// supported; SMS-based MFA is explicitly rejected.
func ValidateMFAConfiguration(method string) error {
	switch strings.ToLower(strings.TrimSpace(method)) {
	case MFAMethodTOTP:
		return nil
	case MFAMethodSMS:
		return ErrUnsupportedMFAMethod
	default:
		return ErrUnsupportedMFAMethod
	}
}

// LoginSecurityCheckInput describes the security context of a login attempt.
type LoginSecurityCheckInput struct {
	ClerkUserID       string
	Email             string
	SessionID         string
	CredentialsValid  bool
	MFAEnabled        bool
	MFAMethod         string
	TOTPVerified      bool
	IsNewDevice       bool
	DeviceFingerprint string
	IPAddress         string
}

// EvaluateLoginSecurity enforces brute-force lockout (>10 failed attempts in
// 5m -> 30m block per RULE-AUTH-007), TOTP MFA on new devices when MFA is
// enabled (RULE-AUTH-006), and new-device email notification (RULE-AUTH-007).
func (c *RecoveryAndMFACoordinator) EvaluateLoginSecurity(
	ctx context.Context,
	in LoginSecurityCheckInput,
) error {
	if ctx == nil {
		return ErrUnauthorized
	}
	if err := ctx.Err(); err != nil {
		return err
	}
	if c == nil || c.Notifier == nil {
		return ErrNotConfigured
	}
	if !isSafeClerkTokenID(in.ClerkUserID, "user_") || !isSafeEmail(in.Email) {
		return ErrUnauthorized
	}

	now := c.nowUTC()

	c.mu.Lock()
	if c.isLoginLockedLocked(in.ClerkUserID, now) {
		c.mu.Unlock()
		return ErrLoginLocked
	}
	if !in.CredentialsValid {
		c.recordLoginFailureLocked(in.ClerkUserID, now)
		locked := c.isLoginLockedLocked(in.ClerkUserID, now)
		c.mu.Unlock()
		if locked {
			return ErrLoginLocked
		}
		return ErrUnauthorized
	}
	c.mu.Unlock()

	if in.MFAEnabled {
		if err := ValidateMFAConfiguration(in.MFAMethod); err != nil {
			return err
		}
		if in.IsNewDevice && !in.TOTPVerified {
			return ErrMFARequired
		}
	}

	c.mu.Lock()
	delete(c.loginAttempts, in.ClerkUserID)
	c.mu.Unlock()

	if c.SessionTracker != nil && in.SessionID != "" {
		c.SessionTracker.AllowFreshSession(in.ClerkUserID, in.SessionID)
	}

	if in.IsNewDevice {
		if err := c.Notifier.NotifyNewDeviceLogin(ctx, in.ClerkUserID, in.Email, in.DeviceFingerprint, in.IPAddress); err != nil {
			return err
		}
	}
	return nil
}

func (c *RecoveryAndMFACoordinator) isRecoveryLockedLocked(key string, now time.Time) bool {
	st, ok := c.recoveryAttempts[key]
	if !ok {
		return false
	}
	return now.Before(st.lockedUntil)
}

func (c *RecoveryAndMFACoordinator) recordRecoveryFailureLocked(key string, now time.Time) {
	st, ok := c.recoveryAttempts[key]
	if !ok {
		st = &attemptState{}
		c.recoveryAttempts[key] = st
	}
	cutoff := now.Add(-RecoveryAttemptWindow)
	filtered := st.failures[:0]
	for _, ts := range st.failures {
		if !ts.Before(cutoff) {
			filtered = append(filtered, ts)
		}
	}
	filtered = append(filtered, now)
	st.failures = filtered
	if len(st.failures) > MaxFailedRecoveryAttemptsPerHour {
		st.lockedUntil = now.Add(RecoveryLockoutDuration)
	}
}

func (c *RecoveryAndMFACoordinator) isLoginLockedLocked(key string, now time.Time) bool {
	st, ok := c.loginAttempts[key]
	if !ok {
		return false
	}
	return now.Before(st.lockedUntil)
}

func (c *RecoveryAndMFACoordinator) recordLoginFailureLocked(key string, now time.Time) {
	st, ok := c.loginAttempts[key]
	if !ok {
		st = &attemptState{}
		c.loginAttempts[key] = st
	}
	cutoff := now.Add(-LoginAttemptWindow)
	filtered := st.failures[:0]
	for _, ts := range st.failures {
		if !ts.Before(cutoff) {
			filtered = append(filtered, ts)
		}
	}
	filtered = append(filtered, now)
	st.failures = filtered
	if len(st.failures) > MaxFailedLoginAttemptsPer5Min {
		st.lockedUntil = now.Add(LoginLockoutDuration)
	}
}
