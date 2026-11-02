import 'dart:async';
import 'package:flutter/material.dart';
import 'package:creativanta_mobile/auth/auth_models.dart';
import 'package:creativanta_mobile/auth/auth_provider_adapter.dart';
import 'package:creativanta_mobile/ui/auth/operator_mode_sheet.dart';
import 'package:creativanta_mobile/ui/auth/session_expired_dialog.dart';
import 'package:creativanta_mobile/ui/auth/sign_in_screen.dart';
import 'package:creativanta_mobile/ui/auth/workspace_switcher_sheet.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CreativantaApp());
}

/// Creativanta mobile root application.
///
/// Implements P0-03 identity boundary:
/// - Unauthenticated / unconfigured users see [MobileAuthScreen].
/// - External Clerk IdP gate is fail-closed by default.
/// - Authenticated users access [WorkspaceShell] with active workspace and operator mode.
class CreativantaApp extends StatefulWidget {
  const CreativantaApp({
    super.key,
    this.authAdapter,
    this.initialSession,
  });

  final AuthProviderAdapter? authAdapter;
  final AuthSession? initialSession;

  static const Color paper = Color(0xFFFBF9F5);
  static const Color ink = Color(0xFF242924);
  static const Color forest = Color(0xFF274333);
  static const Color vermilion = Color(0xFFD94A31);

  @override
  State<CreativantaApp> createState() => _CreativantaAppState();
}

class _CreativantaAppState extends State<CreativantaApp> {
  late final AuthProviderAdapter _adapter;
  late final bool _ownedAdapter;
  StreamSubscription<AuthStatus>? _statusSubscription;
  AuthStatus _status = AuthStatus.unconfigured;

  @override
  void initState() {
    super.initState();
    if (widget.authAdapter != null) {
      _adapter = widget.authAdapter!;
      _ownedAdapter = false;
    } else if (widget.initialSession != null) {
      _adapter = TestAuthProviderAdapter(
        initialStatus: AuthStatus.authenticated,
        initialSession: widget.initialSession,
      );
      _ownedAdapter = true;
    } else {
      _adapter = ClerkAuthProviderAdapter();
      _ownedAdapter = true;
    }

    _status = _adapter.currentStatus;
    _statusSubscription = _adapter.statusStream.listen((status) {
      if (mounted) {
        setState(() {
          _status = status;
        });
      }
    });

    _adapter.initialize();
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    if (_ownedAdapter) {
      _adapter.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creativanta Go',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: CreativantaApp.forest,
          surface: CreativantaApp.paper,
          primary: CreativantaApp.forest,
          secondary: CreativantaApp.vermilion,
        ),
        scaffoldBackgroundColor: CreativantaApp.paper,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 29,
            height: 1.16,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.1,
            color: CreativantaApp.ink,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: CreativantaApp.paper,
          foregroundColor: CreativantaApp.ink,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: _buildHomeForStatus(),
    );
  }

  Widget _buildHomeForStatus() {
    if (_status == AuthStatus.authenticated) {
      return WorkspaceShell(authAdapter: _adapter);
    }

    if (_status == AuthStatus.tokenExpired) {
      return Stack(
        children: [
          WorkspaceShell(authAdapter: _adapter),
          ModalBarrier(
            color: Colors.black.withValues(alpha: 0.4),
            dismissible: false,
          ),
          SessionExpiredDialog(
            authAdapter: _adapter,
            onRefreshSuccess: () {
              if (mounted) {
                setState(() {
                  _status = _adapter.currentStatus;
                });
              }
            },
            onSignOut: () {
              if (mounted) {
                setState(() {
                  _status = _adapter.currentStatus;
                });
              }
            },
          ),
        ],
      );
    }

    return MobileAuthScreen(
      authAdapter: _adapter,
      onAuthenticationSuccess: () {
        if (mounted) {
          setState(() {
            _status = _adapter.currentStatus;
          });
        }
      },
    );
  }
}

/// WorkspaceShell hosts the primary navigation and active workspace context.
///
/// Preserves:
/// - All 5 bottom navigation destinations.
/// - All 6 operator mode identities.
/// - Fail-closed unbuilt feature containers.
/// - M004 Workspace Switch integration.
class WorkspaceShell extends StatefulWidget {
  const WorkspaceShell({
    super.key,
    this.authAdapter,
  });

  final AuthProviderAdapter? authAdapter;

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}

class _WorkspaceShellState extends State<WorkspaceShell> {
  int selectedIndex = 0;
  late final AuthProviderAdapter _adapter;
  late final bool _ownedAdapter;
  StreamSubscription<AuthStatus>? _statusSubscription;

  static const destinations = [
    ('Hôm nay', Icons.home_outlined, Icons.home),
    ('Khám phá', Icons.explore_outlined, Icons.explore),
    ('Sáng tạo', Icons.auto_awesome_outlined, Icons.auto_awesome),
    ('Hộp thư', Icons.chat_bubble_outline, Icons.chat_bubble),
    ('Thêm', Icons.menu_rounded, Icons.menu_open),
  ];

  static const descriptions = [
    'Không gian dành cho những việc quan trọng hôm nay.',
    'Tín hiệu xu hướng sẽ hiển thị sau khi kết nối nguồn dữ liệu.',
    'Studio sáng tạo đang chờ hoàn thiện API và quyền truy cập.',
    'Tin nhắn sẽ khả dụng khi xác thực và kết nối kênh hoàn tất.',
    'Quản lý workspace, kết nối và quyền truy cập.',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.authAdapter != null) {
      _adapter = widget.authAdapter!;
      _ownedAdapter = false;
    } else {
      const defaultWs = WorkspaceSummary(
        id: '018f7a31-2233-7444-8555-667788990011',
        name: 'Creativanta HQ',
        role: 'owner',
        plan: 'Pro Plan',
        isActive: true,
      );
      _adapter = TestAuthProviderAdapter(
        initialStatus: AuthStatus.authenticated,
        initialSession: AuthSession(
          user: const UserIdentity(
            id: 'user_default',
            email: 'creator@creativanta.com',
            displayName: 'Creator One',
          ),
          sessionToken: 'default-session-token',
          sessionId: 'sess_default',
          expiresAt: DateTime.fromMillisecondsSinceEpoch(253402300799000),
          activeWorkspace: defaultWs,
          availableWorkspaces: const [defaultWs],
          activeMode: OperatorMode.creator,
          isTestDouble: true,
        ),
      );
      _ownedAdapter = true;
    }

    _statusSubscription = _adapter.statusStream.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    if (_ownedAdapter) {
      _adapter.dispose();
    }
    super.dispose();
  }

  void _openWorkspaceSwitcher() {
    WorkspaceSwitchSheet.show(
      context: context,
      authAdapter: _adapter,
      onWorkspaceSwitched: (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  void _openOperatorModeSheet() {
    OperatorModeSheet.show(
      context: context,
      authAdapter: _adapter,
      onModeSelected: (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = destinations[selectedIndex];
    final session = _adapter.currentSession;
    final activeWorkspace = session?.activeWorkspace.name ?? 'Creativanta HQ';
    final activeRole = session?.activeWorkspace.role ?? 'owner';
    final activeMode = session?.activeMode ?? OperatorMode.creator;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.layers_rounded,
              color: CreativantaApp.vermilion,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'creativanta.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(width: 8),
            // Workspace selector trigger (M004)
            InkWell(
              onTap: _openWorkspaceSwitcher,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EFEA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      activeWorkspace,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: CreativantaApp.ink,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Operator mode chip trigger
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              avatar: const Icon(
                Icons.tune_rounded,
                size: 14,
                color: CreativantaApp.forest,
              ),
              label: Text(
                activeMode.displayName.split(' ').first,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: CreativantaApp.forest,
                ),
              ),
              visualDensity: VisualDensity.compact,
              backgroundColor: const Color(0xFFEFF5F0),
              side: const BorderSide(color: Color(0xFFC7DCC8)),
              onPressed: _openOperatorModeSheet,
            ),
          ),
          // User session menu
          PopupMenuButton<String>(
            icon: CircleAvatar(
              radius: 14,
              backgroundColor: CreativantaApp.forest,
              child: Text(
                session?.user.displayName.isNotEmpty == true
                    ? session!.user.displayName.substring(0, 1).toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onSelected: (value) async {
              if (value == 'logout') {
                await _adapter.signOut();
              } else if (value == 'switch_ws') {
                _openWorkspaceSwitcher();
              } else if (value == 'switch_mode') {
                _openOperatorModeSheet();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session?.user.displayName ?? 'Người dùng',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CreativantaApp.ink,
                      ),
                    ),
                    Text(
                      session?.user.email ?? '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7D837B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Vai trò: $activeRole',
                      style: const TextStyle(
                        fontSize: 10,
                        color: CreativantaApp.forest,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'switch_ws',
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Đổi workspace'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'switch_mode',
                child: Row(
                  children: [
                    Icon(Icons.tune_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Đổi chế độ vận hành'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: CreativantaApp.vermilion,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Đăng xuất',
                      style: TextStyle(color: CreativantaApp.vermilion),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CREATIVANTA GO / PHASE 0',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 10,
                      letterSpacing: 1.7,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'MODE: ${activeMode.id.toUpperCase()}',
                    style: const TextStyle(
                      color: Color(0xFF7D837B),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                selectedIndex == 0 ? 'Một ngày đáng tạo.' : current.$1,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                descriptions[selectedIndex],
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.7,
                  color: Color(0xFF7D837B),
                ),
              ),
              const SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  color: CreativantaApp.forest,
                  borderRadius: BorderRadius.circular(23),
                ),
                padding: const EdgeInsets.all(23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FOUNDATION / ĐANG XÂY DỰNG',
                      style: TextStyle(
                        color: Color(0xFFC7DCC8),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 19),
                    Text(
                      selectedIndex == 0
                          ? 'Nền tảng vững.\nTrải nghiệm tốt.'
                          : 'Sắp có trong\nCreativanta Go.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.7,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Đây là shell P0. Chưa có dữ liệu sản phẩm hoặc thao tác nghiệp vụ thật.',
                      style: TextStyle(
                        color: Color(0xFFD4E0D5),
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const FilledButton(
                      onPressed: null,
                      child: Text('Chưa khả dụng'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Semantics(
                label: 'Trạng thái tích hợp: chưa kết nối backend',
                child: Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE8E5DC)),
                    color: const Color(0xFFFFFEFA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: CreativantaApp.forest),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tính năng chưa được kích hoạt',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Chỉ mở khi xác thực, phân quyền và kiểm thử API đạt yêu cầu.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF7D837B),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: const Color(0xFFFFFEFA),
        indicatorColor: const Color(0xFFFFF0E7),
        onDestinationSelected: (value) => setState(() => selectedIndex = value),
        destinations: [
          for (final destination in destinations)
            NavigationDestination(
              icon: Icon(destination.$2),
              selectedIcon: Icon(
                destination.$3,
                color: CreativantaApp.vermilion,
              ),
              label: destination.$1,
            ),
        ],
      ),
    );
  }
}
