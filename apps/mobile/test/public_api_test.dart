import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/developer/api_key_models.dart';
import 'package:creativanta_mobile/ui/developer/developer_api_keys_view.dart';

void main() {
  group('P7-05 S24 Public API & Developer Platform Mobile Suite', () {
    late DeveloperStateNotifier notifier;

    setUp(() {
      notifier = DeveloperStateNotifier(
        workspaceId: '22222222-2222-2222-2222-222222222201',
        initialTier: 'pro',
      );
    });

    test('Acceptance Target 1: Read-only key cannot mutate', () {
      notifier.setTier('pro');
      final key = notifier.createKey(
        name: 'Mobile Read-Only Key',
        scopes: ['read:content', 'read:orders'],
      );

      expect(isReadOnlyScopes(key.scopes), isTrue);
      expect(canMutate('pro', key.scopes), isFalse);

      // Read call succeeds
      expect(
        () => notifier.executeApiCall(apiKeyId: key.apiKeyId, isMutation: false),
        returnsNormally,
      );

      // Mutating call MUST throw UnsupportedError
      expect(
        () => notifier.executeApiCall(apiKeyId: key.apiKeyId, isMutation: true),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('Starter tier restricts keys to read-only API access mode', () {
      notifier.setTier('starter');

      // Attempting to create key with write scopes on Starter tier throws UnsupportedError
      expect(
        () => notifier.createKey(
          name: 'Illegal Write Key',
          scopes: ['write:content'],
        ),
        throwsA(isA<UnsupportedError>()),
      );

      final key = notifier.createKey(
        name: 'Valid Starter Key',
        scopes: ['read:content'],
      );

      // Mutating call is blocked on Starter tier
      expect(
        () => notifier.executeApiCall(apiKeyId: key.apiKeyId, isMutation: true),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('Tier key capacities are strictly enforced', () {
      notifier.setTier('starter');

      // Starter allows max 3 keys
      notifier.createKey(name: 'Key 1', scopes: ['read:content']);
      notifier.createKey(name: 'Key 2', scopes: ['read:content']);
      notifier.createKey(name: 'Key 3', scopes: ['read:content']);

      expect(
        () => notifier.createKey(name: 'Key 4', scopes: ['read:content']),
        throwsA(isA<StateError>()),
      );

      // Upgrading to Pro increases capacity to 10
      notifier.setTier('pro');
      final key4 = notifier.createKey(name: 'Key 4', scopes: ['read:content']);
      expect(key4.status, equals(ApiKeyStatus.active));
    });

    test('Rotation supports 24h grace window where both keys are accepted', () {
      notifier.setTier('pro');
      final key = notifier.createKey(
        name: 'Deploy Key',
        scopes: ['read:content', 'write:content'],
      );

      notifier.rotateKey(key.apiKeyId);

      expect(notifier.keys.length, equals(2));
      final oldKey = notifier.keys.firstWhere((k) => k.apiKeyId == key.apiKeyId);
      final newKey = notifier.keys.firstWhere((k) => k.apiKeyId != key.apiKeyId);

      expect(oldKey.status, equals(ApiKeyStatus.rotating));
      expect(oldKey.rotationGraceEndsAt, isNotNull);
      expect(newKey.status, equals(ApiKeyStatus.active));

      // Both keys can make calls within the grace period
      expect(
        () => notifier.executeApiCall(apiKeyId: oldKey.apiKeyId, isMutation: true),
        returnsNormally,
      );
      expect(
        () => notifier.executeApiCall(apiKeyId: newKey.apiKeyId, isMutation: true),
        returnsNormally,
      );
    });

    test('Revoked key is immediately blocked from API calls', () {
      final key = notifier.createKey(
        name: 'Compromised Key',
        scopes: ['read:content'],
      );

      notifier.revokeKey(key.apiKeyId);
      expect(notifier.keys.first.status, equals(ApiKeyStatus.revoked));

      expect(
        () => notifier.executeApiCall(apiKeyId: key.apiKeyId, isMutation: false),
        throwsA(isA<StateError>()),
      );
    });

    test('Acceptance Target 2: Webhooks auto-suspend after 100 consecutive failures', () {
      final sub = notifier.createWebhookSubscription(
        targetUrl: 'https://test.app/webhook',
        eventTypes: ['workflow.completed', 'content.published'],
      );

      expect(sub.status, equals(WebhookStatus.active));

      // 99 failures -> remains active
      for (int i = 0; i < 99; i++) {
        notifier.recordWebhookDelivery(
          subscriptionId: sub.subscriptionId,
          success: false,
          errorMessage: '500 Internal Error',
        );
      }
      expect(notifier.webhooks.first.consecutiveFailureCount, equals(99));
      expect(notifier.webhooks.first.status, equals(WebhookStatus.active));

      // 100th consecutive failure -> auto-suspended (RULE-S24-006)
      notifier.recordWebhookDelivery(
        subscriptionId: sub.subscriptionId,
        success: false,
        errorMessage: '500 Internal Error',
      );
      expect(notifier.webhooks.first.consecutiveFailureCount, equals(100));
      expect(notifier.webhooks.first.status, equals(WebhookStatus.suspended));

      // Successful recovery resets counter
      notifier.recordWebhookDelivery(
        subscriptionId: sub.subscriptionId,
        success: true,
      );
      expect(notifier.webhooks.first.consecutiveFailureCount, equals(0));
    });

    testWidgets('DeveloperApiKeysView renders quota, keys, and webhooks',
        (WidgetTester tester) async {
      notifier.createKey(
        name: 'Production Worker Key',
        scopes: ['read:content', 'write:content'],
      );
      notifier.createWebhookSubscription(
        targetUrl: 'https://hook.client.io/events',
        eventTypes: ['workflow.completed'],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: DeveloperApiKeysView(notifier: notifier),
        ),
      );

      expect(find.text('Developer API & Webhooks (S24)'), findsOneWidget);
      expect(find.text('Monthly Quota & Limits'), findsOneWidget);
      expect(find.text('Production Worker Key'), findsOneWidget);
      expect(find.text('https://hook.client.io/events'), findsOneWidget);
      expect(find.text('New Key'), findsOneWidget);
    });
  });
}
