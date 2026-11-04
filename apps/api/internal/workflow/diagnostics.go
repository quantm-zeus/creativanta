package workflow

import (
	"fmt"
	"time"
)

// DiagnosticsBuilder constructs user-facing diagnostics records per RULE-M20-003.
// Guarantees: user-facing explanation in clean natural language (no raw DB/code stack dumps),
// operator explanation for technical debugging, recommended next steps, and fallback status.
type DiagnosticsBuilder struct{}

func NewDiagnosticsBuilder() *DiagnosticsBuilder {
	return &DiagnosticsBuilder{}
}

func (db *DiagnosticsBuilder) CreateRecord(
	workspaceID, runID, failureType, nodeID string,
	nodeType NodeType,
	userMsg, opMsg, nextStep string,
	fallbackAvailable bool,
) *DiagnosticsRecord {
	return &DiagnosticsRecord{
		RecordID:              newUUID(),
		WorkspaceID:           workspaceID,
		RunID:                 runID,
		FailureType:           failureType,
		AffectedNodeID:        nodeID,
		AffectedNodeType:      nodeType,
		UserFacingExplanation: userMsg,
		OperatorExplanation:   opMsg,
		RecommendedNextStep:   nextStep,
		FallbackAvailable:     fallbackAvailable,
		CreatedAt:             time.Now().UTC(),
	}
}

func (db *DiagnosticsBuilder) CapabilityDegraded(
	workspaceID, runID, nodeID, platform, rpcName, status string,
	hasFallback bool,
) *DiagnosticsRecord {
	userMsg := fmt.Sprintf("This workflow couldn't complete because %s is currently experiencing issues. Please try again later or check the platform status page.", platform)
	opMsg := fmt.Sprintf("Platform capability check for %s returned %s before executing action %s at node %s (RULE-M20-002).", platform, status, rpcName, nodeID)
	nextStep := "Review platform connection under Settings > Connected Accounts or configure a fallback path."
	if hasFallback {
		userMsg = fmt.Sprintf("%s is currently degraded. The workflow automatically routed to the fallback path.", platform)
		nextStep = "Verify that the fallback outcome satisfied your operational requirements."
	}
	return db.CreateRecord(workspaceID, runID, "CAPABILITY_DEGRADED", nodeID, NodeTypeAction, userMsg, opMsg, nextStep, hasFallback)
}

func (db *DiagnosticsBuilder) ApprovalExpired(
	workspaceID, runID, nodeID, requestID string,
	expiresAt time.Time,
	hasFallback bool,
) *DiagnosticsRecord {
	userMsg := "Approval request timed out after the deadline. For safety, the action was automatically denied."
	opMsg := fmt.Sprintf("Approval request %s expired at %s without human response (RULE-M20-004).", requestID, expiresAt.Format(time.RFC3339))
	nextStep := "Trigger a fresh workflow run if this operation is still needed."
	if hasFallback {
		userMsg = "Approval request timed out. The workflow took the reject/fallback path."
		nextStep = "Check the fallback step results in the run timeline."
	}
	return db.CreateRecord(workspaceID, runID, "APPROVAL_EXPIRED", nodeID, NodeTypeApproval, userMsg, opMsg, nextStep, hasFallback)
}

func (db *DiagnosticsBuilder) ApprovalInvalidated(
	workspaceID, runID, nodeID, requestID, reason string,
) *DiagnosticsRecord {
	userMsg := "The pending approval was invalidated because the workflow configuration, target object, or action inputs were modified."
	opMsg := fmt.Sprintf("Approval request %s invalidated per target contract: %s", requestID, reason)
	nextStep := "Request a fresh approval with the updated parameters."
	return db.CreateRecord(workspaceID, runID, "APPROVAL_INVALIDATED", nodeID, NodeTypeApproval, userMsg, opMsg, nextStep, false)
}

func (db *DiagnosticsBuilder) CascadeDepthExceeded(
	workspaceID, runID string,
	depth int,
) *DiagnosticsRecord {
	userMsg := fmt.Sprintf("Workflow cascade depth limit (%d) was reached. Execution was halted to prevent an infinite loop.", depth)
	opMsg := fmt.Sprintf("Cascade depth %d exceeded workspace maximum (EC-M20-001). Potential recursive trigger detected.", depth)
	nextStep := "Review workflow trigger conditions to eliminate cyclical event propagation."
	return db.CreateRecord(workspaceID, runID, "CASCADE_DEPTH_EXCEEDED", "", NodeTypeTrigger, userMsg, opMsg, nextStep, false)
}

func (db *DiagnosticsBuilder) ActionFailed(
	workspaceID, runID, nodeID, rpcName, reason string,
	hasFallback bool,
) *DiagnosticsRecord {
	userMsg := fmt.Sprintf("An error occurred while executing %s. The step could not be completed.", rpcName)
	opMsg := fmt.Sprintf("Action node %s (%s) failed: %s", nodeID, rpcName, reason)
	nextStep := "Inspect the step details and consider retrying with updated inputs or repair parameters."
	return db.CreateRecord(workspaceID, runID, "ACTION_FAILED", nodeID, NodeTypeAction, userMsg, opMsg, nextStep, hasFallback)
}
