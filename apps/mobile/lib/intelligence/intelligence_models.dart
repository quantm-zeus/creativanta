import 'package:creativanta_mobile/generated/creativanta/intelligence/v1/trend.pbenum.dart';

/// Source verification status enum for mobile client.
enum SourceVerificationStatus {
  verified,
  imported,
  degraded,
  unsupported,
}

/// Represents the access proof record for a live data connector.
/// Enforces Acceptance Target 1: "Every live source has access evidence".
class AccessProofResult {
  const AccessProofResult({
    required this.platform,
    required this.actionKey,
    required this.status,
    required this.isVerified,
    required this.isDegraded,
    required this.sourceClass,
    required this.confidenceBand,
    required this.evidenceRef,
    required this.grantedScopes,
    required this.requiredScopes,
    required this.endpoint,
    required this.checkedAt,
    this.validUntil,
    this.degradedReason,
    this.fallbackNote,
    this.canFallbackToImport = true,
    this.reconnectRequired = false,
  });

  final String platform;
  final String actionKey;
  final SourceVerificationStatus status;
  final bool isVerified;
  final bool isDegraded;
  final SourceClass sourceClass;
  final ConfidenceBand confidenceBand;
  final String evidenceRef;
  final List<String> grantedScopes;
  final List<String> requiredScopes;
  final String endpoint;
  final DateTime checkedAt;
  final DateTime? validUntil;
  final String? degradedReason;
  final String? fallbackNote;
  final bool canFallbackToImport;
  final bool reconnectRequired;
}

/// Represents downstream phase gating policy for conversion targets.
/// Enforces Acceptance Target 2: "Future conversions remain assigned to later tasks".
class DownstreamPhaseGate {
  const DownstreamPhaseGate({
    required this.targetType,
    required this.targetModule,
    required this.targetModuleName,
    required this.phaseAssigned,
    required this.taskRef,
    required this.isExecutableInP2,
    required this.explanation,
  });

  final String targetType; // 'idea', 'script', 'campaign', 'live_plan'
  final String targetModule; // 'M05', 'M06', 'M14', 'M17'
  final String targetModuleName;
  final String phaseAssigned; // 'P3' or 'P6'
  final String taskRef; // 'P3-01', 'P3-02', 'P6-01', 'P6-02'
  final bool isExecutableInP2; // false in P2
  final String explanation;
}

/// Returns downstream phase gating policy for a given conversion target.
DownstreamPhaseGate getDownstreamGatePolicy(String targetType) {
  switch (targetType) {
    case 'idea':
      return const DownstreamPhaseGate(
        targetType: 'idea',
        targetModule: 'M05',
        targetModuleName: 'Idea Board (Ý tưởng nội dung)',
        phaseAssigned: 'P3',
        taskRef: 'P3-01',
        isExecutableInP2: false,
        explanation: 'Khởi tạo Idea và quy trình AI drafting được giao cho Phase P3 (M05). Trong Phase P2, liên kết nháp được tạo với dòng xuất xứ đầy đủ.',
      );
    case 'script':
      return const DownstreamPhaseGate(
        targetType: 'script',
        targetModule: 'M06',
        targetModuleName: 'Script Studio (Kịch bản video)',
        phaseAssigned: 'P3',
        taskRef: 'P3-02',
        isExecutableInP2: false,
        explanation: 'Khởi tạo kịch bản 30-60s và AI hook gợi ý thuộc Phase P3 (M06). Trong Phase P2, đối tượng được lưu dưới dạng draft_linked.',
      );
    case 'campaign':
      return const DownstreamPhaseGate(
        targetType: 'campaign',
        targetModule: 'M14',
        targetModuleName: 'Campaign Hub (Chiến dịch đa kênh)',
        phaseAssigned: 'P6',
        taskRef: 'P6-01',
        isExecutableInP2: false,
        explanation: 'Điều phối chiến dịch đa nền tảng và phân bổ ngân sách thuộc Phase P6 (M14). Trong Phase P2, thông tin được bảo lưu lineage.',
      );
    case 'live_plan':
      return const DownstreamPhaseGate(
        targetType: 'live_plan',
        targetModule: 'M17',
        targetModuleName: 'Live Studio (Kế hoạch phát sóng trực tiếp)',
        phaseAssigned: 'P6',
        taskRef: 'P6-02',
        isExecutableInP2: false,
        explanation: 'Kế hoạch phiên live và phân bổ cue cards thuộc Phase P6 (M17). Trong Phase P2, liên kết bảo tồn nguồn gốc cơ hội.',
      );
    default:
      throw ArgumentError('Unsupported downstream target: $targetType');
  }
}

/// Evaluates access evidence and expiration for live connectors.
AccessProofResult verifyLiveSourceAccess({
  required String platform,
  required String actionKey,
  String evidenceRef = '',
  List<String> grantedScopes = const [],
  List<String> requiredScopes = const [],
  String endpoint = '',
  DateTime? validUntil,
  bool isDegraded = false,
  String? degradedReason,
  DateTime? checkedAt,
}) {
  final now = DateTime.now().toUtc();
  final checkTime = checkedAt ?? now;
  final isExpired = validUntil != null && validUntil.isBefore(now);
  final missingScopes = requiredScopes.where((s) => !grantedScopes.contains(s)).toList();

  if (evidenceRef.isEmpty || missingScopes.isNotEmpty) {
    return AccessProofResult(
      platform: platform,
      actionKey: actionKey,
      status: SourceVerificationStatus.unsupported,
      isVerified: false,
      isDegraded: false,
      sourceClass: SourceClass.SOURCE_CLASS_UNSPECIFIED,
      confidenceBand: ConfidenceBand.CONFIDENCE_BAND_LOW,
      evidenceRef: evidenceRef,
      grantedScopes: grantedScopes,
      requiredScopes: requiredScopes,
      endpoint: endpoint,
      checkedAt: checkTime,
      validUntil: validUntil,
      degradedReason: missingScopes.isNotEmpty
          ? 'Thiếu quyền truy cập OAuth: ${missingScopes.join(", ")}'
          : 'Chưa có bằng chứng xác thực hợp lệ',
      fallbackNote: 'Có thể sử dụng chức năng Nhập dữ liệu thủ công / Tệp CSV để tiếp tục',
      canFallbackToImport: true,
      reconnectRequired: true,
    );
  }

  if (isExpired || isDegraded) {
    return AccessProofResult(
      platform: platform,
      actionKey: actionKey,
      status: SourceVerificationStatus.degraded,
      isVerified: true,
      isDegraded: true,
      sourceClass: SourceClass.SOURCE_CLASS_OFFICIAL,
      confidenceBand: ConfidenceBand.CONFIDENCE_BAND_MEDIUM,
      evidenceRef: evidenceRef,
      grantedScopes: grantedScopes,
      requiredScopes: requiredScopes,
      endpoint: endpoint,
      checkedAt: checkTime,
      validUntil: validUntil,
      degradedReason: degradedReason ?? (isExpired ? 'Phiên truy cập đã hết hạn (Token expired)' : 'Kết nối bị suy thoái'),
      fallbackNote: 'Dữ liệu hiển thị từ bộ nhớ đệm gần nhất. Vui lòng kết nối lại tài khoản.',
      canFallbackToImport: true,
      reconnectRequired: true,
    );
  }

  return AccessProofResult(
    platform: platform,
    actionKey: actionKey,
    status: SourceVerificationStatus.verified,
    isVerified: true,
    isDegraded: false,
    sourceClass: SourceClass.SOURCE_CLASS_OFFICIAL,
    confidenceBand: ConfidenceBand.CONFIDENCE_BAND_HIGH,
    evidenceRef: evidenceRef,
    grantedScopes: grantedScopes,
    requiredScopes: requiredScopes,
    endpoint: endpoint,
    checkedAt: checkTime,
    validUntil: validUntil,
    canFallbackToImport: false,
    reconnectRequired: false,
  );
}

/// Neutralizes formula injection (=, +, -, @, \t, \r) for mobile imports.
String neutralizeSpreadsheetFormula(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';
  final firstChar = trimmed[0];
  if (firstChar == '=' || firstChar == '+' || firstChar == '-' || firstChar == '@' || firstChar == '\t' || firstChar == '\r') {
    return "'$trimmed";
  }
  return trimmed;
}

/// Financial non-conflation guard:
/// Blocks observational competitor data or estimated opportunity profit from routing into M19 Operating Ledger.
bool validateFinancialNonConflation(String sourceModule, bool isActualFinancialLedger) {
  if (isActualFinancialLedger && (sourceModule == 'M02' || sourceModule == 'M03' || sourceModule == 'M04')) {
    return false; // strictly forbidden
  }
  return true;
}

/// Evaluates empty state and degraded summary for mobile UI.
class EmptyDegradedSummary {
  const EmptyDegradedSummary({
    required this.hasEmptyState,
    required this.connectedCount,
    required this.degradedCount,
    required this.unconnectedCount,
    required this.emptyStateCtas,
    required this.degradedPlatforms,
  });

  final bool hasEmptyState;
  final int connectedCount;
  final int degradedCount;
  final int unconnectedCount;
  final List<String> emptyStateCtas;
  final List<String> degradedPlatforms;
}

EmptyDegradedSummary evaluateEmptyOrDegraded(
  List<Map<String, dynamic>> workspaceAccounts,
) {
  int connected = 0;
  int degraded = 0;
  int unconnected = 0;
  final degradedPlatforms = <String>[];

  for (final acc in workspaceAccounts) {
    final isConn = acc['isConnected'] as bool? ?? false;
    final isExp = acc['tokenExpired'] as bool? ?? false;
    final platform = acc['platform'] as String? ?? 'unknown';

    if (isConn && !isExp) {
      connected++;
    } else if (isConn && isExp) {
      degraded++;
      degradedPlatforms.add(platform);
    } else {
      unconnected++;
    }
  }

  final hasEmptyState = connected == 0 && degraded == 0;
  final emptyStateCtas = <String>[];
  if (hasEmptyState) {
    emptyStateCtas.add('Kết nối tài khoản mạng xã hội (TikTok, Meta, YouTube, Shopee)');
    emptyStateCtas.add('Nhập thủ công dữ liệu xu hướng qua tệp CSV / Excel');
    emptyStateCtas.add('Khám phá dữ liệu xu hướng công khai từ Google Trends');
  }

  return EmptyDegradedSummary(
    hasEmptyState: hasEmptyState,
    connectedCount: connected,
    degradedCount: degraded,
    unconnectedCount: unconnected,
    emptyStateCtas: emptyStateCtas,
    degradedPlatforms: degradedPlatforms,
  );
}
