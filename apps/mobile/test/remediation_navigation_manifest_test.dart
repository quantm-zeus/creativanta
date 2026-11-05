import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/auth/auth_models.dart';
import 'package:creativanta_mobile/auth/auth_provider_adapter.dart';
import 'package:creativanta_mobile/automation/agent_models.dart';
import 'package:creativanta_mobile/main.dart';
import 'package:creativanta_mobile/ui/automation/agent_runtime_view.dart';
import 'package:creativanta_mobile/ui/commerce/commerce_dashboard_view.dart';
import 'package:creativanta_mobile/ui/production/studio_launcher_view.dart';

void main() {
  test('IQ-08 Android main/release manifest declares android.permission.INTERNET', () {
    final manifestFile = File('android/app/src/main/AndroidManifest.xml');
    expect(manifestFile.existsSync(), isTrue);
    final xml = manifestFile.readAsStringSync();
    expect(
      xml,
      contains('<uses-permission android:name="android.permission.INTERNET"/>'),
    );
  });

  testWidgets('UF-11 Bottom tabs and Home decision CTA navigate to implemented screens', (
    WidgetTester tester,
  ) async {
    const ws = WorkspaceSummary(
      id: 'ws-nav-test-01',
      name: 'Creativanta HQ',
      role: 'owner',
      plan: 'Pro Plan',
      isActive: true,
    );
    final adapter = TestAuthProviderAdapter(
      initialStatus: AuthStatus.authenticated,
      initialSession: AuthSession(
        user: const UserIdentity(
          id: 'usr_nav_01',
          email: 'creator@creativanta.com',
          displayName: 'Creator One',
        ),
        sessionToken: 'tok-nav-01',
        sessionId: 'sess-nav-01',
        expiresAt: DateTime.fromMillisecondsSinceEpoch(253402300799000),
        activeWorkspace: ws,
        availableWorkspaces: const [ws],
        activeMode: OperatorMode.creator,
        isTestDouble: true,
      ),
    );

    await tester.pumpWidget(CreativantaApp(authAdapter: adapter));
    await tester.pumpAndSettle();

    // Navigate to Tab 2 (Sáng tạo) and open StudioLauncherView
    await tester.tap(find.text('Sáng tạo'));
    await tester.pumpAndSettle();

    final studioBtn = find.byKey(const Key('nav_open_studio_launcher'));
    expect(studioBtn, findsOneWidget);
    await tester.ensureVisible(studioBtn);
    await tester.tap(studioBtn);
    await tester.pumpAndSettle();

    expect(find.byType(StudioLauncherView), findsOneWidget);

    // Pop back to WorkspaceShell
    Navigator.of(tester.element(find.byType(StudioLauncherView))).pop();
    await tester.pumpAndSettle();

    // Navigate to Tab 4 (Thêm) and open CommerceDashboardView
    await tester.tap(find.text('Thêm'));
    await tester.pumpAndSettle();

    final commerceBtn = find.byKey(const Key('nav_open_commerce_hub'));
    expect(commerceBtn, findsOneWidget);
    await tester.ensureVisible(commerceBtn);
    await tester.tap(commerceBtn);
    await tester.pumpAndSettle();

    expect(find.byType(CommerceDashboardView), findsOneWidget);
  });

  testWidgets('AI-02 AgentRuntimeView in live mode fails closed without deducting credits', (
    WidgetTester tester,
  ) async {
    final run = MobileAgentRun.createVideoAgentPlan(
      workspaceId: 'ws-agent-01',
      userId: 'usr-01',
      prompt: 'Tạo video review kem dưỡng ẩm',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: AgentRuntimeView(
          initialRun: run,
          initialBalance: 150.0,
          isLiveExecutionMode: true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('150.0 cr'), findsOneWidget);

    final runStepBtn = find.text('Chạy tất cả');
    await tester.ensureVisible(runStepBtn);
    await tester.tap(runStepBtn);
    await tester.pumpAndSettle();

    // Balance remains untouched (150.0 cr) and fail-closed status message is shown
    expect(find.text('150.0 cr'), findsOneWidget);
    expect(find.textContaining('fail-closed'), findsOneWidget);
  });
}
