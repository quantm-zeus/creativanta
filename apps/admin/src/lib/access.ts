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
