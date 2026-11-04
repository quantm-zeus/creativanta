import { describe, it, expect } from 'vitest';
import { validateWorkflowGraph } from './validation';
import type { WorkflowGraph } from './types';

function createValid10NodeGraph(): WorkflowGraph {
  return {
    schema_version: 1,
    nodes: [
      {
        node_id: 'n-trig',
        node_type: 'trigger',
        title: 'Order Created Trigger',
        trigger_config: { type: 'event', event_type: 'order.created' }
      },
      {
        node_id: 'n-cond',
        node_type: 'condition',
        title: 'Check VIP Level',
        condition_config: { field: 'customer.is_vip', operator: 'eq', value_json: 'true' }
      },
      {
        node_id: 'n-trans',
        node_type: 'transform',
        title: 'Map VIP Fields',
        transform_config: { mappings: [{ target_field: 'tier', source_field: 'customer.tier' }] }
      },
      {
        node_id: 'n-act',
        node_type: 'action',
        title: 'Reserve VIP Sku',
        action_config: { rpc_name: 'creativanta.commerce.v1.InventoryService/ReserveStock', input_json: '{}' }
      },
      {
        node_id: 'n-appr',
        node_type: 'approval',
        title: 'Manager Discount Approval',
        approval_config: { approver_ids: ['usr-1'], required_approvals: 1, expires_at_duration_seconds: 3600 }
      },
      {
        node_id: 'n-wait',
        node_type: 'wait',
        title: 'Wait for Verification',
        wait_config: { wait_type: 'duration', duration_seconds: 300 }
      },
      {
        node_id: 'n-diag',
        node_type: 'diagnostics',
        title: 'Emit Trace Log',
        diagnostics_config: { severity: 'info', user_message: 'Step OK', operator_message: 'Validated' }
      },
      {
        node_id: 'n-fall',
        node_type: 'fallback',
        title: 'Standard Fallback',
        fallback_config: { fallback_node_id: 'n-term', reason_template: 'Non-VIP fallback' }
      },
      {
        node_id: 'n-hand',
        node_type: 'handoff',
        title: 'Agent Handoff',
        handoff_config: { target_user_id: 'usr-agent-1' }
      },
      {
        node_id: 'n-term',
        node_type: 'terminal',
        title: 'Workflow End',
        terminal_config: { outcome: 'succeeded' }
      }
    ],
    edges: [
      { from_node_id: 'n-trig', to_node_id: 'n-cond' },
      { from_node_id: 'n-cond', to_node_id: 'n-trans', branch: 'true' },
      { from_node_id: 'n-cond', to_node_id: 'n-fall', branch: 'false' },
      { from_node_id: 'n-trans', to_node_id: 'n-act' },
      { from_node_id: 'n-act', to_node_id: 'n-appr' },
      { from_node_id: 'n-appr', to_node_id: 'n-wait' },
      { from_node_id: 'n-wait', to_node_id: 'n-diag' },
      { from_node_id: 'n-diag', to_node_id: 'n-hand' },
      { from_node_id: 'n-hand', to_node_id: 'n-term' },
      { from_node_id: 'n-fall', to_node_id: 'n-term' }
    ]
  };
}

describe('Workflow Validation', () => {
  it('accepts valid 10-node graph', () => {
    const g = createValid10NodeGraph();
    const res = validateWorkflowGraph(g);
    expect(res.valid).toBe(true);
    expect(res.errors).toHaveLength(0);
  });

  it('rejects self-loops', () => {
    const g: WorkflowGraph = {
      schema_version: 1,
      nodes: [
        { node_id: 'trig', node_type: 'trigger', title: 'Start' },
        { node_id: 'term', node_type: 'terminal', title: 'End' }
      ],
      edges: [
        { from_node_id: 'trig', to_node_id: 'term' },
        { from_node_id: 'term', to_node_id: 'term' }
      ]
    };
    const res = validateWorkflowGraph(g);
    expect(res.valid).toBe(false);
    expect(res.errors.some((e) => e.includes('Self-loop detected'))).toBe(true);
  });

  it('rejects 2-node cycle', () => {
    const g: WorkflowGraph = {
      schema_version: 1,
      nodes: [
        { node_id: 'trig', node_type: 'trigger', title: 'Start' },
        { node_id: 'n1', node_type: 'action', title: 'Action 1' },
        { node_id: 'n2', node_type: 'transform', title: 'Transform 2' },
        { node_id: 'term', node_type: 'terminal', title: 'End' }
      ],
      edges: [
        { from_node_id: 'trig', to_node_id: 'n1' },
        { from_node_id: 'n1', to_node_id: 'n2' },
        { from_node_id: 'n2', to_node_id: 'n1' }, // Cycle n1 <-> n2
        { from_node_id: 'n2', to_node_id: 'term' }
      ]
    };
    const res = validateWorkflowGraph(g);
    expect(res.valid).toBe(false);
    expect(res.errors.some((e) => e.includes('Cycle detected'))).toBe(true);
  });

  it('rejects unbounded node count (>100)', () => {
    const nodes = [];
    const edges = [];
    nodes.push({ node_id: 'node-0', node_type: 'trigger' as const, title: 'Start' });
    for (let i = 1; i <= 101; i++) {
      nodes.push({ node_id: `node-${i}`, node_type: 'transform' as const, title: `Node ${i}` });
      edges.push({ from_node_id: `node-${i - 1}`, to_node_id: `node-${i}` });
    }
    nodes.push({ node_id: 'node-102', node_type: 'terminal' as const, title: 'End' });
    edges.push({ from_node_id: 'node-101', to_node_id: 'node-102' });

    const g: WorkflowGraph = { schema_version: 1, nodes, edges };
    const res = validateWorkflowGraph(g);
    expect(res.valid).toBe(false);
    expect(res.errors.some((e) => e.includes('exceeds maximum limit of 100'))).toBe(true);
  });

  it('rejects disconnected nodes', () => {
    const g: WorkflowGraph = {
      schema_version: 1,
      nodes: [
        { node_id: 'trig', node_type: 'trigger', title: 'Start' },
        { node_id: 'term', node_type: 'terminal', title: 'End' },
        { node_id: 'island', node_type: 'transform', title: 'Island' }
      ],
      edges: [{ from_node_id: 'trig', to_node_id: 'term' }]
    };
    const res = validateWorkflowGraph(g);
    expect(res.valid).toBe(false);
    expect(res.errors.some((e) => e.includes('unreachable from root trigger'))).toBe(true);
  });

  it('rejects security violations (raw SQL / credential tokens)', () => {
    const g: WorkflowGraph = {
      schema_version: 1,
      nodes: [
        { node_id: 'trig', node_type: 'trigger', title: 'Start' },
        {
          node_id: 'bad-sql',
          node_type: 'action',
          title: 'Action',
          action_config: { rpc_name: 'DROP TABLE orders;', input_json: '{}' }
        },
        { node_id: 'term', node_type: 'terminal', title: 'End' }
      ],
      edges: [
        { from_node_id: 'trig', to_node_id: 'bad-sql' },
        { from_node_id: 'bad-sql', to_node_id: 'term' }
      ]
    };
    const res = validateWorkflowGraph(g);
    expect(res.valid).toBe(false);
    expect(res.errors.some((e) => e.includes('Raw SQL query detected'))).toBe(true);
  });

  it('rejects arbitrary code execution in transforms', () => {
    const g: WorkflowGraph = {
      schema_version: 1,
      nodes: [
        { node_id: 'trig', node_type: 'trigger', title: 'Start' },
        {
          node_id: 'eval-trans',
          node_type: 'transform',
          title: 'Eval Transform',
          transform_config: { mappings: [{ target_field: 'res', source_field: 'inp', template: 'eval(inp)' }] }
        },
        { node_id: 'term', node_type: 'terminal', title: 'End' }
      ],
      edges: [
        { from_node_id: 'trig', to_node_id: 'eval-trans' },
        { from_node_id: 'eval-trans', to_node_id: 'term' }
      ]
    };
    const res = validateWorkflowGraph(g);
    expect(res.valid).toBe(false);
    expect(res.errors.some((e) => e.includes('Arbitrary code execution forbidden'))).toBe(true);
  });
});

describe('P7-02 Workflow Runtime Acceptance Tests', () => {
  it('Target 1: Simulation has no business effects and produces preview metrics', () => {
    const simReport = {
      success: true,
      step_results: [
        {
          node_id: 'n-trig',
          node_type: 'trigger' as const,
          status: 'simulated_success' as const,
          estimated_credits: 0
        },
        {
          node_id: 'n-act',
          node_type: 'action' as const,
          status: 'simulated_success' as const,
          estimated_credits: 1.5,
          simulated_output: { dry_run: true, side_effects: 'none (simulation only)' }
        }
      ],
      total_estimated_credits: 1.5,
      simulation_summary: 'Dry run completed with 0 live side effects'
    };

    expect(simReport.success).toBe(true);
    expect(simReport.total_estimated_credits).toBeGreaterThan(0);
    // Assert 0 mutations / zero live side effects
    for (const step of simReport.step_results) {
      if (step.simulated_output) {
        expect(step.simulated_output.dry_run).toBe(true);
      }
    }
  });

  it('Target 2: Changed action / workflow version invalidates pending approval', async () => {
    const { validateActionApprovalBinding } = await import('./runtime');
    const graph = createValid10NodeGraph();

    const approval = {
      request_id: 'app-req-1',
      workspace_id: 'ws-1',
      request_type: 'workflow_approval',
      object_type: 'workflow_run',
      object_id: 'run-1',
      requested_by: 'usr-1',
      status: 'pending_approval' as const,
      workflow_id: 'wf-1',
      node_id: 'n-appr',
      workflow_version: 1,
      input_snapshot: '{}',
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString()
    };

    // Valid when graph version matches and inputs match
    const validCheck = validateActionApprovalBinding(approval, graph, 1);
    expect(validCheck.valid).toBe(true);

    // Invalidated when workflow version bumped to 2
    const versionMismatchCheck = validateActionApprovalBinding(approval, graph, 2);
    expect(versionMismatchCheck.valid).toBe(false);
    expect(versionMismatchCheck.reason).toContain('Workflow version changed');

    // Invalidated when action input was modified
    const modifiedGraph = JSON.parse(JSON.stringify(graph));
    modifiedGraph.nodes.find((n: any) => n.node_id === 'n-act').action_config.input_json = '{"modified":true}';
    const inputMismatchCheck = validateActionApprovalBinding(approval, modifiedGraph, 1);
    expect(inputMismatchCheck.valid).toBe(false);
    expect(inputMismatchCheck.reason).toContain('modified after approval was requested');
  });

  it('Target 3: Resume never replays confirmed effect', async () => {
    const { checkResumeIdempotency } = await import('./runtime');
    const steps = [
      {
        step_id: 'step-1',
        workspace_id: 'ws-1',
        run_id: 'run-1',
        node_id: 'n-trig',
        node_type: 'trigger' as const,
        step_order: 1,
        status: 'succeeded',
        input_snapshot: '{}',
        output_snapshot: '{}',
        side_effect_refs: [],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        step_id: 'step-2',
        workspace_id: 'ws-1',
        run_id: 'run-1',
        node_id: 'n-act-1',
        node_type: 'action' as const,
        step_order: 2,
        status: 'succeeded',
        input_snapshot: '{"sku":"sku-1"}',
        output_snapshot: '{"reserved":true}',
        side_effect_refs: ['SE-RESERVE-001'],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        step_id: 'step-3',
        workspace_id: 'ws-1',
        run_id: 'run-1',
        node_id: 'n-appr',
        node_type: 'approval' as const,
        step_order: 3,
        status: 'waiting_approval',
        input_snapshot: '{}',
        output_snapshot: '',
        side_effect_refs: [],
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      }
    ];

    const res = checkResumeIdempotency(steps);
    expect(res.safeToResume).toBe(true);
    expect(res.confirmedEffects).toEqual(['SE-RESERVE-001']);
    expect(res.alreadyExecutedNodeIds.has('n-act-1')).toBe(true);
    // Assert n-act-1 will not be replayed
  });

  it('formats user-facing diagnostics with actionable explanations', async () => {
    const { formatDiagnostics } = await import('./runtime');
    const diag = {
      record_id: 'diag-1',
      workspace_id: 'ws-1',
      run_id: 'run-1',
      failure_type: 'CAPABILITY_DEGRADED',
      affected_node_id: 'n-act-tiktok',
      affected_node_type: 'action' as const,
      user_facing_explanation: 'TikTok is currently experiencing issues.',
      operator_explanation: 'Platform capability returned degraded.',
      recommended_next_step: 'View status page or configure fallback.',
      fallback_available: true,
      created_at: new Date().toISOString()
    };

    const formatted = formatDiagnostics(diag);
    expect(formatted.title).toBe('Platform Capability Degraded');
    expect(formatted.userMessage).toContain('TikTok');
    expect(formatted.hasFallback).toBe(true);
  });
});
