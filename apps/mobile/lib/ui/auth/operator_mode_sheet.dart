import 'package:flutter/material.dart';
import 'package:creativanta_mobile/auth/auth_models.dart';
import 'package:creativanta_mobile/auth/auth_provider_adapter.dart';

/// Modal bottom sheet enabling the user to switch between the 6 canonical operator modes.
///
/// Complies with docs/01_business/user_segments_and_modes.md:
/// - Creator Mode (`creator`)
/// - Seller Mode (`seller`)
/// - Affiliate Operator Mode (`affiliate_operator`)
/// - Live Operator Mode (`live_operator`)
/// - Agency / MCN Mode (`agency_mcn`)
/// - Brand Collaboration Mode (`brand_collaboration`)
class OperatorModeSheet extends StatelessWidget {
  const OperatorModeSheet({
    super.key,
    required this.authAdapter,
    this.onModeSelected,
  });

  final AuthProviderAdapter authAdapter;
  final void Function(OperatorMode mode)? onModeSelected;

  static const Color paper = Color(0xFFFBF9F5);
  static const Color surface = Color(0xFFFFFEFA);
  static const Color ink = Color(0xFF242924);
  static const Color forest = Color(0xFF274333);
  static const Color textMuted = Color(0xFF7D837B);
  static const Color border = Color(0xFFE8E5DC);

  static Future<void> show({
    required BuildContext context,
    required AuthProviderAdapter authAdapter,
    void Function(OperatorMode mode)? onModeSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => OperatorModeSheet(
        authAdapter: authAdapter,
        onModeSelected: onModeSelected,
      ),
    );
  }

  IconData _iconForMode(OperatorMode mode) {
    switch (mode) {
      case OperatorMode.creator:
        return Icons.auto_awesome_rounded;
      case OperatorMode.seller:
        return Icons.storefront_rounded;
      case OperatorMode.affiliateOperator:
        return Icons.link_rounded;
      case OperatorMode.liveOperator:
        return Icons.live_tv_rounded;
      case OperatorMode.agencyMcn:
        return Icons.groups_rounded;
      case OperatorMode.brandCollaboration:
        return Icons.handshake_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = authAdapter.currentSession;
    final currentMode = session?.activeMode ?? OperatorMode.creator;

    return Container(
      decoration: const BoxDecoration(
        color: OperatorModeSheet.paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4D0C5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chế độ vận hành (6 Modes)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: OperatorModeSheet.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    color: OperatorModeSheet.textMuted,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Mỗi chế độ thay đổi trọng tâm hiển thị và ưu tiên tác vụ trên Creativanta.',
                style: TextStyle(
                  fontSize: 12,
                  color: OperatorModeSheet.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),

              // 6 Mode options
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: OperatorMode.values.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final mode = OperatorMode.values[index];
                    final isSelected = mode == currentMode;

                    return InkWell(
                      onTap: () async {
                        await authAdapter.switchOperatorMode(mode);
                        if (context.mounted) {
                          onModeSelected?.call(mode);
                          Navigator.of(context).pop();
                        }
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEFF5F0)
                              : OperatorModeSheet.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? OperatorModeSheet.forest
                                : OperatorModeSheet.border,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? OperatorModeSheet.forest
                                    : const Color(0xFFF1EFEA),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _iconForMode(mode),
                                size: 18,
                                color: isSelected
                                    ? Colors.white
                                    : OperatorModeSheet.ink,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mode.displayName,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color: OperatorModeSheet.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    mode.description,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: OperatorModeSheet.textMuted,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: OperatorModeSheet.forest,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
