package finance

import (
	"fmt"
	"math/big"
	"strings"

	"github.com/jackc/pgx/v5/pgtype"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// ComputeBaseAmount converts transaction currency amount to workspace base currency amount:
//
//	base_amount = transaction_amount * rate_to_base
//
// Same-currency conversion rate is strictly 1.
// Rates must be strictly positive.
func ComputeBaseAmount(txAmount tenantdb.ExactDecimal, fx ExchangeRateSnapshot) (tenantdb.ExactDecimal, error) {
	if fx.BaseCurrency == "" || fx.QuoteCurrency == "" {
		return txAmount, nil
	}
	if strings.EqualFold(fx.BaseCurrency, fx.QuoteCurrency) {
		return txAmount, nil
	}
	if fx.RateToBase == "" {
		return tenantdb.ExactDecimal{}, fmt.Errorf("%w: missing rate_to_base for %s -> %s", ErrInvalidAmount, fx.QuoteCurrency, fx.BaseCurrency)
	}

	rate, err := tenantdb.ParseExactDecimal(fx.RateToBase)
	if err != nil {
		return tenantdb.ExactDecimal{}, fmt.Errorf("%w: invalid rate_to_base %q: %v", ErrInvalidAmount, fx.RateToBase, err)
	}
	if rate.IsNegative() || rate.IsZero() {
		return tenantdb.ExactDecimal{}, ErrNegativeRate
	}

	// Exact base-10 multiplication: (txAmount * rate) scaled by 10^6
	numA := txAmount.ToPgNumeric().Int
	numB := rate.ToPgNumeric().Int
	if numA == nil || numB == nil {
		return tenantdb.ZeroDecimal(), nil
	}

	prod := new(big.Int).Mul(numA, numB)
	// Both numA and numB were scaled by 10^6, so prod is scaled by 10^12.
	// Divide by 10^6 to return to 10^6 micro-units.
	tenPow6 := big.NewInt(1_000_000)
	scaled := new(big.Int).Quo(prod, tenPow6)

	return tenantdb.FromPgNumeric(pgtype.Numeric{
		Int:   scaled,
		Exp:   -tenantdb.MaxDecimalScale,
		Valid: true,
	})
}

// RankConfidence orders confidence bands numerically:
// high (5) > medium_high (4) > medium (3) > low_medium (2) > low (1).
func RankConfidence(band string) int {
	switch band {
	case ConfidenceHigh:
		return 5
	case ConfidenceMediumHigh:
		return 4
	case ConfidenceMedium:
		return 3
	case ConfidenceLowMedium:
		return 2
	case ConfidenceLow:
		return 1
	default:
		return 1
	}
}

// BandFromRank maps integer rank back to canonical confidence band.
func BandFromRank(rank int) string {
	switch rank {
	case 5:
		return ConfidenceHigh
	case 4:
		return ConfidenceMediumHigh
	case 3:
		return ConfidenceMedium
	case 2:
		return ConfidenceLowMedium
	default:
		return ConfidenceLow
	}
}

type ComponentPostingSummary struct {
	Component   string
	BaseAmount  tenantdb.ExactDecimal
	SourceClass string
	Confidence  string
}

// ResolveAggregateConfidence computes the aggregate confidence according to canonical rules:
// 1. Inherits the lowest contributing band from any active posting component.
// 2. If there is a mix of official and estimated/inferred values, capped at medium.
// 3. If any required component (e.g. COGS) is unknown/missing, capped at low.
func ResolveAggregateConfidence(summaries []ComponentPostingSummary, hasMissingRequiredComponent bool) string {
	if len(summaries) == 0 {
		if hasMissingRequiredComponent {
			return ConfidenceLow
		}
		return ConfidenceMedium
	}

	minRank := 5
	hasOfficial := false
	hasEstimatedOrInferred := false

	for _, s := range summaries {
		r := RankConfidence(s.Confidence)
		if r < minRank {
			minRank = r
		}
		switch s.SourceClass {
		case SourceClassOfficial:
			hasOfficial = true
		case SourceClassEstimated, SourceClassInferred:
			hasEstimatedOrInferred = true
		case SourceClassUnreconciled:
			hasEstimatedOrInferred = true
		}
	}

	resultBand := BandFromRank(minRank)

	// Mixed official and estimated/inferred caps at medium
	if hasOfficial && hasEstimatedOrInferred {
		if RankConfidence(resultBand) > RankConfidence(ConfidenceMedium) {
			resultBand = ConfidenceMedium
		}
	}

	// Missing required component caps at low
	if hasMissingRequiredComponent {
		resultBand = ConfidenceLow
	}

	return resultBand
}

// ComputeNetProfit implements the canonical operating profit formula:
// net_profit = revenue - platform_fee - shipping - cogs - ai_credits - commission - ads_spend - seeding - refund - other
func ComputeNetProfit(
	revenue,
	platformFee,
	shipping,
	cogs,
	aiCredits,
	commission,
	adsSpend,
	seeding,
	refund,
	other tenantdb.ExactDecimal,
) (tenantdb.ExactDecimal, error) {
	totalCosts := tenantdb.ZeroDecimal()
	var err error

	for _, c := range []tenantdb.ExactDecimal{
		platformFee, shipping, cogs, aiCredits, commission, adsSpend, seeding, refund, other,
	} {
		totalCosts, err = totalCosts.Add(c)
		if err != nil {
			return tenantdb.ExactDecimal{}, fmt.Errorf("cost addition overflow: %w", err)
		}
	}

	net, err := revenue.Sub(totalCosts)
	if err != nil {
		return tenantdb.ExactDecimal{}, fmt.Errorf("net profit subtraction overflow: %w", err)
	}
	return net, nil
}

// ActivePostingSummary aggregates postings after taking into account reversals.
type ActivePostingSummary struct {
	ActivePostings   []FinancialPosting
	Currency         string
	GrossRevenue     tenantdb.ExactDecimal
	PlatformFees     tenantdb.ExactDecimal
	ShippingCosts    tenantdb.ExactDecimal
	COGS             tenantdb.ExactDecimal
	AICreditCosts    tenantdb.ExactDecimal
	Commissions      tenantdb.ExactDecimal
	AdsSpend         tenantdb.ExactDecimal
	SeedingCosts     tenantdb.ExactDecimal
	RefundDeductions tenantdb.ExactDecimal
	OtherCosts       tenantdb.ExactDecimal
	NetProfit        tenantdb.ExactDecimal
	SourceClassMix   map[string]tenantdb.ExactDecimal
	Confidence       string
}

func postingEffectiveBaseCurrency(p FinancialPosting) string {
	if base := strings.ToUpper(strings.TrimSpace(p.ExchangeRateSnapshot.BaseCurrency)); base != "" {
		return base
	}
	return strings.ToUpper(strings.TrimSpace(p.Currency))
}

// SummarizePostings filters out reversed postings and computes aggregated totals and confidence.
func SummarizePostings(postings []FinancialPosting, hasMissingCOGS bool) (*ActivePostingSummary, error) {
	// First identify all reversed posting IDs
	reversedIDs := make(map[string]bool)
	for _, p := range postings {
		if p.ReversalOf != nil && *p.ReversalOf != "" {
			reversedIDs[*p.ReversalOf] = true
		}
	}

	// Active postings are those not reversed and not reversals themselves
	var active []FinancialPosting
	resolvedCurrency := ""
	for _, p := range postings {
		if p.ReversalOf != nil && *p.ReversalOf != "" {
			continue // Skip the reversal entry itself when computing net component sums
		}
		if reversedIDs[p.PostingID] {
			continue // Reversed entry is excluded
		}
		effCurr := postingEffectiveBaseCurrency(p)
		if effCurr != "" {
			if resolvedCurrency == "" {
				resolvedCurrency = effCurr
			} else if effCurr != resolvedCurrency {
				return nil, fmt.Errorf("%w: cannot aggregate mixed base currencies %s and %s without conversion", ErrCurrencyMismatch, resolvedCurrency, effCurr)
			}
		}
		active = append(active, p)
	}
	if resolvedCurrency == "" {
		resolvedCurrency = "VND"
	}

	summary := &ActivePostingSummary{
		ActivePostings:   active,
		Currency:         resolvedCurrency,
		GrossRevenue:     tenantdb.ZeroDecimal(),
		PlatformFees:     tenantdb.ZeroDecimal(),
		ShippingCosts:    tenantdb.ZeroDecimal(),
		COGS:             tenantdb.ZeroDecimal(),
		AICreditCosts:    tenantdb.ZeroDecimal(),
		Commissions:      tenantdb.ZeroDecimal(),
		AdsSpend:         tenantdb.ZeroDecimal(),
		SeedingCosts:     tenantdb.ZeroDecimal(),
		RefundDeductions: tenantdb.ZeroDecimal(),
		OtherCosts:       tenantdb.ZeroDecimal(),
		NetProfit:        tenantdb.ZeroDecimal(),
		SourceClassMix:   make(map[string]tenantdb.ExactDecimal),
	}

	var compSummaries []ComponentPostingSummary
	var err error

	for _, p := range active {
		absAmount := p.Amount
		if absAmount.IsNegative() {
			negAmount := absAmount.ToPgNumeric().Int
			if negAmount != nil {
				pos := new(big.Int).Neg(negAmount)
				absAmount, _ = tenantdb.FromPgNumeric(pgtype.Numeric{
					Int:   pos,
					Exp:   -tenantdb.MaxDecimalScale,
					Valid: true,
				})
			}
		}

		// Update source class mix by absolute base amount
		currentClassSum := summary.SourceClassMix[p.SourceClass]
		summary.SourceClassMix[p.SourceClass], _ = currentClassSum.Add(absAmount)

		compSummaries = append(compSummaries, ComponentPostingSummary{
			Component:   p.Component,
			BaseAmount:  absAmount,
			SourceClass: p.SourceClass,
			Confidence:  p.Confidence,
		})

		switch p.Component {
		case ComponentRevenue:
			summary.GrossRevenue, err = summary.GrossRevenue.Add(absAmount)
		case ComponentPlatformFee:
			summary.PlatformFees, err = summary.PlatformFees.Add(absAmount)
		case ComponentShipping:
			summary.ShippingCosts, err = summary.ShippingCosts.Add(absAmount)
		case ComponentCOGS:
			summary.COGS, err = summary.COGS.Add(absAmount)
		case ComponentAICredits:
			summary.AICreditCosts, err = summary.AICreditCosts.Add(absAmount)
		case ComponentCommission:
			summary.Commissions, err = summary.Commissions.Add(absAmount)
		case ComponentAdsSpend:
			summary.AdsSpend, err = summary.AdsSpend.Add(absAmount)
		case ComponentSeeding:
			summary.SeedingCosts, err = summary.SeedingCosts.Add(absAmount)
		case ComponentRefund:
			summary.RefundDeductions, err = summary.RefundDeductions.Add(absAmount)
		case ComponentOther:
			summary.OtherCosts, err = summary.OtherCosts.Add(absAmount)
		}
		if err != nil {
			return nil, err
		}
	}

	net, err := ComputeNetProfit(
		summary.GrossRevenue,
		summary.PlatformFees,
		summary.ShippingCosts,
		summary.COGS,
		summary.AICreditCosts,
		summary.Commissions,
		summary.AdsSpend,
		summary.SeedingCosts,
		summary.RefundDeductions,
		summary.OtherCosts,
	)
	if err != nil {
		return nil, err
	}
	summary.NetProfit = net
	summary.Confidence = ResolveAggregateConfidence(compSummaries, hasMissingCOGS)

	return summary, nil
}
