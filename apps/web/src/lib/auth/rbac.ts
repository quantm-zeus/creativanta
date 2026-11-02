/**
 * Client-side RBAC & Revocation Projection Helpers for Creativanta Web (P0-04)
 * Reference:
 *   - docs/04_contracts/rbac_permission_matrix.md
 *   - docs/02_features/platform/auth.md (EC-AUTH-003 member revocation redirect)
 *   - docs/03_screens/web/screen_web_settings_members.md (W115)
 *   - docs/03_screens/web/screen_web_settings_team.md (W116)
 *
 * Security Invariant: Client-side RBAC is for UI rendering and UX guidance only;
 * the Go API and PostgreSQL 17.10 RLS enforce all authorization server-side.
 */

import type { WorkspaceRole, WorkspaceSummary } from './types';

export interface CanonicalRoleMeta {
  role: WorkspaceRole;
  rank: number;
  label: string;
  vietnameseLabel: string;
  badgeIcon: string;
  summary: string;
  canManageSettings: boolean;
  canInviteMembers: boolean;
  canAssignRoles: boolean;
  canRemoveMembers: boolean;
  canManageBilling: boolean;
  canReadRevenue: boolean;
}

export const CANONICAL_WORKSPACE_ROLES: readonly CanonicalRoleMeta[] = [
  {
    role: 'owner',
    rank: 7,
    label: 'Owner',
    vietnameseLabel: 'Chủ sở hữu',
    badgeIcon: '👑',
    summary: 'Toàn quyền truy cập, thanh toán, xóa workspace và chuyển quyền sở hữu.',
    canManageSettings: true,
    canInviteMembers: true,
    canAssignRoles: true,
    canRemoveMembers: true,
    canManageBilling: true,
    canReadRevenue: true
  },
  {
    role: 'admin',
    rank: 6,
    label: 'Admin',
    vietnameseLabel: 'Quản trị viên',
    badgeIcon: '🔑',
    summary: 'Toàn quyền vận hành và quản lý thành viên (trừ thanh toán & xóa workspace).',
    canManageSettings: true,
    canInviteMembers: true,
    canAssignRoles: true,
    canRemoveMembers: true,
    canManageBilling: false,
    canReadRevenue: true
  },
  {
    role: 'manager',
    rank: 5,
    label: 'Manager',
    vietnameseLabel: 'Quản lý',
    badgeIcon: '📋',
    summary: 'Phê duyệt nội dung/xuất bản, mời thành viên và xem doanh thu tổng hợp.',
    canManageSettings: false,
    canInviteMembers: true,
    canAssignRoles: false,
    canRemoveMembers: false,
    canManageBilling: false,
    canReadRevenue: true
  },
  {
    role: 'editor',
    rank: 4,
    label: 'Editor',
    vietnameseLabel: 'Biên tập viên',
    badgeIcon: '✏️',
    summary: 'Tạo và chỉnh sửa ý tưởng, kịch bản, sản phẩm, chiến dịch và lịch đăng.',
    canManageSettings: false,
    canInviteMembers: false,
    canAssignRoles: false,
    canRemoveMembers: false,
    canManageBilling: false,
    canReadRevenue: false
  },
  {
    role: 'contributor',
    rank: 3,
    label: 'Contributor',
    vietnameseLabel: 'Cộng tác viên',
    badgeIcon: '📎',
    summary: 'Tạo ý tưởng/kịch bản của riêng mình và tạo tài nguyên trong hạn mức.',
    canManageSettings: false,
    canInviteMembers: false,
    canAssignRoles: false,
    canRemoveMembers: false,
    canManageBilling: false,
    canReadRevenue: false
  },
  {
    role: 'viewer',
    rank: 2,
    label: 'Viewer',
    vietnameseLabel: 'Người xem',
    badgeIcon: '👁',
    summary: 'Quyền xem dữ liệu vận hành cơ bản (không xem tài chính chi tiết, không chỉnh sửa).',
    canManageSettings: false,
    canInviteMembers: false,
    canAssignRoles: false,
    canRemoveMembers: false,
    canManageBilling: false,
    canReadRevenue: false
  },
  {
    role: 'external',
    rank: 1,
    label: 'External',
    vietnameseLabel: 'Cộng tác bên ngoài',
    badgeIcon: '🔗',
    summary: 'Chỉ truy cập các mục được chia sẻ hoặc giao việc tường minh (shared_externally).',
    canManageSettings: false,
    canInviteMembers: false,
    canAssignRoles: false,
    canRemoveMembers: false,
    canManageBilling: false,
    canReadRevenue: false
  }
] as const;

export function getRoleMeta(role: WorkspaceRole): CanonicalRoleMeta {
  const normalized = String(role || '').toLowerCase();
  const found = CANONICAL_WORKSPACE_ROLES.find((r) => r.role === normalized);
  return found ?? CANONICAL_WORKSPACE_ROLES[CANONICAL_WORKSPACE_ROLES.length - 1];
}

/**
 * Evaluates whether an actor role can modify or remove a target member row in the UI,
 * enforcing last-owner protection and preventing self-demotion or Admin-on-Owner edits.
 */
export function canModifyMemberInUI(params: {
  actorUserId: string;
  actorRole: WorkspaceRole;
  targetUserId: string;
  targetRole: WorkspaceRole;
  activeOwnerCount: number;
}): { canChangeRole: boolean; canRemove: boolean; reason: string | null } {
  const actor = getRoleMeta(params.actorRole);
  const target = getRoleMeta(params.targetRole);

  if (!actor.canAssignRoles && !actor.canRemoveMembers) {
    return {
      canChangeRole: false,
      canRemove: false,
      reason: 'Vai trò hiện tại không có quyền thay đổi vai trò hoặc xóa thành viên'
    };
  }

  if (params.actorUserId && params.actorUserId === params.targetUserId) {
    if (target.role === 'owner' && params.activeOwnerCount <= 1) {
      return {
        canChangeRole: false,
        canRemove: false,
        reason: 'Chủ sở hữu duy nhất không thể tự hạ quyền hoặc rời workspace trước khi chuyển quyền sở hữu'
      };
    }
    return {
      canChangeRole: false,
      canRemove: false,
      reason: 'Không thể tự thay đổi vai trò hoặc xóa chính bạn'
    };
  }

  if (target.role === 'owner' && actor.role !== 'owner') {
    return {
      canChangeRole: false,
      canRemove: false,
      reason: 'Quản trị viên không thể thay đổi hoặc xóa Chủ sở hữu (Owner)'
    };
  }

  if (target.role === 'owner' && params.activeOwnerCount <= 1) {
    return {
      canChangeRole: false,
      canRemove: false,
      reason: 'Workspace phải luôn có ít nhất 1 Chủ sở hữu đang hoạt động'
    };
  }

  return {
    canChangeRole: actor.canAssignRoles,
    canRemove: actor.canRemoveMembers,
    reason: null
  };
}

/**
 * Handles EC-AUTH-003: When a member's access to the active workspace is revoked mid-session,
 * filters the workspace out of the available list and selects a remaining workspace or null.
 */
export function reconcileRevokedWorkspaceSession(
  workspaces: WorkspaceSummary[],
  revokedWorkspaceId: string,
  currentActiveWorkspaceId: string | null
): {
  remainingWorkspaces: WorkspaceSummary[];
  nextActiveWorkspace: WorkspaceSummary | null;
  redirectPath: '/workspaces' | '/onboarding';
} {
  const remainingWorkspaces = workspaces.filter(
    (w) => w.id !== revokedWorkspaceId && w.status !== 'deactivated'
  );

  let nextActiveWorkspace: WorkspaceSummary | null = null;
  if (currentActiveWorkspaceId && currentActiveWorkspaceId !== revokedWorkspaceId) {
    nextActiveWorkspace =
      remainingWorkspaces.find((w) => w.id === currentActiveWorkspaceId) ?? null;
  }
  if (!nextActiveWorkspace && remainingWorkspaces.length === 1) {
    nextActiveWorkspace = remainingWorkspaces[0];
  }

  return {
    remainingWorkspaces,
    nextActiveWorkspace,
    redirectPath: remainingWorkspaces.length > 0 ? '/workspaces' : '/onboarding'
  };
}

const FORBIDDEN_CLIENT_PROJECTION_KEYS = new Set([
  'access_token_encrypted',
  'refresh_token_encrypted',
  'access_token',
  'refresh_token',
  'key_hash',
  'signing_secret_hash',
  'signing_secret',
  'password_hash',
  'mfa_secret_encrypted',
  'session_token_hash',
  'private_notes',
  'internal_note'
]);

/**
 * Verifies that a projected response object contains no secret hashes, encrypted tokens,
 * or internal support notes (`is_internal_note === true`).
 */
export function assertSafeClientProjection(payload: unknown): void {
  if (payload === null || typeof payload !== 'object') {
    return;
  }
  if (Array.isArray(payload)) {
    for (const item of payload) {
      assertSafeClientProjection(item);
    }
    return;
  }
  const rec = payload as Record<string, unknown>;
  for (const [key, value] of Object.entries(rec)) {
    const normalized = key.trim().toLowerCase();
    if (FORBIDDEN_CLIENT_PROJECTION_KEYS.has(normalized)) {
      throw new Error(`Forbidden secret/private key serialized in projection: ${key}`);
    }
    if (normalized === 'is_internal_note' && value === true) {
      throw new Error('Forbidden internal support note serialized in tenant projection');
    }
    assertSafeClientProjection(value);
  }
}
