// Package billing implements Creativanta P0-06 versioned pricebooks, cost-based
// credit quotes, durable credit lots, holds/reservations, append-only debits and
// compensating refunds, cycle-boundary rollovers/expirations, and the billing sandbox.
//
// Canonical contracts:
//   - docs/01_business/pricing_and_credits.md (§1.1, §3.0, §4, §5.7)
//   - docs/02_features/platform/reporting_admin_billing.md
//   - docs/04_contracts/credit_accounting_contract.md (§1–§4)
//   - docs/04_contracts/database_schema.md (§4.1, §13.1–§13.2, §19.1, §26.1–§26.5)
//   - docs/04_contracts/error_catalog.md (BILLING_*)
package billing

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"sort"
	"strings"
	"time"

	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

const (
	// PricebookVersion is the canonical version identifier for the P0-06 pricebook.
	PricebookVersion = "2026-10-30.v1"

	// DefaultUSDPerCreditFloor is $0.015000 per credit (pricing_and_credits.md §3.0).
	DefaultUSDPerCreditFloor = "0.015000"
	// DefaultGrossMarginFloor is 0.5000 (50% gross margin floor, pricing_and_credits.md §3.0).
	DefaultGrossMarginFloor = "0.5000"

	// QuoteTTL is the 5-minute quote validity window (pricing_and_credits.md §3.0).
	QuoteTTL = 5 * time.Minute
	// ReservationHoldTTL is the 30-minute reservation hold window (credit_accounting_contract.md §3).
	ReservationHoldTTL = 30 * time.Minute
	// ReconcilingEscalationWindow is the 24-hour window before a reconciling reservation escalates to diagnostics_records.
	ReconcilingEscalationWindow = 24 * time.Hour
	// MaxRateCardFreshnessWindow is the 7-day maximum validity window from verified_at (pricing_and_credits.md §3.0).
	MaxRateCardFreshnessWindow = 7 * 24 * time.Hour
	// MaxActiveReservationsPerWorkspace is the canonical concurrency cap (credit_accounting_contract.md §2).
	MaxActiveReservationsPerWorkspace = 5
	// MaxBoundedProviderAttempts is the maximum bounded retry/fallback attempts allowed in a single quote.
	MaxBoundedProviderAttempts = 3
)

// Canonical error codes from docs/04_contracts/error_catalog.md.
const (
	ErrCodeInsufficientCredits   = "BILLING_LIMIT_001"     // HTTP 402
	ErrCodePlanFeatureRestricted = "BILLING_FORBIDDEN_001" // HTTP 403
	ErrCodeQuotaExceeded         = "BILLING_LIMIT_002"     // HTTP 429
	ErrCodeLastPaymentMethod     = "BILLING_CONFLICT_001"  // HTTP 409 (EC-M23-001)
	ErrCodeQuoteInvalidOrStale   = "BILLING_CONFLICT_002"  // HTTP 409
	ErrCodePaymentFailed         = "BILLING_UPSTREAM_001"  // HTTP 502
	ErrCodeInvalidInput          = "AI_INVALID_001"        // HTTP 400
)

var (
	// ErrInsufficientCredits indicates available credits are below the required reservation amount (BILLING_LIMIT_001).
	ErrInsufficientCredits = errors.New("BILLING_LIMIT_001: insufficient available AI credits for reservation")
	// ErrMaxActiveReservations indicates a workspace already has 5 active reservations (BILLING_LIMIT_002).
	ErrMaxActiveReservations = errors.New("BILLING_LIMIT_002: workspace already has the maximum of 5 active credit reservations")
	// ErrQuoteInvalidOrExpired indicates a quote is missing, expired, hash-mismatched, or unconfirmed (BILLING_CONFLICT_002).
	ErrQuoteInvalidOrExpired = errors.New("BILLING_CONFLICT_002: credit quote is expired, stale, or does not match execution parameters")
	// ErrPaidRetryExceedsQuote indicates a retry/fallback attempts a pipeline outside the bounded quote plan (BILLING_CONFLICT_002).
	ErrPaidRetryExceedsQuote = errors.New("BILLING_CONFLICT_002: paid retry or fallback exceeds bounded quote plan; new quote and customer consent required")
	// ErrRateCardStaleOrDisabled indicates a provider rate card is disabled, unverified, or stale >7 days (BILLING_CONFLICT_002).
	ErrRateCardStaleOrDisabled = errors.New("BILLING_CONFLICT_002: provider rate card is disabled, unverified, or expired")
	// ErrLastPaymentMethodOnPaidPlan indicates EC-M23-001: cannot remove the last payment method on an active paid plan (BILLING_CONFLICT_001).
	ErrLastPaymentMethodOnPaidPlan = errors.New("BILLING_CONFLICT_001: cannot remove the last payment method while workspace is on an active paid plan (EC-M23-001)")
	// ErrPlanDowngradeUsageExceedsLimit indicates workspace usage exceeds the target downgrade tier limits (BILLING_CONFLICT_001).
	ErrPlanDowngradeUsageExceedsLimit = errors.New("BILLING_CONFLICT_001: current workspace usage exceeds target tier limits")
	// ErrLateResultAfterTerminalState indicates a provider result arrived after reservation was already released or expired.
	ErrLateResultAfterTerminalState = errors.New("BILLING_CONFLICT_002: late provider result arrived after reservation reached terminal released/expired state; output quarantined without customer debit")
	// ErrReservationInvalidTransition indicates an illegal state machine transition.
	ErrReservationInvalidTransition = errors.New("BILLING_CONFLICT_002: invalid credit reservation state transition")
	// ErrPlanFeatureNotAllowed indicates an action requires a higher subscription tier (BILLING_FORBIDDEN_001).
	ErrPlanFeatureNotAllowed = errors.New("BILLING_FORBIDDEN_001: feature requires Business or Enterprise tier")
)

// TierSpec defines the canonical subscription tier parameters from pricing_and_credits.md §1.1.
type TierSpec struct {
	TierCode         string
	DisplayName      string
	Rank             int
	MonthlyPriceUSD  tenantdb.ExactDecimal
	AnnualPriceUSD   tenantdb.ExactDecimal
	MonthlyPriceVND  tenantdb.ExactDecimal
	AnnualPriceVND   tenantdb.ExactDecimal
	MonthlyCredits   tenantdb.ExactDecimal
	RolloverFraction tenantdb.ExactDecimal
	MaxSeats         int32
	MaxChannels      int32
	MaxStorageGB     int32
	OverageEligible  bool
	PauseEligible    bool
}

// CreditPackSpec defines a canonical top-up credit pack from pricing_and_credits.md §5.7.
type CreditPackSpec struct {
	PackCode     string
	DisplayName  string
	Credits      tenantdb.ExactDecimal
	PriceUSD     tenantdb.ExactDecimal
	PriceVND     tenantdb.ExactDecimal
	NeverExpires bool
}

// AddonSpec defines a canonical module add-on from pricing_and_credits.md §4.
type AddonSpec struct {
	AddonCode       string
	DisplayName     string
	MonthlyPriceUSD tenantdb.ExactDecimal
	MonthlyPriceVND tenantdb.ExactDecimal
	EligibleTiers   []string
}

var canonicalTiers = []TierSpec{
	{
		TierCode:         "free",
		DisplayName:      "Free",
		Rank:             1,
		MonthlyPriceUSD:  tenantdb.MustParseExactDecimal("0"),
		AnnualPriceUSD:   tenantdb.MustParseExactDecimal("0"),
		MonthlyPriceVND:  tenantdb.MustParseExactDecimal("0"),
		AnnualPriceVND:   tenantdb.MustParseExactDecimal("0"),
		MonthlyCredits:   tenantdb.MustParseExactDecimal("50"),
		RolloverFraction: tenantdb.MustParseExactDecimal("0"),
		MaxSeats:         1,
		MaxChannels:      2,
		MaxStorageGB:     5,
		OverageEligible:  false,
		PauseEligible:    false,
	},
	{
		TierCode:         "starter",
		DisplayName:      "Starter",
		Rank:             2,
		MonthlyPriceUSD:  tenantdb.MustParseExactDecimal("20"),
		AnnualPriceUSD:   tenantdb.MustParseExactDecimal("200"),
		MonthlyPriceVND:  tenantdb.MustParseExactDecimal("499000"),
		AnnualPriceVND:   tenantdb.MustParseExactDecimal("4990000"),
		MonthlyCredits:   tenantdb.MustParseExactDecimal("500"),
		RolloverFraction: tenantdb.MustParseExactDecimal("0"),
		MaxSeats:         1,
		MaxChannels:      5,
		MaxStorageGB:     50,
		OverageEligible:  false,
		PauseEligible:    false,
	},
	{
		TierCode:         "pro",
		DisplayName:      "Pro",
		Rank:             3,
		MonthlyPriceUSD:  tenantdb.MustParseExactDecimal("60"),
		AnnualPriceUSD:   tenantdb.MustParseExactDecimal("600"),
		MonthlyPriceVND:  tenantdb.MustParseExactDecimal("1499000"),
		AnnualPriceVND:   tenantdb.MustParseExactDecimal("14990000"),
		MonthlyCredits:   tenantdb.MustParseExactDecimal("2000"),
		RolloverFraction: tenantdb.MustParseExactDecimal("0.200000"),
		MaxSeats:         5,
		MaxChannels:      15,
		MaxStorageGB:     250,
		OverageEligible:  false,
		PauseEligible:    false,
	},
	{
		TierCode:         "business",
		DisplayName:      "Business",
		Rank:             4,
		MonthlyPriceUSD:  tenantdb.MustParseExactDecimal("200"),
		AnnualPriceUSD:   tenantdb.MustParseExactDecimal("2000"),
		MonthlyPriceVND:  tenantdb.MustParseExactDecimal("4999000"),
		AnnualPriceVND:   tenantdb.MustParseExactDecimal("49990000"),
		MonthlyCredits:   tenantdb.MustParseExactDecimal("10000"),
		RolloverFraction: tenantdb.MustParseExactDecimal("0.200000"),
		MaxSeats:         25,
		MaxChannels:      50,
		MaxStorageGB:     2000,
		OverageEligible:  true,
		PauseEligible:    true,
	},
	{
		TierCode:         "enterprise",
		DisplayName:      "Enterprise",
		Rank:             5,
		MonthlyPriceUSD:  tenantdb.MustParseExactDecimal("1000"),
		AnnualPriceUSD:   tenantdb.MustParseExactDecimal("10000"),
		MonthlyPriceVND:  tenantdb.MustParseExactDecimal("24990000"),
		AnnualPriceVND:   tenantdb.MustParseExactDecimal("249900000"),
		MonthlyCredits:   tenantdb.MustParseExactDecimal("50000"),
		RolloverFraction: tenantdb.MustParseExactDecimal("0.200000"),
		MaxSeats:         100,
		MaxChannels:      200,
		MaxStorageGB:     10000,
		OverageEligible:  true,
		PauseEligible:    true,
	},
}

var canonicalCreditPacks = []CreditPackSpec{
	{
		PackCode:     "small",
		DisplayName:  "Small Pack (100 Credits)",
		Credits:      tenantdb.MustParseExactDecimal("100"),
		PriceUSD:     tenantdb.MustParseExactDecimal("5"),
		PriceVND:     tenantdb.MustParseExactDecimal("129000"),
		NeverExpires: true,
	},
	{
		PackCode:     "medium",
		DisplayName:  "Medium Pack (500 Credits)",
		Credits:      tenantdb.MustParseExactDecimal("500"),
		PriceUSD:     tenantdb.MustParseExactDecimal("20"),
		PriceVND:     tenantdb.MustParseExactDecimal("499000"),
		NeverExpires: true,
	},
	{
		PackCode:     "large",
		DisplayName:  "Large Pack (2,000 Credits)",
		Credits:      tenantdb.MustParseExactDecimal("2000"),
		PriceUSD:     tenantdb.MustParseExactDecimal("60"),
		PriceVND:     tenantdb.MustParseExactDecimal("1499000"),
		NeverExpires: true,
	},
	{
		PackCode:     "mega",
		DisplayName:  "Mega Pack (10,000 Credits)",
		Credits:      tenantdb.MustParseExactDecimal("10000"),
		PriceUSD:     tenantdb.MustParseExactDecimal("200"),
		PriceVND:     tenantdb.MustParseExactDecimal("4999000"),
		NeverExpires: true,
	},
}

var canonicalAddons = []AddonSpec{
	{
		AddonCode:       "commerce_intelligence",
		DisplayName:     "Commerce Intelligence Add-on",
		MonthlyPriceUSD: tenantdb.MustParseExactDecimal("39"),
		MonthlyPriceVND: tenantdb.MustParseExactDecimal("999000"),
		EligibleTiers:   []string{"pro", "business", "enterprise"},
	},
	{
		AddonCode:       "continuity_pro",
		DisplayName:     "Continuity Pro Add-on",
		MonthlyPriceUSD: tenantdb.MustParseExactDecimal("29"),
		MonthlyPriceVND: tenantdb.MustParseExactDecimal("749000"),
		EligibleTiers:   []string{"pro", "business", "enterprise"},
	},
	{
		AddonCode:       "advanced_profit",
		DisplayName:     "Advanced Profit & Attribution Add-on",
		MonthlyPriceUSD: tenantdb.MustParseExactDecimal("79"),
		MonthlyPriceVND: tenantdb.MustParseExactDecimal("1999000"),
		EligibleTiers:   []string{"pro", "business", "enterprise"},
	},
	{
		AddonCode:       "workflow_agent_pro",
		DisplayName:     "Workflow & Agent Pro Add-on",
		MonthlyPriceUSD: tenantdb.MustParseExactDecimal("59"),
		MonthlyPriceVND: tenantdb.MustParseExactDecimal("1499000"),
		EligibleTiers:   []string{"pro", "business", "enterprise"},
	},
}

// LookupTier returns the canonical TierSpec for tierCode.
func LookupTier(tierCode string) (TierSpec, bool) {
	normalized := strings.ToLower(strings.TrimSpace(tierCode))
	for _, t := range canonicalTiers {
		if t.TierCode == normalized {
			return t, true
		}
	}
	return TierSpec{}, false
}

// LookupCreditPack returns the canonical CreditPackSpec for packCode.
func LookupCreditPack(packCode string) (CreditPackSpec, bool) {
	normalized := strings.ToLower(strings.TrimSpace(packCode))
	for _, p := range canonicalCreditPacks {
		if p.PackCode == normalized {
			return p, true
		}
	}
	return CreditPackSpec{}, false
}

// LookupAddon returns the canonical AddonSpec for addonCode.
func LookupAddon(addonCode string) (AddonSpec, bool) {
	normalized := strings.ToLower(strings.TrimSpace(addonCode))
	for _, a := range canonicalAddons {
		if a.AddonCode == normalized {
			return a, true
		}
	}
	return AddonSpec{}, false
}

// ListTierSpecs returns a copy of all canonical subscription tiers.
func ListTierSpecs() []TierSpec {
	out := make([]TierSpec, len(canonicalTiers))
	copy(out, canonicalTiers)
	return out
}

// ListCreditPackSpecs returns a copy of all canonical credit top-up packs.
func ListCreditPackSpecs() []CreditPackSpec {
	out := make([]CreditPackSpec, len(canonicalCreditPacks))
	copy(out, canonicalCreditPacks)
	return out
}

// ListAddonSpecs returns a copy of all canonical module add-ons.
func ListAddonSpecs() []AddonSpec {
	out := make([]AddonSpec, len(canonicalAddons))
	copy(out, canonicalAddons)
	return out
}

// ToProtoPlanCatalogEntry converts TierSpec to its protobuf transport representation.
func (t TierSpec) ToProtoPlanCatalogEntry() *adminv1.PlanCatalogEntry {
	return &adminv1.PlanCatalogEntry{
		TierCode:    t.TierCode,
		DisplayName: t.DisplayName,
		MonthlyPriceUsd: &commonv1.Money{
			Amount:   t.MonthlyPriceUSD.String(),
			Currency: "USD",
		},
		AnnualPriceUsd: &commonv1.Money{
			Amount:   t.AnnualPriceUSD.String(),
			Currency: "USD",
		},
		MonthlyPriceVnd: &commonv1.Money{
			Amount:   t.MonthlyPriceVND.String(),
			Currency: "VND",
		},
		AnnualPriceVnd: &commonv1.Money{
			Amount:   t.AnnualPriceVND.String(),
			Currency: "VND",
		},
		MonthlyCredits:   t.MonthlyCredits.String(),
		RolloverFraction: t.RolloverFraction.String(),
		MaxSeats:         t.MaxSeats,
		MaxChannels:      t.MaxChannels,
		MaxStorageGb:     t.MaxStorageGB,
		OverageEligible:  t.OverageEligible,
	}
}

// ToProtoCreditPackEntry converts CreditPackSpec to its protobuf transport representation.
func (p CreditPackSpec) ToProtoCreditPackEntry() *adminv1.CreditPackEntry {
	return &adminv1.CreditPackEntry{
		PackCode:    p.PackCode,
		DisplayName: p.DisplayName,
		Credits:     p.Credits.String(),
		PriceUsd: &commonv1.Money{
			Amount:   p.PriceUSD.String(),
			Currency: "USD",
		},
		PriceVnd: &commonv1.Money{
			Amount:   p.PriceVND.String(),
			Currency: "VND",
		},
		NeverExpires: p.NeverExpires,
	}
}

// ToProtoAddonCatalogEntry converts AddonSpec to its protobuf transport representation.
func (a AddonSpec) ToProtoAddonCatalogEntry() *adminv1.AddonCatalogEntry {
	return &adminv1.AddonCatalogEntry{
		AddonCode:   a.AddonCode,
		DisplayName: a.DisplayName,
		MonthlyPriceUsd: &commonv1.Money{
			Amount:   a.MonthlyPriceUSD.String(),
			Currency: "USD",
		},
		MonthlyPriceVnd: &commonv1.Money{
			Amount:   a.MonthlyPriceVND.String(),
			Currency: "VND",
		},
		EligibleTiers: append([]string{}, a.EligibleTiers...),
	}
}

// ProviderRateCard represents a verified provider rate card (§26.1).
type ProviderRateCard struct {
	RateID     string
	Provider   string
	ModelID    string
	Version    string
	Currency   string
	UnitRates  map[string]string // e.g. {"video_second": "0.040000"} or {"token_1k": "0.005000"}
	SourceURL  string
	VerifiedAt time.Time
	ValidUntil time.Time
	Enabled    bool
}

// DefaultVerifiedRateCards returns the canonical baseline verified rate cards for Creativanta AI providers.
func DefaultVerifiedRateCards(now time.Time) []ProviderRateCard {
	verified := now.UTC().Truncate(time.Second)
	validUntil := verified.Add(6 * 24 * time.Hour) // within 7-day freshness requirement
	return []ProviderRateCard{
		{
			RateID:     "10000000-0000-4000-8000-000000000001",
			Provider:   "google",
			ModelID:    "veo-2",
			Version:    "rate-2026-10-30-v1",
			Currency:   "USD",
			UnitRates:  map[string]string{"video_second": "0.040000", "Flat": "0.000000"},
			SourceURL:  "https://cloud.google.com/vertex-ai/generative-ai/pricing",
			VerifiedAt: verified,
			ValidUntil: validUntil,
			Enabled:    true,
		},
		{
			RateID:     "10000000-0000-4000-8000-000000000002",
			Provider:   "kling",
			ModelID:    "kling-2.1",
			Version:    "rate-2026-10-30-v1",
			Currency:   "USD",
			UnitRates:  map[string]string{"video_second": "0.030000"},
			SourceURL:  "https://klingai.com/pricing",
			VerifiedAt: verified,
			ValidUntil: validUntil,
			Enabled:    true,
		},
		{
			RateID:     "10000000-0000-4000-8000-000000000003",
			Provider:   "openai",
			ModelID:    "gpt-4o",
			Version:    "rate-2026-10-30-v1",
			Currency:   "USD",
			UnitRates:  map[string]string{"input_1k_tokens": "0.002500", "output_1k_tokens": "0.010000", "generation_call": "0.015000"},
			SourceURL:  "https://openai.com/api/pricing",
			VerifiedAt: verified,
			ValidUntil: validUntil,
			Enabled:    true,
		},
		{
			RateID:     "10000000-0000-4000-8000-000000000004",
			Provider:   "anthropic",
			ModelID:    "claude-3-7-sonnet",
			Version:    "rate-2026-10-30-v1",
			Currency:   "USD",
			UnitRates:  map[string]string{"input_1k_tokens": "0.003000", "output_1k_tokens": "0.015000", "generation_call": "0.015000"},
			SourceURL:  "https://www.anthropic.com/pricing",
			VerifiedAt: verified,
			ValidUntil: validUntil,
			Enabled:    true,
		},
		{
			RateID:     "10000000-0000-4000-8000-000000000005",
			Provider:   "elevenlabs",
			ModelID:    "eleven-multilingual-v2",
			Version:    "rate-2026-10-30-v1",
			Currency:   "USD",
			UnitRates:  map[string]string{"audio_minute": "0.150000", "character_1k": "0.030000"},
			SourceURL:  "https://elevenlabs.io/pricing",
			VerifiedAt: verified,
			ValidUntil: validUntil,
			Enabled:    true,
		},
		{
			RateID:     "10000000-0000-4000-8000-000000000006",
			Provider:   "ideogram",
			ModelID:    "ideogram-v3",
			Version:    "rate-2026-10-30-v1",
			Currency:   "USD",
			UnitRates:  map[string]string{"image": "0.045000"},
			SourceURL:  "https://ideogram.ai/pricing",
			VerifiedAt: verified,
			ValidUntil: validUntil,
			Enabled:    true,
		},
	}
}

// ValidateRateCard enforces the fail-closed rate card freshness & verification contract
// from docs/01_business/pricing_and_credits.md §3.0.
func ValidateRateCard(card ProviderRateCard, now time.Time) error {
	if !card.Enabled {
		return fmt.Errorf("%w: model %s/%s is disabled", ErrRateCardStaleOrDisabled, card.Provider, card.ModelID)
	}
	if card.Currency != "USD" {
		return fmt.Errorf("%w: rate card currency must be USD, got %q", ErrRateCardStaleOrDisabled, card.Currency)
	}
	if strings.TrimSpace(card.SourceURL) == "" || card.VerifiedAt.IsZero() || card.ValidUntil.IsZero() {
		return fmt.Errorf("%w: missing source_url, verified_at, or valid_until on %s/%s", ErrRateCardStaleOrDisabled, card.Provider, card.ModelID)
	}
	if !card.ValidUntil.After(now) {
		return fmt.Errorf("%w: rate card %s/%s@%s expired at %s", ErrRateCardStaleOrDisabled, card.Provider, card.ModelID, card.Version, card.ValidUntil.Format(time.RFC3339))
	}
	if card.ValidUntil.Sub(card.VerifiedAt) > MaxRateCardFreshnessWindow {
		return fmt.Errorf("%w: rate card %s/%s@%s valid_until exceeds 7-day freshness window from verified_at", ErrRateCardStaleOrDisabled, card.Provider, card.ModelID, card.Version)
	}
	if len(card.UnitRates) == 0 {
		return fmt.Errorf("%w: rate card %s/%s has empty unit_rates", ErrRateCardStaleOrDisabled, card.Provider, card.ModelID)
	}
	return nil
}

// QuoteInput specifies the bounded parameters for computing a cost-based credit quote.
type QuoteInput struct {
	WorkspaceID         string
	OperationType       string
	Provider            string
	ModelID             string
	FallbackProvider    string
	FallbackModelID     string
	MaxProviderAttempts int32
	MeasuredUnits       map[string]string
	USDPerCreditFloor   string
	GrossMarginFloor    string
}

// ProviderPlanSnapshot is serialized into ai_credit_quotes.provider_plan (§26.2).
type ProviderPlanSnapshot struct {
	PrimaryProvider     string            `json:"primary_provider"`
	PrimaryModelID      string            `json:"primary_model_id"`
	PrimaryRateVersion  string            `json:"primary_rate_version"`
	FallbackProvider    string            `json:"fallback_provider,omitempty"`
	FallbackModelID     string            `json:"fallback_model_id,omitempty"`
	FallbackRateVersion string            `json:"fallback_rate_version,omitempty"`
	MaxProviderAttempts int32             `json:"max_provider_attempts"`
	MeasuredUnits       map[string]string `json:"measured_units"`
	PrimaryAttemptUSD   string            `json:"primary_attempt_usd"`
	FallbackAttemptUSD  string            `json:"fallback_attempt_usd,omitempty"`
}

// ComputedQuote holds the verified quote output ready for persistence in ai_credit_quotes.
type ComputedQuote struct {
	OperationType     string
	RateVersion       string
	RequestHash       string
	ProviderPlan      ProviderPlanSnapshot
	ProviderPlanJSON  []byte
	CostCeilingUSD    tenantdb.ExactDecimal
	USDPerCreditFloor tenantdb.ExactDecimal
	GrossMarginFloor  tenantdb.ExactDecimal
	QuotedCredits     tenantdb.ExactDecimal
	ExpiresAt         time.Time
}

// ComputeRequestHash produces the canonical SHA-256 hash of normalized execution parameters.
// Changing model, duration, resolution, fallback model, or attempt bounds changes the hash
// and invalidates any prior quote (pricing_and_credits.md §3.0).
func ComputeRequestHash(in QuoteInput) string {
	attempts := in.MaxProviderAttempts
	if attempts <= 0 {
		attempts = 1
	}
	keys := make([]string, 0, len(in.MeasuredUnits))
	for k := range in.MeasuredUnits {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	var b strings.Builder
	b.WriteString("op=")
	b.WriteString(strings.TrimSpace(in.OperationType))
	b.WriteString("|prov=")
	b.WriteString(strings.ToLower(strings.TrimSpace(in.Provider)))
	b.WriteString("|model=")
	b.WriteString(strings.ToLower(strings.TrimSpace(in.ModelID)))
	b.WriteString("|fb_prov=")
	b.WriteString(strings.ToLower(strings.TrimSpace(in.FallbackProvider)))
	b.WriteString("|fb_model=")
	b.WriteString(strings.ToLower(strings.TrimSpace(in.FallbackModelID)))
	b.WriteString(fmt.Sprintf("|attempts=%d", attempts))
	for _, k := range keys {
		dec, err := tenantdb.ParseExactDecimal(strings.TrimSpace(in.MeasuredUnits[k]))
		val := strings.TrimSpace(in.MeasuredUnits[k])
		if err == nil {
			val = dec.Fixed6String()
		}
		b.WriteString("|u:")
		b.WriteString(k)
		b.WriteString("=")
		b.WriteString(val)
	}

	sum := sha256.Sum256([]byte(b.String()))
	return hex.EncodeToString(sum[:])
}

// ComputeAttemptCostUSD computes the exact USD provider cost for a single attempt given
// a verified rate card and measured unit map. All unit types in measuredUnits must exist
// in card.UnitRates; otherwise it fails closed.
func ComputeAttemptCostUSD(card ProviderRateCard, measuredUnits map[string]string) (tenantdb.ExactDecimal, error) {
	if len(measuredUnits) == 0 {
		return tenantdb.ExactDecimal{}, fmt.Errorf("%w: measured_units cannot be empty", tenantdb.ErrInvalidDecimal)
	}
	totalUSD := tenantdb.ZeroDecimal()
	for unitName, rawQty := range measuredUnits {
		qty, err := tenantdb.ParseExactDecimal(strings.TrimSpace(rawQty))
		if err != nil || qty.IsNegative() || qty.IsZero() {
			return tenantdb.ExactDecimal{}, fmt.Errorf("%w: invalid unit quantity %q for %s", tenantdb.ErrInvalidDecimal, rawQty, unitName)
		}
		rawRate, ok := card.UnitRates[unitName]
		if !ok {
			return tenantdb.ExactDecimal{}, fmt.Errorf("%w: unit %q not priced on rate card %s/%s@%s", ErrRateCardStaleOrDisabled, unitName, card.Provider, card.ModelID, card.Version)
		}
		rateDec, err := tenantdb.ParseExactDecimal(strings.TrimSpace(rawRate))
		if err != nil || rateDec.IsNegative() {
			return tenantdb.ExactDecimal{}, fmt.Errorf("%w: invalid unit rate %q on %s/%s", ErrRateCardStaleOrDisabled, rawRate, card.Provider, card.ModelID)
		}
		lineCost, err := qty.MulFloor(rateDec)
		if err != nil {
			return tenantdb.ExactDecimal{}, err
		}
		totalUSD, err = totalUSD.Add(lineCost)
		if err != nil {
			return tenantdb.ExactDecimal{}, err
		}
	}
	if totalUSD.IsZero() {
		return tenantdb.ExactDecimal{}, fmt.Errorf("%w: computed provider attempt cost must be > 0", tenantdb.ErrInvalidDecimal)
	}
	return totalUSD, nil
}

// ComputeCostBasedQuote validates primary (and optional fallback) rate cards and calculates
// the exact worst-case cost ceiling and quoted credits using ExactDecimal arithmetic.
func ComputeCostBasedQuote(
	in QuoteInput,
	primaryCard ProviderRateCard,
	fallbackCard *ProviderRateCard,
	now time.Time,
) (ComputedQuote, error) {
	if strings.TrimSpace(in.OperationType) == "" {
		return ComputedQuote{}, fmt.Errorf("%w: operation_type is required", tenantdb.ErrInvalidDecimal)
	}
	attempts := in.MaxProviderAttempts
	if attempts == 0 {
		attempts = 1
	}
	if attempts < 1 || attempts > MaxBoundedProviderAttempts {
		return ComputedQuote{}, fmt.Errorf("%w: max_provider_attempts %d outside bounded range [1..%d]", ErrQuoteInvalidOrExpired, attempts, MaxBoundedProviderAttempts)
	}

	if err := ValidateRateCard(primaryCard, now); err != nil {
		return ComputedQuote{}, err
	}
	primaryAttemptUSD, err := ComputeAttemptCostUSD(primaryCard, in.MeasuredUnits)
	if err != nil {
		return ComputedQuote{}, err
	}

	worstCaseSingleAttemptUSD := primaryAttemptUSD
	var fallbackAttemptStr string
	var fallbackRateVersion string
	if fallbackCard != nil {
		if err := ValidateRateCard(*fallbackCard, now); err != nil {
			return ComputedQuote{}, err
		}
		fbAttemptUSD, err := ComputeAttemptCostUSD(*fallbackCard, in.MeasuredUnits)
		if err != nil {
			return ComputedQuote{}, err
		}
		fallbackAttemptStr = fbAttemptUSD.Fixed6String()
		fallbackRateVersion = fallbackCard.Version
		if fbAttemptUSD.Cmp(worstCaseSingleAttemptUSD) > 0 {
			worstCaseSingleAttemptUSD = fbAttemptUSD
		}
	}

	attemptsDec, err := tenantdb.ParseExactDecimal(fmt.Sprintf("%d", attempts))
	if err != nil {
		return ComputedQuote{}, err
	}
	costCeilingUSD, err := worstCaseSingleAttemptUSD.MulFloor(attemptsDec)
	if err != nil {
		return ComputedQuote{}, err
	}

	floorStr := in.USDPerCreditFloor
	if strings.TrimSpace(floorStr) == "" {
		floorStr = DefaultUSDPerCreditFloor
	}
	usdPerCreditFloor, err := tenantdb.ParseExactDecimal(floorStr)
	if err != nil {
		return ComputedQuote{}, err
	}

	marginStr := in.GrossMarginFloor
	if strings.TrimSpace(marginStr) == "" {
		marginStr = DefaultGrossMarginFloor
	}
	grossMarginFloor, err := tenantdb.ParseExactDecimal(marginStr)
	if err != nil {
		return ComputedQuote{}, err
	}

	quotedCredits, err := tenantdb.ComputeQuotedCredits(costCeilingUSD, usdPerCreditFloor, grossMarginFloor)
	if err != nil {
		return ComputedQuote{}, err
	}

	normalizedUnits := make(map[string]string, len(in.MeasuredUnits))
	for k, v := range in.MeasuredUnits {
		normalizedUnits[k] = strings.TrimSpace(v)
	}

	plan := ProviderPlanSnapshot{
		PrimaryProvider:     primaryCard.Provider,
		PrimaryModelID:      primaryCard.ModelID,
		PrimaryRateVersion:  primaryCard.Version,
		FallbackProvider:    strings.ToLower(strings.TrimSpace(in.FallbackProvider)),
		FallbackModelID:     strings.ToLower(strings.TrimSpace(in.FallbackModelID)),
		FallbackRateVersion: fallbackRateVersion,
		MaxProviderAttempts: attempts,
		MeasuredUnits:       normalizedUnits,
		PrimaryAttemptUSD:   primaryAttemptUSD.Fixed6String(),
		FallbackAttemptUSD:  fallbackAttemptStr,
	}
	planBytes, err := json.Marshal(plan)
	if err != nil {
		return ComputedQuote{}, err
	}

	return ComputedQuote{
		OperationType:     strings.TrimSpace(in.OperationType),
		RateVersion:       primaryCard.Version,
		RequestHash:       ComputeRequestHash(in),
		ProviderPlan:      plan,
		ProviderPlanJSON:  planBytes,
		CostCeilingUSD:    costCeilingUSD,
		USDPerCreditFloor: usdPerCreditFloor,
		GrossMarginFloor:  grossMarginFloor,
		QuotedCredits:     quotedCredits,
		ExpiresAt:         now.UTC().Add(QuoteTTL),
	}, nil
}
