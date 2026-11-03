import 'package:creativanta_mobile/generated/creativanta/intelligence/v1/trend.pbenum.dart';

/// WhyExplanationModel details the evidence, limitations, and data gaps of an AI inference.
/// Conforms to RULE-M03-001 & RULE-M03-002.
class WhyExplanationModel {
  const WhyExplanationModel({
    required this.basisSummary,
    required this.dataSources,
    required this.limitations,
    required this.dataGaps,
  });

  final String basisSummary;
  final List<String> dataSources;
  final List<String> limitations;
  final List<String> dataGaps;
}

/// CompetitorEntity model for Mobile client (Module M03).
class Competitor {
  const Competitor({
    required this.id,
    required this.workspaceId,
    required this.name,
    required this.platform,
    required this.handle,
    required this.category,
    this.notes = '',
    required this.relevanceScore,
    required this.relevanceReason,
    required this.followersCount,
    required this.videoCount30d,
    required this.avgViews,
    required this.growthRate30d,
    required this.avgEngagementRate,
    required this.postingFrequencyPerDay,
    required this.lastPostAt,
    this.status = 'tracking',
    this.avatarUrl,
  });

  final String id;
  final String workspaceId;
  final String name;
  final String platform;
  final String handle;
  final String category;
  final String notes;
  final double relevanceScore;
  final String relevanceReason;
  final int followersCount;
  final int videoCount30d;
  final int avgViews;
  final double growthRate30d;
  final double avgEngagementRate;
  final double postingFrequencyPerDay;
  final String lastPostAt;
  final String status;
  final String? avatarUrl;
}

/// BenchmarkSnapshot model for Mobile client.
/// Conforms to RULE-M03-004 (Staleness >30 days) and RULE-M03-001 (Inferred labeling).
class BenchmarkSnapshot {
  BenchmarkSnapshot({
    required this.id,
    required this.workspaceId,
    required this.competitorId,
    required this.capturedAt,
    this.sourceClass = SourceClass.SOURCE_CLASS_INFERRED,
    this.confidence = ConfidenceBand.CONFIDENCE_BAND_HIGH,
    required this.whyExplanation,
    required this.followers,
    required this.engagementRate,
    required this.avgViews,
    required this.growthRate30d,
    required this.postingFrequency,
  });

  final String id;
  final String workspaceId;
  final String competitorId;
  final DateTime capturedAt;
  final SourceClass sourceClass;
  final ConfidenceBand confidence;
  final WhyExplanationModel whyExplanation;
  final int followers;
  final double engagementRate;
  final int avgViews;
  final double growthRate30d;
  final double postingFrequency;

  /// Invariant RULE-M03-004: Snapshots older than 30 days are stale.
  bool isStale([DateTime? now]) {
    final current = now ?? DateTime.now();
    return current.difference(capturedAt).inDays > 30;
  }

  int daysSinceCapture([DateTime? now]) {
    final current = now ?? DateTime.now();
    return current.difference(capturedAt).inDays;
  }

  String staleWarning([DateTime? now]) {
    if (!isStale(now)) return '';
    final days = daysSinceCapture(now);
    return 'Dữ liệu ảnh chụp đã cũ ($days ngày trước, vượt ngưỡng 30 ngày). Cần làm mới.';
  }
}

/// RevenueMetricGuard enforcing RULE-M03-003.
/// Competitor financial data is private ("—") and must not conflate with accounting truth.
class RevenueMetricGuard {
  static const String privateDisplayValue = '—';
  static const String status = 'PRIVATE_NOT_COMPARED';
  static const String caveat = 'Doanh thu đối thủ không được so sánh (bảo mật và tách biệt với sổ cái M19).';

  static bool validateNonConflationWithFinance(SourceClass source, String targetDomain) {
    final domain = targetDomain.toLowerCase();
    if (domain == 'operating_ledger' || domain == 'accounting' || domain == 'cogs') {
      if (source == SourceClass.SOURCE_CLASS_INFERRED || source == SourceClass.SOURCE_CLASS_ESTIMATED) {
        return false; // strictly blocked
      }
    }
    return true;
  }
}

/// WhiteSpaceOpportunity model.
class WhiteSpaceOpportunity {
  const WhiteSpaceOpportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.niche,
    required this.potentialScore,
    required this.estimatedDemand,
    required this.competitorSaturation,
    this.sourceClass = SourceClass.SOURCE_CLASS_INFERRED,
    this.confidence = ConfidenceBand.CONFIDENCE_BAND_HIGH,
    required this.whyExplanation,
  });

  final String id;
  final String title;
  final String description;
  final String niche;
  final int potentialScore;
  final String estimatedDemand;
  final String competitorSaturation;
  final SourceClass sourceClass;
  final ConfidenceBand confidence;
  final WhyExplanationModel whyExplanation;
}

/// Helper for compact formatting.
String formatCompactNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  }
  if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  }
  return number.toString();
}
