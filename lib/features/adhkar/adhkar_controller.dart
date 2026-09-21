import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/adhkar_category.dart';

/// حالة العدّ لقسم واحد. التقدم بيتحفظ لليوم الحالي بس،
/// وتاني يوم بيبدأ من الصفر تلقائياً.
class AdhkarController extends ChangeNotifier {
  AdhkarController(this.category)
      : _counts = List<int>.filled(category.items.length, 0) {
    _load();
  }

  final AdhkarCategory category;
  List<int> _counts;
  SharedPreferences? _prefs;
  bool _disposed = false;

  String get _key {
    final d = DateTime.now();
    return 'adhkar-${category.id}-${d.year}-${d.month}-${d.day}';
  }

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final saved = _prefs!.getStringList(_key);
    if (saved != null && saved.length == _counts.length) {
      _counts = saved.map((e) => int.tryParse(e) ?? 0).toList();
    }
    _notify();
  }

  void _save() {
    _prefs?.setStringList(_key, _counts.map((e) => '$e').toList());
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  int get total => category.items.length;
  int countAt(int i) => _counts[i];
  bool isDone(int i) => _counts[i] >= category.items[i].count;

  int get doneCount {
    var n = 0;
    for (var i = 0; i < total; i++) {
      if (isDone(i)) n++;
    }
    return n;
  }

  bool get allDone => total > 0 && doneCount == total;

  /// أول ذكر لسه ما خلصش (أو -1 لو الكل خلص).
  int get firstOpenIndex {
    for (var i = 0; i < total; i++) {
      if (!isDone(i)) return i;
    }
    return -1;
  }

  void increment(int i) {
    if (isDone(i)) return;
    _counts[i]++;
    if (isDone(i)) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.selectionClick();
    }
    _save();
    _notify();
  }

  void resetOne(int i) {
    _counts[i] = 0;
    HapticFeedback.lightImpact();
    _save();
    _notify();
  }

  void resetAll() {
    _counts = List<int>.filled(total, 0);
    HapticFeedback.lightImpact();
    _save();
    _notify();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
