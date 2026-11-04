// apps/mobile/lib/engagement/engagement_models.dart
// Domain models for M12 Unified Inbox & Engagement Center (Mobile).
// Follows docs/02_features/engagement/unified_inbox.md and docs/04_contracts/database_schema.md §9.

/// Exception thrown when an engagement operation fails validation.
class EngagementValidationException implements Exception {
  EngagementValidationException(this.message);
  final String message;

  @override
  String toString() => 'EngagementValidationException: $message';
}

/// Acceptance Target 1: Exception thrown when outbound reply is attempted outside 24h window.
class MessagingWindowExpiredException extends EngagementValidationException {
  MessagingWindowExpiredException([
    super.message = '24-hour messaging window expired. Awaiting customer re-engagement.',
  ]);
}

/// Acceptance Target 3: Exception thrown when target account OAuth is revoked.
class AccountRevokedException extends EngagementValidationException {
  AccountRevokedException([
    super.message = 'Connected account authorization revoked. Please reconnect in Settings.',
  ]);
}

/// Canonical WHAT-WHY-NEXT notice for ghost messages and platform restrictions (Pack 05 A4).
class WhatWhyNextNotice {
  const WhatWhyNextNotice({
    required this.what,
    required this.why,
    required this.next,
  });

  final String what;
  final String why;
  final String next;
}

/// Connected Account representing the identity used to reply (RULE-M12-006).
class ConnectedAccountModel {
  const ConnectedAccountModel({
    required this.id,
    required this.workspaceId,
    required this.platform,
    required this.accountName,
    required this.avatarUrl,
    required this.badgeColor,
    this.isRevoked = false,
  });

  final String id;
  final String workspaceId;
  final String platform;
  final String accountName;
  final String avatarUrl;
  final String badgeColor;
  final bool isRevoked;
}

/// Mobile domain model for Thread (database_schema.md §9.2).
class ThreadModel {
  const ThreadModel({
    required this.id,
    required this.workspaceId,
    required this.connectedAccountId,
    required this.sourcePlatform,
    required this.threadType,
    required this.status,
    required this.intent,
    required this.priority,
    required this.ownerUserId,
    required this.nextAction,
    this.slaDueAt,
    this.slaBreached = false,
    this.slaApproaching = false,
    this.messageCount = 0,
    required this.lastActivityAt,
    this.messagingWindowExpiresAt,
    this.autoReplyPaused = false,
    this.autoReplyPermanentlyDisabled = false,
    this.autoReplyConsecutiveCount = 0,
    this.isGhost = false,
    this.ghostStatus = 'active',
    this.throttleState = 'NORMAL',
    this.accountRevoked = false,
    this.relatedObjectRefs = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String workspaceId;
  final String connectedAccountId;
  final String sourcePlatform;
  final String threadType;
  final String status;
  final String intent;
  final String priority;
  final String ownerUserId;
  final String nextAction;
  final DateTime? slaDueAt;
  final bool slaBreached;
  final bool slaApproaching;
  final int messageCount;
  final DateTime lastActivityAt;
  final DateTime? messagingWindowExpiresAt;
  final bool autoReplyPaused;
  final bool autoReplyPermanentlyDisabled;
  final int autoReplyConsecutiveCount;
  final bool isGhost;
  final String ghostStatus; // 'active' | 'deleted_by_user' | 'restricted_by_platform' | 'permanently_removed'
  final String throttleState; // 'NORMAL' | 'THROTTLED' | 'CIRCUIT_BREAKER'
  final bool accountRevoked;
  final List<String> relatedObjectRefs;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Acceptance Target 1: Validates if the 24-hour reply window is currently open.
  bool isWindowOpen(DateTime now) {
    if (messagingWindowExpiresAt == null) return false;
    return now.isBefore(messagingWindowExpiresAt!);
  }

  /// Calculates remaining duration in 24-hour reply window.
  Duration remainingWindow(DateTime now) {
    if (messagingWindowExpiresAt == null) return Duration.zero;
    if (now.isAfter(messagingWindowExpiresAt!)) return Duration.zero;
    return messagingWindowExpiresAt!.difference(now);
  }

  /// Acceptance Target 3: True if compose box should be disabled due to ghost message.
  bool get isGhostBlocked =>
      isGhost &&
      (ghostStatus == 'deleted_by_user' ||
          ghostStatus == 'restricted_by_platform' ||
          ghostStatus == 'permanently_removed');

  /// Acceptance Target 2: True if auto-reply bot loop is tripped or permanently disabled.
  bool get isBotLoopBlocked =>
      autoReplyPaused || autoReplyPermanentlyDisabled;

  ThreadModel copyWith({
    String? status,
    String? ownerUserId,
    String? nextAction,
    DateTime? slaDueAt,
    bool? slaBreached,
    bool? slaApproaching,
    int? messageCount,
    DateTime? lastActivityAt,
    DateTime? messagingWindowExpiresAt,
    bool? autoReplyPaused,
    bool? autoReplyPermanentlyDisabled,
    int? autoReplyConsecutiveCount,
    bool? isGhost,
    String? ghostStatus,
    String? throttleState,
    bool? accountRevoked,
    List<String>? relatedObjectRefs,
    DateTime? updatedAt,
  }) {
    return ThreadModel(
      id: id,
      workspaceId: workspaceId,
      connectedAccountId: connectedAccountId,
      sourcePlatform: sourcePlatform,
      threadType: threadType,
      status: status ?? this.status,
      intent: intent,
      priority: priority,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      nextAction: nextAction ?? this.nextAction,
      slaDueAt: slaDueAt ?? this.slaDueAt,
      slaBreached: slaBreached ?? this.slaBreached,
      slaApproaching: slaApproaching ?? this.slaApproaching,
      messageCount: messageCount ?? this.messageCount,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      messagingWindowExpiresAt:
          messagingWindowExpiresAt ?? this.messagingWindowExpiresAt,
      autoReplyPaused: autoReplyPaused ?? this.autoReplyPaused,
      autoReplyPermanentlyDisabled:
          autoReplyPermanentlyDisabled ?? this.autoReplyPermanentlyDisabled,
      autoReplyConsecutiveCount:
          autoReplyConsecutiveCount ?? this.autoReplyConsecutiveCount,
      isGhost: isGhost ?? this.isGhost,
      ghostStatus: ghostStatus ?? this.ghostStatus,
      throttleState: throttleState ?? this.throttleState,
      accountRevoked: accountRevoked ?? this.accountRevoked,
      relatedObjectRefs: relatedObjectRefs ?? this.relatedObjectRefs,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Mobile domain model for Message (database_schema.md §9.3).
class MessageModel {
  const MessageModel({
    required this.id,
    required this.workspaceId,
    required this.threadId,
    required this.subtype,
    required this.sourcePlatform,
    required this.body,
    required this.authorDirection,
    this.authorEntityId,
    this.authorUserId,
    this.moderationState = 'visible',
    this.attachments = const [],
    required this.createdAt,
  });

  final String id;
  final String workspaceId;
  final String threadId;
  final String subtype;
  final String sourcePlatform;
  final String body;
  final String authorDirection; // 'inbound' | 'outbound' | 'internal' | 'system'
  final String? authorEntityId;
  final String? authorUserId;
  final String moderationState;
  final List<String> attachments;
  final DateTime createdAt;
}

/// Mobile domain model for Entity CRM Profile (database_schema.md §9.1).
class EntityModel {
  const EntityModel({
    required this.id,
    required this.workspaceId,
    required this.entityType,
    required this.displayName,
    this.platformHandles = const [],
    required this.relationshipState,
    this.tags = const [],
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String workspaceId;
  final String entityType;
  final String displayName;
  final List<String> platformHandles;
  final String relationshipState;
  final List<String> tags;
  final Map<String, String> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// Mobile domain model for Follow-up Task (database_schema.md §9.4).
class FollowUpTaskModel {
  const FollowUpTaskModel({
    required this.id,
    required this.workspaceId,
    required this.sourceThreadId,
    this.sourceObjectType,
    this.sourceObjectId,
    required this.assignedUserId,
    required this.taskType,
    required this.title,
    this.description = '',
    this.dueAt,
    required this.status,
    this.outcomeSummary = '',
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String workspaceId;
  final String sourceThreadId;
  final String? sourceObjectType;
  final String? sourceObjectId;
  final String assignedUserId;
  final String taskType;
  final String title;
  final String description;
  final DateTime? dueAt;
  final String status;
  final String outcomeSummary;
  final DateTime createdAt;
  final DateTime updatedAt;
}
