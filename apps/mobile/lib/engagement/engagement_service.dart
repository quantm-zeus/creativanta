// apps/mobile/lib/engagement/engagement_service.dart
// Mobile domain service for M12 Unified Inbox & Engagement Center.
// Implements client-side validation for:
// - Acceptance Target 1: Messaging-Window Denial (24h reply window)
// - Acceptance Target 2: Bot-Loop (RULE-M12-008) and Viral Surge Warning (RULE-M12-007)
// - Acceptance Target 3: Ghost Messages (WHAT-WHY-NEXT copy) and Account Reconnect
// - Swipe Triage (Archive, Snooze) and RULE-M12-003 State Machine

import 'engagement_models.dart';

class EngagementService {
  const EngagementService();

  /// Acceptance Target 1: Validates outbound reply within 24 hours of customer inbound.
  void validateMessagingWindow(ThreadModel thread, DateTime now) {
    if (!thread.isWindowOpen(now)) {
      throw MessagingWindowExpiredException(
        '24-hour messaging window expired. Awaiting customer re-engagement.',
      );
    }
  }

  /// Acceptance Target 3: Ghost message WHAT-WHY-NEXT notice (Pack 05 A4).
  WhatWhyNextNotice? getGhostNotice(ThreadModel thread) {
    if (!thread.isGhost) return null;

    switch (thread.ghostStatus) {
      case 'deleted_by_user':
        return const WhatWhyNextNotice(
          what: 'Tin nhắn đã bị người dùng xóa trên nền tảng gốc.',
          why: 'Nền tảng phản hồi mã 404/410 do nội dung không còn khả dụng.',
          next: 'Hộp soạn phản hồi bị khóa. Bạn có thể lưu trữ luồng này.',
        );
      case 'restricted_by_platform':
        return const WhatWhyNextNotice(
          what: 'Tin nhắn bị nền tảng giới hạn quyền truy cập.',
          why: 'Nền tảng phản hồi mã 403 do hạn chế tài khoản người gửi.',
          next: 'Không thể gửi phản hồi trực tiếp. Bạn có thể chuyển thành thẻ công việc.',
        );
      case 'permanently_removed':
        return const WhatWhyNextNotice(
          what: 'Nội dung đã bị xóa vĩnh viễn trên kênh liên kết.',
          why: 'Nền tảng trả về mã 410 Gone.',
          next: 'Luồng đã được chuyển sang trạng thái lưu trữ.',
        );
      default:
        return null;
    }
  }

  /// Acceptance Target 3: Revoked account reconnect notice.
  Map<String, String>? getRevokedAccountNotice(
    ThreadModel thread,
    ConnectedAccountModel? account,
  ) {
    if (thread.accountRevoked || (account != null && account.isRevoked)) {
      return {
        'message':
            'Tài khoản mạng xã hội này đã bị thu hồi quyền truy cập (OAuth token revoked).',
        'action': 'Vui lòng kết nối lại tài khoản trong Cài đặt Kênh.',
      };
    }
    return null;
  }

  /// Acceptance Target 2: Viral surge status evaluation (RULE-M12-007).
  Map<String, dynamic> getSurgeStatus(
    String throttleState,
    int rateMsgPerMin,
  ) {
    if (throttleState == 'CIRCUIT_BREAKER' || rateMsgPerMin > 500) {
      return {
        'level': 'circuit_breaker',
        'message':
            'Cảnh báo đột biến lưu lượng (>500 tin/phút): Tạm dừng AI phân loại. Hệ thống chỉ ghi nhận tin thô để đảm bảo SLA.',
        'aiActive': false,
        'rawIngestOnly': true,
      };
    }
    if (throttleState == 'THROTTLED' || rateMsgPerMin >= 100) {
      return {
        'level': 'warning',
        'message':
            'Lưu lượng tin nhắn tăng cao (100–500 tin/phút): Đang chuyển sang xử lý AI theo lô mỗi 5 phút.',
        'aiActive': false,
        'rawIngestOnly': false,
      };
    }
    return {
      'level': 'none',
      'message': 'Bình thường. Phân tích AI và trả lời gợi ý đang bật.',
      'aiActive': true,
      'rawIngestOnly': false,
    };
  }

  /// Master compose send validation for mobile.
  void validateCanSend({
    required ThreadModel thread,
    required ConnectedAccountModel? account,
    required String body,
    bool isAutoReply = false,
    required DateTime now,
  }) {
    if (body.trim().isEmpty) {
      throw EngagementValidationException('Nội dung phản hồi không được để trống.');
    }

    // Acceptance Target 3: Account Revoked
    if (thread.accountRevoked || (account != null && account.isRevoked)) {
      throw AccountRevokedException(
        'Tài khoản mạng xã hội đã bị thu hồi quyền truy cập. Vui lòng kết nối lại.',
      );
    }

    // Acceptance Target 3: Ghost Message
    if (thread.isGhostBlocked) {
      throw EngagementValidationException(
        'Không thể gửi tin nhắn vào luồng hội thoại đã bị xóa hoặc giới hạn trên nền tảng gốc.',
      );
    }

    // Acceptance Target 1: 24h Messaging Window
    validateMessagingWindow(thread, now);

    // Acceptance Target 2: Bot-loop circuit breaker
    if (isAutoReply && thread.isBotLoopBlocked) {
      throw EngagementValidationException(
        'Tự động phản hồi bị khóa do vòng lặp bot trên luồng này.',
      );
    }
  }

  /// RULE-M12-003: State machine validation.
  bool validateStatusTransition(String from, String to) {
    if (from == to) return true;
    switch (from) {
      case 'new':
        return to == 'triaged' || to == 'active' || to == 'archived' || to == 'snoozed';
      case 'triaged':
        return to == 'active' || to == 'archived' || to == 'snoozed';
      case 'active':
        return [
          'waiting_on_user',
          'waiting_on_team',
          'snoozed',
          'stale',
          'converted_to_task',
          'resolved',
          'archived',
        ].contains(to);
      case 'waiting_on_user':
      case 'waiting_on_team':
        return ['active', 'resolved', 'archived', 'snoozed', 'stale'].contains(to);
      case 'snoozed':
      case 'stale':
      case 'converted_to_task':
        return ['active', 'archived', 'resolved'].contains(to);
      case 'resolved':
        return ['active', 'archived'].contains(to);
      case 'archived':
        return false; // Terminal
      default:
        return false;
    }
  }

  /// Mobile swipe action: Archive thread (RULE-M12-003).
  ThreadModel swipeArchive(ThreadModel thread, DateTime now) {
    if (!validateStatusTransition(thread.status, 'archived')) {
      throw EngagementValidationException(
        'Không thể chuyển từ trạng thái ${thread.status} sang archived.',
      );
    }
    return thread.copyWith(status: 'archived', updatedAt: now);
  }

  /// Mobile swipe action: Snooze thread (RULE-M12-003).
  ThreadModel swipeSnooze(ThreadModel thread, Duration duration, DateTime now) {
    if (!validateStatusTransition(thread.status, 'snoozed')) {
      throw EngagementValidationException(
        'Không thể chuyển từ trạng thái ${thread.status} sang snoozed.',
      );
    }
    return thread.copyWith(
      status: 'snoozed',
      slaDueAt: now.add(duration),
      updatedAt: now,
    );
  }

  /// Target 3: Converts a thread intent into a Sample Request task linked to P6 Seeding CRM (P6-09).
  Map<String, dynamic> convertToSampleRequest({
    required ThreadModel thread,
    required String sampleRequestId,
    required DateTime now,
  }) {
    final updatedThread = thread.copyWith(
      status: 'converted_to_task',
      relatedObjectRefs: [
        ...thread.relatedObjectRefs,
        RelatedObjectRefModel(
          type: 'sample_request',
          id: sampleRequestId,
          taskRef: 'P6-09',
          phase: 'P6',
          isP6Deferred: true,
          status: 'pending_p6_delivery',
        ),
      ],
      updatedAt: now,
    );

    final task = FollowUpTaskModel(
      id: 'task_${now.millisecondsSinceEpoch}',
      workspaceId: thread.workspaceId,
      sourceThreadId: thread.id,
      sourceObjectType: 'sample_request',
      sourceObjectId: sampleRequestId,
      assignedUserId: thread.ownerUserId,
      taskType: 'sample_request',
      title: 'Fulfill sample request for thread ${thread.id}',
      description:
          'Sample request converted from inbound thread ${thread.id}. Awaiting P6 delivery execution.',
      status: 'pending',
      taskRef: 'P6-09',
      phase: 'P6',
      isP6Deferred: true,
      createdAt: now,
      updatedAt: now,
    );

    return {'thread': updatedThread, 'task': task};
  }

  /// Target 3: Converts a thread intent into a Brand Deal task linked to P6 Brand Deals (P6-09).
  Map<String, dynamic> convertToBrandDeal({
    required ThreadModel thread,
    required String brandDealId,
    required DateTime now,
  }) {
    final updatedThread = thread.copyWith(
      status: 'converted_to_task',
      relatedObjectRefs: [
        ...thread.relatedObjectRefs,
        RelatedObjectRefModel(
          type: 'brand_deal',
          id: brandDealId,
          taskRef: 'P6-09',
          phase: 'P6',
          isP6Deferred: true,
          status: 'pending_p6_delivery',
        ),
      ],
      updatedAt: now,
    );

    final task = FollowUpTaskModel(
      id: 'task_${now.millisecondsSinceEpoch}',
      workspaceId: thread.workspaceId,
      sourceThreadId: thread.id,
      sourceObjectType: 'brand_deal',
      sourceObjectId: brandDealId,
      assignedUserId: thread.ownerUserId,
      taskType: 'brand_deal',
      title: 'Follow up brand collaboration deal for thread ${thread.id}',
      description:
          'Brand collaboration converted from inbound thread ${thread.id}. Awaiting P6 delivery execution.',
      status: 'pending',
      taskRef: 'P6-09',
      phase: 'P6',
      isP6Deferred: true,
      createdAt: now,
      updatedAt: now,
    );

    return {'thread': updatedThread, 'task': task};
  }

  /// Target 3: Converts a thread intent into an Offer task linked to P6 Monetization OS (P6-01).
  Map<String, dynamic> convertToOffer({
    required ThreadModel thread,
    required String offerId,
    required DateTime now,
  }) {
    final updatedThread = thread.copyWith(
      status: 'converted_to_task',
      relatedObjectRefs: [
        ...thread.relatedObjectRefs,
        RelatedObjectRefModel(
          type: 'offer',
          id: offerId,
          taskRef: 'P6-01',
          phase: 'P6',
          isP6Deferred: true,
          status: 'pending_p6_delivery',
        ),
      ],
      updatedAt: now,
    );

    final task = FollowUpTaskModel(
      id: 'task_${now.millisecondsSinceEpoch}',
      workspaceId: thread.workspaceId,
      sourceThreadId: thread.id,
      sourceObjectType: 'offer',
      sourceObjectId: offerId,
      assignedUserId: thread.ownerUserId,
      taskType: 'offer',
      title: 'Provide exclusive offer for thread ${thread.id}',
      description:
          'Offer/coupon converted from inbound thread ${thread.id}. Awaiting P6 delivery execution.',
      status: 'pending',
      taskRef: 'P6-01',
      phase: 'P6',
      isP6Deferred: true,
      createdAt: now,
      updatedAt: now,
    );

    return {'thread': updatedThread, 'task': task};
  }
}
