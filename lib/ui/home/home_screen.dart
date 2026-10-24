import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/category.dart';
import '../../data/models/product.dart';
import '../../state/auth_provider.dart';
import '../../state/products_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_header.dart';
import '../category/category_products_screen.dart';

/// ---------------------------------------------------------------------------
/// HOME SCREEN (tab 1)
/// Shows:
///   - greeting with the logged-in user's name
///   - a live search box (filters the product grid as you type)
///   - horizontal category chips
///   - "Popular" products row + full product grid
///
/// Demonstrates: reading MULTIPLE providers, local (ephemeral) UI state via
/// setState, loading & error handling.
/// ---------------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onOpenCategoriesTab});

  /// Callback the MainShell passes in, so "See all" can switch to the
  /// Categories tab. (Child -> parent communication via callbacks.)
  final VoidCallback? onOpenCategoriesTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // ----- read providers -----
    final ProductsProvider products = context.watch<ProductsProvider>();
    final String userName =
        context.watch<AuthProvider>().user?.name ?? 'there';

    // ----- loading state -----
    if (products.isLoading && !products.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    // ----- error state -----
    if (products.error != null && !products.hasData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('😱', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(products.error!),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.read<ProductsProvider>().loadCatalog(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // ----- filtered data (search) -----
    final List<Category> categories = products.categories;
    final List<Product> visibleProducts =
        _query.isEmpty ? products.products : products.search(_query);

    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          // ----- Header + search box (scrolls away with the list) -----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Hi, ${userName.split(' ').first} 👋',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find something you love.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    onChanged: (String value) =>
                        setState(() => _query = value), // live filter
                    decoration: InputDecoration(
                      hintText: 'Search products…',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ----- Categories (horizontal chips) -----
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'Categories',
                  actionLabel: 'See all',
                  onAction: widget.onOpenCategoriesTab, // switch to tab 2
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 92,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (BuildContext context, int index) =>
                        _CategoryChip(category: categories[index]),
                  ),
                ),
              ],
            ),
          ),

          // ----- Popular products (horizontal cards) -----
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                const SectionHeader(title: 'Popular 🔥'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: products.popularProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (BuildContext context, int index) => SizedBox(
                      width: 150,
                      child:
                          ProductCard(product: products.popularProducts[index]),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ----- All products grid (or search results) -----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: SectionHeader(
                title: _query.isEmpty
                    ? 'All products (${products.products.length})'
                    : 'Results for "$_query"',
              ),
            ),
          ),
          if (visibleProducts.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptySearchPlaceholder(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) =>
                      ProductCard(product: visibleProducts[index]),
                  childCount: visibleProducts.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// One category chip in the horizontal row. Tapping it opens the
/// category's product list screen (pushed on top of the shell).
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CategoryProductsScreen(category: category),
        ),
      ),
      child: Container(
        width: 76,
        decoration: BoxDecoration(
          color: Color(category.color),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(category.emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when a search finds nothing.
class EmptySearchPlaceholder extends StatelessWidget {
  const EmptySearchPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('🔍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'No products found.\nTry a different search.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}
