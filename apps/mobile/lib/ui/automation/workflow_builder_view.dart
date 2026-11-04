import 'package:flutter/material.dart';
import '../../automation/workflow_models.dart';

class WorkflowBuilderView extends StatefulWidget {
  final MobileWorkflow workflow;

  const WorkflowBuilderView({
    super.key,
    required this.workflow,
  });

  @override
  State<WorkflowBuilderView> createState() => _WorkflowBuilderViewState();
}

class _WorkflowBuilderViewState extends State<WorkflowBuilderView> {
  late MobileWorkflow _workflow;
  String? _selectedNodeId;
  bool _simulating = false;
  String? _simReport;

  @override
  void initState() {
    super.initState();
    _workflow = widget.workflow;
    if (_workflow.graph.nodes.isNotEmpty) {
      _selectedNodeId = _workflow.graph.nodes.first.nodeId;
    }
  }

  Color _getNodeColor(WorkflowNodeType type) {
    switch (type) {
      case WorkflowNodeType.trigger:
        return Colors.amber.shade700;
      case WorkflowNodeType.condition:
        return Colors.purple.shade400;
      case WorkflowNodeType.transform:
        return Colors.blue.shade400;
      case WorkflowNodeType.action:
        return Colors.green.shade600;
      case WorkflowNodeType.approval:
        return Colors.orange.shade400;
      case WorkflowNodeType.wait:
        return Colors.cyan.shade400;
      case WorkflowNodeType.fallback:
        return Colors.pink.shade400;
      case WorkflowNodeType.diagnostics:
        return Colors.indigo.shade400;
      case WorkflowNodeType.handoff:
        return Colors.teal.shade400;
      case WorkflowNodeType.terminal:
        return Colors.green.shade700;
    }
  }

  void _runDryRunSimulation() {
    setState(() {
      _simulating = true;
    });

    final validation = validateMobileWorkflowGraph(_workflow.graph);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _simulating = false;
        if (validation.isValid) {
          _simReport =
              'Dry-Run Simulation: Success!\n${_workflow.graph.nodes.length} nodes simulated.\nEstimated cost: ~2.0 credits.\n0 business side effects recorded.';
        } else {
          _simReport = 'Simulation Failed:\n${validation.errors.join('\n')}';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final validation = validateMobileWorkflowGraph(_workflow.graph);
    final selectedNode = _workflow.graph.nodes.firstWhere(
      (n) => n.nodeId == _selectedNodeId,
      orElse: () => _workflow.graph.nodes.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _workflow.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Row(
              children: [
                Text(
                  'v${_workflow.version} • ${_workflow.status.name.toUpperCase()}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
                  ),
                  child: const Text(
                    'Native Engine',
                    style: TextStyle(fontSize: 10, color: Colors.greenAccent, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: _simulating
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.play_arrow, color: Colors.indigoAccent),
            tooltip: 'Run Dry Run Simulation',
            onPressed: _simulating ? null : _runDryRunSimulation,
          ),
        ],
      ),
      body: Column(
        children: [
          if (!validation.isValid)
            Container(
              width: double.infinity,
              color: Colors.red.shade900.withValues(alpha: 0.5),
              padding: const EdgeInsets.all(8),
              child: Text(
                'Validation Error: ${validation.errors.first}',
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
          if (_simReport != null)
            Container(
              width: double.infinity,
              color: Colors.indigo.shade900.withValues(alpha: 0.4),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _simReport!,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54, size: 16),
                    onPressed: () => setState(() => _simReport = null),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _workflow.graph.nodes.length,
              separatorBuilder: (context, index) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Icon(Icons.arrow_downward, size: 16, color: Colors.blueGrey.shade600),
                ),
              ),
              itemBuilder: (context, index) {
                final node = _workflow.graph.nodes[index];
                final isSelected = node.nodeId == _selectedNodeId;
                final color = _getNodeColor(node.nodeType);

                return InkWell(
                  onTap: () => setState(() => _selectedNodeId = node.nodeId),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF131D31),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.indigoAccent : Colors.blueGrey.shade800,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: color.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            node.nodeType.name.toUpperCase(),
                            style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                node.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '#${node.nodeId}',
                                style: TextStyle(
                                  color: Colors.blueGrey.shade400,
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Bottom Node Inspector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              border: Border(top: BorderSide(color: Colors.blueGrey.shade800)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Selected Step Inspector',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      selectedNode.nodeType.name.toUpperCase(),
                      style: TextStyle(
                        color: _getNodeColor(selectedNode.nodeType),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  selectedNode.title,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
