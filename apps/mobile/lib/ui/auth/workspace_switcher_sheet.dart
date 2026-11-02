import 'package:flutter/material.dart';
import 'package:creativanta_mobile/auth/auth_models.dart';
import 'package:creativanta_mobile/auth/auth_provider_adapter.dart';

/// Workspace switcher bottom sheet component implementing M004.
///
/// Follows docs/03_screens/mobile/screen_mobile_home_workspace_switch.md:
/// - Displays all active workspaces for current user session.
/// - Shows active workspace indicator, plan badge, unread count badge.
/// - Switches active workspace context without re-authentication (RULE-AUTH-003).
/// - Unbuilt "+ Tạo workspace mới" stays explicit and disabled in Phase 0.
class WorkspaceSwitchSheet extends StatefulWidget {
  const WorkspaceSwitchSheet({
    super.key,
    required this.authAdapter,
    this.onWorkspaceSwitched,
  });

  final AuthProviderAdapter authAdapter;
  final void Function(WorkspaceSummary workspace)? onWorkspaceSwitched;

  static const Color paper = Color(0xFFFBF9F5);
  static const Color surface = Color(0xFFFFFEFA);
  static const Color ink = Color(0xFF242924);
  static const Color forest = Color(0xFF274333);
  static const Color vermilion = Color(0xFFD94A31);
  static const Color textMuted = Color(0xFF7D837B);
  static const Color border = Color(0xFFE8E5DC);

  static Future<void> show({
    required BuildContext context,
    required AuthProviderAdapter authAdapter,
    void Function(WorkspaceSummary workspace)? onWorkspaceSwitched,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WorkspaceSwitchSheet(
        authAdapter: authAdapter,
        onWorkspaceSwitched: onWorkspaceSwitched,
      ),
    );
  }

  @override
  State<WorkspaceSwitchSheet> createState() => _WorkspaceSwitchSheetState();
}

class _WorkspaceSwitchSheetState extends State<WorkspaceSwitchSheet> {
  bool _isSwitching = false;
  String? _switchingId;

  Future<void> _handleSelectWorkspace(WorkspaceSummary workspace) async {
    if (workspace.isActive) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSwitching = true;
      _switchingId = workspace.id;
    });

    try {
      await widget.authAdapter.switchWorkspace(workspace.id);
      if (mounted) {
        widget.onWorkspaceSwitched?.call(workspace);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSwitching = false;
          _switchingId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Chuyển workspace thất bại: $e'),
            backgroundColor: WorkspaceSwitchSheet.vermilion,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.authAdapter.currentSession;
    final workspaces = session?.availableWorkspaces ?? const [];
    final activeId = session?.activeWorkspace.id;

    return Container(
      decoration: const BoxDecoration(
        color: WorkspaceSwitchSheet.paper,
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

              // Header: Title and Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chọn workspace',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: WorkspaceSwitchSheet.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    color: WorkspaceSwitchSheet.textMuted,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Workspace list
              if (workspaces.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'Không tìm thấy workspace nào khả dụng.',
                      style: TextStyle(color: WorkspaceSwitchSheet.textMuted),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: workspaces.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = workspaces[index];
                      final isActive = item.id == activeId || item.isActive;
                      final isCurrentTarget = _switchingId == item.id;

                      return InkWell(
                        onTap: _isSwitching
                            ? null
                            : () => _handleSelectWorkspace(item),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFEFF5F0)
                                : WorkspaceSwitchSheet.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isActive
                                  ? WorkspaceSwitchSheet.forest
                                  : WorkspaceSwitchSheet.border,
                              width: isActive ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Avatar circle with initial
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: isActive
                                    ? WorkspaceSwitchSheet.forest
                                    : const Color(0xFFE2E0D8),
                                child: Text(
                                  item.name.isNotEmpty
                                      ? item.name.substring(0, 1).toUpperCase()
                                      : 'W',
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.white
                                        : WorkspaceSwitchSheet.ink,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Name & Plan
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: WorkspaceSwitchSheet.ink,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isActive) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: WorkspaceSwitchSheet.forest,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              'Active',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${item.plan} · Vai trò: ${item.role}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: WorkspaceSwitchSheet.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Badges / Switching indicator
                              if (isCurrentTarget)
                                const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: WorkspaceSwitchSheet.forest,
                                  ),
                                )
                              else if (!isActive && item.unreadCount > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: WorkspaceSwitchSheet.vermilion,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${item.unreadCount} unread',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),

              // Unbuilt Action: + Tạo workspace mới (Phase 0 disabled fail-closed)
              OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Tạo workspace mới (Chưa khả dụng P0)'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  side: const BorderSide(color: WorkspaceSwitchSheet.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
