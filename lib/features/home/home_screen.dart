import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/theme_switch.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = context.r;

    return Scaffold(
      body: SafeArea(
        child: Center(
          // على التابلت المحتوى ما يزيدش عن 480
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(r.s(18)),
              child: Column(
                children: [
                  const _Header(),
                  SizedBox(height: r.s(16)),
                  const _Hero(),
                  SizedBox(height: r.s(16)),
                  const _SectionsGrid(),
                  SizedBox(height: r.s(16)),
                  const _VerseBar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── الهيدر ─────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final accent = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        Icon(Icons.eco_outlined, size: r.s(40), color: accent),
        SizedBox(width: r.s(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أذكاري',
                style: text.headlineMedium?.copyWith(
                  fontSize: r.sp(30),
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              Text(
                'طريقك لذكر الله',
                style: text.bodyMedium?.copyWith(
                  fontSize: r.sp(14),
                  color: c.muted,
                ),
              ),
            ],
          ),
        ),
        const ThemeSwitch(),
      ],
    );
  }
}

// ───────────────────────── البانر ─────────────────────────

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final c = context.colors;
    final text = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: r.s(160)),
      padding: EdgeInsets.all(r.s(20)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: c.heroGradient,
        ),
        borderRadius: BorderRadius.circular(r.s(28)),
        boxShadow: [BoxShadow(color: c.shadow, blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Stack(
        children: [
          // شمس/قمر بسيط — بدّله بصورة من assets لما تجهز
          PositionedDirectional(
            start: r.s(8),
            top: r.s(6),
            child: Container(
              width: r.s(72),
              height: r.s(72),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? const [Color(0xFFF4E3B0), Color(0xFFE3C877)]
                      : const [Color(0xFFFFD98A), Color(0xFFF7B955)],
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isDark ? 'اللهم اجعلنا من الذاكرين' : 'ابدأ يومك بذكر الله',
                  style: text.titleLarge?.copyWith(
                    fontSize: r.sp(20),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: r.s(4)),
                Text('﴿وَاذْكُرُوا اللَّهَ كَثِيرًا﴾',
                    style: AppTheme.quran(context, r.sp(17))),
                Text('[ الأحزاب : 41 ]',
                    style: text.bodySmall
                        ?.copyWith(fontSize: r.sp(12), color: c.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── شبكة الأقسام ─────────────────────────

class _SectionsGrid extends StatelessWidget {
  const _SectionsGrid();

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final c = context.colors;

    final items = [
      (route: '/morning', title: 'أذكار الصباح', icon: Icons.wb_sunny_rounded, colors: c.morning),
      (route: '/evening', title: 'أذكار المساء', icon: Icons.nightlight_round, colors: c.evening),
      (route: '/duas', title: 'الأدعية', icon: Icons.volunteer_activism_rounded, colors: c.duas),
      (route: '/tasbeeh', title: 'المسبحة', icon: Icons.blur_circular_rounded, colors: c.tasbeeh),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: r.s(14),
      crossAxisSpacing: r.s(14),
      // الكارت شبه مربع؛ على الشاشات الضيقة بنطوّله شوية عشان النص ما يتقصش
      childAspectRatio: r.isNarrow ? 0.9 : 1 / 1.05,
      children: [
        for (final it in items)
          _Tile(
            title: it.title,
            icon: it.icon,
            colors: it.colors,
            onTap: () => Navigator.pushNamed(context, it.route),
          ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.title,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final TileColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final c = context.colors;
    final text = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors.gradient,
          ),
          borderRadius: BorderRadius.circular(r.s(28)),
          boxShadow: [BoxShadow(color: c.shadow, blurRadius: 20, offset: const Offset(0, 6))],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(r.s(28)),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: r.s(16), horizontal: r.s(12)),
            child: Column(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(icon, size: r.s(64), color: colors.ink),
                  ),
                ),
                SizedBox(height: r.s(8)),
                Text(
                  title,
                  style: text.titleMedium?.copyWith(
                    fontSize: r.sp(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: r.s(8)),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.ink.withOpacity(0.18),
                  ),
                  // في RTL "الأمام" ناحية الشمال
                  child: Icon(Icons.chevron_left_rounded, size: 20, color: colors.ink),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── شريط الآية ─────────────────────────

class _VerseBar extends StatelessWidget {
  const _VerseBar();

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final c = context.colors;
    final text = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: r.s(12), horizontal: r.s(18)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(r.s(20)),
        border: Border.all(color: c.line),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome_outlined, size: 22, color: c.gold),
          SizedBox(width: r.s(14)),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('﴿فَاذْكُرُونِي أَذْكُرْكُمْ﴾',
                    textAlign: TextAlign.center,
                    style: AppTheme.quran(context, r.sp(21))),
                Text('[ سورة البقرة : 152 ]',
                    style: text.bodySmall
                        ?.copyWith(fontSize: r.sp(12), color: c.muted)),
              ],
            ),
          ),
          SizedBox(width: r.s(14)),
          Icon(Icons.auto_awesome_outlined, size: 22, color: c.gold),
        ],
      ),
    );
  }
}
