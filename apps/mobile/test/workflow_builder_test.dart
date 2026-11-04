import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/automation/workflow_models.dart';

MobileWorkflowGraph buildTest10NodeGraph() {
  return MobileWorkflowGraph(
    schemaVersion: 1,
    nodes: [
      const MobileWorkflowNode(
        nodeId: 'n-trig',
        nodeType: WorkflowNodeType.trigger,
        title: 'Order Created Trigger',
        config: {'type': 'event', 'event_type': 'order.created'},
      ),
      const MobileWorkflowNode(
        nodeId: 'n-cond',
        nodeType: WorkflowNodeType.condition,
        title: 'VIP Condition Check',
        config: {'field': 'customer.is_vip', 'operator': 'eq', 'value_json': 'true'},
      ),
      const MobileWorkflowNode(
        nodeId: 'n-trans',
        nodeType: WorkflowNodeType.transform,
        title: 'Transform Payload',
        config: {'mappings': [{'target_field': 'tier', 'source_field': 'customer.tier'}]},
      ),
      const MobileWorkflowNode(
        nodeId: 'n-act',
        nodeType: WorkflowNodeType.action,
        title: 'Reserve Inventory RPC',
        config: {'rpc_name': 'creativanta.commerce.v1.InventoryService/ReserveStock'},
      ),
      const MobileWorkflowNode(
        nodeId: 'n-appr',
        nodeType: WorkflowNodeType.approval,
        title: 'Manager Approval Gate',
        config: {'approver_ids': ['usr-1'], 'required_approvals': 1},
      ),
      const MobileWorkflowNode(
        nodeId: 'n-wait',
        nodeType: WorkflowNodeType.wait,
        title: 'Wait 5 Minutes',
        config: {'wait_type': 'duration', 'duration_seconds': 300},
      ),
      const MobileWorkflowNode(
        nodeId: 'n-diag',
        nodeType: WorkflowNodeType.diagnostics,
        title: 'Diagnostic Logging',
        config: {'severity': 'info', 'user_message': 'Step verified'},
      ),
      const MobileWorkflowNode(
        nodeId: 'n-fall',
        nodeType: WorkflowNodeType.fallback,
        title: 'Fallback Route',
        config: {'fallback_node_id': 'n-term', 'reason_template': 'Non-VIP route'},
      ),
      const MobileWorkflowNode(
        nodeId: 'n-hand',
        nodeType: WorkflowNodeType.handoff,
        title: 'Support Handoff',
        config: {'target_user_id': 'usr-agent-1'},
      ),
      const MobileWorkflowNode(
        nodeId: 'n-term',
        nodeType: WorkflowNodeType.terminal,
        title: 'Completion Terminal',
        config: {'outcome': 'succeeded'},
      ),
    ],
    edges: [
      const MobileWorkflowEdge(fromNodeId: 'n-trig', toNodeId: 'n-cond'),
      const MobileWorkflowEdge(fromNodeId: 'n-cond', toNodeId: 'n-trans', branch: WorkflowEdgeBranch.isTrue),
      const MobileWorkflowEdge(fromNodeId: 'n-cond', toNodeId: 'n-fall', branch: WorkflowEdgeBranch.isFalse),
      const MobileWorkflowEdge(fromNodeId: 'n-trans', toNodeId: 'n-act'),
      const MobileWorkflowEdge(fromNodeId: 'n-act', toNodeId: 'n-appr'),
      const MobileWorkflowEdge(fromNodeId: 'n-appr', toNodeId: 'n-wait'),
      const MobileWorkflowEdge(fromNodeId: 'n-wait', toNodeId: 'n-diag'),
      const MobileWorkflowEdge(fromNodeId: 'n-diag', toNodeId: 'n-hand'),
      const MobileWorkflowEdge(fromNodeId: 'n-hand', toNodeId: 'n-term'),
      const MobileWorkflowEdge(fromNodeId: 'n-fall', toNodeId: 'n-term'),
    ],
  );
}

void main() {
  group('Mobile Workflow Validation & Graph Model', () {
    test('accepts valid 10-node graph', () {
      final g = buildTest10NodeGraph();
      final res = validateMobileWorkflowGraph(g);
      expect(res.isValid, isTrue);
      expect(res.errors, isEmpty);
    });

    test('rejects self-loop', () {
      const g = MobileWorkflowGraph(
        schemaVersion: 1,
        nodes: [
          MobileWorkflowNode(nodeId: 'trig', nodeType: WorkflowNodeType.trigger, title: 'Start'),
          MobileWorkflowNode(nodeId: 'term', nodeType: WorkflowNodeType.terminal, title: 'End'),
        ],
        edges: [
          MobileWorkflowEdge(fromNodeId: 'trig', toNodeId: 'term'),
          MobileWorkflowEdge(fromNodeId: 'term', toNodeId: 'term'), // Self-loop!
        ],
      );
      final res = validateMobileWorkflowGraph(g);
      expect(res.isValid, isFalse);
      expect(res.errors.any((e) => e.contains('Self-loop detected')), isTrue);
    });

    test('rejects 2-node cycle', () {
      const g = MobileWorkflowGraph(
        schemaVersion: 1,
        nodes: [
          MobileWorkflowNode(nodeId: 'trig', nodeType: WorkflowNodeType.trigger, title: 'Start'),
          MobileWorkflowNode(nodeId: 'n1', nodeType: WorkflowNodeType.action, title: 'Action 1'),
          MobileWorkflowNode(nodeId: 'n2', nodeType: WorkflowNodeType.transform, title: 'Transform 2'),
          MobileWorkflowNode(nodeId: 'term', nodeType: WorkflowNodeType.terminal, title: 'End'),
        ],
        edges: [
          MobileWorkflowEdge(fromNodeId: 'trig', toNodeId: 'n1'),
          MobileWorkflowEdge(fromNodeId: 'n1', toNodeId: 'n2'),
          MobileWorkflowEdge(fromNodeId: 'n2', toNodeId: 'n1'), // Cycle n1 <-> n2
          MobileWorkflowEdge(fromNodeId: 'n2', toNodeId: 'term'),
        ],
      );
      final res = validateMobileWorkflowGraph(g);
      expect(res.isValid, isFalse);
      expect(res.errors.any((e) => e.contains('Cycle detected')), isTrue);
    });

    test('rejects unbounded node count (>100)', () {
      final nodes = <MobileWorkflowNode>[
        const MobileWorkflowNode(nodeId: 'node-0', nodeType: WorkflowNodeType.trigger, title: 'Start'),
      ];
      final edges = <MobileWorkflowEdge>[];

      for (int i = 1; i <= 101; i++) {
        nodes.add(MobileWorkflowNode(
          nodeId: 'node-$i',
          nodeType: WorkflowNodeType.transform,
          title: 'Transform $i',
        ));
        edges.add(MobileWorkflowEdge(fromNodeId: 'node-${i - 1}', toNodeId: 'node-$i'));
      }
      nodes.add(const MobileWorkflowNode(nodeId: 'node-102', nodeType: WorkflowNodeType.terminal, title: 'End'));
      edges.add(const MobileWorkflowEdge(fromNodeId: 'node-101', toNodeId: 'node-102'));

      final g = MobileWorkflowGraph(schemaVersion: 1, nodes: nodes, edges: edges);
      final res = validateMobileWorkflowGraph(g);
      expect(res.isValid, isFalse);
      expect(res.errors.any((e) => e.contains('exceeds maximum allowed limit (100)')), isTrue);
    });

    test('round-trip JSON serialization preserves all 10 node types', () {
      final g = buildTest10NodeGraph();
      final json = g.toJson();
      final restored = MobileWorkflowGraph.fromJson(json);

      expect(restored.schemaVersion, equals(1));
      expect(restored.nodes.length, equals(10));
      expect(restored.edges.length, equals(10));

      final types = restored.nodes.map((n) => n.nodeType).toSet();
      expect(types.length, equals(10));
      expect(types.contains(WorkflowNodeType.trigger), isTrue);
      expect(types.contains(WorkflowNodeType.condition), isTrue);
      expect(types.contains(WorkflowNodeType.transform), isTrue);
      expect(types.contains(WorkflowNodeType.action), isTrue);
      expect(types.contains(WorkflowNodeType.approval), isTrue);
      expect(types.contains(WorkflowNodeType.wait), isTrue);
      expect(types.contains(WorkflowNodeType.fallback), isTrue);
      expect(types.contains(WorkflowNodeType.diagnostics), isTrue);
      expect(types.contains(WorkflowNodeType.handoff), isTrue);
      expect(types.contains(WorkflowNodeType.terminal), isTrue);
    });
  });
}
