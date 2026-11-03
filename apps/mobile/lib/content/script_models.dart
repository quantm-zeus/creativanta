import 'package:creativanta_mobile/generated/creativanta/content/v1/script.pbenum.dart';

/// Shot Item within a scene per §6.6.
class ShotItem {
  const ShotItem({
    required this.shotId,
    required this.sceneId,
    required this.workspaceId,
    required this.shotIndex,
    required this.shotType,
    required this.description,
    required this.durationSeconds,
    this.createdAt,
  });

  final String shotId;
  final String sceneId;
  final String workspaceId;
  final int shotIndex;
  final String shotType;
  final String description;
  final int durationSeconds;
  final DateTime? createdAt;
}

/// Structured Scene Item per §6.6.
class SceneItem {
  const SceneItem({
    required this.sceneId,
    required this.scriptId,
    required this.workspaceId,
    required this.sceneIndex,
    required this.description,
    required this.content,
    required this.durationSeconds,
    this.visualNotes = '',
    this.audioNotes = '',
    this.shotList = const [],
    this.createdAt,
  });

  final String sceneId;
  final String scriptId;
  final String workspaceId;
  final int sceneIndex;
  final String description;
  final String content;
  final int durationSeconds;
  final String visualNotes;
  final String audioNotes;
  final List<ShotItem> shotList;
  final DateTime? createdAt;
}

/// Call To Action Block Item.
class CtaBlockItem {
  const CtaBlockItem({
    required this.ctaId,
    required this.text,
    this.buttonText = '',
    this.destinationUrl = '',
    this.ctaType = 'link',
  });

  final String ctaId;
  final String text;
  final String buttonText;
  final String destinationUrl;
  final String ctaType;
}

/// Legal Disclosure Block per RULE-M06-007.
class DisclosureBlockItem {
  const DisclosureBlockItem({
    required this.disclosureId,
    required this.text,
    required this.platform,
    this.isDismissed = false,
    this.dismissedBy,
    this.dismissedAt,
    this.dismissalReason,
  });

  final String disclosureId;
  final String text;
  final String platform;
  final bool isDismissed;
  final String? dismissedBy;
  final DateTime? dismissedAt;
  final String? dismissalReason;
}

/// Asset Brief Item per database_schema.md §6.5.
class AssetBriefItem {
  const AssetBriefItem({
    required this.assetBriefId,
    required this.workspaceId,
    required this.scriptId,
    required this.outputType,
    required this.targetFormat,
    required this.targetDurationSeconds,
    this.targetPlatforms = const [],
    required this.continuityRequirementsJson,
    this.brandVoiceRequirementsJson = '',
    this.productionInstructions = '',
    this.status = AssetBriefStatus.ASSET_BRIEF_STATUS_DRAFT,
    this.createdAt,
    this.updatedAt,
  });

  final String assetBriefId;
  final String workspaceId;
  final String scriptId;
  final String outputType;
  final String targetFormat;
  final int targetDurationSeconds;
  final List<String> targetPlatforms;
  final String continuityRequirementsJson;
  final String brandVoiceRequirementsJson;
  final String productionInstructions;
  final AssetBriefStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

/// Script Item per database_schema.md §6.4.
class ScriptItem {
  const ScriptItem({
    required this.scriptId,
    required this.workspaceId,
    this.ideaId,
    this.sourceIdeaTitle,
    required this.title,
    required this.formatType,
    this.scenes = const [],
    this.ctaBlocks = const [],
    this.disclosureBlocks = const [],
    this.durationTargetSeconds = 60,
    this.lifecycleState = ScriptLifecycleState.SCRIPT_LIFECYCLE_STATE_DRAFT,
    this.approvalState = ScriptApprovalState.SCRIPT_APPROVAL_STATE_UNSPECIFIED,
    this.publishTargetProfiles = const [],
    this.continuityRefs = const [],
    this.offerProductHooks = const [],
    this.rejectionReason,
    this.versionIndex = 1,
    required this.createdBy,
    this.approvedBy,
    this.createdAt,
    this.updatedAt,
  });

  final String scriptId;
  final String workspaceId;
  final String? ideaId;
  final String? sourceIdeaTitle;
  final String title;
  final String formatType;
  final List<SceneItem> scenes;
  final List<CtaBlockItem> ctaBlocks;
  final List<DisclosureBlockItem> disclosureBlocks;
  final int durationTargetSeconds;
  final ScriptLifecycleState lifecycleState;
  final ScriptApprovalState approvalState;
  final List<String> publishTargetProfiles;
  final List<String> continuityRefs;
  final List<String> offerProductHooks;
  final String? rejectionReason;
  final int versionIndex;
  final String createdBy;
  final String? approvedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

// ---------------------------------------------------------------------------
// Business Rules & Acceptance Validation Helpers
// ---------------------------------------------------------------------------

/// Enforces EC-M06-001: Script must have at least one scene and no scene with empty content.
class SceneValidationResult {
  const SceneValidationResult({required this.isValid, this.errorMessage});
  final bool isValid;
  final String? errorMessage;
}

SceneValidationResult validateScenesForSubmission(List<SceneItem> scenes) {
  if (scenes.isEmpty) {
    return const SceneValidationResult(
      isValid: false,
      errorMessage: 'Kịch bản phải có ít nhất 1 phân cảnh trước khi gửi duyệt.',
    );
  }
  for (var i = 0; i < scenes.length; i++) {
    if (scenes[i].content.trim().isEmpty) {
      return SceneValidationResult(
        isValid: false,
        errorMessage: 'Phân cảnh #${i + 1} chưa có nội dung. Vui lòng hoàn thiện toàn bộ phân cảnh trước khi gửi duyệt (EC-M06-001).',
      );
    }
  }
  return const SceneValidationResult(isValid: true);
}

/// Enforces RULE-M06-002, EC-M06-002: Rejection reason must be ≥ 10 characters.
class RejectionValidationResult {
  const RejectionValidationResult({
    required this.isValid,
    required this.characterCount,
    this.errorMessage,
  });
  final bool isValid;
  final int characterCount;
  final String? errorMessage;
}

RejectionValidationResult validateRejectionReason(String reason) {
  final trimmed = reason.trim();
  if (trimmed.length < 10) {
    return RejectionValidationResult(
      isValid: false,
      characterCount: trimmed.length,
      errorMessage: 'Lý do từ chối phải có ít nhất 10 ký tự phản hồi cụ thể (RULE-M06-002, EC-M06-002).',
    );
  }
  return RejectionValidationResult(
    isValid: true,
    characterCount: trimmed.length,
  );
}

/// Enforces RULE-M06-005: Asset Brief completeness check.
bool isAssetBriefComplete(AssetBriefItem? brief) {
  if (brief == null) return false;
  if (brief.outputType.trim().isEmpty) return false;
  if (brief.targetFormat.trim().isEmpty) return false;
  if (brief.targetDurationSeconds <= 0) return false;
  final continuity = brief.continuityRequirementsJson.trim();
  if (continuity.isEmpty || continuity == '{}') return false;
  return true;
}

/// Enforces RULE-M06-005, RULE-M06-006, AC-2: Ready for production eligibility.
class ReadyForProductionResult {
  const ReadyForProductionResult({
    required this.isEligible,
    required this.reasons,
  });
  final bool isEligible;
  final List<String> reasons;
}

ReadyForProductionResult isReadyForProductionEligible(
  ScriptItem script,
  AssetBriefItem? brief,
) {
  final reasons = <String>[];

  if (script.approvalState != ScriptApprovalState.SCRIPT_APPROVAL_STATE_APPROVED) {
    reasons.add('Kịch bản chưa được người quản lý duyệt (Approval State phải là Approved).');
  }

  if (brief == null) {
    reasons.add('Chưa tạo Bản tóm tắt sản xuất (Asset Brief) liên kết với kịch bản.');
  } else if (!isAssetBriefComplete(brief)) {
    reasons.add('Bản tóm tắt sản xuất chưa hoàn chỉnh (thiếu định dạng, thời lượng hoặc yêu cầu tính liên tục).');
  }

  return ReadyForProductionResult(
    isEligible: reasons.isEmpty,
    reasons: reasons,
  );
}

/// Enforces EC-M06-003: Stale review detection.
bool isReviewStale(int currentVersion, int reviewerExpectedVersion) {
  if (reviewerExpectedVersion <= 0) return false;
  return currentVersion != reviewerExpectedVersion;
}

/// Total estimated duration across all scenes.
int calculateTotalDuration(List<SceneItem> scenes) {
  return scenes.fold<int>(0, (sum, sc) => sum + sc.durationSeconds);
}

/// Total words count across all scenes.
int calculateWordCount(List<SceneItem> scenes) {
  return scenes.fold<int>(0, (sum, sc) {
    final words = sc.content.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    return sum + words.length;
  });
}
