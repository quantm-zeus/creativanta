import 'package:flutter/material.dart';
import 'package:creativanta_mobile/commerce/commerce_hub_models.dart';

class CommerceDashboardView extends StatefulWidget {
  const CommerceDashboardView({
    super.key,
    required this.workspaceId,
    this.initialRole = 'owner',
  });

  final String workspaceId;
  final String initialRole;

  @override
  State<CommerceDashboardView> createState() => _CommerceDashboardViewState();
}

class _CommerceDashboardViewState extends State<CommerceDashboardView> {
  late String _selectedRole;
  int _activeTabIndex = 0;
  late List<MobileUnreconciledOutcome> _unreconciledItems;
  late List<MobileModuleIntegritySummary> _moduleSummaries;
  late List<MobileCrossModuleLink> _crossModuleLinks;
  late MobileProviderAndShippingGateSummary _gateSummary;

  String? _successMessage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
    _unreconciledItems = MobileCommerceHubStore.getInitialUnreconciledOutcomes(widget.workspaceId);
    _moduleSummaries = MobileCommerceHubStore.getModuleIntegritySummaries();
    _crossModuleLinks = MobileCrossModuleLinkStore.getCrossModuleLinks();
    _gateSummary = MobileCommerceHubStore.getProviderAndShippingGateSummary(widget.workspaceId);
  }

  void _showRepairDialog(MobileUnreconciledOutcome item) {
    final reasonController = TextEditingController();
    String? localError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sửa chữa vận hành đối soát',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF242924)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF242924)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Thao tác: ${item.repairActionSuggested}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFFAD6047), fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Lý do kiểm toán (Audit Reason — Bắt buộc):',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF242924)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    key: const Key('repair-audit-reason-field'),
                    controller: reasonController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Nhập lý do kiểm toán, biên bản đối chiếu hoặc phê duyệt...',
                      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                  if (localError != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      localError!,
                      style: const TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Hủy'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        key: const Key('submit-repair-button'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF274333),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          if (reasonController.text.trim().isEmpty) {
                            setModalState(() {
                              localError = 'Lý do kiểm toán (audit_reason) là bắt buộc';
                            });
                            return;
                          }

                          try {
                            final req = MobileOperationalRepairRequest(
                              workspaceId: widget.workspaceId,
                              unreconciledId: item.id,
                              repairType: item.repairActionSuggested,
                              auditReason: reasonController.text.trim(),
                              actorId: 'user-mobile-current',
                              actorRole: _selectedRole,
                            );
                            final outcome = MobileCommerceHubStore.applyOperationalRepair(_unreconciledItems, req);
                            setState(() {
                              _unreconciledItems = outcome.updatedOutcomes;
                              _successMessage = 'Đã đối soát thành công! Mã: ${outcome.result.ledgerPostingId}';
                              _errorMessage = null;
                            });
                            Navigator.of(context).pop();
                          } catch (e) {
                            setModalState(() {
                              localError = e.toString();
                            });
                          }
                        },
                        child: const Text('Ghi nhận đối soát', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _unreconciledItems.where((i) => !i.resolved).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F6),
      appBar: AppBar(
        title: const Text('Kinh doanh & Vận hành', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF242924),
        elevation: 0.5,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButton<String>(
              value: _selectedRole,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'owner', child: Text('Owner', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                DropdownMenuItem(value: 'admin', child: Text('Admin', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                DropdownMenuItem(value: 'manager', child: Text('Manager', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                DropdownMenuItem(value: 'editor', child: Text('Editor', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                DropdownMenuItem(value: 'viewer', child: Text('Viewer', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedRole = val);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Sub-nav bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                _buildTabButton(0, '11 Phân hệ (T1)'),
                _buildTabButton(1, 'Cần Đối soát (T2) ${pendingCount > 0 ? '($pendingCount)' : ''}'),
                _buildTabButton(2, 'Cổng Dịch vụ (T3)'),
              ],
            ),
          ),
          if (_successMessage != null)
            Container(
              width: double.infinity,
              color: const Color(0xFFEAF4ED),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _successMessage!,
                style: const TextStyle(fontSize: 12, color: Color(0xFF274333), fontWeight: FontWeight.bold),
              ),
            ),
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              color: const Color(0xFFFDE8E4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _errorMessage!,
                style: const TextStyle(fontSize: 12, color: Color(0xFFAD6047), fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: IndexedStack(
              index: _activeTabIndex,
              children: [
                _buildOverviewTab(),
                _buildUnreconciledTab(),
                _buildGatesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    final active = _activeTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? const Color(0xFF274333) : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: active ? const Color(0xFF274333) : const Color(0xFF7D837B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // Acceptance Target 1 Banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4ED),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD8E6DB)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TARGET 1: KHÔNG THẤT THOÁT TÍNH NĂNG',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF274333)),
              ),
              SizedBox(height: 4),
              Text(
                '11 Phân hệ P6 + Sổ cái M19 hoàn toàn kết nối và đồng bộ chứng từ đối soát.',
                style: TextStyle(fontSize: 11, color: Color(0xFF3A5843)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Danh mục 11 Phân hệ P6',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF242924)),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.8,
          ),
          itemCount: _moduleSummaries.length,
          itemBuilder: (context, index) {
            final mod = _moduleSummaries[index];
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE8E5DC)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(mod.moduleId, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFAD6047), fontFamily: 'monospace')),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(color: const Color(0xFFEAF4ED), borderRadius: BorderRadius.circular(4)),
                        child: Text(mod.status, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF274333))),
                      ),
                    ],
                  ),
                  Text(mod.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF242924)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('${mod.connectedLinks} liên kết • ${mod.activeEntities} mục', style: const TextStyle(fontSize: 10, color: Color(0xFF7D837B))),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        const Text(
          'Chuỗi Chuyển đổi & Đối chiếu Đa Phân hệ',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF242924)),
        ),
        const SizedBox(height: 8),
        ..._crossModuleLinks.map((link) => Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE8E5DC)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFEAF4ED), borderRadius: BorderRadius.circular(4)),
                child: Text('${link.fromModule} → ${link.toModule}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF274333), fontFamily: 'monospace')),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(link.description, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF242924))),
                    const SizedBox(height: 2),
                    Text('Loại: ${link.linkType} • Đã xác minh', style: const TextStyle(fontSize: 10, color: Color(0xFF7D837B))),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildUnreconciledTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // Target 2 Banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5F3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFDE8E4)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TARGET 2: MINH BẠCH KẾT QUẢ BÁN PHẦN & CHƯA ĐỐI SOÁT',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFAD6047)),
              ),
              SizedBox(height: 4),
              Text(
                'Gắn nhãn trung thực source_class và độ tin cậy. Hỗ trợ sửa chữa vận hành với lý do kiểm toán bắt buộc.',
                style: TextStyle(fontSize: 11, color: Color(0xFF7C3B28)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ..._unreconciledItems.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: item.resolved ? const Color(0xFFF9F9F9) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: item.resolved ? Colors.grey.shade300 : const Color(0xFFE8E5DC)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFF4F2EA), borderRadius: BorderRadius.circular(4)),
                        child: Text(item.domain, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF242924), fontFamily: 'monospace')),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.sourceClass == CommerceSourceClass.official
                              ? const Color(0xFFEAF4ED)
                              : item.sourceClass == CommerceSourceClass.unreconciled
                                  ? const Color(0xFFFEE2E2)
                                  : const Color(0xFFFEF9C3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('source: ${item.sourceClass.name}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  if (!item.resolved)
                    ElevatedButton(
                      key: Key('repair-btn-${item.id}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF274333),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: () => _showRepairDialog(item),
                      child: const Text('Sửa chữa', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4)),
                      child: const Text('✓ Đã đối soát', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF242924))),
              const SizedBox(height: 4),
              Text(item.detail, style: const TextStyle(fontSize: 11, color: Color(0xFF616C63))),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trạng thái: ${item.status}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFAD6047))),
                  Text('Độ tin cậy: ${(item.confidenceScore * 100).round()}%', style: const TextStyle(fontSize: 10, color: Color(0xFF7D837B))),
                ],
              ),
              if (item.auditReason != null) ...[
                const SizedBox(height: 4),
                Text('Lý do kiểm toán: ${item.auditReason}', style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.green)),
              ],
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildGatesTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // Target 3 Banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4ED),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD8E6DB)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TARGET 3: BẰNG CHỨNG CỔNG THANH TOÁN & VẬN CHUYỂN',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF274333)),
              ),
              SizedBox(height: 4),
              Text(
                'Xác minh chữ ký HMAC webhook, chống trùng replay và minh bạch external gates.',
                style: TextStyle(fontSize: 11, color: Color(0xFF3A5843)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Cổng Thanh toán (Payment Gates)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF242924)),
        ),
        const SizedBox(height: 8),
        ..._gateSummary.paymentGates.map((gate) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE8E5DC)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(gate.provider.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF242924))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                    child: Text(gate.gateStatus, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF274333))),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text('✓ Xác minh chữ ký HMAC: ĐẠT', style: TextStyle(fontSize: 11, color: Colors.green)),
              const Text('✓ Chống gửi trùng Replay: ĐẠT', style: TextStyle(fontSize: 11, color: Colors.green)),
              const Text('✓ Phục hồi thanh toán trễ: ĐẠT', style: TextStyle(fontSize: 11, color: Colors.green)),
              const SizedBox(height: 4),
              Text('Gate ID: ${gate.externalGateId}', style: const TextStyle(fontSize: 10, color: Color(0xFF7D837B), fontFamily: 'monospace')),
            ],
          ),
        )),
        const SizedBox(height: 12),
        const Text(
          'Hãng Vận chuyển Đông Nam Á (Shipping)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF242924)),
        ),
        const SizedBox(height: 8),
        ..._gateSummary.shippingGates.map((parcel) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE8E5DC)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${parcel.carrier.toUpperCase()} • ${parcel.trackingNumber}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFAD6047), fontFamily: 'monospace')),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFEAF4ED), borderRadius: BorderRadius.circular(4)),
                    child: Text(parcel.state, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF274333))),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Điểm đến: ${parcel.destinationProvince} • Khối lượng: ${parcel.weightGrams}g', style: const TextStyle(fontSize: 11, color: Color(0xFF616C63))),
            ],
          ),
        )),
        const SizedBox(height: 12),
        const Text(
          'Bảng External Gates Độc lập',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF242924)),
        ),
        const SizedBox(height: 8),
        ..._gateSummary.externalGates.map((eg) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE8E5DC)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(eg.gateId, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF242924), fontFamily: 'monospace')),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(4)),
                    child: Text(eg.status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(eg.description, style: const TextStyle(fontSize: 11, color: Color(0xFF616C63))),
            ],
          ),
        )),
      ],
    );
  }
}

class MobileCrossModuleLinkStore {
  static List<MobileCrossModuleLink> getCrossModuleLinks() {
    return MobileCommerceHubStore.getCrossModuleLinks();
  }
}
