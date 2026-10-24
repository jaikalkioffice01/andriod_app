// `hide Category` avoids a name clash: Flutter's foundation library also
// exports a class called Category (a docs annotation). This import line
// hides Flutter's one so `Category` below means OUR model.
import 'package:flutter/foundation.dart' hide Category;

import '../data/models/category.dart';
import '../data/models/product.dart';
import '../data/repositories/product_repository.dart';

/// ---------------------------------------------------------------------------
/// PRODUCTS PROVIDER (state layer)
/// Loads the catalog once at app start and exposes handy ways to slice it:
///
///   products            -> all 20 products
///   categories          -> all 6 categories
///   productsIn(categoryId) -> products of one category
///   search(query)       -> name search
///   getById(id)         -> one product (used by cart/wishlist/details)
/// ---------------------------------------------------------------------------
class ProductsProvider extends ChangeNotifier {
  ProductsProvider(this._repository);

  final ProductRepository _repository;

  // ----- state -----
  List<Product> _products = <Product>[];
  List<Category> _categories = <Category>[];
  bool _isLoading = false; // show spinner while the "API call" runs
  String? _error;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _products.isNotEmpty;

  /// Load the catalog. Called once from main() at app startup.
  Future<void> loadCatalog() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final CatalogSnapshot snapshot = await _repository.fetchCatalog();
      _products = snapshot.products;
      _categories = snapshot.categories;
    } catch (e) {
      _error = 'Could not load products: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Products belonging to one category (keeps catalog order).
  List<Product> productsIn(String categoryId) => _products
      .where((Product p) => p.categoryId == categoryId)
      .toList(growable: false);

  /// Simple name search (case-insensitive). Empty query -> all products.
  List<Product> search(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return _products;
    return _products
        .where((Product p) => p.name.toLowerCase().contains(q))
        .toList(growable: false);
  }

  /// Look up a single product by id (used by details / cart / wishlist).
  Product? getById(String id) {
    for (final Product p in _products) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// Category name for a product card, e.g. "Electronics".
  String? categoryNameOf(Product p) {
    for (final Category c in _categories) {
      if (c.id == p.categoryId) return c.name;
    }
    return null;
  }

  /// "Popular" = products rated 4.5 and above.
  List<Product> get popularProducts =>
      _products.where((Product p) => p.rating >= 4.5).toList(growable: false);
}
