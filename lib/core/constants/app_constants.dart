/// ---------------------------------------------------------------------------
/// APP CONSTANTS
/// Every "magic string/number" lives here so screens stay clean and
/// you only have to change values in one place.
/// ---------------------------------------------------------------------------
class AppConstants {
  AppConstants._();

  // ----- App -----
  static const String appName = 'ShopKart';

  // ----- Demo login (pre-seeded account, always works) -----
  static const String demoEmail = 'demo@shopkart.com';
  static const String demoPassword = 'demo123';
  static const String demoUserName = 'Demo User';

  // ----- SharedPreferences keys (the "database table names") -----
  static const String prefsUsers = 'sk_users'; // registered users (JSON map)
  static const String prefsSession = 'sk_session'; // logged-in email
  static const String prefsCart = 'sk_cart'; // cart (JSON list)
  static const String prefsWishlist = 'sk_wishlist'; // wishlist (JSON list)
}
