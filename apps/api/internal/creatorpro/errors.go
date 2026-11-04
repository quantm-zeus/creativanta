package creatorpro

import (
	"errors"

	"connectrpc.com/connect"
)

var (
	ErrMissingTenant              = errors.New("creatorpro: missing workspace tenant identifier")
	ErrScopeMismatch              = errors.New("creatorpro: workspace tenant scope mismatch")
	ErrPageNotFound               = errors.New("creatorpro: link-in-bio page not found")
	ErrDuplicatePageSlug          = errors.New("creatorpro: link-in-bio page slug already exists")
	ErrLinkItemNotFound           = errors.New("creatorpro: link item not found")
	ErrRateCardNotFound           = errors.New("creatorpro: rate card not found")
	ErrRateCardItemNotFound       = errors.New("creatorpro: rate card item not found")
	ErrMediaKitNotFound           = errors.New("creatorpro: media kit not found")
	ErrBrandDealNotFound          = errors.New("creatorpro: brand deal not found")
	ErrSponsorInquiryNotFound     = errors.New("creatorpro: sponsor inquiry not found")
	ErrInvalidAmount              = errors.New("creatorpro: invalid numeric amount")
	ErrInvalidStateTransition     = errors.New("creatorpro: invalid lifecycle state transition")
	ErrCompletedDealImmutable     = errors.New("creatorpro: completed deal is terminal and cannot be modified or cancelled")
	ErrCancellationReasonRequired = errors.New("creatorpro: cancellation reason is required when cancelling a deal")
	ErrFinancialReversalRequired  = errors.New("creatorpro: financial reversal audit required for paid deal cancellation")
	// Target 2: Phishing cannot be acknowledged away
	ErrPhishingBlocked           = errors.New("creatorpro: phishing cannot be acknowledged away; confirmed phishing URLs cannot be published or activated; request security review of false positives")
	ErrDailyLinkLimitExceeded    = errors.New("creatorpro: daily link creation limit reached (20 links/day); mass creation blocked")
	ErrCustomDomainNotConfigured = errors.New("creatorpro: CNAME record not found; add CNAME record pointing to creativanta.link")
	// Target 3: Zero-view RPM undefined
	ErrZeroViewRPMUndefined = errors.New("creatorpro: zero-view RPM is undefined; denominator cannot be zero")
	ErrTierLimitExceeded    = errors.New("creatorpro: tier limit exceeded; please upgrade to unlock more items or features")
	ErrPermissionDenied     = errors.New("creatorpro: permission denied for requested operator mode and role")
)

// MapErrorToConnect translates creatorpro domain errors to standard ConnectRPC codes.
func MapErrorToConnect(err error) error {
	if err == nil {
		return nil
	}
	switch {
	case errors.Is(err, ErrMissingTenant):
		return connect.NewError(connect.CodeUnauthenticated, err)
	case errors.Is(err, ErrScopeMismatch), errors.Is(err, ErrPermissionDenied):
		return connect.NewError(connect.CodePermissionDenied, err)
	case errors.Is(err, ErrPageNotFound), errors.Is(err, ErrLinkItemNotFound),
		errors.Is(err, ErrRateCardNotFound), errors.Is(err, ErrRateCardItemNotFound),
		errors.Is(err, ErrMediaKitNotFound), errors.Is(err, ErrBrandDealNotFound),
		errors.Is(err, ErrSponsorInquiryNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, ErrDuplicatePageSlug):
		return connect.NewError(connect.CodeAlreadyExists, err)
	case errors.Is(err, ErrPhishingBlocked), errors.Is(err, ErrDailyLinkLimitExceeded),
		errors.Is(err, ErrCompletedDealImmutable), errors.Is(err, ErrCustomDomainNotConfigured),
		errors.Is(err, ErrTierLimitExceeded):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	case errors.Is(err, ErrInvalidAmount), errors.Is(err, ErrInvalidStateTransition),
		errors.Is(err, ErrCancellationReasonRequired), errors.Is(err, ErrFinancialReversalRequired),
		errors.Is(err, ErrZeroViewRPMUndefined):
		return connect.NewError(connect.CodeInvalidArgument, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}
