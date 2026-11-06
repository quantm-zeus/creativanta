package workflow

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
)

// CapabilityStatusProvider abstracts checking external platform capabilities (M22).
type CapabilityStatusProvider interface {
	GetPlatformCapability(ctx context.Context, workspaceID, platform, action string) (string, error)
}

// DefaultCapabilityProvider provides baseline capability lookup.
type DefaultCapabilityProvider struct {
	statuses map[string]string // key: platform:action or platform
}

func NewDefaultCapabilityProvider() *DefaultCapabilityProvider {
	return &DefaultCapabilityProvider{
		statuses: map[string]string{
			"tiktok":    "supported",
			"youtube":   "supported",
			"instagram": "supported",
			"facebook":  "supported",
			"shopee":    "supported",
			"lazada":    "supported",
		},
	}
}

func (p *DefaultCapabilityProvider) SetStatus(platform, status string) {
	if p.statuses == nil {
		p.statuses = make(map[string]string)
	}
	p.statuses[strings.ToLower(platform)] = strings.ToLower(status)
}

func (p *DefaultCapabilityProvider) GetPlatformCapability(ctx context.Context, workspaceID, platform, action string) (string, error) {
	if p.statuses == nil {
		return "supported", nil
	}
	key := strings.ToLower(platform)
	if action != "" {
		actionKey := fmt.Sprintf("%s:%s", key, strings.ToLower(action))
		if status, ok := p.statuses[actionKey]; ok {
			return status, nil
		}
	}
	if status, ok := p.statuses[key]; ok {
		return status, nil
	}
	return "supported", nil
}

// PreflightEngine evaluates graph actions, permissions, capabilities, and quotes.
type PreflightEngine struct {
	capProvider CapabilityStatusProvider
}

func NewPreflightEngine(capProvider CapabilityStatusProvider) *PreflightEngine {
	if capProvider == nil {
		capProvider = NewDefaultCapabilityProvider()
	}
	return &PreflightEngine{capProvider: capProvider}
}

// workflowActionPolicy defines the canonical RBAC permission and approval sensitivity for a workflow action RPC.
type workflowActionPolicy struct {
	PermissionKey string
	Sensitive     bool
}

// canonicalWorkflowActionPolicies maps normalized "service/method" keys (and symbolic action categories)
// to their canonical RBAC permission in docs/04_contracts/rbac_permission_matrix.md and RULE-M20-004 sensitivity.
var canonicalWorkflowActionPolicies = map[string]workflowActionPolicy{
	// Publishing
	"publishservice/publish":          {PermissionKey: "publish:create", Sensitive: true},
	"publishservice/execute":          {PermissionKey: "publish:execute", Sensitive: true},
	"publishservice/publishnow":       {PermissionKey: "publish:execute", Sensitive: true},
	"publishservice/schedule":         {PermissionKey: "publish:schedule", Sensitive: true},
	"publishservice/createitem":       {PermissionKey: "publish:create", Sensitive: false},
	"publishservice/reconcilepublish": {PermissionKey: "publish:execute", Sensitive: true},
	"publish":                         {PermissionKey: "publish:execute", Sensitive: true},

	// Commerce: Offers & Monetization
	"offerservice/activate":             {PermissionKey: "offer:activate", Sensitive: true},
	"offerservice/activateoffer":        {PermissionKey: "offer:activate", Sensitive: true},
	"monetizationservice/activateoffer": {PermissionKey: "offer:activate", Sensitive: true},
	"monetizationservice/activate":      {PermissionKey: "offer:activate", Sensitive: true},
	"monetization/activate":             {PermissionKey: "offer:activate", Sensitive: true},
	"offer_activation":                  {PermissionKey: "offer:activate", Sensitive: true},
	"offerservice/updateprice":          {PermissionKey: "offer:price_change", Sensitive: true},
	"offerservice/changeprice":          {PermissionKey: "offer:price_change", Sensitive: true},
	"price_change":                      {PermissionKey: "offer:price_change", Sensitive: true},
	"offerservice/create":               {PermissionKey: "offer:manage", Sensitive: false},
	"offerservice/update":               {PermissionKey: "offer:manage", Sensitive: false},
	"offerservice/deactivate":           {PermissionKey: "offer:manage", Sensitive: true},

	// Commerce: Products & Inventory
	"inventoryservice/reservestock": {PermissionKey: "product:manage", Sensitive: false},
	"inventoryservice/adjuststock":  {PermissionKey: "product:manage", Sensitive: false},
	"productservice/create":         {PermissionKey: "product:manage", Sensitive: false},
	"productservice/update":         {PermissionKey: "product:manage", Sensitive: false},
	"productservice/delete":         {PermissionKey: "product:delete", Sensitive: true},
	"productservice/deleteproduct":  {PermissionKey: "product:delete", Sensitive: true},
	"productservice/archive":        {PermissionKey: "product:delete", Sensitive: true},
	"destructive_archive":           {PermissionKey: "product:delete", Sensitive: true},

	// Commerce: Orders, Refunds, Reconciliation, Payouts
	"orderservice/cancel":            {PermissionKey: "order:manage", Sensitive: true},
	"orderservice/forcecancel":       {PermissionKey: "order:manage", Sensitive: true},
	"orderservice/forcecomplete":     {PermissionKey: "order:manage", Sensitive: true},
	"force_cancel":                   {PermissionKey: "order:manage", Sensitive: true},
	"force_complete":                 {PermissionKey: "order:manage", Sensitive: true},
	"refundservice/approve":          {PermissionKey: "refund:manage", Sensitive: true},
	"refundservice/process":          {PermissionKey: "refund:manage", Sensitive: true},
	"reconciliationservice/override": {PermissionKey: "reconciliation:override", Sensitive: true},
	"reconciliation_override":        {PermissionKey: "reconciliation:override", Sensitive: true},
	"affiliateservice/payout":        {PermissionKey: "reconciliation:override", Sensitive: true},
	"payoutservice/execute":          {PermissionKey: "reconciliation:override", Sensitive: true},
	"payout_affecting":               {PermissionKey: "reconciliation:override", Sensitive: true},

	// Billing
	"billingservice/manage":          {PermissionKey: "workspace:billing:manage", Sensitive: true},
	"workspaceservice/updatebilling": {PermissionKey: "workspace:billing:manage", Sensitive: true},

	// Production & Engagement
	"productionservice/generatevideo": {PermissionKey: "asset:generate", Sensitive: false},
	"productionservice/generate":      {PermissionKey: "asset:generate", Sensitive: false},
	"threadservice/reply":             {PermissionKey: "thread:reply", Sensitive: false},
}

// normalizeWorkflowRPCKey normalizes a full or short RPC identifier (e.g. "creativanta.commerce.v1.OfferService/Activate")
// to its canonical "service/method" lowercase key ("offerservice/activate").
func normalizeWorkflowRPCKey(rpcName string) string {
	trimmed := strings.ToLower(strings.TrimSpace(rpcName))
	if trimmed == "" {
		return ""
	}
	if slashIdx := strings.LastIndex(trimmed, "/"); slashIdx > 0 {
		servicePart := trimmed[:slashIdx]
		methodPart := trimmed[slashIdx+1:]
		if dotIdx := strings.LastIndex(servicePart, "."); dotIdx >= 0 {
			servicePart = servicePart[dotIdx+1:]
		}
		return servicePart + "/" + methodPart
	}
	return trimmed
}

// lookupWorkflowActionPolicy resolves the canonical RBAC permission and sensitivity for an action RPC.
// Returns false if the RPC is not in the canonical allowlist (fail-closed).
func lookupWorkflowActionPolicy(rpcName string) (workflowActionPolicy, bool) {
	norm := normalizeWorkflowRPCKey(rpcName)
	if policy, ok := canonicalWorkflowActionPolicies[norm]; ok {
		return policy, true
	}
	rawLower := strings.ToLower(strings.TrimSpace(rpcName))
	if policy, ok := canonicalWorkflowActionPolicies[rawLower]; ok {
		return policy, true
	}
	return workflowActionPolicy{}, false
}

// ActionPlatformDetector extracts target platform from RPC name or input JSON.
func detectPlatform(rpcName, inputJSON string) string {
	lowerRPC := strings.ToLower(rpcName)
	if strings.Contains(lowerRPC, "tiktok") {
		return "tiktok"
	} else if strings.Contains(lowerRPC, "youtube") {
		return "youtube"
	} else if strings.Contains(lowerRPC, "instagram") {
		return "instagram"
	} else if strings.Contains(lowerRPC, "facebook") {
		return "facebook"
	} else if strings.Contains(lowerRPC, "shopee") {
		return "shopee"
	} else if strings.Contains(lowerRPC, "lazada") {
		return "lazada"
	}

	if inputJSON != "" {
		var m map[string]any
		if err := json.Unmarshal([]byte(inputJSON), &m); err == nil {
			if p, ok := m["platform"].(string); ok && p != "" {
				return strings.ToLower(p)
			}
			if p, ok := m["channel"].(string); ok && p != "" {
				return strings.ToLower(p)
			}
		}
	}
	return ""
}

// EstimateActionCredits provides baseline positive credit quotes.
func estimateActionCredits(rpcName string) float64 {
	lower := strings.ToLower(rpcName)
	if strings.Contains(lower, "video") {
		return 5.0
	} else if strings.Contains(lower, "image") {
		return 2.0
	} else if strings.Contains(lower, "publish") {
		return 1.0
	}
	return 0.5
}

// IsSensitiveAction checks if an RPC requires approval under RULE-M20-004.
// Fails closed (returns true) if the RPC is not in the canonical allowlist.
func IsSensitiveAction(rpcName string) bool {
	if policy, ok := lookupWorkflowActionPolicy(rpcName); ok {
		return policy.Sensitive
	}
	return true
}

// PreflightWorkflow inspects every action in the workflow graph and produces an audit report.
func (pe *PreflightEngine) PreflightWorkflow(
	ctx context.Context,
	workspaceID string,
	graph *WorkflowGraph,
) (*PreflightReport, error) {
	if err := ValidateWorkflowGraph(graph); err != nil {
		return nil, fmt.Errorf("preflight graph validation failed: %w", err)
	}

	report := &PreflightReport{
		Valid:    true,
		Actions:  make([]PreflightActionSummary, 0),
		Warnings: make([]string, 0),
		Errors:   make([]string, 0),
	}

	// Adjacency for fallback check
	hasFallbackEdge := make(map[string]bool)
	for _, edge := range graph.Edges {
		if edge.Branch == EdgeBranchFailure {
			hasFallbackEdge[edge.FromNodeID] = true
		}
	}

	for _, node := range graph.Nodes {
		if node.NodeType == NodeTypeApproval {
			report.RequiresApproval = true
		}
		if node.NodeType != NodeTypeAction {
			continue
		}

		cfg := node.ActionConfig
		if cfg == nil {
			cfg = parseActionConfigFromMap(node.Config)
		}
		if cfg == nil || cfg.RPCName == "" {
			report.Errors = append(report.Errors, fmt.Sprintf("Action node %s has empty RPC configuration", node.NodeID))
			report.Valid = false
			continue
		}

		rpc := cfg.RPCName
		policy, ok := lookupWorkflowActionPolicy(rpc)
		var reqPerm string
		if !ok {
			reqPerm = "UNREGISTERED_RPC"
			report.Errors = append(report.Errors, fmt.Sprintf("Action node %s references unregistered or unsupported RPC %q (fail-closed)", node.NodeID, rpc))
			report.Valid = false
		} else {
			reqPerm = policy.PermissionKey
		}

		platform := detectPlatform(rpc, cfg.InputJSON)
		capStatus := "supported"
		if platform != "" {
			status, err := pe.capProvider.GetPlatformCapability(ctx, workspaceID, platform, rpc)
			if err == nil && status != "" {
				capStatus = status
			}
		}

		requiresApproval := IsSensitiveAction(rpc)
		if requiresApproval {
			report.RequiresApproval = true
		}

		quotedCredits := estimateActionCredits(rpc)
		report.TotalMaxCreditQuote += quotedCredits

		var missingInputs []string
		if cfg.InputJSON == "" || cfg.InputJSON == "{}" {
			// Check if action strictly requires inputs
			if strings.Contains(strings.ToLower(rpc), "reserve") || strings.Contains(strings.ToLower(rpc), "publish") {
				missingInputs = append(missingInputs, "input payload parameters")
				report.Warnings = append(report.Warnings, fmt.Sprintf("Node %s (%s): input payload is empty", node.NodeID, rpc))
			}
		}

		if capStatus == "degraded" || capStatus == "unsupported" {
			if !hasFallbackEdge[node.NodeID] {
				report.Warnings = append(report.Warnings, fmt.Sprintf("Node %s targets %s with %s capability but lacks a fallback failure branch", node.NodeID, platform, capStatus))
			}
		}

		summary := PreflightActionSummary{
			NodeID:             node.NodeID,
			RPCName:            rpc,
			RequiredPermission: reqPerm,
			Platform:           platform,
			CapabilityStatus:   capStatus,
			RequiresApproval:   requiresApproval,
			QuotedCredits:      quotedCredits,
			MissingInputs:      missingInputs,
		}
		report.Actions = append(report.Actions, summary)
	}

	return report, nil
}
