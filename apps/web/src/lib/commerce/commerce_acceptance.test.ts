import { describe, it, expect } from 'vitest';
import {
  getModuleIntegritySummaries,
  getCrossModuleLinks,
  getInitialUnreconciledOutcomes,
  applyOperationalRepair,
  getProviderAndShippingGateSummary,
  type OperationalRepairRequest
} from './commerce_acceptance';

describe('P6-09 Web Commerce Acceptance Suite', () => {
  const wsId = 'ws-p6-test-acceptance';

  describe('Acceptance Target 1: No Function Lost Between Modules', () => {
    it('verifies all 12 modules are registered, healthy, and linked to canonical routes', () => {
      const summaries = getModuleIntegritySummaries();
      expect(summaries.length).toBe(12);

      const moduleIds = summaries.map((s) => s.moduleId);
      expect(moduleIds).toContain('M04');
      expect(moduleIds).toContain('M05');
      expect(moduleIds).toContain('M09');
      expect(moduleIds).toContain('M12');
      expect(moduleIds).toContain('M13');
      expect(moduleIds).toContain('M14');
      expect(moduleIds).toContain('M15');
      expect(moduleIds).toContain('M16');
      expect(moduleIds).toContain('M17');
      expect(moduleIds).toContain('M18');
      expect(moduleIds).toContain('S16');
      expect(moduleIds).toContain('M19');

      for (const summary of summaries) {
        expect(summary.status).toBe('HEALTHY');
        expect(summary.connectedLinks).toBeGreaterThan(0);
        expect(summary.activeEntities).toBeGreaterThan(0);
        expect(summary.route).toMatch(/^\/[a-z0-9\-_/]+$/);
      }
    });

    it('verifies cross-domain linkage integrity across the complete commerce loop', () => {
      const links = getCrossModuleLinks();
      expect(links.length).toBeGreaterThanOrEqual(10);

      const conversionLinks = links.filter((l) => l.linkType === 'conversion');
      expect(conversionLinks.length).toBeGreaterThanOrEqual(3);

      for (const link of links) {
        expect(link.verified).toBe(true);
        expect(link.description.length).toBeGreaterThan(10);
      }
    });
  });

  describe('Acceptance Target 2: Partial & Unreconciled Outcomes Visible', () => {
    it('surfaces partial refunds, physical returns, and stock discrepancies with honest labels', () => {
      const outcomes = getInitialUnreconciledOutcomes(wsId);
      expect(outcomes.length).toBeGreaterThanOrEqual(6);

      // 1. Partial refund
      const partRefund = outcomes.find((o) => o.id === 'unrec-refund-001');
      expect(partRefund).toBeDefined();
      expect(partRefund?.status).toBe('partially_refunded');
      expect(partRefund?.refundedAmountExact).toBe('200000.000000');
      expect(partRefund?.originalCapturedExact).toBe('500000.000000');
      expect(partRefund?.physicalReturnState).toBe('not_returned');

      // 2. Physical return only (RULE-M13-006)
      const retOnly = outcomes.find((o) => o.id === 'unrec-return-002');
      expect(retOnly).toBeDefined();
      expect(retOnly?.status).toBe('returned');
      expect(retOnly?.refundedAmountExact).toBe('0.000000');
      expect(retOnly?.physicalReturnState).toBe('returned');

      // 3. Stock discrepancy
      const stock = outcomes.find((o) => o.id === 'unrec-stock-003');
      expect(stock).toBeDefined();
      expect(stock?.status).toBe('stock_discrepancy');
      expect(stock?.sourceClass).toBe('unreconciled');
      expect(stock?.requiresAuditReason).toBe(true);

      // 4. Seeding pending outcome (RULE-M18-002)
      const seeding = outcomes.find((o) => o.id === 'unrec-seeding-004');
      expect(seeding).toBeDefined();
      expect(seeding?.status).toBe('pending_outcome');
      expect(seeding?.sourceClass).toBe('estimated');
      expect(seeding?.confidenceScore).toBe(0.5);

      // 5. Affiliate statement unmatched
      const affiliate = outcomes.find((o) => o.id === 'unrec-affiliate-005');
      expect(affiliate).toBeDefined();
      expect(affiliate?.status).toBe('unmatched_statement_item');
      expect(affiliate?.sourceClass).toBe('unreconciled');

      // 6. Brand deal dispute
      const deal = outcomes.find((o) => o.id === 'unrec-deal-006');
      expect(deal).toBeDefined();
      expect(deal?.status).toBe('disputed_deliverable');
    });

    it('requires mandatory audit reason for operational repairs', () => {
      const outcomes = getInitialUnreconciledOutcomes(wsId);
      const invalidReq: OperationalRepairRequest = {
        workspaceId: wsId,
        unreconciledId: 'unrec-stock-003',
        repairType: 'reconcile_stock_adjustment',
        auditReason: '', // Empty reason
        actorId: 'user-01',
        actorRole: 'manager'
      };

      expect(() => applyOperationalRepair(outcomes, invalidReq)).toThrow(
        'Lý do kiểm toán (audit_reason) là bắt buộc'
      );
    });

    it('applies operational repair successfully and prevents duplicate resolution', () => {
      const outcomes = getInitialUnreconciledOutcomes(wsId);
      const validReq: OperationalRepairRequest = {
        workspaceId: wsId,
        unreconciledId: 'unrec-stock-003',
        repairType: 'reconcile_stock_adjustment',
        auditReason: 'Đã kiểm kê đối chiếu kho thực tế và xuất bù 1 áo mẫu',
        actorId: 'user-01',
        actorRole: 'manager'
      };

      const { updatedOutcomes, result } = applyOperationalRepair(outcomes, validReq);
      expect(result.success).toBe(true);
      expect(result.unreconciledId).toBe('unrec-stock-003');
      expect(result.ledgerPostingId).toBeDefined();
      expect(result.auditLogEntryId).toBeDefined();

      const repairedItem = updatedOutcomes.find((o) => o.id === 'unrec-stock-003');
      expect(repairedItem?.resolved).toBe(true);
      expect(repairedItem?.status).toBe('reconciled');
      expect(repairedItem?.sourceClass).toBe('official');
      expect(repairedItem?.confidenceScore).toBe(1.0);

      // Attempting to repair again throws
      expect(() => applyOperationalRepair(updatedOutcomes, validReq)).toThrow(
        'Mục chưa đối soát này đã được xử lý trước đó'
      );
    });
  });

  describe('Acceptance Target 3: Actual Provider / Payment / Shipping Gate Evidence', () => {
    it('verifies payment providers with HMAC verification and replay deduplication', () => {
      const summary = getProviderAndShippingGateSummary(wsId);
      expect(summary.paymentGates.length).toBe(4);

      const stripe = summary.paymentGates.find((p) => p.provider === 'stripe');
      expect(stripe).toBeDefined();
      expect(stripe?.webhookHmacVerified).toBe(true);
      expect(stripe?.replayDeduplicated).toBe(true);
      expect(stripe?.latePaymentRecovery).toBe(true);
      expect(stripe?.gateStatus).toBe('VERIFIED_LOCAL_ADAPTER');

      const tiktok = summary.paymentGates.find((p) => p.provider === 'tiktok_shop');
      expect(tiktok).toBeDefined();
      expect(tiktok?.webhookHmacVerified).toBe(true);
    });

    it('verifies shipping carrier logistics tracking and cost posting', () => {
      const summary = getProviderAndShippingGateSummary(wsId);
      expect(summary.shippingGates.length).toBeGreaterThanOrEqual(2);

      const ghn = summary.shippingGates.find((p) => p.carrier === 'ghn');
      expect(ghn).toBeDefined();
      expect(ghn?.state).toBe('delivered');
      expect(ghn?.signatureVerified).toBe(true);
      expect(ghn?.shippingCostExact).toBe('32000.000000');

      const ghtk = summary.shippingGates.find((p) => p.carrier === 'ghtk');
      expect(ghtk).toBeDefined();
      expect(ghtk?.sampleRequestId).toBe('smp-req-creator-linh');
    });

    it('honestly distinguishes local adapter verification from production external gates', () => {
      const summary = getProviderAndShippingGateSummary(wsId);
      expect(summary.externalGates.length).toBe(4);

      const gateIds = summary.externalGates.map((g) => g.gateId);
      expect(gateIds).toContain('EXT-GATE-PAYMENT-STRIPE-LIVE');
      expect(gateIds).toContain('EXT-GATE-PLATFORM-TIKTOK-PARTNER');
      expect(gateIds).toContain('EXT-GATE-SHIPPING-CARRIER-API');
      expect(gateIds).toContain('EXT-GATE-POSTGRES-LIVE-RLS');

      const stripeGate = summary.externalGates.find((g) => g.gateId === 'EXT-GATE-PAYMENT-STRIPE-LIVE');
      expect(stripeGate?.status).toBe('PENDING_PRODUCTION_KEY');

      const tiktokGate = summary.externalGates.find((g) => g.gateId === 'EXT-GATE-PLATFORM-TIKTOK-PARTNER');
      expect(tiktokGate?.status).toBe('PENDING_EXTERNAL_PROVIDER_APPROVAL');
    });
  });
});
