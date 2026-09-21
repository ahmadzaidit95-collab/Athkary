import 'dart:math' as math;

import 'package:flutter/material.dart';

/// مساعد الريسبونسف.
/// التصميم مبني على عرض 390 (iPhone 14). أي عرض تاني بنعمله scale
/// بحدود عشان الشاشات الصغيرة (320) ما تتزنقش، والكبيرة (tablet) ما تتضخمش.
class Responsive {
  Responsive._(this.width);

  factory Responsive.of(BuildContext context) =>
      Responsive._(MediaQuery.sizeOf(context).width);

  static const double _designWidth = 390;
  static const double maxContentWidth = 480;

  final double width;

  /// العرض الفعلي للمحتوى (على التابلت بيتحدد بـ 480).
  double get contentWidth => math.min(width, maxContentWidth);

  double get _scale => (contentWidth / _designWidth).clamp(0.82, 1.2);

  /// للمسافات والأحجام.
  double s(double v) => v * _scale;

  /// للخطوط.
  double sp(double v) => v * _scale;

  bool get isNarrow => width < 340;
}

extension ResponsiveX on BuildContext {
  Responsive get r => Responsive.of(this);
}
