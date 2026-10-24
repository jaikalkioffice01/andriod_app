import 'package:flutter/foundation.dart';

import '../data/models/product.dart';
import '../data/repositories/cart_wishlist_repository.dart';

/// ---------------------------------------------------------------------------
/// CART PROVIDER (state layer)
/// The cart is just a Map of  {productId: quantity}  kept in memory and
/// mirrored to SharedPreferences on every change (so it survives restarts).
///
/// Screens call:  addToCart(), increment(), decrement(), removeFromCart()
/// Screens read:  items, itemCount, totalAmount, quantityOf()
/// ---------------------------------------------------------------------------
class CartProvider extends ChangeNotifier {
  CartProvider(this._repository, this._productLookup);

  final CartWishlistRepository _repository;

  /// Function that resolves a product id -> Product (provided by
  /// ProductsProvider). Keeps cart logic decoupled from catalog logic.
  final Product? Function(String id) _productLookup;

  // ----- state -----
  final Map<String, int> _items = <String, int>{}; // productId -> quantity

  /// Unmodifiable view for the UI.
  Map<String, int> get items => Map<String, int>.unmodifiable(_items);

  /// Total number of UNITS in the cart (2 mugs + 1 shirt = 3). Used for badge.
  int get itemCount =>
      _items.values.fold(0, (int sum, int qty) => sum + qty);

  /// Number of distinct products in the cart.
  int get distinctCount => _items.length;

  /// Sum of all line totals.
  double get totalAmount {
    double total = 0;
    _items.forEach((String id, int qty) {
      final Product? product = _productLookup(id);
      if (product != null) total += product.price * qty;
    });
    return total;
  }

  /// Currently saved amount vs old prices (shows "You saved ₹X").
  double get totalSavings {
    double saved = 0;
    _items.forEach((String id, int qty) {
      final Product? product = _productLookup(id);
      if (product != null && product.hasDiscount) {
        saved += (product.oldPrice! - product.price) * qty;
      }
    });
    return saved;
  }

  int quantityOf(String productId) => _items[productId] ?? 0;

  bool get isEmpty => _items.isEmpty;

  // ----- actions -----

  /// Load the persisted cart. Called once at app startup.
  Future<void> loadCart() async {
    _items
      ..clear()
      ..addAll(_repository.loadCart());
    notifyListeners();
  }

  /// Add to cart (or +1 if already present).
  Future<void> addToCart(String productId, {int quantity = 1}) async {
    final int current = _items[productId] ?? 0;
    _items[productId] = current + quantity;
    await _persist();
  }

  /// Increase quantity by 1.
  Future<void> increment(String productId) =>
      addToCart(productId, quantity: 1);

  /// Decrease quantity by 1; removes the line if it reaches 0.
  Future<void> decrement(String productId) async {
    final int current = _items[productId] ?? 0;
    if (current <= 1) {
      await removeFromCart(productId);
      return;
    }
    _items[productId] = current - 1;
    await _persist();
  }

  Future<void> removeFromCart(String productId) async {
    _items.remove(productId);
    await _persist();
  }

  /// Called after a successful (demo) checkout.
  Future<void> clear() async {
    _items.clear();
    await _repository.clearCart();
    notifyListeners();
  }

  /// One place that updates storage + notifies listeners.
  Future<void> _persist() async {
    await _repository.saveCart(_items);
    notifyListeners();
  }
}
