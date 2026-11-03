import 'package:flutter/material.dart';
import 'package:creativanta_mobile/content/idea_models.dart';
import 'package:creativanta_mobile/generated/creativanta/content/v1/idea.pbenum.dart';
import 'package:creativanta_mobile/ui/content/quick_capture_sheet.dart';

/// IdeaBoardView displays mobile idea list with provenance and status flow (M05).
class IdeaBoardView extends StatefulWidget {
  const IdeaBoardView({
    super.key,
    required this.workspaceId,
    required this.userId,
    this.initialIdeas = const [],
  });

  final String workspaceId;
  final String userId;
  final List<IdeaItem> initialIdeas;

  @override
  State<IdeaBoardView> createState() => _IdeaBoardViewState();
}

class _IdeaBoardViewState extends State<IdeaBoardView> {
  late List<IdeaItem> _ideas;
  IdeaStatus? _filterStatus;

  @override
  void initState() {
    super.initState();
    _ideas = List.from(widget.initialIdeas);
  }

  void _openQuickCapture() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => QuickCaptureSheet(
        workspaceId: widget.workspaceId,
        userId: widget.userId,
        existingIdeas: _ideas,
        onIdeaSaved: (newIdea) {
          setState(() {
            _ideas.insert(0, newIdea);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Đã lưu bản nháp "${newIdea.title}"!'),
              backgroundColor: const Color(0xFF274333),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filterStatus == null
        ? _ideas
        : _ideas.where((i) => i.status == _filterStatus).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('💡 Kho ý tưởng'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF242924),
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Tất cả'),
                  selected: _filterStatus == null,
                  onSelected: (_) => setState(() => _filterStatus = null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Bản nháp'),
                  selected: _filterStatus == IdeaStatus.IDEA_STATUS_DRAFT,
                  onSelected: (_) => setState(
                      () => _filterStatus = IdeaStatus.IDEA_STATUS_DRAFT),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Ứng viên'),
                  selected: _filterStatus == IdeaStatus.IDEA_STATUS_CANDIDATE,
                  onSelected: (_) => setState(
                      () => _filterStatus = IdeaStatus.IDEA_STATUS_CANDIDATE),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Được chọn'),
                  selected: _filterStatus == IdeaStatus.IDEA_STATUS_SELECTED,
                  onSelected: (_) => setState(
                      () => _filterStatus = IdeaStatus.IDEA_STATUS_SELECTED),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Đã chuyển đổi'),
                  selected: _filterStatus == IdeaStatus.IDEA_STATUS_CONVERTED,
                  onSelected: (_) => setState(
                      () => _filterStatus = IdeaStatus.IDEA_STATUS_CONVERTED),
                ),
              ],
            ),
          ),

          // Idea List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'Chưa có ý tưởng nào.',
                      style: TextStyle(color: Color(0xFF616C63)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFFE7E2D7)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF242924),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Colors.green.shade200),
                                    ),
                                    child: Text(
                                      '${item.ideaScore.round()} đ',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (item.description.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  item.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF616C63),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),

                              // Source Lineage Chip
                              if (item.sources.isNotEmpty) ...[
                                Wrap(
                                  spacing: 4,
                                  children: item.sources.map((src) {
                                    return Chip(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      labelPadding: EdgeInsets.zero,
                                      backgroundColor: src.isArchived
                                          ? Colors.amber.shade50
                                          : const Color(0xFFFBF9F5),
                                      side: BorderSide(
                                        color: src.isArchived
                                            ? Colors.amber.shade300
                                            : const Color(0xFFE7E2D7),
                                      ),
                                      label: Text(
                                        '🔗 ${src.displayLabel}: ${src.sourceTitle}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: src.isArchived
                                              ? Colors.amber.shade900
                                              : const Color(0xFF242924),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 8),
                              ],

                              // Status Chip
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Trạng thái: ${item.status.name.replaceFirst("IDEA_STATUS_", "")}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF616C63),
                                    ),
                                  ),
                                  if (item.status ==
                                      IdeaStatus.IDEA_STATUS_DRAFT)
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          item.status = IdeaStatus
                                              .IDEA_STATUS_CANDIDATE;
                                        });
                                      },
                                      child: const Text('Duyệt ứng viên →',
                                          style: TextStyle(fontSize: 11)),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF274333),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Ghi nhanh'),
        onPressed: _openQuickCapture,
      ),
    );
  }
}
