import 'package:flutter/material.dart';
import 'package:creativanta_mobile/competitor/competitor_models.dart';
import 'package:creativanta_mobile/generated/creativanta/intelligence/v1/trend.pbenum.dart';

/// Modal bottom sheet presenting the RULE-M03-002 "Why" explanation.
class CompetitorWhySheet extends StatelessWidget {
  const CompetitorWhySheet({
    super.key,
    required this.title,
    required this.whyExplanation,
    this.sourceClass = SourceClass.SOURCE_CLASS_INFERRED,
    this.confidence = ConfidenceBand.CONFIDENCE_BAND_HIGH,
  });

  final String title;
  final WhyExplanationModel whyExplanation;
  final SourceClass sourceClass;
  final ConfidenceBand confidence;

  static void show(
    BuildContext context, {
    required String title,
    required WhyExplanationModel whyExplanation,
    SourceClass sourceClass = SourceClass.SOURCE_CLASS_INFERRED,
    ConfidenceBand confidence = ConfidenceBand.CONFIDENCE_BAND_HIGH,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => CompetitorWhySheet(
        title: title,
        whyExplanation: whyExplanation,
        sourceClass: sourceClass,
        confidence: confidence,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListView(
            controller: scrollController,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7E2D7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Badges
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF9C3),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF854D0E).withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '🏷️ ${sourceClass.name} (Suy luận AI)',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF854D0E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF4ED),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF274333).withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      'Độ tin cậy: ${confidence.name}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF274333),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF242924),
                ),
              ),
              const SizedBox(height: 16),

              // Basis Summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F0E8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CƠ SỞ SUY LUẬN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF616C63),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      whyExplanation.basisSummary,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF242924),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section: Data Sources
              const Text(
                '✅ Nguồn dữ liệu sử dụng',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF274333),
                ),
              ),
              const SizedBox(height: 8),
              ...whyExplanation.dataSources.map(
                (src) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Color(0xFF274333), fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          src,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF242924)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Section: Limitations
              const Text(
                '⚠️ Hạn chế thuật toán',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF854D0E),
                ),
              ),
              const SizedBox(height: 8),
              ...whyExplanation.limitations.map(
                (lim) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Color(0xFF854D0E), fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          lim,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF854D0E)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Section: Data Gaps
              const Text(
                '🚫 Khoảng trống dữ liệu',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD94A31),
                ),
              ),
              const SizedBox(height: 8),
              ...whyExplanation.dataGaps.map(
                (gap) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: Color(0xFFD94A31), fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          gap,
                          style: const TextStyle(fontSize: 12, color: Color(0xFFD94A31)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Understand button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF274333),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Đã hiểu', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
