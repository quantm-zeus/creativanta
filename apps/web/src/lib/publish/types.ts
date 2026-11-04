export type PublishItemStatus =
  | 'draft'
  | 'pending_approval'
  | 'approved'
  | 'scheduled'
  | 'publishing'
  | 'published'
  | 'failed'
  | 'cancelled';

export type PublishJobStatus =
  | 'queued'
  | 'running'
  | 'success'
  | 'failed'
  | 'retry_pending'
  | 'blocked'
  | 'cancelled';

export type PublishExecutionPath = 'native_api' | 'manual_upload' | 'reconciled';

export type PublishResultStatus =
  | 'success'
  | 'failed'
  | 'unknown'
  | 'rate_limited'
  | 'auth_expired';

export type DiagnosticsState = 'healthy' | 'warning' | 'blocked' | 'unsupported';

export interface PublishItem {
  id: string;
  workspaceId: string;
  targetAccountId: string;
  targetChannelId: string;
  platform: string;
  mediaAssetId: string;
  caption: string;
  title: string;
  scheduleAt: string; // ISO-8601
  status: PublishItemStatus;
  approvalStatus: string;
  executionPath: PublishExecutionPath;
  createdAt: string;
  updatedAt: string;
}

export interface PublishJob {
  id: string;
  workspaceId: string;
  publishItemId: string;
  targetAccountId: string;
  platform: string;
  status: PublishJobStatus;
  diagnosticsState: DiagnosticsState;
  scheduledFor: string;
  effectiveSchedule: string;
  attemptCount: number;
  maxAttempts: number;
  lastError: string | null;
  externalPostId: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface PublishLog {
  id: string;
  workspaceId: string;
  publishJobId: string;
  attemptNumber: number;
  executionPath: PublishExecutionPath;
  resultStatus: PublishResultStatus;
  providerRequestId: string | null;
  evidenceRef: string | null;
  logPayload: Record<string, unknown>;
  createdAt: string;
}

export interface ManualExportPackage {
  publishItemId: string;
  platform: string;
  renderedVideoUrl: string;
  caption: string;
  hashtags: string[];
  instructions: string;
  checklist: string[];
  verificationUrl: string;
  generatedAt: string;
}

export interface ScheduleFairnessConfig {
  minJitterMs: number;
  maxJitterMs: number;
}

export interface UnknownSubmitReconciliationResult {
  reconciled: boolean;
  externalPostId?: string;
  status: 'published' | 'failed' | 'retry_pending';
  notes: string;
}
