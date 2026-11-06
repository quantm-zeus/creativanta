import 'package:flutter/foundation.dart';

enum ApiKeyStatus {
  active,
  rotating,
  suspended,
  revoked,
  expired,
}

enum WebhookStatus {
  active,
  suspended,
  revoked,
}

class ApiKeyItem {
  final String apiKeyId;
  final String workspaceId;
  final String keyPrefix;
  final String name;
  final List<String> scopes;
  final ApiKeyStatus status;
  final String logicalKeyId;
  final String? replacedByKeyId;
  final DateTime? rotationGraceEndsAt;
  final int requestCount;
  final DateTime expiresAt;
  final String createdBy;
  final String? secretKey;

  const ApiKeyItem({
    required this.apiKeyId,
    required this.workspaceId,
    required this.keyPrefix,
    required this.name,
    required this.scopes,
    required this.status,
    required this.logicalKeyId,
    this.replacedByKeyId,
    this.rotationGraceEndsAt,
    required this.requestCount,
    required this.expiresAt,
    required this.createdBy,
    this.secretKey,
  });

  ApiKeyItem copyWith({
    String? name,
    List<String>? scopes,
    ApiKeyStatus? status,
    String? replacedByKeyId,
    DateTime? rotationGraceEndsAt,
    int? requestCount,
  }) {
    return ApiKeyItem(
      apiKeyId: apiKeyId,
      workspaceId: workspaceId,
      keyPrefix: keyPrefix,
      name: name ?? this.name,
      scopes: scopes ?? this.scopes,
      status: status ?? this.status,
      logicalKeyId: logicalKeyId,
      replacedByKeyId: replacedByKeyId ?? this.replacedByKeyId,
      rotationGraceEndsAt: rotationGraceEndsAt ?? this.rotationGraceEndsAt,
      requestCount: requestCount ?? this.requestCount,
      expiresAt: expiresAt,
      createdBy: createdBy,
      secretKey: secretKey,
    );
  }
}

class WebhookSubscriptionItem {
  final String subscriptionId;
  final String workspaceId;
  final String targetUrl;
  final List<String> eventTypes;
  final WebhookStatus status;
  final int consecutiveFailureCount;
  final DateTime? lastDeliveryAt;
  final String? lastError;
  final String? signingSecret;

  const WebhookSubscriptionItem({
    required this.subscriptionId,
    required this.workspaceId,
    required this.targetUrl,
    required this.eventTypes,
    required this.status,
    required this.consecutiveFailureCount,
    this.lastDeliveryAt,
    this.lastError,
    this.signingSecret,
  });

  WebhookSubscriptionItem copyWith({
    WebhookStatus? status,
    int? consecutiveFailureCount,
    DateTime? lastDeliveryAt,
    String? lastError,
  }) {
    return WebhookSubscriptionItem(
      subscriptionId: subscriptionId,
      workspaceId: workspaceId,
      targetUrl: targetUrl,
      eventTypes: eventTypes,
      status: status ?? this.status,
      consecutiveFailureCount:
          consecutiveFailureCount ?? this.consecutiveFailureCount,
      lastDeliveryAt: lastDeliveryAt ?? this.lastDeliveryAt,
      lastError: lastError ?? this.lastError,
      signingSecret: signingSecret,
    );
  }
}

class UsageSummaryItem {
  final int monthRequests;
  final int monthlyQuota;
  final int readRateLimitRPM;
  final int writeRateLimitRPM;
  final double billableAICreditsUsed;

  const UsageSummaryItem({
    required this.monthRequests,
    required this.monthlyQuota,
    required this.readRateLimitRPM,
    required this.writeRateLimitRPM,
    required this.billableAICreditsUsed,
  });
}

// 13 canonical S24 webhook events (§21.2)
const List<String> kCanonicalWebhookEvents = [
  'content.published',
  'content.publish_failed',
  'order.created',
  'order.updated',
  'refund.completed',
  'engagement.thread_created',
  'asset.ready',
  'workflow.completed',
  'billing.plan_changed',
  'billing.credits_exhausted',
  'brand_deal.updated',
  'live.ended',
  'gamification.achievement',
];

const Map<String, int> kTierKeyCaps = {
  'starter': 3,
  'pro': 10,
  'business': 25,
  'enterprise': 100,
};

const Map<String, int> kTierMonthlyQuotas = {
  'starter': 10000,
  'pro': 100000,
  'business': 1000000,
  'enterprise': 10000000,
};

bool isReadOnlyScopes(List<String> scopes) {
  for (final s in scopes) {
    if (s.startsWith('write:') ||
        s.contains('manage') ||
        s.contains('delete') ||
        s == '*:*' ||
        s == '*' ||
        s == 'write:all') {
      return false;
    }
  }
  return true;
}

// Invariant Target 1: Read-only key cannot mutate (Starter tier is strictly read-only mode).
bool canMutate(String tier, List<String> scopes) {
  if (tier.toLowerCase() == 'starter') {
    return false;
  }
  return !isReadOnlyScopes(scopes);
}

typedef DeveloperRpcCaller = Future<Map<String, dynamic>> Function(
  String service,
  String method,
  Map<String, dynamic> payload,
);

class DeveloperMutationOutcome<T> {
  final bool ok;
  final T? data;
  final String? errorCode;
  final String? message;

  const DeveloperMutationOutcome({
    required this.ok,
    this.data,
    this.errorCode,
    this.message,
  });
}

ApiKeyStatus _parseApiKeyStatus(String? raw) {
  switch ((raw ?? '').trim().toUpperCase()) {
    case 'API_KEY_STATUS_ROTATING':
    case 'ROTATING':
      return ApiKeyStatus.rotating;
    case 'API_KEY_STATUS_SUSPENDED':
    case 'SUSPENDED':
      return ApiKeyStatus.suspended;
    case 'API_KEY_STATUS_REVOKED':
    case 'REVOKED':
      return ApiKeyStatus.revoked;
    case 'API_KEY_STATUS_EXPIRED':
    case 'EXPIRED':
      return ApiKeyStatus.expired;
    case 'API_KEY_STATUS_ACTIVE':
    case 'ACTIVE':
    default:
      return ApiKeyStatus.active;
  }
}

WebhookStatus _parseWebhookStatus(String? raw) {
  switch ((raw ?? '').trim().toUpperCase()) {
    case 'WEBHOOK_SUBSCRIPTION_STATUS_SUSPENDED':
    case 'SUSPENDED':
      return WebhookStatus.suspended;
    case 'WEBHOOK_SUBSCRIPTION_STATUS_REVOKED':
    case 'REVOKED':
      return WebhookStatus.revoked;
    case 'WEBHOOK_SUBSCRIPTION_STATUS_ACTIVE':
    case 'ACTIVE':
    default:
      return WebhookStatus.active;
  }
}

class DeveloperStateNotifier extends ChangeNotifier {
  String _tier;
  final String workspaceId;
  final DeveloperRpcCaller? rpcCaller;
  final List<ApiKeyItem> _keys = [];
  final List<WebhookSubscriptionItem> _webhooks = [];
  int _monthRequests = 0;
  double _billableAICredits = 0.0;

  DeveloperStateNotifier({
    required this.workspaceId,
    String initialTier = 'pro',
    this.rpcCaller,
  }) : _tier = initialTier;

  bool get isBackendWired => rpcCaller != null;
  String get tier => _tier;
  List<ApiKeyItem> get keys => List.unmodifiable(_keys);
  List<WebhookSubscriptionItem> get webhooks => List.unmodifiable(_webhooks);
  int get monthRequests => _monthRequests;
  int get monthlyQuota => kTierMonthlyQuotas[_tier.toLowerCase()] ?? 100000;
  double get billableAICredits => _billableAICredits;

  int get keyCap => kTierKeyCaps[_tier.toLowerCase()] ?? 3;
  int get activeKeyCount => _keys
      .where((k) => k.status == ApiKeyStatus.active || k.status == ApiKeyStatus.rotating)
      .length;

  void setTier(String newTier) {
    _tier = newTier.toLowerCase();
    notifyListeners();
  }

  /// Remote fail-closed RPC call to creativanta.platform.v1.APIKeyService/Create.
  /// Never fabricates ca_live_ secrets locally when backend transport is absent or fails.
  Future<DeveloperMutationOutcome<ApiKeyItem>> createKeyRemote({
    required String name,
    required List<String> scopes,
    String idempotencyKey = '',
  }) async {
    if (activeKeyCount >= keyCap) {
      return DeveloperMutationOutcome(
        ok: false,
        errorCode: 'KEY_CAP_EXCEEDED',
        message: 'Workspace tier $_tier allows a maximum of $keyCap active keys',
      );
    }
    if (_tier.toLowerCase() == 'starter' && !isReadOnlyScopes(scopes)) {
      return const DeveloperMutationOutcome(
        ok: false,
        errorCode: 'STARTER_READ_ONLY',
        message: 'Starter tier is restricted to read-only API access mode',
      );
    }
    if (rpcCaller == null) {
      return const DeveloperMutationOutcome(
        ok: false,
        errorCode: 'DEVELOPER_BACKEND_UNAVAILABLE',
        message: 'Backend APIKeyService is not connected. Refusing to mint simulated API key.',
      );
    }

    try {
      final res = await rpcCaller!(
        'creativanta.platform.v1.APIKeyService',
        'Create',
        {
          'context': {'workspace_id': workspaceId},
          'idempotency_key': idempotencyKey.isNotEmpty
              ? idempotencyKey
              : 'ak_create_${DateTime.now().millisecondsSinceEpoch}',
          'name': name,
          'scopes': scopes,
        },
      );

      final rawKey = res['api_key'] as Map<String, dynamic>?;
      final secretKey = (res['secret_key'] as String?)?.trim() ?? '';
      final apiKeyId = (rawKey?['api_key_id'] as String?)?.trim() ?? '';
      if (rawKey == null || apiKeyId.isEmpty || secretKey.isEmpty) {
        return const DeveloperMutationOutcome(
          ok: false,
          errorCode: 'INVALID_BACKEND_RESPONSE',
          message: 'APIKeyService/Create did not return a valid api_key and secret_key.',
        );
      }

      final now = DateTime.now().toUtc();
      final rawScopes = (rawKey['scopes'] as List?)?.map((e) => e.toString()).toList() ?? scopes;
      final newKey = ApiKeyItem(
        apiKeyId: apiKeyId,
        workspaceId: (rawKey['workspace_id'] as String?) ?? workspaceId,
        keyPrefix: (rawKey['key_prefix'] as String?) ??
            (secretKey.length >= 10 ? secretKey.substring(0, 10) : secretKey),
        name: (rawKey['name'] as String?) ?? name,
        scopes: rawScopes,
        status: _parseApiKeyStatus(rawKey['status'] as String?),
        logicalKeyId: (rawKey['logical_key_id'] as String?) ?? apiKeyId,
        requestCount: (rawKey['request_count'] as int?) ?? 0,
        expiresAt: DateTime.tryParse((rawKey['expires_at'] as String?) ?? '') ??
            now.add(const Duration(days: 90)),
        createdBy: (rawKey['created_by'] as String?) ?? 'user_authenticated',
        secretKey: secretKey,
      );

      _keys.add(newKey);
      notifyListeners();
      return DeveloperMutationOutcome(ok: true, data: newKey);
    } catch (e) {
      return DeveloperMutationOutcome(
        ok: false,
        errorCode: 'RPC_CREATE_KEY_FAILED',
        message: e.toString(),
      );
    }
  }

  /// Remote fail-closed RPC call to creativanta.platform.v1.APIKeyService/Rotate.
  Future<DeveloperMutationOutcome<ApiKeyItem>> rotateKeyRemote(
    String apiKeyId, {
    String idempotencyKey = '',
  }) async {
    final index = _keys.indexWhere((k) => k.apiKeyId == apiKeyId);
    if (index == -1) {
      return const DeveloperMutationOutcome(
        ok: false,
        errorCode: 'API_KEY_NOT_FOUND',
        message: 'API key not found',
      );
    }
    final existing = _keys[index];
    if (existing.status == ApiKeyStatus.revoked) {
      return const DeveloperMutationOutcome(
        ok: false,
        errorCode: 'API_KEY_REVOKED',
        message: 'Cannot rotate a revoked key',
      );
    }
    if (rpcCaller == null) {
      return const DeveloperMutationOutcome(
        ok: false,
        errorCode: 'DEVELOPER_BACKEND_UNAVAILABLE',
        message: 'Backend APIKeyService is not connected. Refusing to mint simulated rotated secret.',
      );
    }

    try {
      final res = await rpcCaller!(
        'creativanta.platform.v1.APIKeyService',
        'Rotate',
        {
          'context': {'workspace_id': workspaceId},
          'idempotency_key': idempotencyKey.isNotEmpty
              ? idempotencyKey
              : 'ak_rotate_${DateTime.now().millisecondsSinceEpoch}',
          'api_key_id': apiKeyId,
          'grace_period_hours': 24,
        },
      );

      final rawNewKey = res['new_key'] as Map<String, dynamic>?;
      final newSecretKey = ((res['new_secret_key'] ?? res['secret_key']) as String?)?.trim() ?? '';
      final newKeyId = (rawNewKey?['api_key_id'] as String?)?.trim() ?? '';
      if (rawNewKey == null || newKeyId.isEmpty || newSecretKey.isEmpty) {
        return const DeveloperMutationOutcome(
          ok: false,
          errorCode: 'INVALID_BACKEND_RESPONSE',
          message: 'APIKeyService/Rotate did not return a valid new_key and new_secret_key.',
        );
      }

      final now = DateTime.now().toUtc();
      final graceEndsAt = DateTime.tryParse((res['grace_ends_at'] as String?) ?? '') ??
          now.add(const Duration(hours: 24));
      final rawScopes =
          (rawNewKey['scopes'] as List?)?.map((e) => e.toString()).toList() ?? existing.scopes;

      final rotatedNewKey = ApiKeyItem(
        apiKeyId: newKeyId,
        workspaceId: (rawNewKey['workspace_id'] as String?) ?? workspaceId,
        keyPrefix: (rawNewKey['key_prefix'] as String?) ??
            (newSecretKey.length >= 10 ? newSecretKey.substring(0, 10) : newSecretKey),
        name: (rawNewKey['name'] as String?) ?? '${existing.name} (Rotated)',
        scopes: rawScopes,
        status: _parseApiKeyStatus(rawNewKey['status'] as String?),
        logicalKeyId: (rawNewKey['logical_key_id'] as String?) ?? existing.logicalKeyId,
        requestCount: 0,
        expiresAt: DateTime.tryParse((rawNewKey['expires_at'] as String?) ?? '') ??
            now.add(const Duration(days: 90)),
        createdBy: existing.createdBy,
        secretKey: newSecretKey,
      );

      _keys[index] = existing.copyWith(
        status: ApiKeyStatus.rotating,
        replacedByKeyId: newKeyId,
        rotationGraceEndsAt: graceEndsAt,
      );
      _keys.add(rotatedNewKey);
      notifyListeners();
      return DeveloperMutationOutcome(ok: true, data: rotatedNewKey);
    } catch (e) {
      return DeveloperMutationOutcome(
        ok: false,
        errorCode: 'RPC_ROTATE_KEY_FAILED',
        message: e.toString(),
      );
    }
  }

  /// Remote fail-closed RPC call to creativanta.platform.v1.APIKeyService/Revoke.
  Future<DeveloperMutationOutcome<ApiKeyItem>> revokeKeyRemote(
    String apiKeyId, {
    String idempotencyKey = '',
  }) async {
    final index = _keys.indexWhere((k) => k.apiKeyId == apiKeyId);
    if (index == -1) {
      return const DeveloperMutationOutcome(
        ok: false,
        errorCode: 'API_KEY_NOT_FOUND',
        message: 'API key not found',
      );
    }
    if (rpcCaller == null) {
      return const DeveloperMutationOutcome(
        ok: false,
        errorCode: 'DEVELOPER_BACKEND_UNAVAILABLE',
        message: 'Backend APIKeyService is not connected. Key revocation was not persisted.',
      );
    }

    try {
      await rpcCaller!(
        'creativanta.platform.v1.APIKeyService',
        'Revoke',
        {
          'context': {'workspace_id': workspaceId},
          'idempotency_key': idempotencyKey.isNotEmpty
              ? idempotencyKey
              : 'ak_revoke_${DateTime.now().millisecondsSinceEpoch}',
          'api_key_id': apiKeyId,
        },
      );

      final updated = _keys[index].copyWith(status: ApiKeyStatus.revoked);
      _keys[index] = updated;
      notifyListeners();
      return DeveloperMutationOutcome(ok: true, data: updated);
    } catch (e) {
      return DeveloperMutationOutcome(
        ok: false,
        errorCode: 'RPC_REVOKE_KEY_FAILED',
        message: e.toString(),
      );
    }
  }

  /// Remote fail-closed RPC call to creativanta.platform.v1.WebhookSubscriptionService/CreateWebhookSubscription.
  Future<DeveloperMutationOutcome<WebhookSubscriptionItem>> createWebhookSubscriptionRemote({
    required String targetUrl,
    required List<String> eventTypes,
    String idempotencyKey = '',
  }) async {
    if (rpcCaller == null) {
      return const DeveloperMutationOutcome(
        ok: false,
        errorCode: 'DEVELOPER_BACKEND_UNAVAILABLE',
        message: 'Backend WebhookSubscriptionService is not connected. Refusing to mint simulated signing secret.',
      );
    }

    try {
      final res = await rpcCaller!(
        'creativanta.platform.v1.WebhookSubscriptionService',
        'CreateWebhookSubscription',
        {
          'context': {'workspace_id': workspaceId},
          'idempotency_key': idempotencyKey.isNotEmpty
              ? idempotencyKey
              : 'wh_create_${DateTime.now().millisecondsSinceEpoch}',
          'target_url': targetUrl,
          'event_types': eventTypes,
        },
      );

      final rawSub = res['subscription'] as Map<String, dynamic>?;
      final signingSecret = (res['signing_secret'] as String?)?.trim() ?? '';
      final subId = ((rawSub?['webhook_subscription_id'] ?? rawSub?['subscription_id']) as String?)
              ?.trim() ??
          '';
      if (rawSub == null || subId.isEmpty || signingSecret.isEmpty) {
        return const DeveloperMutationOutcome(
          ok: false,
          errorCode: 'INVALID_BACKEND_RESPONSE',
          message:
              'WebhookSubscriptionService/CreateWebhookSubscription did not return a valid subscription and signing_secret.',
        );
      }

      final sub = WebhookSubscriptionItem(
        subscriptionId: subId,
        workspaceId: (rawSub['workspace_id'] as String?) ?? workspaceId,
        targetUrl: (rawSub['target_url'] as String?) ?? targetUrl,
        eventTypes:
            (rawSub['event_types'] as List?)?.map((e) => e.toString()).toList() ?? eventTypes,
        status: _parseWebhookStatus(rawSub['status'] as String?),
        consecutiveFailureCount: (rawSub['consecutive_failure_count'] as int?) ?? 0,
        signingSecret: signingSecret,
      );

      _webhooks.add(sub);
      notifyListeners();
      return DeveloperMutationOutcome(ok: true, data: sub);
    } catch (e) {
      return DeveloperMutationOutcome(
        ok: false,
        errorCode: 'RPC_CREATE_WEBHOOK_FAILED',
        message: e.toString(),
      );
    }
  }

  ApiKeyItem createKey({
    required String name,
    required List<String> scopes,
  }) {
    if (activeKeyCount >= keyCap) {
      throw StateError('Workspace tier $_tier allows a maximum of $keyCap active keys');
    }

    if (_tier.toLowerCase() == 'starter' && !isReadOnlyScopes(scopes)) {
      throw UnsupportedError('Starter tier is restricted to read-only API access mode');
    }

    final id = 'ak_${DateTime.now().millisecondsSinceEpoch}';
    final rawSecret = 'ca_live_sec_$id';
    final prefix = rawSecret.substring(0, 10);
    final now = DateTime.now().toUtc();
    final expires = now.add(const Duration(days: 90));

    final newKey = ApiKeyItem(
      apiKeyId: id,
      workspaceId: workspaceId,
      keyPrefix: prefix,
      name: name,
      scopes: scopes,
      status: ApiKeyStatus.active,
      logicalKeyId: id,
      requestCount: 0,
      expiresAt: expires,
      createdBy: 'user_admin',
      secretKey: rawSecret,
    );

    _keys.add(newKey);
    notifyListeners();
    return newKey;
  }

  void rotateKey(String apiKeyId) {
    final index = _keys.indexWhere((k) => k.apiKeyId == apiKeyId);
    if (index == -1) {
      throw StateError('API key not found');
    }
    final existing = _keys[index];
    if (existing.status == ApiKeyStatus.revoked) {
      throw StateError('Cannot rotate a revoked key');
    }

    final now = DateTime.now().toUtc();
    final grace = now.add(const Duration(hours: 24));
    final newId = 'ak_${DateTime.now().millisecondsSinceEpoch}_rot';
    final newRawSecret = 'ca_live_rot_$newId';
    final newPrefix = newRawSecret.substring(0, 10);

    final rotatedNewKey = ApiKeyItem(
      apiKeyId: newId,
      workspaceId: workspaceId,
      keyPrefix: newPrefix,
      name: '${existing.name} (Rotated)',
      scopes: existing.scopes,
      status: ApiKeyStatus.active,
      logicalKeyId: existing.logicalKeyId,
      requestCount: 0,
      expiresAt: now.add(const Duration(days: 90)),
      createdBy: existing.createdBy,
      secretKey: newRawSecret,
    );

    _keys[index] = existing.copyWith(
      status: ApiKeyStatus.rotating,
      replacedByKeyId: newId,
      rotationGraceEndsAt: grace,
    );

    _keys.add(rotatedNewKey);
    notifyListeners();
  }

  void revokeKey(String apiKeyId) {
    final index = _keys.indexWhere((k) => k.apiKeyId == apiKeyId);
    if (index != -1) {
      _keys[index] = _keys[index].copyWith(status: ApiKeyStatus.revoked);
      notifyListeners();
    }
  }

  void executeApiCall({
    required String apiKeyId,
    required bool isMutation,
    double aiCredits = 0.0,
  }) {
    final index = _keys.indexWhere((k) => k.apiKeyId == apiKeyId);
    if (index == -1) {
      throw StateError('API key not found');
    }
    final key = _keys[index];

    if (key.status == ApiKeyStatus.revoked) {
      throw StateError('API key has been revoked');
    }

    final now = DateTime.now().toUtc();
    if (key.status == ApiKeyStatus.rotating && key.rotationGraceEndsAt != null) {
      if (now.isAfter(key.rotationGraceEndsAt!)) {
        throw StateError('API key rotation grace period ended; use new key');
      }
    }

    // Target 1 Invariant: Read-only key cannot mutate!
    if (isMutation && !canMutate(_tier, key.scopes)) {
      throw UnsupportedError('Read-only API key cannot execute mutating operation');
    }

    _keys[index] = key.copyWith(requestCount: key.requestCount + 1);
    _monthRequests++;
    _billableAICredits += aiCredits;
    notifyListeners();
  }

  WebhookSubscriptionItem createWebhookSubscription({
    required String targetUrl,
    required List<String> eventTypes,
  }) {
    final id = 'wh_${DateTime.now().millisecondsSinceEpoch}';
    final secret = 'whsec_$id';

    final sub = WebhookSubscriptionItem(
      subscriptionId: id,
      workspaceId: workspaceId,
      targetUrl: targetUrl,
      eventTypes: eventTypes,
      status: WebhookStatus.active,
      consecutiveFailureCount: 0,
      signingSecret: secret,
    );

    _webhooks.add(sub);
    notifyListeners();
    return sub;
  }

  void recordWebhookDelivery({
    required String subscriptionId,
    required bool success,
    String? errorMessage,
  }) {
    final index = _webhooks.indexWhere((w) => w.subscriptionId == subscriptionId);
    if (index != -1) {
      final sub = _webhooks[index];
      final nextFailures = success ? 0 : sub.consecutiveFailureCount + 1;
      final nextStatus = nextFailures >= 100 ? WebhookStatus.suspended : sub.status;

      _webhooks[index] = sub.copyWith(
        consecutiveFailureCount: nextFailures,
        status: nextStatus,
        lastDeliveryAt: DateTime.now().toUtc(),
        lastError: success ? null : errorMessage,
      );
      notifyListeners();
    }
  }
}
