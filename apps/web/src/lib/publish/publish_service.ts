import type {
  DiagnosticsState,
  ManualExportPackage,
  PublishItem,
  PublishJob,
  PublishLog,
  UnknownSubmitReconciliationResult
} from './types';

export const SCHEDULE_FAIRNESS_DEFAULT = {
  minJitterMs: 0,
  maxJitterMs: 30000 // 30 seconds
};

export class PublishValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'PublishValidationError';
  }
}

export class PrematurePublishError extends PublishValidationError {
  constructor(message: string = 'Cannot publish prior to scheduled time') {
    super(message);
    this.name = 'PrematurePublishError';
  }
}

export class CapabilityBlockedError extends PublishValidationError {
  constructor(message: string = 'Action is not natively supported or verified') {
    super(message);
    this.name = 'CapabilityBlockedError';
  }
}

export class AuthRevokedError extends PublishValidationError {
  constructor(message: string = 'Target account authentication revoked or expired') {
    super(message);
    this.name = 'AuthRevokedError';
  }
}

/**
 * Calculates effective schedule time with additive fairness jitter.
 * Strict Invariant: effectiveSchedule >= scheduledTime (never runs early).
 */
export function calculateFairSchedule(
  scheduleAt: Date | string,
  jitterMs?: number
): { effectiveSchedule: Date; jitterMs: number } {
  const schedDate = typeof scheduleAt === 'string' ? new Date(scheduleAt) : scheduleAt;
  if (isNaN(schedDate.getTime())) {
    throw new PublishValidationError('Invalid schedule date');
  }

  // Jitter must be strictly non-negative
  const selectedJitter =
    jitterMs !== undefined && jitterMs >= 0
      ? jitterMs
      : Math.floor(Math.random() * (SCHEDULE_FAIRNESS_DEFAULT.maxJitterMs + 1));

  const effectiveSchedule = new Date(schedDate.getTime() + selectedJitter);
  return {
    effectiveSchedule,
    jitterMs: selectedJitter
  };
}

/**
 * Validates execution timing against schedule.
 * Throws PrematurePublishError if now < scheduleAt.
 */
export function validateScheduleTiming(now: Date, scheduleAt: Date | string): void {
  const schedDate = typeof scheduleAt === 'string' ? new Date(scheduleAt) : scheduleAt;
  if (now.getTime() < schedDate.getTime()) {
    throw new PrematurePublishError(
      `Cannot publish prior to scheduled time (now: ${now.toISOString()}, scheduled: ${schedDate.toISOString()})`
    );
  }
}

/**
 * Evaluates whether an automated native dispatch can proceed based on capability state.
 */
export function canDispatchNatively(capabilityState: string): boolean {
  return capabilityState === 'native';
}

/**
 * Reconciles unknown submit results (e.g. platform timeout or dropped connection).
 * Never blindly assumes success. Queries provider verification endpoint.
 */
export async function reconcileUnknownSubmit(params: {
  providerRequestId?: string;
  checkStatus: (reqId: string) => Promise<{ found: boolean; externalPostId?: string }>;
}): Promise<UnknownSubmitReconciliationResult> {
  if (!params.providerRequestId) {
    return {
      reconciled: false,
      status: 'failed',
      notes: 'No provider request ID available to reconcile unknown submission'
    };
  }

  try {
    const result = await params.checkStatus(params.providerRequestId);
    if (result.found && result.externalPostId) {
      return {
        reconciled: true,
        externalPostId: result.externalPostId,
        status: 'published',
        notes: `Reconciled successfully via provider request ID ${params.providerRequestId}`
      };
    } else {
      return {
        reconciled: true,
        status: 'retry_pending',
        notes: `Submission confirmed not posted on remote platform for ${params.providerRequestId}; safe to retry`
      };
    }
  } catch (err: unknown) {
    const msg = err instanceof Error ? err.message : String(err);
    return {
      reconciled: false,
      status: 'retry_pending',
      notes: `Reconciliation probe failed: ${msg}; keeping in unknown state`
    };
  }
}

/**
 * Generates manual export package for fallback paths when automated dispatch is unavailable.
 */
export function generateManualExportPackage(
  item: PublishItem,
  mediaAssetUrl: string
): ManualExportPackage {
  const hashtags = (item.caption.match(/#[a-zA-Z0-9_]+/g) || []).map((t) => t.slice(1));
  const cleanCaption = item.caption.replace(/#[a-zA-Z0-9_]+/g, '').trim();

  const instructionsMap: Record<string, string> = {
    tiktok: '1. Download video. 2. Open TikTok Studio / App. 3. Upload video. 4. Paste caption and hashtags. 5. Publish.',
    instagram: '1. Download video. 2. Open Instagram App. 3. Create Reel. 4. Paste caption and hashtags. 5. Share.',
    youtube: '1. Download video. 2. Open YouTube Studio. 3. Upload Short. 4. Set Title and Description. 5. Publish.'
  };

  return {
    publishItemId: item.id,
    platform: item.platform,
    renderedVideoUrl: mediaAssetUrl,
    caption: cleanCaption,
    hashtags,
    instructions: instructionsMap[item.platform.toLowerCase()] || 'Follow manual platform upload guidelines.',
    checklist: [
      'Rendered video downloaded',
      'Caption and hashtags copied',
      'Platform upload confirmed',
      'Proof screenshot or link saved'
    ],
    verificationUrl: `https://${item.platform.toLowerCase()}.com`,
    generatedAt: new Date().toISOString()
  };
}

/**
 * Submits manual proof of publication, retaining the full graph connection.
 * Transitions item to published, produces immutable log record.
 */
export function submitManualProof(
  item: PublishItem,
  proof: {
    evidenceRef: string;
    logId?: string;
    operatorUserId?: string;
    notes?: string;
  }
): {
  updatedItem: PublishItem;
  log: PublishLog;
} {
  if (!proof.evidenceRef || proof.evidenceRef.trim().length === 0) {
    throw new PublishValidationError('Evidence reference (URL or media storage ref) is required');
  }

  const nowIso = new Date().toISOString();

  const updatedItem: PublishItem = {
    ...item,
    status: 'published',
    executionPath: 'manual_upload',
    updatedAt: nowIso
  };

  const log: PublishLog = {
    id: proof.logId || `log_${Math.random().toString(36).substring(2, 11)}`,
    workspaceId: item.workspaceId,
    publishJobId: item.id, // Graph connection retained
    attemptNumber: 1,
    executionPath: 'manual_upload',
    resultStatus: 'success',
    providerRequestId: null,
    evidenceRef: proof.evidenceRef,
    logPayload: {
      operatorUserId: proof.operatorUserId || 'unknown',
      notes: proof.notes || 'Proof submitted manually by operator',
      submittedAt: nowIso
    },
    createdAt: nowIso
  };

  return { updatedItem, log };
}

/**
 * Handles token revocation during job execution:
 * 1. Fails the executing job with auth_expired.
 * 2. Pauses all queued or scheduled jobs targeting the same connected account.
 */
export function handleTokenRevocation(
  executingJob: PublishJob,
  allJobs: PublishJob[],
  pausedAccountsSet: Set<string>
): {
  failedJob: PublishJob;
  pausedJobs: PublishJob[];
} {
  // Mark the account as paused in caller's set
  pausedAccountsSet.add(executingJob.targetAccountId);

  const nowIso = new Date().toISOString();

  const failedJob: PublishJob = {
    ...executingJob,
    status: 'failed',
    diagnosticsState: 'blocked',
    lastError: 'Target account authentication revoked or expired (auth_revoked)',
    updatedAt: nowIso
  };

  // Find all queued/running/retry_pending jobs for the same account and pause them
  const pausedJobs: PublishJob[] = allJobs
    .filter(
      (j) =>
        j.targetAccountId === executingJob.targetAccountId &&
        j.id !== executingJob.id &&
        (j.status === 'queued' || j.status === 'retry_pending' || j.status === 'running')
    )
    .map((j) => ({
      ...j,
      status: 'blocked' as const,
      diagnosticsState: 'blocked' as DiagnosticsState,
      lastError: 'Target account authentication revoked; queued job paused pending reconnection',
      updatedAt: nowIso
    }));

  return { failedJob, pausedJobs };
}
