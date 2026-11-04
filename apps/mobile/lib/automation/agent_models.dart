/// Creativanta P7-04 Automation Agent Runtime, Video Agent & Copilot Actions Models.
/// Canonical references: docs/02_features/automation/recipe_agent_center.md,
/// docs/02_features/production/ai_video_studio.md, docs/02_features/platform/copilot.md,
/// and database_schema.md §12.4, §12.4A, §12.4B.
library;

import 'dart:convert';

enum MobileAgentRunState {
  unspecified,
  planning,
  awaitingApproval,
  executing,
  waitingContext,
  completed,
  partiallyCompleted,
  failed,
  handedOff,
  cancelled;

  static MobileAgentRunState fromString(String raw) {
    switch (raw.toLowerCase().replaceAll('-', '_')) {
      case 'planning':
        return MobileAgentRunState.planning;
      case 'awaiting_approval':
        return MobileAgentRunState.awaitingApproval;
      case 'executing':
        return MobileAgentRunState.executing;
      case 'waiting_context':
        return MobileAgentRunState.waitingContext;
      case 'completed':
        return MobileAgentRunState.completed;
      case 'partially_completed':
        return MobileAgentRunState.partiallyCompleted;
      case 'failed':
        return MobileAgentRunState.failed;
      case 'handed_off':
        return MobileAgentRunState.handedOff;
      case 'cancelled':
        return MobileAgentRunState.cancelled;
      default:
        return MobileAgentRunState.unspecified;
    }
  }

  String toDisplayString() {
    switch (this) {
      case MobileAgentRunState.planning:
        return 'Lập kế hoạch';
      case MobileAgentRunState.awaitingApproval:
        return 'Chờ phê duyệt';
      case MobileAgentRunState.executing:
        return 'Đang thực thi';
      case MobileAgentRunState.waitingContext:
        return 'Tạm dừng ngân sách';
      case MobileAgentRunState.completed:
        return 'Hoàn thành';
      case MobileAgentRunState.partiallyCompleted:
        return 'Hoàn thành một phần';
      case MobileAgentRunState.failed:
        return 'Thất bại';
      case MobileAgentRunState.handedOff:
        return 'Đã bàn giao sự cố';
      case MobileAgentRunState.cancelled:
        return 'Đã hủy';
      case MobileAgentRunState.unspecified:
        return 'Không xác định';
    }
  }
}

enum MobileAgentStepStatus {
  planning,
  awaitingApproval,
  executing,
  waitingContext,
  completed,
  failed,
  skipped,
  cancelled;

  static MobileAgentStepStatus fromString(String raw) {
    switch (raw.toLowerCase().replaceAll('-', '_')) {
      case 'awaiting_approval':
        return MobileAgentStepStatus.awaitingApproval;
      case 'executing':
        return MobileAgentStepStatus.executing;
      case 'waiting_context':
        return MobileAgentStepStatus.waitingContext;
      case 'completed':
        return MobileAgentStepStatus.completed;
      case 'failed':
        return MobileAgentStepStatus.failed;
      case 'skipped':
        return MobileAgentStepStatus.skipped;
      case 'cancelled':
        return MobileAgentStepStatus.cancelled;
      case 'planning':
      default:
        return MobileAgentStepStatus.planning;
    }
  }
}

enum MobileAgentOutputType {
  text,
  asset,
  dataset,
  workflowPatch,
  recommendation,
  report,
  video;

  static MobileAgentOutputType fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'asset':
        return MobileAgentOutputType.asset;
      case 'dataset':
        return MobileAgentOutputType.dataset;
      case 'workflow_patch':
        return MobileAgentOutputType.workflowPatch;
      case 'recommendation':
        return MobileAgentOutputType.recommendation;
      case 'report':
        return MobileAgentOutputType.report;
      case 'video':
        return MobileAgentOutputType.video;
      case 'text':
      default:
        return MobileAgentOutputType.text;
    }
  }
}

enum MobileAgentType {
  generic,
  videoAgent,
  copilotAction,
  contentOptimizer;

  static MobileAgentType fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'video_agent':
        return MobileAgentType.videoAgent;
      case 'copilot_action':
        return MobileAgentType.copilotAction;
      case 'content_optimizer':
        return MobileAgentType.contentOptimizer;
      case 'generic':
      default:
        return MobileAgentType.generic;
    }
  }
}

class MobileAgentMemoryEntry {
  final String key;
  final String value;
  final int byteSize;
  final DateTime observedAt;

  const MobileAgentMemoryEntry({
    required this.key,
    required this.value,
    required this.byteSize,
    required this.observedAt,
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
        'byte_size': byteSize,
        'observed_at': observedAt.toIso8601String(),
      };
}

class MobileAgentMemory {
  final int totalBytes;
  final int maxBytes;
  final bool isCompressed;
  final List<MobileAgentMemoryEntry> entries;
  final String summary;

  const MobileAgentMemory({
    this.totalBytes = 0,
    this.maxBytes = 50000,
    this.isCompressed = false,
    this.entries = const [],
    this.summary = '',
  });

  MobileAgentMemory append(String key, String value) {
    final updatedEntries = List<MobileAgentMemoryEntry>.from(entries);
    var currentSummary = summary;
    var compressed = isCompressed;

    final rawEntryBytes = utf8.encode('$key:$value').length;
    var projectedBytes = totalBytes + rawEntryBytes;

    // Compress when reaching 80% capacity
    if (projectedBytes > maxBytes * 0.8) {
      compressed = true;
      currentSummary =
          '[Compressed memory: ${updatedEntries.length} previous observations summarized]';
      while (updatedEntries.length > 1 && projectedBytes > maxBytes * 0.5) {
        final removed = updatedEntries.removeAt(0);
        projectedBytes -= removed.byteSize;
      }
    }

    final currentTotal = updatedEntries.fold<int>(0, (sum, e) => sum + e.byteSize);
    final keyBytes = utf8.encode(key).length + 1; // plus separator
    final maxAllowedValBytes = maxBytes - currentTotal - keyBytes;

    var finalValue = value;
    final valBytesList = utf8.encode(value);
    if (maxAllowedValBytes <= 0) {
      finalValue = '';
    } else if (valBytesList.length > maxAllowedValBytes) {
      const suffix = '...[truncated]';
      final suffixBytes = utf8.encode(suffix).length;
      if (maxAllowedValBytes > suffixBytes) {
        final sliced = valBytesList.sublist(0, maxAllowedValBytes - suffixBytes);
        finalValue = '${utf8.decode(sliced, allowMalformed: true)}$suffix';
      } else {
        finalValue = suffix.substring(0, maxAllowedValBytes);
      }
    }

    final finalBytes = utf8.encode('$key:$finalValue').length;
    updatedEntries.add(MobileAgentMemoryEntry(
      key: key,
      value: finalValue,
      byteSize: finalBytes,
      observedAt: DateTime.now().toUtc(),
    ));

    final total = updatedEntries.fold<int>(0, (sum, e) => sum + e.byteSize);
    return MobileAgentMemory(
      totalBytes: total,
      maxBytes: maxBytes,
      isCompressed: compressed,
      entries: updatedEntries,
      summary: currentSummary,
    );
  }
}

class MobileAgentStep {
  final String stepId;
  final String agentRunId;
  final int stepOrder;
  final String phase;
  final String title;
  final MobileAgentStepStatus status;
  final String expectedOutcome;
  final String? observedOutcome;
  final String requiredPermission;
  final String? requiredCapability;
  final bool isHighRisk;
  final double estimatedCredits;
  final double actualCredits;
  final String? diagnosticsRef;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const MobileAgentStep({
    required this.stepId,
    required this.agentRunId,
    required this.stepOrder,
    required this.phase,
    required this.title,
    required this.status,
    required this.expectedOutcome,
    this.observedOutcome,
    required this.requiredPermission,
    this.requiredCapability,
    this.isHighRisk = false,
    required this.estimatedCredits,
    this.actualCredits = 0.0,
    this.diagnosticsRef,
    this.startedAt,
    this.completedAt,
  });

  MobileAgentStep copyWith({
    MobileAgentStepStatus? status,
    String? observedOutcome,
    double? actualCredits,
    String? diagnosticsRef,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return MobileAgentStep(
      stepId: stepId,
      agentRunId: agentRunId,
      stepOrder: stepOrder,
      phase: phase,
      title: title,
      status: status ?? this.status,
      expectedOutcome: expectedOutcome,
      observedOutcome: observedOutcome ?? this.observedOutcome,
      requiredPermission: requiredPermission,
      requiredCapability: requiredCapability,
      isHighRisk: isHighRisk,
      estimatedCredits: estimatedCredits,
      actualCredits: actualCredits ?? this.actualCredits,
      diagnosticsRef: diagnosticsRef ?? this.diagnosticsRef,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class MobileAgentOutput {
  final String outputId;
  final String agentRunId;
  final MobileAgentOutputType outputType;
  final String title;
  final String summary;
  final List<String> objectRefs;
  final List<String> downloadableRefs;
  final String approvalState;
  final DateTime createdAt;

  const MobileAgentOutput({
    required this.outputId,
    required this.agentRunId,
    required this.outputType,
    required this.title,
    required this.summary,
    required this.objectRefs,
    this.downloadableRefs = const [],
    this.approvalState = 'approved',
    required this.createdAt,
  });
}

class MobileAgentHandoffContext {
  final String handoffTargetUserId;
  final String reason;
  final String summaryOfCompletedWork;
  final List<String> unresolvedActions;
  final String diagnosticsRef;
  final String auditRef;

  const MobileAgentHandoffContext({
    required this.handoffTargetUserId,
    required this.reason,
    required this.summaryOfCompletedWork,
    required this.unresolvedActions,
    required this.diagnosticsRef,
    required this.auditRef,
  });
}

class MobileStepExecutionResult {
  final bool success;
  final MobileAgentRun run;
  final String? pausedReason;
  final String? error;

  const MobileStepExecutionResult({
    required this.success,
    required this.run,
    this.pausedReason,
    this.error,
  });
}

class MobileAgentRun {
  final String agentRunId;
  final String workspaceId;
  final MobileAgentType agentType;
  final String planSummary;
  final String approvalState; // not_required, awaiting_approval, approved, rejected
  final MobileAgentRunState currentState;
  final double creditsUsed;
  final double budgetCeiling;
  final MobileAgentMemory memory;
  final List<MobileAgentStep> steps;
  final List<MobileAgentOutput> outputs;
  final MobileAgentHandoffContext? handoffContext;
  final String? diagnosticsRef;
  final String? auditRef;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MobileAgentRun({
    required this.agentRunId,
    required this.workspaceId,
    required this.agentType,
    required this.planSummary,
    required this.approvalState,
    required this.currentState,
    required this.creditsUsed,
    required this.budgetCeiling,
    required this.memory,
    required this.steps,
    required this.outputs,
    this.handoffContext,
    this.diagnosticsRef,
    this.auditRef,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  static bool hasPermission(String role, String requiredPermission) {
    if (role == 'owner' || role == 'admin') return true;
    const rolePermissions = <String, List<String>>{
      'manager': [
        'content:write',
        'asset:generate',
        'publish:manage',
        'product:write',
        'billing:read'
      ],
      'editor': ['content:write', 'asset:generate'],
      'contributor': ['content:write'],
      'viewer': ['content:read'],
      'external': [],
    };
    final perms = rolePermissions[role] ?? [];
    return perms.contains(requiredPermission) || perms.contains('*');
  }

  /// Acceptance Target 1: Caller delegated permissions check per step.
  /// Acceptance Target 2: Budget ceiling pause without overdraft.
  MobileStepExecutionResult executeStep({
    required int stepIndex,
    required String callerRole,
    required double availableBalance,
  }) {
    if (stepIndex < 0 || stepIndex >= steps.length) {
      return MobileStepExecutionResult(
        success: false,
        run: this,
        error: 'Chỉ mục bước không hợp lệ: $stepIndex',
      );
    }

    final step = steps[stepIndex];
    final updatedSteps = List<MobileAgentStep>.from(steps);
    final updatedOutputs = List<MobileAgentOutput>.from(outputs);

    // Target 1: Permission check
    if (!hasPermission(callerRole, step.requiredPermission)) {
      final diag = 'diag-${step.stepId}-perm-denied';
      final audit = 'audit-${step.stepId}-${DateTime.now().millisecondsSinceEpoch}';
      updatedSteps[stepIndex] = step.copyWith(
        status: MobileAgentStepStatus.failed,
        observedOutcome:
            'Từ chối ủy quyền: Quyền $callerRole không có permission ${step.requiredPermission}',
        diagnosticsRef: diag,
      );
      final updatedRun = MobileAgentRun(
        agentRunId: agentRunId,
        workspaceId: workspaceId,
        agentType: agentType,
        planSummary: planSummary,
        approvalState: approvalState,
        currentState: MobileAgentRunState.failed,
        creditsUsed: creditsUsed,
        budgetCeiling: budgetCeiling,
        memory: memory,
        steps: updatedSteps,
        outputs: updatedOutputs,
        diagnosticsRef: diag,
        auditRef: audit,
        createdBy: createdBy,
        createdAt: createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
      return MobileStepExecutionResult(
        success: false,
        run: updatedRun,
        error: 'Từ chối ủy quyền: Quyền $callerRole không đủ thẩm quyền',
      );
    }

    // High risk check: pauses if not approved
    if (step.isHighRisk && approvalState != 'approved') {
      updatedSteps[stepIndex] = step.copyWith(
        status: MobileAgentStepStatus.awaitingApproval,
      );
      final updatedRun = MobileAgentRun(
        agentRunId: agentRunId,
        workspaceId: workspaceId,
        agentType: agentType,
        planSummary: planSummary,
        approvalState: 'awaiting_approval',
        currentState: MobileAgentRunState.awaitingApproval,
        creditsUsed: creditsUsed,
        budgetCeiling: budgetCeiling,
        memory: memory,
        steps: updatedSteps,
        outputs: updatedOutputs,
        createdBy: createdBy,
        createdAt: createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
      return MobileStepExecutionResult(
        success: false,
        run: updatedRun,
        pausedReason:
            'Bước ${step.stepOrder} (${step.title}) là thao tác rủi ro cao và cần phê duyệt trước khi kích hoạt.',
      );
    }

    // Target 2: Budget ceiling pause without overdraft
    final projectedTotal = creditsUsed + step.estimatedCredits;
    if (projectedTotal > budgetCeiling || projectedTotal > availableBalance) {
      updatedSteps[stepIndex] = step.copyWith(
        status: MobileAgentStepStatus.waitingContext,
      );
      final updatedRun = MobileAgentRun(
        agentRunId: agentRunId,
        workspaceId: workspaceId,
        agentType: agentType,
        planSummary: planSummary,
        approvalState: approvalState,
        currentState: MobileAgentRunState.waitingContext,
        creditsUsed: creditsUsed,
        budgetCeiling: budgetCeiling,
        memory: memory,
        steps: updatedSteps,
        outputs: updatedOutputs,
        createdBy: createdBy,
        createdAt: createdAt,
        updatedAt: DateTime.now().toUtc(),
      );
      return MobileStepExecutionResult(
        success: false,
        run: updatedRun,
        pausedReason:
            'Tạm dừng vì chạm hạn mức tín dụng: Dự kiến $projectedTotal cr > Hạn mức $budgetCeiling cr. Không trừ credits dư thừa.',
      );
    }

    // Execute successfully
    updatedSteps[stepIndex] = step.copyWith(
      status: MobileAgentStepStatus.completed,
      actualCredits: step.estimatedCredits,
      observedOutcome: 'Hoàn thành bước ${step.stepOrder}: ${step.title}',
      completedAt: DateTime.now().toUtc(),
    );

    final newCreditsUsed = creditsUsed + step.estimatedCredits;
    final updatedMemory = memory.append(
      'step_${step.stepOrder}_output',
      'Hoàn thành bước ${step.stepOrder}: ${step.title}',
    );

    if (step.phase == 'script_generation') {
      updatedOutputs.add(MobileAgentOutput(
        outputId: 'out-scr-${DateTime.now().millisecondsSinceEpoch}',
        agentRunId: agentRunId,
        outputType: MobileAgentOutputType.text,
        title: 'Bản thảo kịch bản phân đoạn',
        summary: 'Kịch bản phân đoạn đã sẵn sàng',
        objectRefs: ['script:$agentRunId'],
        createdAt: DateTime.now().toUtc(),
      ));
    } else if (step.phase == 'visual_generation') {
      updatedOutputs.add(MobileAgentOutput(
        outputId: 'out-vis-${DateTime.now().millisecondsSinceEpoch}',
        agentRunId: agentRunId,
        outputType: MobileAgentOutputType.asset,
        title: 'Bộ phân cảnh Video Clips AI',
        summary: '5 cảnh visual 1080p sinh từ Veo',
        objectRefs: ['asset:vis:$agentRunId'],
        createdAt: DateTime.now().toUtc(),
      ));
    } else if (step.phase == 'assembly_and_export') {
      updatedOutputs.add(MobileAgentOutput(
        outputId: 'out-vid-${DateTime.now().millisecondsSinceEpoch}',
        agentRunId: agentRunId,
        outputType: MobileAgentOutputType.video,
        title: 'Video thành phẩm 1080p',
        summary: 'Video hoàn thiện sẵn sàng đăng tải',
        objectRefs: ['asset:video:$agentRunId'],
        downloadableRefs: ['https://storage.creativanta.vn/vid/$agentRunId.mp4'],
        createdAt: DateTime.now().toUtc(),
      ));
    }

    final allDone = updatedSteps.every(
      (s) => s.status == MobileAgentStepStatus.completed,
    );

    final updatedRun = MobileAgentRun(
      agentRunId: agentRunId,
      workspaceId: workspaceId,
      agentType: agentType,
      planSummary: planSummary,
      approvalState: approvalState,
      currentState: allDone
          ? MobileAgentRunState.completed
          : MobileAgentRunState.executing,
      creditsUsed: newCreditsUsed,
      budgetCeiling: budgetCeiling,
      memory: updatedMemory,
      steps: updatedSteps,
      outputs: updatedOutputs,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: DateTime.now().toUtc(),
    );

    return MobileStepExecutionResult(
      success: true,
      run: updatedRun,
    );
  }

  /// Acceptance Target 3: Partial failure has audited handoff.
  MobileAgentRun recordPartialFailureHandoff({
    required int failedStepIndex,
    required String errorReason,
    required String targetUserId,
  }) {
    final updatedSteps = List<MobileAgentStep>.from(steps);
    final failedStep = updatedSteps[failedStepIndex];

    final diagRef = 'diag-p7-04-$agentRunId-step-${failedStep.stepOrder}';
    final auditRef = 'audit-handoff-$agentRunId-${DateTime.now().millisecondsSinceEpoch}';

    updatedSteps[failedStepIndex] = failedStep.copyWith(
      status: MobileAgentStepStatus.failed,
      observedOutcome: 'Lỗi tại bước ${failedStep.stepOrder}: $errorReason',
      diagnosticsRef: diagRef,
    );

    for (int i = failedStepIndex + 1; i < updatedSteps.length; i++) {
      updatedSteps[i] = updatedSteps[i].copyWith(
        status: MobileAgentStepStatus.skipped,
      );
    }

    final completedCount = updatedSteps
        .where((s) => s.status == MobileAgentStepStatus.completed)
        .length;

    final unresolved = updatedSteps
        .where((s) =>
            s.status == MobileAgentStepStatus.failed ||
            s.status == MobileAgentStepStatus.skipped)
        .map((s) => 'Bước ${s.stepOrder}: ${s.title}')
        .toList();

    final handoff = MobileAgentHandoffContext(
      handoffTargetUserId: targetUserId,
      reason: 'Lỗi tại bước ${failedStep.title}: $errorReason',
      summaryOfCompletedWork:
          'Đã hoàn thành $completedCount/${steps.length} bước. Đã bảo tồn ${outputs.length} outputs thành phẩm.',
      unresolvedActions: unresolved,
      diagnosticsRef: diagRef,
      auditRef: auditRef,
    );

    return MobileAgentRun(
      agentRunId: agentRunId,
      workspaceId: workspaceId,
      agentType: agentType,
      planSummary: planSummary,
      approvalState: approvalState,
      currentState: targetUserId.isNotEmpty
          ? MobileAgentRunState.handedOff
          : MobileAgentRunState.partiallyCompleted,
      creditsUsed: creditsUsed,
      budgetCeiling: budgetCeiling,
      memory: memory,
      steps: updatedSteps,
      outputs: outputs,
      handoffContext: handoff,
      diagnosticsRef: diagRef,
      auditRef: auditRef,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  MobileAgentRun increaseCeiling(double additionalCredits) {
    final updatedSteps = List<MobileAgentStep>.from(steps);
    var newState = currentState;

    if (currentState == MobileAgentRunState.waitingContext) {
      newState = MobileAgentRunState.executing;
      for (int i = 0; i < updatedSteps.length; i++) {
        if (updatedSteps[i].status == MobileAgentStepStatus.waitingContext) {
          updatedSteps[i] = updatedSteps[i].copyWith(
            status: MobileAgentStepStatus.planning,
          );
        }
      }
    }

    return MobileAgentRun(
      agentRunId: agentRunId,
      workspaceId: workspaceId,
      agentType: agentType,
      planSummary: planSummary,
      approvalState: approvalState,
      currentState: newState,
      creditsUsed: creditsUsed,
      budgetCeiling: budgetCeiling + additionalCredits,
      memory: memory,
      steps: updatedSteps,
      outputs: outputs,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  MobileAgentRun approveRun(String approverRole) {
    if (approverRole != 'owner' &&
        approverRole != 'admin' &&
        approverRole != 'manager') {
      return this;
    }

    final updatedSteps = List<MobileAgentStep>.from(steps);
    var newState = currentState;

    if (currentState == MobileAgentRunState.awaitingApproval) {
      newState = MobileAgentRunState.executing;
    }

    for (int i = 0; i < updatedSteps.length; i++) {
      if (updatedSteps[i].status == MobileAgentStepStatus.awaitingApproval) {
        updatedSteps[i] = updatedSteps[i].copyWith(
          status: MobileAgentStepStatus.planning,
        );
      }
    }

    return MobileAgentRun(
      agentRunId: agentRunId,
      workspaceId: workspaceId,
      agentType: agentType,
      planSummary: planSummary,
      approvalState: 'approved',
      currentState: newState,
      creditsUsed: creditsUsed,
      budgetCeiling: budgetCeiling,
      memory: memory,
      steps: updatedSteps,
      outputs: outputs,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  /// Factory helper to build canonical 6-stage video agent pipeline.
  static MobileAgentRun createVideoAgentPlan({
    required String workspaceId,
    required String userId,
    required String prompt,
    double budgetCeiling = 50.0,
    bool autoPublish = false,
  }) {
    final runId = 'run-vid-mob-${DateTime.now().millisecondsSinceEpoch}';
    final steps = <MobileAgentStep>[
      MobileAgentStep(
        stepId: '$runId-s1',
        agentRunId: runId,
        stepOrder: 1,
        phase: 'script_generation',
        title: 'Tạo kịch bản & phân cảnh',
        status: MobileAgentStepStatus.planning,
        expectedOutcome: 'Kịch bản phân đoạn 3 hồi có hook mạnh',
        requiredPermission: 'content:write',
        estimatedCredits: 3.0,
      ),
      MobileAgentStep(
        stepId: '$runId-s2',
        agentRunId: runId,
        stepOrder: 2,
        phase: 'scene_planning',
        title: 'Lập kế hoạch storyboard & nhân vật đồng nhất',
        status: MobileAgentStepStatus.planning,
        expectedOutcome: '5 cảnh visual định danh nhân vật',
        requiredPermission: 'asset:generate',
        estimatedCredits: 2.0,
      ),
      MobileAgentStep(
        stepId: '$runId-s3',
        agentRunId: runId,
        stepOrder: 3,
        phase: 'visual_generation',
        title: 'Sinh hình ảnh đa cảnh (Veo 720p)',
        status: MobileAgentStepStatus.planning,
        expectedOutcome: '5 video clips ngắn theo timeline',
        requiredPermission: 'asset:generate',
        estimatedCredits: 25.0,
      ),
      MobileAgentStep(
        stepId: '$runId-s4',
        agentRunId: runId,
        stepOrder: 4,
        phase: 'voiceover_synthesis',
        title: 'Tổng hợp giọng đọc AI đa cảm xúc',
        status: MobileAgentStepStatus.planning,
        expectedOutcome: 'Audio voiceover đồng bộ phân đoạn',
        requiredPermission: 'asset:generate',
        estimatedCredits: 4.0,
      ),
      MobileAgentStep(
        stepId: '$runId-s5',
        agentRunId: runId,
        stepOrder: 5,
        phase: 'music_sfx',
        title: 'Phối nhạc nền bản quyền & SFX',
        status: MobileAgentStepStatus.planning,
        expectedOutcome: 'Track âm thanh chuẩn -14 LUFS',
        requiredPermission: 'asset:generate',
        estimatedCredits: 3.0,
      ),
      MobileAgentStep(
        stepId: '$runId-s6',
        agentRunId: runId,
        stepOrder: 6,
        phase: 'assembly_and_export',
        title: autoPublish
            ? 'Lắp ghép video & Tự động xuất bản lên kênh'
            : 'Lắp ghép video & Xuất bản thảo',
        status: MobileAgentStepStatus.planning,
        expectedOutcome: 'Render video MP4 1080p và tạo asset library ref',
        requiredPermission: autoPublish ? 'publish:manage' : 'asset:generate',
        isHighRisk: autoPublish,
        estimatedCredits: 3.0,
      ),
    ];

    return MobileAgentRun(
      agentRunId: runId,
      workspaceId: workspaceId,
      agentType: MobileAgentType.videoAgent,
      planSummary: 'Tự động tạo video từ mô tả: $prompt',
      approvalState: autoPublish ? 'awaiting_approval' : 'not_required',
      currentState: MobileAgentRunState.planning,
      creditsUsed: 0.0,
      budgetCeiling: budgetCeiling,
      memory: const MobileAgentMemory(),
      steps: steps,
      outputs: const [],
      createdBy: userId,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }
}
