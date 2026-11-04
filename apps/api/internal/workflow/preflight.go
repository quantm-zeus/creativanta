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

// ActionsRequiringApproval per RULE-M20-004 and Pack 03 §6.1
var sensitiveActionsRequiringApproval = map[string]bool{
	"publish":                 true,
	"publishservice/publish":  true,
	"offer_activation":        true,
	"price_change":            true,
	"monetization/activate":   true,
	"destructive_archive":     true,
	"reconciliation_override": true,
	"payout_affecting":        true,
	"affiliateservice/payout": true,
	"force_cancel":            true,
	"force_complete":          true,
}

// ActionPermissionMap maps canonical RPCs to required RBAC permission tokens.
var actionPermissionMap = map[string]string{
	"creativanta.publish.v1.PublishService/Publish":             "publish:create",
	"creativanta.commerce.v1.InventoryService/ReserveStock":     "commerce:inventory:manage",
	"creativanta.commerce.v1.MonetizationService/ActivateOffer": "commerce:monetization:manage",
	"creativanta.commerce.v1.AffiliateService/Payout":           "payout:manage",
	"creativanta.production.v1.ProductionService/GenerateVideo": "production:create",
	"creativanta.engagement.v1.ThreadService/Reply":             "engagement:reply",
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
func IsSensitiveAction(rpcName string) bool {
	lower := strings.ToLower(rpcName)
	for pattern := range sensitiveActionsRequiringApproval {
		if strings.Contains(lower, pattern) {
			return true
		}
	}
	return false
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
		reqPerm := actionPermissionMap[rpc]
		if reqPerm == "" {
			reqPerm = "workflow:edit"
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
