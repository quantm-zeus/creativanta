/// Commerce Acceptance & Operational Repair Mobile Models (P6-09)
/// Canonical Sources:
/// - docs/00_index/BUILD_INDEX.md
/// - docs/02_features/commerce/product_hub.md (M13)
/// - docs/02_features/commerce/monetization_os.md (M14)
/// - docs/02_features/commerce/creator_store.md (M15)
/// - docs/02_features/commerce/affiliate_network.md (M16)
/// - docs/02_features/commerce/live_war_room.md (M17)
/// - docs/02_features/commerce/seeding_crm.md (M18)
/// - docs/02_features/commerce/creator_pro_tools.md (S16)
/// - docs/04_contracts/financial_computation_contract.md
library;

enum CommerceSourceClass {
  official,
  imported,
  inferred,
  estimated,
  unreconciled,
}

enum CommerceModuleID {
  m04,
  m05,
  m09,
  m12,
  m13,
  m14,
  m15,
  m16,
  m17,
  m18,
  s16,
  m19,
}

class MobileModuleIntegritySummary {
  final String moduleId;
  final String name;
  final int connectedLinks;
  final int activeEntities;
  final String status;
  final String route;

  const MobileModuleIntegritySummary({
    required this.moduleId,
    required this.name,
    required this.connectedLinks,
    required this.activeEntities,
    required this.status,
    required this.route,
  });
}

class MobileCrossModuleLink {
  final String fromModule;
  final String toModule;
  final String linkType;
  final String sourceId;
  final String targetId;
  final bool verified;
  final String description;

  const MobileCrossModuleLink({
    required this.fromModule,
    required this.toModule,
    required this.linkType,
    required this.sourceId,
    required this.targetId,
    required this.verified,
    required this.description,
  });
}

class MobileUnreconciledOutcome {
  final String id;
  final String workspaceId;
  final String domain;
  final String entityId;
  final String title;
  final CommerceSourceClass sourceClass;
  final double confidenceScore;
  final String status;
  final String detail;
  final String financialImpactExact;
  final String? originalCapturedExact;
  final String? refundedAmountExact;
  final String? physicalReturnState;
  final bool requiresAuditReason;
  final String repairActionSuggested;
  final bool resolved;
  final String? resolvedAt;
  final String? auditReason;
  final String createdAt;

  const MobileUnreconciledOutcome({
    required this.id,
    required this.workspaceId,
    required this.domain,
    required this.entityId,
    required this.title,
    required this.sourceClass,
    required this.confidenceScore,
    required this.status,
    required this.detail,
    required this.financialImpactExact,
    this.originalCapturedExact,
    this.refundedAmountExact,
    this.physicalReturnState,
    required this.requiresAuditReason,
    required this.repairActionSuggested,
    required this.resolved,
    this.resolvedAt,
    this.auditReason,
    required this.createdAt,
  });

  MobileUnreconciledOutcome copyWith({
    String? status,
    CommerceSourceClass? sourceClass,
    double? confidenceScore,
    bool? resolved,
    String? resolvedAt,
    String? auditReason,
  }) {
    return MobileUnreconciledOutcome(
      id: id,
      workspaceId: workspaceId,
      domain: domain,
      entityId: entityId,
      title: title,
      sourceClass: sourceClass ?? this.sourceClass,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      status: status ?? this.status,
      detail: detail,
      financialImpactExact: financialImpactExact,
      originalCapturedExact: originalCapturedExact,
      refundedAmountExact: refundedAmountExact,
      physicalReturnState: physicalReturnState,
      requiresAuditReason: requiresAuditReason,
      repairActionSuggested: repairActionSuggested,
      resolved: resolved ?? this.resolved,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      auditReason: auditReason ?? this.auditReason,
      createdAt: createdAt,
    );
  }
}

class MobileOperationalRepairRequest {
  final String workspaceId;
  final String unreconciledId;
  final String repairType;
  final String auditReason;
  final String actorId;
  final String actorRole;

  const MobileOperationalRepairRequest({
    required this.workspaceId,
    required this.unreconciledId,
    required this.repairType,
    required this.auditReason,
    required this.actorId,
    required this.actorRole,
  });
}

class MobileOperationalRepairResult {
  final bool success;
  final String unreconciledId;
  final String actionTaken;
  final String repairedAt;
  final String? ledgerPostingId;
  final String auditLogEntryId;

  const MobileOperationalRepairResult({
    required this.success,
    required this.unreconciledId,
    required this.actionTaken,
    required this.repairedAt,
    this.ledgerPostingId,
    required this.auditLogEntryId,
  });
}

class MobileShippingParcel {
  final String trackingNumber;
  final String carrier;
  final String orderId;
  final String? sampleRequestId;
  final String state;
  final String shippingCostExact;
  final int weightGrams;
  final String destinationProvince;
  final String lastStatusUpdate;
  final bool signatureVerified;
  final String externalGateId;
  final String gateStatus;

  const MobileShippingParcel({
    required this.trackingNumber,
    required this.carrier,
    required this.orderId,
    this.sampleRequestId,
    required this.state,
    required this.shippingCostExact,
    required this.weightGrams,
    required this.destinationProvince,
    required this.lastStatusUpdate,
    required this.signatureVerified,
    required this.externalGateId,
    required this.gateStatus,
  });
}

class MobilePaymentGateHealth {
  final String provider;
  final bool configured;
  final bool webhookHmacVerified;
  final bool replayDeduplicated;
  final bool latePaymentRecovery;
  final String externalGateId;
  final String gateStatus;

  const MobilePaymentGateHealth({
    required this.provider,
    required this.configured,
    required this.webhookHmacVerified,
    required this.replayDeduplicated,
    required this.latePaymentRecovery,
    required this.externalGateId,
    required this.gateStatus,
  });
}

class MobileExternalGateInfo {
  final String gateId;
  final String status;
  final String description;

  const MobileExternalGateInfo({
    required this.gateId,
    required this.status,
    required this.description,
  });
}

class MobileProviderAndShippingGateSummary {
  final String workspaceId;
  final String checkedAt;
  final List<MobilePaymentGateHealth> paymentGates;
  final List<MobileShippingParcel> shippingGates;
  final List<MobileExternalGateInfo> externalGates;

  const MobileProviderAndShippingGateSummary({
    required this.workspaceId,
    required this.checkedAt,
    required this.paymentGates,
    required this.shippingGates,
    required this.externalGates,
  });
}

class MobileCommerceHubStore {
  static List<MobileModuleIntegritySummary> getModuleIntegritySummaries() {
    return const [
      MobileModuleIntegritySummary(moduleId: 'M04', name: 'Opportunity Board', connectedLinks: 4, activeEntities: 18, status: 'HEALTHY', route: '/opportunities'),
      MobileModuleIntegritySummary(moduleId: 'M05', name: 'Idea Engine', connectedLinks: 3, activeEntities: 24, status: 'HEALTHY', route: '/ideas'),
      MobileModuleIntegritySummary(moduleId: 'M09', name: 'Asset Derivatives', connectedLinks: 2, activeEntities: 12, status: 'HEALTHY', route: '/derivatives'),
      MobileModuleIntegritySummary(moduleId: 'M12', name: 'Unified Inbox', connectedLinks: 3, activeEntities: 45, status: 'HEALTHY', route: '/inbox'),
      MobileModuleIntegritySummary(moduleId: 'M13', name: 'Product Hub & Inventory', connectedLinks: 6, activeEntities: 30, status: 'HEALTHY', route: '/products'),
      MobileModuleIntegritySummary(moduleId: 'M14', name: 'Monetization OS', connectedLinks: 5, activeEntities: 15, status: 'HEALTHY', route: '/monetization'),
      MobileModuleIntegritySummary(moduleId: 'M15', name: 'Creator Store', connectedLinks: 4, activeEntities: 8, status: 'HEALTHY', route: '/store'),
      MobileModuleIntegritySummary(moduleId: 'M16', name: 'Affiliate Network', connectedLinks: 4, activeEntities: 22, status: 'HEALTHY', route: '/affiliates'),
      MobileModuleIntegritySummary(moduleId: 'M17', name: 'Live War Room', connectedLinks: 4, activeEntities: 6, status: 'HEALTHY', route: '/live'),
      MobileModuleIntegritySummary(moduleId: 'M18', name: 'Seeding CRM', connectedLinks: 4, activeEntities: 14, status: 'HEALTHY', route: '/seeding'),
      MobileModuleIntegritySummary(moduleId: 'S16', name: 'Creator Pro Tools', connectedLinks: 5, activeEntities: 10, status: 'HEALTHY', route: '/creator-pro'),
      MobileModuleIntegritySummary(moduleId: 'M19', name: 'Operating Ledger', connectedLinks: 8, activeEntities: 140, status: 'HEALTHY', route: '/ledger'),
    ];
  }

  static List<MobileCrossModuleLink> getCrossModuleLinks() {
    return const [
      MobileCrossModuleLink(fromModule: 'M04', toModule: 'M14', linkType: 'conversion', sourceId: 'opp-01', targetId: 'cmp-01', verified: true, description: 'Cơ hội chuyển đổi thành Chiến dịch có kiểm tra quyền'),
      MobileCrossModuleLink(fromModule: 'M04', toModule: 'M17', linkType: 'conversion', sourceId: 'opp-02', targetId: 'live-01', verified: true, description: 'Cơ hội chuyển đổi thành Phiên Live War Room'),
      MobileCrossModuleLink(fromModule: 'M05', toModule: 'M14', linkType: 'conversion', sourceId: 'idea-01', targetId: 'ofr-01', verified: true, description: 'Ý tưởng video chuyển đổi thành Gói ưu đãi'),
      MobileCrossModuleLink(fromModule: 'M12', toModule: 'M18', linkType: 'conversion', sourceId: 'th-01', targetId: 'smp-01', verified: true, description: 'Hội thoại inbox chuyển đổi thành Yêu cầu gửi mẫu'),
      MobileCrossModuleLink(fromModule: 'M13', toModule: 'M14', linkType: 'reference', sourceId: 'prod-01', targetId: 'ofr-01', verified: true, description: 'Gói ưu đãi liên kết danh mục SKU và tồn kho'),
      MobileCrossModuleLink(fromModule: 'M13', toModule: 'M15', linkType: 'inventory_guard', sourceId: 'prod-01', targetId: 'bndl-01', verified: true, description: 'Store bundle kiểm tra tồn kho từng SKU trước khi bán'),
      MobileCrossModuleLink(fromModule: 'M17', toModule: 'M09', linkType: 'clip_extraction', sourceId: 'live-01', targetId: 'deriv-01', verified: true, description: 'Highlight live trích xuất thành clip phái sinh'),
      MobileCrossModuleLink(fromModule: 'M18', toModule: 'M19', linkType: 'ledger_cost', sourceId: 'smp-01', targetId: 'cost-01', verified: true, description: 'Chi phí vận chuyển mẫu ghi nhận Sổ cái M19'),
      MobileCrossModuleLink(fromModule: 'M16', toModule: 'M19', linkType: 'commission_proof', sourceId: 'aff-01', targetId: 'payout-01', verified: true, description: 'Hoa hồng Affiliate đối soát chứng từ Sổ cái'),
      MobileCrossModuleLink(fromModule: 'S16', toModule: 'M19', linkType: 'content_roi', sourceId: 'deal-01', targetId: 'post-01', verified: true, description: 'Hợp đồng tài trợ đối chiếu quyết toán Sổ cái'),
    ];
  }

  static List<MobileUnreconciledOutcome> getInitialUnreconciledOutcomes(String workspaceId) {
    final now = DateTime.now().toUtc().toIso8601String();
    return [
      MobileUnreconciledOutcome(
        id: 'unrec-refund-001',
        workspaceId: workspaceId,
        domain: 'order_refund',
        entityId: 'order-part-refund-99',
        title: 'Đơn #99 hoàn tiền một phần (200.000 / 500.000 VND)',
        sourceClass: CommerceSourceClass.official,
        confidenceScore: 1.0,
        status: 'partially_refunded',
        detail: 'Khách hàng giữ hàng vật lý nhưng yêu cầu bồi hoàn bao bì; hàng vật lý không hoàn lại kho, tiền hoàn trừ Sổ cái M19.',
        financialImpactExact: '200000.000000',
        originalCapturedExact: '500000.000000',
        refundedAmountExact: '200000.000000',
        physicalReturnState: 'not_returned',
        requiresAuditReason: true,
        repairActionSuggested: 'settle_partial_refund',
        resolved: false,
        createdAt: now,
      ),
      MobileUnreconciledOutcome(
        id: 'unrec-return-002',
        workspaceId: workspaceId,
        domain: 'order_refund',
        entityId: 'order-ret-only-88',
        title: 'Đơn #88 nhận lại hàng vật lý chưa hoàn tiền (RULE-M13-006)',
        sourceClass: CommerceSourceClass.official,
        confidenceScore: 1.0,
        status: 'returned',
        detail: 'Kho đã nhập lại tồn kho vật lý (+1 unit); lệnh hoàn tiền đang chờ Manager duyệt.',
        financialImpactExact: '350000.000000',
        originalCapturedExact: '350000.000000',
        refundedAmountExact: '0.000000',
        physicalReturnState: 'returned',
        requiresAuditReason: true,
        repairActionSuggested: 'settle_partial_refund',
        resolved: false,
        createdAt: now,
      ),
      MobileUnreconciledOutcome(
        id: 'unrec-stock-003',
        workspaceId: workspaceId,
        domain: 'stock_movement',
        entityId: 'sku-tshirt-xl-black',
        title: 'Lệch tồn kho Áo thun XL: Sàn 14 cái, Sổ cái 15 cái',
        sourceClass: CommerceSourceClass.unreconciled,
        confidenceScore: 0.60,
        status: 'stock_discrepancy',
        detail: 'Lệch 1 cái nghi do hàng mẫu gửi đi chưa kịp trừ kho; cần tạo bút toán điều chỉnh kèm lý do (EC-M13-004).',
        financialImpactExact: '180000.000000',
        requiresAuditReason: true,
        repairActionSuggested: 'reconcile_stock_adjustment',
        resolved: false,
        createdAt: now,
      ),
      MobileUnreconciledOutcome(
        id: 'unrec-seeding-004',
        workspaceId: workspaceId,
        domain: 'seeding_crm',
        entityId: 'smp-req-creator-linh',
        title: 'Mẫu Creator Linh Ka đã giao — Chờ creator đăng bài',
        sourceClass: CommerceSourceClass.estimated,
        confidenceScore: 0.50,
        status: 'pending_outcome',
        detail: 'Mẫu đã giao 5 ngày trước; chưa có chứng từ bài đăng; tuyệt đối không coi là thất bại hay ghi nhận ảo (RULE-M18-002).',
        financialImpactExact: '420000.000000',
        requiresAuditReason: false,
        repairActionSuggested: 'qualify_seeding_outcome',
        resolved: false,
        createdAt: now,
      ),
      MobileUnreconciledOutcome(
        id: 'unrec-affiliate-005',
        workspaceId: workspaceId,
        domain: 'affiliate_statement',
        entityId: 'stmt-shopee-oct-2026',
        title: 'Bảng kê Shopee có 3 đơn đối soát chưa khớp liên kết',
        sourceClass: CommerceSourceClass.unreconciled,
        confidenceScore: 0.45,
        status: 'unmatched_statement_item',
        detail: 'Doanh thu 1.850.000 VND chưa tìm thấy link ID tương ứng; giữ nguyên nhãn unreconciled, không tự xóa.',
        financialImpactExact: '1850000.000000',
        requiresAuditReason: true,
        repairActionSuggested: 'resolve_affiliate_statement',
        resolved: false,
        createdAt: now,
      ),
      MobileUnreconciledOutcome(
        id: 'unrec-deal-006',
        workspaceId: workspaceId,
        domain: 'creator_pro_deal',
        entityId: 'deal-collab-brand-x',
        title: 'Hợp đồng Brand X: Deliverable #2 cần điều chỉnh thời lượng',
        sourceClass: CommerceSourceClass.official,
        confidenceScore: 0.85,
        status: 'disputed_deliverable',
        detail: 'Creator đăng video 45s nhưng nhãn hàng yêu cầu 60s; giữ trạng thái giao hàng chờ giải quyết trước khi quyết toán.',
        financialImpactExact: '15000000.000000',
        requiresAuditReason: true,
        repairActionSuggested: 'resolve_deal_dispute',
        resolved: false,
        createdAt: now,
      ),
    ];
  }

  static ({List<MobileUnreconciledOutcome> updatedOutcomes, MobileOperationalRepairResult result}) applyOperationalRepair(
    List<MobileUnreconciledOutcome> outcomes,
    MobileOperationalRepairRequest req,
  ) {
    if (req.auditReason.trim().isEmpty) {
      throw ArgumentError('Lý do kiểm toán (audit_reason) là bắt buộc cho mọi thao tác sửa chữa vận hành');
    }

    final targetIdx = outcomes.indexWhere((o) => o.id == req.unreconciledId);
    if (targetIdx == -1) {
      throw StateError('Không tìm thấy mục chưa đối soát có mã: ${req.unreconciledId}');
    }

    final item = outcomes[targetIdx];
    if (item.resolved) {
      throw StateError('Mục chưa đối soát này đã được xử lý trước đó');
    }

    final now = DateTime.now().toUtc().toIso8601String();
    String actionTaken = '';
    String statusUpdate = 'reconciled';

    switch (req.repairType) {
      case 'reconcile_stock_adjustment':
        actionTaken = 'Tạo bút toán điều chỉnh tồn kho kèm lý do: ${req.auditReason}';
        statusUpdate = 'reconciled';
      case 'resolve_affiliate_statement':
        actionTaken = 'Khớp dòng đối soát bảng kê với chứng từ thủ công kèm lý do: ${req.auditReason}';
        statusUpdate = 'fully_reconciled';
      case 'qualify_seeding_outcome':
        actionTaken = 'Đính kèm chứng từ bài đăng creator kèm lý do: ${req.auditReason}';
        statusUpdate = 'outcome_verified';
      case 'settle_partial_refund':
        actionTaken = 'Xác nhận quyết toán hoàn tiền một phần trong Sổ cái: ${req.auditReason}';
        statusUpdate = 'partially_refunded_settled';
      case 'resolve_deal_dispute':
        actionTaken = 'Nghiệm thu phụ lục thời lượng video và mở khóa quyết toán: ${req.auditReason}';
        statusUpdate = 'dispute_resolved';
      default:
        throw ArgumentError('Loại sửa chữa không hợp lệ: ${req.repairType}');
    }

    final updatedItem = item.copyWith(
      status: statusUpdate,
      sourceClass: CommerceSourceClass.official,
      confidenceScore: 1.0,
      resolved: true,
      resolvedAt: now,
      auditReason: req.auditReason,
    );

    final updatedOutcomes = List<MobileUnreconciledOutcome>.from(outcomes);
    updatedOutcomes[targetIdx] = updatedItem;

    final result = MobileOperationalRepairResult(
      success: true,
      unreconciledId: item.id,
      actionTaken: actionTaken,
      repairedAt: now,
      ledgerPostingId: 'post-mobile-${DateTime.now().millisecondsSinceEpoch}',
      auditLogEntryId: 'audit-mobile-${DateTime.now().millisecondsSinceEpoch}',
    );

    return (updatedOutcomes: updatedOutcomes, result: result);
  }

  static MobileProviderAndShippingGateSummary getProviderAndShippingGateSummary(String workspaceId) {
    final now = DateTime.now().toUtc().toIso8601String();
    return MobileProviderAndShippingGateSummary(
      workspaceId: workspaceId,
      checkedAt: now,
      paymentGates: const [
        MobilePaymentGateHealth(
          provider: 'stripe',
          configured: true,
          webhookHmacVerified: true,
          replayDeduplicated: true,
          latePaymentRecovery: true,
          externalGateId: 'EXT-GATE-PAYMENT-STRIPE-LIVE',
          gateStatus: 'VERIFIED_LOCAL_ADAPTER',
        ),
        MobilePaymentGateHealth(
          provider: 'tiktok_shop',
          configured: true,
          webhookHmacVerified: true,
          replayDeduplicated: true,
          latePaymentRecovery: true,
          externalGateId: 'EXT-GATE-PLATFORM-TIKTOK-PARTNER',
          gateStatus: 'VERIFIED_LOCAL_ADAPTER',
        ),
        MobilePaymentGateHealth(
          provider: 'shopee',
          configured: true,
          webhookHmacVerified: true,
          replayDeduplicated: true,
          latePaymentRecovery: true,
          externalGateId: 'EXT-GATE-PLATFORM-SHOPEE-PARTNER',
          gateStatus: 'VERIFIED_LOCAL_ADAPTER',
        ),
        MobilePaymentGateHealth(
          provider: 'lazada',
          configured: true,
          webhookHmacVerified: true,
          replayDeduplicated: true,
          latePaymentRecovery: true,
          externalGateId: 'EXT-GATE-PLATFORM-LAZADA-PARTNER',
          gateStatus: 'VERIFIED_LOCAL_ADAPTER',
        ),
      ],
      shippingGates: [
        MobileShippingParcel(
          trackingNumber: 'GHN-8829103-ORD-99',
          carrier: 'ghn',
          orderId: 'order-part-refund-99',
          state: 'delivered',
          shippingCostExact: '32000.000000',
          weightGrams: 450,
          destinationProvince: 'TP. Hồ Chí Minh',
          lastStatusUpdate: now,
          signatureVerified: true,
          externalGateId: 'EXT-GATE-SHIPPING-CARRIER-API',
          gateStatus: 'VERIFIED_LOCAL_ADAPTER',
        ),
        MobileShippingParcel(
          trackingNumber: 'GHTK-SMP-441209',
          carrier: 'ghtk',
          orderId: '',
          sampleRequestId: 'smp-req-creator-linh',
          state: 'delivered',
          shippingCostExact: '28000.000000',
          weightGrams: 280,
          destinationProvince: 'Hà Nội',
          lastStatusUpdate: now,
          signatureVerified: true,
          externalGateId: 'EXT-GATE-SHIPPING-CARRIER-API',
          gateStatus: 'VERIFIED_LOCAL_ADAPTER',
        ),
      ],
      externalGates: const [
        MobileExternalGateInfo(
          gateId: 'EXT-GATE-PAYMENT-STRIPE-LIVE',
          status: 'PENDING_PRODUCTION_KEY',
          description: 'Xử lý thẻ live Stripe & Webhook HMAC chạy dưới adapter giả lập tất định.',
        ),
        MobileExternalGateInfo(
          gateId: 'EXT-GATE-PLATFORM-TIKTOK-PARTNER',
          status: 'PENDING_EXTERNAL_PROVIDER_APPROVAL',
          description: 'TikTok Shop Partner API cần phê duyệt quyền đối tác chính thức.',
        ),
        MobileExternalGateInfo(
          gateId: 'EXT-GATE-SHIPPING-CARRIER-API',
          status: 'PENDING_CARRIER_PRODUCTION_KEY',
          description: 'Hãng vận chuyển GHN/GHTK cần production API token.',
        ),
        MobileExternalGateInfo(
          gateId: 'EXT-GATE-POSTGRES-LIVE-RLS',
          status: 'PENDING_CI_LIVE_POSTGRES',
          description: 'Chính sách FORCE ROW LEVEL SECURITY kiểm chứng trong GitHub CI.',
        ),
      ],
    );
  }
}
