import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/core/theme/app_colors.dart';
import '../lib/features/adhkar/adhkar_screen.dart';
import '../lib/features/adhkar/data/adhkar_category.dart';

void main() {
  testWidgets('اختبار سرعة بناء ورندر شاشة الأذكار', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);

    final stopwatch = Stopwatch()..start();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          extensions: const [AppColors.light],
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          extensions: const [AppColors.dark],
        ),
        home: const AdhkarScreen(category: AdhkarCategory.morning),
      ),
    );

    stopwatch.stop();

    final ms = stopwatch.elapsedMilliseconds;
    print('\n==================================================');
    print('UI Render Time: ' + ms.toString() + ' ms');
    print('==================================================\n');

    expect(find.byType(AdhkarScreen), findsOneWidget);
    expect(ms, lessThan(1000));
  });
}