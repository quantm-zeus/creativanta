package workflow

import (
	"encoding/json"
	"fmt"
	"strings"
)

const (
	MaxWorkflowNodes = 100
)

var allowlistedOperators = map[string]bool{
	"eq":       true,
	"neq":      true,
	"gt":       true,
	"gte":      true,
	"lt":       true,
	"lte":      true,
	"in":       true,
	"contains": true,
	"exists":   true,
	"matches":  true,
}

var allowlistedSeverities = map[string]bool{
	"info":     true,
	"warning":  true,
	"error":    true,
	"critical": true,
}

var allowlistedOutcomes = map[string]bool{
	"succeeded":           true,
	"partially_succeeded": true,
	"failed":              true,
	"cancelled":           true,
}

// ValidateWorkflowGraph validates the graph structure, rejects cycles and unbounded graphs,
// and validates every node config against canonical schemas.
func ValidateWorkflowGraph(graph *WorkflowGraph) error {
	if graph == nil || len(graph.Nodes) == 0 {
		return ErrEmptyGraph
	}
	if graph.SchemaVersion != 1 {
		return fmt.Errorf("%w: unsupported schema_version %d, expected 1", ErrInvalidGraphStructure, graph.SchemaVersion)
	}
	if len(graph.Nodes) > MaxWorkflowNodes {
		return fmt.Errorf("%w: graph has %d nodes, maximum allowed is %d", ErrNodeCountExceeded, len(graph.Nodes), MaxWorkflowNodes)
	}

	nodeMap := make(map[string]*WorkflowNode, len(graph.Nodes))
	inDegree := make(map[string]int, len(graph.Nodes))
	outDegree := make(map[string]int, len(graph.Nodes))
	adj := make(map[string][]string, len(graph.Nodes))
	revAdj := make(map[string][]string, len(graph.Nodes))

	var triggerNodes []string
	var terminalNodes []string

	for i := range graph.Nodes {
		node := &graph.Nodes[i]
		if strings.TrimSpace(node.NodeID) == "" {
			return fmt.Errorf("%w: node ID cannot be empty", ErrInvalidGraphStructure)
		}
		if _, exists := nodeMap[node.NodeID]; exists {
			return fmt.Errorf("%w: duplicate node_id %q", ErrInvalidGraphStructure, node.NodeID)
		}
		nodeMap[node.NodeID] = node
		inDegree[node.NodeID] = 0
		outDegree[node.NodeID] = 0
		adj[node.NodeID] = nil
		revAdj[node.NodeID] = nil

		if err := validateNodeConfig(node); err != nil {
			return err
		}

		switch node.NodeType {
		case NodeTypeTrigger:
			triggerNodes = append(triggerNodes, node.NodeID)
		case NodeTypeTerminal:
			terminalNodes = append(terminalNodes, node.NodeID)
		}
	}

	// 1. Root trigger check
	if len(triggerNodes) != 1 {
		return fmt.Errorf("%w: found %d trigger nodes, expected exactly 1", ErrMissingTriggerNode, len(triggerNodes))
	}
	triggerNodeID := triggerNodes[0]

	// 2. Terminal node check
	if len(terminalNodes) == 0 {
		return fmt.Errorf("%w: found 0 terminal nodes, expected at least 1", ErrMissingTerminalNode)
	}

	// 3. Edges validation
	edgeSeen := make(map[string]bool, len(graph.Edges))
	for _, edge := range graph.Edges {
		if edge.FromNodeID == edge.ToNodeID {
			return fmt.Errorf("%w: node %q connects to itself", ErrSelfLoopDetected, edge.FromNodeID)
		}
		fromNode, okFrom := nodeMap[edge.FromNodeID]
		if !okFrom {
			return fmt.Errorf("%w: from_node_id %q does not exist", ErrInvalidEdge, edge.FromNodeID)
		}
		toNode, okTo := nodeMap[edge.ToNodeID]
		if !okTo {
			return fmt.Errorf("%w: to_node_id %q does not exist", ErrInvalidEdge, edge.ToNodeID)
		}

		edgeKey := fmt.Sprintf("%s->%s:%s", edge.FromNodeID, edge.ToNodeID, edge.Branch)
		if edgeSeen[edgeKey] {
			return fmt.Errorf("%w: duplicate edge %s", ErrInvalidGraphStructure, edgeKey)
		}
		edgeSeen[edgeKey] = true

		// Branch validity checks
		if fromNode.NodeType == NodeTypeCondition {
			if edge.Branch != EdgeBranchTrue && edge.Branch != EdgeBranchFalse {
				return fmt.Errorf("%w: condition node %q edge must specify branch 'true' or 'false', got %q", ErrInvalidBranch, fromNode.NodeID, edge.Branch)
			}
		}

		inDegree[toNode.NodeID]++
		outDegree[fromNode.NodeID]++
		adj[fromNode.NodeID] = append(adj[fromNode.NodeID], toNode.NodeID)
		revAdj[toNode.NodeID] = append(revAdj[toNode.NodeID], fromNode.NodeID)
	}

	// Trigger node must have in-degree 0
	if inDegree[triggerNodeID] > 0 {
		return fmt.Errorf("%w: trigger node %q cannot have incoming edges", ErrInvalidGraphStructure, triggerNodeID)
	}

	// Terminal nodes must have out-degree 0
	for _, termID := range terminalNodes {
		if outDegree[termID] > 0 {
			return fmt.Errorf("%w: terminal node %q cannot have outgoing edges", ErrInvalidGraphStructure, termID)
		}
	}

	// 4. Cycle detection (DFS with 3 colors: 0=White, 1=Gray, 2=Black)
	color := make(map[string]int, len(graph.Nodes))
	parent := make(map[string]string)
	var cyclePath []string

	var dfsCycle func(u string) bool
	dfsCycle = func(u string) bool {
		color[u] = 1 // Gray
		for _, v := range adj[u] {
			if color[v] == 1 { // Back-edge found: cycle!
				// Reconstruct cycle path
				cyclePath = []string{v, u}
				curr := u
				for curr != v && parent[curr] != "" {
					curr = parent[curr]
					cyclePath = append([]string{curr}, cyclePath...)
				}
				return true
			}
			if color[v] == 0 {
				parent[v] = u
				if dfsCycle(v) {
					return true
				}
			}
		}
		color[u] = 2 // Black
		return false
	}

	for _, node := range graph.Nodes {
		if color[node.NodeID] == 0 {
			if dfsCycle(node.NodeID) {
				return fmt.Errorf("%w: path %s", ErrCycleDetected, strings.Join(cyclePath, " -> "))
			}
		}
	}

	// 5. Reachability from Trigger root
	reachableFromRoot := make(map[string]bool, len(graph.Nodes))
	queue := []string{triggerNodeID}
	reachableFromRoot[triggerNodeID] = true

	for len(queue) > 0 {
		curr := queue[0]
		queue = queue[1:]
		for _, next := range adj[curr] {
			if !reachableFromRoot[next] {
				reachableFromRoot[next] = true
				queue = append(queue, next)
			}
		}
	}

	for _, node := range graph.Nodes {
		if !reachableFromRoot[node.NodeID] {
			return fmt.Errorf("%w: node %q is not reachable from trigger node %q", ErrDisconnectedComponent, node.NodeID, triggerNodeID)
		}
	}

	// 6. Path termination: every non-terminal node must have a path reaching at least one terminal node
	canReachTerminal := make(map[string]bool, len(graph.Nodes))
	termQueue := make([]string, 0, len(terminalNodes))
	for _, termID := range terminalNodes {
		canReachTerminal[termID] = true
		termQueue = append(termQueue, termID)
	}

	for len(termQueue) > 0 {
		curr := termQueue[0]
		termQueue = termQueue[1:]
		for _, prev := range revAdj[curr] {
			if !canReachTerminal[prev] {
				canReachTerminal[prev] = true
				termQueue = append(termQueue, prev)
			}
		}
	}

	for _, node := range graph.Nodes {
		if !canReachTerminal[node.NodeID] {
			return fmt.Errorf("%w: node %q has no path leading to a terminal node", ErrNoPathToTerminal, node.NodeID)
		}
	}

	return nil
}

func validateNodeConfig(node *WorkflowNode) error {
	// Security audit: forbid credentials and raw SQL in node config
	configRaw, err := json.Marshal(node)
	if err == nil {
		configStr := strings.ToLower(string(configRaw))
		forbiddenCredentials := []string{
			`"password"`, `"secret"`, `"private_key"`, `"api_secret"`, `"auth_token"`, "sk_live_", "ghp_",
		}
		for _, cred := range forbiddenCredentials {
			if strings.Contains(configStr, cred) {
				return fmt.Errorf("%w: credential detected in node %q config", ErrSecurityViolation, node.NodeID)
			}
		}
		forbiddenSQL := []string{
			"select ", "insert into ", "drop table", "delete from ", "update ",
		}
		for _, sql := range forbiddenSQL {
			if strings.Contains(configStr, sql) {
				return fmt.Errorf("%w: raw SQL query detected in node %q config", ErrSecurityViolation, node.NodeID)
			}
		}
	}

	switch node.NodeType {
	case NodeTypeTrigger:
		return validateTriggerNode(node)
	case NodeTypeCondition:
		return validateConditionNode(node)
	case NodeTypeTransform:
		return validateTransformNode(node)
	case NodeTypeAction:
		return validateActionNode(node)
	case NodeTypeApproval:
		return validateApprovalNode(node)
	case NodeTypeWait:
		return validateWaitNode(node)
	case NodeTypeFallback:
		return validateFallbackNode(node)
	case NodeTypeDiagnostics:
		return validateDiagnosticsNode(node)
	case NodeTypeHandoff:
		return validateHandoffNode(node)
	case NodeTypeTerminal:
		return validateTerminalNode(node)
	default:
		return fmt.Errorf("%w: unknown node_type %q in node %q", ErrInvalidNodeType, node.NodeType, node.NodeID)
	}
}

func validateTriggerNode(node *WorkflowNode) error {
	cfg := node.TriggerConfig
	if cfg == nil && node.Config != nil {
		cfg = parseTriggerConfigFromMap(node.Config)
	}
	if cfg == nil {
		return fmt.Errorf("%w: trigger node %q missing configuration", ErrInvalidNodeConfig, node.NodeID)
	}
	switch cfg.Type {
	case TriggerTypeEvent:
		if strings.TrimSpace(cfg.EventType) == "" {
			return fmt.Errorf("%w: event trigger requires non-empty event_type", ErrInvalidNodeConfig)
		}
	case TriggerTypeSchedule:
		if strings.TrimSpace(cfg.CronExpression) == "" {
			return fmt.Errorf("%w: schedule trigger requires non-empty cron_expression", ErrInvalidNodeConfig)
		}
	case TriggerTypeWebhook:
		if strings.TrimSpace(cfg.WebhookPath) == "" {
			return fmt.Errorf("%w: webhook trigger requires non-empty webhook_path", ErrInvalidNodeConfig)
		}
	case TriggerTypeManual:
		// manual is valid without extra path
	default:
		return fmt.Errorf("%w: unsupported trigger type %q", ErrInvalidTriggerType, cfg.Type)
	}
	return nil
}

func validateConditionNode(node *WorkflowNode) error {
	cfg := node.ConditionConfig
	if cfg == nil && node.Config != nil {
		cfg = parseConditionConfigFromMap(node.Config)
	}
	if cfg == nil {
		return fmt.Errorf("%w: condition node %q missing configuration", ErrInvalidNodeConfig, node.NodeID)
	}
	if strings.TrimSpace(cfg.Field) == "" {
		return fmt.Errorf("%w: condition node %q requires field", ErrInvalidNodeConfig, node.NodeID)
	}
	if !allowlistedOperators[strings.ToLower(cfg.Operator)] {
		return fmt.Errorf("%w: condition node %q operator %q not allowed", ErrInvalidNodeConfig, node.NodeID, cfg.Operator)
	}
	return nil
}

func validateTransformNode(node *WorkflowNode) error {
	cfg := node.TransformConfig
	if cfg == nil && node.Config != nil {
		cfg = parseTransformConfigFromMap(node.Config)
	}
	if cfg == nil || len(cfg.Mappings) == 0 {
		return fmt.Errorf("%w: transform node %q requires at least one mapping", ErrInvalidNodeConfig, node.NodeID)
	}
	for _, m := range cfg.Mappings {
		if strings.TrimSpace(m.TargetField) == "" {
			return fmt.Errorf("%w: transform node %q mapping requires target_field", ErrInvalidNodeConfig, node.NodeID)
		}
		// Forbid arbitrary code execution in transform templates (declarative mappings only)
		lowTemplate := strings.ToLower(m.Template)
		forbiddenCode := []string{"eval(", "function(", "exec(", "<script", "javascript:", "process.exit"}
		for _, fc := range forbiddenCode {
			if strings.Contains(lowTemplate, fc) {
				return fmt.Errorf("%w: transform template in node %q contains forbidden code %q", ErrArbitraryCodeForbidden, node.NodeID, fc)
			}
		}
	}
	return nil
}

func validateActionNode(node *WorkflowNode) error {
	cfg := node.ActionConfig
	if cfg == nil && node.Config != nil {
		cfg = parseActionConfigFromMap(node.Config)
	}
	if cfg == nil {
		return fmt.Errorf("%w: action node %q missing configuration", ErrInvalidNodeConfig, node.NodeID)
	}
	if strings.TrimSpace(cfg.RPCName) == "" {
		return fmt.Errorf("%w: action node %q requires rpc_name", ErrInvalidNodeConfig, node.NodeID)
	}
	return nil
}

func validateApprovalNode(node *WorkflowNode) error {
	cfg := node.ApprovalConfig
	if cfg == nil && node.Config != nil {
		cfg = parseApprovalConfigFromMap(node.Config)
	}
	if cfg == nil {
		return fmt.Errorf("%w: approval node %q missing configuration", ErrInvalidNodeConfig, node.NodeID)
	}
	if len(cfg.ApproverIDs) == 0 {
		return fmt.Errorf("%w: approval node %q must specify at least one approver_id", ErrMissingRequiredApprover, node.NodeID)
	}
	return nil
}

func validateWaitNode(node *WorkflowNode) error {
	cfg := node.WaitConfig
	if cfg == nil && node.Config != nil {
		cfg = parseWaitConfigFromMap(node.Config)
	}
	if cfg == nil {
		return fmt.Errorf("%w: wait node %q missing configuration", ErrInvalidNodeConfig, node.NodeID)
	}
	if cfg.WaitType == "" {
		cfg.WaitType = "duration"
	}
	return nil
}

func validateFallbackNode(node *WorkflowNode) error {
	cfg := node.FallbackConfig
	if cfg == nil && node.Config != nil {
		cfg = parseFallbackConfigFromMap(node.Config)
	}
	if cfg == nil || strings.TrimSpace(cfg.FallbackNodeID) == "" {
		return fmt.Errorf("%w: fallback node %q requires fallback_node_id", ErrInvalidNodeConfig, node.NodeID)
	}
	return nil
}

func validateDiagnosticsNode(node *WorkflowNode) error {
	cfg := node.DiagnosticsConfig
	if cfg == nil && node.Config != nil {
		cfg = parseDiagnosticsConfigFromMap(node.Config)
	}
	if cfg == nil {
		return fmt.Errorf("%w: diagnostics node %q missing configuration", ErrInvalidNodeConfig, node.NodeID)
	}
	if cfg.Severity != "" && !allowlistedSeverities[strings.ToLower(cfg.Severity)] {
		return fmt.Errorf("%w: diagnostics node %q invalid severity %q", ErrInvalidNodeConfig, node.NodeID, cfg.Severity)
	}
	return nil
}

func validateHandoffNode(node *WorkflowNode) error {
	cfg := node.HandoffConfig
	if cfg == nil && node.Config != nil {
		cfg = parseHandoffConfigFromMap(node.Config)
	}
	if cfg == nil || (strings.TrimSpace(cfg.TargetUserID) == "" && strings.TrimSpace(cfg.TargetRole) == "") {
		return fmt.Errorf("%w: handoff node %q requires target_user_id or target_role", ErrInvalidNodeConfig, node.NodeID)
	}
	return nil
}

func validateTerminalNode(node *WorkflowNode) error {
	cfg := node.TerminalConfig
	if cfg == nil && node.Config != nil {
		cfg = parseTerminalConfigFromMap(node.Config)
	}
	if cfg == nil {
		return fmt.Errorf("%w: terminal node %q missing configuration", ErrInvalidNodeConfig, node.NodeID)
	}
	if cfg.Outcome != "" && !allowlistedOutcomes[strings.ToLower(cfg.Outcome)] {
		return fmt.Errorf("%w: terminal node %q invalid outcome %q", ErrInvalidNodeConfig, node.NodeID, cfg.Outcome)
	}
	return nil
}

// ----------------------------------------------------------------------------
// Helper parsers from untyped map[string]any
// ----------------------------------------------------------------------------

func parseTriggerConfigFromMap(m map[string]any) *TriggerConfig {
	b, err := json.Marshal(m)
	if err != nil {
		return nil
	}
	var cfg TriggerConfig
	if err := json.Unmarshal(b, &cfg); err != nil {
		return nil
	}
	return &cfg
}

func parseConditionConfigFromMap(m map[string]any) *ConditionConfig {
	b, err := json.Marshal(m)
	if err != nil {
		return nil
	}
	var cfg ConditionConfig
	if err := json.Unmarshal(b, &cfg); err != nil {
		return nil
	}
	return &cfg
}

func parseTransformConfigFromMap(m map[string]any) *TransformConfig {
	b, err := json.Marshal(m)
	if err != nil {
		return nil
	}
	var cfg TransformConfig
	if err := json.Unmarshal(b, &cfg); err != nil {
		return nil
	}
	return &cfg
}

func parseActionConfigFromMap(m map[string]any) *ActionConfig {
	b, err := json.Marshal(m)
	if err != nil {
		return nil
	}
	var cfg ActionConfig
	if err := json.Unmarshal(b, &cfg); err != nil {
		return nil
	}
	return &cfg
}

func parseApprovalConfigFromMap(m map[string]any) *ApprovalConfig {
	b, err := json.Marshal(m)
	if err != nil {
		return nil
	}
	var cfg ApprovalConfig
	if err := json.Unmarshal(b, &cfg); err != nil {
		return nil
	}
	return &cfg
}

func parseWaitConfigFromMap(m map[string]any) *WaitConfig {
	b, err := json.Marshal(m)
	if err != nil {
		return nil
	}
	var cfg WaitConfig
	if err := json.Unmarshal(b, &cfg); err != nil {
		return nil
	}
	return &cfg
}

func parseFallbackConfigFromMap(m map[string]any) *FallbackConfig {
	b, err := json.Marshal(m)
	if err != nil {
		return nil
	}
	var cfg FallbackConfig
	if err := json.Unmarshal(b, &cfg); err != nil {
		return nil
	}
	return &cfg
}

func parseDiagnosticsConfigFromMap(m map[string]any) *DiagnosticsConfig {
	b, err := json.Marshal(m)
	if err != nil {
		return nil
	}
	var cfg DiagnosticsConfig
	if err := json.Unmarshal(b, &cfg); err != nil {
		return nil
	}
	return &cfg
}

func parseHandoffConfigFromMap(m map[string]any) *HandoffConfig {
	b, err := json.Marshal(m)
	if err != nil {
		return nil
	}
	var cfg HandoffConfig
	if err := json.Unmarshal(b, &cfg); err != nil {
		return nil
	}
	return &cfg
}

func parseTerminalConfigFromMap(m map[string]any) *TerminalConfig {
	b, err := json.Marshal(m)
	if err != nil {
		return nil
	}
	var cfg TerminalConfig
	if err := json.Unmarshal(b, &cfg); err != nil {
		return nil
	}
	return &cfg
}
