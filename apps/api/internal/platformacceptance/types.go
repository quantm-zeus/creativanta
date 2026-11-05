// Package platformacceptance implements the Full-Scope Acceptance and Release
// Decision Engine for Creativanta Task P8-09.
//
// Canonical Sources:
// - docs/00_index/BUILD_INDEX.md (31 Modules / Specs, 6 Operator Modes)
// - docs/00_index/BUILD_EXECUTION_CONTRACT.md (§1 Meaning of ready, §6 Full-scope completion, §7 Source-linked handoff)
// - docs/00_index/AGENT_BUILD_BACKLOG.md (§4 Phase acceptance rules)
// - docs/02_features/platform/home_decision_engine.md (M01, RULE-M01-001..007)
// - docs/02_features/platform/reporting_admin_billing.md (M23/S26, RULE-M23-B01)
// - docs/04_contracts/database_schema.md (§4, §15, §26, §27)
// - docs/04_contracts/rpc_permission_bindings.csv
package platformacceptance

import (
	"context"
	"errors"
	"time"
)

var (
	ErrUnauthenticated              = errors.New("platformacceptance: unauthenticated request")
	ErrPermissionDenied             = errors.New("platformacceptance: caller role is not authorized for this action")
	ErrInvalidOperatorMode          = errors.New("platformacceptance: invalid operator mode; must be one of 6 canonical modes")
	ErrExternalGatesUnsatisfied     = errors.New("platformacceptance: cannot approve full production launch while external gates remain open")
	ErrManifestNotFound             = errors.New("platformacceptance: required phase manifest not found")
	ErrUntrackedRemainingScopeFound = errors.New("platformacceptance: untracked remaining scope found in final release candidate")
	ErrTamperedManifestChecksum     = errors.New("platformacceptance: manifest checksum or integrity check failed")
)

// ReleaseDecisionStatus represents the evaluated release state.
type ReleaseDecisionStatus string

const (
	DecisionConditionalReadyLocal ReleaseDecisionStatus = "CONDITIONAL_READY_LOCAL"
	DecisionReleaseBlocked        ReleaseDecisionStatus = "RELEASE_BLOCKED"
	DecisionLaunchApproved        ReleaseDecisionStatus = "LAUNCH_APPROVED"
)

// Canonical 31 Module definitions per docs/00_index/BUILD_INDEX.md and docs/00_index/agent_task_catalog.json.
type ModuleInfo struct {
	ID             string `json:"id"`
	Name           string `json:"name"`
	Domain         string `json:"domain"`
	TargetDoc      string `json:"target_doc"`
	DefaultTask    string `json:"default_task"`
	CompletionTask string `json:"completion_task"`
}

// CanonicalTaskSpec defines a task entry in the 60-task DAG per docs/00_index/agent_task_catalog.json.
type CanonicalTaskSpec struct {
	TaskID  string   `json:"task_id"`
	Phase   string   `json:"phase"`
	Modules []string `json:"modules"`
}

// Canonical 6 Operator Modes per docs/01_business/user_segments_and_modes.md and PRD §8.2.
type OperatorModeInfo struct {
	ModeID      string `json:"mode_id"`
	DisplayName string `json:"display_name"`
	CardCount   int    `json:"card_count"`
	TargetActor string `json:"target_actor"`
}

// ExternalGateInfo models an explicit external gate that cannot be bypassed.
type ExternalGateInfo struct {
	GateID                     string `json:"gate_id"`
	Owner                      string `json:"owner"`
	Status                     string `json:"status"`
	Description                string `json:"description"`
	IsBlockingProductionLaunch bool   `json:"is_blocking_production_launch"`
}

// CallerContext models the authenticated caller context.
type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string // e.g. "owner", "admin", "manager", "editor", "contributor", "viewer"
	AdminRole     string // e.g. "super_admin", "ops_admin", "auditor", "tech_admin", "support_admin"
	IsAdmin       bool
}

type callerCtxKey struct{}

// WithCallerContext attaches CallerContext to ctx.
func WithCallerContext(ctx context.Context, caller CallerContext) context.Context {
	return context.WithValue(ctx, callerCtxKey{}, caller)
}

// CallerFromContext extracts CallerContext from ctx.
func CallerFromContext(ctx context.Context) (CallerContext, bool) {
	if ctx == nil {
		return CallerContext{}, false
	}
	c, ok := ctx.Value(callerCtxKey{}).(CallerContext)
	return c, ok
}

// ReconcileFullScopeRequest specifies parameters for reconciling the platform.
type ReconcileFullScopeRequest struct {
	Environment              string `json:"environment"` // "local", "rehearsal", "staging", "production"
	ReleaseCandidateVersion  string `json:"release_candidate_version"`
	IncludeExternalGateCheck bool   `json:"include_external_gate_check"`
	AssertProductionLaunch   bool   `json:"assert_production_launch"` // If true, caller asserts production readiness (must fail if external gates open)
}

// ModuleReconciliationResult captures the audit state of an individual module.
type ModuleReconciliationResult struct {
	ModuleID           string   `json:"module_id"`
	Name               string   `json:"name"`
	Domain             string   `json:"domain"`
	Verified           bool     `json:"verified"`
	DeliveryTask       string   `json:"delivery_task"`
	AcceptanceTask     string   `json:"acceptance_task"`
	VerifiedFeatures   []string `json:"verified_features"`
	EvidenceSignatures []string `json:"evidence_signatures"`
}

// OperatorModeReconciliationResult captures the audit state of an operator mode.
type OperatorModeReconciliationResult struct {
	ModeID            string   `json:"mode_id"`
	DisplayName       string   `json:"display_name"`
	Verified          bool     `json:"verified"`
	DecisionCardCount int      `json:"decision_card_count"`
	AvailableRoutes   []string `json:"available_routes"`
}

// TaskManifestSummary captures the verified state of a build task manifest.
type TaskManifestSummary struct {
	TaskID               string   `json:"task_id"`
	Phase                string   `json:"phase"`
	Title                string   `json:"title"`
	Status               string   `json:"status"`
	SubsliceStatus       string   `json:"subslice_status,omitempty"`
	AcceptanceStatus     string   `json:"acceptance_status,omitempty"`
	RemainingScopeCount  int      `json:"remaining_scope_count"`
	RemainingScopeItems  []string `json:"remaining_scope_items"`
	SourceFileCount      int      `json:"source_file_count"`
	VerifiedSourceHashes int      `json:"verified_source_hashes"`
	EvidenceCount        int      `json:"evidence_count"`
	ExternalGatesPending bool     `json:"external_gates_pending"`
	Verified             bool     `json:"verified"`
	ManifestSha256       string   `json:"manifest_sha256"`
}

// FullScopeReconciliationReport contains the complete evidence-backed audit across all dimensions.
type FullScopeReconciliationReport struct {
	Environment              string                             `json:"environment"`
	ReleaseCandidateVersion  string                             `json:"release_candidate_version"`
	AcceptanceStatus         string                             `json:"acceptance_status"`
	TotalModules             int                                `json:"total_modules"`
	TotalOperatorModes       int                                `json:"total_operator_modes"`
	TotalBuildTasks          int                                `json:"total_build_tasks"`
	TotalRequirementUnits    int                                `json:"total_requirements"`
	TotalScreenAssignments   int                                `json:"total_screens"`
	TotalRpcBindings         int                                `json:"total_rpc_bindings"`
	TotalTenantTables        int                                `json:"total_tenant_tables"`
	AllManifestsVerified     bool                               `json:"all_manifests_verified"`
	ZeroUntrackedScope       bool                               `json:"zero_untracked_scope"`
	UnmetExternalGatesCount  int                                `json:"unmet_external_gates_count"`
	ProductionLaunchApproved bool                               `json:"production_launch_approved"`
	ReleaseDecision          ReleaseDecisionStatus              `json:"release_decision"`
	Modules                  []ModuleReconciliationResult       `json:"modules"`
	OperatorModes            []OperatorModeReconciliationResult `json:"operator_modes"`
	TaskManifests            []TaskManifestSummary              `json:"task_manifests"`
	ExternalGates            []ExternalGateInfo                 `json:"external_gates"`
	IntegritySha256          string                             `json:"integrity_sha256"`
	EvaluatedAt              time.Time                          `json:"evaluated_at"`
	EvaluatedByAdminID       string                             `json:"evaluated_by_admin_id"`
	Notes                    string                             `json:"notes"`
}

// WorkspaceSignoffRequest allows a workspace owner to verify their workspace readiness.
type WorkspaceSignoffRequest struct {
	WorkspaceID                string   `json:"workspace_id"`
	OperatorMode               string   `json:"operator_mode"`
	CompletedOnboardingStepIDs []string `json:"completed_onboarding_step_ids,omitempty"`
	Notes                      string   `json:"notes"`
}

// WorkspaceSignoffRecord stores a tenant-level acceptance verification.
type WorkspaceSignoffRecord struct {
	SignoffID               string    `json:"signoff_id"`
	WorkspaceID             string    `json:"workspace_id"`
	OperatorMode            string    `json:"operator_mode"`
	ReviewedByUserID        string    `json:"reviewed_by_user_id"`
	SixModesVerified        bool      `json:"six_modes_verified"`
	OnboardingLoopCompleted bool      `json:"onboarding_loop_completed"`
	VerifiedModulesCount    int       `json:"verified_modules_count"`
	Status                  string    `json:"status"`
	SignoffNotes            string    `json:"signoff_notes"`
	SignoffDigest           string    `json:"signoff_digest"`
	CreatedAt               time.Time `json:"created_at"`
}
