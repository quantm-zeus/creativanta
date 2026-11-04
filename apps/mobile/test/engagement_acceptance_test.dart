import 'package:creativanta_mobile/engagement/engagement_models.dart';
import 'package:creativanta_mobile/engagement/engagement_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('P5-02 Unified Inbox & Engagement Center Acceptance Targets (Mobile)', () {
    const service = EngagementService();
    final baseTime = DateTime.utc(2026, 11, 4, 10, 0, 0);

    final defaultAccount = ConnectedAccountModel(
      id: 'acc_mobile_01',
      workspaceId: 'ws_mobile_eng',
      platform: 'tiktok',
      accountName: '@creativanta_mobile',
      avatarUrl: 'https://cdn.example.com/avatar.png',
      badgeColor: '#FE2C55',
    );

    final defaultThread = ThreadModel(
      id: 'th_mobile_01',
      workspaceId: 'ws_mobile_eng',
      connectedAccountId: defaultAccount.id,
      sourcePlatform: 'tiktok',
      threadType: 'comment',
      status: 'active',
      intent: 'question',
      priority: 'normal',
      ownerUserId: 'user_agent_mobile',
      nextAction: 'Tư vấn giao hàng',
      messageCount: 2,
      lastActivityAt: baseTime,
      messagingWindowExpiresAt: baseTime.add(const Duration(hours: 24)),
      createdAt: baseTime,
      updatedAt: baseTime,
    );

    // ========================================================================
    // ACCEPTANCE TARGET 1: Messaging-Window Denial
    // ========================================================================
    test('Target 1: Enforce 24-hour reply window from customer inbound', () {
      // 1. Within 24-hour window (e.g. 5 hours later) -> Allowed
      final withinWindow = baseTime.add(const Duration(hours: 5));
      expect(defaultThread.isWindowOpen(withinWindow), isTrue);
      expect(
        defaultThread.remainingWindow(withinWindow),
        equals(const Duration(hours: 19)),
      );
      expect(
        () => service.validateCanSend(
          thread: defaultThread,
          account: defaultAccount,
          body: 'Dạ shop giao hàng trong 2 ngày nhé!',
          now: withinWindow,
        ),
        returnsNormally,
      );

      // 2. Exactly at expiration + 1 second -> Denied with MessagingWindowExpiredException
      final pastWindow = baseTime.add(const Duration(hours: 24, seconds: 1));
      expect(defaultThread.isWindowOpen(pastWindow), isFalse);
      expect(defaultThread.remainingWindow(pastWindow), equals(Duration.zero));
      expect(
        () => service.validateCanSend(
          thread: defaultThread,
          account: defaultAccount,
          body: 'Shop vẫn còn hàng nhé!',
          now: pastWindow,
        ),
        throwsA(isA<MessagingWindowExpiredException>()),
      );

      // 3. Inbound re-engagement refreshes window
      final refreshedThread = defaultThread.copyWith(
        messagingWindowExpiresAt: pastWindow.add(const Duration(hours: 24)),
      );
      expect(refreshedThread.isWindowOpen(pastWindow), isTrue);
    });

    // ========================================================================
    // ACCEPTANCE TARGET 2: Bot-Loop & Viral Surge Handling
    // ========================================================================
    test('Target 2: Bot-loop circuit breaker blocks auto-reply but allows human reply', () {
      final loopPausedThread = defaultThread.copyWith(autoReplyPaused: true);
      expect(loopPausedThread.isBotLoopBlocked, isTrue);

      // Auto-reply must be blocked
      expect(
        () => service.validateCanSend(
          thread: loopPausedThread,
          account: defaultAccount,
          body: 'Auto greeting reply',
          isAutoReply: true,
          now: baseTime.add(const Duration(minutes: 5)),
        ),
        throwsA(isA<EngagementValidationException>()),
      );

      // Human operator reply is allowed
      expect(
        () => service.validateCanSend(
          thread: loopPausedThread,
          account: defaultAccount,
          body: 'Chào bạn, tôi là nhân viên hỗ trợ.',
          isAutoReply: false,
          now: baseTime.add(const Duration(minutes: 5)),
        ),
        returnsNormally,
      );
    });

    test('Target 2: Viral surge throttle levels without pausing SLA', () {
      // Normal: <100 msg/min
      final normal = service.getSurgeStatus('NORMAL', 50);
      expect(normal['level'], equals('none'));
      expect(normal['aiActive'], isTrue);

      // Throttled: 100-500 msg/min
      final throttled = service.getSurgeStatus('THROTTLED', 250);
      expect(throttled['level'], equals('warning'));
      expect(throttled['aiActive'], isFalse);

      // Circuit breaker: >500 msg/min (raw ingest only, SLA continues)
      final circuit = service.getSurgeStatus('CIRCUIT_BREAKER', 800);
      expect(circuit['level'], equals('circuit_breaker'));
      expect(circuit['aiActive'], isFalse);
      expect(circuit['rawIngestOnly'], isTrue);
      expect(circuit['message'], contains('đảm bảo SLA'));
    });

    // ========================================================================
    // ACCEPTANCE TARGET 3: Ghost Messages & Revoked Account Repair
    // ========================================================================
    test('Target 3: Ghost message disabled compose with WHAT-WHY-NEXT copy', () {
      final ghostThread = defaultThread.copyWith(
        isGhost: true,
        ghostStatus: 'deleted_by_user',
      );
      expect(ghostThread.isGhostBlocked, isTrue);

      // Compose validation throws
      expect(
        () => service.validateCanSend(
          thread: ghostThread,
          account: defaultAccount,
          body: 'Shop phản hồi',
          now: baseTime.add(const Duration(minutes: 2)),
        ),
        throwsA(isA<EngagementValidationException>()),
      );

      // WHAT-WHY-NEXT notice is properly formed
      final notice = service.getGhostNotice(ghostThread);
      expect(notice, isNotNull);
      expect(notice!.what, contains('người dùng xóa'));
      expect(notice.why, contains('404/410'));
      expect(notice.next, contains('Hộp soạn phản hồi bị khóa'));
    });

    test('Target 3: Revoked account blocks reply and provides reconnect notice', () {
      final revokedThread = defaultThread.copyWith(accountRevoked: true);
      expect(
        () => service.validateCanSend(
          thread: revokedThread,
          account: defaultAccount,
          body: 'Shop phản hồi',
          now: baseTime.add(const Duration(minutes: 2)),
        ),
        throwsA(isA<AccountRevokedException>()),
      );

      final notice = service.getRevokedAccountNotice(revokedThread, defaultAccount);
      expect(notice, isNotNull);
      expect(notice!['action'], contains('kết nối lại'));
    });

    // ========================================================================
    // Swipe Triage & RULE-M12-003 State Machine
    // ========================================================================
    test('Mobile swipe actions: archive and snooze transitions', () {
      // Archive
      final archived = service.swipeArchive(defaultThread, baseTime);
      expect(archived.status, equals('archived'));

      // Snooze for 4 hours
      final snoozed = service.swipeSnooze(
        defaultThread,
        const Duration(hours: 4),
        baseTime,
      );
      expect(snoozed.status, equals('snoozed'));
      expect(snoozed.slaDueAt, equals(baseTime.add(const Duration(hours: 4))));

      // Valid transitions
      expect(service.validateStatusTransition('new', 'triaged'), isTrue);
      expect(service.validateStatusTransition('new', 'active'), isTrue);
      expect(service.validateStatusTransition('new', 'resolved'), isFalse);
      expect(service.validateStatusTransition('archived', 'active'), isFalse);
    });
  });
}
