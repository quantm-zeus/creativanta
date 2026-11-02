import 'package:creativanta_mobile/generated/creativanta/intelligence/v1/trend.pbenum.dart';

/// Multi-dimensional Trend Model for mobile client (Module M02).
/// Conforms to docs/02_features/intelligence/trend_radar.md & database_schema.md §5.
class TrendSummary {
  TrendSummary({
    required this.id,
    required this.workspaceId,
    required this.title,
    required this.category,
    required this.platform,
    required this.velocity,
    required this.freshnessScore,
    required this.saturationScore,
    required this.strengthScore,
    required this.confidence,
    required this.sourceClass,
    required this.isDegraded,
    this.degradedReason,
    required this.sampleSize,
    required this.whyNow,
    required this.relevanceDescription,
    this.isSavedToWatchlist = false,
  });

  final String id;
  final String workspaceId;
  final String title;
  final String category;
  final String platform;
  final double velocity; // 0 - 100
  final double freshnessScore; // 0 - 100
  final double saturationScore; // 0 - 100
  final double strengthScore; // 0 - 100
  final ConfidenceBand confidence;
  final SourceClass sourceClass;
  final bool isDegraded;
  final String? degradedReason;
  final int sampleSize;
  final String whyNow;
  final String relevanceDescription;
  final bool isSavedToWatchlist;

  /// Multi-dimensional scoring formula per RULE-M02-002:
  /// strength_score = 0.45 * velocity + 0.35 * freshness + 0.20 * (100 - saturation)
  static double calculateStrengthScore(
    double velocity,
    double freshness,
    double saturation,
  ) {
    final v = velocity.clamp(0.0, 100.0);
    final f = freshness.clamp(0.0, 100.0);
    final s = saturation.clamp(0.0, 100.0);
    final raw = 0.45 * v + 0.35 * f + 0.20 * (100.0 - s);
    return double.parse(raw.clamp(0.0, 100.0).toStringAsFixed(1));
  }

  /// Acceptance Target 1: Source unavailable shows degraded data.
  /// When platform disconnected, demotes confidence to LOW and marks ESTIMATED.
  TrendSummary copyWithDegradation(bool platformConnected, String platformName) {
    if (platform.toLowerCase() == platformName.toLowerCase() && !platformConnected) {
      return TrendSummary(
        id: id,
        workspaceId: workspaceId,
        title: title,
        category: category,
        platform: platform,
        velocity: velocity,
        freshnessScore: freshnessScore,
        saturationScore: saturationScore,
        strengthScore: strengthScore,
        confidence: ConfidenceBand.CONFIDENCE_BAND_LOW,
        sourceClass: SourceClass.SOURCE_CLASS_ESTIMATED,
        isDegraded: true,
        degradedReason: 'Nguồn $platformName bị gián đoạn; hiển thị dữ liệu ước tính.',
        sampleSize: sampleSize,
        whyNow: whyNow,
        relevanceDescription: relevanceDescription,
        isSavedToWatchlist: isSavedToWatchlist,
      );
    }
    return this;
  }

  TrendSummary copyWith({bool? isSavedToWatchlist}) {
    return TrendSummary(
      id: id,
      workspaceId: workspaceId,
      title: title,
      category: category,
      platform: platform,
      velocity: velocity,
      freshnessScore: freshnessScore,
      saturationScore: saturationScore,
      strengthScore: strengthScore,
      confidence: confidence,
      sourceClass: sourceClass,
      isDegraded: isDegraded,
      degradedReason: degradedReason,
      sampleSize: sampleSize,
      whyNow: whyNow,
      relevanceDescription: relevanceDescription,
      isSavedToWatchlist: isSavedToWatchlist ?? this.isSavedToWatchlist,
    );
  }
}

/// Alert log model for mobile watchlist
class WatchlistAlertModel {
  WatchlistAlertModel({
    required this.alertId,
    required this.workspaceId,
    required this.watchlistId,
    required this.trendId,
    required this.trendTitle,
    required this.metricName,
    required this.thresholdValue,
    required this.actualValue,
    required this.fingerprint,
    required this.isBatchedSummary,
    required this.batchedAlertCount,
    required this.createdAt,
  });

  final String alertId;
  final String workspaceId;
  final String watchlistId;
  final String trendId;
  final String trendTitle;
  final String metricName;
  final double thresholdValue;
  final double actualValue;
  final String fingerprint;
  final bool isBatchedSummary;
  final int batchedAlertCount;
  final DateTime createdAt;

  static String generateFingerprint(
    String wsId,
    String wlId,
    String trendId,
    String metricName,
  ) {
    final raw = '$wsId:$wlId:$trendId:$metricName';
    var hash = 0;
    for (var i = 0; i < raw.length; i++) {
      hash = ((hash << 5) - hash) + raw.codeUnitAt(i);
      hash &= 0x7FFFFFFF;
    }
    return 'fp-${hash.toRadixString(16)}-$trendId';
  }
}

/// Deduplication and storm batching result
class AlertEvaluationResult {
  AlertEvaluationResult({
    required this.emittedAlerts,
    required this.suppressedCount,
    required this.updatedFingerprints,
  });

  final List<WatchlistAlertModel> emittedAlerts;
  final int suppressedCount;
  final Map<String, DateTime> updatedFingerprints;
}

/// Acceptance Target 2: Threshold alerts deduplicate & storm batching
AlertEvaluationResult evaluateMobileAlerts({
  required List<Map<String, dynamic>> breaches,
  required Map<String, DateTime> existingFingerprints,
  int cooldownMinutes = 60,
  DateTime? now,
}) {
  final current = now ?? DateTime.now();
  final updated = Map<String, DateTime>.from(existingFingerprints);
  final passed = <WatchlistAlertModel>[];
  var suppressed = 0;

  for (final b in breaches) {
    final wsId = b['workspaceId'] as String;
    final wlId = b['watchlistId'] as String;
    final trendId = b['trendId'] as String;
    final metric = b['metric'] as String;
    final title = b['title'] as String;
    final threshold = (b['threshold'] as num).toDouble();
    final actual = (b['actual'] as num).toDouble();

    final fp = WatchlistAlertModel.generateFingerprint(wsId, wlId, trendId, metric);
    final lastTime = updated[fp];

    if (lastTime != null && current.difference(lastTime).inMinutes < cooldownMinutes) {
      suppressed++;
      continue;
    }

    updated[fp] = current;
    passed.add(WatchlistAlertModel(
      alertId: 'al-${current.millisecondsSinceEpoch}-${passed.length + 1}',
      workspaceId: wsId,
      watchlistId: wlId,
      trendId: trendId,
      trendTitle: title,
      metricName: metric,
      thresholdValue: threshold,
      actualValue: actual,
      fingerprint: fp,
      isBatchedSummary: false,
      batchedAlertCount: 1,
      createdAt: current,
    ));
  }

  // EC-M02-004 Alert storm batching: if >5 breaches simultaneously, collapse into 1 summary
  if (passed.length > 5) {
    final summaryAlert = WatchlistAlertModel(
      alertId: 'al-storm-${current.millisecondsSinceEpoch}',
      workspaceId: breaches.isNotEmpty ? (breaches.first['workspaceId'] as String) : '',
      watchlistId: breaches.isNotEmpty ? (breaches.first['watchlistId'] as String) : '',
      trendId: 'multiple',
      trendTitle: 'Bão cảnh báo: ${passed.length} xu hướng cùng lúc vượt ngưỡng',
      metricName: 'multi_storm',
      thresholdValue: 0,
      actualValue: passed.length.toDouble(),
      fingerprint: 'storm-${current.millisecondsSinceEpoch}',
      isBatchedSummary: true,
      batchedAlertCount: passed.length,
      createdAt: current,
    );
    return AlertEvaluationResult(
      emittedAlerts: [summaryAlert],
      suppressedCount: suppressed,
      updatedFingerprints: updated,
    );
  }

  return AlertEvaluationResult(
    emittedAlerts: passed,
    suppressedCount: suppressed,
    updatedFingerprints: updated,
  );
}

/// Acceptance Target 3: Tenant-scoped semantic and keyword search
List<TrendSummary> searchAndFilterMobileTrends({
  required List<TrendSummary> trends,
  required String currentWorkspaceId,
  String? query,
  String? platform,
  String? category,
}) {
  if (currentWorkspaceId.isEmpty) return [];

  // Strict tenant boundary
  final scoped = trends.where((t) => t.workspaceId == currentWorkspaceId).toList();

  return scoped.where((t) {
    if (platform != null && platform != 'all' && platform.isNotEmpty) {
      if (t.platform.toLowerCase() != platform.toLowerCase()) return false;
    }
    if (category != null && category != 'all' && category.isNotEmpty) {
      if (t.category.toLowerCase() != category.toLowerCase()) return false;
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      final inTitle = t.title.toLowerCase().contains(q);
      final inWhy = t.whyNow.toLowerCase().contains(q);
      final inCat = t.category.toLowerCase().contains(q);
      if (!inTitle && !inWhy && !inCat) return false;
    }
    return true;
  }).toList();
}
