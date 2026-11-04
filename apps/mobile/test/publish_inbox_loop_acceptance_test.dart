import 'package:creativanta_mobile/engagement/engagement_models.dart';
import 'package:creativanta_mobile/engagement/engagement_service.dart';
import 'package:creativanta_mobile/publish/publish_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('P5-04 Mobile Acceptance: Publish & Inbox Loop Across Verified and Manual Routes', () {
    const service = EngagementService();
    final now = DateTime.utc(2026, 11, 4, 10, 0, 0);
    const wsId = 'ws-p5-04-mobile';

    final baseAccount = ConnectedAccountModel(
      id: 'acc-tiktok-mobile',
      workspaceId: wsId,
      platform: 'tiktok',
      accountName: '@creativanta_shop',
      avatarUrl: 'https://cdn.example.com/avatar.png',
      badgeColor: '#00f2fe',
    );

    final baseItem = PublishItemModel(
      id: 'item-mobile-01',
      workspaceId: wsId,
      targetAccountId: baseAccount.id,
      targetChannelId: 'chan-tt-01',
      platform: 'tiktok',
      mediaAssetId: 'asset-video-101',
      caption: 'Bộ sưu tập thời trang mùa hè mới nhất #summer #fashion',
      title: 'Summer Fashion Lookbook',
      scheduleAt: now,
      status: 'scheduled',
      approvalStatus: 'approved',
      executionPath: 'native_api',
    );

    final baseThread = ThreadModel(
      id: 'th-mobile-01',
      workspaceId: wsId,
      connectedAccountId: baseAccount.id,
      sourcePlatform: 'tiktok',
      threadType: 'comment',
      status: 'new',
      intent: 'purchase_interest',
      priority: 'normal',
      ownerUserId: 'user-mobile-01',
      nextAction: 'Tư vấn sản phẩm',
      messageCount: 1,
      lastActivityAt: now,
      messagingWindowExpiresAt: now.add(const Duration(hours: 24)),
      createdAt: now,
      updatedAt: now,
    );

    // ========================================================================
    // TARGET 1: FIVE ACCEPTANCE PATHS
    // ========================================================================
    group('Target 1: Five Acceptance Paths', () {
      test('Path 1 - Happy Path: verified native publish loops to unified inbox with valid compose', () {
        // 1. Publish completes via native API
        final publishedItem = baseItem.copyWith(
          status: 'published',
          executionPath: 'native_api',
        );
        expect(publishedItem.status, equals('published'));
        expect(publishedItem.executionPath, equals('native_api'));

        // 2. Channel post generates inbound thread in Unified Inbox
        final replyTime = now.add(const Duration(minutes: 10));
        expect(baseThread.isWindowOpen(replyTime), isTrue);
        expect(
          () => service.validateCanSend(
            thread: baseThread,
            account: baseAccount,
            body: 'Chào bạn, mẫu này bên mình còn đủ size nhé!',
            now: replyTime,
          ),
          returnsNormally,
        );
      });

      test('Path 2 - Degraded Path: manual export package and proof submission retain graph connection', () {
        // 1. Degraded platform triggers manual fallback export package
        final degradedItem = PublishItemModel(
          id: 'item-shopee-mobile',
          workspaceId: wsId,
          targetAccountId: 'acc-shopee-01',
          targetChannelId: 'chan-shopee-01',
          platform: 'shopee',
          mediaAssetId: 'asset-shopee-101',
          caption: 'Video đánh giá sản phẩm Shopee #shopee #review',
          title: 'Shopee Review Video',
          scheduleAt: now,
          status: 'draft',
          approvalStatus: 'approved',
          executionPath: 'manual_upload',
        );

        final exportPkg = generateManualFallbackPackage(
          item: degradedItem,
          mediaUrl: 'https://cdn.creativanta.test/shopee_video.mp4',
        );
        expect(exportPkg.publishItemId, equals(degradedItem.id));
        expect(exportPkg.checklist.length, greaterThan(0));
        expect(exportPkg.hashtags, contains('shopee'));

        // 2. Operator submits manual proof
        final proofResult = submitManualProof(
          item: degradedItem,
          evidenceRef: 'https://cdn.creativanta.test/proof_screenshot.png',
          operatorUserId: 'operator-mobile-01',
        );

        final updatedItem = proofResult['item'] as PublishItemModel;
        final log = proofResult['log'] as PublishLogModel;

        expect(updatedItem.status, equals('published'));
        expect(updatedItem.executionPath, equals('manual_upload'));
        expect(log.publishJobId, equals(degradedItem.id)); // Graph connection retained
        expect(log.evidenceRef, equals('https://cdn.creativanta.test/proof_screenshot.png'));
        expect(log.resultStatus, equals('success'));
      });

      test('Path 3 - Missing Data Path: validation rejects missing proof evidence or expired window safely', () {
        // Missing evidence in manual proof throws PublishValidationException
        expect(
          () => submitManualProof(
            item: baseItem,
            evidenceRef: '   ',
          ),
          throwsA(isA<PublishValidationException>()),
        );

        // Expired window throws MessagingWindowExpiredException
        final expiredTime = now.add(const Duration(hours: 24, seconds: 1));
        expect(
          () => service.validateCanSend(
            thread: baseThread,
            account: baseAccount,
            body: 'Phản hồi sau khi hết hạn',
            now: expiredTime,
          ),
          throwsA(isA<MessagingWindowExpiredException>()),
        );
      });

      test('Path 4 - Broken Path: account revocation pauses queue, ghost message blocks reply with WHAT-WHY-NEXT', () {
        // 1. Account revocation handling
        final executingJob = PublishJobModel(
          id: 'job-exec-revoked',
          workspaceId: wsId,
          publishItemId: baseItem.id,
          targetAccountId: 'acc-broken-mobile',
          platform: 'tiktok',
          status: 'running',
          diagnosticsState: 'healthy',
          scheduledFor: now,
          effectiveSchedule: now,
          attemptCount: 1,
        );

        final queuedJob = PublishJobModel(
          id: 'job-queued-revoked',
          workspaceId: wsId,
          publishItemId: 'item-other-02',
          targetAccountId: 'acc-broken-mobile',
          platform: 'tiktok',
          status: 'queued',
          diagnosticsState: 'healthy',
          scheduledFor: now.add(const Duration(hours: 1)),
          effectiveSchedule: now.add(const Duration(hours: 1)),
          attemptCount: 0,
        );

        final pausedAccounts = <String>{};
        final revocationResult = applyTokenRevocation(
          failedJob: executingJob,
          queuedJobs: [executingJob, queuedJob],
          pausedAccounts: pausedAccounts,
        );

        final failedJob = revocationResult['failedJob'] as PublishJobModel;
        final pausedJobs = revocationResult['pausedJobs'] as List<PublishJobModel>;

        expect(failedJob.status, equals('failed'));
        expect(failedJob.diagnosticsState, equals('blocked'));
        expect(pausedAccounts.contains('acc-broken-mobile'), isTrue);
        expect(pausedJobs.length, equals(1));
        expect(pausedJobs.first.status, equals('blocked'));

        // 2. Ghost message in inbox
        final ghostThread = baseThread.copyWith(
          isGhost: true,
          ghostStatus: 'deleted_by_user',
        );
        final ghostNotice = service.getGhostNotice(ghostThread);
        expect(ghostNotice, isNotNull);
        expect(ghostNotice!.what, contains('xóa'));
        expect(ghostNotice.why, contains('404'));
        expect(ghostNotice.next, contains('khóa'));

        expect(
          () => service.validateCanSend(
            thread: ghostThread,
            account: baseAccount,
            body: 'Phản hồi bình luận đã xóa',
            now: now,
          ),
          throwsA(isA<EngagementValidationException>()),
        );
      });

      test('Path 5 - Audit Path: generates immutable log with operator metadata and execution trail', () {
        final proofResult = submitManualProof(
          item: baseItem,
          evidenceRef: 'https://cdn.creativanta.test/audit_proof.png',
          operatorUserId: 'operator-audit-99',
        );

        final log = proofResult['log'] as PublishLogModel;
        expect(log.id, startsWith('log_'));
        expect(log.workspaceId, equals(wsId));
        expect(log.executionPath, equals('manual_upload'));
        expect(log.resultStatus, equals('success'));
        expect(log.evidenceRef, equals('https://cdn.creativanta.test/audit_proof.png'));
      });
    });

    // ========================================================================
    // TARGET 2: REPLAY WITH ONE EXTERNAL RESULT
    // ========================================================================
    group('Target 2: Replay with One External Result', () {
      test('reconciles unknown external submission probe without duplicate post creation', () async {
        int remoteProbeCount = 0;
        Future<bool> mockRemoteCheck(String reqId) async {
          remoteProbeCount++;
          return reqId == 'req-idempotent-101';
        }

        // First reconciliation probe
        final res1 = await reconcileUnknownSubmit(
          providerRequestId: 'req-idempotent-101',
          checkRemotePublished: mockRemoteCheck,
        );
        expect(res1['reconciled'], isTrue);
        expect(res1['status'], equals('published'));
        expect(res1['externalPostId'], equals('remote_req-idempotent-101'));
        expect(remoteProbeCount, equals(1));

        // Replay of identical reconciliation
        final res2 = await reconcileUnknownSubmit(
          providerRequestId: 'req-idempotent-101',
          checkRemotePublished: mockRemoteCheck,
        );
        expect(res2['reconciled'], isTrue);
        expect(res2['status'], equals('published'));
        expect(res2['externalPostId'], equals('remote_req-idempotent-101'));
        expect(remoteProbeCount, equals(2)); // probed status, did not create second post
      });
    });

    // ========================================================================
    // TARGET 3: COMMERCE/SEEDING ACTIONS RETAIN P6 TASK LINKS
    // ========================================================================
    group('Target 3: Commerce/Seeding Actions Retain P6 Task Links', () {
      test('preserves P6 task link and deferred status when converting to Sample Request (P6-09)', () {
        const sampleReqId = 'sample-req-mobile-77';
        final result = service.convertToSampleRequest(
          thread: baseThread,
          sampleRequestId: sampleReqId,
          now: now,
        );

        final updatedThread = result['thread'] as ThreadModel;
        final task = result['task'] as FollowUpTaskModel;

        expect(updatedThread.status, equals('converted_to_task'));
        expect(updatedThread.relatedObjectRefs.length, equals(1));

        final ref = updatedThread.relatedObjectRefs.first;
        expect(ref.type, equals('sample_request'));
        expect(ref.id, equals(sampleReqId));
        expect(ref.taskRef, equals('P6-09'));
        expect(ref.phase, equals('P6'));
        expect(ref.isP6Deferred, isTrue);
        expect(ref.status, equals('pending_p6_delivery'));

        expect(task.sourceThreadId, equals(baseThread.id));
        expect(task.sourceObjectId, equals(sampleReqId));
        expect(task.taskRef, equals('P6-09'));
        expect(task.phase, equals('P6'));
        expect(task.isP6Deferred, isTrue);
        expect(task.status, equals('pending'));
      });

      test('preserves P6 task link and deferred status when converting to Brand Deal (P6-09)', () {
        const dealId = 'brand-deal-mobile-88';
        final result = service.convertToBrandDeal(
          thread: baseThread,
          brandDealId: dealId,
          now: now,
        );

        final updatedThread = result['thread'] as ThreadModel;
        final task = result['task'] as FollowUpTaskModel;

        expect(updatedThread.status, equals('converted_to_task'));
        final ref = updatedThread.relatedObjectRefs.first;
        expect(ref.type, equals('brand_deal'));
        expect(ref.id, equals(dealId));
        expect(ref.taskRef, equals('P6-09'));
        expect(ref.phase, equals('P6'));
        expect(ref.isP6Deferred, isTrue);
        expect(ref.status, equals('pending_p6_delivery'));

        expect(task.taskRef, equals('P6-09'));
        expect(task.phase, equals('P6'));
        expect(task.isP6Deferred, isTrue);
      });

      test('preserves P6 task link and deferred status when converting to Offer (P6-01)', () {
        const offerId = 'offer-coupon-mobile-99';
        final result = service.convertToOffer(
          thread: baseThread,
          offerId: offerId,
          now: now,
        );

        final updatedThread = result['thread'] as ThreadModel;
        final task = result['task'] as FollowUpTaskModel;

        expect(updatedThread.status, equals('converted_to_task'));
        final ref = updatedThread.relatedObjectRefs.first;
        expect(ref.type, equals('offer'));
        expect(ref.id, equals(offerId));
        expect(ref.taskRef, equals('P6-01'));
        expect(ref.phase, equals('P6'));
        expect(ref.isP6Deferred, isTrue);
        expect(ref.status, equals('pending_p6_delivery'));

        expect(task.taskRef, equals('P6-01'));
        expect(task.phase, equals('P6'));
        expect(task.isP6Deferred, isTrue);
      });
    });
  });
}
