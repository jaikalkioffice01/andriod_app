import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/cart_wishlist_repository.dart';
import 'data/repositories/product_repository.dart';
import 'state/auth_provider.dart';
import 'state/cart_provider.dart';
import 'state/products_provider.dart';
import 'state/wishlist_provider.dart';

/// ---------------------------------------------------------------------------
/// MAIN - the entry point of the whole app.
///
/// 1. Make sure Flutter bindings are ready (needed before using plugins).
/// 2. Load SharedPreferences (the tiny local "database").
/// 3. Create all Providers (the app's state) ONCE, above MaterialApp.
/// 4. Run the app.
///
/// Everything below `MultiProvider` can read any provider with:
///   context.watch<T>()  /  context.read<T>()
/// ---------------------------------------------------------------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // plugin code needs this

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(buildApp(prefs));
}

/// Builds the provider tree + MaterialApp.
/// It is a top-level function (not inside main) so that TESTS can build
/// exactly the same tree with mock preferences.
Widget buildApp(SharedPreferences prefs) {
  return MultiProvider(
    providers: <ChangeNotifierProvider<ChangeNotifier>>[
      // ----- Auth: session restore happens right after construction -----
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => AuthProvider(AuthRepository(prefs))..restoreSession(),
      ),
      // ----- Catalog: loads the 20 products + 6 categories -----
      ChangeNotifierProvider<ProductsProvider>(
        create: (_) => ProductsProvider(ProductRepository())..loadCatalog(),
      ),
      // ----- Cart & wishlist: depend on product lookup for totals -----
      ChangeNotifierProvider<CartProvider>(
        create: (BuildContext context) => CartProvider(
          CartWishlistRepository(prefs),
          context.read<ProductsProvider>().getById, // id -> Product resolver
        )..loadCart(),
      ),
      ChangeNotifierProvider<WishlistProvider>(
        create: (_) =>
            WishlistProvider(CartWishlistRepository(prefs))..loadWishlist(),
      ),
    ],
    child: const ShopKartApp(),
  );
}
