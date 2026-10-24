import 'product.dart';

/// ---------------------------------------------------------------------------
/// CART ITEM MODEL
/// The cart does NOT store full copies of products. It only stores
/// "product id + quantity" and the UI looks up product details from the
/// catalog. This mirrors how real apps work (one source of truth).
/// ---------------------------------------------------------------------------
class CartItem {
  const CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  /// price x quantity for this line.
  double get lineTotal => product.price * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
        product: product,
        quantity: quantity ?? this.quantity,
      );
}
