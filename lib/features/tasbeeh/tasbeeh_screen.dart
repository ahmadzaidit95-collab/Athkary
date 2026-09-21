import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/scene_banner.dart';
import 'tasbeeh_controller.dart';

class TasbeehScreen extends StatelessWidget {
  const TasbeehScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TasbeehController(),
      child: const _TasbeehTheme(),
    );
  }
}

/// لون المسبحة (بني ذهبي) بدون ما نغيّر باقي التطبيق.
class _TasbeehTheme extends StatelessWidget {
  const _TasbeehTheme();

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final dark = base.brightness == Brightness.dark;

    final themed = base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: dark ? const Color(0xFFE9C480) : const Color(0xFF8A5A2B),
        onPrimary: dark ? const Color(0xFF1C1608) : const Color(0xFFFBF6EC),
      ),
      extensions: [
        base.extension<AppColors>()!.copyWith(
          accentSoft: dark ? const Color(0xFF2B2417) : const Color(0xFFF0E2CC),
        ),
      ],
    );

    return Theme(data: themed, child: const _TasbeehBody());
  }
}

class _TasbeehBody extends StatelessWidget {
  const _TasbeehBody();

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final ctrl = context.watch<TasbeehController>();

    final dialSize =
        math.max(190.0, math.min(300.0, r.contentWidth * 0.62));

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SceneBanner(
                  title: 'المسبحة',
                  subtitle: 'سبّح واذكر الله',
                  light: SceneColors.tasbeehLight,
                  dark: SceneColors.tasbeehDark,
                ),
                Padding(
                  padding: EdgeInsets.all(r.s(18)),
                  child: Column(
                    children: [
                      SizedBox(height: r.s(4)),

                      // ── اختيار الذكر ──
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var i = 0; i < tasbeehItems.length; i++)
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.only(end: r.s(8)),
                                child: _Choice(
                                  label: tasbeehItems[i].label,
                                  selected: ctrl.index == i,
                                  onTap: () => ctrl.select(i),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: r.s(22)),

                      // ── نص الذكر ──
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          ctrl.item.text,
                          key: ValueKey(ctrl.index),
                          textAlign: TextAlign.center,
                          style: AppTheme.quran(context, r.sp(30)),
                        ),
                      ),
                      SizedBox(height: r.s(22)),

                      // ── العدّاد ──
                      _CounterDial(
                        size: dialSize,
                        count: ctrl.count,
                        target: ctrl.target,
                        progress: ctrl.progress,
                        onTap: ctrl.tap,
                      ),
                      SizedBox(height: r.s(22)),

                      // ── الهدف ──
                      Row(
                        children: [
                          Text('الهدف',
                              style: text.bodyMedium?.copyWith(
                                  fontSize: r.sp(14), color: c.muted)),
                          SizedBox(width: r.s(12)),
                          for (final t in tasbeehTargets)
                            Padding(
                              padding: EdgeInsetsDirectional.only(end: r.s(8)),
                              child: _Choice(
                                label: t == 0 ? 'حر' : '$t',
                                selected: ctrl.target == t,
                                onTap: () => ctrl.setTarget(t),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: r.s(16)),

                      // ── الدورات + تصفير ──
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'عدد الدورات: ${ctrl.rounds}',
                              style: text.titleMedium?.copyWith(
                                fontSize: r.sp(16),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: ctrl.count == 0 && ctrl.rounds == 0
                                ? null
                                : ctrl.reset,
                            icon: const Icon(Icons.restart_alt_rounded),
                            label: const Text('تصفير'),
                            style: OutlinedButton.styleFrom(
                              shape: const StadiumBorder(),
                              side: BorderSide(color: c.line),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.paddingOf(context).bottom,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final c = context.colors;
    final scheme = Theme.of(context).colorScheme;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      shape: const StadiumBorder(),
      side: BorderSide(color: selected ? scheme.primary : c.line),
      backgroundColor: scheme.surface,
      selectedColor: scheme.primary,
      labelStyle: TextStyle(
        fontSize: r.sp(14),
        fontWeight: FontWeight.w600,
        color: selected ? scheme.onPrimary : scheme.onSurface,
      ),
    );
  }
}

class _CounterDial extends StatefulWidget {
  const _CounterDial({
    required this.size,
    required this.count,
    required this.target,
    required this.progress,
    required this.onTap,
  });

  final double size;
  final int count;
  final int target;
  final double progress;
  final VoidCallback onTap;

  @override
  State<_CounterDial> createState() => _CounterDialState();
}

class _CounterDialState extends State<_CounterDial> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final size = widget.size;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: widget.progress),
              duration: const Duration(milliseconds: 200),
              builder: (_, v, __) => CustomPaint(
                painter: _RingPainter(
                  value: v,
                  track: c.track,
                  color: scheme.primary,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size * 0.075),
            child: AnimatedScale(
              scale: _down ? 0.96 : 1,
              duration: const Duration(milliseconds: 90),
              child: Material(
                color: c.accentSoft,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: widget.onTap,
                  onHighlightChanged: (v) => setState(() => _down = v),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\u2066${widget.count}\u2069',
                          style: text.displayMedium?.copyWith(
                            fontSize: size * 0.28,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                        if (widget.target > 0)
                          Text(
                            'من ${widget.target}',
                            style: text.bodyMedium?.copyWith(
                              fontSize: size * 0.07,
                              color: c.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.track,
    required this.color,
  });

  final double value;
  final Color track;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 10.0;
    final rect = Offset(stroke / 2, stroke / 2) &
        Size(size.width - stroke, size.height - stroke);

    canvas.drawArc(
      rect,
      0,
      2 * math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = track,
    );

    if (value > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * value,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round
          ..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.value != value || old.track != track || old.color != color;
}
