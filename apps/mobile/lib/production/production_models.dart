/// Production mode specification (M07 AI Studio)
class ProductionModeModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int creditCost;
  final int durationSecs;
  final String? badge;

  const ProductionModeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.creditCost,
    required this.durationSecs,
    this.badge,
  });
}

const List<ProductionModeModel> kProductionModes = [
  ProductionModeModel(
    id: 'video_gen',
    title: 'AI Video Studio',
    description: 'Tạo video bán hàng từ kịch bản hoặc văn bản',
    icon: '🎬',
    creditCost: 80,
    durationSecs: 15,
    badge: 'Veo 2.0',
  ),
  ProductionModeModel(
    id: 'image_gen',
    title: 'AI Image Studio',
    description: 'Tạo ảnh sản phẩm chuẩn thương mại điện tử',
    icon: '🖼️',
    creditCost: 20,
    durationSecs: 0,
    badge: 'Imagen 3',
  ),
  ProductionModeModel(
    id: 'remix',
    title: 'Video Remix',
    description: 'Tái phối hợp video thành góc quay mới',
    icon: '🔄',
    creditCost: 40,
    durationSecs: 15,
  ),
  ProductionModeModel(
    id: 'avatar',
    title: 'AI Avatar Host',
    description: 'Người dẫn ảo đọc thoại khẩu hình tự nhiên',
    icon: '👤',
    creditCost: 60,
    durationSecs: 15,
  ),
  ProductionModeModel(
    id: 'voiceover',
    title: 'AI Voiceover',
    description: 'Lồng tiếng đa ngôn ngữ cảm xúc chân thực',
    icon: '🎙️',
    creditCost: 15,
    durationSecs: 30,
  ),
  ProductionModeModel(
    id: 'music',
    title: 'AI Sound & BGM',
    description: 'Soạn nhạc nền và sound effect độc quyền',
    icon: '🎵',
    creditCost: 15,
    durationSecs: 30,
  ),
  ProductionModeModel(
    id: 'subtitles',
    title: 'AI Subtitle',
    description: 'Phụ đề động tự động bắt tai',
    icon: '💬',
    creditCost: 10,
    durationSecs: 60,
  ),
  ProductionModeModel(
    id: 'thumbnail',
    title: 'AI Thumbnail',
    description: 'Ảnh bìa tối ưu CTR',
    icon: '✨',
    creditCost: 10,
    durationSecs: 0,
  ),
  ProductionModeModel(
    id: 'broll',
    title: 'AI B-Roll Insertion',
    description: 'Chèn cảnh đệm minh họa tự động',
    icon: '🎞️',
    creditCost: 35,
    durationSecs: 15,
  ),
  ProductionModeModel(
    id: 'quick_edit',
    title: 'Quick Edit',
    description: 'Biên tập video qua chỉnh sửa văn bản transcript',
    icon: '✂️',
    creditCost: 10,
    durationSecs: 30,
    badge: 'M014',
  ),
  ProductionModeModel(
    id: 'multi_merge',
    title: 'Multi-Merge Studio',
    description: 'Ghép nhiều video, hình ảnh và âm thanh thành video hoàn chỉnh',
    icon: '🎞️',
    creditCost: 25,
    durationSecs: 60,
    badge: 'M015',
  ),
  ProductionModeModel(
    id: 'batch_gen',
    title: 'Tạo hàng loạt (Batch)',
    description: 'Xử lý nhiều sản phẩm với kiểm duyệt ngân sách',
    icon: '📦',
    creditCost: 80,
    durationSecs: 15,
    badge: 'Batch',
  ),
];

/// Row input and validation result for batch budget preview
class BatchRowItem {
  final int index;
  final String itemId;
  final String itemName;
  final String prompt;
  final bool isValid;
  final String? validationError;
  final int estimatedCredits;
  final double estimatedCostUSD;

  const BatchRowItem({
    required this.index,
    required this.itemId,
    required this.itemName,
    required this.prompt,
    required this.isValid,
    this.validationError,
    required this.estimatedCredits,
    required this.estimatedCostUSD,
  });
}

/// Budget preview result for batch production
class BatchBudgetPreviewModel {
  final String quoteId;
  final DateTime quoteExpiresAt;
  final int totalItems;
  final int validCount;
  final int invalidCount;
  final int totalCredits;
  final double totalCostUSD;
  final int availableCredits;
  final bool sufficientCredits;
  final List<BatchRowItem> items;

  const BatchBudgetPreviewModel({
    required this.quoteId,
    required this.quoteExpiresAt,
    required this.totalItems,
    required this.validCount,
    required this.invalidCount,
    required this.totalCredits,
    required this.totalCostUSD,
    required this.availableCredits,
    required this.sufficientCredits,
    required this.items,
  });
}

/// Active or historical generation job item
class ProductionJobModel {
  final String jobId;
  final String assetId;
  final String title;
  final String prompt;
  final String provider; // 'veo' or 'kling'
  final String status; // 'queued', 'processing', 'completed', 'failed', 'cancelled'
  final String stage;
  final int progressPct;
  final int estimatedCredits;
  final int actualCredits;
  final double costCeilingUSD;
  final String? resultUrl;
  final String? errorMessage;

  const ProductionJobModel({
    required this.jobId,
    required this.assetId,
    required this.title,
    required this.prompt,
    required this.provider,
    required this.status,
    required this.stage,
    required this.progressPct,
    required this.estimatedCredits,
    required this.actualCredits,
    required this.costCeilingUSD,
    this.resultUrl,
    this.errorMessage,
  });

  ProductionJobModel copyWith({
    String? status,
    String? stage,
    int? progressPct,
    String? provider,
    String? errorMessage,
  }) {
    return ProductionJobModel(
      jobId: jobId,
      assetId: assetId,
      title: title,
      prompt: prompt,
      provider: provider ?? this.provider,
      status: status ?? this.status,
      stage: stage ?? this.stage,
      progressPct: progressPct ?? this.progressPct,
      estimatedCredits: estimatedCredits,
      actualCredits: actualCredits,
      costCeilingUSD: costCeilingUSD,
      resultUrl: resultUrl,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Helper to compute partial batch budget preview
BatchBudgetPreviewModel evaluateBatchPreview({
  required List<Map<String, String>> rawItems,
  double rateUSDPerSec = 0.04,
  int availableCredits = 100,
}) {
  final List<BatchRowItem> evaluated = [];
  int validCount = 0;
  int invalidCount = 0;

  for (int i = 0; i < rawItems.length; i++) {
    final item = rawItems[i];
    final name = (item['name'] ?? '').trim();
    final prompt = (item['prompt'] ?? '').trim();
    final itemId = item['id'] ?? 'item-${i + 1}';

    String? error;
    if (name.length < 2) {
      error = 'Tên sản phẩm phải có ít nhất 2 ký tự';
    } else if (prompt.length < 5) {
      error = 'Prompt miêu tả phải có ít nhất 5 ký tự';
    }

    final isValid = error == null;
    if (isValid) {
      validCount++;
      const credits = 80;
      final cost = 15 * rateUSDPerSec;
      evaluated.add(BatchRowItem(
        index: i,
        itemId: itemId,
        itemName: name,
        prompt: prompt,
        isValid: true,
        estimatedCredits: credits,
        estimatedCostUSD: cost,
      ));
    } else {
      invalidCount++;
      evaluated.add(BatchRowItem(
        index: i,
        itemId: itemId,
        itemName: name.isEmpty ? 'Mục #${i + 1}' : name,
        prompt: prompt,
        isValid: false,
        validationError: error,
        estimatedCredits: 0, // Invalid items are charged 0 credits
        estimatedCostUSD: 0.0,
      ));
    }
  }

  final totalCredits = validCount * 80;
  final totalCostUSD = validCount * 15 * rateUSDPerSec;

  return BatchBudgetPreviewModel(
    quoteId: 'quote-mob-${DateTime.now().millisecondsSinceEpoch}',
    quoteExpiresAt: DateTime.now().add(const Duration(minutes: 5)),
    totalItems: rawItems.length,
    validCount: validCount,
    invalidCount: invalidCount,
    totalCredits: totalCredits,
    totalCostUSD: totalCostUSD,
    availableCredits: availableCredits,
    sufficientCredits: availableCredits >= totalCredits,
    items: evaluated,
  );
}

// ============================================================================
// Multi-Merge and AI Remix Mobile Models & Validators (P4-04)
// ============================================================================

const double kCanonicalSimilarityThreshold = 30.0;

class OriginalityCheckModel {
  final double similarityPercentage;
  final double canonicalThresholdPercentage;
  final double originalityScore;
  final bool passed;
  final String explanation;
  final List<String> actionableAlternatives;

  const OriginalityCheckModel({
    required this.similarityPercentage,
    this.canonicalThresholdPercentage = kCanonicalSimilarityThreshold,
    required this.originalityScore,
    required this.passed,
    required this.explanation,
    this.actionableAlternatives = const [],
  });
}

OriginalityCheckModel evaluateRemixOriginality(double similarityPercentage) {
  final passed = similarityPercentage < kCanonicalSimilarityThreshold;
  final originalityScore = (100.0 - similarityPercentage).clamp(0.0, 100.0);
  if (!passed) {
    return OriginalityCheckModel(
      similarityPercentage: similarityPercentage,
      originalityScore: originalityScore,
      passed: false,
      explanation:
          'Remix is too similar to reference (${similarityPercentage.toStringAsFixed(1)}% similarity, max ${kCanonicalSimilarityThreshold.toStringAsFixed(1)}%). [Adjust to \'Loose Inspiration\' fidelity] or [Edit script manually].',
      actionableAlternatives: const [
        "Adjust to 'Loose Inspiration' fidelity",
        'Edit script manually',
        'Focus on a different angle or product benefit',
      ],
    );
  }
  return OriginalityCheckModel(
    similarityPercentage: similarityPercentage,
    originalityScore: originalityScore,
    passed: true,
    explanation:
        'Passed originality check: ${similarityPercentage.toStringAsFixed(1)}% similarity (threshold: <${kCanonicalSimilarityThreshold.toStringAsFixed(1)}%).',
  );
}

class ReferenceUrlValidation {
  final bool isValid;
  final bool isDRM;
  final bool isGeoBlocked;
  final String? errorMessage;
  final String? actionableAdvice;

  const ReferenceUrlValidation({
    required this.isValid,
    this.isDRM = false,
    this.isGeoBlocked = false,
    this.errorMessage,
    this.actionableAdvice,
  });
}

ReferenceUrlValidation validateReferenceUrl(String rawUrl) {
  final trimmed = rawUrl.trim();
  if (trimmed.isEmpty) {
    return const ReferenceUrlValidation(
      isValid: false,
      errorMessage: 'Video URL cannot be empty.',
      actionableAdvice:
          'Please paste a valid video URL or upload a file directly.',
    );
  }
  final uri = Uri.tryParse(trimmed);
  if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
    return const ReferenceUrlValidation(
      isValid: false,
      errorMessage: 'Invalid protocol. Must be HTTP or HTTPS.',
      actionableAdvice:
          'Cannot access video at this URL. [Upload video file instead] or [Try different URL].',
    );
  }
  final host = uri.host.toLowerCase();
  if (host == 'localhost' ||
      host == '127.0.0.1' ||
      host.startsWith('10.') ||
      host.startsWith('192.168.') ||
      host.startsWith('169.254.') ||
      host == '::1') {
    return const ReferenceUrlValidation(
      isValid: false,
      errorMessage:
          'Access to internal network destinations is forbidden (SSRF protection).',
      actionableAdvice:
          'Cannot access video at this URL. [Upload video file instead] or [Try different URL].',
    );
  }
  final lower = trimmed.toLowerCase();
  if (lower.contains('drm-protected') ||
      lower.contains('widevine') ||
      lower.contains('fairplay') ||
      lower.contains('netflix.com') ||
      lower.contains('disneyplus.com') ||
      lower.contains('drm=')) {
    return const ReferenceUrlValidation(
      isValid: false,
      isDRM: true,
      errorMessage:
          'Reference video is protected by Digital Rights Management (DRM).',
      actionableAdvice:
          'Cannot access video at this URL. [Upload video file instead] or [Try different URL].',
    );
  }
  if (lower.contains('geo-blocked') ||
      lower.contains('georestricted') ||
      lower.contains('geo-restricted') ||
      lower.contains('hulu.com') ||
      lower.contains('restricted-region')) {
    return const ReferenceUrlValidation(
      isValid: false,
      isGeoBlocked: true,
      errorMessage:
          'Reference video is restricted or geo-blocked in the server region.',
      actionableAdvice:
          'Cannot access video at this URL. [Upload video file instead] or [Try different URL].',
    );
  }
  return const ReferenceUrlValidation(isValid: true);
}

class MultiMergeItemModel {
  final String itemId;
  final String assetId;
  final String mediaType; // video, image, audio
  final String title;
  final double durationSeconds;
  final String? transitionToNext;
  final bool hasCopyrightHit;
  final String? licenseProofKey;

  const MultiMergeItemModel({
    required this.itemId,
    required this.assetId,
    required this.mediaType,
    required this.title,
    required this.durationSeconds,
    this.transitionToNext,
    this.hasCopyrightHit = false,
    this.licenseProofKey,
  });

  MultiMergeItemModel copyWith({
    String? itemId,
    String? assetId,
    String? mediaType,
    String? title,
    double? durationSeconds,
    String? transitionToNext,
    bool? hasCopyrightHit,
    String? licenseProofKey,
  }) {
    return MultiMergeItemModel(
      itemId: itemId ?? this.itemId,
      assetId: assetId ?? this.assetId,
      mediaType: mediaType ?? this.mediaType,
      title: title ?? this.title,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      transitionToNext: transitionToNext ?? this.transitionToNext,
      hasCopyrightHit: hasCopyrightHit ?? this.hasCopyrightHit,
      licenseProofKey: licenseProofKey ?? this.licenseProofKey,
    );
  }
}

int getTierMaxMedia(String tier) {
  switch (tier.toLowerCase()) {
    case 'business':
    case 'enterprise':
      return 50;
    case 'pro':
      return 20;
    case 'starter':
      return 10;
    case 'free':
    default:
      return 5;
  }
}

class MultiMergeValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<MultiMergeItemModel> processedItems;
  final bool hasUnlicensedCopyrightBlock;

  const MultiMergeValidationResult({
    required this.isValid,
    required this.errors,
    required this.processedItems,
    required this.hasUnlicensedCopyrightBlock,
  });
}

MultiMergeValidationResult validateMultiMergeTimeline(
    String tier, List<MultiMergeItemModel> items,
    {bool autoTransitions = true}) {
  final errors = <String>[];
  bool hasCopyrightBlock = false;

  if (items.length < 2) {
    errors.add('Multi-merge requires at least 2 media files.');
  }

  final maxAllowed = getTierMaxMedia(tier);
  if (items.length > maxAllowed) {
    errors.add('Item count (${items.length}) exceeds tier limit of $maxAllowed.');
  }

  final processed = <MultiMergeItemModel>[];
  for (int i = 0; i < items.length; i++) {
    var item = items[i];
    // Auto transition
    if (autoTransitions && i < items.length - 1) {
      final next = items[i + 1];
      if (item.mediaType == 'image' && next.mediaType == 'image') {
        item = item.copyWith(transitionToNext: 'ken_burns');
      } else if (item.mediaType == 'video' && next.mediaType == 'video') {
        item = item.copyWith(transitionToNext: 'crossfade');
      } else if (item.mediaType == 'image' && next.mediaType == 'video') {
        item = item.copyWith(transitionToNext: 'fade_in');
      } else {
        item = item.copyWith(transitionToNext: 'cut');
      }
    }

    if (item.hasCopyrightHit &&
        (item.licenseProofKey == null ||
            item.licenseProofKey!.trim().isEmpty)) {
      hasCopyrightBlock = true;
      errors.add(
          'Track "${item.title}" detected as copyrighted. Rights violations cannot be bypassed by accepting risk (SAFE-2026-02).');
    }
    processed.add(item);
  }

  return MultiMergeValidationResult(
    isValid: errors.isEmpty,
    errors: errors,
    processedItems: processed,
    hasUnlicensedCopyrightBlock: hasCopyrightBlock,
  );
}

class RemixBlueprintModel {
  final String blueprintId;
  final String workspaceId;
  final String referenceAssetId;
  final String? referenceUrl;
  final String? trendId;
  final String? referenceTranscript;
  final String remixScript;
  final String fidelityLevel;
  final double originalityScore;
  final double similarityPercentage;
  final String status;
  final String? rejectionReason;
  final DateTime createdAt;

  const RemixBlueprintModel({
    required this.blueprintId,
    required this.workspaceId,
    required this.referenceAssetId,
    this.referenceUrl,
    this.trendId,
    this.referenceTranscript,
    required this.remixScript,
    required this.fidelityLevel,
    required this.originalityScore,
    required this.similarityPercentage,
    required this.status,
    this.rejectionReason,
    required this.createdAt,
  });

  bool get hasTrendProvenance => trendId != null && trendId!.isNotEmpty;
}

class StudioJobCancelOutcome {
  final bool ok;
  final String jobId;
  final bool creditsRefunded;
  final int refundedCredits;
  final String? errorMessage;

  const StudioJobCancelOutcome({
    required this.ok,
    required this.jobId,
    this.creditsRefunded = false,
    this.refundedCredits = 0,
    this.errorMessage,
  });
}

typedef StudioJobCancelCallback = Future<StudioJobCancelOutcome> Function(
  String jobId,
  int estimatedCredits,
);

class StudioBatchRunOutcome {
  final bool ok;
  final int reservedCredits;
  final String? errorMessage;

  const StudioBatchRunOutcome({
    required this.ok,
    this.reservedCredits = 0,
    this.errorMessage,
  });
}

typedef StudioBatchRunCallback = Future<StudioBatchRunOutcome> Function(
  BatchBudgetPreviewModel preview,
);
