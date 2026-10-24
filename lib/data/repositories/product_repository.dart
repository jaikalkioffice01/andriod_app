import '../models/category.dart';
import '../models/product.dart';
import '../dummy_data.dart';

/// ---------------------------------------------------------------------------
/// PRODUCT REPOSITORY (data layer)
/// Knows WHERE product data comes from and hides that from the rest of the
/// app. Today it returns DummyData after a fake 800 ms "network" delay
/// (so you can SEE loading spinners). Tomorrow you could swap the body of
/// fetchCatalog() with a real http.get() call - nothing else would change.
/// ---------------------------------------------------------------------------
class CatalogSnapshot {
  const CatalogSnapshot({required this.categories, required this.products});

  final List<Category> categories;
  final List<Product> products;
}

class ProductRepository {
  /// Simulates fetching the whole catalog (categories + products).
  Future<CatalogSnapshot> fetchCatalog() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return CatalogSnapshot(
      categories: DummyData.categories,
      products: DummyData.products,
    );
  }
}
