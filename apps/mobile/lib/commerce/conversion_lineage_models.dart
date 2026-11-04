import 'package:flutter/foundation.dart';

/// Supported source types for cross-domain conversion.
enum ConversionSourceType {
  opportunity,
  idea,
  thread;

  String get value {
    switch (this) {
      case ConversionSourceType.opportunity:
        return 'opportunity';
      case ConversionSourceType.idea:
        return 'idea';
      case ConversionSourceType.thread:
        return 'thread';
    }
  }

  static ConversionSourceType fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'opportunity':
        return ConversionSourceType.opportunity;
      case 'idea':
        return ConversionSourceType.idea;
      case 'thread':
        return ConversionSourceType.thread;
      default:
        throw ArgumentError('Unknown source type: $raw');
    }
  }
}

/// Supported commerce target types.
enum ConversionTargetType {
  campaign,
  liveSession,
  offer,
  seedingRequest,
  brandDeal;

  String get value {
    switch (this) {
      case ConversionTargetType.campaign:
        return 'campaign';
      case ConversionTargetType.liveSession:
        return 'live_session';
      case ConversionTargetType.offer:
        return 'offer';
      case ConversionTargetType.seedingRequest:
        return 'seeding_request';
      case ConversionTargetType.brandDeal:
        return 'brand_deal';
    }
  }

  static ConversionTargetType fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'campaign':
        return ConversionTargetType.campaign;
      case 'live_session':
      case 'livesession':
      case 'live':
        return ConversionTargetType.liveSession;
      case 'offer':
        return ConversionTargetType.offer;
      case 'seeding_request':
      case 'seedingrequest':
      case 'sample':
      case 'seeding':
        return ConversionTargetType.seedingRequest;
      case 'brand_deal':
      case 'branddeal':
      case 'deal':
        return ConversionTargetType.brandDeal;
      default:
        throw ArgumentError('Unknown target type: $raw');
    }
  }
}

/// Canonical permission mappings per docs/04_contracts/rbac_permission_matrix.md
class ConversionPermissions {
  static const String oppConvert = 'opportunity:convert';
  static const String ideaConvert = 'idea:convert';
  static const String threadTriage = 'thread:triage';

  static const String campaignManage = 'campaign:manage';
  static const String liveManage = 'live:manage';
  static const String offerManage = 'offer:manage';
  static const String sampleManage = 'sample:manage';
  static const String brandDealManage = 'brand_deal:manage';

  static String getSourcePermission(ConversionSourceType source) {
    switch (source) {
      case ConversionSourceType.opportunity:
        return oppConvert;
      case ConversionSourceType.idea:
        return ideaConvert;
      case ConversionSourceType.thread:
        return threadTriage;
    }
  }

  static String getTargetPermission(ConversionTargetType target) {
    switch (target) {
      case ConversionTargetType.campaign:
        return campaignManage;
      case ConversionTargetType.liveSession:
        return liveManage;
      case ConversionTargetType.offer:
        return offerManage;
      case ConversionTargetType.seedingRequest:
        return sampleManage;
      case ConversionTargetType.brandDeal:
        return brandDealManage;
    }
  }

  static const Map<String, Set<String>> rolePermissions = {
    'owner': {
      oppConvert,
      ideaConvert,
      threadTriage,
      campaignManage,
      liveManage,
      offerManage,
      sampleManage,
      brandDealManage,
    },
    'admin': {
      oppConvert,
      ideaConvert,
      threadTriage,
      campaignManage,
      liveManage,
      offerManage,
      sampleManage,
      brandDealManage,
    },
    'manager': {
      oppConvert,
      ideaConvert,
      threadTriage,
      campaignManage,
      liveManage,
      offerManage,
      sampleManage,
      brandDealManage,
    },
    'editor': {
      oppConvert,
      ideaConvert,
      threadTriage,
      campaignManage,
      liveManage,
      offerManage,
      sampleManage,
      // NOTE: 'brand_deal:manage' is strictly NOT granted to Editor
    },
    'contributor': {},
    'viewer': {},
  };

  static bool hasPermission(String role, String permission) {
    final perms = rolePermissions[role.toLowerCase()] ?? {};
    return perms.contains(permission);
  }

  static ConversionPermissionCheckResult evaluatePermissions({
    required String role,
    required ConversionSourceType source,
    required ConversionTargetType target,
  }) {
    final srcPerm = getSourcePermission(source);
    if (!hasPermission(role, srcPerm)) {
      return ConversionPermissionCheckResult(
        allowed: false,
        requiredPermission: srcPerm,
        errorCode: 'ERR_SOURCE_PERMISSION_DENIED',
        failureReason: 'Role $role lacks required source permission: $srcPerm',
      );
    }

    final tgtPerm = getTargetPermission(target);
    if (!hasPermission(role, tgtPerm)) {
      return ConversionPermissionCheckResult(
        allowed: false,
        requiredPermission: tgtPerm,
        errorCode: 'ERR_TARGET_PERMISSION_DENIED',
        failureReason: 'Role $role lacks required target permission: $tgtPerm',
      );
    }

    return const ConversionPermissionCheckResult(allowed: true);
  }
}

class ConversionPermissionCheckResult {
  final bool allowed;
  final String? requiredPermission;
  final String? errorCode;
  final String? failureReason;

  const ConversionPermissionCheckResult({
    required this.allowed,
    this.requiredPermission,
    this.errorCode,
    this.failureReason,
  });
}

/// Represents an immutable lineage record preserving cross-domain provenance.
@immutable
class LineageRecord {
  final String id;
  final String workspaceId;
  final ConversionSourceType sourceType;
  final String sourceId;
  final String sourceTitle;
  final ConversionTargetType targetType;
  final String targetId;
  final String targetTitle;
  final String convertedBy;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  const LineageRecord({
    required this.id,
    required this.workspaceId,
    required this.sourceType,
    required this.sourceId,
    required this.sourceTitle,
    required this.targetType,
    required this.targetId,
    required this.targetTitle,
    required this.convertedBy,
    required this.createdAt,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'workspace_id': workspaceId,
        'source_type': sourceType.value,
        'source_id': sourceId,
        'source_title': sourceTitle,
        'target_type': targetType.value,
        'target_id': targetId,
        'target_title': targetTitle,
        'converted_by': convertedBy,
        'created_at': createdAt.toIso8601String(),
        'metadata': metadata,
      };
}

/// Represents a source item (Opportunity, Idea, or Thread) undergoing conversion.
@immutable
class SourceItem {
  final String id;
  final String workspaceId;
  final ConversionSourceType sourceType;
  final String title;
  final String status;
  final String? convertedToType;
  final String? convertedToId;
  final DateTime? convertedAt;

  const SourceItem({
    required this.id,
    required this.workspaceId,
    required this.sourceType,
    required this.title,
    required this.status,
    this.convertedToType,
    this.convertedToId,
    this.convertedAt,
  });

  bool get isConverted =>
      status == 'converted' ||
      status == 'converted_to_task' ||
      convertedToId != null;

  SourceItem copyWith({
    String? status,
    String? convertedToType,
    String? convertedToId,
    DateTime? convertedAt,
  }) {
    return SourceItem(
      id: id,
      workspaceId: workspaceId,
      sourceType: sourceType,
      title: title,
      status: status ?? this.status,
      convertedToType: convertedToType ?? this.convertedToType,
      convertedToId: convertedToId ?? this.convertedToId,
      convertedAt: convertedAt ?? this.convertedAt,
    );
  }
}

/// Represents a target item created via conversion.
@immutable
class TargetItem {
  final String id;
  final String workspaceId;
  final ConversionTargetType targetType;
  final String title;
  final String status;
  final ConversionSourceType sourceType;
  final String sourceId;
  final DateTime createdAt;

  const TargetItem({
    required this.id,
    required this.workspaceId,
    required this.targetType,
    required this.title,
    required this.status,
    required this.sourceType,
    required this.sourceId,
    required this.createdAt,
  });
}

/// Result of a cross-domain conversion attempt.
class ConversionExecutionResult {
  final bool success;
  final SourceItem? updatedSource;
  final TargetItem? createdTarget;
  final LineageRecord? lineage;
  final String? errorCode;
  final String? errorMessage;
  final bool rollbackPerformed;

  const ConversionExecutionResult({
    required this.success,
    this.updatedSource,
    this.createdTarget,
    this.lineage,
    this.errorCode,
    this.errorMessage,
    this.rollbackPerformed = false,
  });
}

/// Executes a cross-domain commerce conversion with:
/// 1. Target permission recheck (fails closed before creating any resources)
/// 2. Atomic rollback on any failure (target creation, source update, lineage store)
/// 3. Source survival (source is never deleted; status transitions to converted)
Future<ConversionExecutionResult> executeCrossDomainConversion({
  required String workspaceId,
  required String userRole,
  required String userId,
  required SourceItem source,
  required ConversionTargetType targetType,
  required String targetTitle,
  Future<TargetItem> Function(TargetItem draft)? targetCreator,
  Future<SourceItem> Function(SourceItem updated)? sourceUpdater,
  Future<LineageRecord> Function(LineageRecord lineage)? lineageRecorder,
  Future<void> Function(String targetId)? targetCompensator,
  Future<void> Function(SourceItem original)? sourceCompensator,
}) async {
  // Target 1: Target permission rechecked
  final permCheck = ConversionPermissions.evaluatePermissions(
    role: userRole,
    source: source.sourceType,
    target: targetType,
  );

  if (!permCheck.allowed) {
    return ConversionExecutionResult(
      success: false,
      errorCode: permCheck.errorCode,
      errorMessage: permCheck.failureReason,
    );
  }

  // Pre-condition: Source cannot already be converted
  if (source.isConverted) {
    return const ConversionExecutionResult(
      success: false,
      errorCode: 'ERR_SOURCE_ALREADY_CONVERTED',
      errorMessage: 'Source item has already been converted and cannot be converted again',
    );
  }

  final now = DateTime.now().toUtc();
  final targetId = 'tgt-${now.millisecondsSinceEpoch}';
  final draftTarget = TargetItem(
    id: targetId,
    workspaceId: workspaceId,
    targetType: targetType,
    title: targetTitle,
    status: 'draft',
    sourceType: source.sourceType,
    sourceId: source.id,
    createdAt: now,
  );

  // Step 1: Create target
  TargetItem createdTarget;
  try {
    if (targetCreator != null) {
      createdTarget = await targetCreator(draftTarget);
    } else {
      createdTarget = draftTarget;
    }
  } catch (e) {
    // Target creation failed: source remains untouched, atomic guarantee holds
    return ConversionExecutionResult(
      success: false,
      errorCode: 'ERR_TARGET_CREATION_FAILED',
      errorMessage: 'Failed to create target resource: $e',
      rollbackPerformed: false, // nothing created to rollback
    );
  }

  // Step 2: Update source (Source survives conversion!)
  final convertedStatus = source.sourceType == ConversionSourceType.thread
      ? 'converted_to_task'
      : 'converted';
  final draftSourceUpdate = source.copyWith(
    status: convertedStatus,
    convertedToType: targetType.value,
    convertedToId: createdTarget.id,
    convertedAt: now,
  );

  SourceItem updatedSource;
  try {
    if (sourceUpdater != null) {
      updatedSource = await sourceUpdater(draftSourceUpdate);
    } else {
      updatedSource = draftSourceUpdate;
    }
  } catch (e) {
    // Atomic rollback: Compensate created target
    if (targetCompensator != null) {
      await targetCompensator(createdTarget.id);
    }
    return ConversionExecutionResult(
      success: false,
      errorCode: 'ERR_SOURCE_UPDATE_FAILED',
      errorMessage: 'Failed to update source status: $e',
      rollbackPerformed: true,
    );
  }

  // Step 3: Record shared lineage
  final lineageDraft = LineageRecord(
    id: 'lin-${now.millisecondsSinceEpoch}',
    workspaceId: workspaceId,
    sourceType: source.sourceType,
    sourceId: source.id,
    sourceTitle: source.title,
    targetType: targetType,
    targetId: createdTarget.id,
    targetTitle: targetTitle,
    convertedBy: userId,
    createdAt: now,
    metadata: {
      'converted_by_role': userRole,
    },
  );

  LineageRecord recordedLineage;
  try {
    if (lineageRecorder != null) {
      recordedLineage = await lineageRecorder(lineageDraft);
    } else {
      recordedLineage = lineageDraft;
    }
  } catch (e) {
    // Atomic rollback: Compensate target and restore source
    if (targetCompensator != null) {
      await targetCompensator(createdTarget.id);
    }
    if (sourceCompensator != null) {
      await sourceCompensator(source);
    }
    return ConversionExecutionResult(
      success: false,
      errorCode: 'ERR_LINEAGE_RECORD_FAILED',
      errorMessage: 'Failed to record lineage: $e',
      rollbackPerformed: true,
    );
  }

  return ConversionExecutionResult(
    success: true,
    createdTarget: createdTarget,
    updatedSource: updatedSource,
    lineage: recordedLineage,
  );
}
