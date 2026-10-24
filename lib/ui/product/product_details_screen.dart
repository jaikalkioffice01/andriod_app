import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/product.dart';
import '../../state/cart_provider.dart';
import '../../state/products_provider.dart';
import '../../state/wishlist_provider.dart';
import '../../widgets/quantity_stepper.dart';

/// ---------------------------------------------------------------------------
/// PRODUCT DETAILS SCREEN
/// Full info about ONE product + actions (quantity, add to cart, wishlist).
///
/// Demonstrates:
///  - receiving an object through the constructor
///  - Hero animation (the emoji "image" flies in from the card)
///  - reading the cart quantity for THIS product (quantityOf)
/// ---------------------------------------------------------------------------
class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1; // local quantity chosen on this screen

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Product product = widget.product;

    // How many of this product are already in the cart?
    final int inCart = context.watch<CartProvider>().quantityOf(product.id);
    final bool wishlisted =
        context.watch<WishlistProvider>().isWishlisted(product.id);
    final String? categoryName =
        context.read<ProductsProvider>().categoryNameOf(product);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              wishlisted
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: wishlisted ? const Color(0xFFE91E63) : null,
            ),
            onPressed: () async {
              await context.read<WishlistProvider>().toggle(product.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(
                      wishlisted
                          ? 'Removed from wishlist 💔'
                          : 'Added to wishlist ❤️',
                    ),
                    duration: const Duration(milliseconds: 900),
                  ));
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ----- Big "image" (emoji) with Hero animation -----
            Center(
              child: Hero(
                tag: 'product-${product.id}',
                child: Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  alignment: Alignment.center,
                  child: Text(product.emoji,
                      style: const TextStyle(fontSize: 110)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ----- Category + rating row -----
            Row(
              children: <Widget>[
                if (categoryName != null) ...<Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categoryName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                const Icon(Icons.star_rounded,
                    size: 18, color: Color(0xFFFFB300)),
                const SizedBox(width: 4),
                Text(
                  '${product.rating} · ${product.reviewCount} reviews',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ----- Name + price -----
            Text(
              product.name,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  Formatters.price(product.price),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
                if (product.hasDiscount) ...<Widget>[
                  const SizedBox(width: 10),
                  Text(
                    Formatters.price(product.oldPrice!),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.outline,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${product.discountPercent}% OFF',
                      style: TextStyle(
                        color: AppTheme.accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // ----- Description -----
            Text(
              'Description',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),

            // ----- Quantity selector -----
            Row(
              children: <Widget>[
                Text(
                  'Quantity',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                QuantityStepper(
                  quantity: _quantity,
                  onIncrement: () => setState(() => _quantity++),
                  onDecrement: () =>
                      setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1),
                ),
              ],
            ),
            if (inCart > 0) ...<Widget>[
              const SizedBox(height: 10),
              Text(
                '🛒 $inCart already in your cart',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
            ],
            const SizedBox(height: 100), // space above bottom bar
          ],
        ),
      ),

      // ----- Bottom action bar -----
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton.icon(
            onPressed: () async {
              await context
                  .read<CartProvider>()
                  .addToCart(product.id, quantity: _quantity);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                        '$_quantity × ${product.name} added to cart 🛒'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              setState(() => _quantity = 1);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add_shopping_cart_rounded),
            label: Text(
              'Add to cart · ${Formatters.price(product.price * _quantity)}',
            ),
          ),
        ),
      ),
    );
  }
}
