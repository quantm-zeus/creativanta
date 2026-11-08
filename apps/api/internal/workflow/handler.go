package workflow

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"

	"connectrpc.com/connect"
	automationv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/automation/v1/automationv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"google.golang.org/protobuf/types/known/timestamppb"
)

// MembershipRoleResolver looks up a user's active workspace membership role.
type MembershipRoleResolver func(ctx context.Context, workspaceID, userID string) (role string, active bool, err error)

// Handler implements the ConnectRPC automationv1connect.WorkflowServiceHandler.
type Handler struct {
	service      *Service
	roleResolver MembershipRoleResolver
}

// NewHandler creates a new WorkflowService ConnectRPC handler.
func NewHandler(service *Service) *Handler {
	return &Handler{service: service}
}

// WithMembershipRoleResolver configures a workspace membership role resolver for Handler.
func (h *Handler) WithMembershipRoleResolver(resolver MembershipRoleResolver) *Handler {
	h.roleResolver = resolver
	if h.service != nil {
		h.service.SetMembershipRoleResolver(resolver)
	}
	return h
}

var _ automationv1connect.WorkflowServiceHandler = (*Handler)(nil)

func (h *Handler) resolveCaller(ctx context.Context, explicitWorkspaceID string, requiredPerm string) (CallerContext, error) {
	session, ok := transportauth.PrincipalFromContext(ctx)
	if !ok || strings.TrimSpace(session.UserID) == "" || strings.TrimSpace(session.WorkspaceID) == "" {
		return CallerContext{}, connect.NewError(connect.CodeUnauthenticated, errors.New("authenticated workspace principal required"))
	}
	if session.InternalAdmin || session.ServiceKeyID != "" {
		return CallerContext{}, connect.NewError(connect.CodePermissionDenied, errors.New("workspace user principal required"))
	}
	if explicitWorkspaceID != "" && explicitWorkspaceID != session.WorkspaceID {
		return CallerContext{}, connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
	}

	role := strings.TrimSpace(session.Role)
	if h.roleResolver != nil {
		resolvedRole, active, err := h.roleResolver(ctx, session.WorkspaceID, session.UserID)
		if err != nil {
			return CallerContext{}, connect.NewError(connect.CodePermissionDenied, err)
		}
		if !active {
			return CallerContext{}, connect.NewError(connect.CodePermissionDenied, errors.New("active workspace membership required"))
		}
		role = strings.TrimSpace(resolvedRole)
	} else if h.service != nil && h.service.store != nil {
		if memStore, ok := h.service.store.(WorkspaceMembershipStore); ok && memStore != nil {
			resolvedRole, active, found, err := memStore.ResolveWorkspaceMemberRole(ctx, session.WorkspaceID, session.UserID)
			if err != nil {
				return CallerContext{}, connect.NewError(connect.CodePermissionDenied, err)
			}
			if found {
				if isInactiveOrRevokedRole(resolvedRole, active) {
					return CallerContext{}, connect.NewError(connect.CodePermissionDenied, errors.New("active workspace membership required"))
				}
				role = strings.TrimSpace(resolvedRole)
			}
		}
	}
	if role == "" || !rbac.IsValidWorkspaceRole(role) {
		return CallerContext{}, connect.NewError(connect.CodePermissionDenied, errors.New("verified workspace membership role required"))
	}

	if requiredPerm != "" {
		if err := rbac.CheckWorkspacePermission(requiredPerm, rbac.PolicyContext{
			ActorUserID: session.UserID,
			WorkspaceID: session.WorkspaceID,
			Role:        role,
		}); err != nil {
			return CallerContext{}, connect.NewError(connect.CodePermissionDenied, err)
		}
	}

	return CallerContext{
		UserID:        session.UserID,
		WorkspaceID:   session.WorkspaceID,
		WorkspaceRole: role,
	}, nil
}

func toConnectError(err error) error {
	if err == nil {
		return nil
	}
	var connectErr *connect.Error
	if errors.As(err, &connectErr) {
		return connectErr
	}

	switch {
	case errors.Is(err, ErrWorkflowNotFound), errors.Is(err, ErrWorkflowRunNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, ErrCycleDetected),
		errors.Is(err, ErrUnboundedGraph),
		errors.Is(err, ErrInvalidGraphStructure),
		errors.Is(err, ErrInvalidNodeType),
		errors.Is(err, ErrInvalidTriggerType),
		errors.Is(err, ErrSecurityViolation),
		errors.Is(err, ErrMissingTerminalNode),
		errors.Is(err, ErrMissingTriggerNode),
		errors.Is(err, ErrSelfLoopDetected),
		errors.Is(err, ErrNodeCountExceeded),
		errors.Is(err, ErrDisconnectedComponent),
		errors.Is(err, ErrNoPathToTerminal),
		errors.Is(err, ErrInvalidEdge),
		errors.Is(err, ErrInvalidBranch),
		errors.Is(err, ErrArbitraryCodeForbidden),
		errors.Is(err, ErrEmptyGraph):
		return connect.NewError(connect.CodeInvalidArgument, err)
	case errors.Is(err, ErrUnauthorized):
		return connect.NewError(connect.CodePermissionDenied, err)
	case errors.Is(err, ErrVersionMismatch):
		return connect.NewError(connect.CodeAborted, err)
	case errors.Is(err, ErrActivepiecesUnentitled):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}

// ----------------------------------------------------------------------------
// Protobuf Serialization / Conversion Helpers
// ----------------------------------------------------------------------------

func toProtoWorkflowStatus(s WorkflowStatus) automationv1.WorkflowStatus {
	switch s {
	case WorkflowStatusDraft:
		return automationv1.WorkflowStatus_WORKFLOW_STATUS_DRAFT
	case WorkflowStatusActive:
		return automationv1.WorkflowStatus_WORKFLOW_STATUS_ACTIVE
	case WorkflowStatusPaused:
		return automationv1.WorkflowStatus_WORKFLOW_STATUS_PAUSED
	case WorkflowStatusError:
		return automationv1.WorkflowStatus_WORKFLOW_STATUS_ERROR
	case WorkflowStatusArchived:
		return automationv1.WorkflowStatus_WORKFLOW_STATUS_ARCHIVED
	default:
		return automationv1.WorkflowStatus_WORKFLOW_STATUS_UNSPECIFIED
	}
}

func fromProtoWorkflowStatus(s automationv1.WorkflowStatus) WorkflowStatus {
	switch s {
	case automationv1.WorkflowStatus_WORKFLOW_STATUS_DRAFT:
		return WorkflowStatusDraft
	case automationv1.WorkflowStatus_WORKFLOW_STATUS_ACTIVE:
		return WorkflowStatusActive
	case automationv1.WorkflowStatus_WORKFLOW_STATUS_PAUSED:
		return WorkflowStatusPaused
	case automationv1.WorkflowStatus_WORKFLOW_STATUS_ERROR:
		return WorkflowStatusError
	case automationv1.WorkflowStatus_WORKFLOW_STATUS_ARCHIVED:
		return WorkflowStatusArchived
	default:
		return WorkflowStatusDraft
	}
}

func toProtoWorkflowRunStatus(s WorkflowRunStatus) automationv1.WorkflowRunStatus {
	switch s {
	case WorkflowRunStatusQueued:
		return automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_QUEUED
	case WorkflowRunStatusRunning:
		return automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_RUNNING
	case WorkflowRunStatusWaitingApproval:
		return automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_WAITING_APPROVAL
	case WorkflowRunStatusWaitingExternalCondition:
		return automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_WAITING_EXTERNAL_CONDITION
	case WorkflowRunStatusSucceeded:
		return automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_SUCCEEDED
	case WorkflowRunStatusPartiallySucceeded:
		return automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_PARTIALLY_SUCCEEDED
	case WorkflowRunStatusFailed:
		return automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_FAILED
	case WorkflowRunStatusCancelled:
		return automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_CANCELLED
	case WorkflowRunStatusRequiresManualIntervention:
		return automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_REQUIRES_MANUAL_INTERVENTION
	default:
		return automationv1.WorkflowRunStatus_WORKFLOW_RUN_STATUS_UNSPECIFIED
	}
}

func toProtoNodeType(t NodeType) automationv1.NodeType {
	switch t {
	case NodeTypeTrigger:
		return automationv1.NodeType_NODE_TYPE_TRIGGER
	case NodeTypeCondition:
		return automationv1.NodeType_NODE_TYPE_CONDITION
	case NodeTypeTransform:
		return automationv1.NodeType_NODE_TYPE_TRANSFORM
	case NodeTypeAction:
		return automationv1.NodeType_NODE_TYPE_ACTION
	case NodeTypeApproval:
		return automationv1.NodeType_NODE_TYPE_APPROVAL
	case NodeTypeWait:
		return automationv1.NodeType_NODE_TYPE_WAIT
	case NodeTypeFallback:
		return automationv1.NodeType_NODE_TYPE_FALLBACK
	case NodeTypeDiagnostics:
		return automationv1.NodeType_NODE_TYPE_DIAGNOSTICS
	case NodeTypeHandoff:
		return automationv1.NodeType_NODE_TYPE_HANDOFF
	case NodeTypeTerminal:
		return automationv1.NodeType_NODE_TYPE_TERMINAL
	default:
		return automationv1.NodeType_NODE_TYPE_UNSPECIFIED
	}
}

func fromProtoNodeType(t automationv1.NodeType) NodeType {
	switch t {
	case automationv1.NodeType_NODE_TYPE_TRIGGER:
		return NodeTypeTrigger
	case automationv1.NodeType_NODE_TYPE_CONDITION:
		return NodeTypeCondition
	case automationv1.NodeType_NODE_TYPE_TRANSFORM:
		return NodeTypeTransform
	case automationv1.NodeType_NODE_TYPE_ACTION:
		return NodeTypeAction
	case automationv1.NodeType_NODE_TYPE_APPROVAL:
		return NodeTypeApproval
	case automationv1.NodeType_NODE_TYPE_WAIT:
		return NodeTypeWait
	case automationv1.NodeType_NODE_TYPE_FALLBACK:
		return NodeTypeFallback
	case automationv1.NodeType_NODE_TYPE_DIAGNOSTICS:
		return NodeTypeDiagnostics
	case automationv1.NodeType_NODE_TYPE_HANDOFF:
		return NodeTypeHandoff
	case automationv1.NodeType_NODE_TYPE_TERMINAL:
		return NodeTypeTerminal
	default:
		return NodeTypeTrigger
	}
}

func toProtoTriggerType(t TriggerType) automationv1.TriggerType {
	switch t {
	case TriggerTypeEvent:
		return automationv1.TriggerType_TRIGGER_TYPE_EVENT
	case TriggerTypeSchedule:
		return automationv1.TriggerType_TRIGGER_TYPE_SCHEDULE
	case TriggerTypeManual:
		return automationv1.TriggerType_TRIGGER_TYPE_MANUAL
	case TriggerTypeWebhook:
		return automationv1.TriggerType_TRIGGER_TYPE_WEBHOOK
	default:
		return automationv1.TriggerType_TRIGGER_TYPE_UNSPECIFIED
	}
}

func fromProtoTriggerType(t automationv1.TriggerType) TriggerType {
	switch t {
	case automationv1.TriggerType_TRIGGER_TYPE_EVENT:
		return TriggerTypeEvent
	case automationv1.TriggerType_TRIGGER_TYPE_SCHEDULE:
		return TriggerTypeSchedule
	case automationv1.TriggerType_TRIGGER_TYPE_MANUAL:
		return TriggerTypeManual
	case automationv1.TriggerType_TRIGGER_TYPE_WEBHOOK:
		return TriggerTypeWebhook
	default:
		return TriggerTypeManual
	}
}

func toProtoEdgeBranch(b EdgeBranch) automationv1.EdgeBranch {
	switch b {
	case EdgeBranchSuccess:
		return automationv1.EdgeBranch_EDGE_BRANCH_SUCCESS
	case EdgeBranchFailure:
		return automationv1.EdgeBranch_EDGE_BRANCH_FAILURE
	case EdgeBranchTrue:
		return automationv1.EdgeBranch_EDGE_BRANCH_TRUE
	case EdgeBranchFalse:
		return automationv1.EdgeBranch_EDGE_BRANCH_FALSE
	default:
		return automationv1.EdgeBranch_EDGE_BRANCH_UNSPECIFIED
	}
}

func fromProtoEdgeBranch(b automationv1.EdgeBranch) EdgeBranch {
	switch b {
	case automationv1.EdgeBranch_EDGE_BRANCH_SUCCESS:
		return EdgeBranchSuccess
	case automationv1.EdgeBranch_EDGE_BRANCH_FAILURE:
		return EdgeBranchFailure
	case automationv1.EdgeBranch_EDGE_BRANCH_TRUE:
		return EdgeBranchTrue
	case automationv1.EdgeBranch_EDGE_BRANCH_FALSE:
		return EdgeBranchFalse
	default:
		return ""
	}
}

func triggerConfigToProto(tc TriggerConfig) *automationv1.TriggerConfig {
	filters := make([]*automationv1.TriggerFilter, len(tc.Filters))
	for i, f := range tc.Filters {
		filters[i] = &automationv1.TriggerFilter{
			Field:     f.Field,
			Operator:  f.Operator,
			ValueJson: f.ValueJSON,
		}
	}
	return &automationv1.TriggerConfig{
		Type:           toProtoTriggerType(tc.Type),
		EventType:      tc.EventType,
		CronExpression: tc.CronExpression,
		WebhookPath:    tc.WebhookPath,
		Filters:        filters,
	}
}

func triggerConfigFromProto(pb *automationv1.TriggerConfig) TriggerConfig {
	if pb == nil {
		return TriggerConfig{Type: TriggerTypeManual}
	}
	filters := make([]TriggerFilter, len(pb.Filters))
	for i, f := range pb.Filters {
		filters[i] = TriggerFilter{
			Field:     f.Field,
			Operator:  f.Operator,
			ValueJSON: f.ValueJson,
		}
	}
	return TriggerConfig{
		Type:           fromProtoTriggerType(pb.Type),
		EventType:      pb.EventType,
		CronExpression: pb.CronExpression,
		WebhookPath:    pb.WebhookPath,
		Filters:        filters,
	}
}

func graphToProto(g WorkflowGraph) *automationv1.WorkflowGraph {
	nodes := make([]*automationv1.WorkflowNode, len(g.Nodes))
	for i, n := range g.Nodes {
		rawJSON, _ := json.Marshal(n.Config)
		pbNode := &automationv1.WorkflowNode{
			NodeId:        n.NodeID,
			NodeType:      toProtoNodeType(n.NodeType),
			Title:         n.Title,
			Description:   n.Description,
			RawConfigJson: string(rawJSON),
		}

		if n.TriggerConfig != nil {
			pbNode.Config = &automationv1.WorkflowNode_TriggerConfig{
				TriggerConfig: &automationv1.TriggerNodeConfig{
					Config: triggerConfigToProto(*n.TriggerConfig),
				},
			}
		} else if n.ConditionConfig != nil {
			pbNode.Config = &automationv1.WorkflowNode_ConditionConfig{
				ConditionConfig: &automationv1.ConditionNodeConfig{
					Field:     n.ConditionConfig.Field,
					Operator:  n.ConditionConfig.Operator,
					ValueJson: n.ConditionConfig.ValueJSON,
				},
			}
		} else if n.TransformConfig != nil {
			mappings := make([]*automationv1.TransformMapping, len(n.TransformConfig.Mappings))
			for j, m := range n.TransformConfig.Mappings {
				mappings[j] = &automationv1.TransformMapping{
					TargetField:  m.TargetField,
					SourceField:  m.SourceField,
					DefaultValue: m.DefaultValue,
					Template:     m.Template,
				}
			}
			pbNode.Config = &automationv1.WorkflowNode_TransformConfig{
				TransformConfig: &automationv1.TransformNodeConfig{
					Mappings: mappings,
				},
			}
		} else if n.ActionConfig != nil {
			pbNode.Config = &automationv1.WorkflowNode_ActionConfig{
				ActionConfig: &automationv1.ActionNodeConfig{
					RpcName:        n.ActionConfig.RPCName,
					InputJson:      n.ActionConfig.InputJSON,
					TimeoutSeconds: int32(n.ActionConfig.TimeoutSeconds),
					MaxRetries:     int32(n.ActionConfig.MaxRetries),
					BackoffSeconds: int32(n.ActionConfig.BackoffSeconds),
				},
			}
		} else if n.ApprovalConfig != nil {
			pbNode.Config = &automationv1.WorkflowNode_ApprovalConfig{
				ApprovalConfig: &automationv1.ApprovalNodeConfig{
					ApproverIds:              n.ApprovalConfig.ApproverIDs,
					RequiredApprovals:        int32(n.ApprovalConfig.RequiredApprovals),
					ExpiresAtDurationSeconds: n.ApprovalConfig.ExpiresAtDurationSeconds,
					AutoActionOnTimeout:      n.ApprovalConfig.AutoActionOnTimeout,
				},
			}
		} else if n.WaitConfig != nil {
			pbNode.Config = &automationv1.WorkflowNode_WaitConfig{
				WaitConfig: &automationv1.WaitNodeConfig{
					WaitType:        n.WaitConfig.WaitType,
					DurationSeconds: n.WaitConfig.DurationSeconds,
					ResumeCondition: n.WaitConfig.ResumeCondition,
					UntilTimestamp:  n.WaitConfig.UntilTimestamp,
				},
			}
		} else if n.FallbackConfig != nil {
			pbNode.Config = &automationv1.WorkflowNode_FallbackConfig{
				FallbackConfig: &automationv1.FallbackNodeConfig{
					FallbackNodeId: n.FallbackConfig.FallbackNodeID,
					ReasonTemplate: n.FallbackConfig.ReasonTemplate,
					LogLevel:       n.FallbackConfig.LogLevel,
				},
			}
		} else if n.DiagnosticsConfig != nil {
			pbNode.Config = &automationv1.WorkflowNode_DiagnosticsConfig{
				DiagnosticsConfig: &automationv1.DiagnosticsNodeConfig{
					Severity:            n.DiagnosticsConfig.Severity,
					UserMessage:         n.DiagnosticsConfig.UserMessage,
					OperatorMessage:     n.DiagnosticsConfig.OperatorMessage,
					RecommendedNextStep: n.DiagnosticsConfig.RecommendedNextStep,
				},
			}
		} else if n.HandoffConfig != nil {
			pbNode.Config = &automationv1.WorkflowNode_HandoffConfig{
				HandoffConfig: &automationv1.HandoffNodeConfig{
					TargetUserId: n.HandoffConfig.TargetUserID,
					TargetRole:   n.HandoffConfig.TargetRole,
					ContextNote:  n.HandoffConfig.ContextNote,
				},
			}
		} else if n.TerminalConfig != nil {
			pbNode.Config = &automationv1.WorkflowNode_TerminalConfig{
				TerminalConfig: &automationv1.TerminalNodeConfig{
					Outcome:        n.TerminalConfig.Outcome,
					ResultTemplate: n.TerminalConfig.ResultTemplate,
				},
			}
		}
		nodes[i] = pbNode
	}

	edges := make([]*automationv1.WorkflowEdge, len(g.Edges))
	for i, e := range g.Edges {
		edges[i] = &automationv1.WorkflowEdge{
			FromNodeId: e.FromNodeID,
			ToNodeId:   e.ToNodeID,
			Branch:     toProtoEdgeBranch(e.Branch),
		}
	}

	return &automationv1.WorkflowGraph{
		SchemaVersion: int32(g.SchemaVersion),
		Nodes:         nodes,
		Edges:         edges,
	}
}

func graphFromProto(pb *automationv1.WorkflowGraph) WorkflowGraph {
	if pb == nil {
		return WorkflowGraph{SchemaVersion: 1}
	}
	nodes := make([]WorkflowNode, len(pb.Nodes))
	for i, n := range pb.Nodes {
		var cfg map[string]any
		if n.RawConfigJson != "" {
			_ = json.Unmarshal([]byte(n.RawConfigJson), &cfg)
		}
		if cfg == nil {
			cfg = make(map[string]any)
		}

		node := WorkflowNode{
			NodeID:      n.NodeId,
			NodeType:    fromProtoNodeType(n.NodeType),
			Title:       n.Title,
			Description: n.Description,
			Config:      cfg,
		}

		if tc := n.GetTriggerConfig(); tc != nil && tc.Config != nil {
			trig := triggerConfigFromProto(tc.Config)
			node.TriggerConfig = &trig
		} else if cc := n.GetConditionConfig(); cc != nil {
			node.ConditionConfig = &ConditionConfig{
				Field:     cc.Field,
				Operator:  cc.Operator,
				ValueJSON: cc.ValueJson,
			}
		} else if tc := n.GetTransformConfig(); tc != nil {
			mappings := make([]TransformMapping, len(tc.Mappings))
			for j, m := range tc.Mappings {
				mappings[j] = TransformMapping{
					TargetField:  m.TargetField,
					SourceField:  m.SourceField,
					DefaultValue: m.DefaultValue,
					Template:     m.Template,
				}
			}
			node.TransformConfig = &TransformConfig{Mappings: mappings}
		} else if ac := n.GetActionConfig(); ac != nil {
			node.ActionConfig = &ActionConfig{
				RPCName:        ac.RpcName,
				InputJSON:      ac.InputJson,
				TimeoutSeconds: int(ac.TimeoutSeconds),
				MaxRetries:     int(ac.MaxRetries),
				BackoffSeconds: int(ac.BackoffSeconds),
			}
		} else if ap := n.GetApprovalConfig(); ap != nil {
			node.ApprovalConfig = &ApprovalConfig{
				ApproverIDs:              ap.ApproverIds,
				RequiredApprovals:        int(ap.RequiredApprovals),
				ExpiresAtDurationSeconds: ap.ExpiresAtDurationSeconds,
				AutoActionOnTimeout:      ap.AutoActionOnTimeout,
			}
		} else if wc := n.GetWaitConfig(); wc != nil {
			node.WaitConfig = &WaitConfig{
				WaitType:        wc.WaitType,
				DurationSeconds: wc.DurationSeconds,
				ResumeCondition: wc.ResumeCondition,
				UntilTimestamp:  wc.UntilTimestamp,
			}
		} else if fc := n.GetFallbackConfig(); fc != nil {
			node.FallbackConfig = &FallbackConfig{
				FallbackNodeID: fc.FallbackNodeId,
				ReasonTemplate: fc.ReasonTemplate,
				LogLevel:       fc.LogLevel,
			}
		} else if dc := n.GetDiagnosticsConfig(); dc != nil {
			node.DiagnosticsConfig = &DiagnosticsConfig{
				Severity:            dc.Severity,
				UserMessage:         dc.UserMessage,
				OperatorMessage:     dc.OperatorMessage,
				RecommendedNextStep: dc.RecommendedNextStep,
			}
		} else if hc := n.GetHandoffConfig(); hc != nil {
			node.HandoffConfig = &HandoffConfig{
				TargetUserID: hc.TargetUserId,
				TargetRole:   hc.TargetRole,
				ContextNote:  hc.ContextNote,
			}
		} else if tc := n.GetTerminalConfig(); tc != nil {
			node.TerminalConfig = &TerminalConfig{
				Outcome:        tc.Outcome,
				ResultTemplate: tc.ResultTemplate,
			}
		}
		nodes[i] = node
	}

	edges := make([]WorkflowEdge, len(pb.Edges))
	for i, e := range pb.Edges {
		edges[i] = WorkflowEdge{
			FromNodeID: e.FromNodeId,
			ToNodeID:   e.ToNodeId,
			Branch:     fromProtoEdgeBranch(e.Branch),
		}
	}

	return WorkflowGraph{
		SchemaVersion: int(pb.SchemaVersion),
		Nodes:         nodes,
		Edges:         edges,
	}
}

// Exported helpers for cross-package conversions (e.g., recipe package)
func WorkflowToProto(w *Workflow) *automationv1.Workflow {
	return workflowToProto(w)
}

func RunToProto(r *WorkflowRun) *automationv1.WorkflowRun {
	return runToProto(r)
}

func workflowToProto(w *Workflow) *automationv1.Workflow {
	if w == nil {
		return nil
	}
	actionChainJSON, _ := json.Marshal(w.ActionChain)
	approvalReqJSON, _ := json.Marshal(w.ApprovalRequirements)

	return &automationv1.Workflow{
		WorkflowId:               w.WorkflowID,
		WorkspaceId:              w.WorkspaceID,
		Title:                    w.Title,
		Description:              w.Description,
		WorkflowType:             w.WorkflowType,
		Status:                   toProtoWorkflowStatus(w.Status),
		Version:                  w.Version,
		TriggerConfig:            triggerConfigToProto(w.TriggerConfig),
		ActionChain:              graphToProto(w.ActionChain),
		ActionChainJson:          string(actionChainJSON),
		ApprovalRequirementsJson: string(approvalReqJSON),
		ActivepiecesFlowId:       w.ActivepiecesFlowID,
		TierLimitCheck:           w.TierLimitCheck,
		RunCount:                 w.RunCount,
		CreatedBy:                w.CreatedBy,
		CreatedAt:                timestamppb.New(w.CreatedAt),
		UpdatedAt:                timestamppb.New(w.UpdatedAt),
	}
}

func workflowSummaryToProto(w *Workflow) *automationv1.WorkflowSummary {
	if w == nil {
		return nil
	}
	return &automationv1.WorkflowSummary{
		WorkflowId:   w.WorkflowID,
		WorkspaceId:  w.WorkspaceID,
		Title:        w.Title,
		WorkflowType: w.WorkflowType,
		Status:       toProtoWorkflowStatus(w.Status),
		Version:      w.Version,
		TriggerType:  toProtoTriggerType(w.TriggerConfig.Type),
		NodeCount:    int32(len(w.ActionChain.Nodes)),
		RunCount:     w.RunCount,
		CreatedAt:    timestamppb.New(w.CreatedAt),
		UpdatedAt:    timestamppb.New(w.UpdatedAt),
	}
}

func runToProto(r *WorkflowRun) *automationv1.WorkflowRun {
	if r == nil {
		return nil
	}
	trigJSON, _ := json.Marshal(r.TriggerEvent)
	resJSON, _ := json.Marshal(r.ResultSummary)
	logJSON, _ := json.Marshal(r.ExecutionLog)
	affJSON, _ := json.Marshal(r.AffectedObjectRefs)
	sideJSON, _ := json.Marshal(r.SideEffectsSummary)

	pr := &automationv1.WorkflowRun{
		RunId:                  r.RunID,
		WorkspaceId:            r.WorkspaceID,
		WorkflowId:             r.WorkflowID,
		Status:                 toProtoWorkflowRunStatus(r.Status),
		CurrentNode:            r.CurrentNode,
		TriggerEventJson:       string(trigJSON),
		ResultSummaryJson:      string(resJSON),
		ExecutionLogJson:       string(logJSON),
		AffectedObjectRefsJson: string(affJSON),
		SideEffectsSummaryJson: string(sideJSON),
		ActivepiecesRunId:      r.ActivepiecesRunID,
		CreatedAt:              timestamppb.New(r.CreatedAt),
		UpdatedAt:              timestamppb.New(r.UpdatedAt),
	}
	if r.StartedAt != nil {
		pr.StartedAt = timestamppb.New(*r.StartedAt)
	}
	if r.CompletedAt != nil {
		pr.CompletedAt = timestamppb.New(*r.CompletedAt)
	}
	return pr
}

func stepToProto(s *WorkflowRunStep) *automationv1.WorkflowRunStep {
	if s == nil {
		return nil
	}
	sideJSON, _ := json.Marshal(s.SideEffectRefs)
	ps := &automationv1.WorkflowRunStep{
		StepId:             s.StepID,
		WorkspaceId:        s.WorkspaceID,
		RunId:              s.RunID,
		NodeId:             s.NodeID,
		NodeType:           toProtoNodeType(s.NodeType),
		StepOrder:          int32(s.StepOrder),
		Status:             s.Status,
		InputSnapshotJson:  s.InputSnapshot,
		OutputSnapshotJson: s.OutputSnapshot,
		DiagnosticsRef:     s.DiagnosticsRef,
		SideEffectRefsJson: string(sideJSON),
		CreatedAt:          timestamppb.New(s.CreatedAt),
		UpdatedAt:          timestamppb.New(s.UpdatedAt),
	}
	if s.StartedAt != nil {
		ps.StartedAt = timestamppb.New(*s.StartedAt)
	}
	if s.CompletedAt != nil {
		ps.CompletedAt = timestamppb.New(*s.CompletedAt)
	}
	return ps
}

func portablePayloadToProto(p *PortableWorkflowPayload) *automationv1.PortableWorkflowPayload {
	if p == nil {
		return nil
	}
	paramsJSON, _ := json.Marshal(p.Parameters)
	return &automationv1.PortableWorkflowPayload{
		SchemaVersion:  int32(p.SchemaVersion),
		Title:          p.Title,
		Description:    p.Description,
		WorkflowType:   p.WorkflowType,
		TriggerConfig:  triggerConfigToProto(p.TriggerConfig),
		Graph:          graphToProto(p.Graph),
		LicenseNotice:  p.LicenseNotice,
		ParametersJson: string(paramsJSON),
	}
}

func portablePayloadFromProto(pb *automationv1.PortableWorkflowPayload) *PortableWorkflowPayload {
	if pb == nil {
		return &PortableWorkflowPayload{SchemaVersion: 1}
	}
	var params map[string]any
	if pb.ParametersJson != "" {
		_ = json.Unmarshal([]byte(pb.ParametersJson), &params)
	}
	return &PortableWorkflowPayload{
		SchemaVersion: int(pb.SchemaVersion),
		Title:         pb.Title,
		Description:   pb.Description,
		WorkflowType:  pb.WorkflowType,
		TriggerConfig: triggerConfigFromProto(pb.TriggerConfig),
		Graph:         graphFromProto(pb.Graph),
		LicenseNotice: pb.LicenseNotice,
		Parameters:    params,
	}
}

// ----------------------------------------------------------------------------
// RPC Implementations (21 Methods)
// ----------------------------------------------------------------------------

func (h *Handler) Create(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceCreateRequest]) (*connect.Response[automationv1.WorkflowServiceCreateResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:create")
	if err != nil {
		return nil, err
	}

	var approvalReqs []string
	if msg.ApprovalRequirementsJson != "" {
		_ = json.Unmarshal([]byte(msg.ApprovalRequirementsJson), &approvalReqs)
	}

	w, err := h.service.CreateWorkflow(
		ctx,
		caller,
		msg.Title,
		msg.Description,
		msg.WorkflowType,
		triggerConfigFromProto(msg.TriggerConfig),
		graphFromProto(msg.ActionChain),
		approvalReqs,
	)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceCreateResponse{
		Id:          w.WorkflowID,
		WorkspaceId: w.WorkspaceID,
		Title:       w.Title,
		Status:      string(w.Status),
		NodeCount:   int32(len(w.ActionChain.Nodes)),
		Version:     w.Version,
		CreatedAt:   timestamppb.New(w.CreatedAt),
		Workflow:    workflowToProto(w),
	}), nil
}

func (h *Handler) Get(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceGetRequest]) (*connect.Response[automationv1.WorkflowServiceGetResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:read")
	if err != nil {
		return nil, err
	}

	w, err := h.service.GetWorkflow(ctx, caller, msg.WorkflowId)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceGetResponse{
		Workflow: workflowToProto(w),
	}), nil
}

func (h *Handler) List(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceListRequest]) (*connect.Response[automationv1.WorkflowServiceListResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:read")
	if err != nil {
		return nil, err
	}

	limit := int(msg.Limit)
	if limit <= 0 {
		limit = 50
	}
	offset := int(msg.Offset)

	workflows, total, err := h.service.ListWorkflows(ctx, caller, msg.Status, limit, offset)
	if err != nil {
		return nil, toConnectError(err)
	}

	summaries := make([]*automationv1.WorkflowSummary, len(workflows))
	for i := range workflows {
		summaries[i] = workflowSummaryToProto(&workflows[i])
	}

	return connect.NewResponse(&automationv1.WorkflowServiceListResponse{
		Workflows:  summaries,
		TotalCount: int32(total),
	}), nil
}

func (h *Handler) Update(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceUpdateRequest]) (*connect.Response[automationv1.WorkflowServiceUpdateResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:edit")
	if err != nil {
		return nil, err
	}

	var approvalReqs []string
	if msg.ApprovalRequirementsJson != "" {
		_ = json.Unmarshal([]byte(msg.ApprovalRequirementsJson), &approvalReqs)
	}

	w, err := h.service.UpdateWorkflow(
		ctx,
		caller,
		msg.WorkflowId,
		msg.Title,
		msg.Description,
		triggerConfigFromProto(msg.TriggerConfig),
		graphFromProto(msg.ActionChain),
		approvalReqs,
		msg.ExpectedVersion,
	)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceUpdateResponse{
		Workflow: workflowToProto(w),
	}), nil
}

func (h *Handler) Activate(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceActivateRequest]) (*connect.Response[automationv1.WorkflowServiceActivateResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:activate")
	if err != nil {
		return nil, err
	}

	w, err := h.service.ActivateWorkflow(ctx, caller, msg.WorkflowId)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceActivateResponse{
		Workflow: workflowToProto(w),
	}), nil
}

func (h *Handler) Deactivate(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceDeactivateRequest]) (*connect.Response[automationv1.WorkflowServiceDeactivateResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:activate")
	if err != nil {
		return nil, err
	}

	w, err := h.service.DeactivateWorkflow(ctx, caller, msg.WorkflowId)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceDeactivateResponse{
		Workflow: workflowToProto(w),
	}), nil
}

func (h *Handler) Run(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceRunRequest]) (*connect.Response[automationv1.WorkflowServiceRunResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:edit")
	if err != nil {
		return nil, err
	}

	var triggerContext map[string]any
	if msg.TriggerContextJson != "" {
		_ = json.Unmarshal([]byte(msg.TriggerContextJson), &triggerContext)
	}
	if triggerContext == nil {
		triggerContext = make(map[string]any)
	}

	run, err := h.service.RunWorkflow(ctx, caller, msg.WorkflowId, triggerContext)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceRunResponse{
		RunId:       run.RunID,
		WorkflowId:  run.WorkflowID,
		Status:      string(run.Status),
		CurrentNode: run.CurrentNode,
		CreatedAt:   timestamppb.New(run.CreatedAt),
		Run:         runToProto(run),
	}), nil
}

func (h *Handler) GetRunDetail(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceGetRunDetailRequest]) (*connect.Response[automationv1.WorkflowServiceGetRunDetailResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:read")
	if err != nil {
		return nil, err
	}

	run, steps, err := h.service.GetRunDetail(ctx, caller, msg.RunId)
	if err != nil {
		return nil, toConnectError(err)
	}

	pbSteps := make([]*automationv1.WorkflowRunStep, len(steps))
	for i := range steps {
		pbSteps[i] = stepToProto(&steps[i])
	}

	return connect.NewResponse(&automationv1.WorkflowServiceGetRunDetailResponse{
		Run:   runToProto(run),
		Steps: pbSteps,
	}), nil
}

func (h *Handler) GetRunLogs(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceGetRunLogsRequest]) (*connect.Response[automationv1.WorkflowServiceGetRunLogsResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:read")
	if err != nil {
		return nil, err
	}

	logs, steps, err := h.service.GetRunLogs(ctx, caller, msg.RunId)
	if err != nil {
		return nil, toConnectError(err)
	}

	logJSON, _ := json.Marshal(logs)
	pbSteps := make([]*automationv1.WorkflowRunStep, len(steps))
	for i := range steps {
		pbSteps[i] = stepToProto(&steps[i])
	}

	return connect.NewResponse(&automationv1.WorkflowServiceGetRunLogsResponse{
		ExecutionLogJson: string(logJSON),
		Steps:            pbSteps,
	}), nil
}

func (h *Handler) ListRuns(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceListRunsRequest]) (*connect.Response[automationv1.WorkflowServiceListRunsResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:read")
	if err != nil {
		return nil, err
	}

	limit := int(msg.Limit)
	if limit <= 0 {
		limit = 50
	}
	offset := int(msg.Offset)

	runs, total, err := h.service.ListRuns(ctx, caller, msg.WorkflowId, msg.Status, limit, offset)
	if err != nil {
		return nil, toConnectError(err)
	}

	pbRuns := make([]*automationv1.WorkflowRun, len(runs))
	for i := range runs {
		pbRuns[i] = runToProto(&runs[i])
	}

	return connect.NewResponse(&automationv1.WorkflowServiceListRunsResponse{
		Runs:       pbRuns,
		TotalCount: int32(total),
	}), nil
}

func (h *Handler) Clone(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceCloneRequest]) (*connect.Response[automationv1.WorkflowServiceCloneResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:edit")
	if err != nil {
		return nil, err
	}

	w, err := h.service.CloneWorkflow(ctx, caller, msg.WorkflowId, msg.NewTitle)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceCloneResponse{
		Workflow: workflowToProto(w),
	}), nil
}

func (h *Handler) Export(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceExportRequest]) (*connect.Response[automationv1.WorkflowServiceExportResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:edit")
	if err != nil {
		return nil, err
	}

	payload, err := h.service.ExportWorkflow(ctx, caller, msg.WorkflowId)
	if err != nil {
		return nil, toConnectError(err)
	}

	payloadJSON, _ := json.Marshal(payload)

	return connect.NewResponse(&automationv1.WorkflowServiceExportResponse{
		Payload:     portablePayloadToProto(payload),
		PayloadJson: string(payloadJSON),
	}), nil
}

func (h *Handler) Import(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceImportRequest]) (*connect.Response[automationv1.WorkflowServiceImportResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:edit")
	if err != nil {
		return nil, err
	}

	var payload *PortableWorkflowPayload
	if msg.Payload != nil {
		payload = portablePayloadFromProto(msg.Payload)
	} else if msg.PayloadJson != "" {
		payload = &PortableWorkflowPayload{}
		if err := json.Unmarshal([]byte(msg.PayloadJson), payload); err != nil {
			return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid payload json: %w", err))
		}
	} else {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("missing payload or payload_json"))
	}

	w, err := h.service.ImportWorkflow(ctx, caller, payload)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceImportResponse{
		Workflow: workflowToProto(w),
	}), nil
}

func (h *Handler) Test(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceTestRequest]) (*connect.Response[automationv1.WorkflowServiceTestResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:edit")
	if err != nil {
		return nil, err
	}

	var targetGraph *WorkflowGraph
	if msg.DraftGraph != nil {
		g := graphFromProto(msg.DraftGraph)
		targetGraph = &g
	}
	var sampleContext map[string]any
	if msg.SampleContextJson != "" {
		_ = json.Unmarshal([]byte(msg.SampleContextJson), &sampleContext)
	}
	if sampleContext == nil {
		sampleContext = make(map[string]any)
	}

	result, err := h.service.TestWorkflow(ctx, caller, msg.WorkflowId, targetGraph, sampleContext)
	if err != nil {
		return nil, toConnectError(err)
	}

	stepResults := make([]*automationv1.WorkflowServiceTestStepResult, len(result.StepResults))
	for i, sr := range result.StepResults {
		outJSON, _ := json.Marshal(sr.SimulatedOutput)
		stepResults[i] = &automationv1.WorkflowServiceTestStepResult{
			NodeId:              sr.NodeID,
			NodeType:            toProtoNodeType(sr.NodeType),
			Status:              sr.Status,
			SimulatedOutputJson: string(outJSON),
			DiagnosticMessage:   sr.DiagnosticMessage,
			EstimatedCredits:    sr.EstimatedCredits,
		}
	}

	return connect.NewResponse(&automationv1.WorkflowServiceTestResponse{
		Success:               result.Success,
		StepResults:           stepResults,
		TotalEstimatedCredits: result.TotalEstimatedCredits,
		SimulationSummary:     result.SimulationSummary,
	}), nil
}

func (h *Handler) GetRunStats(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceGetRunStatsRequest]) (*connect.Response[automationv1.WorkflowServiceGetRunStatsResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:read")
	if err != nil {
		return nil, err
	}

	tot, succ, fail, pend, avg, err := h.service.GetRunStats(ctx, caller, msg.WorkflowId)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceGetRunStatsResponse{
		TotalRuns:          int32(tot),
		SuccessfulRuns:     int32(succ),
		FailedRuns:         int32(fail),
		PendingApprovals:   int32(pend),
		AvgDurationSeconds: avg,
	}), nil
}

func (h *Handler) CancelRun(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceCancelRunRequest]) (*connect.Response[automationv1.WorkflowServiceCancelRunResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:edit")
	if err != nil {
		return nil, err
	}

	run, err := h.service.CancelRun(ctx, caller, msg.RunId, msg.Reason)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceCancelRunResponse{
		Run: runToProto(run),
	}), nil
}

func (h *Handler) RetryRun(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceRetryRunRequest]) (*connect.Response[automationv1.WorkflowServiceRetryRunResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:edit")
	if err != nil {
		return nil, err
	}

	run, err := h.service.RetryRun(ctx, caller, msg.RunId, msg.RepairContextJson)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceRetryRunResponse{
		Run: runToProto(run),
	}), nil
}

func (h *Handler) DismissRun(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceDismissRunRequest]) (*connect.Response[automationv1.WorkflowServiceDismissRunResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:edit")
	if err != nil {
		return nil, err
	}

	if err := h.service.DismissRun(ctx, caller, msg.RunId, msg.DismissalReason); err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceDismissRunResponse{
		Dismissed: true,
	}), nil
}

func (h *Handler) SkipStep(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceSkipStepRequest]) (*connect.Response[automationv1.WorkflowServiceSkipStepResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:edit")
	if err != nil {
		return nil, err
	}

	step, err := h.service.SkipStep(ctx, caller, msg.RunId, msg.NodeId, msg.Reason)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceSkipStepResponse{
		Step: stepToProto(step),
	}), nil
}

func (h *Handler) ProvideInput(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceProvideInputRequest]) (*connect.Response[automationv1.WorkflowServiceProvideInputResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:edit")
	if err != nil {
		return nil, err
	}

	step, err := h.service.ProvideInput(ctx, caller, msg.RunId, msg.NodeId, msg.InputJson)
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceProvideInputResponse{
		Step: stepToProto(step),
	}), nil
}

func (h *Handler) ExportRuns(ctx context.Context, req *connect.Request[automationv1.WorkflowServiceExportRunsRequest]) (*connect.Response[automationv1.WorkflowServiceExportRunsResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("empty request message"))
	}
	caller, err := h.resolveCaller(ctx, msg.WorkspaceId, "workflow:edit")
	if err != nil {
		return nil, err
	}

	fileURL, content, err := h.service.ExportRuns(ctx, caller, msg.WorkflowId, strings.ToLower(msg.Format))
	if err != nil {
		return nil, toConnectError(err)
	}

	return connect.NewResponse(&automationv1.WorkflowServiceExportRunsResponse{
		FileUrl: fileURL,
		Content: content,
	}), nil
}
