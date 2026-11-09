import 'dart:convert';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/developer/api_key_models.dart';
import 'package:creativanta_mobile/generated/creativanta/platform/v1/public_api.pb.dart'
    as pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $timestamp;
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

    testWidgets(
        'DeveloperApiKeysView fails closed and refuses to mint fake ca_live_ secrets when backend RPC is unavailable',
        (WidgetTester tester) async {
      final unwiredNotifier = DeveloperStateNotifier(
        workspaceId: '22222222-2222-2222-2222-222222222201',
        initialTier: 'pro',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: DeveloperApiKeysView(notifier: unwiredNotifier),
        ),
      );

      await tester.tap(find.text('New Key'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(unwiredNotifier.keys, isEmpty);
      expect(find.text('DISPLAYED ONCE'), findsNothing);
      expect(find.byKey(const Key('developer-error-banner')), findsOneWidget);
      expect(find.textContaining('DEVELOPER_BACKEND_UNAVAILABLE'), findsOneWidget);
    });

    testWidgets(
        'DeveloperStateNotifier & DeveloperApiKeysView wire creativanta.platform.v1.APIKeyService and WebhookSubscriptionService',
        (WidgetTester tester) async {
      final calls = <Map<String, dynamic>>[];
      final wiredNotifier = DeveloperStateNotifier(
        workspaceId: '22222222-2222-2222-2222-222222222201',
        initialTier: 'pro',
        rpcCaller: (service, method, payload) async {
          calls.add({
            'service': service,
            'method': method,
            'payload': payload,
          });
          if (service == 'creativanta.platform.v1.APIKeyService' && method == 'Create') {
            return {
              'api_key': {
                'api_key_id': 'ak_server_901',
                'workspace_id': '22222222-2222-2222-2222-222222222201',
                'key_prefix': 'ca_live_sv',
                'name': payload['name'],
                'scopes': payload['scopes'],
                'status': 'API_KEY_STATUS_ACTIVE',
                'logical_key_id': 'lk_server_901',
              },
              'secret_key': 'ca_live_server_secret_901',
            };
          }
          if (service == 'creativanta.platform.v1.APIKeyService' && method == 'Rotate') {
            return {
              'old_key': {
                'api_key_id': 'ak_server_901',
                'status': 'API_KEY_STATUS_ROTATING',
              },
              'new_key': {
                'api_key_id': 'ak_server_902',
                'workspace_id': '22222222-2222-2222-2222-222222222201',
                'key_prefix': 'ca_live_rt',
                'name': 'Mobile Key (Rotated)',
                'scopes': ['read:content'],
                'status': 'API_KEY_STATUS_ACTIVE',
                'logical_key_id': 'lk_server_901',
              },
              'new_secret_key': 'ca_live_rotated_server_secret_902',
              'grace_ends_at': '2026-12-01T00:00:00Z',
            };
          }
          if (service == 'creativanta.platform.v1.WebhookSubscriptionService' &&
              method == 'CreateWebhookSubscription') {
            return {
              'subscription': {
                'webhook_subscription_id': 'wh_server_501',
                'workspace_id': '22222222-2222-2222-2222-222222222201',
                'target_url': payload['target_url'],
                'event_types': payload['event_types'],
                'status': 'WEBHOOK_SUBSCRIPTION_STATUS_ACTIVE',
                'consecutive_failure_count': 0,
              },
              'signing_secret': 'whsec_server_501',
            };
          }
          throw StateError('Unexpected RPC $service/$method');
        },
      );

      final whOutcome = await wiredNotifier.createWebhookSubscriptionRemote(
        targetUrl: 'https://hooks.partner.vn/events',
        eventTypes: ['order.created'],
      );
      expect(whOutcome.ok, isTrue);
      expect(whOutcome.data?.subscriptionId, equals('wh_server_501'));
      expect(whOutcome.data?.signingSecret, equals('whsec_server_501'));

      await tester.pumpWidget(
        MaterialApp(
          home: DeveloperApiKeysView(notifier: wiredNotifier),
        ),
      );

      await tester.tap(find.text('New Key'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(wiredNotifier.keys.length, equals(1));
      expect(find.text('DISPLAYED ONCE'), findsOneWidget);
      expect(find.text('ca_live_server_secret_901'), findsOneWidget);

      final rotateOutcome = await wiredNotifier.rotateKeyRemote('ak_server_901');
      expect(rotateOutcome.ok, isTrue);
      expect(rotateOutcome.data?.apiKeyId, equals('ak_server_902'));
      expect(rotateOutcome.data?.secretKey, equals('ca_live_rotated_server_secret_902'));
      expect(calls.length, equals(3));
    });

    test(
        'S8-F3 DeveloperStateNotifier decodes canonical ProtoJSON camelCase responses from Go handler (apiKey, secretKey, newKey, newSecretKey, webhookSubscriptionId, signingSecret, int64 string)',
        () async {
      final protoJsonNotifier = DeveloperStateNotifier(
        workspaceId: '22222222-2222-2222-2222-222222222201',
        initialTier: 'pro',
        rpcCaller: (service, method, payload) async {
          if (service == 'creativanta.platform.v1.APIKeyService' && method == 'Create') {
            // Exact Go protojson.Marshal output for CreateResponse
            return {
              'apiKey': {
                'apiKeyId': 'ak_protojson_101',
                'workspaceId': '22222222-2222-2222-2222-222222222201',
                'keyPrefix': 'ca_live_pj',
                'name': 'ProtoJSON Key',
                'scopes': ['read:content', 'write:content'],
                'status': 'API_KEY_STATUS_ACTIVE',
                'logicalKeyId': 'lk_protojson_101',
                'requestCount': '42',
                'expiresAt': '2027-02-05T18:00:00Z',
                'createdBy': 'usr_owner_01',
                'secretKey': 'ca_live_protojson_redacted_101',
              },
              'secretKey': 'ca_live_protojson_redacted_101',
            };
          }
          if (service == 'creativanta.platform.v1.APIKeyService' && method == 'Rotate') {
            // Exact Go protojson.Marshal output for RotateResponse
            return {
              'oldKey': {
                'apiKeyId': 'ak_protojson_101',
                'workspaceId': '22222222-2222-2222-2222-222222222201',
                'status': 'API_KEY_STATUS_ROTATING',
                'replacedByKeyId': 'ak_protojson_102',
                'rotationGraceEndsAt': '2026-11-08T18:00:00Z',
              },
              'newKey': {
                'apiKeyId': 'ak_protojson_102',
                'workspaceId': '22222222-2222-2222-2222-222222222201',
                'keyPrefix': 'ca_live_rt',
                'name': 'ProtoJSON Key (Rotated)',
                'scopes': ['read:content', 'write:content'],
                'status': 'API_KEY_STATUS_ACTIVE',
                'logicalKeyId': 'lk_protojson_101',
                'requestCount': '0',
                'expiresAt': '2027-02-05T18:00:00Z',
                'createdBy': 'usr_owner_01',
                'secretKey': 'ca_live_protojson_redacted_102',
              },
              'newSecretKey': 'ca_live_protojson_redacted_102',
              'graceEndsAt': '2026-11-08T18:00:00Z',
            };
          }
          if (service == 'creativanta.platform.v1.APIKeyService' && method == 'Revoke') {
            return {
              'apiKey': {
                'apiKeyId': 'ak_protojson_102',
                'workspaceId': '22222222-2222-2222-2222-222222222201',
                'status': 'API_KEY_STATUS_REVOKED',
              },
            };
          }
          if (service == 'creativanta.platform.v1.WebhookSubscriptionService' &&
              method == 'CreateWebhookSubscription') {
            // Exact Go protojson.Marshal output for CreateWebhookSubscriptionResponse
            return {
              'subscription': {
                'webhookSubscriptionId': 'wh_protojson_301',
                'workspaceId': '22222222-2222-2222-2222-222222222201',
                'targetUrl': 'https://hooks.creativanta.vn/protojson',
                'eventTypes': ['order.created', 'workflow.completed'],
                'status': 'WEBHOOK_SUBSCRIPTION_STATUS_ACTIVE',
                'consecutiveFailureCount': 0,
              },
              'signingSecret': 'whsec_protojson_redacted_301',
            };
          }
          throw StateError('Unexpected RPC $service/$method');
        },
      );

      final createRes = await protoJsonNotifier.createKeyRemote(
        name: 'ProtoJSON Key',
        scopes: ['read:content', 'write:content'],
      );
      expect(createRes.ok, isTrue, reason: createRes.message);
      expect(createRes.data?.apiKeyId, equals('ak_protojson_101'));
      expect(createRes.data?.keyPrefix, equals('ca_live_pj'));
      expect(createRes.data?.logicalKeyId, equals('lk_protojson_101'));
      expect(createRes.data?.requestCount, equals(42));
      expect(createRes.data?.secretKey, equals('ca_live_protojson_redacted_101'));

      final rotateRes = await protoJsonNotifier.rotateKeyRemote('ak_protojson_101');
      expect(rotateRes.ok, isTrue, reason: rotateRes.message);
      expect(rotateRes.data?.apiKeyId, equals('ak_protojson_102'));
      expect(rotateRes.data?.logicalKeyId, equals('lk_protojson_101'));
      expect(rotateRes.data?.secretKey, equals('ca_live_protojson_redacted_102'));

      final revokeRes = await protoJsonNotifier.revokeKeyRemote('ak_protojson_102');
      expect(revokeRes.ok, isTrue, reason: revokeRes.message);
      expect(revokeRes.data?.status, equals(ApiKeyStatus.revoked));

      final whRes = await protoJsonNotifier.createWebhookSubscriptionRemote(
        targetUrl: 'https://hooks.creativanta.vn/protojson',
        eventTypes: ['order.created', 'workflow.completed'],
      );
      expect(whRes.ok, isTrue, reason: whRes.message);
      expect(whRes.data?.subscriptionId, equals('wh_protojson_301'));
      expect(whRes.data?.signingSecret, equals('whsec_protojson_redacted_301'));
    });

    test(
        'T8-F3 DeveloperStateNotifier sends strict Proto3JSON requests (top-level workspace_id, no unknown fields) and round-trips generated protobuf toProto3Json() responses',
        () async {
      final strictNotifier = DeveloperStateNotifier(
        workspaceId: '22222222-2222-2222-2222-222222222201',
        initialTier: 'pro',
        rpcCaller: (service, method, payload) async {
          if (service == 'creativanta.platform.v1.APIKeyService' &&
              method == 'Create') {
            final req = pb.CreateRequest()
              ..mergeFromProto3Json(payload, ignoreUnknownFields: false);
            expect(
              req.workspaceId,
              equals('22222222-2222-2222-2222-222222222201'),
            );
            expect(req.name, equals('Strict Roundtrip Key'));
            expect(req.scopes, equals(['read:content', 'write:content']));

            final resp = pb.CreateResponse(
              apiKey: pb.APIKey(
                apiKeyId: 'ak_rt_001',
                workspaceId: req.workspaceId,
                keyPrefix: 'ca_live_rt',
                name: req.name,
                scopes: req.scopes,
                status: pb.APIKeyStatus.API_KEY_STATUS_ACTIVE,
                logicalKeyId: 'lk_rt_001',
                requestCount: Int64(19),
                expiresAt: $timestamp.Timestamp.fromDateTime(
                  DateTime.utc(2027, 3, 1, 12, 0),
                ),
                createdBy: 'usr_owner_01',
                secretKey: 'ca_live_rt_secret_001',
              ),
              secretKey: 'ca_live_rt_secret_001',
            );
            return jsonDecode(jsonEncode(resp.toProto3Json()))
                as Map<String, dynamic>;
          }

          if (service == 'creativanta.platform.v1.APIKeyService' &&
              method == 'Rotate') {
            final req = pb.RotateRequest()
              ..mergeFromProto3Json(payload, ignoreUnknownFields: false);
            expect(
              req.workspaceId,
              equals('22222222-2222-2222-2222-222222222201'),
            );
            expect(req.apiKeyId, equals('ak_rt_001'));

            final grace = $timestamp.Timestamp.fromDateTime(
              DateTime.utc(2026, 11, 10, 12, 0),
            );
            final resp = pb.RotateResponse(
              oldKey: pb.APIKey(
                apiKeyId: 'ak_rt_001',
                workspaceId: req.workspaceId,
                status: pb.APIKeyStatus.API_KEY_STATUS_ROTATING,
                replacedByKeyId: 'ak_rt_002',
                rotationGraceEndsAt: grace,
              ),
              newKey: pb.APIKey(
                apiKeyId: 'ak_rt_002',
                workspaceId: req.workspaceId,
                keyPrefix: 'ca_live_r2',
                name: 'Strict Roundtrip Key (Rotated)',
                scopes: ['read:content', 'write:content'],
                status: pb.APIKeyStatus.API_KEY_STATUS_ACTIVE,
                logicalKeyId: 'lk_rt_001',
                requestCount: Int64.ZERO,
                expiresAt: $timestamp.Timestamp.fromDateTime(
                  DateTime.utc(2027, 3, 1, 12, 0),
                ),
                createdBy: 'usr_owner_01',
                secretKey: 'ca_live_r2_secret_002',
              ),
              newSecretKey: 'ca_live_r2_secret_002',
              graceEndsAt: grace,
            );
            return jsonDecode(jsonEncode(resp.toProto3Json()))
                as Map<String, dynamic>;
          }

          if (service == 'creativanta.platform.v1.APIKeyService' &&
              method == 'Revoke') {
            final req = pb.RevokeRequest()
              ..mergeFromProto3Json(payload, ignoreUnknownFields: false);
            expect(
              req.workspaceId,
              equals('22222222-2222-2222-2222-222222222201'),
            );
            expect(req.apiKeyId, equals('ak_rt_002'));

            final resp = pb.RevokeResponse(
              apiKey: pb.APIKey(
                apiKeyId: 'ak_rt_002',
                workspaceId: req.workspaceId,
                status: pb.APIKeyStatus.API_KEY_STATUS_REVOKED,
              ),
            );
            return jsonDecode(jsonEncode(resp.toProto3Json()))
                as Map<String, dynamic>;
          }

          if (service ==
                  'creativanta.platform.v1.WebhookSubscriptionService' &&
              method == 'CreateWebhookSubscription') {
            final req = pb.CreateWebhookSubscriptionRequest()
              ..mergeFromProto3Json(payload, ignoreUnknownFields: false);
            expect(
              req.workspaceId,
              equals('22222222-2222-2222-2222-222222222201'),
            );
            expect(req.targetUrl, equals('https://hooks.creativanta.vn/rt'));
            expect(req.eventTypes, equals(['order.created']));

            final resp = pb.CreateWebhookSubscriptionResponse(
              subscription: pb.WebhookSubscription(
                webhookSubscriptionId: 'wh_rt_001',
                workspaceId: req.workspaceId,
                targetUrl: req.targetUrl,
                eventTypes: req.eventTypes,
                status: pb.WebhookSubscriptionStatus
                    .WEBHOOK_SUBSCRIPTION_STATUS_ACTIVE,
                consecutiveFailureCount: 0,
              ),
              signingSecret: 'whsec_rt_secret_001',
            );
            return jsonDecode(jsonEncode(resp.toProto3Json()))
                as Map<String, dynamic>;
          }

          throw StateError('Unexpected RPC $service/$method');
        },
      );

      final cRes = await strictNotifier.createKeyRemote(
        name: 'Strict Roundtrip Key',
        scopes: ['read:content', 'write:content'],
      );
      expect(cRes.ok, isTrue, reason: cRes.message);
      expect(cRes.data?.apiKeyId, equals('ak_rt_001'));
      expect(cRes.data?.requestCount, equals(19));
      expect(cRes.data?.secretKey, equals('ca_live_rt_secret_001'));

      final rRes = await strictNotifier.rotateKeyRemote('ak_rt_001');
      expect(rRes.ok, isTrue, reason: rRes.message);
      expect(rRes.data?.apiKeyId, equals('ak_rt_002'));
      expect(rRes.data?.secretKey, equals('ca_live_r2_secret_002'));

      final vRes = await strictNotifier.revokeKeyRemote('ak_rt_002');
      expect(vRes.ok, isTrue, reason: vRes.message);
      expect(vRes.data?.status, equals(ApiKeyStatus.revoked));

      final wRes = await strictNotifier.createWebhookSubscriptionRemote(
        targetUrl: 'https://hooks.creativanta.vn/rt',
        eventTypes: ['order.created'],
      );
      expect(wRes.ok, isTrue, reason: wRes.message);
      expect(wRes.data?.subscriptionId, equals('wh_rt_001'));
      expect(wRes.data?.signingSecret, equals('whsec_rt_secret_001'));
    });

    testWidgets(
        'T8-F4 DeveloperApiKeysView wipes revealed secret immediately when notifier.reset() is called on logout or session change',
        (WidgetTester tester) async {
      final resettableNotifier = DeveloperStateNotifier(
        workspaceId: '22222222-2222-2222-2222-222222222201',
        initialTier: 'pro',
        rpcCaller: (service, method, payload) async {
          return {
            'apiKey': {
              'apiKeyId': 'ak_f4_mob_01',
              'workspaceId': '22222222-2222-2222-2222-222222222201',
              'keyPrefix': 'ca_live_f4',
              'name': payload['name'],
              'scopes': payload['scopes'],
              'status': 'API_KEY_STATUS_ACTIVE',
              'logicalKeyId': 'lk_f4_mob_01',
            },
            'secretKey': 'ca_live_f4_mobile_secret_once',
          };
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: DeveloperApiKeysView(notifier: resettableNotifier),
        ),
      );

      await tester.tap(find.text('New Key'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(find.text('DISPLAYED ONCE'), findsOneWidget);
      expect(find.text('ca_live_f4_mobile_secret_once'), findsOneWidget);

      // Simulate logout / session reset
      resettableNotifier.reset();
      await tester.pumpAndSettle();

      expect(resettableNotifier.keys, isEmpty);
      expect(find.text('DISPLAYED ONCE'), findsNothing);
      expect(find.text('ca_live_f4_mobile_secret_once'), findsNothing);
    });
  });
}
