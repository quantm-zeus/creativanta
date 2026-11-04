import 'package:creativanta_mobile/generated/creativanta/commerce/v1/live.pb.dart';

/// Fixed micro-units arithmetic for monetary calculations (never float per DB-H-001).
BigInt parseMicros(String raw) {
  final trimmed = raw.trim();
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

/// Mobile model for Live Session (RULE-M17-001).
class MobileLiveSession {
  MobileLiveSession({
    required this.sessionId,
    required this.workspaceId,
    required this.title,
    required this.platform,
    required this.status,
    this.actualStartAt,
    this.actualEndAt,
    Map<String, String>? metadata,
  }) : metadata = metadata ?? <String, String>{};

  final String sessionId;
  final String workspaceId;
  final String title;
  final String platform;
  LiveSessionStatus status;
  DateTime? actualStartAt;
  DateTime? actualEndAt;
  final Map<String, String> metadata;
}

/// Mobile model for Cue Cards (RULE-M17-002).
class MobileCueCard {
  MobileCueCard({
    required this.cueCardId,
    required this.sessionId,
    required this.workspaceId,
    required this.cueType,
    required this.title,
    required this.body,
    this.pinnedProductId,
    this.pinnedOfferId,
    required this.displayOrder,
    this.status = CueCardStatus.CUE_CARD_STATUS_PENDING,
    this.triggeredAt,
  });

  final String cueCardId;
  final String sessionId;
  final String workspaceId;
  final String cueType;
  final String title;
  final String body;
  final String? pinnedProductId;
  final String? pinnedOfferId;
  final int displayOrder;
  CueCardStatus status;
  DateTime? triggeredAt;
}

/// Mobile model for Highlights (RULE-M17-002).
class MobileHighlight {
  MobileHighlight({
    required this.highlightId,
    required this.sessionId,
    required this.workspaceId,
    required this.title,
    required this.startOffsetSeconds,
    required this.endOffsetSeconds,
    required this.highlightType,
    this.autoDetected = false,
    this.assetId,
    this.engagementScore = 90.0,
    this.pinnedOfferId,
    this.pinnedProductId,
  });

  final String highlightId;
  final String sessionId;
  final String workspaceId;
  final String title;
  final int startOffsetSeconds;
  final int endOffsetSeconds;
  final String highlightType;
  final bool autoDetected;
  String? assetId; // M09 clip derivative ID
  final double engagementScore;
  final String? pinnedOfferId;
  final String? pinnedProductId;
}

/// Mobile model for Traceable Revenue Order Link (RULE-M17-004, Acceptance Target 3).
class MobileTraceableOrder {
  const MobileTraceableOrder({
    required this.orderId,
    required this.productId,
    required this.offerId,
    required this.customerId,
    required this.amount,
    required this.currency,
    required this.reconciliationState,
  });

  final String orderId;
  final String productId;
  final String offerId;
  final String customerId;
  final String amount;
  final String currency;
  final String reconciliationState;
}

/// Mobile model for Post-Live Proof Summary (RULE-M17-003, RULE-M17-004).
class MobileProofSummary {
  const MobileProofSummary({
    required this.summaryId,
    required this.sessionId,
    required this.workspaceId,
    required this.sessionTitle,
    required this.totalOrders,
    required this.totalRevenue,
    required this.currency,
    required this.sourceClass,
    required this.proofBundleId,
    required this.extractedClipAssetIds,
    required this.orders,
  });

  final String summaryId;
  final String sessionId;
  final String workspaceId;
  final String sessionTitle;
  final int totalOrders;
  final String totalRevenue;
  final String currency;
  final String sourceClass; // "live_attributed"
  final String proofBundleId;
  final List<String> extractedClipAssetIds;
  final List<MobileTraceableOrder> orders;
}

/// Live War Room Controller implementing reconnection deduplication,
/// M07 extraction/M09 derivative link, and traceable revenue summary.
class MobileLiveWarRoomController {
  MobileLiveWarRoomController();

  final Set<String> _executedCommands = <String>{};
  MobileLiveSession? _session;
  final List<MobileCueCard> _cueCards = <MobileCueCard>[];
  final List<MobileHighlight> _highlights = <MobileHighlight>[];
  final List<MobileTraceableOrder> _orders = <MobileTraceableOrder>[];

  MobileLiveSession? get session => _session;
  List<MobileCueCard> get cueCards => List.unmodifiable(_cueCards);
  List<MobileHighlight> get highlights => List.unmodifiable(_highlights);
  List<MobileTraceableOrder> get orders => List.unmodifiable(_orders);

  bool hasExecuted(String? idempotencyKey) {
    if (idempotencyKey == null || idempotencyKey.isEmpty) return false;
    return _executedCommands.contains(idempotencyKey);
  }

  void _recordCommand(String? idempotencyKey) {
    if (idempotencyKey != null && idempotencyKey.isNotEmpty) {
      _executedCommands.add(idempotencyKey);
    }
  }

  /// Create Session (Acceptance Target 1: Reconnect does not duplicate)
  ({MobileLiveSession session, bool isDuplicate}) createSession({
    required String workspaceId,
    required String title,
    String platform = 'tiktok_live',
    String? idempotencyKey,
  }) {
    if (hasExecuted(idempotencyKey) && _session != null) {
      return (session: _session!, isDuplicate: true);
    }

    _session = MobileLiveSession(
      sessionId: 'sess-${DateTime.now().millisecondsSinceEpoch}',
      workspaceId: workspaceId,
      title: title,
      platform: platform,
      status: LiveSessionStatus.LIVE_SESSION_STATUS_PLANNED,
    );

    _recordCommand(idempotencyKey);
    return (session: _session!, isDuplicate: false);
  }

  /// Start Session (Acceptance Target 1: Reconnect does not duplicate)
  ({MobileLiveSession session, bool isDuplicate}) startSession({String? idempotencyKey}) {
    if (_session == null) throw StateError('Session not initialized');
    if (hasExecuted(idempotencyKey) || _session!.status == LiveSessionStatus.LIVE_SESSION_STATUS_LIVE) {
      return (session: _session!, isDuplicate: true);
    }

    _session!.status = LiveSessionStatus.LIVE_SESSION_STATUS_LIVE;
    _session!.actualStartAt = DateTime.now();

    _recordCommand(idempotencyKey);
    return (session: _session!, isDuplicate: false);
  }

  /// Add Cue Card (Acceptance Target 1: Reconnect does not duplicate)
  ({MobileCueCard cueCard, bool isDuplicate}) addCue({
    required String cueType,
    required String title,
    required String body,
    String? pinnedProductId,
    String? pinnedOfferId,
    String? idempotencyKey,
  }) {
    if (_session == null) throw StateError('Session not initialized');
    if (hasExecuted(idempotencyKey)) {
      final existing = _cueCards.firstWhere((c) => c.title == title);
      return (cueCard: existing, isDuplicate: true);
    }

    final cue = MobileCueCard(
      cueCardId: 'cue-${DateTime.now().millisecondsSinceEpoch}-${_cueCards.length}',
      sessionId: _session!.sessionId,
      workspaceId: _session!.workspaceId,
      cueType: cueType,
      title: title,
      body: body,
      pinnedProductId: pinnedProductId,
      pinnedOfferId: pinnedOfferId,
      displayOrder: _cueCards.length + 1,
    );

    _cueCards.add(cue);
    _recordCommand(idempotencyKey);
    return (cueCard: cue, isDuplicate: false);
  }

  /// Trigger Cue Card (Acceptance Target 1)
  ({MobileCueCard cueCard, bool isDuplicate}) triggerCue(String cueCardId, {String? idempotencyKey}) {
    final cue = _cueCards.firstWhere((c) => c.cueCardId == cueCardId);
    if (hasExecuted(idempotencyKey) || cue.status == CueCardStatus.CUE_CARD_STATUS_USED) {
      return (cueCard: cue, isDuplicate: true);
    }

    cue.status = CueCardStatus.CUE_CARD_STATUS_USED;
    cue.triggeredAt = DateTime.now();

    _recordCommand(idempotencyKey);
    return (cueCard: cue, isDuplicate: false);
  }

  /// Highlight Product (pin/unpin, Acceptance Target 1)
  ({bool isPinned, bool isDuplicate}) highlightProduct({
    required String productId,
    required String offerId,
    required bool isPinned,
    int activeOffsetSec = 0,
    String? idempotencyKey,
  }) {
    if (_session == null) throw StateError('Session not initialized');
    if (hasExecuted(idempotencyKey)) {
      return (isPinned: isPinned, isDuplicate: true);
    }

    if (isPinned) {
      _session!.metadata['pinned_product_id'] = productId;
      _session!.metadata['pinned_offer_id'] = offerId;
    } else {
      _session!.metadata.remove('pinned_product_id');
      _session!.metadata.remove('pinned_offer_id');
    }

    _recordCommand(idempotencyKey);
    return (isPinned: isPinned, isDuplicate: false);
  }

  /// Create Highlight (Acceptance Target 1 & 2)
  ({MobileHighlight highlight, bool isDuplicate}) createHighlight({
    required String title,
    required String highlightType,
    required int startSec,
    required int endSec,
    String? pinnedOfferId,
    String? idempotencyKey,
  }) {
    if (_session == null) throw StateError('Session not initialized');
    if (hasExecuted(idempotencyKey)) {
      final existing = _highlights.firstWhere((h) => h.title == title && h.startOffsetSeconds == startSec);
      return (highlight: existing, isDuplicate: true);
    }

    final hl = MobileHighlight(
      highlightId: 'hl-${DateTime.now().millisecondsSinceEpoch}-${_highlights.length}',
      sessionId: _session!.sessionId,
      workspaceId: _session!.workspaceId,
      title: title,
      startOffsetSeconds: startSec,
      endOffsetSeconds: endSec,
      highlightType: highlightType,
      pinnedOfferId: pinnedOfferId,
    );

    _highlights.add(hl);
    _recordCommand(idempotencyKey);
    return (highlight: hl, isDuplicate: false);
  }

  /// M07 extracts, M09 registers clips (Acceptance Target 2)
  ({int extractedCount, List<String> registeredAssetIds, bool isDuplicate}) extractHighlights({
    required String sourceAssetId,
    String? idempotencyKey,
  }) {
    if (sourceAssetId.isEmpty) throw ArgumentError('sourceAssetId cannot be empty');
    if (hasExecuted(idempotencyKey)) {
      final existing = _highlights.where((h) => h.assetId != null).map((h) => h.assetId!).toList();
      return (extractedCount: existing.length, registeredAssetIds: existing, isDuplicate: true);
    }

    final registered = <String>[];
    for (final hl in _highlights) {
      if (hl.assetId == null) {
        // M09 derivative clip registration
        final clipAssetId = 'm09-clip-${DateTime.now().millisecondsSinceEpoch}-${registered.length + 1}';
        hl.assetId = clipAssetId;
        registered.add(clipAssetId);
      } else {
        registered.add(hl.assetId!);
      }
    }

    _recordCommand(idempotencyKey);
    return (extractedCount: registered.length, registeredAssetIds: registered, isDuplicate: false);
  }

  /// Attach Order arriving during live (Acceptance Target 3)
  void attachOrder(MobileTraceableOrder order) {
    _orders.add(order);
  }

  /// Generate Post-Live Proof Summary (Acceptance Target 3, RULE-M17-003, RULE-M17-004)
  MobileProofSummary generateProofSummary() {
    if (_session == null) throw StateError('Session not initialized');

    // Exact BigInt micros aggregation
    var totalMicros = BigInt.zero;
    for (final order in _orders) {
      totalMicros += parseMicros(order.amount);
    }

    final totalRevStr = formatMicros(totalMicros);
    final clipAssets = _highlights.where((h) => h.assetId != null).map((h) => h.assetId!).toList();

    return MobileProofSummary(
      summaryId: 'proof-summary-${DateTime.now().millisecondsSinceEpoch}',
      sessionId: _session!.sessionId,
      workspaceId: _session!.workspaceId,
      sessionTitle: _session!.title,
      totalOrders: _orders.length,
      totalRevenue: totalRevStr,
      currency: 'VND',
      sourceClass: 'live_attributed', // Labeled revenue
      proofBundleId: 'bundle-${DateTime.now().millisecondsSinceEpoch}',
      extractedClipAssetIds: clipAssets,
      orders: List.unmodifiable(_orders),
    );
  }
}
