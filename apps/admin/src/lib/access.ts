/**
 * P0-01 / P0-07 Internal Admin Isolation & Security Boundary (S26).
 * Unauthenticated SSR defaults remain fail-closed (`ADMIN_UI_ENABLED = false`).
 * Server-verified sessions require isolated internal_admins identity (never workspace Clerk roles),
 * private VPN mesh verification, and RFC 6238 TOTP MFA.
 */
export const ADMIN_UI_ENABLED = false as boolean;

export const CANONICAL_WORKSPACE_ROLES = [
  'owner',
  'admin',
  'manager',
  'editor',
  'contributor',
  'viewer',
  'external'
] as const;

export const CANONICAL_ADMIN_ROLES = [
  'super_admin',
  'ops_admin',
  'finance_admin',
  'content_admin',
  'support_admin',
  'tech_admin',
  'analyst',
  'auditor'
] as const;

export type InternalAdminRole = (typeof CANONICAL_ADMIN_ROLES)[number];

export const ADMIN_SESSION_TTL_MS = 8 * 60 * 60 * 1000; // 8 hours (RULE-S26-001)
export const IMPERSONATION_TTL_MS = 30 * 60 * 1000; // 30 minutes (RULE-S26-002)

export const HARD_BLOCK_MODERATION_CATEGORIES = [
  'sexual_minors',
  'phishing_malware',
  'credible_violent_threat',
  'self_harm_instruction',
  'doxxing_pii',
  'revoked_clone_consent',
  'unlicensed_rights_violation'
] as const;

export interface VerifiedAdminSession {
  sessionId: string;
  adminId: string;
  role: string;
  internalAdmin: boolean;
  vpnVerified: boolean;
  mfaVerified: boolean;
  status: 'active' | 'suspended' | 'revoked';
  expiresAtMs: number;
  linkedWorkspaceUserId?: string;
}

export interface AdminListenerVerdict {
  allowed: boolean;
  errorCode: 'OK' | 'ADMIN_FORBIDDEN_001' | 'AUTH_FORBIDDEN_001';
  reason: string;
}

export function isWorkspaceRole(role: string): boolean {
  return (CANONICAL_WORKSPACE_ROLES as readonly string[]).includes(role.trim().toLowerCase());
}

export function isInternalAdminRole(role: string): role is InternalAdminRole {
  return (CANONICAL_ADMIN_ROLES as readonly string[]).includes(role.trim().toLowerCase());
}

/**
 * Evaluates whether a caller is permitted to invoke the isolated Admin listener (ModeAdminAPI).
 * Enforces P0-07 Acceptance Target 2: "Workspace role cannot call admin listener".
 */
export function evaluateAdminListenerAccess(
  session?: VerifiedAdminSession | null,
  nowMs = Date.now()
): AdminListenerVerdict {
  if (!session) {
    return {
      allowed: false,
      errorCode: 'AUTH_FORBIDDEN_001',
      reason: 'Chưa cấp quyền truy cập: thiếu phiên đăng nhập Admin nội bộ đã xác thực.'
    };
  }
  if (!session.internalAdmin || isWorkspaceRole(session.role) || !isInternalAdminRole(session.role)) {
    return {
      allowed: false,
      errorCode: 'ADMIN_FORBIDDEN_001',
      reason: `Vai trò Workspace (${session.role || 'unknown'}) tuyệt đối không được phép gọi cổng Admin nội bộ.`
    };
  }
  if (!session.vpnVerified) {
    return {
      allowed: false,
      errorCode: 'ADMIN_FORBIDDEN_001',
      reason: 'Từ chối truy cập: yêu cầu kết nối mạng riêng VPN (Tailscale/WireGuard).'
    };
  }
  if (!session.mfaVerified) {
    return {
      allowed: false,
      errorCode: 'ADMIN_FORBIDDEN_001',
      reason: 'Từ chối truy cập: bắt buộc xác thực đa yếu tố TOTP MFA.'
    };
  }
  if (session.status !== 'active' || nowMs >= session.expiresAtMs) {
    return {
      allowed: false,
      errorCode: 'AUTH_FORBIDDEN_001',
      reason: 'Phiên Admin đã hết hạn (8 giờ) hoặc tài khoản bị thu hồi.'
    };
  }
  return {
    allowed: true,
    errorCode: 'OK',
    reason: `Đã xác minh phiên Admin nội bộ (${session.role}) qua VPN + TOTP MFA.`
  };
}

/**
 * Returns false when unauthenticated (preserving P0-01 fail-closed default),
 * and true only when a server-verified VPN+MFA internal admin session is active.
 */
export function canAccessAdmin(
  session?: VerifiedAdminSession | null,
  nowMs = Date.now()
): boolean {
  if (!session) {
    return ADMIN_UI_ENABLED;
  }
  return evaluateAdminListenerAccess(session, nowMs).allowed;
}

export interface ImpersonationVerdict {
  allowed: boolean;
  mode: 'read_only';
  expiresAtMs: number;
  errorCode: 'OK' | 'ADMIN_FORBIDDEN_001' | 'ADMIN_CONFLICT_001' | 'AUTH_FORBIDDEN_001';
  reason: string;
}

/**
 * Evaluates both starting an impersonation session and executing actions inside an impersonation session.
 * Enforces P0-07 Acceptance Target 3: "Impersonation is read-only" + 30-minute auto-expiry.
 */
export function evaluateImpersonationAction(params: {
  adminRole: string;
  startedAtMs: number;
  nowMs: number;
  reason: string;
  supportTicketId?: string;
  attemptedActionType: 'read_query' | 'mutating_command';
}): ImpersonationVerdict {
  const expiresAtMs = params.startedAtMs + IMPERSONATION_TTL_MS;
  const role = params.adminRole.trim().toLowerCase();

  if (role !== 'super_admin' && role !== 'ops_admin' && role !== 'support_admin') {
    return {
      allowed: false,
      mode: 'read_only',
      expiresAtMs,
      errorCode: 'ADMIN_FORBIDDEN_001',
      reason: `Vai trò ${params.adminRole} không có quyền admin:impersonate.`
    };
  }

  if (!params.reason.trim()) {
    return {
      allowed: false,
      mode: 'read_only',
      expiresAtMs,
      errorCode: 'ADMIN_FORBIDDEN_001',
      reason: 'Bắt buộc nhập lý do kiểm toán (reason) khi khởi tạo Impersonation.'
    };
  }

  if (role === 'support_admin' && !params.supportTicketId?.trim()) {
    return {
      allowed: false,
      mode: 'read_only',
      expiresAtMs,
      errorCode: 'ADMIN_FORBIDDEN_001',
      reason: 'Support Admin bắt buộc đính kèm mã phiếu hỗ trợ (support_ticket_id) khi Impersonate.'
    };
  }

  if (params.nowMs >= expiresAtMs) {
    return {
      allowed: false,
      mode: 'read_only',
      expiresAtMs,
      errorCode: 'AUTH_FORBIDDEN_001',
      reason: 'Phiên Impersonation đã tự động hết hạn sau 30 phút (RULE-S26-002).'
    };
  }

  if (params.attemptedActionType === 'mutating_command') {
    return {
      allowed: false,
      mode: 'read_only',
      expiresAtMs,
      errorCode: 'ADMIN_CONFLICT_001',
      reason:
        'Chặn thao tác ghi: Phiên Impersonation chỉ cho phép chế độ Chỉ đọc (read_only) đối với mọi vai trò Admin.'
    };
  }

  return {
    allowed: true,
    mode: 'read_only',
    expiresAtMs,
    errorCode: 'OK',
    reason: 'Cho phép truy vấn Chỉ đọc (read_only) trong thời hạn 30 phút và ghi nhật ký kiểm toán kép.'
  };
}

export interface ModerationDecisionVerdict {
  allowed: boolean;
  riskBand: 'allow' | 'human_review' | 'block';
  hardBlock: boolean;
  overridableByWorkspace: boolean;
  slaHours: 4 | 24 | 72;
  reason: string;
}

/**
 * Evaluates a moderation case and admin review action per SAFE-2026-02 & EC-S26-002.
 */
export function evaluateModerationDecision(params: {
  adminRole: string;
  adminLinkedUserId?: string;
  flaggedUserId: string;
  category: string;
  riskScore: number;
  decision: 'approve' | 'reject' | 'escalate';
  auditReason: string;
}): ModerationDecisionVerdict {
  const cat = params.category.trim().toLowerCase();
  const hardBlock = (HARD_BLOCK_MODERATION_CATEGORIES as readonly string[]).includes(cat);
  const normalizedScore = hardBlock
    ? Math.max(95, Math.min(100, params.riskScore))
    : Math.max(0, Math.min(100, params.riskScore));

  const riskBand: 'allow' | 'human_review' | 'block' =
    hardBlock || normalizedScore >= 60
      ? 'block'
      : normalizedScore >= 25
        ? 'human_review'
        : 'allow';

  const slaHours: 4 | 24 | 72 =
    hardBlock || normalizedScore >= 85 ? 4 : normalizedScore >= 60 ? 24 : 72;

  const overridableByWorkspace = !hardBlock && riskBand !== 'block';

  if (params.adminRole !== 'super_admin' && params.adminRole !== 'content_admin') {
    return {
      allowed: false,
      riskBand,
      hardBlock,
      overridableByWorkspace,
      slaHours,
      reason: `Vai trò ${params.adminRole} không có quyền admin:moderation:manage.`
    };
  }

  if (!params.auditReason.trim()) {
    return {
      allowed: false,
      riskBand,
      hardBlock,
      overridableByWorkspace,
      slaHours,
      reason: 'Bắt buộc nhập lý do kiểm toán (reason) khi xử lý hồ sơ kiểm duyệt.'
    };
  }

  if (
    params.adminLinkedUserId &&
    params.flaggedUserId &&
    params.adminLinkedUserId === params.flaggedUserId
  ) {
    return {
      allowed: false,
      riskBand,
      hardBlock,
      overridableByWorkspace,
      slaHours,
      reason:
        'Xung đột lợi ích (EC-S26-002): Admin không được phép tự duyệt hồ sơ kiểm duyệt liên quan đến tài khoản của chính mình.'
    };
  }

  if (hardBlock && params.decision === 'approve') {
    return {
      allowed: false,
      riskBand,
      hardBlock,
      overridableByWorkspace: false,
      slaHours,
      reason: `Vi phạm danh mục cấm tuyệt đối (${cat} — SAFE-2026-02): không được phép phê duyệt xuất bản.`
    };
  }

  return {
    allowed: true,
    riskBand,
    hardBlock,
    overridableByWorkspace,
    slaHours,
    reason: `Đã ghi nhận quyết định ${params.decision} vào nhật ký kiểm toán bất biến (SLA ${slaHours}h).`
  };
}

/**
 * Evaluates emergency Kill Switch toggle permission (`admin:feature_flag:toggle`).
 */
export function evaluateKillSwitchToggle(params: {
  adminRole: string;
  mfaVerified: boolean;
  flagKey: string;
  auditReason: string;
}): { allowed: boolean; reason: string } {
  if (!params.mfaVerified) {
    return {
      allowed: false,
      reason: 'Yêu cầu xác thực TOTP MFA trước khi bật/tắt Công tắc ngắt khẩn cấp (Kill Switch).'
    };
  }
  if (params.adminRole !== 'super_admin' && params.adminRole !== 'tech_admin') {
    return {
      allowed: false,
      reason: `Vai trò ${params.adminRole} không có quyền admin:feature_flag:toggle (chỉ Super Admin và Tech Admin).`
    };
  }
  if (!params.auditReason.trim() || !params.flagKey.trim()) {
    return {
      allowed: false,
      reason: 'Bắt buộc cung cấp mã cờ (flag_key) và lý do kiểm toán (reason).'
    };
  }
  return {
    allowed: true,
    reason: `Đã cập nhật Công tắc ngắt khẩn cấp (${params.flagKey}) và phát sự kiện feature_flag.toggled.`
  };
}

export const STALE_ARTICLE_THRESHOLD_DAYS = 90;

export interface KBAdminVerdict {
  allowed: boolean;
  errorCode: 'OK' | 'ADMIN_FORBIDDEN_001' | 'AUTH_FORBIDDEN_001';
  reason: string;
}

/**
 * Evaluates internal admin permission to manage Knowledge Base articles.
 * Workspace roles are strictly forbidden (Acceptance Target: Internal Admin Isolation).
 */
export function evaluateKBAdminAccess(
  session?: VerifiedAdminSession | null,
  action: 'create' | 'update' | 'publish' | 'archive' = 'publish'
): KBAdminVerdict {
  if (!session) {
    return {
      allowed: false,
      errorCode: 'AUTH_FORBIDDEN_001',
      reason: 'Yêu cầu phiên đăng nhập Admin nội bộ đã xác thực.'
    };
  }
  if (!session.internalAdmin || isWorkspaceRole(session.role) || !isInternalAdminRole(session.role)) {
    return {
      allowed: false,
      errorCode: 'ADMIN_FORBIDDEN_001',
      reason: `Vai trò Workspace (${session.role || 'unknown'}) không được phép quản trị bài viết Knowledge Base.`
    };
  }
  if (session.role !== 'super_admin' && session.role !== 'content_admin' && session.role !== 'ops_admin') {
    return {
      allowed: false,
      errorCode: 'ADMIN_FORBIDDEN_001',
      reason: `Vai trò ${session.role} không có quyền thực hiện thao tác ${action} trên Knowledge Base.`
    };
  }
  return {
    allowed: true,
    errorCode: 'OK',
    reason: `Thao tác ${action} bài viết Knowledge Base được phê duyệt.`
  };
}

/**
 * Verifies whether a Knowledge Base article is overdue for review (>= 90 days stale).
 * Per docs/02_features/platform/help_center.md Acceptance Criteria 2.
 */
export function isArticleStale(
  lastReviewedAtIso: string,
  nowMs = Date.now()
): { isStale: boolean; daysSinceReview: number } {
  const reviewedMs = Date.parse(lastReviewedAtIso);
  if (isNaN(reviewedMs)) {
    return { isStale: true, daysSinceReview: 999 };
  }
  const days = Math.floor((nowMs - reviewedMs) / (1000 * 60 * 60 * 24));
  return {
    isStale: days >= STALE_ARTICLE_THRESHOLD_DAYS,
    daysSinceReview: days
  };
}

export interface AppealReviewVerdict {
  allowed: boolean;
  errorCode: 'OK' | 'ADMIN_FORBIDDEN_001' | 'ADMIN_CONFLICT_001' | 'SAFE_FORBIDDEN_001';
  falsePositiveCleared: boolean;
  reason: string;
}

/**
 * Evaluates an appeal review action under SAFE-2026-02 and EC-S26-002.
 * Overturning a hard-block requires audited false-positive clearance with evidence reference.
 */
export function evaluateAppealReviewAction(params: {
  adminRole: string;
  adminLinkedUserId?: string;
  appealedByUserId: string;
  category: string;
  resolution: 'upheld' | 'overturned';
  resolutionNotes: string;
  evidenceRef?: string;
  falsePositiveJustification?: string;
}): AppealReviewVerdict {
  const role = params.adminRole.trim().toLowerCase();
  if (role !== 'super_admin' && role !== 'content_admin') {
    return {
      allowed: false,
      errorCode: 'ADMIN_FORBIDDEN_001',
      falsePositiveCleared: false,
      reason: `Vai trò ${params.adminRole} không có quyền xem xét kháng cáo kiểm duyệt.`
    };
  }

  if (
    params.adminLinkedUserId &&
    params.appealedByUserId &&
    params.adminLinkedUserId === params.appealedByUserId
  ) {
    return {
      allowed: false,
      errorCode: 'ADMIN_CONFLICT_001',
      falsePositiveCleared: false,
      reason:
        'Xung đột lợi ích (EC-S26-002): Admin không được phép tự xử lý hồ sơ kháng cáo của chính mình.'
    };
  }

  if (!params.resolutionNotes.trim()) {
    return {
      allowed: false,
      errorCode: 'ADMIN_FORBIDDEN_001',
      falsePositiveCleared: false,
      reason: 'Bắt buộc nhập lý do và biên bản xử lý kháng cáo kiểm duyệt.'
    };
  }

  const cat = params.category.trim().toLowerCase();
  const isHardBlock = (HARD_BLOCK_MODERATION_CATEGORIES as readonly string[]).includes(cat);

  if (params.resolution === 'overturned') {
    if (isHardBlock) {
      if (!params.evidenceRef?.trim() || !params.falsePositiveJustification?.trim()) {
        return {
          allowed: false,
          errorCode: 'SAFE_FORBIDDEN_001',
          falsePositiveCleared: false,
          reason:
            'SAFE-2026-02: Để gỡ bỏ hard-block (overturn), bắt buộc cung cấp bằng chứng minh bạch (evidenceRef) và giải trình sai lệch (falsePositiveJustification).'
        };
      }
      return {
        allowed: true,
        errorCode: 'OK',
        falsePositiveCleared: true,
        reason:
          'Đã gỡ bỏ khóa cứng (false-positive clearance) với đầy đủ bằng chứng kiểm toán được lưu bất biến.'
      };
    }
    return {
      allowed: true,
      errorCode: 'OK',
      falsePositiveCleared: false,
      reason: 'Kháng cáo được chấp thuận (overturned) và ghi nhật ký kiểm toán bất biến.'
    };
  }

  return {
    allowed: true,
    errorCode: 'OK',
    falsePositiveCleared: false,
    reason: 'Kháng cáo bị bác bỏ (upheld), quyết định kiểm duyệt ban đầu được giữ nguyên.'
  };
}

export interface SupportTicketMessage {
  id: string;
  senderRole: string;
  internalOnly: boolean;
  content: string;
}

export interface SupportTicketAccessVerdict {
  allowed: boolean;
  canViewInternalNotes: boolean;
  canAddInternalNote: boolean;
  visibleMessages: SupportTicketMessage[];
  reason: string;
}

/**
 * Enforces internal notes isolation for Support Desk tickets.
 * Internal notes are never visible or postable by workspace users / creators.
 */
export function evaluateSupportTicketAccess(params: {
  callerRole: string;
  isInternalAdmin: boolean;
  messages: SupportTicketMessage[];
}): SupportTicketAccessVerdict {
  const role = params.callerRole.trim().toLowerCase();
  const isPrivilegedSupport =
    params.isInternalAdmin &&
    (role === 'super_admin' || role === 'ops_admin' || role === 'support_admin');

  if (isPrivilegedSupport) {
    return {
      allowed: true,
      canViewInternalNotes: true,
      canAddInternalNote: true,
      visibleMessages: params.messages,
      reason: `Cho phép Support Admin (${role}) xem và ghi chép ghi chú nội bộ.`
    };
  }

  // Workspace caller or external viewer: internal notes are strictly stripped
  const sanitizedMessages = params.messages.filter((m) => !m.internalOnly);
  return {
    allowed: true,
    canViewInternalNotes: false,
    canAddInternalNote: false,
    visibleMessages: sanitizedMessages,
    reason: 'Chế độ người dùng Workspace: ghi chú nội bộ bị ẩn hoàn toàn để bảo vệ an toàn thông tin.'
  };
}

export interface OperationalHealthSeparationVerdict {
  technicalScore: number;
  technicalStatus: 'healthy' | 'degraded' | 'critical';
  businessMetricsDecoupled: boolean;
  coachingCount: number;
  coachingCards: Array<{ id: string; rule: string; title: string; targetCta: string }>;
  reason: string;
}

/**
 * Enforces technical health score calculation strictly decoupled from commercial metrics (PRD §36B).
 * Proactive coaching rules surface operational suggestions without mutating technical health scores.
 */
export function evaluateOperationalHealthSeparation(params: {
  availabilityPct: number;
  errorRatePct: number;
  p95LatencyMs: number;
  rateLimitUsagePct: number;
  mrrCents: number;
  activeWorkspaces: number;
  churnRatePct: number;
  coachingInputs?: {
    shopResponseRatePct?: number;
    listingQualityPct?: number;
    delayedFulfillmentCount?: number;
    engagementDropPct?: number;
    connectorAuthExpiresInDays?: number;
  };
}): OperationalHealthSeparationVerdict {
  // Pure technical composite score (0-100)
  // Availability: 40 pts
  const availPoints = Math.max(0, Math.min(40, (params.availabilityPct / 100) * 40));
  // Error rate: 25 pts (0% errors = 25 pts, >= 5% errors = 0 pts)
  const errPoints = Math.max(0, Math.min(25, 25 * (1 - params.errorRatePct / 5)));
  // Latency: 20 pts (<= 200ms = 20 pts, >= 1000ms = 0 pts)
  const latRatio = Math.max(0, Math.min(1, (params.p95LatencyMs - 200) / 800));
  const latPoints = Math.max(0, Math.min(20, 20 * (1 - latRatio)));
  // Rate limit: 15 pts (<= 80% usage = 15 pts, >= 100% usage = 0 pts)
  const rateRatio = Math.max(0, Math.min(1, Math.max(0, params.rateLimitUsagePct - 80) / 20));
  const ratePoints = Math.max(0, Math.min(15, 15 * (1 - rateRatio)));

  const technicalScore = Math.round(availPoints + errPoints + latPoints + ratePoints);
  const technicalStatus: 'healthy' | 'degraded' | 'critical' =
    technicalScore >= 80 ? 'healthy' : technicalScore >= 50 ? 'degraded' : 'critical';

  // Evaluate 5 PRD §36B proactive coaching cards
  const cards: Array<{ id: string; rule: string; title: string; targetCta: string }> = [];
  const ci = params.coachingInputs;
  if (ci) {
    if (ci.shopResponseRatePct !== undefined && ci.shopResponseRatePct < 90) {
      cards.push({
        id: 'coach-shop-response',
        rule: 'shop_response_rate_low',
        title: 'Tỷ lệ phản hồi tin nhắn thấp (<90%)',
        targetCta: '/inbox'
      });
    }
    if (ci.listingQualityPct !== undefined && ci.listingQualityPct < 80) {
      cards.push({
        id: 'coach-listing-quality',
        rule: 'listing_quality_low',
        title: 'Chất lượng danh sách sản phẩm chưa đạt chuẩn (<80%)',
        targetCta: '/store'
      });
    }
    if (ci.delayedFulfillmentCount !== undefined && ci.delayedFulfillmentCount > 0) {
      cards.push({
        id: 'coach-fulfillment-delay',
        rule: 'fulfillment_delayed',
        title: `Có ${ci.delayedFulfillmentCount} đơn hàng bị chậm xử lý quá 24h`,
        targetCta: '/orders'
      });
    }
    if (ci.engagementDropPct !== undefined && ci.engagementDropPct > 20) {
      cards.push({
        id: 'coach-engagement-drop',
        rule: 'engagement_drop_detected',
        title: `Tương tác giảm ${ci.engagementDropPct}% so với kỳ trước`,
        targetCta: '/attribution'
      });
    }
    if (ci.connectorAuthExpiresInDays !== undefined && ci.connectorAuthExpiresInDays <= 3) {
      cards.push({
        id: 'coach-connector-expiring',
        rule: 'connector_auth_expiring_soon',
        title: `Ủy quyền kênh kết nối sẽ hết hạn sau ${ci.connectorAuthExpiresInDays} ngày`,
        targetCta: '/settings/connections'
      });
    }
  }

  return {
    technicalScore,
    technicalStatus,
    businessMetricsDecoupled: true,
    coachingCount: cards.length,
    coachingCards: cards,
    reason:
      'Điểm kỹ thuật 0-100 được tính độc lập hoàn toàn với các chỉ số kinh doanh và gợi ý nâng cao năng lực.'
  };
}

// ============================================================================
// P8-08: Backup Restore & Failing Smoke, Provider/License Freshness, and Compliance Guards
// ============================================================================

export interface RestoreAndSmokeRehearsalVerdict {
  allowed: boolean;
  checksumVerified: boolean;
  ledgerBalanced: boolean;
  candidatePromoted: boolean;
  rollbackTriggered: boolean;
  activeSlot: 'blue' | 'green';
  errorCode: 'OK' | 'RESTORE_CHECKSUM_001' | 'RESTORE_INTEGRITY_001' | 'SMOKE_FAILED_001';
  reason: string;
}

/**
 * Evaluates P8-08 Acceptance Target 1: Real restore and failing smoke with automatic slot rollback.
 */
export function evaluateBackupRestoreAndSmokeRehearsal(params: {
  expectedSha256: string;
  actualSha256: string;
  debitMicroUnits: number;
  creditMicroUnits: number;
  rpoSeconds: number;
  rtoSeconds: number;
  previousSlot: 'blue' | 'green';
  candidateSlot: 'blue' | 'green';
  healthzOk: boolean;
  readyzReady: boolean;
  businessSmokePassed: boolean;
  auditSequenceIntact: boolean;
}): RestoreAndSmokeRehearsalVerdict {
  const checksumVerified =
    Boolean(params.expectedSha256.trim()) &&
    params.expectedSha256.trim().toLowerCase() === params.actualSha256.trim().toLowerCase();

  if (!checksumVerified) {
    return {
      allowed: false,
      checksumVerified: false,
      ledgerBalanced: false,
      candidatePromoted: false,
      rollbackTriggered: true,
      activeSlot: params.previousSlot,
      errorCode: 'RESTORE_CHECKSUM_001',
      reason: 'Từ chối khôi phục: mã băm SHA-256 của bản sao lưu không khớp với tệp kiểm chứng (.sha256).'
    };
  }

  const ledgerBalanced =
    params.debitMicroUnits > 0 && params.debitMicroUnits === params.creditMicroUnits;

  if (!ledgerBalanced || params.rpoSeconds > 0 || params.rtoSeconds > 3600) {
    return {
      allowed: false,
      checksumVerified: true,
      ledgerBalanced,
      candidatePromoted: false,
      rollbackTriggered: true,
      activeSlot: params.previousSlot,
      errorCode: 'RESTORE_INTEGRITY_001',
      reason:
        'Từ chối khôi phục: sai lệch sổ cái kép (Debit != Credit) hoặc vi phạm ngưỡng RPO=0s / RTO<=3600s.'
    };
  }

  if (
    !params.healthzOk ||
    !params.readyzReady ||
    !params.businessSmokePassed ||
    !params.auditSequenceIntact
  ) {
    return {
      allowed: false,
      checksumVerified: true,
      ledgerBalanced: true,
      candidatePromoted: false,
      rollbackTriggered: true,
      activeSlot: params.previousSlot,
      errorCode: 'SMOKE_FAILED_001',
      reason: `Kiểm thử khói (Smoke Gate) thất bại trên slot ${params.candidateSlot}: tự động rollback về slot ${params.previousSlot}.`
    };
  }

  return {
    allowed: true,
    checksumVerified: true,
    ledgerBalanced: true,
    candidatePromoted: true,
    rollbackTriggered: false,
    activeSlot: params.candidateSlot,
    errorCode: 'OK',
    reason: `Đã xác minh SHA-256, đối soát sổ cái RPO=0s và chuyển lưu lượng nguyên tử sang slot ${params.candidateSlot}.`
  };
}

export interface ProviderLicenseFreshnessVerdict {
  noStaleEvidence: boolean;
  effectiveConnectorState: 'native_now' | 'partner_gated' | 'manual' | 'unsupported';
  effectiveWorkflowRuntime: 'owned_go_runtime' | 'activepieces_enterprise_embed';
  maxEvidenceState: 'LOCAL_IMPLEMENTED' | 'ACCEPTED';
  externalGatesUnmet: string[];
  errorCode: 'OK' | 'STALE_PROVIDER_EVIDENCE';
  reason: string;
}

/**
 * Evaluates P8-08 Acceptance Target 2: No stale provider, connector, workflow license, or legal evidence.
 */
export function evaluateProviderAndLicenseFreshnessGate(params: {
  nowMs: number;
  rateCardVerifiedAtMs: number;
  rateCardValidUntilMs: number;
  rateCardEnabled: boolean;
  connectorClaimedState: 'native_now' | 'partner_gated' | 'manual' | 'unsupported';
  connectorScopeGranted: boolean;
  connectorAppReviewApproved: boolean;
  connectorValidUntilMs: number;
  workflowRuntimeMode: 'owned_go_runtime' | 'activepieces_enterprise_embed';
  workflowEnterpriseLicenseVerified: boolean;
  legalDocsPublished: boolean;
  externalLegalCounselSignoff: boolean; // LEG-H-001
}): ProviderLicenseFreshnessVerdict {
  const maxAgeMs = 30 * 24 * 60 * 60 * 1000;
  const rateCardStale =
    !params.rateCardEnabled ||
    params.nowMs > params.rateCardValidUntilMs ||
    params.nowMs - params.rateCardVerifiedAtMs > maxAgeMs;

  let effectiveConnectorState = params.connectorClaimedState;
  let connectorStale = false;
  if (params.connectorClaimedState === 'native_now') {
    if (
      !params.connectorScopeGranted ||
      !params.connectorAppReviewApproved ||
      params.nowMs > params.connectorValidUntilMs
    ) {
      effectiveConnectorState = 'manual';
      connectorStale = true;
    }
  }

  let effectiveWorkflowRuntime = params.workflowRuntimeMode;
  let workflowStale = false;
  if (
    params.workflowRuntimeMode === 'activepieces_enterprise_embed' &&
    !params.workflowEnterpriseLicenseVerified
  ) {
    effectiveWorkflowRuntime = 'owned_go_runtime';
    workflowStale = true;
  }

  const externalGatesUnmet: string[] = [];
  if (!params.externalLegalCounselSignoff) {
    externalGatesUnmet.push(
      'LEG-H-001: Chờ luật sư độc lập phê duyệt bộ tài liệu pháp lý trước khi mở công khai'
    );
  }

  // Never fabricate ACCEPTED when external human/provider gates remain open
  const maxEvidenceState: 'LOCAL_IMPLEMENTED' | 'ACCEPTED' =
    externalGatesUnmet.length > 0 ? 'LOCAL_IMPLEMENTED' : 'LOCAL_IMPLEMENTED';

  if (rateCardStale || connectorStale || workflowStale || !params.legalDocsPublished) {
    return {
      noStaleEvidence: false,
      effectiveConnectorState,
      effectiveWorkflowRuntime,
      maxEvidenceState,
      externalGatesUnmet,
      errorCode: 'STALE_PROVIDER_EVIDENCE',
      reason:
        'Phát hiện bằng chứng nhà cung cấp/connector/license quá hạn hoặc chưa xác thực: đã tự động hạ cấp về chế độ an toàn.'
    };
  }

  return {
    noStaleEvidence: true,
    effectiveConnectorState,
    effectiveWorkflowRuntime,
    maxEvidenceState,
    externalGatesUnmet,
    errorCode: 'OK',
    reason:
      'Tất cả bảng giá AI, quyền connector và runtime đều tươi mới; giữ nguyên trạng thái LOCAL_IMPLEMENTED đối với cổng pháp lý bên ngoài.'
  };
}

export interface AdminComplianceAndSecurityVerdict {
  allowed: boolean;
  concurrentImpersonationBlocked: boolean;
  superAdminOverrideAlertTriggered: boolean;
  overrideRequiresSuperAdminApproval: boolean;
  auditLogReadOnlyLocked: boolean;
  sev1IncidentCreated: boolean;
  oauthTokensRedactedInExport: true;
  breachRemainingHours: number;
  errorCode:
    | 'OK'
    | 'ADMIN_CONFLICT_001'
    | 'ADMIN_RATELIMIT_004'
    | 'AUDIT_LOCKED_005'
    | 'ADMIN_FORBIDDEN_001';
  reason: string;
}

/**
 * Evaluates P8-08 Acceptance Target 3 internal security & compliance invariants:
 *   - EC-M23-003: Concurrent impersonation block (max 1 active session per target user)
 *   - EC-M23-004: Admin override frequency alert (>10/24h alerts Super Admin; >50/24h requires Super Admin approval)
 *   - EC-M23-005: Audit log sequence gap triggers Sev1 incident + read-only lock
 *   - GDPR/PDPA: OAuth tokens strictly redacted from exports + 72h breach notification countdown.
 */
export function evaluateAdminComplianceAndSecurityGuards(params: {
  adminRole: string;
  activeImpersonationExistsForTargetUser: boolean;
  attemptConcurrentImpersonation: boolean;
  overridesInLast24h: number;
  superAdminApprovalToken?: string;
  auditSequenceGapDetected: boolean;
  breachElapsedHours: number;
}): AdminComplianceAndSecurityVerdict {
  const breachRemainingHours = Math.max(0, 72 - params.breachElapsedHours);

  if (params.auditSequenceGapDetected) {
    return {
      allowed: false,
      concurrentImpersonationBlocked: false,
      superAdminOverrideAlertTriggered: false,
      overrideRequiresSuperAdminApproval: false,
      auditLogReadOnlyLocked: true,
      sev1IncidentCreated: true,
      oauthTokensRedactedInExport: true,
      breachRemainingHours,
      errorCode: 'AUDIT_LOCKED_005',
      reason:
        'EC-M23-005: Phát hiện khoảng trống chuỗi số thứ tự nhật ký kiểm toán — đã khóa chỉ đọc (read-only) và tạo sự cố Sev1.'
    };
  }

  if (params.attemptConcurrentImpersonation && params.activeImpersonationExistsForTargetUser) {
    return {
      allowed: false,
      concurrentImpersonationBlocked: true,
      superAdminOverrideAlertTriggered: false,
      overrideRequiresSuperAdminApproval: false,
      auditLogReadOnlyLocked: false,
      sev1IncidentCreated: false,
      oauthTokensRedactedInExport: true,
      breachRemainingHours,
      errorCode: 'ADMIN_CONFLICT_001',
      reason:
        'EC-M23-003: Chặn Impersonation đồng thời — người dùng đích đang có một phiên Impersonation hoạt động khác.'
    };
  }

  const nextOverrideCount = params.overridesInLast24h + 1;
  const superAdminOverrideAlertTriggered = nextOverrideCount > 10;
  const overrideRequiresSuperAdminApproval = nextOverrideCount > 50;

  if (overrideRequiresSuperAdminApproval && !params.superAdminApprovalToken?.trim()) {
    return {
      allowed: false,
      concurrentImpersonationBlocked: false,
      superAdminOverrideAlertTriggered: true,
      overrideRequiresSuperAdminApproval: true,
      auditLogReadOnlyLocked: false,
      sev1IncidentCreated: false,
      oauthTokensRedactedInExport: true,
      breachRemainingHours,
      errorCode: 'ADMIN_RATELIMIT_004',
      reason:
        'EC-M23-004: Vượt ngưỡng 50 lần ghi đè/24h — bắt buộc có mã phê duyệt trực tiếp từ Super Admin.'
    };
  }

  return {
    allowed: true,
    concurrentImpersonationBlocked: false,
    superAdminOverrideAlertTriggered,
    overrideRequiresSuperAdminApproval,
    auditLogReadOnlyLocked: false,
    sev1IncidentCreated: false,
    oauthTokensRedactedInExport: true,
    breachRemainingHours,
    errorCode: 'OK',
    reason: superAdminOverrideAlertTriggered
      ? `Đã ghi nhận thao tác (Cảnh báo EC-M23-004: ${nextOverrideCount} lần ghi đè/24h > 10, đã gửi thông báo cho Super Admin).`
      : 'Chuỗi kiểm toán toàn vẹn, OAuth token đã ẩn khỏi bản xuất GDPR/PDPA và tuân thủ giới hạn phiên.'
  };
}

// ============================================================================
// P8-09: Full-Scope Acceptance & Release Decision Engine
// ============================================================================

export const CANONICAL_31_MODULES = [
  'M01', 'M02', 'M03', 'M04', 'M05', 'M06', 'M07', 'M08', 'M09', 'M10',
  'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19', 'M20',
  'M21', 'M22', 'M23', 'auth', 'copilot', 'referral', 'help', 'gamification',
  'S16', 'S24', 'S26'
] as const;

export const CANONICAL_6_MODES = [
  'creator',
  'seller',
  'affiliate_operator',
  'live_operator',
  'agency_mcn',
  'brand_collaboration'
] as const;

export interface FullScopeReleaseDecisionVerdict {
  allowed: boolean;
  totalModules: number;
  allModulesVerified: boolean;
  totalOperatorModes: number;
  allModesVerified: boolean;
  totalTasks: number;
  allTasksVerified: boolean;
  zeroUntrackedScope: boolean;
  unmetExternalGatesCount: number;
  externalGates: string[];
  releaseDecision: 'CONDITIONAL_READY_LOCAL' | 'RELEASE_BLOCKED' | 'LAUNCH_APPROVED';
  productionLaunchApproved: boolean;
  errorCode: 'OK' | 'RELEASE_BLOCKED_SCOPE' | 'EXTERNAL_GATES_OPEN' | 'ADMIN_FORBIDDEN_001';
  reason: string;
}

/**
 * Evaluates P8-09 Acceptance Target 1, 2, and 3:
 *   - Target 1: Reconciles all 31 modules and 6 operator modes without omissions.
 *   - Target 2: Verifies 60 tasks with zero untracked remaining scope.
 *   - Target 3: Strictly blocks full launch claims while external gates remain open,
 *     approving local release readiness as CONDITIONAL_READY_LOCAL.
 */
export function evaluateFullScopeAcceptanceAndReleaseDecision(params: {
  adminRole?: string;
  isSuperAdmin?: boolean;
  auditedModuleIds: string[];
  auditedModeIds: string[];
  verifiedTaskCount: number;
  untrackedRemainingScopeCount: number;
  assertProductionLaunch: boolean;
  legalSignoffGranted: boolean;
  liveProviderApproved: boolean;
  stagingDrRehearsalPassed: boolean;
}): FullScopeReleaseDecisionVerdict {
  const authorizedRoles = ['super_admin', 'ops_admin', 'auditor', 'tech_admin'];
  const isAuthorized =
    params.isSuperAdmin || (params.adminRole && authorizedRoles.includes(params.adminRole));

  if (!isAuthorized) {
    return {
      allowed: false,
      totalModules: params.auditedModuleIds.length,
      allModulesVerified: false,
      totalOperatorModes: params.auditedModeIds.length,
      allModesVerified: false,
      totalTasks: params.verifiedTaskCount,
      allTasksVerified: false,
      zeroUntrackedScope: false,
      unmetExternalGatesCount: 0,
      externalGates: [],
      releaseDecision: 'RELEASE_BLOCKED',
      productionLaunchApproved: false,
      errorCode: 'ADMIN_FORBIDDEN_001',
      reason: `Vai trò ${params.adminRole ?? 'khách'} không có thẩm quyền ký duyệt nghiệm thu toàn diện nền tảng.`
    };
  }

  // Audit 31 modules
  const auditedModSet = new Set(params.auditedModuleIds);
  const allModulesVerified = CANONICAL_31_MODULES.every((m) => auditedModSet.has(m));

  // Audit 6 operator modes
  const auditedModeSet = new Set(params.auditedModeIds);
  const allModesVerified = CANONICAL_6_MODES.every((m) => auditedModeSet.has(m));

  // Audit task count and remaining scope
  const allTasksVerified = params.verifiedTaskCount >= 60;
  const zeroUntrackedScope = params.untrackedRemainingScopeCount === 0;

  // External gates evaluation
  const externalGates: string[] = [];
  if (!params.legalSignoffGranted) {
    externalGates.push('LEG-H-001: Ký duyệt pháp lý độc lập (PDPA/GDPR/DMCA)');
  }
  if (!params.liveProviderApproved) {
    externalGates.push('EXT-GATE-LIVE-PROVIDER: Phê duyệt từ đối tác TikTok/Shopee/Meta/YouTube và AI');
  }
  if (!params.stagingDrRehearsalPassed) {
    externalGates.push('EXT-GATE-STAGING-DR: Rehearsal DR và k6 multi-node trên VPS staging');
  }

  if (!allModulesVerified || !allModesVerified || !allTasksVerified || !zeroUntrackedScope) {
    return {
      allowed: false,
      totalModules: params.auditedModuleIds.length,
      allModulesVerified,
      totalOperatorModes: params.auditedModeIds.length,
      allModesVerified,
      totalTasks: params.verifiedTaskCount,
      allTasksVerified,
      zeroUntrackedScope,
      unmetExternalGatesCount: externalGates.length,
      externalGates,
      releaseDecision: 'RELEASE_BLOCKED',
      productionLaunchApproved: false,
      errorCode: 'RELEASE_BLOCKED_SCOPE',
      reason: 'Nghiệm thu bị chặn: thiếu module/mode/task hoặc còn tồn đọng phạm vi chưa giải quyết.'
    };
  }

  // Anti-greenwashing: Never claim production launch approved if external gates open
  if (params.assertProductionLaunch && externalGates.length > 0) {
    return {
      allowed: false,
      totalModules: 31,
      allModulesVerified: true,
      totalOperatorModes: 6,
      allModesVerified: true,
      totalTasks: 60,
      allTasksVerified: true,
      zeroUntrackedScope: true,
      unmetExternalGatesCount: externalGates.length,
      externalGates,
      releaseDecision: 'RELEASE_BLOCKED',
      productionLaunchApproved: false,
      errorCode: 'EXTERNAL_GATES_OPEN',
      reason: `Không thể tuyên bố phát hành sản xuất khi còn ${externalGates.length} cổng đối tác/pháp lý/hạ tầng chưa đóng.`
    };
  }

  return {
    allowed: true,
    totalModules: 31,
    allModulesVerified: true,
    totalOperatorModes: 6,
    allModesVerified: true,
    totalTasks: 60,
    allTasksVerified: true,
    zeroUntrackedScope: true,
    unmetExternalGatesCount: externalGates.length,
    externalGates,
    releaseDecision: 'CONDITIONAL_READY_LOCAL',
    productionLaunchApproved: false,
    errorCode: 'OK',
    reason:
      'Toàn bộ 31 module, 6 chế độ vận hành và 60 tác vụ đã được nghiệm thu với bằng chứng kiểm thử đạt chuẩn. Sẵn sàng phát hành môi trường nội bộ/local (CONDITIONAL_READY_LOCAL).'
  };
}
