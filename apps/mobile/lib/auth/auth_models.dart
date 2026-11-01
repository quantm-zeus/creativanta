import 'package:flutter/foundation.dart';

/// The six canonical operator modes defined by Creativanta PRD §8 and
/// docs/01_business/user_segments_and_modes.md.
enum OperatorMode {
  creator(
    id: 'creator',
    displayName: 'Sáng tạo nội dung',
    description: 'Tập trung ý tưởng, kịch bản, sản xuất và xuất bản đa kênh.',
  ),
  seller(
    id: 'seller',
    displayName: 'Bán hàng & Tồn kho',
    description: 'Quản lý sản phẩm, đơn hàng, tồn kho và đối soát doanh thu.',
  ),
  affiliateOperator(
    id: 'affiliate_operator',
    displayName: 'Tiếp thị liên kết (KOC/KOL)',
    description: 'Nghiên cứu cơ hội, tối ưu link/coupon và doanh thu quy đổi.',
  ),
  liveOperator(
    id: 'live_operator',
    displayName: 'Phòng chiến Live Commerce',
    description: 'Điều phối kịch bản live, ghim deal, hội thoại và điểm nhấn.',
  ),
  agencyMcn(
    id: 'agency_mcn',
    displayName: 'Đội ngũ Agency / MCN',
    description: 'Quản lý đa workspace, creator, hàng đợi duyệt và báo cáo.',
  ),
  brandCollaboration(
    id: 'brand_collaboration',
    displayName: 'Hợp tác nhãn hàng & Tài trợ',
    description: 'Theo dõi yêu cầu tài trợ, bằng chứng phân phối và thanh toán.',
  );

  const OperatorMode({
    required this.id,
    required this.displayName,
    required this.description,
  });

  final String id;
  final String displayName;
  final String description;

  static OperatorMode fromId(String id) {
    for (final mode in OperatorMode.values) {
      if (mode.id == id) {
        return mode;
      }
    }
    return OperatorMode.creator;
  }
}

/// Workspace summary information used for discovery and switcher UI (M004).
@immutable
class WorkspaceSummary {
  const WorkspaceSummary({
    required this.id,
    required this.name,
    required this.role,
    this.plan = 'Starter Plan',
    this.unreadCount = 0,
    this.isActive = false,
  });

  final String id;
  final String name;
  final String role;
  final String plan;
  final int unreadCount;
  final bool isActive;

  WorkspaceSummary copyWith({
    String? id,
    String? name,
    String? role,
    String? plan,
    int? unreadCount,
    bool? isActive,
  }) {
    return WorkspaceSummary(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      plan: plan ?? this.plan,
      unreadCount: unreadCount ?? this.unreadCount,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkspaceSummary &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          role == other.role &&
          plan == other.plan &&
          unreadCount == other.unreadCount &&
          isActive == other.isActive;

  @override
  int get hashCode => Object.hash(id, name, role, plan, unreadCount, isActive);

  @override
  String toString() =>
      'WorkspaceSummary(id: $id, name: $name, role: $role, plan: $plan, isActive: $isActive)';
}

/// Verified user identity details.
@immutable
class UserIdentity {
  const UserIdentity({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.emailVerified = true,
  });

  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final bool emailVerified;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserIdentity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          displayName == other.displayName &&
          avatarUrl == other.avatarUrl &&
          emailVerified == other.emailVerified;

  @override
  int get hashCode => Object.hash(id, email, displayName, avatarUrl, emailVerified);

  @override
  String toString() =>
      'UserIdentity(id: $id, email: $email, displayName: $displayName, verified: $emailVerified)';
}

/// Active user authentication session.
@immutable
class AuthSession {
  const AuthSession({
    required this.user,
    required this.sessionToken,
    required this.sessionId,
    required this.expiresAt,
    required this.activeWorkspace,
    required this.availableWorkspaces,
    this.activeMode = OperatorMode.creator,
    this.isTestDouble = false,
  });

  final UserIdentity user;
  final String sessionToken;
  final String sessionId;
  final DateTime expiresAt;
  final WorkspaceSummary activeWorkspace;
  final List<WorkspaceSummary> availableWorkspaces;
  final OperatorMode activeMode;
  final bool isTestDouble;

  bool isExpired([DateTime? now]) {
    final current = now ?? DateTime.now();
    return current.isAfter(expiresAt);
  }

  AuthSession copyWith({
    UserIdentity? user,
    String? sessionToken,
    String? sessionId,
    DateTime? expiresAt,
    WorkspaceSummary? activeWorkspace,
    List<WorkspaceSummary>? availableWorkspaces,
    OperatorMode? activeMode,
    bool? isTestDouble,
  }) {
    return AuthSession(
      user: user ?? this.user,
      sessionToken: sessionToken ?? this.sessionToken,
      sessionId: sessionId ?? this.sessionId,
      expiresAt: expiresAt ?? this.expiresAt,
      activeWorkspace: activeWorkspace ?? this.activeWorkspace,
      availableWorkspaces: availableWorkspaces ?? this.availableWorkspaces,
      activeMode: activeMode ?? this.activeMode,
      isTestDouble: isTestDouble ?? this.isTestDouble,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthSession &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          sessionId == other.sessionId &&
          expiresAt == other.expiresAt &&
          activeWorkspace == other.activeWorkspace &&
          activeMode == other.activeMode &&
          isTestDouble == other.isTestDouble &&
          listEquals(availableWorkspaces, other.availableWorkspaces);

  @override
  int get hashCode => Object.hash(
        user,
        sessionId,
        expiresAt,
        activeWorkspace,
        activeMode,
        isTestDouble,
      );

  @override
  String toString() =>
      'AuthSession(user: ${user.id}, session: $sessionId, expiresAt: $expiresAt, activeWorkspace: ${activeWorkspace.id}, activeMode: ${activeMode.id}, isTestDouble: $isTestDouble, sessionToken: [REDACTED])';
}

/// Authentication state machine statuses.
enum AuthStatus {
  /// External IdP provider is unconfigured or pending provider access. Fail-closed.
  unconfigured,

  /// Provider is configured, user has no active session.
  unauthenticated,

  /// In-flight login or session verification.
  authenticating,

  /// User holds an active, verified session.
  authenticated,

  /// Access token has reached expiry; re-auth or refresh required.
  tokenExpired,

  /// Authentication failed or provider experienced an error.
  error,
}

/// Supported social OAuth providers.
enum OAuthProvider {
  google(displayName: 'Google'),
  apple(displayName: 'Apple'),
  facebook(displayName: 'Facebook');

  const OAuthProvider({required this.displayName});

  final String displayName;
}

/// Structured failure response from auth actions.
@immutable
class AuthFailure {
  const AuthFailure({
    required this.code,
    required this.message,
    this.underlyingError,
    this.externalGateRequired = false,
  });

  final String code;
  final String message;
  final String? underlyingError;
  final bool externalGateRequired;

  @override
  String toString() =>
      'AuthFailure(code: $code, message: $message, externalGate: $externalGateRequired)';
}

/// Result of an authentication request.
@immutable
class AuthResult {
  const AuthResult.success(this.session) : failure = null;
  const AuthResult.failure(this.failure) : session = null;

  final AuthSession? session;
  final AuthFailure? failure;

  bool get isSuccess => session != null && failure == null;
}
