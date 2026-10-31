import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CreativantaApp());
}

/// Phase P0 shell only. No mocked authentication, payments or provider success.
class CreativantaApp extends StatelessWidget {
  const CreativantaApp({super.key});

  static const Color paper = Color(0xFFFBF9F5);
  static const Color ink = Color(0xFF242924);
  static const Color forest = Color(0xFF274333);
  static const Color vermilion = Color(0xFFD94A31);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creativanta Go',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: forest,
          surface: paper,
          primary: forest,
          secondary: vermilion,
        ),
        scaffoldBackgroundColor: paper,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 29,
            height: 1.16,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.1,
            color: ink,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: paper,
          foregroundColor: ink,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const WorkspaceShell(),
    );
  }
}

class WorkspaceShell extends StatefulWidget {
  const WorkspaceShell({super.key});

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}

class _WorkspaceShellState extends State<WorkspaceShell> {
  int selectedIndex = 0;

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
  Widget build(BuildContext context) {
    final current = destinations[selectedIndex];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.layers_rounded,
              color: CreativantaApp.vermilion,
              size: 25,
            ),
            SizedBox(width: 9),
            Text(
              'creativanta.',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.0,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Tooltip(
              message: 'Chưa kết nối dịch vụ thông báo',
              child: Icon(Icons.notifications_none_rounded),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
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
                      'Đây là shell P0. Chưa có đăng nhập, dữ liệu sản phẩm hoặc thao tác nghiệp vụ thật.',
                      style: TextStyle(
                        color: Color(0xFFD4E0D5),
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 22),
                    FilledButton(
                      onPressed: null,
                      child: const Text('Chưa khả dụng'),
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
