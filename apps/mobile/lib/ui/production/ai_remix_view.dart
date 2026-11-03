import 'package:flutter/material.dart';
import '../../production/production_models.dart';

/// Screen M016: Mobile AI Remix Studio
class AiRemixView extends StatefulWidget {
  final int initialBalance;

  const AiRemixView({
    super.key,
    this.initialBalance = 200,
  });

  @override
  State<AiRemixView> createState() => _AiRemixViewState();
}

class _AiRemixViewState extends State<AiRemixView> {
  late int _balance;
  int _currentPhase = 1; // 1: Input, 2: DNA Report, 3: Polish & Export

  // Phase 1 Controllers
  final TextEditingController _urlController = TextEditingController(
    text: 'https://tiktok.com/@creator/video/73918274912',
  );
  final TextEditingController _topicController = TextEditingController(
    text: 'Bí quyết dưỡng da căng bóng mùa hè',
  );
  double _fidelityValue = 1.0; // 0: Match 1:1, 1: Adapt, 2: Loose
  ReferenceUrlValidation? _urlValidation;
  bool _isAnalyzing = false;

  // Phase 2 DNA toggles
  bool _keepPacing = true;
  bool _keepVisualStyle = true;
  bool _keepAudio = true;
  bool _isGenerating = false;

  // Phase 3 Results
  OriginalityCheckModel? _originalityCheck;
  double _similarityPercentage = 18.5;

  @override
  void initState() {
    super.initState();
    _balance = widget.initialBalance;
  }

  @override
  void dispose() {
    _urlController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  String get _fidelityName {
    if (_fidelityValue < 0.5) return 'Match 1:1';
    if (_fidelityValue < 1.5) return 'Adapt (Default)';
    return 'Loose Inspiration';
  }

  void _onUrlChanged(String val) {
    if (val.trim().isNotEmpty) {
      final res = validateReferenceUrl(val);
      setState(() {
        _urlValidation = res.isValid ? null : res;
      });
    } else {
      setState(() {
        _urlValidation = null;
      });
    }
  }

  void _analyzeReference() {
    final res = validateReferenceUrl(_urlController.text);
    if (!res.isValid) {
      setState(() {
        _urlValidation = res;
      });
      return;
    }

    if (_balance < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không đủ credits để phân tích (~8 cr required)')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _urlValidation = null;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _balance -= 8;
        _isAnalyzing = false;
        _currentPhase = 2;
      });
    });
  }

  void _generateRemix() {
    if (_balance < 35) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không đủ credits để tạo remix (~35 cr required)')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      // If fidelity is 0 (Match 1:1) and topic was identical, simulate similarity >= 30%
      double sim = 18.5;
      if (_fidelityValue < 0.5) {
        sim = 35.0; // Rejected by canonical threshold < 30%
      }

      final check = evaluateRemixOriginality(sim);
      setState(() {
        _isGenerating = false;
        _similarityPercentage = sim;
        _originalityCheck = check;
        if (check.passed) {
          _balance -= 35; // Charged only if passed
        }
        _currentPhase = 3;
      });
    });
  }

  void _regenerateOriginality() {
    setState(() {
      _similarityPercentage = 14.0;
      _originalityCheck = evaluateRemixOriginality(14.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('🔄 AI Remix Studio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple),
                ),
                child: Text(
                  '$_balance cr',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Step Wizard Indicator
          Container(
            color: const Color(0xFF1E1E1E),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepTab(1, 'Phase 1: Input'),
                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                _buildStepTab(2, 'Phase 2: DNA Report'),
                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                _buildStepTab(3, 'Phase 3: Polish'),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildCurrentPhaseContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTab(int step, String title) {
    final isActive = _currentPhase == step;
    return GestureDetector(
      onTap: () {
        if (step <= _currentPhase) {
          setState(() => _currentPhase = step);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.deepPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPhaseContent() {
    switch (_currentPhase) {
      case 1:
        return _buildPhase1Input();
      case 2:
        return _buildPhase2DnaReport();
      case 3:
      default:
        return _buildPhase3Polish();
    }
  }

  Widget _buildPhase1Input() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Video tham khảo (Reference URL)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('remix-url-input'),
          controller: _urlController,
          onChanged: _onUrlChanged,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'https://tiktok.com/@user/video/...',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF262626),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.link, color: Colors.deepPurpleAccent),
          ),
        ),
        if (_urlValidation != null) ...[
          const SizedBox(height: 10),
          Container(
            key: const Key('url-error-box'),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade900.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade700),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.redAccent, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _urlValidation!.errorMessage ?? 'Lỗi URL',
                        style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                if (_urlValidation!.actionableAdvice != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _urlValidation!.actionableAdvice!,
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        const Text(
          'Độ bám sát kịch bản (Fidelity Level)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          _fidelityName,
          style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Slider(
          key: const Key('fidelity-slider'),
          value: _fidelityValue,
          min: 0.0,
          max: 2.0,
          divisions: 2,
          activeColor: Colors.deepPurpleAccent,
          onChanged: (val) {
            setState(() => _fidelityValue = val);
          },
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Strict (1:1)', style: TextStyle(color: Colors.grey, fontSize: 11)),
            Text('Adapt', style: TextStyle(color: Colors.grey, fontSize: 11)),
            Text('Loose (Free)', style: TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Chủ đề nội dung mới',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _topicController,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF262626),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            key: const Key('analyze-button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _isAnalyzing ? null : _analyzeReference,
            child: _isAnalyzing
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('🔍 Phân tích Creative DNA (~8 cr)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildPhase2DnaReport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🧬 Báo cáo Creative DNA',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 4),
        const Text(
          'Nhấn để xem và giữ nguyên hoặc điều chỉnh từng yếu tố cốt lõi.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        ExpansionTile(
          key: const Key('tile-pacing'),
          collapsedBackgroundColor: const Color(0xFF262626),
          backgroundColor: const Color(0xFF262626),
          textColor: Colors.white,
          collapsedTextColor: Colors.white,
          title: const Text('Nhịp điệu phân cảnh (Pacing: 28s - 6 cảnh)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          children: [
            SwitchListTile(
              title: const Text('Giữ nhịp điệu gốc (Hook 3s, Tips 6s, CTA 5s)', style: TextStyle(fontSize: 12, color: Colors.white70)),
              value: _keepPacing,
              activeThumbColor: Colors.deepPurpleAccent,
              onChanged: (val) => setState(() => _keepPacing = val),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ExpansionTile(
          key: const Key('tile-visual'),
          collapsedBackgroundColor: const Color(0xFF262626),
          backgroundColor: const Color(0xFF262626),
          textColor: Colors.white,
          collapsedTextColor: Colors.white,
          title: const Text('Phong cách hình ảnh (Visual: Bright palette)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          children: [
            SwitchListTile(
              title: const Text('Giữ góc máy cận & chuyển cảnh zoom-in', style: TextStyle(fontSize: 12, color: Colors.white70)),
              value: _keepVisualStyle,
              activeThumbColor: Colors.deepPurpleAccent,
              onChanged: (val) => setState(() => _keepVisualStyle = val),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ExpansionTile(
          key: const Key('tile-audio'),
          collapsedBackgroundColor: const Color(0xFF262626),
          backgroundColor: const Color(0xFF262626),
          textColor: Colors.white,
          collapsedTextColor: Colors.white,
          title: const Text('Âm thanh & Voiceover (BPM 120 Pop Beat)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          children: [
            SwitchListTile(
              title: const Text('Giữ cấu trúc thoại 70% / Nhạc nền 30%', style: TextStyle(fontSize: 12, color: Colors.white70)),
              value: _keepAudio,
              activeThumbColor: Colors.deepPurpleAccent,
              onChanged: (val) => setState(() => _keepAudio = val),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            key: const Key('generate-button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _isGenerating ? null : _generateRemix,
            child: _isGenerating
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('🚀 Tạo Video Remix (~35 cr)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildPhase3Polish() {
    final check = _originalityCheck ?? evaluateRemixOriginality(_similarityPercentage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Originality Safeguard Card
        Container(
          key: const Key('originality-card'),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: check.passed ? Colors.green.shade900.withValues(alpha: 0.4) : Colors.red.shade900.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: check.passed ? Colors.green.shade700 : Colors.red.shade700),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(check.passed ? Icons.verified : Icons.block, color: check.passed ? Colors.greenAccent : Colors.redAccent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        check.passed ? 'Originality Passed' : 'Originality Blocked',
                        style: TextStyle(
                          color: check.passed ? Colors.greenAccent : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${check.similarityPercentage.toStringAsFixed(1)}% Sim',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      color: check.passed ? Colors.greenAccent : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Canonical limit: < ${kCanonicalSimilarityThreshold.toStringAsFixed(0)}% (RULE-M07-003)',
                style: const TextStyle(fontSize: 11, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Text(
                check.explanation,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
              if (!check.passed) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '⛔ Không trừ credits khi vi phạm rào cản độc bản. Hãy chọn độ bám sát tự do hơn hoặc chỉnh sửa kịch bản thủ công.',
                    style: TextStyle(fontSize: 11, color: Colors.amberAccent),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Side-by-side or preview player box
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF262626),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  check.passed ? Icons.play_circle_filled : Icons.lock_outline,
                  size: 48,
                  color: check.passed ? Colors.deepPurpleAccent : Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  check.passed ? 'Sẵn sàng xem trước video' : 'Bản nháp bị chặn xem trước do trùng lặp',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (!check.passed) ...[
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              key: const Key('switch-loose-button'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.deepPurpleAccent),
              ),
              onPressed: () {
                setState(() {
                  _fidelityValue = 2.0; // Loose
                  _regenerateOriginality();
                });
              },
              child: const Text('🔄 Chuyển sang Loose Inspiration & Kiểm tra lại', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade800),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🎉 Video Remix đã được lưu vào thư viện!')),
                );
              },
              child: const Text('✅ Xuất Video Hoàn Thiện', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ],
    );
  }
}
