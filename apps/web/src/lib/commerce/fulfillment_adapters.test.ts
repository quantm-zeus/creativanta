import { describe, it, expect } from 'vitest';
import {
  parseExactMicros,
  formatExactMicros,
  validateReturnBounds,
  validateRefundBounds,
  computeOrderStateAfterRefund,
  evaluatePlatformCapability,
  computeStockDelta,
  reconcileStockBalances,
  calculateNetProfit,
  type OrderItem,
  type ReturnRecord,
  type RefundRecord,
  type FeeBreakdown
} from './fulfillment_adapters';

describe('Fulfillment, Refund, Physical Returns, and Finance Adapters Suite (P6-07)', () => {
  describe('Exact Decimal Micros Math', () => {
    it('correctly parses and formats whole and fractional amounts', () => {
      expect(parseExactMicros('100')).toBe(100000000n);
      expect(parseExactMicros('100.5')).toBe(100500000n);
      expect(parseExactMicros('0.000001')).toBe(1n);
      expect(parseExactMicros('-50.25')).toBe(-50250000n);

      expect(formatExactMicros(100000000n)).toBe('100');
      expect(formatExactMicros(100500000n)).toBe('100.5');
      expect(formatExactMicros(1n)).toBe('0.000001');
      expect(formatExactMicros(-50250000n)).toBe('-50.25');
      expect(formatExactMicros(0n)).toBe('0');
    });
  });

  describe('Acceptance Target 3: Physical Return Cumulative Bounds', () => {
    const items: OrderItem[] = [
      { sku: 'sku-shoes-42', name: 'Running Shoes', quantity: 2, unitPrice: '500000' },
      { sku: 'sku-socks-white', name: 'Crew Socks', quantity: 5, unitPrice: '50000' }
    ];

    it('allows valid return within purchased quantities', () => {
      const priorReturns: ReturnRecord[] = [];
      const newItems = [{ sku: 'sku-shoes-42', quantity: 1, reason: 'Wrong size' }];

      const res = validateReturnBounds(items, priorReturns, newItems);
      expect(res.valid).toBe(true);
    });

    it('rejects return exceeding purchased line quantity', () => {
      const priorReturns: ReturnRecord[] = [
        {
          returnId: 'ret-1',
          orderId: 'ord-1',
          items: [{ sku: 'sku-shoes-42', quantity: 1 }],
          lifecycleState: 'received',
          createdAt: '2026-11-04T10:00:00Z'
        }
      ];
      // Trying to return 2 more shoes when only 2 were bought and 1 already returned
      const newItems = [{ sku: 'sku-shoes-42', quantity: 2 }];

      const res = validateReturnBounds(items, priorReturns, newItems);
      expect(res.valid).toBe(false);
      expect(res.error).toContain('Cumulative return (3) exceeds ordered quantity (2)');
    });

    it('disregards rejected returns from consumed quota', () => {
      const priorReturns: ReturnRecord[] = [
        {
          returnId: 'ret-rejected',
          orderId: 'ord-1',
          items: [{ sku: 'sku-shoes-42', quantity: 2 }],
          lifecycleState: 'rejected',
          createdAt: '2026-11-04T10:00:00Z'
        }
      ];
      const newItems = [{ sku: 'sku-shoes-42', quantity: 2 }];

      const res = validateReturnBounds(items, priorReturns, newItems);
      expect(res.valid).toBe(true);
    });
  });

  describe('Acceptance Target 3: Cumulative Refund Bounds & State Progression', () => {
    const orderAmount = '1000000'; // 1,000,000 VND

    it('enforces partial refund bounds and tracks remaining refundable amount', () => {
      const priorRefunds: RefundRecord[] = [
        {
          refundId: 'ref-1',
          orderId: 'ord-1',
          amount: '400000',
          currency: 'VND',
          lifecycleState: 'completed',
          reason: 'Item defective',
          createdAt: '2026-11-04T10:00:00Z'
        }
      ];

      // Second partial refund of 300,000 -> Allowed (remains 300,000)
      const res1 = validateRefundBounds(orderAmount, priorRefunds, '300000');
      expect(res1.valid).toBe(true);
      expect(res1.remainingRefundable).toBe('300000');

      // Attempt refund of 700,000 -> Exceeds remaining 600,000!
      const res2 = validateRefundBounds(orderAmount, priorRefunds, '700000');
      expect(res2.valid).toBe(false);
      expect(res2.remainingRefundable).toBe('600000');
      expect(res2.error).toContain('exceeds remaining refundable balance');
    });

    it('computes correct lifecycle state progression', () => {
      expect(computeOrderStateAfterRefund('1000000', '0')).toBe('completed');
      expect(computeOrderStateAfterRefund('1000000', '400000')).toBe('partially_refunded');
      expect(computeOrderStateAfterRefund('1000000', '1000000')).toBe('refunded');
      expect(computeOrderStateAfterRefund('1000000', '1200000')).toBe('refunded');
    });
  });

  describe('Platform Capabilities & Safe Fallback', () => {
    it('returns verified capability for authenticated partner connections', () => {
      const cap = evaluatePlatformCapability('tiktok', true);
      expect(cap.status).toBe('verified');
      expect(cap.isNative).toBe(true);
    });

    it('falls back to manual mode when credentials are not verified', () => {
      const cap = evaluatePlatformCapability('shopee', false);
      expect(cap.status).toBe('manual');
      expect(cap.isNative).toBe(false);
      expect(cap.reason).toContain('fallback to authorized CSV');
    });
  });

  describe('Acceptance Target 1: Stock Synchronization & Reconciliation', () => {
    it('detects polling delta and identifies duplicate poll no-ops (I10)', () => {
      const delta1 = computeStockDelta(10, 15);
      expect(delta1.delta).toBe(5);
      expect(delta1.isNoOp).toBe(false);

      const delta2 = computeStockDelta(15, 15);
      expect(delta2.delta).toBe(0);
      expect(delta2.isNoOp).toBe(true);
    });

    it('identifies stock discrepancies between ledger sum and on-hand (I09)', () => {
      const balanced = reconcileStockBalances(10, 10);
      expect(balanced.status).toBe('balanced');
      expect(balanced.discrepancy).toBe(0);

      const drifted = reconcileStockBalances(10, 8);
      expect(drifted.status).toBe('drift_detected');
      expect(drifted.discrepancy).toBe(-2);
    });
  });

  describe('Acceptance Target 2: Correcting Fees & Operating Ledger Proof Preservation', () => {
    it('calculates net profit accurately without floating point drift', () => {
      const fees: FeeBreakdown = {
        platformFee: '100000',
        paymentFee: '20000',
        shippingFee: '30000',
        affiliateCommission: '50000',
        vatAmount: '10000'
      };
      // Net = 1,000,000 - 100,000 - 20,000 - 30,000 - 50,000 - 350,000 - 50,000 = 400,000
      const net = calculateNetProfit('1000000', fees, '350000', '50000');
      expect(net).toBe('400000');
    });
  });
});
