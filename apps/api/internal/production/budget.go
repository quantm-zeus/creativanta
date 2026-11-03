package production

import (
	"context"
	"fmt"
	"net/url"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// BudgetCalculator handles preflight bounded quotes and partial batch input validation.
type BudgetCalculator struct {
	USDPerCreditFloor tenantdb.ExactDecimal // default $0.015000
	GrossMarginFloor  tenantdb.ExactDecimal // default 0.500000 (50% gross margin)
}

// NewBudgetCalculator initializes a budget calculator with canonical pricing invariants.
func NewBudgetCalculator() *BudgetCalculator {
	floor, _ := tenantdb.ParseExactDecimal("0.015000")
	margin, _ := tenantdb.ParseExactDecimal("0.500000")
	return &BudgetCalculator{
		USDPerCreditFloor: floor,
		GrossMarginFloor:  margin,
	}
}

// ComputeQuotedCredits converts cost ceiling USD to credits using canonical pricing formula:
// credits = ceil(cost_usd / (usd_per_credit_floor * (1 - gross_margin_floor)))
func (b *BudgetCalculator) ComputeQuotedCredits(costUSD tenantdb.ExactDecimal) (tenantdb.ExactDecimal, error) {
	if costUSD.IsZero() || costUSD.IsNegative() {
		return tenantdb.ZeroDecimal(), nil
	}
	return tenantdb.ComputeQuotedCredits(costUSD, b.USDPerCreditFloor, b.GrossMarginFloor)
}

// ValidateSingleInput inspects a single generation request input.
func (b *BudgetCalculator) ValidateSingleInput(title, prompt, aspectRatio string) (bool, string) {
	if strings.TrimSpace(title) == "" {
		return false, "title cannot be empty"
	}
	if strings.TrimSpace(prompt) == "" {
		return false, "prompt cannot be empty"
	}
	if len(prompt) < 5 {
		return false, "prompt must be at least 5 characters"
	}
	validRatios := map[string]bool{
		"9:16": true, "16:9": true, "1:1": true, "4:5": true,
	}
	if aspectRatio != "" && !validRatios[aspectRatio] {
		return false, fmt.Sprintf("unsupported aspect ratio %q (allowed: 9:16, 16:9, 1:1, 4:5)", aspectRatio)
	}
	return true, ""
}

// ValidateBatchRow validates an individual row in a batch (e.g. product showcase or multi-merge).
func (b *BudgetCalculator) ValidateBatchRow(row BatchRowInput, rateUSDPerSec tenantdb.ExactDecimal) BatchRowValidationResult {
	res := BatchRowValidationResult{
		Index:    row.Index,
		ItemID:   row.ItemID,
		ItemName: row.ItemName,
		IsValid:  true,
	}

	// 1. Name or Title check
	if strings.TrimSpace(row.ItemName) == "" && strings.TrimSpace(row.Prompt) == "" {
		res.IsValid = false
		res.ValidationError = "missing required item name and prompt"
		return res
	}

	// 2. Reference URL check if provided
	if row.ReferenceURL != "" {
		parsed, err := url.ParseRequestURI(row.ReferenceURL)
		if err != nil || (parsed.Scheme != "http" && parsed.Scheme != "https") {
			res.IsValid = false
			res.ValidationError = fmt.Sprintf("invalid reference URL %q; must be valid HTTP/HTTPS URL", row.ReferenceURL)
			return res
		}
	}

	// 3. Image URLs check if provided
	for _, imgURL := range row.ImageURLs {
		if imgURL != "" {
			parsed, err := url.ParseRequestURI(imgURL)
			if err != nil || (parsed.Scheme != "http" && parsed.Scheme != "https") {
				res.IsValid = false
				res.ValidationError = fmt.Sprintf("invalid image URL %q; must be valid HTTP/HTTPS URL", imgURL)
				return res
			}
		}
	}

	// Default per-item duration: 15 seconds
	durSecs, _ := tenantdb.ParseExactDecimal("15.000000")
	costUSD, _ := durSecs.MulFloor(rateUSDPerSec)
	credits, _ := b.ComputeQuotedCredits(costUSD)

	res.EstimatedCostUSD = costUSD
	res.EstimatedCredits = credits
	return res
}

// PreviewBatchBudget satisfies Acceptance Target 3:
// "Budget preview and partial batch input validation"
// Given a batch (e.g. 20 products), inspects each row, calculates cost ONLY for valid rows,
// zeroes out invalid rows with detailed error messages, and bounds quotes and balances.
func (b *BudgetCalculator) PreviewBatchBudget(ctx context.Context, rows []BatchRowInput, rateUSDPerSec tenantdb.ExactDecimal, availableCredits tenantdb.ExactDecimal) BatchBudgetPreviewResult {
	var (
		totalCredits = tenantdb.ZeroDecimal()
		totalCostUSD = tenantdb.ZeroDecimal()
		validCount   = 0
		invalidCount = 0
		rowResults   = make([]BatchRowValidationResult, len(rows))
	)

	for i, row := range rows {
		row.Index = i
		result := b.ValidateBatchRow(row, rateUSDPerSec)
		if result.IsValid {
			validCount++
			totalCredits, _ = totalCredits.Add(result.EstimatedCredits)
			totalCostUSD, _ = totalCostUSD.Add(result.EstimatedCostUSD)
		} else {
			invalidCount++
			// RULE-M07-006 & Section 28: Invalid rows are NEVER charged credits or costs
			result.EstimatedCredits = tenantdb.ZeroDecimal()
			result.EstimatedCostUSD = tenantdb.ZeroDecimal()
		}
		rowResults[i] = result
	}

	quoteID := fmt.Sprintf("quote-batch-%d", time.Now().UnixNano())
	sufficient := availableCredits.Cmp(totalCredits) >= 0

	return BatchBudgetPreviewResult{
		TotalEstimatedCredits:   totalCredits,
		TotalCostCeilingUSD:     totalCostUSD,
		TotalItems:              len(rows),
		ValidItemsCount:         validCount,
		InvalidItemsCount:       invalidCount,
		Items:                   rowResults,
		SufficientCredits:       sufficient,
		CurrentAvailableCredits: availableCredits,
		QuoteID:                 quoteID,
		QuoteExpiresAt:          time.Now().Add(5 * time.Minute).UTC(),
	}
}
