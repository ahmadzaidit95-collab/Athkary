import 'package:flutter/material.dart';

/// ألوان كارت في الشاشة الرئيسية: تدرج + لون الأيقونة.
@immutable
class TileColors {
  const TileColors({required this.gradient, required this.ink});
  final List<Color> gradient;
  final Color ink;
}

/// ألوان التطبيق الإضافية (اللي مش موجودة في ColorScheme).
/// بنوصلها من أي مكان بـ: context.colors
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.muted,
    required this.line,
    required this.track,
    required this.gold,
    required this.accentSoft,
    required this.heroGradient,
    required this.shadow,
    required this.morning,
    required this.evening,
    required this.duas,
    required this.tasbeeh,
  });

  final Color muted;
  final Color line;
  final Color track;
  final Color gold;
  final Color accentSoft;
  final List<Color> heroGradient;
  final Color shadow;
  final TileColors morning;
  final TileColors evening;
  final TileColors duas;
  final TileColors tasbeeh;

  static const light = AppColors(
    muted: Color(0xFF7A817B),
    line: Color(0xFFE4DECC),
    track: Color(0xFFDDD7C6),
    gold: Color(0xFFB08A3E),
    accentSoft: Color(0xFFDCE7DD),
    heroGradient: [Color(0xFFFBEFD3), Color(0xFFDDE8D8)],
    shadow: Color(0x143C3214),
    morning: TileColors(
      gradient: [Color(0xFFFFF3DC), Color(0xFFFBE3BD)],
      ink: Color(0xFFB7791F),
    ),
    evening: TileColors(
      gradient: [Color(0xFFEEF0FF), Color(0xFFDFE4FB)],
      ink: Color(0xFF3E4F86),
    ),
    duas: TileColors(
      gradient: [Color(0xFFE6EFE6), Color(0xFFD3E4D6)],
      ink: Color(0xFF2C5A44),
    ),
    tasbeeh: TileColors(
      gradient: [Color(0xFFF6E9D8), Color(0xFFEBD5B8)],
      ink: Color(0xFF8A5A2B),
    ),
  );

  static const dark = AppColors(
    muted: Color(0xFF94A0A6),
    line: Color(0xFF24323C),
    track: Color(0xFF263540),
    gold: Color(0xFFD2AE68),
    accentSoft: Color(0xFF1F3429),
    heroGradient: [Color(0xFF1A2748), Color(0xFF0F1A2B)],
    shadow: Color(0x59000000),
    morning: TileColors(
      gradient: [Color(0xFF1D2733), Color(0xFF182029)],
      ink: Color(0xFFF2B94B),
    ),
    evening: TileColors(
      gradient: [Color(0xFF1E2540), Color(0xFF181E36)],
      ink: Color(0xFFA9B4FF),
    ),
    duas: TileColors(
      gradient: [Color(0xFF17301F), Color(0xFF12261A)],
      ink: Color(0xFF8FD3A5),
    ),
    tasbeeh: TileColors(
      gradient: [Color(0xFF2A2418), Color(0xFF211D14)],
      ink: Color(0xFFE9C480),
    ),
  );

  @override
  AppColors copyWith({Color? accentSoft}) => AppColors(
        muted: muted,
        line: line,
        track: track,
        gold: gold,
        accentSoft: accentSoft ?? this.accentSoft,
        heroGradient: heroGradient,
        shadow: shadow,
        morning: morning,
        evening: evening,
        duas: duas,
        tasbeeh: tasbeeh,
      );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return t < 0.5 ? this : other;
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>() ?? AppColors.light;
}
