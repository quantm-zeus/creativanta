import 'package:flutter/material.dart';
import 'package:creativanta_mobile/billing/billing_models.dart';

/// M061: Mobile Billing, Credit Lots & Cost-Based Quote Screen.
class MobileBillingScreen extends StatelessWidget {
  final String role;
  final String subscriptionTier;
  final String availableCredits;
  final String requestedCredits;
  final int activeReservations;
  final String purchasedCredits;
  final String lifecycleScenario;
  final String paymentMethodType;
  final List<String> grantedPaymentGates;

  const MobileBillingScreen({
    super.key,
    this.role = 'owner',
    this.subscriptionTier = 'pro',
    this.availableCredits = '10',
    this.requestedCredits = '8',
    this.activeReservations = 0,
    this.purchasedCredits = '500',
    this.lifecycleScenario = 'cancel_phase_1_quarantine_0_30d',
    this.paymentMethodType = 'card',
    this.grantedPaymentGates = const <String>[],
  });

  @override
  Widget build(BuildContext context) {
    final holdVerdict = evaluateMobileCreditHold(
      availableCredits: availableCredits,
      requestedCredits: requestedCredits,
      activeReservations: activeReservations,
    );
    final isOwner = canManageMobileBilling(role);
    final gateVerdict = evaluateMobilePaymentMethodGate(
      methodType: paymentMethodType,
      subscriptionTier: subscriptionTier,
      grantedGates: grantedPaymentGates,
    );
    final lifecycleVerdict = evaluateMobileRetentionLifecycle(
      scenario: lifecycleScenario,
      paidTier: subscriptionTier,
      purchasedCredits: purchasedCredits,
    );
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán & Credits (M061)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'P0-06: Credit Lots, Báo giá & Thanh toán',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('Phiên bản bảng giá: $kMobilePricebookVersion'),
                  Text('Gói hiện tại: $subscriptionTier'),
                  Text('Vai trò: $role (${isOwner ? "Owner-only: Cho phép" : "Chỉ xem"})'),
                  const SizedBox(height: 8),
                  Text('Kết quả giữ chỗ: ${holdVerdict.errorCode}'),
                  Text('Khả dụng sau giữ chỗ: ${holdVerdict.remainingAvailable}'),
                  Text(holdVerdict.explanation),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'P8-02: Cổng Thanh toán, Vòng đời Dunning ≠ Hủy gói & Kinh tế Cohort (M045)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Text('Cổng thanh toán (${gateVerdict.accessGateKey}): ${gateVerdict.errorCode}'),
                  Text('Giai đoạn lưu giữ: ${lifecycleVerdict.retentionPhase}'),
                  Text('Credits đã mua bảo toàn: ${lifecycleVerdict.preservedPurchasedCredits}'),
                  Text(lifecycleVerdict.summary),
                  const SizedBox(height: 6),
                  Text(
                    'Cohort Economics: GM=${cohort.grossMarginPct}% · NRR=${cohort.netRevenueRetentionPct}% · LTV:CAC=${cohort.ltvToCacRatio}x',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
