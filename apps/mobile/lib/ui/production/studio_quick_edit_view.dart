import 'package:flutter/material.dart';
import '../../production/quick_edit_models.dart';

/// Screen M014: Mobile Quick Edit (Module M07 AI Studio)
/// Upstream: Pack 04, A1 Schema, B5 RBAC
class StudioQuickEditView extends StatefulWidget {
  final int initialBalance;
  final List<QuickEditWordModel>? initialWords;
  final List<QuickEditPauseModel>? initialPauses;
  final int initialDurationMs;

  const StudioQuickEditView({
    super.key,
    this.initialBalance = 320,
    this.initialWords,
    this.initialPauses,
    this.initialDurationMs = 135000, // 2m 15s
  });

  @override
  State<StudioQuickEditView> createState() => _StudioQuickEditViewState();
}

class _StudioQuickEditViewState extends State<StudioQuickEditView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _balance;
  late List<QuickEditWordModel> _words;
  late List<QuickEditPauseModel> _pauses;
  late int _totalDurationMs;
  late QuickEditAddonsModel _addons;

  bool _showBeforePreview = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _balance = widget.initialBalance;
    _totalDurationMs = widget.initialDurationMs;
    _addons = const QuickEditAddonsModel();

    _words = widget.initialWords ??
        [
          const QuickEditWordModel(
            wordId: 'w1',
            text: 'Xin chào các bạn, hôm nay mình sẽ',
            startMs: 0,
            endMs: 3200,
          ),
          const QuickEditWordModel(
            wordId: 'w2',
            text: 'ừm',
            startMs: 3300,
            endMs: 3750,
            isFiller: true,
          ),
          const QuickEditWordModel(
            wordId: 'w3',
            text: 'review sản phẩm serum vitamin C này',
            startMs: 3800,
            endMs: 7500,
          ),
          const QuickEditWordModel(
            wordId: 'w4',
            text: 'kiểu',
            startMs: 7600,
            endMs: 8000,
            isFiller: true,
          ),
          const QuickEditWordModel(
            wordId: 'w5',
            text: 'Đầu tiên mình thấy là texture rất nhẹ',
            startMs: 8100,
            endMs: 12000,
          ),
          const QuickEditWordModel(
            wordId: 'w6',
            text: 'đoạn này bị thừa từ',
            startMs: 12100,
            endMs: 14500,
          ),
          const QuickEditWordModel(
            wordId: 'w7',
            text: 'thấm nhanh vào da không gây bết dính',
            startMs: 14600,
            endMs: 18500,
          ),
        ];

    _pauses = widget.initialPauses ??
        [
          const QuickEditPauseModel(startMs: 18500, endMs: 20500, durationMs: 2000),
        ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleWordDeleted(String wordId) {
    setState(() {
      _words = _words.map((w) {
        if (w.wordId == wordId) {
          return w.copyWith(isDeleted: !w.isDeleted);
        }
        return w;
      }).toList();
    });
  }

  void _openRepairDialog(QuickEditWordModel word) {
    final textController = TextEditingController(text: word.text);
    final startController = TextEditingController(text: word.startMs.toString());
    final endController = TextEditingController(text: word.endMs.toString());
    String? localError;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E293B),
              title: const Text(
                'Sửa từ / ASR (EC-M07-Q01)',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Nội dung từ',
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: startController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Start (ms)',
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: endController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'End (ms)',
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (localError != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      localError!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newStart = int.tryParse(startController.text) ?? word.startMs;
                    final newEnd = int.tryParse(endController.text) ?? word.endMs;
                    final res = repairMobileWordTranscript(
                      _words,
                      word.wordId,
                      textController.text,
                      newStart,
                      newEnd,
                    );
                    if (res.fallbackMode && res.error != null) {
                      setDialogState(() {
                        localError = res.error;
                      });
                    } else {
                      setState(() {
                        _words = res.words;
                      });
                      Navigator.pop(dialogCtx);
                    }
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showConfirmationDialog() {
    final cost = calculateMobileQuickEditCredits(_addons);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text(
            'Xác nhận tạo video',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estimated cost: $cost credits. Your balance: $_balance credits.',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 8),
              if (_balance < cost)
                const Text(
                  '⚠️ Số dư không đủ credits!',
                  style: TextStyle(color: Colors.redAccent, fontSize: 12),
                )
              else
                Text(
                  'Số dư còn lại: ${_balance - cost} credits',
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: _balance < cost
                  ? null
                  : () {
                      Navigator.pop(ctx);
                      setState(() {
                        _balance -= cost;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã gửi yêu cầu Quick Edit thành công ($cost credits)')),
                      );
                    },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text('Generate', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final creditCost = calculateMobileQuickEditCredits(_addons);
    final timeline = computeMobileRetainedTimeline(
      _totalDurationMs,
      _words,
      _pauses,
      true,
      true,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Quick Edit', style: TextStyle(fontSize: 16)),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueGrey.shade800),
            ),
            child: Center(
              child: Text(
                '🪙 $_balance',
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Video Player Area with Before/After toggle overlay
          Container(
            height: 180,
            width: double.infinity,
            color: Colors.black,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.movie_creation, color: Colors.blueAccent, size: 40),
                      const SizedBox(height: 6),
                      Text(
                        _showBeforePreview
                            ? '[Gốc] 00:35 / 02:15'
                            : '[Sau cắt] 00:35 / ${(timeline.finalDurationMs / 1000).round()}s',
                        style: TextStyle(
                          color: _showBeforePreview ? Colors.amber : Colors.greenAccent,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                      if (_addons.autoCaptions) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.yellowAccent),
                          ),
                          child: Text(
                            '💬 ${_addons.captionStyle.toUpperCase()}: REVIEW SERUM...',
                            style: const TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Before / After toggle button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showBeforePreview = !_showBeforePreview;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _showBeforePreview ? Colors.amber.shade900 : Colors.blue.shade900,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _showBeforePreview ? 'Gốc (Trước)' : 'Sau chỉnh sửa',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. TabBar
          Container(
            color: const Color(0xFF1E293B),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blueAccent,
              tabs: const [
                Tab(icon: Icon(Icons.description, size: 16), text: 'Transcript'),
                Tab(icon: Icon(Icons.content_cut, size: 16), text: 'Edit Plan'),
                Tab(icon: Icon(Icons.settings, size: 16), text: 'Settings'),
              ],
            ),
          ),

          // 3. TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // TAB 1: Transcript List
                ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _words.length,
                  itemBuilder: (ctx, idx) {
                    final w = _words[idx];
                    return Dismissible(
                      key: Key(w.wordId),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        _toggleWordDeleted(w.wordId);
                      },
                      background: Container(
                        color: Colors.redAccent.withAlpha(200),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        color: w.isDeleted
                            ? Colors.red.shade900.withAlpha(80)
                            : (w.isFiller ? Colors.amber.shade900.withAlpha(80) : const Color(0xFF1E293B)),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          dense: true,
                          title: Text(
                            w.text,
                            style: TextStyle(
                              color: w.isDeleted ? Colors.white38 : Colors.white,
                              decoration: w.isDeleted ? TextDecoration.lineThrough : null,
                              fontSize: 13,
                            ),
                          ),
                          subtitle: Text(
                            '[${(w.startMs / 1000).toStringAsFixed(1)}s - ${(w.endMs / 1000).toStringAsFixed(1)}s]',
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (w.isFiller)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade800,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('filler', style: TextStyle(color: Colors.white, fontSize: 9)),
                                ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 14, color: Colors.blueAccent),
                                onPressed: () => _openRepairDialog(w),
                              ),
                            ],
                          ),
                          onTap: () => _toggleWordDeleted(w.wordId),
                        ),
                      ),
                    );
                  },
                ),

                // TAB 2: Edit Plan
                ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    CheckboxListTile(
                      title: const Text('💬 Phụ đề hoạt họa', style: TextStyle(color: Colors.white, fontSize: 13)),
                      subtitle: const Text('Đã bao gồm', style: TextStyle(color: Colors.greenAccent, fontSize: 11)),
                      value: _addons.autoCaptions,
                      onChanged: (val) => setState(() => _addons = _addons.copyWith(autoCaptions: val ?? true)),
                    ),
                    CheckboxListTile(
                      title: const Text('🎯 Thêm Hook mở đầu', style: TextStyle(color: Colors.white, fontSize: 13)),
                      subtitle: const Text('+3 credits', style: TextStyle(color: Colors.amber, fontSize: 11)),
                      value: _addons.addHook,
                      onChanged: (val) => setState(() => _addons = _addons.copyWith(addHook: val ?? false)),
                    ),
                    CheckboxListTile(
                      title: const Text('🎵 Beat-sync nhạc nền', style: TextStyle(color: Colors.white, fontSize: 13)),
                      subtitle: const Text('+5 credits', style: TextStyle(color: Colors.amber, fontSize: 11)),
                      value: _addons.beatSync,
                      onChanged: (val) => setState(() => _addons = _addons.copyWith(beatSync: val ?? false)),
                    ),
                    CheckboxListTile(
                      title: const Text('🎞️ AI B-Roll chèn cảnh', style: TextStyle(color: Colors.white, fontSize: 13)),
                      subtitle: const Text('+10 credits', style: TextStyle(color: Colors.amber, fontSize: 11)),
                      value: _addons.bRoll,
                      onChanged: (val) => setState(() => _addons = _addons.copyWith(bRoll: val ?? false)),
                    ),
                    CheckboxListTile(
                      title: const Text('🔊 Lọc ồn & chuẩn -14 LUFS', style: TextStyle(color: Colors.white, fontSize: 13)),
                      subtitle: const Text('+3 credits', style: TextStyle(color: Colors.amber, fontSize: 11)),
                      value: _addons.audioEnhancement,
                      onChanged: (val) => setState(() => _addons = _addons.copyWith(audioEnhancement: val ?? false)),
                    ),
                  ],
                ),

                // TAB 3: Settings
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tỉ lệ xuất (Reframe Ratio):', style: TextStyle(color: Colors.white, fontSize: 13)),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: '9:16', label: Text('9:16 (TikTok)')),
                          ButtonSegment(value: '16:9', label: Text('16:9 (YouTube)')),
                          ButtonSegment(value: '1:1', label: Text('1:1 (Insta)')),
                        ],
                        selected: {_addons.reframeRatio},
                        onSelectionChanged: (set) => setState(() => _addons = _addons.copyWith(reframeRatio: set.first)),
                      ),
                      const SizedBox(height: 16),
                      const Text('Mục tiêu âm lượng: -14.0 LUFS (RULE-M07-005)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. Bottom Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Chi phí: $creditCost credits',
                        style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        'Tiết kiệm: ${(timeline.timeSavedMs / 1000).round()}s',
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  icon: const Icon(Icons.rocket_launch, size: 16, color: Colors.white),
                  label: Text('Apply ($creditCost cr)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
