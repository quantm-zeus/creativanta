package invitations

import (
	"errors"
	"fmt"
)

// StatusCategory mirrors the canonical gRPC/Connect status categories in
// docs/04_contracts/error_catalog.md ("gRPC <-> HTTP Status Mapping").
type StatusCategory string

const (
	StatusInvalidArgument    StatusCategory = "INVALID_ARGUMENT"    // HTTP 400
	StatusUnauthenticated    StatusCategory = "UNAUTHENTICATED"     // HTTP 401
	StatusPermissionDenied   StatusCategory = "PERMISSION_DENIED"   // HTTP 403
	StatusNotFound           StatusCategory = "NOT_FOUND"           // HTTP 404
	StatusAlreadyExists      StatusCategory = "ALREADY_EXISTS"      // HTTP 409
	StatusFailedPrecondition StatusCategory = "FAILED_PRECONDITION" // HTTP 412
	StatusResourceExhausted  StatusCategory = "RESOURCE_EXHAUSTED"  // HTTP 429
	StatusCanceled           StatusCategory = "CANCELED"            // HTTP 499
	StatusInternal           StatusCategory = "INTERNAL"            // HTTP 500
	StatusUnavailable        StatusCategory = "UNAVAILABLE"         // HTTP 503
	StatusDeadlineExceeded   StatusCategory = "DEADLINE_EXCEEDED"   // HTTP 504
)

// Canonical error codes from docs/04_contracts/error_catalog.md.
// Per error_catalog.md line 14, no ad-hoc error code prefixes or numbers are invented.
const (
	ErrCodeAuthInvalid001     = "AUTH_INVALID_001"
	ErrCodeAuthForbidden001   = "AUTH_FORBIDDEN_001"
	ErrCodeAuthForbidden002   = "AUTH_FORBIDDEN_002"
	ErrCodeAuthConflict001    = "AUTH_CONFLICT_001"
	ErrCodeSystemInternal001  = "SYSTEM_INTERNAL_001"
	ErrCodeSystemConflict001  = "SYSTEM_CONFLICT_001"
	ErrCodeSystemTimeout001   = "SYSTEM_TIMEOUT_001"
	ErrCodeSystemInvalid001   = "SYSTEM_INVALID_001"
	ErrCodeSystemNotFound001  = "SYSTEM_NOTFOUND_001"
	ErrCodeSystemForbidden001 = "SYSTEM_FORBIDDEN_001"
	ErrCodeSystemCanceled001  = "SYSTEM_CANCELED_001"
)

// Canonical EC-AUTH-004 user-facing message for expired invitation links
// (docs/02_features/platform/auth.md lines 118-121).
const (
	ExpiredInviteMessageEN = "This invitation has expired. Ask the workspace admin to send a new invite."
	ExpiredInviteMessageVI = "Lời mời này đã hết hạn. Vui lòng nhờ quản trị viên workspace gửi lời mời mới."
)

// Domain sentinel errors for programmatic inspection via errors.Is.
var (
	ErrDependencyUnconfigured = errors.New("invitations: required runtime dependency or gate is not configured")
	ErrProductionGateOpen     = errors.New("invitations: production readiness gates are not satisfied")
	ErrUnauthenticated        = errors.New("invitations: verified Clerk session required")
	ErrEmailNotVerified       = errors.New("invitations: verified primary email required before workspace join")
	ErrAccountUnavailable     = errors.New("invitations: user account is suspended or deleted")
	ErrInvalidInput           = errors.New("invitations: invalid command input")
	ErrInvitationInvalidToken = errors.New("invitations: invitation token is invalid or unrecognized")
	ErrInvitationExpired      = errors.New("invitations: invitation link has expired")
	ErrInvitationRevoked      = errors.New("invitations: invitation link has been revoked")
	ErrInvitationDeclined     = errors.New("invitations: invitation has been declined")
	ErrInvitationNotExpired   = errors.New("invitations: invitation has not expired or cannot be resent in current state")
	ErrInviteeEmailMismatch   = errors.New("invitations: authenticated user email does not match invitation recipient")
	ErrInviterNotAuthorized   = errors.New("invitations: inviter lacks workspace permission or role authority")
	ErrRoleElevationDenied    = errors.New("invitations: role self-elevation or unauthorized role grant denied")
	ErrCrossTenantMismatch    = errors.New("invitations: cross-tenant workspace or organization mismatch")
	ErrAlreadyActiveMember    = errors.New("invitations: invitee is already an active member of this workspace")
	ErrSelfInvitationDenied   = errors.New("invitations: inviter cannot invite their own email address")
	ErrIdempotencyConflict    = errors.New("invitations: idempotency key reused with a different request payload")
	ErrIdempotencyInProgress  = errors.New("invitations: idempotent request with same key is currently processing")
	ErrStaleProviderEvent     = errors.New("invitations: provider event is older than authoritative membership state")
)

// FieldViolation describes an invalid input field without echoing secret tokens.
type FieldViolation struct {
	Field  string
	Reason string
}

// DomainError carries a canonical error_catalog.md code, status category,
// bilingual user-safe message, optional field violations, and state transition
// metadata required by error_catalog.md Error Handling Rule #4.
type DomainError struct {
	Sentinel            error
	Code                string
	Status              StatusCategory
	UserMessageVI       string
	UserMessageEN       string
	CurrentState        string
	AttemptedTransition string
	ValidTransitions    []string
	FieldErrors         []FieldViolation
}

func (e *DomainError) Error() string {
	if e == nil {
		return ""
	}
	if e.Sentinel != nil {
		return fmt.Sprintf("%s (%s): %v", e.Code, e.Status, e.Sentinel)
	}
	return fmt.Sprintf("%s (%s): %s", e.Code, e.Status, e.UserMessageEN)
}

func (e *DomainError) Unwrap() error {
	if e == nil {
		return nil
	}
	return e.Sentinel
}

func newDomainError(sentinel error, code string, status StatusCategory, vi, en string) *DomainError {
	return &DomainError{
		Sentinel:      sentinel,
		Code:          code,
		Status:        status,
		UserMessageVI: vi,
		UserMessageEN: en,
	}
}

func newValidationError(field, reason string) *DomainError {
	err := newDomainError(
		ErrInvalidInput,
		ErrCodeSystemInvalid001,
		StatusInvalidArgument,
		"Dữ liệu yêu cầu không hợp lệ.",
		"Invalid request input.",
	)
	if field != "" {
		err.FieldErrors = []FieldViolation{{Field: field, Reason: reason}}
	}
	return err
}

func newPreconditionError(sentinel error, code, vi, en, currentState, attempted string, valid []string) *DomainError {
	err := newDomainError(sentinel, code, StatusFailedPrecondition, vi, en)
	err.CurrentState = currentState
	err.AttemptedTransition = attempted
	err.ValidTransitions = valid
	return err
}
