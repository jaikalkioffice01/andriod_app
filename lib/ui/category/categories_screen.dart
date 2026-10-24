import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/category.dart';
import '../../state/products_provider.dart';
import '../../widgets/shop_card.dart';
import 'category_products_screen.dart';

/// ---------------------------------------------------------------------------
/// CATEGORIES SCREEN (tab 2)
/// A simple grid of all categories. Tapping one opens
/// [CategoryProductsScreen] with the chosen category (argument passing).
/// ---------------------------------------------------------------------------
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Category> categories =
        context.watch<ProductsProvider>().categories;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Shop by category',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${categories.length} categories in the demo catalog.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.outline),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.35,
              ),
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                final Category category = categories[index];
                return _CategoryTile(category: category);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // How many products does this category have?
    final int count =
        context.read<ProductsProvider>().productsIn(category.id).length;

    return ShopCard(
      color: Color(category.color),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CategoryProductsScreen(category: category),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(category.emoji, style: const TextStyle(fontSize: 34)),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            Text(
              '$count products',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.black.withOpacity(0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
