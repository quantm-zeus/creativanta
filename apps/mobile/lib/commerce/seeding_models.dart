/// Seeding CRM, Sample Requests, Shipments and Costs/Outcomes Mobile Domain Models
/// Module M18 (docs/02_features/commerce/seeding_crm.md)
/// Canonical Sources:
/// - docs/04_contracts/database_schema.md#sample_requests
/// - docs/04_contracts/database_schema.md#sample_shipments
/// - docs/04_contracts/financial_computation_contract.md
///
/// Implements:
/// - Acceptance Target 1: Request, shipment, outcome, and follow-up states separate
/// - Acceptance Target 2: Missing outcome not definitive zero
/// - Acceptance Target 3: Replay no duplicate sample cost
library;

/// Fixed micro-units arithmetic for monetary calculations (never float per DB-H-001).
BigInt parseMicros(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return BigInt.zero;
  final neg = trimmed.startsWith('-');
  final unsigned = neg ? trimmed.substring(1) : trimmed;
  final parts = unsigned.split('.');
  final intPart = parts[0].isEmpty ? '0' : parts[0];
  final fracPart = parts.length > 1 ? parts[1] : '';
  final padded = fracPart.padRight(6, '0').substring(0, 6);
  final micros = BigInt.parse('$intPart$padded');
  return neg ? -micros : micros;
}

String formatMicros(BigInt micros) {
  if (micros == BigInt.zero) {
    return '0.000000';
  }
  final scale = BigInt.from(1000000);
  final neg = micros.isNegative;
  final abs = micros.abs();
  final intPart = abs ~/ scale;
  final fracPart = abs % scale;
  final fracStr = fracPart.toString().padLeft(6, '0');
  return '${neg ? '-' : ''}$intPart.$fracStr';
}

enum MobileSampleRequestStatus {
  requested,
  approved,
  declined,
  fulfilled,
  cancelled,
}

enum MobileSampleShipmentStatus {
  preparing,
  shipped,
  delivered,
  lost,
  returned,
  closed,
}

enum MobileSampleOutcomeStatus {
  pending,
  logged,
}

enum MobileFollowUpStatus {
  pendingFollowup,
  contacted,
  responded,
  noResponse,
}

enum MobileSeedingSourceClass {
  official,
  imported,
  inferred,
  estimated,
  unreconciled,
}

enum MobileConfidenceLevel {
  high,
  medium,
  low,
}

class MobileShippingAddress {
  final String name;
  final String phone;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String? postalCode;
  final String country;

  const MobileShippingAddress({
    required this.name,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    this.postalCode,
    required this.country,
  });
}

class MobileSampleOutcome {
  final String? contentUrl;
  final String? contentType;
  final String? publishItemId;
  final int impressions;
  final int views;
  final int engagements;
  final int conversionsCount;
  final String attributableRevenue; // Exact decimal string e.g. "1500000.000000"
  final String currency;
  final MobileSeedingSourceClass sourceClass;
  final MobileConfidenceLevel confidenceLevel;
  final String? confidenceReason;
  final String? notes;
  final DateTime loggedAt;

  const MobileSampleOutcome({
    this.contentUrl,
    this.contentType,
    this.publishItemId,
    this.impressions = 0,
    this.views = 0,
    this.engagements = 0,
    this.conversionsCount = 0,
    required this.attributableRevenue,
    this.currency = 'VND',
    required this.sourceClass,
    required this.confidenceLevel,
    this.confidenceReason,
    this.notes,
    required this.loggedAt,
  });
}

class MobileSampleShipment {
  final String shipmentId;
  final String requestId;
  final String workspaceId;
  final String trackingNumber;
  final String carrier;
  final String shippingCost; // Exact decimal string NUMERIC(18,6)
  final MobileSampleShipmentStatus status;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MobileSampleShipment({
    required this.shipmentId,
    required this.requestId,
    required this.workspaceId,
    required this.trackingNumber,
    required this.carrier,
    required this.shippingCost,
    required this.status,
    this.shippedAt,
    this.deliveredAt,
    required this.createdAt,
    required this.updatedAt,
  });

  MobileSampleShipment copyWith({
    String? trackingNumber,
    String? carrier,
    String? shippingCost,
    MobileSampleShipmentStatus? status,
    DateTime? shippedAt,
    DateTime? deliveredAt,
  }) {
    return MobileSampleShipment(
      shipmentId: shipmentId,
      requestId: requestId,
      workspaceId: workspaceId,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      carrier: carrier ?? this.carrier,
      shippingCost: shippingCost ?? this.shippingCost,
      status: status ?? this.status,
      shippedAt: shippedAt ?? this.shippedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class MobileSampleRequest {
  final String requestId;
  final String workspaceId;
  final String? campaignId;
  final String productId;
  final String productTitle;
  final String productCogs; // Exact decimal string
  final String creatorEntityId;
  final String creatorName;
  final String creatorHandle;
  final String? creatorAvatarUrl;
  final int creatorFollowers;
  final MobileSampleRequestStatus status;
  final int quantity;
  final MobileSampleOutcomeStatus outcomeStatus;
  final MobileSampleOutcome? outcome;
  final MobileFollowUpStatus followUpStatus;
  final MobileShippingAddress shippingAddress;
  final String? contentRequirements;
  final String? deadline;
  final String? declineReason;
  final String? notes;
  final MobileSampleShipment? shipment;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MobileSampleRequest({
    required this.requestId,
    required this.workspaceId,
    this.campaignId,
    required this.productId,
    required this.productTitle,
    required this.productCogs,
    required this.creatorEntityId,
    required this.creatorName,
    required this.creatorHandle,
    this.creatorAvatarUrl,
    this.creatorFollowers = 0,
    required this.status,
    required this.quantity,
    required this.outcomeStatus,
    this.outcome,
    required this.followUpStatus,
    required this.shippingAddress,
    this.contentRequirements,
    this.deadline,
    this.declineReason,
    this.notes,
    this.shipment,
    required this.createdAt,
    required this.updatedAt,
  });

  MobileSampleRequest copyWith({
    MobileSampleRequestStatus? status,
    MobileSampleOutcomeStatus? outcomeStatus,
    MobileSampleOutcome? outcome,
    MobileFollowUpStatus? followUpStatus,
    String? declineReason,
    String? notes,
    MobileSampleShipment? shipment,
  }) {
    return MobileSampleRequest(
      requestId: requestId,
      workspaceId: workspaceId,
      campaignId: campaignId,
      productId: productId,
      productTitle: productTitle,
      productCogs: productCogs,
      creatorEntityId: creatorEntityId,
      creatorName: creatorName,
      creatorHandle: creatorHandle,
      creatorAvatarUrl: creatorAvatarUrl,
      creatorFollowers: creatorFollowers,
      status: status ?? this.status,
      quantity: quantity,
      outcomeStatus: outcomeStatus ?? this.outcomeStatus,
      outcome: outcome ?? this.outcome,
      followUpStatus: followUpStatus ?? this.followUpStatus,
      shippingAddress: shippingAddress,
      contentRequirements: contentRequirements,
      deadline: deadline,
      declineReason: declineReason ?? this.declineReason,
      notes: notes ?? this.notes,
      shipment: shipment ?? this.shipment,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class MobileSeedingCostItem {
  final String costItemId;
  final String workspaceId;
  final String requestId;
  final String costType;
  final String amount; // Exact decimal string
  final String currency;
  final String description;
  final MobileSeedingSourceClass sourceClass;
  final String idempotencyKey;

  const MobileSeedingCostItem({
    required this.costItemId,
    required this.workspaceId,
    required this.requestId,
    this.costType = 'seeding',
    required this.amount,
    this.currency = 'VND',
    required this.description,
    required this.sourceClass,
    required this.idempotencyKey,
  });

  MobileSeedingCostItem copyWith({
    String? amount,
    String? description,
    MobileSeedingSourceClass? sourceClass,
  }) {
    return MobileSeedingCostItem(
      costItemId: costItemId,
      workspaceId: workspaceId,
      requestId: requestId,
      costType: costType,
      amount: amount ?? this.amount,
      currency: currency,
      description: description ?? this.description,
      sourceClass: sourceClass ?? this.sourceClass,
      idempotencyKey: idempotencyKey,
    );
  }
}

class MobileSeedingReport {
  final String? campaignId;
  final String workspaceId;
  final int totalSamplesRequested;
  final int totalSamplesApproved;
  final int totalSamplesShipped;
  final int totalSamplesDelivered;
  final int outcomesLoggedCount;
  final int pendingOutcomesCount;
  final String outcomeCoverageRate;
  final String totalCogs;
  final String totalShipping;
  final String totalCost;
  final String attributableRevenue;
  final String roiPercentage;
  final MobileConfidenceLevel overallConfidence;
  final List<String> confidenceNotes;
  final String currency;
  final bool isMissingOutcomePending;

  const MobileSeedingReport({
    this.campaignId,
    required this.workspaceId,
    required this.totalSamplesRequested,
    required this.totalSamplesApproved,
    required this.totalSamplesShipped,
    required this.totalSamplesDelivered,
    required this.outcomesLoggedCount,
    required this.pendingOutcomesCount,
    required this.outcomeCoverageRate,
    required this.totalCogs,
    required this.totalShipping,
    required this.totalCost,
    required this.attributableRevenue,
    required this.roiPercentage,
    required this.overallConfidence,
    required this.confidenceNotes,
    this.currency = 'VND',
    required this.isMissingOutcomePending,
  });
}

/// Computes Seeding Report enforcing Acceptance Target 1, Target 2, and non-float arithmetic.
MobileSeedingReport computeMobileSeedingReport({
  required List<MobileSampleRequest> requests,
  required String workspaceId,
  String? campaignId,
  String currency = 'VND',
}) {
  int totalRequested = requests.length;
  int totalApproved = 0;
  int totalShipped = 0;
  int totalDelivered = 0;
  int outcomesLogged = 0;

  BigInt cogsMicros = BigInt.zero;
  BigInt shippingMicros = BigInt.zero;
  BigInt revenueMicros = BigInt.zero;

  var lowestConfidence = MobileConfidenceLevel.high;

  for (final req in requests) {
    if (req.status == MobileSampleRequestStatus.approved ||
        req.status == MobileSampleRequestStatus.fulfilled) {
      totalApproved++;
    }

    // Accumulate COGS: quantity * unit COGS
    final unitCogs = parseMicros(req.productCogs);
    cogsMicros += unitCogs * BigInt.from(req.quantity);

    // Physical shipment tracking (Target 1: separate state)
    if (req.shipment != null) {
      if (req.shipment!.status == MobileSampleShipmentStatus.shipped ||
          req.shipment!.status == MobileSampleShipmentStatus.delivered) {
        totalShipped++;
      }
      if (req.shipment!.status == MobileSampleShipmentStatus.delivered) {
        totalDelivered++;
      }
      shippingMicros += parseMicros(req.shipment!.shippingCost);
    }

    // Business outcome tracking (Target 1: separate state)
    if (req.outcomeStatus == MobileSampleOutcomeStatus.logged && req.outcome != null) {
      outcomesLogged++;
      revenueMicros += parseMicros(req.outcome!.attributableRevenue);
      if (req.outcome!.confidenceLevel == MobileConfidenceLevel.low) {
        lowestConfidence = MobileConfidenceLevel.low;
      } else if (req.outcome!.confidenceLevel == MobileConfidenceLevel.medium &&
          lowestConfidence != MobileConfidenceLevel.low) {
        lowestConfidence = MobileConfidenceLevel.medium;
      }
    }
  }

  final totalCostMicros = cogsMicros + shippingMicros;
  final notes = <String>[];
  bool isMissingOutcomePending = false;
  int pendingOutcomes = 0;

  // Acceptance Target 2: Missing outcome is NOT definitive zero!
  if (totalDelivered > outcomesLogged) {
    pendingOutcomes = totalDelivered - outcomesLogged;
    isMissingOutcomePending = true;
    notes.add('$pendingOutcomes delivered sample(s) have pending content/conversion outcomes; missing data is not counted as zero revenue');
    if (lowestConfidence == MobileConfidenceLevel.high) {
      lowestConfidence = MobileConfidenceLevel.medium;
    }
  } else if (totalDelivered == 0) {
    notes.add('No samples delivered yet; pending delivery and creator review');
    lowestConfidence = MobileConfidenceLevel.medium;
  } else {
    notes.add('All delivered samples have logged outcomes with verified evidence');
  }

  // Coverage rate
  String coverageRate = '0.0%';
  if (totalDelivered > 0) {
    final pct = (outcomesLogged / totalDelivered) * 100.0;
    coverageRate = '${pct.toStringAsFixed(1)}%';
  }

  // ROI Percentage
  String roiPercentage = '0.0%';
  if (totalCostMicros > BigInt.zero) {
    final netGainMicros = revenueMicros - totalCostMicros;
    final roi = (netGainMicros.toDouble() / totalCostMicros.toDouble()) * 100.0;
    roiPercentage = '${roi >= 0 ? '+' : ''}${roi.toStringAsFixed(1)}%';
  }

  return MobileSeedingReport(
    campaignId: campaignId,
    workspaceId: workspaceId,
    totalSamplesRequested: totalRequested,
    totalSamplesApproved: totalApproved,
    totalSamplesShipped: totalShipped,
    totalSamplesDelivered: totalDelivered,
    outcomesLoggedCount: outcomesLogged,
    pendingOutcomesCount: pendingOutcomes,
    outcomeCoverageRate: coverageRate,
    totalCogs: formatMicros(cogsMicros),
    totalShipping: formatMicros(shippingMicros),
    totalCost: formatMicros(totalCostMicros),
    attributableRevenue: formatMicros(revenueMicros),
    roiPercentage: roiPercentage,
    overallConfidence: lowestConfidence,
    confidenceNotes: notes,
    currency: currency,
    isMissingOutcomePending: isMissingOutcomePending,
  );
}

/// Evaluates approval and shipment idempotency ensuring no duplicate cost items (Target 3).
class MobileIdempotentCostResult {
  final List<MobileSeedingCostItem> costItems;
  final MobileSeedingCostItem activeCostItem;
  final bool isReplay;
  final String totalCost;

  const MobileIdempotentCostResult({
    required this.costItems,
    required this.activeCostItem,
    required this.isReplay,
    required this.totalCost,
  });
}

MobileIdempotentCostResult evaluateMobileIdempotentCost({
  required List<MobileSeedingCostItem> existingCostItems,
  required String requestId,
  required String workspaceId,
  required int quantity,
  required String unitCogs,
  required String shippingCost,
  required String idempotencyKey,
  required bool isShippingUpdate,
}) {
  final items = List<MobileSeedingCostItem>.from(existingCostItems);
  final existingIndex = items.indexWhere((c) => c.requestId == requestId);

  final totalCogsMicros = parseMicros(unitCogs) * BigInt.from(quantity);
  final shippingMicros = parseMicros(shippingCost);
  final totalCostMicros = totalCogsMicros + shippingMicros;
  final totalCostStr = formatMicros(totalCostMicros);

  if (existingIndex != -1) {
    // Cost item already exists for this request: update in-place or replay!
    final existing = items[existingIndex];
    if (isShippingUpdate) {
      // Shipped: update existing cost item with actual shipping cost (in-place)
      final updated = existing.copyWith(
        amount: totalCostStr,
        description: 'Seeding cost: $quantity x product + shipping $shippingCost',
        sourceClass: MobileSeedingSourceClass.imported,
      );
      items[existingIndex] = updated;
      return MobileIdempotentCostResult(
        costItems: items,
        activeCostItem: updated,
        isReplay: true, // Recognized as idempotent update
        totalCost: totalCostStr,
      );
    } else {
      // Replay approval with same or existing key: return existing without duplicating
      return MobileIdempotentCostResult(
        costItems: items,
        activeCostItem: existing,
        isReplay: true,
        totalCost: existing.amount,
      );
    }
  }

  // First time approval: create provisional cost item
  final newItem = MobileSeedingCostItem(
    costItemId: 'cost-${DateTime.now().millisecondsSinceEpoch}',
    workspaceId: workspaceId,
    requestId: requestId,
    amount: formatMicros(totalCogsMicros),
    description: 'Provisional seeding cost: $quantity x product',
    sourceClass: MobileSeedingSourceClass.estimated,
    idempotencyKey: idempotencyKey,
  );
  items.add(newItem);

  return MobileIdempotentCostResult(
    costItems: items,
    activeCostItem: newItem,
    isReplay: false,
    totalCost: formatMicros(totalCogsMicros),
  );
}
