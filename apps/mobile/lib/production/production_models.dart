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
