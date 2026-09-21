import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';
import '../home/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

/// شاشة البداية: شمس بتطلع، الأيقونة بتظهر جواها،
/// واسم "أذكاري" بيتكتب من اليمين لليسار زي القلم.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds:4000 ),
  );

  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _c.forward().whenComplete(() async {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      _goHome();
    });
  }

  void _goHome() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  /// جزء من الأنيميشن بين [a] و[b] (من 0 لـ 1).
  double _t(double a, double b, [Curve curve = Curves.easeOut]) =>
      Interval(a, b, curve: curve).transform(_c.value);

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ink = scheme.onSurface;

    final sky = isDark
        ? const [Color(0xFF16233F), Color(0xFF0F1A2B)]
        : const [Color(0xFFFBEFD3), Color(0xFFE4EDDB)];
    final orb = isDark ? const Color(0xFFF1E1AE) : const Color(0xFFF7C766);
    final gold = isDark ? const Color(0xFFD2AE68) : const Color(0xFFB08A3E);
    final farHill = isDark ? const Color(0xFF1D3B3A) : const Color(0xFFBFD4C0);
    final nearHill = isDark ? const Color(0xFF12292B) : const Color(0xFF93B5A0);

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _goHome, // اضغط لتخطي الشاشة
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final sun = _t(0.0, 0.55, Curves.easeOutCubic);
            final logo = _t(0.10, 0.40, Curves.easeOutBack);
            final title = _t(0.30, 0.75, Curves.easeInOut);
            final line = _t(0.60, 0.85);
            final tag = _t(0.72, 1.0);

            // حافة الكشف: بتمشي من اليمين لليسار
            final edge = title * 1.2 - 0.2;
            final a = edge.clamp(0.0, 1.0);
            final b = (edge + 0.2).clamp(0.0, 1.0);

            return Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: sky,
                      ),
                    ),
                  ),
                ),

                // التلال
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: MediaQuery.sizeOf(context).height * 0.24,
                  child: Transform.translate(
                    offset: Offset(0, (1 - sun) * 70),
                    child: CustomPaint(
                      painter: _HillsPainter(far: farHill, near: nearHill),
                    ),
                  ),
                ),

                // المحتوى
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // الشمس + الأيقونة
                      Opacity(
                        opacity: sun.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, (1 - sun) * 90),
                          child: Container(
                            width: r.s(112),
                            height: r.s(112),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [orb, orb.withOpacity(0.85)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: orb.withOpacity(0.35),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Transform.scale(
                                scale: logo,
                                child: Icon(
                                  Icons.eco_rounded,
                                  size: r.s(56),
                                  color: scheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: r.s(26)),

                      // الاسم: بيتكتب من اليمين لليسار
                      ShaderMask(
                        blendMode: BlendMode.dstIn,
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: const [
                            Colors.white,
                            Colors.white,
                            Colors.transparent,
                            Colors.transparent,
                          ],
                          stops: [0, a, b, 1],
                        ).createShader(bounds),
                        child: Text(
                          'أذكاري',
                          style: GoogleFonts.arefRuqaa(
                            fontSize: r.sp(96),
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: isDark
                                    ? const [
                                        Color(0xFF7DB394),
                                        Color(0xFFE9C480)
                                      ]
                                    : const [
                                        Color(0xFF2C5A44),
                                        Color(0xFFB08A3E)
                                      ],
                              ).createShader(
                                  Rect.fromLTWH(0, 0, r.sp(260), r.sp(120))),
                          ),
                        ),
                      ),
                      SizedBox(height: r.s(6)),

                      // خط زخرفي
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: r.s(50) * line,
                            height: 2,
                            color: gold,
                          ),
                          SizedBox(width: r.s(8)),
                          Opacity(
                            opacity: line.clamp(0.0, 1.0),
                            child: Icon(Icons.auto_awesome,
                                size: r.s(18), color: gold),
                          ),
                          SizedBox(width: r.s(8)),
                          Container(
                            width: r.s(50) * line,
                            height: 2,
                            color: gold,
                          ),
                        ],
                      ),
                      SizedBox(height: r.s(14)),

                      // الشعار
                      Opacity(
                        opacity: tag.clamp(0.0, 1.0),
                        child: Transform.translate(
                          offset: Offset(0, (1 - tag) * 10),
                          child: Text(
                            'طريقك لذكر الله',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontSize: r.sp(18),
                                  color: ink.withOpacity(0.75),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HillsPainter extends CustomPainter {
  const _HillsPainter({required this.far, required this.near});

  final Color far;
  final Color near;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final farPath = Path()
      ..moveTo(0, h * 0.45)
      ..quadraticBezierTo(w * 0.25, h * 0.10, w * 0.5, h * 0.40)
      ..quadraticBezierTo(w * 0.78, h * 0.70, w, h * 0.25)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(farPath, Paint()..color = far);

    final nearPath = Path()
      ..moveTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.30, h * 0.40, w * 0.58, h * 0.68)
      ..quadraticBezierTo(w * 0.82, h * 0.92, w, h * 0.58)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(nearPath, Paint()..color = near);
  }

  @override
  bool shouldRepaint(covariant _HillsPainter old) =>
      old.far != far || old.near != near;
}
