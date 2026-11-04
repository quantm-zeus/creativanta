import { describe, it, expect } from 'vitest';
import {
  type Bundle,
  type CheckoutRequest,
  checkBundleStockAtomic,
  MemoryCheckoutLedger,
  validateBuyerPrivilegeBoundary,
  addExactDecimals,
  mulExactDecimalByInt,
  cmpExactDecimals,
} from './store';

describe('Creator Store, Bundles & Memberships Acceptance Suite (P6-02)', () => {
  const workspaceId = 'ws-store-test-1';

  // --------------------------------------------------------------------------
  // TARGET 1: Bundle stock atomic
  // --------------------------------------------------------------------------
  describe('Acceptance Target 1: Bundle stock atomic', () => {
    const bundle: Bundle = {
      bundleId: 'bun-creator-starter',
      workspaceId,
      title: 'Creator Starter Kit',
      bundlePrice: '1490000.000000',
      currency: 'VND',
      isActive: true,
      items: [
        { productId: 'prod-mic', quantity: 1, productTitle: 'USB Microphone' },
        { productId: 'prod-preset', quantity: 2, productTitle: 'LUT & Preset Pack' },
        { productId: 'prod-guide', quantity: 1, productTitle: 'Course PDF' },
      ],
      createdAt: '2026-11-04T00:00:00Z',
      updatedAt: '2026-11-04T00:00:00Z',
    };

    it('all components in stock -> bundle available with max possible units computed', () => {
      const inventory = {
        'prod-mic': 10,
        'prod-preset': 25, // 2 per bundle -> 12 bundles max
        'prod-guide': 50,
      };

      const res = checkBundleStockAtomic(bundle, inventory, 1);
      expect(res.isAvailable).toBe(true);
      expect(res.reason).toBeUndefined();
      expect(res.maxPossibleUnits).toBe(10); // bound by prod-mic (10)
    });

    it('single component with 0 stock -> bundle marked unavailable atomically', () => {
      const inventory = {
        'prod-mic': 0, // Out of stock
        'prod-preset': 25,
        'prod-guide': 50,
      };

      const res = checkBundleStockAtomic(bundle, inventory, 1);
      expect(res.isAvailable).toBe(false);
      expect(res.reason).toContain("Component 'USB Microphone' has insufficient stock");
      expect(res.maxPossibleUnits).toBe(0);

      const micItem = res.stockBreakdown.find((i) => i.productId === 'prod-mic');
      expect(micItem?.isSufficient).toBe(false);
      expect(micItem?.availableStock).toBe(0);
    });

    it('multi-unit request where component has insufficient stock -> rejected atomically', () => {
      const inventory = {
        'prod-mic': 5,
        'prod-preset': 5, // Requires 2 * 3 = 6 for 3 bundles
        'prod-guide': 10,
      };

      const res = checkBundleStockAtomic(bundle, inventory, 3);
      expect(res.isAvailable).toBe(false);
      expect(res.reason).toContain("Component 'LUT & Preset Pack' has insufficient stock");
    });

    it('checkout fails closed without leaking inventory reservations when component is empty', () => {
      const ledger = new MemoryCheckoutLedger();
      ledger.setStock('prod-mic', 5);
      ledger.setStock('prod-preset', 0); // Empty
      ledger.setStock('prod-guide', 10);

      const req: CheckoutRequest = {
        workspaceId,
        customerEntityId: 'cust-buyer-1',
        idempotencyKey: 'idem-bundle-fail-1',
        paymentIntentId: 'pi-bundle-fail-1',
        bundleId: bundle.bundleId,
        orderAmount: '1490000.000000',
        currency: 'VND',
      };

      expect(() => ledger.processCheckout(req, bundle)).toThrow(/insufficient stock/);

      // Verify ZERO inventory leakage
      expect(ledger.getStock('prod-mic')).toBe(5);
      expect(ledger.getStock('prod-preset')).toBe(0);
      expect(ledger.getStock('prod-guide')).toBe(10);
    });
  });

  // --------------------------------------------------------------------------
  // TARGET 2: Payment replay no duplicate delivery
  // --------------------------------------------------------------------------
  describe('Acceptance Target 2: Payment replay no duplicate delivery', () => {
    it('replaying checkout returns existing order and delivery tokens without creating duplicates', () => {
      const ledger = new MemoryCheckoutLedger();
      ledger.setStock('prod-ebook', 100);

      const bundle: Bundle = {
        bundleId: 'bun-ebook',
        workspaceId,
        title: 'Ebook Bundle',
        bundlePrice: '99000.000000',
        currency: 'VND',
        isActive: true,
        items: [{ productId: 'prod-ebook', quantity: 1, productTitle: 'Ebook' }],
        createdAt: '2026-11-04T00:00:00Z',
        updatedAt: '2026-11-04T00:00:00Z',
      };

      const digitalAssets = [
        { productId: 'prod-ebook', assetUrl: 'https://cdn.creativanta.example/ebook.pdf' },
      ];

      const checkoutReq: CheckoutRequest = {
        workspaceId,
        customerEntityId: 'buyer-repeat-1',
        idempotencyKey: 'idem-pay-12345',
        paymentIntentId: 'pi-stripe-98765',
        bundleId: bundle.bundleId,
        orderAmount: '99000.000000',
        currency: 'VND',
      };

      // 1. Initial checkout
      const res1 = ledger.processCheckout(checkoutReq, bundle, digitalAssets);
      expect(res1.success).toBe(true);
      expect(res1.isReplayed).toBe(false);
      expect(res1.deliveries).toHaveLength(1);
      const deliveryToken1 = res1.deliveries[0].downloadToken;

      // Stock should have deducted by 1
      expect(ledger.getStock('prod-ebook')).toBe(99);

      // 2. Replay with exact same idempotency key
      const res2 = ledger.processCheckout(checkoutReq, bundle, digitalAssets);
      expect(res2.success).toBe(true);
      expect(res2.isReplayed).toBe(true);
      expect(res2.orderId).toBe(res1.orderId);
      expect(res2.deliveries).toHaveLength(1);
      expect(res2.deliveries[0].downloadToken).toBe(deliveryToken1);

      // Stock should NOT be deducted again
      expect(ledger.getStock('prod-ebook')).toBe(99);

      // 3. Replay with different idempotency key but same paymentIntentId
      const replayWithSamePI: CheckoutRequest = {
        ...checkoutReq,
        idempotencyKey: 'idem-different-key-same-pi',
      };
      const res3 = ledger.processCheckout(replayWithSamePI, bundle, digitalAssets);
      expect(res3.isReplayed).toBe(true);
      expect(res3.orderId).toBe(res1.orderId);
      expect(ledger.getStock('prod-ebook')).toBe(99);
    });
  });

  // --------------------------------------------------------------------------
  // TARGET 3: Buyer subscription cannot unlock SaaS privileges
  // --------------------------------------------------------------------------
  describe('Acceptance Target 3: Buyer subscription cannot unlock SaaS privileges', () => {
    const forbiddenSaaSPermissions = [
      'store:manage',
      'product:manage',
      'workspace:admin',
      'workspace:read',
      'workspace:write',
      'workspace:delete',
      'billing:manage',
      'team:invite',
      'campaign:manage',
      'order:fulfill',
    ];

    it.each(forbiddenSaaSPermissions)(
      'buyer subscription must be rejected for SaaS privilege: %s',
      (perm) => {
        const check = validateBuyerPrivilegeBoundary(true, perm);
        expect(check.allowed).toBe(false);
        expect(check.reason).toContain('Privilege escalation blocked');
      }
    );

    it('buyer subscription allows buyer-specific perks', () => {
      const allowedPerms = ['content:access', 'discount:view', 'store:browse'];
      for (const perm of allowedPerms) {
        const check = validateBuyerPrivilegeBoundary(true, perm);
        expect(check.allowed).toBe(true);
      }
    });

    it('workspace member (non-buyer subscription) is not blocked by buyer privilege barrier', () => {
      const check = validateBuyerPrivilegeBoundary(false, 'store:manage');
      expect(check.allowed).toBe(true);
    });
  });

  // --------------------------------------------------------------------------
  // Exact Decimal Arithmetic
  // --------------------------------------------------------------------------
  describe('Exact Decimal Arithmetic', () => {
    it('adds amounts without float inaccuracies', () => {
      const sum = addExactDecimals('100000.500000', '25000.250000');
      expect(sum).toBe('125000.75');
    });

    it('multiplies amount by subscriber count without floating precision loss', () => {
      const mrr = mulExactDecimalByInt('99000.000000', 15);
      expect(mrr).toBe('1485000');
    });

    it('compares amounts correctly', () => {
      expect(cmpExactDecimals('100.000000', '99.999999')).toBe(1);
      expect(cmpExactDecimals('50.000000', '50.000000')).toBe(0);
      expect(cmpExactDecimals('10.000000', '20.000000')).toBe(-1);
    });
  });
});
