import 'package:flutter/material.dart';
import '../../intelligence/intelligence_models.dart';

/// Access evidence badge for mobile views.
/// Enforces Acceptance Target 1: "Every live source has access evidence".
class AccessEvidenceBadge extends StatelessWidget {
  const AccessEvidenceBadge({
    super.key,
    required this.result,
    this.onReconnect,
  });

  final AccessProofResult result;
  final VoidCallback? onReconnect;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color text;
    String label;
    IconData icon;

    switch (result.status) {
      case SourceVerificationStatus.verified:
        bg = const Color(0xFFECFDF5);
        border = const Color(0xFFA7F3D0);
        text = const Color(0xFF047857);
        label = 'Xác minh chính thức';
        icon = Icons.verified_user_outlined;
        break;
      case SourceVerificationStatus.imported:
        bg = const Color(0xFFEFF6FF);
        border = const Color(0xFFBFDBFE);
        text = const Color(0xFF1D4ED8);
        label = 'Nhập thủ công';
        icon = Icons.file_download_done_outlined;
        break;
      case SourceVerificationStatus.degraded:
        bg = const Color(0xFFFFFBEB);
        border = const Color(0xFFFDE68A);
        text = const Color(0xFFB45309);
        label = 'Suy thoái kết nối';
        icon = Icons.warning_amber_rounded;
        break;
      case SourceVerificationStatus.unsupported:
        bg = const Color(0xFFFEF2F2);
        border = const Color(0xFFFECACA);
        text = const Color(0xFFB91C1C);
        label = 'Chưa xác thực';
        icon = Icons.lock_outline_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
          if (result.reconnectRequired && onReconnect != null) ...[
            const SizedBox(width: 6),
            InkWell(
              onTap: onReconnect,
              child: Text(
                'Làm mới',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: text,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Banner warning when a live source is in degraded state.
class DegradedStateBanner extends StatelessWidget {
  const DegradedStateBanner({
    super.key,
    required this.result,
    required this.onReconnect,
  });

  final AccessProofResult result;
  final VoidCallback onReconnect;

  @override
  Widget build(BuildContext context) {
    if (!result.isDegraded) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFB45309), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảnh báo kết nối: ${result.platform.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF92400E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  result.degradedReason ?? 'Phiên truy cập đã hết hạn. Hiển thị từ bộ nhớ đệm.',
                  style: const TextStyle(fontSize: 11, color: Color(0xFFB45309)),
                ),
                const SizedBox(height: 6),
                OutlinedButton(
                  onPressed: onReconnect,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF92400E),
                    side: const BorderSide(color: Color(0xFFD97706)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Kết nối lại tài khoản', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Downstream Phase Gating card showing task assignment and preserved lineage.
/// Enforces Acceptance Target 2: "Future conversions remain assigned to later tasks".
class DownstreamGatingNoticeCard extends StatelessWidget {
  const DownstreamGatingNoticeCard({
    super.key,
    required this.targetType,
    required this.opportunityId,
    this.convertedDraftId,
  });

  final String targetType;
  final String opportunityId;
  final String? convertedDraftId;

  @override
  Widget build(BuildContext context) {
    final policy = getDownstreamGatePolicy(targetType);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC7D2FE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule_outlined, size: 16, color: Color(0xFF4338CA)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Giai đoạn ${policy.phaseAssigned}: ${policy.targetModuleName}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3730A3),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  policy.taskRef,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3730A3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            policy.explanation,
            style: const TextStyle(fontSize: 11, color: Color(0xFF4338CA), height: 1.3),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFC7D2FE)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                '🛡️ Bảo tồn xuất xứ:',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF3730A3)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: const Color(0xFFC7D2FE)),
                ),
                child: Text(
                  'Gốc: $opportunityId',
                  style: const TextStyle(fontSize: 9, fontFamily: 'monospace', color: Colors.black87),
                ),
              ),
              if (convertedDraftId != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: const Color(0xFFC7D2FE)),
                  ),
                  child: Text(
                    'Nháp: $convertedDraftId',
                    style: const TextStyle(fontSize: 9, fontFamily: 'monospace', color: Colors.black87),
                  ),
                ),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  'draft_linked',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
