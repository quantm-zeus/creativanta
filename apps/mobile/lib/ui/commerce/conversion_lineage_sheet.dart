import 'package:flutter/material.dart';
import 'package:creativanta_mobile/commerce/conversion_lineage_models.dart';

/// Modal bottom sheet allowing users to convert an Opportunity, Idea, or Thread
/// into a Campaign, Live Session, Offer, Seeding Request, or Brand Deal.
///
/// Strictly rechecks target permissions before initiating and displays
/// permission status to the operator.
class ConversionLineageSheet extends StatefulWidget {
  const ConversionLineageSheet({
    super.key,
    required this.workspaceId,
    required this.userRole,
    required this.userId,
    required this.source,
    this.onConverted,
  });

  final String workspaceId;
  final String userRole;
  final String userId;
  final SourceItem source;
  final void Function(ConversionExecutionResult result)? onConverted;

  @override
  State<ConversionLineageSheet> createState() => _ConversionLineageSheetState();
}

class _ConversionLineageSheetState extends State<ConversionLineageSheet> {
  ConversionTargetType _selectedTarget = ConversionTargetType.campaign;
  late final TextEditingController _titleController;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: '[From ${widget.source.sourceType.value}] ${widget.source.title}',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  ConversionPermissionCheckResult get _permissionCheck =>
      ConversionPermissions.evaluatePermissions(
        role: widget.userRole,
        source: widget.source.sourceType,
        target: _selectedTarget,
      );

  Future<void> _handleConvert() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final result = await executeCrossDomainConversion(
      workspaceId: widget.workspaceId,
      userRole: widget.userRole,
      userId: widget.userId,
      source: widget.source,
      targetType: _selectedTarget,
      targetTitle: _titleController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (result.success) {
      widget.onConverted?.call(result);
      Navigator.of(context).pop(result);
    } else {
      setState(() {
        _errorMessage = result.errorMessage ?? 'Chuyển đổi thất bại';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final check = _permissionCheck;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.transform, color: Colors.indigo),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Chuyển đổi sang Commerce: ${widget.source.title}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Source badge
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  'Nguồn (${widget.source.sourceType.value.toUpperCase()}): ',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Expanded(
                  child: Text(
                    widget.source.title,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Target selector
          DropdownButtonFormField<ConversionTargetType>(
            key: const Key('conversion-target-selector'),
            initialValue: _selectedTarget,
            decoration: const InputDecoration(
              labelText: 'Mục tiêu Commerce chuyển đổi',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: ConversionTargetType.campaign,
                child: Text('Chiến dịch (Campaign)'),
              ),
              DropdownMenuItem(
                value: ConversionTargetType.liveSession,
                child: Text('Phiên Live (Live Session)'),
              ),
              DropdownMenuItem(
                value: ConversionTargetType.offer,
                child: Text('Ưu đãi / Sản phẩm (Offer)'),
              ),
              DropdownMenuItem(
                value: ConversionTargetType.seedingRequest,
                child: Text('Gửi mẫu (Seeding Request)'),
              ),
              DropdownMenuItem(
                value: ConversionTargetType.brandDeal,
                child: Text('Hợp tác thương hiệu (Brand Deal - Manager+)'),
              ),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedTarget = val;
                  _errorMessage = null;
                });
              }
            },
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('conversion-target-title-input'),
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Tiêu đề tài nguyên đích',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          // Target permission badge or warning
          if (!check.allowed)
            Container(
              key: const Key('permission-denial-warning'),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.gpp_bad, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Vai trò ${widget.userRole} không có quyền: ${check.requiredPermission}',
                      style: TextStyle(color: Colors.red[900], fontSize: 12),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              key: const Key('permission-granted-info'),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Đủ quyền chuyển đổi: ${ConversionPermissions.getTargetPermission(_selectedTarget)}',
                      style: TextStyle(color: Colors.green[900], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              key: const Key('conversion-error-message'),
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            key: const Key('submit-conversion-button'),
            onPressed: (!check.allowed || _isSubmitting) ? null : _handleConvert,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Thực hiện chuyển đổi'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
