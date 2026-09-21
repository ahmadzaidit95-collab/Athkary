import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/theme_switch.dart';
import '../data/adhkar_category.dart';

/// هيدر الشاشة: مشهد (سماء + شمس/قمر + تلال) + العنوان + كارت التقدم.
/// بدّل الـ CustomPaint بصورة من assets لما تجهز صور التصميم.
class SceneHeader extends StatelessWidget {
  const SceneHeader({
    super.key,
    required this.category,
    required this.done,
    required this.total,
  });

  final AdhkarCategory category;
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final top = MediaQuery.paddingOf(context).top;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final text = Theme.of(context).textTheme;
    final ink = Theme.of(context).colorScheme.onSurface;

    final sceneHeight = r.s(190) + top;
    final palette = _Palette.of(isDark: isDark, evening: category.isEvening);

    return SizedBox(
      height: sceneHeight + r.s(34),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: sceneHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(r.s(28)),
              ),
              child: CustomPaint(
                painter: _ScenePainter(
                  palette: palette,
                  isDark: isDark,
                  orbY: top + r.s(46),
                ),
              ),
            ),
          ),

          // الصف العلوي: سويتش الثيم (يمين) + رجوع (شمال) زي التصميم
          Positioned(
            top: top + r.s(8),
            left: r.s(14),
            right: r.s(14),
            child: Row(
              children: [
                const ThemeSwitch(),
                const Spacer(),
                _BackButton(),
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
                  category.title,
                  style: text.headlineMedium?.copyWith(
                    fontSize: r.sp(32),
                    fontWeight: FontWeight.w700,
                    color: ink,
                  ),
                ),
                Text(
                  category.subtitle,
                  style: text.bodyMedium?.copyWith(
                    fontSize: r.sp(15),
                    color: ink.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // كارت التقدم (بيتداخل مع أسفل الهيدر)
          Positioned(
            bottom: 0,
            left: r.s(18),
            right: r.s(18),
            child: _ProgressCard(done: done, total: total),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final scheme = Theme.of(context).colorScheme;
    return Material(
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
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.done, required this.total});
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final c = context.colors;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final value = total == 0 ? 0.0 : done / total;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.s(16), vertical: r.s(14)),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(r.s(20)),
        border: Border.all(color: c.line),
        boxShadow: [
          BoxShadow(color: c.shadow, blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Text('عدد الأذكار',
              style: text.bodyMedium
                  ?.copyWith(fontSize: r.sp(14), color: c.muted)),
          SizedBox(width: r.s(12)),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: value),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              builder: (_, v, __) => ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: v,
                  minHeight: r.s(8),
                  backgroundColor: c.track,
                  color: scheme.primary,
                ),
              ),
            ),
          ),
          SizedBox(width: r.s(12)),
          Text('$done من $total',
              style: text.titleMedium
                  ?.copyWith(fontSize: r.sp(16), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ───────────────────────── المشهد ─────────────────────────

class _Palette {
  const _Palette({
    required this.sky,
    required this.orb,
    required this.farHill,
    required this.nearHill,
  });

  final List<Color> sky;
  final Color orb;
  final Color farHill;
  final Color nearHill;

  static _Palette of({required bool isDark, required bool evening}) {
    if (!isDark && !evening) {
      return const _Palette(
        sky: [Color(0xFFFBEFD3), Color(0xFFE4EDDB)],
        orb: Color(0xFFF7C766),
        farHill: Color(0xFFBFD4C0),
        nearHill: Color(0xFF93B5A0),
      );
    }
    if (!isDark && evening) {
      return const _Palette(
        sky: [Color(0xFFF7CDB0), Color(0xFFD9B8D8)],
        orb: Color(0xFFF3A24B),
        farHill: Color(0xFFB99BC6),
        nearHill: Color(0xFF8E75A8),
      );
    }
    if (isDark && !evening) {
      return const _Palette(
        sky: [Color(0xFF16233F), Color(0xFF10202E)],
        orb: Color(0xFFF1E1AE),
        farHill: Color(0xFF1D3B3A),
        nearHill: Color(0xFF12292B),
      );
    }
    return const _Palette(
      sky: [Color(0xFF141B3A), Color(0xFF0E1230)],
      orb: Color(0xFFF1E1AE),
      farHill: Color(0xFF1B2350),
      nearHill: Color(0xFF121840),
    );
  }
}

class _ScenePainter extends CustomPainter {
  const _ScenePainter({
    required this.palette,
    required this.isDark,
    required this.orbY,
  });

  final _Palette palette;
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
          colors: palette.sky,
        ).createShader(rect),
    );

    final center = Offset(w * 0.5, orbY);

    // هالة
    canvas.drawCircle(
      center,
      44,
      Paint()
        ..color = palette.orb.withOpacity(0.28)
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
      // هلال
      final moon = Path.combine(
        PathOperation.difference,
        Path()..addOval(Rect.fromCircle(center: center, radius: 24)),
        Path()..addOval(Rect.fromCircle(center: center.translate(11, -5), radius: 21)),
      );
      canvas.drawPath(moon, Paint()..color = palette.orb);
    } else {
      canvas.drawCircle(center, 26, Paint()..color = palette.orb);
    }

    // تلال
    final far = Path()
      ..moveTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.25, h * 0.52, w * 0.5, h * 0.70)
      ..quadraticBezierTo(w * 0.75, h * 0.86, w, h * 0.62)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(far, Paint()..color = palette.farHill);

    final near = Path()
      ..moveTo(0, h * 0.86)
      ..quadraticBezierTo(w * 0.30, h * 0.68, w * 0.58, h * 0.84)
      ..quadraticBezierTo(w * 0.82, h * 0.96, w, h * 0.80)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(near, Paint()..color = palette.nearHill);
  }

  @override
  bool shouldRepaint(covariant _ScenePainter old) =>
      old.palette != palette || old.isDark != isDark || old.orbY != orbY;
}
