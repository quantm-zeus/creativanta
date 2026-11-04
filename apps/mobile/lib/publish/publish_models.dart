import 'dart:math';

/// Exception thrown when publish is attempted before scheduled time.
class PrematurePublishException implements Exception {
  PrematurePublishException(this.message);
  final String message;

  @override
  String toString() => 'PrematurePublishException: $message';
}

/// Exception thrown when publish validation fails.
class PublishValidationException implements Exception {
  PublishValidationException(this.message);
  final String message;

  @override
  String toString() => 'PublishValidationException: $message';
}

/// Mobile model for Publish Item.
class PublishItemModel {
  const PublishItemModel({
    required this.id,
    required this.workspaceId,
    required this.targetAccountId,
    required this.targetChannelId,
    required this.platform,
    required this.mediaAssetId,
    required this.caption,
    required this.title,
    required this.scheduleAt,
    required this.status,
    required this.approvalStatus,
    required this.executionPath,
  });

  final String id;
  final String workspaceId;
  final String targetAccountId;
  final String targetChannelId;
  final String platform;
  final String mediaAssetId;
  final String caption;
  final String title;
  final DateTime scheduleAt;
  final String status; // 'draft' | 'scheduled' | 'publishing' | 'published' | 'failed'
  final String approvalStatus;
  final String executionPath; // 'native_api' | 'manual_upload' | 'reconciled'

  PublishItemModel copyWith({
    String? status,
    String? executionPath,
  }) {
    return PublishItemModel(
      id: id,
      workspaceId: workspaceId,
      targetAccountId: targetAccountId,
      targetChannelId: targetChannelId,
      platform: platform,
      mediaAssetId: mediaAssetId,
      caption: caption,
      title: title,
      scheduleAt: scheduleAt,
      status: status ?? this.status,
      approvalStatus: approvalStatus,
      executionPath: executionPath ?? this.executionPath,
    );
  }
}

/// Mobile model for Publish Job.
class PublishJobModel {
  const PublishJobModel({
    required this.id,
    required this.workspaceId,
    required this.publishItemId,
    required this.targetAccountId,
    required this.platform,
    required this.status, // 'queued' | 'running' | 'success' | 'failed' | 'blocked'
    required this.diagnosticsState, // 'healthy' | 'warning' | 'blocked'
    required this.scheduledFor,
    required this.effectiveSchedule,
    required this.attemptCount,
    this.lastError,
    this.externalPostId,
  });

  final String id;
  final String workspaceId;
  final String publishItemId;
  final String targetAccountId;
  final String platform;
  final String status;
  final String diagnosticsState;
  final DateTime scheduledFor;
  final DateTime effectiveSchedule;
  final int attemptCount;
  final String? lastError;
  final String? externalPostId;

  PublishJobModel copyWith({
    String? status,
    String? diagnosticsState,
    String? lastError,
    String? externalPostId,
    int? attemptCount,
  }) {
    return PublishJobModel(
      id: id,
      workspaceId: workspaceId,
      publishItemId: publishItemId,
      targetAccountId: targetAccountId,
      platform: platform,
      status: status ?? this.status,
      diagnosticsState: diagnosticsState ?? this.diagnosticsState,
      scheduledFor: scheduledFor,
      effectiveSchedule: effectiveSchedule,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
      externalPostId: externalPostId ?? this.externalPostId,
    );
  }
}

/// Mobile model for immutable Publish Log.
class PublishLogModel {
  const PublishLogModel({
    required this.id,
    required this.workspaceId,
    required this.publishJobId,
    required this.attemptNumber,
    required this.executionPath,
    required this.resultStatus,
    this.providerRequestId,
    this.evidenceRef,
    required this.createdAt,
  });

  final String id;
  final String workspaceId;
  final String publishJobId;
  final int attemptNumber;
  final String executionPath;
  final String resultStatus;
  final String? providerRequestId;
  final String? evidenceRef;
  final DateTime createdAt;
}

/// Mobile model for manual export package.
class ManualProofPackage {
  const ManualProofPackage({
    required this.publishItemId,
    required this.platform,
    required this.mediaUrl,
    required this.caption,
    required this.hashtags,
    required this.instructions,
    required this.checklist,
  });

  final String publishItemId;
  final String platform;
  final String mediaUrl;
  final String caption;
  final List<String> hashtags;
  final String instructions;
  final List<String> checklist;
}

/// Computes fair effective schedule with strictly non-negative additive jitter.
/// Invariant: effectiveSchedule >= scheduledTime.
DateTime calculateFairEffectiveSchedule(DateTime scheduleAt, [int? fixedJitterMs]) {
  final int jitterMs = fixedJitterMs ?? Random().nextInt(30001); // 0..30,000ms
  if (jitterMs < 0) {
    throw PublishValidationException('Jitter delay cannot be negative');
  }
  return scheduleAt.add(Duration(milliseconds: jitterMs));
}

/// Asserts timing condition: cannot publish prior to schedule.
void assertScheduleTimingAllowed(DateTime now, DateTime scheduleAt) {
  if (now.isBefore(scheduleAt)) {
    throw PrematurePublishException(
      'Cannot publish before scheduled time (now: ${now.toIso8601String()}, scheduled: ${scheduleAt.toIso8601String()})',
    );
  }
}

/// Reconciles unknown submit response without blind retry or duplicate posting.
Future<Map<String, dynamic>> reconcileUnknownSubmit({
  required String? providerRequestId,
  required Future<bool> Function(String reqId) checkRemotePublished,
}) async {
  if (providerRequestId == null || providerRequestId.isEmpty) {
    return {
      'reconciled': false,
      'status': 'failed',
      'notes': 'Missing provider request ID for unknown submission reconciliation',
    };
  }

  try {
    final bool isPublished = await checkRemotePublished(providerRequestId);
    if (isPublished) {
      return {
        'reconciled': true,
        'status': 'published',
        'externalPostId': 'remote_$providerRequestId',
        'notes': 'Successfully reconciled as published remotely',
      };
    } else {
      return {
        'reconciled': true,
        'status': 'retry_pending',
        'notes': 'Confirmed absent on remote platform; safe to retry dispatch',
      };
    }
  } catch (e) {
    return {
      'reconciled': false,
      'status': 'retry_pending',
      'notes': 'Reconciliation probe failed: $e',
    };
  }
}

/// Generates manual fallback package for manual upload.
ManualProofPackage generateManualFallbackPackage({
  required PublishItemModel item,
  required String mediaUrl,
}) {
  final exp = RegExp(r'#([a-zA-Z0-9_]+)');
  final tags = exp.allMatches(item.caption).map((m) => m.group(1)!).toList();
  final cleanCaption = item.caption.replaceAll(exp, '').trim();

  return ManualProofPackage(
    publishItemId: item.id,
    platform: item.platform,
    mediaUrl: mediaUrl,
    caption: cleanCaption,
    hashtags: tags,
    instructions: '1. Download media. 2. Open ${item.platform} App. 3. Upload & paste caption. 4. Post and save proof link.',
    checklist: const [
      'Rendered media verified',
      'Caption copied to clipboard',
      'Native post published',
      'Proof screenshot or link recorded',
    ],
  );
}

/// Submits manual proof and retains graph connection to publishItemId / publishJobId.
Map<String, dynamic> submitManualProof({
  required PublishItemModel item,
  required String evidenceRef,
  String? operatorUserId,
}) {
  if (evidenceRef.trim().isEmpty) {
    throw PublishValidationException('Evidence reference is required for manual proof');
  }

  final now = DateTime.now().toUtc();
  final updatedItem = item.copyWith(
    status: 'published',
    executionPath: 'manual_upload',
  );

  final log = PublishLogModel(
    id: 'log_${now.millisecondsSinceEpoch}',
    workspaceId: item.workspaceId,
    publishJobId: item.id, // Graph connection retained
    attemptNumber: 1,
    executionPath: 'manual_upload',
    resultStatus: 'success',
    evidenceRef: evidenceRef,
    createdAt: now,
  );

  return {
    'item': updatedItem,
    'log': log,
  };
}

/// Applies token revocation event: fails executing job and pauses queued jobs for the same account.
Map<String, dynamic> applyTokenRevocation({
  required PublishJobModel failedJob,
  required List<PublishJobModel> queuedJobs,
  required Set<String> pausedAccounts,
}) {
  pausedAccounts.add(failedJob.targetAccountId);

  final updatedFailedJob = failedJob.copyWith(
    status: 'failed',
    diagnosticsState: 'blocked',
    lastError: 'Target account authentication revoked (auth_revoked)',
  );

  final pausedJobs = <PublishJobModel>[];
  for (final job in queuedJobs) {
    if (job.targetAccountId == failedJob.targetAccountId && job.id != failedJob.id) {
      pausedJobs.add(job.copyWith(
        status: 'blocked',
        diagnosticsState: 'blocked',
        lastError: 'Paused due to revoked credentials on target account',
      ));
    }
  }

  return {
    'failedJob': updatedFailedJob,
    'pausedJobs': pausedJobs,
  };
}
