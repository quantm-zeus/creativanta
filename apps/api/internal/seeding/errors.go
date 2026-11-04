package seeding

import "errors"

var (
	ErrSampleRequestNotFound      = errors.New("seeding: sample request not found")
	ErrSampleShipmentNotFound     = errors.New("seeding: sample shipment not found")
	ErrOutcomeNotFound            = errors.New("seeding: outcome not found")
	ErrCampaignNotFound           = errors.New("seeding: seeding campaign not found")
	ErrProductNotFound            = errors.New("seeding: product not found")
	ErrCreatorEntityNotFound      = errors.New("seeding: creator entity not found")
	ErrAssignmentNotFound         = errors.New("seeding: assignment not found")
	ErrInvalidLifecycleTransition = errors.New("seeding: invalid sample request lifecycle state transition")
	ErrInvalidShipmentTransition  = errors.New("seeding: invalid shipment state transition")
	ErrInvalidFollowUpTransition  = errors.New("seeding: invalid follow-up state transition")
	ErrMissingCarrierOrTracking   = errors.New("seeding: carrier and tracking number are required for shipment")
	ErrDeclineReasonRequired      = errors.New("seeding: decline reason is required per RULE-M18-001")
	ErrQuantityNonPositive        = errors.New("seeding: sample quantity must be positive")
	ErrDuplicateRequest           = errors.New("seeding: sample request for creator and product already exists")
	ErrCarrierUnavailable         = errors.New("seeding: carrier tracking provider unavailable")
	ErrInvalidSourceClass         = errors.New("seeding: invalid source class for outcome")
)
