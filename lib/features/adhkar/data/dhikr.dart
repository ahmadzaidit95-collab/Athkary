/// ذكر واحد.
class Dhikr {
  const Dhikr({
    required this.text,
    required this.count,
    required this.source,
  });

  /// نص الذكر.
  final String text;

  /// عدد مرات التكرار.
  final int count;

  /// المصدر (مثلاً: صحيح مسلم).
  final String source;
}
