import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/support/support_models.dart';

void main() {
  group('P8-04 Support SLAs & Contracts (legal_compliance.md §7.2)', () {
    test('1. Calculates canonical support SLAs across all subscription tiers', () {
      final freeSLA = SupportSLA.calculate('free');
      expect(freeSLA.responseHours, 48);
      expect(freeSLA.resolutionHours, 120); // 5 days

      final starterSLA = SupportSLA.calculate('starter');
      expect(starterSLA.responseHours, 24);
      expect(starterSLA.resolutionHours, 72); // 3 days

      final proSLA = SupportSLA.calculate('pro');
      expect(proSLA.responseHours, 8);
      expect(proSLA.resolutionHours, 24); // 1 day

      final bizSLA = SupportSLA.calculate('business');
      expect(bizSLA.responseHours, 2);
      expect(bizSLA.resolutionHours, 8);

      final entSLA = SupportSLA.calculate('enterprise');
      expect(entSLA.responseHours, 1);
      expect(entSLA.resolutionHours, 4);
    });

    test('2. Accurately detects SLA breaches for response and resolution', () {
      final baseTime = DateTime.parse('2026-11-04T10:00:00Z');
      final ticket = SupportTicket(
        id: 't-001',
        ticketNumber: 'TICK-1001',
        workspaceId: 'ws-001',
        subject: 'Lỗi đồng bộ tồn kho Shopee',
        planTier: 'pro', // 8h response, 24h resolution
        createdAt: baseTime,
      );

      // Within SLA (<8h)
      final withinTime = baseTime.add(const Duration(hours: 5));
      expect(ticket.isResponseBreached(withinTime), isFalse);

      // Breached first response (>8h)
      final breachedResponseTime = baseTime.add(const Duration(hours: 9));
      expect(ticket.isResponseBreached(breachedResponseTime), isTrue);

      // First response provided at 4h (compliant)
      ticket.firstResponseAt = baseTime.add(const Duration(hours: 4));
      expect(ticket.isResponseBreached(breachedResponseTime), isFalse);

      // Resolution breached (>24h)
      final breachedResolutionTime = baseTime.add(const Duration(hours: 26));
      expect(ticket.isResolutionBreached(breachedResolutionTime), isTrue);

      // Ticket resolved at 20h (compliant)
      ticket.resolvedAt = baseTime.add(const Duration(hours: 20));
      expect(ticket.isResolutionBreached(breachedResolutionTime), isFalse);
    });

    test('3. Enforces strict internal note isolation for tenant workspace users', () {
      final ticket = SupportTicket(
        id: 't-002',
        ticketNumber: 'TICK-1002',
        workspaceId: 'ws-002',
        subject: 'Cần hỗ trợ hoá đơn VAT',
        planTier: 'business',
        messages: [
          TicketMessage(
            id: 'm-01',
            authorId: 'usr-1',
            authorRole: 'user',
            body: 'Nhờ xuất hoá đơn công ty.',
            isInternalNote: false,
          ),
          TicketMessage(
            id: 'm-02',
            authorId: 'admin-1',
            authorRole: 'admin',
            body: '[INTERNAL] Khách hàng VIP cần xử lý gấp.',
            isInternalNote: true, // INTERNAL NOTE
          ),
          TicketMessage(
            id: 'm-03',
            authorId: 'agent-1',
            authorRole: 'agent',
            body: 'Dạ chúng tôi đã tiếp nhận và đang tiến hành.',
            isInternalNote: false,
          ),
        ],
      );

      // Workspace sanitation
      final sanitized = ticket.sanitizeForWorkspace();
      expect(sanitized.messages.length, 2);
      expect(sanitized.messages.any((m) => m.isInternalNote), isFalse);
      expect(sanitized.messages.map((m) => m.body), contains('Nhờ xuất hoá đơn công ty.'));
      expect(sanitized.messages.map((m) => m.body), contains('Dạ chúng tôi đã tiếp nhận và đang tiến hành.'));
      expect(sanitized.messages.map((m) => m.body), isNot(contains('[INTERNAL] Khách hàng VIP cần xử lý gấp.')));
    });
  });

  group('P8-04 Beta Program & "Beta Grant Once" Guarantee (§4)', () {
    test('4. Enforces tier eligibility and awards bonus credits exactly once', () {
      final beta = BetaProgramManager();

      // Free tier rejected
      expect(
        () => beta.enroll('ws-free', 'free'),
        throwsA(isA<ArgumentError>()),
      );

      // First enrollment for Starter: granted 50 credits once!
      final res1 = beta.enroll('ws-starter', 'starter');
      expect(res1.success, isTrue);
      expect(res1.creditsAwarded, 50);
      expect(res1.enabledFlags, contains('beta_video_continuity'));
      expect(beta.isEnrolled('ws-starter'), isTrue);

      // Opt-out
      beta.optOut('ws-starter');
      expect(beta.isEnrolled('ws-starter'), isFalse);

      // Re-enrollment: features reactivated, but GRANTS 0 CREDITS!
      final res2 = beta.enroll('ws-starter', 'starter');
      expect(res2.success, isTrue);
      expect(res2.creditsAwarded, 0); // Strictly 0 credits!
      expect(res2.enabledFlags, contains('beta_video_continuity'));
      expect(beta.isEnrolled('ws-starter'), isTrue);
    });
  });

  group('P8-04 Status Monitor & Subscription Privacy (§5)', () {
    test('5. Enforces privacy-protected status subscriptions', () {
      final status = StatusPrivacyManager();
      final initialCount = status.subscriberCount;

      // Subscribe with sensitive email
      final token = status.subscribe('email', 'confidential-customer@enterprise.com');
      expect(token, startsWith('tok_priv_'));
      expect(token, isNot(contains('confidential-customer')));
      expect(status.subscriberCount, initialCount + 1);

      // Unsubscribe using privacy token
      final unSubSuccess = status.unsubscribe(token);
      expect(unSubSuccess, isTrue);
      expect(status.subscriberCount, initialCount);

      // Invalid token throws
      expect(
        () => status.unsubscribe('invalid_plain_email@test.com'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
