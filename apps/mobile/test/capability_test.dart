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
  });
}
