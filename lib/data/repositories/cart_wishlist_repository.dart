import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';

/// ---------------------------------------------------------------------------
/// CART + WISHLIST REPOSITORY (data layer)
/// Persists the cart and wishlist as small JSON lists in SharedPreferences:
///
///   cart     -> [ {"id": "p1", "qty": 2}, {"id": "p7", "qty": 1} ]
///   wishlist -> [ "p1", "p14" ]
///
/// We store only product IDs. Product details always come from the catalog
/// (single source of truth) - exactly like a real backend cart API.
/// ---------------------------------------------------------------------------
class CartWishlistRepository {
  CartWishlistRepository(this._prefs);

  final SharedPreferences _prefs;

  // ---------------- CART ----------------

  /// Returns the saved cart as  {productId: quantity}.
  Map<String, int> loadCart() {
    final String? raw = _prefs.getString(AppConstants.prefsCart);
    if (raw == null || raw.isEmpty) return <String, int>{};

    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    final Map<String, int> result = <String, int>{};
    for (final dynamic entry in list) {
      final Map<String, dynamic> map = entry as Map<String, dynamic>;
      result[map['id'] as String] = map['qty'] as int;
    }
    return result;
  }

  Future<void> saveCart(Map<String, int> items) async {
    final List<Map<String, dynamic>> list = items.entries
        .map((MapEntry<String, int> e) =>
            <String, dynamic>{'id': e.key, 'qty': e.value})
        .toList();
    await _prefs.setString(AppConstants.prefsCart, jsonEncode(list));
  }

  // ---------------- WISHLIST ----------------

  /// Returns the saved wishlist as a Set of product ids.
  Set<String> loadWishlist() {
    final String? raw = _prefs.getString(AppConstants.prefsWishlist);
    if (raw == null || raw.isEmpty) return <String>{};
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list.cast<String>().toSet();
  }

  Future<void> saveWishlist(Set<String> ids) async {
    await _prefs.setString(AppConstants.prefsWishlist, jsonEncode(ids.toList()));
  }

  // ---------------- CHECKOUT ----------------

  /// Clears both cart & wishlist after a (demo) order is placed.
  Future<void> clearCart() => _prefs.remove(AppConstants.prefsCart);
}
