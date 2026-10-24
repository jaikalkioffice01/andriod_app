import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopkart/data/dummy_data.dart';
import 'package:shopkart/data/models/app_user.dart';
import 'package:shopkart/data/models/cart_item.dart';
import 'package:shopkart/data/models/category.dart';
import 'package:shopkart/data/models/product.dart';

/// ---------------------------------------------------------------------------
/// UNIT TESTS - the data & model layer, no UI involved.
///
/// These run with:  flutter test
/// They prove the "business logic" works: models compute correct values and
/// the dummy catalog is consistent (every product points at a real category).
/// ---------------------------------------------------------------------------
void main() {
  group('Product model', () {
    test('computes discount percent correctly', () {
      final Product p = Product(
        id: 't1',
        name: 'Test',
        description: 'x',
        price: 700,
        oldPrice: 1000,
        rating: 4,
        reviewCount: 1,
        categoryId: 'c1',
        emoji: '🎯',
      );
      expect(p.hasDiscount, isTrue);
      expect(p.discountPercent, 30); // (1000-700)/1000 = 30%
    });

    test('no discount when oldPrice is missing or lower', () {
      final Product p = Product(
        id: 't2',
        name: 'Test',
        description: 'x',
        price: 500,
        oldPrice: 300, // old price LOWER than current -> not a discount
        rating: 4,
        reviewCount: 1,
        categoryId: 'c1',
        emoji: '🎯',
      );
      expect(p.hasDiscount, isFalse);
      expect(p.discountPercent, 0);
    });

    test('json round-trip keeps all fields', () {
      final Product p = DummyData.products.first;
      final Product copy = Product.fromJson(p.toJson());
      expect(copy.id, p.id);
      expect(copy.name, p.name);
      expect(copy.price, p.price);
      expect(copy.oldPrice, p.oldPrice);
      expect(copy.rating, p.rating);
    });
  });

  group('Cart item model', () {
    test('line total = price x quantity', () {
      final CartItem item = CartItem(
        product: DummyData.products.first,
        quantity: 3,
      );
      expect(item.lineTotal, DummyData.products.first.price * 3);
    });
  });

  group('App user model', () {
    test('initials from full name', () {
      const AppUser user = AppUser(name: 'Demo User', email: 'd@d.com');
      expect(user.initials, 'DU');
    });

    test('initials from single name', () {
      const AppUser user = AppUser(name: 'Ravi', email: 'r@r.com');
      expect(user.initials, 'R');
    });
  });

  group('Dummy catalog', () {
    test('has exactly 20 products and 6 categories', () {
      expect(DummyData.products.length, 20);
      expect(DummyData.categories.length, 6);
    });

    test('every product points to an existing category', () {
      final Set<String> categoryIds =
          DummyData.categories.map((Category c) => c.id).toSet();
      for (final Product p in DummyData.products) {
        expect(categoryIds, contains(p.categoryId),
            reason: '${p.name} has unknown category ${p.categoryId}');
      }
    });

    test('product ids are unique', () {
      final Set<String> ids = DummyData.products.map((Product p) => p.id).toSet();
      expect(ids.length, DummyData.products.length);
    });

    test('all prices are positive', () {
      for (final Product p in DummyData.products) {
        expect(p.price, greaterThan(0), reason: p.name);
      }
    });
  });

  group('SharedPreferences mock', () {
    test('starts empty (used by repos in widget tests)', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('sk_session'), isNull);
    });
  });
}
