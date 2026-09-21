import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// شاشة مؤقتة للأقسام اللي لسه ما اتبنتش.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.transparent),
      body: Center(
        child: Text(
          'الشاشة دي هنبنيها في خXXXXXXXXXXطوة جاية',
          style: text.bodyLarge?.copyWith(color: context.colors.muted),
        ),
      ),
    );
  }
}
