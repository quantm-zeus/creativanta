import 'package:creativanta_mobile/generated/creativanta/admin/v1/diagnostics.pb.dart';

/// Canonical external_effects states (§26.8).
enum MobileExternalEffectStatus {
  prepared,
  submitted,
  succeeded,
  failed,
  unknown,
  cancelled,
}

/// Verdict returned by the P0-05 external effects guard on Mobile (M059).
class ExternalEffectGuardVerdict {
  const ExternalEffectGuardVerdict({
    required this.allowBlindRetry,
    required this.decisionKey,
    required this.explanation,
  });

  final bool allowBlindRetry;
  final String decisionKey;
  final String explanation;
}

/// Evaluates whether an external side effect can be retried automatically.
/// Unresolved (`unknown` or `submitted`) outcomes are never blindly retried.
ExternalEffectGuardVerdict evaluateMobileExternalEffectGuard(
  MobileExternalEffectStatus status,
) {
  switch (status) {
    case MobileExternalEffectStatus.unknown:
    case MobileExternalEffectStatus.submitted:
      return const ExternalEffectGuardVerdict(
        allowBlindRetry: false,
        decisionKey: 'blocked_requires_reconciliation',
        explanation:
            'Kết quả tác vụ bên ngoài chưa xác định (unknown/submitted). Khóa tự động gửi lại để tránh nhân đôi tác vụ.',
      );
    case MobileExternalEffectStatus.succeeded:
      return const ExternalEffectGuardVerdict(
        allowBlindRetry: false,
        decisionKey: 'already_succeeded',
        explanation:
            'Tác vụ đã hoàn tất trước đó; không gọi lại nền tảng đối tác.',
      );
    case MobileExternalEffectStatus.cancelled:
      return const ExternalEffectGuardVerdict(
        allowBlindRetry: false,
        decisionKey: 'blocked_cancelled',
        explanation: 'Tác vụ đã bị hủy chủ động.',
      );
    case MobileExternalEffectStatus.prepared:
    case MobileExternalEffectStatus.failed:
      return const ExternalEffectGuardVerdict(
        allowBlindRetry: true,
        decisionKey: 'proceed',
        explanation:
            'Tác vụ chưa phát sinh hiệu ứng ngoài hoặc đã bị từ chối rõ ràng; cho phép gửi lại có kiểm soát.',
      );
  }
}

/// Enforces RULE-M23-A04 on Mobile (M059): strips raw SQL, stack traces, and tokens.
String sanitizeMobileDiagnosticExplanation(String rawText) {
  final trimmed = rawText.trim();
  if (trimmed.isEmpty) {
    return 'Hệ thống ghi nhận cảnh báo cần kiểm tra trong Chẩn đoán (M059).';
  }
  final lower = trimmed.toLowerCase();
  const forbiddenFragments = <String>[
    'select ',
    'insert into ',
    'update ',
    'delete from ',
    'sqlstate',
    'goroutine ',
    'panic:',
    'access_token',
    'refresh_token',
    'signing_secret',
  ];
  for (final frag in forbiddenFragments) {
    if (lower.contains(frag)) {
      return 'Hệ thống phát hiện sự cố kỹ thuật trên thành phần này. Vui lòng mở Trình sửa lỗi 4 bước để kiểm tra an toàn.';
    }
  }
  return trimmed;
}

/// Checks whether a step in the 4-step repair wizard is permitted.
bool canExecuteMobileRepairStep({
  required RepairWizardStep step,
  required bool requiresManualReconciliation,
  required String verificationReference,
}) {
  if (step == RepairWizardStep.REPAIR_WIZARD_STEP_UNSPECIFIED) {
    return false;
  }
  if (step == RepairWizardStep.REPAIR_WIZARD_STEP_FIX &&
      requiresManualReconciliation &&
      verificationReference.trim().isEmpty) {
    return false;
  }
  return true;
}
