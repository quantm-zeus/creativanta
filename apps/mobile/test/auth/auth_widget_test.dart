import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/auth/auth_models.dart';
import 'package:creativanta_mobile/auth/auth_provider_adapter.dart';
import 'package:creativanta_mobile/ui/auth/operator_mode_sheet.dart';
import 'package:creativanta_mobile/ui/auth/session_expired_dialog.dart';
import 'package:creativanta_mobile/ui/auth/sign_in_screen.dart';
import 'package:creativanta_mobile/ui/auth/workspace_switcher_sheet.dart';

void main() {
  group('MobileAuthScreen Widget Tests', () {
    testWidgets('unconfigured state displays external provider gate banner and fail-closed notice', (
      WidgetTester tester,
    ) async {
      final unconfiguredAdapter = ClerkAuthProviderAdapter();

      await tester.pumpWidget(
        MaterialApp(
          home: MobileAuthScreen(authAdapter: unconfiguredAdapter),
        ),
      );

      expect(find.text('creativanta.'), findsOneWidget);
      expect(find.text('PROOFED TREND-TO-PROFIT OS'), findsOneWidget);
      expect(find.text('CỔNG XÁC THỰC NGOẠI VI (EXTERNAL GATE)'), findsOneWidget);
      expect(
        find.textContaining('Clerk Identity Provider chưa được kích hoạt'),
        findsOneWidget,
      );
      expect(
        find.textContaining('EXT-GATE-CLERK-MOBILE'),
        findsOneWidget,
      );

      // Attempting to submit form validates email
      final submitButton = find.widgetWithText(FilledButton, 'Đăng nhập (Cần cấu hình IdP)');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();
      expect(find.text('Vui lòng nhập email.'), findsOneWidget);

      // Entering email and submitting in unconfigured state fails closed
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('EXT-GATE-CLERK-MOBILE'),
        findsWidgets,
      );
    });

    testWidgets('configured test adapter executes login and notifies success', (
      WidgetTester tester,
    ) async {
      final testAdapter = TestAuthProviderAdapter();
      bool successCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: MobileAuthScreen(
            authAdapter: testAdapter,
            onAuthenticationSuccess: () {
              successCalled = true;
            },
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, 'creator@creativanta.com');
      await tester.enterText(find.byType(TextFormField).last, 'valid-password');
      final loginButton = find.widgetWithText(FilledButton, 'Đăng nhập vào Creativanta');
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(successCalled, isTrue);
      expect(testAdapter.currentStatus, equals(AuthStatus.authenticated));
    });
  });

  group('WorkspaceSwitchSheet (M004) Widget Tests', () {
    testWidgets('displays active workspace, other workspaces and switches context', (
      WidgetTester tester,
    ) async {
      final defaultWs = const WorkspaceSummary(
        id: '018f7a31-2233-7444-8555-667788990011',
        name: 'Creativanta HQ',
        role: 'owner',
        plan: 'Pro Plan',
        isActive: true,
      );
      final secondaryWs = const WorkspaceSummary(
        id: '018f7a31-2233-7444-8555-667788990022',
        name: 'SkinCare Brand',
        role: 'admin',
        plan: 'Free Plan',
        unreadCount: 3,
        isActive: false,
      );

      final session = AuthSession(
        user: const UserIdentity(
          id: 'user_1',
          email: 'user@example.com',
          displayName: 'Test User',
        ),
        sessionToken: 'test-token',
        sessionId: 'sess_1',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        activeWorkspace: defaultWs,
        availableWorkspaces: [defaultWs, secondaryWs],
        activeMode: OperatorMode.creator,
        isTestDouble: true,
      );

      final adapter = TestAuthProviderAdapter(
        initialStatus: AuthStatus.authenticated,
        initialSession: session,
      );

      WorkspaceSummary? switchedWs;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WorkspaceSwitchSheet(
              authAdapter: adapter,
              onWorkspaceSwitched: (ws) {
                switchedWs = ws;
              },
            ),
          ),
        ),
      );

      expect(find.text('Chọn workspace'), findsOneWidget);
      expect(find.text('Creativanta HQ'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('SkinCare Brand'), findsOneWidget);
      expect(find.text('3 unread'), findsOneWidget);
      expect(find.text('Tạo workspace mới (Chưa khả dụng P0)'), findsOneWidget);

      // Tap on secondary workspace
      await tester.tap(find.text('SkinCare Brand'));
      await tester.pumpAndSettle();

      expect(switchedWs, isNotNull);
      expect(switchedWs!.id, equals(secondaryWs.id));
      expect(adapter.currentSession!.activeWorkspace.id, equals(secondaryWs.id));
    });
  });

  group('OperatorModeSheet (6 Modes) Widget Tests', () {
    testWidgets('displays all six operator modes and allows switching', (
      WidgetTester tester,
    ) async {
      final defaultWs = const WorkspaceSummary(
        id: '018f7a31-2233-7444-8555-667788990011',
        name: 'Creativanta HQ',
        role: 'owner',
        isActive: true,
      );
      final session = AuthSession(
        user: const UserIdentity(
          id: 'user_1',
          email: 'user@example.com',
          displayName: 'Test User',
        ),
        sessionToken: 'test-token',
        sessionId: 'sess_1',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        activeWorkspace: defaultWs,
        availableWorkspaces: [defaultWs],
        activeMode: OperatorMode.creator,
        isTestDouble: true,
      );

      final adapter = TestAuthProviderAdapter(
        initialStatus: AuthStatus.authenticated,
        initialSession: session,
      );

      OperatorMode? selectedMode;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OperatorModeSheet(
              authAdapter: adapter,
              onModeSelected: (mode) {
                selectedMode = mode;
              },
            ),
          ),
        ),
      );

      expect(find.text('Chế độ vận hành (6 Modes)'), findsOneWidget);
      expect(find.text('Sáng tạo nội dung'), findsOneWidget);
      expect(find.text('Bán hàng & Tồn kho'), findsOneWidget);
      expect(find.text('Tiếp thị liên kết (KOC/KOL)'), findsOneWidget);
      expect(find.text('Phòng chiến Live Commerce'), findsOneWidget);
      expect(find.text('Đội ngũ Agency / MCN'), findsOneWidget);
      expect(find.text('Hợp tác nhãn hàng & Tài trợ'), findsOneWidget);

      // Select Seller Mode
      await tester.tap(find.text('Bán hàng & Tồn kho'));
      await tester.pumpAndSettle();

      expect(selectedMode, equals(OperatorMode.seller));
      expect(adapter.currentSession!.activeMode, equals(OperatorMode.seller));
    });
  });

  group('SessionExpiredDialog Widget Tests', () {
    testWidgets('allows token refresh and sign out', (
      WidgetTester tester,
    ) async {
      final defaultWs = const WorkspaceSummary(
        id: '018f7a31-2233-7444-8555-667788990011',
        name: 'Creativanta HQ',
        role: 'owner',
        isActive: true,
      );
      final session = AuthSession(
        user: const UserIdentity(
          id: 'user_1',
          email: 'user@example.com',
          displayName: 'Test User',
        ),
        sessionToken: 'test-token',
        sessionId: 'sess_1',
        expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
        activeWorkspace: defaultWs,
        availableWorkspaces: [defaultWs],
        activeMode: OperatorMode.creator,
        isTestDouble: true,
      );

      final adapter = TestAuthProviderAdapter(
        initialStatus: AuthStatus.tokenExpired,
        initialSession: session,
      );

      bool refreshSuccess = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SessionExpiredDialog(
              authAdapter: adapter,
              onRefreshSuccess: () {
                refreshSuccess = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Phiên đăng nhập đã hết hạn'), findsOneWidget);
      expect(find.text('Làm mới phiên'), findsOneWidget);
      expect(find.text('Đăng xuất'), findsOneWidget);

      await tester.tap(find.text('Làm mới phiên'));
      await tester.pumpAndSettle();

      expect(refreshSuccess, isTrue);
      expect(adapter.currentStatus, equals(AuthStatus.authenticated));
    });
  });
}
