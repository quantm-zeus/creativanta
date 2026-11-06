import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:creativanta_mobile/auth/auth_models.dart';
import 'package:creativanta_mobile/auth/secure_token_store.dart';

/// HTTP transport abstraction for Clerk & backend workspace discovery calls.
/// Allows deterministic testing while using real `dart:io` [HttpClient] in production.
abstract class AuthHttpTransport {
  Future<AuthHttpResponse> postJson(
    Uri uri, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  });
}

class AuthHttpResponse {
  const AuthHttpResponse({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;
  final String body;

  bool get isOk => statusCode >= 200 && statusCode < 300;
}

class DartIoAuthHttpTransport implements AuthHttpTransport {
  DartIoAuthHttpTransport({
    this.timeout = const Duration(seconds: 10),
  });

  final Duration timeout;

  @override
  Future<AuthHttpResponse> postJson(
    Uri uri, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final client = HttpClient()..connectionTimeout = timeout;
    try {
      final request = await client.postUrl(uri).timeout(timeout);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      headers?.forEach(request.headers.set);
      if (body != null) {
        request.add(utf8.encode(jsonEncode(body)));
      }
      final response = await request.close().timeout(timeout);
      final responseBody = await response.transform(utf8.decoder).join().timeout(timeout);
      return AuthHttpResponse(
        statusCode: response.statusCode,
        body: responseBody,
      );
    } finally {
      client.close(force: true);
    }
  }
}

/// Explicit Provider-Adapter Interface for user identity and session management.
///
/// Complies with P0-03 specification:
/// - Fails closed when external Clerk IdP is unconfigured.
/// - Never allows fake auth bypasses or cleartext token storage.
/// - Enforces workspace switching without re-authentication (RULE-AUTH-003).
/// - Preserves operator mode selection across all six canonical modes.
abstract class AuthProviderAdapter {
  Stream<AuthStatus> get statusStream;
  AuthStatus get currentStatus;
  AuthSession? get currentSession;
  String? get currentError;
  bool get isConfigured;
  String get externalGateDescription;

  Future<void> initialize();
  Future<AuthResult> signInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<AuthResult> signInWithOAuth(OAuthProvider provider);
  Future<AuthResult> refreshToken();
  Future<void> signOut();
  Future<void> switchWorkspace(String workspaceId);
  Future<void> switchOperatorMode(OperatorMode mode);
  void dispose();
}

/// Represents a short-lived Clerk session token issued/refreshed directly by the
/// Clerk IdP SDK / Frontend API bridge per `RULE-AUTH-002` (`docs/02_features/platform/auth.md`).
class ClerkIssuedSession {
  final String sessionToken;
  final String sessionId;
  final UserIdentity? user;
  final int expiresInSeconds;

  const ClerkIssuedSession({
    required this.sessionToken,
    required this.sessionId,
    this.user,
    this.expiresInSeconds = 3600,
  });
}

/// Bridge to the external Clerk Identity Provider SDK / Frontend API.
/// Per `RULE-AUTH-002`, Clerk issues and refreshes short-lived session JWTs directly;
/// the Creativanta Go backend does NOT host `/api/auth/clerk/sign-in` or `/api/auth/clerk/refresh`.
abstract class ClerkIdpSessionBridge {
  Future<ClerkIssuedSession> signInWithPassword({
    required String publishableKey,
    required String email,
    required String password,
  });

  Future<ClerkIssuedSession?> refreshSessionToken({
    required String publishableKey,
    required String sessionId,
    required String currentToken,
  });
}

/// Production Clerk provider adapter with fail-closed security boundary and
/// live HTTP workspace-discovery integration (`POST /api/workspaces/discovery`, UF-03, IQ-09).
class ClerkAuthProviderAdapter implements AuthProviderAdapter {
  ClerkAuthProviderAdapter({
    this.publishableKey,
    this.apiBaseUrl,
    this.idpBridge,
    SecureTokenStore? tokenStore,
    AuthHttpTransport? httpTransport,
  })  : _tokenStore = tokenStore ?? EphemeralSecureTokenStore(),
        _httpTransport = httpTransport ?? DartIoAuthHttpTransport();

  /// Factory reading compile-time `--dart-define` configuration (`IQ-09`).
  factory ClerkAuthProviderAdapter.fromEnvironment({
    ClerkIdpSessionBridge? idpBridge,
    SecureTokenStore? tokenStore,
    AuthHttpTransport? httpTransport,
  }) {
    const envPublishableKey = String.fromEnvironment('CLERK_PUBLISHABLE_KEY');
    const envApiBaseUrl = String.fromEnvironment('CREATIVANTA_API_BASE_URL');
    return ClerkAuthProviderAdapter(
      publishableKey: envPublishableKey.isNotEmpty ? envPublishableKey : null,
      apiBaseUrl: envApiBaseUrl.isNotEmpty ? envApiBaseUrl : null,
      idpBridge: idpBridge,
      tokenStore: tokenStore,
      httpTransport: httpTransport,
    );
  }

  static const String _jwtKey = 'clerk_session_jwt';
  static const String _sessionIdKey = 'clerk_session_id';
  static const String _activeModeKey = 'creativanta_operator_mode';
  static const String _activeWorkspaceKey = 'creativanta_active_workspace_id';

  final String? publishableKey;
  final String? apiBaseUrl;
  final ClerkIdpSessionBridge? idpBridge;
  final SecureTokenStore _tokenStore;
  final AuthHttpTransport _httpTransport;

  final StreamController<AuthStatus> _statusController =
      StreamController<AuthStatus>.broadcast();

  AuthStatus _currentStatus = AuthStatus.unconfigured;
  AuthSession? _currentSession;
  String? _currentError;

  @override
  Stream<AuthStatus> get statusStream => _statusController.stream;

  @override
  AuthStatus get currentStatus => _currentStatus;

  @override
  AuthSession? get currentSession => _currentSession;

  @override
  String? get currentError => _currentError;

  bool get _hasValidPublishableKey =>
      publishableKey != null &&
      publishableKey!.trim().isNotEmpty &&
      publishableKey!.startsWith('pk_');

  /// Live password sign-in and SDK token refresh require BOTH a valid Clerk
  /// publishable key (`pk_...`) and a configured `ClerkIdpSessionBridge`.
  /// Without `idpBridge`, the adapter fails closed (`EXT-GATE-CLERK-MOBILE`)
  /// rather than posting credentials to non-existent backend routes.
  @override
  bool get isConfigured => _hasValidPublishableKey && idpBridge != null;

  String get _resolvedApiBaseUrl {
    final trimmed = (apiBaseUrl ?? '').trim();
    if (trimmed.isEmpty) {
      return 'http://localhost:8080';
    }
    return trimmed.endsWith('/') ? trimmed.substring(0, trimmed.length - 1) : trimmed;
  }

  @override
  String get externalGateDescription =>
      'External Gate EXT-GATE-CLERK-MOBILE: Real Clerk IdP integration is pending '
      'production credential provisioning and provider verification. '
      'Fail-closed: live login is disabled.';

  Future<OperatorMode> _readPersistedMode() async {
    final saved = await _tokenStore.readToken(key: _activeModeKey);
    if (saved != null && saved.isNotEmpty) {
      return OperatorMode.fromId(saved);
    }
    return OperatorMode.creator;
  }

  List<WorkspaceSummary> _parseWorkspaces(dynamic rawPayload, String? preferredWorkspaceId) {
    dynamic rawList = rawPayload;
    if (rawPayload is Map<String, dynamic>) {
      if (!rawPayload.containsKey('workspaces')) {
        return const [];
      }
      rawList = rawPayload['workspaces'];
      if (rawList == null) {
        return const [];
      }
    }
    if (rawList is! List || rawList.isEmpty) {
      return const [];
    }
    final parsed = <WorkspaceSummary>[];
    for (final item in rawList) {
      if (item is Map<String, dynamic>) {
        final id = (item['workspace_id'] ?? item['id'] ?? '').toString().trim();
        if (id.isEmpty) continue;
        final displayName = (item['display_name'] ?? '').toString().trim();
        final slugName = (item['name'] ?? '').toString().trim();
        parsed.add(
          WorkspaceSummary(
            id: id,
            name: displayName.isNotEmpty
                ? displayName
                : (slugName.isNotEmpty ? slugName : 'Workspace'),
            role: (item['role'] ?? 'viewer').toString().trim(),
            plan: (item['plan'] ?? item['plan_tier'] ?? 'Starter').toString().trim(),
            unreadCount: item['unread_count'] is int ? item['unread_count'] as int : 0,
            isActive: false,
          ),
        );
      }
    }
    if (parsed.isEmpty) return const [];
    final activeIdx = preferredWorkspaceId != null
        ? parsed.indexWhere((w) => w.id == preferredWorkspaceId)
        : 0;
    final chosenIdx = activeIdx >= 0 ? activeIdx : 0;
    return [
      for (var i = 0; i < parsed.length; i++)
        parsed[i].copyWith(isActive: i == chosenIdx),
    ];
  }

  @override
  Future<void> initialize() async {
    if (!_hasValidPublishableKey) {
      _currentStatus = AuthStatus.unconfigured;
      _currentError = externalGateDescription;
      _statusController.add(_currentStatus);
      return;
    }

    try {
      final existingToken = await _tokenStore.readToken(key: _jwtKey);
      final existingSessionId = await _tokenStore.readToken(key: _sessionIdKey);
      if (existingToken != null && existingToken.isNotEmpty) {
        _currentStatus = AuthStatus.authenticating;
        _statusController.add(_currentStatus);

        final discoveryUri = Uri.parse('$_resolvedApiBaseUrl/api/workspaces/discovery');
        try {
          final resp = await _httpTransport.postJson(
            discoveryUri,
            headers: {
              'Authorization': 'Bearer $existingToken',
              'X-Clerk-Publishable-Key': publishableKey!,
            },
          );
          if (resp.isOk) {
            final decoded = jsonDecode(resp.body);
            final savedWsId = await _tokenStore.readToken(key: _activeWorkspaceKey);
            final savedMode = await _readPersistedMode();
            final wsList = _parseWorkspaces(decoded, savedWsId);
            if (wsList.isNotEmpty) {
              final activeWs = wsList.firstWhere((w) => w.isActive, orElse: () => wsList.first);
              final userMap = decoded is Map<String, dynamic> && decoded['user'] is Map<String, dynamic>
                  ? decoded['user'] as Map<String, dynamic>
                  : const <String, dynamic>{};
              _currentSession = AuthSession(
                user: UserIdentity(
                  id: (userMap['id'] ?? 'usr_verified').toString(),
                  email: (userMap['email'] ?? 'operator@creativanta.vn').toString(),
                  displayName: (userMap['display_name'] ?? 'Operator').toString(),
                ),
                sessionToken: existingToken,
                sessionId: existingSessionId ?? 'sess_restored',
                expiresAt: DateTime.now().add(const Duration(minutes: 55)),
                activeWorkspace: activeWs,
                availableWorkspaces: wsList,
                activeMode: savedMode,
              );
              _currentStatus = AuthStatus.authenticated;
              _currentError = null;
              _statusController.add(_currentStatus);
              return;
            }
          }
        } catch (_) {
          // Network or verification failure during cold start falls back below
        }
        await _tokenStore.clearAll();
      }

      if (!isConfigured) {
        _currentStatus = AuthStatus.unconfigured;
        _currentError = externalGateDescription;
      } else {
        _currentStatus = AuthStatus.unauthenticated;
        _currentError = null;
      }
    } catch (e) {
      _currentStatus = AuthStatus.error;
      _currentError = 'Failed to inspect secure credential store: $e';
    }

    _statusController.add(_currentStatus);
  }

  @override
  Future<AuthResult> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (!isConfigured || idpBridge == null) {
      final failure = AuthFailure(
        code: 'PROVIDER_UNAVAILABLE_001',
        message: externalGateDescription,
        externalGateRequired: true,
      );
      _currentStatus = AuthStatus.unconfigured;
      _currentError = failure.message;
      _statusController.add(_currentStatus);
      return AuthResult.failure(failure);
    }

    _currentStatus = AuthStatus.authenticating;
    _statusController.add(_currentStatus);

    try {
      final issued = await idpBridge!.signInWithPassword(
        publishableKey: publishableKey!,
        email: email.trim(),
        password: password,
      );

      final token = issued.sessionToken.trim();
      final sessionId = issued.sessionId.trim();
      if (token.isEmpty || sessionId.isEmpty) {
        const failure = AuthFailure(
          code: 'AUTH_INVALID_PAYLOAD_001',
          message: 'Clerk IdP không trả về session_token hợp lệ (fail-closed).',
        );
        _currentStatus = AuthStatus.error;
        _currentError = failure.message;
        _statusController.add(_currentStatus);
        return const AuthResult.failure(failure);
      }

      final discoveryUri = Uri.parse('$_resolvedApiBaseUrl/api/workspaces/discovery');
      final discResp = await _httpTransport.postJson(
        discoveryUri,
        headers: {
          'Authorization': 'Bearer $token',
          'X-Clerk-Publishable-Key': publishableKey!,
        },
      );

      if (!discResp.isOk) {
        final failure = AuthFailure(
          code: discResp.statusCode == 401 || discResp.statusCode == 403
              ? 'AUTH_UNAUTHORIZED_001'
              : 'WORKSPACE_DISCOVERY_FAILED_001',
          message: discResp.statusCode == 401 || discResp.statusCode == 403
              ? 'Token phiên Clerk bị từ chối bởi máy chủ Creativanta (fail-closed).'
              : 'Dịch vụ khám phá Workspace (/api/workspaces/discovery) trả về lỗi (${discResp.statusCode}).',
        );
        _currentStatus = AuthStatus.error;
        _currentError = failure.message;
        _statusController.add(_currentStatus);
        return AuthResult.failure(failure);
      }

      final discJson = jsonDecode(discResp.body);
      final savedWsId = await _tokenStore.readToken(key: _activeWorkspaceKey);
      final workspaces = _parseWorkspaces(discJson, savedWsId);

      if (workspaces.isEmpty) {
        const failure = AuthFailure(
          code: 'WORKSPACE_DISCOVERY_EMPTY_001',
          message: 'Không tìm thấy Workspace hợp lệ cho tài khoản này.',
        );
        _currentStatus = AuthStatus.error;
        _currentError = failure.message;
        _statusController.add(_currentStatus);
        return const AuthResult.failure(failure);
      }

      final activeWs = workspaces.firstWhere((w) => w.isActive, orElse: () => workspaces.first);
      final savedMode = await _readPersistedMode();

      final session = AuthSession(
        user: issued.user ??
            UserIdentity(
              id: 'usr_clerk',
              email: email.trim(),
              displayName: email.trim().split('@').first,
            ),
        sessionToken: token,
        sessionId: sessionId,
        expiresAt: DateTime.now().add(Duration(seconds: issued.expiresInSeconds)),
        activeWorkspace: activeWs,
        availableWorkspaces: workspaces,
        activeMode: savedMode,
      );

      await _tokenStore.writeToken(key: _jwtKey, token: token);
      await _tokenStore.writeToken(key: _sessionIdKey, token: sessionId);
      await _tokenStore.writeToken(key: _activeWorkspaceKey, token: activeWs.id);

      _currentSession = session;
      _currentStatus = AuthStatus.authenticated;
      _currentError = null;
      _statusController.add(_currentStatus);
      return AuthResult.success(session);
    } on AuthFailure catch (failure) {
      _currentStatus = AuthStatus.error;
      _currentError = failure.message;
      _statusController.add(_currentStatus);
      return AuthResult.failure(failure);
    } catch (_) {
      const failure = AuthFailure(
        code: 'AUTH_UNAUTHORIZED_001',
        message: 'Xác thực Clerk hoặc khám phá Workspace không thành công.',
      );
      _currentStatus = AuthStatus.error;
      _currentError = failure.message;
      _statusController.add(_currentStatus);
      return const AuthResult.failure(failure);
    }
  }

  @override
  Future<AuthResult> signInWithOAuth(OAuthProvider provider) async {
    if (!isConfigured) {
      final failure = AuthFailure(
        code: 'PROVIDER_UNAVAILABLE_001',
        message: externalGateDescription,
        externalGateRequired: true,
      );
      _currentStatus = AuthStatus.unconfigured;
      _currentError = failure.message;
      _statusController.add(_currentStatus);
      return AuthResult.failure(failure);
    }

    final failure = AuthFailure(
      code: 'AUTH_UNAUTHORIZED_001',
      message: 'OAuth qua ${provider.displayName} yêu cầu cấu hình Clerk redirect URI.',
    );
    _currentStatus = AuthStatus.error;
    _currentError = failure.message;
    _statusController.add(_currentStatus);
    return AuthResult.failure(failure);
  }

  @override
  Future<AuthResult> refreshToken() async {
    if (!isConfigured || idpBridge == null || _currentSession == null) {
      const failure = AuthFailure(
        code: 'AUTH_UNAUTHORIZED_001',
        message: 'Không có phiên hợp lệ để làm mới.',
      );
      _currentStatus = isConfigured ? AuthStatus.unauthenticated : AuthStatus.unconfigured;
      _statusController.add(_currentStatus);
      return const AuthResult.failure(failure);
    }

    try {
      final refreshed = await idpBridge!.refreshSessionToken(
        publishableKey: publishableKey!,
        sessionId: _currentSession!.sessionId,
        currentToken: _currentSession!.sessionToken,
      );

      final freshToken = (refreshed?.sessionToken ?? '').trim();
      if (freshToken.isNotEmpty) {
        final discoveryUri = Uri.parse('$_resolvedApiBaseUrl/api/workspaces/discovery');
        final discResp = await _httpTransport.postJson(
          discoveryUri,
          headers: {
            'Authorization': 'Bearer $freshToken',
            'X-Clerk-Publishable-Key': publishableKey!,
          },
        );
        if (discResp.isOk) {
          final decoded = jsonDecode(discResp.body);
          final workspaces = _parseWorkspaces(decoded, _currentSession!.activeWorkspace.id);
          if (workspaces.isNotEmpty) {
            final activeWs = workspaces.firstWhere(
              (w) => w.isActive,
              orElse: () => workspaces.first,
            );
            await _tokenStore.writeToken(key: _jwtKey, token: freshToken);
            _currentSession = _currentSession!.copyWith(
              sessionToken: freshToken,
              expiresAt: DateTime.now().add(
                Duration(seconds: refreshed?.expiresInSeconds ?? 3600),
              ),
              activeWorkspace: activeWs,
              availableWorkspaces: workspaces,
            );
            _currentStatus = AuthStatus.authenticated;
            _currentError = null;
            _statusController.add(_currentStatus);
            return AuthResult.success(_currentSession);
          }
        }
      }
    } catch (_) {
      // Fall through to fail-closed session expiry below
    }

    await _tokenStore.clearAll();
    _currentSession = null;
    _currentStatus = AuthStatus.unauthenticated;
    _statusController.add(_currentStatus);
    return const AuthResult.failure(
      AuthFailure(
        code: 'AUTH_EXPIRED_001',
        message: 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
      ),
    );
  }

  @override
  Future<void> signOut() async {
    await _tokenStore.clearAll();
    _currentSession = null;
    _currentStatus = isConfigured ? AuthStatus.unauthenticated : AuthStatus.unconfigured;
    _statusController.add(_currentStatus);
  }

  @override
  Future<void> switchWorkspace(String workspaceId) async {
    if (_currentSession == null) {
      throw StateError('Cannot switch workspace without an active session');
    }

    final matchIndex = _currentSession!.availableWorkspaces.indexWhere(
      (w) => w.id == workspaceId,
    );
    if (matchIndex == -1) {
      throw ArgumentError('Workspace $workspaceId not found in active session');
    }

    final target = _currentSession!.availableWorkspaces[matchIndex];
    final updatedList = _currentSession!.availableWorkspaces.map((w) {
      return w.copyWith(isActive: w.id == workspaceId);
    }).toList();

    _currentSession = _currentSession!.copyWith(
      activeWorkspace: target.copyWith(isActive: true),
      availableWorkspaces: updatedList,
    );
    await _tokenStore.writeToken(key: _activeWorkspaceKey, token: workspaceId);
    _statusController.add(_currentStatus);
  }

  @override
  Future<void> switchOperatorMode(OperatorMode mode) async {
    if (_currentSession == null) {
      throw StateError('Cannot switch operator mode without an active session');
    }
    _currentSession = _currentSession!.copyWith(activeMode: mode);
    await _tokenStore.writeToken(key: _activeModeKey, token: mode.id);
    _statusController.add(_currentStatus);
  }

  @override
  void dispose() {
    _statusController.close();
  }
}

/// Explicit test double implementation of [AuthProviderAdapter].
///
/// Designed strictly for unit and widget testing.
/// Marked with [isTestDouble: true] to prevent mistaking test runs for live auth.
class TestAuthProviderAdapter implements AuthProviderAdapter {
  TestAuthProviderAdapter({
    AuthStatus initialStatus = AuthStatus.unauthenticated,
    AuthSession? initialSession,
    String? initialError,
    this.isConfigured = true,
  })  : _currentStatus = initialStatus,
        _currentSession = initialSession,
        _currentError = initialError;

  final StreamController<AuthStatus> _statusController =
      StreamController<AuthStatus>.broadcast();

  AuthStatus _currentStatus;
  AuthSession? _currentSession;
  String? _currentError;

  @override
  final bool isConfigured;

  @override
  String get externalGateDescription =>
      'Test double adapter for automated test execution only. '
      'Not a real Clerk integration.';

  @override
  Stream<AuthStatus> get statusStream => _statusController.stream;

  @override
  AuthStatus get currentStatus => _currentStatus;

  @override
  AuthSession? get currentSession => _currentSession;

  @override
  String? get currentError => _currentError;

  @override
  Future<void> initialize() async {
    _statusController.add(_currentStatus);
  }

  void setStatus(AuthStatus status, {String? error}) {
    _currentStatus = status;
    _currentError = error;
    _statusController.add(_currentStatus);
  }

  void setSession(AuthSession? session) {
    _currentSession = session;
    if (session != null) {
      _currentStatus = AuthStatus.authenticated;
    }
    _statusController.add(_currentStatus);
  }

  void simulateTokenExpiry() {
    if (_currentSession != null) {
      _currentSession = _currentSession!.copyWith(
        expiresAt: DateTime.now().subtract(const Duration(minutes: 5)),
      );
    }
    _currentStatus = AuthStatus.tokenExpired;
    _statusController.add(_currentStatus);
  }

  @override
  Future<AuthResult> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (!isConfigured) {
      final failure = const AuthFailure(
        code: 'PROVIDER_UNAVAILABLE_001',
        message: 'Provider is not configured.',
        externalGateRequired: true,
      );
      _currentStatus = AuthStatus.unconfigured;
      _statusController.add(_currentStatus);
      return AuthResult.failure(failure);
    }

    if (password == 'wrong-password') {
      const failure = AuthFailure(
        code: 'AUTH_UNAUTHORIZED_001',
        message: 'Thông tin đăng nhập không chính xác.',
      );
      _currentStatus = AuthStatus.error;
      _currentError = failure.message;
      _statusController.add(_currentStatus);
      return const AuthResult.failure(failure);
    }

    _currentStatus = AuthStatus.authenticating;
    _statusController.add(_currentStatus);

    final defaultWorkspace = const WorkspaceSummary(
      id: '018f7a31-2233-7444-8555-667788990011',
      name: 'Creativanta HQ',
      role: 'owner',
      plan: 'Pro Plan',
      isActive: true,
    );

    final secondaryWorkspace = const WorkspaceSummary(
      id: '018f7a31-2233-7444-8555-667788990022',
      name: 'SkinCare Brand',
      role: 'admin',
      plan: 'Free Plan',
      unreadCount: 3,
      isActive: false,
    );

    final session = AuthSession(
      user: UserIdentity(
        id: 'user_test_123',
        email: email,
        displayName: 'Test Operator',
      ),
      sessionToken: 'test-session-jwt-token',
      sessionId: 'sess_test_123',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      activeWorkspace: defaultWorkspace,
      availableWorkspaces: [defaultWorkspace, secondaryWorkspace],
      activeMode: OperatorMode.creator,
      isTestDouble: true,
    );

    _currentSession = session;
    _currentStatus = AuthStatus.authenticated;
    _currentError = null;
    _statusController.add(_currentStatus);
    return AuthResult.success(session);
  }

  @override
  Future<AuthResult> signInWithOAuth(OAuthProvider provider) async {
    return signInWithEmailPassword(
      email: 'oauth-${provider.name}@example.com',
      password: 'oauth-verified',
    );
  }

  @override
  Future<AuthResult> refreshToken() async {
    if (_currentSession == null) {
      const failure = AuthFailure(
        code: 'AUTH_UNAUTHORIZED_001',
        message: 'Không tìm thấy phiên cần làm mới.',
      );
      _currentStatus = AuthStatus.unauthenticated;
      _statusController.add(_currentStatus);
      return const AuthResult.failure(failure);
    }

    _currentSession = _currentSession!.copyWith(
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      sessionToken: 'test-refreshed-jwt-token',
    );
    _currentStatus = AuthStatus.authenticated;
    _currentError = null;
    _statusController.add(_currentStatus);
    return AuthResult.success(_currentSession);
  }

  @override
  Future<void> signOut() async {
    _currentSession = null;
    _currentStatus = AuthStatus.unauthenticated;
    _currentError = null;
    _statusController.add(_currentStatus);
  }

  @override
  Future<void> switchWorkspace(String workspaceId) async {
    if (_currentSession == null) {
      throw StateError('Cannot switch workspace without an active session');
    }

    final matchIndex = _currentSession!.availableWorkspaces.indexWhere(
      (w) => w.id == workspaceId,
    );
    if (matchIndex == -1) {
      throw ArgumentError('Workspace $workspaceId not found');
    }

    final target = _currentSession!.availableWorkspaces[matchIndex];
    final updated = _currentSession!.availableWorkspaces.map((w) {
      return w.copyWith(isActive: w.id == workspaceId);
    }).toList();

    _currentSession = _currentSession!.copyWith(
      activeWorkspace: target.copyWith(isActive: true),
      availableWorkspaces: updated,
    );
    _statusController.add(_currentStatus);
  }

  @override
  Future<void> switchOperatorMode(OperatorMode mode) async {
    if (_currentSession == null) {
      throw StateError('Cannot switch operator mode without an active session');
    }
    _currentSession = _currentSession!.copyWith(activeMode: mode);
    _statusController.add(_currentStatus);
  }

  @override
  void dispose() {
    _statusController.close();
  }
}
