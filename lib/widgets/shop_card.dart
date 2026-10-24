import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// SHOP CARD - the app's standard card container.
///
/// Why does this exist instead of ThemeData(cardTheme: ...)?
/// Flutter changed the type of ThemeData.cardTheme across versions
/// (CardTheme -> CardThemeData), which breaks old OR new SDKs depending on
/// which one you use. Styling a shared WIDGET instead is version-proof -
/// and it is a good pattern anyway: one place defines the look.
///
/// Use it like a Card:
///   ShopCard(child: Text('hi'))
///   ShopCard(onTap: ..., child: ...)   // adds ripple + clipped corners
/// ---------------------------------------------------------------------------
class ShopCard extends StatelessWidget {
  const ShopCard({
    super.key,
    required this.child,
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.color,
    this.borderRadius = 16,
  });

  final Widget child;
  final EdgeInsetsGeometry margin;

  /// When set, the whole card becomes tappable (with ripple).
  final VoidCallback? onTap;

  /// Override the background color (e.g. colored category tiles).
  final Color? color;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(borderRadius);

    Widget content = child;
    if (onTap != null) {
      content = InkWell(borderRadius: radius, onTap: onTap, child: content);
    }

    return Card(
      color: color ?? Colors.white,
      elevation: 0,
      margin: margin,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(
          color: color == null
              ? const Color(0xFFECECF4) // hairline border for white cards
              : Colors.transparent,
        ),
      ),
      child: content,
    );
  }
}
