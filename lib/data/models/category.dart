/// ---------------------------------------------------------------------------
/// CATEGORY MODEL
/// A plain Dart class describing one product category
/// (e.g. Electronics, Fashion...).
///
/// Models are DUMB data holders - no Flutter, no logic about screens.
/// ---------------------------------------------------------------------------
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
  });

  /// Unique id, e.g. "c1". Products reference the category by this id.
  final String id;
  final String name;

  /// The demo app uses emojis instead of downloaded images (works offline,
  /// keeps the repo small). In a real app this would be an image URL/path.
  final String emoji;

  /// ARGB int color used for the category tile background.
  final int color;

  /// Convert to a Map (used if we ever save categories to storage/API).
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'emoji': emoji,
        'color': color,
      };

  /// Rebuild a Category from a Map.
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        name: json['name'] as String,
        emoji: json['emoji'] as String,
        color: json['color'] as int,
      );
}
