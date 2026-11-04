/**
 * Cross-Domain Commerce Conversions & Shared Lineage (P6-08)
 * Canonical Sources:
 *   - docs/02_features/intelligence/opportunity_board.md (RULE-M04-004, RULE-M04-006, EC-M04-002)
 *   - docs/02_features/content/idea_engine.md (RULE-M05-001, RULE-M05-002, RULE-M05-003)
 *   - docs/02_features/engagement/unified_inbox.md (RULE-M12-003, RULE-M12-005)
 *   - docs/04_contracts/rbac_permission_matrix.md (§2.2, §2.3, §2.7, §2.11, §2.12, §2.13)
 *   - docs/04_contracts/database_schema.md (cross_domain_conversions)
 */

export type SourceType = 'opportunity' | 'idea' | 'thread';
export type TargetType = 'campaign' | 'live' | 'offer' | 'seeding' | 'deal' | 'script';
export type WorkspaceRole = 'owner' | 'admin' | 'manager' | 'editor' | 'contributor' | 'viewer' | 'external';

export interface TargetPermissionRequirement {
  permission: string;
  minRole: 'manager' | 'editor' | 'contributor';
  description: string;
}

export const TARGET_PERMISSIONS: Record<TargetType, TargetPermissionRequirement> = {
  campaign: {
    permission: 'campaign:manage',
    minRole: 'editor',
    description: 'Quyền tạo và quản lý Chiến dịch (M14)',
  },
  live: {
    permission: 'live:manage',
    minRole: 'editor',
    description: 'Quyền tạo và điều phối Livestream (M17)',
  },
  offer: {
    permission: 'offer:manage',
    minRole: 'editor',
    description: 'Quyền tạo và quản lý Ưu đãi / Mã giảm giá (M14)',
  },
  seeding: {
    permission: 'sample:manage',
    minRole: 'editor',
    description: 'Quyền tạo yêu cầu gửi mẫu thử Seeding (M18)',
  },
  deal: {
    permission: 'brand_deal:manage',
    minRole: 'manager',
    description: 'Quyền quản lý Hợp tác Nhãn hàng Brand Deal (S16 - Manager+)',
  },
  script: {
    permission: 'script:create',
    minRole: 'contributor',
    description: 'Quyền tạo Kịch bản Script Lab (M06)',
  },
};

export const SOURCE_PERMISSIONS: Record<SourceType, string> = {
  opportunity: 'opportunity:convert',
  idea: 'idea:convert',
  thread: 'thread:triage',
};

/**
 * Evaluates whether a workspace role possesses a given named permission per RBAC matrix.
 */
export function hasPermission(role: WorkspaceRole, permission: string): boolean {
  switch (permission) {
    case 'opportunity:convert':
    case 'idea:convert':
    case 'thread:triage':
    case 'campaign:manage':
    case 'live:manage':
    case 'offer:manage':
    case 'sample:manage':
      return role === 'owner' || role === 'admin' || role === 'manager' || role === 'editor';
    case 'brand_deal:manage':
      // Acceptance Target 1: brand_deal:manage is Manager+ only!
      return role === 'owner' || role === 'admin' || role === 'manager';
    case 'script:create':
    case 'idea:create':
      return role === 'owner' || role === 'admin' || role === 'manager' || role === 'editor' || role === 'contributor';
    default:
      return false;
  }
}

/**
 * Acceptance Target 1: Rechecks that the caller possesses BOTH the source convert permission
 * AND the specific target domain permission before proceeding.
 */
export function evaluateConversionPermissions(
  role: WorkspaceRole,
  sourceType: SourceType,
  targetType: TargetType
): { allowed: boolean; error?: string; missingPermission?: string } {
  const sourcePerm = SOURCE_PERMISSIONS[sourceType];
  if (!hasPermission(role, sourcePerm)) {
    return {
      allowed: false,
      error: `Vai trò "${role}" không có quyền chuyển đổi nguồn (${sourcePerm}).`,
      missingPermission: sourcePerm,
    };
  }

  const targetReq = TARGET_PERMISSIONS[targetType];
  if (!hasPermission(role, targetReq.permission)) {
    return {
      allowed: false,
      error: `Chuyển đổi sang ${targetType} yêu cầu quyền "${targetReq.permission}" (${targetReq.description}). Vai trò "${role}" không đủ quyền.`,
      missingPermission: targetReq.permission,
    };
  }

  return { allowed: true };
}

export function resolveTargetRoute(targetType: TargetType, targetId: string): string {
  switch (targetType) {
    case 'campaign':
      return `/campaigns/${targetId}`;
    case 'live':
      return `/live/sessions/${targetId}`;
    case 'offer':
      return `/offers/${targetId}`;
    case 'seeding':
      return `/seeding/samples/${targetId}`;
    case 'deal':
      return `/brand-deals/${targetId}`;
    case 'script':
      return `/scripts/${targetId}`;
    default:
      return `/${targetType}/${targetId}`;
  }
}

export interface LineageRecord {
  conversionId: string;
  workspaceId: string;
  sourceType: SourceType;
  sourceId: string;
  targetType: TargetType;
  targetId: string;
  convertedBy: string;
  status: 'completed' | 'failed' | 'rolled_back';
  lineageDepth: number;
  rootSourceType?: string;
  rootSourceId?: string;
  metadata: Record<string, any>;
  createdAt: string;
}

export interface ConversionSourceItem {
  id: string;
  type: SourceType;
  title: string;
  status: string;
  convertedToType?: string;
  convertedToId?: string;
  metadata?: Record<string, any>;
}

export interface ConversionExecutionParams {
  workspaceId: string;
  role: WorkspaceRole;
  userId: string;
  source: ConversionSourceItem;
  targetType: TargetType;
  targetTitle?: string;
  targetDetails?: Record<string, any>;
  simulateFailureStage?: 'target_creation' | 'source_update' | 'lineage_save';
}

export interface ConversionExecutionResult {
  success: boolean;
  conversionId?: string;
  targetId?: string;
  targetRoute?: string;
  lineageRecord?: LineageRecord;
  updatedSource?: ConversionSourceItem;
  sourceSurvives: boolean;
  error?: string;
}

/**
 * Executes a cross-domain conversion with atomic rollback on failure and source survival.
 */
export function executeCrossDomainConversion(
  params: ConversionExecutionParams
): ConversionExecutionResult {
  const { workspaceId, role, userId, source, targetType, targetTitle, targetDetails, simulateFailureStage } = params;

  // 1. Permission Recheck (Target 1)
  const permCheck = evaluateConversionPermissions(role, source.type, targetType);
  if (!permCheck.allowed) {
    return {
      success: false,
      sourceSurvives: true,
      updatedSource: { ...source },
      error: permCheck.error,
    };
  }

  // 2. Validate source convertible state
  if (source.convertedToType || source.status === 'converted' || source.status === 'converted_to_task') {
    return {
      success: false,
      sourceSurvives: true,
      updatedSource: { ...source },
      error: `Đối tượng nguồn ${source.type} #${source.id} đã được chuyển đổi trước đó.`,
    };
  }

  // 3. Simulated failure during target creation (Target 2: Atomic)
  if (simulateFailureStage === 'target_creation') {
    return {
      success: false,
      sourceSurvives: true,
      updatedSource: { ...source }, // untouched!
      error: 'Lỗi khởi tạo đối tượng đích: kết nối cơ sở dữ liệu gián đoạn. Giao dịch đã khôi phục hoàn toàn.',
    };
  }

  const targetId = `target-${targetType}-${Date.now()}`;
  const conversionId = `conv-${Date.now()}`;
  const route = resolveTargetRoute(targetType, targetId);

  // 4. Simulated failure during source update (Target 2: Compensation)
  if (simulateFailureStage === 'source_update') {
    // Target was created but source update failed -> compensation rollback
    return {
      success: false,
      sourceSurvives: true,
      updatedSource: { ...source },
      error: 'Lỗi cập nhật trạng thái nguồn. Đã hoàn tác và xoá bản ghi đích.',
    };
  }

  // 5. Update Source (Target 3: Source survives conversion)
  const updatedSource: ConversionSourceItem = {
    ...source,
    convertedToType: targetType,
    convertedToId: targetId,
    status: source.type === 'thread' ? 'converted_to_task' : 'converted',
  };

  // 6. Simulated failure during lineage save
  if (simulateFailureStage === 'lineage_save') {
    return {
      success: false,
      sourceSurvives: true,
      updatedSource: { ...source }, // rolled back to original!
      error: 'Lỗi lưu trữ bản đồ phả hệ (lineage). Đã khôi phục đối tượng nguồn.',
    };
  }

  // 7. Success: create Lineage Record
  const lineageRecord: LineageRecord = {
    conversionId,
    workspaceId,
    sourceType: source.type,
    sourceId: source.id,
    targetType,
    targetId,
    convertedBy: userId,
    status: 'completed',
    lineageDepth: 1,
    rootSourceType: source.type,
    rootSourceId: source.id,
    metadata: {
      sourceTitle: source.title,
      targetTitle: targetTitle || source.title,
      targetRoute: route,
      details: targetDetails || {},
    },
    createdAt: new Date().toISOString(),
  };

  return {
    success: true,
    conversionId,
    targetId,
    targetRoute: route,
    lineageRecord,
    updatedSource,
    sourceSurvives: true,
  };
}
