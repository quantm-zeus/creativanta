// apps/web/src/lib/engagement/engagement.test.ts
// Unit and acceptance tests for M12 Unified Inbox web domain service.

import { describe, expect, it } from 'vitest';
import {
  evaluateBotLoopState,
  evaluateGhostStatus,
  evaluateRevokedAccount,
  evaluateSurgeState,
  validateComposeCanSend,
  validateMessagingWindow,
  validateReplyAsIdentity,
  validateStateTransition
} from './engagement_service';
import type { ConnectedAccount, Thread } from './types';

function createMockThread(overrides?: Partial<Thread>): Thread {
  return {
    id: 'thread-test-101',
    workspaceId: 'ws-eng-1',
    connectedAccountId: 'acc-tiktok-1',
    sourcePlatform: 'tiktok',
    threadType: 'comment',
    status: 'active',
    intent: 'question',
    priority: 'normal',
    ownerUserId: 'agent-alice',
    nextAction: 'Tư vấn thông số',
    slaDueAt: '2026-11-04T12:00:00.000Z',
    slaBreached: false,
    slaApproaching: false,
    messageCount: 3,
    lastActivityAt: '2026-11-04T10:00:00.000Z',
    messagingWindowExpiresAt: '2026-11-05T10:00:00.000Z',
    autoReplyPaused: false,
    autoReplyPermanentlyDisabled: false,
    autoReplyConsecutiveCount: 0,
    isGhost: false,
    ghostStatus: 'active',
    throttleState: 'NORMAL',
    accountRevoked: false,
    relatedObjectRefs: [],
    createdAt: '2026-11-04T10:00:00.000Z',
    updatedAt: '2026-11-04T10:00:00.000Z',
    ...overrides
  };
}

const mockAccount: ConnectedAccount = {
  id: 'acc-tiktok-1',
  workspaceId: 'ws-eng-1',
  platform: 'tiktok',
  accountName: '@creativanta_vietnam',
  avatarUrl: 'https://cdn.example.com/avatar.png',
  badgeColor: '#FE2C55',
  isRevoked: false
};

describe('Acceptance Target 1: Messaging-Window Denial', () => {
  it('validates open window within 24 hours of customer inbound', () => {
    const expiresAt = '2026-11-05T10:00:00.000Z';
    const now = new Date('2026-11-04T14:00:00.000Z'); // 4 hours later

    const result = validateMessagingWindow(expiresAt, now);
    expect(result.isValid).toBe(true);
    expect(result.remainingMs).toBe(20 * 60 * 60 * 1000); // 20 hours remaining
  });

  it('denies messaging when 24 hours have elapsed', () => {
    const expiresAt = '2026-11-05T10:00:00.000Z';
    const now = new Date('2026-11-05T10:00:01.000Z'); // 1 second past expiry

    const result = validateMessagingWindow(expiresAt, now);
    expect(result.isValid).toBe(false);
    expect(result.remainingMs).toBe(0);

    const thread = createMockThread({ messagingWindowExpiresAt: expiresAt });
    const composeCheck = validateComposeCanSend(thread, mockAccount, 'Chào bạn!', false, now);
    expect(composeCheck.canSend).toBe(false);
    expect(composeCheck.reason).toContain('hết hạn');
  });

  it('rejects null or invalid expiration timestamps', () => {
    const res1 = validateMessagingWindow(null);
    expect(res1.isValid).toBe(false);

    const res2 = validateMessagingWindow('not-a-date');
    expect(res2.isValid).toBe(false);
  });
});

describe('Acceptance Target 2: Bot-Loop & Viral Surge Handling', () => {
  it('detects paused auto-reply loop and permanently disabled loop', () => {
    const normalThread = createMockThread();
    expect(evaluateBotLoopState(normalThread).isPaused).toBe(false);

    const pausedThread = createMockThread({ autoReplyPaused: true });
    const pausedEval = evaluateBotLoopState(pausedThread);
    expect(pausedEval.isPaused).toBe(true);
    expect(pausedEval.isPermanentlyDisabled).toBe(false);
    expect(pausedEval.notice?.message).toContain('tạm dừng');

    const permDisabledThread = createMockThread({
      autoReplyPaused: true,
      autoReplyPermanentlyDisabled: true
    });
    const permEval = evaluateBotLoopState(permDisabledThread);
    expect(permEval.isPaused).toBe(true);
    expect(permEval.isPermanentlyDisabled).toBe(true);
    expect(permEval.notice?.message).toContain('vĩnh viễn');
  });

  it('blocks compose validation when auto-reply bot loop is tripped', () => {
    const now = new Date('2026-11-04T14:00:00.000Z');
    const thread = createMockThread({ autoReplyPaused: true });
    const autoReplyCheck = validateComposeCanSend(thread, mockAccount, 'Auto greeting', true, now);
    expect(autoReplyCheck.canSend).toBe(false);
    expect(autoReplyCheck.botLoopNotice?.isPaused).toBe(true);

    // Operator human reply is still allowed even if auto-reply loop is tripped!
    const humanCheck = validateComposeCanSend(thread, mockAccount, 'Chào bạn, tôi là Alice.', false, now);
    expect(humanCheck.canSend).toBe(true);
  });

  it('evaluates viral surge levels: NORMAL -> THROTTLED -> CIRCUIT_BREAKER', () => {
    // Normal rate (<100 msg/min)
    const normal = evaluateSurgeState('NORMAL', 45);
    expect(normal.level).toBe('none');
    expect(normal.aiActive).toBe(true);
    expect(normal.rawIngestOnly).toBe(false);

    // Throttled (100–500 msg/min)
    const throttled = evaluateSurgeState('THROTTLED', 250);
    expect(throttled.level).toBe('warning');
    expect(throttled.aiActive).toBe(false);
    expect(throttled.rawIngestOnly).toBe(false);
    expect(throttled.message).toContain('theo lô');

    // Circuit breaker (>500 msg/min)
    const breaker = evaluateSurgeState('CIRCUIT_BREAKER', 750);
    expect(breaker.level).toBe('circuit_breaker');
    expect(breaker.aiActive).toBe(false);
    expect(breaker.rawIngestOnly).toBe(true);
    expect(breaker.message).toContain('đảm bảo SLA');
  });
});

describe('Acceptance Target 3: Ghost Messages and Revoked Account Repair', () => {
  it('evaluates ghost message with canonical WHAT-WHY-NEXT copy and blocks compose', () => {
    const ghostDeleted = createMockThread({
      isGhost: true,
      ghostStatus: 'deleted_by_user'
    });

    const evalDeleted = evaluateGhostStatus(ghostDeleted);
    expect(evalDeleted.isBlocked).toBe(true);
    expect(evalDeleted.notice?.what).toContain('người dùng xóa');
    expect(evalDeleted.notice?.why).toContain('404/410');
    expect(evalDeleted.notice?.next).toContain('Hộp soạn phản hồi đã bị khóa');

    const composeCheck = validateComposeCanSend(ghostDeleted, mockAccount, 'Shop xin chào!');
    expect(composeCheck.canSend).toBe(false);
    expect(composeCheck.ghostNotice).toBeDefined();

    const ghostRestricted = createMockThread({
      isGhost: true,
      ghostStatus: 'restricted_by_platform'
    });
    const evalRestricted = evaluateGhostStatus(ghostRestricted);
    expect(evalRestricted.isBlocked).toBe(true);
    expect(evalRestricted.notice?.why).toContain('403');
  });

  it('detects revoked connected account and blocks compose with reconnect action', () => {
    const revokedAccount: ConnectedAccount = { ...mockAccount, isRevoked: true };
    const thread = createMockThread({ accountRevoked: true });

    const evalRevoked = evaluateRevokedAccount(revokedAccount, thread);
    expect(evalRevoked.isBlocked).toBe(true);
    expect(evalRevoked.notice?.action).toContain('kết nối lại');

    const composeCheck = validateComposeCanSend(thread, revokedAccount, 'Shop liên hệ');
    expect(composeCheck.canSend).toBe(false);
    expect(composeCheck.accountRevokedNotice?.action).toContain('kết nối lại');
  });
});

describe('RULE-M12-006: Reply-As Identity & State Transitions', () => {
  it('validates Reply-As identity requires valid selected account', () => {
    const accounts = [mockAccount];
    const missing = validateReplyAsIdentity(null, accounts);
    expect(missing.isValid).toBe(false);

    const nonExistent = validateReplyAsIdentity('unknown-acc', accounts);
    expect(nonExistent.isValid).toBe(false);

    const valid = validateReplyAsIdentity(mockAccount.id, accounts);
    expect(valid.isValid).toBe(true);
    expect(valid.account?.accountName).toBe('@creativanta_vietnam');
  });

  it('enforces RULE-M12-003 valid thread state transitions', () => {
    // new -> triaged or active
    expect(validateStateTransition('new', 'triaged')).toBe(true);
    expect(validateStateTransition('new', 'active')).toBe(true);
    expect(validateStateTransition('new', 'resolved')).toBe(false); // cannot skip

    // active -> waiting_on_user, resolved, etc.
    expect(validateStateTransition('active', 'waiting_on_user')).toBe(true);
    expect(validateStateTransition('active', 'resolved')).toBe(true);
    expect(validateStateTransition('active', 'archived')).toBe(true);

    // archived is terminal
    expect(validateStateTransition('archived', 'active')).toBe(false);
  });
});
