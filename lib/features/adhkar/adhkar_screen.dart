import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import 'adhkar_controller.dart';
import 'data/adhkar_category.dart';
import 'widgets/dhikr_card.dart';
import 'widgets/scene_header.dart';

/// شاشة الأذكار (صباح/مساء).
class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key, required this.category});
  final AdhkarCategory category;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdhkarController(category),
      child: _AdhkarView(category: category),
    );
  }
}

class _AdhkarView extends StatefulWidget {
  const _AdhkarView({required this.category});
  final AdhkarCategory category;

  @override
  State<_AdhkarView> createState() => _AdhkarViewState();
}

class _AdhkarViewState extends State<_AdhkarView> {
  final _scroll = ScrollController();
  late final List<GlobalKey> _keys =
      List.generate(widget.category.items.length, (_) => GlobalKey());

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToFirstOpen(AdhkarController ctrl) {
    final i = ctrl.firstOpenIndex;
    if (i < 0) return;
    final ctx = _keys[i].currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      alignment: 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final dark = base.brightness == Brightness.dark;
    final cat = widget.category;

    // حماية ضد الـ Null Crash مع الـ Theme Extension
    final appColors = base.extension<AppColors>();

    final themed = base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: dark ? cat.accentDark : cat.accentLight,
        onPrimary: dark ? cat.onAccentDark : cat.onAccentLight,
        secondary: dark ? cat.accentDark : cat.accentLight,
      ),
      extensions: [
        if (appColors != null)
          appColors.copyWith(
            accentSoft: dark ? cat.softDark : cat.softLight,
          ),
      ],
    );

    return Theme(
      data: themed,
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scroll,
                    padding: EdgeInsets.zero,
                    itemCount: cat.items.length + 1, // +1 لـ SceneHeader
                    itemBuilder: (context, index) {
                      final r = context.r;

                      if (index == 0) {
                        return Selector<AdhkarController, (int, int)>(
                          selector: (_, ctrl) => (ctrl.doneCount, ctrl.total),
                          builder: (_, data, __) => SceneHeader(
                            category: cat,
                            done: data.$1,
                            total: data.$2,
                          ),
                        );
                      }

                      final i = index - 1;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: r.s(18)),
                        child: Column(
                          children: [
                            KeyedSubtree(
                              key: _keys[i],
                              child: Selector<AdhkarController, int>(
                                selector: (_, ctrl) => ctrl.countAt(i),
                                builder: (context, count, _) {
                                  final ctrl = context.read<AdhkarController>();
                                  return DhikrCard(
                                    index: i,
                                    dhikr: cat.items[i],
                                    count: count,
                                    onIncrement: () => ctrl.increment(i),
                                    onReset: () => ctrl.resetOne(i),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: r.s(14)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Selector<AdhkarController, bool>(
                  selector: (_, ctrl) => ctrl.allDone,
                  builder: (context, allDone, _) {
                    final ctrl = context.read<AdhkarController>();
                    return _BottomButton(
                      allDone: allDone,
                      onPressed: () => allDone
                          ? ctrl.resetAll()
                          : _scrollToFirstOpen(ctrl),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _BottomButton extends StatelessWidget {
  const _BottomButton({required this.allDone, required this.onPressed});
  final bool allDone;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.s(18), r.s(8), r.s(18), r.s(12)),
        child: SizedBox(
          width: double.infinity,
          height: r.s(56),
          child: FilledButton.icon(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              shape: const StadiumBorder(),
            ),
            icon: Icon(
              allDone ? Icons.restart_alt_rounded : Icons.menu_book_rounded,
              size: r.s(22),
            ),
            label: Text(
              allDone ? 'تقبّل الله منك — إعادة الأذكار' : 'متابعة الأذكار',
              style: TextStyle(
                fontSize: r.sp(17),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}