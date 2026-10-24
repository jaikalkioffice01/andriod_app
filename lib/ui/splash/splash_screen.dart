import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../state/auth_provider.dart';
import '../auth/login_screen.dart';
import '../shell/main_shell.dart';

/// ---------------------------------------------------------------------------
/// SPLASH SCREEN
/// Shown for ~1.6 seconds while the app "warms up". Then it checks the auth
/// state and routes to:
///   - MainShell (home)  if a session exists (user already logged in)
///   - LoginScreen       otherwise
/// ---------------------------------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _routeAfterDelay();
  }

  Future<void> _routeAfterDelay() async {
    // Give the splash a moment, and let AuthProvider finish restoring
    // the session from SharedPreferences.
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return; // widget may have been disposed while waiting

    final AuthProvider auth = context.read<AuthProvider>();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) =>
            auth.isLoggedIn ? const MainShell() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // "Logo": shopping bag icon inside a rounded brand-colored box.
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppConstants.appName,
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'A demo e-commerce app for learning',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.outline),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
