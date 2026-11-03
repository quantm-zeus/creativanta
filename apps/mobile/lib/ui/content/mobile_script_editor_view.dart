import 'dart:async';
import 'package:flutter/material.dart';
import 'package:creativanta_mobile/content/content_handoff_models.dart';
import 'package:creativanta_mobile/content/script_models.dart';
import 'package:creativanta_mobile/ui/content/source_chain_lineage_widget.dart';

/// Screen M011: Mobile — Script Editor (/scripts/[id])
/// Canonical spec: docs/03_screens/mobile/screen_mobile_script_editor.md
class MobileScriptEditorView extends StatefulWidget {
  const MobileScriptEditorView({
    super.key,
    required this.script,
    this.lineage,
    this.assetBrief,
    this.initialVersion,
    required this.onSaveScript,
    required this.onSubmitForReview,
    this.onApprove,
    this.onNavigateToProduction,
    this.isManagerOrAbove = false,
  });

  final ScriptItem script;
  final SourceChainLineage? lineage;
  final AssetBriefItem? assetBrief;
  final int? initialVersion;
  final Future<void> Function(ScriptItem updatedScript) onSaveScript;
  final Future<void> Function() onSubmitForReview;
  final VoidCallback? onApprove;
  final VoidCallback? onNavigateToProduction;
  final bool isManagerOrAbove;

  @override
  State<MobileScriptEditorView> createState() => _MobileScriptEditorViewState();
}

class _MobileScriptEditorViewState extends State<MobileScriptEditorView> {
  late TextEditingController _titleController;
  final Map<String, TextEditingController> _sectionControllers = {};
  late List<SceneItem> _scenes;
  late int _currentVersion;
  late int _loadedVersion;

  bool _isSaving = false;
  bool _isSaved = true;
  String? _concurrencyConflictMessage;

  // Readthrough timer state
  Timer? _readthroughTimer;
  int _timerSeconds = 0;
  bool _isTimerRunning = false;

  // Creative Assistant drawer / safety check
  final TextEditingController _assistantPromptController = TextEditingController();
  CreativeAssistantPublishCheck? _lastAssistantCheck;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.script.title);
    _scenes = List.from(widget.script.scenes);
    _currentVersion = widget.script.versionIndex;
    _loadedVersion = widget.initialVersion ?? widget.script.versionIndex;

    for (final scene in _scenes) {
      _sectionControllers[scene.sceneId] = TextEditingController(text: scene.content);
    }

    _evaluateConcurrency();
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final c in _sectionControllers.values) {
      c.dispose();
    }
    _readthroughTimer?.cancel();
    _assistantPromptController.dispose();
    super.dispose();
  }

  void _evaluateConcurrency() {
    if (_loadedVersion > 0 && _currentVersion > _loadedVersion) {
      _concurrencyConflictMessage =
          '⚠️ Kịch bản đã được tác giả cập nhật lên v$_currentVersion sau khi bạn mở xem (v$_loadedVersion). Vui lòng tải lại dữ liệu để tránh xung đột (EC-M06-003).';
    } else {
      _concurrencyConflictMessage = null;
    }
  }

  Future<void> _handleSave() async {
    setState(() {
      _isSaving = true;
    });

    final updatedScenes = _scenes.map((scene) {
      final controller = _sectionControllers[scene.sceneId];
      final newContent = controller?.text ?? scene.content;
      return SceneItem(
        sceneId: scene.sceneId,
        scriptId: scene.scriptId,
        workspaceId: scene.workspaceId,
        sceneIndex: scene.sceneIndex,
        description: scene.description,
        content: newContent,
        durationSeconds: scene.durationSeconds,
        visualNotes: scene.visualNotes,
        audioNotes: scene.audioNotes,
      );
    }).toList();

    final updatedScript = ScriptItem(
      scriptId: widget.script.scriptId,
      workspaceId: widget.script.workspaceId,
      ideaId: widget.script.ideaId,
      sourceIdeaTitle: widget.script.sourceIdeaTitle,
      title: _titleController.text.trim(),
      formatType: widget.script.formatType,
      scenes: updatedScenes,
      durationTargetSeconds: widget.script.durationTargetSeconds,
      lifecycleState: widget.script.lifecycleState,
      approvalState: widget.script.approvalState,
      versionIndex: _currentVersion + 1,
      createdBy: widget.script.createdBy,
      createdAt: widget.script.createdAt,
      updatedAt: DateTime.now(),
    );

    try {
      await widget.onSaveScript(updatedScript);
      setState(() {
        _scenes = updatedScenes;
        _currentVersion += 1;
        _loadedVersion = _currentVersion;
        _concurrencyConflictMessage = null;
        _isSaving = false;
        _isSaved = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('💾 Đã lưu phiên bản mới')),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
        _isSaved = false;
      });
    }
  }

  void _toggleTimer() {
    if (_isTimerRunning) {
      _readthroughTimer?.cancel();
      setState(() {
        _isTimerRunning = false;
      });
    } else {
      _readthroughTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          _timerSeconds += 1;
        });
      });
      setState(() {
        _isTimerRunning = true;
      });
    }
  }

  void _resetTimer() {
    _readthroughTimer?.cancel();
    setState(() {
      _timerSeconds = 0;
      _isTimerRunning = false;
    });
  }

  void _showCreativeAssistantSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
                top: 16,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.indigo),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Trợ lý sáng tạo (Creative Assistant)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hỗ trợ viết tiếp hoặc sửa đổi phân cảnh. Trợ lý sáng tạo tuyệt đối không có quyền xuất bản bài đăng (M11 Publish Hub thuộc Phase P5).',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('assistant-prompt-input'),
                    controller: _assistantPromptController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Nhập yêu cầu sáng tạo... (ví dụ: Viết lại hook cuốn hút hơn)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_lastAssistantCheck != null) ...[
                    if (_lastAssistantCheck!.hasPublishIntent)
                      Container(
                        key: const Key('assistant-blocked-banner'),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.red[300]!),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.block, size: 16, color: Colors.red),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                _lastAssistantCheck!.blockedReason ?? 'Yêu cầu bị từ chối: chứa lệnh đăng bài.',
                                style: const TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        key: const Key('assistant-safe-banner'),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green[300]!),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '✓ Yêu cầu hợp lệ — không có tác dụng phụ đăng bài.',
                                style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Đóng'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        key: const Key('assistant-submit-btn'),
                        icon: const Icon(Icons.send, size: 14),
                        label: const Text('Gửi yêu cầu'),
                        onPressed: () {
                          final text = _assistantPromptController.text.trim();
                          if (text.isEmpty) return;
                          final check = CreativeAssistantPublishCheck.inspect(text);
                          setSheetState(() {
                            _lastAssistantCheck = check;
                          });
                          setState(() {
                            _lastAssistantCheck = check;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final validation = validateScenesForSubmission(_scenes);
    final readiness = isReadyForProductionEligible(widget.script, widget.assetBrief);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          key: const Key('script-title-input'),
          controller: _titleController,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Tiêu đề kịch bản...',
          ),
          onChanged: (_) => setState(() => _isSaved = false),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                _isSaving
                    ? 'Saving...'
                    : _isSaved
                        ? '💾 Saved'
                        : '❌ Unsaved',
                key: const Key('save-status-indicator'),
                style: TextStyle(fontSize: 11, color: _isSaved ? Colors.grey[600] : Colors.orange[800]),
              ),
            ),
          ),
          IconButton(
            key: const Key('save-script-icon-btn'),
            icon: const Icon(Icons.save_outlined),
            onPressed: _concurrencyConflictMessage != null ? null : _handleSave,
          ),
          IconButton(
            key: const Key('assistant-icon-btn'),
            icon: const Icon(Icons.auto_awesome),
            onPressed: _showCreativeAssistantSheet,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Concurrency Conflict Banner (EC-M06-003)
          if (_concurrencyConflictMessage != null)
            Card(
              key: const Key('editor-concurrency-conflict-banner'),
              color: Colors.amber[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.amber[400]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.amber),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _concurrencyConflictMessage!,
                        style: const TextStyle(fontSize: 12, color: Colors.brown, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Source Chain Lineage Breadcrumb (Acceptance Target 1)
          if (widget.lineage != null) ...[
            const SizedBox(height: 8),
            SourceChainLineageWidget(lineage: widget.lineage!),
          ],

          const SizedBox(height: 12),

          // Metadata Bar
          Card(
            elevation: 0,
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.movie, size: 16, color: Colors.blueGrey),
                  const SizedBox(width: 6),
                  Text(
                    widget.script.formatType,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.timer_outlined, size: 16, color: Colors.blueGrey),
                  const SizedBox(width: 4),
                  Text(
                    '${calculateTotalDuration(_scenes)}s / ${widget.script.durationTargetSeconds}s',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      'v$_currentVersion',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Sections List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Phân cảnh (${_scenes.length})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${calculateWordCount(_scenes)} từ',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),

          for (var i = 0; i < _scenes.length; i++) ...[
            _buildSectionCard(_scenes[i], i),
            const SizedBox(height: 8),
          ],

          const SizedBox(height: 16),

          // Readthrough Timer Card
          Card(
            key: const Key('readthrough-timer-card'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.mic, color: Colors.indigo),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Đồng hồ đọc thử',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$_timerSeconds s / ${widget.script.durationTargetSeconds}s target',
                        key: const Key('timer-display'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _timerSeconds > widget.script.durationTargetSeconds ? Colors.red : Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _timerSeconds == 0
                        ? 'Bấm bắt đầu đọc thử để kiểm tra tốc độ diễn đạt.'
                        : _timerSeconds > widget.script.durationTargetSeconds
                            ? '⚠️ Tốc độ đọc vượt quá thời lượng mục tiêu (+${_timerSeconds - widget.script.durationTargetSeconds}s).'
                            : '✅ Tốc độ đọc phù hợp với thời lượng mục tiêu.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        key: const Key('timer-toggle-btn'),
                        icon: Icon(_isTimerRunning ? Icons.pause : Icons.play_arrow),
                        label: Text(_isTimerRunning ? 'Tạm dừng' : 'Bắt đầu đọc'),
                        onPressed: _toggleTimer,
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        key: const Key('timer-reset-btn'),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Đặt lại'),
                        onPressed: _resetTimer,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Bottom Action Bar
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          key: const Key('submit-review-btn'),
                          icon: const Icon(Icons.send),
                          label: const Text('Gửi review'),
                          onPressed: _concurrencyConflictMessage != null || !validation.isValid
                              ? null
                              : () => widget.onSubmitForReview(),
                        ),
                      ),
                      if (widget.isManagerOrAbove && widget.onApprove != null) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            key: const Key('editor-approve-btn'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], foregroundColor: Colors.white),
                            icon: const Icon(Icons.check),
                            label: const Text('Phê duyệt'),
                            onPressed: _concurrencyConflictMessage != null ? null : widget.onApprove,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      key: const Key('goto-production-btn'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                      icon: const Icon(Icons.movie_creation),
                      label: const Text('🎬 → Production'),
                      onPressed: readiness.isEligible ? widget.onNavigateToProduction : null,
                    ),
                  ),
                  if (!readiness.isEligible)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Chỉ mở khi kịch bản đã được duyệt và có Asset Brief đầy đủ (RULE-M06-005).',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(SceneItem scene, int index) {
    final controller = _sectionControllers[scene.sceneId]!;
    final words = controller.text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

    return Card(
      key: Key('scene-card-$index'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Cảnh #${index + 1}',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.indigo[700]),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    scene.description,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                Text(
                  '$words từ · ${scene.durationSeconds}s',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              key: Key('scene-content-input-$index'),
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Nội dung phân cảnh...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
              ),
              onChanged: (_) => setState(() => _isSaved = false),
            ),
          ],
        ),
      ),
    );
  }
}
