import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:creativanta_mobile/billing/billing_models.dart';
import 'package:creativanta_mobile/generated/creativanta/admin/v1/billing.pb.dart';
import 'package:creativanta_mobile/generated/creativanta/common/v1/types.pb.dart';
import 'package:creativanta_mobile/ui/billing/billing_screen.dart';

void main() {
  group('P0-06 Mobile Billing, Credit Lots & Quotes (M061)', () {
    test('AdminBillingService protobuf roundtrip for EstimateCostResponse and CreditBalance', () {
      final resp = EstimateCostResponse(
        quote: CreditQuote(
          quoteId: UUID(value: '20000000-0000-4000-8000-000000000001'),
          operationType: 'ai_video_gen',
          rateVersion: 'rate-2026-10-30-v1',
          costCeilingUsd: '0.600000',
          usdPerCreditFloor: '0.015000',
          grossMarginFloor: '0.5000',
          quotedCredits: '80',
        ),
        currentBalance: CreditBalance(
          totalRemaining: '500',
          reserved: '80',
          available: '420',
          subscriptionRemaining: '120',
          purchasedRemaining: '300',
          promotionalRemaining: '0',
          overageRemaining: '0',
          subscriptionTier: 'pro',
        ),
        sufficientCredits: true,
      );

      final bytes = resp.writeToBuffer();
      final decoded = EstimateCostResponse.fromBuffer(bytes);
      expect(decoded.quote.quotedCredits, '80');
      expect(decoded.currentBalance.available, '420');
      expect(decoded.currentBalance.purchasedRemaining, '300');
      expect(decoded.sufficientCredits, isTrue);
    });

    test('computes exact cost-based quote ceiling without floating point', () {
      expect(
        computeMobileQuotedCredits(
          costCeilingUsd: '0.600000',
          usdPerCreditFloor: '0.015000',
          grossMarginFloor: '0.5000',
        ),
        '80',
      );
      expect(
        computeMobileQuotedCredits(
          costCeilingUsd: '0.600001',
          usdPerCreditFloor: '0.015000',
          grossMarginFloor: '0.5000',
        ),
        '81',
      );
    });

    test('prevents concurrent holds from overspending and caps paid retry at confirmed quote', () {
      final hold1 = evaluateMobileCreditHold(
        availableCredits: '10',
        requestedCredits: '8',
        activeReservations: 0,
      );
      expect(hold1.allowed, isTrue);
      expect(hold1.remainingAvailable, '2');

      final hold2 = evaluateMobileCreditHold(
        availableCredits: hold1.remainingAvailable,
        requestedCredits: '8',
        activeReservations: 1,
      );
      expect(hold2.allowed, isFalse);
      expect(hold2.errorCode, 'BILLING_LIMIT_001');

      expect(
        evaluateMobilePaidRetryCharge(
          confirmedQuoteCredits: '80',
          measuredActualCredits: '120',
          attemptNumber: 2,
          maxAllowedAttempts: 2,
        ),
        '80',
      );
      expect(
        () => evaluateMobilePaidRetryCharge(
          confirmedQuoteCredits: '80',
          measuredActualCredits: '80',
          attemptNumber: 3,
          maxAllowedAttempts: 2,
        ),
        throwsStateError,
      );
    });

    testWidgets('MobileBillingScreen renders M061 credit hold and Owner-only state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MobileBillingScreen(
            role: 'owner',
            subscriptionTier: 'pro',
            availableCredits: '10',
            requestedCredits: '8',
          ),
        ),
      );

      expect(find.text('Thanh toán & Credits (M061)'), findsOneWidget);
      expect(find.textContaining('Khả dụng sau giữ chỗ: 2'), findsOneWidget);
    });
  });
}
