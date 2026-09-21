import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/theme_switch.dart';
import 'data/duas_data.dart';
import 'data/dua_category.dart';
import 'dua_category_screen.dart';

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DuaCategory> get _filteredCategories {
    if (_searchQuery.trim().isEmpty) {
      return duaCategories;
    }

    final query = _searchQuery.trim();

    return duaCategories.where((category) {
      return category.title.contains(query) ||
          category.subtitle.contains(query);
    }).toList();
  }

  void _openCategory(DuaCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DuaCategoryScreen(
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final categories = _filteredCategories;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              searchController: _searchController,
              onSearchChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: categories.isEmpty
                  ? Center(
                      child: Text(
                        'لا توجد نتائج',
                        style: TextStyle(
                          fontSize: 18,
                          color: colors.muted,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.95,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        return _CategoryCard(
                          category: category,
                          onTap: () => _openCategory(category),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.searchController,
    required this.onSearchChanged,
    required this.onBack,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 310,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        child: Stack(
          children: [
            // خلفية الهيدر + الشمس + التلال
            Positioned.fill(
              child: CustomPaint(
                painter: _DuasHeaderPainter(
                  isDark: isDark,
                ),
              ),
            ),

            // زر الوضع الليلي / النهاري
            Positioned(
              right: 16,
              top: 12,
              child: const ThemeSwitch(),
            ),

            // زر الرجوع - الشمال
            Positioned(
              left: 16,
              top: 12,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Material(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.25)
                      : Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    onTap: onBack,
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 46,
                      height: 46,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: isDark
                            ? Colors.white
                            : colors.duas.ink,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // العنوان
            Positioned(
              top: 72,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'الأدعية',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF2F6650),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'أدعية من القرآن والسنة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? Colors.white70
                          : const Color(0xFF6F8D7D),
                    ),
                  ),
                ],
              ),
            ),

            // البحث
            Positioned(
              left: 28,
              right: 28,
              bottom: 30,
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'ابحث عن قسم...',
                  hintStyle: TextStyle(
                    color: isDark
                        ? Colors.white60
                        : const Color(0xFF777777),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: isDark
                        ? Colors.white70
                        : const Color(0xFF365E4E),
                  ),
                  filled: true,
                  fillColor: isDark
                      ? Colors.black.withValues(alpha: 0.35)
                      : Colors.white.withValues(alpha: 0.82),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DuasHeaderPainter extends CustomPainter {
  _DuasHeaderPainter({
    required this.isDark,
  });

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    // الخلفية
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? const [
                Color(0xFF18271F),
                Color(0xFF21362C),
              ]
            : const [
                Color(0xFFFFF9E9),
                Color(0xFFEAF1DE),
              ],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // الشمس
    final sunPaint = Paint()
      ..color = isDark
          ? const Color(0xFFD8B85A)
          : const Color(0xFFFFC85C);

    canvas.drawCircle(
      Offset(size.width * 0.50, 62),
      27,
      sunPaint,
    );

    // التلة الخلفية
    final backHillPaint = Paint()
      ..color = isDark
          ? const Color(0xFF29483C)
          : const Color(0xFFB7D6C5);

    final backHill = Path();

    backHill.moveTo(0, size.height * 0.64);

    backHill.cubicTo(
      size.width * 0.18,
      size.height * 0.54,
      size.width * 0.33,
      size.height * 0.57,
      size.width * 0.48,
      size.height * 0.63,
    );

    backHill.cubicTo(
      size.width * 0.65,
      size.height * 0.70,
      size.width * 0.78,
      size.height * 0.55,
      size.width,
      size.height * 0.50,
    );

    backHill.lineTo(size.width, size.height);
    backHill.lineTo(0, size.height);
    backHill.close();

    canvas.drawPath(backHill, backHillPaint);

    // التلة الأمامية
    final frontHillPaint = Paint()
      ..color = isDark
          ? const Color(0xFF1F3A31)
          : const Color(0xFF9DC9B8);

    final frontHill = Path();

    frontHill.moveTo(0, size.height * 0.73);

    frontHill.cubicTo(
      size.width * 0.18,
      size.height * 0.64,
      size.width * 0.35,
      size.height * 0.68,
      size.width * 0.52,
      size.height * 0.73,
    );

    frontHill.cubicTo(
      size.width * 0.70,
      size.height * 0.79,
      size.width * 0.84,
      size.height * 0.66,
      size.width,
      size.height * 0.61,
    );

    frontHill.lineTo(size.width, size.height);
    frontHill.lineTo(0, size.height);
    frontHill.close();

    canvas.drawPath(frontHill, frontHillPaint);

    // مئذنة صغيرة على اليمين
    final mosquePaint = Paint()
      ..color = isDark
          ? const Color(0xFF34594B)
          : const Color(0xFF4C7C69);

    final rightMosque = Path();

    rightMosque.moveTo(size.width * 0.84, size.height * 0.72);
    rightMosque.lineTo(size.width * 0.84, size.height * 0.64);
    rightMosque.lineTo(size.width * 0.86, size.height * 0.61);
    rightMosque.lineTo(size.width * 0.88, size.height * 0.64);
    rightMosque.lineTo(size.width * 0.88, size.height * 0.72);
    rightMosque.close();

    canvas.drawPath(rightMosque, mosquePaint);

    // قبة صغيرة
    canvas.drawCircle(
      Offset(size.width * 0.86, size.height * 0.64),
      5,
      mosquePaint,
    );

    // مئذنة صغيرة على اليسار
    final leftMinaret = Path();

    leftMinaret.moveTo(size.width * 0.17, size.height * 0.73);
    leftMinaret.lineTo(size.width * 0.17, size.height * 0.62);
    leftMinaret.lineTo(size.width * 0.18, size.height * 0.59);
    leftMinaret.lineTo(size.width * 0.19, size.height * 0.62);
    leftMinaret.lineTo(size.width * 0.19, size.height * 0.73);
    leftMinaret.close();

    canvas.drawPath(leftMinaret, mosquePaint);
  }

  @override
  bool shouldRepaint(covariant _DuasHeaderPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  final DuaCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: colors.line,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: colors.duas.gradient.first,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: colors.duas.ink,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  category.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  category.subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.muted,
                    height: 1.5,
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