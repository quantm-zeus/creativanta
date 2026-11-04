// apps/web/src/lib/engagement/types.ts
// Frontend domain models and types for M12 Unified Inbox & Engagement Center.
// Follows docs/02_features/engagement/unified_inbox.md and docs/04_contracts/database_schema.md §9.

export type ThreadStatus =
  | 'new'
  | 'triaged'
  | 'active'
  | 'waiting_on_user'
  | 'waiting_on_team'
  | 'snoozed'
  | 'stale'
  | 'converted_to_task'
  | 'resolved'
  | 'archived';

export type ThreadIntent =
  | 'purchase_interest'
  | 'question'
  | 'support_issue'
  | 'objection'
  | 'sponsor_interest'
  | 'sample_request'
  | 'moderation_risk'
  | 'unknown';

export type ThreadPriority = 'urgent' | 'high' | 'normal' | 'low';

export type SurgeThrottleState = 'NORMAL' | 'THROTTLED' | 'CIRCUIT_BREAKER';

export type GhostStatus =
  | 'active'
  | 'deleted_by_user'
  | 'restricted_by_platform'
  | 'permanently_removed';

export type MessageSubtype =
  | 'comment'
  | 'dm'
  | 'review'
  | 'inquiry'
  | 'sponsor_inquiry'
  | 'sample_request'
  | 'reply'
  | 'internal_note'
  | 'system';

export type AuthorDirection = 'inbound' | 'outbound' | 'internal' | 'system';

export interface ConnectedAccount {
  id: string;
  workspaceId: string;
  platform: string;
  accountName: string;
  avatarUrl: string;
  badgeColor: string;
  isRevoked: boolean;
}

export interface RelatedObjectRef {
  type: string;
  id: string;
  sourceEventId?: string;
  url?: string;
  taskRef?: string;
  phase?: string;
  isP6Deferred?: boolean;
  status?: string;
}

export interface Thread {
  id: string;
  workspaceId: string;
  connectedAccountId: string;
  sourcePlatform: string;
  threadType: string;
  status: ThreadStatus;
  intent: ThreadIntent;
  priority: ThreadPriority;
  ownerUserId: string;
  nextAction: string;
  slaDueAt: string | null; // ISO-8601
  slaBreached: boolean;
  slaApproaching: boolean;
  messageCount: number;
  lastActivityAt: string; // ISO-8601
  messagingWindowExpiresAt: string | null; // ISO-8601
  autoReplyPaused: boolean;
  autoReplyPermanentlyDisabled: boolean;
  autoReplyConsecutiveCount: number;
  isGhost: boolean;
  ghostStatus: GhostStatus;
  throttleState: SurgeThrottleState;
  accountRevoked: boolean;
  relatedObjectRefs: RelatedObjectRef[];
  createdAt: string; // ISO-8601
  updatedAt: string; // ISO-8601
}

export interface Message {
  id: string;
  workspaceId: string;
  threadId: string;
  subtype: MessageSubtype;
  sourcePlatform: string;
  body: string;
  authorDirection: AuthorDirection;
  authorEntityId?: string;
  authorUserId?: string;
  moderationState: string;
  intentOverlay?: string;
  attachments: string[];
  externalMessageId?: string;
  createdAt: string; // ISO-8601
}

export interface Entity {
  id: string;
  workspaceId: string;
  entityType: 'customer' | 'creator' | 'brand' | 'agency' | 'internal';
  displayName: string;
  platformHandles: string[];
  relationshipState: 'lead' | 'active_customer' | 'vip' | 'churned' | 'partner' | 'blocked';
  tags: string[];
  metadata: Record<string, string>;
  createdAt: string;
  updatedAt: string;
}

export interface FollowUpTask {
  id: string;
  workspaceId: string;
  sourceThreadId: string;
  sourceObjectType?: string;
  sourceObjectId?: string;
  assignedUserId: string;
  taskType: string;
  title: string;
  description: string;
  dueAt: string | null; // ISO-8601
  status: 'pending' | 'in_progress' | 'completed' | 'cancelled';
  outcomeSummary?: string;
  taskRef?: string;
  phase?: string;
  isP6Deferred?: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface SuggestedReply {
  id: string;
  body: string;
  confidenceScore: number;
  tone: 'professional' | 'friendly' | 'concise' | 'urgent';
}

export interface WhatWhyNextNotice {
  what: string;
  why: string;
  next: string;
}

export interface ComposeValidationResult {
  canSend: boolean;
  reason?: string;
  windowRemainingMs?: number;
  ghostNotice?: WhatWhyNextNotice;
  accountRevokedNotice?: {
    message: string;
    action: string;
  };
  botLoopNotice?: {
    isPaused: boolean;
    isPermanentlyDisabled: boolean;
    message: string;
  };
}

export interface SurgeBannerState {
  level: 'none' | 'warning' | 'circuit_breaker';
  message: string;
  aiActive: boolean;
  rawIngestOnly: boolean;
}
