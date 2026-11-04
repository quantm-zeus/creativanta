// apps/web/src/lib/engagement/engagement_service.ts
// Frontend domain service and business logic for M12 Unified Inbox & Engagement Center.
// Enforces:
// 1. Acceptance Target 1: Messaging-Window Denial (24-hour window from customer inbound)
// 2. Acceptance Target 2: Bot-Loop (RULE-M12-008) and Viral Surge Throttling (RULE-M12-007)
// 3. Acceptance Target 3: Ghost Messages (WHAT-WHY-NEXT copy) and Revoked Account Repair
// 4. RULE-M12-001 (mandatory fields), RULE-M12-003 (state machine), RULE-M12-006 (Reply-As identity)

import type {
  ConnectedAccount,
  ComposeValidationResult,
  FollowUpTask,
  GhostStatus,
  Message,
  SurgeBannerState,
  SurgeThrottleState,
  Thread,
  ThreadStatus,
  WhatWhyNextNotice
} from './types';

export class EngagementValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'EngagementValidationError';
  }
}

export class MessagingWindowExpiredError extends EngagementValidationError {
  constructor(message: string = 'engagement: 24-hour messaging window expired for this thread') {
    super(message);
    this.name = 'MessagingWindowExpiredError';
  }
}

export class AccountRevokedError extends EngagementValidationError {
  constructor(message: string = 'engagement: target connected account authorization has been revoked') {
    super(message);
    this.name = 'AccountRevokedError';
  }
}

export class BotLoopBlockedError extends EngagementValidationError {
  constructor(message: string = 'engagement: bot-loop circuit breaker triggered on thread') {
    super(message);
    this.name = 'BotLoopBlockedError';
  }
}

/**
 * Validates whether the 24-hour messaging window is still open for an outbound reply.
 * Acceptance Target 1: Enforces 24-hour reply window from last customer inbound.
 */
export function validateMessagingWindow(
  expiresAt: string | null,
  now: Date = new Date()
): { isValid: boolean; remainingMs: number } {
  if (!expiresAt) {
    // If no expiration is recorded, assume expired / closed unless active
    return { isValid: false, remainingMs: 0 };
  }

  const expTime = new Date(expiresAt).getTime();
  if (isNaN(expTime)) {
    return { isValid: false, remainingMs: 0 };
  }

  const remaining = expTime - now.getTime();
  if (remaining <= 0) {
    return { isValid: false, remainingMs: 0 };
  }

  return { isValid: true, remainingMs: remaining };
}

/**
 * Evaluates ghost message status and provides canonical WHAT-WHY-NEXT copy (Pack 05 A4).
 * Acceptance Target 3: Handles 404 (deleted), 403 (restricted), 410 (permanently removed).
 */
export function evaluateGhostStatus(thread: Thread): {
  isBlocked: boolean;
  notice?: WhatWhyNextNotice;
} {
  if (!thread.isGhost) {
    return { isBlocked: false };
  }

  switch (thread.ghostStatus) {
    case 'deleted_by_user':
      return {
        isBlocked: true,
        notice: {
          what: 'Tin nhắn này đã bị người dùng xóa trên nền tảng gốc.',
          why: 'Nền tảng trả về mã lỗi 404/410 do nội dung không còn tồn tại.',
          next: 'Hộp soạn phản hồi đã bị khóa. Bạn có thể lưu trữ luồng này hoặc thêm ghi chú nội bộ.'
        }
      };
    case 'restricted_by_platform':
      return {
        isBlocked: true,
        notice: {
          what: 'Tin nhắn này đã bị nền tảng giới hạn quyền truy cập.',
          why: 'Nền tảng trả về mã lỗi 403 do chính sách kiểm duyệt hoặc hạn chế tài khoản người gửi.',
          next: 'Không thể gửi phản hồi trực tiếp. Bạn có thể chuyển thành thẻ công việc cần xử lý.'
        }
      };
    case 'permanently_removed':
      return {
        isBlocked: true,
        notice: {
          what: 'Nội dung hội thoại đã bị xóa vĩnh viễn trên kênh liên kết.',
          why: 'Nền tảng trả về mã lỗi 410 Gone.',
          next: 'Luồng đã được chuyển sang trạng thái lưu trữ.'
        }
      };
    default:
      return { isBlocked: false };
  }
}

/**
 * Evaluates whether the connected account authorization has been revoked mid-sync or reply.
 * Acceptance Target 3: Prompts operator to reconnect OAuth account.
 */
export function evaluateRevokedAccount(
  account: ConnectedAccount | null,
  thread: Thread
): {
  isBlocked: boolean;
  notice?: { message: string; action: string };
} {
  if (thread.accountRevoked || (account && account.isRevoked)) {
    return {
      isBlocked: true,
      notice: {
        message: 'Tài khoản mạng xã hội này đã bị thu hồi quyền truy cập (OAuth token revoked).',
        action: 'Vui lòng kết nối lại tài khoản trong Cài đặt Kênh để tiếp tục gửi tin nhắn.'
      }
    };
  }
  return { isBlocked: false };
}

/**
 * Evaluates auto-reply loop circuit breaker states (RULE-M12-008).
 * Acceptance Target 2: Pauses on >=3 consecutive bot replies, >=5 in 5m, or >80% similarity.
 */
export function evaluateBotLoopState(thread: Thread): {
  isPaused: boolean;
  isPermanentlyDisabled: boolean;
  notice?: { isPaused: boolean; isPermanentlyDisabled: boolean; message: string };
} {
  if (thread.autoReplyPermanentlyDisabled) {
    return {
      isPaused: true,
      isPermanentlyDisabled: true,
      notice: {
        isPaused: true,
        isPermanentlyDisabled: true,
        message: 'Tự động phản hồi đã bị vô hiệu hóa vĩnh viễn trên luồng này do kích hoạt vòng lặp lặp lại lần 2.'
      }
    };
  }

  if (thread.autoReplyPaused) {
    return {
      isPaused: true,
      isPermanentlyDisabled: false,
      notice: {
        isPaused: true,
        isPermanentlyDisabled: false,
        message: 'Tự động phản hồi đang tạm dừng (phát hiện vòng lặp bot). Nhân viên cần gửi phản hồi thủ công hoặc đặt lại.'
      }
    };
  }

  return { isPaused: false, isPermanentlyDisabled: false };
}

/**
 * Evaluates viral surge ingestion throttle state (RULE-M12-007).
 * Acceptance Target 2:
 * <100 msg/min: NORMAL (real-time AI)
 * 100-500 msg/min: THROTTLED (batch AI every 5m)
 * >500 msg/min: CIRCUIT_BREAKER (raw ingest only, AI paused)
 * Invariant: SLA clocks NEVER pause during surge.
 */
export function evaluateSurgeState(
  throttleState: SurgeThrottleState,
  currentRateMsgPerMin: number
): SurgeBannerState {
  if (throttleState === 'CIRCUIT_BREAKER' || currentRateMsgPerMin > 500) {
    return {
      level: 'circuit_breaker',
      message: 'Cảnh báo đột biến lưu lượng (>500 tin/phút): Tạm dừng AI phân loại thời gian thực. Hệ thống chỉ ghi nhận tin thô để đảm bảo SLA.',
      aiActive: false,
      rawIngestOnly: true
    };
  }

  if (throttleState === 'THROTTLED' || currentRateMsgPerMin >= 100) {
    return {
      level: 'warning',
      message: 'Lưu lượng tin nhắn tăng cao (100–500 tin/phút): Đang chuyển sang xử lý AI theo lô mỗi 5 phút.',
      aiActive: false,
      rawIngestOnly: false
    };
  }

  return {
    level: 'none',
    message: 'Hoạt động bình thường. Phân tích AI và trả lời gợi ý đang bật tức thì.',
    aiActive: true,
    rawIngestOnly: false
  };
}

/**
 * Validates Reply-As identity (RULE-M12-006).
 * Compose box MUST display color-coded badge + avatar + account name.
 * Users cannot send without identity selected.
 */
export function validateReplyAsIdentity(
  selectedAccountId: string | null,
  accounts: ConnectedAccount[]
): {
  isValid: boolean;
  account?: ConnectedAccount;
  error?: string;
} {
  if (!selectedAccountId) {
    return { isValid: false, error: 'Chưa chọn tài khoản gửi phản hồi (Reply-As identity required).' };
  }

  const account = accounts.find((a) => a.id === selectedAccountId);
  if (!account) {
    return { isValid: false, error: 'Tài khoản gửi phản hồi không tồn tại trong Không gian làm việc.' };
  }

  return { isValid: true, account };
}

/**
 * Validates thread state transitions according to RULE-M12-003.
 */
export function validateStateTransition(from: ThreadStatus, to: ThreadStatus): boolean {
  if (from === to) return true;

  switch (from) {
    case 'new':
      return to === 'triaged' || to === 'active' || to === 'archived' || to === 'snoozed';
    case 'triaged':
      return to === 'active' || to === 'archived' || to === 'snoozed';
    case 'active':
      return [
        'waiting_on_user',
        'waiting_on_team',
        'snoozed',
        'stale',
        'converted_to_task',
        'resolved',
        'archived'
      ].includes(to);
    case 'waiting_on_user':
      return ['active', 'resolved', 'archived', 'snoozed', 'stale'].includes(to);
    case 'waiting_on_team':
      return ['active', 'resolved', 'archived', 'snoozed', 'stale'].includes(to);
    case 'snoozed':
      return ['active', 'archived', 'resolved'].includes(to);
    case 'stale':
      return ['active', 'archived', 'resolved'].includes(to);
    case 'converted_to_task':
      return ['active', 'resolved', 'archived'].includes(to);
    case 'resolved':
      return ['active', 'archived'].includes(to);
    case 'archived':
      return false; // Terminal state
    default:
      return false;
  }
}

/**
 * Master compose validation that consolidates all gates before message dispatch.
 */
export function validateComposeCanSend(
  thread: Thread,
  account: ConnectedAccount | null,
  body: string,
  isAutoReply: boolean = false,
  now: Date = new Date()
): ComposeValidationResult {
  // Empty body
  if (!body || body.trim().length === 0) {
    return { canSend: false, reason: 'Nội dung phản hồi không được để trống.' };
  }

  // Acceptance Target 3: Revoked Account
  const revokedEval = evaluateRevokedAccount(account, thread);
  if (revokedEval.isBlocked) {
    return {
      canSend: false,
      reason: 'Tài khoản mạng xã hội đã bị thu hồi quyền truy cập.',
      accountRevokedNotice: revokedEval.notice
    };
  }

  // Acceptance Target 3: Ghost message
  const ghostEval = evaluateGhostStatus(thread);
  if (ghostEval.isBlocked) {
    return {
      canSend: false,
      reason: 'Không thể gửi tin nhắn vào luồng hội thoại đã bị xóa hoặc giới hạn trên nền tảng gốc.',
      ghostNotice: ghostEval.notice
    };
  }

  // Acceptance Target 1: 24-hour messaging window
  const windowEval = validateMessagingWindow(thread.messagingWindowExpiresAt, now);
  if (!windowEval.isValid) {
    return {
      canSend: false,
      reason: 'Cửa sổ nhắn tin 24 giờ đã hết hạn. Chỉ có thể phản hồi sau khi khách hàng nhắn tin lại.',
      windowRemainingMs: 0
    };
  }

  // Acceptance Target 2: Bot loop on auto-reply
  if (isAutoReply) {
    const loopEval = evaluateBotLoopState(thread);
    if (loopEval.isPaused) {
      return {
        canSend: false,
        reason: loopEval.notice?.message || 'Tự động phản hồi bị khóa do vòng lặp bot.',
        botLoopNotice: loopEval.notice
      };
    }
  }

  return {
    canSend: true,
    windowRemainingMs: windowEval.remainingMs
  };
}

/**
 * Target 3: Converts a thread intent into a Sample Request task linked to P6 Seeding CRM (P6-09).
 * Preserves P6 task link and deferral status without faking completion.
 */
export function convertToSampleRequest(
  thread: Thread,
  sampleRequestId: string,
  nowIso: string = new Date().toISOString()
): { thread: Thread; task: FollowUpTask } {
  const updatedThread: Thread = {
    ...thread,
    status: 'converted_to_task',
    relatedObjectRefs: [
      ...thread.relatedObjectRefs,
      {
        type: 'sample_request',
        id: sampleRequestId,
        taskRef: 'P6-09',
        phase: 'P6',
        isP6Deferred: true,
        status: 'pending_p6_delivery'
      }
    ],
    updatedAt: nowIso
  };

  const task: FollowUpTask = {
    id: `task_${Math.random().toString(36).substring(2, 11)}`,
    workspaceId: thread.workspaceId,
    sourceThreadId: thread.id,
    sourceObjectType: 'sample_request',
    sourceObjectId: sampleRequestId,
    assignedUserId: thread.ownerUserId || 'unassigned',
    taskType: 'sample_request',
    title: `Fulfill sample request for thread ${thread.id}`,
    description: `Sample request converted from inbound thread ${thread.id}. Awaiting P6 delivery execution.`,
    dueAt: null,
    status: 'pending',
    taskRef: 'P6-09',
    phase: 'P6',
    isP6Deferred: true,
    createdAt: nowIso,
    updatedAt: nowIso
  };

  return { thread: updatedThread, task };
}

/**
 * Target 3: Converts a thread intent into a Brand Deal task linked to P6 Brand Deals (P6-09).
 * Preserves P6 task link and deferral status without faking completion.
 */
export function convertToBrandDeal(
  thread: Thread,
  brandDealId: string,
  nowIso: string = new Date().toISOString()
): { thread: Thread; task: FollowUpTask } {
  const updatedThread: Thread = {
    ...thread,
    status: 'converted_to_task',
    relatedObjectRefs: [
      ...thread.relatedObjectRefs,
      {
        type: 'brand_deal',
        id: brandDealId,
        taskRef: 'P6-09',
        phase: 'P6',
        isP6Deferred: true,
        status: 'pending_p6_delivery'
      }
    ],
    updatedAt: nowIso
  };

  const task: FollowUpTask = {
    id: `task_${Math.random().toString(36).substring(2, 11)}`,
    workspaceId: thread.workspaceId,
    sourceThreadId: thread.id,
    sourceObjectType: 'brand_deal',
    sourceObjectId: brandDealId,
    assignedUserId: thread.ownerUserId || 'unassigned',
    taskType: 'brand_deal',
    title: `Follow up brand collaboration deal for thread ${thread.id}`,
    description: `Brand collaboration converted from inbound thread ${thread.id}. Awaiting P6 delivery execution.`,
    dueAt: null,
    status: 'pending',
    taskRef: 'P6-09',
    phase: 'P6',
    isP6Deferred: true,
    createdAt: nowIso,
    updatedAt: nowIso
  };

  return { thread: updatedThread, task };
}

/**
 * Target 3: Converts a thread intent into an Offer task linked to P6 Monetization OS (P6-01).
 * Preserves P6 task link and deferral status without faking completion.
 */
export function convertToOffer(
  thread: Thread,
  offerId: string,
  nowIso: string = new Date().toISOString()
): { thread: Thread; task: FollowUpTask } {
  const updatedThread: Thread = {
    ...thread,
    status: 'converted_to_task',
    relatedObjectRefs: [
      ...thread.relatedObjectRefs,
      {
        type: 'offer',
        id: offerId,
        taskRef: 'P6-01',
        phase: 'P6',
        isP6Deferred: true,
        status: 'pending_p6_delivery'
      }
    ],
    updatedAt: nowIso
  };

  const task: FollowUpTask = {
    id: `task_${Math.random().toString(36).substring(2, 11)}`,
    workspaceId: thread.workspaceId,
    sourceThreadId: thread.id,
    sourceObjectType: 'offer',
    sourceObjectId: offerId,
    assignedUserId: thread.ownerUserId || 'unassigned',
    taskType: 'offer',
    title: `Provide exclusive offer for thread ${thread.id}`,
    description: `Offer/coupon converted from inbound thread ${thread.id}. Awaiting P6 delivery execution.`,
    dueAt: null,
    status: 'pending',
    taskRef: 'P6-01',
    phase: 'P6',
    isP6Deferred: true,
    createdAt: nowIso,
    updatedAt: nowIso
  };

  return { thread: updatedThread, task };
}
