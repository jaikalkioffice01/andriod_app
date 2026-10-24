/// ---------------------------------------------------------------------------
/// PRODUCT MODEL
/// Describes one product in the catalog. This is THE most important model
/// in the app - screens, cart and wishlist all revolve around it.
/// ---------------------------------------------------------------------------
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewCount,
    required this.categoryId,
    required this.emoji,
  });

  final String id;
  final String name;
  final String description;

  /// Current selling price.
  final double price;

  /// Price before discount (null = no discount). Old price is shown with a
  /// strikethrough in the UI when it exists.
  final double? oldPrice;

  /// 0.0 - 5.0
  final double rating;
  final int reviewCount;

  /// Which category this product belongs to (matches Category.id).
  final String categoryId;

  /// Emoji used as the product "image" in this demo app.
  final String emoji;

  // ----- Computed getters (small pieces of derived logic) -----

  /// True when there is a real discount to show.
  bool get hasDiscount => oldPrice != null && oldPrice! > price;

  /// Discount percentage, e.g. 29 (= "29% OFF").
  int get discountPercent {
    if (!hasDiscount) return 0;
    final double diff = (oldPrice! - price) / oldPrice! * 100;
    return diff.round();
  }

  // ----- Serialization -----
  // Cart & wishlist are saved to SharedPreferences as JSON, so every model
  // knows how to turn itself into/from a Map.

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'oldPrice': oldPrice,
        'rating': rating,
        'reviewCount': reviewCount,
        'categoryId': categoryId,
        'emoji': emoji,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        oldPrice: json['oldPrice'] == null
            ? null
            : (json['oldPrice'] as num).toDouble(),
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
        categoryId: json['categoryId'] as String,
        emoji: json['emoji'] as String,
      );
}
