import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/formatters.dart';
import '../../data/models/product.dart';
import '../../state/cart_provider.dart';
import '../../state/products_provider.dart';
import '../../state/wishlist_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/shop_card.dart';
import '../product/product_details_screen.dart';

/// ---------------------------------------------------------------------------
/// WISHLIST SCREEN (tab 4)
/// All hearted products. Each row can be:
///   - tapped -> product details
///   - "Move to cart" -> adds to cart AND removes from wishlist
///   - removed from the wishlist
/// ---------------------------------------------------------------------------
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final WishlistProvider wishlist = context.watch<WishlistProvider>();
    final ProductsProvider products = context.watch<ProductsProvider>();

    if (wishlist.isEmpty) {
      return const EmptyState(
        emoji: '💔',
        title: 'Your wishlist is empty',
        message: 'Tap the ❤ on any product to save it here.',
      );
    }

    // Resolve wishlist ids -> products (skip unknown ids defensively).
    final List<Product> items = <Product>[];
    for (final String id in wishlist.ids) {
      final Product? product = products.getById(id);
      if (product != null) items.add(product);
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'My wishlist ❤️ (${items.length})',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (BuildContext context, int index) {
                final Product product = items[index];
                return _WishlistTile(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WishlistTile extends StatelessWidget {
  const _WishlistTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ShopCard(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ProductDetailsScreen(product: product),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(product.emoji, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 12),
              Expanded(
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
                    Text(
                      Formatters.price(product.price),
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              // Move to cart
              IconButton(
                tooltip: 'Move to cart',
                icon: const Icon(Icons.add_shopping_cart_rounded),
                color: theme.colorScheme.primary,
                onPressed: () async {
                  await context.read<CartProvider>().addToCart(product.id);
                  await context.read<WishlistProvider>().remove(product.id);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text('${product.name} moved to cart 🛒'),
                      duration: const Duration(milliseconds: 900),
                    ));
                },
              ),
              // Remove from wishlist
              IconButton(
                tooltip: 'Remove',
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: theme.colorScheme.error,
                ),
                onPressed: () =>
                    context.read<WishlistProvider>().remove(product.id),
              ),
            ],
          ),
        ),
    );
  }
}