import 'package:flutter/material.dart';
import 'package:creativanta_mobile/competitor/competitor_models.dart';
import 'package:creativanta_mobile/ui/competitor/competitor_why_sheet.dart';
import 'package:creativanta_mobile/ui/competitor/benchmark_comparison_view.dart';

/// Screen W040 Mobile: Competitor Registry View
class CompetitorRegistryView extends StatefulWidget {
  const CompetitorRegistryView({super.key, this.workspaceId = 'ws-mobile-tenant'});

  final String workspaceId;

  @override
  State<CompetitorRegistryView> createState() => _CompetitorRegistryViewState();
}

class _CompetitorRegistryViewState extends State<CompetitorRegistryView> {
  late List<Competitor> _competitors;
  String _searchQuery = '';
  String _selectedPlatform = 'all';

  @override
  void initState() {
    super.initState();
    _competitors = [
      Competitor(
        id: 'comp-101',
        workspaceId: widget.workspaceId,
        name: 'Skincare Queen VN',
        platform: 'TikTok',
        handle: '@skincare_queen',
        category: 'Làm đẹp / Skincare',
        notes: 'Chuyên serum phục hồi',
        relevanceScore: 92.0,
        relevanceReason: 'Cùng phân khúc sản phẩm dưỡng da mụn, trùng lặp 78% tệp khán giả trẻ.',
        followersCount: 245000,
        videoCount30d: 48,
        avgViews: 120000,
        growthRate30d: 14.2,
        avgEngagementRate: 9.5,
        postingFrequencyPerDay: 2.3,
        lastPostAt: '6 giờ trước',
      ),
      Competitor(
        id: 'comp-102',
        workspaceId: widget.workspaceId,
        name: 'Beauty Guru Official',
        platform: 'Instagram',
        handle: '@beauty_guru99',
        category: 'Làm đẹp / Mỹ phẩm',
        notes: 'Hình ảnh tối giản cao cấp',
        relevanceScore: 78.0,
        relevanceReason: 'Cùng ngành hàng mỹ phẩm, phong cách quay aesthetic.',
        followersCount: 180000,
        videoCount30d: 32,
        avgViews: 85000,
        growthRate30d: 8.0,
        avgEngagementRate: 5.2,
        postingFrequencyPerDay: 1.1,
        lastPostAt: '1 ngày trước',
      ),
    ];
  }

  List<Competitor> get _filteredCompetitors {
    return _competitors.where((c) {
      if (_selectedPlatform != 'all' && c.platform.toLowerCase() != _selectedPlatform.toLowerCase()) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final match = c.name.toLowerCase().contains(q) ||
            c.handle.toLowerCase().contains(q) ||
            c.category.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList();
  }

  void _openWhyDrawer(Competitor c) {
    CompetitorWhySheet.show(
      context,
      title: 'Căn cứ AI: ${c.name} (${c.handle})',
      whyExplanation: WhyExplanationModel(
        basisSummary: 'Độ tương quan ${c.relevanceScore.toInt()}/100 được tính toán qua đối chiếu tập khán giả và danh mục nội dung.',
        dataSources: [
          'Dữ liệu công khai từ ${c.platform} API',
          'Tần suất 30 ngày qua (${c.videoCount30d} video)',
          'Creativanta Niche Classifier',
        ],
        limitations: [
          'Không ghi nhận các video đã bị đối thủ xóa',
          'Không đo lường bài viết trả phí (Dark Posts)',
        ],
        dataGaps: [
          'Không có số liệu doanh thu hoặc GMV nội bộ của đối thủ',
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F5),
      appBar: AppBar(
        title: const Text(
          '🏆 Đối thủ cạnh tranh (M03)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF242924)),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Color(0xFF274333)),
            tooltip: 'So sánh Benchmark',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const BenchmarkComparisonView()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Tìm theo tên, handle...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFF4F0E8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Tất cả', 'all'),
                      const SizedBox(width: 6),
                      _buildFilterChip('TikTok', 'tiktok'),
                      const SizedBox(width: 6),
                      _buildFilterChip('Instagram', 'instagram'),
                      const SizedBox(width: 6),
                      _buildFilterChip('YouTube', 'youtube'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Competitors list
          Expanded(
            child: _filteredCompetitors.isEmpty
                ? const Center(child: Text('Không tìm thấy đối thủ phù hợp'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filteredCompetitors.length,
                    itemBuilder: (context, index) {
                      final c = _filteredCompetitors[index];
                      return _buildCompetitorCard(c);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedPlatform == value;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedPlatform = value),
      selectedColor: const Color(0xFF274333),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF616C63),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildCompetitorCard(Competitor c) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE7E2D7)),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFEAF4ED),
                  child: Text(
                    c.name.substring(0, 1),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF274333)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(
                        '${c.handle} • ${c.platform}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF616C63)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4ED),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Đang theo dõi',
                    style: TextStyle(fontSize: 10, color: Color(0xFF274333), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Metrics row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF9F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _metricCol('Followers', formatCompactNumber(c.followersCount)),
                  _metricCol('Tương tác', '${c.avgEngagementRate}%'),
                  _metricCol('Tăng 30d', '+${c.growthRate30d}%', textColor: const Color(0xFF274333)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // AI Relevance with "Why" trigger (Acceptance Target 1)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEFCE8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFEF08A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('⭐ ', style: TextStyle(fontSize: 12)),
                          Text(
                            'Độ tương quan: ${c.relevanceScore.toInt()}/100',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF854D0E),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _openWhyDrawer(c),
                        child: const Text(
                          'Tại sao? (Why) →',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF854D0E),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    c.relevanceReason,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF713F12), fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCol(String label, String value, {Color? textColor}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF616C63))),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor ?? const Color(0xFF242924)),
        ),
      ],
    );
  }
}
