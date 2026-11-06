package store

import (
	"errors"

	"connectrpc.com/connect"
)

var (
	ErrMissingTenant                    = errors.New("store: missing workspace tenant identifier")
	ErrScopeMismatch                    = errors.New("store: workspace tenant scope mismatch")
	ErrPageNotFound                     = errors.New("store: store page not found")
	ErrDuplicatePageSlug                = errors.New("store: store page slug already exists in workspace")
	ErrPlanNotFound                     = errors.New("store: membership plan not found")
	ErrSubscriptionNotFound             = errors.New("store: membership subscription not found")
	ErrBundleNotFound                   = errors.New("store: bundle not found")
	ErrBundleComponentOutOfStock        = errors.New("store: bundle component is out of stock, bundle is temporarily unavailable")
	ErrPaymentReplay                    = errors.New("store: payment transaction replay detected with mismatched payload")
	ErrForbiddenSaaSFromBuyerMembership = errors.New("store: buyer store subscription cannot unlock SaaS workspace privileges")
	ErrOfferExpired                     = errors.New("store: offer is expired or inactive and cannot be purchased")
	ErrOfferNotActive                   = errors.New("store: offer is not in active lifecycle state")
	ErrOfferNotFound                    = errors.New("store: offer not found")
	ErrProductNotFound                  = errors.New("store: product not found")
	ErrProductNotActive                 = errors.New("store: product is not in active lifecycle state")
	ErrInvalidAmount                    = errors.New("store: invalid numeric amount")
	ErrInvalidStateTransition           = errors.New("store: invalid lifecycle state transition")
	ErrIdempotencyKeyRequired           = errors.New("store: idempotency key is required for payment and checkout")
	ErrPaymentRequired                  = errors.New("store: confirmed payment intent is required before fulfillment")
	ErrPaymentNotVerified               = errors.New("store: payment intent has not been verified")
	ErrPaymentFailed                    = errors.New("store: payment capture failed or was declined")
	ErrPriceMismatch                    = errors.New("store: checkout order amount or currency does not match catalog price")
	ErrStorefrontNotPublished           = errors.New("store: storefront has no published pages available for checkout")
)

// MapErrorToConnect translates store domain errors to standard ConnectRPC codes.
func MapErrorToConnect(err error) error {
	if err == nil {
		return nil
	}
	switch {
	case errors.Is(err, ErrMissingTenant):
		return connect.NewError(connect.CodeUnauthenticated, err)
	case errors.Is(err, ErrScopeMismatch), errors.Is(err, ErrForbiddenSaaSFromBuyerMembership):
		return connect.NewError(connect.CodePermissionDenied, err)
	case errors.Is(err, ErrPageNotFound), errors.Is(err, ErrPlanNotFound), errors.Is(err, ErrBundleNotFound),
		errors.Is(err, ErrSubscriptionNotFound), errors.Is(err, ErrProductNotFound), errors.Is(err, ErrOfferNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, ErrDuplicatePageSlug):
		return connect.NewError(connect.CodeAlreadyExists, err)
	case errors.Is(err, ErrBundleComponentOutOfStock), errors.Is(err, ErrOfferExpired), errors.Is(err, ErrOfferNotActive),
		errors.Is(err, ErrProductNotActive), errors.Is(err, ErrPaymentRequired), errors.Is(err, ErrPaymentNotVerified),
		errors.Is(err, ErrPaymentFailed), errors.Is(err, ErrStorefrontNotPublished):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	case errors.Is(err, ErrInvalidAmount), errors.Is(err, ErrInvalidStateTransition), errors.Is(err, ErrIdempotencyKeyRequired),
		errors.Is(err, ErrPaymentReplay), errors.Is(err, ErrPriceMismatch):
		return connect.NewError(connect.CodeInvalidArgument, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}
