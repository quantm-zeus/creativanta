package inventory

import (
	"crypto/rand"
	"errors"
	"fmt"
	"strings"
	"time"
)

func newUUID() string {
	var b [16]byte
	_, _ = rand.Read(b[:])
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

var (
	ErrInsufficientStock   = errors.New("inventory: insufficient sellable stock")
	ErrReservationConflict = errors.New("inventory: reservation conflict or expired")
	ErrMovementDuplicate   = errors.New("inventory: duplicate movement key")
	ErrLocationNotFound    = errors.New("inventory: location not found")
	ErrSkuNotInitialized   = errors.New("inventory: sku balance not initialized at location")
	ErrInvalidQuantity     = errors.New("inventory: quantity must be positive")
	ErrNegativeSellable    = errors.New("inventory: local operation cannot produce negative sellable stock")
	ErrReservationNotFound = errors.New("inventory: reservation not found")
	ErrReservationExpired  = errors.New("inventory: reservation expired")
	ErrDiscrepancy         = errors.New("inventory: stock ledger discrepancy detected")
	ErrMissingTenant       = errors.New("inventory: missing tenant workspace ID")
	ErrTenantMismatch      = errors.New("inventory: tenant workspace mismatch")
	ErrInvalidInput        = errors.New("inventory: invalid input parameters")
	ErrReturnExceedsSold   = errors.New("inventory: return quantity exceeds sold quantity")
	ErrMovementImmutable   = errors.New("inventory: stock movement ledger history is immutable")
)

const (
	LocWarehouse = "warehouse"
	LocStore     = "store"
	LocSupplier  = "supplier"
	LocInTransit = "in_transit"

	StatusActive   = "active"
	StatusInactive = "inactive"

	MovementPurchase     = "purchase"
	MovementSale         = "sale"
	MovementReturn       = "return"
	MovementAdjustment   = "adjustment"
	MovementTransfer     = "transfer"
	MovementDamage       = "damage"
	MovementPlatformSync = "platform_sync"

	ResHeld     = "held"
	ResConsumed = "consumed"
	ResReleased = "released"
	ResExpired  = "expired"

	DefaultHoldTTL = 15 * time.Minute
)

// Location represents an inventory storage facility or channel virtual location (§19.9G).
type Location struct {
	LocationID   string         `json:"location_id"`
	WorkspaceID  string         `json:"workspace_id"`
	Name         string         `json:"name"`
	LocationType string         `json:"location_type"`
	Address      map[string]any `json:"address,omitempty"`
	IsDefault    bool           `json:"is_default"`
	Status       string         `json:"status"`
	CreatedAt    time.Time      `json:"created_at"`
}

// Balance represents the current on-hand and reserved projections for a SKU at a location (§26.11).
// Per inventory computation contract §1: sellable = on_hand - reserved.
type Balance struct {
	BalanceID   string     `json:"balance_id"`
	WorkspaceID string     `json:"workspace_id"`
	SkuID       string     `json:"sku_id"`
	LocationID  string     `json:"location_id"`
	OnHand      int32      `json:"on_hand"`
	Reserved    int32      `json:"reserved"`
	OpeningAt   *time.Time `json:"opening_at,omitempty"`
	UpdatedAt   time.Time  `json:"updated_at"`
}

// Sellable returns the current available units that can be promised to local checkout.
func (b *Balance) Sellable() int32 {
	return b.OnHand - b.Reserved
}

// Movement represents an immutable stock movement ledger entry (§19.9H).
type Movement struct {
	MovementID      string         `json:"movement_id"`
	WorkspaceID     string         `json:"workspace_id"`
	SkuID           string         `json:"sku_id"`
	LocationID      string         `json:"location_id"`
	MovementType    string         `json:"movement_type"`
	MovementKey     string         `json:"movement_key"`
	Quantity        int32          `json:"quantity"` // positive = in, negative = out
	ReferenceType   string         `json:"reference_type,omitempty"`
	ReferenceID     string         `json:"reference_id,omitempty"`
	SourceCreatedAt *time.Time     `json:"source_created_at,omitempty"`
	Reason          string         `json:"reason,omitempty"`
	Metadata        map[string]any `json:"metadata,omitempty"`
	CreatedAt       time.Time      `json:"created_at"`
}

// Reservation represents a durable stock hold for an order during checkout or prior to fulfillment (§26.12).
type Reservation struct {
	ReservationID  string     `json:"reservation_id"`
	WorkspaceID    string     `json:"workspace_id"`
	OrderID        string     `json:"order_id"`
	SkuID          string     `json:"sku_id"`
	LocationID     string     `json:"location_id"`
	ReservationKey string     `json:"reservation_key"`
	Quantity       int32      `json:"quantity"`
	Status         string     `json:"status"` // held, consumed, released, expired
	ExpiresAt      *time.Time `json:"expires_at,omitempty"`
	CreatedAt      time.Time  `json:"created_at"`
	UpdatedAt      time.Time  `json:"updated_at"`
}

// ReservationItem represents a single SKU request inside a multi-line or bundle reservation.
type ReservationItem struct {
	SkuID      string `json:"sku_id"`
	LocationID string `json:"location_id"`
	Quantity   int32  `json:"quantity"`
}

// DiscrepancyReport records reconciliation discrepancies between the movement ledger and balance projection.
type DiscrepancyReport struct {
	WorkspaceID   string `json:"workspace_id"`
	SkuID         string `json:"sku_id"`
	LocationID    string `json:"location_id"`
	ExpectedStock int32  `json:"expected_stock"`
	ActualStock   int32  `json:"actual_stock"`
	Discrepancy   int32  `json:"discrepancy"`
}

func IsValidMovementType(t string) bool {
	switch strings.ToLower(strings.TrimSpace(t)) {
	case MovementPurchase, MovementSale, MovementReturn, MovementAdjustment,
		MovementTransfer, MovementDamage, MovementPlatformSync:
		return true
	default:
		return false
	}
}
