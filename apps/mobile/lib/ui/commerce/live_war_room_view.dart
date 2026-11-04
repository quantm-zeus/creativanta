import 'package:flutter/material.dart';
import 'package:creativanta_mobile/commerce/live_war_room_models.dart';
import 'package:creativanta_mobile/generated/creativanta/commerce/v1/live.pb.dart';

/// Screen M055: Mobile Live War Room (docs/03_screens/mobile/screen_mobile_live_war_room.md).
/// Real-time command center during live streams with cue triggers, highlight marking, and proof summary.
class MobileLiveWarRoomView extends StatefulWidget {
  const MobileLiveWarRoomView({
    super.key,
    this.workspaceId = '019086a1-7c3e-7000-8000-000000000001',
    this.sessionTitle = '🔴 Mega Live Sale — Flash Deals',
  });

  final String workspaceId;
  final String sessionTitle;

  @override
  State<MobileLiveWarRoomView> createState() => _MobileLiveWarRoomViewState();
}

class _MobileLiveWarRoomViewState extends State<MobileLiveWarRoomView> {
  late final MobileLiveWarRoomController _controller;
  bool _isPinned = true;
  MobileProofSummary? _latestSummary;

  @override
  void initState() {
    super.initState();
    _controller = MobileLiveWarRoomController();
    _controller.createSession(
      workspaceId: widget.workspaceId,
      title: widget.sessionTitle,
      idempotencyKey: 'mob-init-sess',
    );
    _controller.startSession(idempotencyKey: 'mob-start-sess');

    _controller.addCue(
      cueType: 'product_highlight',
      title: 'Serum HA 50ml — Giảm 30%',
      body: 'Nhắc khán giả mã FLASH50K chỉ áp dụng trong live!',
      pinnedProductId: 'prod-001',
      pinnedOfferId: 'off-001',
      idempotencyKey: 'mob-cue-1',
    );

    // Initial orders
    _controller.attachOrder(const MobileTraceableOrder(
      orderId: 'ORD-M-1',
      productId: 'prod-001',
      offerId: 'off-001',
      customerId: 'cust-1',
      amount: '249000.000000',
      currency: 'VND',
      reconciliationState: 'matched',
    ));
    _controller.attachOrder(const MobileTraceableOrder(
      orderId: 'ORD-M-2',
      productId: 'prod-001',
      offerId: 'off-001',
      customerId: 'cust-2',
      amount: '498000.000000',
      currency: 'VND',
      reconciliationState: 'matched',
    ));
  }

  void _triggerCue(String cueId) {
    setState(() {
      _controller.triggerCue(cueId, idempotencyKey: 'trig-$cueId');
    });
  }

  void _markHighlight(String title, String type) {
    setState(() {
      _controller.createHighlight(
        title: title,
        highlightType: type,
        startSec: 60,
        endSec: 90,
        idempotencyKey: 'hl-${DateTime.now().millisecondsSinceEpoch}',
      );
    });
  }

  void _extractHighlights() {
    setState(() {
      _controller.extractHighlights(
        sourceAssetId: 'rec-mobile-master-001',
        idempotencyKey: 'ext-${DateTime.now().millisecondsSinceEpoch}',
      );
    });
  }

  void _togglePin() {
    setState(() {
      _isPinned = !_isPinned;
      _controller.highlightProduct(
        productId: 'prod-001',
        offerId: 'off-001',
        isPinned: _isPinned,
        idempotencyKey: 'pin-${DateTime.now().millisecondsSinceEpoch}',
      );
    });
  }

  void _generateSummary() {
    setState(() {
      _latestSummary = _controller.generateProofSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = _controller.session;
    final cues = _controller.cueCards;
    final highlights = _controller.highlights;
    final orders = _controller.orders;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF18181D),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withAlpha(120)),
              ),
              child: const Text('🔴 LIVE', style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                session?.title ?? 'Live War Room',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Colors.white70),
            onPressed: _generateSummary,
            tooltip: 'Tạo tóm tắt phiên live',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Live Metrics Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E24),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('📊 Chỉ số thời gian thực', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetricBox('Đơn hàng', '${orders.length}', Colors.white),
                    _buildMetricBox('Tương tác', '14.8%', Colors.greenAccent),
                    _buildMetricBox('Điểm nhấn', '${highlights.length}', Colors.amberAccent),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Pinned Product & Flash Deal Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E24),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _isPinned ? Colors.redAccent.withAlpha(100) : Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('📌 Sản phẩm đang ghim', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                    if (_isPinned)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red.withAlpha(40), borderRadius: BorderRadius.circular(4)),
                        child: const Text('ĐANG GHIM', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Serum Phục Hồi & Dưỡng Ẩm HA 50ml', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('249.000đ  (Gốc: 350.000đ)', style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: _isPinned ? Colors.white12 : Colors.redAccent),
                        onPressed: _togglePin,
                        child: Text(_isPinned ? 'Bỏ ghim' : 'Ghim ngay', style: const TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _markHighlight('Flash Deal Serum', 'best_sale'),
                        child: const Text('⚡ Flash Sale', style: TextStyle(color: Colors.amberAccent, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Cue Cards Section
          const Text('Thẻ nhắc bài (Cue Cards)', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final cue in cues)
            Card(
              color: const Color(0xFF1E1E24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(cue.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text(cue.body, style: const TextStyle(color: Colors.white60, fontSize: 11)),
                trailing: cue.status == CueCardStatus.CUE_CARD_STATUS_USED
                    ? const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20)
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.withAlpha(40),
                          foregroundColor: Colors.greenAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                        onPressed: () => _triggerCue(cue.cueCardId),
                        child: const Text('Nhắc', style: TextStyle(fontSize: 11)),
                      ),
              ),
            ),
          const SizedBox(height: 16),

          // Highlights & Clip Extraction Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Điểm nhấn đã lưu (${highlights.length})', style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
              TextButton.icon(
                icon: const Icon(Icons.content_cut, size: 16, color: Colors.redAccent),
                label: const Text('Trích xuất M09', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                onPressed: _extractHighlights,
              ),
            ],
          ),
          for (final hl in highlights)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E24),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(hl.title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      Text('${hl.startOffsetSeconds}s - ${hl.endOffsetSeconds}s · ${hl.highlightType}', style: const TextStyle(color: Colors.white38, fontSize: 10)),
                    ],
                  ),
                  if (hl.assetId != null)
                    const Text('✓ M09 Clip', style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold))
                  else
                    const Text('Chờ trích xuất', style: TextStyle(color: Colors.white38, fontSize: 10)),
                ],
              ),
            ),

          if (_latestSummary != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.withAlpha(80)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📜 BÁO CÁO CHỨNG THỰC M19 (PROVED)', style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Doanh thu ghi nhận: ${_latestSummary!.totalRevenue} ${_latestSummary!.currency}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('Nhãn nguồn thu: ${_latestSummary!.sourceClass}', style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontFamily: 'monospace')),
                  Text('Đơn hàng đối soát: ${_latestSummary!.totalOrders}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricBox(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
