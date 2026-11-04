import { describe, expect, it } from 'vitest';
import {
  buildShareLinks,
  calculateReferralTier,
  CANONICAL_GROWTH_PROMPTS,
  CANONICAL_REFERRAL_TIERS,
  evaluatePaymentQualificationGate,
  evaluateRefundReversalGate,
  evaluateSelfReferralGate,
  formatFunnelMetrics
} from './index';

describe('P8-05 Web: Referral & Growth Engine', () => {
  describe('Acceptance Target 1: No immediate qualified reward on pending payment', () => {
    it('withholds qualified reward when payment is pending', () => {
      const result = evaluatePaymentQualificationGate('pending', 'pending');
      expect(result.canReward).toBe(false);
      expect(result.nextStatus).toBe('pending');
      expect(result.heldReason).toContain('đang chờ xử lý');
    });

    it('withholds reward when plan is unpaid', () => {
      const result = evaluatePaymentQualificationGate('unpaid', 'pending');
      expect(result.canReward).toBe(false);
      expect(result.nextStatus).toBe('pending');
    });

    it('denies reward if referral is flagged for fraud', () => {
      const result = evaluatePaymentQualificationGate('paid', 'fraud_flagged');
      expect(result.canReward).toBe(false);
      expect(result.nextStatus).toBe('fraud_flagged');
    });

    it('allows reward only when payment is settled (paid)', () => {
      const result = evaluatePaymentQualificationGate('paid', 'pending');
      expect(result.canReward).toBe(true);
      expect(result.nextStatus).toBe('rewarded');
    });
  });

  describe('Acceptance Target 2: Self-referral held for review', () => {
    it('flags self-referral with same user ID', () => {
      const gate = evaluateSelfReferralGate({
        referrerWorkspaceId: 'ws-1',
        refereeWorkspaceId: 'ws-2',
        referrerUserId: 'usr-same',
        refereeUserId: 'usr-same'
      });
      expect(gate.isSelfReferral).toBe(true);
      expect(gate.reason).toContain('người dùng');
    });

    it('flags self-referral within same workspace', () => {
      const gate = evaluateSelfReferralGate({
        referrerWorkspaceId: 'ws-same',
        refereeWorkspaceId: 'ws-same',
        referrerUserId: 'usr-1',
        refereeUserId: 'usr-2'
      });
      expect(gate.isSelfReferral).toBe(true);
      expect(gate.reason).toContain('Không gian làm việc');
    });

    it('flags self-referral matching IP address', () => {
      const gate = evaluateSelfReferralGate({
        referrerWorkspaceId: 'ws-1',
        refereeWorkspaceId: 'ws-2',
        ipMatch: true
      });
      expect(gate.isSelfReferral).toBe(true);
      expect(gate.reason).toContain('IP');
    });

    it('flags self-referral matching device fingerprint', () => {
      const gate = evaluateSelfReferralGate({
        referrerWorkspaceId: 'ws-1',
        refereeWorkspaceId: 'ws-2',
        deviceMatch: true
      });
      expect(gate.isSelfReferral).toBe(true);
      expect(gate.reason).toContain('thiết bị');
    });

    it('flags self-referral matching credit card fingerprint', () => {
      const gate = evaluateSelfReferralGate({
        referrerWorkspaceId: 'ws-1',
        refereeWorkspaceId: 'ws-2',
        cardMatch: true
      });
      expect(gate.isSelfReferral).toBe(true);
      expect(gate.reason).toContain('thẻ');
    });

    it('allows genuine referral between distinct entities', () => {
      const gate = evaluateSelfReferralGate({
        referrerWorkspaceId: 'ws-alpha',
        refereeWorkspaceId: 'ws-beta',
        referrerUserId: 'usr-alpha',
        refereeUserId: 'usr-beta',
        ipMatch: false,
        deviceMatch: false,
        cardMatch: false
      });
      expect(gate.isSelfReferral).toBe(false);
    });
  });

  describe('Acceptance Target 3: Replay / refund reverses once', () => {
    it('executes first refund reversal from rewarded status', () => {
      const rev = evaluateRefundReversalGate('rewarded');
      expect(rev.canReverse).toBe(true);
      expect(rev.isDuplicateReplay).toBe(false);
      expect(rev.nextStatus).toBe('revoked');
    });

    it('prevents double-reversal on idempotent duplicate replay', () => {
      const rev = evaluateRefundReversalGate('revoked');
      expect(rev.canReverse).toBe(false);
      expect(rev.isDuplicateReplay).toBe(true);
      expect(rev.nextStatus).toBe('revoked');
      expect(rev.message).toContain('Idempotent Replay');
    });
  });

  describe('Tier Progression and Multipliers', () => {
    it('calculates Bronze tier for 0 to 5 referrals', () => {
      const t0 = calculateReferralTier(0);
      expect(t0.currentTier).toBe('bronze');
      expect(t0.nextTier).toBe('silver');
      expect(t0.multiplierString).toBe('1.0x');
      expect(t0.recurringCommissionPercent).toBe(0);
      expect(t0.referralsToNextTier).toBe(6);

      const t5 = calculateReferralTier(5);
      expect(t5.currentTier).toBe('bronze');
      expect(t5.referralsToNextTier).toBe(1);
    });

    it('calculates Silver tier for 6 to 20 referrals', () => {
      const t6 = calculateReferralTier(6);
      expect(t6.currentTier).toBe('silver');
      expect(t6.nextTier).toBe('gold');
      expect(t6.multiplierString).toBe('1.5x');
      expect(t6.recurringCommissionPercent).toBe(0);
      expect(t6.referralsToNextTier).toBe(15);
    });

    it('calculates Gold tier with 10% recurring commission for 21 to 50 referrals', () => {
      const t21 = calculateReferralTier(21);
      expect(t21.currentTier).toBe('gold');
      expect(t21.nextTier).toBe('platinum');
      expect(t21.multiplierString).toBe('2.0x');
      expect(t21.recurringCommissionPercent).toBe(10);
    });

    it('calculates Platinum tier with 15% recurring commission for 51+ referrals', () => {
      const t55 = calculateReferralTier(55);
      expect(t55.currentTier).toBe('platinum');
      expect(t55.nextTier).toBeNull();
      expect(t55.multiplierString).toBe('2.5x');
      expect(t55.recurringCommissionPercent).toBe(15);
      expect(t55.progressPercent).toBe(100);
    });
  });

  describe('Growth Funnel & Social Sharing', () => {
    it('formats funnel conversion rates accurately', () => {
      const summary = formatFunnelMetrics(100, 25, 5, '150.000000', '50.000000');
      expect(summary.clickToSignupPercent).toBe('25.0%');
      expect(summary.signupToPaidPercent).toBe('20.0%');
      expect(summary.overallConversionPercent).toBe('5.0%');
      expect(summary.creditsEarned).toBe('150.000000');
    });

    it('constructs correct multi-channel sharing links', () => {
      const links = buildShareLinks('QUANNG2026', 'https://creativanta.vn');
      expect(links.shareUrl).toBe('https://creativanta.vn/r/QUANNG2026');
      expect(links.zaloUrl).toContain('zalo.me/share');
      expect(links.facebookUrl).toContain('facebook.com/sharer');
      expect(links.telegramUrl).toContain('t.me/share');
    });

    it('includes canonical viral prompts', () => {
      expect(CANONICAL_GROWTH_PROMPTS.length).toBeGreaterThanOrEqual(4);
      const publishPrompt = CANONICAL_GROWTH_PROMPTS.find((p) => p.type === 'first_publish');
      expect(publishPrompt).toBeDefined();
      expect(publishPrompt?.rewardCredits).toBe('20');
    });
  });
});
