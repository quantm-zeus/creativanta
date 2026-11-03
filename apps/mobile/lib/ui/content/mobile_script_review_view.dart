import 'package:flutter/material.dart';
import 'package:creativanta_mobile/content/content_handoff_models.dart';
import 'package:creativanta_mobile/content/script_models.dart';
import 'package:creativanta_mobile/generated/creativanta/content/v1/script.pbenum.dart';
import 'package:creativanta_mobile/ui/content/source_chain_lineage_widget.dart';

/// Mobile review and approval screen for Module M06 (Script Lab).
class MobileScriptReviewView extends StatefulWidget {
  const MobileScriptReviewView({
    super.key,
    required this.script,
    this.lineage,
    this.assetBrief,
    required this.reviewerExpectedVersion,
    required this.onApprove,
    required this.onReject,
  });

  final ScriptItem script;
  final SourceChainLineage? lineage;
  final AssetBriefItem? assetBrief;
  final int reviewerExpectedVersion;
  final VoidCallback onApprove;
  final ValueChanged<String> onReject;

  @override
  State<MobileScriptReviewView> createState() => _MobileScriptReviewViewState();
}

class _MobileScriptReviewViewState extends State<MobileScriptReviewView> {
  final _rejectionController = TextEditingController();

  @override
  void dispose() {
    _rejectionController.dispose();
    super.dispose();
  }

  void _showRejectionDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final validation = validateRejectionReason(_rejectionController.text);
            return AlertDialog(
              key: const Key('mobile-rejection-dialog'),
              title: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Từ chối kịch bản', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vui lòng nhập lý do cụ thể (tối thiểu 10 ký tự) để tác giả sửa đổi (RULE-M06-002):',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('rejection-reason-input'),
                    controller: _rejectionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Ví dụ: Cảnh 1 hook quá chậm, cần cắt ngắn thành 3 giây...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: !validation.isValid && _rejectionController.text.trim().isNotEmpty
                            ? Text(
                                validation.errorMessage ?? '',
                                style: const TextStyle(fontSize: 11, color: Colors.red),
                              )
                            : validation.isValid
                                ? Text(
                                    '✓ Hợp lệ (${validation.characterCount} ký tự)',
                                    style: const TextStyle(fontSize: 11, color: Colors.green),
                                  )
                                : const Text('Tối thiểu 10 ký tự', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_rejectionController.text.trim().length} / 10',
                        style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  key: const Key('confirm-rejection-btn'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: validation.isValid
                      ? () {
                          final text = _rejectionController.text.trim();
                          Navigator.of(ctx).pop();
                          widget.onReject(text);
                        }
                      : null,
                  child: const Text('Xác nhận từ chối', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isStale = isReviewStale(widget.script.versionIndex, widget.reviewerExpectedVersion);
    final readiness = isReadyForProductionEligible(widget.script, widget.assetBrief);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.script.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          Chip(
            label: Text(
              widget.script.approvalState == ScriptApprovalState.SCRIPT_APPROVAL_STATE_APPROVED
                  ? 'Đã duyệt'
                  : widget.script.approvalState == ScriptApprovalState.SCRIPT_APPROVAL_STATE_REJECTED
                      ? 'Cần sửa'
                      : widget.script.approvalState == ScriptApprovalState.SCRIPT_APPROVAL_STATE_PENDING_APPROVAL
                          ? 'Chờ duyệt'
                          : 'Bản nháp',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stale warning banner (EC-M06-003)
          if (isStale)
            Card(
              key: const Key('stale-review-banner'),
              color: Colors.amber[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.amber[400]!),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.amber),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Kịch bản đã được tác giả cập nhật sau khi bạn mở xem (EC-M06-003). Vui lòng tải lại trang để tránh xung đột.',
                        style: TextStyle(fontSize: 12, color: Colors.brown, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Source Chain Lineage Breadcrumb
          if (widget.lineage != null) ...[
            SourceChainLineageWidget(lineage: widget.lineage!),
            const SizedBox(height: 12),
          ],

          // Script scenes breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Phân cảnh (${widget.script.scenes.length})',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Tổng: ${calculateTotalDuration(widget.script.scenes)}s / ${calculateWordCount(widget.script.scenes)} từ',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const Divider(),
                  ...widget.script.scenes.map((sc) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  'Cảnh #${sc.sceneIndex + 1}',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.indigo[700]),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(sc.description, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              ),
                              Text('${sc.durationSeconds}s', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(sc.content, style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Production Readiness Card (RULE-M06-005, RULE-M06-006, AC-2)
          Card(
            key: const Key('mobile-asset-brief-card'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.video_library, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text('Bản tóm tắt sản xuất (Asset Brief)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (widget.assetBrief != null) ...[
                    Text('Định dạng: ${widget.assetBrief!.targetFormat} • Thời lượng: ${widget.assetBrief!.targetDurationSeconds}s',
                        style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      readiness.isEligible
                          ? '✓ Đủ điều kiện sẵn sàng sản xuất (Ready for production).'
                          : '⚠️ Chưa đủ điều kiện: ${readiness.reasons.join(", ")}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: readiness.isEligible ? Colors.green[700] : Colors.orange[800],
                      ),
                    ),
                  ] else ...[
                    Text('Chưa tạo Asset Brief cho kịch bản này.', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('reject-script-button'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: isStale ? null : _showRejectionDialog,
                  icon: const Icon(Icons.close),
                  label: const Text('Từ chối duyệt'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('approve-script-button'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: isStale ? null : widget.onApprove,
                  icon: const Icon(Icons.check),
                  label: const Text('Phê duyệt'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
