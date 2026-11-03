import 'package:flutter/material.dart';
import 'package:creativanta_mobile/content/idea_models.dart';

/// QuickCaptureSheet implements screen M006 for fast mobile idea capture.
/// Fulfills Acceptance Target 3 (Mobile title-only draft works)
/// and Acceptance Target 1 (Duplicate idea warns without silent merge).
class QuickCaptureSheet extends StatefulWidget {
  const QuickCaptureSheet({
    super.key,
    required this.workspaceId,
    required this.userId,
    this.existingIdeas = const [],
    required this.onIdeaSaved,
  });

  final String workspaceId;
  final String userId;
  final List<IdeaItem> existingIdeas;
  final ValueChanged<IdeaItem> onIdeaSaved;

  @override
  State<QuickCaptureSheet> createState() => _QuickCaptureSheetState();
}

class _QuickCaptureSheetState extends State<QuickCaptureSheet> {
  final TextEditingController _titleController = TextEditingController();
  DuplicateWarningItem? _duplicateWarning;
  bool _proceedAnyway = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onTitleChanged(String value) {
    if (_proceedAnyway) return;

    final warning = IdeaItem.checkDuplicate(
      title: value,
      existingIdeas: widget.existingIdeas,
      threshold: 0.85,
    );

    setState(() {
      _duplicateWarning = warning;
    });
  }

  void _saveDraft({bool force = false}) {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tiêu đề ý tưởng')),
      );
      return;
    }

    if (!force && _duplicateWarning != null && !_proceedAnyway) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_duplicateWarning!.warningMessage),
          backgroundColor: Colors.amber.shade800,
        ),
      );
      return;
    }

    // Acceptance Target 3: Mobile title-only draft works
    final draftIdea = IdeaItem.createMobileQuickCapture(
      workspaceId: widget.workspaceId,
      userId: widget.userId,
      title: title,
    );

    widget.onIdeaSaved(draftIdea);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF274333),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'M05',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '⚡ Ghi ý tưởng nhanh',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF242924),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Chỉ cần nhập tiêu đề để lưu bản nháp tức thì trong 3 giây. Thông tin chi tiết có thể bổ sung sau.',
            style: TextStyle(fontSize: 12, color: Color(0xFF616C63)),
          ),
          const SizedBox(height: 16),

          // Duplicate warning banner if >0.85
          if (_duplicateWarning != null && !_proceedAnyway) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade300, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: Colors.amber.shade800, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Ý tưởng tương tự đã tồn tại (${(_duplicateWarning!.similarityScore * 100).round()}%)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Đã có: "${_duplicateWarning!.existingIdeaTitle}"',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.amber.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          textStyle: const TextStyle(fontSize: 11),
                        ),
                        onPressed: () {
                          setState(() {
                            _proceedAnyway = true;
                          });
                          _saveDraft(force: true);
                        },
                        child: const Text('Vẫn lưu (Không gộp)'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          TextField(
            controller: _titleController,
            autofocus: true,
            onChanged: _onTitleChanged,
            decoration: const InputDecoration(
              hintText: 'Nhập tiêu đề ý tưởng (ví dụ: Skincare mùa hè...)',
              hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF274333),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _saveDraft(force: _proceedAnyway),
            child: const Text(
              'Lưu bản nháp (Draft)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
