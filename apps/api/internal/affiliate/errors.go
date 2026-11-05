package affiliate

import "errors"

var (
	ErrLinkNotFound                 = errors.New("affiliate: link not found")
	ErrLinkInvalidStateChange       = errors.New("affiliate: invalid link lifecycle state transition")
	ErrLinkPermanentlyRevoked       = errors.New("affiliate: link is permanently revoked and cannot be reactivated")
	ErrLinkExpired                  = errors.New("affiliate: link has expired")
	ErrInvalidCommissionRate        = errors.New("affiliate: commission rate must be between 0 and 100 percent")
	ErrInvalidDestinationURL        = errors.New("affiliate: original url cannot be empty")
	ErrAssignmentNotFound           = errors.New("affiliate: creator assignment not found")
	ErrAssignmentInvalidStateChange = errors.New("affiliate: invalid assignment status transition")
	ErrCommissionNotFound           = errors.New("affiliate: commission not found")
	ErrCommissionAlreadyConfirmed   = errors.New("affiliate: commission is already confirmed or paid out")
	ErrCommissionHoldPeriodActive   = errors.New("affiliate: commission hold period has not elapsed yet")
	ErrInvalidClawbackAmount        = errors.New("affiliate: clawback amount exceeds remaining commission")
	ErrPayoutNotFound               = errors.New("affiliate: payout batch not found")
	ErrPayoutAlreadyExecuted        = errors.New("affiliate: payout batch already executed")
	ErrInvalidPayoutBatch           = errors.New("affiliate: invalid payout batch commissions or creator")
	ErrCommissionAlreadyInPayout    = errors.New("affiliate: commission is already assigned to a payout batch")
	ErrSettlementRequired           = errors.New("affiliate: verified external settlement reference is required to execute payout")
	ErrStatementNotFound            = errors.New("affiliate: statement not found")
	ErrHealthRecordNotFound         = errors.New("affiliate: health record not found")
	ErrEconomicRoleRequired         = errors.New("affiliate: workspace economic role must be creator or seller")
)
