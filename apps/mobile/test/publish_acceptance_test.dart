import 'package:creativanta_mobile/publish/publish_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('P5-01 Publish Hub Acceptance Targets (Mobile)', () {
    final DateTime scheduledTime = DateTime.utc(2026, 11, 3, 14, 0, 0);

    final item = PublishItemModel(
      id: 'pub_item_m01',
      workspaceId: 'ws_mobile_test',
      targetAccountId: 'acc_tiktok_01',
      targetChannelId: 'chan_tiktok_main',
      platform: 'tiktok',
      mediaAssetId: 'media_rendered_101',
      caption: 'Exclusive flash sale today only! #sale #flashdeal',
      title: 'Flash Sale Short',
      scheduleAt: scheduledTime,
      status: 'scheduled',
      approvalStatus: 'approved',
      executionPath: 'native_api',
    );

    final executingJob = PublishJobModel(
      id: 'job_m01',
      workspaceId: 'ws_mobile_test',
      publishItemId: item.id,
      targetAccountId: 'acc_tiktok_01',
      platform: 'tiktok',
      status: 'running',
      diagnosticsState: 'healthy',
      scheduledFor: scheduledTime,
      effectiveSchedule: scheduledTime.add(const Duration(seconds: 10)),
      attemptCount: 1,
    );

    test('Target 1: Never publish before schedule - fairness jitter is additive and rejects premature dispatch', () {
      // 1. Fairness jitter is non-negative and strictly >= schedule_at
      for (int i = 0; i < 30; i++) {
        final effective = calculateFairEffectiveSchedule(scheduledTime);
        expect(effective.isBefore(scheduledTime), isFalse);
      }

      // Explicit jitter test
      final effective15s = calculateFairEffectiveSchedule(scheduledTime, 15000);
      expect(effective15s, equals(scheduledTime.add(const Duration(seconds: 15))));

      // 2. Reject premature publish when now < schedule_at
      final prematureNow = DateTime.utc(2026, 11, 3, 13, 59, 59);
      expect(
        () => assertScheduleTimingAllowed(prematureNow, scheduledTime),
        throwsA(isA<PrematurePublishException>()),
      );

      // 3. Allow dispatch when now >= schedule_at
      expect(
        () => assertScheduleTimingAllowed(scheduledTime, scheduledTime),
        returnsNormally,
      );
      final laterNow = DateTime.utc(2026, 11, 3, 14, 0, 1);
      expect(
        () => assertScheduleTimingAllowed(laterNow, scheduledTime),
        returnsNormally,
      );
    });

    test('Target 2: Unknown submit reconciles via provider request ID without blind retry', () async {
      // 1. Reconcile as published when remote check confirms existence
      final foundResult = await reconcileUnknownSubmit(
        providerRequestId: 'req_tt_unknown_99',
        checkRemotePublished: (reqId) async => reqId == 'req_tt_unknown_99',
      );
      expect(foundResult['reconciled'], isTrue);
      expect(foundResult['status'], equals('published'));
      expect(foundResult['externalPostId'], equals('remote_req_tt_unknown_99'));

      // 2. Reconcile as safe retry_pending when remote check confirms not published
      final notFoundResult = await reconcileUnknownSubmit(
        providerRequestId: 'req_tt_dropped_88',
        checkRemotePublished: (reqId) async => false,
      );
      expect(notFoundResult['reconciled'], isTrue);
      expect(notFoundResult['status'], equals('retry_pending'));
      expect(notFoundResult['externalPostId'], isNull);

      // 3. Fails closed if request ID is missing
      final missingResult = await reconcileUnknownSubmit(
        providerRequestId: null,
        checkRemotePublished: (reqId) async => true,
      );
      expect(missingResult['reconciled'], isFalse);
      expect(missingResult['status'], equals('failed'));
    });

    test('Target 3: Manual proof retains graph connection and updates status to published', () {
      // 1. Generate fallback package
      final pkg = generateManualFallbackPackage(
        item: item,
        mediaUrl: 'https://cdn.creativanta.test/media_rendered_101.mp4',
      );
      expect(pkg.publishItemId, equals(item.id));
      expect(pkg.platform, equals('tiktok'));
      expect(pkg.hashtags, contains('sale'));
      expect(pkg.hashtags, contains('flashdeal'));
      expect(pkg.caption, equals('Exclusive flash sale today only!'));
      expect(pkg.checklist.length, greaterThanOrEqualTo(3));

      // 2. Submit manual proof
      final proofOutcome = submitManualProof(
        item: item,
        evidenceRef: 'https://www.tiktok.com/@shop/video/1234567890',
        operatorUserId: 'usr_operator_88',
      );

      final PublishItemModel updatedItem = proofOutcome['item'] as PublishItemModel;
      final PublishLogModel log = proofOutcome['log'] as PublishLogModel;

      expect(updatedItem.status, equals('published'));
      expect(updatedItem.executionPath, equals('manual_upload'));

      // Verify graph retention
      expect(log.publishJobId, equals(item.id));
      expect(log.executionPath, equals('manual_upload'));
      expect(log.resultStatus, equals('success'));
      expect(log.evidenceRef, equals('https://www.tiktok.com/@shop/video/1234567890'));

      // Reject empty evidence
      expect(
        () => submitManualProof(item: item, evidenceRef: '  '),
        throwsA(isA<PublishValidationException>()),
      );
    });

    test('Target 4: Token revoke pauses affected queued work for same account', () {
      final pausedAccounts = <String>{};

      final otherJobSameAccount = PublishJobModel(
        id: 'job_m02',
        workspaceId: 'ws_mobile_test',
        publishItemId: 'pub_item_m02',
        targetAccountId: 'acc_tiktok_01',
        platform: 'tiktok',
        status: 'queued',
        diagnosticsState: 'healthy',
        scheduledFor: scheduledTime.add(const Duration(hours: 1)),
        effectiveSchedule: scheduledTime.add(const Duration(hours: 1)),
        attemptCount: 0,
      );

      final otherAccountJob = PublishJobModel(
        id: 'job_m03',
        workspaceId: 'ws_mobile_test',
        publishItemId: 'pub_item_m03',
        targetAccountId: 'acc_instagram_99',
        platform: 'instagram',
        status: 'queued',
        diagnosticsState: 'healthy',
        scheduledFor: scheduledTime.add(const Duration(hours: 2)),
        effectiveSchedule: scheduledTime.add(const Duration(hours: 2)),
        attemptCount: 0,
      );

      final queuedJobs = [executingJob, otherJobSameAccount, otherAccountJob];

      final outcome = applyTokenRevocation(
        failedJob: executingJob,
        queuedJobs: queuedJobs,
        pausedAccounts: pausedAccounts,
      );

      final failedJob = outcome['failedJob'] as PublishJobModel;
      final pausedJobs = outcome['pausedJobs'] as List<PublishJobModel>;

      // Executing job failed
      expect(failedJob.id, equals(executingJob.id));
      expect(failedJob.status, equals('failed'));
      expect(failedJob.diagnosticsState, equals('blocked'));
      expect(failedJob.lastError, contains('auth_revoked'));

      // Target account added to paused set
      expect(pausedAccounts.contains('acc_tiktok_01'), isTrue);

      // Other job for same account is paused (status blocked)
      expect(pausedJobs.length, equals(1));
      expect(pausedJobs.first.id, equals('job_m02'));
      expect(pausedJobs.first.status, equals('blocked'));
      expect(pausedJobs.first.diagnosticsState, equals('blocked'));

      // Job for different account untouched
      final hasOtherAccount = pausedJobs.any((j) => j.targetAccountId == 'acc_instagram_99');
      expect(hasOtherAccount, isFalse);
    });
  });
}
