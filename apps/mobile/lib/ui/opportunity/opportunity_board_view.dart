import 'package:flutter/material.dart';
import '../../generated/creativanta/intelligence/v1/opportunity.pbenum.dart';
import '../../generated/creativanta/intelligence/v1/trend.pbenum.dart';
import '../../opportunity/opportunity_models.dart';

/// Mobile Opportunity Board Screen (Module M04 / Screen W043 / Mobile equiv).
/// Surfaces AI-scored opportunities with repair banners and conversion actions.
class OpportunityBoardView extends StatefulWidget {
  const OpportunityBoardView({
    super.key,
    required this.workspaceId,
    this.initialOpportunities,
  });

  final String workspaceId;
  final List<OpportunityItem>? initialOpportunities;

  @override
  State<OpportunityBoardView> createState() => _OpportunityBoardViewState();
}

class _OpportunityBoardViewState extends State<OpportunityBoardView> {
  late List<OpportunityItem> _opportunities;

  @override
  void initState() {
    super.initState();
    _opportunities = widget.initialOpportunities ?? _createDefaultSeedData();
  }

  List<OpportunityItem> _createDefaultSeedData() {
    return [
      OpportunityItem(
        id: 'opp-m-001',
        workspaceId: widget.workspaceId,
        opportunityType: 'content',
        title: 'Morning skincare routine — chưa có trên TikTok VN',
        summary: 'Hiện chỉ có 3 video VN về morning routine. Trending +200% globally nhưng VN market chưa khai thác. Audience 18-25 match 92%.',
        whyItMatters: 'First mover advantage rất cao; đối thủ chưa phủ ngách buổi sáng.',
        expectedImpactScore: 89,
        expectedImpactDesc: 'Tăng trưởng organic reach và tương tác cao',
        expectedEffortScore: 35,
        expectedEffortDesc: 'Quay ngắn 30-45s với sản phẩm hiện có',
        priorityState: PriorityState.PRIORITY_STATE_PRIORITIZED,
        priorityReason: 'Audience match 92%, low competition trên TikTok VN',
        suggestedNextStep: 'Tạo kịch bản POV buổi sáng 30 giây',
        ownerUserId: '', // Unassigned -> repairable
        confidence: ConfidenceBand.CONFIDENCE_BAND_HIGH,
        sourceClass: SourceClass.SOURCE_CLASS_INFERRED,
        sources: [
          const OpportunitySourceItem(
            sourceType: 'trend',
            sourceId: 'trend-morning-glow',
            sourceName: 'Morning Glow #morningroutine (+200%)',
          ),
          const OpportunitySourceItem(
            sourceType: 'competitor',
            sourceId: 'comp-queen',
            sourceName: '@skincare_queen (khoảng trống nội dung)',
          ),
        ],
        overallScore: 89,
        estimatedProfitAmountCents: 25000000,
        profitExplanation: 'Dự toán doanh thu tiềm năng dựa trên tín hiệu thị trường; không phải số liệu kế toán chính thức.',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
        isRepairable: true,
        repairReasons: const [
          'Chưa phân công người phụ trách (Unassigned owner — assign team member)',
        ],
      ),
      OpportunityItem(
        id: 'opp-m-002',
        workspaceId: widget.workspaceId,
        opportunityType: 'content',
        title: 'Review serum retinol — competitor giảm tần suất',
        summary: '@skincare_queen chưa post về retinol 2 tuần nay. Keyword vẫn trending. Cơ hội lấp khoảng trống.',
        whyItMatters: 'Top competitor đang chuyển hướng sang sản phẩm khác, bỏ trống từ khóa retinol.',
        expectedImpactScore: 74,
        expectedImpactDesc: 'Chiếm sóng tìm kiếm ngành hàng phục hồi da',
        expectedEffortScore: 40,
        expectedEffortDesc: 'Cần so sánh 2 chai serum thực tế',
        priorityState: PriorityState.PRIORITY_STATE_ASSIGNED,
        priorityReason: 'Đối thủ ngừng post, nhu cầu tìm kiếm vẫn duy trì mức cao',
        suggestedNextStep: 'Quay video so sánh Retinol 0.5% vs 1%',
        ownerUserId: 'user-creator-01',
        confidence: ConfidenceBand.CONFIDENCE_BAND_MEDIUM_HIGH,
        sourceClass: SourceClass.SOURCE_CLASS_INFERRED,
        sources: [
          const OpportunitySourceItem(
            sourceType: 'competitor',
            sourceId: 'comp-queen',
            sourceName: '@skincare_queen chưa đăng retinol 14 ngày qua',
          ),
        ],
        overallScore: 74,
        estimatedProfitAmountCents: 18000000,
        profitExplanation: 'Ước tính GMV affiliate tiềm năng.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
        isRepairable: false,
        repairReasons: const [],
      ),
    ];
  }

  void _assignOwner(OpportunityItem opp) {
    showDialog<String>(
      context: context,
      builder: (ctx) {
        String selected = 'user-creator-01';
        return AlertDialog(
          title: const Text('Phân công người phụ trách'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return DropdownButton<String>(
                value: selected,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'user-creator-01', child: Text('Nguyễn Văn A (Content Lead)')),
                  DropdownMenuItem(value: 'user-creator-02', child: Text('Trần Thị B (Video Creator)')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setDialogState(() => selected = val);
                  }
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(selected),
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    ).then((chosenUser) {
      if (chosenUser != null) {
        setState(() {
          opp.ownerUserId = chosenUser;
          if (opp.priorityState == PriorityState.PRIORITY_STATE_OPEN ||
              opp.priorityState == PriorityState.PRIORITY_STATE_PRIORITIZED) {
            opp.priorityState = PriorityState.PRIORITY_STATE_ASSIGNED;
          }
          opp.updatedAt = DateTime.now();
          final status = OpportunityItem.computeRepairStatus(opp);
          opp.isRepairable = status.isRepairable;
          opp.repairReasons = status.repairReasons;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã phân công người phụ trách thành công!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredOpps = _opportunities.where((o) => !o.isDismissed).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('💎 Cơ hội (Opportunity Board)'),
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Summary Metrics Banner
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('${filteredOpps.length}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text('Cơ hội', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        filteredOpps.isEmpty
                            ? '0'
                            : '${(filteredOpps.map((e) => e.overallScore).reduce((a, b) => a + b) / filteredOpps.length).round()}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      const SizedBox(height: 4),
                      const Text('Điểm TB', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const Column(
                    children: [
                      Text('+2', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                      SizedBox(height: 4),
                      Text('Mới hôm nay', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Opportunity Feed
          for (final opp in filteredOpps) ...[
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge and Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '⭐ ${opp.overallScore}/100',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo.shade800, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            opp.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Acceptance Target 1: Repair Warning Banner
                    if (opp.isRepairable) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Cần phân công người phụ trách (Repair Required)',
                                style: TextStyle(fontSize: 12, color: Colors.amber.shade900, fontWeight: FontWeight.w500),
                              ),
                            ),
                            TextButton(
                              onPressed: () => _assignOwner(opp),
                              child: const Text('Phân công', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Summary & AI Analysis
                    Text(
                      opp.summary,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.3),
                    ),
                    const SizedBox(height: 10),

                    // Financial Non-Conflation Estimate Badge (RULE-M04-005)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Dự toán: ${(opp.estimatedProfitAmountCents / 100).toStringAsFixed(0)} đ',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('ESTIMATE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chuyển đổi sang Studio Kịch bản...')),
                            );
                          },
                          child: const Text('📝 Viết script'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Đã tạo ý tưởng từ cơ hội!')),
                            );
                          },
                          child: const Text('💡 Tạo ý tưởng'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
