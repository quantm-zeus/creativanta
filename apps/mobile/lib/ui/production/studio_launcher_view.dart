import 'package:flutter/material.dart';
import '../../production/production_models.dart';

/// Screen M013: Mobile Studio Launcher
class StudioLauncherView extends StatefulWidget {
  final int initialBalance;
  final List<ProductionJobModel>? initialJobs;
  final StudioJobCancelCallback? onCancelJobRemote;
  final StudioBatchRunCallback? onRunBatchRemote;

  const StudioLauncherView({
    super.key,
    this.initialBalance = 500,
    this.initialJobs,
    this.onCancelJobRemote,
    this.onRunBatchRemote,
  });

  @override
  State<StudioLauncherView> createState() => _StudioLauncherViewState();
}

class _StudioLauncherViewState extends State<StudioLauncherView> {
  late int _balance;
  late List<ProductionJobModel> _jobs;
  String? _snackBarMessage;
  bool _isMutatingJob = false;

  @override
  void initState() {
    super.initState();
    _balance = widget.initialBalance;
    _jobs = widget.initialJobs ??
        [
          const ProductionJobModel(
            jobId: 'job-mob-01',
            assetId: 'asset-mob-01',
            title: 'Video review kem chống nắng SPF50',
            prompt: 'Quay cận cảnh chất kem mịn thoa trên da',
            provider: 'veo',
            status: 'processing',
            stage: 'Tạo hình ảnh visual',
            progressPct: 75,
            estimatedCredits: 80,
            actualCredits: 80,
            costCeilingUSD: 0.60,
          ),
          const ProductionJobModel(
            jobId: 'job-mob-02',
            assetId: 'asset-mob-02',
            title: 'Clip ngắn đồng hồ cơ',
            prompt: 'Chi tiết kim trôi mượt mà',
            provider: 'kling',
            status: 'processing',
            stage: 'Xử lý chuyển động (Fallback)',
            progressPct: 40,
            estimatedCredits: 80,
            actualCredits: 80,
            costCeilingUSD: 0.60,
          ),
        ];
  }

  Future<void> _cancelJob(String jobId) async {
    if (_isMutatingJob) return;
    final index = _jobs.indexWhere((j) => j.jobId == jobId);
    if (index == -1) return;
    final job = _jobs[index];
    if (job.status == 'completed' || job.status == 'cancelled') return;

    if (widget.onCancelJobRemote == null) {
      if (!mounted) return;
      const failClosedMsg =
          'Không thể hủy tiến trình: Dịch vụ StudioService/Cancel chưa kết nối máy chủ (fail-closed). Số dư và trạng thái tác vụ được giữ nguyên.';
      setState(() {
        _snackBarMessage = failClosedMsg;
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text(failClosedMsg),
            backgroundColor: Colors.red.shade800,
            duration: const Duration(seconds: 3),
          ),
        );
      return;
    }

    setState(() {
      _isMutatingJob = true;
    });

    try {
      final outcome = await widget.onCancelJobRemote!(jobId, job.estimatedCredits);
      if (!mounted) return;

      if (!outcome.ok) {
        final errMsg = outcome.errorMessage ??
            'Không thể hủy tiến trình $jobId trên máy chủ (StudioService/Cancel fail-closed). Số dư được giữ nguyên.';
        setState(() {
          _snackBarMessage = errMsg;
        });
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(errMsg),
              backgroundColor: Colors.red.shade800,
              duration: const Duration(seconds: 3),
            ),
          );
        return;
      }

      setState(() {
        if (outcome.creditsRefunded && outcome.refundedCredits > 0) {
          _balance += outcome.refundedCredits;
          _snackBarMessage =
              'Đã hủy job $jobId và hoàn trả ${outcome.refundedCredits} credits!';
        } else {
          _snackBarMessage = 'Đã hủy job $jobId theo xác nhận từ máy chủ.';
        }
        _jobs[index] = job.copyWith(
          status: 'cancelled',
          stage: 'Đã hủy bởi người dùng (xác nhận từ máy chủ)',
          progressPct: 0,
        );
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(_snackBarMessage ?? 'Đã hủy job'),
            backgroundColor: Colors.green.shade800,
            duration: const Duration(seconds: 3),
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isMutatingJob = false;
        });
      }
    }
  }

  void _showBatchPreviewDialog() {
    // 5-item batch with 1 invalid item for verification
    final rawBatch = [
      {'id': 'b-1', 'name': 'Son dưỡng ẩm Glow', 'prompt': 'Cận cảnh môi căng mọng'},
      {'id': 'b-2', 'name': 'Sữa rửa mặt bọt mịn', 'prompt': 'Lớp bọt làm sạch sâu'},
      {'id': 'b-3', 'name': '', 'prompt': 'Tên rỗng không hợp lệ'},
      {'id': 'b-4', 'name': 'Serum vitamin C', 'prompt': 'Tinh chất thẩm thấu nhanh'},
      {'id': 'b-5', 'name': 'Kem chống nắng nâng tone', 'prompt': 'Rạng rỡ tự nhiên'},
    ];

    final preview = evaluateBatchPreview(
      rawItems: rawBatch,
      availableCredits: _balance,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Text('💰 ', style: TextStyle(fontSize: 20)),
            Expanded(
              child: Text(
                'Xem trước ngân sách (Batch)',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mã báo giá: ${preview.quoteId}',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 11, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tổng số mục: ${preview.totalItems}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('Hợp lệ: ${preview.validCount}', style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('Không hợp lệ: ${preview.invalidCount}', style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ước tính: ${preview.totalCredits} credits', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('Số dư: $_balance cr', style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text('Chi tiết từng dòng:', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: preview.items.length,
                  itemBuilder: (c, idx) {
                    final item = preview.items[idx];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Row(
                        children: [
                          Icon(
                            item.isValid ? Icons.check_circle : Icons.cancel,
                            size: 14,
                            color: item.isValid ? Colors.greenAccent : Colors.redAccent,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemName,
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                                ),
                                if (!item.isValid && item.validationError != null)
                                  Text(
                                    item.validationError!,
                                    style: const TextStyle(color: Colors.redAccent, fontSize: 9),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            '${item.estimatedCredits} cr',
                            style: TextStyle(
                              color: item.isValid ? Colors.blueAccent : Colors.grey,
                              fontSize: 11,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: preview.sufficientCredits && preview.validCount > 0
                ? () async {
                    Navigator.of(ctx).pop();
                    if (widget.onRunBatchRemote == null) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Không thể khởi chạy Batch: Dịch vụ AssetService/Generate chưa kết nối máy chủ (fail-closed). Số dư được giữ nguyên.',
                          ),
                          backgroundColor: Colors.red.shade800,
                        ),
                      );
                      return;
                    }
                    final outcome = await widget.onRunBatchRemote!(preview);
                    if (!mounted) return;
                    if (!outcome.ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            outcome.errorMessage ??
                                'Không thể khởi chạy Batch trên máy chủ (fail-closed). Số dư được giữ nguyên.',
                          ),
                          backgroundColor: Colors.red.shade800,
                        ),
                      );
                      return;
                    }
                    setState(() {
                      _balance -= outcome.reservedCredits > 0
                          ? outcome.reservedCredits
                          : preview.totalCredits;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã khởi chạy mẻ ${preview.validCount} sản phẩm!'),
                        backgroundColor: Colors.blue.shade800,
                      ),
                    );
                  }
                : null,
            child: const Text('Xác nhận & Chạy', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeJobs = _jobs.where((j) => j.status == 'processing' || j.status == 'queued').toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Row(
          children: [
            Text('🎬 ', style: TextStyle(fontSize: 20)),
            Text('AI Studio (M013)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '$_balance cr',
                  key: const ValueKey('mobile_studio_credit_balance'),
                  style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Jobs Banner
            if (activeJobs.isNotEmpty) ...[
              const Text(
                'Tiến trình đang thực hiện',
                style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...activeJobs.map((job) => Card(
                    color: const Color(0xFF1E293B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.amber.withValues(alpha: 0.3)),
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  job.title,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: job.provider == 'kling' ? Colors.amber.shade900 : Colors.blue.shade900,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  job.provider == 'kling' ? 'Kling (Fallback)' : 'Veo (Primary)',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(job.stage, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: job.progressPct / 100.0,
                            backgroundColor: Colors.grey.shade800,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${job.progressPct}% · ${job.estimatedCredits} credits',
                                  style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace')),
                              TextButton(
                                key: ValueKey('cancel_job_${job.jobId}'),
                                onPressed: () => _cancelJob(job.jobId),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  backgroundColor: Colors.red.withValues(alpha: 0.2),
                                ),
                                child: const Text('Hủy & Hoàn', style: TextStyle(color: Colors.redAccent, fontSize: 11)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 16),
            ],

            // Batch Trigger Card
            Card(
              color: const Color(0xFF1E293B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.blueAccent, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Text('📦 ', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tạo hàng loạt (Batch Studio)',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Kiểm duyệt hạn mức & loại trừ sản phẩm lỗi',
                              style: TextStyle(color: Colors.white60, fontSize: 11)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      key: const ValueKey('open_batch_preview_btn'),
                      onPressed: _showBatchPreviewDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      child: const Text('Preview', style: TextStyle(color: Colors.white, fontSize: 11)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Modes Grid
            const Text(
              'Chế độ sản xuất AI',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.3,
              ),
              itemCount: kProductionModes.length,
              itemBuilder: (context, idx) {
                final mode = kProductionModes[idx];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(mode.icon, style: const TextStyle(fontSize: 20)),
                          if (mode.badge != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(mode.badge!, style: const TextStyle(color: Colors.blueAccent, fontSize: 9)),
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mode.title,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text('${mode.creditCost} credits',
                              style: const TextStyle(color: Colors.white54, fontSize: 10, fontFamily: 'monospace')),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
