import { describe, expect, it } from 'vitest';
import {
  ADMIN_UI_ENABLED,
  CANONICAL_WORKSPACE_ROLES,
  canAccessAdmin,
  evaluateAdminListenerAccess,
  evaluateAppealReviewAction,
  evaluateImpersonationAction,
  evaluateKillSwitchToggle,
  evaluateModerationDecision,
  evaluateOperationalHealthSeparation,
  evaluateSupportTicketAccess,
  evaluateKBAdminAccess,
  evaluateBackupRestoreAndSmokeRehearsal,
  evaluateProviderAndLicenseFreshnessGate,
  evaluateAdminComplianceAndSecurityGuards,
  evaluateFullScopeAcceptanceAndReleaseDecision,
  CANONICAL_31_MODULES,
  CANONICAL_6_MODES,
  isArticleStale,
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

  it('restricts Knowledge Base management to content_admin/super_admin and rejects workspace roles', () => {
    // Reject unauthenticated
    expect(evaluateKBAdminAccess(null).allowed).toBe(false);

    // Reject workspace role (owner)
    expect(
      evaluateKBAdminAccess({
        sessionId: 's-1',
        adminId: 'a-1',
        role: 'owner',
        internalAdmin: false,
        vpnVerified: true,
        mfaVerified: true,
        status: 'active',
        expiresAtMs: Date.now() + 10000
      }).allowed
    ).toBe(false);

    // Allow content_admin
    expect(
      evaluateKBAdminAccess({
        sessionId: 's-2',
        adminId: 'a-2',
        role: 'content_admin',
        internalAdmin: true,
        vpnVerified: true,
        mfaVerified: true,
        status: 'active',
        expiresAtMs: Date.now() + 10000
      }).allowed
    ).toBe(true);

    // Stale article detection (90 days)
    const nowMs = Date.parse('2026-11-02T10:00:00Z');
    const freshIso = new Date(nowMs - 30 * 24 * 60 * 60 * 1000).toISOString();
    const staleIso = new Date(nowMs - 95 * 24 * 60 * 60 * 1000).toISOString();

    expect(isArticleStale(freshIso, nowMs).isStale).toBe(false);
    expect(isArticleStale(staleIso, nowMs).isStale).toBe(true);
    expect(isArticleStale(staleIso, nowMs).daysSinceReview).toBe(95);
  });

  it('enforces P8-03 moderation appeal audit and SAFE-2026-02 false-positive clearance rules', () => {
    // 1. Role boundary: ops_admin cannot review moderation appeals
    const unauthorized = evaluateAppealReviewAction({
      adminRole: 'ops_admin',
      appealedByUserId: 'user-app-1',
      category: 'medical_claim_warning',
      resolution: 'overturned',
      resolutionNotes: 'Approved'
    });
    expect(unauthorized.allowed).toBe(false);
    expect(unauthorized.errorCode).toBe('ADMIN_FORBIDDEN_001');

    // 2. Conflict of interest EC-S26-002: admin cannot review their own appeal
    const conflict = evaluateAppealReviewAction({
      adminRole: 'content_admin',
      adminLinkedUserId: 'user-admin-1',
      appealedByUserId: 'user-admin-1',
      category: 'medical_claim_warning',
      resolution: 'overturned',
      resolutionNotes: 'Self appeal'
    });
    expect(conflict.allowed).toBe(false);
    expect(conflict.errorCode).toBe('ADMIN_CONFLICT_001');

    // 3. SAFE-2026-02: Overturning hard-block requires evidenceRef and falsePositiveJustification
    const hardBlockWithoutEvidence = evaluateAppealReviewAction({
      adminRole: 'content_admin',
      adminLinkedUserId: 'user-admin-2',
      appealedByUserId: 'user-app-1',
      category: 'phishing_malware',
      resolution: 'overturned',
      resolutionNotes: 'User said it was fine'
    });
    expect(hardBlockWithoutEvidence.allowed).toBe(false);
    expect(hardBlockWithoutEvidence.errorCode).toBe('SAFE_FORBIDDEN_001');

    // 4. Overturning hard-block with complete false-positive clearance evidence succeeds
    const validOverturnHardBlock = evaluateAppealReviewAction({
      adminRole: 'content_admin',
      adminLinkedUserId: 'user-admin-2',
      appealedByUserId: 'user-app-1',
      category: 'phishing_malware',
      resolution: 'overturned',
      resolutionNotes: 'Audited external domain validation report confirms legitimate partner checkout portal',
      evidenceRef: 'https://security.creativanta.internal/ev/FP-2026-8812.pdf',
      falsePositiveJustification: 'Vendor domain was mistakenly flagged by upstream heuristic signature #4092'
    });
    expect(validOverturnHardBlock.allowed).toBe(true);
    expect(validOverturnHardBlock.falsePositiveCleared).toBe(true);

    // 5. Normal appeal upheld
    const validUpheld = evaluateAppealReviewAction({
      adminRole: 'super_admin',
      appealedByUserId: 'user-app-1',
      category: 'unlicensed_rights_violation',
      resolution: 'upheld',
      resolutionNotes: 'Confirmed copyright infringement on uploaded audio asset'
    });
    expect(validUpheld.allowed).toBe(true);
    expect(validUpheld.falsePositiveCleared).toBe(false);
  });

  it('enforces P8-03 Support Desk internal note isolation from workspace roles', () => {
    const messages = [
      { id: 'm-1', senderRole: 'customer', internalOnly: false, content: 'Cannot connect TikTok shop' },
      { id: 'm-2', senderRole: 'support_admin', internalOnly: true, content: 'User token revoked due to suspected replay attack. Escalating to tech admin.' },
      { id: 'm-3', senderRole: 'support_admin', internalOnly: false, content: 'We are investigating your connection issue.' }
    ];

    // Workspace owner caller: internal note is stripped completely
    const workspaceView = evaluateSupportTicketAccess({
      callerRole: 'owner',
      isInternalAdmin: false,
      messages
    });
    expect(workspaceView.canViewInternalNotes).toBe(false);
    expect(workspaceView.canAddInternalNote).toBe(false);
    expect(workspaceView.visibleMessages).toHaveLength(2);
    expect(workspaceView.visibleMessages.some((m) => m.internalOnly)).toBe(false);

    // Support admin caller: sees all messages including internal note
    const adminView = evaluateSupportTicketAccess({
      callerRole: 'support_admin',
      isInternalAdmin: true,
      messages
    });
    expect(adminView.canViewInternalNotes).toBe(true);
    expect(adminView.canAddInternalNote).toBe(true);
    expect(adminView.visibleMessages).toHaveLength(3);
    expect(adminView.visibleMessages.some((m) => m.internalOnly)).toBe(true);
  });

  it('enforces technical health score separation from business metrics and evaluates 5 proactive coaching rules', () => {
    const verdict = evaluateOperationalHealthSeparation({
      availabilityPct: 99.9,
      errorRatePct: 0.1,
      p95LatencyMs: 150,
      rateLimitUsagePct: 65,
      mrrCents: 12500000,
      activeWorkspaces: 850,
      churnRatePct: 1.2,
      coachingInputs: {
        shopResponseRatePct: 82, // triggers rule 1 (< 90%)
        listingQualityPct: 75,   // triggers rule 2 (< 80%)
        delayedFulfillmentCount: 3, // triggers rule 3 (> 0)
        engagementDropPct: 28,  // triggers rule 4 (> 20%)
        connectorAuthExpiresInDays: 2 // triggers rule 5 (<= 3 days)
      }
    });

    // Technical score is healthy and near maximum
    expect(verdict.technicalScore).toBeGreaterThanOrEqual(95);
    expect(verdict.technicalStatus).toBe('healthy');
    expect(verdict.businessMetricsDecoupled).toBe(true);

    // All 5 PRD §36B proactive coaching cards are generated
    expect(verdict.coachingCount).toBe(5);
    expect(verdict.coachingCards.map((c) => c.rule)).toEqual([
      'shop_response_rate_low',
      'listing_quality_low',
      'fulfillment_delayed',
      'engagement_drop_detected',
      'connector_auth_expiring_soon'
    ]);
    expect(verdict.coachingCards.map((c) => c.targetCta)).toEqual([
      '/inbox',
      '/store',
      '/orders',
      '/attribution',
      '/settings/connections'
    ]);
  });

  it('enforces P8-08 Target 1: real backup/restore SHA-256 verification and automatic rollback on failing smoke', () => {
    const validHash = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';

    // Healthy restore & smoke promotes candidate green slot
    const passed = evaluateBackupRestoreAndSmokeRehearsal({
      expectedSha256: validHash,
      actualSha256: validHash,
      debitMicroUnits: 15000000000,
      creditMicroUnits: 15000000000,
      rpoSeconds: 0,
      rtoSeconds: 420,
      previousSlot: 'blue',
      candidateSlot: 'green',
      healthzOk: true,
      readyzReady: true,
      businessSmokePassed: true,
      auditSequenceIntact: true
    });
    expect(passed.allowed).toBe(true);
    expect(passed.candidatePromoted).toBe(true);
    expect(passed.rollbackTriggered).toBe(false);
    expect(passed.activeSlot).toBe('green');

    // Tampered SHA-256 fails closed
    const badChecksum = evaluateBackupRestoreAndSmokeRehearsal({
      expectedSha256: validHash,
      actualSha256: '0000000000000000000000000000000000000000000000000000000000000000',
      debitMicroUnits: 15000000000,
      creditMicroUnits: 15000000000,
      rpoSeconds: 0,
      rtoSeconds: 420,
      previousSlot: 'blue',
      candidateSlot: 'green',
      healthzOk: true,
      readyzReady: true,
      businessSmokePassed: true,
      auditSequenceIntact: true
    });
    expect(badChecksum.allowed).toBe(false);
    expect(badChecksum.errorCode).toBe('RESTORE_CHECKSUM_001');
    expect(badChecksum.activeSlot).toBe('blue');

    // Failing business smoke triggers automatic rollback to previousSlot
    const failedSmoke = evaluateBackupRestoreAndSmokeRehearsal({
      expectedSha256: validHash,
      actualSha256: validHash,
      debitMicroUnits: 15000000000,
      creditMicroUnits: 15000000000,
      rpoSeconds: 0,
      rtoSeconds: 420,
      previousSlot: 'blue',
      candidateSlot: 'green',
      healthzOk: true,
      readyzReady: true,
      businessSmokePassed: false,
      auditSequenceIntact: true
    });
    expect(failedSmoke.allowed).toBe(false);
    expect(failedSmoke.rollbackTriggered).toBe(true);
    expect(failedSmoke.activeSlot).toBe('blue');
    expect(failedSmoke.errorCode).toBe('SMOKE_FAILED_001');
  });

  it('enforces P8-08 Target 2: rejects stale provider/connector/workflow evidence and preserves LOCAL_IMPLEMENTED gate', () => {
    const freshVerdict = evaluateProviderAndLicenseFreshnessGate({
      nowMs,
      rateCardVerifiedAtMs: nowMs - 2 * 24 * 60 * 60 * 1000,
      rateCardValidUntilMs: nowMs + 28 * 24 * 60 * 60 * 1000,
      rateCardEnabled: true,
      connectorClaimedState: 'native_now',
      connectorScopeGranted: true,
      connectorAppReviewApproved: true,
      connectorValidUntilMs: nowMs + 28 * 24 * 60 * 60 * 1000,
      workflowRuntimeMode: 'owned_go_runtime',
      workflowEnterpriseLicenseVerified: false,
      legalDocsPublished: true,
      externalLegalCounselSignoff: false // LEG-H-001 open
    });
    expect(freshVerdict.noStaleEvidence).toBe(true);
    expect(freshVerdict.maxEvidenceState).toBe('LOCAL_IMPLEMENTED');
    expect(freshVerdict.externalGatesUnmet).toHaveLength(1);

    // Unverified native_now connector or expired rate card is rejected and downgraded to manual
    const staleVerdict = evaluateProviderAndLicenseFreshnessGate({
      nowMs,
      rateCardVerifiedAtMs: nowMs - 45 * 24 * 60 * 60 * 1000,
      rateCardValidUntilMs: nowMs - 1000,
      rateCardEnabled: true,
      connectorClaimedState: 'native_now',
      connectorScopeGranted: true,
      connectorAppReviewApproved: false,
      connectorValidUntilMs: nowMs + 28 * 24 * 60 * 60 * 1000,
      workflowRuntimeMode: 'activepieces_enterprise_embed',
      workflowEnterpriseLicenseVerified: false,
      legalDocsPublished: true,
      externalLegalCounselSignoff: false
    });
    expect(staleVerdict.noStaleEvidence).toBe(false);
    expect(staleVerdict.errorCode).toBe('STALE_PROVIDER_EVIDENCE');
    expect(staleVerdict.effectiveConnectorState).toBe('manual');
    expect(staleVerdict.effectiveWorkflowRuntime).toBe('owned_go_runtime');
  });

  it('enforces P8-08 Target 3: EC-M23-003 concurrent impersonation, EC-M23-004 override alert, EC-M23-005 audit sequence lock & 72h breach timer', () => {
    // 1. Concurrent impersonation blocked (EC-M23-003)
    const concurrentImp = evaluateAdminComplianceAndSecurityGuards({
      adminRole: 'ops_admin',
      activeImpersonationExistsForTargetUser: true,
      attemptConcurrentImpersonation: true,
      overridesInLast24h: 2,
      auditSequenceGapDetected: false,
      breachElapsedHours: 12
    });
    expect(concurrentImp.allowed).toBe(false);
    expect(concurrentImp.concurrentImpersonationBlocked).toBe(true);
    expect(concurrentImp.errorCode).toBe('ADMIN_CONFLICT_001');
    expect(concurrentImp.breachRemainingHours).toBe(60);

    // 2. >10 overrides/24h triggers Super Admin alert (EC-M23-004)
    const alertVerdict = evaluateAdminComplianceAndSecurityGuards({
      adminRole: 'ops_admin',
      activeImpersonationExistsForTargetUser: false,
      attemptConcurrentImpersonation: false,
      overridesInLast24h: 10,
      auditSequenceGapDetected: false,
      breachElapsedHours: 12
    });
    expect(alertVerdict.allowed).toBe(true);
    expect(alertVerdict.superAdminOverrideAlertTriggered).toBe(true);

    // 3. >50 overrides/24h without Super Admin approval token is blocked (EC-M23-004)
    const blockedOverride = evaluateAdminComplianceAndSecurityGuards({
      adminRole: 'ops_admin',
      activeImpersonationExistsForTargetUser: false,
      attemptConcurrentImpersonation: false,
      overridesInLast24h: 50,
      auditSequenceGapDetected: false,
      breachElapsedHours: 12
    });
    expect(blockedOverride.allowed).toBe(false);
    expect(blockedOverride.errorCode).toBe('ADMIN_RATELIMIT_004');

    // 4. Audit log sequence gap locks audit log read-only and creates Sev1 incident (EC-M23-005)
    const seqGap = evaluateAdminComplianceAndSecurityGuards({
      adminRole: 'super_admin',
      activeImpersonationExistsForTargetUser: false,
      attemptConcurrentImpersonation: false,
      overridesInLast24h: 1,
      auditSequenceGapDetected: true,
      breachElapsedHours: 12
    });
    expect(seqGap.allowed).toBe(false);
    expect(seqGap.auditLogReadOnlyLocked).toBe(true);
    expect(seqGap.sev1IncidentCreated).toBe(true);
    expect(seqGap.errorCode).toBe('AUDIT_LOCKED_005');
  });

  it('enforces P8-09: full-scope acceptance, 31 modules, 6 operator modes, zero untracked scope, and explicit external gates', () => {
    // 1. Happy path: all 31 modules, 6 modes, 60 tasks, 0 untracked scope -> CONDITIONAL_READY_LOCAL
    const fullScopeVerdict = evaluateFullScopeAcceptanceAndReleaseDecision({
      adminRole: 'super_admin',
      auditedModuleIds: [...CANONICAL_31_MODULES],
      auditedModeIds: [...CANONICAL_6_MODES],
      verifiedTaskCount: 60,
      untrackedRemainingScopeCount: 0,
      assertProductionLaunch: false,
      legalSignoffGranted: false, // LEG-H-001 open
      liveProviderApproved: false, // EXT-GATE open
      stagingDrRehearsalPassed: false // EXT-GATE open
    });
    expect(fullScopeVerdict.allowed).toBe(true);
    expect(fullScopeVerdict.allModulesVerified).toBe(true);
    expect(fullScopeVerdict.allModesVerified).toBe(true);
    expect(fullScopeVerdict.allTasksVerified).toBe(true);
    expect(fullScopeVerdict.zeroUntrackedScope).toBe(true);
    expect(fullScopeVerdict.releaseDecision).toBe('CONDITIONAL_READY_LOCAL');
    expect(fullScopeVerdict.productionLaunchApproved).toBe(false);
    expect(fullScopeVerdict.unmetExternalGatesCount).toBe(3);
    expect(fullScopeVerdict.externalGates).toHaveLength(3);

    // 2. Missing module or missing operator mode blocks release
    const missingModuleVerdict = evaluateFullScopeAcceptanceAndReleaseDecision({
      adminRole: 'super_admin',
      auditedModuleIds: CANONICAL_31_MODULES.slice(0, 30), // missing 1 module
      auditedModeIds: [...CANONICAL_6_MODES],
      verifiedTaskCount: 60,
      untrackedRemainingScopeCount: 0,
      assertProductionLaunch: false,
      legalSignoffGranted: false,
      liveProviderApproved: false,
      stagingDrRehearsalPassed: false
    });
    expect(missingModuleVerdict.allowed).toBe(false);
    expect(missingModuleVerdict.errorCode).toBe('RELEASE_BLOCKED_SCOPE');
    expect(missingModuleVerdict.releaseDecision).toBe('RELEASE_BLOCKED');

    // 3. Untracked remaining scope (> 0) blocks release
    const untrackedScopeVerdict = evaluateFullScopeAcceptanceAndReleaseDecision({
      adminRole: 'super_admin',
      auditedModuleIds: [...CANONICAL_31_MODULES],
      auditedModeIds: [...CANONICAL_6_MODES],
      verifiedTaskCount: 60,
      untrackedRemainingScopeCount: 2, // untracked scope exists
      assertProductionLaunch: false,
      legalSignoffGranted: false,
      liveProviderApproved: false,
      stagingDrRehearsalPassed: false
    });
    expect(untrackedScopeVerdict.allowed).toBe(false);
    expect(untrackedScopeVerdict.errorCode).toBe('RELEASE_BLOCKED_SCOPE');

    // 4. Fake production launch assertion while external gates open fails closed
    const fakeLaunchVerdict = evaluateFullScopeAcceptanceAndReleaseDecision({
      adminRole: 'super_admin',
      auditedModuleIds: [...CANONICAL_31_MODULES],
      auditedModeIds: [...CANONICAL_6_MODES],
      verifiedTaskCount: 60,
      untrackedRemainingScopeCount: 0,
      assertProductionLaunch: true, // asserting production launch!
      legalSignoffGranted: false,
      liveProviderApproved: false,
      stagingDrRehearsalPassed: false
    });
    expect(fakeLaunchVerdict.allowed).toBe(false);
    expect(fakeLaunchVerdict.errorCode).toBe('EXTERNAL_GATES_OPEN');
    expect(fakeLaunchVerdict.productionLaunchApproved).toBe(false);

    // 5. Unauthorized role denied
    const unauthorizedVerdict = evaluateFullScopeAcceptanceAndReleaseDecision({
      adminRole: 'content_admin',
      auditedModuleIds: [...CANONICAL_31_MODULES],
      auditedModeIds: [...CANONICAL_6_MODES],
      verifiedTaskCount: 60,
      untrackedRemainingScopeCount: 0,
      assertProductionLaunch: false,
      legalSignoffGranted: false,
      liveProviderApproved: false,
      stagingDrRehearsalPassed: false
    });
    expect(unauthorizedVerdict.allowed).toBe(false);
    expect(unauthorizedVerdict.errorCode).toBe('ADMIN_FORBIDDEN_001');
  });
});
