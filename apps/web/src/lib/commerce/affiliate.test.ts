import { describe, it, expect } from 'vitest';
import {
  evaluateLedgerImpact,
  labelAttributionProvenance,
  repairBrokenLink,
  getHealthStatusColor,
  getSourceClassBadge,
  type AffiliateLink,
} from './affiliate';

describe('P6-03 Web Affiliate Operations & Ledger Proof', () => {
  const wsId = 'ws-test-p6-03';

  describe('Acceptance Target 1: Creator income distinct from seller expense', () => {
    it('records creator commission as pure income without deducting COGS', () => {
      const result = evaluateLedgerImpact(wsId, '250000.000000', 'VND', 'creator');

      expect(result.postingType).toBe('creator_income');
      expect(result.economicRole).toBe('creator');
      expect(result.cogsDeducted).toBe(false); // CRITICAL: COGS must NOT be deducted for creator!
      expect(result.netProfitImpact).toBe('+250000.000000');
      expect(result.amount).toBe('250000.000000');
    });

    it('records seller commission as cost/expense deduction with negative profit impact', () => {
      const result = evaluateLedgerImpact(wsId, '250000.000000', 'VND', 'seller');

      expect(result.postingType).toBe('seller_commission_expense');
      expect(result.economicRole).toBe('seller');
      expect(result.cogsDeducted).toBe(true);
      expect(result.netProfitImpact).toBe('-250000.000000');
    });
  });

  describe('Acceptance Target 2: Ambiguous attribution labeled', () => {
    it('labels single-touch official platform API as official with high confidence', () => {
      const provenance = labelAttributionProvenance(1, false, true);

      expect(provenance.sourceClass).toBe('official');
      expect(provenance.confidence).toBe('high');
      expect(provenance.badgeLabel).toBe('Official');
      expect(provenance.explanationNote).toContain('Official platform API');
    });

    it('labels multi-touch conversion as inferred with medium confidence and explanation', () => {
      const provenance = labelAttributionProvenance(2, true, false);

      expect(provenance.sourceClass).toBe('inferred');
      expect(provenance.confidence).toBe('medium');
      expect(provenance.badgeLabel).toBe('Attributed (inferred)');
      expect(provenance.explanationNote).toBe(
        'Multiple touch points detected — last click rule applied.'
      );
    });

    it('downgrades confidence to low when touchpoint count exceeds 3', () => {
      const provenance = labelAttributionProvenance(5, true, false);

      expect(provenance.sourceClass).toBe('inferred');
      expect(provenance.confidence).toBe('low');
      expect(provenance.badgeLabel).toBe('Attributed (inferred)');
    });
  });

  describe('Acceptance Target 3: Broken link repair', () => {
    const baseLink: AffiliateLink = {
      affiliateLinkId: 'link-123',
      workspaceId: wsId,
      platform: 'shopee',
      originalUrl: 'https://shopee.vn/broken-p',
      trackedUrl: 'https://creativanta.link/sh123',
      shortCode: 'sh123',
      commissionRate: '10.00',
      lifecycleState: 'active',
      healthStatus: 'broken',
      clickCount: 150,
      conversionCount: 12,
      revenueAttributed: '2400000.000000',
      createdAt: '2026-11-01T00:00:00Z',
      updatedAt: '2026-11-01T00:00:00Z',
    };

    it('repairs broken link with new URL and replacement product, restoring healthy status', () => {
      const res = repairBrokenLink(
        baseLink,
        'https://shopee.vn/fixed-replacement-product',
        'prod-replacement-456'
      );

      expect(res.success).toBe(true);
      expect(res.link.healthStatus).toBe('healthy');
      expect(res.link.originalUrl).toBe('https://shopee.vn/fixed-replacement-product');
      expect(res.link.productId).toBe('prod-replacement-456');
    });

    it('strictly forbids repairing or reactivating permanently revoked link', () => {
      const revokedLink: AffiliateLink = {
        ...baseLink,
        lifecycleState: 'revoked',
      };

      const res = repairBrokenLink(revokedLink, 'https://shopee.vn/fixed');

      expect(res.success).toBe(false);
      expect(res.error).toContain('Cannot repair permanently revoked');
      expect(res.link.healthStatus).toBe('broken');
    });
  });

  describe('UI Badges & Formatting', () => {
    it('returns appropriate color schemes for health and source badges', () => {
      const healthy = getHealthStatusColor('healthy');
      expect(healthy.label).toBe('Healthy');

      const broken = getHealthStatusColor('broken');
      expect(broken.label).toBe('Broken');

      const inferred = getSourceClassBadge('inferred');
      expect(inferred.label).toBe('Inferred');

      const official = getSourceClassBadge('official');
      expect(official.label).toBe('Official');
    });
  });
});
