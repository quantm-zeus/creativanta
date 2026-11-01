import 'package:flutter/material.dart';
import 'package:creativanta_mobile/auth/auth_models.dart';
import 'package:creativanta_mobile/auth/auth_provider_adapter.dart';

/// User-facing identity entry screen for Creativanta Mobile.
///
/// Implements responsive, fail-closed authentication boundary:
/// - Prominently displays external Clerk provider gate when unconfigured.
/// - Rejects simulated or unverified logins.
/// - Never persists cleartext credentials.
class MobileAuthScreen extends StatefulWidget {
  const MobileAuthScreen({
    super.key,
    required this.authAdapter,
    this.onAuthenticationSuccess,
  });

  final AuthProviderAdapter authAdapter;
  final VoidCallback? onAuthenticationSuccess;

  static const Color paper = Color(0xFFFBF9F5);
  static const Color surface = Color(0xFFFFFEFA);
  static const Color ink = Color(0xFF242924);
  static const Color forest = Color(0xFF274333);
  static const Color forestSubtle = Color(0xFFEAF3EA);
  static const Color vermilion = Color(0xFFD94A31);
  static const Color textMuted = Color(0xFF7D837B);
  static const Color border = Color(0xFFE8E5DC);

  @override
  State<MobileAuthScreen> createState() => _MobileAuthScreenState();
}

class _MobileAuthScreenState extends State<MobileAuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  String? _localErrorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    setState(() {
      _localErrorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!widget.authAdapter.isConfigured) {
      setState(() {
        _localErrorMessage = widget.authAdapter.externalGateDescription;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await widget.authAdapter.signInWithEmailPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      widget.onAuthenticationSuccess?.call();
    } else {
      setState(() {
        _localErrorMessage = result.failure?.message ?? 'Đăng nhập không thành công';
      });
    }
  }

  Future<void> _handleOAuth(OAuthProvider provider) async {
    setState(() {
      _localErrorMessage = null;
    });

    if (!widget.authAdapter.isConfigured) {
      setState(() {
        _localErrorMessage =
            'Đăng nhập qua ${provider.displayName} tạm khóa: ${widget.authAdapter.externalGateDescription}';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await widget.authAdapter.signInWithOAuth(provider);
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      widget.onAuthenticationSuccess?.call();
    } else {
      setState(() {
        _localErrorMessage = result.failure?.message ?? 'Đăng nhập OAuth thất bại';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConfigured = widget.authAdapter.isConfigured;

    return Scaffold(
      backgroundColor: MobileAuthScreen.paper,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand Header
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.layers_rounded,
                          color: MobileAuthScreen.vermilion,
                          size: 32,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'creativanta.',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.2,
                            color: MobileAuthScreen.ink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'PROOFED TREND-TO-PROFIT OS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: MobileAuthScreen.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Fail-Closed External Gate Banner (when unconfigured)
                    if (!isConfigured) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF6ED),
                          border: Border.all(color: const Color(0xFFF5C5A3)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.shield_outlined,
                                  color: MobileAuthScreen.vermilion,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'CỔNG XÁC THỰC NGOẠI VI (EXTERNAL GATE)',
                                    style: TextStyle(
                                      color: MobileAuthScreen.vermilion,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 11,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Clerk Identity Provider chưa được kích hoạt cho môi trường này. '
                              'Đăng nhập tạm khóa theo nguyên tắc fail-closed: không sử dụng tài khoản giả và không lưu token không hợp lệ.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: Color(0xFF8B4513),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.authAdapter.externalGateDescription,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFFA0522D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Error display banner
                    if (_localErrorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFECEB),
                          border: Border.all(color: MobileAuthScreen.vermilion),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: MobileAuthScreen.vermilion,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _localErrorMessage!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: MobileAuthScreen.vermilion,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Email Input Field
                    const Text(
                      'Email tài khoản',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: MobileAuthScreen.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        hintText: 'creator@creativanta.com',
                        filled: true,
                        fillColor: MobileAuthScreen.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MobileAuthScreen.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MobileAuthScreen.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: MobileAuthScreen.forest,
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập email.';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Định dạng email không hợp lệ.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Input Field
                    const Text(
                      'Mật khẩu',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: MobileAuthScreen.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        filled: true,
                        fillColor: MobileAuthScreen.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                            color: MobileAuthScreen.textMuted,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MobileAuthScreen.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MobileAuthScreen.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: MobileAuthScreen.forest,
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Primary Sign-in Button
                    FilledButton(
                      onPressed: _isLoading ? null : _handleSignIn,
                      style: FilledButton.styleFrom(
                        backgroundColor: MobileAuthScreen.forest,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isConfigured
                                  ? 'Đăng nhập vào Creativanta'
                                  : 'Đăng nhập (Cần cấu hình IdP)',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),

                    // Divider with text
                    const Row(
                      children: [
                        Expanded(child: Divider(color: MobileAuthScreen.border)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'HOẶC',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                              color: MobileAuthScreen.textMuted,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: MobileAuthScreen.border)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Social OAuth Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isLoading
                                ? null
                                : () => _handleOAuth(OAuthProvider.google),
                            icon: const Icon(Icons.g_mobiledata, size: 24),
                            label: const Text('Google'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: MobileAuthScreen.ink,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: MobileAuthScreen.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isLoading
                                ? null
                                : () => _handleOAuth(OAuthProvider.apple),
                            icon: const Icon(Icons.apple, size: 20),
                            label: const Text('Apple'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: MobileAuthScreen.ink,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: MobileAuthScreen.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Security contract notice
                    const Text(
                      'Bảo mật theo chuẩn Creativanta P0-03 · Xác thực Clerk JWT ngắn hạn · Không lưu mật khẩu hoặc token dạng văn bản thuần.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: MobileAuthScreen.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
