import 'package:creativanta_mobile/auth/auth_models.dart';
import 'package:creativanta_mobile/auth/auth_provider_adapter.dart';
import 'package:creativanta_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('P0 mobile entry is explicit about fail-closed external provider gate when unconfigured', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CreativantaApp());
    expect(find.text('creativanta.'), findsOneWidget);
    expect(find.text('PROOFED TREND-TO-PROFIT OS'), findsOneWidget);
    expect(find.text('CỔNG XÁC THỰC NGOẠI VI (EXTERNAL GATE)'), findsOneWidget);
    expect(find.text('Đăng nhập (Cần cấu hình IdP)'), findsOneWidget);
    expect(
      find.textContaining('EXT-GATE-CLERK-MOBILE'),
      findsOneWidget,
      reason: 'External Clerk IdP gate must be explicit in unconfigured state',
    );
  });

  testWidgets('P0 mobile home is explicit about unavailable integrations when authenticated', (
    WidgetTester tester,
  ) async {
    const defaultWs = WorkspaceSummary(
      id: '018f7a31-2233-7444-8555-667788990011',
      name: 'Creativanta HQ',
      role: 'owner',
      plan: 'Pro Plan',
      isActive: true,
    );
    final session = AuthSession(
      user: const UserIdentity(
        id: 'usr_test',
        email: 'creator@creativanta.com',
        displayName: 'Creator One',
      ),
      sessionToken: 'test-token',
      sessionId: 'sess_test',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      activeWorkspace: defaultWs,
      availableWorkspaces: const [defaultWs],
      activeMode: OperatorMode.creator,
      isTestDouble: true,
    );

    final adapter = TestAuthProviderAdapter(
      initialStatus: AuthStatus.authenticated,
      initialSession: session,
    );

    await tester.pumpWidget(CreativantaApp(authAdapter: adapter));
    await tester.pumpAndSettle();

    expect(find.text('creativanta.'), findsOneWidget);
    expect(find.text('Một ngày đáng tạo.'), findsOneWidget);
    expect(find.text('Chưa khả dụng'), findsOneWidget);
    final unavailable = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Chưa khả dụng'),
    );
    expect(
      unavailable.onPressed,
      isNull,
      reason: 'Unimplemented provider actions must stay disabled',
    );
  });

  testWidgets('five navigation destinations change workspace content', (
    WidgetTester tester,
  ) async {
    const defaultWs = WorkspaceSummary(
      id: '018f7a31-2233-7444-8555-667788990011',
      name: 'Creativanta HQ',
      role: 'owner',
      plan: 'Pro Plan',
      isActive: true,
    );
    final session = AuthSession(
      user: const UserIdentity(
        id: 'usr_test',
        email: 'creator@creativanta.com',
        displayName: 'Creator One',
      ),
      sessionToken: 'test-token',
      sessionId: 'sess_test',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      activeWorkspace: defaultWs,
      availableWorkspaces: const [defaultWs],
      activeMode: OperatorMode.creator,
      isTestDouble: true,
    );

    final adapter = TestAuthProviderAdapter(
      initialStatus: AuthStatus.authenticated,
      initialSession: session,
    );

    await tester.pumpWidget(CreativantaApp(authAdapter: adapter));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationDestination), findsNWidgets(5));
    await tester.tap(find.text('Khám phá').last);
    await tester.pumpAndSettle();
    expect(
      find.textContaining('sau khi kết nối nguồn dữ liệu'),
      findsOneWidget,
    );
    await tester.tap(find.text('Hộp thư').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('xác thực và kết nối kênh'), findsOneWidget);
    await tester.tap(find.text('Hôm nay').last);
    await tester.pumpAndSettle();
    expect(find.text('Một ngày đáng tạo.'), findsOneWidget);
  });

  testWidgets('app shell displays active workspace and operator mode', (
    WidgetTester tester,
  ) async {
    const defaultWs = WorkspaceSummary(
      id: '018f7a31-2233-7444-8555-667788990011',
      name: 'Creativanta HQ',
      role: 'owner',
      isActive: true,
    );
    final session = AuthSession(
      user: const UserIdentity(
        id: 'usr_test',
        email: 'creator@creativanta.com',
        displayName: 'Creator One',
      ),
      sessionToken: 'test-token',
      sessionId: 'sess_test',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      activeWorkspace: defaultWs,
      availableWorkspaces: const [defaultWs],
      activeMode: OperatorMode.creator,
      isTestDouble: true,
    );

    final adapter = TestAuthProviderAdapter(
      initialStatus: AuthStatus.authenticated,
      initialSession: session,
    );

    await tester.pumpWidget(CreativantaApp(authAdapter: adapter));
    await tester.pumpAndSettle();

    // Verify active workspace name in AppBar
    expect(find.text('Creativanta HQ'), findsOneWidget);

    // Verify operator mode indicator
    expect(find.text('MODE: CREATOR'), findsOneWidget);
    expect(find.text('Sáng tạo'), findsOneWidget);
  });
}
