import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/auth/auth_models.dart';
import 'package:creativanta_mobile/auth/auth_provider_adapter.dart';
import 'package:creativanta_mobile/main.dart';

void main() {
  const testWorkspace = WorkspaceSummary(
    id: 'ws-test-01',
    name: 'Creativanta Studio',
    role: 'owner',
    plan: 'Pro Plan',
    isActive: true,
  );

  AuthSession createTestSession({OperatorMode mode = OperatorMode.creator}) {
    return AuthSession(
      user: const UserIdentity(
        id: 'usr_p0_08',
        email: 'operator@creativanta.com',
        displayName: 'Operator Test',
      ),
      sessionToken: 'token_p0_08',
      sessionId: 'sess_p0_08',
      expiresAt: DateTime.now().add(const Duration(hours: 4)),
      activeWorkspace: testWorkspace,
      availableWorkspaces: const [testWorkspace],
      activeMode: mode,
      isTestDouble: true,
    );
  }

  group('P0-08 Mobile Shells, Notifications & Help Center Entry', () {
    testWidgets('1. All six operator modes identities are retained and switchable', (
      WidgetTester tester,
    ) async {
      final session = createTestSession(mode: OperatorMode.seller);
      final adapter = TestAuthProviderAdapter(
        initialStatus: AuthStatus.authenticated,
        initialSession: session,
      );

      await tester.pumpWidget(CreativantaApp(authAdapter: adapter));
      await tester.pumpAndSettle();

      // Top mode chip reflects active mode
      expect(find.byType(ActionChip), findsOneWidget);
      expect(find.text('MODE: SELLER'), findsOneWidget);

      // Open operator mode sheet by tapping ActionChip
      await tester.tap(find.byType(ActionChip));
      await tester.pumpAndSettle();

      // Verify all 6 modes exist in bottom sheet
      expect(find.text('Chế độ vận hành (6 Modes)'), findsOneWidget);
      expect(find.text('Sáng tạo nội dung'), findsOneWidget);
      expect(find.text('Bán hàng & Tồn kho'), findsOneWidget);
      expect(find.text('Tiếp thị liên kết (KOC/KOL)'), findsOneWidget);
      expect(find.text('Phòng chiến Live Commerce'), findsOneWidget);
      expect(find.text('Đội ngũ Agency / MCN'), findsOneWidget);
      expect(find.text('Hợp tác nhãn hàng & Tài trợ'), findsOneWidget);

      // Select Creator Mode
      await tester.tap(find.text('Sáng tạo nội dung'));
      await tester.pumpAndSettle();

      expect(adapter.currentSession?.activeMode, OperatorMode.creator);
    });

    testWidgets('2. Notifications sheet opens, marks read, and dismisses items', (
      WidgetTester tester,
    ) async {
      final session = createTestSession();
      final adapter = TestAuthProviderAdapter(
        initialStatus: AuthStatus.authenticated,
        initialSession: session,
      );

      await tester.pumpWidget(CreativantaApp(authAdapter: adapter));
      await tester.pumpAndSettle();

      // Tap Notifications Bell icon
      final bellFinder = find.byIcon(Icons.notifications_outlined);
      expect(bellFinder, findsOneWidget);
      await tester.tap(bellFinder);
      await tester.pumpAndSettle();

      // Verify sheet opened with notifications
      expect(find.text('Thông báo vận hành'), findsOneWidget);
      expect(find.text('Cảnh báo vi phạm SLA xử lý đơn hàng (M19)'), findsOneWidget);
      expect(find.text('Cần cấp lại quyền tài khoản TikTok Shop (M11)'), findsOneWidget);

      // Tap "Đã đọc"
      final markReadBtn = find.text('Đã đọc').first;
      await tester.tap(markReadBtn);
      await tester.pumpAndSettle();

      // Tap "Bỏ qua" to dismiss
      final dismissBtn = find.text('Bỏ qua').first;
      await tester.tap(dismissBtn);
      await tester.pumpAndSettle();

      // Tap "Đọc tất cả"
      final readAllBtn = find.text('Đọc tất cả');
      if (readAllBtn.evaluate().isNotEmpty) {
        await tester.tap(readAllBtn);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('3. Help center sheet opens, searches, and allows article rating', (
      WidgetTester tester,
    ) async {
      final session = createTestSession();
      final adapter = TestAuthProviderAdapter(
        initialStatus: AuthStatus.authenticated,
        initialSession: session,
      );

      await tester.pumpWidget(CreativantaApp(authAdapter: adapter));
      await tester.pumpAndSettle();

      // Tap Help icon in AppBar
      final helpFinder = find.byIcon(Icons.help_outline_rounded);
      expect(helpFinder, findsOneWidget);
      await tester.tap(helpFinder);
      await tester.pumpAndSettle();

      // Verify Help Center sheet
      expect(find.text('Trung tâm trợ giúp'), findsOneWidget);
      expect(find.text('Hướng dẫn 6 Chế độ Vận hành trên Creativanta'), findsOneWidget);

      // Search
      await tester.enterText(find.byType(TextField), 'TikTok');
      await tester.pumpAndSettle();

      expect(find.text('Khắc phục lỗi ngắt kết nối tài khoản TikTok Shop'), findsOneWidget);

      // Tap article to open detail
      await tester.tap(find.text('Khắc phục lỗi ngắt kết nối tài khoản TikTok Shop'));
      await tester.pumpAndSettle();

      expect(find.text('Tài liệu này có hữu ích không?'), findsOneWidget);

      // Vote helpful
      await tester.tap(find.byIcon(Icons.thumb_up_alt_outlined));
      await tester.pumpAndSettle();

      expect(find.text('✓ Cảm ơn bạn đã gửi phản hồi!'), findsOneWidget);
    });

    testWidgets('4. Why This Number sheet enforces strict Demo data isolation', (
      WidgetTester tester,
    ) async {
      final session = createTestSession();
      final adapter = TestAuthProviderAdapter(
        initialStatus: AuthStatus.authenticated,
        initialSession: session,
      );

      await tester.pumpWidget(CreativantaApp(authAdapter: adapter));
      await tester.pumpAndSettle();

      // Revenue breakdown is visible on Home
      expect(find.text('DOANH THU & SỐ LIỆU MINH BẠCH'), findsOneWidget);
      expect(find.text('0 ₫'), findsOneWidget);
      expect(find.text('48.500.000 ₫'), findsOneWidget);

      // Open "Tại sao có số này?"
      final whyBtn = find.text('Tại sao có số này?');
      expect(whyBtn, findsOneWidget);
      await tester.tap(whyBtn);
      await tester.pumpAndSettle();

      // Verify Demo isolation banner (Target 3)
      expect(find.text('CÁCH LY: KHÔNG CỘNG DỒN'), findsOneWidget);
      expect(find.text('Bảo vệ dữ liệu khách hàng (Acceptance Target 3)'), findsOneWidget);
      expect(find.text('Công thức tính toán (Formula)'), findsOneWidget);

      // Close sheet
      final closeBtn = find.text('Đã hiểu giải trình');
      await tester.ensureVisible(closeBtn);
      await tester.tap(closeBtn);
      await tester.pumpAndSettle();
    });

    testWidgets('5. 4 UI States are switchable on mobile home', (
      WidgetTester tester,
    ) async {
      final session = createTestSession();
      final adapter = TestAuthProviderAdapter(
        initialStatus: AuthStatus.authenticated,
        initialSession: session,
      );

      await tester.pumpWidget(CreativantaApp(authAdapter: adapter));
      await tester.pumpAndSettle();

      // Switch to Error State
      await tester.tap(find.text('4. Lỗi'));
      await tester.pumpAndSettle();
      expect(find.text('Lỗi đồng bộ dữ liệu quyết định (M01-E-503)'), findsOneWidget);

      // Switch to Repair State
      await tester.tap(find.text('5. Sửa lỗi'));
      await tester.pumpAndSettle();
      expect(find.text('Cần sửa: TikTok Shop bị ngắt kết nối'), findsOneWidget);

      // Switch to Loading State
      await tester.tap(find.text('2. Đang tải'));
      await tester.pumpAndSettle();
      expect(find.text('Đang tải nhịp quyết định theo vai trò...'), findsOneWidget);

      // Switch to Empty State
      await tester.tap(find.text('3. Trống'));
      await tester.pumpAndSettle();
      expect(find.text('Tất cả quyết định hôm nay đã hoàn thành'), findsOneWidget);

      // Switch back to Normal State
      await tester.tap(find.text('1. Chuẩn'));
      await tester.pumpAndSettle();
      expect(find.text('DOANH THU & SỐ LIỆU MINH BẠCH'), findsOneWidget);
    });
  });
}
