package home

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

// Canonical SourceClass values preserved uncollapsed per docs/04_contracts/database_schema.md (§3)
// and docs/06_quality_ops/analytics_event_taxonomy.md (§6).
const (
	SourceClassOfficial     = "official"
	SourceClassImported     = "imported"
	SourceClassInferred     = "inferred"
	SourceClassEstimated    = "estimated"
	SourceClassUnreconciled = "unreconciled"
)

// Canonical ConfidenceBand values preserved uncollapsed (5 bands — NEVER collapse medium_high or low_medium)
// per docs/04_contracts/database_schema.md (§3) and docs/06_quality_ops/analytics_event_taxonomy.md (§6).
const (
	ConfidenceBandHigh       = "high"
	ConfidenceBandMediumHigh = "medium_high"
	ConfidenceBandMedium     = "medium"
	ConfidenceBandLowMedium  = "low_medium"
	ConfidenceBandLow        = "low"
)

// PilotObservation represents a single P1 validation telemetry observation.
// Deduplicated by (WorkspaceID, ObjectID, OperationID).
type PilotObservation struct {
	WorkspaceID string
	ObjectID    string
	OperationID string

	// Hygiene flags: any true value excludes the observation from customer pilot reports.
	IsDemoFixture     bool
	IsTestAccount     bool
	IsInternalAccount bool

	// Uncollapsed provenance & confidence bands.
	SourceClass    string // official, imported, inferred, estimated, unreconciled
	ConfidenceBand string // high, medium_high, medium, low_medium, low
	OperatorMode   string
	ObservedAt     time.Time

	// 1. First value (onboarding + profit_dashboard_viewed with source/gap disclosure)
	Kind                      string // "first_value_view", "operating_loop", "retention_activity", "repair_batch", "production_job", "unit_economics"
	WorkspaceCreatedAt        *time.Time
	FirstSnapshotViewedAt     *time.Time
	HasSourceAndGapDisclosure bool

	// 2. Weekly proofed operating loops
	PublishObjectID              string
	HasCompletedOrder            bool
	HasVersionedProfitProjection bool
	EvidenceReviewed             bool
	UnresolvedRequiredGapsCount  int

	// 3. Weekly operator retention
	CohortWeek                int
	WorkspaceEligibleForWeek  bool
	WorkspaceCensored         bool
	PerformedRealDomainAction bool
	PerformedEvidenceReview   bool
	LoginOrPageViewOnly       bool

	// 4. Repair burden (missing operator time remains nil/unknown, NEVER 0)
	OperatorRepairSeconds *int64

	// 5 & 6. Usable production yield & Cost per accepted output
	AssetType                   string
	ProviderModel               string
	StartedProductionJob        bool
	AcceptedWithinBoundedPasses bool
	SettledProviderCostMicros   int64 // USD in 10^-6 micro-units
	SettledCreditsMicros        int64 // Credits in 10^-6 micro-units

	// 7. Net unit economics (all amounts in integer micro-units; nil component means unknown, NEVER 0)
	RecognizedRevenueMicros int64
	PlatformFeesMicros      *int64
	ShippingCostsMicros     *int64
	RefundsMicros           *int64
	COGSMicros              *int64
	AffiliatePayoutMicros   *int64
	AdSeedingSpendMicros    *int64
}

// FirstValueSummary reports P1 First Value latency and missingness.
type FirstValueSummary struct {
	EligibleWorkspacesCount       int
	ReachedFirstValueCount        int
	UnknownLatencyWorkspacesCount int
	MedianFirstValueSeconds       *int64
	MedianKnown                   bool
	ImpliesFullClosedLoop         bool // Always false in P1
	ImpliesVerifiedProfit         bool // Always false in P1
}

// ProofedLoopsSummary reports Weekly Proofed Operating Loops.
type ProofedLoopsSummary struct {
	DistinctCandidatePublishObjects int
	ProofCompleteLoopsCount         int
	OfficialProofLoopsCount         int
	ImportedOrManualProofLoopsCount int
	ExcludedUnresolvedGapLoopsCount int
	ExcludedUnreviewedLoopsCount    int
}

// RetentionSummary reports Weekly Operator Retention.
type RetentionSummary struct {
	EligibleCohortSize               int
	CensoredWorkspacesCount          int
	RetainedWorkspacesCount          int
	ExcludedLoginOrPageViewOnlyCount int
	RetentionRateKnown               bool
	RetentionRateBasisPoints         *int64 // 0..10000 when EligibleCohortSize > 0
}

// RepairBurdenSummary reports P1 Repair Burden per imported batch/report.
// Missing operator time tracking remains explicitly unknown (nil), NEVER 0.
type RepairBurdenSummary struct {
	TotalImportedBatchesCount         int
	KnownOperatorTimeBatchesCount     int
	UnknownOperatorTimeBatchesCount   int
	OperatorTimeKnown                 bool
	MedianOperatorRepairSeconds       *int64 // nil when KnownOperatorTimeBatchesCount == 0
	MedianUnresolvedRequiredGapsCount *int
	MissingTimeTrackingDisclosure     string
}

// ProductionYieldAndCostSummary reports Usable Production Yield and Cost per Accepted Output.
// Zero accepted outputs makes Cost per Accepted Output undefined/unknown, NEVER zero cost.
type ProductionYieldAndCostSummary struct {
	StartedJobsCount               int
	AcceptedOutputsCount           int
	YieldKnown                     bool
	YieldBasisPoints               *int64
	CostPerAcceptedOutputKnown     bool
	CostPerAcceptedOutputStatus    string // "computed" or "undefined_zero_accepted_outputs"
	CostUSDPerAcceptedMicros       *int64 // nil when AcceptedOutputsCount == 0
	CreditsPerAcceptedMicros       *int64 // nil when AcceptedOutputsCount == 0
	TotalSettledProviderCostMicros int64
	TotalSettledCreditsMicros      int64
}

// NetUnitEconomicsSummary reports Net Unit Economics and explicit unknown cost missingness.
type NetUnitEconomicsSummary struct {
	EvaluatedScopesCount       int
	CompleteScopesCount        int
	IncompleteScopesCount      int
	HasUnknownCosts            bool
	UnknownComponentCounts     map[string]int // e.g. {"cogs": 2, "shipping": 1}
	RecognizedRevenueMicros    int64
	KnownCostsTotalMicros      int64
	NetKnownContributionMicros int64
	MissingnessDisclosure      string
}

// PilotCohortReport is the complete P1 pilot measurement report per analytics_event_taxonomy.md §6.
type PilotCohortReport struct {
	ObservationWindowStart      time.Time
	ObservationWindowEnd        time.Time
	TotalRawObservations        int
	ExcludedDemoOrInternalCount int
	DeduplicatedDuplicatesCount int
	SampleSize                  int
	SourceClassDistribution     map[string]int // official, imported, inferred, estimated, unreconciled
	ConfidenceBandDistribution  map[string]int // high, medium_high, medium, low_medium, low (never collapsed)
	FirstValue                  FirstValueSummary
	WeeklyProofedOperatingLoops ProofedLoopsSummary
	WeeklyOperatorRetention     RetentionSummary
	RepairBurden                RepairBurdenSummary
	ProductionYieldAndCost      ProductionYieldAndCostSummary
	NetUnitEconomics            NetUnitEconomicsSummary
}

// RecordPilotObservation records a P1 pilot telemetry observation on the Home service.
func (s *Service) RecordPilotObservation(obs PilotObservation) error {
	if strings.TrimSpace(obs.WorkspaceID) == "" || strings.TrimSpace(obs.ObjectID) == "" || strings.TrimSpace(obs.OperationID) == "" {
		return fmt.Errorf("%w: pilot observation requires workspace_id, object_id, and operation_id", ErrInvalidInput)
	}
	if obs.ObservedAt.IsZero() {
		obs.ObservedAt = time.Now().UTC()
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	s.pilotObservations = append(s.pilotObservations, obs)
	return nil
}

// BuildPilotCohortReport evaluates recorded P1 pilot observations over [windowStart, windowEnd]
// and produces a truthful PilotCohortReport.
//
// Enforces P1-05 Acceptance Target #4 ("P1 pilot measurements record actual unknowns"):
//   - Excludes demo, test, and internal accounts.
//   - Deduplicates by (workspace_id, object_id, operation_id).
//   - Preserves all 5 canonical source_class values and all 5 canonical confidence_band values uncollapsed.
//   - Missing operator repair time in repair_burden remains nil/unknown (never 0).
//   - Zero accepted outputs makes cost_per_accepted_output undefined/unknown (never 0).
//   - Missing required cost components (COGS, shipping, fees, etc.) are counted as explicit unknowns in net_unit_economics.
func (s *Service) BuildPilotCohortReport(windowStart, windowEnd time.Time) PilotCohortReport {
	s.mu.RLock()
	rawCopy := make([]PilotObservation, len(s.pilotObservations))
	copy(rawCopy, s.pilotObservations)
	s.mu.RUnlock()

	return EvaluatePilotCohort(rawCopy, windowStart, windowEnd)
}

// EvaluatePilotCohort is a pure deterministic aggregator for P1 pilot observations.
func EvaluatePilotCohort(observations []PilotObservation, windowStart, windowEnd time.Time) PilotCohortReport {
	report := PilotCohortReport{
		ObservationWindowStart: windowStart.UTC(),
		ObservationWindowEnd:   windowEnd.UTC(),
		TotalRawObservations:   len(observations),
		SourceClassDistribution: map[string]int{
			SourceClassOfficial:     0,
			SourceClassImported:     0,
			SourceClassInferred:     0,
			SourceClassEstimated:    0,
			SourceClassUnreconciled: 0,
		},
		ConfidenceBandDistribution: map[string]int{
			ConfidenceBandHigh:       0,
			ConfidenceBandMediumHigh: 0,
			ConfidenceBandMedium:     0,
			ConfidenceBandLowMedium:  0,
			ConfidenceBandLow:        0,
		},
		FirstValue: FirstValueSummary{
			ImpliesFullClosedLoop: false,
			ImpliesVerifiedProfit: false,
		},
		NetUnitEconomics: NetUnitEconomicsSummary{
			UnknownComponentCounts: map[string]int{
				"platform_fees":    0,
				"shipping_costs":   0,
				"refunds":          0,
				"cogs":             0,
				"affiliate_payout": 0,
				"ad_seeding_spend": 0,
			},
		},
	}

	seenIdentity := make(map[string]struct{})
	var validObs []PilotObservation

	for _, obs := range observations {
		if !windowStart.IsZero() && obs.ObservedAt.Before(windowStart) {
			continue
		}
		if !windowEnd.IsZero() && obs.ObservedAt.After(windowEnd) {
			continue
		}
		// Rule: Exclude demo, test, and internal accounts.
		if obs.IsDemoFixture || obs.IsTestAccount || obs.IsInternalAccount {
			report.ExcludedDemoOrInternalCount++
			continue
		}
		// Rule: Deduplicate by (workspace_id, object_id, operation_id).
		dedupKey := fmt.Sprintf("%s|%s|%s", strings.TrimSpace(obs.WorkspaceID), strings.TrimSpace(obs.ObjectID), strings.TrimSpace(obs.OperationID))
		if _, dup := seenIdentity[dedupKey]; dup {
			report.DeduplicatedDuplicatesCount++
			continue
		}
		seenIdentity[dedupKey] = struct{}{}
		validObs = append(validObs, obs)

		if sc := strings.TrimSpace(obs.SourceClass); sc != "" {
			report.SourceClassDistribution[sc]++
		}
		if cb := strings.TrimSpace(obs.ConfidenceBand); cb != "" {
			report.ConfidenceBandDistribution[cb]++
		}
	}

	report.SampleSize = len(validObs)

	// 1. First value aggregation (deduplicated per workspace).
	firstValueSeenWS := make(map[string]bool)
	var knownFirstValueLatencies []int64

	// 2. Weekly proofed operating loops (count each publish object once).
	type loopState struct {
		hasCompletedOrder  bool
		hasVersionedProfit bool
		evidenceReviewed   bool
		unresolvedGaps     int
		sourceClass        string
	}
	publishLoops := make(map[string]*loopState)

	// 3. Weekly operator retention (per workspace).
	type wsRetentionState struct {
		eligible        bool
		censored        bool
		realAction      bool
		loginOrViewOnly bool
	}
	retentionByWS := make(map[string]*wsRetentionState)

	// 4. Repair burden.
	var knownRepairTimes []int64
	var unresolvedGapCounts []int

	for _, obs := range validObs {
		switch obs.Kind {
		case "first_value_view":
			if firstValueSeenWS[obs.WorkspaceID] {
				continue
			}
			firstValueSeenWS[obs.WorkspaceID] = true
			report.FirstValue.EligibleWorkspacesCount++
			if obs.HasSourceAndGapDisclosure && obs.WorkspaceCreatedAt != nil && obs.FirstSnapshotViewedAt != nil && !obs.FirstSnapshotViewedAt.Before(*obs.WorkspaceCreatedAt) {
				report.FirstValue.ReachedFirstValueCount++
				secs := int64(obs.FirstSnapshotViewedAt.Sub(*obs.WorkspaceCreatedAt).Seconds())
				knownFirstValueLatencies = append(knownFirstValueLatencies, secs)
			} else {
				report.FirstValue.UnknownLatencyWorkspacesCount++
			}

		case "operating_loop":
			pubID := strings.TrimSpace(obs.PublishObjectID)
			if pubID == "" {
				pubID = strings.TrimSpace(obs.ObjectID)
			}
			pubKey := obs.WorkspaceID + "|" + pubID
			ls, exists := publishLoops[pubKey]
			if !exists {
				ls = &loopState{
					hasCompletedOrder:  obs.HasCompletedOrder,
					hasVersionedProfit: obs.HasVersionedProfitProjection,
					evidenceReviewed:   obs.EvidenceReviewed,
					unresolvedGaps:     obs.UnresolvedRequiredGapsCount,
					sourceClass:        obs.SourceClass,
				}
				publishLoops[pubKey] = ls
			} else {
				ls.hasCompletedOrder = ls.hasCompletedOrder || obs.HasCompletedOrder
				ls.hasVersionedProfit = ls.hasVersionedProfit || obs.HasVersionedProfitProjection
				ls.evidenceReviewed = ls.evidenceReviewed || obs.EvidenceReviewed
				if obs.UnresolvedRequiredGapsCount > ls.unresolvedGaps {
					ls.unresolvedGaps = obs.UnresolvedRequiredGapsCount
				}
			}

		case "retention_activity":
			rs, exists := retentionByWS[obs.WorkspaceID]
			if !exists {
				rs = &wsRetentionState{}
				retentionByWS[obs.WorkspaceID] = rs
			}
			if obs.WorkspaceCensored {
				rs.censored = true
			}
			if obs.WorkspaceEligibleForWeek {
				rs.eligible = true
			}
			if obs.PerformedRealDomainAction || obs.PerformedEvidenceReview {
				rs.realAction = true
			} else if obs.LoginOrPageViewOnly {
				rs.loginOrViewOnly = true
			}

		case "repair_batch":
			report.RepairBurden.TotalImportedBatchesCount++
			unresolvedGapCounts = append(unresolvedGapCounts, obs.UnresolvedRequiredGapsCount)
			if obs.OperatorRepairSeconds == nil {
				// CRITICAL RULE: Missing time tracking remains unknown, NEVER zero!
				report.RepairBurden.UnknownOperatorTimeBatchesCount++
			} else {
				report.RepairBurden.KnownOperatorTimeBatchesCount++
				knownRepairTimes = append(knownRepairTimes, *obs.OperatorRepairSeconds)
			}

		case "production_job":
			if obs.StartedProductionJob {
				report.ProductionYieldAndCost.StartedJobsCount++
			}
			if obs.AcceptedWithinBoundedPasses {
				report.ProductionYieldAndCost.AcceptedOutputsCount++
			}
			report.ProductionYieldAndCost.TotalSettledProviderCostMicros += obs.SettledProviderCostMicros
			report.ProductionYieldAndCost.TotalSettledCreditsMicros += obs.SettledCreditsMicros

		case "unit_economics":
			report.NetUnitEconomics.EvaluatedScopesCount++
			report.NetUnitEconomics.RecognizedRevenueMicros += obs.RecognizedRevenueMicros
			scopeHasUnknown := false
			var scopeKnownCosts int64

			checkComponent := func(name string, val *int64) {
				if val == nil {
					scopeHasUnknown = true
					report.NetUnitEconomics.HasUnknownCosts = true
					report.NetUnitEconomics.UnknownComponentCounts[name]++
				} else {
					scopeKnownCosts += *val
				}
			}
			checkComponent("platform_fees", obs.PlatformFeesMicros)
			checkComponent("shipping_costs", obs.ShippingCostsMicros)
			checkComponent("refunds", obs.RefundsMicros)
			checkComponent("cogs", obs.COGSMicros)
			checkComponent("affiliate_payout", obs.AffiliatePayoutMicros)
			checkComponent("ad_seeding_spend", obs.AdSeedingSpendMicros)
			scopeKnownCosts += obs.SettledProviderCostMicros

			report.NetUnitEconomics.KnownCostsTotalMicros += scopeKnownCosts
			if scopeHasUnknown {
				report.NetUnitEconomics.IncompleteScopesCount++
			} else {
				report.NetUnitEconomics.CompleteScopesCount++
			}
		}
	}

	// Finalize 1. First value median.
	if len(knownFirstValueLatencies) > 0 {
		med := medianInt64(knownFirstValueLatencies)
		report.FirstValue.MedianFirstValueSeconds = &med
		report.FirstValue.MedianKnown = true
	}

	// Finalize 2. Weekly proofed operating loops.
	report.WeeklyProofedOperatingLoops.DistinctCandidatePublishObjects = len(publishLoops)
	for _, ls := range publishLoops {
		if ls.unresolvedGaps > 0 {
			report.WeeklyProofedOperatingLoops.ExcludedUnresolvedGapLoopsCount++
			continue
		}
		if !ls.hasCompletedOrder || !ls.hasVersionedProfit || !ls.evidenceReviewed {
			report.WeeklyProofedOperatingLoops.ExcludedUnreviewedLoopsCount++
			continue
		}
		report.WeeklyProofedOperatingLoops.ProofCompleteLoopsCount++
		if ls.sourceClass == SourceClassOfficial {
			report.WeeklyProofedOperatingLoops.OfficialProofLoopsCount++
		} else {
			report.WeeklyProofedOperatingLoops.ImportedOrManualProofLoopsCount++
		}
	}

	// Finalize 3. Weekly operator retention.
	for _, rs := range retentionByWS {
		if rs.censored {
			report.WeeklyOperatorRetention.CensoredWorkspacesCount++
			continue
		}
		if !rs.eligible {
			continue
		}
		report.WeeklyOperatorRetention.EligibleCohortSize++
		if rs.realAction {
			report.WeeklyOperatorRetention.RetainedWorkspacesCount++
		} else if rs.loginOrViewOnly {
			report.WeeklyOperatorRetention.ExcludedLoginOrPageViewOnlyCount++
		}
	}
	if report.WeeklyOperatorRetention.EligibleCohortSize > 0 {
		bps := int64(report.WeeklyOperatorRetention.RetainedWorkspacesCount*10000) / int64(report.WeeklyOperatorRetention.EligibleCohortSize)
		report.WeeklyOperatorRetention.RetentionRateBasisPoints = &bps
		report.WeeklyOperatorRetention.RetentionRateKnown = true
	}

	// Finalize 4. Repair burden (missing operator time remains nil/unknown, never 0).
	if len(unresolvedGapCounts) > 0 {
		medGaps := medianInt(unresolvedGapCounts)
		report.RepairBurden.MedianUnresolvedRequiredGapsCount = &medGaps
	}
	if len(knownRepairTimes) > 0 {
		medTime := medianInt64(knownRepairTimes)
		report.RepairBurden.MedianOperatorRepairSeconds = &medTime
		report.RepairBurden.OperatorTimeKnown = true
	} else {
		report.RepairBurden.MedianOperatorRepairSeconds = nil
		report.RepairBurden.OperatorTimeKnown = false
	}
	if report.RepairBurden.UnknownOperatorTimeBatchesCount > 0 {
		report.RepairBurden.MissingTimeTrackingDisclosure = fmt.Sprintf(
			"%d/%d imported batches have unknown operator repair duration; recorded as unknown (never 0)",
			report.RepairBurden.UnknownOperatorTimeBatchesCount,
			report.RepairBurden.TotalImportedBatchesCount,
		)
	} else {
		report.RepairBurden.MissingTimeTrackingDisclosure = "all evaluated batches reported measured operator repair duration"
	}

	// Finalize 5 & 6. Usable production yield & Cost per accepted output.
	if report.ProductionYieldAndCost.StartedJobsCount > 0 {
		bps := int64(report.ProductionYieldAndCost.AcceptedOutputsCount*10000) / int64(report.ProductionYieldAndCost.StartedJobsCount)
		report.ProductionYieldAndCost.YieldBasisPoints = &bps
		report.ProductionYieldAndCost.YieldKnown = true
	}
	if report.ProductionYieldAndCost.AcceptedOutputsCount == 0 {
		// CRITICAL RULE: Zero accepted outputs makes cost_per_accepted_output undefined/unknown, NOT zero cost!
		report.ProductionYieldAndCost.CostPerAcceptedOutputKnown = false
		report.ProductionYieldAndCost.CostPerAcceptedOutputStatus = "undefined_zero_accepted_outputs"
		report.ProductionYieldAndCost.CostUSDPerAcceptedMicros = nil
		report.ProductionYieldAndCost.CreditsPerAcceptedMicros = nil
	} else {
		acc := int64(report.ProductionYieldAndCost.AcceptedOutputsCount)
		usdPerAcc := report.ProductionYieldAndCost.TotalSettledProviderCostMicros / acc
		credPerAcc := report.ProductionYieldAndCost.TotalSettledCreditsMicros / acc
		report.ProductionYieldAndCost.CostPerAcceptedOutputKnown = true
		report.ProductionYieldAndCost.CostPerAcceptedOutputStatus = "computed"
		report.ProductionYieldAndCost.CostUSDPerAcceptedMicros = &usdPerAcc
		report.ProductionYieldAndCost.CreditsPerAcceptedMicros = &credPerAcc
	}

	// Finalize 7. Net unit economics.
	report.NetUnitEconomics.NetKnownContributionMicros = report.NetUnitEconomics.RecognizedRevenueMicros - report.NetUnitEconomics.KnownCostsTotalMicros
	if report.NetUnitEconomics.HasUnknownCosts {
		report.NetUnitEconomics.MissingnessDisclosure = fmt.Sprintf(
			"%d/%d scopes have unknown required cost components (e.g. cogs=%d, shipping=%d); unknown costs are disclosed and never verified as zero",
			report.NetUnitEconomics.IncompleteScopesCount,
			report.NetUnitEconomics.EvaluatedScopesCount,
			report.NetUnitEconomics.UnknownComponentCounts["cogs"],
			report.NetUnitEconomics.UnknownComponentCounts["shipping_costs"],
		)
	} else {
		report.NetUnitEconomics.MissingnessDisclosure = "all evaluated unit-economics scopes have complete known cost components"
	}

	return report
}

func medianInt64(values []int64) int64 {
	cp := append([]int64(nil), values...)
	sort.Slice(cp, func(i, j int) bool { return cp[i] < cp[j] })
	n := len(cp)
	if n == 0 {
		return 0
	}
	if n%2 == 1 {
		return cp[n/2]
	}
	return (cp[n/2-1] + cp[n/2]) / 2
}

func medianInt(values []int) int {
	cp := append([]int(nil), values...)
	sort.Ints(cp)
	n := len(cp)
	if n == 0 {
		return 0
	}
	if n%2 == 1 {
		return cp[n/2]
	}
	return (cp[n/2-1] + cp[n/2]) / 2
}
