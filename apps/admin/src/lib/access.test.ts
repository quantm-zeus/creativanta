import { describe, expect, it } from 'vitest';
import {
  ADMIN_UI_ENABLED,
  CANONICAL_WORKSPACE_ROLES,
  canAccessAdmin,
  evaluateAdminListenerAccess,
  evaluateImpersonationAction,
  evaluateKillSwitchToggle,
  evaluateModerationDecision,
  type VerifiedAdminSession
} from './access';

describe('P0-01 / P0-07 Internal Admin Isolation, Impersonation, Moderation & Kill Switch', () => {
  const nowMs = Date.parse('2026-11-02T09:00:00Z');

  const validSuperAdminSession: VerifiedAdminSession = {
    sessionId: '90000000-0000-4000-8000-000000000010',
    adminId: '90000000-0000-4000-8000-000000000001',
    role: 'super_admin',
    internalAdmin: true,
    vpnVerified: true,
    mfaVerified: true,
    status: 'active',
    expiresAtMs: nowMs + 8 * 60 * 60 * 1000
  };

  it('denies access without independent admin authentication', () => {
    expect(ADMIN_UI_ENABLED).toBe(false);
    expect(canAccessAdmin()).toBe(false);
  });

  it('rejects every workspace role on the isolated admin listener (Acceptance Target 2)', () => {
    for (const wsRole of CANONICAL_WORKSPACE_ROLES) {
      const verdict = evaluateAdminListenerAccess(
        {
          ...validSuperAdminSession,
          role: wsRole,
          internalAdmin: true
        },
        nowMs
      );
      expect(verdict.allowed).toBe(false);
      expect(verdict.errorCode).toBe('ADMIN_FORBIDDEN_001');
    }

    // Missing VPN or MFA is also rejected
    expect(
      evaluateAdminListenerAccess({ ...validSuperAdminSession, vpnVerified: false }, nowMs).allowed
    ).toBe(false);
    expect(
      evaluateAdminListenerAccess({ ...validSuperAdminSession, mfaVerified: false }, nowMs).allowed
    ).toBe(false);

    // Valid VPN + MFA internal admin session succeeds
    expect(canAccessAdmin(validSuperAdminSession, nowMs)).toBe(true);
  });

  it('enforces read-only impersonation and 30-minute auto-expiry (Acceptance Target 3)', () => {
    // Support admin without ticket is denied
    expect(
      evaluateImpersonationAction({
        adminRole: 'support_admin',
        startedAtMs: nowMs,
        nowMs: nowMs + 5 * 60 * 1000,
        reason: 'Investigating issue',
        attemptedActionType: 'read_query'
      }).allowed
    ).toBe(false);

    // Support admin with ticket can perform read_query within 30m
    const readVerdict = evaluateImpersonationAction({
      adminRole: 'support_admin',
      startedAtMs: nowMs,
      nowMs: nowMs + 10 * 60 * 1000,
      reason: 'Investigating ticket SUP-101',
      supportTicketId: 'SUP-101',
      attemptedActionType: 'read_query'
    });
    expect(readVerdict.allowed).toBe(true);
    expect(readVerdict.mode).toBe('read_only');

    // Mutating command is blocked even for super_admin during impersonation
    const writeVerdict = evaluateImpersonationAction({
      adminRole: 'super_admin',
      startedAtMs: nowMs,
      nowMs: nowMs + 5 * 60 * 1000,
      reason: 'Investigating workspace',
      attemptedActionType: 'mutating_command'
    });
    expect(writeVerdict.allowed).toBe(false);
    expect(writeVerdict.errorCode).toBe('ADMIN_CONFLICT_001');

    // Session auto-expires after 30 minutes
    const expiredVerdict = evaluateImpersonationAction({
      adminRole: 'super_admin',
      startedAtMs: nowMs,
      nowMs: nowMs + 31 * 60 * 1000,
      reason: 'Investigating workspace',
      attemptedActionType: 'read_query'
    });
    expect(expiredVerdict.allowed).toBe(false);
    expect(expiredVerdict.errorCode).toBe('AUTH_FORBIDDEN_001');
  });

  it('enforces moderation hard-block non-overridable rules (SAFE-2026-02) and self-review conflict guard (EC-S26-002)', () => {
    // Self-review conflict blocked
    const selfConflict = evaluateModerationDecision({
      adminRole: 'content_admin',
      adminLinkedUserId: 'user-99',
      flaggedUserId: 'user-99',
      category: 'medical_claim_warning',
      riskScore: 40,
      decision: 'approve',
      auditReason: 'Approving own post'
    });
    expect(selfConflict.allowed).toBe(false);

    // Hard-block category cannot be approved and is not overridable by workspace
    const hardBlockApprove = evaluateModerationDecision({
      adminRole: 'content_admin',
      adminLinkedUserId: 'user-99',
      flaggedUserId: 'user-100',
      category: 'revoked_clone_consent',
      riskScore: 95,
      decision: 'approve',
      auditReason: 'Try approve hard block'
    });
    expect(hardBlockApprove.allowed).toBe(false);
    expect(hardBlockApprove.hardBlock).toBe(true);
    expect(hardBlockApprove.overridableByWorkspace).toBe(false);
    expect(hardBlockApprove.slaHours).toBe(4);

    // Rejecting hard-block case succeeds
    const hardBlockReject = evaluateModerationDecision({
      adminRole: 'content_admin',
      adminLinkedUserId: 'user-99',
      flaggedUserId: 'user-100',
      category: 'revoked_clone_consent',
      riskScore: 95,
      decision: 'reject',
      auditReason: 'Confirmed revoked consent'
    });
    expect(hardBlockReject.allowed).toBe(true);
  });

  it('requires tech_admin/super_admin, MFA, and audit reason to toggle a Kill Switch', () => {
    expect(
      evaluateKillSwitchToggle({
        adminRole: 'analyst',
        mfaVerified: true,
        flagKey: 'kill_switch:tiktok',
        auditReason: 'Analyst try toggle'
      }).allowed
    ).toBe(false);

    expect(
      evaluateKillSwitchToggle({
        adminRole: 'tech_admin',
        mfaVerified: true,
        flagKey: 'kill_switch:tiktok',
        auditReason: 'Emergency upstream TikTok outage INC-2026-042'
      }).allowed
    ).toBe(true);
  });
});
