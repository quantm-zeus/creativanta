import 'package:flutter/material.dart';
import 'package:creativanta_mobile/commerce/seeding_models.dart';

/// Module M18: Seeding CRM & Costs/Outcomes Mobile View (Screen M056)
class MobileSeedingView extends StatefulWidget {
  const MobileSeedingView({
    super.key,
    this.workspaceId = 'ws-mobile-seeding-01',
  });

  final String workspaceId;

  @override
  State<MobileSeedingView> createState() => _MobileSeedingViewState();
}

class _MobileSeedingViewState extends State<MobileSeedingView> {
  late List<MobileSampleRequest> _requests;
  late List<MobileSeedingCostItem> _costItems;
  String _selectedFilter = 'all'; // all, pending, shipped, received, content
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _costItems = [];
    _requests = [
      // 1. Approved & Shipped with pending outcome
      MobileSampleRequest(
        requestId: 'req-beauty-girl',
        workspaceId: widget.workspaceId,
        productId: 'prod-serum-ha',
        productTitle: 'Serum HA Phục Hồi',
        productCogs: '299000.000000',
        creatorEntityId: 'creator-bg-45k',
        creatorName: 'Beauty Girl',
        creatorHandle: '@beauty_girl',
        creatorFollowers: 45000,
        status: MobileSampleRequestStatus.approved,
        quantity: 1,
        outcomeStatus: MobileSampleOutcomeStatus.pending,
        followUpStatus: MobileFollowUpStatus.pendingFollowup,
        shippingAddress: const MobileShippingAddress(
          name: 'Nguyen Thi Huong',
          phone: '0901122334',
          addressLine1: '45 Nguyen Hue',
          city: 'Ho Chi Minh',
          country: 'VN',
        ),
        shipment: MobileSampleShipment(
          shipmentId: 'ship-bg-01',
          requestId: 'req-beauty-girl',
          workspaceId: widget.workspaceId,
          trackingNumber: 'VN123456',
          carrier: 'GHTK',
          shippingCost: '30000.000000',
          status: MobileSampleShipmentStatus.shipped,
          shippedAt: DateTime.now().subtract(const Duration(days: 2)),
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      // 2. Delivered with completed outcome & proven ROI
      MobileSampleRequest(
        requestId: 'req-skincare-tips',
        workspaceId: widget.workspaceId,
        productId: 'prod-mask-set',
        productTitle: 'Combo Mặt Nạ Tràm Trà',
        productCogs: '350000.000000',
        creatorEntityId: 'creator-st-22k',
        creatorName: 'Skincare Tips',
        creatorHandle: '@skincare_tips',
        creatorFollowers: 22000,
        status: MobileSampleRequestStatus.fulfilled,
        quantity: 2,
        outcomeStatus: MobileSampleOutcomeStatus.logged,
        followUpStatus: MobileFollowUpStatus.responded,
        outcome: MobileSampleOutcome(
          contentUrl: 'https://tiktok.com/@skincare_tips/video/77889900',
          contentType: 'video',
          publishItemId: 'pub-st-video-01',
          views: 12000,
          conversionsCount: 14,
          attributableRevenue: '1800000.000000',
          currency: 'VND',
          sourceClass: MobileSeedingSourceClass.official,
          confidenceLevel: MobileConfidenceLevel.high,
          confidenceReason: 'Verified via linked TikTok showcase and affiliate tracking',
          loggedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        shippingAddress: const MobileShippingAddress(
          name: 'Le Thi Thu',
          phone: '0988776655',
          addressLine1: '12 Tran Hung Dao',
          city: 'Hanoi',
          country: 'VN',
        ),
        shipment: MobileSampleShipment(
          shipmentId: 'ship-st-02',
          requestId: 'req-skincare-tips',
          workspaceId: widget.workspaceId,
          trackingNumber: 'GHN887766',
          carrier: 'GHN',
          shippingCost: '35000.000000',
          status: MobileSampleShipmentStatus.delivered,
          shippedAt: DateTime.now().subtract(const Duration(days: 6)),
          deliveredAt: DateTime.now().subtract(const Duration(days: 4)),
          createdAt: DateTime.now().subtract(const Duration(days: 6)),
          updatedAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      // 3. New submitted request awaiting approval
      MobileSampleRequest(
        requestId: 'req-makeup-daily',
        workspaceId: widget.workspaceId,
        productId: 'prod-lipstick-01',
        productTitle: 'Son Tint Bóng Cherry',
        productCogs: '120000.000000',
        creatorEntityId: 'creator-md-80k',
        creatorName: 'Makeup Daily',
        creatorHandle: '@makeup_daily',
        creatorFollowers: 80000,
        status: MobileSampleRequestStatus.requested,
        quantity: 1,
        outcomeStatus: MobileSampleOutcomeStatus.pending,
        followUpStatus: MobileFollowUpStatus.pendingFollowup,
        shippingAddress: const MobileShippingAddress(
          name: 'Pham Minh Anh',
          phone: '0977112233',
          addressLine1: '88 Le Duan',
          city: 'Da Nang',
          country: 'VN',
        ),
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }

  void _approveRequest(String requestId) {
    setState(() {
      final index = _requests.indexWhere((r) => r.requestId == requestId);
      if (index == -1) return;
      final req = _requests[index];

      // Target 3: Idempotent cost evaluation
      final costResult = evaluateMobileIdempotentCost(
        existingCostItems: _costItems,
        requestId: req.requestId,
        workspaceId: req.workspaceId,
        quantity: req.quantity,
        unitCogs: req.productCogs,
        shippingCost: '0.000000',
        idempotencyKey: 'idemp-approve-${req.requestId}',
        isShippingUpdate: false,
      );
      _costItems = costResult.costItems;

      _requests[index] = req.copyWith(
        status: MobileSampleRequestStatus.approved,
      );
      _statusMessage = costResult.isReplay
          ? 'Đã duyệt lại (không trùng lặp chi phí)'
          : 'Đã duyệt yêu cầu và tạo chi phí ước tính';
    });
  }

  void _shipRequest(String requestId) {
    setState(() {
      final index = _requests.indexWhere((r) => r.requestId == requestId);
      if (index == -1) return;
      final req = _requests[index];

      // Target 3: Update existing cost item in-place with shipping cost
      final costResult = evaluateMobileIdempotentCost(
        existingCostItems: _costItems,
        requestId: req.requestId,
        workspaceId: req.workspaceId,
        quantity: req.quantity,
        unitCogs: req.productCogs,
        shippingCost: '30000.000000',
        idempotencyKey: 'idemp-ship-${req.requestId}',
        isShippingUpdate: true,
      );
      _costItems = costResult.costItems;

      final now = DateTime.now();
      final shipment = req.shipment != null
          ? req.shipment!.copyWith(
              status: MobileSampleShipmentStatus.shipped,
              shippedAt: now,
            )
          : MobileSampleShipment(
              shipmentId: 'ship-${now.millisecondsSinceEpoch}',
              requestId: req.requestId,
              workspaceId: req.workspaceId,
              trackingNumber: 'GHTK-${now.millisecondsSinceEpoch % 100000}',
              carrier: 'GHTK',
              shippingCost: '30000.000000',
              status: MobileSampleShipmentStatus.shipped,
              shippedAt: now,
              createdAt: now,
              updatedAt: now,
            );

      _requests[index] = req.copyWith(
        shipment: shipment,
      );
      _statusMessage = 'Đã gửi hàng & cập nhật chi phí vận chuyển';
    });
  }

  void _markDelivered(String requestId) {
    setState(() {
      final index = _requests.indexWhere((r) => r.requestId == requestId);
      if (index == -1) return;
      final req = _requests[index];
      if (req.shipment == null) return;

      final deliveredShipment = req.shipment!.copyWith(
        status: MobileSampleShipmentStatus.delivered,
        deliveredAt: DateTime.now(),
      );

      // Target 1: Logistics fulfilled, outcome remains pending!
      _requests[index] = req.copyWith(
        status: MobileSampleRequestStatus.fulfilled,
        shipment: deliveredShipment,
        outcomeStatus: MobileSampleOutcomeStatus.pending,
      );
      _statusMessage = 'Xác nhận creator đã nhận hàng (outcome đang chờ)';
    });
  }

  void _linkOutcome(String requestId) {
    setState(() {
      final index = _requests.indexWhere((r) => r.requestId == requestId);
      if (index == -1) return;
      final req = _requests[index];

      final outcome = MobileSampleOutcome(
        contentUrl: 'https://tiktok.com/@creator/video/new',
        contentType: 'video',
        publishItemId: 'pub-item-new',
        conversionsCount: 8,
        attributableRevenue: '950000.000000',
        currency: 'VND',
        sourceClass: MobileSeedingSourceClass.official,
        confidenceLevel: MobileConfidenceLevel.high,
        loggedAt: DateTime.now(),
      );

      _requests[index] = req.copyWith(
        outcomeStatus: MobileSampleOutcomeStatus.logged,
        outcome: outcome,
        followUpStatus: MobileFollowUpStatus.responded,
      );
      _statusMessage = 'Đã ghi nhận video review và doanh thu quy đổi';
    });
  }

  List<MobileSampleRequest> get _filteredRequests {
    return _requests.where((r) {
      if (_selectedFilter == 'pending') {
        return r.status == MobileSampleRequestStatus.requested;
      }
      if (_selectedFilter == 'shipped') {
        return r.shipment != null && r.shipment!.status == MobileSampleShipmentStatus.shipped;
      }
      if (_selectedFilter == 'received') {
        return r.shipment != null && r.shipment!.status == MobileSampleShipmentStatus.delivered;
      }
      if (_selectedFilter == 'content') {
        return r.outcomeStatus == MobileSampleOutcomeStatus.logged;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final report = computeMobileSeedingReport(
      requests: _requests,
      workspaceId: widget.workspaceId,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('📦 Seeding CRM'),
        actions: [
          IconButton(
            key: const Key('btn-create-request'),
            icon: const Icon(Icons.add),
            tooltip: 'Tạo request',
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Status snackbar if message exists
          if (_statusMessage != null)
            Container(
              key: const Key('status-banner'),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.green.shade50,
              child: Text(
                _statusMessage!,
                style: TextStyle(color: Colors.green.shade800, fontSize: 13),
              ),
            ),

          // 1. Seeding ROI Summary Card
          Card(
            key: const Key('seeding-summary-card'),
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hiệu quả Seeding (ROI)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: report.overallConfidence == MobileConfidenceLevel.high
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Độ tin cậy: ${report.overallConfidence.name}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: report.overallConfidence == MobileConfidenceLevel.high
                                ? Colors.green.shade900
                                : Colors.orange.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricCol('Tổng chi phí', report.totalCost, Colors.grey.shade800),
                      _buildMetricCol('Doanh thu gán', report.attributableRevenue, Colors.blue.shade700),
                      _buildMetricCol('ROI ước tính', report.roiPercentage, Colors.green.shade700),
                      _buildMetricCol('Tỷ lệ có video', report.outcomeCoverageRate, Colors.purple.shade700),
                    ],
                  ),
                  if (report.isMissingOutcomePending) ...[
                    const Divider(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 16, color: Colors.amber),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '⚠️ ${report.pendingOutcomesCount} mẫu đã giao đang chờ creator đăng video. Chưa tính là 0đ thất bại.',
                            style: const TextStyle(fontSize: 12, color: Colors.brown),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // 2. Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                _buildFilterChip('all', 'Tất cả (${_requests.length})'),
                _buildFilterChip('pending', '⏳ Chờ duyệt'),
                _buildFilterChip('shipped', '🚚 Đang giao'),
                _buildFilterChip('received', '📬 Đã nhận'),
                _buildFilterChip('content', '🎬 Đã có video'),
              ],
            ),
          ),

          // 3. Request List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRequests.length,
              itemBuilder: (context, index) {
                final req = _filteredRequests[index];
                return _buildRequestCard(req);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCol(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final selected = _selectedFilter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        key: Key('chip-filter-$key'),
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          setState(() {
            _selectedFilter = key;
          });
        },
      ),
    );
  }

  Widget _buildRequestCard(MobileSampleRequest req) {
    final hasDeliveredShipment = req.shipment != null &&
        req.shipment!.status == MobileSampleShipmentStatus.delivered;
    final isPendingOutcome = hasDeliveredShipment &&
        req.outcomeStatus == MobileSampleOutcomeStatus.pending;

    return Card(
      key: Key('card-request-${req.requestId}'),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Creator header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      child: Text(req.creatorName.isNotEmpty ? req.creatorName[0] : 'C'),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${req.creatorName} (${req.creatorHandle})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${req.creatorFollowers} followers',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                // Target 1: Badges for independent states
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBadge(req.status.name.toUpperCase(), Colors.blue),
                    if (req.shipment != null)
                      _buildBadge(req.shipment!.status.name.toUpperCase(), Colors.amber),
                  ],
                ),
              ],
            ),
            const Divider(height: 14),

            // Product & Cost info
            Text(
              '📦 ${req.productTitle} x ${req.quantity}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'Giá vốn COGS: ${req.productCogs} VND ${req.shipment != null ? '+ Ship: ${req.shipment!.shippingCost}' : ''}',
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),

            // Target 2: Missing outcome banner
            if (isPendingOutcome)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.hourglass_top, size: 14, color: Colors.amber),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Đã nhận hàng - Chờ creator đăng nội dung (Chưa tính là 0đ doanh thu)',
                        style: TextStyle(fontSize: 11, color: Colors.brown),
                      ),
                    ),
                  ],
                ),
              ),

            // Outcome info if logged
            if (req.outcomeStatus == MobileSampleOutcomeStatus.logged && req.outcome != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '🎬 Video đã đăng · ${req.outcome!.views} views',
                      style: TextStyle(fontSize: 12, color: Colors.green.shade900),
                    ),
                    Text(
                      '+${req.outcome!.attributableRevenue} VND',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 8),

            // Action row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (req.status == MobileSampleRequestStatus.requested)
                  ElevatedButton(
                    key: Key('btn-approve-${req.requestId}'),
                    onPressed: () => _approveRequest(req.requestId),
                    child: const Text('Duyệt yêu cầu'),
                  ),
                if (req.status == MobileSampleRequestStatus.approved &&
                    (req.shipment == null || req.shipment!.status == MobileSampleShipmentStatus.preparing))
                  ElevatedButton(
                    key: Key('btn-ship-${req.requestId}'),
                    onPressed: () => _shipRequest(req.requestId),
                    child: const Text('Gửi hàng'),
                  ),
                if (req.shipment != null && req.shipment!.status == MobileSampleShipmentStatus.shipped)
                  ElevatedButton(
                    key: Key('btn-deliver-${req.requestId}'),
                    onPressed: () => _markDelivered(req.requestId),
                    child: const Text('Đã nhận hàng'),
                  ),
                if (isPendingOutcome)
                  ElevatedButton(
                    key: Key('btn-link-outcome-${req.requestId}'),
                    onPressed: () => _linkOutcome(req.requestId),
                    child: const Text('Ghi nhận video'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
