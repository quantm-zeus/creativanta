import 'dart:async';
import 'package:creativanta_mobile/auth/auth_models.dart';
import 'package:creativanta_mobile/auth/secure_token_store.dart';

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

/// Production Clerk provider adapter with fail-closed security boundary.
///
/// In unconfigured environments (pending official Clerk credentials and live
/// native configuration), this adapter maintains an explicit fail-closed state
/// with [AuthStatus.unconfigured] and refuses any simulated authentication.
class ClerkAuthProviderAdapter implements AuthProviderAdapter {
  ClerkAuthProviderAdapter({
    this.publishableKey,
    this.apiBaseUrl,
    SecureTokenStore? tokenStore,
  }) : _tokenStore = tokenStore ?? EphemeralSecureTokenStore();

  final String? publishableKey;
  final String? apiBaseUrl;
  final SecureTokenStore _tokenStore;

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

  @override
  bool get isConfigured =>
      publishableKey != null &&
      publishableKey!.trim().isNotEmpty &&
      publishableKey!.startsWith('pk_');

  @override
  String get externalGateDescription =>
      'External Gate EXT-GATE-CLERK-MOBILE: Real Clerk IdP integration is pending '
      'production credential provisioning and provider verification. '
      'Fail-closed: live login is disabled.';

  @override
  Future<void> initialize() async {
    if (!isConfigured) {
      _currentStatus = AuthStatus.unconfigured;
      _currentError = externalGateDescription;
      _statusController.add(_currentStatus);
      return;
    }

    _currentStatus = AuthStatus.authenticating;
    _statusController.add(_currentStatus);

    try {
      final existingToken = await _tokenStore.readToken(key: 'clerk_session_jwt');
      if (existingToken != null && existingToken.isNotEmpty) {
        // If an existing token exists in secure storage, validation against IdP would occur here.
        // For fail-closed safety, unverified tokens require re-auth.
        _currentStatus = AuthStatus.unauthenticated;
      } else {
        _currentStatus = AuthStatus.unauthenticated;
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

    _currentStatus = AuthStatus.authenticating;
    _statusController.add(_currentStatus);

    // Live Clerk flow requires external provider connection.
    // In production without network endpoint:
    final failure = const AuthFailure(
      code: 'AUTH_UNAUTHORIZED_001',
      message: 'Kết nối máy chủ xác thực Clerk không thành công.',
    );
    _currentStatus = AuthStatus.error;
    _currentError = failure.message;
    _statusController.add(_currentStatus);
    return AuthResult.failure(failure);
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
    if (!isConfigured || _currentSession == null) {
      const failure = AuthFailure(
        code: 'AUTH_UNAUTHORIZED_001',
        message: 'Không có phiên hợp lệ để làm mới.',
      );
      _currentStatus = AuthStatus.unauthenticated;
      _statusController.add(_currentStatus);
      return const AuthResult.failure(failure);
    }

    // Clerk SDK transparent refresh would exchange session token against Clerk API.
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
