import 'package:flutter/material.dart';
import 'package:creativanta_mobile/commerce/store_models.dart';

/// Module M15: Creator Store, Digital Delivery, Bundles & Memberships Mobile View
class MobileStoreView extends StatefulWidget {
  const MobileStoreView({
    super.key,
    this.workspaceId = 'ws-mobile-store-01',
  });

  final String workspaceId;

  @override
  State<MobileStoreView> createState() => _MobileStoreViewState();
}

class _MobileStoreViewState extends State<MobileStoreView> {
  late MobileStorePage _storePage;
  late MobileBundle _bundle;
  late MobileMembershipPlan _membershipPlan;
  late MobileCheckoutLedger _ledger;

  final Map<String, int> _inventory = {
    'prod-cam-mic': 10,
    'prod-lut-pack': 50,
    'prod-strap': 0, // Out of stock to demonstrate Target 1
  };

  MobileCheckoutResult? _checkoutResult;
  String? _checkoutError;

  @override
  void initState() {
    super.initState();
    _storePage = MobileStorePage(
      storePageId: 'page-mob-main',
      workspaceId: widget.workspaceId,
      title: 'Cửa hàng chính (Creator Store)',
      slug: 'main-store',
      description: 'Cửa hàng bán sản phẩm số và tài nguyên video',
      status: StorePageStatus.published,
      customDomain: 'shop.creativanta.me',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    );

    _bundle = const MobileBundle(
      bundleId: 'bun-filmmaker-kit',
      workspaceId: 'ws-mobile-store-01',
      title: 'Combo Bộ Làm Phim Toàn Diện',
      bundlePrice: '1490000.000000',
      currency: 'VND',
      items: [
        MobileBundleItem(productId: 'prod-cam-mic', productTitle: 'Microphone Rode', quantity: 1),
        MobileBundleItem(productId: 'prod-lut-pack', productTitle: 'Cinematic LUTs Pack', quantity: 1),
        MobileBundleItem(productId: 'prod-strap', productTitle: 'Dây đeo máy ảnh Pro', quantity: 1),
      ],
    );

    _membershipPlan = const MobileMembershipPlan(
      planId: 'plan-vip-club',
      workspaceId: 'ws-mobile-store-01',
      title: 'VIP Creator Club',
      description: 'Quyền lợi hội viên đặc quyền và tải không giới hạn',
      price: '199000.000000',
      currency: 'VND',
      interval: MembershipBillingInterval.monthly,
      benefits: ['Tải preset độc quyền', 'Phòng Discord VIP', 'Xem trước video 48h'],
      status: MembershipPlanStatus.active,
      subscriberCount: 142,
    );

    _ledger = MobileCheckoutLedger();
    _ledger.stockMap.addAll(_inventory);
  }

  void _runCheckout({required bool simulateReplay}) {
    setState(() {
      _checkoutError = null;
    });

    final key = simulateReplay ? 'idem-shared-payment-intent' : 'idem-${DateTime.now().millisecondsSinceEpoch}';

    try {
      final res = _ledger.processCheckout(
        MobileCheckoutRequest(
          workspaceId: widget.workspaceId,
          customerEntityId: 'cust-mob-buyer-1',
          idempotencyKey: key,
          paymentIntentId: 'pi-stripe-mob-001',
          bundleId: _bundle.bundleId,
          orderAmount: _bundle.bundlePrice,
          currency: _bundle.currency,
        ),
        bundle: _inventory['prod-strap']! > 0 ? _bundle : null,
        digitalProductIds: ['prod-lut-pack'],
      );

      setState(() {
        _checkoutResult = res;
      });
    } catch (e) {
      setState(() {
        _checkoutError = e.toString();
      });
    }
  }

  void _replenishStock() {
    setState(() {
      _inventory['prod-strap'] = 15;
      _ledger.stockMap['prod-strap'] = 15;
    });
  }

  @override
  Widget build(BuildContext context) {
    final stockCheck = checkMobileBundleStock(_bundle, _inventory, 1);
    final privilegeCheck = validateMobileBuyerPrivilegeBoundary(true, 'store:manage');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Creator Store & Memberships (M15)'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Store Page Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _storePage.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _storePage.status.name.toUpperCase(),
                          style: TextStyle(fontSize: 10, color: Colors.green.shade800, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(_storePage.description, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(
                    'Tên miền: ${_storePage.customDomain ?? _storePage.slug}',
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Colors.indigo),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Target 1: Bundle Stock Atomicity Card
          Card(
            color: stockCheck.isAvailable ? Colors.green.shade50 : Colors.amber.shade50,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: stockCheck.isAvailable ? Colors.green.shade300 : Colors.amber.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Target 1: Bundle Stock Atomic',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        stockCheck.isAvailable ? 'SẴN SÀNG' : 'HẾT HÀNG TẠM THỜI',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: stockCheck.isAvailable ? Colors.green.shade800 : Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stockCheck.isAvailable
                        ? 'Tất cả các thành phần trong bundle đều đủ số lượng.'
                        : 'Lỗi tồn kho: ${stockCheck.reason}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 8),
                  ...stockCheck.stockBreakdown.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['productTitle'] as String, style: const TextStyle(fontSize: 12)),
                        Text(
                          'Tồn: ${item['availableStock']}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: (item['isSufficient'] as bool) ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )),
                  if (!stockCheck.isAvailable) ...[
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _replenishStock,
                      child: const Text('Bổ sung tồn kho thành phần thiếu'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Target 2: Payment Replay & Digital Delivery Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Target 2: Payment Replay & Digital Delivery',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Replay thanh toán cùng Idempotency Key không được tạo thêm đơn hàng hoặc giao tài nguyên trùng lặp.',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _runCheckout(simulateReplay: false),
                        child: const Text('Thanh toán mới'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _runCheckout(simulateReplay: true),
                        child: const Text('Replay cùng Key'),
                      ),
                    ],
                  ),
                  if (_checkoutError != null) ...[
                    const SizedBox(height: 8),
                    Text(_checkoutError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ],
                  if (_checkoutResult != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Đơn hàng: ${_checkoutResult!.orderId}', style: const TextStyle(fontSize: 11)),
                          Text(
                            'Trạng thái Replay: ${_checkoutResult!.isReplayed ? "ĐÃ PHÁT HIỆN REPLAY (KHÔNG TẠO MỚI)" : "GIAO DỊCH GỐC MỚI"}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _checkoutResult!.isReplayed ? Colors.orange.shade800 : Colors.green.shade800,
                            ),
                          ),
                          Text('Số token giao hàng: ${_checkoutResult!.deliveries.length}', style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Target 3: Privilege Isolation Card
          Card(
            color: Colors.indigo.shade50,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.indigo.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Target 3: Buyer Privilege Barrier (Hội viên không mở quyền SaaS)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.indigo),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Gói Hội viên: ${_membershipPlan.title} (${_membershipPlan.subscriberCount} thành viên)',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kết quả kiểm tra bảo mật: ${privilegeCheck.denialReason}',
                    style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w600),
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
