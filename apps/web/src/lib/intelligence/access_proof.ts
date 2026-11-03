// Package intelligence provides frontend contracts, access proof evaluation,
// downstream conversion gating, empty/degraded state handling, and non-conflation guards.
// Canonical sources: docs/00_index/BUILD_INDEX.md (P2), docs/00_index/AGENT_TASK_CARDS.md (P2-04),
// docs/02_features/intelligence/trend_radar.md (M02), docs/02_features/intelligence/competitor_intelligence.md (M03),
// docs/02_features/intelligence/opportunity_board.md (M04), docs/02_features/platform/capability_matrix.md (M22).

export type SourceVerificationStatus = 'verified' | 'imported' | 'degraded' | 'unsupported';

export type ConfidenceBand =
  | 'unspecified'
  | 'low'
  | 'low_medium'
  | 'medium'
  | 'medium_high'
  | 'high';

export type SourceClass =
  | 'unspecified'
  | 'official'
  | 'imported'
  | 'inferred'
  | 'estimated'
  | 'unreconciled';

export interface AccessProofRecord {
  platform: string;
  actionKey: string;
  status: SourceVerificationStatus;
  isVerified: boolean;
  isDegraded: boolean;
  sourceClass: SourceClass;
  confidenceBand: ConfidenceBand;
  evidenceRef: string;
  grantedScopes: string[];
  requiredScopes: string[];
  endpoint: string;
  checkedAt: string;
  validUntil: string;
  degradedReason?: string;
  fallbackNote?: string;
  canFallbackToImport: boolean;
  reconnectRequired: boolean;
}

export type DownstreamTargetType = 'idea' | 'script' | 'campaign' | 'live_plan';

export interface DownstreamPhaseGate {
  targetType: DownstreamTargetType;
  targetModule: string;
  targetModuleName: string;
  phaseAssigned: 'P3' | 'P6';
  taskRef: string;
  isExecutableInP2: boolean;
  explanation: string;
}

const DOWNSTREAM_POLICIES: Record<DownstreamTargetType, DownstreamPhaseGate> = {
  idea: {
    targetType: 'idea',
    targetModule: 'M05',
    targetModuleName: 'Idea Board (Ý tưởng nội dung)',
    phaseAssigned: 'P3',
    taskRef: 'P3-01',
    isExecutableInP2: false,
    explanation: 'Khởi tạo Idea và quy trình AI drafting được giao cho Phase P3 (M05). Trong Phase P2, liên kết nháp được tạo với dòng xuất xứ đầy đủ.'
  },
  script: {
    targetType: 'script',
    targetModule: 'M06',
    targetModuleName: 'Script Studio (Kịch bản video)',
    phaseAssigned: 'P3',
    taskRef: 'P3-02',
    isExecutableInP2: false,
    explanation: 'Khởi tạo kịch bản 30-60s và AI hook gợi ý thuộc Phase P3 (M06). Trong Phase P2, đối tượng được lưu dưới dạng draft_linked.'
  },
  campaign: {
    targetType: 'campaign',
    targetModule: 'M14',
    targetModuleName: 'Campaign Hub (Chiến dịch đa kênh)',
    phaseAssigned: 'P6',
    taskRef: 'P6-01',
    isExecutableInP2: false,
    explanation: 'Điều phối chiến dịch đa nền tảng và phân bổ ngân sách thuộc Phase P6 (M14). Trong Phase P2, thông tin được bảo lưu lineage.'
  },
  live_plan: {
    targetType: 'live_plan',
    targetModule: 'M17',
    targetModuleName: 'Live Studio (Kế hoạch phát sóng trực tiếp)',
    phaseAssigned: 'P6',
    taskRef: 'P6-02',
    isExecutableInP2: false,
    explanation: 'Kế hoạch phiên live và phân bổ cue cards thuộc Phase P6 (M17). Trong Phase P2, liên kết bảo tồn nguồn gốc cơ hội.'
  }
};

/**
 * Returns downstream phase gating policy for a given conversion target.
 * Enforces Acceptance Target 2: "Future conversions remain assigned to later tasks".
 */
export function getDownstreamGatePolicy(targetType: DownstreamTargetType): DownstreamPhaseGate {
  const policy = DOWNSTREAM_POLICIES[targetType];
  if (!policy) {
    throw new Error(`Unsupported downstream conversion target: ${targetType}`);
  }
  return policy;
}

/**
 * Verifies live source access proof and checks for expiration/revocation.
 * Enforces Acceptance Target 1: "Every live source has access evidence".
 */
export function verifyLiveSourceAccess(
  record: Partial<AccessProofRecord> & { platform: string; actionKey: string }
): AccessProofRecord {
  const now = new Date();
  const validUntil = record.validUntil ? new Date(record.validUntil) : null;
  const isExpired = validUntil !== null && validUntil < now;

  const grantedScopes = record.grantedScopes || [];
  const requiredScopes = record.requiredScopes || [];
  const missingScopes = requiredScopes.filter(s => !grantedScopes.includes(s));

  if (!record.evidenceRef || missingScopes.length > 0) {
    return {
      platform: record.platform,
      actionKey: record.actionKey,
      status: 'unsupported',
      isVerified: false,
      isDegraded: false,
      sourceClass: 'unspecified',
      confidenceBand: 'low',
      evidenceRef: record.evidenceRef || '',
      grantedScopes,
      requiredScopes,
      endpoint: record.endpoint || '',
      checkedAt: record.checkedAt || now.toISOString(),
      validUntil: record.validUntil || '',
      degradedReason: missingScopes.length > 0 ? `Thiếu quyền OAuth: ${missingScopes.join(', ')}` : 'Chưa có bằng chứng truy cập hợp lệ',
      fallbackNote: 'Có thể sử dụng chức năng Nhập dữ liệu thủ công / File CSV để tiếp tục',
      canFallbackToImport: true,
      reconnectRequired: true
    };
  }

  if (isExpired || record.isDegraded) {
    return {
      platform: record.platform,
      actionKey: record.actionKey,
      status: 'degraded',
      isVerified: true,
      isDegraded: true,
      sourceClass: 'official',
      confidenceBand: 'medium',
      evidenceRef: record.evidenceRef,
      grantedScopes,
      requiredScopes,
      endpoint: record.endpoint || '',
      checkedAt: record.checkedAt || now.toISOString(),
      validUntil: record.validUntil || '',
      degradedReason: record.degradedReason || (isExpired ? 'Phiên truy cập đã hết hạn (Token expired)' : 'Kết nối bị suy thoái'),
      fallbackNote: 'Dữ liệu hiển thị từ bộ nhớ đệm gần nhất. Nhấn Kết nối lại để làm mới token.',
      canFallbackToImport: true,
      reconnectRequired: true
    };
  }

  return {
    platform: record.platform,
    actionKey: record.actionKey,
    status: 'verified',
    isVerified: true,
    isDegraded: false,
    sourceClass: record.sourceClass || 'official',
    confidenceBand: record.confidenceBand || 'high',
    evidenceRef: record.evidenceRef,
    grantedScopes,
    requiredScopes,
    endpoint: record.endpoint || '',
    checkedAt: record.checkedAt || now.toISOString(),
    validUntil: record.validUntil || '',
    canFallbackToImport: false,
    reconnectRequired: false
  };
}

/**
 * Formula neutralization prevents CSV / Spreadsheet injection vulnerability.
 * Strips leading '=', '+', '-', '@', '\t', '\r'.
 */
export function neutralizeSpreadsheetFormula(raw: string): string {
  const trimmed = raw.trim();
  if (!trimmed) return '';
  if (/^[=+\-@\t\r]/.test(trimmed)) {
    return `'${trimmed}`;
  }
  return trimmed;
}

/**
 * Financial non-conflation guard:
 * Validates that observational competitor pricing or opportunity estimated profits
 * are NEVER routed into M19 Operating Financial Ledger.
 */
export function validateFinancialNonConflation(
  sourceModule: string,
  isActualFinancialLedger: boolean
): { allowed: boolean; error?: string } {
  if (isActualFinancialLedger && (sourceModule === 'M03' || sourceModule === 'M04' || sourceModule === 'M02')) {
    return {
      allowed: false,
      error: `Vi phạm nguyên tắc không lẫn lộn tài chính (Financial Non-Conflation): Dữ liệu quan sát từ ${sourceModule} không được phép ghi nhận vào Sổ cái vận hành thực tế M19.`
    };
  }
  return { allowed: true };
}

/**
 * Empty & degraded state summary evaluator.
 * Enforces Acceptance Target 3: "Empty/degraded/audit paths pass".
 */
export function evaluateEmptyOrDegraded(
  workspaceAccounts: Array<{ platform: string; isConnected: boolean; tokenExpired?: boolean }>
) {
  const connected = workspaceAccounts.filter(a => a.isConnected && !a.tokenExpired);
  const degraded = workspaceAccounts.filter(a => a.isConnected && a.tokenExpired);
  const unconnected = workspaceAccounts.filter(a => !a.isConnected);

  const hasEmptyState = connected.length === 0 && degraded.length === 0;

  const emptyStateCtas: string[] = [];
  if (hasEmptyState) {
    emptyStateCtas.push('Kết nối tài khoản mạng xã hội (TikTok, Meta, YouTube, Shopee)');
    emptyStateCtas.push('Nhập thủ công dữ liệu xu hướng qua tệp CSV / Excel');
    emptyStateCtas.push('Khám phá dữ liệu xu hướng công khai từ Google Trends');
  }

  return {
    hasEmptyState,
    connectedCount: connected.length,
    degradedCount: degraded.length,
    unconnectedCount: unconnected.length,
    emptyStateCtas,
    degradedPlatforms: degraded.map(d => d.platform)
  };
}
