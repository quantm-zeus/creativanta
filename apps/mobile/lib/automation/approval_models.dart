/// Creativanta P7-02 Automation Approvals, DLQ & Runtime Diagnostics Models.
/// Canonical rules: PRD §23, workflow_studio.md, database_schema.md §12.
library;

enum MobileApprovalStatus {
  pending,
  approved,
  rejected,
  expired,
  invalidated;

  static MobileApprovalStatus fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'approved':
        return MobileApprovalStatus.approved;
      case 'rejected':
        return MobileApprovalStatus.rejected;
      case 'expired':
        return MobileApprovalStatus.expired;
      case 'invalidated':
        return MobileApprovalStatus.invalidated;
      case 'pending':
      default:
        return MobileApprovalStatus.pending;
    }
  }
}

enum MobileDLQStatus {
  pending,
  retrying,
  resolved,
  discarded;

  static MobileDLQStatus fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'retrying':
        return MobileDLQStatus.retrying;
      case 'resolved':
        return MobileDLQStatus.resolved;
      case 'discarded':
        return MobileDLQStatus.discarded;
      case 'pending':
      default:
        return MobileDLQStatus.pending;
    }
  }
}

class MobileApprovalRequest {
  final String approvalId;
  final String workspaceId;
  final String runId;
  final String workflowId;
  final String nodeId;
  final String title;
  final String actionHash;
  final String actionRpc;
  final List<String> targetObjects;
  final int budgetQuoteCredits;
  final List<String> approverRoles;
  final MobileApprovalStatus status;
  final DateTime requestedAt;
  final DateTime expiresAt;
  final DateTime? decidedAt;
  final String? decidedBy;
  final String? decisionNotes;
  final bool isInvalidated;
  final String? invalidationReason;

  const MobileApprovalRequest({
    required this.approvalId,
    required this.workspaceId,
    required this.runId,
    required this.workflowId,
    required this.nodeId,
    required this.title,
    required this.actionHash,
    required this.actionRpc,
    this.targetObjects = const [],
    this.budgetQuoteCredits = 0,
    this.approverRoles = const [],
    required this.status,
    required this.requestedAt,
    required this.expiresAt,
    this.decidedAt,
    this.decidedBy,
    this.decisionNotes,
    this.isInvalidated = false,
    this.invalidationReason,
  });

  /// Target acceptance 2: Changed action invalidates approval.
  /// If currentActionHash does not match actionHash, approval is invalidated.
  bool isActionHashValid(String currentActionHash) {
    if (isInvalidated) return false;
    return actionHash == currentActionHash;
  }

  /// Target acceptance: Wait/approval expiry detection.
  bool isExpired(DateTime now) {
    if (status != MobileApprovalStatus.pending) return false;
    return now.isAfter(expiresAt);
  }

  Map<String, dynamic> toJson() => {
        'approval_id': approvalId,
        'workspace_id': workspaceId,
        'run_id': runId,
        'workflow_id': workflowId,
        'node_id': nodeId,
        'title': title,
        'action_hash': actionHash,
        'action_rpc': actionRpc,
        'target_objects': targetObjects,
        'budget_quote_credits': budgetQuoteCredits,
        'approver_roles': approverRoles,
        'status': status.name,
        'requested_at': requestedAt.toIso8601String(),
        'expires_at': expiresAt.toIso8601String(),
        if (decidedAt != null) 'decided_at': decidedAt!.toIso8601String(),
        if (decidedBy != null) 'decided_by': decidedBy,
        if (decisionNotes != null) 'decision_notes': decisionNotes,
        'is_invalidated': isInvalidated,
        if (invalidationReason != null) 'invalidation_reason': invalidationReason,
      };

  factory MobileApprovalRequest.fromJson(Map<String, dynamic> json) {
    return MobileApprovalRequest(
      approvalId: json['approval_id'] as String? ?? '',
      workspaceId: json['workspace_id'] as String? ?? '',
      runId: json['run_id'] as String? ?? '',
      workflowId: json['workflow_id'] as String? ?? '',
      nodeId: json['node_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      actionHash: json['action_hash'] as String? ?? '',
      actionRpc: json['action_rpc'] as String? ?? '',
      targetObjects: (json['target_objects'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      budgetQuoteCredits: json['budget_quote_credits'] as int? ?? 0,
      approverRoles: (json['approver_roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      status: MobileApprovalStatus.fromString(json['status'] as String? ?? 'pending'),
      requestedAt: DateTime.parse(json['requested_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      decidedAt: json['decided_at'] != null ? DateTime.parse(json['decided_at'] as String) : null,
      decidedBy: json['decided_by'] as String?,
      decisionNotes: json['decision_notes'] as String?,
      isInvalidated: json['is_invalidated'] as bool? ?? false,
      invalidationReason: json['invalidation_reason'] as String?,
    );
  }
}

class MobileDLQItem {
  final String dlqId;
  final String workspaceId;
  final String runId;
  final String workflowId;
  final String nodeId;
  final String errorCode;
  final String errorMessage;
  final Map<String, dynamic> failedPayload;
  final int retryCount;
  final int maxRetries;
  final MobileDLQStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MobileDLQItem({
    required this.dlqId,
    required this.workspaceId,
    required this.runId,
    required this.workflowId,
    required this.nodeId,
    required this.errorCode,
    required this.errorMessage,
    this.failedPayload = const {},
    this.retryCount = 0,
    this.maxRetries = 3,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get canRetry => status == MobileDLQStatus.pending && retryCount < maxRetries;

  Map<String, dynamic> toJson() => {
        'dlq_id': dlqId,
        'workspace_id': workspaceId,
        'run_id': runId,
        'workflow_id': workflowId,
        'node_id': nodeId,
        'error_code': errorCode,
        'error_message': errorMessage,
        'failed_payload': failedPayload,
        'retry_count': retryCount,
        'max_retries': maxRetries,
        'status': status.name,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory MobileDLQItem.fromJson(Map<String, dynamic> json) {
    return MobileDLQItem(
      dlqId: json['dlq_id'] as String? ?? '',
      workspaceId: json['workspace_id'] as String? ?? '',
      runId: json['run_id'] as String? ?? '',
      workflowId: json['workflow_id'] as String? ?? '',
      nodeId: json['node_id'] as String? ?? '',
      errorCode: json['error_code'] as String? ?? '',
      errorMessage: json['error_message'] as String? ?? '',
      failedPayload: (json['failed_payload'] as Map<String, dynamic>?) ?? {},
      retryCount: json['retry_count'] as int? ?? 0,
      maxRetries: json['max_retries'] as int? ?? 3,
      status: MobileDLQStatus.fromString(json['status'] as String? ?? 'pending'),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class MobileSideEffect {
  final String effectId;
  final String rpcName;
  final String idempotencyKey;
  final String targetResource;
  final bool confirmed;
  final DateTime executedAt;

  const MobileSideEffect({
    required this.effectId,
    required this.rpcName,
    required this.idempotencyKey,
    required this.targetResource,
    required this.confirmed,
    required this.executedAt,
  });
}

/// Target acceptance 3: Resume never replays confirmed effect.
class MobileResumeSafetyGate {
  final Set<String> _confirmedIdempotencyKeys = {};
  final List<MobileSideEffect> _recordedEffects = [];

  List<MobileSideEffect> get recordedEffects => List.unmodifiable(_recordedEffects);

  void recordConfirmedEffect(MobileSideEffect effect) {
    if (effect.confirmed) {
      _confirmedIdempotencyKeys.add(effect.idempotencyKey);
      _recordedEffects.add(effect);
    }
  }

  /// Returns true if execution is permitted; false if effect was already confirmed and must be skipped.
  bool shouldExecute(String idempotencyKey) {
    if (_confirmedIdempotencyKeys.contains(idempotencyKey)) {
      return false; // Already confirmed: NEVER replay
    }
    return true;
  }
}

class MobilePreflightActionSummary {
  final String nodeId;
  final String rpcName;
  final String targetPlatform;
  final int estimatedCredits;
  final bool isSensitive;

  const MobilePreflightActionSummary({
    required this.nodeId,
    required this.rpcName,
    required this.targetPlatform,
    required this.estimatedCredits,
    required this.isSensitive,
  });
}

class MobilePreflightReport {
  final String workflowId;
  final bool isValid;
  final int estimatedCreditsTotal;
  final List<MobilePreflightActionSummary> actions;
  final List<String> warnings;
  final List<String> blockers;

  const MobilePreflightReport({
    required this.workflowId,
    required this.isValid,
    required this.estimatedCreditsTotal,
    required this.actions,
    required this.warnings,
    required this.blockers,
  });
}
