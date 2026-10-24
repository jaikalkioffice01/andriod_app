import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/product.dart';
import '../../state/cart_provider.dart';
import '../../state/products_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/quantity_stepper.dart';
import '../../widgets/shop_card.dart';

/// ---------------------------------------------------------------------------
/// CART SCREEN (tab 3)
/// Lists every cart line with a quantity stepper, shows a bill summary and
/// a (fake) checkout that clears the cart.
///
/// Demonstrates: combining TWO providers (cart ids + catalog products),
/// computing derived values (totals) in the UI layer.
/// ---------------------------------------------------------------------------
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CartProvider cart = context.watch<CartProvider>();
    final ProductsProvider products = context.watch<ProductsProvider>();

    // Empty cart -> friendly placeholder.
    if (cart.isEmpty) {
      return const EmptyState(
        emoji: '🛒',
        title: 'Your cart is empty',
        message: 'Browse the catalog and add some products!',
      );
    }

    // Build cart lines: (product, quantity) pairs.
    final List<CartItemLine> lines = <CartItemLine>[];
    cart.items.forEach((String productId, int qty) {
      final Product? product = products.getById(productId);
      if (product != null) lines.add(CartItemLine(product, qty));
    });

    return Column(
      children: <Widget>[
        // ----- Product list -----
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            itemCount: lines.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) =>
                _CartTile(line: lines[index]),
          ),
        ),

        // ----- Bill summary -----
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _SummaryRow(
                  label: 'Items (${cart.itemCount})',
                  value: Formatters.price(cart.totalAmount),
                ),
                const SizedBox(height: 6),
                const _SummaryRow(label: 'Delivery', value: 'FREE'),
                if (cart.totalSavings > 0) ...<Widget>[
                  const SizedBox(height: 6),
                  _SummaryRow(
                    label: 'You saved',
                    value: '- ${Formatters.price(cart.totalSavings)}',
                    valueColor: const Color(0xFF2E7D32),
                  ),
                ],
                const Divider(height: 20),
                _SummaryRow(
                  label: 'Total',
                  value: Formatters.price(cart.totalAmount),
                  bold: true,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.verified_rounded),
                  label: const Text('Place order (demo)'),
                  onPressed: () => _checkout(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Fake checkout: confirm dialog -> clear cart -> success snackbar.
  Future<void> _checkout(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Place order?'),
        content: const Text(
          'This is a demo app — no payment happens and no real order is '
          'placed. Your cart will be cleared.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Place order'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await context.read<CartProvider>().clear();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎉 Order placed! (demo only)')),
    );
  }
}

/// Helper pair used while building the list (product + its quantity).
class CartItemLine {
  const CartItemLine(this.product, this.quantity);

  final Product product;
  final int quantity;

  /// Total price for this cart line: unit price x quantity.
  double get lineTotal => product.price * quantity;
}

/// One cart row: emoji, name, unit price, stepper, line total, delete.
class _CartTile extends StatelessWidget {
  const _CartTile({required this.line});

  final CartItemLine line;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CartProvider cart = context.read<CartProvider>();

    return ShopCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            // emoji "image"
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(line.product.emoji,
                  style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 12),

            // name + unit price + stepper
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    line.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${Formatters.price(line.product.price)} each',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                  const SizedBox(height: 8),
                  QuantityStepper(
                    compact: true,
                    quantity: line.quantity,
                    onIncrement: () => cart.increment(line.product.id),
                    onDecrement: () => cart.decrement(line.product.id),
                  ),
                ],
              ),
            ),

            // line total + remove button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  Formatters.price(line.lineTotal),
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: theme.colorScheme.error,
                  ),
                  onPressed: () => cart.removeFromCart(line.product.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle style = bold
        ? theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w800)
        : theme.textTheme.bodyMedium!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(label, style: style),
        Text(value, style: style.copyWith(color: valueColor)),
      ],
    );
  }
}
