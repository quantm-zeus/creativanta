import { describe, expect, it } from 'vitest';
import {
  CANONICAL_CAPABILITY_MATRIX,
  computeCompositeHealthScore,
  evaluateActionCapability,
  evaluateConnectorMutationAccess,
  validateExplicitScopes,
  type ActionAccessVerificationInput
} from './index';

describe('P0-07 M22 Capability Verification Registry & Health Score', () => {
  const nowMs = Date.parse('2026-11-02T08:00:00Z');
  const tiktokPublish = CANONICAL_CAPABILITY_MATRIX.find(
    (item) => item.platform === 'tiktok' && item.actionKey === 'publish_post'
  )!;
  const shopeePublish = CANONICAL_CAPABILITY_MATRIX.find(
    (item) => item.platform === 'shopee' && item.actionKey === 'publish_post'
  )!;

  const validVerification: ActionAccessVerificationInput = {
    platform: 'tiktok',
    product: 'TikTok Content Posting API',
    actionKey: 'publish_post',
    appApprovalStatus: 'approved',
    requiredScopes: ['video.publish', 'video.upload'],
    grantedScopes: ['video.publish', 'video.upload', 'user.info.basic'],
    accountEligible: true,
    marketEligibility: ['VN', 'SG'],
    probeEndpoint: '/v2/post/publish/video/init/',
    probeMethod: 'POST',
    probeStatus: 'passed',
    checkedAtMs: nowMs - 2 * 60 * 1000, // 2m ago (< 10m TTL)
    validUntilMs: nowMs + 24 * 60 * 60 * 1000
  };

  it('blocks unverified, stale (>10m), GET-only probe, unsupported, and kill-switched routes from executing', () => {
    // 1. Missing verification -> manual, cannot execute, includes policyNote & fallbackPath
    const unverified = evaluateActionCapability(tiktokPublish, null, {
      nowMs,
      targetMarket: 'VN'
    });
    expect(unverified.state).toBe('manual');
    expect(unverified.executable).toBe(false);
    expect(unverified.policyNote.summary.length).toBeGreaterThan(10);
    expect(unverified.fallbackPath.instructions.length).toBeGreaterThan(10);

    // 2. Unsupported Shopee social post -> unsupported, cannot execute
    const unsupported = evaluateActionCapability(shopeePublish, validVerification, {
      nowMs,
      targetMarket: 'VN'
    });
    expect(unsupported.state).toBe('unsupported');
    expect(unsupported.executable).toBe(false);

    // 3. Stale snapshot (> 10 minutes old) -> manual, verificationFresh=false, executable=false
    const stale = evaluateActionCapability(
      tiktokPublish,
      { ...validVerification, checkedAtMs: nowMs - 15 * 60 * 1000 },
      { nowMs, targetMarket: 'VN' }
    );
    expect(stale.state).toBe('manual');
    expect(stale.verificationFresh).toBe(false);
    expect(stale.executable).toBe(false);

    // 4. Read-only GET probe on a write action -> read_only, executable=false
    const readOnlyProbe = evaluateActionCapability(
      tiktokPublish,
      { ...validVerification, probeMethod: 'GET' },
      { nowMs, targetMarket: 'VN' }
    );
    expect(readOnlyProbe.state).toBe('read_only');
    expect(readOnlyProbe.executable).toBe(false);

    // 5. Verified fresh POST probe -> native, executable=true
    const native = evaluateActionCapability(tiktokPublish, validVerification, {
      nowMs,
      targetMarket: 'VN'
    });
    expect(native.state).toBe('native');
    expect(native.executable).toBe(true);
    expect(native.verificationFresh).toBe(true);

    // 6. Active kill switch immediately degrades a verified route and blocks execution
    const killed = evaluateActionCapability(tiktokPublish, validVerification, {
      nowMs,
      targetMarket: 'VN',
      killSwitchActive: true,
      killSwitchReason: 'TikTok API incident INC-2026-042'
    });
    expect(killed.state).toBe('degraded');
    expect(killed.executable).toBe(false);
  });

  it('rejects wildcard scopes such as shop.*', () => {
    expect(validateExplicitScopes(['video.publish', 'video.upload']).valid).toBe(true);
    expect(validateExplicitScopes(['shop.*']).valid).toBe(false);
  });

  it('computes 40/25/20/15 composite health scores and triggers proactive coaching below 80', () => {
    const healthy = computeCompositeHealthScore({
      availabilityPct: 99,
      errorRatePct: 1,
      latencyP95Ms: 220,
      rateLimitRemainingPct: 90
    });
    expect(healthy.overallScore).toBeGreaterThanOrEqual(80);
    expect(healthy.statusBand).toBe('healthy');
    expect(healthy.proactiveCoachingAlert).toBe(false);

    const degraded = computeCompositeHealthScore({
      availabilityPct: 72,
      errorRatePct: 9,
      latencyP95Ms: 1400,
      rateLimitRemainingPct: 35
    });
    expect(degraded.overallScore).toBeLessThan(80);
    expect(degraded.proactiveCoachingAlert).toBe(true);
    expect(degraded.recommendedActions.length).toBeGreaterThan(0);
  });

  it('enforces read-only impersonation on connector mutations even for Owner role', () => {
    expect(evaluateConnectorMutationAccess('owner', 'disconnect', false).allowed).toBe(true);
    expect(evaluateConnectorMutationAccess('owner', 'disconnect', true).allowed).toBe(false);
    expect(evaluateConnectorMutationAccess('owner', 'connect', true).allowed).toBe(false);
    expect(evaluateConnectorMutationAccess('owner', 'read', true).allowed).toBe(true);
  });
});
