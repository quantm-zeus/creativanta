import 'package:flutter/material.dart';

class WhyNumberSheet extends StatelessWidget {
  const WhyNumberSheet({
    super.key,
    required this.metricTitle,
    required this.displayValue,
    required this.dataSourceBadge,
    required this.confidenceLevel,
    required this.calculationFormula,
    required this.caveats,
    required this.nextSteps,
    this.isCustomerVerified = false,
  });

  final String metricTitle;
  final String displayValue;
  final String dataSourceBadge; // 'OFFICIAL' | 'IMPORTED' | 'INFERRED' | 'DEMO'
  final String confidenceLevel; // 'HIGH' | 'MEDIUM' | 'LOW'
  final String calculationFormula;
  final List<String> caveats;
  final List<String> nextSteps;
  final bool isCustomerVerified;

  static const Color paper = Color(0xFFFBF9F5);
  static const Color surface = Color(0xFFFFFEFA);
  static const Color ink = Color(0xFF242924);
  static const Color forest = Color(0xFF274333);
  static const Color vermilion = Color(0xFFD94A31);
  static const Color textMuted = Color(0xFF7D837B);
  static const Color border = Color(0xFFE8E5DC);

  static Future<void> show({
    required BuildContext context,
    required String metricTitle,
    required String displayValue,
    required String dataSourceBadge,
    required String confidenceLevel,
    required String calculationFormula,
    required List<String> caveats,
    required List<String> nextSteps,
    bool isCustomerVerified = false,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WhyNumberSheet(
        metricTitle: metricTitle,
        displayValue: displayValue,
        dataSourceBadge: dataSourceBadge,
        confidenceLevel: confidenceLevel,
        calculationFormula: calculationFormula,
        caveats: caveats,
        nextSteps: nextSteps,
        isCustomerVerified: isCustomerVerified,
      ),
    );
  }

  (String label, Color bg, Color text) _badgeMeta() {
    switch (dataSourceBadge) {
      case 'OFFICIAL':
        return ('Chính thức (Official API)', const Color(0xFFEFF5F0), forest);
      case 'IMPORTED':
        return ('Nhập liệu (Imported CSV)', const Color(0xFFEDF4FB), const Color(0xFF1E40AF));
      case 'INFERRED':
        return ('Suy luận AI (Inferred)', const Color(0xFFFEF9C3), const Color(0xFF854D0E));
      case 'DEMO':
      default:
        return ('Dữ liệu mẫu (Demo Fixture)', const Color(0xFFFBEEE9), vermilion);
    }
  }

  @override
  Widget build(BuildContext context) {
    final badge = _badgeMeta();
    final isDemo = dataSourceBadge == 'DEMO';

    return Container(
      decoration: const BoxDecoration(
        color: paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4D0C5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Badge & Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badge.$2,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: badge.$3.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      badge.$1,
                      style: TextStyle(
                        color: badge.$3,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isDemo) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: vermilion,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'CÁCH LY: KHÔNG CỘNG DỒN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                metricTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ink,
                ),
              ),
              const SizedBox(height: 16),

              // Value Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    const Text(
                      'GIÁ TRỊ HIỂN THỊ',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      displayValue,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: isDemo ? vermilion : forest,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Độ tin cậy: $confidenceLevel',
                      style: const TextStyle(
                        fontSize: 11,
                        color: textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Strict Demo Isolation Warning (Acceptance Target 3)
              if (isDemo) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBEEE9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: vermilion.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Bảo vệ dữ liệu khách hàng (Acceptance Target 3)',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: vermilion,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Dữ liệu mẫu fixture tĩnh độc lập nhằm mục đích trải nghiệm ban đầu. Hệ thống kế toán Creativanta tuyệt đối không cộng gộp số tiền này vào tổng doanh thu thực nhận hay số dư tài khoản của bạn.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          color: Color(0xFF8B2C19),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Formula
              const SizedBox(height: 16),
              const Text(
                'Công thức tính toán (Formula)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ink),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EFEA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: border),
                ),
                child: Text(
                  calculationFormula,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: ink,
                  ),
                ),
              ),

              // Caveats
              if (caveats.isNotEmpty) ...[
                const SizedBox(height: 14),
                const Text(
                  'Lưu ý quan trọng',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ink),
                ),
                const SizedBox(height: 6),
                for (final caveat in caveats)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: textMuted)),
                        Expanded(
                          child: Text(
                            caveat,
                            style: const TextStyle(fontSize: 11.5, color: textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],

              // Next Steps
              if (nextSteps.isNotEmpty) ...[
                const SizedBox(height: 14),
                const Text(
                  'Khuyến nghị tiếp theo',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: forest),
                ),
                const SizedBox(height: 6),
                for (final step in nextSteps)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.arrow_forward_rounded, size: 12, color: forest),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            step,
                            style: const TextStyle(fontSize: 11.5, color: forest, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: forest,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Đã hiểu giải trình'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
