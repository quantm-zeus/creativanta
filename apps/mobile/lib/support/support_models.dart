// Creativanta P8-04 — Mobile Support, SLAs, Beta Program & Status Models
// Implements canonical contracts per legal_compliance.md §7.2, help_center.md §4, §5, §7.

enum SupportPriority { urgent, high, normal, low }

enum TicketStatus { open, inProgress, waitingUser, resolved, closed }

class SupportSLA {
  final String tier;
  final int responseHours;
  final int resolutionHours;

  const SupportSLA({
    required this.tier,
    required this.responseHours,
    required this.resolutionHours,
  });

  int get responseDueMinutes => responseHours * 60;
  int get resolutionDueMinutes => resolutionHours * 60;

  /// Canonical Support SLAs per legal_compliance.md §7.2:
  /// - Free: First response 48h, resolution 5 days (120h)
  /// - Starter: First response 24h, resolution 3 days (72h)
  /// - Pro: First response 8h, resolution 1 day (24h)
  /// - Business: First response 2h, resolution 8h
  /// - Enterprise: First response 1h, resolution 4h
  static SupportSLA calculate(String tier) {
    switch (tier.toLowerCase().trim()) {
      case 'enterprise':
        return const SupportSLA(tier: 'enterprise', responseHours: 1, resolutionHours: 4);
      case 'business':
        return const SupportSLA(tier: 'business', responseHours: 2, resolutionHours: 8);
      case 'pro':
        return const SupportSLA(tier: 'pro', responseHours: 8, resolutionHours: 24);
      case 'starter':
        return const SupportSLA(tier: 'starter', responseHours: 24, resolutionHours: 72);
      case 'free':
      default:
        return const SupportSLA(tier: 'free', responseHours: 48, resolutionHours: 120);
    }
  }
}

class TicketMessage {
  final String id;
  final String authorId;
  final String authorRole; // 'user' | 'agent' | 'admin' | 'system'
  final String body;
  final bool isInternalNote; // Strictly isolated from tenant/workspace users!
  final DateTime createdAt;

  TicketMessage({
    required this.id,
    required this.authorId,
    required this.authorRole,
    required this.body,
    this.isInternalNote = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'author_id': authorId,
        'author_role': authorRole,
        'body': body,
        'is_internal_note': isInternalNote,
        'created_at': createdAt.toIso8601String(),
      };
}

class SupportTicket {
  final String id;
  final String ticketNumber;
  final String workspaceId;
  final String subject;
  final SupportPriority priority;
  TicketStatus status;
  final String planTier;
  final SupportSLA sla;
  final DateTime createdAt;
  DateTime? firstResponseAt;
  DateTime? resolvedAt;
  int? csatScore; // 1-5
  final List<TicketMessage> messages;

  SupportTicket({
    required this.id,
    required this.ticketNumber,
    required this.workspaceId,
    required this.subject,
    this.priority = SupportPriority.normal,
    this.status = TicketStatus.open,
    required this.planTier,
    DateTime? createdAt,
    this.firstResponseAt,
    this.resolvedAt,
    this.csatScore,
    List<TicketMessage>? messages,
  })  : sla = SupportSLA.calculate(planTier),
        createdAt = createdAt ?? DateTime.now(),
        messages = messages ?? [];

  /// Check if first response has breached the SLA
  bool isResponseBreached([DateTime? now]) {
    final ref = now ?? DateTime.now();
    if (firstResponseAt != null) {
      final elapsedMinutes = firstResponseAt!.difference(createdAt).inMinutes;
      return elapsedMinutes > sla.responseDueMinutes;
    }
    final elapsedMinutes = ref.difference(createdAt).inMinutes;
    return elapsedMinutes > sla.responseDueMinutes;
  }

  /// Check if resolution has breached the SLA
  bool isResolutionBreached([DateTime? now]) {
    final ref = now ?? DateTime.now();
    if (resolvedAt != null) {
      final elapsedMinutes = resolvedAt!.difference(createdAt).inMinutes;
      return elapsedMinutes > sla.resolutionDueMinutes;
    }
    if (status == TicketStatus.resolved || status == TicketStatus.closed) {
      return false;
    }
    final elapsedMinutes = ref.difference(createdAt).inMinutes;
    return elapsedMinutes > sla.resolutionDueMinutes;
  }

  /// Strict isolation guarantee: tenant workspace users NEVER receive internal notes!
  SupportTicket sanitizeForWorkspace() {
    final visibleMessages = messages.where((m) => !m.isInternalNote).toList();
    return SupportTicket(
      id: id,
      ticketNumber: ticketNumber,
      workspaceId: workspaceId,
      subject: subject,
      priority: priority,
      status: status,
      planTier: planTier,
      createdAt: createdAt,
      firstResponseAt: firstResponseAt,
      resolvedAt: resolvedAt,
      csatScore: csatScore,
      messages: visibleMessages,
    );
  }
}

/// Beta Program State Machine & "Beta Grant Once" logic
class BetaEnrollmentResult {
  final bool success;
  final int creditsAwarded;
  final String message;
  final List<String> enabledFlags;

  const BetaEnrollmentResult({
    required this.success,
    required this.creditsAwarded,
    required this.message,
    required this.enabledFlags,
  });
}

class BetaProgramManager {
  final Map<String, bool> _hasEverEnrolled = {};
  final Map<String, bool> _activeEnrollments = {};

  static const List<String> canonicalBetaFlags = [
    'beta_video_continuity',
    'beta_live_radar',
    'beta_recipe_v2',
  ];

  /// Enrolls a workspace into the Beta program (§4)
  /// - Free tier is rejected (Starter+ required)
  /// - Beta Grant Once: 50 credits awarded on first enrollment, 0 on re-enrollment
  BetaEnrollmentResult enroll(String workspaceId, String planTier) {
    final tier = planTier.toLowerCase().trim();
    if (tier == 'free' || tier.isEmpty) {
      throw ArgumentError('Gói Free không đủ điều kiện tham gia Beta. Vui lòng nâng cấp từ Starter.');
    }

    final hasEnrolledBefore = _hasEverEnrolled[workspaceId] ?? false;
    _activeEnrollments[workspaceId] = true;
    _hasEverEnrolled[workspaceId] = true;

    if (!hasEnrolledBefore) {
      return const BetaEnrollmentResult(
        success: true,
        creditsAwarded: 50,
        message: 'Đăng ký thành công! Đã cộng 50 AI credits trải nghiệm.',
        enabledFlags: canonicalBetaFlags,
      );
    } else {
      return const BetaEnrollmentResult(
        success: true,
        creditsAwarded: 0,
        message: 'Chào mừng trở lại! Đã kích hoạt lại cờ tính năng Beta.',
        enabledFlags: canonicalBetaFlags,
      );
    }
  }

  void optOut(String workspaceId) {
    _activeEnrollments[workspaceId] = false;
  }

  bool isEnrolled(String workspaceId) {
    return _activeEnrollments[workspaceId] ?? false;
  }
}

/// Status Component & Subscription Privacy Model (§5)
class StatusComponent {
  final String id;
  final String name;
  final String status;
  final int latencyMs;

  const StatusComponent({
    required this.id,
    required this.name,
    required this.status,
    required this.latencyMs,
  });
}

class StatusPrivacyManager {
  static const List<String> canonicalComponents = [
    'web_app',
    'mobile_backend',
    'public_api',
    'database',
    'ai_services',
    'platform_connectors',
    'payment_processing',
    'notification_delivery',
  ];

  int _subscriberCount = 100;

  int get subscriberCount => _subscriberCount;

  /// Subscription strictly preserves privacy: returns privacy token, never exposes target
  String subscribe(String channel, String target) {
    if (target.isEmpty) throw ArgumentError('Target cannot be empty');
    _subscriberCount++;
    return 'tok_priv_${target.hashCode.abs().toRadixString(16)}';
  }

  bool unsubscribe(String token) {
    if (!token.startsWith('tok_priv_')) {
      throw ArgumentError('Invalid privacy token');
    }
    if (_subscriberCount > 0) _subscriberCount--;
    return true;
  }
}
