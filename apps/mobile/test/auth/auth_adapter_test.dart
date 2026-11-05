import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/auth/auth_models.dart';
import 'package:creativanta_mobile/auth/auth_provider_adapter.dart';

class _MockAuthHttpTransport implements AuthHttpTransport {
  final Map<String, AuthHttpResponse Function(Map<String, String>? headers, Map<String, dynamic>? body)> routes;

  _MockAuthHttpTransport(this.routes);

  @override
  Future<AuthHttpResponse> postJson(
    Uri uri, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final key = 'POST ${uri.path}';
    final handler = routes[key];
    if (handler == null) {
      return const AuthHttpResponse(statusCode: 404, body: '{"message":"Not Found"}');
    }
    return handler(headers, body);
  }
}

void main() {
  group('ClerkAuthProviderAdapter unconfigured fail-closed contract', () {
    late ClerkAuthProviderAdapter adapter;

    setUp(() {
      adapter = ClerkAuthProviderAdapter();
    });

    tearDown(() {
      adapter.dispose();
    });

    test('defaults to unconfigured status and documents external provider gate', () async {
      await adapter.initialize();
      expect(adapter.isConfigured, isFalse);
      expect(adapter.currentStatus, equals(AuthStatus.unconfigured));
      expect(adapter.currentSession, isNull);
      expect(adapter.externalGateDescription, contains('EXT-GATE-CLERK-MOBILE'));
    });

    test('signInWithEmailPassword fails closed with PROVIDER_UNAVAILABLE_001', () async {
      await adapter.initialize();
      final result = await adapter.signInWithEmailPassword(
        email: 'creator@creativanta.com',
        password: 'password123',
      );

      expect(result.isSuccess, isFalse);
      expect(result.failure, isNotNull);
      expect(result.failure!.code, equals('PROVIDER_UNAVAILABLE_001'));
      expect(result.failure!.externalGateRequired, isTrue);
      expect(adapter.currentStatus, equals(AuthStatus.unconfigured));
    });

    test('signInWithOAuth fails closed when unconfigured', () async {
      await adapter.initialize();
      final result = await adapter.signInWithOAuth(OAuthProvider.google);

      expect(result.isSuccess, isFalse);
      expect(result.failure!.code, equals('PROVIDER_UNAVAILABLE_001'));
      expect(result.failure!.externalGateRequired, isTrue);
    });

    test('refreshToken fails closed when unauthenticated', () async {
      final result = await adapter.refreshToken();
      expect(result.isSuccess, isFalse);
      expect(result.failure!.code, equals('AUTH_UNAUTHORIZED_001'));
    });

    test('signOut clears state and remains fail-closed unconfigured', () async {
      await adapter.signOut();
      expect(adapter.currentSession, isNull);
      expect(adapter.currentStatus, equals(AuthStatus.unconfigured));
    });
  });

  group('TestAuthProviderAdapter test double behavior', () {
    late TestAuthProviderAdapter adapter;

    setUp(() {
      adapter = TestAuthProviderAdapter();
    });

    tearDown(() {
      adapter.dispose();
    });

    test('handles authentication flow with test double session', () async {
      await adapter.initialize();
      expect(adapter.currentStatus, equals(AuthStatus.unauthenticated));

      // Test bad password rejection
      final badResult = await adapter.signInWithEmailPassword(
        email: 'user@example.com',
        password: 'wrong-password',
      );
      expect(badResult.isSuccess, isFalse);
      expect(badResult.failure!.code, equals('AUTH_UNAUTHORIZED_001'));
      expect(adapter.currentStatus, equals(AuthStatus.error));

      // Test successful sign-in
      final goodResult = await adapter.signInWithEmailPassword(
        email: 'user@example.com',
        password: 'correct-password',
      );
      expect(goodResult.isSuccess, isTrue);
      expect(adapter.currentStatus, equals(AuthStatus.authenticated));

      final session = adapter.currentSession!;
      expect(session.isTestDouble, isTrue,
          reason: 'Test double sessions must be explicitly marked as test doubles');
      expect(session.user.email, equals('user@example.com'));
      expect(session.availableWorkspaces.length, greaterThanOrEqualTo(2));
      expect(session.activeWorkspace.name, equals('Creativanta HQ'));
      expect(session.activeMode, equals(OperatorMode.creator));
    });

    test('RULE-AUTH-003: switches workspace without re-authentication', () async {
      await adapter.signInWithEmailPassword(
        email: 'user@example.com',
        password: 'password',
      );

      final initialToken = adapter.currentSession!.sessionToken;
      const targetWorkspaceId = '018f7a31-2233-7444-8555-667788990022';

      await adapter.switchWorkspace(targetWorkspaceId);

      expect(adapter.currentStatus, equals(AuthStatus.authenticated));
      expect(adapter.currentSession!.activeWorkspace.id, equals(targetWorkspaceId));
      expect(adapter.currentSession!.activeWorkspace.name, equals('SkinCare Brand'));
      expect(adapter.currentSession!.sessionToken, equals(initialToken),
          reason: 'Switching workspace must not require new auth or new token');
    });

    test('rejects switching to non-existent workspace', () async {
      await adapter.signInWithEmailPassword(
        email: 'user@example.com',
        password: 'password',
      );

      expect(
        () => adapter.switchWorkspace('00000000-0000-0000-0000-000000000000'),
        throwsArgumentError,
      );
    });

    test('switches across all six canonical operator modes', () async {
      await adapter.signInWithEmailPassword(
        email: 'user@example.com',
        password: 'password',
      );

      for (final mode in OperatorMode.values) {
        await adapter.switchOperatorMode(mode);
        expect(adapter.currentSession!.activeMode, equals(mode));
      }
    });

    test('handles token expiry and transparent refresh', () async {
      await adapter.signInWithEmailPassword(
        email: 'user@example.com',
        password: 'password',
      );

      adapter.simulateTokenExpiry();
      expect(adapter.currentStatus, equals(AuthStatus.tokenExpired));
      expect(adapter.currentSession!.isExpired(), isTrue);

      final refreshResult = await adapter.refreshToken();
      expect(refreshResult.isSuccess, isTrue);
      expect(adapter.currentStatus, equals(AuthStatus.authenticated));
      expect(adapter.currentSession!.isExpired(), isFalse);
    });

    test('sign-out resets session and status', () async {
      await adapter.signInWithEmailPassword(
        email: 'user@example.com',
        password: 'password',
      );
      expect(adapter.currentSession, isNotNull);

      await adapter.signOut();
      expect(adapter.currentSession, isNull);
      expect(adapter.currentStatus, equals(AuthStatus.unauthenticated));
    });
  });

  group('AuthSession security redaction', () {
    test('toString() redacts sessionToken', () {
      const defaultWs = WorkspaceSummary(
        id: '018f7a31-2233-7444-8555-667788990011',
        name: 'Creativanta HQ',
        role: 'owner',
      );
      final session = AuthSession(
        user: const UserIdentity(
          id: 'usr_secret_123',
          email: 'secret@creativanta.com',
          displayName: 'Secret User',
        ),
        sessionToken: 'super-sensitive-jwt-token-string',
        sessionId: 'sess_secret_123',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        activeWorkspace: defaultWs,
        availableWorkspaces: const [defaultWs],
        activeMode: OperatorMode.creator,
      );

      final str = session.toString();
      expect(str.contains('super-sensitive-jwt-token-string'), isFalse,
          reason: 'AuthSession toString must never expose cleartext JWT token');
      expect(str.contains('[REDACTED]'), isTrue);
    });
  });

  group('UF-03 & IQ-09 ClerkAuthProviderAdapter configured transport lifecycle', () {
    test('signInWithEmailPassword, workspace discovery, and refreshToken succeed with live HTTP transport', () async {
      final transport = _MockAuthHttpTransport({
        'POST /api/auth/clerk/sign-in': (headers, body) {
          if (body?['password'] != 'valid-pass') {
            return const AuthHttpResponse(
              statusCode: 401,
              body: '{"message":"Sai mật khẩu"}',
            );
          }
          return const AuthHttpResponse(
            statusCode: 200,
            body: '''
            {
              "session_token": "jwt_live_token_001",
              "session_id": "sess_live_001",
              "user": {
                "id": "usr_clerk_live_01",
                "email": "live@creativanta.vn",
                "display_name": "Live Operator"
              },
              "workspaces": [
                {
                  "workspace_id": "ws-live-01",
                  "display_name": "Live Brand Studio",
                  "role": "owner",
                  "plan_tier": "Pro",
                  "status": "active"
                }
              ]
            }
            ''',
          );
        },
        'POST /api/auth/clerk/refresh': (headers, body) {
          return const AuthHttpResponse(
            statusCode: 200,
            body: '{"session_token":"jwt_live_token_002_refreshed"}',
          );
        },
      });

      final adapter = ClerkAuthProviderAdapter(
        publishableKey: 'pk_live_configured_key',
        apiBaseUrl: 'https://api.creativanta.vn',
        httpTransport: transport,
      );

      await adapter.initialize();
      expect(adapter.isConfigured, isTrue);
      expect(adapter.currentStatus, equals(AuthStatus.unauthenticated));

      // Negative: invalid credentials fail closed with AUTH_UNAUTHORIZED_001
      final badLogin = await adapter.signInWithEmailPassword(
        email: 'live@creativanta.vn',
        password: 'wrong',
      );
      expect(badLogin.isSuccess, isFalse);
      expect(badLogin.failure?.code, equals('AUTH_UNAUTHORIZED_001'));

      // Positive: valid credentials establish non-test-double session
      final okLogin = await adapter.signInWithEmailPassword(
        email: 'live@creativanta.vn',
        password: 'valid-pass',
      );
      expect(okLogin.isSuccess, isTrue);
      expect(adapter.currentStatus, equals(AuthStatus.authenticated));
      expect(adapter.currentSession?.isTestDouble, isFalse);
      expect(adapter.currentSession?.activeWorkspace.id, equals('ws-live-01'));

      // Refresh token updates sessionToken and keeps activeWorkspace
      final refreshed = await adapter.refreshToken();
      expect(refreshed.isSuccess, isTrue);
      expect(adapter.currentSession?.sessionToken, equals('jwt_live_token_002_refreshed'));
      expect(adapter.currentSession?.activeWorkspace.id, equals('ws-live-01'));

      adapter.dispose();
    });
  });
}
