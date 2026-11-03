import 'package:flutter/material.dart';
import 'package:creativanta_mobile/competitor/competitor_models.dart';
import 'package:creativanta_mobile/ui/competitor/competitor_why_sheet.dart';

/// Screen W041 Mobile: Benchmark Comparison View
class BenchmarkComparisonView extends StatefulWidget {
  const BenchmarkComparisonView({super.key});

  @override
  State<BenchmarkComparisonView> createState() => _BenchmarkComparisonViewState();
}

class _BenchmarkComparisonViewState extends State<BenchmarkComparisonView> {
  // Acceptance Target 2: Stale snapshot state (40 days old > 30 days)
  late DateTime _capturedAt;

  @override
  void initState() {
    super.initState();
    // Simulate initial snapshot captured 40 days ago to verify staleness banner
    _capturedAt = DateTime.now().subtract(const Duration(days: 40));
  }

  void _refreshData() {
    setState(() {
      _capturedAt = DateTime.now(); // Fresh snapshot
    });
  }

  void _openWhitepsaceWhy(WhiteSpaceOpportunity gap) {
    CompetitorWhySheet.show(
      context,
      title: gap.title,
      whyExplanation: gap.whyExplanation,
      sourceClass: gap.sourceClass,
      confidence: gap.confidence,
    );
  }

  @override
  Widget build(BuildContext context) {
    final daysOld = DateTime.now().difference(_capturedAt).inDays;
    final isStale = daysOld > 30;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F5),
      appBar: AppBar(
        title: const Text(
          '📊 So sánh Benchmark (W041)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF242924)),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Acceptance Target 2: Stale snapshot banner
          if (isStale) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF5F3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD94A31)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFD94A31), size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DỮ LIỆU ĐÃ CŨ (>30 NGÀY)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD94A31),
                          ),
                        ),
                        Text(
                          'Ảnh chụp đã lưu $daysOld ngày trước. Nhấn làm mới để cập nhật.',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF616C63)),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _refreshData,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFD94A31),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                    child: const Text('Làm mới', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Overall Score / Podium Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE7E2D7)),
            ),
            child: Column(
              children: [
                const Text(
                  'XẾP HẠNG TỔNG THỂ',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF616C63)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Bạn đứng #2 trong 3 kênh so sánh',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF242924)),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _podiumCol('🥈 #2 Bạn', '78đ', const Color(0xFF274333), 60),
                    _podiumCol('🏆 #1 Skincare', '88đ', Colors.amber.shade700, 80),
                    _podiumCol('🥉 #3 Beauty', '64đ', const Color(0xFF616C63), 50),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Comparative Metrics Table (Acceptance Target 3)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE7E2D7)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BẢNG SO SÁNH CHỈ SỐ',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF242924)),
                ),
                const SizedBox(height: 10),
                _tableRow('Chỉ số', 'Bạn', '@skincare', isHeader: true),
                const Divider(),
                _tableRow('Followers', '125K', '245K 🏆'),
                _tableRow('Tương tác', '9.8% 🏆', '7.5%'),
                _tableRow('Tăng 30d', '+8.5%', '+14.2% 🏆'),
                _tableRow('Views TB', '45K', '120K 🏆'),

                // Acceptance Target 3: Revenue row strictly private "—"
                _tableRow('Doanh thu*', 'Bảo mật', RevenueMetricGuard.privateDisplayValue, isGuarded: true),
                const SizedBox(height: 8),
                const Text(
                  '* Doanh thu đối thủ không được so sánh (bảo mật và tách biệt tuyệt đối khỏi Sổ cái M19).',
                  style: TextStyle(fontSize: 10, color: Color(0xFF8A968C), fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Acceptance Target 1: White-Space Opportunities Section
          const Text(
            '🎯 Khoảng trống thị trường (White-Space)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF242924)),
          ),
          const SizedBox(height: 8),
          _buildGapCard(
            title: 'Phân tích thành phần B5 phục hồi da ban đêm',
            demand: 'Rất cao (+120%)',
            saturation: 'Rất thấp (0 video)',
            score: 94,
            why: const WhyExplanationModel(
              basisSummary: 'Nhu cầu tìm kiếm serum ban đêm tăng vọt nhưng đối thủ chưa có nội dung tương ứng.',
              dataSources: ['TikTok Keyword Search Analytics', 'Shopee Product Search Demand'],
              limitations: ['Dữ liệu phản ánh 14 ngày gần nhất'],
              dataGaps: ['Không có số liệu đơn hàng thực tế của đối thủ'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _podiumCol(String label, String score, Color color, double height) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color),
          ),
          alignment: Alignment.center,
          child: Text(score, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _tableRow(String c1, String c2, String c3, {bool isHeader = false, bool isGuarded = false}) {
    final style = TextStyle(
      fontSize: 12,
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      color: isGuarded ? const Color(0xFF8A968C) : const Color(0xFF242924),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(c1, style: style)),
          Expanded(flex: 2, child: Text(c2, style: style.copyWith(color: isHeader ? null : const Color(0xFF274333)))),
          Expanded(flex: 2, child: Text(c3, style: style)),
        ],
      ),
    );
  }

  Widget _buildGapCard({
    required String title,
    required String demand,
    required String saturation,
    required int score,
    required WhyExplanationModel why,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFFE7E2D7)),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF9C3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '🏷️ INFERRED',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF854D0E)),
                  ),
                ),
                Text('Tiềm năng: $score/100', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF274333))),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            Text('Nhu cầu: $demand • Mật độ đối thủ: $saturation', style: const TextStyle(fontSize: 11, color: Color(0xFF616C63))),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _openWhitepsaceWhy(
                WhiteSpaceOpportunity(
                  id: 'gap-1',
                  title: title,
                  description: '',
                  niche: 'Skincare',
                  potentialScore: score,
                  estimatedDemand: demand,
                  competitorSaturation: saturation,
                  whyExplanation: why,
                ),
              ),
              child: const Text(
                'Xem cơ sở suy luận (Why?) →',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF274333), decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
