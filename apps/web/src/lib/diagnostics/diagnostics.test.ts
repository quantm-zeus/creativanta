import { describe, it, expect } from 'vitest';
import {
  CANONICAL_QUEUE_SPECS,
  CANONICAL_DIAGNOSTIC_CATEGORIES,
  evaluateExternalEffectRetryGuard,
  evaluateDiagnosticsPermission,
  sanitizeUserFacingDiagnosticMessage,
  evaluateRepairWizardTransition
} from './index';

describe('Web Diagnostics Center (W125 / P0-05)', () => {
  it('defines all 11 canonical durable queues and 8 diagnostic health categories', () => {
    expect(CANONICAL_QUEUE_SPECS).toHaveLength(11);
    expect(CANONICAL_DIAGNOSTIC_CATEGORIES).toHaveLength(8);
    const queueNames = CANONICAL_QUEUE_SPECS.map((q) => q.name);
    expect(queueNames).toContain('publish_jobs');
    expect(queueNames).toContain('webhook_delivery');
    expect(queueNames).toContain('reconciliation');
  });

  it('never allows blind retry when external_effects status is unknown or submitted', () => {
    const unknownVerdict = evaluateExternalEffectRetryGuard('unknown');
    expect(unknownVerdict.allowBlindRetry).toBe(false);
    expect(unknownVerdict.decision).toBe('blocked_requires_reconciliation');

    const submittedVerdict = evaluateExternalEffectRetryGuard('submitted');
    expect(submittedVerdict.allowBlindRetry).toBe(false);
    expect(submittedVerdict.decision).toBe('blocked_requires_reconciliation');

    const succeededVerdict = evaluateExternalEffectRetryGuard('succeeded');
    expect(succeededVerdict.allowBlindRetry).toBe(false);
    expect(succeededVerdict.decision).toBe('already_succeeded');

    const preparedVerdict = evaluateExternalEffectRetryGuard('prepared');
    expect(preparedVerdict.allowBlindRetry).toBe(true);
    expect(preparedVerdict.decision).toBe('proceed');
  });

  it('enforces RBAC for diagnostics:read and workspace:settings:manage (Owner/Admin only)', () => {
    expect(evaluateDiagnosticsPermission('owner', 'read').allowed).toBe(true);
    expect(evaluateDiagnosticsPermission('admin', 'repair').allowed).toBe(true);
    expect(evaluateDiagnosticsPermission('manager', 'read').allowed).toBe(false);
    expect(evaluateDiagnosticsPermission('editor', 'repair').allowed).toBe(false);
    expect(evaluateDiagnosticsPermission('viewer', 'read').allowed).toBe(false);
  });

  it('enforces RULE-M23-A04 by stripping raw SQL, stack traces, and tokens from user-facing messages', () => {
    const leaked = "SELECT * FROM connected_accounts WHERE access_token = 'secret'";
    const sanitized = sanitizeUserFacingDiagnosticMessage(leaked);
    expect(sanitized.toLowerCase()).not.toContain('select ');
    expect(sanitized.toLowerCase()).not.toContain('access_token');

    const safe = 'Kết nối tới TikTok Shop phản hồi chậm hơn thời gian chờ.';
    expect(sanitizeUserFacingDiagnosticMessage(safe)).toBe(safe);
  });

  it('blocks Step 3 of the 4-step Guided Repair Wizard on unknown external effects without verification reference', () => {
    const step1 = evaluateRepairWizardTransition(1, true, '');
    expect(step1.allowed).toBe(true);
    expect(step1.nextStep).toBe(2);

    const step3Blocked = evaluateRepairWizardTransition(3, true, '   ');
    expect(step3Blocked.allowed).toBe(false);
    expect(step3Blocked.statusLabel).toBe('blocked');

    const step3Allowed = evaluateRepairWizardTransition(3, true, 'tiktok_post_verified_9988');
    expect(step3Allowed.allowed).toBe(true);
    expect(step3Allowed.nextStep).toBe(4);

    const step4 = evaluateRepairWizardTransition(4, true, 'tiktok_post_verified_9988');
    expect(step4.allowed).toBe(true);
    expect(step4.statusLabel).toBe('resolved');
  });
});
