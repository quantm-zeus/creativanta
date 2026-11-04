import { describe, expect, it, vi } from 'vitest';
import {
  calculateFairSchedule,
  validateScheduleTiming,
  reconcileUnknownSubmit,
  generateManualExportPackage,
  submitManualProof,
  handleTokenRevocation,
  PrematurePublishError,
  PublishValidationError
} from './publish_service';
import type { PublishItem, PublishJob } from './types';

describe('P5-01 Publish Hub Acceptance Targets (Web)', () => {
  const mockItem: PublishItem = {
    id: 'item_1001',
    workspaceId: 'ws_test_01',
    targetAccountId: 'acc_tiktok_main',
    targetChannelId: 'chan_main',
    platform: 'tiktok',
    mediaAssetId: 'media_asset_77',
    caption: 'Big summer sale! Check out new arrivals #deals #summersale',
    title: 'Summer Sale Promo',
    scheduleAt: '2026-11-04T12:00:00.000Z',
    status: 'scheduled',
    approvalStatus: 'approved',
    executionPath: 'native_api',
    createdAt: '2026-11-03T10:00:00.000Z',
    updatedAt: '2026-11-03T10:00:00.000Z'
  };

  const mockJob: PublishJob = {
    id: 'job_2001',
    workspaceId: 'ws_test_01',
    publishItemId: 'item_1001',
    targetAccountId: 'acc_tiktok_main',
    platform: 'tiktok',
    status: 'queued',
    diagnosticsState: 'healthy',
    scheduledFor: '2026-11-04T12:00:00.000Z',
    effectiveSchedule: '2026-11-04T12:00:15.000Z',
    attemptCount: 0,
    maxAttempts: 3,
    lastError: null,
    externalPostId: null,
    createdAt: '2026-11-03T10:00:00.000Z',
    updatedAt: '2026-11-03T10:00:00.000Z'
  };

  describe('Target 1: Never publish before schedule', () => {
    it('guarantees additive fairness jitter where effective schedule is >= scheduled time', () => {
      const scheduledTime = new Date('2026-11-04T12:00:00.000Z');

      for (let i = 0; i < 50; i++) {
        const { effectiveSchedule, jitterMs } = calculateFairSchedule(scheduledTime);
        expect(jitterMs).toBeGreaterThanOrEqual(0);
        expect(jitterMs).toBeLessThanOrEqual(30000);
        expect(effectiveSchedule.getTime()).toBeGreaterThanOrEqual(scheduledTime.getTime());
      }
    });

    it('strictly forbids dispatch when now < schedule_at', () => {
      const scheduledTime = new Date('2026-11-04T12:00:00.000Z');
      const prematureTime = new Date('2026-11-04T11:59:59.999Z');

      expect(() => {
        validateScheduleTiming(prematureTime, scheduledTime);
      }).toThrowError(PrematurePublishError);

      const arrivedTime = new Date('2026-11-04T12:00:00.000Z');
      expect(() => {
        validateScheduleTiming(arrivedTime, scheduledTime);
      }).not.toThrow();

      const laterTime = new Date('2026-11-04T12:00:15.000Z');
      expect(() => {
        validateScheduleTiming(laterTime, scheduledTime);
      }).not.toThrow();
    });
  });

  describe('Target 2: Unknown submit reconciles', () => {
    it('queries provider request ID and confirms post published if found remotely', async () => {
      const checkStatusMock = vi.fn().mockResolvedValue({
        found: true,
        externalPostId: 'tt_remote_987654'
      });

      const result = await reconcileUnknownSubmit({
        providerRequestId: 'req_tiktok_pending_01',
        checkStatus: checkStatusMock
      });

      expect(checkStatusMock).toHaveBeenCalledWith('req_tiktok_pending_01');
      expect(result.reconciled).toBe(true);
      expect(result.status).toBe('published');
      expect(result.externalPostId).toBe('tt_remote_987654');
    });

    it('marks retry_pending instead of duplicate posting when platform confirms post was not created', async () => {
      const checkStatusMock = vi.fn().mockResolvedValue({
        found: false
      });

      const result = await reconcileUnknownSubmit({
        providerRequestId: 'req_tiktok_dropped_02',
        checkStatus: checkStatusMock
      });

      expect(checkStatusMock).toHaveBeenCalledWith('req_tiktok_dropped_02');
      expect(result.reconciled).toBe(true);
      expect(result.status).toBe('retry_pending');
      expect(result.externalPostId).toBeUndefined();
    });

    it('fails closed when provider request ID is absent', async () => {
      const result = await reconcileUnknownSubmit({
        checkStatus: vi.fn()
      });

      expect(result.reconciled).toBe(false);
      expect(result.status).toBe('failed');
    });
  });

  describe('Target 3: Manual proof retains graph', () => {
    it('generates a full manual export package with parsed hashtags and platform checklist', () => {
      const pkg = generateManualExportPackage(mockItem, 'https://cdn.creativanta.test/renders/v1.mp4');

      expect(pkg.publishItemId).toBe('item_1001');
      expect(pkg.platform).toBe('tiktok');
      expect(pkg.renderedVideoUrl).toBe('https://cdn.creativanta.test/renders/v1.mp4');
      expect(pkg.hashtags).toEqual(['deals', 'summersale']);
      expect(pkg.caption).toBe('Big summer sale! Check out new arrivals');
      expect(pkg.checklist.length).toBeGreaterThan(2);
      expect(pkg.instructions).toContain('TikTok');
    });

    it('submits manual proof, retains publishItemId linkage, and updates status to published', () => {
      const { updatedItem, log } = submitManualProof(mockItem, {
        evidenceRef: 'https://www.tiktok.com/@brand/video/9988776655',
        operatorUserId: 'user_operator_42',
        notes: 'Verified live on TikTok mobile app'
      });

      expect(updatedItem.status).toBe('published');
      expect(updatedItem.executionPath).toBe('manual_upload');

      // Invariant: publish_log retains publishJobId / publishItemId reference
      expect(log.publishJobId).toBe(mockItem.id);
      expect(log.executionPath).toBe('manual_upload');
      expect(log.resultStatus).toBe('success');
      expect(log.evidenceRef).toBe('https://www.tiktok.com/@brand/video/9988776655');
      expect(log.logPayload.operatorUserId).toBe('user_operator_42');
    });

    it('rejects empty evidence reference', () => {
      expect(() => {
        submitManualProof(mockItem, { evidenceRef: '' });
      }).toThrowError(PublishValidationError);
    });
  });

  describe('Target 4: Token revoke pauses affected queued work', () => {
    it('fails executing job and pauses all queued jobs for the affected account without touching other accounts', () => {
      const pausedSet = new Set<string>();

      const job2: PublishJob = {
        ...mockJob,
        id: 'job_2002',
        targetAccountId: 'acc_tiktok_main',
        status: 'queued'
      };

      const jobOtherAccount: PublishJob = {
        ...mockJob,
        id: 'job_2003',
        targetAccountId: 'acc_youtube_creator',
        platform: 'youtube',
        status: 'queued'
      };

      const allJobs = [mockJob, job2, jobOtherAccount];

      const { failedJob, pausedJobs } = handleTokenRevocation(mockJob, allJobs, pausedSet);

      // 1. Executing job failed
      expect(failedJob.id).toBe('job_2001');
      expect(failedJob.status).toBe('failed');
      expect(failedJob.diagnosticsState).toBe('blocked');
      expect(failedJob.lastError).toContain('auth_revoked');

      // 2. Account is registered as paused
      expect(pausedSet.has('acc_tiktok_main')).toBe(true);

      // 3. job2 for same account is paused (blocked diagnostics state)
      expect(pausedJobs.length).toBe(1);
      expect(pausedJobs[0].id).toBe('job_2002');
      expect(pausedJobs[0].status).toBe('blocked');
      expect(pausedJobs[0].diagnosticsState).toBe('blocked');

      // 4. Other account job was NOT paused
      const otherPaused = pausedJobs.find((j) => j.id === 'job_2003');
      expect(otherPaused).toBeUndefined();
    });
  });
});
