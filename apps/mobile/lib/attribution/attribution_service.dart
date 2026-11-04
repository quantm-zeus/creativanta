import 'attribution_models.dart';

class AttributionService {
  // ----------------------------------------------------------------------------
  // Acceptance Target 2: Missing Denominators Remain Unknown
  // ----------------------------------------------------------------------------

  static SafeMetric calculateSafeRPM(
    double revenue,
    int? views, {
    bool isViewsUnknown = false,
    String reason = '',
  }) {
    if (isViewsUnknown || views == null) {
      return SafeMetric(
        value: null,
        isUnknown: true,
        unknownReason: reason.isNotEmpty ? reason : 'MISSING_DENOMINATOR_VIEWS',
        status: 'unknown_denominator',
      );
    }

    if (views <= 0) {
      return const SafeMetric(
        value: null,
        isUnknown: true,
        unknownReason: 'MISSING_DENOMINATOR_VIEWS',
        status: 'collecting_data',
      );
    }

    // Exposure below 100 views is inconclusive for comparison (EXP-2026-02)
    if (views < 100) {
      return const SafeMetric(
        value: null,
        isUnknown: true,
        unknownReason: 'LOW_EXPOSURE_INCONCLUSIVE',
        status: 'low_exposure_inconclusive',
      );
    }

    final rpm = (revenue * 1000.0) / views;
    return SafeMetric(
      value: rpm.toStringAsFixed(6),
      isUnknown: false,
      status: 'calculated',
    );
  }

  static SafeMetric calculateSafeCTR(
    int? clicks,
    int? views, {
    bool isViewsUnknown = false,
    bool isClicksUnknown = false,
  }) {
    if (isViewsUnknown || views == null || views <= 0) {
      return const SafeMetric(
        value: null,
        isUnknown: true,
        unknownReason: 'MISSING_DENOMINATOR_VIEWS',
        status: 'unknown_denominator',
      );
    }

    if (isClicksUnknown || clicks == null) {
      return const SafeMetric(
        value: null,
        isUnknown: true,
        unknownReason: 'MISSING_CLICKS',
        status: 'unknown_denominator',
      );
    }

    if (views < 100) {
      return const SafeMetric(
        value: null,
        isUnknown: true,
        unknownReason: 'LOW_EXPOSURE_INCONCLUSIVE',
        status: 'low_exposure_inconclusive',
      );
    }

    final ctr = (clicks / views) * 100.0;
    return SafeMetric(
      value: '${ctr.toStringAsFixed(4)}%',
      isUnknown: false,
      status: 'calculated',
    );
  }

  static SafeMetric calculateSafeConversionRate(
    int ordersCount,
    int? clicks, {
    bool isClicksUnknown = false,
  }) {
    if (isClicksUnknown || clicks == null || clicks <= 0) {
      return const SafeMetric(
        value: null,
        isUnknown: true,
        unknownReason: 'MISSING_DENOMINATOR_CLICKS',
        status: 'unknown_denominator',
      );
    }

    final rate = (ordersCount / clicks) * 100.0;
    return SafeMetric(
      value: '${rate.toStringAsFixed(4)}%',
      isUnknown: false,
      status: 'calculated',
    );
  }

  // ----------------------------------------------------------------------------
  // Acceptance Target 3: Imported Proof Integrity & Mixed Confidence Cap
  // ----------------------------------------------------------------------------

  static ({SourceClass sourceClass, String? error}) enforceSourceClassIntegrity(
    SourceClass currentClass,
    SourceClass requestedClass, {
    bool isLiveAPIVerified = false,
  }) {
    // RULE-M19-001, RULE-M19-007: Imported proof cannot be upgraded to official
    if (currentClass == SourceClass.imported && requestedClass == SourceClass.official) {
      return (
        sourceClass: SourceClass.imported,
        error: 'finance: imported proof cannot be upgraded to official without verified live platform API session',
      );
    }

    if (requestedClass == SourceClass.official && !isLiveAPIVerified) {
      return (
        sourceClass: SourceClass.imported,
        error: 'finance: official source class requires verified live platform API session',
      );
    }

    return (sourceClass: requestedClass, error: null);
  }

  static ConfidenceBand resolveAggregateConfidence(
    List<ConfidenceBand> bands,
    bool hasImportedOrEstimated,
  ) {
    if (bands.isEmpty) return ConfidenceBand.unspecified;

    int minRank = 5;
    for (final b in bands) {
      if (b.rank < minRank) minRank = b.rank;
    }

    ConfidenceBand resolved = ConfidenceBand.fromRank(minRank);

    // Target 3: If imported or estimated sources are included, cap at 'medium'
    if (hasImportedOrEstimated && resolved.rank > ConfidenceBand.medium.rank) {
      resolved = ConfidenceBand.medium;
    }

    return resolved;
  }

  // ----------------------------------------------------------------------------
  // Acceptance Target 1: Workspace Revenue Counted Once & Order Net Capacity
  // ----------------------------------------------------------------------------

  static ({double remainingCapacity, bool isValid, String? error}) validateAttributionCapacity(
    double netRevenue,
    List<double> existingAllocations,
    double newAllocation,
  ) {
    final currentSum = existingAllocations.fold<double>(0.0, (acc, v) => acc + v);
    final total = currentSum + newAllocation;

    if (total > netRevenue + 0.000001) {
      return (
        remainingCapacity: (netRevenue - currentSum) > 0 ? (netRevenue - currentSum) : 0.0,
        isValid: false,
        error: 'finance: attributed revenue (${total.toStringAsFixed(6)}) exceeds order net recognized revenue capacity (${netRevenue.toStringAsFixed(6)})',
      );
    }

    return (
      remainingCapacity: netRevenue - total,
      isValid: true,
      error: null,
    );
  }

  static WorkspaceDeduplicationSummary deduplicateWorkspaceRevenue(
    String workspaceId,
    List<CanonicalOrder> canonicalOrders,
    List<AttributionRecord> attributions,
  ) {
    final orderMap = <String, CanonicalOrder>{};
    for (final o in canonicalOrders) {
      if (o.workspaceId == workspaceId && o.isRecognized) {
        orderMap[o.orderId] = o;
      }
    }

    // Sum distinct recognized orders once
    double canonicalTotal = 0.0;
    for (final order in orderMap.values) {
      canonicalTotal += double.tryParse(order.netRevenue) ?? 0.0;
    }

    final orderAllocations = <String, List<double>>{};
    double sumAttributions = 0.0;
    bool hasImportedOrEstimated = false;
    final bands = <ConfidenceBand>[];

    for (final a in attributions) {
      if (a.workspaceId != workspaceId) continue;

      final amt = double.tryParse(a.revenueAttributed) ?? 0.0;
      sumAttributions += amt;
      bands.add(a.confidence);

      if (a.sourceClass == SourceClass.imported || a.sourceClass == SourceClass.estimated) {
        hasImportedOrEstimated = true;
      }

      final allocs = orderAllocations[a.orderId] ?? <double>[];
      final order = orderMap[a.orderId];
      final netCap = order != null ? (double.tryParse(order.netRevenue) ?? 0.0) : amt;

      final validation = validateAttributionCapacity(netCap, allocs, amt);
      if (!validation.isValid) {
        throw StateError(validation.error!);
      }

      allocs.add(amt);
      orderAllocations[a.orderId] = allocs;
    }

    final aggregateConfidence = resolveAggregateConfidence(bands, hasImportedOrEstimated);

    String? caveatMessage;
    if (hasImportedOrEstimated) {
      caveatMessage = 'Aggregated revenue includes imported/estimated sources; confidence capped at medium.';
    }

    return WorkspaceDeduplicationSummary(
      workspaceId: workspaceId,
      totalOrdersAttributed: attributions.where((a) => a.workspaceId == workspaceId).length,
      uniqueOrdersCounted: orderAllocations.length,
      canonicalWorkspaceRevenue: canonicalTotal.toStringAsFixed(6),
      sumAttributionLines: sumAttributions.toStringAsFixed(6),
      isRevenueCountedOnce: true,
      aggregateConfidence: aggregateConfidence,
      includesEstimatedOrImported: hasImportedOrEstimated,
      caveatMessage: caveatMessage,
    );
  }
}
