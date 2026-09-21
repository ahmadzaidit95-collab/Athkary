import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbeehItem {
  const TasbeehItem({required this.label, required this.text});

  /// اسم قصير للزرار.
  final String label;

  /// النص الكامل بالتشكيل.
  final String text;
}

const List<TasbeehItem> tasbeehItems = [
  TasbeehItem(label: 'سبحان الله', text: 'سُبْحَانَ اللَّهِ'),
  TasbeehItem(label: 'الحمد لله', text: 'الْحَمْدُ لِلَّهِ'),
  TasbeehItem(label: 'الله أكبر', text: 'اللَّهُ أَكْبَرُ'),
  TasbeehItem(label: 'لا إله إلا الله', text: 'لَا إِلَهَ إِلَّا اللَّهُ'),
  TasbeehItem(label: 'أستغفر الله', text: 'أَسْتَغْفِرُ اللَّهَ'),
  TasbeehItem(
    label: 'لا حول ولا قوة',
    text: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
  ),
];

/// الأهداف المتاحة. 0 = بدون حد.
const List<int> tasbeehTargets = [33, 99, 100, 0];

class TasbeehController extends ChangeNotifier {
  TasbeehController() {
    _load();
  }

  List<int> _counts = List<int>.filled(tasbeehItems.length, 0);
  List<int> _rounds = List<int>.filled(tasbeehItems.length, 0);
  int _index = 0;
  int _target = 33;
  SharedPreferences? _prefs;
  bool _disposed = false;

  int get index => _index;
  int get target => _target;
  TasbeehItem get item => tasbeehItems[_index];
  int get count => _counts[_index];
  int get rounds => _rounds[_index];

  /// نسبة التقدم في الدورة الحالية (0 لو مفيش هدف).
  double get progress => _target == 0 ? 0 : count / _target;

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final c = _prefs!.getStringList('tasbeeh-counts');
    final r = _prefs!.getStringList('tasbeeh-rounds');
    if (c != null && c.length == _counts.length) {
      _counts = c.map((e) => int.tryParse(e) ?? 0).toList();
    }
    if (r != null && r.length == _rounds.length) {
      _rounds = r.map((e) => int.tryParse(e) ?? 0).toList();
    }
    _index =
        (_prefs!.getInt('tasbeeh-index') ?? 0).clamp(0, tasbeehItems.length - 1).toInt();
    _target = _prefs!.getInt('tasbeeh-target') ?? 33;
    _notify();
  }

  void _save() {
    final p = _prefs;
    if (p == null) return;
    p.setStringList('tasbeeh-counts', _counts.map((e) => '$e').toList());
    p.setStringList('tasbeeh-rounds', _rounds.map((e) => '$e').toList());
    p.setInt('tasbeeh-index', _index);
    p.setInt('tasbeeh-target', _target);
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  void select(int i) {
    _index = i;
    _save();
    _notify();
  }

  void setTarget(int t) {
    _target = t;
    if (t > 0 && _counts[_index] >= t) {
      _counts[_index] = _counts[_index] % t;
    }
    _save();
    _notify();
  }

  void tap() {
    _counts[_index]++;
    if (_target > 0 && _counts[_index] >= _target) {
      _counts[_index] = 0;
      _rounds[_index]++;
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.selectionClick();
    }
    _save();
    _notify();
  }

  void reset() {
    _counts[_index] = 0;
    _rounds[_index] = 0;
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
