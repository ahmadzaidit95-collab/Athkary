import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// بيحفظ اختيار الثيم (فاتح/ليلي) ويبلّغ الواجهة لما يتغير.
class ThemeController extends ChangeNotifier {
  ThemeController._(this._prefs, this._mode);

  static const _key = 'adhkari-theme';

  final SharedPreferences _prefs;
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  static Future<ThemeController> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    final mode = switch (saved) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
    return ThemeController._(prefs, mode);
  }

  /// [currentlyDark] هو الثيم الظاهر فعلاً حالياً (حتى لو كان system).
  Future<void> toggle({required bool currentlyDark}) async {
    _mode = currentlyDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    await _prefs.setString(_key, currentlyDark ? 'light' : 'dark');
  }
}
