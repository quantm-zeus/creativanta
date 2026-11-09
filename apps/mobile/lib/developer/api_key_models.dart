import 'package:flutter/foundation.dart';
import 'package:creativanta_mobile/generated/creativanta/platform/v1/public_api.pb.dart'
    as pb;

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

ApiKeyStatus _fromProtoApiKeyStatus(pb.APIKeyStatus status) {
  switch (status) {
    case pb.APIKeyStatus.API_KEY_STATUS_ROTATING:
      return ApiKeyStatus.rotating;
    case pb.APIKeyStatus.API_KEY_STATUS_SUSPENDED:
      return ApiKeyStatus.suspended;
    case pb.APIKeyStatus.API_KEY_STATUS_REVOKED:
      return ApiKeyStatus.revoked;
    case pb.APIKeyStatus.API_KEY_STATUS_EXPIRED:
      return ApiKeyStatus.expired;
    case pb.APIKeyStatus.API_KEY_STATUS_ACTIVE:
    case pb.APIKeyStatus.API_KEY_STATUS_UNSPECIFIED:
    default:
      return ApiKeyStatus.active;
  }
}

WebhookStatus _fromProtoWebhookStatus(pb.WebhookSubscriptionStatus status) {
  switch (status) {
    case pb.WebhookSubscriptionStatus.WEBHOOK_SUBSCRIPTION_STATUS_SUSPENDED:
      return WebhookStatus.suspended;
    case pb.WebhookSubscriptionStatus.WEBHOOK_SUBSCRIPTION_STATUS_REVOKED:
      return WebhookStatus.revoked;
    case pb.WebhookSubscriptionStatus.WEBHOOK_SUBSCRIPTION_STATUS_ACTIVE:
    case pb.WebhookSubscriptionStatus.WEBHOOK_SUBSCRIPTION_STATUS_UNSPECIFIED:
    default:
      return WebhookStatus.active;
  }
}

String _snakeToCamel(String input) {
  if (!input.contains('_')) return input;
  final parts = input.split('_');
  final buffer = StringBuffer(parts.first);
  for (var i = 1; i < parts.length; i++) {
    final part = parts[i];
    if (part.isEmpty) continue;
    buffer.write(part[0].toUpperCase());
    if (part.length > 1) {
      buffer.write(part.substring(1));
    }
  }
  return buffer.toString();
}

Map<String, dynamic> _normalizeProto3JsonMap(
  Map<String, dynamic> raw, {
  String? enumHint,
}) {
  final out = <String, dynamic>{};
  raw.forEach((rawKey, rawValue) {
    final key = _snakeToCamel(rawKey);
    if (rawValue is Map) {
      final childMap = rawValue.map((k, v) => MapEntry(k.toString(), v));
      final nextHint = (key == 'apiKey' || key == 'oldKey' || key == 'newKey')
          ? 'apiKey'
          : (key == 'subscription' ? 'webhook' : null);
      out[key] = _normalizeProto3JsonMap(childMap, enumHint: nextHint);
    } else if (rawValue is List) {
      out[key] = rawValue
          .map((item) => item is Map
              ? _normalizeProto3JsonMap(
                  item.map((k, v) => MapEntry(k.toString(), v)),
                )
              : item)
          .toList();
    } else if (key == 'status' && rawValue is String) {
      final upper = rawValue.trim().toUpperCase();
      if (enumHint == 'apiKey' && !upper.startsWith('API_KEY_STATUS_')) {
        out[key] = 'API_KEY_STATUS_$upper';
      } else if (enumHint == 'webhook' &&
          !upper.startsWith('WEBHOOK_SUBSCRIPTION_STATUS_')) {
        out[key] = 'WEBHOOK_SUBSCRIPTION_STATUS_$upper';
      } else {
        out[key] = rawValue;
      }
    } else {
      out[key] = rawValue;
    }
  });

  if (enumHint == 'webhook' &&
      !out.containsKey('webhookSubscriptionId') &&
      out['subscriptionId'] != null) {
    out['webhookSubscriptionId'] = out['subscriptionId'];
  }
  return out;
}

class DeveloperStateNotifier extends ChangeNotifier {
  String _tier;
  final String workspaceId;
  final DeveloperRpcCaller? rpcCaller;
  final List<ApiKeyItem> _keys = [];
  final List<WebhookSubscriptionItem> _webhooks = [];
  int _monthRequests = 0;
  double _billableAICredits = 0.0;
  int _resetEpoch = 0;

  DeveloperStateNotifier({
    required this.workspaceId,
    String initialTier = 'pro',
    this.rpcCaller,
  }) : _tier = initialTier;

  bool get isBackendWired => rpcCaller != null;
  String get tier => _tier;
  int get resetEpoch => _resetEpoch;
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

  void reset() {
    _resetEpoch += 1;
    _keys.clear();
    _webhooks.clear();
    _monthRequests = 0;
    _billableAICredits = 0.0;
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

    final startEpoch = _resetEpoch;
    try {
      final res = await rpcCaller!(
        'creativanta.platform.v1.APIKeyService',
        'Create',
        {
          'workspace_id': workspaceId,
          'name': name,
          'scopes': scopes,
        },
      );

      if (_resetEpoch != startEpoch) {
        return const DeveloperMutationOutcome(
          ok: false,
          errorCode: 'SESSION_RESET',
          message: 'Session or workspace changed during API key creation (fail-closed).',
        );
      }

      final normalized = _normalizeProto3JsonMap(res);
      final protoRes = pb.CreateResponse()
        ..mergeFromProto3Json(normalized, ignoreUnknownFields: true);

      final protoKey = protoRes.apiKey;
      final secretKey = protoRes.secretKey.trim();
      final apiKeyId = protoKey.apiKeyId.trim();
      if (!protoRes.hasApiKey() || apiKeyId.isEmpty || secretKey.isEmpty) {
        return const DeveloperMutationOutcome(
          ok: false,
          errorCode: 'INVALID_BACKEND_RESPONSE',
          message: 'APIKeyService/Create did not return a valid api_key and secret_key.',
        );
      }

      final now = DateTime.now().toUtc();
      final rawScopes =
          protoKey.scopes.isNotEmpty ? protoKey.scopes.toList() : scopes;
      final newKey = ApiKeyItem(
        apiKeyId: apiKeyId,
        workspaceId:
            protoKey.workspaceId.isNotEmpty ? protoKey.workspaceId : workspaceId,
        keyPrefix: protoKey.keyPrefix.isNotEmpty
            ? protoKey.keyPrefix
            : (secretKey.length >= 10 ? secretKey.substring(0, 10) : secretKey),
        name: protoKey.name.isNotEmpty ? protoKey.name : name,
        scopes: rawScopes,
        status: _fromProtoApiKeyStatus(protoKey.status),
        logicalKeyId:
            protoKey.logicalKeyId.isNotEmpty ? protoKey.logicalKeyId : apiKeyId,
        requestCount: protoKey.requestCount.toInt(),
        expiresAt: protoKey.hasExpiresAt()
            ? protoKey.expiresAt.toDateTime()
            : now.add(const Duration(days: 90)),
        createdBy: protoKey.createdBy.isNotEmpty
            ? protoKey.createdBy
            : 'user_authenticated',
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

    final startEpoch = _resetEpoch;
    try {
      final res = await rpcCaller!(
        'creativanta.platform.v1.APIKeyService',
        'Rotate',
        {
          'workspace_id': workspaceId,
          'api_key_id': apiKeyId,
        },
      );

      if (_resetEpoch != startEpoch) {
        return const DeveloperMutationOutcome(
          ok: false,
          errorCode: 'SESSION_RESET',
          message: 'Session or workspace changed during API key rotation (fail-closed).',
        );
      }

      final normalized = _normalizeProto3JsonMap(res);
      if (!normalized.containsKey('newSecretKey') &&
          normalized['secretKey'] != null) {
        normalized['newSecretKey'] = normalized['secretKey'];
      }
      final protoRes = pb.RotateResponse()
        ..mergeFromProto3Json(normalized, ignoreUnknownFields: true);

      final protoNewKey = protoRes.newKey;
      final newSecretKey = protoRes.newSecretKey.trim();
      final newKeyId = protoNewKey.apiKeyId.trim();
      if (!protoRes.hasNewKey() || newKeyId.isEmpty || newSecretKey.isEmpty) {
        return const DeveloperMutationOutcome(
          ok: false,
          errorCode: 'INVALID_BACKEND_RESPONSE',
          message: 'APIKeyService/Rotate did not return a valid new_key and new_secret_key.',
        );
      }

      final now = DateTime.now().toUtc();
      final graceEndsAt = protoRes.oldKey.hasRotationGraceEndsAt()
          ? protoRes.oldKey.rotationGraceEndsAt.toDateTime()
          : (DateTime.tryParse(
                  (normalized['graceEndsAt'] as String?) ?? '') ??
              now.add(const Duration(hours: 24)));
      final rawScopes = protoNewKey.scopes.isNotEmpty
          ? protoNewKey.scopes.toList()
          : existing.scopes;

      final rotatedNewKey = ApiKeyItem(
        apiKeyId: newKeyId,
        workspaceId: protoNewKey.workspaceId.isNotEmpty
            ? protoNewKey.workspaceId
            : workspaceId,
        keyPrefix: protoNewKey.keyPrefix.isNotEmpty
            ? protoNewKey.keyPrefix
            : (newSecretKey.length >= 10
                ? newSecretKey.substring(0, 10)
                : newSecretKey),
        name: protoNewKey.name.isNotEmpty
            ? protoNewKey.name
            : '${existing.name} (Rotated)',
        scopes: rawScopes,
        status: _fromProtoApiKeyStatus(protoNewKey.status),
        logicalKeyId: protoNewKey.logicalKeyId.isNotEmpty
            ? protoNewKey.logicalKeyId
            : existing.logicalKeyId,
        requestCount: protoNewKey.requestCount.toInt(),
        expiresAt: protoNewKey.hasExpiresAt()
            ? protoNewKey.expiresAt.toDateTime()
            : now.add(const Duration(days: 90)),
        createdBy: protoNewKey.createdBy.isNotEmpty
            ? protoNewKey.createdBy
            : existing.createdBy,
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

    final startEpoch = _resetEpoch;
    try {
      final res = await rpcCaller!(
        'creativanta.platform.v1.APIKeyService',
        'Revoke',
        {
          'workspace_id': workspaceId,
          'api_key_id': apiKeyId,
        },
      );

      if (_resetEpoch != startEpoch) {
        return const DeveloperMutationOutcome(
          ok: false,
          errorCode: 'SESSION_RESET',
          message: 'Session or workspace changed during API key revocation (fail-closed).',
        );
      }

      final normalized = _normalizeProto3JsonMap(res);
      final protoRes = pb.RevokeResponse()
        ..mergeFromProto3Json(normalized, ignoreUnknownFields: true);
      final confirmedRevoked = (protoRes.hasApiKey() &&
              protoRes.apiKey.status ==
                  pb.APIKeyStatus.API_KEY_STATUS_REVOKED) ||
          _parseApiKeyStatus(res['status']?.toString()) == ApiKeyStatus.revoked;
      if (!confirmedRevoked) {
        return const DeveloperMutationOutcome(
          ok: false,
          errorCode: 'INVALID_BACKEND_RESPONSE',
          message: 'APIKeyService/Revoke did not confirm revoked key status.',
        );
      }

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

    final startEpoch = _resetEpoch;
    try {
      final res = await rpcCaller!(
        'creativanta.platform.v1.WebhookSubscriptionService',
        'CreateWebhookSubscription',
        {
          'workspace_id': workspaceId,
          'target_url': targetUrl,
          'event_types': eventTypes,
        },
      );

      if (_resetEpoch != startEpoch) {
        return const DeveloperMutationOutcome(
          ok: false,
          errorCode: 'SESSION_RESET',
          message: 'Session or workspace changed during webhook subscription creation (fail-closed).',
        );
      }

      final normalized = _normalizeProto3JsonMap(res);
      final protoRes = pb.CreateWebhookSubscriptionResponse()
        ..mergeFromProto3Json(normalized, ignoreUnknownFields: true);

      final protoSub = protoRes.subscription;
      final signingSecret = protoRes.signingSecret.trim();
      final subId = protoSub.webhookSubscriptionId.trim();
      if (!protoRes.hasSubscription() || subId.isEmpty || signingSecret.isEmpty) {
        return const DeveloperMutationOutcome(
          ok: false,
          errorCode: 'INVALID_BACKEND_RESPONSE',
          message:
              'WebhookSubscriptionService/CreateWebhookSubscription did not return a valid subscription and signing_secret.',
        );
      }

      final sub = WebhookSubscriptionItem(
        subscriptionId: subId,
        workspaceId:
            protoSub.workspaceId.isNotEmpty ? protoSub.workspaceId : workspaceId,
        targetUrl:
            protoSub.targetUrl.isNotEmpty ? protoSub.targetUrl : targetUrl,
        eventTypes: protoSub.eventTypes.isNotEmpty
            ? protoSub.eventTypes.toList()
            : eventTypes,
        status: _fromProtoWebhookStatus(protoSub.status),
        consecutiveFailureCount: protoSub.consecutiveFailureCount,
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
