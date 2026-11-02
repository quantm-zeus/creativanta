import type { WorkspaceRole } from '$lib/auth';

export type ExternalEffectStatus =
  | 'prepared'
  | 'submitted'
  | 'succeeded'
  | 'failed'
  | 'unknown'
  | 'cancelled';

export type DiagnosticHealthState = 'healthy' | 'warning' | 'error' | 'critical';

export type RepairWizardStepNumber = 1 | 2 | 3 | 4;

export interface QueueTopologyEntry {
  name: string;
  vietnameseLabel: string;
  concurrency: number;
  timeoutLabel: string;
  maxRetries: number;
  backoffLabel: string;
}

export const CANONICAL_QUEUE_SPECS: readonly QueueTopologyEntry[] = [
  {
    name: 'generation_jobs',
    vietnameseLabel: 'Tạo video & AI Studio',
    concurrency: 4,
    timeoutLabel: '5m',
    maxRetries: 3,
    backoffLabel: '5s, 15s, 60s'
  },
  {
    name: 'publish_jobs',
    vietnameseLabel: 'Đăng bài đa kênh',
    concurrency: 4,
    timeoutLabel: '2m',
    maxRetries: 3,
    backoffLabel: '10s, 30s, 120s'
  },
  {
    name: 'connector_sync',
    vietnameseLabel: 'Đồng bộ Connector',
    concurrency: 2,
    timeoutLabel: '3m',
    maxRetries: 3,
    backoffLabel: '30s, 120s, 600s'
  },
  {
    name: 'webhook_delivery',
    vietnameseLabel: 'Giao nhận Webhook (S24)',
    concurrency: 4,
    timeoutLabel: '30s',
    maxRetries: 3,
    backoffLabel: '1s, 10s, 60s (tự ngắt sau 100 lỗi)'
  },
  {
    name: 'notifications',
    vietnameseLabel: 'Thông báo đa kênh',
    concurrency: 4,
    timeoutLabel: '15s',
    maxRetries: 3,
    backoffLabel: '2s, 10s, 30s'
  },
  {
    name: 'analytics_compute',
    vietnameseLabel: 'Tính toán phân tích',
    concurrency: 2,
    timeoutLabel: '5m',
    maxRetries: 2,
    backoffLabel: '60s, 300s'
  },
  {
    name: 'reconciliation',
    vietnameseLabel: 'Đối soát tài chính',
    concurrency: 1,
    timeoutLabel: '10m',
    maxRetries: 2,
    backoffLabel: '120s, 600s'
  },
  {
    name: 'export_jobs',
    vietnameseLabel: 'Xuất dữ liệu & báo cáo',
    concurrency: 2,
    timeoutLabel: '10m',
    maxRetries: 2,
    backoffLabel: '30s, 120s'
  },
  {
    name: 'search_indexing',
    vietnameseLabel: 'Chỉ mục tìm kiếm',
    concurrency: 2,
    timeoutLabel: '1m',
    maxRetries: 3,
    backoffLabel: '5s, 15s, 60s'
  },
  {
    name: 'moderation_scan',
    vietnameseLabel: 'Quét kiểm duyệt nội dung',
    concurrency: 2,
    timeoutLabel: '1m',
    maxRetries: 2,
    backoffLabel: '5s, 30s'
  },
  {
    name: 'gamification',
    vietnameseLabel: 'Thành tích & XP',
    concurrency: 2,
    timeoutLabel: '30s',
    maxRetries: 2,
    backoffLabel: '5s, 30s'
  }
] as const;

export interface DiagnosticCategoryMeta {
  key: string;
  displayName: string;
  summary: string;
}

export const CANONICAL_DIAGNOSTIC_CATEGORIES: readonly DiagnosticCategoryMeta[] = [
  {
    key: 'connected_accounts',
    displayName: 'Tài khoản kết nối',
    summary: 'Kiểm tra trạng thái OAuth token và quyền truy cập nền tảng.'
  },
  {
    key: 'publish_pipeline',
    displayName: 'Luồng đăng bài & lịch phát',
    summary: 'Kiểm tra hàng đợi publish_jobs và xác nhận phản hồi từ nền tảng.'
  },
  {
    key: 'order_inventory_sync',
    displayName: 'Đồng bộ đơn hàng & tồn kho',
    summary: 'Kiểm tra đối chiếu đơn hàng và giữ chỗ tồn kho.'
  },
  {
    key: 'webhook_delivery',
    displayName: 'Webhook & Public API (S24)',
    summary: 'Kiểm tra chống trùng lặp webhook inbound và chữ ký HMAC outbound.'
  },
  {
    key: 'ai_generation_credits',
    displayName: 'AI Studio & Hạn mức Credits',
    summary: 'Kiểm tra Circuit Breaker nhà cung cấp AI và sổ cái Credits.'
  },
  {
    key: 'workflow_automation',
    displayName: 'Quy trình tự động hóa',
    summary: 'Kiểm tra xác thực lại quyền live RBAC và hạn phê duyệt trước khi thực thi.'
  },
  {
    key: 'reconciliation_settlement',
    displayName: 'Đối soát & Thanh toán',
    summary: 'Kiểm tra tính bất biến nhật ký kiểm toán và bảo vệ dữ liệu tài chính (OPS-2026-02).'
  },
  {
    key: 'outbox_external_effects',
    displayName: 'Hàng đợi bền vững & Tác vụ ngoài',
    summary: 'Kiểm tra Outbox lease 30s, Consumer Inbox XAUTOCLAIM 60s và khóa chống gửi lại mù.'
  }
] as const;

export interface ExternalEffectGuardVerdict {
  allowBlindRetry: boolean;
  decision:
    | 'proceed'
    | 'already_succeeded'
    | 'blocked_requires_reconciliation'
    | 'blocked_cancelled';
  reason: string;
}

/**
 * Evaluates whether an external side effect in a given state can be retried automatically.
 * Enforces P0-05 Acceptance Target #3: unresolved ('unknown' or 'submitted') external results
 * are NEVER blindly retried.
 */
export function evaluateExternalEffectRetryGuard(
  status: ExternalEffectStatus
): ExternalEffectGuardVerdict {
  switch (status) {
    case 'unknown':
    case 'submitted':
      return {
        allowBlindRetry: false,
        decision: 'blocked_requires_reconciliation',
        reason:
          'Kết quả tác vụ bên ngoài chưa xác định (unknown/submitted). Hệ thống khóa tự động gửi lại để chống nhân đôi tác vụ; cần đối chiếu trạng thái thực tế trước.'
      };
    case 'succeeded':
      return {
        allowBlindRetry: false,
        decision: 'already_succeeded',
        reason: 'Tác vụ đã hoàn tất thành công trước đó; trả về kết quả đã lưu mà không gọi lại đối tác.'
      };
    case 'cancelled':
      return {
        allowBlindRetry: false,
        decision: 'blocked_cancelled',
        reason: 'Tác vụ đã bị hủy chủ động.'
      };
    case 'prepared':
    case 'failed':
      return {
        allowBlindRetry: true,
        decision: 'proceed',
        reason: 'Tác vụ chưa phát sinh hiệu ứng ngoài hoặc đã xác nhận từ chối rõ ràng; cho phép thực thi có kiểm soát.'
      };
  }
}

/**
 * Checks whether the current workspace role is permitted to view or repair diagnostics (W125 / M059).
 * Both `diagnostics:read` and `workspace:settings:manage` require `owner` or `admin`.
 */
export function evaluateDiagnosticsPermission(
  role: WorkspaceRole,
  action: 'read' | 'repair'
): { allowed: boolean; permissionKey: string; reason: string } {
  const permissionKey = action === 'read' ? 'diagnostics:read' : 'workspace:settings:manage';
  if (role === 'owner' || role === 'admin') {
    return {
      allowed: true,
      permissionKey,
      reason: `Vai trò ${role} được cấp quyền ${permissionKey}.`
    };
  }
  return {
    allowed: false,
    permissionKey,
    reason: `Vai trò ${role} không có quyền ${permissionKey} (chỉ Owner và Admin được phép truy cập Trung tâm Chẩn đoán M23).`
  };
}

const RAW_TECHNICAL_PATTERNS = [
  /select\s+.+\s+from\s+/i,
  /insert\s+into\s+/i,
  /update\s+.+\s+set\s+/i,
  /delete\s+from\s+/i,
  /sqlstate/i,
  /goroutine\s+\d+/i,
  /panic:/i,
  /access_token/i,
  /refresh_token/i,
  /signing_secret/i
];

/**
 * Enforces RULE-M23-A04: user-facing diagnostic messages must be plain-language
 * explanations and must never leak raw SQL, stack traces, or credentials.
 */
export function sanitizeUserFacingDiagnosticMessage(rawText: string): string {
  const trimmed = rawText.trim();
  if (!trimmed) {
    return 'Hệ thống ghi nhận cảnh báo cần kiểm tra trong Trung tâm Chẩn đoán.';
  }
  for (const pattern of RAW_TECHNICAL_PATTERNS) {
    if (pattern.test(trimmed)) {
      return 'Hệ thống phát hiện sự cố kỹ thuật trên thành phần này. Vui lòng sử dụng Trình sửa lỗi 4 bước để kiểm tra và khắc phục an toàn.';
    }
  }
  return trimmed;
}

export interface RepairWizardStepResult {
  allowed: boolean;
  completedStep: RepairWizardStepNumber;
  nextStep: RepairWizardStepNumber | null;
  statusLabel: 'acknowledged' | 'resolving' | 'resolved' | 'blocked';
  message: string;
}

/**
 * Evaluates a step transition in the 4-step Guided Repair Wizard (W125 / M059):
 * 1 (Verify) -> 2 (Diagnose) -> 3 (Fix) -> 4 (Confirm).
 */
export function evaluateRepairWizardTransition(
  step: RepairWizardStepNumber,
  requiresManualReconciliation: boolean,
  verificationReference: string
): RepairWizardStepResult {
  const ref = verificationReference.trim();
  if (step === 1) {
    return {
      allowed: true,
      completedStep: 1,
      nextStep: 2,
      statusLabel: 'acknowledged',
      message: 'Bước 1/4 (Xác minh): Đã kiểm tra trạng thái hiện tại của thành phần và khóa chống tự động gửi lại.'
    };
  }
  if (step === 2) {
    return {
      allowed: true,
      completedStep: 2,
      nextStep: 3,
      statusLabel: 'acknowledged',
      message: requiresManualReconciliation
        ? 'Bước 2/4 (Chẩn đoán): Tác vụ ngoài đang ở trạng thái unknown. Yêu cầu mã đối chiếu xác minh trước khi thực hiện Bước 3.'
        : 'Bước 2/4 (Chẩn đoán): Đã xác định nguyên nhân gốc và sẵn sàng thực hiện bước sửa lỗi.'
    };
  }
  if (step === 3) {
    if (requiresManualReconciliation && ref.length === 0) {
      return {
        allowed: false,
        completedStep: 3,
        nextStep: 3,
        statusLabel: 'blocked',
        message:
          'Từ chối Bước 3 (Khắc phục): Tác vụ bên ngoài có kết quả chưa xác định (unknown). Bắt buộc nhập mã xác minh đối chiếu (verification_reference) để tránh nhân đôi tác vụ.'
      };
    }
    return {
      allowed: true,
      completedStep: 3,
      nextStep: 4,
      statusLabel: 'resolving',
      message: 'Bước 3/4 (Khắc phục): Đã đối chiếu và cập nhật trạng thái tác vụ ngoài an toàn.'
    };
  }
  return {
    allowed: true,
    completedStep: 4,
    nextStep: null,
    statusLabel: 'resolved',
    message: 'Bước 4/4 (Xác nhận): Sự cố đã được đóng và ghi nhận vào nhật ký kiểm toán bất biến (audit_events).'
  };
}
