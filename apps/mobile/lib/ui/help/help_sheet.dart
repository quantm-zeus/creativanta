import 'package:flutter/material.dart';

class MobileKBArticle {
  final String id;
  final String slug;
  final String title;
  final String summary;
  final String content;
  final String moduleRef;
  int helpfulVotes;
  int unhelpfulVotes;
  bool? userVote;

  MobileKBArticle({
    required this.id,
    required this.slug,
    required this.title,
    required this.summary,
    required this.content,
    required this.moduleRef,
    this.helpfulVotes = 0,
    this.unhelpfulVotes = 0,
    this.userVote,
  });
}

class HelpSheet extends StatefulWidget {
  const HelpSheet({super.key, this.initialModuleRef});

  final String? initialModuleRef;

  static const Color paper = Color(0xFFFBF9F5);
  static const Color surface = Color(0xFFFFFEFA);
  static const Color ink = Color(0xFF242924);
  static const Color forest = Color(0xFF274333);
  static const Color vermilion = Color(0xFFD94A31);
  static const Color textMuted = Color(0xFF7D837B);
  static const Color border = Color(0xFFE8E5DC);

  static Future<void> show(BuildContext context, {String? moduleRef}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => HelpSheet(initialModuleRef: moduleRef),
    );
  }

  @override
  State<HelpSheet> createState() => _HelpSheetState();
}

class _HelpSheetState extends State<HelpSheet> {
  final TextEditingController _searchController = TextEditingController();
  MobileKBArticle? _selectedArticle;

  final List<MobileKBArticle> _articles = [
    MobileKBArticle(
      id: 'm-art-001',
      slug: '6-operator-modes-guide',
      title: 'Hướng dẫn 6 Chế độ Vận hành trên Creativanta',
      summary: 'Khám phá sự khác biệt giữa Creator, Seller, Affiliate, Live, Agency và Brand.',
      content: '''Creativanta V5 hỗ trợ 6 vai trò vận hành chuyên biệt:
• Solo Creator: Kịch bản, video AI và xu hướng âm thanh viral.
• Seller: Cảnh báo tồn kho, xử lý đơn hàng và SLA sàn TMĐT.
• Affiliate Operator: Link tiếp thị, tuyển deal hoa hồng cao.
• Live Operator: Kịch bản live, deal flash sale thời gian thực.
• Agency / MCN: Giám sát KPI mạng lưới creator, phân quyền đội ngũ.
• Brand Collaboration: Duyệt brief sáng tạo từ KOC và đo lường ROI.

Chuyển đổi nhanh qua thanh AppBar trên cùng bất kỳ lúc nào.''',
      moduleRef: 'M01',
      helpfulVotes: 48,
    ),
    MobileKBArticle(
      id: 'm-art-002',
      slug: 'understanding-why-this-number',
      title: 'Tại sao có số này: Tính minh bạch dữ liệu',
      summary: 'Cam kết không bao giờ cộng gộp số liệu mẫu demo vào doanh thu thực.',
      content: '''Mọi con số trên Creativanta đều truy xuất được nguồn gốc:
1. Chính thức (Official): Đồng bộ trực tiếp từ API sàn hoặc ngân hàng.
2. Nhập liệu (Imported): File bảng tính do bạn tải lên.
3. Suy luận (Inferred): Thuật toán dự báo máy học.
4. Mẫu (Demo Fixture): Dữ liệu tĩnh phục vụ trải nghiệm.

Dữ liệu DEMO luôn được cách ly hoàn toàn và KHÔNG BAO GIỜ tính vào doanh số thực.''',
      moduleRef: 'M01',
      helpfulVotes: 92,
    ),
    MobileKBArticle(
      id: 'm-art-003',
      slug: 'reconnect-tiktok-shop-channel',
      title: 'Khắc phục lỗi ngắt kết nối tài khoản TikTok Shop',
      summary: 'Cách cấp lại quyền OAuth khi token 30 ngày hết hạn.',
      content: '''Khi kênh bán hàng báo lỗi hết hạn ủy quyền:
1. Mở Cài đặt > Kênh kết nối.
2. Tìm kênh có nhãn đỏ Cần cấp lại quyền.
3. Nhấn Cấp lại quyền để mở trang ủy quyền chính thức.
4. Hệ thống sẽ tự động đồng bộ lại sau 60 giây.''',
      moduleRef: 'M11',
      helpfulVotes: 33,
    ),
    MobileKBArticle(
      id: 'm-art-004',
      slug: 'ai-credits-consumption-rules',
      title: 'Quy tắc trừ AI Credits minh bạch (M23)',
      summary: 'Bảng quy đổi credit theo từng tác vụ video và cơ chế hoàn trả lỗi.',
      content: '''• Tạo kịch bản ngắn: 1 Credit
• Sinh ý tưởng đa góc: 2 Credits
• Render video tiêu chuẩn 15s: 10 Credits

Nếu tác vụ bị lỗi hệ thống, credit sẽ tự động được hoàn lại trong 120 giây.''',
      moduleRef: 'M23',
      helpfulVotes: 61,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MobileKBArticle> get _filteredArticles {
    final query = _searchController.text.trim().toLowerCase();
    return _articles.where((a) {
      if (widget.initialModuleRef != null && !a.moduleRef.contains(widget.initialModuleRef!)) {
        return false;
      }
      if (query.isEmpty) return true;
      return a.title.toLowerCase().contains(query) ||
          a.summary.toLowerCase().contains(query) ||
          a.content.toLowerCase().contains(query);
    }).toList();
  }

  void _voteArticle(MobileKBArticle article, bool helpful) {
    setState(() {
      if (article.userVote == helpful) return;
      if (article.userVote == null) {
        if (helpful) {
          article.helpfulVotes++;
        } else {
          article.unhelpfulVotes++;
        }
      } else {
        if (helpful) {
          article.helpfulVotes++;
          article.unhelpfulVotes--;
        } else {
          article.unhelpfulVotes++;
          article.helpfulVotes--;
        }
      }
      article.userVote = helpful;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: HelpSheet.paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: HelpSheet.forest,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Trung tâm trợ giúp',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: HelpSheet.ink,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content: Detail OR List
            Expanded(
              child: _selectedArticle != null
                  ? _buildDetailView(_selectedArticle!)
                  : _buildListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Tìm tài liệu, mã lỗi...',
              hintStyle: const TextStyle(fontSize: 12, color: HelpSheet.textMuted),
              prefixIcon: const Icon(Icons.search_rounded, size: 18, color: HelpSheet.textMuted),
              filled: true,
              fillColor: HelpSheet.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: HelpSheet.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: HelpSheet.border),
              ),
            ),
            style: const TextStyle(fontSize: 13),
          ),
        ),
        const Divider(height: 1, color: HelpSheet.border),

        // List
        Expanded(
          child: _filteredArticles.isEmpty
              ? const Center(
                  child: Text(
                    'Không tìm thấy tài liệu phù hợp.',
                    style: TextStyle(fontSize: 13, color: HelpSheet.textMuted),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredArticles.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = _filteredArticles[index];
                    return InkWell(
                      onTap: () => setState(() => _selectedArticle = item),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: HelpSheet.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: HelpSheet.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF5F0),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.moduleRef,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 10,
                                      color: HelpSheet.forest,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '👍 ${item.helpfulVotes}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: HelpSheet.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: HelpSheet.ink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.summary,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: HelpSheet.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDetailView(MobileKBArticle article) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        TextButton.icon(
          onPressed: () => setState(() => _selectedArticle = null),
          icon: const Icon(Icons.arrow_back_rounded, size: 16),
          label: const Text('Quay lại danh sách'),
          style: TextButton.styleFrom(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            foregroundColor: HelpSheet.forest,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF5F0),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            article.moduleRef,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: HelpSheet.forest,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          article.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: HelpSheet.ink,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          article.content,
          style: const TextStyle(
            fontSize: 12.5,
            height: 1.6,
            color: HelpSheet.ink,
          ),
        ),
        const SizedBox(height: 24),

        // Rating
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: HelpSheet.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: HelpSheet.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tài liệu này có hữu ích không?',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: HelpSheet.ink,
                ),
              ),
              const SizedBox(height: 8),
              if (article.userVote != null)
                const Text(
                  '✓ Cảm ơn bạn đã gửi phản hồi!',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: HelpSheet.forest,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _voteArticle(article, true),
                      icon: const Icon(Icons.thumb_up_alt_outlined, size: 14),
                      label: Text('Có (${article.helpfulVotes})'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HelpSheet.forest,
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        textStyle: const TextStyle(fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => _voteArticle(article, false),
                      icon: const Icon(Icons.thumb_down_alt_outlined, size: 14),
                      label: Text('Chưa rõ (${article.unhelpfulVotes})'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HelpSheet.textMuted,
                        visualDensity: VisualDensity.compact,
                        textStyle: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
