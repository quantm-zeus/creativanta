import { describe, it, expect } from 'vitest';
import {
  getSlotQuota,
  isSlotQuotaExceeded,
  validateWizardProgression,
  getDriftSeverityBadgeInfo,
  TIER_SLOT_LIMITS,
} from './types';

describe('Module M08 — Continuity OS Frontend Tests', () => {
  describe('Subscription Tier Slot Quota (RULE-M08-003, AC 3)', () => {
    it('correctly returns slot limits for all subscription tiers', () => {
      expect(getSlotQuota('free')).toBe(1);
      expect(getSlotQuota('starter')).toBe(2);
      expect(getSlotQuota('pro')).toBe(5);
      expect(getSlotQuota('business')).toBe(15);
      expect(getSlotQuota('enterprise')).toBe(-1); // Unlimited
      expect(getSlotQuota('unknown')).toBe(1); // Default to free tier
    });

    it('identifies when character slot quota is exceeded', () => {
      // Free tier: 1 allowed
      expect(isSlotQuotaExceeded(0, 'free')).toBe(false);
      expect(isSlotQuotaExceeded(1, 'free')).toBe(true);
      expect(isSlotQuotaExceeded(2, 'free')).toBe(true);

      // Starter tier: 2 allowed
      expect(isSlotQuotaExceeded(1, 'starter')).toBe(false);
      expect(isSlotQuotaExceeded(2, 'starter')).toBe(true);

      // Pro tier: 5 allowed
      expect(isSlotQuotaExceeded(4, 'pro')).toBe(false);
      expect(isSlotQuotaExceeded(5, 'pro')).toBe(true);

      // Enterprise tier: unlimited
      expect(isSlotQuotaExceeded(100, 'enterprise')).toBe(false);
    });
  });

  describe('Wizard Progression and Preview Validation (RULE-M08-001, AC 1)', () => {
    it('allows steps 1 to 3 to proceed without final preview verification', () => {
      const res = validateWizardProgression(2, false, 'ai_generated', false);
      expect(res.valid).toBe(true);
    });

    it('rejects step 4 save if preview video was not verified (AC 1)', () => {
      const res = validateWizardProgression(4, false, 'ai_generated', false);
      expect(res.valid).toBe(false);
      expect(res.error).toContain('Preview');
    });

    it('rejects step 4 save if digital twin lacks likeness consent (RULE-M08-002, AC 2)', () => {
      const res = validateWizardProgression(4, true, 'digital_twin', false);
      expect(res.valid).toBe(false);
      expect(res.error).toContain('consent');
    });

    it('accepts step 4 save when preview is verified and consent is granted', () => {
      const resAI = validateWizardProgression(4, true, 'ai_generated', false);
      expect(resAI.valid).toBe(true);

      const resTwin = validateWizardProgression(4, true, 'digital_twin', true);
      expect(resTwin.valid).toBe(true);
    });
  });

  describe('Drift Severity Enforcement (RULE-M08-005, AC 4)', () => {
    it('high_drift blocks publish and triggers warnings', () => {
      const info = getDriftSeverityBadgeInfo('high_drift');
      expect(info.blocksPublish).toBe(true);
      expect(info.requiresWarning).toBe(true);
      expect(info.badgeClass).toContain('rose');
    });

    it('moderate_drift triggers warnings but allows publish', () => {
      const info = getDriftSeverityBadgeInfo('moderate_drift');
      expect(info.blocksPublish).toBe(false);
      expect(info.requiresWarning).toBe(true);
      expect(info.badgeClass).toContain('amber');
    });

    it('none and low_drift allow seamless publishing without warnings', () => {
      const infoNone = getDriftSeverityBadgeInfo('none');
      expect(infoNone.blocksPublish).toBe(false);
      expect(infoNone.requiresWarning).toBe(false);

      const infoLow = getDriftSeverityBadgeInfo('low_drift');
      expect(infoLow.blocksPublish).toBe(false);
      expect(infoLow.requiresWarning).toBe(false);
    });
  });
});
