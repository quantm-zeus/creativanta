import 'dart:collection';

/// Canonical lifecycle states per database_schema.md §12.2 and workflow_studio.md RULE-M20-001.
enum WorkflowStatus {
  draft,
  active,
  paused,
  error,
  archived;

  static WorkflowStatus fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'active':
        return WorkflowStatus.active;
      case 'paused':
        return WorkflowStatus.paused;
      case 'error':
        return WorkflowStatus.error;
      case 'archived':
        return WorkflowStatus.archived;
      case 'draft':
      default:
        return WorkflowStatus.draft;
    }
  }
}

/// Runtime run states per database_schema.md §12.3.
enum WorkflowRunStatus {
  queued,
  running,
  waitingApproval,
  waitingExternalCondition,
  succeeded,
  partiallySucceeded,
  failed,
  cancelled,
  requiresManualIntervention;

  static WorkflowRunStatus fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'running':
        return WorkflowRunStatus.running;
      case 'waiting_approval':
        return WorkflowRunStatus.waitingApproval;
      case 'waiting_external_condition':
        return WorkflowRunStatus.waitingExternalCondition;
      case 'succeeded':
        return WorkflowRunStatus.succeeded;
      case 'partially_succeeded':
        return WorkflowRunStatus.partiallySucceeded;
      case 'failed':
        return WorkflowRunStatus.failed;
      case 'cancelled':
        return WorkflowRunStatus.cancelled;
      case 'requires_manual_intervention':
        return WorkflowRunStatus.requiresManualIntervention;
      case 'queued':
      default:
        return WorkflowRunStatus.queued;
    }
  }
}

/// All 10 canonical node types per database_schema.md §12.3A and runtime_workflow.md §4.2.
enum WorkflowNodeType {
  trigger,
  condition,
  transform,
  action,
  approval,
  wait,
  fallback,
  diagnostics,
  handoff,
  terminal;

  static WorkflowNodeType fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'condition':
        return WorkflowNodeType.condition;
      case 'transform':
        return WorkflowNodeType.transform;
      case 'action':
        return WorkflowNodeType.action;
      case 'approval':
        return WorkflowNodeType.approval;
      case 'wait':
        return WorkflowNodeType.wait;
      case 'fallback':
        return WorkflowNodeType.fallback;
      case 'diagnostics':
        return WorkflowNodeType.diagnostics;
      case 'handoff':
        return WorkflowNodeType.handoff;
      case 'terminal':
        return WorkflowNodeType.terminal;
      case 'trigger':
      default:
        return WorkflowNodeType.trigger;
    }
  }
}

/// Supported trigger types per database_schema.md §25.4.
enum WorkflowTriggerType {
  event,
  schedule,
  manual,
  webhook;

  static WorkflowTriggerType fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'schedule':
        return WorkflowTriggerType.schedule;
      case 'manual':
        return WorkflowTriggerType.manual;
      case 'webhook':
        return WorkflowTriggerType.webhook;
      case 'event':
      default:
        return WorkflowTriggerType.event;
    }
  }
}

/// Directed edge branching conditions per database_schema.md §25.7.
enum WorkflowEdgeBranch {
  success,
  failure,
  isTrue,
  isFalse;

  static WorkflowEdgeBranch? fromString(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    switch (raw.toLowerCase()) {
      case 'failure':
        return WorkflowEdgeBranch.failure;
      case 'true':
        return WorkflowEdgeBranch.isTrue;
      case 'false':
        return WorkflowEdgeBranch.isFalse;
      case 'success':
      default:
        return WorkflowEdgeBranch.success;
    }
  }

  String toContractString() {
    switch (this) {
      case WorkflowEdgeBranch.failure:
        return 'failure';
      case WorkflowEdgeBranch.isTrue:
        return 'true';
      case WorkflowEdgeBranch.isFalse:
        return 'false';
      case WorkflowEdgeBranch.success:
        return 'success';
    }
  }
}

class MobileWorkflowNode {
  final String nodeId;
  final WorkflowNodeType nodeType;
  final String title;
  final String description;
  final Map<String, dynamic> config;

  const MobileWorkflowNode({
    required this.nodeId,
    required this.nodeType,
    required this.title,
    this.description = '',
    this.config = const {},
  });

  Map<String, dynamic> toJson() => {
        'node_id': nodeId,
        'node_type': nodeType.name,
        'title': title,
        'description': description,
        'config': config,
      };

  factory MobileWorkflowNode.fromJson(Map<String, dynamic> json) {
    return MobileWorkflowNode(
      nodeId: json['node_id'] as String? ?? '',
      nodeType: WorkflowNodeType.fromString(json['node_type'] as String? ?? 'trigger'),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      config: (json['config'] as Map<String, dynamic>?) ?? {},
    );
  }
}

class MobileWorkflowEdge {
  final String fromNodeId;
  final String toNodeId;
  final WorkflowEdgeBranch? branch;

  const MobileWorkflowEdge({
    required this.fromNodeId,
    required this.toNodeId,
    this.branch,
  });

  Map<String, dynamic> toJson() => {
        'from_node_id': fromNodeId,
        'to_node_id': toNodeId,
        if (branch != null) 'branch': branch!.toContractString(),
      };

  factory MobileWorkflowEdge.fromJson(Map<String, dynamic> json) {
    return MobileWorkflowEdge(
      fromNodeId: json['from_node_id'] as String? ?? '',
      toNodeId: json['to_node_id'] as String? ?? '',
      branch: WorkflowEdgeBranch.fromString(json['branch'] as String?),
    );
  }
}

class MobileWorkflowGraph {
  final int schemaVersion;
  final List<MobileWorkflowNode> nodes;
  final List<MobileWorkflowEdge> edges;

  const MobileWorkflowGraph({
    this.schemaVersion = 1,
    required this.nodes,
    required this.edges,
  });

  Map<String, dynamic> toJson() => {
        'schema_version': schemaVersion,
        'nodes': nodes.map((n) => n.toJson()).toList(),
        'edges': edges.map((e) => e.toJson()).toList(),
      };

  factory MobileWorkflowGraph.fromJson(Map<String, dynamic> json) {
    return MobileWorkflowGraph(
      schemaVersion: json['schema_version'] as int? ?? 1,
      nodes: (json['nodes'] as List<dynamic>? ?? [])
          .map((item) => MobileWorkflowNode.fromJson(item as Map<String, dynamic>))
          .toList(),
      edges: (json['edges'] as List<dynamic>? ?? [])
          .map((item) => MobileWorkflowEdge.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MobileWorkflow {
  final String workflowId;
  final String workspaceId;
  final String title;
  final String description;
  final String workflowType;
  final WorkflowStatus status;
  final int version;
  final WorkflowTriggerType triggerType;
  final MobileWorkflowGraph graph;
  final int runCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MobileWorkflow({
    required this.workflowId,
    required this.workspaceId,
    required this.title,
    this.description = '',
    this.workflowType = 'custom',
    required this.status,
    required this.version,
    required this.triggerType,
    required this.graph,
    this.runCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });
}

class MobileWorkflowRun {
  final String runId;
  final String workspaceId;
  final String workflowId;
  final WorkflowRunStatus status;
  final String currentNode;
  final DateTime createdAt;
  final DateTime? completedAt;

  const MobileWorkflowRun({
    required this.runId,
    required this.workspaceId,
    required this.workflowId,
    required this.status,
    this.currentNode = '',
    required this.createdAt,
    this.completedAt,
  });
}

class MobileWorkflowRunStep {
  final String stepId;
  final String runId;
  final String nodeId;
  final WorkflowNodeType nodeType;
  final int stepOrder;
  final String status;
  final DateTime createdAt;

  const MobileWorkflowRunStep({
    required this.stepId,
    required this.runId,
    required this.nodeId,
    required this.nodeType,
    required this.stepOrder,
    required this.status,
    required this.createdAt,
  });
}

/// Validation result with specific failure messages.
class GraphValidationResult {
  final bool isValid;
  final List<String> errors;

  const GraphValidationResult({
    required this.isValid,
    required this.errors,
  });
}

/// Direct client-side validation mirroring backend invariants.
GraphValidationResult validateMobileWorkflowGraph(MobileWorkflowGraph graph) {
  final errors = <String>[];

  if (graph.schemaVersion != 1) {
    errors.add('Invalid schemaVersion: must be strictly 1');
  }

  if (graph.nodes.isEmpty) {
    errors.add('Action chain graph cannot be empty');
    return GraphValidationResult(isValid: false, errors: errors);
  }

  if (graph.nodes.length > 100) {
    errors.add('Node count ${graph.nodes.length} exceeds maximum allowed limit (100)');
  }

  final nodeMap = <String, MobileWorkflowNode>{};
  int triggerCount = 0;
  int terminalCount = 0;
  String rootTriggerId = '';

  for (final node in graph.nodes) {
    if (node.nodeId.trim().isEmpty) {
      errors.add('All nodes must have non-empty nodeId');
      continue;
    }
    if (nodeMap.containsKey(node.nodeId)) {
      errors.add('Duplicate nodeId detected: "${node.nodeId}"');
    }
    nodeMap[node.nodeId] = node;

    if (node.nodeType == WorkflowNodeType.trigger) {
      triggerCount++;
      rootTriggerId = node.nodeId;
    } else if (node.nodeType == WorkflowNodeType.terminal) {
      terminalCount++;
    }
  }

  if (triggerCount == 0) {
    errors.add('Graph must contain exactly one root trigger node');
  } else if (triggerCount > 1) {
    errors.add('Graph contains $triggerCount trigger nodes; exactly 1 is allowed');
  }

  if (terminalCount == 0) {
    errors.add('Graph must contain at least one terminal node');
  }

  final inDegree = <String, int>{};
  final outDegree = <String, int>{};
  final adj = <String, List<String>>{};

  for (final n in graph.nodes) {
    inDegree[n.nodeId] = 0;
    outDegree[n.nodeId] = 0;
    adj[n.nodeId] = [];
  }

  for (final edge in graph.edges) {
    if (!nodeMap.containsKey(edge.fromNodeId)) {
      errors.add('Edge references non-existent fromNodeId: "${edge.fromNodeId}"');
      continue;
    }
    if (!nodeMap.containsKey(edge.toNodeId)) {
      errors.add('Edge references non-existent toNodeId: "${edge.toNodeId}"');
      continue;
    }
    if (edge.fromNodeId == edge.toNodeId) {
      errors.add('Self-loop detected on node "${edge.fromNodeId}"');
    }

    inDegree[edge.toNodeId] = (inDegree[edge.toNodeId] ?? 0) + 1;
    outDegree[edge.fromNodeId] = (outDegree[edge.fromNodeId] ?? 0) + 1;
    adj[edge.fromNodeId]?.add(edge.toNodeId);
  }

  // Trigger cannot have incoming edges
  if (rootTriggerId.isNotEmpty && (inDegree[rootTriggerId] ?? 0) > 0) {
    errors.add('Trigger node "$rootTriggerId" cannot have incoming edges');
  }

  // Terminal cannot have outgoing edges
  for (final n in graph.nodes) {
    if (n.nodeType == WorkflowNodeType.terminal && (outDegree[n.nodeId] ?? 0) > 0) {
      errors.add('Terminal node "${n.nodeId}" cannot have outgoing edges');
    }
  }

  // Cycle detection via DFS 3-color coloring: 0=unvisited, 1=visiting, 2=visited
  final color = <String, int>{};
  for (final n in graph.nodes) {
    color[n.nodeId] = 0;
  }

  bool cycleFound = false;
  bool dfs(String u) {
    color[u] = 1; // visiting
    for (final v in adj[u] ?? []) {
      if (color[v] == 1) {
        cycleFound = true;
        return true;
      }
      if (color[v] == 0) {
        if (dfs(v)) return true;
      }
    }
    color[u] = 2; // visited
    return false;
  }

  for (final n in graph.nodes) {
    if (color[n.nodeId] == 0) {
      if (dfs(n.nodeId)) break;
    }
  }

  if (cycleFound) {
    errors.add('Cycle detected in workflow graph');
  }

  // Reachability from root trigger
  if (rootTriggerId.isNotEmpty && triggerCount == 1) {
    final reachable = <String>{rootTriggerId};
    final queue = Queue<String>()..add(rootTriggerId);

    while (queue.isNotEmpty) {
      final curr = queue.removeFirst();
      for (final neighbor in adj[curr] ?? []) {
        if (!reachable.contains(neighbor)) {
          reachable.add(neighbor);
          queue.add(neighbor);
        }
      }
    }

    for (final n in graph.nodes) {
      if (!reachable.contains(n.nodeId)) {
        errors.add('Disconnected node detected: "${n.nodeId}" is unreachable from root trigger');
      }
    }
  }

  // Termination check: every non-terminal node must reach at least one terminal node
  final terminalNodes = graph.nodes
      .where((n) => n.nodeType == WorkflowNodeType.terminal)
      .map((n) => n.nodeId)
      .toSet();

  if (terminalNodes.isNotEmpty) {
    final canReachTerminal = Set<String>.from(terminalNodes);
    bool changed = true;
    while (changed) {
      changed = false;
      for (final entry in adj.entries) {
        if (!canReachTerminal.contains(entry.key)) {
          for (final target in entry.value) {
            if (canReachTerminal.contains(target)) {
              canReachTerminal.add(entry.key);
              changed = true;
              break;
            }
          }
        }
      }
    }

    for (final n in graph.nodes) {
      if (n.nodeType != WorkflowNodeType.terminal && !canReachTerminal.contains(n.nodeId)) {
        errors.add('Dead-end node detected: "${n.nodeId}" has no path to any terminal node');
      }
    }
  }

  return GraphValidationResult(
    isValid: errors.isEmpty,
    errors: errors,
  );
}
