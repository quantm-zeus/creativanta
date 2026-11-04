import { describe, expect, it } from 'vitest';
import {
  calculateSafeConversionRate,
  calculateSafeCTR,
  calculateSafeRPM,
  deduplicateWorkspaceRevenue,
  enforceSourceClassIntegrity,
  resolveAggregateConfidence,
  validateAttributionCapacity,
} from './attribution_service';
import type { AttributionRecord, CanonicalOrder } from './types';

describe('P5-03 Web Attribution & Metrics Acceptance Tests', () => {
  describe('Target 1: Workspace Revenue Counted Once & Order Net Capacity', () => {
    it('sums distinct recognized orders exactly once in workspace summary', () => {
      const wsId = 'ws-test-web';
      const orders: CanonicalOrder[] = [
        {
          orderId: 'ord-1',
          workspaceId: wsId,
          grossRevenue: '100000.000000',
          refundDeductions: '0.000000',
          netRevenue: '100000.000000',
          currency: 'VND',
          sourceClass: 'official',
          confidence: 'high',
          isRecognized: true,
        },
        {
          orderId: 'ord-2',
          workspaceId: wsId,
          grossRevenue: '200000.000000',
          refundDeductions: '0.000000',
          netRevenue: '200000.000000',
          currency: 'VND',
          sourceClass: 'official',
          confidence: 'high',
          isRecognized: true,
        },
      ];

      // Multiple attribution records across different channel posts/derivatives pointing to ord-1
      const attributions: AttributionRecord[] = [
        {
          attributionId: 'attr-1',
          workspaceId: wsId,
          orderId: 'ord-1',
          attributionType: 'direct_click',
          revenueAttributed: '60000.000000',
          sourceClass: 'official',
          confidence: 'high',
        },
        {
          attributionId: 'attr-2',
          workspaceId: wsId,
          orderId: 'ord-1',
          attributionType: 'utm_match',
          revenueAttributed: '40000.000000',
          sourceClass: 'official',
          confidence: 'high',
        },
        {
          attributionId: 'attr-3',
          workspaceId: wsId,
          orderId: 'ord-2',
          attributionType: 'affiliate',
          revenueAttributed: '150000.000000',
          sourceClass: 'official',
          confidence: 'high',
        },
      ];

      const summary = deduplicateWorkspaceRevenue(wsId, orders, attributions);

      // Target 1 Verification:
      // Workspace canonical revenue = 100,000 + 200,000 = 300,000.000000 (COUNTED ONCE!)
      expect(summary.uniqueOrdersCounted).toBe(2);
      expect(summary.canonicalWorkspaceRevenue).toBe('300000.000000');
      expect(summary.sumAttributionLines).toBe('250000.000000');
      expect(summary.isRevenueCountedOnce).toBe(true);
      expect(summary.aggregateConfidence).toBe('high');
      expect(summary.includesEstimatedOrImported).toBe(false);
    });

    it('enforces order net recognized capacity and throws on over-allocation', () => {
      // Net capacity is 80,000 (100k gross - 20k refund)
      const existing = [50000];
      const validNew = 30000;
      const invalidNew = 40000;

      const validRes = validateAttributionCapacity(80000, existing, validNew);
      expect(validRes.isValid).toBe(true);
      expect(validRes.remainingCapacity).toBe(0);

      const invalidRes = validateAttributionCapacity(80000, existing, invalidNew);
      expect(invalidRes.isValid).toBe(false);
      expect(invalidRes.error).toContain('exceeds order net recognized revenue capacity');

      const wsId = 'ws-throw-test';
      const orders: CanonicalOrder[] = [
        {
          orderId: 'ord-net-cap',
          workspaceId: wsId,
          grossRevenue: '100000.000000',
          refundDeductions: '20000.000000',
          netRevenue: '80000.000000',
          currency: 'VND',
          sourceClass: 'official',
          confidence: 'high',
          isRecognized: true,
        },
      ];
      const attributions: AttributionRecord[] = [
        {
          attributionId: 'a1',
          workspaceId: wsId,
          orderId: 'ord-net-cap',
          attributionType: 'direct_click',
          revenueAttributed: '50000.000000',
          sourceClass: 'official',
          confidence: 'high',
        },
        {
          attributionId: 'a2',
          workspaceId: wsId,
          orderId: 'ord-net-cap',
          attributionType: 'utm_match',
          revenueAttributed: '40000.000000', // 50k + 40k = 90k > 80k
          sourceClass: 'official',
          confidence: 'high',
        },
      ];

      expect(() => deduplicateWorkspaceRevenue(wsId, orders, attributions)).toThrow(
        /exceeds order net recognized revenue capacity/
      );
    });
  });

  describe('Target 2: Missing Denominators Remain Unknown & Low Exposure Safety', () => {
    it('returns isUnknown: true and null value for missing or zero views in RPM', () => {
      // Nil / undefined views
      const nilRpm = calculateSafeRPM('500000', null, true);
      expect(nilRpm.isUnknown).toBe(true);
      expect(nilRpm.value).toBeNull();
      expect(nilRpm.unknownReason).toBe('MISSING_DENOMINATOR_VIEWS');

      // Zero views
      const zeroRpm = calculateSafeRPM('500000', 0);
      expect(zeroRpm.isUnknown).toBe(true);
      expect(zeroRpm.value).toBeNull();
      expect(zeroRpm.unknownReason).toBe('MISSING_DENOMINATOR_VIEWS');
    });

    it('treats low exposure (< 100 views) as inconclusive to prevent premature winner selection (EXP-2026-02)', () => {
      const lowRpm = calculateSafeRPM('500000', 45);
      expect(lowRpm.isUnknown).toBe(true);
      expect(lowRpm.value).toBeNull();
      expect(lowRpm.status).toBe('low_exposure_inconclusive');
      expect(lowRpm.unknownReason).toBe('LOW_EXPOSURE_INCONCLUSIVE');

      const lowCtr = calculateSafeCTR(5, 45);
      expect(lowCtr.isUnknown).toBe(true);
      expect(lowCtr.status).toBe('low_exposure_inconclusive');
    });

    it('calculates exact metrics when exposure is sufficient (>= 100 views)', () => {
      // 1000 views, 500,000 revenue -> RPM = (500000 * 1000) / 1000 = 500000.000000
      const validRpm = calculateSafeRPM('500000', 1000);
      expect(validRpm.isUnknown).toBe(false);
      expect(validRpm.value).toBe('500000.000000');
      expect(validRpm.status).toBe('calculated');

      // 50 clicks, 1000 views -> CTR = 5.0000%
      const validCtr = calculateSafeCTR(50, 1000);
      expect(validCtr.isUnknown).toBe(false);
      expect(validCtr.value).toBe('5.0000%');

      // 10 orders, 50 clicks -> Conversion Rate = 20.0000%
      const validConv = calculateSafeConversionRate(10, 50);
      expect(validConv.isUnknown).toBe(false);
      expect(validConv.value).toBe('20.0000%');
    });

    it('marks conversion rate as unknown when clicks denominator is missing', () => {
      const missingClicks = calculateSafeConversionRate(5, null, true);
      expect(missingClicks.isUnknown).toBe(true);
      expect(missingClicks.value).toBeNull();
      expect(missingClicks.unknownReason).toBe('MISSING_DENOMINATOR_CLICKS');
    });
  });

  describe('Target 3: Imported Proof Integrity & Mixed Confidence Cap', () => {
    it('prevents imported proof from being upgraded to official', () => {
      // Attempt to upgrade imported to official
      const upgradeRes = enforceSourceClassIntegrity('imported', 'official', false);
      expect(upgradeRes.sourceClass).toBe('imported');
      expect(upgradeRes.error).toContain('cannot be upgraded to official');

      // Attempt to claim official without live API session
      const unverifiedRes = enforceSourceClassIntegrity('inferred', 'official', false);
      expect(unverifiedRes.sourceClass).toBe('imported');
      expect(unverifiedRes.error).toContain('requires verified live platform API session');

      // Legitimate official with live API verification
      const legitRes = enforceSourceClassIntegrity('official', 'official', true);
      expect(legitRes.sourceClass).toBe('official');
      expect(legitRes.error).toBeUndefined();
    });

    it('strictly caps aggregate confidence at medium when imported or estimated sources are mixed', () => {
      // Official only with High confidence -> stays High
      expect(resolveAggregateConfidence(['high', 'high'], false)).toBe('high');

      // Mixed official + imported sources -> strictly capped at medium!
      expect(resolveAggregateConfidence(['high', 'high'], true)).toBe('medium');
      expect(resolveAggregateConfidence(['high', 'medium'], true)).toBe('medium');

      // Low confidence remains low
      expect(resolveAggregateConfidence(['low', 'high'], true)).toBe('low');
    });
  });
});
