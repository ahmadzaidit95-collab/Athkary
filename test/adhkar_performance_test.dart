import 'package:flutter_test/flutter_test.dart';
import '../lib/features/adhkar/data/adhkar_category.dart';
import '../lib/features/adhkar/data/adhkar_data.dart';

void main() {
  test('Azkar Performance Test', () {
    final stopwatch = Stopwatch()..start();

    final morningList = morningAdhkar;
    final morningCategory = AdhkarCategory.morning;

    stopwatch.stop();

    final micros = stopwatch.elapsedMicroseconds;
    final count = morningList.length;
    final title = morningCategory.title;

    print('\n==================================================');
    print('Time elapsed: ' + micros.toString() + ' microsecond');
    print('Morning Azkar count: ' + count.toString());
    print('Category title: ' + title);
    print('==================================================\n');

    expect(morningList.isNotEmpty, true);
    expect(stopwatch.elapsedMilliseconds, lessThan(10));
  });
}