import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../data/dhikr.dart';

/// كارت ذكر واحد: رقم + التكرار + النص + المصدر + العدّاد.
class DhikrCard extends StatelessWidget {
  const DhikrCard({
    super.key,
    required this.index,
    required this.dhikr,
    required this.count,
    required this.onIncrement,
    required this.onReset,
  });

  final int index;
  final Dhikr dhikr;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  bool get _done => count >= dhikr.count;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final c = context.colors;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: _done ? 0.6 : 1,
      child: Material(
        color: scheme.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r.s(24)),
          side: BorderSide(color: c.line),
        ),
        child: InkWell(
          // الضغط على أي مكان في الكارت بيعدّ
          onTap: _done ? null : onIncrement,
          child: Padding(
            padding: EdgeInsets.fromLTRB(r.s(16), r.s(14), r.s(16), r.s(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _RepeatPill(count: dhikr.count),
                    const Spacer(),
                    _NumberBadge(number: index + 1, done: _done),
                  ],
                ),
                SizedBox(height: r.s(10)),
                Text(
                  dhikr.text,
                  style: text.titleMedium?.copyWith(
                    fontSize: r.sp(19),
                    fontWeight: FontWeight.w600,
                    height: 1.95,
                  ),
                ),
                SizedBox(height: r.s(8)),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book_outlined,
                          size: r.s(16), color: c.muted),
                      SizedBox(width: r.s(6)),
                      Text(
                        'المصدر: ${dhikr.source}',
                        style: text.bodySmall
                            ?.copyWith(fontSize: r.sp(12.5), color: c.muted),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: r.s(12)),
                _CounterBar(
                  count: count,
                  target: dhikr.count,
                  done: _done,
                  onIncrement: onIncrement,
                  onReset: onReset,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _repeatLabel(int n) {
  if (n == 1) return 'التكرار: مرة واحدة';
  if (n == 2) return 'التكرار: مرتان';
  if (n <= 10) return 'التكرار: $n مرات';
  return 'التكرار: $n مرة';
}

class _RepeatPill extends StatelessWidget {
  const _RepeatPill({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final c = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.s(12), vertical: r.s(4)),
      decoration: BoxDecoration(
        color: c.accentSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _repeatLabel(count),
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(fontSize: r.sp(12.5), fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number, required this.done});
  final int number;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final c = context.colors;
    final scheme = Theme.of(context).colorScheme;
    final size = r.s(34);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? scheme.primary : c.accentSoft,
      ),
      child: done
          ? Icon(Icons.check_rounded, size: r.s(20), color: scheme.onPrimary)
          : Text(
              '$number',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: r.sp(15), fontWeight: FontWeight.w600),
            ),
    );
  }
}

class _CounterBar extends StatelessWidget {
  const _CounterBar({
    required this.count,
    required this.target,
    required this.done,
    required this.onIncrement,
    required this.onReset,
  });

  final int count;
  final int target;
  final bool done;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final r = context.r;
    final c = context.colors;
    final scheme = Theme.of(context).colorScheme;
    final h = r.s(52);

    return Container(
      padding: EdgeInsets.all(r.s(5)),
      decoration: BoxDecoration(
        color: c.track.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          // زرار + (ناحية بداية السطر = اليمين في RTL)
          Material(
            color: done ? c.track : scheme.primary,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: done ? null : onIncrement,
              child: SizedBox(
                width: r.s(86),
                height: h,
                child: Icon(
                  done ? Icons.check_rounded : Icons.add_rounded,
                  size: r.s(28),
                  color: done ? c.muted : scheme.onPrimary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                // LTR isolate عشان يظهر "0 / 3" مش "3 / 0"
                '\u2066$count / $target\u2069',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: r.sp(20),
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              ),
            ),
          ),
          // زرار إعادة العدّ
          Material(
            color: c.track.withOpacity(0.5),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: count == 0 ? null : onReset,
              child: SizedBox(
                width: h,
                height: h,
                child: Icon(
                  Icons.restart_alt_rounded,
                  size: r.s(24),
                  color: count == 0 ? c.muted.withOpacity(0.5) : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
