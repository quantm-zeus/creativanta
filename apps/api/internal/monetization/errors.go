package monetization

import (
	"errors"

	"connectrpc.com/connect"
)

var (
	ErrMissingTenant              = errors.New("monetization: missing workspace tenant identifier")
	ErrScopeMismatch              = errors.New("monetization: workspace tenant scope mismatch")
	ErrOfferNotFound              = errors.New("monetization: offer not found")
	ErrOfferExpired               = errors.New("monetization: offer is expired and cannot be used at checkout")
	ErrOfferNotActive             = errors.New("monetization: offer is not currently active")
	ErrOfferProductRequired       = errors.New("monetization: offer must reference a product (M13) or declare product-less type (RULE-M14-002)")
	ErrOfferInvalidStateChange    = errors.New("monetization: invalid offer lifecycle state transition")
	ErrCouponNotFound             = errors.New("monetization: coupon not found")
	ErrCouponExpired              = errors.New("monetization: coupon is expired")
	ErrCouponRevoked              = errors.New("monetization: coupon has been revoked")
	ErrCouponNotActive            = errors.New("monetization: coupon is not active")
	ErrCouponLimitExceeded        = errors.New("monetization: coupon redemption limit has been reached")
	ErrCouponMinOrderNotMet       = errors.New("monetization: order amount does not meet minimum order threshold for coupon")
	ErrCouponInvalidStateChange   = errors.New("monetization: invalid coupon lifecycle state transition")
	ErrCampaignNotFound           = errors.New("monetization: campaign not found")
	ErrCampaignBudgetExceeded     = errors.New("monetization: campaign budget exceeded")
	ErrCampaignInvalidStateChange = errors.New("monetization: invalid campaign lifecycle state transition")
	ErrInvalidAmount              = errors.New("monetization: invalid numeric amount")
)

// MapErrorToConnect translates monetization domain errors to standard ConnectRPC codes.
func MapErrorToConnect(err error) error {
	if err == nil {
		return nil
	}
	switch {
	case errors.Is(err, ErrMissingTenant):
		return connect.NewError(connect.CodeUnauthenticated, err)
	case errors.Is(err, ErrScopeMismatch):
		return connect.NewError(connect.CodePermissionDenied, err)
	case errors.Is(err, ErrOfferNotFound), errors.Is(err, ErrCouponNotFound), errors.Is(err, ErrCampaignNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, ErrOfferExpired), errors.Is(err, ErrCouponExpired), errors.Is(err, ErrCouponRevoked), errors.Is(err, ErrCouponLimitExceeded):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	case errors.Is(err, ErrOfferProductRequired), errors.Is(err, ErrCouponMinOrderNotMet), errors.Is(err, ErrOfferInvalidStateChange), errors.Is(err, ErrCouponInvalidStateChange), errors.Is(err, ErrCampaignInvalidStateChange), errors.Is(err, ErrInvalidAmount):
		return connect.NewError(connect.CodeInvalidArgument, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}
