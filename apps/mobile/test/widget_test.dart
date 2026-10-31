import 'package:creativanta_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('P0 mobile home is explicit about unavailable integrations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CreativantaApp());
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
    await tester.pumpWidget(const CreativantaApp());
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
}
