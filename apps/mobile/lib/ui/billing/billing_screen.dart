import 'package:flutter/material.dart';
import 'package:creativanta_mobile/billing/billing_models.dart';

/// M061: Mobile Billing, Credit Lots & Cost-Based Quote Screen.
class MobileBillingScreen extends StatelessWidget {
  const MobileBillingScreen({
    super.key,
    this.role = 'owner',
    this.subscriptionTier = 'pro',
    this.availableCredits = '10',
    this.requestedCredits = '8',
    this.activeReservations = 0,
  });

  final String role;
  final String subscriptionTier;
  final String availableCredits;
  final String requestedCredits;
  final int activeReservations;

  @override
  Widget build(BuildContext context) {
    final holdVerdict = evaluateMobileCreditHold(
      availableCredits: availableCredits,
      requestedCredits: requestedCredits,
      activeReservations: activeReservations,
    );
    final isOwner = canManageMobileBilling(role);

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
        ],
      ),
    );
  }
}
