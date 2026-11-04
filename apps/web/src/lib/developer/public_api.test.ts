import { describe, it, expect, beforeEach } from 'vitest';
import {
  developerStore,
  canMutate,
  isReadOnlyScopes,
  evaluateKeyAuthentication,
  PermissionDeniedError,
  KeyExpiredError,
  ELIGIBLE_WEBHOOK_EVENTS,
  TIER_KEY_CAPS
} from './public_api';

describe('P7-05 S24 Public API & Developer Platform Suite', () => {
  beforeEach(() => {
    developerStore.reset();
  });

  describe('Acceptance Target 1: Read-only key cannot mutate', () => {
    it('allows read operations but strictly rejects mutating operations with PermissionDeniedError (403)', () => {
      developerStore.setTier('pro');
      const { key } = developerStore.createKey('Read-Only API Key', [
        'read:content',
        'read:orders'
      ]);

      expect(isReadOnlyScopes(key.scopes)).toBe(true);
      expect(canMutate('pro', key.scopes)).toBe(false);

      // Read call succeeds
      const readRes = developerStore.executeApiCall(key.apiKeyId, false, 0);
      expect(readRes.success).toBe(true);

      // Mutating call MUST throw PermissionDeniedError (403)
      expect(() => {
        developerStore.executeApiCall(key.apiKeyId, true, 0);
      }).toThrowError(PermissionDeniedError);
    });

    it('enforces Starter tier read-only mode regardless of requested scopes', () => {
      developerStore.setTier('starter');

      // Attempting to create a key with write scopes on Starter tier is rejected
      expect(() => {
        developerStore.createKey('Illegal Write Key', ['write:content']);
      }).toThrowError(PermissionDeniedError);

      // Valid read-only key on Starter tier
      const { key } = developerStore.createKey('Starter Key', ['read:content']);

      // Mutating call is blocked on Starter tier
      expect(() => {
        developerStore.executeApiCall(key.apiKeyId, true, 0);
      }).toThrowError(PermissionDeniedError);
    });

    it('allows mutating calls for keys with write scopes on Pro tier', () => {
      developerStore.setTier('pro');
      const { key } = developerStore.createKey('Read-Write Key', [
        'read:content',
        'write:content'
      ]);

      expect(isReadOnlyScopes(key.scopes)).toBe(false);
      expect(canMutate('pro', key.scopes)).toBe(true);

      const mutateRes = developerStore.executeApiCall(key.apiKeyId, true, 2.5);
      expect(mutateRes.success).toBe(true);
    });
  });

  describe('Tier Key Capacities & Rotation Lifecycle', () => {
    it('enforces tier key limits (Starter: 3 keys, Pro: 10 keys)', () => {
      developerStore.setTier('starter');

      // Create 3 keys
      developerStore.createKey('Key 1', ['read:content']);
      developerStore.createKey('Key 2', ['read:content']);
      developerStore.createKey('Key 3', ['read:content']);

      // 4th key exceeds Starter capacity (3)
      expect(() => {
        developerStore.createKey('Key 4', ['read:content']);
      }).toThrowError(/allows a maximum of 3 active keys/);

      // Upgrade to Pro allows up to 10 keys
      developerStore.setTier('pro');
      const { key: key4 } = developerStore.createKey('Key 4', ['read:content']);
      expect(key4.status).toBe('active');
    });

    it('supports key rotation with a 24h grace window where both keys are accepted', () => {
      developerStore.setTier('pro');
      const { key: origKey } = developerStore.createKey('Production Key', [
        'read:content',
        'write:content'
      ]);

      const rotation = developerStore.rotateKey(origKey.apiKeyId);
      expect(rotation.newKey.status).toBe('active');
      expect(rotation.graceEndsAt).toBeDefined();

      // Within grace window: both keys evaluate as valid
      const now = new Date();
      expect(evaluateKeyAuthentication(origKey, now).valid).toBe(true);
      expect(evaluateKeyAuthentication(rotation.newKey, now).valid).toBe(true);

      // After 24h grace period: old key is expired, new key remains active
      const afterGrace = new Date(now.getTime() + 25 * 60 * 60 * 1000);
      const oldAuth = evaluateKeyAuthentication(
        {
          ...origKey,
          status: 'rotating',
          rotationGraceEndsAt: rotation.graceEndsAt
        },
        afterGrace
      );
      expect(oldAuth.valid).toBe(false);
      expect(oldAuth.reason).toContain('24h grace period ended');

      expect(evaluateKeyAuthentication(rotation.newKey, afterGrace).valid).toBe(true);
    });

    it('immediately invalidates revoked keys', () => {
      developerStore.setTier('pro');
      const { key } = developerStore.createKey('Disposable Key', ['read:content']);

      developerStore.revokeKey(key.apiKeyId);

      expect(() => {
        developerStore.executeApiCall(key.apiKeyId, false, 0);
      }).toThrowError(KeyExpiredError);
    });
  });

  describe('Acceptance Target 2: Webhooks & Auto-Suspension', () => {
    it('registers subscriptions for eligible events and generates signing secret', () => {
      const { subscription, secret } = developerStore.createWebhook(
        'https://partner.com/webhook',
        ['workflow.completed', 'content.published']
      );

      expect(subscription.status).toBe('active');
      expect(secret).toMatch(/^whsec_/);
      expect(subscription.eventTypes).toContain('workflow.completed');
    });

    it('auto-suspends webhook subscription after 100 consecutive failures (RULE-S24-006)', () => {
      const { subscription } = developerStore.createWebhook(
        'https://failing.app/hook',
        ['order.created']
      );

      // Simulate 99 failures -> remains active
      for (let i = 0; i < 99; i++) {
        developerStore.recordWebhookOutcome(subscription.subscriptionId, false, '500 Server Error');
      }

      let currentSub: any;
      developerStore.subscribe((s) => {
        currentSub = s.webhooks.find((w) => w.subscriptionId === subscription.subscriptionId);
      })();
      expect(currentSub.consecutiveFailureCount).toBe(99);
      expect(currentSub.status).toBe('active');

      // 100th consecutive failure -> auto-suspended!
      developerStore.recordWebhookOutcome(subscription.subscriptionId, false, '500 Server Error');

      developerStore.subscribe((s) => {
        currentSub = s.webhooks.find((w) => w.subscriptionId === subscription.subscriptionId);
      })();
      expect(currentSub.consecutiveFailureCount).toBe(100);
      expect(currentSub.status).toBe('suspended');
    });

    it('resets failure count to 0 upon successful delivery', () => {
      const { subscription } = developerStore.createWebhook(
        'https://recovering.app/hook',
        ['asset.ready']
      );

      developerStore.recordWebhookOutcome(subscription.subscriptionId, false, '408 Timeout');
      developerStore.recordWebhookOutcome(subscription.subscriptionId, false, '408 Timeout');
      developerStore.recordWebhookOutcome(subscription.subscriptionId, true);

      let currentSub: any;
      developerStore.subscribe((s) => {
        currentSub = s.webhooks.find((w) => w.subscriptionId === subscription.subscriptionId);
      })();
      expect(currentSub.consecutiveFailureCount).toBe(0);
      expect(currentSub.lastError).toBeUndefined();
    });
  });
});
