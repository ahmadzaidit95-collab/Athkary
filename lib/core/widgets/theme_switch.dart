import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: 'تبديل الوضع الليلي',
      child: GestureDetector(
        onTap: () => context
            .read<ThemeController>()
            .toggle(currentlyDark: isDark),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 64,
          height: 34,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: c.track,
            borderRadius: BorderRadius.circular(999),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            // فاتح: الزرار ناحية النهاية (شمال في RTL)، ليلي: ناحية البداية
            alignment: isDark
                ? AlignmentDirectional.centerStart
                : AlignmentDirectional.centerEnd,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF0D141A)
                    : Theme.of(context).colorScheme.surface,
                boxShadow: const [
                  BoxShadow(color: Color(0x2E000000), blurRadius: 6),
                ],
              ),
              child: Icon(
                isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                size: 18,
                color: isDark ? const Color(0xFFF5E2A8) : c.gold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
