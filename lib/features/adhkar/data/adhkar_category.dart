import 'package:flutter/material.dart';

import 'adhkar_data.dart';
import 'dhikr.dart';

/// إعدادات قسم أذكار (صباح / مساء): العنوان + الأذكار + ألوان القسم.
class AdhkarCategory {
  const AdhkarCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.isEvening,
    required this.accentLight,
    required this.onAccentLight,
    required this.softLight,
    required this.accentDark,
    required this.onAccentDark,
    required this.softDark,
  });
  /// قسم أدعية بألوان خضراء (بيستخدم في تصنيفات الأدعية).
  const AdhkarCategory.dua({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.items,
  })  : isEvening = false,
        accentLight = const Color(0xFF2C5A44),
        onAccentLight = const Color(0xFFF6F3EA),
        softLight = const Color(0xFFDCE7DD),
        accentDark = const Color(0xFF7DB394),
        onAccentDark = const Color(0xFF0C1712),
        softDark = const Color(0xFF1F3429);
  final String id;
  final String title;
  final String subtitle;
  final List<Dhikr> items;
  final bool isEvening;

  final Color accentLight;
  final Color onAccentLight;
  final Color softLight;
  final Color accentDark;
  final Color onAccentDark;
  final Color softDark;

  static const morning = AdhkarCategory(
    id: 'morning',
    title: 'أذكار الصباح',
    subtitle: 'ابدأ يومك بذكر الله',
    items: morningAdhkar,
    isEvening: false,
    accentLight: Color(0xFF2C5A44),
    onAccentLight: Color(0xFFF6F3EA),
    softLight: Color(0xFFDCE7DD),
    accentDark: Color(0xFF7DB394),
    onAccentDark: Color(0xFF0C1712),
    softDark: Color(0xFF1F3429),
  );

  static const evening = AdhkarCategory(
    id: 'evening',
    title: 'أذكار المساء',
    subtitle: 'اختم يومك بذكر الله',
    items: eveningAdhkar,
    isEvening: true,
    accentLight: Color(0xFF862F45),
    onAccentLight: Color(0xFFFFF3F0),
    softLight: Color(0xFFF6DDE0),
    accentDark: Color(0xFF7C83F0),
    onAccentDark: Color(0xFF0D1030),
    softDark: Color(0xFF232A55),
  );
}
