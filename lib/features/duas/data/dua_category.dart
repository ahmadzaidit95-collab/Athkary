import 'dua_item.dart';

class DuaCategory {
  const DuaCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<DuaItem> items;
}
