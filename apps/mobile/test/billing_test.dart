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
      expect(find.textContaining('Credits đã mua bảo toàn: 500'), findsOneWidget);
    });

    test('P8-02 Mobile targets: payment gates, add-on proration, cancellation != dunning, purchased credits preserved, SHA-512 evidence, and cohort economics', () {
      // Payment method access gates
      expect(
        evaluateMobilePaymentMethodGate(
          methodType: 'card',
          subscriptionTier: 'starter',
        ).allowed,
        isTrue,
      );
      expect(
        evaluateMobilePaymentMethodGate(
          methodType: 'momo',
          subscriptionTier: 'pro',
        ).allowed,
        isFalse,
      );
      expect(
        evaluateMobilePaymentMethodGate(
          methodType: 'momo',
          subscriptionTier: 'pro',
          grantedGates: const <String>['momo'],
        ).allowed,
        isTrue,
      );
      expect(
        evaluateMobilePaymentMethodGate(
          methodType: 'bank_transfer',
          subscriptionTier: 'starter',
          grantedGates: const <String>['bank_transfer'],
        ).allowed,
        isFalse,
      );
      expect(
        evaluateMobilePaymentMethodGate(
          methodType: 'bank_transfer',
          subscriptionTier: 'business',
          grantedGates: const <String>['bank_transfer'],
        ).allowed,
        isTrue,
      );

      // Mid-cycle add-on proration ($39 for 15/30 days = $19.5)
      expect(
        computeMobileAddonProration(
          basePrice: '39',
          remainingDays: 15,
          totalCycleDays: 30,
        ),
        '19.5',
      );

      // Cancellation differs from Dunning & purchased credits preserved
      final dunningDay14 = evaluateMobileRetentionLifecycle(
        scenario: 'dunning_downgrade_day_14',
        paidTier: 'pro',
        purchasedCredits: '500',
      );
      final cancelPhase1 = evaluateMobileRetentionLifecycle(
        scenario: 'cancel_phase_1_quarantine_0_30d',
        paidTier: 'pro',
        purchasedCredits: '500',
      );
      expect(dunningDay14.effectiveTier, 'free');
      expect(dunningDay14.readOnlyMode, isFalse);
      expect(dunningDay14.preservedPurchasedCredits, '500');
      expect(cancelPhase1.subscriptionStatus, 'canceled');
      expect(cancelPhase1.retentionPhase, 'read_only_quarantine_0_30d');
      expect(cancelPhase1.readOnlyMode, isTrue);
      expect(cancelPhase1.preservedPurchasedCredits, '500');

      // Restore/export/erase SHA-512 evidence & EC-M23-002 multi-member deletion guard
      final blockedErase = evaluateMobileEraseRestoreEvidence(
        actionType: 'erase_right_to_erasure',
        workspaceId: '00000000-0000-4000-8000-000000000001',
        activeMemberCount: 3,
        ownershipTransferredOrMembersRemoved: false,
        purchasedCredits: '250',
      );
      expect(blockedErase.allowed, isFalse);
      expect(blockedErase.errorCode, 'BILLING_CONFLICT_002');

      final phase1Restore = evaluateMobileEraseRestoreEvidence(
        actionType: 'restore_phase_1',
        workspaceId: '00000000-0000-4000-8000-000000000001',
        activeMemberCount: 1,
        ownershipTransferredOrMembersRemoved: true,
        purchasedCredits: '250',
      );
      expect(phase1Restore.allowed, isTrue);
      expect(phase1Restore.evidenceSha512Hex.length, 128);
      expect(phase1Restore.preservedPurchasedCredits, '250');

      // Measured cohort economics
      final cohort = computeMobileCohortEconomics(
        activeWorkspaces: 100,
        totalRevenueUsd: '10000',
        totalCogsUsd: '3000',
        aiProviderCostUsd: '2000',
        startingMrrUsd: '8000',
        endingRetainedMrrUsd: '8800',
        salesAndMarketingSpendUsd: '2800',
        newPaidWorkspacesAcquired: 20,
        monthlyLogoChurnRatePct: '5',
      );
      expect(cohort.grossMarginPct, '70');
      expect(cohort.netRevenueRetentionPct, '110');
      expect(cohort.blendedCacUsd, '140');
      expect(cohort.ltvUsd, '1400');
      expect(cohort.ltvToCacRatio, '10');
      expect(cohort.cacPaybackMonths, '2');
      expect(cohort.aiCostPerActiveWorkspaceUsd, '20');
    });
  });
}
