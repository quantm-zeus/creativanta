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
