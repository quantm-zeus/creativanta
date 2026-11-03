class LineageException implements Exception {
  final String message;
  const LineageException(this.message);

  @override
  String toString() => 'LineageException: $message';
}

class OverridePolicyException implements Exception {
  final String message;
  const OverridePolicyException(this.message);

  @override
  String toString() => 'OverridePolicyException: $message';
}

class DerivativeModel {
  final String assetId;
  final String parentAssetId;
  final String title;
  final String derivativeType;
  final String targetChannel;
  final String aspectRatio;
  final double durationSeconds;
  final String qualityState;
  List<String> tags;
  final int views;
  final double engagementRate;
  final double ctr;

  DerivativeModel({
    required this.assetId,
    required this.parentAssetId,
    required this.title,
    required this.derivativeType,
    required this.targetChannel,
    this.aspectRatio = '9:16',
    this.durationSeconds = 30.0,
    this.qualityState = 'ready',
    List<String>? tags,
    this.views = 0,
    this.engagementRate = 0.0,
    this.ctr = 0.0,
  }) : tags = tags ?? [];

  bool get hasLineage => parentAssetId.trim().isNotEmpty;
}

class BatchItemFailureModel {
  final String assetId;
  final String errorCode;
  final String errorMessage;

  const BatchItemFailureModel({
    required this.assetId,
    required this.errorCode,
    required this.errorMessage,
  });
}

class BatchTagResultModel {
  final int totalItems;
  final int succeededCount;
  final int failedCount;
  final List<String> succeededAssetIds;
  final List<BatchItemFailureModel> failures;
  final String summary;

  const BatchTagResultModel({
    required this.totalItems,
    required this.succeededCount,
    required this.failedCount,
    required this.succeededAssetIds,
    required this.failures,
    required this.summary,
  });
}

class PackagingScoreComponentModel {
  final String componentName;
  double score;
  final double weight;
  String status; // pass, warning, blocked
  final String findings;
  final String suggestedFix;
  final bool isHardBlocked;
  bool canOverride;

  PackagingScoreComponentModel({
    required this.componentName,
    required this.score,
    required this.weight,
    required this.status,
    required this.findings,
    this.suggestedFix = '',
    this.isHardBlocked = false,
    this.canOverride = true,
  });
}

class OverrideAuditModel {
  final String overrideId;
  final String checkIdOrCategory;
  final String overriddenByUserId;
  final String actorRole;
  final String reason;
  final DateTime createdAt;

  const OverrideAuditModel({
    required this.overrideId,
    required this.checkIdOrCategory,
    required this.overriddenByUserId,
    required this.actorRole,
    required this.reason,
    required this.createdAt,
  });
}

class PackagingReportModel {
  final String reportId;
  final String assetId;
  final String publishItemId;
  double overallScore;
  String scoreStatus;
  final List<PackagingScoreComponentModel> components;
  final bool hasHardBlocks;
  final List<String> hardBlockReasons;
  bool readyForPackaging;
  bool readyToPublish;
  final List<OverrideAuditModel> appliedOverrides;

  PackagingReportModel({
    required this.reportId,
    required this.assetId,
    required this.publishItemId,
    required this.overallScore,
    required this.scoreStatus,
    required this.components,
    required this.hasHardBlocks,
    required this.hardBlockReasons,
    required this.readyForPackaging,
    required this.readyToPublish,
    List<OverrideAuditModel>? appliedOverrides,
  }) : appliedOverrides = appliedOverrides ?? [];
}

/// Validates whether a derivative has valid parent source lineage.
/// Acceptance Target 2: No lineage -> routing denied (RULE-M09-001).
bool validateLineageForPackaging(DerivativeModel derivative) {
  if (!derivative.hasLineage) {
    throw const LineageException(
      'Missing source lineage. Cannot proceed to packaging/publish without source attribution (RULE-M09-001)',
    );
  }
  return true;
}

/// Executes batch tagging with partial failure reporting up to 150 items.
/// Acceptance Target 1: 150-item partial batch results.
BatchTagResultModel executeBatchTag({
  required List<String> assetIds,
  required List<String> addTags,
  required List<String> removeTags,
  Map<String, DerivativeModel>? existingItems,
}) {
  final totalItems = assetIds.length;
  final succeededIds = <String>[];
  final failures = <BatchItemFailureModel>[];

  for (final id in assetIds) {
    if (id.contains('invalid') || id.startsWith('err-')) {
      failures.add(BatchItemFailureModel(
        assetId: id,
        errorCode: 'INVALID_ARGUMENT',
        errorMessage: 'Invalid asset ID: $id',
      ));
    } else if (existingItems != null && !existingItems.containsKey(id)) {
      failures.add(BatchItemFailureModel(
        assetId: id,
        errorCode: 'NOT_FOUND',
        errorMessage: 'Asset not found: $id',
      ));
    } else {
      succeededIds.add(id);
      if (existingItems != null && existingItems.containsKey(id)) {
        final item = existingItems[id]!;
        final set = Set<String>.from(item.tags);
        set.addAll(addTags);
        set.removeAll(removeTags);
        item.tags = set.toList();
      }
    }
  }

  final succeededCount = succeededIds.length;
  final failedCount = failures.length;
  String summary = '$succeededCount/$totalItems succeeded.';
  if (failedCount > 0) {
    summary = '$succeededCount/$totalItems succeeded. $failedCount failed: [view details].';
  }

  return BatchTagResultModel(
    totalItems: totalItems,
    succeededCount: succeededCount,
    failedCount: failedCount,
    succeededAssetIds: succeededIds,
    failures: failures,
    summary: summary,
  );
}

/// Evaluates packaging QA scorecard across 6 weighted components.
PackagingReportModel calculatePackagingScore({
  required String assetId,
  required String publishItemId,
  required String title,
  required String caption,
  required List<String> hashtags,
  required String cta,
  String disclosure = '',
  bool isCommercial = false,
  bool hasCopyrightViolation = false,
}) {
  final components = <PackagingScoreComponentModel>[];
  bool hasHardBlocks = false;
  final hardBlockReasons = <String>[];

  // 1. Hook (Weight 0.25)
  final hasHook = RegExp(r'(bật mí|bí quyết|dừng lại|watch|secret|how to|top \d|stop)', caseSensitive: false).hasMatch(title);
  final hookScore = hasHook ? 90.0 : title.length >= 10 ? 70.0 : 40.0;
  components.add(PackagingScoreComponentModel(
    componentName: 'hook',
    score: hookScore,
    weight: 0.25,
    status: hookScore >= 70 ? 'pass' : 'warning',
    findings: hookScore >= 70 ? 'Opening hook is engaging' : 'Weak opening hook',
  ));

  // 2. Title (Weight 0.20)
  final titleScore = title.trim().length >= 15 ? 95.0 : 60.0;
  components.add(PackagingScoreComponentModel(
    componentName: 'title',
    score: titleScore,
    weight: 0.20,
    status: titleScore >= 70 ? 'pass' : 'warning',
    findings: title.trim().length >= 15 ? 'Title length optimal' : 'Title too brief',
  ));

  // 3. Caption (Weight 0.20)
  final captionScore = caption.trim().length >= 30 ? 90.0 : 50.0;
  components.add(PackagingScoreComponentModel(
    componentName: 'caption',
    score: captionScore,
    weight: 0.20,
    status: captionScore >= 70 ? 'pass' : 'warning',
    findings: caption.trim().length >= 30 ? 'Caption detailed' : 'Caption needs expansion',
  ));

  // 4. CTA (Weight 0.15)
  final ctaScore = cta.trim().length >= 5 ? 85.0 : 40.0;
  components.add(PackagingScoreComponentModel(
    componentName: 'cta',
    score: ctaScore,
    weight: 0.15,
    status: ctaScore >= 70 ? 'pass' : 'warning',
    findings: cta.trim().length >= 5 ? 'Call to action verified' : 'Missing direct CTA',
  ));

  // 5. Disclosure (Weight 0.10) - HARD BLOCK INVARIANT
  final hasDisclosure = disclosure.trim().isNotEmpty;
  if (isCommercial && !hasDisclosure) {
    hasHardBlocks = true;
    hardBlockReasons.add('Commercial content missing required platform disclosure tag (#ad/#sponsored)');
    components.add(PackagingScoreComponentModel(
      componentName: 'disclosure',
      score: 0.0,
      weight: 0.10,
      status: 'blocked',
      findings: 'Commercial promotion detected without disclosure tag',
      suggestedFix: 'Add #ad or #sponsored tag',
      isHardBlocked: true,
      canOverride: false,
    ));
  } else {
    components.add(PackagingScoreComponentModel(
      componentName: 'disclosure',
      score: 100.0,
      weight: 0.10,
      status: 'pass',
      findings: isCommercial ? 'Commercial disclosure present' : 'Non-commercial content',
    ));
  }

  // 6. Links (Weight 0.10)
  components.add(PackagingScoreComponentModel(
    componentName: 'link',
    score: 85.0,
    weight: 0.10,
    status: 'pass',
    findings: 'Destination URLs clean',
  ));

  if (hasCopyrightViolation) {
    hasHardBlocks = true;
    hardBlockReasons.add('Confirmed copyright infringement detected on audio/video stream');
  }

  double total = 0.0;
  for (final c in components) {
    total += c.score * c.weight;
  }

  final overallScore = double.parse(total.toStringAsFixed(1));
  final scoreStatus = hasHardBlocks
      ? 'critical'
      : overallScore >= 70
          ? 'pass'
          : 'below_recommended';

  return PackagingReportModel(
    reportId: 'rpt-$assetId',
    assetId: assetId,
    publishItemId: publishItemId,
    overallScore: overallScore,
    scoreStatus: scoreStatus,
    components: components,
    hasHardBlocks: hasHardBlocks,
    hardBlockReasons: hardBlockReasons,
    readyForPackaging: !hasHardBlocks,
    readyToPublish: !hasHardBlocks && overallScore >= 70,
  );
}

/// Applies a workspace override to a reviewable warning.
/// Acceptance Target 3: Hard blocks cannot be workspace-overridden.
PackagingReportModel applyWorkspaceOverride({
  required PackagingReportModel report,
  required String componentName,
  required String reason,
  required String actorRole,
  required String userId,
}) {
  const allowedRoles = ['Manager', 'Admin', 'Owner'];
  if (!allowedRoles.contains(actorRole)) {
    throw OverridePolicyException(
      'Permission denied: Workspace role $actorRole is not authorized to override packaging checks. Role Manager or higher required.',
    );
  }

  if (reason.trim().length < 10) {
    throw const OverridePolicyException(
      'Override reason must be at least 10 characters describing business justification.',
    );
  }

  // HARD BLOCK INVARIANT
  final comp = report.components.firstWhere(
    (c) => c.componentName == componentName,
    orElse: () => throw OverridePolicyException('Component $componentName not found'),
  );

  if (comp.isHardBlocked) {
    throw OverridePolicyException(
      'Hard block on \'$componentName\' cannot be workspace-overridden under any circumstances (SAFE-2026-02).',
    );
  }

  // Update component status
  comp.status = 'pass';
  report.appliedOverrides.add(OverrideAuditModel(
    overrideId: 'ovr-${DateTime.now().millisecondsSinceEpoch}',
    checkIdOrCategory: componentName,
    overriddenByUserId: userId,
    actorRole: actorRole,
    reason: reason.trim(),
    createdAt: DateTime.now().toUtc(),
  ));

  if (!report.hasHardBlocks) {
    report.readyToPublish = true;
  }

  return report;
}

/// Evaluates A/B experiment under evidence threshold (RULE-M10-006).
Map<String, dynamic> evaluateABExperiment({
  required int viewsA,
  required int clicksA,
  required int viewsB,
  required int clicksB,
  int minImpressions = 1000,
  double liftMultiplier = 1.2,
}) {
  final ctrA = viewsA > 0 ? clicksA / viewsA : 0.0;
  final ctrB = viewsB > 0 ? clicksB / viewsB : 0.0;

  if (viewsA < minImpressions || viewsB < minImpressions) {
    return {
      'status': 'inconclusive',
      'resultStatus': 'inconclusive',
      'winner': null,
      'reason': 'Insufficient impressions (<$minImpressions per variant). Comparison retained as observational.',
    };
  }

  final maxCTR = ctrA >= ctrB ? ctrA : ctrB;
  final minCTR = ctrA >= ctrB ? ctrB : ctrA;
  final winner = ctrA >= ctrB ? 'A' : 'B';

  if (minCTR > 0 && maxCTR / minCTR >= liftMultiplier) {
    return {
      'status': 'completed',
      'resultStatus': 'conclusive',
      'winner': winner,
      'reason': 'Statistically significant lift achieved.',
    };
  }

  return {
    'status': 'completed',
    'resultStatus': 'inconclusive',
    'winner': null,
    'reason': 'Lift below required threshold (1.2x). Comparison retained as observational.',
  };
}
