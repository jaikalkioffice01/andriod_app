import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// APP THEME
/// Central place for all colors, fonts and theme configuration.
/// Keeping this in ONE file means you can re-skin the whole app from here.
/// ---------------------------------------------------------------------------
class AppTheme {
  AppTheme._(); // No instances - only static config.

  /// The single "brand" color. Material 3 generates a full color scheme
  /// (primary, surface, onPrimary...) automatically from this seed.
  static const Color seedColor = Color(0xFF5B4FE9); // Indigo/violet

  static const Color accentColor = Color(0xFFFF6B35); // Orange (CTAs, badges)

  /// Build the light Material 3 theme for the whole app.
  static ThemeData get light {
    final ColorScheme scheme = ColorScheme.fromSeed(seedColor: seedColor);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF7F7FB),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFFF7F7FB),
        foregroundColor: Color(0xFF1B1B2F),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: seedColor,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE4E4F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE4E4F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
      ),
      // NOTE: Cards are styled by the reusable ShopCard widget
      // (lib/widgets/shop_card.dart) instead of ThemeData.cardTheme,
      // because the cardTheme parameter type changed across Flutter
      // versions (CardTheme -> CardThemeData) and would break builds
      // on some SDK versions.
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: scheme.primary.withOpacity(0.14),
        height: 68,
      ),
    );
  }
}
