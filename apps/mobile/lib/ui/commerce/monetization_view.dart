import 'package:flutter/material.dart';
import 'package:creativanta_mobile/commerce/monetization_models.dart';
import 'package:creativanta_mobile/generated/creativanta/commerce/v1/monetization.pb.dart';

/// M14: Mobile Monetization OS Screen.
/// Displays active offers, coupons, campaign budget utilization and checkout simulation.
class MobileMonetizationView extends StatefulWidget {
  const MobileMonetizationView({
    super.key,
    this.workspaceId = 'ws-mobile-comm-01',
  });

  final String workspaceId;

  @override
  State<MobileMonetizationView> createState() => _MobileMonetizationViewState();
}

class _MobileMonetizationViewState extends State<MobileMonetizationView> {
  late MobileOffer _activeOffer;
  late MobileOffer _expiredOffer;
  late MobileCoupon _limitedCoupon;
  late MobileCampaign _campaign;
  MobileCheckoutResult? _lastCheckoutResult;

  @override
  void initState() {
    super.initState();
    _activeOffer = MobileOffer(
      offerId: 'off-mob-active',
      workspaceId: widget.workspaceId,
      title: 'Khuyến mãi khai trương 20%',
      offerType: OfferType.OFFER_TYPE_PRODUCT_OFFER,
      pricingValue: '20.000000',
      pricingCurrency: 'VND',
      productId: 'prod-mob-1',
      lifecycleState: OfferLifecycleState.OFFER_LIFECYCLE_STATE_ACTIVE,
      validUntil: DateTime.now().toUtc().add(const Duration(days: 7)),
    );

    _expiredOffer = MobileOffer(
      offerId: 'off-mob-expired',
      workspaceId: widget.workspaceId,
      title: 'Giảm giá cuối tuần (Đã hết hạn)',
      offerType: OfferType.OFFER_TYPE_PRODUCT_OFFER,
      pricingValue: '50.000000',
      pricingCurrency: 'VND',
      productId: 'prod-mob-1',
      lifecycleState: OfferLifecycleState.OFFER_LIFECYCLE_STATE_EXPIRED,
      validUntil: DateTime.now().toUtc().subtract(const Duration(days: 1)),
    );

    _limitedCoupon = MobileCoupon(
      couponId: 'cpn-mob-flash',
      workspaceId: widget.workspaceId,
      code: 'FLASH30K',
      couponType: CouponType.COUPON_TYPE_FIXED_AMOUNT,
      discountValue: '30000.000000',
      maxUses: 3,
      currentUses: 0,
      minOrderAmount: '100000.000000',
      lifecycleState: CouponLifecycleState.COUPON_LIFECYCLE_STATE_ACTIVE,
    );

    _campaign = MobileCampaign(
      campaignId: 'camp-mob-q4',
      workspaceId: widget.workspaceId,
      title: 'Chiến dịch Livestream Q4',
      campaignType: CampaignType.CAMPAIGN_TYPE_LIVE,
      status: CampaignStatus.CAMPAIGN_STATUS_LIVE,
      budget: '5000000.000000',
      budgetCurrency: 'VND',
      totalSpend: '4250000.000000',
    );
  }

  void _runCheckout({required bool useExpiredOffer}) {
    final offer = useExpiredOffer ? _expiredOffer : _activeOffer;
    final res = evaluateMobileCheckout(
      workspaceId: widget.workspaceId,
      offer: offer,
      coupon: _limitedCoupon,
      orderAmount: '200000.000000',
      currency: 'VND',
    );

    setState(() {
      _lastCheckoutResult = res;
      if (res.accepted && res.updatedCoupon != null) {
        _limitedCoupon = res.updatedCoupon!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monetization OS (M14)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          // Budget Alert Card (EC-M14-003)
          if (_campaign.isWarning)
            Card(
              color: _campaign.isOverBudget ? Colors.red.shade50 : Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: <Widget>[
                    Icon(
                      _campaign.isOverBudget ? Icons.error : Icons.warning_amber,
                      color: _campaign.isOverBudget ? Colors.red : Colors.amber.shade900,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Chiến dịch: ${_campaign.title} đã dùng ${_campaign.utilizationPercentage}% ngân sách (Cảnh báo vượt ngưỡng 80%)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _campaign.isOverBudget ? Colors.red.shade900 : Colors.amber.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Overview Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Ưu đãi & Hạn mức mã giảm giá',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('Ưu đãi hiệu lực: ${_activeOffer.title}'),
                  Text('Ưu đãi hết hạn: ${_expiredOffer.title} (Target 1)'),
                  const SizedBox(height: 4),
                  Text(
                    'Coupon: ${_limitedCoupon.code} (${_limitedCoupon.currentUses}/${_limitedCoupon.maxUses} lượt) [${_limitedCoupon.lifecycleState.name}]',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Thử nghiệm Checkout (Acceptance Targets)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _runCheckout(useExpiredOffer: false),
                        child: const Text('Checkout Hợp lệ'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _runCheckout(useExpiredOffer: true),
                        child: const Text('Thử Ưu đãi Hết hạn'),
                      ),
                    ],
                  ),
                  if (_lastCheckoutResult != null) ...<Widget>[
                    const Divider(height: 24),
                    Text(
                      _lastCheckoutResult!.accepted
                          ? '✅ Chấp thuận: Giảm ${_lastCheckoutResult!.discountAmount} -> Net ${_lastCheckoutResult!.netPayableAmount} VND'
                          : '❌ Từ chối: ${_lastCheckoutResult!.errorCode} (${_lastCheckoutResult!.errorMessage})',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _lastCheckoutResult!.accepted ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                    ),
                    if (_lastCheckoutResult!.posting != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        'Sổ cái M19: ${_lastCheckoutResult!.posting!.postingId} | Thuần: ${_lastCheckoutResult!.posting!.netAmount} VND',
                        style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
