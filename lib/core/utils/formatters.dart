/// ---------------------------------------------------------------------------
/// FORMATTING HELPERS
/// Tiny utility functions used across the UI.
/// ---------------------------------------------------------------------------
class Formatters {
  Formatters._();

  /// Currency symbol used across the demo app.
  static const String currency = '₹';

  /// 2499   ->  "₹2,499"
  /// 15999  ->  "₹15,999"
  /// (Indian numbering style: last 3 digits, then groups of 2.)
  static String price(double amount) {
    final String digits = amount.round().toString();
    return '$currency${_groupIndian(digits)}';
  }

  static String _groupIndian(String digits) {
    if (digits.length <= 3) return digits;

    final String last3 = digits.substring(digits.length - 3);
    String rest = digits.substring(0, digits.length - 3);

    final List<String> parts = <String>[];
    while (rest.length > 2) {
      parts.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) parts.insert(0, rest);

    return '${parts.join(',')},$last3';
  }

  /// Trim long text with an ellipsis: "A very long name…" (max chars).
  static String short(String text, {int max = 40}) {
    if (text.length <= max) return text;
    return '${text.substring(0, max)}…';
  }
}
