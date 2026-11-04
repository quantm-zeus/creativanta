import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/auth/auth_models.dart';
import 'package:creativanta_mobile/ui/home/home_dashboard_view.dart';
import 'package:creativanta_mobile/ui/home/why_number_sheet.dart';

Widget _buildTestApp({
  required OperatorMode activeMode,
  ValueChanged<OperatorMode>? onSwitchMode,
  ValueChanged<String>? onNavigateToRoute,
  Set<int> initialCompletedSteps = const {1},
  String initialUiState = 'normal',
}) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: HomeDashboardView(
            activeMode: activeMode,
            onSwitchMode: onSwitchMode,
            onNavigateToRoute: onNavigateToRoute,
            initialCompletedSteps: initialCompletedSteps,
            initialUiState: initialUiState,
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('P8-01 Acceptance Target 1: All Six Mode Priorities (Mobile)', () {
    testWidgets('renders all 7 Creator mode decision cards with canonical ranks', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(activeMode: OperatorMode.creator));
      await tester.pumpAndSettle();

      expect(find.text('SÁNG TẠO NỘI DUNG'), findsOneWidget);
      expect(find.text('QUYẾT ĐỊNH ƯU TIÊN (7 HẠNG MỤC)'), findsOneWidget);

      // Verify canonical cards for Creator
      expect(find.text('Cơ hội xu hướng FMCG & Đồ gia dụng thông minh'), findsOneWidget);
      expect(find.text('Ưu tiên #1'), findsOneWidget);
      expect(find.text('M02'), findsOneWidget);

      expect(find.text('5 ý tưởng video mới từ Trend Radar'), findsOneWidget);
      expect(find.text('Ưu tiên #2'), findsOneWidget);
      expect(find.text('M05'), findsOneWidget);

      expect(find.text('3 kịch bản AI Video Studio đề xuất'), findsOneWidget);
      expect(find.text('Ưu tiên #3'), findsOneWidget);
      expect(find.text('M06'), findsOneWidget);
    });

    testWidgets('renders all 5 Seller mode decision cards with stock and fulfillment focus', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(activeMode: OperatorMode.seller));
      await tester.pumpAndSettle();

      expect(find.text('BÁN HÀNG & TỒN KHO'), findsOneWidget);
      expect(find.text('QUYẾT ĐỊNH ƯU TIÊN (5 HẠNG MỤC)'), findsOneWidget);

      expect(find.text('Hàng đợi đơn hàng cần xử lý'), findsOneWidget);
      expect(find.text('Ưu tiên #1'), findsOneWidget);
      expect(find.text('Doanh thu bán hàng hôm nay'), findsOneWidget);
      expect(find.text('Cảnh báo tồn kho an toàn'), findsOneWidget);
    });

    testWidgets('renders all 5 Affiliate Operator mode decision cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(activeMode: OperatorMode.affiliateOperator));
      await tester.pumpAndSettle();

      expect(find.text('TIẾP THỊ LIÊN KẾT (KOC/KOL)'), findsOneWidget);
      expect(find.text('QUYẾT ĐỊNH ƯU TIÊN (5 HẠNG MỤC)'), findsOneWidget);
      expect(find.text('Giám sát tính khả dụng của liên kết tiếp thị'), findsOneWidget);
      expect(find.text('M16'), findsWidgets);
    });

    testWidgets('renders all 5 Live Operator mode decision cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(activeMode: OperatorMode.liveOperator));
      await tester.pumpAndSettle();

      expect(find.text('PHÒNG CHIẾN LIVE COMMERCE'), findsOneWidget);
      expect(find.text('QUYẾT ĐỊNH ƯU TIÊN (5 HẠNG MỤC)'), findsOneWidget);
      expect(find.text('Kiểm tra kịch bản & luồng kỹ thuật phòng Live'), findsOneWidget);
      expect(find.text('M17'), findsWidgets);
    });

    testWidgets('renders all 5 Agency/MCN mode decision cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(activeMode: OperatorMode.agencyMcn));
      await tester.pumpAndSettle();

      expect(find.text('ĐỘI NGŨ AGENCY / MCN'), findsOneWidget);
      expect(find.text('QUYẾT ĐỊNH ƯU TIÊN (5 HẠNG MỤC)'), findsOneWidget);
      expect(find.text('Quy trình phê duyệt nội dung Creator & Khách hàng'), findsOneWidget);
      expect(find.text('M20'), findsWidgets);
    });

    testWidgets('renders all 5 Brand Collaboration mode decision cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(activeMode: OperatorMode.brandCollaboration));
      await tester.pumpAndSettle();

      expect(find.text('HỢP TÁC NHÃN HÀNG & TÀI TRỢ'), findsOneWidget);
      expect(find.text('QUYẾT ĐỊNH ƯU TIÊN (5 HẠNG MỤC)'), findsOneWidget);
      expect(find.text('Yêu cầu hợp tác & booking tài trợ mới'), findsOneWidget);
      expect(find.text('M18'), findsWidgets);
    });

    testWidgets('triggers navigation callback when primary CTA is tapped', (
      WidgetTester tester,
    ) async {
      String? routedTo;
      await tester.pumpWidget(_buildTestApp(
        activeMode: OperatorMode.creator,
        onNavigateToRoute: (route) => routedTo = route,
      ));
      await tester.pumpAndSettle();

      final firstCta = find.widgetWithText(ElevatedButton, 'Khám phá tín hiệu xu hướng →');
      expect(firstCta, findsOneWidget);

      await tester.ensureVisible(firstCta);
      await tester.pumpAndSettle();

      await tester.tap(firstCta);
      await tester.pumpAndSettle();

      expect(routedTo, equals('/kham-pha'));
    });
  });

  group('P8-01 Acceptance Target 2: First-Value and Full-Loop Distinct (Mobile)', () {
    testWidgets('displays First-Value badge when only Step 1 is completed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(
        activeMode: OperatorMode.creator,
        initialCompletedSteps: const {1},
      ));
      await tester.pumpAndSettle();

      expect(find.text('1/5 hoàn thành'), findsOneWidget);
      expect(find.text('🌟 FIRST-VALUE ĐẠT ĐƯỢC'), findsOneWidget);
      expect(find.text('🎉 CHU TRÌNH KHÉP KÍN HOÀN TẤT'), findsNothing);
    });

    testWidgets('toggling Step 1 off clears First-Value badge', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(
        activeMode: OperatorMode.creator,
        initialCompletedSteps: const {1},
      ));
      await tester.pumpAndSettle();

      expect(find.text('🌟 FIRST-VALUE ĐẠT ĐƯỢC'), findsOneWidget);

      // Tap on Step 1 to uncheck it
      final step1Item = find.text('1. Kết nối kênh bán hoặc nhập tệp dữ liệu mẫu');
      expect(step1Item, findsOneWidget);
      await tester.tap(step1Item);
      await tester.pumpAndSettle();

      expect(find.text('0/5 hoàn thành'), findsOneWidget);
      expect(find.text('🌟 FIRST-VALUE ĐẠT ĐƯỢC'), findsNothing);
      expect(find.text('Hoàn thành bước 1 để đạt First-Value'), findsOneWidget);
    });

    testWidgets('completing all 5 steps displays Closed-Loop Completed badge', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(
        activeMode: OperatorMode.creator,
        initialCompletedSteps: const {1, 2, 3, 4, 5},
      ));
      await tester.pumpAndSettle();

      expect(find.text('5/5 hoàn thành'), findsOneWidget);
      expect(find.text('🎉 CHU TRÌNH KHÉP KÍN HOÀN TẤT'), findsOneWidget);
      expect(find.text('🌟 FIRST-VALUE ĐẠT ĐƯỢC'), findsNothing);
    });
  });

  group('P8-01 Acceptance Target 3: Every Shared UI State & Route Mapped (Mobile)', () {
    testWidgets('handles all 5 canonical UI states (Normal, Loading, Empty, Error, Repair)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(
        activeMode: OperatorMode.creator,
        initialUiState: 'normal',
      ));
      await tester.pumpAndSettle();

      // Normal State shows decision cards & revenue
      expect(find.text('DOANH THU & SỐ LIỆU MINH BẠCH'), findsOneWidget);
      expect(find.text('Thực tế (Verified)'), findsOneWidget);
      expect(find.text('DEMO (Cách ly)'), findsOneWidget);

      // Switch to Loading
      await tester.tap(find.text('2. Đang tải'));
      await tester.pumpAndSettle();
      expect(find.text('Đang tải nhịp quyết định theo vai trò...'), findsOneWidget);

      // Switch to Empty
      await tester.tap(find.text('3. Trống'));
      await tester.pumpAndSettle();
      expect(find.text('Tất cả quyết định hôm nay đã hoàn thành'), findsOneWidget);

      // Switch to Error
      await tester.tap(find.text('4. Lỗi'));
      await tester.pumpAndSettle();
      expect(find.text('Lỗi đồng bộ dữ liệu quyết định (M01-E-503)'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Thử lại kết nối'), findsOneWidget);

      // Switch to Repair
      await tester.tap(find.text('5. Sửa lỗi'));
      await tester.pumpAndSettle();
      expect(find.text('Cần sửa: Kênh kết nối bị gián đoạn (M22)'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Cấp lại'), findsOneWidget);
    });

    testWidgets('opens WhyNumberSheet when "Tại sao có số này?" is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(
        activeMode: OperatorMode.creator,
        initialUiState: 'normal',
      ));
      await tester.pumpAndSettle();

      final whyButton = find.widgetWithText(TextButton, 'Tại sao có số này?');
      expect(whyButton, findsOneWidget);

      await tester.ensureVisible(whyButton);
      await tester.pumpAndSettle();

      await tester.tap(whyButton);
      await tester.pumpAndSettle();

      // Verify WhyNumberSheet opened
      expect(find.byType(WhyNumberSheet), findsOneWidget);
      expect(find.text('Doanh thu mẫu minh họa (Demo GMV)'), findsOneWidget);
      expect(find.text('48.500.000 ₫'), findsWidgets);
    });
  });
}
