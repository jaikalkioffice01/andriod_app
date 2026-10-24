import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopkart/main.dart';

/// ---------------------------------------------------------------------------
/// WIDGET TEST - builds the REAL app (with an in-memory fake
/// SharedPreferences) and simulates a full user journey:
///
///   splash -> login screen -> tap "Use demo account"
///   -> home loads with all 20 products -> add to cart -> badge shows 1
///
/// Run with:  flutter test
///
/// How it works:
///   tester.pumpWidget()  = "build the app"
///   tester.pump(time)    = "advance the clock & rebuild" (runs timers)
///   tester.tap()         = "the user tapped here"
///   expect(...)          = "the UI should show this"
/// ---------------------------------------------------------------------------
void main() {
  testWidgets('demo login -> catalog -> add to cart', (WidgetTester tester) async {
    // Fake SharedPreferences: nothing is written to disk in tests.
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Build the whole app (splash is the first screen).
    await tester.pumpWidget(buildApp(prefs));

    // ----- Splash routes after its 1.6 s delay -----
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back 👋'), findsOneWidget);

    // ----- One-tap demo login (has a 600 ms fake "API call") -----
    await tester.tap(find.text('Use demo account'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // ----- Home screen: greeting + full catalog loaded -----
    expect(find.text('Hi, Demo 👋'), findsOneWidget);
    expect(find.text('All products (20)'), findsOneWidget);

    // ----- Tap the "+" on the first product card -----
    await tester.tap(find.byIcon(Icons.add_rounded).first);
    await tester.pump(const Duration(milliseconds: 200)); // snackbar appears
    expect(find.textContaining('added to cart'), findsOneWidget);

    // Let the snackbar finish, then check the cart badge in the bottom bar.
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('1'), findsOneWidget); // the badge on the Cart tab
  });
}
