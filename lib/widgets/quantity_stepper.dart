import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// QUANTITY STEPPER  [ -  2  + ]
/// Used on the product details screen and in the cart.
/// Demonstrates: a widget that takes values + callbacks instead of owning
/// state (state lives in the CartProvider, not here).
/// ---------------------------------------------------------------------------
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.compact = false,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color fill =
        theme.colorScheme.primary.withOpacity(compact ? 0.08 : 0.12);
    final Size buttonSize = compact ? const Size(30, 30) : const Size(38, 38);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _StepButton(
            icon: Icons.remove_rounded,
            size: buttonSize,
            onTap: quantity > 0 ? onDecrement : null,
          ),
          SizedBox(
            width: compact ? 30 : 40,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            size: buttonSize,
            onTap: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.size,
    required this.onTap,
  });

  final IconData icon;
  final Size size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Icon(icon, size: 18),
      ),
    );
  }
}
