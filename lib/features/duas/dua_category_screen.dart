import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'data/dua_category.dart';

class DuaCategoryScreen extends StatelessWidget {
  const DuaCategoryScreen({
    super.key,
    required this.category,
  });

  final DuaCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              title: category.title,
              subtitle: category.subtitle,
            ),
            Expanded(
              child: category.items.isEmpty
                  ? Center(
                      child: Text(
                        'لا توجد أدعية مضافة حتى الآن',
                        style: TextStyle(
                          fontSize: 18,
                          color: colors.muted,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      itemCount: category.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _DuaCard(
                          text: category.items[index].text,
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
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors.heroGradient,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 46,
            child: Stack(
              children: [
                // السهم في أقصى الشمال
                Positioned(
                  left: 0,
                  top: 0,
                  child: _HeaderButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: colors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: isDark
            ? Colors.white.withValues(alpha: 0.10)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 46,
            height: 46,
            child: Icon(
              icon,
              color: isDark ? colors.duas.ink : colors.duas.ink,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

class _DuaCard extends StatelessWidget {
  const _DuaCard({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.line,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          text,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 20,
            height: 2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}