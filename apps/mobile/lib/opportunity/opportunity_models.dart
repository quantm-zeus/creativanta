import 'package:creativanta_mobile/generated/creativanta/intelligence/v1/opportunity.pbenum.dart';
import 'package:creativanta_mobile/generated/creativanta/intelligence/v1/trend.pbenum.dart';

/// Provenance Source link (RULE-M04-001).
class OpportunitySourceItem {
  const OpportunitySourceItem({
    required this.sourceType,
    required this.sourceId,
    required this.sourceName,
    this.sourceUrl,
    this.isExpired = false,
    this.archiveNotice,
  });

  final String sourceType;
  final String sourceId;
  final String sourceName;
  final String? sourceUrl;
  final bool isExpired;
  final String? archiveNotice;
}

/// Mobile Opportunity Model for Module M04 (Opportunity Board & Prioritization).
/// Canonical sources: docs/02_features/intelligence/opportunity_board.md
/// and docs/04_contracts/database_schema.md §5.4 & §5.5.
class OpportunityItem {
  OpportunityItem({
    required this.id,
    required this.workspaceId,
    required this.opportunityType,
    required this.title,
    required this.summary,
    required this.whyItMatters,
    required this.expectedImpactScore,
    required this.expectedImpactDesc,
    required this.expectedEffortScore,
    required this.expectedEffortDesc,
    required this.priorityState,
    required this.priorityReason,
    required this.suggestedNextStep,
    required this.ownerUserId,
    required this.confidence,
    required this.sourceClass,
    this.convertedToType = '',
    this.convertedToId = '',
    required this.sources,
    this.isSaved = false,
    this.isDismissed = false,
    required this.overallScore,
    required this.estimatedProfitAmountCents,
    this.isEstimate = true,
    required this.profitExplanation,
    required this.createdAt,
    required this.updatedAt,
    required this.isRepairable,
    required this.repairReasons,
  });

  final String id;
  final String workspaceId;
  final String opportunityType;
  final String title;
  final String summary;
  final String whyItMatters;
  final int expectedImpactScore;
  final String expectedImpactDesc;
  final int expectedEffortScore;
  final String expectedEffortDesc;
  PriorityState priorityState;
  String priorityReason;
  final String suggestedNextStep;
  String ownerUserId;
  final ConfidenceBand confidence;
  final SourceClass sourceClass;
  String convertedToType;
  String convertedToId;
  final List<OpportunitySourceItem> sources;
  bool isSaved;
  bool isDismissed;
  final int overallScore;
  final int estimatedProfitAmountCents;
  final bool isEstimate; // Always true per RULE-M04-005
  final String profitExplanation;
  final DateTime createdAt;
  DateTime updatedAt;
  bool isRepairable;
  List<String> repairReasons;

  /// Multi-dimensional composite scoring:
  /// Impact 70%, Effort 30% (inverted: 100 - effort).
  static int calculateOverallScore(int impactScore, int effortScore) {
    final i = impactScore.clamp(1, 100);
    final e = effortScore.clamp(0, 100);
    final score = (i * 0.7 + (100 - e) * 0.3).round();
    return score.clamp(1, 100);
  }

  /// Acceptance Target 1: Unassigned open items remain repairable.
  static ({bool isRepairable, List<String> repairReasons}) computeRepairStatus(OpportunityItem opp) {
    final reasons = <String>[];

    // RULE-M04-002: Open/prioritized items without owner display assign prompt and are repairable
    if ((opp.priorityState == PriorityState.PRIORITY_STATE_OPEN ||
            opp.priorityState == PriorityState.PRIORITY_STATE_PRIORITIZED) &&
        opp.ownerUserId.trim().isEmpty) {
      reasons.add('Chưa phân công người phụ trách (Unassigned owner — assign team member)');
    }

    // RULE-M04-003: Missing priority justification
    if (opp.priorityReason.trim().isEmpty &&
        opp.confidence == ConfidenceBand.CONFIDENCE_BAND_UNSPECIFIED) {
      reasons.add('Thiếu ngữ cảnh ưu tiên (Missing priority context — add reason or confidence)');
    }

    // Incomplete summary
    if (opp.summary.trim().isEmpty) {
      reasons.add('Thiếu tóm tắt cơ hội (Missing opportunity summary)');
    }

    return (isRepairable: reasons.isNotEmpty, repairReasons: reasons);
  }

  /// Canonical state transition validation (RULE-M04-004).
  static ({bool allowed, String? error}) validateStateTransition(
    PriorityState current,
    PriorityState target,
    OpportunityItem opp, {
    String? targetOwner,
    String? reason,
  }) {
    if (current == target) {
      return (allowed: true, error: null);
    }

    // Allow parking from active non-terminal states with reason
    if (target == PriorityState.PRIORITY_STATE_PARKED) {
      if (current == PriorityState.PRIORITY_STATE_CLOSED_WON ||
          current == PriorityState.PRIORITY_STATE_CLOSED_LOST ||
          current == PriorityState.PRIORITY_STATE_CONVERTED) {
        return (allowed: false, error: 'Cannot park terminal opportunity in state $current');
      }
      if (reason == null || reason.trim().isEmpty) {
        return (allowed: false, error: 'Parking requires explanation reason');
      }
      return (allowed: true, error: null);
    }

    // Re-activating from parked must go to open
    if (current == PriorityState.PRIORITY_STATE_PARKED) {
      if (target == PriorityState.PRIORITY_STATE_OPEN) {
        return (allowed: true, error: null);
      }
      return (allowed: false, error: 'Parked opportunities must re-activate to open, not $target');
    }

    switch (current) {
      case PriorityState.PRIORITY_STATE_DRAFT:
        if (target != PriorityState.PRIORITY_STATE_OPEN) {
          return (allowed: false, error: 'Draft can only transition to open, not $target');
        }
        if (opp.title.trim().isEmpty || opp.summary.trim().isEmpty) {
          return (allowed: false, error: 'Draft requires title and summary to open');
        }
        return (allowed: true, error: null);

      case PriorityState.PRIORITY_STATE_OPEN:
        if (target != PriorityState.PRIORITY_STATE_PRIORITIZED) {
          return (allowed: false, error: 'Open can only transition to prioritized, not $target');
        }
        // RULE-M04-003: Priority justification required
        if (opp.priorityReason.trim().isEmpty &&
            opp.confidence == ConfidenceBand.CONFIDENCE_BAND_UNSPECIFIED) {
          return (allowed: false, error: 'Priority justification required (RULE-M04-003)');
        }
        return (allowed: true, error: null);

      case PriorityState.PRIORITY_STATE_PRIORITIZED:
        if (target != PriorityState.PRIORITY_STATE_ASSIGNED) {
          return (allowed: false, error: 'Prioritized can only transition to assigned, not $target');
        }
        final effectiveOwner = targetOwner ?? opp.ownerUserId;
        if (effectiveOwner.trim().isEmpty) {
          return (allowed: false, error: 'Owner required for assignment (RULE-M04-002)');
        }
        return (allowed: true, error: null);

      case PriorityState.PRIORITY_STATE_ASSIGNED:
        if (target != PriorityState.PRIORITY_STATE_IN_PROGRESS) {
          return (allowed: false, error: 'Assigned can only transition to in_progress, not $target');
        }
        return (allowed: true, error: null);

      case PriorityState.PRIORITY_STATE_IN_PROGRESS:
        if (target != PriorityState.PRIORITY_STATE_CONVERTED) {
          return (allowed: false, error: 'In_progress can only transition to converted, not $target');
        }
        return (allowed: true, error: null);

      case PriorityState.PRIORITY_STATE_CONVERTED:
        if (target == PriorityState.PRIORITY_STATE_CLOSED_WON ||
            target == PriorityState.PRIORITY_STATE_CLOSED_LOST) {
          if (reason == null || reason.trim().isEmpty) {
            return (allowed: false, error: 'Closing converted opportunity requires explanation');
          }
          return (allowed: true, error: null);
        }
        return (allowed: false, error: 'Converted can only transition to closed won/lost, not $target');

      default:
        return (allowed: false, error: 'Terminal state $current cannot transition to $target');
    }
  }

  /// Concurrency conflict check (EC-M04-003).
  static bool isConcurrentConflict(DateTime currentUpdatedAt, DateTime expectedUpdatedAt) {
    return currentUpdatedAt.millisecondsSinceEpoch != expectedUpdatedAt.millisecondsSinceEpoch;
  }
}
