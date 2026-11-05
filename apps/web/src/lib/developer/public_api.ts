/**
 * Creativanta Developer Platform & Public API Client Module (S24)
 * Canonical Sources:
 *  - docs/02_features/platform/public_api.md (RULE-S24-001..006, EC-S24-001..003)
 *  - docs/04_contracts/database_schema.md (§18.4, §18.4A, §18.4B)
 *  - docs/04_contracts/domain_event_catalog.md (§21.2)
 *  - docs/00_index/ACCEPTANCE_TESTS.md (AC-S24-001, AC-S24-002)
 */

import { writable, derived, get } from 'svelte/store';

export type APIKeyStatus = 'active' | 'rotating' | 'suspended' | 'revoked' | 'expired';
export type WebhookStatus = 'active' | 'suspended' | 'revoked';

export interface APIKey {
  apiKeyId: string;
  workspaceId: string;
  keyPrefix: string;
  name: string;
  scopes: string[];
  status: APIKeyStatus;
  logicalKeyId: string;
  replacedByKeyId?: string;
  rotationGraceEndsAt?: string; // ISO string
  lastUsedAt?: string;
  requestCount: number;
  rateLimitOverride?: number;
  expiresAt: string;
  createdBy: string;
  secretKey?: string; // Only populated on creation or rotation
}

export interface WebhookSubscription {
  subscriptionId: string;
  workspaceId: string;
  apiKeyId?: string;
  targetUrl: string;
  eventTypes: string[];
  status: WebhookStatus;
  consecutiveFailureCount: number;
  lastDeliveryAt?: string;
  lastError?: string;
  signingSecret?: string;
}

export interface WebhookDeliveryRecord {
  deliveryId: string;
  workspaceId: string;
  subscriptionId: string;
  eventType: string;
  targetUrl: string;
  statusCode: number;
  attemptNumber: number;
  deliveryStatus: 'delivered' | 'retrying' | 'failed' | 'replayed';
  errorMessage?: string;
  signature: string;
  isReplay: boolean;
  deliveredAt: string;
}

export interface DailyUsage {
  date: string;
  readRequests: number;
  writeRequests: number;
  error4xxCount: number;
  error5xxCount: number;
  outboundWebhookDeliveries: number;
  billableAICredits: number;
}

export interface UsageSummary {
  monthRequests: number;
  monthlyQuota: number;
  readRateLimitRPM: number;
  writeRateLimitRPM: number;
  billableAICreditsUsed: number;
}

// 13 canonical S24 webhook-eligible events (§21.2)
export const ELIGIBLE_WEBHOOK_EVENTS = [
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
  'gamification.achievement'
] as const;

export const TIER_KEY_CAPS: Record<string, number> = {
  starter: 3,
  pro: 10,
  business: 25,
  enterprise: 100
};

export const TIER_MONTHLY_QUOTAS: Record<string, number> = {
  starter: 10000,
  pro: 100000,
  business: 1000000,
  enterprise: 10000000
};

export const DEFAULT_READ_RATE_LIMIT_RPM = 100;
export const DEFAULT_WRITE_RATE_LIMIT_RPM = 30;

export class PermissionDeniedError extends Error {
  code = 403;
  constructor(message: string) {
    super(message);
    this.name = 'PermissionDeniedError';
  }
}

export class RateLimitExceededError extends Error {
  code = 429;
  retryAfter: number;
  constructor(message: string, retryAfter: number) {
    super(message);
    this.name = 'RateLimitExceededError';
    this.retryAfter = retryAfter;
  }
}

export class KeyExpiredError extends Error {
  code = 401;
  constructor(message: string) {
    super(message);
    this.name = 'KeyExpiredError';
  }
}

/**
 * Checks if scopes list is strictly read-only (no mutating permissions).
 */
export function isReadOnlyScopes(scopes: string[]): boolean {
  return !scopes.some(
    (s) =>
      s.startsWith('write:') ||
      s.includes('manage') ||
      s.includes('delete') ||
      s === '*:*' ||
      s === '*' ||
      s === 'write:all'
  );
}

/**
 * Evaluates whether an API key in a given tier can execute a mutating operation.
 * Invariant Target 1: Read-only key cannot mutate (Starter is also strictly read-only mode).
 */
export function canMutate(tier: string, scopes: string[]): boolean {
  if (tier.toLowerCase() === 'starter') {
    return false;
  }
  return !isReadOnlyScopes(scopes);
}

/**
 * Validates whether an API key is authenticated and within 24h rotation grace window.
 */
export function evaluateKeyAuthentication(
  key: APIKey,
  now: Date = new Date()
): { valid: boolean; reason?: string } {
  if (key.status === 'revoked') {
    return { valid: false, reason: 'api key has been revoked' };
  }
  if (key.status === 'suspended') {
    return { valid: false, reason: 'api key is suspended' };
  }
  if (key.status === 'expired') {
    return { valid: false, reason: 'api key has expired' };
  }

  const nowMs = now.getTime();
  if (key.status === 'rotating') {
    if (key.rotationGraceEndsAt) {
      const graceEndMs = new Date(key.rotationGraceEndsAt).getTime();
      if (nowMs > graceEndMs) {
        return {
          valid: false,
          reason: 'key has been rotated and 24h grace period ended; use new key'
        };
      }
    }
    return { valid: true };
  }

  if (key.status === 'active') {
    const expireMs = new Date(key.expiresAt).getTime();
    if (nowMs > expireMs) {
      return { valid: false, reason: 'api key has expired' };
    }
    return { valid: true };
  }

  return { valid: false, reason: 'unknown status' };
}

/**
 * Developer State Store
 */
export interface DeveloperState {
  workspaceId: string;
  tier: string;
  keys: APIKey[];
  webhooks: WebhookSubscription[];
  deliveries: WebhookDeliveryRecord[];
  dailyUsage: DailyUsage[];
  summary: UsageSummary;
}

function createDeveloperStore(initialTier: string = 'pro') {
  const initialState: DeveloperState = {
    workspaceId: '22222222-2222-2222-2222-222222222201',
    tier: initialTier,
    keys: [],
    webhooks: [],
    deliveries: [],
    dailyUsage: [],
    summary: {
      monthRequests: 0,
      monthlyQuota: TIER_MONTHLY_QUOTAS[initialTier] || 100000,
      readRateLimitRPM: DEFAULT_READ_RATE_LIMIT_RPM,
      writeRateLimitRPM: DEFAULT_WRITE_RATE_LIMIT_RPM,
      billableAICreditsUsed: 0
    }
  };

  const { subscribe, set, update } = writable<DeveloperState>(initialState);

  return {
    subscribe,
    setTier: (tier: string) => {
      update((s) => ({
        ...s,
        tier: tier.toLowerCase(),
        summary: {
          ...s.summary,
          monthlyQuota: TIER_MONTHLY_QUOTAS[tier.toLowerCase()] || 100000
        }
      }));
    },
    createKey: (name: string, scopes: string[]) => {
      const current = get({ subscribe });
      const cap = TIER_KEY_CAPS[current.tier] || 3;
      const activeCount = current.keys.filter(
        (k) => k.status === 'active' || k.status === 'rotating'
      ).length;

      if (activeCount >= cap) {
        throw new Error(
          `Workspace tier ${current.tier} allows a maximum of ${cap} active keys`
        );
      }

      if (current.tier === 'starter' && !isReadOnlyScopes(scopes)) {
        throw new PermissionDeniedError(
          'Starter tier is restricted to read-only API access mode'
        );
      }

      const id = 'ak_' + Math.random().toString(36).substring(2, 10);
      const rawSecret = 'ca_live_' + Math.random().toString(16).substring(2) + Math.random().toString(16).substring(2);
      const prefix = rawSecret.substring(0, 10);
      const now = new Date();
      const expires = new Date(now.getTime() + 90 * 24 * 60 * 60 * 1000);

      const newKey: APIKey = {
        apiKeyId: id,
        workspaceId: current.workspaceId,
        keyPrefix: prefix,
        name,
        scopes,
        status: 'active',
        logicalKeyId: id,
        requestCount: 0,
        expiresAt: expires.toISOString(),
        createdBy: 'usr_admin',
        secretKey: rawSecret
      };

      update((s) => ({
        ...s,
        keys: [...s.keys, newKey]
      }));

      return { key: newKey, rawSecret };
    },
    rotateKey: (apiKeyId: string) => {
      const current = get({ subscribe });
      const existing = current.keys.find((k) => k.apiKeyId === apiKeyId);
      if (!existing) {
        throw new Error('API key not found');
      }
      if (existing.status === 'revoked') {
        throw new Error('Cannot rotate a revoked key');
      }

      const now = new Date();
      const graceEnd = new Date(now.getTime() + 24 * 60 * 60 * 1000);
      const newKeyId = 'ak_' + Math.random().toString(36).substring(2, 10);
      const newRawSecret = 'ca_live_' + Math.random().toString(16).substring(2) + Math.random().toString(16).substring(2);
      const newPrefix = newRawSecret.substring(0, 10);

      const rotatedNewKey: APIKey = {
        apiKeyId: newKeyId,
        workspaceId: existing.workspaceId,
        keyPrefix: newPrefix,
        name: existing.name + ' (Rotated)',
        scopes: existing.scopes,
        status: 'active',
        logicalKeyId: existing.logicalKeyId,
        requestCount: 0,
        expiresAt: new Date(now.getTime() + 90 * 24 * 60 * 60 * 1000).toISOString(),
        createdBy: existing.createdBy,
        secretKey: newRawSecret
      };

      update((s) => {
        const updatedKeys = s.keys.map((k) => {
          if (k.apiKeyId === apiKeyId) {
            return {
              ...k,
              status: 'rotating' as APIKeyStatus,
              replacedByKeyId: newKeyId,
              rotationGraceEndsAt: graceEnd.toISOString()
            };
          }
          return k;
        });
        return {
          ...s,
          keys: [...updatedKeys, rotatedNewKey]
        };
      });

      return {
        oldKeyId: apiKeyId,
        newKey: rotatedNewKey,
        newSecret: newRawSecret,
        graceEndsAt: graceEnd.toISOString()
      };
    },
    revokeKey: (apiKeyId: string) => {
      update((s) => ({
        ...s,
        keys: s.keys.map((k) =>
          k.apiKeyId === apiKeyId ? { ...k, status: 'revoked' as APIKeyStatus } : k
        )
      }));
    },
    executeApiCall: (keyId: string, isMutation: boolean, aiCredits: number = 0) => {
      const current = get({ subscribe });
      const key = current.keys.find((k) => k.apiKeyId === keyId);
      if (!key) {
        throw new Error('API key not found');
      }

      const auth = evaluateKeyAuthentication(key);
      if (!auth.valid) {
        throw new KeyExpiredError(auth.reason || 'Authentication failed');
      }

      // Target 1 Invariant: Read-only key cannot mutate!
      if (isMutation && !canMutate(current.tier, key.scopes)) {
        throw new PermissionDeniedError(
          'Read-only API key cannot execute mutating operation'
        );
      }

      update((s) => ({
        ...s,
        keys: s.keys.map((k) =>
          k.apiKeyId === keyId ? { ...k, requestCount: k.requestCount + 1 } : k
        ),
        summary: {
          ...s.summary,
          monthRequests: s.summary.monthRequests + 1,
          billableAICreditsUsed: s.summary.billableAICreditsUsed + aiCredits
        }
      }));
      return { success: true };
    },
    createWebhook: (targetUrl: string, eventTypes: string[]) => {
      const subId = 'wh_' + Math.random().toString(36).substring(2, 10);
      const secret = 'whsec_' + Math.random().toString(16).substring(2);

      const sub: WebhookSubscription = {
        subscriptionId: subId,
        workspaceId: get({ subscribe }).workspaceId,
        targetUrl,
        eventTypes,
        status: 'active',
        consecutiveFailureCount: 0,
        signingSecret: secret
      };

      update((s) => ({
        ...s,
        webhooks: [...s.webhooks, sub]
      }));

      return { subscription: sub, secret };
    },
    recordWebhookOutcome: (subscriptionId: string, success: boolean, errMsg?: string) => {
      update((s) => ({
        ...s,
        webhooks: s.webhooks.map((sub) => {
          if (sub.subscriptionId === subscriptionId) {
            const nextFailures = success ? 0 : sub.consecutiveFailureCount + 1;
            const nextStatus: WebhookStatus = nextFailures >= 100 ? 'suspended' : sub.status;
            return {
              ...sub,
              consecutiveFailureCount: nextFailures,
              status: nextStatus,
              lastError: success ? undefined : errMsg,
              lastDeliveryAt: new Date().toISOString()
            };
          }
          return sub;
        })
      }));
    },
    reset: () => set(initialState),
    upsertRemoteKey: (key: APIKey) => {
      update((s) => {
        const exists = s.keys.some((k) => k.apiKeyId === key.apiKeyId);
        return {
          ...s,
          keys: exists
            ? s.keys.map((k) => (k.apiKeyId === key.apiKeyId ? key : k))
            : [...s.keys, key]
        };
      });
    },
    upsertRemoteWebhook: (sub: WebhookSubscription) => {
      update((s) => {
        const exists = s.webhooks.some((w) => w.subscriptionId === sub.subscriptionId);
        return {
          ...s,
          webhooks: exists
            ? s.webhooks.map((w) => (w.subscriptionId === sub.subscriptionId ? sub : w))
            : [...s.webhooks, sub]
        };
      });
    }
  };
}

export const developerStore = createDeveloperStore();

import { callCanonicalRpc, generateIdempotencyKey, type CanonicalRpcOptions } from '$lib/api/client';

export interface IssueApiKeyRemoteResult {
  ok: boolean;
  key?: APIKey;
  rawSecret?: string;
  error?: string;
}

export async function issueApiKeyRemote(
  params: {
    workspaceId?: string;
    tier: string;
    activeKeysCount: number;
    name: string;
    scopes: string[];
  },
  options: CanonicalRpcOptions = {}
): Promise<IssueApiKeyRemoteResult> {
  const cap = TIER_KEY_CAPS[params.tier] || 3;
  if (params.activeKeysCount >= cap) {
    return {
      ok: false,
      error: `Workspace tier ${params.tier} allows a maximum of ${cap} active keys`
    };
  }

  if (params.tier === 'starter' && !isReadOnlyScopes(params.scopes)) {
    return {
      ok: false,
      error: 'Starter tier is restricted to read-only API access mode'
    };
  }

  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    {
      api_key?: {
        api_key_id?: string;
        workspace_id?: string;
        key_prefix?: string;
        name?: string;
        scopes?: string[];
        status?: APIKeyStatus;
        logical_key_id?: string;
        expires_at?: string;
        created_by?: string;
      };
      raw_secret?: string;
    }
  >(
    'creativanta.workspace.v1.APIKeyService/Create',
    {
      idempotency_key: options.idempotencyKey || generateIdempotencyKey('apikey-create'),
      workspace_id: params.workspaceId,
      name: (params.name || '').trim() || 'API Key',
      scopes: params.scopes
    },
    {
      ...options,
      workspaceId: options.workspaceId ?? params.workspaceId
    }
  );

  if (!rpcRes.ok) {
    return {
      ok: false,
      error: rpcRes.error.message
    };
  }

  const remoteKey = rpcRes.data?.api_key;
  const rawSecret = rpcRes.data?.raw_secret;
  if (!remoteKey?.api_key_id || !rawSecret) {
    return {
      ok: false,
      error: 'Phản hồi từ máy chủ thiếu thông tin khóa API (api_key_id/raw_secret). Không tạo khóa giả lập.'
    };
  }

  const key: APIKey = {
    apiKeyId: remoteKey.api_key_id,
    workspaceId: remoteKey.workspace_id || params.workspaceId || '',
    keyPrefix: remoteKey.key_prefix || rawSecret.slice(0, 10),
    name: remoteKey.name || params.name,
    scopes: remoteKey.scopes || params.scopes,
    status: remoteKey.status || 'active',
    logicalKeyId: remoteKey.logical_key_id || remoteKey.api_key_id,
    requestCount: 0,
    expiresAt:
      remoteKey.expires_at ||
      new Date(Date.now() + 90 * 24 * 60 * 60 * 1000).toISOString(),
    createdBy: remoteKey.created_by || 'authenticated_user'
  };

  developerStore.upsertRemoteKey(key);
  return { ok: true, key, rawSecret };
}

export async function rotateApiKeyRemote(
  params: { workspaceId?: string; apiKeyId: string },
  options: CanonicalRpcOptions = {}
): Promise<{
  ok: boolean;
  newKey?: APIKey;
  newSecret?: string;
  graceEndsAt?: string;
  error?: string;
}> {
  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    {
      new_key?: {
        api_key_id?: string;
        workspace_id?: string;
        key_prefix?: string;
        name?: string;
        scopes?: string[];
        logical_key_id?: string;
        expires_at?: string;
      };
      new_secret?: string;
      grace_ends_at?: string;
    }
  >(
    'creativanta.workspace.v1.APIKeyService/Rotate',
    {
      idempotency_key: options.idempotencyKey || generateIdempotencyKey('apikey-rotate'),
      workspace_id: params.workspaceId,
      api_key_id: params.apiKeyId
    },
    {
      ...options,
      workspaceId: options.workspaceId ?? params.workspaceId
    }
  );

  if (!rpcRes.ok) {
    return {
      ok: false,
      error: rpcRes.error.message
    };
  }

  const newKeyData = rpcRes.data?.new_key;
  const newSecret = rpcRes.data?.new_secret;
  if (!newKeyData?.api_key_id || !newSecret) {
    return {
      ok: false,
      error: 'Phản hồi từ máy chủ thiếu khóa xoay vòng mới (fail-closed).'
    };
  }

  const graceEndsAt =
    rpcRes.data?.grace_ends_at || new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString();

  const newKey: APIKey = {
    apiKeyId: newKeyData.api_key_id,
    workspaceId: newKeyData.workspace_id || params.workspaceId || '',
    keyPrefix: newKeyData.key_prefix || newSecret.slice(0, 10),
    name: newKeyData.name || 'Rotated API Key',
    scopes: newKeyData.scopes || ['read:content'],
    status: 'active',
    logicalKeyId: newKeyData.logical_key_id || params.apiKeyId,
    requestCount: 0,
    expiresAt:
      newKeyData.expires_at ||
      new Date(Date.now() + 90 * 24 * 60 * 60 * 1000).toISOString(),
    createdBy: 'authenticated_user'
  };

  developerStore.upsertRemoteKey(newKey);
  return {
    ok: true,
    newKey,
    newSecret,
    graceEndsAt
  };
}

export async function revokeApiKeyRemote(
  params: { workspaceId?: string; apiKeyId: string },
  options: CanonicalRpcOptions = {}
): Promise<{ ok: boolean; error?: string }> {
  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    { revoked?: boolean; status?: string }
  >(
    'creativanta.workspace.v1.APIKeyService/Revoke',
    {
      idempotency_key: options.idempotencyKey || generateIdempotencyKey('apikey-revoke'),
      workspace_id: params.workspaceId,
      api_key_id: params.apiKeyId
    },
    {
      ...options,
      workspaceId: options.workspaceId ?? params.workspaceId
    }
  );

  if (!rpcRes.ok) {
    return {
      ok: false,
      error: rpcRes.error.message
    };
  }

  developerStore.revokeKey(params.apiKeyId);
  return { ok: true };
}

export async function registerWebhookRemote(
  params: {
    workspaceId?: string;
    targetUrl: string;
    eventTypes: string[];
  },
  options: CanonicalRpcOptions = {}
): Promise<{
  ok: boolean;
  subscription?: WebhookSubscription;
  secret?: string;
  error?: string;
}> {
  if (!params.targetUrl || !params.targetUrl.trim().startsWith('https://')) {
    return {
      ok: false,
      error: 'Webhook endpoint URL phải bắt đầu bằng https://'
    };
  }

  const rpcRes = await callCanonicalRpc<
    Record<string, unknown>,
    {
      subscription?: {
        subscription_id?: string;
        workspace_id?: string;
        target_url?: string;
        event_types?: string[];
        status?: WebhookStatus;
      };
      signing_secret?: string;
    }
  >(
    'creativanta.workspace.v1.WebhookService/Create',
    {
      idempotency_key: options.idempotencyKey || generateIdempotencyKey('webhook-create'),
      workspace_id: params.workspaceId,
      target_url: params.targetUrl.trim(),
      event_types: params.eventTypes
    },
    {
      ...options,
      workspaceId: options.workspaceId ?? params.workspaceId
    }
  );

  if (!rpcRes.ok) {
    return {
      ok: false,
      error: rpcRes.error.message
    };
  }

  const remoteSub = rpcRes.data?.subscription;
  const secret = rpcRes.data?.signing_secret;
  if (!remoteSub?.subscription_id || !secret) {
    return {
      ok: false,
      error: 'Phản hồi từ máy chủ thiếu subscription_id hoặc signing_secret (fail-closed).'
    };
  }

  const sub: WebhookSubscription = {
    subscriptionId: remoteSub.subscription_id,
    workspaceId: remoteSub.workspace_id || params.workspaceId || '',
    targetUrl: remoteSub.target_url || params.targetUrl.trim(),
    eventTypes: remoteSub.event_types || params.eventTypes,
    status: remoteSub.status || 'active',
    consecutiveFailureCount: 0
  };

  developerStore.upsertRemoteWebhook(sub);
  return { ok: true, subscription: sub, secret };
}
