// Screen M015: Mobile Clip Factory (1→N Mode 2, Module M07 AI Studio)
// Canonical Sources: docs/02_features/production/ai_video_studio.md §Mode 2
//                    docs/03_screens/mobile/screen_mobile_studio_clip_factory.md

import 'dart:convert';
import 'package:flutter/material.dart';
import '../../production/clip_factory_models.dart';

class StudioClipFactoryView extends StatefulWidget {
  final int initialBalance;
  final String sourceAssetId;
  final String sourceTitle;
  final List<ClipProposalModel>? initialClips;

  const StudioClipFactoryView({
    super.key,
    this.initialBalance = 350,
    this.sourceAssetId = 'asset-src-mobile-001',
    this.sourceTitle = 'Chiến Lược Tăng Trưởng Khách Hàng 2026',
    this.initialClips,
  });

  @override
  State<StudioClipFactoryView> createState() => _StudioClipFactoryViewState();
}

class _StudioClipFactoryViewState extends State<StudioClipFactoryView> {
  late int _balance;
  late List<ClipProposalModel> _clips;
  late Map<String, ClipVariantConfigModel> _variantConfigs;

  bool _hasSpeech = true;
  bool _hasTrendData = false; // Default false to demonstrate Acceptance Target 2 badge
  bool _isProcessing = false;
  List<ProcessedClipOutputModel> _completedOutputs = [];

  @override
  void initState() {
    super.initState();
    _balance = widget.initialBalance;

    _clips = widget.initialClips ??
        [
          ClipProposalModel(
            clipId: 'clip-m-01',
            startS: 30.0,
            endS: 75.0,
            durationS: 45.0,
            title: '3 Chiến thuật chốt sale đột phá trên livestream',
            hookType: 'speech_hook',
            hookDescription: 'Speech hook: "Nếu bạn không áp dụng ngay điều này..."',
            viralityScore: calculateViralityScore(
              engagement: 88,
              hook: 92,
              pacing: 85,
              audio: 80,
              relevance: 0,
              hasTrendData: false,
            ),
            transcriptSnippet: 'Nếu bạn không áp dụng ngay điều này trong 3 giây đầu livestream...',
            isSelected: true,
          ),
          ClipProposalModel(
            clipId: 'clip-m-02',
            startS: 180.0,
            endS: 222.0,
            durationS: 42.0,
            title: 'Visual Drop: Cận cảnh biến hình diện mạo mới',
            hookType: 'visual_hook',
            hookDescription: 'Visual hook: Dynamic beat drop & camera zoom',
            viralityScore: calculateViralityScore(
              engagement: 84,
              hook: 86,
              pacing: 90,
              audio: 88,
              relevance: 0,
              hasTrendData: false,
            ),
            transcriptSnippet: '',
            isSelected: true,
          ),
          ClipProposalModel(
            clipId: 'clip-m-03',
            startS: 420.0,
            endS: 468.0,
            durationS: 48.0,
            title: 'Cách tối ưu phễu chuyển đổi từ 0 lên 1000 đơn',
            hookType: 'speech_hook',
            hookDescription: 'Speech hook: "Bí mật tối ưu phễu không ai nói với bạn"',
            viralityScore: calculateViralityScore(
              engagement: 92,
              hook: 95,
              pacing: 89,
              audio: 84,
              relevance: 0,
              hasTrendData: false,
            ),
            transcriptSnippet: 'Bí mật tối ưu phễu không ai nói với bạn ở các khóa học trả phí...',
            isSelected: true,
          ),
        ];

    _variantConfigs = {
      for (final c in _clips)
        c.clipId: ClipVariantConfigModel(
          clipId: c.clipId,
          targetRatios: ['9:16', '1:1'],
          subtitleFirst: true,
          ctaText: 'Follow để xem tiếp!',
        ),
    };
  }

  void _toggleSpeechMode() {
    setState(() {
      _hasSpeech = !_hasSpeech;
      _clips = _clips.map((clip) {
        final strategy = deriveHookStrategy(
          hasSpeech: _hasSpeech,
          transcriptSnippet: _hasSpeech ? clip.transcriptSnippet : '',
          visualBeatPattern: 'Visual beat & scene motion detection',
        );
        final newScore = calculateViralityScore(
          engagement: clip.viralityScore.engagementPrediction,
          hook: (strategy['hookStrengthScore'] as num).toDouble(),
          pacing: clip.viralityScore.pacingScore,
          audio: clip.viralityScore.audioEnergy,
          relevance: clip.viralityScore.contentRelevance,
          hasTrendData: _hasTrendData,
        );
        return clip.copyWith(
          hookType: strategy['hookType'] as String,
          hookDescription: strategy['hookDescription'] as String,
          viralityScore: newScore,
        );
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _hasSpeech
              ? 'Đã bật phân tích giọng nói (Speech Hook)'
              : 'Đã chuyển sang Visual Path & Beat Analysis (EC-M07-C01)',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleTrendData() {
    setState(() {
      _hasTrendData = !_hasTrendData;
      _clips = _clips.map((clip) {
        final newScore = calculateViralityScore(
          engagement: clip.viralityScore.engagementPrediction,
          hook: clip.viralityScore.hookStrength,
          pacing: clip.viralityScore.pacingScore,
          audio: clip.viralityScore.audioEnergy,
          relevance: _hasTrendData ? 88.0 : 0.0,
          hasTrendData: _hasTrendData,
        );
        return clip.copyWith(viralityScore: newScore);
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _hasTrendData
              ? 'Đã liên kết xu hướng từ M02/M03'
              : 'Thiếu dữ liệu trend: Nhãn "⚠️ Pattern-only" được kích hoạt',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleClipSelection(String clipId) {
    setState(() {
      _clips = _clips.map((c) {
        if (c.clipId == clipId) {
          return c.copyWith(isSelected: !c.isSelected);
        }
        return c;
      }).toList();
    });
  }

  void _showLineageInspectionDialog(BuildContext ctx, Map<String, dynamic> lineage) {
    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Row(
          children: [
            Text('🧬 ', style: TextStyle(fontSize: 18)),
            Expanded(
              child: Text(
                'Source Lineage (AC-5 / AT-3)',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Clip con được dẫn xuất có nguồn gốc rõ ràng, tuân thủ chuẩn -14.0 LUFS:',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    const JsonEncoder.withIndent('  ').convert(lineage),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.greenAccent,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Đóng', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _processBatch() {
    final selected = _clips.where((c) => c.isSelected).toList();
    if (selected.isEmpty) return;

    int totalVariants = 0;
    for (final c in selected) {
      final cfg = _variantConfigs[c.clipId];
      totalVariants += cfg?.targetRatios.length ?? 1;
    }
    final totalCost = totalVariants * 5;

    if (_balance < totalCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số dư credit không đủ!')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      final List<ProcessedClipOutputModel> outputs = [];
      for (final clip in selected) {
        final cfg = _variantConfigs[clip.clipId] ??
            ClipVariantConfigModel(
              clipId: clip.clipId,
              targetRatios: ['9:16'],
            );

        for (final ratio in cfg.targetRatios) {
          final outId = 'clip-${clip.clipId}-${ratio.replaceAll(':', 'x')}';
          final lineage = buildClipLineagePayload(
            sourceAssetId: widget.sourceAssetId,
            clipId: clip.clipId,
            startS: clip.startS,
            endS: clip.endS,
            ratio: ratio,
            hasTrendData: _hasTrendData,
            ctaText: cfg.ctaText,
          );

          outputs.add(
            ProcessedClipOutputModel(
              outputAssetId: outId,
              clipId: clip.clipId,
              ratio: ratio,
              title: '${clip.title} [$ratio]',
              durationS: clip.durationS,
              videoUrl: 'https://cdn.creativanta.test/clips/$outId.mp4',
              lineageJson: jsonEncode(lineage),
              audioLufs: kCanonicalAudioLufs,
            ),
          );
        }
      }

      setState(() {
        _balance -= totalCost;
        _completedOutputs = outputs;
        _isProcessing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedClips = _clips.where((c) => c.isSelected).toList();
    int totalVariants = 0;
    for (final c in selectedClips) {
      final cfg = _variantConfigs[c.clipId];
      totalVariants += cfg?.targetRatios.length ?? 1;
    }
    final totalCost = totalVariants * 5;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2E),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Clip Factory (1→N)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              '${widget.sourceTitle} · 30:00',
              style: const TextStyle(fontSize: 11, color: Colors.white60),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.greenAccent.withAlpha(76)),
                ),
                child: Text(
                  '🪙 $_balance',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Target Toggles Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFF161622),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _toggleSpeechMode,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _hasSpeech ? Colors.blueAccent : Colors.amberAccent,
                      side: BorderSide(
                        color: _hasSpeech ? Colors.blueAccent : Colors.amberAccent,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: Icon(
                      _hasSpeech ? Icons.mic : Icons.music_note,
                      size: 16,
                    ),
                    label: Text(
                      _hasSpeech ? 'Speech Mode' : 'Visual Path',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _toggleTrendData,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _hasTrendData ? Colors.greenAccent : Colors.orangeAccent,
                      side: BorderSide(
                        color: _hasTrendData ? Colors.greenAccent : Colors.orangeAccent,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: Icon(
                      _hasTrendData ? Icons.trending_up : Icons.warning_amber_rounded,
                      size: 16,
                    ),
                    label: Text(
                      _hasTrendData ? 'Trend Linked' : 'Pattern-only',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: _completedOutputs.isNotEmpty
                ? _buildCompletedOutputsList()
                : _buildClipProposalsList(),
          ),

          // Bottom Action Bar
          if (_completedOutputs.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E2E),
                border: Border(top: BorderSide(color: Colors.white12)),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${selectedClips.length} clips · $totalVariants biến thể',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Chi phí: 🪙 $totalCost credits',
                            style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: selectedClips.isEmpty || _isProcessing ? null : _processBatch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'Xuất hàng loạt →',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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

  Widget _buildClipProposalsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _clips.length,
      itemBuilder: (ctx, idx) {
        final clip = _clips[idx];
        final cfg = _variantConfigs[clip.clipId] ??
            ClipVariantConfigModel(clipId: clip.clipId, targetRatios: ['9:16']);

        return Card(
          color: const Color(0xFF1A1A27),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: clip.isSelected ? const Color(0xFF7C3AED) : Colors.white10,
              width: clip.isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Timecode & Checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '⏱️ ${clip.startS.toInt()}s - ${clip.endS.toInt()}s (${clip.durationS.toInt()}s)',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    Checkbox(
                      value: clip.isSelected,
                      activeColor: const Color(0xFF7C3AED),
                      onChanged: (_) => _toggleClipSelection(clip.clipId),
                    ),
                  ],
                ),

                const SizedBox(height: 6),
                Text(
                  clip.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),
                // Hook Badge (Acceptance Target 1)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: clip.hookType == 'visual_hook'
                            ? Colors.amber.withAlpha(51)
                            : Colors.blue.withAlpha(51),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: clip.hookType == 'visual_hook'
                              ? Colors.amberAccent
                              : Colors.blueAccent,
                        ),
                      ),
                      child: Text(
                        clip.hookType == 'visual_hook' ? '👁️ Visual Hook' : '🗣️ Speech Hook',
                        style: TextStyle(
                          color: clip.hookType == 'visual_hook'
                              ? Colors.amberAccent
                              : Colors.blueAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        clip.hookDescription,
                        style: const TextStyle(color: Colors.white54, fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                // Virality Score & Badge (Acceptance Target 2)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${clip.viralityScore.compositeScore}',
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            '/100 Virality',
                            style: TextStyle(color: Colors.white54, fontSize: 11),
                          ),
                        ],
                      ),
                      // Target 2 Badge Label
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: clip.viralityScore.hasTrendData
                              ? Colors.green.withAlpha(51)
                              : Colors.orange.withAlpha(51),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: clip.viralityScore.hasTrendData
                                ? Colors.greenAccent
                                : Colors.orangeAccent,
                          ),
                        ),
                        child: Text(
                          clip.viralityScore.scoreBadge,
                          style: TextStyle(
                            color: clip.viralityScore.hasTrendData
                                ? Colors.greenAccent
                                : Colors.orangeAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                // Aspect Ratio Selector
                Row(
                  children: [
                    const Text(
                      'Tỷ lệ: ',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    for (final ratio in ['9:16', '16:9', '1:1']) ...[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            final current = List<String>.from(cfg.targetRatios);
                            if (current.contains(ratio)) {
                              if (current.length > 1) current.remove(ratio);
                            } else {
                              current.add(ratio);
                            }
                            _variantConfigs[clip.clipId] = cfg.copyWith(targetRatios: current);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: cfg.targetRatios.contains(ratio)
                                ? const Color(0xFF7C3AED)
                                : Colors.black45,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            ratio,
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletedOutputsList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.green.withAlpha(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🎉 Đã xuất thành công ${_completedOutputs.length} clip biến thể',
                style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
              ),
              TextButton(
                onPressed: () => setState(() => _completedOutputs = []),
                child: const Text('← Trở lại', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _completedOutputs.length,
            itemBuilder: (ctx, idx) {
              final out = _completedOutputs[idx];
              final lineageMap = jsonDecode(out.lineageJson) as Map<String, dynamic>;

              return Card(
                color: const Color(0xFF1A1A27),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(
                    out.title,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Asset: ${out.outputAssetId}\n🔊 ${out.audioLufs} LUFS · Lineage OK',
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  trailing: TextButton.icon(
                    onPressed: () => _showLineageInspectionDialog(context, lineageMap),
                    icon: const Icon(Icons.info_outline, size: 16, color: Colors.purpleAccent),
                    label: const Text('Lineage', style: TextStyle(color: Colors.purpleAccent, fontSize: 11)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
