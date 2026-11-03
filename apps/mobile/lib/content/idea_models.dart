import 'package:creativanta_mobile/generated/creativanta/content/v1/idea.pbenum.dart';

/// Provenance Source Item for M05 (RULE-M05-001, EC-M05-002).
class IdeaSourceItem {
  const IdeaSourceItem({
    required this.sourceType,
    required this.sourceId,
    required this.sourceTitle,
    this.sourceUrl,
    this.isArchived = false,
    this.archiveNotice,
  });

  final String sourceType; // trend, opportunity, product, thread, comment_cluster, objection, offer, manual
  final String sourceId;
  final String sourceTitle;
  final String? sourceUrl;
  final bool isArchived;
  final String? archiveNotice;

  String get displayLabel {
    switch (sourceType.toLowerCase()) {
      case 'trend':
        return 'Xu hướng (Trend)';
      case 'opportunity':
        return 'Cơ hội (Opportunity)';
      case 'product':
        return 'Sản phẩm (Product)';
      case 'comment_cluster':
        return 'Nhóm bình luận';
      case 'objection':
        return 'Góc phản biện';
      case 'manual':
        return 'Ghi chú thủ công';
      default:
        return sourceType;
    }
  }
}

/// Hook Item attached to an idea (§6.3).
class HookItem {
  const HookItem({
    required this.hookId,
    required this.hookText,
    required this.hookType,
    required this.effectivenessScore,
    this.usageCount = 0,
    required this.source,
  });

  final String hookId;
  final String hookText;
  final HookType hookType;
  final double effectivenessScore;
  final int usageCount;
  final HookSource source;
}

/// Duplicate warning model for M05 (>0.85 similarity warning, RULE-M05-005).
class DuplicateWarningItem {
  const DuplicateWarningItem({
    required this.isDuplicate,
    required this.similarityScore,
    required this.existingIdeaId,
    required this.existingIdeaTitle,
    required this.warningMessage,
  });

  final bool isDuplicate;
  final double similarityScore;
  final String existingIdeaId;
  final String existingIdeaTitle;
  final String warningMessage;
}

/// Mobile Idea Model for Module M05 (Idea Engine).
class IdeaItem {
  IdeaItem({
    required this.ideaId,
    required this.workspaceId,
    required this.title,
    this.description = '',
    this.audienceIntent = '',
    this.creatorIntent = '',
    this.suggestedFormat = '',
    this.suggestedDirection = '',
    required this.status,
    required this.ideaScore,
    required this.createdBy,
    required this.sources,
    this.hooks = const [],
    required this.createdAt,
    required this.updatedAt,
    this.convertedToType,
    this.convertedToId,
  });

  final String ideaId;
  final String workspaceId;
  String title;
  String description;
  String audienceIntent;
  String creatorIntent;
  String suggestedFormat;
  String suggestedDirection;
  IdeaStatus status;
  double ideaScore;
  final String createdBy;
  final List<IdeaSourceItem> sources;
  final List<HookItem> hooks;
  final DateTime createdAt;
  DateTime updatedAt;
  String? convertedToType;
  String? convertedToId;

  /// Acceptance Target 3: Mobile title-only draft creation.
  /// Given a mobile user enters only a title and saves, the system creates
  /// a draft idea with the title — no description or format is required.
  factory IdeaItem.createMobileQuickCapture({
    required String workspaceId,
    required String userId,
    required String title,
    String? ideaId,
  }) {
    final now = DateTime.now().toUtc();
    final generatedId = ideaId ?? 'idea-mob-${now.millisecondsSinceEpoch}';

    // RULE-M05-001: Every idea links to at least one source ref.
    // Manual mobile capture uses source_type = 'manual' with source_id = userId.
    final manualSource = IdeaSourceItem(
      sourceType: 'manual',
      sourceId: userId,
      sourceTitle: 'Mobile Quick Capture by $userId',
    );

    return IdeaItem(
      ideaId: generatedId,
      workspaceId: workspaceId,
      title: title.trim(),
      description: '', // Title-only draft: empty description is valid!
      audienceIntent: '',
      creatorIntent: '',
      suggestedFormat: '', // Title-only draft: empty format is valid!
      suggestedDirection: '',
      status: IdeaStatus.IDEA_STATUS_DRAFT,
      ideaScore: 70.0,
      createdBy: userId,
      sources: [manualSource],
      hooks: const [],
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Acceptance Target 1: Duplicate idea detection (>0.85 similarity).
  /// Warns without silent merge; user can choose to proceed or view existing.
  static DuplicateWarningItem? checkDuplicate({
    required String title,
    required List<IdeaItem> existingIdeas,
    double threshold = 0.85,
  }) {
    if (title.trim().isEmpty || existingIdeas.isEmpty) {
      return null;
    }

    IdeaItem? bestMatch;
    double maxSim = 0.0;

    for (final existing in existingIdeas) {
      final sim = calculateSimilarity(title, existing.title);
      if (sim >= threshold && sim > maxSim) {
        maxSim = sim;
        bestMatch = existing;
      }
    }

    if (bestMatch != null) {
      return DuplicateWarningItem(
        isDuplicate: true,
        similarityScore: maxSim,
        existingIdeaId: bestMatch.ideaId,
        existingIdeaTitle: bestMatch.title,
        warningMessage:
            'Đã có ý tưởng tương tự: "${bestMatch.title}" (độ tương đồng: ${(maxSim * 100).round()}%) — Bạn có muốn xem lại hay vẫn tiếp tục tạo?',
      );
    }

    return null;
  }

  /// Lexical / substring similarity metric.
  static double calculateSimilarity(String s1, String s2) {
    final c1 = s1.toLowerCase().trim();
    final c2 = s2.toLowerCase().trim();
    if (c1 == c2) return 1.0;
    if (c1.isEmpty || c2.isEmpty) return 0.0;

    final tokens1 = c1.split(RegExp(r'\s+')).toSet();
    final tokens2 = c2.split(RegExp(r'\s+')).toSet();

    final intersection = tokens1.intersection(tokens2).length;
    final union = tokens1.union(tokens2).length;
    if (union == 0) return 0.0;

    double jaccard = intersection / union;

    // Substring containment boost
    if (c1.contains(c2) || c2.contains(c1)) {
      if (jaccard < 0.88) {
        jaccard = 0.88;
      }
    }

    return jaccard > 1.0 ? 1.0 : jaccard;
  }

  /// EC-M05-004: Validate required fields before converting to script.
  /// Needs at least description and suggestedFormat.
  String? validateConversionEligibility() {
    if (description.trim().isEmpty) {
      return 'Ý tưởng cần có mô tả (description) trước khi chuyển sang kịch bản.';
    }
    if (suggestedFormat.trim().isEmpty) {
      return 'Ý tưởng cần có định dạng đề xuất (suggested_format) trước khi chuyển sang kịch bản.';
    }
    return null;
  }

  /// RULE-M05-002: Canonical state machine progression.
  /// draft → candidate → selected → converted | archived; archived → draft.
  bool canTransitionTo(IdeaStatus target) {
    if (status == target) return true;

    switch (status) {
      case IdeaStatus.IDEA_STATUS_DRAFT:
        return target == IdeaStatus.IDEA_STATUS_CANDIDATE ||
            target == IdeaStatus.IDEA_STATUS_ARCHIVED;
      case IdeaStatus.IDEA_STATUS_CANDIDATE:
        return target == IdeaStatus.IDEA_STATUS_SELECTED ||
            target == IdeaStatus.IDEA_STATUS_ARCHIVED;
      case IdeaStatus.IDEA_STATUS_SELECTED:
        return target == IdeaStatus.IDEA_STATUS_CONVERTED ||
            target == IdeaStatus.IDEA_STATUS_ARCHIVED;
      case IdeaStatus.IDEA_STATUS_ARCHIVED:
        return target == IdeaStatus.IDEA_STATUS_DRAFT;
      case IdeaStatus.IDEA_STATUS_CONVERTED:
        return false;
      default:
        return false;
    }
  }
}
