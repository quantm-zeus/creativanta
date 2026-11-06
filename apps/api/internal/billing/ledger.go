package billing

import (
	"context"
	"encoding/json"
	"fmt"
	"sort"
	"strings"
	"sync"
	"time"

	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// Canonical credit source types (§26.3).
const (
	SourcePromotional  = "promotional"
	SourceSubscription = "subscription"
	SourcePurchased    = "purchased"
	SourceOverage      = "overage"
)

// Canonical credit reservation statuses (§26.4).
const (
	ReservationHeld        = "held"
	ReservationInFlight    = "in_flight"
	ReservationReconciling = "reconciling"
	ReservationCommitted   = "committed"
	ReservationReleased    = "released"
	ReservationExpired     = "expired"
)

// Canonical domain event types emitted by the credit & billing engine (domain_event_catalog.md §12, §16).
const (
	EventCreditsDeducted           = "credits.deducted"
	EventCreditsLowWarning         = "credits.low_warning"
	EventCreditsExhausted          = "credits.exhausted"
	EventCreditsPurchased          = "credits.purchased"
	EventCreditsMonthlyReset       = "credits.monthly_reset"
	EventBillingPlanChanged        = "billing.plan_changed"
	EventBillingSubscriptionCancel = "billing.subscription_cancelled"
	EventBillingPaymentSucceeded   = "billing.payment_succeeded"
	EventBillingPaymentFailed      = "billing.payment_failed"
	EventAIGenerationDispatch      = "ai.generation.dispatch"
)

// EmittedEvent represents a transactional outbox event queued alongside a ledger/billing mutation.
type EmittedEvent struct {
	EventType      string
	WorkspaceID    string
	AggregateType  string
	AggregateID    string
	IdempotencyKey string
	Payload        map[string]any
	CreatedAt      time.Time
}

// LateResultReport records the quarantine of a late provider completion that arrived
// after its reservation was already released or expired (Acceptance Target #2).
type LateResultReport struct {
	WorkspaceID       string
	ReservationID     string
	ProviderRequestID string
	ReservationStatus string
	Quarantined       bool
	CustomerDebited   tenantdb.ExactDecimal
	PlatformLossNote  string
	RecordedAt        time.Time
}

// ReserveRequest specifies the worker-internal parameters to create a credit hold.
type ReserveRequest struct {
	ReservationID    string
	WorkspaceID      string
	UserID           string
	QuoteID          string
	IdempotencyKey   string
	RequestHash      string
	ConfirmedCredits tenantdb.ExactDecimal
	Now              time.Time
}

// ReserveResult returns the created (or idempotently replayed) reservation and its lot allocations.
type ReserveResult struct {
	Reservation tenantdb.CreditReservationRow
	Allocations []tenantdb.CreditReservationAllocationRow
	Replayed    bool
}

// CommitRequest specifies the worker-internal parameters to commit a credit reservation.
type CommitRequest struct {
	WorkspaceID          string
	UserID               string
	ReservationID        string
	ExecutedProvider     string
	ExecutedModelID      string
	ProviderAttemptCount int32
	MeasuredUnits        map[string]string
	ProviderRequestID    string
	Now                  time.Time
}

// CommitResult returns the committed reservation, actual debited credits, and appended ledger transactions.
type CommitResult struct {
	Reservation  tenantdb.CreditReservationRow
	ActualCharge tenantdb.ExactDecimal
	Transactions []tenantdb.CreditTransactionRow
	Replayed     bool
}

// CycleBoundaryRequest specifies the parameters for running a billing cycle boundary / monthly reset.
type CycleBoundaryRequest struct {
	WorkspaceID    string
	SubscriptionID string
	PeriodKey      string // e.g. "2026-11"
	NextPeriodEnd  time.Time
	Now            time.Time
}

// CycleBoundaryResult summarizes the effects of a monthly cycle boundary run.
type CycleBoundaryResult struct {
	ExpiredHeldReservations int
	ExpiredCreditsTotal     tenantdb.ExactDecimal
	RolloverCreditsGranted  tenantdb.ExactDecimal
	NewMonthlyAllocation    tenantdb.ExactDecimal
	PreservedPurchasedTotal tenantdb.ExactDecimal
	PreservedInFlightHeld   tenantdb.ExactDecimal
	AlreadyProcessedPeriod  bool
}

// BalanceSnapshot represents the computed canonical CreditBalance projection (api_behavior_contracts.md §2).
type BalanceSnapshot struct {
	TotalRemaining        tenantdb.ExactDecimal
	Reserved              tenantdb.ExactDecimal
	Available             tenantdb.ExactDecimal
	SubscriptionRemaining tenantdb.ExactDecimal
	PurchasedRemaining    tenantdb.ExactDecimal
	PromotionalRemaining  tenantdb.ExactDecimal
	OverageRemaining      tenantdb.ExactDecimal
	NextAllocationAt      *time.Time
	SubscriptionTier      string
	ActiveLots            []tenantdb.CreditLotRow
}

// ToProto converts BalanceSnapshot to the canonical adminv1.CreditBalance protobuf projection.
func (b BalanceSnapshot) ToProto() *adminv1.CreditBalance {
	lots := make([]*adminv1.CreditLotSummary, 0, len(b.ActiveLots))
	for _, l := range b.ActiveLots {
		avail, err := l.RemainingCredits.Sub(l.ReservedCredits)
		if err != nil || avail.IsNegative() {
			avail = tenantdb.ZeroDecimal()
		}
		var expTS *timestamppb.Timestamp
		if l.ExpiresAt != nil {
			expTS = timestamppb.New(*l.ExpiresAt)
		}
		lots = append(lots, &adminv1.CreditLotSummary{
			LotId:            &commonv1.UUID{Value: l.LotID},
			SourceType:       sourceTypeToProto(l.SourceType),
			GrantedCredits:   l.GrantedCredits.String(),
			RemainingCredits: l.RemainingCredits.String(),
			ReservedCredits:  l.ReservedCredits.String(),
			AvailableCredits: avail.String(),
			ExpiresAt:        expTS,
			ExternalGrantKey: l.ExternalGrantKey,
			CreatedAt:        timestamppb.New(l.CreatedAt),
		})
	}
	var nextAlloc *timestamppb.Timestamp
	if b.NextAllocationAt != nil {
		nextAlloc = timestamppb.New(*b.NextAllocationAt)
	}
	return &adminv1.CreditBalance{
		TotalRemaining:        b.TotalRemaining.String(),
		Reserved:              b.Reserved.String(),
		Available:             b.Available.String(),
		SubscriptionRemaining: b.SubscriptionRemaining.String(),
		PurchasedRemaining:    b.PurchasedRemaining.String(),
		PromotionalRemaining:  b.PromotionalRemaining.String(),
		OverageRemaining:      b.OverageRemaining.String(),
		NextAllocationAt:      nextAlloc,
		SubscriptionTier:      b.SubscriptionTier,
		ActiveLots:            lots,
	}
}

func sourceTypeToProto(s string) adminv1.CreditSourceType {
	switch s {
	case SourceSubscription:
		return adminv1.CreditSourceType_CREDIT_SOURCE_TYPE_SUBSCRIPTION
	case SourcePurchased:
		return adminv1.CreditSourceType_CREDIT_SOURCE_TYPE_PURCHASED
	case SourcePromotional:
		return adminv1.CreditSourceType_CREDIT_SOURCE_TYPE_PROMOTIONAL
	case SourceOverage:
		return adminv1.CreditSourceType_CREDIT_SOURCE_TYPE_OVERAGE
	default:
		return adminv1.CreditSourceType_CREDIT_SOURCE_TYPE_UNSPECIFIED
	}
}

func sourcePriority(sourceType string) int {
	switch sourceType {
	case SourcePromotional:
		return 1
	case SourceSubscription:
		return 2
	case SourcePurchased:
		return 3
	case SourceOverage:
		return 4
	default:
		return 5
	}
}

// sortLotsInConsumptionOrder sorts credit lots in the exact canonical priority order
// defined in docs/04_contracts/credit_accounting_contract.md §1:
//  1. promotional (earliest expires_at first)
//  2. subscription / rollover (earliest expires_at first)
//  3. purchased (expires_at IS NULL, FIFO by created_at)
//  4. overage (FIFO by created_at)
func sortLotsInConsumptionOrder(lots []tenantdb.CreditLotRow) {
	sort.SliceStable(lots, func(i, j int) bool {
		pi := sourcePriority(lots[i].SourceType)
		pj := sourcePriority(lots[j].SourceType)
		if pi != pj {
			return pi < pj
		}
		if lots[i].ExpiresAt != nil && lots[j].ExpiresAt != nil {
			if !lots[i].ExpiresAt.Equal(*lots[j].ExpiresAt) {
				return lots[i].ExpiresAt.Before(*lots[j].ExpiresAt)
			}
		} else if lots[i].ExpiresAt != nil && lots[j].ExpiresAt == nil {
			return true
		} else if lots[i].ExpiresAt == nil && lots[j].ExpiresAt != nil {
			return false
		}
		if !lots[i].CreatedAt.Equal(lots[j].CreatedAt) {
			return lots[i].CreatedAt.Before(lots[j].CreatedAt)
		}
		return lots[i].LotID < lots[j].LotID
	})
}

// BillingEventRecord represents a canonical row in billing_events (§13.1).
type BillingEventRecord struct {
	BillingEventID   string
	WorkspaceID      string
	EventType        string
	StripeEventID    string
	Amount           tenantdb.ExactDecimal
	Currency         string
	SubscriptionTier string
	CreditsChange    tenantdb.ExactDecimal
	Description      string
	Metadata         map[string]any
	CreatedAt        time.Time
}

// WorkspaceBillingState holds a workspace's complete credit & billing state inside a store transaction.
type WorkspaceBillingState struct {
	WorkspaceID               string
	SubscriptionTier          string
	SeatsUsed                 int32
	ChannelsUsed              int32
	StorageUsedGB             int32
	AutoRefill                *adminv1.AutoRefillConfig
	Subscription              *tenantdb.SubscriptionRow
	PaymentMethods            []tenantdb.PaymentMethodRow
	Invoices                  []tenantdb.InvoiceRow
	Quotes                    map[string]tenantdb.CreditQuoteRow
	Lots                      []tenantdb.CreditLotRow
	Reservations              map[string]tenantdb.CreditReservationRow
	Allocations               map[string][]tenantdb.CreditReservationAllocationRow
	Transactions              []tenantdb.CreditTransactionRow
	BillingEvents             []BillingEventRecord
	OutboxEvents              []EmittedEvent
	LateResultReports         []LateResultReport
	ProcessedWebhooks         map[string]time.Time
	ProcessedCycleClosures    map[string]CycleBoundaryResult
	CheckoutSessions          map[string]*CheckoutSessionRecord
	ReadOnlyMode              bool
	ReadOnlyReason            string
	RetentionPhase            string
	DunningDay                int32
	DunningAttempt            int32
	GracePeriodEndsAt         *time.Time
	TrialEndsAt               *time.Time
	TrialConsumed             bool
	RetentionOfferApplied     bool
	RetentionOfferDiscountPct string
	RetentionOfferMonths      int32
	PausedAt                  *time.Time
	PauseAutoResumesAt        *time.Time
	PauseDay83Notified        bool
	ScheduledAddonRemovals    []string
	OverageTermsAccepted      bool
	OverageUsedCredits        tenantdb.ExactDecimal
	EnabledPaymentMethodGates map[string]bool
	ExportJobs                []DataExportJobRecord
	LifecycleEvidences        []RetentionLifecycleEvidence
	SoftDeletedAt             *time.Time
	HardDeletedAt             *time.Time
}

// CheckoutSessionRecord tracks a billing or credit pack checkout session.
// Credits or plan activations are NEVER granted at session creation; they settle only via verified webhook.
type CheckoutSessionRecord struct {
	SessionID           string
	WorkspaceID         string
	UserID              string
	Kind                string // "credit_pack" or "subscription_plan"
	PackCode            string
	TargetPlan          string
	Interval            string
	Currency            string
	BaseAmount          tenantdb.ExactDecimal
	ProratedAddonCharge tenantdb.ExactDecimal
	Amount              tenantdb.ExactDecimal
	Addons              []string
	AcceptOverageTerms  bool
	Status              string // "pending", "settled", "expired"
	CreatedAt           time.Time
	SettledAt           *time.Time
}

// MemoryStore provides a deterministic, concurrency-safe (per-workspace mutex with
// transactional copy-on-commit) store for unit and -race tests.
type MemoryStore struct {
	mu         sync.Mutex
	wsLocks    map[string]*sync.Mutex
	workspaces map[string]*WorkspaceBillingState
	rateCards  map[string]ProviderRateCard
	seqCounter uint64
}

// NewMemoryStore initializes a MemoryStore seeded with the canonical verified provider rate cards.
func NewMemoryStore(now time.Time) *MemoryStore {
	s := &MemoryStore{
		wsLocks:    make(map[string]*sync.Mutex),
		workspaces: make(map[string]*WorkspaceBillingState),
		rateCards:  make(map[string]ProviderRateCard),
	}
	for _, card := range DefaultVerifiedRateCards(now) {
		key := fmt.Sprintf("%s|%s|%s", strings.ToLower(card.Provider), strings.ToLower(card.ModelID), card.Version)
		s.rateCards[key] = card
	}
	return s
}

func (s *MemoryStore) nextUUID(prefix string) string {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.seqCounter++
	return fmt.Sprintf("%s-0000-4000-8000-%012d", prefix[:8], s.seqCounter)
}

// UpsertRateCard registers or updates a provider rate card in the store.
func (s *MemoryStore) UpsertRateCard(card ProviderRateCard) {
	s.mu.Lock()
	defer s.mu.Unlock()
	key := fmt.Sprintf("%s|%s|%s", strings.ToLower(card.Provider), strings.ToLower(card.ModelID), card.Version)
	s.rateCards[key] = card
}

// LookupRateCard finds the latest (or specific version) rate card for (provider, modelID).
func (s *MemoryStore) LookupRateCard(provider, modelID, version string) (ProviderRateCard, bool) {
	s.mu.Lock()
	defer s.mu.Unlock()
	p := strings.ToLower(strings.TrimSpace(provider))
	m := strings.ToLower(strings.TrimSpace(modelID))
	if version != "" {
		card, ok := s.rateCards[fmt.Sprintf("%s|%s|%s", p, m, version)]
		return card, ok
	}
	var best ProviderRateCard
	found := false
	for _, card := range s.rateCards {
		if strings.ToLower(card.Provider) == p && strings.ToLower(card.ModelID) == m {
			if !found || card.VerifiedAt.After(best.VerifiedAt) {
				best = card
				found = true
			}
		}
	}
	return best, found
}

func (s *MemoryStore) getWorkspaceMutex(workspaceID string) *sync.Mutex {
	s.mu.Lock()
	defer s.mu.Unlock()
	m, ok := s.wsLocks[workspaceID]
	if !ok {
		m = &sync.Mutex{}
		s.wsLocks[workspaceID] = m
	}
	return m
}

func cloneWorkspaceState(src *WorkspaceBillingState) *WorkspaceBillingState {
	raw, err := json.Marshal(src)
	if err != nil {
		panic(err)
	}
	var dst WorkspaceBillingState
	if err := json.Unmarshal(raw, &dst); err != nil {
		panic(err)
	}
	if dst.Quotes == nil {
		dst.Quotes = make(map[string]tenantdb.CreditQuoteRow)
	}
	if dst.Reservations == nil {
		dst.Reservations = make(map[string]tenantdb.CreditReservationRow)
	}
	if dst.Allocations == nil {
		dst.Allocations = make(map[string][]tenantdb.CreditReservationAllocationRow)
	}
	if dst.ProcessedWebhooks == nil {
		dst.ProcessedWebhooks = make(map[string]time.Time)
	}
	if dst.ProcessedCycleClosures == nil {
		dst.ProcessedCycleClosures = make(map[string]CycleBoundaryResult)
	}
	if dst.CheckoutSessions == nil {
		dst.CheckoutSessions = make(map[string]*CheckoutSessionRecord)
	}
	if dst.EnabledPaymentMethodGates == nil {
		dst.EnabledPaymentMethodGates = make(map[string]bool)
	}
	return &dst
}

// WithWorkspaceTx executes fn under an exclusive per-workspace lock (matching SELECT ... FOR UPDATE on workspaces).
// If fn returns an error, all mutations to the workspace state are discarded (transactional rollback).
func (s *MemoryStore) WithWorkspaceTx(workspaceID string, fn func(state *WorkspaceBillingState) error) error {
	wsMu := s.getWorkspaceMutex(workspaceID)
	wsMu.Lock()
	defer wsMu.Unlock()

	s.mu.Lock()
	current, exists := s.workspaces[workspaceID]
	if !exists {
		current = &WorkspaceBillingState{
			WorkspaceID:            workspaceID,
			SubscriptionTier:       "free",
			SeatsUsed:              1,
			ChannelsUsed:           1,
			StorageUsedGB:          1,
			Quotes:                 make(map[string]tenantdb.CreditQuoteRow),
			Reservations:           make(map[string]tenantdb.CreditReservationRow),
			Allocations:            make(map[string][]tenantdb.CreditReservationAllocationRow),
			ProcessedWebhooks:      make(map[string]time.Time),
			ProcessedCycleClosures: make(map[string]CycleBoundaryResult),
			CheckoutSessions:       make(map[string]*CheckoutSessionRecord),
		}
		s.workspaces[workspaceID] = current
	}
	workingCopy := cloneWorkspaceState(current)
	s.mu.Unlock()

	if err := fn(workingCopy); err != nil {
		return err
	}

	s.mu.Lock()
	s.workspaces[workspaceID] = workingCopy
	s.mu.Unlock()
	return nil
}

// Engine executes cost-based quote creation, credit lot grants, reservation holds,
// commits, releases, expirations, late-result quarantines, refunds, and cycle boundaries.
type Engine struct {
	store *MemoryStore
}

// NewEngine creates a credit & billing Engine backed by store.
func NewEngine(store *MemoryStore) *Engine {
	return &Engine{store: store}
}

// Store returns the underlying MemoryStore.
func (e *Engine) Store() *MemoryStore {
	return e.store
}

// CreateQuote computes and persists a versioned cost-based CreditQuote in ai_credit_quotes (§26.2).
func (e *Engine) CreateQuote(in QuoteInput, now time.Time) (tenantdb.CreditQuoteRow, error) {
	if now.IsZero() {
		now = time.Now().UTC()
	}
	primaryCard, ok := e.store.LookupRateCard(in.Provider, in.ModelID, "")
	if !ok {
		return tenantdb.CreditQuoteRow{}, fmt.Errorf("%w: unknown provider/model %s/%s", ErrRateCardStaleOrDisabled, in.Provider, in.ModelID)
	}
	var fallbackCard *ProviderRateCard
	if strings.TrimSpace(in.FallbackProvider) != "" || strings.TrimSpace(in.FallbackModelID) != "" {
		fb, fbOK := e.store.LookupRateCard(in.FallbackProvider, in.FallbackModelID, "")
		if !fbOK {
			return tenantdb.CreditQuoteRow{}, fmt.Errorf("%w: unknown fallback provider/model %s/%s", ErrRateCardStaleOrDisabled, in.FallbackProvider, in.FallbackModelID)
		}
		fallbackCard = &fb
	}

	computed, err := ComputeCostBasedQuote(in, primaryCard, fallbackCard, now)
	if err != nil {
		return tenantdb.CreditQuoteRow{}, err
	}

	var saved tenantdb.CreditQuoteRow
	err = e.store.WithWorkspaceTx(in.WorkspaceID, func(st *WorkspaceBillingState) error {
		quoteID := e.store.nextUUID("20000000")
		saved = tenantdb.CreditQuoteRow{
			QuoteID:           quoteID,
			WorkspaceID:       in.WorkspaceID,
			RequestHash:       computed.RequestHash,
			OperationType:     computed.OperationType,
			RateVersion:       computed.RateVersion,
			ProviderPlanJSON:  computed.ProviderPlanJSON,
			CostCeilingUSD:    computed.CostCeilingUSD,
			USDPerCreditFloor: computed.USDPerCreditFloor,
			GrossMarginFloor:  computed.GrossMarginFloor,
			QuotedCredits:     computed.QuotedCredits,
			ExpiresAt:         computed.ExpiresAt,
			CreatedAt:         now.UTC(),
		}
		st.Quotes[quoteID] = saved
		return nil
	})
	return saved, err
}

// GrantLot grants a credit lot idempotently by (workspace_id, external_grant_key) (§26.3).
func (e *Engine) GrantLot(
	workspaceID, userID, sourceType string,
	credits tenantdb.ExactDecimal,
	expiresAt *time.Time,
	externalGrantKey, description string,
	now time.Time,
) (tenantdb.CreditLotRow, bool, error) {
	if now.IsZero() {
		now = time.Now().UTC()
	}
	if credits.IsNegative() || credits.IsZero() {
		return tenantdb.CreditLotRow{}, false, fmt.Errorf("%w: granted credits must be > 0", tenantdb.ErrInvalidDecimal)
	}
	if strings.TrimSpace(externalGrantKey) == "" {
		return tenantdb.CreditLotRow{}, false, fmt.Errorf("%w: external_grant_key is required", tenantdb.ErrInvalidDecimal)
	}
	if sourceType == SourcePurchased && expiresAt != nil {
		return tenantdb.CreditLotRow{}, false, fmt.Errorf("%w: purchased credit lots must have expires_at = NULL", tenantdb.ErrInvalidDecimal)
	}
	if sourceType == SourceSubscription && expiresAt == nil {
		return tenantdb.CreditLotRow{}, false, fmt.Errorf("%w: subscription credit lots must have non-null expires_at", tenantdb.ErrInvalidDecimal)
	}

	var resultLot tenantdb.CreditLotRow
	var created bool
	err := e.store.WithWorkspaceTx(workspaceID, func(st *WorkspaceBillingState) error {
		if sourceType == SourceOverage {
			tier, ok := LookupTier(st.SubscriptionTier)
			if !ok || !tier.OverageEligible {
				return ErrPlanFeatureNotAllowed
			}
		}
		for _, existing := range st.Lots {
			if existing.ExternalGrantKey == externalGrantKey {
				resultLot = existing
				created = false
				return nil
			}
		}

		lotID := e.store.nextUUID("30000000")
		lot := tenantdb.CreditLotRow{
			LotID:            lotID,
			WorkspaceID:      workspaceID,
			SourceType:       sourceType,
			GrantedCredits:   credits,
			RemainingCredits: credits,
			ReservedCredits:  tenantdb.ZeroDecimal(),
			ExpiresAt:        expiresAt,
			ExternalGrantKey: externalGrantKey,
			CreatedAt:        now.UTC(),
		}
		st.Lots = append(st.Lots, lot)
		sortLotsInConsumptionOrder(st.Lots)

		bal := computeBalanceFromState(st, now)
		opType := "credit_grant"
		if sourceType == SourcePurchased {
			opType = "credit_purchase"
		} else if sourceType == SourceSubscription {
			opType = "subscription_allocation"
		}
		txRow := tenantdb.CreditTransactionRow{
			TransactionID:  e.store.nextUUID("40000000"),
			WorkspaceID:    workspaceID,
			UserID:         userID,
			OperationType:  opType,
			CreditsDelta:   credits,
			BalanceAfter:   bal.Available,
			Source:         sourceType,
			LotID:          lotID,
			IdempotencyKey: "grant:" + externalGrantKey,
			Description:    description,
			CreatedAt:      now.UTC(),
		}
		st.Transactions = append([]tenantdb.CreditTransactionRow{txRow}, st.Transactions...)
		resultLot = lot
		created = true
		return nil
	})
	return resultLot, created, err
}

func computeBalanceFromState(st *WorkspaceBillingState, now time.Time) BalanceSnapshot {
	totalRem := tenantdb.ZeroDecimal()
	totalRes := tenantdb.ZeroDecimal()
	totalAvail := tenantdb.ZeroDecimal()
	subRem := tenantdb.ZeroDecimal()
	purRem := tenantdb.ZeroDecimal()
	promoRem := tenantdb.ZeroDecimal()
	overRem := tenantdb.ZeroDecimal()
	var activeLots []tenantdb.CreditLotRow

	for _, lot := range st.Lots {
		isExpired := lot.ExpiresAt != nil && !lot.ExpiresAt.After(now)
		//Reserved credits on an in-flight lot are still tracked in Reserved even if the lot timestamp passed during flight.
		totalRes, _ = totalRes.Add(lot.ReservedCredits)

		if isExpired {
			// An expired lot contributes 0 to available credits; only its in-flight reserved amount remains until resolution.
			if !lot.ReservedCredits.IsZero() {
				totalRem, _ = totalRem.Add(lot.ReservedCredits)
				activeLots = append(activeLots, lot)
			}
			continue
		}

		lotAvail, err := lot.RemainingCredits.Sub(lot.ReservedCredits)
		if err != nil || lotAvail.IsNegative() {
			lotAvail = tenantdb.ZeroDecimal()
		}
		totalRem, _ = totalRem.Add(lot.RemainingCredits)
		totalAvail, _ = totalAvail.Add(lotAvail)

		switch lot.SourceType {
		case SourceSubscription:
			subRem, _ = subRem.Add(lotAvail)
		case SourcePurchased:
			purRem, _ = purRem.Add(lotAvail)
		case SourcePromotional:
			promoRem, _ = promoRem.Add(lotAvail)
		case SourceOverage:
			overRem, _ = overRem.Add(lotAvail)
		}
		if !lot.RemainingCredits.IsZero() || !lot.ReservedCredits.IsZero() {
			activeLots = append(activeLots, lot)
		}
	}

	var nextAlloc *time.Time
	if st.Subscription != nil && !st.Subscription.CurrentPeriodEnd.IsZero() {
		t := st.Subscription.CurrentPeriodEnd
		nextAlloc = &t
	}
	tier := st.SubscriptionTier
	if tier == "" {
		tier = "free"
	}

	return BalanceSnapshot{
		TotalRemaining:        totalRem,
		Reserved:              totalRes,
		Available:             totalAvail,
		SubscriptionRemaining: subRem,
		PurchasedRemaining:    purRem,
		PromotionalRemaining:  promoRem,
		OverageRemaining:      overRem,
		NextAllocationAt:      nextAlloc,
		SubscriptionTier:      tier,
		ActiveLots:            activeLots,
	}
}

// GetBalance computes the canonical CreditBalance projection for workspaceID.
func (e *Engine) GetBalance(workspaceID string, now time.Time) (BalanceSnapshot, error) {
	if now.IsZero() {
		now = time.Now().UTC()
	}
	var snap BalanceSnapshot
	err := e.store.WithWorkspaceTx(workspaceID, func(st *WorkspaceBillingState) error {
		snap = computeBalanceFromState(st, now)
		return nil
	})
	return snap, err
}

// Reserve places an atomic credit hold across eligible lots in consumption priority order (§2 & §3).
// Enforces:
//   - Concurrent holds cannot overspend (serialized per workspace via WithWorkspaceTx / FOR UPDATE)
//   - Quote expiry (5m), request_hash match, and confirmed_credits match
//   - Max 5 active reservations per workspace
//   - No debit transaction row at reserve time (remaining_credits unchanged; reserved_credits incremented)
func (e *Engine) Reserve(req ReserveRequest) (ReserveResult, error) {
	now := req.Now
	if now.IsZero() {
		now = time.Now().UTC()
	}
	if strings.TrimSpace(req.IdempotencyKey) == "" {
		return ReserveResult{}, fmt.Errorf("%w: idempotency_key is required", ErrQuoteInvalidOrExpired)
	}

	var out ReserveResult
	err := e.store.WithWorkspaceTx(req.WorkspaceID, func(st *WorkspaceBillingState) error {
		// 1. Check idempotency key first.
		for _, existing := range st.Reservations {
			if existing.IdempotencyKey == req.IdempotencyKey {
				if existing.RequestHash != req.RequestHash || existing.QuoteID != req.QuoteID {
					return fmt.Errorf("%w: idempotency_key %q reused with different quote or request_hash", ErrQuoteInvalidOrExpired, req.IdempotencyKey)
				}
				out = ReserveResult{
					Reservation: existing,
					Allocations: append([]tenantdb.CreditReservationAllocationRow{}, st.Allocations[existing.ReservationID]...),
					Replayed:    true,
				}
				return nil
			}
		}

		// 1b. Enforce read-only / quarantine / soft-delete / hard-delete access gate:
		// During dunning grace (Day 7–14), subscription pause, or post-cancellation quarantine/soft-delete,
		// credit spending is blocked while purchased credit lots are preserved intact (Acceptance Target #2).
		if st.ReadOnlyMode || st.RetentionPhase == "phase_2_soft_delete" || st.RetentionPhase == "phase_3_hard_deleted" {
			return ErrWorkspaceReadOnlyOrSuspended
		}

		// 2. Validate quote existence, expiry, request_hash, and confirmed_credits.
		quote, ok := st.Quotes[req.QuoteID]
		if !ok {
			return fmt.Errorf("%w: quote %q not found in workspace", ErrQuoteInvalidOrExpired, req.QuoteID)
		}
		if !quote.ExpiresAt.After(now) {
			return fmt.Errorf("%w: quote %q expired at %s", ErrQuoteInvalidOrExpired, req.QuoteID, quote.ExpiresAt.Format(time.RFC3339))
		}
		if quote.RequestHash != req.RequestHash {
			return fmt.Errorf("%w: request_hash mismatch for quote %q", ErrQuoteInvalidOrExpired, req.QuoteID)
		}
		if req.ConfirmedCredits.Cmp(quote.QuotedCredits) < 0 {
			return fmt.Errorf("%w: confirmed_credits (%s) is less than quoted_credits (%s)", ErrQuoteInvalidOrExpired, req.ConfirmedCredits.String(), quote.QuotedCredits.String())
		}

		// 3. Enforce max 5 active reservations per workspace.
		activeCount := 0
		for _, r := range st.Reservations {
			if r.Status == ReservationHeld || r.Status == ReservationInFlight || r.Status == ReservationReconciling {
				activeCount++
			}
		}
		if activeCount >= MaxActiveReservationsPerWorkspace {
			return ErrMaxActiveReservations
		}

		// 4. Sort lots in canonical consumption order and allocate from non-expired lots.
		sortLotsInConsumptionOrder(st.Lots)
		needed := quote.QuotedCredits

		resID := req.ReservationID
		if strings.TrimSpace(resID) == "" {
			resID = e.store.nextUUID("50000000")
		}

		var allocations []tenantdb.CreditReservationAllocationRow
		for idx := range st.Lots {
			if needed.IsZero() {
				break
			}
			lot := &st.Lots[idx]
			if lot.ExpiresAt != nil && !lot.ExpiresAt.After(now) {
				continue
			}
			if lot.SourceType == SourceOverage {
				tier, ok := LookupTier(st.SubscriptionTier)
				if !ok || !tier.OverageEligible {
					continue
				}
			}
			avail, err := lot.RemainingCredits.Sub(lot.ReservedCredits)
			if err != nil || avail.IsNegative() || avail.IsZero() {
				continue
			}
			take := avail
			if take.Cmp(needed) > 0 {
				take = needed
			}
			newRes, err := lot.ReservedCredits.Add(take)
			if err != nil {
				return err
			}
			lot.ReservedCredits = newRes
			needed, err = needed.Sub(take)
			if err != nil {
				return err
			}
			allocations = append(allocations, tenantdb.CreditReservationAllocationRow{
				AllocationID:  e.store.nextUUID("60000000"),
				WorkspaceID:   req.WorkspaceID,
				ReservationID: resID,
				LotID:         lot.LotID,
				Credits:       take,
			})
		}

		if !needed.IsZero() {
			// Check if Business/Enterprise authorized overage (BIZ-002: up to 110% of monthly allocation
			// when valid payment method is on file AND overage terms are accepted) can cover the remainder.
			tier, ok := LookupTier(st.SubscriptionTier)
			if ok && tier.OverageEligible && st.OverageTermsAccepted && len(st.PaymentMethods) > 0 {
				maxOverage, err := tier.MonthlyCredits.Mul(tenantdb.MustParseExactDecimal("0.10"))
				if err == nil {
					candidateOverage, err := st.OverageUsedCredits.Add(needed)
					if err == nil && candidateOverage.Cmp(maxOverage) <= 0 {
						overageLotID := e.store.nextUUID("39000000")
						overageLot := tenantdb.CreditLotRow{
							LotID:            overageLotID,
							WorkspaceID:      req.WorkspaceID,
							SourceType:       SourceOverage,
							GrantedCredits:   needed,
							RemainingCredits: needed,
							ReservedCredits:  needed,
							ExpiresAt:        nil,
							ExternalGrantKey: "overage:" + resID,
							CreatedAt:        now.UTC(),
						}
						st.Lots = append(st.Lots, overageLot)
						st.OverageUsedCredits = candidateOverage
						allocations = append(allocations, tenantdb.CreditReservationAllocationRow{
							AllocationID:  e.store.nextUUID("60000000"),
							WorkspaceID:   req.WorkspaceID,
							ReservationID: resID,
							LotID:         overageLotID,
							Credits:       needed,
						})
						needed = tenantdb.ZeroDecimal()
					}
				}
			}
			if !needed.IsZero() {
				return ErrInsufficientCredits
			}
		}

		resRow := tenantdb.CreditReservationRow{
			ReservationID:   resID,
			WorkspaceID:     req.WorkspaceID,
			QuoteID:         req.QuoteID,
			IdempotencyKey:  req.IdempotencyKey,
			RequestHash:     req.RequestHash,
			Status:          ReservationHeld,
			ReservedCredits: quote.QuotedCredits,
			ExpiresAt:       now.UTC().Add(ReservationHoldTTL),
			CreatedAt:       now.UTC(),
			UpdatedAt:       now.UTC(),
		}
		st.Reservations[resID] = resRow
		st.Allocations[resID] = allocations

		st.OutboxEvents = append(st.OutboxEvents, EmittedEvent{
			EventType:      EventAIGenerationDispatch,
			WorkspaceID:    req.WorkspaceID,
			AggregateType:  "credit_reservation",
			AggregateID:    resID,
			IdempotencyKey: "dispatch:" + resID,
			Payload: map[string]any{
				"reservation_id":   resID,
				"quote_id":         req.QuoteID,
				"reserved_credits": quote.QuotedCredits.String(),
			},
			CreatedAt: now.UTC(),
		})

		out = ReserveResult{
			Reservation: resRow,
			Allocations: allocations,
			Replayed:    false,
		}
		return nil
	})
	return out, err
}

// MarkInFlight atomically claims a held reservation before provider submission (held -> in_flight).
func (e *Engine) MarkInFlight(workspaceID, reservationID, providerRequestID string, now time.Time) (tenantdb.CreditReservationRow, error) {
	if now.IsZero() {
		now = time.Now().UTC()
	}
	var updated tenantdb.CreditReservationRow
	err := e.store.WithWorkspaceTx(workspaceID, func(st *WorkspaceBillingState) error {
		res, ok := st.Reservations[reservationID]
		if !ok {
			return fmt.Errorf("%w: reservation %q not found", ErrReservationInvalidTransition, reservationID)
		}
		if res.Status == ReservationInFlight && res.ProviderRequestID == providerRequestID {
			updated = res
			return nil
		}
		if res.Status != ReservationHeld {
			return fmt.Errorf("%w: cannot mark reservation %q in_flight from status %q", ErrReservationInvalidTransition, reservationID, res.Status)
		}
		if !res.ExpiresAt.After(now) {
			return fmt.Errorf("%w: held reservation %q expired at %s before provider submit", ErrReservationInvalidTransition, reservationID, res.ExpiresAt.Format(time.RFC3339))
		}
		hb := now.UTC()
		res.Status = ReservationInFlight
		res.LastHeartbeatAt = &hb
		res.ProviderRequestID = providerRequestID
		res.UpdatedAt = hb
		st.Reservations[reservationID] = res
		updated = res
		return nil
	})
	return updated, err
}

// MarkReconciling transitions an in_flight reservation with an unknown provider outcome to reconciling,
// preserving all source lot holds until provider status is reconciled (§3).
func (e *Engine) MarkReconciling(workspaceID, reservationID, reason string, now time.Time) (tenantdb.CreditReservationRow, error) {
	if now.IsZero() {
		now = time.Now().UTC()
	}
	var updated tenantdb.CreditReservationRow
	err := e.store.WithWorkspaceTx(workspaceID, func(st *WorkspaceBillingState) error {
		res, ok := st.Reservations[reservationID]
		if !ok {
			return fmt.Errorf("%w: reservation %q not found", ErrReservationInvalidTransition, reservationID)
		}
		if res.Status == ReservationReconciling {
			updated = res
			return nil
		}
		if res.Status != ReservationInFlight {
			return fmt.Errorf("%w: cannot transition %q from %s to reconciling", ErrReservationInvalidTransition, reservationID, res.Status)
		}
		res.Status = ReservationReconciling
		res.TerminalReason = reason
		res.UpdatedAt = now.UTC()
		st.Reservations[reservationID] = res
		updated = res
		return nil
	})
	return updated, err
}

// Commit settles an in_flight or reconciling reservation using the quote's rate card version
// and measured units, capped at the confirmed quote (reserved_credits).
// Enforces Acceptance Target #3:
//   - Bounded retries/fallbacks included in the quote plan cannot charge above reserved_credits.
//   - Any attempt beyond the bounded quote plan (unquoted model or attempt count > max_provider_attempts)
//     fails closed with ErrPaidRetryExceedsQuote (BILLING_CONFLICT_002).
func (e *Engine) Commit(req CommitRequest) (CommitResult, error) {
	now := req.Now
	if now.IsZero() {
		now = time.Now().UTC()
	}
	var out CommitResult
	err := e.store.WithWorkspaceTx(req.WorkspaceID, func(st *WorkspaceBillingState) error {
		res, ok := st.Reservations[req.ReservationID]
		if !ok {
			return fmt.Errorf("%w: reservation %q not found", ErrReservationInvalidTransition, req.ReservationID)
		}
		if res.Status == ReservationCommitted {
			out = CommitResult{
				Reservation:  res,
				ActualCharge: *res.ActualCredits,
				Replayed:     true,
			}
			return nil
		}
		if res.Status == ReservationReleased || res.Status == ReservationExpired {
			// Acceptance Target #2: Late result after release/expiry MUST NOT debit customer credits!
			st.LateResultReports = append(st.LateResultReports, LateResultReport{
				WorkspaceID:       req.WorkspaceID,
				ReservationID:     req.ReservationID,
				ProviderRequestID: req.ProviderRequestID,
				ReservationStatus: res.Status,
				Quarantined:       true,
				CustomerDebited:   tenantdb.ZeroDecimal(),
				PlatformLossNote:  fmt.Sprintf("late completion arrived after reservation status=%s; output quarantined and zero credits debited", res.Status),
				RecordedAt:        now.UTC(),
			})
			return ErrLateResultAfterTerminalState
		}
		if res.Status != ReservationInFlight && res.Status != ReservationReconciling {
			return fmt.Errorf("%w: cannot commit reservation %q from status %q", ErrReservationInvalidTransition, req.ReservationID, res.Status)
		}

		quote, ok := st.Quotes[res.QuoteID]
		if !ok {
			return fmt.Errorf("%w: quote %q missing for reservation %q", ErrQuoteInvalidOrExpired, res.QuoteID, req.ReservationID)
		}
		var plan ProviderPlanSnapshot
		if err := json.Unmarshal(quote.ProviderPlanJSON, &plan); err != nil {
			return fmt.Errorf("%w: invalid provider_plan on quote %q", ErrQuoteInvalidOrExpired, res.QuoteID)
		}

		// Verify executed provider/model and attempt count are within the bounded quote plan.
		attempts := req.ProviderAttemptCount
		if attempts <= 0 {
			attempts = 1
		}
		if attempts > plan.MaxProviderAttempts {
			return fmt.Errorf("%w: executed %d provider attempts but quote %q bounded max_provider_attempts=%d", ErrPaidRetryExceedsQuote, attempts, quote.QuoteID, plan.MaxProviderAttempts)
		}

		execProv := strings.ToLower(strings.TrimSpace(req.ExecutedProvider))
		execModel := strings.ToLower(strings.TrimSpace(req.ExecutedModelID))
		if execProv == "" {
			execProv = strings.ToLower(plan.PrimaryProvider)
		}
		if execModel == "" {
			execModel = strings.ToLower(plan.PrimaryModelID)
		}

		var rateCard ProviderRateCard
		var cardOK bool
		switch {
		case execProv == strings.ToLower(plan.PrimaryProvider) && execModel == strings.ToLower(plan.PrimaryModelID):
			rateCard, cardOK = e.store.LookupRateCard(plan.PrimaryProvider, plan.PrimaryModelID, plan.PrimaryRateVersion)
		case plan.FallbackProvider != "" && execProv == strings.ToLower(plan.FallbackProvider) && execModel == strings.ToLower(plan.FallbackModelID):
			rateCard, cardOK = e.store.LookupRateCard(plan.FallbackProvider, plan.FallbackModelID, plan.FallbackRateVersion)
		default:
			return fmt.Errorf("%w: executed provider/model %s/%s was not authorized in quote %q", ErrPaidRetryExceedsQuote, execProv, execModel, quote.QuoteID)
		}
		if !cardOK {
			return fmt.Errorf("%w: rate card version %s not found for %s/%s", ErrRateCardStaleOrDisabled, quote.RateVersion, execProv, execModel)
		}

		units := req.MeasuredUnits
		if len(units) == 0 {
			units = plan.MeasuredUnits
		}
		singleAttemptCostUSD, err := ComputeAttemptCostUSD(rateCard, units)
		if err != nil {
			return err
		}
		// Customer credits are priced from the single fulfilled attempt's measured units using the same
		// quote floor & margin parameters, and strictly capped at res.ReservedCredits (confirmed quote).
		measuredCredits, err := tenantdb.ComputeQuotedCredits(singleAttemptCostUSD, quote.USDPerCreditFloor, quote.GrossMarginFloor)
		if err != nil {
			return err
		}
		actualCredits := measuredCredits
		if actualCredits.Cmp(res.ReservedCredits) > 0 {
			actualCredits = res.ReservedCredits
		}

		// Consume allocated lots in canonical priority order up to actualCredits.
		allocs := st.Allocations[res.ReservationID]
		remainingToDebit := actualCredits
		var appendedTxs []tenantdb.CreditTransactionRow

		for _, alloc := range allocs {
			for idx := range st.Lots {
				if st.Lots[idx].LotID != alloc.LotID {
					continue
				}
				lot := &st.Lots[idx]

				consumed := alloc.Credits
				if consumed.Cmp(remainingToDebit) > 0 {
					consumed = remainingToDebit
				}
				unusedFromAlloc, err := alloc.Credits.Sub(consumed)
				if err != nil {
					return err
				}

				// Release full allocation hold from lot.ReservedCredits.
				newReserved, err := lot.ReservedCredits.Sub(alloc.Credits)
				if err != nil {
					return err
				}
				lot.ReservedCredits = newReserved

				// Deduct consumed credits from lot.RemainingCredits.
				newRemaining, err := lot.RemainingCredits.Sub(consumed)
				if err != nil {
					return err
				}
				lot.RemainingCredits = newRemaining

				remainingToDebit, err = remainingToDebit.Sub(consumed)
				if err != nil {
					return err
				}

				if !consumed.IsZero() {
					negDelta, _ := tenantdb.ZeroDecimal().Sub(consumed)
					balAfter := computeBalanceFromState(st, now).Available
					costCopy := singleAttemptCostUSD
					txRow := tenantdb.CreditTransactionRow{
						TransactionID:   e.store.nextUUID("70000000"),
						WorkspaceID:     req.WorkspaceID,
						UserID:          req.UserID,
						OperationType:   quote.OperationType,
						CreditsDelta:    negDelta,
						BalanceAfter:    balAfter,
						Source:          lot.SourceType,
						ReservationID:   res.ReservationID,
						LotID:           lot.LotID,
						QuoteID:         quote.QuoteID,
						ProviderCostUSD: &costCopy,
						RateVersion:     rateCard.Version,
						IdempotencyKey:  fmt.Sprintf("debit:%s:%s", res.ReservationID, lot.LotID),
						Description:     fmt.Sprintf("Committed %s credits from %s lot", consumed.String(), lot.SourceType),
						CreatedAt:       now.UTC(),
					}
					st.Transactions = append([]tenantdb.CreditTransactionRow{txRow}, st.Transactions...)
					appendedTxs = append(appendedTxs, txRow)
				}

				// Acceptance Target #2: If this lot expired while the reservation was in_flight,
				// any unused remainder from this allocation MUST expire immediately rather than
				// becoming available current-cycle or purchased credit!
				if !unusedFromAlloc.IsZero() && lot.ExpiresAt != nil && !lot.ExpiresAt.After(now) {
					afterExp, err := lot.RemainingCredits.Sub(unusedFromAlloc)
					if err != nil {
						return err
					}
					lot.RemainingCredits = afterExp
					negExp, _ := tenantdb.ZeroDecimal().Sub(unusedFromAlloc)
					balAfter := computeBalanceFromState(st, now).Available
					expTx := tenantdb.CreditTransactionRow{
						TransactionID:  e.store.nextUUID("71000000"),
						WorkspaceID:    req.WorkspaceID,
						OperationType:  "credit_expiration",
						CreditsDelta:   negExp,
						BalanceAfter:   balAfter,
						Source:         lot.SourceType,
						ReservationID:  res.ReservationID,
						LotID:          lot.LotID,
						IdempotencyKey: fmt.Sprintf("expire_unused:%s:%s", res.ReservationID, lot.LotID),
						Description:    "Unused held remainder on expired source lot expired upon in-flight commit",
						CreatedAt:      now.UTC(),
					}
					st.Transactions = append([]tenantdb.CreditTransactionRow{expTx}, st.Transactions...)
				}
				break
			}
		}

		actCopy := actualCredits
		res.Status = ReservationCommitted
		res.ActualCredits = &actCopy
		if req.ProviderRequestID != "" {
			res.ProviderRequestID = req.ProviderRequestID
		}
		res.UpdatedAt = now.UTC()
		st.Reservations[res.ReservationID] = res

		// Emit credits.deducted and low/exhausted warnings if thresholds crossed.
		bal := computeBalanceFromState(st, now)
		st.OutboxEvents = append(st.OutboxEvents, EmittedEvent{
			EventType:      EventCreditsDeducted,
			WorkspaceID:    req.WorkspaceID,
			AggregateType:  "credit_reservation",
			AggregateID:    res.ReservationID,
			IdempotencyKey: "evt:deducted:" + res.ReservationID,
			Payload: map[string]any{
				"reservation_id":    res.ReservationID,
				"quote_id":          res.QuoteID,
				"actual_credits":    actualCredits.String(),
				"available_credits": bal.Available.String(),
			},
			CreatedAt: now.UTC(),
		})
		if bal.Available.IsZero() {
			st.OutboxEvents = append(st.OutboxEvents, EmittedEvent{
				EventType:      EventCreditsExhausted,
				WorkspaceID:    req.WorkspaceID,
				AggregateType:  "workspace",
				AggregateID:    req.WorkspaceID,
				IdempotencyKey: "evt:exhausted:" + res.ReservationID,
				Payload:        map[string]any{"available_credits": "0"},
				CreatedAt:      now.UTC(),
			})
		} else if tier, ok := LookupTier(st.SubscriptionTier); ok && !tier.MonthlyCredits.IsZero() {
			threshold20, _ := tier.MonthlyCredits.MulFloor(tenantdb.MustParseExactDecimal("0.200000"))
			if bal.Available.Cmp(threshold20) < 0 {
				st.OutboxEvents = append(st.OutboxEvents, EmittedEvent{
					EventType:      EventCreditsLowWarning,
					WorkspaceID:    req.WorkspaceID,
					AggregateType:  "workspace",
					AggregateID:    req.WorkspaceID,
					IdempotencyKey: "evt:low_warning:" + res.ReservationID,
					Payload:        map[string]any{"available_credits": bal.Available.String()},
					CreatedAt:      now.UTC(),
				})
			}
		}

		out = CommitResult{
			Reservation:  res,
			ActualCharge: actualCredits,
			Transactions: appendedTxs,
			Replayed:     false,
		}
		return nil
	})
	return out, err
}

// Release releases a held, in_flight, or reconciling reservation upon definitive failure or cancellation (§3).
// If the reservation's source lot expired while the job was in_flight, the released amount on that expired lot
// expires immediately rather than becoming current-cycle or purchased credit.
func (e *Engine) Release(workspaceID, reservationID, reason string, now time.Time) (tenantdb.CreditReservationRow, error) {
	if now.IsZero() {
		now = time.Now().UTC()
	}
	var out tenantdb.CreditReservationRow
	err := e.store.WithWorkspaceTx(workspaceID, func(st *WorkspaceBillingState) error {
		res, ok := st.Reservations[reservationID]
		if !ok {
			return fmt.Errorf("%w: reservation %q not found", ErrReservationInvalidTransition, reservationID)
		}
		if res.Status == ReservationReleased {
			out = res
			return nil
		}
		if res.Status == ReservationCommitted || res.Status == ReservationExpired {
			return fmt.Errorf("%w: cannot release reservation %q in terminal status %q", ErrReservationInvalidTransition, reservationID, res.Status)
		}

		if err := releaseAllocationsOnState(st, res, "release", now); err != nil {
			return err
		}
		res.Status = ReservationReleased
		res.TerminalReason = reason
		res.UpdatedAt = now.UTC()
		st.Reservations[reservationID] = res
		out = res
		return nil
	})
	return out, err
}

func releaseAllocationsOnState(st *WorkspaceBillingState, res tenantdb.CreditReservationRow, prefix string, now time.Time) error {
	allocs := st.Allocations[res.ReservationID]
	for _, alloc := range allocs {
		for idx := range st.Lots {
			if st.Lots[idx].LotID != alloc.LotID {
				continue
			}
			lot := &st.Lots[idx]
			newReserved, err := lot.ReservedCredits.Sub(alloc.Credits)
			if err != nil {
				return err
			}
			lot.ReservedCredits = newReserved

			// If the source lot expired while the reservation was held/in_flight, expire the released
			// remainder so it never inflates current-cycle or purchased credits (Acceptance Target #2).
			if lot.ExpiresAt != nil && !lot.ExpiresAt.After(now) {
				newRem, err := lot.RemainingCredits.Sub(alloc.Credits)
				if err != nil {
					return err
				}
				lot.RemainingCredits = newRem
				negExp, _ := tenantdb.ZeroDecimal().Sub(alloc.Credits)
				balAfter := computeBalanceFromState(st, now).Available
				expTx := tenantdb.CreditTransactionRow{
					TransactionID:  fmt.Sprintf("72000000-0000-4000-8000-%012d", len(st.Transactions)+1),
					WorkspaceID:    st.WorkspaceID,
					OperationType:  "credit_expiration",
					CreditsDelta:   negExp,
					BalanceAfter:   balAfter,
					Source:         lot.SourceType,
					ReservationID:  res.ReservationID,
					LotID:          lot.LotID,
					IdempotencyKey: fmt.Sprintf("expire_%s:%s:%s", prefix, res.ReservationID, lot.LotID),
					Description:    "Released hold on expired source lot expired immediately",
					CreatedAt:      now.UTC(),
				}
				st.Transactions = append([]tenantdb.CreditTransactionRow{expTx}, st.Transactions...)
			}
			break
		}
	}
	return nil
}

// SweepExpiredHeld expires ONLY 'held' reservations whose 30-minute hold TTL has passed
// without provider submission. In-flight and reconciling reservations are NEVER expired by TTL (§3).
func (e *Engine) SweepExpiredHeld(workspaceID string, now time.Time) (int, error) {
	if now.IsZero() {
		now = time.Now().UTC()
	}
	expiredCount := 0
	err := e.store.WithWorkspaceTx(workspaceID, func(st *WorkspaceBillingState) error {
		for id, res := range st.Reservations {
			if res.Status == ReservationHeld && !res.ExpiresAt.After(now) {
				if err := releaseAllocationsOnState(st, res, "sweep", now); err != nil {
					return err
				}
				res.Status = ReservationExpired
				res.TerminalReason = "hold_ttl_expired_before_provider_submit"
				res.UpdatedAt = now.UTC()
				st.Reservations[id] = res
				expiredCount++
			}
		}
		return nil
	})
	return expiredCount, err
}

// HandleLateResult handles a late provider result arriving for a reservation (Acceptance Target #2).
// If the reservation is already released or expired, it quarantines the output, records a platform-loss
// diagnostic report, and leaves all credit lots and customer ledger balances completely untouched.
func (e *Engine) HandleLateResult(workspaceID, reservationID, providerRequestID string, now time.Time) (LateResultReport, error) {
	if now.IsZero() {
		now = time.Now().UTC()
	}
	var report LateResultReport
	err := e.store.WithWorkspaceTx(workspaceID, func(st *WorkspaceBillingState) error {
		res, ok := st.Reservations[reservationID]
		if !ok {
			return fmt.Errorf("%w: reservation %q not found", ErrReservationInvalidTransition, reservationID)
		}
		if res.Status != ReservationReleased && res.Status != ReservationExpired {
			return fmt.Errorf("%w: reservation %q is in status %q, not terminal released/expired", ErrReservationInvalidTransition, reservationID, res.Status)
		}
		report = LateResultReport{
			WorkspaceID:       workspaceID,
			ReservationID:     reservationID,
			ProviderRequestID: providerRequestID,
			ReservationStatus: res.Status,
			Quarantined:       true,
			CustomerDebited:   tenantdb.ZeroDecimal(),
			PlatformLossNote:  fmt.Sprintf("late provider result for %s after status=%s; output quarantined, zero customer debit", reservationID, res.Status),
			RecordedAt:        now.UTC(),
		}
		st.LateResultReports = append(st.LateResultReports, report)
		return nil
	})
	return report, err
}

// RefundTransaction appends a compensating positive transaction referencing an original debit transaction
// and restores credits to the source lot (never mutating the original debit row, §4).
func (e *Engine) RefundTransaction(workspaceID, userID, originalTransactionID, reason string, now time.Time) (tenantdb.CreditTransactionRow, error) {
	if now.IsZero() {
		now = time.Now().UTC()
	}
	var refundTx tenantdb.CreditTransactionRow
	err := e.store.WithWorkspaceTx(workspaceID, func(st *WorkspaceBillingState) error {
		idempKey := "refund:" + originalTransactionID
		for _, tx := range st.Transactions {
			if tx.IdempotencyKey == idempKey {
				refundTx = tx
				return nil
			}
		}

		var orig *tenantdb.CreditTransactionRow
		for i := range st.Transactions {
			if st.Transactions[i].TransactionID == originalTransactionID {
				orig = &st.Transactions[i]
				break
			}
		}
		if orig == nil {
			return fmt.Errorf("billing: original transaction %q not found", originalTransactionID)
		}
		if !orig.CreditsDelta.IsNegative() {
			return fmt.Errorf("billing: transaction %q is not a debit entry", originalTransactionID)
		}

		positiveRefund, err := tenantdb.ZeroDecimal().Sub(orig.CreditsDelta)
		if err != nil {
			return err
		}

		for idx := range st.Lots {
			if st.Lots[idx].LotID == orig.LotID {
				restored, err := st.Lots[idx].RemainingCredits.Add(positiveRefund)
				if err != nil {
					return err
				}
				st.Lots[idx].RemainingCredits = restored
				break
			}
		}

		balAfter := computeBalanceFromState(st, now).Available
		refundTx = tenantdb.CreditTransactionRow{
			TransactionID:          e.store.nextUUID("80000000"),
			WorkspaceID:            workspaceID,
			UserID:                 userID,
			OperationType:          "credit_refund",
			CreditsDelta:           positiveRefund,
			BalanceAfter:           balAfter,
			Source:                 orig.Source,
			ReservationID:          orig.ReservationID,
			LotID:                  orig.LotID,
			QuoteID:                orig.QuoteID,
			ReferenceTransactionID: orig.TransactionID,
			IdempotencyKey:         idempKey,
			Description:            reason,
			CreatedAt:              now.UTC(),
		}
		st.Transactions = append([]tenantdb.CreditTransactionRow{refundTx}, st.Transactions...)
		return nil
	})
	return refundTx, err
}

// RunCycleBoundary executes the atomic billing cycle boundary / monthly reset (§4 & Acceptance Target #2):
//  1. Sweeps expired 'held' reservations while keeping 'in_flight'/'reconciling' holds bound to their source lots.
//  2. Preserves all 'purchased' credit lots untouched (expires_at IS NULL).
//  3. Computes 20% rollover once on unspent primary subscription credits for Pro/Business (0% for Free/Starter).
//  4. Expires unheld remaining credits on expired subscription/promotional lots (leaving any in-flight reserved amount
//     on the expired lot until that reservation resolves).
//  5. Grants the new period's subscription lot idempotently via external_grant_key = sub_alloc:<sub_id>:<period>.
func (e *Engine) RunCycleBoundary(req CycleBoundaryRequest) (CycleBoundaryResult, error) {
	now := req.Now
	if now.IsZero() {
		now = time.Now().UTC()
	}
	var out CycleBoundaryResult
	err := e.store.WithWorkspaceTx(req.WorkspaceID, func(st *WorkspaceBillingState) error {
		res, _, _, err := processCycleBoundaryOnState(e.store, st, req.WorkspaceID, req.SubscriptionID, req.PeriodKey, req.NextPeriodEnd, now)
		if err != nil {
			return err
		}
		out = res
		return nil
	})
	return out, err
}

func processCycleBoundaryOnState(
	store *MemoryStore,
	st *WorkspaceBillingState,
	workspaceID, subID, periodKey string,
	nextPeriodEnd, now time.Time,
) (CycleBoundaryResult, *tenantdb.CreditLotRow, bool, error) {
	tierCode := st.SubscriptionTier
	if st.Subscription != nil && st.Subscription.Plan != "" && st.Subscription.Status == "active" {
		tierCode = st.Subscription.Plan
	}
	tierSpec, ok := LookupTier(tierCode)
	if !ok {
		tierSpec, _ = LookupTier("free")
	}
	subID = strings.TrimSpace(subID)
	if subID == "" && st.Subscription != nil && st.Subscription.SubscriptionID != "" {
		subID = st.Subscription.SubscriptionID
	}
	if subID == "" {
		subID = "default_sub"
	}
	cycleKey := fmt.Sprintf("%s:%s", subID, periodKey)
	allocGrantKey := fmt.Sprintf("sub_alloc:%s:%s", subID, periodKey)
	rolloverGrantKey := fmt.Sprintf("rollover:%s:%s", subID, periodKey)

	nextExp := nextPeriodEnd.UTC()
	if nextExp.IsZero() {
		nextExp = now.UTC().Add(30 * 24 * time.Hour)
	}

	findLotByKey := func(grantKey string) *tenantdb.CreditLotRow {
		for i := range st.Lots {
			if st.Lots[i].ExternalGrantKey == grantKey {
				cp := st.Lots[i]
				return &cp
			}
		}
		return nil
	}

	hasTxByKey := func(idempKey string) bool {
		for i := range st.Transactions {
			if st.Transactions[i].IdempotencyKey == idempKey {
				return true
			}
		}
		return false
	}

	if st.ProcessedCycleClosures == nil {
		st.ProcessedCycleClosures = make(map[string]CycleBoundaryResult)
	}
	prevClosure, cycleAlreadyClosed := st.ProcessedCycleClosures[cycleKey]
	existingAllocLot := findLotByKey(allocGrantKey)

	if cycleAlreadyClosed && existingAllocLot != nil {
		purchasedPreserved := tenantdb.ZeroDecimal()
		inFlightHeld := tenantdb.ZeroDecimal()
		for _, l := range st.Lots {
			if l.SourceType == SourcePurchased {
				avail, _ := l.RemainingCredits.Sub(l.ReservedCredits)
				purchasedPreserved, _ = purchasedPreserved.Add(avail)
			}
			inFlightHeld, _ = inFlightHeld.Add(l.ReservedCredits)
		}
		res := CycleBoundaryResult{
			ExpiredCreditsTotal:     prevClosure.ExpiredCreditsTotal,
			RolloverCreditsGranted:  prevClosure.RolloverCreditsGranted,
			NewMonthlyAllocation:    existingAllocLot.GrantedCredits,
			PreservedPurchasedTotal: purchasedPreserved,
			PreservedInFlightHeld:   inFlightHeld,
			ExpiredHeldReservations: prevClosure.ExpiredHeldReservations,
			AlreadyProcessedPeriod:  true,
		}
		return res, existingAllocLot, true, nil
	}

	var expiredTotal tenantdb.ExactDecimal
	var rolloverTotal tenantdb.ExactDecimal
	var expiredHeldCount int

	if cycleAlreadyClosed {
		expiredTotal = prevClosure.ExpiredCreditsTotal
		rolloverTotal = prevClosure.RolloverCreditsGranted
		expiredHeldCount = prevClosure.ExpiredHeldReservations
	} else {
		expiredTotal = tenantdb.ZeroDecimal()
		rolloverTotal = tenantdb.ZeroDecimal()

		// 1. Sweep expired held (unsubmitted) reservations first.
		for id, res := range st.Reservations {
			if res.Status == ReservationHeld && !res.ExpiresAt.After(now) {
				if err := releaseAllocationsOnState(st, res, "cycle_sweep", now); err != nil {
					return CycleBoundaryResult{}, nil, false, err
				}
				res.Status = ReservationExpired
				res.TerminalReason = "expired_at_cycle_boundary"
				res.UpdatedAt = now.UTC()
				st.Reservations[id] = res
				expiredHeldCount++
			}
		}

		// 2. Process expired subscription/promotional lots while preserving purchased lots and in-flight holds.
		maxRolloverCap, _ := tierSpec.MonthlyCredits.MulFloor(tierSpec.RolloverFraction)
		maxRolloverCap, _ = maxRolloverCap.CeilWhole()

		for idx := range st.Lots {
			lot := &st.Lots[idx]
			if lot.SourceType == SourcePurchased {
				continue // Purchased credits NEVER expire!
			}
			if lot.ExternalGrantKey == allocGrantKey || lot.ExternalGrantKey == rolloverGrantKey {
				continue
			}
			if lot.ExpiresAt == nil || lot.ExpiresAt.After(now) {
				continue
			}

			unheldRem, err := lot.RemainingCredits.Sub(lot.ReservedCredits)
			if err != nil || unheldRem.IsNegative() || unheldRem.IsZero() {
				continue
			}

			// Eligible primary subscription lots (not already a rollover lot) can roll over up to 20% on Pro/Business.
			if lot.SourceType == SourceSubscription &&
				!strings.HasPrefix(lot.ExternalGrantKey, "rollover:") &&
				!tierSpec.RolloverFraction.IsZero() {
				candidate, _ := unheldRem.MulFloor(tierSpec.RolloverFraction)
				if candidate.Cmp(maxRolloverCap) > 0 {
					candidate = maxRolloverCap
				}
				rolloverTotal, _ = rolloverTotal.Add(candidate)
				if rolloverTotal.Cmp(maxRolloverCap) > 0 {
					rolloverTotal = maxRolloverCap
				}
			}

			// Expire unheld remaining credits on the expired lot; keep lot.ReservedCredits intact for in_flight jobs!
			lot.RemainingCredits = lot.ReservedCredits
			expiredTotal, _ = expiredTotal.Add(unheldRem)

			expKey := fmt.Sprintf("expire:%s:%s", lot.LotID, periodKey)
			if !hasTxByKey(expKey) {
				negExp, _ := tenantdb.ZeroDecimal().Sub(unheldRem)
				balAfter := computeBalanceFromState(st, now).Available
				expTx := tenantdb.CreditTransactionRow{
					TransactionID:  store.nextUUID("81000000"),
					WorkspaceID:    workspaceID,
					OperationType:  "credit_expiration",
					CreditsDelta:   negExp,
					BalanceAfter:   balAfter,
					Source:         lot.SourceType,
					LotID:          lot.LotID,
					IdempotencyKey: expKey,
					Description:    fmt.Sprintf("Expired %s unspent %s credits at cycle boundary %s", unheldRem.String(), lot.SourceType, periodKey),
					CreatedAt:      now.UTC(),
				}
				st.Transactions = append([]tenantdb.CreditTransactionRow{expTx}, st.Transactions...)
			}
		}

		// 3. Grant one-cycle rollover lot if rolloverTotal > 0.
		if !rolloverTotal.IsZero() && findLotByKey(rolloverGrantKey) == nil {
			rollLot := tenantdb.CreditLotRow{
				LotID:            store.nextUUID("82000000"),
				WorkspaceID:      workspaceID,
				SourceType:       SourceSubscription,
				GrantedCredits:   rolloverTotal,
				RemainingCredits: rolloverTotal,
				ReservedCredits:  tenantdb.ZeroDecimal(),
				ExpiresAt:        &nextExp,
				ExternalGrantKey: rolloverGrantKey,
				CreatedAt:        now.UTC(),
			}
			st.Lots = append(st.Lots, rollLot)
			sortLotsInConsumptionOrder(st.Lots)
			if !hasTxByKey("grant:" + rolloverGrantKey) {
				balAfter := computeBalanceFromState(st, now).Available
				rollTx := tenantdb.CreditTransactionRow{
					TransactionID:  store.nextUUID("83000000"),
					WorkspaceID:    workspaceID,
					OperationType:  "subscription_rollover",
					CreditsDelta:   rolloverTotal,
					BalanceAfter:   balAfter,
					Source:         SourceSubscription,
					LotID:          rollLot.LotID,
					IdempotencyKey: "grant:" + rolloverGrantKey,
					Description:    fmt.Sprintf("20%% rollover grant for period %s", periodKey),
					CreatedAt:      now.UTC(),
				}
				st.Transactions = append([]tenantdb.CreditTransactionRow{rollTx}, st.Transactions...)
			}
		}
	}

	// 4. Grant new period monthly subscription allocation idempotently.
	allocLot := existingAllocLot
	if allocLot == nil {
		newLot := tenantdb.CreditLotRow{
			LotID:            store.nextUUID("84000000"),
			WorkspaceID:      workspaceID,
			SourceType:       SourceSubscription,
			GrantedCredits:   tierSpec.MonthlyCredits,
			RemainingCredits: tierSpec.MonthlyCredits,
			ReservedCredits:  tenantdb.ZeroDecimal(),
			ExpiresAt:        &nextExp,
			ExternalGrantKey: allocGrantKey,
			CreatedAt:        now.UTC(),
		}
		st.Lots = append(st.Lots, newLot)
		sortLotsInConsumptionOrder(st.Lots)
		allocLot = &newLot

		if !hasTxByKey("grant:" + allocGrantKey) {
			balAfter := computeBalanceFromState(st, now).Available
			allocTx := tenantdb.CreditTransactionRow{
				TransactionID:  store.nextUUID("85000000"),
				WorkspaceID:    workspaceID,
				OperationType:  "subscription_allocation",
				CreditsDelta:   tierSpec.MonthlyCredits,
				BalanceAfter:   balAfter,
				Source:         SourceSubscription,
				LotID:          newLot.LotID,
				IdempotencyKey: "grant:" + allocGrantKey,
				Description:    fmt.Sprintf("Monthly subscription credit allocation for period %s (%s tier)", periodKey, tierSpec.TierCode),
				CreatedAt:      now.UTC(),
			}
			st.Transactions = append([]tenantdb.CreditTransactionRow{allocTx}, st.Transactions...)
		}
	} else {
		sortLotsInConsumptionOrder(st.Lots)
	}

	if st.Subscription != nil {
		st.Subscription.CurrentPeriodStart = now.UTC()
		st.Subscription.CurrentPeriodEnd = nextExp
		if len(st.ScheduledAddonRemovals) > 0 {
			removeSet := make(map[string]bool, len(st.ScheduledAddonRemovals))
			for _, r := range st.ScheduledAddonRemovals {
				removeSet[r] = true
			}
			var kept []string
			for _, a := range st.Subscription.Addons {
				if !removeSet[a] {
					kept = append(kept, a)
				}
			}
			st.Subscription.Addons = kept
			st.ScheduledAddonRemovals = nil
		}
	}
	st.OverageUsedCredits = tenantdb.ZeroDecimal()

	resetEventKey := "evt:monthly_reset:" + allocGrantKey
	hasResetEvent := false
	for _, ev := range st.OutboxEvents {
		if ev.IdempotencyKey == resetEventKey {
			hasResetEvent = true
			break
		}
	}
	if !hasResetEvent {
		st.OutboxEvents = append(st.OutboxEvents, EmittedEvent{
			EventType:      EventCreditsMonthlyReset,
			WorkspaceID:    workspaceID,
			AggregateType:  "workspace",
			AggregateID:    workspaceID,
			IdempotencyKey: resetEventKey,
			Payload: map[string]any{
				"period_key":        periodKey,
				"expired_credits":   expiredTotal.String(),
				"rollover_credits":  rolloverTotal.String(),
				"allocated_credits": allocLot.GrantedCredits.String(),
			},
			CreatedAt: now.UTC(),
		})
	}

	purchasedPreserved := tenantdb.ZeroDecimal()
	inFlightHeld := tenantdb.ZeroDecimal()
	for _, l := range st.Lots {
		if l.SourceType == SourcePurchased {
			avail, _ := l.RemainingCredits.Sub(l.ReservedCredits)
			purchasedPreserved, _ = purchasedPreserved.Add(avail)
		}
		inFlightHeld, _ = inFlightHeld.Add(l.ReservedCredits)
	}

	out := CycleBoundaryResult{
		ExpiredCreditsTotal:     expiredTotal,
		RolloverCreditsGranted:  rolloverTotal,
		NewMonthlyAllocation:    allocLot.GrantedCredits,
		PreservedPurchasedTotal: purchasedPreserved,
		PreservedInFlightHeld:   inFlightHeld,
		ExpiredHeldReservations: expiredHeldCount,
		AlreadyProcessedPeriod:  cycleAlreadyClosed && existingAllocLot != nil,
	}
	st.ProcessedCycleClosures[cycleKey] = out
	return out, allocLot, false, nil
}

// Ensure context import is used by Postgres-backed helpers.
var _ = context.Background
