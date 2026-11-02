import 'package:flutter/material.dart';
import 'package:creativanta_mobile/auth/auth_provider_adapter.dart';

/// Modal dialog presented when a session token expires during active use.
///
/// Implements EC-AUTH-002:
/// - Informs the user that their session token has expired.
/// - Provides actions to attempt token refresh or sign out to the login screen.
/// - Fail-closed: prevents unauthenticated state access.
class SessionExpiredDialog extends StatefulWidget {
  const SessionExpiredDialog({
    super.key,
    required this.authAdapter,
    this.onRefreshSuccess,
    this.onSignOut,
  });

  final AuthProviderAdapter authAdapter;
  final VoidCallback? onRefreshSuccess;
  final VoidCallback? onSignOut;

  static const Color paper = Color(0xFFFBF9F5);
  static const Color ink = Color(0xFF242924);
  static const Color forest = Color(0xFF274333);
  static const Color vermilion = Color(0xFFD94A31);
  static const Color textMuted = Color(0xFF7D837B);

  static Future<void> show({
    required BuildContext context,
    required AuthProviderAdapter authAdapter,
    VoidCallback? onRefreshSuccess,
    VoidCallback? onSignOut,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: SessionExpiredDialog(
          authAdapter: authAdapter,
          onRefreshSuccess: onRefreshSuccess,
          onSignOut: onSignOut,
        ),
      ),
    );
  }

  @override
  State<SessionExpiredDialog> createState() => _SessionExpiredDialogState();
}

class _SessionExpiredDialogState extends State<SessionExpiredDialog> {
  bool _isRefreshing = false;
  String? _errorMessage;

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
      _errorMessage = null;
    });

    final result = await widget.authAdapter.refreshToken();
    if (!mounted) return;

    setState(() {
      _isRefreshing = false;
    });

    if (result.isSuccess) {
      widget.onRefreshSuccess?.call();
      Navigator.of(context).pop();
    } else {
      setState(() {
        _errorMessage = result.failure?.message ??
            'Làm mới phiên không thành công. Vui lòng đăng nhập lại.';
      });
    }
  }

  Future<void> _handleSignOut() async {
    await widget.authAdapter.signOut();
    if (!mounted) return;
    widget.onSignOut?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: SessionExpiredDialog.paper,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.timer_outlined, color: SessionExpiredDialog.vermilion),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Phiên đăng nhập đã hết hạn',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: SessionExpiredDialog.ink,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mã phiên xác thực Clerk của bạn đã hết hạn. Theo nguyên tắc bảo mật Creativanta, cần làm mới phiên hoặc đăng nhập lại để tiếp tục.',
            style: TextStyle(
              fontSize: 13,
              color: SessionExpiredDialog.textMuted,
              height: 1.5,
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFECEB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: SessionExpiredDialog.vermilion),
              ),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: SessionExpiredDialog.vermilion,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isRefreshing ? null : _handleSignOut,
          child: const Text('Đăng xuất'),
        ),
        FilledButton(
          onPressed: _isRefreshing ? null : _handleRefresh,
          style: FilledButton.styleFrom(
            backgroundColor: SessionExpiredDialog.forest,
          ),
          child: _isRefreshing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Làm mới phiên'),
        ),
      ],
    );
  }
}
