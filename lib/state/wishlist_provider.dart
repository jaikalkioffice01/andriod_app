import 'package:flutter/foundation.dart';

import '../data/repositories/cart_wishlist_repository.dart';

/// ---------------------------------------------------------------------------
/// WISHLIST PROVIDER (state layer)
/// The wishlist is just a Set of product ids the user "hearted".
/// Mirrored to SharedPreferences on every change.
/// ---------------------------------------------------------------------------
class WishlistProvider extends ChangeNotifier {
  WishlistProvider(this._repository);

  final CartWishlistRepository _repository;

  // ----- state -----
  final Set<String> _ids = <String>{};

  Set<String> get ids => Set<String>.unmodifiable(_ids);
  bool get isEmpty => _ids.isEmpty;
  int get count => _ids.length;

  bool isWishlisted(String productId) => _ids.contains(productId);

  // ----- actions -----

  /// Load persisted wishlist. Called once at app startup.
  Future<void> loadWishlist() async {
    _ids
      ..clear()
      ..addAll(_repository.loadWishlist());
    notifyListeners();
  }

  /// Toggle: heart it if not hearted, un-heart if already hearted.
  Future<void> toggle(String productId) async {
    if (!_ids.remove(productId)) {
      _ids.add(productId);
    }
    await _repository.saveWishlist(_ids);
    notifyListeners();
  }

  Future<void> remove(String productId) async {
    if (_ids.remove(productId)) {
      await _repository.saveWishlist(_ids);
      notifyListeners();
    }
  }
}
