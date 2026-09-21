import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
        brightness: Brightness.light,
        bg: const Color(0xFFF6F2E8),
        surface: const Color(0xFFFCFAF5),
        ink: const Color(0xFF1E2B24),
        accent: const Color(0xFF2C5A44),
        onAccent: const Color(0xFFF6F3EA),
        extra: AppColors.light,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        bg: const Color(0xFF0D141A),
        surface: const Color(0xFF151F27),
        ink: const Color(0xFFEAEEE9),
        accent: const Color(0xFF7DB394),
        onAccent: const Color(0xFF0C1712),
        extra: AppColors.dark,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color bg,
    required Color surface,
    required Color ink,
    required Color accent,
    required Color onAccent,
    required AppColors extra,
  }) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: accent,
        onPrimary: onAccent,
        secondary: accent,
        onSecondary: onAccent,
        error: const Color(0xFFB3261E),
        onError: Colors.white,
        surface: surface,
        onSurface: ink,
      ),
      textTheme: GoogleFonts.ibmPlexSansArabicTextTheme(base.textTheme)
          .apply(bodyColor: ink, displayColor: ink),
      extensions: [extra],
    );
  }

  /// خط الآيات والأذكار.
  static TextStyle quran(BuildContext context, double size) =>
      GoogleFonts.amiri(fontSize: size, height: 1.9);
}
