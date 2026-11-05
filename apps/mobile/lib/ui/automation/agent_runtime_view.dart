import 'package:flutter/material.dart';
import '../../automation/agent_models.dart';

/// Screen: Mobile — AI Agent Runtime & Video Studio Orchestration
/// Canonical references: docs/02_features/automation/recipe_agent_center.md,
/// docs/02_features/production/ai_video_studio.md, docs/02_features/platform/copilot.md.
class AgentRuntimeView extends StatefulWidget {
  final MobileAgentRun initialRun;
  final String callerRole;
  final double initialBalance;
  final void Function(MobileAgentRun updatedRun)? onRunUpdated;
  final bool isLiveExecutionMode;
  final Future<MobileStepExecutionResult> Function(
    MobileAgentRun run,
    int stepIndex,
    String callerRole,
    double availableBalance,
  )? onExecuteStepRemote;

  const AgentRuntimeView({
    super.key,
    required this.initialRun,
    this.callerRole = 'editor',
    this.initialBalance = 150.0,
    this.onRunUpdated,
    this.isLiveExecutionMode = false,
    this.onExecuteStepRemote,
  });

  @override
  State<AgentRuntimeView> createState() => _AgentRuntimeViewState();
}

class _AgentRuntimeViewState extends State<AgentRuntimeView> {
  late MobileAgentRun _run;
  late double _balance;
  late String _role;
  String? _statusMessage;
  bool _isAutoRunning = false;

  @override
  void initState() {
    super.initState();
    _run = widget.initialRun;
    _balance = widget.initialBalance;
    _role = widget.callerRole;
  }

  Future<void> _executeStep(int index) async {
    if (widget.isLiveExecutionMode && widget.onExecuteStepRemote == null) {
      setState(() {
        _isAutoRunning = false;
        _statusMessage =
            'Dịch vụ AI Agent Runtime chưa được kết nối (fail-closed). Hệ thống không tự động trừ credits hoặc tạo kết quả giả lập.';
      });
      return;
    }

    final MobileStepExecutionResult res;
    if (widget.onExecuteStepRemote != null) {
      res = await widget.onExecuteStepRemote!(
        _run,
        index,
        _role,
        _balance,
      );
    } else {
      res = _run.executeStep(
        stepIndex: index,
        callerRole: _role,
        availableBalance: _balance,
      );
    }

    if (!mounted) return;
    setState(() {
      _run = res.run;
      if (res.success) {
        _balance -= _run.steps[index].estimatedCredits;
        _statusMessage = 'Đã hoàn thành bước ${index + 1}: ${_run.steps[index].title}';
      } else {
        _isAutoRunning = false;
        _statusMessage = res.pausedReason ?? res.error ?? 'Thao tác không thành công';
      }
    });

    widget.onRunUpdated?.call(_run);
  }

  void _runAllSteps() {
    setState(() {
      _isAutoRunning = true;
    });
    _runNextStepRecursive();
  }

  Future<void> _runNextStepRecursive() async {
    if (!_isAutoRunning) return;

    final nextIndex = _run.steps.indexWhere(
      (s) =>
          s.status == MobileAgentStepStatus.planning ||
          s.status == MobileAgentStepStatus.executing,
    );

    if (nextIndex == -1) {
      setState(() {
        _isAutoRunning = false;
        _statusMessage = '🎉 Pipeline đã hoàn tất thành công!';
      });
      return;
    }

    await _executeStep(nextIndex);
    if (!mounted) return;

    if (_run.currentState == MobileAgentRunState.executing && _isAutoRunning) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _isAutoRunning) {
          _runNextStepRecursive();
        }
      });
    } else {
      setState(() {
        _isAutoRunning = false;
      });
    }
  }

  void _simulateFailure(int stepIndex) {
    setState(() {
      _isAutoRunning = false;
      _run = _run.recordPartialFailureHandoff(
        failedStepIndex: stepIndex,
        errorReason: 'GPU worker timeout: Render node unreachable',
        targetUserId: 'usr-ops-lead-01',
      );
      _statusMessage = '🚨 Đã kích hoạt Handoff có kiểm toán. Diagnostics: ${_run.diagnosticsRef}';
    });
    widget.onRunUpdated?.call(_run);
  }

  void _approveHighRisk() {
    setState(() {
      _run = _run.approveRun('manager');
      _statusMessage = '🛡️ Quản lý đã phê duyệt bước rủi ro cao. Có thể tiếp tục thực thi.';
    });
    widget.onRunUpdated?.call(_run);
  }

  void _increaseCeiling() {
    setState(() {
      _run = _run.increaseCeiling(50.0);
      _statusMessage = '💳 Đã nâng hạn mức ngân sách lên ${_run.budgetCeiling} credits.';
    });
    widget.onRunUpdated?.call(_run);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤖 AI Agent Studio'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_balance.toStringAsFixed(1)} cr',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header summary card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _run.agentType == MobileAgentType.videoAgent
                            ? 'AI Video Agent (M07)'
                            : 'Copilot Action',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStateColor(_run.currentState).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _run.currentState.toDisplayString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getStateColor(_run.currentState),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _run.planSummary,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tiêu thụ: ${_run.creditsUsed.toStringAsFixed(1)} / ${_run.budgetCeiling.toStringAsFixed(1)} cr',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Bộ nhớ: ${_run.memory.totalBytes}/${_run.memory.maxBytes} b',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Status Banner
          if (_statusMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _statusMessage!,
                style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
              ),
            ),

          // Acceptance Target 2 Alert: Budget Ceiling Pause
          if (_run.currentState == MobileAgentRunState.waitingContext)
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.pause_circle_filled, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Tạm dừng vì chạm hạn mức tín dụng (Target 2)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Không đủ ngân sách để tiếp tục bước kế tiếp mà không vượt hạn mức. Hệ thống dừng lại an toàn.',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _increaseCeiling,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Text('+ Tăng 50 credits & Tiếp tục'),
                  ),
                ],
              ),
            ),

          // Acceptance Target 1 Alert: High Risk Approval Required
          if (_run.currentState == MobileAgentRunState.awaitingApproval)
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.security, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Thao tác rủi ro cao yêu cầu phê duyệt (Target 1)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Bước xuất bản trực tiếp lên kênh cần xác nhận từ Manager trước khi kích hoạt.',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _approveHighRisk,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('✓ Quản lý Phê duyệt'),
                  ),
                ],
              ),
            ),

          // Acceptance Target 3 Alert: Audited Handoff on Partial Failure
          if (_run.currentState == MobileAgentRunState.handedOff ||
              _run.currentState == MobileAgentRunState.partiallyCompleted)
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                border: Border.all(color: Colors.purple.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.assignment_late, color: Colors.purple, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Bàn giao sự cố có kiểm toán (Target 3)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Lý do: ${_run.handoffContext?.reason ?? ""}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    _run.handoffContext?.summaryOfCompletedWork ?? '',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Mã kiểm toán: ${_run.handoffContext?.auditRef ?? ""}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '📦 Bảo tồn ${_run.outputs.length} outputs thành phẩm',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                  )
                ],
              ),
            ),

          // Pipeline Steps Header & Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Các giai đoạn thực thi (6 Stages)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              if (_run.currentState != MobileAgentRunState.completed)
                ElevatedButton.icon(
                  onPressed: _isAutoRunning ? null : _runAllSteps,
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: Text(_isAutoRunning ? 'Đang chạy...' : 'Chạy tất cả'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Step List
          ...List.generate(_run.steps.length, (idx) {
            final step = _run.steps[idx];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: _getStepStatusBg(step.status),
                  child: _getStepStatusIcon(step.status),
                ),
                title: Text(
                  '${step.stepOrder}. ${step.title}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.expectedOutcome,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                    if (step.observedOutcome != null)
                      Text(
                        '👉 ${step.observedOutcome}',
                        style: TextStyle(fontSize: 11, color: Colors.green.shade800),
                      ),
                    Row(
                      children: [
                        Text(
                          '${step.estimatedCredits.toStringAsFixed(0)} cr',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Quyền: ${step.requiredPermission}',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: step.status == MobileAgentStepStatus.planning
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.play_arrow, color: Colors.indigo, size: 20),
                            onPressed: () => _executeStep(idx),
                            tooltip: 'Chạy bước này',
                          ),
                          IconButton(
                            icon: const Icon(Icons.bug_report, color: Colors.red, size: 20),
                            onPressed: () => _simulateFailure(idx),
                            tooltip: 'Mô phỏng lỗi',
                          ),
                        ],
                      )
                    : null,
              ),
            );
          }),

          const SizedBox(height: 16),

          // Outputs section if any
          if (_run.outputs.isNotEmpty) ...[
            const Text(
              '📦 Sản phẩm thành phẩm (Outputs)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ..._run.outputs.map((out) => Card(
                  color: Colors.green.shade50,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(out.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: Text(out.summary, style: const TextStyle(fontSize: 11)),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Color _getStateColor(MobileAgentRunState state) {
    switch (state) {
      case MobileAgentRunState.completed:
        return Colors.green;
      case MobileAgentRunState.executing:
        return Colors.blue;
      case MobileAgentRunState.awaitingApproval:
      case MobileAgentRunState.waitingContext:
        return Colors.amber.shade800;
      case MobileAgentRunState.handedOff:
        return Colors.purple;
      case MobileAgentRunState.failed:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getStepStatusBg(MobileAgentStepStatus status) {
    switch (status) {
      case MobileAgentStepStatus.completed:
        return Colors.green.shade100;
      case MobileAgentStepStatus.executing:
        return Colors.blue.shade100;
      case MobileAgentStepStatus.failed:
        return Colors.red.shade100;
      case MobileAgentStepStatus.awaitingApproval:
      case MobileAgentStepStatus.waitingContext:
        return Colors.amber.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Widget _getStepStatusIcon(MobileAgentStepStatus status) {
    switch (status) {
      case MobileAgentStepStatus.completed:
        return const Icon(Icons.check, size: 16, color: Colors.green);
      case MobileAgentStepStatus.executing:
        return const Icon(Icons.refresh, size: 16, color: Colors.blue);
      case MobileAgentStepStatus.failed:
        return const Icon(Icons.close, size: 16, color: Colors.red);
      case MobileAgentStepStatus.awaitingApproval:
      case MobileAgentStepStatus.waitingContext:
        return const Icon(Icons.pause, size: 16, color: Colors.amber);
      default:
        return const Icon(Icons.hourglass_empty, size: 16, color: Colors.grey);
    }
  }
}
