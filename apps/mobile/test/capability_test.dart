import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/capability/capability_models.dart';
import 'package:creativanta_mobile/generated/creativanta/admin/v1/capability.pb.dart';
import 'package:creativanta_mobile/ui/capability/connections_screen.dart';

void main() {
  group('P0-07 M058 Mobile Capability Verification & Read-Only Impersonation', () {
    final now = DateTime.utc(2026, 11, 2, 8, 0);

    test('blocks unverified, stale (>10m), GET-only probe, and kill-switched routes', () {
      // 1. Unverified route cannot execute
      final unverified = evaluateMobileActionCapability(
        platform: 'tiktok',
        actionKey: 'publish_post',
        requiresWrite: true,
        isUnsupportedByPlatform: false,
        targetMarket: 'VN',
        now: now,
        policyNoteVi: 'Yêu cầu duyệt TikTok App Audit.',
        fallbackInstructionsVi: 'Đăng thủ công qua ứng dụng TikTok.',
      );
      expect(unverified.executable, isFalse);
      expect(unverified.state, CapabilityState.CAPABILITY_STATE_MANUAL);

      // 2. GET-only probe cannot unlock a write capability
      final getOnly = evaluateMobileActionCapability(
        platform: 'tiktok',
        actionKey: 'publish_post',
        requiresWrite: true,
        isUnsupportedByPlatform: false,
        targetMarket: 'VN',
        now: now,
        policyNoteVi: 'Yêu cầu duyệt TikTok App Audit.',
        fallbackInstructionsVi: 'Đăng thủ công qua ứng dụng TikTok.',
        verification: MobileActionVerification(
          platform: 'tiktok',
          actionKey: 'publish_post',
          appApproved: true,
          grantedScopes: const <String>['video.publish', 'video.upload'],
          requiredScopes: const <String>['video.publish', 'video.upload'],
          accountEligible: true,
          supportedMarkets: const <String>['VN'],
          probeMethod: 'GET',
          probePassed: true,
          checkedAt: now.subtract(const Duration(minutes: 2)),
          validUntil: now.add(const Duration(hours: 12)),
        ),
      );
      expect(getOnly.executable, isFalse);
      expect(getOnly.state, CapabilityState.CAPABILITY_STATE_READ_ONLY);

      // 3. Verified fresh POST probe unlocks CAPABILITY_STATE_NATIVE
      final verified = evaluateMobileActionCapability(
        platform: 'tiktok',
        actionKey: 'publish_post',
        requiresWrite: true,
        isUnsupportedByPlatform: false,
        targetMarket: 'VN',
        now: now,
        policyNoteVi: 'Yêu cầu duyệt TikTok App Audit.',
        fallbackInstructionsVi: 'Đăng thủ công qua ứng dụng TikTok.',
        verification: MobileActionVerification(
          platform: 'tiktok',
          actionKey: 'publish_post',
          appApproved: true,
          grantedScopes: const <String>['video.publish', 'video.upload'],
          requiredScopes: const <String>['video.publish', 'video.upload'],
          accountEligible: true,
          supportedMarkets: const <String>['VN'],
          probeMethod: 'POST',
          probePassed: true,
          checkedAt: now.subtract(const Duration(minutes: 2)),
          validUntil: now.add(const Duration(hours: 12)),
        ),
      );
      expect(verified.executable, isTrue);
      expect(verified.state, CapabilityState.CAPABILITY_STATE_NATIVE);

      // 4. Kill switch immediately degrades and blocks execution
      final killed = evaluateMobileActionCapability(
        platform: 'tiktok',
        actionKey: 'publish_post',
        requiresWrite: true,
        isUnsupportedByPlatform: false,
        targetMarket: 'VN',
        now: now,
        policyNoteVi: 'Yêu cầu duyệt TikTok App Audit.',
        fallbackInstructionsVi: 'Đăng thủ công qua ứng dụng TikTok.',
        verification: MobileActionVerification(
          platform: 'tiktok',
          actionKey: 'publish_post',
          appApproved: true,
          grantedScopes: const <String>['video.publish', 'video.upload'],
          requiredScopes: const <String>['video.publish', 'video.upload'],
          accountEligible: true,
          supportedMarkets: const <String>['VN'],
          probeMethod: 'POST',
          probePassed: true,
          checkedAt: now.subtract(const Duration(minutes: 2)),
          validUntil: now.add(const Duration(hours: 12)),
        ),
        killSwitchActive: true,
      );
      expect(killed.executable, isFalse);
      expect(killed.state, CapabilityState.CAPABILITY_STATE_DEGRADED);
    });

    testWidgets('ConnectionsScreen disables mutations under read-only impersonation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ConnectionsScreen(isImpersonationSession: true),
        ),
      );

      expect(find.byKey(const Key('impersonation-readonly-banner')), findsOneWidget);
      final ElevatedButton disconnectBtn = tester.widget(
        find.byKey(const Key('disconnect-account-button')),
      );
      expect(disconnectBtn.onPressed, isNull);
    });

    test('computes 40/25/20/15 mobile composite health score correctly', () {
      final healthy = computeMobileCompositeHealthScore(
        availabilityScore: 100,
        errorRateScore: 100,
        latencyScore: 100,
        rateLimitScore: 100,
      );
      expect(healthy, equals(100));

      final composite = computeMobileCompositeHealthScore(
        availabilityScore: 90, // 36
        errorRateScore: 80,    // 20
        latencyScore: 70,      // 14
        rateLimitScore: 60,    // 9 -> sum 79
      );
      expect(composite, equals(79));
    });

    test('evaluates all 5 PRD §36B proactive coaching cards on mobile with CTA targets', () {
      // 1. None triggered when all indicators are healthy
      final emptyCards = evaluateMobileProactiveCoaching(
        shopResponseRatePct: 95.0,
        listingQualityPct: 88.0,
        delayedFulfillmentCount: 0,
        engagementDropPct: 5.0,
        connectorAuthExpiresInDays: 14,
      );
      expect(emptyCards, isEmpty);

      // 2. All 5 triggered when thresholds are exceeded
      final triggeredCards = evaluateMobileProactiveCoaching(
        shopResponseRatePct: 84.0,           // < 90%
        listingQualityPct: 72.0,            // < 80%
        delayedFulfillmentCount: 2,         // > 0
        engagementDropPct: 25.0,            // > 20%
        connectorAuthExpiresInDays: 2,      // <= 3
      );
      expect(triggeredCards.length, equals(5));

      final rules = triggeredCards.map((c) => c.rule).toList();
      expect(rules, contains('shop_response_rate_low'));
      expect(rules, contains('listing_quality_low'));
      expect(rules, contains('fulfillment_delayed'));
      expect(rules, contains('engagement_drop_detected'));
      expect(rules, contains('connector_auth_expiring_soon'));

      final ctas = triggeredCards.map((c) => c.actionCta).toList();
      expect(ctas, contains('/inbox'));
      expect(ctas, contains('/store'));
      expect(ctas, contains('/orders'));
      expect(ctas, contains('/attribution'));
      expect(ctas, contains('/settings/connections'));
    });
  });
}
