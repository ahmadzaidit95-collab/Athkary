import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import 'theme_switch.dart';

/// ألوان مشهد الهيدر (سماء + شمس/قمر + تلال).
class SceneColors {
  const SceneColors({
    required this.sky,
    required this.orb,
    required this.farHill,
    required this.nearHill,
  });

  final List<Color> sky;
  final Color orb;
  final Color farHill;
  final Color nearHill;

  static const tasbeehLight = SceneColors(
    sky: [Color(0xFFFBEBD2), Color(0xFFF0DCC0)],
    orb: Color(0xFFF2B65C),
    farHill: Color(0xFFDDBF9A),
    nearHill: Color(0xFFC49A6A),
  );

  static const tasbeehDark = SceneColors(
    sky: [Color(0xFF221C14), Color(0xFF171209)],
    orb: Color(0xFFF1E1AE),
    farHill: Color(0xFF3A2D1C),
    nearHill: Color(0xFF2A2013),
  );
}

/// هيدر بمشهد: سويتش الثيم + زرار رجوع + عنوان وعنوان فرعي.
class SceneBanner extends StatelessWidget {
  const SceneBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.light,
    required this.dark,
  });

  final String title;
  final String subtitle;
  final SceneColors light;
  final SceneColors dark;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final top = MediaQuery.paddingOf(context).top;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final ink = scheme.onSurface;
    final height = r.s(180) + top;

    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(r.s(28)),
              ),
              child: CustomPaint(
                painter: _BannerPainter(
                  colors: isDark ? dark : light,
                  isDark: isDark,
                  orbY: top + r.s(46),
                ),
              ),
            ),
          ),

          // سويتش الثيم (يمين) + رجوع (شمال)
          Positioned(
            top: top + r.s(8),
            left: r.s(14),
            right: r.s(14),
            child: Row(
              children: [
                const ThemeSwitch(),
                const Spacer(),
                Material(
                  color: scheme.surface.withOpacity(0.9),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.maybePop(context),
                    child: SizedBox(
                      width: r.s(44),
                      height: r.s(44),
                      child: Icon(Icons.chevron_left_rounded, size: r.s(28)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // العنوان
          Positioned(
            top: top + r.s(74),
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  title,
                  style: text.headlineMedium?.copyWith(
                    fontSize: r.sp(32),
                    fontWeight: FontWeight.w700,
                    color: ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: text.bodyMedium?.copyWith(
                    fontSize: r.sp(15),
                    color: ink.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerPainter extends CustomPainter {
  const _BannerPainter({
    required this.colors,
    required this.isDark,
    required this.orbY,
  });

  final SceneColors colors;
  final bool isDark;
  final double orbY;

  static const _stars = [
    Offset(.08, .14), Offset(.22, .30), Offset(.35, .10), Offset(.62, .16),
    Offset(.78, .28), Offset(.90, .12), Offset(.70, .40), Offset(.15, .50),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors.sky,
        ).createShader(rect),
    );

    final center = Offset(w * 0.5, orbY);

    canvas.drawCircle(
      center,
      44,
      Paint()
        ..color = colors.orb.withOpacity(0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );

    if (isDark) {
      for (final p in _stars) {
        canvas.drawCircle(
          Offset(w * p.dx, h * p.dy),
          1.3,
          Paint()..color = Colors.white.withOpacity(0.7),
        );
      }
      final moon = Path.combine(
        PathOperation.difference,
        Path()..addOval(Rect.fromCircle(center: center, radius: 24)),
        Path()
          ..addOval(
            Rect.fromCircle(center: center.translate(11, -5), radius: 21),
          ),
      );
      canvas.drawPath(moon, Paint()..color = colors.orb);
    } else {
      canvas.drawCircle(center, 26, Paint()..color = colors.orb);
    }

    final far = Path()
      ..moveTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.25, h * 0.52, w * 0.5, h * 0.70)
      ..quadraticBezierTo(w * 0.75, h * 0.86, w, h * 0.62)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(far, Paint()..color = colors.farHill);

    final near = Path()
      ..moveTo(0, h * 0.86)
      ..quadraticBezierTo(w * 0.30, h * 0.68, w * 0.58, h * 0.84)
      ..quadraticBezierTo(w * 0.82, h * 0.96, w, h * 0.80)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(near, Paint()..color = colors.nearHill);
  }

  @override
  bool shouldRepaint(covariant _BannerPainter old) =>
      old.colors != colors || old.isDark != isDark || old.orbY != orbY;
}