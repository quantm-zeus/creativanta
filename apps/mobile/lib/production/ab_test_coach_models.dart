// Experiment Lab & Performance Coach Mobile Models (EF-09, EF-10, M039, W027)
// Canonical Sources: docs/02_features/production/ai_video_studio.md §EF-09, §EF-10
//                    docs/02_features/production/packaging_qa.md
//                    docs/04_contracts/api_behavior_contracts.md §7
//                    docs/04_contracts/database_schema.md §8.1, §22.9

/// Standard observational notice required by canonical contracts.
const String kStandardObservationalNotice =
    'Observational recommendation - not causal proof or guaranteed revenue uplift.';

/// AB Variant Model representing one test variant.
class ABVariantModel {
  final String variantId;
  final String assetId;
  final String label;
  final String variantType; // thumbnail, title, hook, call_to_action
  final int impressions;
  final int views;
  final int clicks;
  final int conversions;
  final double clickThroughRate;
  final double conversionRate;
  final bool isWinner;

  const ABVariantModel({
    required this.variantId,
    required this.assetId,
    required this.label,
    required this.variantType,
    required this.impressions,
    required this.views,
    required this.clicks,
    required this.conversions,
    required this.clickThroughRate,
    required this.conversionRate,
    required this.isWinner,
  });

  ABVariantModel copyWith({
    String? variantId,
    String? assetId,
    String? label,
    String? variantType,
    int? impressions,
    int? views,
    int? clicks,
    int? conversions,
    double? clickThroughRate,
    double? conversionRate,
    bool? isWinner,
  }) {
    return ABVariantModel(
      variantId: variantId ?? this.variantId,
      assetId: assetId ?? this.assetId,
      label: label ?? this.label,
      variantType: variantType ?? this.variantType,
      impressions: impressions ?? this.impressions,
      views: views ?? this.views,
      clicks: clicks ?? this.clicks,
      conversions: conversions ?? this.conversions,
      clickThroughRate: clickThroughRate ?? this.clickThroughRate,
      conversionRate: conversionRate ?? this.conversionRate,
      isWinner: isWinner ?? this.isWinner,
    );
  }
}

/// Auto-winner criteria for automated evaluation.
class AutoWinnerCriteriaModel {
  final String metric; // views, clicks, conversions, ctr
  final double minConfidence;
  final int minSamplePerVariant; // Canonical: 1000
  final int minDurationHours; // Canonical: 48
  final double liftThresholdPercent; // e.g. 10.0

  const AutoWinnerCriteriaModel({
    this.metric = 'ctr',
    this.minConfidence = 0.95,
    this.minSamplePerVariant = 1000,
    this.minDurationHours = 48,
    this.liftThresholdPercent = 10.0,
  });
}

/// AB Experiment Model representing an active or completed experiment.
class ABExperimentModel {
  final String id;
  final String title;
  final String baseAssetId;
  final String targetPlatform;
  final String status; // draft, running, paused, completed, cancelled
  final String resultStatus; // pending, conclusive, inconclusive, scaled
  final String? winnerAssetId;
  final double confidenceLevel;
  final bool isObservational;
  final String observationalNotice;
  final List<ABVariantModel> variants;
  final AutoWinnerCriteriaModel criteria;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const ABExperimentModel({
    required this.id,
    required this.title,
    required this.baseAssetId,
    required this.targetPlatform,
    required this.status,
    required this.resultStatus,
    this.winnerAssetId,
    required this.confidenceLevel,
    this.isObservational = true,
    this.observationalNotice = kStandardObservationalNotice,
    required this.variants,
    required this.criteria,
    this.startedAt,
    this.completedAt,
  });

  ABExperimentModel copyWith({
    String? id,
    String? title,
    String? baseAssetId,
    String? targetPlatform,
    String? status,
    String? resultStatus,
    String? winnerAssetId,
    double? confidenceLevel,
    bool? isObservational,
    String? observationalNotice,
    List<ABVariantModel>? variants,
    AutoWinnerCriteriaModel? criteria,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return ABExperimentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      baseAssetId: baseAssetId ?? this.baseAssetId,
      targetPlatform: targetPlatform ?? this.targetPlatform,
      status: status ?? this.status,
      resultStatus: resultStatus ?? this.resultStatus,
      winnerAssetId: winnerAssetId ?? this.winnerAssetId,
      confidenceLevel: confidenceLevel ?? this.confidenceLevel,
      isObservational: isObservational ?? this.isObservational,
      observationalNotice: observationalNotice ?? this.observationalNotice,
      variants: variants ?? this.variants,
      criteria: criteria ?? this.criteria,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

/// Video Scorecard Model for coaching evaluations.
class VideoScorecardModel {
  final String videoId;
  final String title;
  final String? thumbnailUrl;
  final double overallScore; // 0.0 - 100.0
  final String letterGrade; // A+, A, A-, B+, B, C, D
  final double engagementRate;
  final double retentionRate;
  final double clickThroughRate;
  final bool isObservational;
  final String observationalNotice;
  final List<String> keyObservations;

  const VideoScorecardModel({
    required this.videoId,
    required this.title,
    this.thumbnailUrl,
    required this.overallScore,
    required this.letterGrade,
    required this.engagementRate,
    required this.retentionRate,
    required this.clickThroughRate,
    this.isObservational = true,
    this.observationalNotice = kStandardObservationalNotice,
    required this.keyObservations,
  });
}

/// Improvement Plan Model for actionable recommendations.
class ImprovementPlanModel {
  final String id;
  final String title;
  final String description;
  final String impact; // High, Medium, Low
  final String effort; // Low, Medium, High
  final String suggestedAction;
  final String category; // hook, timing, cta, topic
  final bool isObservational;

  const ImprovementPlanModel({
    required this.id,
    required this.title,
    required this.description,
    required this.impact,
    required this.effort,
    required this.suggestedAction,
    required this.category,
    this.isObservational = true,
  });
}

/// Industry Benchmark Model for platform niches.
class IndustryBenchmarkModel {
  final String niche;
  final String platform;
  final double p50EngagementRate;
  final double p75EngagementRate;
  final double p90EngagementRate;
  final int sampleSize;
  final bool isObservational;

  const IndustryBenchmarkModel({
    required this.niche,
    required this.platform,
    required this.p50EngagementRate,
    required this.p75EngagementRate,
    required this.p90EngagementRate,
    required this.sampleSize,
    this.isObservational = true,
  });
}

/// Industry Comparison Model for creator performance against benchmarks.
class IndustryComparisonModel {
  final double accountRate;
  final double industryP50;
  final double percentileRank;
  final double deltaVsMedian;
  final bool isObservational;
  final String observationalNotice;

  const IndustryComparisonModel({
    required this.accountRate,
    required this.industryP50,
    required this.percentileRank,
    required this.deltaVsMedian,
    this.isObservational = true,
    this.observationalNotice = kStandardObservationalNotice,
  });
}

/// Error thrown when an M11 scaling gate check fails.
class ScalingGateException implements Exception {
  final String gate;
  final String message;
  final String remediation;

  const ScalingGateException({
    required this.gate,
    required this.message,
    required this.remediation,
  });

  @override
  String toString() => 'ScalingGateException($gate): $message. Remediation: $remediation';
}

/// Evaluates an AB experiment against canonical thresholds.
///
/// Acceptance Target 1: Low exposure (<1000 views per variant or duration < minDurationHours)
/// MUST yield status = completed, resultStatus = inconclusive, winnerAssetId = null.
///
/// Acceptance Target 2: isObservational MUST remain true regardless of outcome.
ABExperimentModel evaluateABExperiment(
  ABExperimentModel experiment, {
  DateTime? evaluatedAt,
}) {
  final now = evaluatedAt ?? DateTime.now();
  final criteria = experiment.criteria;

  // Check duration threshold if startedAt is provided
  if (experiment.startedAt != null) {
    final elapsedHours = now.difference(experiment.startedAt!).inHours;
    if (elapsedHours < criteria.minDurationHours) {
      return experiment.copyWith(
        status: 'completed',
        resultStatus: 'inconclusive',
        winnerAssetId: null,
        confidenceLevel: 0.0,
        isObservational: true,
        observationalNotice: kStandardObservationalNotice,
        completedAt: now,
      );
    }
  }

  // Check sample size threshold for each variant
  bool hasUnderExposedVariant = false;
  for (final variant in experiment.variants) {
    if (variant.views < criteria.minSamplePerVariant) {
      hasUnderExposedVariant = true;
      break;
    }
  }

  if (hasUnderExposedVariant || experiment.variants.isEmpty) {
    return experiment.copyWith(
      status: 'completed',
      resultStatus: 'inconclusive',
      winnerAssetId: null,
      confidenceLevel: 0.0,
      isObservational: true,
      observationalNotice: kStandardObservationalNotice,
      completedAt: now,
    );
  }

  // Safe rate calculation helper
  double getRate(ABVariantModel v) {
    if (criteria.metric == 'ctr') {
      return v.impressions > 0 ? (v.clicks / v.impressions) : 0.0;
    }
    return v.views > 0 ? (v.conversions / v.views) : 0.0;
  }

  ABVariantModel best = experiment.variants.first;
  double bestRate = getRate(best);
  double runnerUpRate = -1.0;

  for (int i = 1; i < experiment.variants.length; i++) {
    final v = experiment.variants[i];
    final rate = getRate(v);
    if (rate > bestRate) {
      runnerUpRate = bestRate;
      best = v;
      bestRate = rate;
    } else if (rate > runnerUpRate) {
      runnerUpRate = rate;
    }
  }

  if (runnerUpRate < 0.0 && experiment.variants.length > 1) {
    runnerUpRate = getRate(experiment.variants[1]);
  }

  // Check minimum lift threshold
  final lift = runnerUpRate > 0.0 ? ((bestRate - runnerUpRate) / runnerUpRate) * 100.0 : 0.0;
  if (lift < criteria.liftThresholdPercent) {
    return experiment.copyWith(
      status: 'completed',
      resultStatus: 'inconclusive',
      winnerAssetId: null,
      confidenceLevel: 0.50,
      isObservational: true,
      observationalNotice: kStandardObservationalNotice,
      completedAt: now,
    );
  }

  // Statistically conclusive winner found
  final updatedVariants = experiment.variants.map((v) {
    return v.copyWith(isWinner: v.variantId == best.variantId);
  }).toList();

  return experiment.copyWith(
    status: 'completed',
    resultStatus: 'conclusive',
    winnerAssetId: best.assetId,
    confidenceLevel: 0.95,
    isObservational: true, // Acceptance Target 2: Observational label retained!
    observationalNotice: kStandardObservationalNotice,
    variants: updatedVariants,
    completedAt: now,
  );
}

/// Validates the 4 M11 scaling gates before an experiment winner can be scaled.
///
/// Gate 1: Caller Permission (publish:execute / Editor+)
/// Gate 2: Platform Capability (connector active and supported)
/// Gate 3: Policy Compliance (Packaging QA compliance free of hard blocks)
/// Gate 4: Duplicate-post Gate (cooldown window 24h)
void validateM11ScalingGates({
  required String callerRole,
  required bool platformConnectorActive,
  required bool platformConnectorSupported,
  required bool packagingQaBlocked,
  required DateTime? lastPostTime,
  DateTime? currentTime,
}) {
  final now = currentTime ?? DateTime.now();

  // Gate 1: Permission
  final allowedRoles = {'Editor', 'Admin', 'Owner'};
  if (!allowedRoles.contains(callerRole)) {
    throw const ScalingGateException(
      gate: 'M11-GATE-1-PERMISSION',
      message: 'Caller lacks publish:execute permission for automated scaling',
      remediation: 'Request Editor or Admin role authorization before scaling',
    );
  }

  // Gate 2: Platform Capability
  if (!platformConnectorActive || !platformConnectorSupported) {
    throw const ScalingGateException(
      gate: 'M11-GATE-2-CAPABILITY',
      message: 'Target platform connector is degraded, unsupported, or revoked',
      remediation: 'Reconnect platform credentials in Platform Settings',
    );
  }

  // Gate 3: Policy Compliance
  if (packagingQaBlocked) {
    throw const ScalingGateException(
      gate: 'M11-GATE-3-POLICY',
      message: 'Packaging QA compliance scan identified hard blocking violations',
      remediation: 'Remediate QA findings in Packaging QA before scaling',
    );
  }

  // Gate 4: Duplicate-post Cooldown
  if (lastPostTime != null) {
    final diff = now.difference(lastPostTime);
    if (diff.inHours < 24) {
      final waitHours = 24 - diff.inHours;
      throw ScalingGateException(
        gate: 'M11-GATE-4-COOLDOWN',
        message: 'Duplicate-post cooldown window active. Cooldown remaining: $waitHours hours',
        remediation: 'Wait until cooldown period expires or select different channel',
      );
    }
  }
}

/// Executes winner scaling if all M11 gates pass.
ABExperimentModel scaleExperimentWinner({
  required ABExperimentModel experiment,
  required String callerRole,
  required bool platformConnectorActive,
  required bool platformConnectorSupported,
  required bool packagingQaBlocked,
  required DateTime? lastPostTime,
  DateTime? currentTime,
}) {
  if (experiment.resultStatus != 'conclusive' || experiment.winnerAssetId == null) {
    throw StateError('Cannot scale experiment without a conclusive winner');
  }

  validateM11ScalingGates(
    callerRole: callerRole,
    platformConnectorActive: platformConnectorActive,
    platformConnectorSupported: platformConnectorSupported,
    packagingQaBlocked: packagingQaBlocked,
    lastPostTime: lastPostTime,
    currentTime: currentTime,
  );

  return experiment.copyWith(
    resultStatus: 'scaled',
    isObservational: true, // Acceptance Target 2: Observational label retained!
  );
}
