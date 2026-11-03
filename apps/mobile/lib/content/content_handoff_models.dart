import 'package:creativanta_mobile/content/script_models.dart';
import 'package:creativanta_mobile/generated/creativanta/content/v1/script.pbenum.dart';

/// Stage in the end-to-end creative workflow pipeline.
enum ContentPipelineStage {
  trend,
  opportunity,
  idea,
  script,
  assetBrief,
  production,
}

/// A single provenance node in the source lineage chain.
class SourceChainNode {
  const SourceChainNode({
    required this.stage,
    required this.id,
    required this.title,
    required this.status,
    this.score,
    this.author,
    this.timestamp,
    this.metadata = const {},
  });

  final ContentPipelineStage stage;
  final String id;
  final String title;
  final String status;
  final double? score;
  final String? author;
  final DateTime? timestamp;
  final Map<String, String> metadata;

  String get stageName {
    switch (stage) {
      case ContentPipelineStage.trend:
        return 'Xu hướng (Trend Radar)';
      case ContentPipelineStage.opportunity:
        return 'Cơ hội (Opportunity Board)';
      case ContentPipelineStage.idea:
        return 'Ý tưởng (Idea Engine)';
      case ContentPipelineStage.script:
        return 'Kịch bản (Script Lab)';
      case ContentPipelineStage.assetBrief:
        return 'Bản tóm tắt (Asset Brief)';
      case ContentPipelineStage.production:
        return 'Sản xuất (AI Studio)';
    }
  }
}

/// Complete end-to-end source chain lineage: Trend -> Opportunity -> Idea -> Script -> Asset Brief.
class SourceChainLineage {
  const SourceChainLineage({
    required this.workspaceId,
    required this.scriptId,
    this.trend,
    this.opportunity,
    this.idea,
    required this.script,
    this.assetBrief,
  });

  final String workspaceId;
  final String scriptId;
  final SourceChainNode? trend;
  final SourceChainNode? opportunity;
  final SourceChainNode? idea;
  final ScriptItem script;
  final AssetBriefItem? assetBrief;

  /// Ordered nodes for visual breadcrumb rendering.
  List<SourceChainNode> get nodes {
    final list = <SourceChainNode>[];
    if (trend != null) list.add(trend!);
    if (opportunity != null) list.add(opportunity!);
    if (idea != null) list.add(idea!);
    list.add(
      SourceChainNode(
        stage: ContentPipelineStage.script,
        id: script.scriptId,
        title: script.title,
        status: script.approvalState.name,
        author: script.createdBy,
        timestamp: script.updatedAt ?? script.createdAt,
      ),
    );
    if (assetBrief != null) {
      list.add(
        SourceChainNode(
          stage: ContentPipelineStage.assetBrief,
          id: assetBrief!.assetBriefId,
          title: 'Asset Brief: ${assetBrief!.targetFormat}',
          status: assetBrief!.status.name,
          timestamp: assetBrief!.updatedAt ?? assetBrief!.createdAt,
        ),
      );
    }
    return list;
  }

  /// Whether the chain reaches an approved script and complete asset brief (AC-M06-002, RULE-M06-005).
  bool get reachesApprovedBrief {
    final isApproved = script.approvalState == ScriptApprovalState.SCRIPT_APPROVAL_STATE_APPROVED;
    final briefComplete = isAssetBriefComplete(assetBrief);
    return isApproved && briefComplete;
  }

  /// Production readiness evaluation.
  ReadyForProductionResult evaluateProductionReadiness() {
    return isReadyForProductionEligible(script, assetBrief);
  }
}

/// Status of concurrent review conflict (EC-M06-003).
class ConcurrentReviewStatus {
  const ConcurrentReviewStatus({
    required this.scriptId,
    required this.currentVersion,
    required this.reviewerExpectedVersion,
    required this.hasConflict,
    this.conflictMessage,
  });

  final String scriptId;
  final int currentVersion;
  final int reviewerExpectedVersion;
  final bool hasConflict;
  final String? conflictMessage;

  factory ConcurrentReviewStatus.evaluate({
    required String scriptId,
    required int currentVersion,
    required int reviewerExpectedVersion,
  }) {
    final isStale = isReviewStale(currentVersion, reviewerExpectedVersion);
    return ConcurrentReviewStatus(
      scriptId: scriptId,
      currentVersion: currentVersion,
      reviewerExpectedVersion: reviewerExpectedVersion,
      hasConflict: isStale,
      conflictMessage: isStale
          ? 'Xung đột phiên bản: Tác giả đã cập nhật lên v$currentVersion sau khi bạn mở xem v$reviewerExpectedVersion. Vui lòng tải lại dữ liệu để duyệt nội dung mới nhất (EC-M06-003).'
          : null,
    );
  }
}

/// Creative Assistant Safety Guard against accidental publish side effects.
/// Creative Assistant & Copilot are strictly limited to drafting/editing scripts.
/// All post publishing and scheduling belong strictly to M11 Publish Hub (Phase P5).
class CreativeAssistantPublishCheck {
  const CreativeAssistantPublishCheck({
    required this.prompt,
    required this.hasPublishIntent,
    this.blockedReason,
  });

  final String prompt;
  final bool hasPublishIntent;
  final String? blockedReason;

  static const List<String> publishKeywords = [
    'publish',
    'đăng bài',
    'dang bai',
    'đăng video',
    'dang video',
    'đăng lên',
    'schedule',
    'lên lịch',
    'len lich',
    'post to',
    'post on',
    'upload to',
    'tiktok upload',
    'broadcast',
    'phát sóng',
    'auto-post',
  ];

  /// Scans prompt for publish/scheduling intent.
  static CreativeAssistantPublishCheck inspect(String prompt) {
    final lower = prompt.toLowerCase();
    for (final kw in publishKeywords) {
      if (lower.contains(kw)) {
        return CreativeAssistantPublishCheck(
          prompt: prompt,
          hasPublishIntent: true,
          blockedReason: 'Trợ lý sáng tạo chỉ hỗ trợ soạn thảo và tinh chỉnh kịch bản (Script Lab M06). Chức năng đăng bài và lên lịch phát hành thuộc Trung tâm phát hành M11 (Module M11 Publish Hub - Phase P5). Không có lệnh xuất bản nào được thực thi.',
        );
      }
    }
    return CreativeAssistantPublishCheck(
      prompt: prompt,
      hasPublishIntent: false,
    );
  }
}
