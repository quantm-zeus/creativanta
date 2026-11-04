import 'package:creativanta_mobile/generated/creativanta/admin/v1/capability.pb.dart';

/// Maximum freshness TTL for a capability verification snapshot (10 minutes).
const Duration kCapabilityFreshnessTtl = Duration(minutes: 10);

/// Input facts for evaluating a mobile connector capability (M058 / M22).
class MobileActionVerification {
  const MobileActionVerification({
    required this.platform,
    required this.actionKey,
    required this.appApproved,
    required this.grantedScopes,
    required this.requiredScopes,
    required this.accountEligible,
    required this.supportedMarkets,
    required this.probeMethod,
    required this.probePassed,
    required this.checkedAt,
    required this.validUntil,
  });

  final String platform;
  final String actionKey;
  final bool appApproved;
  final List<String> grantedScopes;
  final List<String> requiredScopes;
  final bool accountEligible;
  final List<String> supportedMarkets;
  final String probeMethod;
  final bool probePassed;
  final DateTime checkedAt;
  final DateTime validUntil;
}

/// Evaluation verdict for a mobile connector capability cell.
class MobileCapabilityVerdict {
  const MobileCapabilityVerdict({
    required this.state,
    required this.executable,
    required this.verificationFresh,
    required this.reasonVi,
    required this.policyNoteVi,
    required this.fallbackInstructionsVi,
  });

  final CapabilityState state;
  final bool executable;
  final bool verificationFresh;
  final String reasonVi;
  final String policyNoteVi;
  final String fallbackInstructionsVi;
}

/// Validates that no granted scope contains a wildcard (`*`) or whitespace.
bool hasValidExplicitScopes(List<String> scopes) {
  for (final raw in scopes) {
    final s = raw.trim();
    if (s.isEmpty || s.contains('*') || s.contains(' ')) {
      return false;
    }
  }
  return true;
}

/// Evaluates whether a platform/action route can execute on Mobile (M058).
/// Enforces P0-07 Acceptance Target 1: unverified, stale (>10m), GET-only probe
/// on a write action, or kill-switched routes cannot execute.
MobileCapabilityVerdict evaluateMobileActionCapability({
  required String platform,
  required String actionKey,
  required bool requiresWrite,
  required bool isUnsupportedByPlatform,
  required String targetMarket,
  required DateTime now,
  required String policyNoteVi,
  required String fallbackInstructionsVi,
  MobileActionVerification? verification,
  bool killSwitchActive = false,
  String killSwitchReasonVi = '',
}) {
  if (isUnsupportedByPlatform) {
    return MobileCapabilityVerdict(
      state: CapabilityState.CAPABILITY_STATE_UNSUPPORTED,
      executable: false,
      verificationFresh: true,
      reasonVi: policyNoteVi,
      policyNoteVi: policyNoteVi,
      fallbackInstructionsVi: fallbackInstructionsVi,
    );
  }

  if (killSwitchActive) {
    return MobileCapabilityVerdict(
      state: CapabilityState.CAPABILITY_STATE_DEGRADED,
      executable: false,
      verificationFresh: false,
      reasonVi: killSwitchReasonVi.trim().isNotEmpty
          ? killSwitchReasonVi
          : 'Công tắc ngắt khẩn cấp (Kill Switch) đang kích hoạt cho $platform.',
      policyNoteVi: policyNoteVi,
      fallbackInstructionsVi: fallbackInstructionsVi,
    );
  }

  if (verification == null) {
    return MobileCapabilityVerdict(
      state: CapabilityState.CAPABILITY_STATE_MANUAL,
      executable: false,
      verificationFresh: false,
      reasonVi:
          'Chưa có hồ sơ xác minh ActionAccessVerification; bắt buộc thực hiện thủ công.',
      policyNoteVi: policyNoteVi,
      fallbackInstructionsVi: fallbackInstructionsVi,
    );
  }

  if (!hasValidExplicitScopes(verification.grantedScopes)) {
    return MobileCapabilityVerdict(
      state: CapabilityState.CAPABILITY_STATE_MANUAL,
      executable: false,
      verificationFresh: false,
      reasonVi: 'Scope không hợp lệ hoặc chứa ký tự đại diện (*) bị cấm.',
      policyNoteVi: policyNoteVi,
      fallbackInstructionsVi: fallbackInstructionsVi,
    );
  }

  final age = now.difference(verification.checkedAt);
  final fresh = !age.isNegative &&
      age <= kCapabilityFreshnessTtl &&
      now.isBefore(verification.validUntil);

  if (!fresh) {
    return MobileCapabilityVerdict(
      state: CapabilityState.CAPABILITY_STATE_MANUAL,
      executable: false,
      verificationFresh: false,
      reasonVi: 'Ảnh chụp xác minh đã quá hạn 10 phút; cần kiểm tra lại.',
      policyNoteVi: policyNoteVi,
      fallbackInstructionsVi: fallbackInstructionsVi,
    );
  }

  if (!verification.appApproved || !verification.accountEligible) {
    return MobileCapabilityVerdict(
      state: CapabilityState.CAPABILITY_STATE_MANUAL,
      executable: false,
      verificationFresh: true,
      reasonVi: 'Ứng dụng đối tác chưa được duyệt hoặc tài khoản chưa đủ điều kiện.',
      policyNoteVi: policyNoteVi,
      fallbackInstructionsVi: fallbackInstructionsVi,
    );
  }

  final normalizedMarket = targetMarket.trim().toUpperCase();
  if (!verification.supportedMarkets.contains('GLOBAL') &&
      !verification.supportedMarkets.contains(normalizedMarket)) {
    return MobileCapabilityVerdict(
      state: CapabilityState.CAPABILITY_STATE_MANUAL,
      executable: false,
      verificationFresh: true,
      reasonVi: 'Thị trường $normalizedMarket không thuộc phạm vi được cấp phép.',
      policyNoteVi: policyNoteVi,
      fallbackInstructionsVi: fallbackInstructionsVi,
    );
  }

  for (final reqScope in verification.requiredScopes) {
    if (!verification.grantedScopes.contains(reqScope)) {
      return MobileCapabilityVerdict(
        state: CapabilityState.CAPABILITY_STATE_READ_ONLY,
        executable: false,
        verificationFresh: true,
        reasonVi: 'Thiếu quyền OAuth bắt buộc ($reqScope); chỉ cho phép đọc.',
        policyNoteVi: policyNoteVi,
        fallbackInstructionsVi: fallbackInstructionsVi,
      );
    }
  }

  if (!verification.probePassed) {
    return MobileCapabilityVerdict(
      state: CapabilityState.CAPABILITY_STATE_DEGRADED,
      executable: false,
      verificationFresh: true,
      reasonVi: 'Kiểm tra kết nối thực tế (live probe) thất bại.',
      policyNoteVi: policyNoteVi,
      fallbackInstructionsVi: fallbackInstructionsVi,
    );
  }

  if (requiresWrite && verification.probeMethod.toUpperCase() == 'GET') {
    return MobileCapabilityVerdict(
      state: CapabilityState.CAPABILITY_STATE_READ_ONLY,
      executable: false,
      verificationFresh: true,
      reasonVi:
          'Kiểm tra GET chỉ đọc không được phép mở khóa tác vụ ghi (write action).',
      policyNoteVi: policyNoteVi,
      fallbackInstructionsVi: fallbackInstructionsVi,
    );
  }

  return MobileCapabilityVerdict(
    state: CapabilityState.CAPABILITY_STATE_NATIVE,
    executable: true,
    verificationFresh: true,
    reasonVi: 'Đã xác minh đầy đủ App Approval, Scope, Account, Market và Probe.',
    policyNoteVi: policyNoteVi,
    fallbackInstructionsVi: fallbackInstructionsVi,
  );
}

/// Computes the 0-100 composite Platform Health Score (40/25/20/15 weights).
int computeMobileCompositeHealthScore({
  required int availabilityScore,
  required int errorRateScore,
  required int latencyScore,
  required int rateLimitScore,
}) {
  final weighted = (availabilityScore.clamp(0, 100) * 0.40) +
      (errorRateScore.clamp(0, 100) * 0.25) +
      (latencyScore.clamp(0, 100) * 0.20) +
      (rateLimitScore.clamp(0, 100) * 0.15);
  return weighted.round().clamp(0, 100);
}

/// PRD §36B proactive capability coaching card representation on Mobile.
class MobileProactiveCoachingCard {
  const MobileProactiveCoachingCard({
    required this.id,
    required this.rule,
    required this.severity,
    required this.titleVi,
    required this.summaryVi,
    required this.actionCta,
  });

  final String id;
  final String rule;
  final String severity;
  final String titleVi;
  final String summaryVi;
  final String actionCta;
}

/// Evaluates 5 PRD §36B proactive coaching cards for Mobile.
/// Invariant: Coaching suggestions NEVER modify the composite technical health score
/// or grant capability execution bypasses.
List<MobileProactiveCoachingCard> evaluateMobileProactiveCoaching({
  double? shopResponseRatePct,
  double? listingQualityPct,
  int? delayedFulfillmentCount,
  double? engagementDropPct,
  int? connectorAuthExpiresInDays,
}) {
  final cards = <MobileProactiveCoachingCard>[];

  if (shopResponseRatePct != null && shopResponseRatePct < 90.0) {
    cards.add(const MobileProactiveCoachingCard(
      id: 'coach-shop-response',
      rule: 'shop_response_rate_low',
      severity: 'medium',
      titleVi: 'Tỷ lệ phản hồi tin nhắn khách hàng thấp (<90%)',
      summaryVi:
          'Tỷ lệ phản hồi khách hàng trong 15 phút thấp. Khách hàng dễ hủy đơn nếu không được hỗ trợ kịp thời.',
      actionCta: '/inbox',
    ));
  }

  if (listingQualityPct != null && listingQualityPct < 80.0) {
    cards.add(const MobileProactiveCoachingCard(
      id: 'coach-listing-quality',
      rule: 'listing_quality_low',
      severity: 'medium',
      titleVi: 'Chất lượng danh sách sản phẩm chưa đạt chuẩn (<80%)',
      summaryVi:
          'Thiếu video mô tả hoặc hình ảnh chưa chuẩn kích thước sàn. Cải thiện để tăng tỷ lệ chuyển đổi.',
      actionCta: '/store',
    ));
  }

  if (delayedFulfillmentCount != null && delayedFulfillmentCount > 0) {
    cards.add(MobileProactiveCoachingCard(
      id: 'coach-fulfillment-delay',
      rule: 'fulfillment_delayed',
      severity: 'high',
      titleVi: 'Có $delayedFulfillmentCount đơn hàng bị chậm xử lý quá 24h',
      summaryVi:
          'Đơn hàng tồn đọng quá 24h có nguy cơ bị sàn phạt hoặc người mua hủy đơn tự động.',
      actionCta: '/orders',
    ));
  }

  if (engagementDropPct != null && engagementDropPct > 20.0) {
    cards.add(MobileProactiveCoachingCard(
      id: 'coach-engagement-drop',
      rule: 'engagement_drop_detected',
      severity: 'medium',
      titleVi: 'Tương tác giảm ${engagementDropPct.round()}% so với kỳ trước',
      summaryVi:
          'Lượng xem hoặc tương tác giảm hơn 20% so với tuần trước. Hãy áp dụng mẫu nội dung thịnh hành.',
      actionCta: '/attribution',
    ));
  }

  if (connectorAuthExpiresInDays != null &&
      connectorAuthExpiresInDays <= 3 &&
      connectorAuthExpiresInDays >= 0) {
    cards.add(MobileProactiveCoachingCard(
      id: 'coach-connector-expiring',
      rule: 'connector_auth_expiring_soon',
      severity: 'high',
      titleVi:
          'Ủy quyền kênh kết nối sẽ hết hạn sau $connectorAuthExpiresInDays ngày',
      summaryVi:
          'Phiên kết nối mạng xã hội/sàn TMĐT sẽ hết hạn trong vòng 3 ngày tới. Cần gia hạn ngay để không gián đoạn xuất bản.',
      actionCta: '/settings/connections',
    ));
  }

  return cards;
}
