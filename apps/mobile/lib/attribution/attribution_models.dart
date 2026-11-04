/// Creativanta P5-03: Channel post metrics and attributed order links,
/// source rollups and confidence (M09, M19, S16).
library;

enum SourceClass {
  official,
  imported,
  inferred,
  estimated,
  unreconciled;

  static SourceClass fromString(String val) {
    switch (val.toLowerCase()) {
      case 'official':
        return SourceClass.official;
      case 'imported':
        return SourceClass.imported;
      case 'inferred':
        return SourceClass.inferred;
      case 'estimated':
        return SourceClass.estimated;
      case 'unreconciled':
        return SourceClass.unreconciled;
      default:
        return SourceClass.imported;
    }
  }
}

enum ConfidenceBand {
  high,
  mediumHigh,
  medium,
  lowMedium,
  low,
  unspecified;

  int get rank {
    switch (this) {
      case ConfidenceBand.high:
        return 5;
      case ConfidenceBand.mediumHigh:
        return 4;
      case ConfidenceBand.medium:
        return 3;
      case ConfidenceBand.lowMedium:
        return 2;
      case ConfidenceBand.low:
        return 1;
      case ConfidenceBand.unspecified:
        return 0;
    }
  }

  static ConfidenceBand fromRank(int rank) {
    if (rank >= 5) return ConfidenceBand.high;
    if (rank >= 4) return ConfidenceBand.mediumHigh;
    if (rank >= 3) return ConfidenceBand.medium;
    if (rank >= 2) return ConfidenceBand.lowMedium;
    return ConfidenceBand.low;
  }
}

/// SafeMetric encapsulates a calculated metric or records an explicit unknown state (Target 2).
class SafeMetric {
  final String? value;
  final bool isUnknown;
  final String? unknownReason;
  final String status; // calculated, unknown_denominator, collecting_data, low_exposure_inconclusive

  const SafeMetric({
    this.value,
    required this.isUnknown,
    this.unknownReason,
    required this.status,
  });

  @override
  String toString() {
    if (isUnknown) {
      return 'UNKNOWN ($unknownReason)';
    }
    return value ?? 'UNKNOWN';
  }
}

class AttributionRecord {
  final String attributionId;
  final String workspaceId;
  final String? publishItemId;
  final String? channelPostId;
  final String orderId;
  final String attributionType;
  final String revenueAttributed;
  final SourceClass sourceClass;
  final ConfidenceBand confidence;
  final String? utmSource;
  final String? utmMedium;
  final String? utmCampaign;
  final DateTime? createdAt;

  const AttributionRecord({
    required this.attributionId,
    required this.workspaceId,
    this.publishItemId,
    this.channelPostId,
    required this.orderId,
    required this.attributionType,
    required this.revenueAttributed,
    required this.sourceClass,
    required this.confidence,
    this.utmSource,
    this.utmMedium,
    this.utmCampaign,
    this.createdAt,
  });
}

class CanonicalOrder {
  final String orderId;
  final String workspaceId;
  final String grossRevenue;
  final String refundDeductions;
  final String netRevenue;
  final String currency;
  final SourceClass sourceClass;
  final ConfidenceBand confidence;
  final bool isRecognized;

  const CanonicalOrder({
    required this.orderId,
    required this.workspaceId,
    required this.grossRevenue,
    required this.refundDeductions,
    required this.netRevenue,
    required this.currency,
    required this.sourceClass,
    required this.confidence,
    required this.isRecognized,
  });
}

class WorkspaceDeduplicationSummary {
  final String workspaceId;
  final int totalOrdersAttributed;
  final int uniqueOrdersCounted;
  final String canonicalWorkspaceRevenue;
  final String sumAttributionLines;
  final bool isRevenueCountedOnce;
  final ConfidenceBand aggregateConfidence;
  final bool includesEstimatedOrImported;
  final String? caveatMessage;

  const WorkspaceDeduplicationSummary({
    required this.workspaceId,
    required this.totalOrdersAttributed,
    required this.uniqueOrdersCounted,
    required this.canonicalWorkspaceRevenue,
    required this.sumAttributionLines,
    required this.isRevenueCountedOnce,
    required this.aggregateConfidence,
    required this.includesEstimatedOrImported,
    this.caveatMessage,
  });
}

class ContentRevenueAttribution {
  final String contentId;
  final String publishItemId;
  final int directOrderCount;
  final String attributedRevenue;
  final int views;
  final int clicks;
  final bool isViewsUnknown;
  final bool isClicksUnknown;
  final String? unknownReason;
  final String? rpm;
  final bool isRpmUnknown;
  final String? ctr;
  final bool isCtrUnknown;
  final String? conversionRate;
  final bool isConversionRateUnknown;
  final ConfidenceBand confidence;
  final Map<String, double> sourceClassPercentages;
  final String status;

  const ContentRevenueAttribution({
    required this.contentId,
    required this.publishItemId,
    required this.directOrderCount,
    required this.attributedRevenue,
    required this.views,
    required this.clicks,
    required this.isViewsUnknown,
    required this.isClicksUnknown,
    this.unknownReason,
    this.rpm,
    required this.isRpmUnknown,
    this.ctr,
    required this.isCtrUnknown,
    this.conversionRate,
    required this.isConversionRateUnknown,
    required this.confidence,
    required this.sourceClassPercentages,
    required this.status,
  });
}
