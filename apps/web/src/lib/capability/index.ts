import type { WorkspaceRole } from '$lib/auth';

export type CapabilityState = 'native' | 'read_only' | 'manual' | 'degraded' | 'unsupported';

export type FallbackType =
  | 'csv_export'
  | 'deep_link'
  | 'manual_upload'
  | 'clipboard_copy'
  | 'checklist';

export interface PolicyNoteSpec {
  platform: string;
  capabilityKey: string;
  summary: string;
  documentationUrl: string;
  reviewedAtIso: string;
}

export interface FallbackPathSpec {
  platform: string;
  capabilityKey: string;
  fallbackType: FallbackType;
  instructions: string;
}

export interface ActionAccessVerificationInput {
  platform: string;
  product: string;
  actionKey: string;
  appApprovalStatus: 'approved' | 'pending' | 'rejected' | 'not_applied';
  requiredScopes: readonly string[];
  grantedScopes: readonly string[];
  accountEligible: boolean;
  marketEligibility: readonly string[];
  probeEndpoint: string;
  probeMethod: 'GET' | 'POST' | 'PUT';
  probeStatus: 'passed' | 'failed' | 'untested';
  checkedAtMs: number;
  validUntilMs: number;
}

export interface CapabilityMatrixEntry {
  platform: string;
  platformDisplayName: string;
  actionKey: string;
  displayName: string;
  requiresWrite: boolean;
  defaultState: CapabilityState;
  requiredScopes: readonly string[];
  supportedMarkets: readonly string[];
  policyNote: PolicyNoteSpec;
  fallbackPath: FallbackPathSpec;
}

export interface CapabilityEvaluationResult {
  platform: string;
  actionKey: string;
  state: CapabilityState;
  executable: boolean;
  verificationFresh: boolean;
  reason: string;
  policyNote: PolicyNoteSpec;
  fallbackPath: FallbackPathSpec;
}

export const SNAPSHOT_FRESHNESS_TTL_MS = 10 * 60 * 1000; // 10 minutes per connector_specs.md §0

export const CAPABILITY_STATE_META: Record<
  CapabilityState,
  { labelVi: string; badgeClass: string; descriptionVi: string }
> = {
  native: {
    labelVi: 'Tự động (Native API)',
    badgeClass: 'bg-emerald-50 text-emerald-800 border-emerald-200',
    descriptionVi: 'Đã xác minh đầy đủ App Approval, Scope, Account, Market và Probe thực tế (<10 phút).'
  },
  read_only: {
    labelVi: 'Chỉ đọc (Read-Only)',
    badgeClass: 'bg-sky-50 text-sky-800 border-sky-200',
    descriptionVi: 'Chỉ cấp quyền đọc chỉ số/đơn hàng; thao tác ghi cần thực hiện qua phương án dự phòng.'
  },
  manual: {
    labelVi: 'Thủ công (Manual Fallback)',
    badgeClass: 'bg-amber-50 text-amber-800 border-amber-200',
    descriptionVi: 'Chưa xác minh đủ điều kiện API hoặc phiên kiểm tra đã quá hạn 10 phút; dùng Checklist/Deep-link.'
  },
  degraded: {
    labelVi: 'Suy giảm / Tạm ngắt (Degraded)',
    badgeClass: 'bg-orange-50 text-orange-800 border-orange-200',
    descriptionVi: 'Nền tảng đối tác đang gặp sự cố hoặc Công tắc ngắt khẩn cấp (Kill Switch) đang kích hoạt.'
  },
  unsupported: {
    labelVi: 'Không hỗ trợ API (Unsupported)',
    badgeClass: 'bg-stone-100 text-stone-700 border-stone-300',
    descriptionVi: 'Nền tảng không cung cấp API công khai cho tác vụ này; luôn thực hiện qua hướng dẫn thủ công.'
  }
};

export const CANONICAL_CAPABILITY_MATRIX: readonly CapabilityMatrixEntry[] = [
  {
    platform: 'tiktok',
    platformDisplayName: 'TikTok & TikTok Shop',
    actionKey: 'publish_post',
    displayName: 'Đăng video TikTok trực tiếp',
    requiresWrite: true,
    defaultState: 'manual',
    requiredScopes: ['video.publish', 'video.upload'],
    supportedMarkets: ['VN', 'SG', 'TH', 'MY', 'PH', 'ID'],
    policyNote: {
      platform: 'tiktok',
      capabilityKey: 'publish_post',
      summary:
        'TikTok Content Posting API yêu cầu App Audit được duyệt, quyền video.publish + video.upload và kiểm tra पोस्ट probe thực tế.',
      documentationUrl: 'https://developers.tiktok.com/doc/content-posting-api-get-started',
      reviewedAtIso: '2026-11-01T00:00:00Z'
    },
    fallbackPath: {
      platform: 'tiktok',
      capabilityKey: 'publish_post',
      fallbackType: 'deep_link',
      instructions:
        'Tải gói video + phụ đề đã xuất bản và mở ứng dụng TikTok để đăng thủ công kèm danh sách kiểm tra hashtag.'
    }
  },
  {
    platform: 'tiktok',
    platformDisplayName: 'TikTok & TikTok Shop',
    actionKey: 'sync_orders',
    displayName: 'Đồng bộ đơn hàng TikTok Shop',
    requiresWrite: false,
    defaultState: 'manual',
    requiredScopes: ['seller.order.info'],
    supportedMarkets: ['VN', 'SG', 'TH', 'MY', 'PH', 'ID'],
    policyNote: {
      platform: 'tiktok',
      capabilityKey: 'sync_orders',
      summary: 'TikTok Shop Partner API yêu cầu ủy quyền Seller tại thị trường VN và quyền seller.order.info.',
      documentationUrl: 'https://partner.tiktokshop.com/docv2/page/650aa8ccc16ffe02b8f10a1a',
      reviewedAtIso: '2026-11-01T00:00:00Z'
    },
    fallbackPath: {
      platform: 'tiktok',
      capabilityKey: 'sync_orders',
      fallbackType: 'csv_export',
      instructions: 'Xuất tệp CSV đơn hàng từ TikTok Shop Seller Center và nhập vào Trung tâm Sản phẩm.'
    }
  },
  {
    platform: 'facebook',
    platformDisplayName: 'Facebook Pages & Reels',
    actionKey: 'publish_post',
    displayName: 'Đăng bài & Reels lên Facebook Page',
    requiresWrite: true,
    defaultState: 'manual',
    requiredScopes: ['pages_manage_posts', 'pages_read_engagement'],
    supportedMarkets: ['VN', 'SG', 'GLOBAL'],
    policyNote: {
      platform: 'facebook',
      capabilityKey: 'publish_post',
      summary: 'Meta Graph API yêu cầu Meta App Review cho quyền pages_manage_posts và Page Access Token hợp lệ.',
      documentationUrl: 'https://developers.facebook.com/docs/pages-api/posts',
      reviewedAtIso: '2026-11-01T00:00:00Z'
    },
    fallbackPath: {
      platform: 'facebook',
      capabilityKey: 'publish_post',
      fallbackType: 'clipboard_copy',
      instructions: 'Sao chép nội dung bài viết và tải tệp media lên Meta Business Suite.'
    }
  },
  {
    platform: 'youtube',
    platformDisplayName: 'YouTube & Shorts',
    actionKey: 'publish_post',
    displayName: 'Tải lên YouTube Video / Shorts',
    requiresWrite: true,
    defaultState: 'manual',
    requiredScopes: ['https://www.googleapis.com/auth/youtube.upload'],
    supportedMarkets: ['VN', 'SG', 'GLOBAL'],
    policyNote: {
      platform: 'youtube',
      capabilityKey: 'publish_post',
      summary: 'YouTube Data API v3 tính phí 1.600 đơn vị hạn ngạch cho mỗi lượt videos.insert.',
      documentationUrl: 'https://developers.google.com/youtube/v3/docs/videos/insert',
      reviewedAtIso: '2026-11-01T00:00:00Z'
    },
    fallbackPath: {
      platform: 'youtube',
      capabilityKey: 'publish_post',
      fallbackType: 'manual_upload',
      instructions: 'Tải gói video + ảnh thu nhỏ và đăng qua YouTube Studio.'
    }
  },
  {
    platform: 'shopee',
    platformDisplayName: 'Shopee Open Platform',
    actionKey: 'publish_post',
    displayName: 'Đăng bài mạng xã hội trên Shopee',
    requiresWrite: true,
    defaultState: 'unsupported',
    requiredScopes: [],
    supportedMarkets: ['VN', 'SG', 'TH', 'MY', 'PH', 'ID'],
    policyNote: {
      platform: 'shopee',
      capabilityKey: 'publish_post',
      summary: 'Shopee Open Platform chỉ cung cấp API Thương mại (Sản phẩm/Đơn hàng), không có API đăng bài mạng xã hội.',
      documentationUrl: 'https://open.shopee.com/documents',
      reviewedAtIso: '2026-11-01T00:00:00Z'
    },
    fallbackPath: {
      platform: 'shopee',
      capabilityKey: 'publish_post',
      fallbackType: 'checklist',
      instructions: 'Sử dụng danh sách kiểm tra Shopee Video/Live trên ứng dụng Shopee Seller.'
    }
  },
  {
    platform: 'zalo_oa',
    platformDisplayName: 'Zalo Official Account',
    actionKey: 'publish_post',
    displayName: 'Gửi bài viết Zalo OA Broadcast',
    requiresWrite: true,
    defaultState: 'manual',
    requiredScopes: ['oa.message.send', 'oa.article.manage'],
    supportedMarkets: ['VN'],
    policyNote: {
      platform: 'zalo_oa',
      capabilityKey: 'publish_post',
      summary: 'Zalo OA API yêu cầu tài khoản OA đã xác thực doanh nghiệp tại Việt Nam và hạn mức gửi bài theo gói.',
      documentationUrl: 'https://developers.zalo.me/docs/official-account',
      reviewedAtIso: '2026-11-01T00:00:00Z'
    },
    fallbackPath: {
      platform: 'zalo_oa',
      capabilityKey: 'publish_post',
      fallbackType: 'clipboard_copy',
      instructions: 'Sao chép bài viết đã định dạng và gửi từ cổng quản trị oa.zalo.me.'
    }
  }
] as const;

/**
 * Validates that every scope is explicit and non-wildcard (connector_specs.md §0).
 * Wildcard scopes like "shop.*" or "*" are strictly forbidden.
 */
export function validateExplicitScopes(scopes: readonly string[]): {
  valid: boolean;
  invalidScope?: string;
} {
  for (const raw of scopes) {
    const s = raw.trim();
    if (!s || s.includes('*') || /\s/.test(s)) {
      return { valid: false, invalidScope: raw };
    }
  }
  return { valid: true };
}

/**
 * Evaluates whether a platform/action capability route can execute (P0-07 Acceptance Target 1:
 * "Unverified route cannot execute").
 *
 * Rules enforced:
 * 1. Unsupported routes never execute (`unsupported`).
 * 2. Active kill switch immediately degrades the route (`degraded`, `executable = false`).
 * 3. Missing, expired, or stale (> 10m) ActionAccessVerification cannot execute (`manual`).
 * 4. Read-only GET probe cannot unlock a write capability (`read_only`, `executable = false`).
 * 5. Every non-native state includes a PolicyNote and FallbackPath (RULE-M22-001 & RULE-M22-004).
 */
export function evaluateActionCapability(
  entry: CapabilityMatrixEntry,
  verification: ActionAccessVerificationInput | null,
  options: {
    nowMs: number;
    targetMarket: string;
    killSwitchActive?: boolean;
    killSwitchReason?: string;
    accountActive?: boolean;
  }
): CapabilityEvaluationResult {
  if (entry.defaultState === 'unsupported') {
    return {
      platform: entry.platform,
      actionKey: entry.actionKey,
      state: 'unsupported',
      executable: false,
      verificationFresh: true,
      reason: entry.policyNote.summary,
      policyNote: entry.policyNote,
      fallbackPath: entry.fallbackPath
    };
  }

  if (options.killSwitchActive) {
    return {
      platform: entry.platform,
      actionKey: entry.actionKey,
      state: 'degraded',
      executable: false,
      verificationFresh: false,
      reason:
        options.killSwitchReason?.trim() ||
        `Công tắc ngắt khẩn cấp (Kill Switch) đang bật cho ${entry.platformDisplayName}.`,
      policyNote: entry.policyNote,
      fallbackPath: entry.fallbackPath
    };
  }

  if (options.accountActive === false || !verification) {
    return {
      platform: entry.platform,
      actionKey: entry.actionKey,
      state: 'manual',
      executable: false,
      verificationFresh: false,
      reason:
        'Tác vụ chưa có hồ sơ xác minh ActionAccessVerification hợp lệ. Hệ thống chặn tự động thực thi và chuyển sang hướng dẫn thủ công.',
      policyNote: entry.policyNote,
      fallbackPath: entry.fallbackPath
    };
  }

  const scopeCheck = validateExplicitScopes(verification.grantedScopes);
  if (!scopeCheck.valid) {
    return {
      platform: entry.platform,
      actionKey: entry.actionKey,
      state: 'manual',
      executable: false,
      verificationFresh: false,
      reason: `Scope không hợp lệ hoặc chứa ký tự đại diện bị cấm (${scopeCheck.invalidScope}).`,
      policyNote: entry.policyNote,
      fallbackPath: entry.fallbackPath
    };
  }

  const ageMs = options.nowMs - verification.checkedAtMs;
  const fresh =
    ageMs >= 0 &&
    ageMs <= SNAPSHOT_FRESHNESS_TTL_MS &&
    options.nowMs < verification.validUntilMs;

  if (!fresh) {
    return {
      platform: entry.platform,
      actionKey: entry.actionKey,
      state: 'manual',
      executable: false,
      verificationFresh: false,
      reason:
        'Ảnh chụp xác minh năng lực đã quá hạn 10 phút (stale snapshot). Bắt buộc xác minh lại trước khi thực thi.',
      policyNote: entry.policyNote,
      fallbackPath: entry.fallbackPath
    };
  }

  if (verification.appApprovalStatus !== 'approved' || !verification.accountEligible) {
    return {
      platform: entry.platform,
      actionKey: entry.actionKey,
      state: 'manual',
      executable: false,
      verificationFresh: true,
      reason: 'Ứng dụng đối tác chưa được duyệt hoặc loại tài khoản chưa đủ điều kiện.',
      policyNote: entry.policyNote,
      fallbackPath: entry.fallbackPath
    };
  }

  const market = options.targetMarket.trim().toUpperCase();
  const marketAllowed =
    verification.marketEligibility.includes('GLOBAL') ||
    verification.marketEligibility.includes(market);
  if (!marketAllowed) {
    return {
      platform: entry.platform,
      actionKey: entry.actionKey,
      state: 'manual',
      executable: false,
      verificationFresh: true,
      reason: `Thị trường ${market} không nằm trong phạm vi được cấp phép của tài khoản kết nối.`,
      policyNote: entry.policyNote,
      fallbackPath: entry.fallbackPath
    };
  }

  for (const reqScope of entry.requiredScopes) {
    if (!verification.grantedScopes.includes(reqScope)) {
      return {
        platform: entry.platform,
        actionKey: entry.actionKey,
        state: 'read_only',
        executable: false,
        verificationFresh: true,
        reason: `Thiếu quyền OAuth bắt buộc (${reqScope}); chỉ cho phép chế độ đọc.`,
        policyNote: entry.policyNote,
        fallbackPath: entry.fallbackPath
      };
    }
  }

  if (verification.probeStatus !== 'passed') {
    return {
      platform: entry.platform,
      actionKey: entry.actionKey,
      state: 'degraded',
      executable: false,
      verificationFresh: true,
      reason: 'Kiểm tra kết nối thực tế (live probe) tới đối tác thất bại.',
      policyNote: entry.policyNote,
      fallbackPath: entry.fallbackPath
    };
  }

  if (entry.requiresWrite && verification.probeMethod === 'GET') {
    return {
      platform: entry.platform,
      actionKey: entry.actionKey,
      state: 'read_only',
      executable: false,
      verificationFresh: true,
      reason:
        'Kiểm tra GET chỉ đọc không được phép mở khóa tác vụ ghi (write action). Cần xác minh POST/PUT probe.',
      policyNote: entry.policyNote,
      fallbackPath: entry.fallbackPath
    };
  }

  return {
    platform: entry.platform,
    actionKey: entry.actionKey,
    state: 'native',
    executable: true,
    verificationFresh: true,
    reason: 'Đã xác minh đầy đủ App Approval, Scope, Account, Market và Probe thực tế.',
    policyNote: entry.policyNote,
    fallbackPath: entry.fallbackPath
  };
}

export interface ProactiveCoachingCard {
  id: string;
  rule: string;
  severity: 'low' | 'medium' | 'high' | 'critical';
  title: string;
  summary: string;
  actionCta: string;
}

export interface HealthMetricsInput {
  availabilityPct: number;
  errorRatePct: number;
  latencyP95Ms: number;
  rateLimitRemainingPct: number;
  // PRD §36B proactive coaching metrics
  shopResponseRateNumerator?: number;
  shopResponseRateDenom?: number;
  listingQualityNumerator?: number;
  listingQualityDenom?: number;
  delayedFulfillmentCount?: number;
  engagementDropPct?: number;
  connectorAuthExpiresInDays?: number;
}

export interface HealthScoreSummary {
  overallScore: number;
  availabilityScore: number;
  errorRateScore: number;
  latencyScore: number;
  rateLimitScore: number;
  statusBand: 'healthy' | 'degraded' | 'critical';
  proactiveCoachingAlert: boolean;
  recommendedActions: string[];
  proactiveCoachingCards: ProactiveCoachingCard[];
}

function clamp100(val: number): number {
  return Math.max(0, Math.min(100, Math.round(val)));
}

/**
 * Computes the composite 0-100 Platform Health Score per RULE-M22-003:
 *   - 40% API Availability
 *   - 25% Error Rate
 *   - 20% Latency P95
 *   - 15% Rate Limit Headroom
 * Triggers a proactive coaching alert when overallScore < 80.
 * Invariant: Proactive coaching cards (PRD §36B) are surfaced without mutating
 * the technical composite health score.
 */
export function computeCompositeHealthScore(metrics: HealthMetricsInput): HealthScoreSummary {
  const availabilityScore = clamp100(metrics.availabilityPct);
  const errorRateScore = clamp100(100 - metrics.errorRatePct * 5);
  let latencyScore = 100;
  if (metrics.latencyP95Ms > 250) {
    latencyScore = clamp100(100 - Math.floor((metrics.latencyP95Ms - 250) / 35));
  }
  const rateLimitScore = clamp100(metrics.rateLimitRemainingPct);

  const weighted =
    availabilityScore * 0.4 +
    errorRateScore * 0.25 +
    latencyScore * 0.2 +
    rateLimitScore * 0.15;
  const overallScore = clamp100(weighted);

  const statusBand: 'healthy' | 'degraded' | 'critical' =
    overallScore >= 80 ? 'healthy' : overallScore >= 50 ? 'degraded' : 'critical';

  const recommendedActions: string[] = [];
  if (overallScore < 80) {
    if (errorRateScore < 80) {
      recommendedActions.push(
        'Làm mới OAuth token hoặc kiểm tra lại quyền truy cập trên nền tảng đối tác.'
      );
    }
    if (rateLimitScore < 50) {
      recommendedActions.push(
        'Giảm tần suất đồng bộ tức thời để bảo toàn hạn mức Rate Limit còn lại.'
      );
    }
    if (availabilityScore < 80 || latencyScore < 70) {
      recommendedActions.push(
        'Tạm chuyển các bài đăng gấp sang chế độ Thủ công (Manual Fallback) cho đến khi đối tác ổn định.'
      );
    }
    if (recommendedActions.length === 0) {
      recommendedActions.push('Kiểm tra chi tiết kết nối trong Trung tâm Chẩn đoán.');
    }
  }

  // PRD §36B proactive coaching cards evaluation
  const proactiveCoachingCards: ProactiveCoachingCard[] = [];

  // Rule 1: Shop response rate < 90%
  if (
    metrics.shopResponseRateDenom !== undefined &&
    metrics.shopResponseRateDenom > 0 &&
    metrics.shopResponseRateNumerator !== undefined
  ) {
    const rate = (metrics.shopResponseRateNumerator * 100) / metrics.shopResponseRateDenom;
    if (rate < 90) {
      proactiveCoachingCards.push({
        id: 'coach-shop-response',
        rule: 'shop_response_rate_low',
        severity: 'medium',
        title: 'Tỷ lệ phản hồi tin nhắn khách hàng thấp (<90%)',
        summary:
          'Tỷ lệ phản hồi khách hàng trong 15 phút thấp. Khách hàng dễ hủy đơn nếu không được hỗ trợ kịp thời.',
        actionCta: '/inbox'
      });
    }
  }

  // Rule 2: Listing quality < 80%
  if (
    metrics.listingQualityDenom !== undefined &&
    metrics.listingQualityDenom > 0 &&
    metrics.listingQualityNumerator !== undefined
  ) {
    const quality = (metrics.listingQualityNumerator * 100) / metrics.listingQualityDenom;
    if (quality < 80) {
      proactiveCoachingCards.push({
        id: 'coach-listing-quality',
        rule: 'listing_quality_low',
        severity: 'medium',
        title: 'Chất lượng danh sách sản phẩm chưa đạt chuẩn (<80%)',
        summary:
          'Thiếu video mô tả hoặc hình ảnh chưa chuẩn kích thước sàn. Cải thiện để tăng tỷ lệ chuyển đổi.',
        actionCta: '/store'
      });
    }
  }

  // Rule 3: Delayed fulfillment count > 0
  if (metrics.delayedFulfillmentCount !== undefined && metrics.delayedFulfillmentCount > 0) {
    proactiveCoachingCards.push({
      id: 'coach-fulfillment-delay',
      rule: 'fulfillment_delayed',
      severity: 'high',
      title: `Có ${metrics.delayedFulfillmentCount} đơn hàng bị chậm xử lý quá 24h`,
      summary:
        'Đơn hàng tồn đọng quá 24h có nguy cơ bị sàn phạt hoặc người mua hủy đơn tự động.',
      actionCta: '/orders'
    });
  }

  // Rule 4: Engagement drop > 20%
  if (metrics.engagementDropPct !== undefined && metrics.engagementDropPct > 20) {
    proactiveCoachingCards.push({
      id: 'coach-engagement-drop',
      rule: 'engagement_drop_detected',
      severity: 'medium',
      title: `Tương tác giảm ${metrics.engagementDropPct}% so với kỳ trước`,
      summary:
        'Lượng xem hoặc tương tác giảm hơn 20% so với tuần trước. Hãy áp dụng mẫu nội dung thịnh hành.',
      actionCta: '/attribution'
    });
  }

  // Rule 5: Connector auth expires in <= 3 days
  if (
    metrics.connectorAuthExpiresInDays !== undefined &&
    metrics.connectorAuthExpiresInDays >= 0 &&
    metrics.connectorAuthExpiresInDays <= 3
  ) {
    proactiveCoachingCards.push({
      id: 'coach-connector-expiring',
      rule: 'connector_auth_expiring_soon',
      severity: 'high',
      title: `Ủy quyền kênh kết nối sẽ hết hạn sau ${metrics.connectorAuthExpiresInDays} ngày`,
      summary:
        'Phiên kết nối mạng xã hội/sàn TMĐT sẽ hết hạn trong vòng 3 ngày tới. Cần gia hạn ngay để không gián đoạn xuất bản.',
      actionCta: '/settings/connections'
    });
  }

  return {
    overallScore,
    availabilityScore,
    errorRateScore,
    latencyScore,
    rateLimitScore,
    statusBand,
    proactiveCoachingAlert: overallScore < 80,
    recommendedActions,
    proactiveCoachingCards
  };
}

/**
 * Evaluates RBAC and read-only impersonation constraints for connector operations.
 * Enforces P0-07 Acceptance Target 3 ("Impersonation is read-only").
 */
export function evaluateConnectorMutationAccess(
  role: WorkspaceRole,
  action: 'read' | 'connect' | 'disconnect',
  isImpersonation = false
): { allowed: boolean; permissionKey: string; reason: string } {
  const permissionKey =
    action === 'read'
      ? 'account:read'
      : action === 'connect'
        ? 'account:connect'
        : 'account:disconnect';

  if (isImpersonation && action !== 'read') {
    return {
      allowed: false,
      permissionKey,
      reason:
        'Phiên Impersonation của Admin nội bộ luôn ở chế độ Chỉ đọc (read_only). Mọi thao tác kết nối hoặc ngắt kết nối tài khoản đều bị khóa.'
    };
  }

  if (action === 'read') {
    if (role === 'external') {
      return {
        allowed: false,
        permissionKey,
        reason: 'Cộng tác viên bên ngoài (external) không có quyền xem danh sách tài khoản kết nối.'
      };
    }
    return {
      allowed: true,
      permissionKey,
      reason: `Vai trò ${role} được phép xem trạng thái kết nối.`
    };
  }

  if (action === 'connect') {
    if (role === 'owner' || role === 'admin' || role === 'manager') {
      return {
        allowed: true,
        permissionKey,
        reason: `Vai trò ${role} có quyền ${permissionKey}.`
      };
    }
    return {
      allowed: false,
      permissionKey,
      reason: `Vai trò ${role} không có quyền ${permissionKey} (yêu cầu Owner, Admin hoặc Manager).`
    };
  }

  // disconnect requires owner or admin
  if (role === 'owner' || role === 'admin') {
    return {
      allowed: true,
      permissionKey,
      reason: `Vai trò ${role} có quyền ${permissionKey}.`
    };
  }
  return {
    allowed: false,
    permissionKey,
    reason: `Vai trò ${role} không có quyền ${permissionKey} (chỉ Owner và Admin được phép ngắt kết nối).`
  };
}
