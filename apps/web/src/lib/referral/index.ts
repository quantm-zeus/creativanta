/**
 * Referral & Growth Engine Client Library
 * Domain: Platform / Growth / Referral
 * Upstream: docs/02_features/platform/referral_growth.md
 * Screen Specs: Web W126 (screen_web_settings_referral.md), Mobile M062 (screen_mobile_referral.md)
 */

export type ReferralStatus =
  | 'pending'
  | 'qualified'
  | 'rewarded'
  | 'revoked'
  | 'expired'
  | 'fraud_flagged'
  | 'forfeited';

export type ReferralTier = 'bronze' | 'silver' | 'gold' | 'platinum';

export interface ReferralRecord {
  referralId: string;
  workspaceId: string;
  refereeWorkspaceId?: string;
  referrerUserId: string;
  refereeUserId: string;
  refereeName: string;
  refereeEmailMasked: string;
  referralCode: string;
  status: ReferralStatus;
  referrerCreditsAwarded: string;
  refereeCreditsAwarded: string;
  planTier: string;
  paymentStatus: string;
  fraudCheckPassed: boolean | null;
  fraudReason?: string;
  recurringCommissionRate: string;
  recurringCommissionEarned: string;
  qualifiedAt?: string;
  rewardedAt?: string;
  createdAt: string;
  updatedAt: string;
}

export interface TierInfo {
  tier: ReferralTier;
  title: string;
  minReferrals: number;
  maxReferrals: number | null;
  multiplier: number;
  recurringCommissionPercent: number;
  description: string;
}

export const CANONICAL_REFERRAL_TIERS: Record<ReferralTier, TierInfo> = {
  bronze: {
    tier: 'bronze',
    title: '🥉 Đồng (Bronze)',
    minReferrals: 1,
    maxReferrals: 5,
    multiplier: 1.0,
    recurringCommissionPercent: 0,
    description: '1.0x thưởng cơ bản (50–300 credits)'
  },
  silver: {
    tier: 'silver',
    title: '🥈 Bạc (Silver)',
    minReferrals: 6,
    maxReferrals: 20,
    multiplier: 1.5,
    recurringCommissionPercent: 0,
    description: '1.5x thưởng credits + huy hiệu danh dự'
  },
  gold: {
    tier: 'gold',
    title: '🥇 Vàng (Gold)',
    minReferrals: 21,
    maxReferrals: 50,
    multiplier: 2.0,
    recurringCommissionPercent: 10,
    description: '2.0x thưởng credits + 10% hoa hồng định kỳ hàng tháng'
  },
  platinum: {
    tier: 'platinum',
    title: '💎 Bạch Kim (Platinum)',
    minReferrals: 51,
    maxReferrals: null,
    multiplier: 2.5,
    recurringCommissionPercent: 15,
    description: '2.5x thưởng credits + 15% hoa hồng trọn đời từ các gói trả phí'
  }
};

export interface CalculatedTierProgress {
  currentTier: ReferralTier;
  nextTier: ReferralTier | null;
  qualifiedCount: number;
  referralsToNextTier: number;
  progressPercent: number;
  multiplierString: string;
  recurringCommissionPercent: number;
}

export function calculateReferralTier(qualifiedCount: number): CalculatedTierProgress {
  if (qualifiedCount >= 51) {
    return {
      currentTier: 'platinum',
      nextTier: null,
      qualifiedCount,
      referralsToNextTier: 0,
      progressPercent: 100,
      multiplierString: '2.5x',
      recurringCommissionPercent: 15
    };
  }
  if (qualifiedCount >= 21) {
    const toNext = 51 - qualifiedCount;
    const progress = Math.min(100, Math.round(((qualifiedCount - 20) / (51 - 20)) * 100));
    return {
      currentTier: 'gold',
      nextTier: 'platinum',
      qualifiedCount,
      referralsToNextTier: toNext,
      progressPercent: progress,
      multiplierString: '2.0x',
      recurringCommissionPercent: 10
    };
  }
  if (qualifiedCount >= 6) {
    const toNext = 21 - qualifiedCount;
    const progress = Math.min(100, Math.round(((qualifiedCount - 5) / (21 - 5)) * 100));
    return {
      currentTier: 'silver',
      nextTier: 'gold',
      qualifiedCount,
      referralsToNextTier: toNext,
      progressPercent: progress,
      multiplierString: '1.5x',
      recurringCommissionPercent: 0
    };
  }
  // Bronze
  const toNext = Math.max(0, 6 - qualifiedCount);
  const progress = Math.min(100, Math.round((qualifiedCount / 6) * 100));
  return {
    currentTier: 'bronze',
    nextTier: 'silver',
    qualifiedCount,
    referralsToNextTier: toNext,
    progressPercent: progress,
    multiplierString: '1.0x',
    recurringCommissionPercent: 0
  };
}

export interface FunnelSummary {
  clicks: number;
  signups: number;
  paid: number;
  clickToSignupPercent: string;
  signupToPaidPercent: string;
  overallConversionPercent: string;
  creditsEarned: string;
  creditsPending: string;
}

export function formatFunnelMetrics(
  clicks: number,
  signups: number,
  paid: number,
  creditsEarned: string = '0.000000',
  creditsPending: string = '0.000000'
): FunnelSummary {
  const c2s = clicks > 0 ? ((signups / clicks) * 100).toFixed(1) + '%' : '0.0%';
  const s2p = signups > 0 ? ((paid / signups) * 100).toFixed(1) + '%' : '0.0%';
  const overall = clicks > 0 ? ((paid / clicks) * 100).toFixed(1) + '%' : '0.0%';

  return {
    clicks,
    signups,
    paid,
    clickToSignupPercent: c2s,
    signupToPaidPercent: s2p,
    overallConversionPercent: overall,
    creditsEarned,
    creditsPending
  };
}

/**
 * Acceptance Target 1: No immediate qualified reward on pending payment.
 */
export function evaluatePaymentQualificationGate(
  paymentStatus: string,
  currentStatus: ReferralStatus
): { canReward: boolean; heldReason?: string; nextStatus: ReferralStatus } {
  const norm = paymentStatus.toLowerCase().trim();
  if (norm === 'pending') {
    return {
      canReward: false,
      heldReason: 'Thanh toán đang chờ xử lý — phần thưởng được giữ lại cho tới khi hoàn tất',
      nextStatus: 'pending'
    };
  }
  if (norm === 'unpaid') {
    return {
      canReward: false,
      heldReason: 'Chưa thanh toán gói dịch vụ',
      nextStatus: 'pending'
    };
  }
  if (currentStatus === 'fraud_flagged') {
    return {
      canReward: false,
      heldReason: 'Hồ sơ bị tạm giữ để xem xét gian lận',
      nextStatus: 'fraud_flagged'
    };
  }
  return {
    canReward: true,
    nextStatus: 'rewarded'
  };
}

/**
 * Acceptance Target 2: Self-referral held for review.
 */
export function evaluateSelfReferralGate(params: {
  referrerWorkspaceId: string;
  refereeWorkspaceId: string;
  referrerUserId?: string;
  refereeUserId?: string;
  ipMatch?: boolean;
  deviceMatch?: boolean;
  cardMatch?: boolean;
}): { isSelfReferral: boolean; reason?: string } {
  if (
    params.referrerUserId &&
    params.refereeUserId &&
    params.referrerUserId === params.refereeUserId
  ) {
    return { isSelfReferral: true, reason: 'Tự giới thiệu bản thân (trùng ID người dùng)' };
  }
  if (
    params.referrerWorkspaceId &&
    params.refereeWorkspaceId &&
    params.referrerWorkspaceId === params.refereeWorkspaceId
  ) {
    return { isSelfReferral: true, reason: 'Tự giới thiệu trong cùng Không gian làm việc' };
  }
  if (params.ipMatch) {
    return { isSelfReferral: true, reason: 'Trùng địa chỉ IP với người giới thiệu' };
  }
  if (params.deviceMatch) {
    return { isSelfReferral: true, reason: 'Trùng thiết bị/trình duyệt với người giới thiệu' };
  }
  if (params.cardMatch) {
    return { isSelfReferral: true, reason: 'Trùng phương thức thanh toán thẻ' };
  }
  return { isSelfReferral: false };
}

/**
 * Acceptance Target 3: Replay / refund reverses once.
 */
export function evaluateRefundReversalGate(currentStatus: ReferralStatus): {
  canReverse: boolean;
  isDuplicateReplay: boolean;
  message: string;
  nextStatus: ReferralStatus;
} {
  if (currentStatus === 'revoked') {
    return {
      canReverse: false,
      isDuplicateReplay: true,
      message: 'Giao dịch hoàn tiền đã được hoàn tất trước đó (Idempotent Replay)',
      nextStatus: 'revoked'
    };
  }
  if (currentStatus === 'rewarded' || currentStatus === 'qualified') {
    return {
      canReverse: true,
      isDuplicateReplay: false,
      message: 'Thu hồi phần thưởng giới thiệu thành công do hoàn tiền',
      nextStatus: 'revoked'
    };
  }
  return {
    canReverse: true,
    isDuplicateReplay: false,
    message: 'Hủy bỏ lượt giới thiệu chưa kích hoạt',
    nextStatus: 'revoked'
  };
}

export interface ShareChannels {
  shareUrl: string;
  copyText: string;
  zaloUrl: string;
  facebookUrl: string;
  twitterUrl: string;
  telegramUrl: string;
}

export function buildShareLinks(referralCode: string, origin: string = 'https://creativanta.vn'): ShareChannels {
  const shareUrl = `${origin}/r/${referralCode}`;
  const encodedUrl = encodeURIComponent(shareUrl);
  const text = encodeURIComponent(
    'Tham gia Creativanta — Nền tảng Proofed Trend-to-Profit với 50 credits miễn phí!'
  );

  return {
    shareUrl,
    copyText: shareUrl,
    zaloUrl: `https://zalo.me/share?url=${encodedUrl}`,
    facebookUrl: `https://www.facebook.com/sharer/sharer.php?u=${encodedUrl}`,
    twitterUrl: `https://twitter.com/intent/tweet?url=${encodedUrl}&text=${text}`,
    telegramUrl: `https://t.me/share/url?url=${encodedUrl}&text=${text}`
  };
}

export interface GrowthTriggerPrompt {
  id: string;
  title: string;
  description: string;
  rewardCredits: string;
  actionText: string;
  type: string;
}

export const CANONICAL_GROWTH_PROMPTS: GrowthTriggerPrompt[] = [
  {
    id: 'first_publish',
    title: 'Xuất bản nội dung thành công!',
    description: 'Chia sẻ Creativanta tới bạn bè và nhận ngay 20 credits.',
    rewardCredits: '20',
    actionText: 'Chia sẻ ngay',
    type: 'first_publish'
  },
  {
    id: 'first_profit_proof',
    title: 'Minh chứng lợi nhuận đầu tiên!',
    description: 'Chia sẻ bài học kiếm tiền thực tế nhận ngay 50 credits.',
    rewardCredits: '50',
    actionText: 'Chia sẻ Case Study',
    type: 'first_profit_proof'
  },
  {
    id: 'followers_1000',
    title: 'Đạt mốc 1.000 Follower!',
    description: 'Mở khóa huy hiệu tăng trưởng và 30 credits.',
    rewardCredits: '30',
    actionText: 'Khoe thành tích',
    type: 'followers_1000'
  },
  {
    id: 'team_invite',
    title: 'Mời thành viên nhóm',
    description: 'Thêm đồng đội vào workspace nhận 10 credits/người.',
    rewardCredits: '10',
    actionText: 'Gửi lời mời',
    type: 'team_invite'
  }
];
