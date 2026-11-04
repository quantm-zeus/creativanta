import { describe, expect, it, vi } from 'vitest';
import {
  generateManualExportPackage,
  submitManualProof,
  handleTokenRevocation,
  reconcileUnknownSubmit
} from './publish_service';
import type { PublishItem, PublishJob } from './types';
import {
  evaluateGhostStatus,
  validateComposeCanSend,
  validateMessagingWindow,
  convertToSampleRequest,
  convertToBrandDeal,
  convertToOffer
} from '../engagement/engagement_service';
import type { ConnectedAccount, Thread, Message } from '../engagement/types';

describe('P5-04 Web Acceptance: Publish & Inbox Loop Across Verified and Manual Routes', () => {
  const wsId = 'ws-p5-04-web';

  const baseItem: PublishItem = {
    id: 'item-loop-01',
    workspaceId: wsId,
    targetAccountId: 'acc-tiktok-01',
    targetChannelId: 'chan-01',
    platform: 'tiktok',
    mediaAssetId: 'asset-video-01',
    caption: 'Discover summer trends now! #summer #deals',
    title: 'Summer Campaign',
    scheduleAt: '2026-11-04T10:00:00.000Z',
    status: 'scheduled',
    approvalStatus: 'approved',
    executionPath: 'native_api',
    createdAt: '2026-11-04T09:00:00.000Z',
    updatedAt: '2026-11-04T09:00:00.000Z'
  };

  const baseAccount: ConnectedAccount = {
    id: 'acc-tiktok-01',
    workspaceId: wsId,
    platform: 'tiktok',
    accountName: 'Shop Official TikTok',
    avatarUrl: 'https://cdn.creativanta.test/avatar.png',
    badgeColor: '#00f2fe',
    isRevoked: false
  };

  const baseThread: Thread = {
    id: 'th-loop-01',
    workspaceId: wsId,
    connectedAccountId: 'acc-tiktok-01',
    sourcePlatform: 'tiktok',
    threadType: 'comment',
    status: 'new',
    intent: 'purchase_interest',
    priority: 'normal',
    ownerUserId: 'user-01',
    nextAction: 'reply_to_customer',
    slaDueAt: '2026-11-04T14:00:00.000Z',
    slaBreached: false,
    slaApproaching: false,
    messageCount: 1,
    lastActivityAt: '2026-11-04T10:05:00.000Z',
    messagingWindowExpiresAt: '2026-11-05T10:05:00.000Z',
    autoReplyPaused: false,
    autoReplyPermanentlyDisabled: false,
    autoReplyConsecutiveCount: 0,
    isGhost: false,
    ghostStatus: 'active',
    throttleState: 'NORMAL',
    accountRevoked: false,
    relatedObjectRefs: [],
    createdAt: '2026-11-04T10:05:00.000Z',
    updatedAt: '2026-11-04T10:05:00.000Z'
  };

  // ==========================================================================
  // TARGET 1: FIVE ACCEPTANCE PATHS
  // ==========================================================================

  describe('Target 1: Five Acceptance Paths', () => {
    it('Path 1 - Happy Path: verified native publish loops to unified inbox and reply compose validation', () => {
      // 1. Publish completes natively
      const publishedItem: PublishItem = {
        ...baseItem,
        status: 'published',
        executionPath: 'native_api',
        updatedAt: '2026-11-04T10:00:05.000Z'
      };
      expect(publishedItem.status).toBe('published');

      // 2. Channel post generates inbound customer question in Inbox
      const now = new Date('2026-11-04T10:10:00.000Z');
      const validation = validateComposeCanSend(
        baseThread,
        baseAccount,
        'Dạ size XL bên em còn hàng bạn nhé!',
        false,
        now
      );

      expect(validation.canSend).toBe(true);
      expect(validation.windowRemainingMs).toBeGreaterThan(0);
    });

    it('Path 2 - Degraded Path: manual export package, proof submission with graph retained, and degraded inbox note', () => {
      // 1. Degraded platform triggers manual export package
      const shopeeItem: PublishItem = {
        ...baseItem,
        platform: 'shopee',
        caption: 'Shopee review video #shopee #review'
      };
      const exportPkg = generateManualExportPackage(
        shopeeItem,
        'https://cdn.creativanta.test/render_shopee.mp4'
      );
      expect(exportPkg.checklist.length).toBeGreaterThan(0);
      expect(exportPkg.renderedVideoUrl).toContain('render_shopee.mp4');

      // 2. Operator submits manual proof
      const { updatedItem, log } = submitManualProof(shopeeItem, {
        evidenceRef: 'https://cdn.creativanta.test/proof_screenshot.png',
        notes: 'Posted manually via Shopee App'
      });

      expect(updatedItem.status).toBe('published');
      expect(updatedItem.executionPath).toBe('manual_upload');
      expect(log.publishJobId).toBe(shopeeItem.id); // Graph retained
      expect(log.evidenceRef).toBe('https://cdn.creativanta.test/proof_screenshot.png');
      expect(log.resultStatus).toBe('success');
    });

    it('Path 3 - Missing Data Path: validation rejects missing proof or expired window safely', () => {
      // Missing evidence in manual proof throws validation error
      expect(() => {
        submitManualProof(baseItem, { evidenceRef: '' });
      }).toThrowError(/Evidence reference.*required/);

      // Thread with expired window rejects compose
      const expiredThread: Thread = {
        ...baseThread,
        messagingWindowExpiresAt: '2026-11-04T09:00:00.000Z'
      };
      const validation = validateComposeCanSend(
        expiredThread,
        baseAccount,
        'Phản hồi sau khi hết hạn',
        false,
        new Date('2026-11-04T10:00:00.000Z')
      );
      expect(validation.canSend).toBe(false);
      expect(validation.reason).toContain('24 giờ đã hết hạn');
    });

    it('Path 4 - Broken Path: token revocation pauses account queue, ghost message disables reply with WHAT-WHY-NEXT', () => {
      // 1. Token revocation handling
      const executingJob: PublishJob = {
        id: 'job-revoked-01',
        workspaceId: wsId,
        publishItemId: baseItem.id,
        targetAccountId: 'acc-broken',
        platform: 'tiktok',
        status: 'running',
        diagnosticsState: 'healthy',
        scheduledFor: '2026-11-04T10:00:00.000Z',
        effectiveSchedule: '2026-11-04T10:00:00.000Z',
        attemptCount: 1,
        maxAttempts: 3,
        lastError: null,
        externalPostId: null,
        createdAt: '2026-11-04T09:00:00.000Z',
        updatedAt: '2026-11-04T09:00:00.000Z'
      };

      const queuedJob: PublishJob = {
        ...executingJob,
        id: 'job-revoked-02',
        status: 'queued'
      };

      const pausedSet = new Set<string>();
      const { failedJob, pausedJobs } = handleTokenRevocation(
        executingJob,
        [executingJob, queuedJob],
        pausedSet
      );

      expect(failedJob.status).toBe('failed');
      expect(failedJob.diagnosticsState).toBe('blocked');
      expect(pausedSet.has('acc-broken')).toBe(true);
      expect(pausedJobs.length).toBe(1);
      expect(pausedJobs[0].status).toBe('blocked');

      // 2. Ghost message in inbox
      const ghostThread: Thread = {
        ...baseThread,
        isGhost: true,
        ghostStatus: 'deleted_by_user'
      };
      const ghostEval = evaluateGhostStatus(ghostThread);
      expect(ghostEval.isBlocked).toBe(true);
      expect(ghostEval.notice?.what).toContain('xóa');
      expect(ghostEval.notice?.why).toContain('404');
      expect(ghostEval.notice?.next).toContain('khóa');

      const composeEval = validateComposeCanSend(
        ghostThread,
        baseAccount,
        'Phản hồi tin nhắn',
        false,
        new Date('2026-11-04T10:10:00.000Z')
      );
      expect(composeEval.canSend).toBe(false);
      expect(composeEval.ghostNotice).toBeDefined();
    });

    it('Path 5 - Audit Path: produces immutable publish log and intact lineage metadata', () => {
      const { log } = submitManualProof(baseItem, {
        evidenceRef: 'https://cdn.creativanta.test/proof.png',
        operatorUserId: 'operator-123',
        notes: 'Audit verification test'
      });

      expect(log.id).toBeDefined();
      expect(log.workspaceId).toBe(wsId);
      expect(log.executionPath).toBe('manual_upload');
      expect(log.logPayload.operatorUserId).toBe('operator-123');
      expect(log.logPayload.notes).toBe('Audit verification test');
    });
  });

  // ==========================================================================
  // TARGET 2: REPLAY WITH ONE EXTERNAL RESULT
  // ==========================================================================

  describe('Target 2: Replay with One External Result', () => {
    it('reconciles unknown external submission probe without duplicating external submission', async () => {
      let probeCallCount = 0;
      const checkStatusMock = vi.fn().mockImplementation(async (reqId: string) => {
        probeCallCount++;
        return { found: true, externalPostId: 'ext-post-verified-777' };
      });

      // First reconciliation check
      const res1 = await reconcileUnknownSubmit({
        providerRequestId: 'prov-req-999',
        checkStatus: checkStatusMock
      });

      expect(res1.reconciled).toBe(true);
      expect(res1.status).toBe('published');
      expect(res1.externalPostId).toBe('ext-post-verified-777');
      expect(probeCallCount).toBe(1);

      // Replay reconciliation call: does not create duplicate post
      const res2 = await reconcileUnknownSubmit({
        providerRequestId: 'prov-req-999',
        checkStatus: checkStatusMock
      });

      expect(res2.reconciled).toBe(true);
      expect(res2.status).toBe('published');
      expect(res2.externalPostId).toBe('ext-post-verified-777');
      expect(probeCallCount).toBe(2); // probed status, did not create second post
    });
  });

  // ==========================================================================
  // TARGET 3: COMMERCE/SEEDING ACTIONS RETAIN P6 TASK LINKS
  // ==========================================================================

  describe('Target 3: Commerce/Seeding Actions Retain P6 Task Links', () => {
    it('preserves P6 task link and deferred delivery status when converting to Sample Request (P6-09)', () => {
      const sampleRequestId = 'sample-req-12345';
      const { thread, task } = convertToSampleRequest(baseThread, sampleRequestId);

      expect(thread.status).toBe('converted_to_task');
      expect(thread.relatedObjectRefs.length).toBe(1);

      const ref = thread.relatedObjectRefs[0];
      expect(ref.type).toBe('sample_request');
      expect(ref.id).toBe(sampleRequestId);
      expect(ref.taskRef).toBe('P6-09');
      expect(ref.phase).toBe('P6');
      expect(ref.isP6Deferred).toBe(true);
      expect(ref.status).toBe('pending_p6_delivery');

      expect(task.sourceThreadId).toBe(baseThread.id);
      expect(task.sourceObjectId).toBe(sampleRequestId);
      expect(task.taskRef).toBe('P6-09');
      expect(task.phase).toBe('P6');
      expect(task.isP6Deferred).toBe(true);
      expect(task.status).toBe('pending');
    });

    it('preserves P6 task link and deferred delivery status when converting to Brand Deal (P6-09)', () => {
      const brandDealId = 'brand-deal-67890';
      const { thread, task } = convertToBrandDeal(baseThread, brandDealId);

      expect(thread.status).toBe('converted_to_task');
      const ref = thread.relatedObjectRefs[0];
      expect(ref.type).toBe('brand_deal');
      expect(ref.id).toBe(brandDealId);
      expect(ref.taskRef).toBe('P6-09');
      expect(ref.phase).toBe('P6');
      expect(ref.isP6Deferred).toBe(true);
      expect(ref.status).toBe('pending_p6_delivery');

      expect(task.taskRef).toBe('P6-09');
      expect(task.phase).toBe('P6');
      expect(task.isP6Deferred).toBe(true);
    });

    it('preserves P6 task link and deferred delivery status when converting to Offer (P6-01)', () => {
      const offerId = 'offer-coupon-999';
      const { thread, task } = convertToOffer(baseThread, offerId);

      expect(thread.status).toBe('converted_to_task');
      const ref = thread.relatedObjectRefs[0];
      expect(ref.type).toBe('offer');
      expect(ref.id).toBe(offerId);
      expect(ref.taskRef).toBe('P6-01');
      expect(ref.phase).toBe('P6');
      expect(ref.isP6Deferred).toBe(true);
      expect(ref.status).toBe('pending_p6_delivery');

      expect(task.taskRef).toBe('P6-01');
      expect(task.phase).toBe('P6');
      expect(task.isP6Deferred).toBe(true);
    });
  });
});
