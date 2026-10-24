import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/formatters.dart';
import '../data/models/product.dart';
import '../state/cart_provider.dart';
import '../state/wishlist_provider.dart';
import '../ui/product/product_details_screen.dart';
import 'shop_card.dart';

/// ---------------------------------------------------------------------------
/// PRODUCT CARD
/// The tile used in every product grid (home, category, search results).
/// Demonstrates:
///  - context.watch (rebuild when cart/wishlist change)
///  - navigation with MaterialPageRoute
///  - computed model getters (hasDiscount, discountPercent)
/// ---------------------------------------------------------------------------
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // watch() = rebuild this card when wishlist state changes (heart fill).
    final bool wishlisted =
        context.watch<WishlistProvider>().isWishlisted(product.id);

    return ShopCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ProductDetailsScreen(product: product),
        ),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // ----- "Image" area (emoji on tinted background) -----
            Stack(
              children: <Widget>[
                Container(
                  height: 110,
                  color: theme.colorScheme.primary.withOpacity(0.06),
                  alignment: Alignment.center,
                  child:
                      Text(product.emoji, style: const TextStyle(fontSize: 44)),
                ),
                if (product.hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${product.discountPercent}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                // Heart (wishlist toggle)
                Positioned(
                  top: 2,
                  right: 2,
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      wishlisted
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: wishlisted
                          ? const Color(0xFFE91E63)
                          : theme.colorScheme.outline,
                      size: 20,
                    ),
                    onPressed: () => context
                        .read<WishlistProvider>()
                        .toggle(product.id),
                  ),
                ),
              ],
            ),

            // ----- Text + price + actions -----
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.star_rounded,
                            size: 14, color: Color(0xFFFFB300)),
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating} (${product.reviewCount})',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                Formatters.price(product.price),
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (product.hasDiscount)
                                Text(
                                  Formatters.price(product.oldPrice!),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.outline,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        _AddButton(product: product),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}

/// Small round "+" button that adds the product to the cart.
class _AddButton extends StatelessWidget {
  const _AddButton({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: 34,
      height: 34,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          backgroundColor: theme.colorScheme.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () async {
          // read() = call an action WITHOUT rebuilding on changes.
          await context.read<CartProvider>().addToCart(product.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to cart 🛒'),
                  duration: const Duration(milliseconds: 900),
                ),
              );
          }
        },
        child: const Icon(Icons.add_rounded, size: 20),
      ),
    );
  }
}

