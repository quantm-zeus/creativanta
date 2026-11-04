import type { WorkflowGraph, WorkflowNode } from './types';

export interface ValidationResult {
  valid: boolean;
  errors: string[];
}

export function validateWorkflowGraph(graph: WorkflowGraph): ValidationResult {
  const errors: string[] = [];

  if (!graph) {
    return { valid: false, errors: ['Graph is required'] };
  }

  if (graph.schema_version !== 1) {
    errors.push(`Invalid schema_version ${graph.schema_version}: must be strictly 1`);
  }

  if (!graph.nodes || graph.nodes.length === 0) {
    errors.push('Action chain graph cannot be empty');
    return { valid: false, errors };
  }

  if (graph.nodes.length > 100) {
    errors.push(`Node count ${graph.nodes.length} exceeds maximum limit of 100`);
  }

  const nodeMap = new Map<string, WorkflowNode>();
  let triggerCount = 0;
  let terminalCount = 0;
  let rootTriggerId = '';

  for (const node of graph.nodes) {
    if (!node.node_id || node.node_id.trim() === '') {
      errors.push('All nodes must have a non-empty node_id');
      continue;
    }
    if (nodeMap.has(node.node_id)) {
      errors.push(`Duplicate node_id detected: "${node.node_id}"`);
    }
    nodeMap.set(node.node_id, node);

    if (node.node_type === 'trigger') {
      triggerCount++;
      rootTriggerId = node.node_id;
    }
    if (node.node_type === 'terminal') {
      terminalCount++;
    }

    // Security audit
    const rawStr = JSON.stringify(node).toLowerCase();
    const forbiddenCreds = ['"password"', '"secret"', '"private_key"', '"api_secret"', '"auth_token"', 'sk_live_', 'ghp_'];
    for (const cred of forbiddenCreds) {
      if (rawStr.includes(cred)) {
        errors.push(`Credential pattern detected in node "${node.node_id}" config`);
      }
    }
    const forbiddenSQL = ['select ', 'insert into ', 'drop table', 'delete from ', 'update '];
    for (const sql of forbiddenSQL) {
      if (rawStr.includes(sql)) {
        errors.push(`Raw SQL query detected in node "${node.node_id}" config`);
      }
    }

    // Transform node check for arbitrary eval
    if (node.node_type === 'transform' && node.transform_config) {
      for (const m of node.transform_config.mappings || []) {
        const tpl = (m.template || '').toLowerCase();
        if (tpl.includes('eval(') || tpl.includes('function(') || tpl.includes('exec(')) {
          errors.push(`Arbitrary code execution forbidden in transform node "${node.node_id}"`);
        }
      }
    }
  }

  if (triggerCount === 0) {
    errors.push('Graph must contain exactly one root trigger node');
  } else if (triggerCount > 1) {
    errors.push(`Graph contains ${triggerCount} trigger nodes; exactly 1 is allowed`);
  }

  if (terminalCount === 0) {
    errors.push('Graph must contain at least one terminal node');
  }

  const inDegree: Record<string, number> = {};
  const outDegree: Record<string, number> = {};
  const adj: Record<string, string[]> = {};

  for (const n of graph.nodes) {
    inDegree[n.node_id] = 0;
    outDegree[n.node_id] = 0;
    adj[n.node_id] = [];
  }

  for (const edge of graph.edges || []) {
    if (!nodeMap.has(edge.from_node_id)) {
      errors.push(`Edge from_node_id "${edge.from_node_id}" does not exist in graph`);
      continue;
    }
    if (!nodeMap.has(edge.to_node_id)) {
      errors.push(`Edge to_node_id "${edge.to_node_id}" does not exist in graph`);
      continue;
    }
    if (edge.from_node_id === edge.to_node_id) {
      errors.push(`Self-loop detected on node "${edge.from_node_id}"`);
    }

    const fromNode = nodeMap.get(edge.from_node_id)!;
    if (fromNode.node_type === 'condition') {
      if (edge.branch !== 'true' && edge.branch !== 'false') {
        errors.push(`Condition node "${fromNode.node_id}" branch must be "true" or "false", got "${edge.branch}"`);
      }
    }

    inDegree[edge.to_node_id] = (inDegree[edge.to_node_id] || 0) + 1;
    outDegree[edge.from_node_id] = (outDegree[edge.from_node_id] || 0) + 1;
    adj[edge.from_node_id].push(edge.to_node_id);
  }

  // Trigger cannot have incoming edges
  if (rootTriggerId && inDegree[rootTriggerId] > 0) {
    errors.push(`Trigger node "${rootTriggerId}" cannot have incoming edges`);
  }

  // Terminal cannot have outgoing edges
  for (const node of graph.nodes) {
    if (node.node_type === 'terminal' && outDegree[node.node_id] > 0) {
      errors.push(`Terminal node "${node.node_id}" cannot have outgoing edges`);
    }
  }

  // Cycle detection via DFS 3-color coloring
  // 0: unvisited, 1: visiting (in stack), 2: visited
  const color: Record<string, number> = {};
  for (const n of graph.nodes) {
    color[n.node_id] = 0;
  }

  let cycleFound = false;
  function dfs(u: string): boolean {
    color[u] = 1; // visiting
    for (const v of adj[u] || []) {
      if (color[v] === 1) {
        cycleFound = true;
        return true;
      }
      if (color[v] === 0) {
        if (dfs(v)) return true;
      }
    }
    color[u] = 2; // visited
    return false;
  }

  for (const n of graph.nodes) {
    if (color[n.node_id] === 0) {
      if (dfs(n.node_id)) break;
    }
  }

  if (cycleFound) {
    errors.push('Cycle detected in workflow graph: cycles and unbounded loops are forbidden');
  }

  // Reachability from root trigger
  if (rootTriggerId && triggerCount === 1) {
    const reachable = new Set<string>();
    const queue = [rootTriggerId];
    reachable.add(rootTriggerId);

    while (queue.length > 0) {
      const curr = queue.shift()!;
      for (const neighbor of adj[curr] || []) {
        if (!reachable.has(neighbor)) {
          reachable.add(neighbor);
          queue.push(neighbor);
        }
      }
    }

    for (const n of graph.nodes) {
      if (!reachable.has(n.node_id)) {
        errors.push(`Disconnected node detected: "${n.node_id}" is unreachable from root trigger`);
      }
    }
  }

  // Termination: every non-terminal node must have a path to at least one terminal node
  const terminalNodes = graph.nodes.filter((n) => n.node_type === 'terminal').map((n) => n.node_id);
  if (terminalNodes.length > 0) {
    const canReachTerminal = new Set<string>(terminalNodes);
    let changed = true;
    while (changed) {
      changed = false;
      for (const [from, toList] of Object.entries(adj)) {
        if (!canReachTerminal.has(from)) {
          for (const to of toList) {
            if (canReachTerminal.has(to)) {
              canReachTerminal.add(from);
              changed = true;
              break;
            }
          }
        }
      }
    }

    for (const n of graph.nodes) {
      if (n.node_type !== 'terminal' && !canReachTerminal.has(n.node_id)) {
        errors.push(`Dead-end node detected: "${n.node_id}" has no path to any terminal node`);
      }
    }
  }

  return {
    valid: errors.length === 0,
    errors
  };
}
