import { describe, it, expect } from 'vitest';
import {
  evaluateCheckout,
  evaluateCampaignBudget,
  validateOfferActivation,
  type Offer,
  type Coupon,
  type Campaign
} from './monetization';

describe('Monetization OS Acceptance Suite (P6-01)', () => {
  const workspaceId = 'ws-test-commerce-001';

  // --------------------------------------------------------------------------
  // TARGET 1: Expired offer rejected at checkout
  // --------------------------------------------------------------------------
  it('Target 1: Expired offer rejected at checkout (ERR_OFFER_EXPIRED)', () => {
    const expiredOffer: Offer = {
      offerId: 'off-expired-01',
      workspaceId,
      title: 'Flash Sale (Expired)',
      offerType: 'product_offer',
      pricingValue: '20.0',
      pricingCurrency: 'VND',
      lifecycleState: 'expired',
      createdAt: '2026-10-01T00:00:00Z',
      updatedAt: '2026-10-02T00:00:00Z'
    };

    const res = evaluateCheckout({
      workspaceId,
      offer: expiredOffer,
      orderAmount: '500000.0',
      currency: 'VND',
      now: '2026-11-04T12:00:00Z'
    });

    expect(res.accepted).toBe(false);
    expect(res.errorCode).toBe('ERR_OFFER_EXPIRED');
    expect(res.discountAmount).toBe('0.0');
    expect(res.netPayableAmount).toBe('500000.0');
  });

  it('Target 1: Offer with passed validUntil window rejected as expired', () => {
    const timedOffer: Offer = {
      offerId: 'off-timed-02',
      workspaceId,
      title: 'Midnight Madness',
      offerType: 'product_offer',
      pricingValue: '30.0',
      pricingCurrency: 'VND',
      lifecycleState: 'active',
      validFrom: '2026-11-01T00:00:00Z',
      validUntil: '2026-11-03T23:59:59Z',
      createdAt: '2026-11-01T00:00:00Z',
      updatedAt: '2026-11-01T00:00:00Z'
    };

    const res = evaluateCheckout({
      workspaceId,
      offer: timedOffer,
      orderAmount: '200000.0',
      currency: 'VND',
      now: '2026-11-04T08:00:00Z'
    });

    expect(res.accepted).toBe(false);
    expect(res.errorCode).toBe('ERR_OFFER_EXPIRED');
  });

  // --------------------------------------------------------------------------
  // TARGET 2: Coupon races do not exceed limits
  // --------------------------------------------------------------------------
  it('Target 2: Coupon redemptions strictly ceiling at max_uses under concurrent race sequence', () => {
    let coupon: Coupon = {
      couponId: 'cpn-race-01',
      workspaceId,
      code: 'LIMITED3',
      couponType: 'fixed_amount',
      discountValue: '50000.0',
      maxUses: 3,
      currentUses: 0,
      lifecycleState: 'active',
      createdAt: '2026-11-04T00:00:00Z',
      updatedAt: '2026-11-04T00:00:00Z'
    };

    const successfulOrders: string[] = [];
    const deniedErrors: string[] = [];

    // Simulate 10 checkout races contending for 3 maxUses
    for (let i = 0; i < 10; i++) {
      const res = evaluateCheckout({
        workspaceId,
        coupon,
        orderAmount: '300000.0',
        currency: 'VND',
        now: '2026-11-04T12:00:00Z'
      });

      if (res.accepted && res.updatedCoupon) {
        successfulOrders.push(res.orderId!);
        coupon = res.updatedCoupon;
      } else {
        deniedErrors.push(res.errorCode!);
      }
    }

    expect(successfulOrders.length).toBe(3);
    expect(deniedErrors.length).toBe(7);
    expect(deniedErrors.every((err) => err === 'ERR_COUPON_LIMIT_EXCEEDED' || err === 'ERR_COUPON_EXPIRED')).toBe(true);
    expect(coupon.currentUses).toBe(3);
    expect(coupon.lifecycleState).toBe('expired');
  });

  // --------------------------------------------------------------------------
  // TARGET 3: Financial impact reaches ledger
  // --------------------------------------------------------------------------
  it('Target 3: Approved checkout creates double-entry financial posting linked to order and ledger', () => {
    const coupon: Coupon = {
      couponId: 'cpn-ledger-01',
      workspaceId,
      code: 'SAVE100K',
      couponType: 'fixed_amount',
      discountValue: '100000.0',
      maxUses: 10,
      currentUses: 0,
      lifecycleState: 'active',
      createdAt: '2026-11-04T00:00:00Z',
      updatedAt: '2026-11-04T00:00:00Z'
    };

    const res = evaluateCheckout({
      workspaceId,
      coupon,
      orderAmount: '450000.0',
      currency: 'VND',
      now: '2026-11-04T14:30:00Z'
    });

    expect(res.accepted).toBe(true);
    expect(res.discountAmount).toBe('100000.0');
    expect(res.netPayableAmount).toBe('350000.0');
    expect(res.posting).toBeDefined();
    expect(res.posting?.component).toBe('revenue');
    expect(res.posting?.grossAmount).toBe('450000.0');
    expect(res.posting?.discountAmount).toBe('100000.0');
    expect(res.posting?.netAmount).toBe('350000.0');
    expect(res.posting?.workspaceId).toBe(workspaceId);
    expect(res.posting?.orderId).toBe(res.orderId);
  });

  // --------------------------------------------------------------------------
  // Edge Case EC-M14-001: Offer activation requires product or declaration
  // --------------------------------------------------------------------------
  it('EC-M14-001: Offer activation denied without product_id or product-less declaration', () => {
    const invalidOffer: Offer = {
      offerId: 'off-no-prod',
      workspaceId,
      title: 'Free Floating Offer',
      offerType: 'product_offer',
      pricingValue: '10.0',
      pricingCurrency: 'VND',
      lifecycleState: 'draft',
      createdAt: '2026-11-04T00:00:00Z',
      updatedAt: '2026-11-04T00:00:00Z'
    };

    const res = validateOfferActivation(invalidOffer);
    expect(res.valid).toBe(false);
    expect(res.reason).toContain('product_id or an explicit product-less declaration');

    const validOffer: Offer = {
      ...invalidOffer,
      productId: 'prod-sku-999'
    };
    expect(validateOfferActivation(validOffer).valid).toBe(true);
  });

  // --------------------------------------------------------------------------
  // Edge Case EC-M14-003: Campaign budget thresholds
  // --------------------------------------------------------------------------
  it('EC-M14-003: Campaign budget threshold tracking and alerts at 80% and 100%', () => {
    const campaign: Campaign = {
      campaignId: 'camp-summer-01',
      workspaceId,
      title: 'Summer Launch',
      campaignType: 'content',
      status: 'active',
      startDate: '2026-06-01',
      endDate: '2026-06-30',
      budget: '10000000.0',
      budgetCurrency: 'VND',
      totalSpend: '7500000.0',
      costs: [],
      createdAt: '2026-05-01T00:00:00Z',
      updatedAt: '2026-05-01T00:00:00Z'
    };

    // Under 80%
    const under = evaluateCampaignBudget(campaign);
    expect(under.utilizationPct).toBe(75);
    expect(under.isWarning).toBe(false);
    expect(under.isOverBudget).toBe(false);

    // At 85% -> Warning
    const warning = evaluateCampaignBudget({ ...campaign, totalSpend: '8500000.0' });
    expect(warning.utilizationPct).toBe(85);
    expect(warning.isWarning).toBe(true);
    expect(warning.isOverBudget).toBe(false);
    expect(warning.alertMessage).toContain('80% threshold');

    // At 105% -> Over budget alert
    const alert = evaluateCampaignBudget({ ...campaign, totalSpend: '10500000.0' });
    expect(alert.utilizationPct).toBe(105);
    expect(alert.isWarning).toBe(true);
    expect(alert.isOverBudget).toBe(true);
    expect(alert.alertMessage).toContain('EC-M14-003');
  });
});
