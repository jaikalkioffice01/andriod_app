import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/category.dart';
import '../../data/models/product.dart';
import '../../state/products_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_card.dart';

/// ---------------------------------------------------------------------------
/// CATEGORY PRODUCTS SCREEN
/// Shows all products of ONE category as a grid.
/// Demonstrates: passing an object (the category) to a new screen via the
/// constructor, then reading derived data from a provider.
/// ---------------------------------------------------------------------------
class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ProductsProvider products = context.watch<ProductsProvider>();
    final List<Product> items = products.productsIn(category.id);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(category.emoji),
            const SizedBox(width: 8),
            Text(category.name),
          ],
        ),
      ),
      body: items.isEmpty
          ? const EmptyState(
              emoji: '📦',
              title: 'Nothing here yet',
              message: 'This category has no products in the demo data.',
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) =>
                  ProductCard(product: items[index]),
            ),
    );
  }
}
