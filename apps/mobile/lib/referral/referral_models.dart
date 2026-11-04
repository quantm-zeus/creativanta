// Referral Models and Domain Gates for Creativanta Mobile (M062)
// Upstream: docs/02_features/platform/referral_growth.md
// Screen: docs/03_screens/mobile/screen_mobile_referral.md

enum MobileReferralTier { bronze, silver, gold, platinum }

enum MobileReferralStatus {
  pending,
  qualified,
  rewarded,
  revoked,
  expired,
  fraudFlagged,
  forfeited,
}

class MobileTierProgress {
  final MobileReferralTier currentTier;
  final MobileReferralTier? nextTier;
  final int qualifiedCount;
  final int referralsToNextTier;
  final double progressPercent;
  final String rewardMultiplier;
  final double recurringCommissionPercent;

  const MobileTierProgress({
    required this.currentTier,
    this.nextTier,
    required this.qualifiedCount,
    required this.referralsToNextTier,
    required this.progressPercent,
    required this.rewardMultiplier,
    required this.recurringCommissionPercent,
  });

  String get tierName {
    switch (currentTier) {
      case MobileReferralTier.bronze:
        return '🥉 Bronze';
      case MobileReferralTier.silver:
        return '🥈 Silver';
      case MobileReferralTier.gold:
        return '🥇 Gold';
      case MobileReferralTier.platinum:
        return '🏆 Platinum';
    }
  }

  String get nextTierName {
    if (nextTier == null) return 'Tối đa';
    switch (nextTier!) {
      case MobileReferralTier.bronze:
        return 'Bronze';
      case MobileReferralTier.silver:
        return 'Silver';
      case MobileReferralTier.gold:
        return 'Gold';
      case MobileReferralTier.platinum:
        return 'Platinum';
    }
  }
}

MobileTierProgress calculateMobileTier(int qualifiedCount) {
  if (qualifiedCount >= 51) {
    return MobileTierProgress(
      currentTier: MobileReferralTier.platinum,
      nextTier: null,
      qualifiedCount: qualifiedCount,
      referralsToNextTier: 0,
      progressPercent: 1.0,
      rewardMultiplier: '2.5x',
      recurringCommissionPercent: 15.0,
    );
  }
  if (qualifiedCount >= 21) {
    final toNext = 51 - qualifiedCount;
    final progress = (qualifiedCount - 20) / (51 - 20);
    return MobileTierProgress(
      currentTier: MobileReferralTier.gold,
      nextTier: MobileReferralTier.platinum,
      qualifiedCount: qualifiedCount,
      referralsToNextTier: toNext,
      progressPercent: progress.clamp(0.0, 1.0),
      rewardMultiplier: '2.0x',
      recurringCommissionPercent: 10.0,
    );
  }
  if (qualifiedCount >= 6) {
    final toNext = 21 - qualifiedCount;
    final progress = (qualifiedCount - 5) / (21 - 5);
    return MobileTierProgress(
      currentTier: MobileReferralTier.silver,
      nextTier: MobileReferralTier.gold,
      qualifiedCount: qualifiedCount,
      referralsToNextTier: toNext,
      progressPercent: progress.clamp(0.0, 1.0),
      rewardMultiplier: '1.5x',
      recurringCommissionPercent: 0.0,
    );
  }
  final toNext = (6 - qualifiedCount).clamp(0, 6);
  final progress = (qualifiedCount / 6.0).clamp(0.0, 1.0);
  return MobileTierProgress(
    currentTier: MobileReferralTier.bronze,
    nextTier: MobileReferralTier.silver,
    qualifiedCount: qualifiedCount,
    referralsToNextTier: toNext,
    progressPercent: progress,
    rewardMultiplier: '1.0x',
    recurringCommissionPercent: 0.0,
  );
}

/// Acceptance Target 1: No immediate qualified reward on pending payment.
class PaymentQualificationGateResult {
  final bool canReward;
  final String? heldReason;
  final MobileReferralStatus nextStatus;

  const PaymentQualificationGateResult({
    required this.canReward,
    this.heldReason,
    required this.nextStatus,
  });
}

PaymentQualificationGateResult evaluatePaymentQualification({
  required String paymentStatus,
  required MobileReferralStatus currentStatus,
}) {
  final norm = paymentStatus.toLowerCase().trim();
  if (norm == 'pending') {
    return const PaymentQualificationGateResult(
      canReward: false,
      heldReason: 'Thanh toán đang chờ xử lý — phần thưởng được tạm giữ',
      nextStatus: MobileReferralStatus.pending,
    );
  }
  if (norm == 'unpaid') {
    return const PaymentQualificationGateResult(
      canReward: false,
      heldReason: 'Chưa thanh toán gói dịch vụ',
      nextStatus: MobileReferralStatus.pending,
    );
  }
  if (currentStatus == MobileReferralStatus.fraudFlagged) {
    return const PaymentQualificationGateResult(
      canReward: false,
      heldReason: 'Bị tạm giữ do có dấu hiệu gian lận',
      nextStatus: MobileReferralStatus.fraudFlagged,
    );
  }
  return const PaymentQualificationGateResult(
    canReward: true,
    nextStatus: MobileReferralStatus.rewarded,
  );
}

/// Acceptance Target 2: Self-referral held for review.
class SelfReferralGateResult {
  final bool isSelfReferral;
  final String? reason;

  const SelfReferralGateResult({
    required this.isSelfReferral,
    this.reason,
  });
}

SelfReferralGateResult evaluateSelfReferral({
  required String referrerWorkspaceId,
  required String refereeWorkspaceId,
  String? referrerUserId,
  String? refereeUserId,
  bool ipMatch = false,
  bool deviceMatch = false,
  bool cardMatch = false,
}) {
  if (referrerUserId != null &&
      refereeUserId != null &&
      referrerUserId == refereeUserId) {
    return const SelfReferralGateResult(
      isSelfReferral: true,
      reason: 'Tự giới thiệu bản thân (trùng ID người dùng)',
    );
  }
  if (referrerWorkspaceId == refereeWorkspaceId) {
    return const SelfReferralGateResult(
      isSelfReferral: true,
      reason: 'Tự giới thiệu trong cùng Không gian làm việc',
    );
  }
  if (ipMatch) {
    return const SelfReferralGateResult(
      isSelfReferral: true,
      reason: 'Trùng địa chỉ IP với người giới thiệu',
    );
  }
  if (deviceMatch) {
    return const SelfReferralGateResult(
      isSelfReferral: true,
      reason: 'Trùng thiết bị/máy với người giới thiệu',
    );
  }
  if (cardMatch) {
    return const SelfReferralGateResult(
      isSelfReferral: true,
      reason: 'Trùng phương thức thanh toán thẻ',
    );
  }
  return const SelfReferralGateResult(isSelfReferral: false);
}

/// Acceptance Target 3: Replay / refund reverses once.
class RefundReversalGateResult {
  final bool canReverse;
  final bool isDuplicateReplay;
  final String message;
  final MobileReferralStatus nextStatus;

  const RefundReversalGateResult({
    required this.canReverse,
    required this.isDuplicateReplay,
    required this.message,
    required this.nextStatus,
  });
}

RefundReversalGateResult evaluateRefundReversal(MobileReferralStatus currentStatus) {
  if (currentStatus == MobileReferralStatus.revoked) {
    return const RefundReversalGateResult(
      canReverse: false,
      isDuplicateReplay: true,
      message: 'Giao dịch hoàn tiền đã được xử lý trước đó (Idempotent Replay)',
      nextStatus: MobileReferralStatus.revoked,
    );
  }
  if (currentStatus == MobileReferralStatus.rewarded ||
      currentStatus == MobileReferralStatus.qualified) {
    return const RefundReversalGateResult(
      canReverse: true,
      isDuplicateReplay: false,
      message: 'Thu hồi phần thưởng giới thiệu do khách hàng yêu cầu hoàn tiền',
      nextStatus: MobileReferralStatus.revoked,
    );
  }
  return const RefundReversalGateResult(
    canReverse: true,
    isDuplicateReplay: false,
    message: 'Hủy bỏ lượt giới thiệu chưa kích hoạt',
    nextStatus: MobileReferralStatus.revoked,
  );
}

class MobileReferralFunnel {
  final int clicks;
  final int signups;
  final int paid;
  final String creditsEarned;
  final String creditsPending;

  const MobileReferralFunnel({
    required this.clicks,
    required this.signups,
    required this.paid,
    required this.creditsEarned,
    required this.creditsPending,
  });

  String get clickToSignupPercent =>
      clicks > 0 ? '${((signups / clicks) * 100).toStringAsFixed(1)}%' : '0.0%';

  String get signupToPaidPercent =>
      signups > 0 ? '${((paid / signups) * 100).toStringAsFixed(1)}%' : '0.0%';
}
