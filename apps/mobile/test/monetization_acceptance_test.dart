import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/commerce/monetization_models.dart';
import 'package:creativanta_mobile/generated/creativanta/commerce/v1/monetization.pb.dart';
import 'package:creativanta_mobile/ui/commerce/monetization_view.dart';

void main() {
  group('P6-01 Mobile Monetization OS Acceptance Suite (M14)', () {
    const workspaceId = 'ws-test-mobile-001';

    // ------------------------------------------------------------------------
    // TARGET 1: Expired offer rejected at checkout
    // ------------------------------------------------------------------------
    test('Target 1: Expired offer rejected at checkout with ERR_OFFER_EXPIRED', () {
      final expiredOffer = MobileOffer(
        offerId: 'off-expired-mob',
        workspaceId: workspaceId,
        title: 'Flash Sale (Hết hạn)',
        offerType: OfferType.OFFER_TYPE_PRODUCT_OFFER,
        pricingValue: '25.000000',
        pricingCurrency: 'VND',
        lifecycleState: OfferLifecycleState.OFFER_LIFECYCLE_STATE_EXPIRED,
      );

      final res = evaluateMobileCheckout(
        workspaceId: workspaceId,
        offer: expiredOffer,
        orderAmount: '400000.000000',
        currency: 'VND',
      );

      expect(res.accepted, isFalse);
      expect(res.errorCode, 'ERR_OFFER_EXPIRED');
      expect(res.discountAmount, '0.0');
      expect(res.netPayableAmount, '400000.000000');
    });

    test('Target 1: Offer with passed validUntil timestamp rejected as expired', () {
      final timedOffer = MobileOffer(
        offerId: 'off-timed-mob',
        workspaceId: workspaceId,
        title: 'Chớp nhoáng 24h',
        offerType: OfferType.OFFER_TYPE_PRODUCT_OFFER,
        pricingValue: '30.000000',
        pricingCurrency: 'VND',
        lifecycleState: OfferLifecycleState.OFFER_LIFECYCLE_STATE_ACTIVE,
        validUntil: DateTime.utc(2026, 11, 1),
      );

      final res = evaluateMobileCheckout(
        workspaceId: workspaceId,
        offer: timedOffer,
        orderAmount: '150000.000000',
        currency: 'VND',
        evaluatedAt: DateTime.utc(2026, 11, 4),
      );

      expect(res.accepted, isFalse);
      expect(res.errorCode, 'ERR_OFFER_EXPIRED');
    });

    // ------------------------------------------------------------------------
    // TARGET 2: Coupon races do not exceed limits
    // ------------------------------------------------------------------------
    test('Target 2: Coupon redemptions strictly ceiling at max_uses', () {
      var coupon = MobileCoupon(
        couponId: 'cpn-race-mob',
        workspaceId: workspaceId,
        code: 'RACE3',
        couponType: CouponType.COUPON_TYPE_FIXED_AMOUNT,
        discountValue: '20000.000000',
        maxUses: 3,
        currentUses: 0,
        lifecycleState: CouponLifecycleState.COUPON_LIFECYCLE_STATE_ACTIVE,
      );

      final acceptedOrders = <String>[];
      final deniedErrors = <String>[];

      // Simulate 8 sequential checkout attempts
      for (int i = 0; i < 8; i++) {
        final res = evaluateMobileCheckout(
          workspaceId: workspaceId,
          coupon: coupon,
          orderAmount: '100000.000000',
          currency: 'VND',
        );

        if (res.accepted && res.updatedCoupon != null) {
          acceptedOrders.add(res.orderId!);
          coupon = res.updatedCoupon!;
        } else {
          deniedErrors.add(res.errorCode!);
        }
      }

      expect(acceptedOrders.length, 3);
      expect(deniedErrors.length, 5);
      expect(deniedErrors.every((err) => err == 'ERR_COUPON_LIMIT_EXCEEDED' || err == 'ERR_COUPON_EXPIRED'), isTrue);
      expect(coupon.currentUses, 3);
      expect(coupon.lifecycleState, CouponLifecycleState.COUPON_LIFECYCLE_STATE_EXPIRED);
    });

    // ------------------------------------------------------------------------
    // TARGET 3: Financial impact reaches ledger
    // ------------------------------------------------------------------------
    test('Target 3: Approved checkout creates MobileFinancialPosting with exact amounts', () {
      final coupon = MobileCoupon(
        couponId: 'cpn-ledger-mob',
        workspaceId: workspaceId,
        code: 'SAVE50K',
        couponType: CouponType.COUPON_TYPE_FIXED_AMOUNT,
        discountValue: '50000.000000',
        maxUses: 10,
        currentUses: 0,
        lifecycleState: CouponLifecycleState.COUPON_LIFECYCLE_STATE_ACTIVE,
      );

      final res = evaluateMobileCheckout(
        workspaceId: workspaceId,
        coupon: coupon,
        orderAmount: '300000.000000',
        currency: 'VND',
      );

      expect(res.accepted, isTrue);
      expect(res.discountAmount, '50000.0');
      expect(res.netPayableAmount, '250000.0');
      expect(res.posting, isNotNull);
      expect(res.posting!.component, 'revenue');
      expect(res.posting!.grossAmount, '300000.0');
      expect(res.posting!.discountAmount, '50000.0');
      expect(res.posting!.netAmount, '250000.0');
      expect(res.posting!.workspaceId, workspaceId);
      expect(res.posting!.orderId, res.orderId);
    });

    // ------------------------------------------------------------------------
    // Edge Cases: EC-M14-001 & EC-M14-003
    // ------------------------------------------------------------------------
    test('EC-M14-001: Offer activation requires product or declaration', () {
      final invalidOffer = MobileOffer(
        offerId: 'off-unattached',
        workspaceId: workspaceId,
        title: 'Lơ lửng không sản phẩm',
        offerType: OfferType.OFFER_TYPE_PRODUCT_OFFER,
        pricingValue: '10.000000',
        pricingCurrency: 'VND',
        lifecycleState: OfferLifecycleState.OFFER_LIFECYCLE_STATE_DRAFT,
      );
      expect(validateMobileOfferActivation(invalidOffer), isFalse);

      final validOffer = MobileOffer(
        offerId: 'off-attached',
        workspaceId: workspaceId,
        title: 'Đính kèm SKU',
        offerType: OfferType.OFFER_TYPE_PRODUCT_OFFER,
        pricingValue: '10.000000',
        pricingCurrency: 'VND',
        productId: 'prod-sku-1',
        lifecycleState: OfferLifecycleState.OFFER_LIFECYCLE_STATE_DRAFT,
      );
      expect(validateMobileOfferActivation(validOffer), isTrue);
    });

    test('EC-M14-003: Campaign budget thresholds trigger warning at 80% and over-budget at 100%', () {
      final campaignNormal = MobileCampaign(
        campaignId: 'c1',
        workspaceId: workspaceId,
        title: 'Chiến dịch A',
        campaignType: CampaignType.CAMPAIGN_TYPE_CONTENT,
        status: CampaignStatus.CAMPAIGN_STATUS_LIVE,
        budget: '10000000.000000',
        budgetCurrency: 'VND',
        totalSpend: '7000000.000000',
      );
      expect(campaignNormal.utilizationPercentage, 70);
      expect(campaignNormal.isWarning, isFalse);
      expect(campaignNormal.isOverBudget, isFalse);

      final campaignWarning = MobileCampaign(
        campaignId: 'c2',
        workspaceId: workspaceId,
        title: 'Chiến dịch B',
        campaignType: CampaignType.CAMPAIGN_TYPE_CONTENT,
        status: CampaignStatus.CAMPAIGN_STATUS_LIVE,
        budget: '10000000.000000',
        budgetCurrency: 'VND',
        totalSpend: '8500000.000000',
      );
      expect(campaignWarning.utilizationPercentage, 85);
      expect(campaignWarning.isWarning, isTrue);
      expect(campaignWarning.isOverBudget, isFalse);

      final campaignOver = MobileCampaign(
        campaignId: 'c3',
        workspaceId: workspaceId,
        title: 'Chiến dịch C',
        campaignType: CampaignType.CAMPAIGN_TYPE_CONTENT,
        status: CampaignStatus.CAMPAIGN_STATUS_LIVE,
        budget: '10000000.000000',
        budgetCurrency: 'VND',
        totalSpend: '10200000.000000',
      );
      expect(campaignOver.utilizationPercentage, 102);
      expect(campaignOver.isWarning, isTrue);
      expect(campaignOver.isOverBudget, isTrue);
    });

    // ------------------------------------------------------------------------
    // Widget Test: MobileMonetizationView
    // ------------------------------------------------------------------------
    testWidgets('MobileMonetizationView renders correctly and simulates checkout', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MobileMonetizationView(),
        ),
      );

      expect(find.text('Monetization OS (M14)'), findsOneWidget);
      expect(find.text('Ưu đãi & Hạn mức mã giảm giá'), findsOneWidget);
      expect(find.text('Checkout Hợp lệ'), findsOneWidget);
      expect(find.text('Thử Ưu đãi Hết hạn'), findsOneWidget);

      // Tap valid checkout
      await tester.tap(find.text('Checkout Hợp lệ'));
      await tester.pump();
      expect(find.textContaining('✅ Chấp thuận'), findsOneWidget);

      // Tap expired checkout
      await tester.tap(find.text('Thử Ưu đãi Hết hạn'));
      await tester.pump();
      expect(find.textContaining('❌ Từ chối: ERR_OFFER_EXPIRED'), findsOneWidget);
    });
  });
}
