import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'ui/auth/login_screen.dart';
import 'ui/auth/signup_screen.dart';
import 'ui/shell/main_shell.dart';
import 'ui/splash/splash_screen.dart';

/// ---------------------------------------------------------------------------
/// SHOPKART APP - the root MaterialApp.
///
/// Defines the THEME and the ROUTE TABLE (map of screen-name -> screen).
/// Named routes make navigation readable:  Navigator.pushNamed('/login').
/// ---------------------------------------------------------------------------
class ShopKartApp extends StatelessWidget {
  const ShopKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false, // hide the red "debug" ribbon
      theme: AppTheme.light,

      // "/" is the first screen: a short splash, then it routes based on
      // whether a user session exists (see splash_screen.dart).
      initialRoute: SplashScreen.routeName,
      routes: <String, WidgetBuilder>{
        SplashScreen.routeName: (_) => const SplashScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        SignupScreen.routeName: (_) => const SignupScreen(),
        MainShell.routeName: (_) => const MainShell(),
      },
    );
  }
}
