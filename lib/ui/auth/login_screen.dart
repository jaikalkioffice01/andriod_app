import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../state/auth_provider.dart';
import '../shell/main_shell.dart';
import 'signup_screen.dart';

/// ---------------------------------------------------------------------------
/// LOGIN SCREEN
/// Demonstrates:
///  - Form + GlobalKey<FormState> + validators (input validation)
///  - TextEditingControllers (reading field values)
///  - Calling a provider method and reacting to its result
///  - "Demo login" - one tap fills & logs in with the demo account
/// ---------------------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Always dispose controllers to free resources.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Validate all form fields first.
    if (!_formKey.currentState!.validate()) return;

    final AuthProvider auth = context.read<AuthProvider>();
    final bool ok = await auth.login(
      _emailController.text,
      _passwordController.text,
    );
    if (!mounted) return;

    if (ok) {
      // Go to home and remove login from the back stack.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const MainShell()),
        (Route<dynamic> route) => false,
      );
    } else {
      // Show the error message the provider received from the repository.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Login failed'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  /// One-tap demo login: fill the fields and submit.
  Future<void> _loginAsDemo() async {
    setState(() {
      _emailController.text = AppConstants.demoEmail;
      _passwordController.text = AppConstants.demoPassword;
    });
    await _submit();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool busy = context.watch<AuthProvider>().busy;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey, // enables form-wide validation
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // ----- Header -----
                  Container(
                    width: 72,
                    height: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome back 👋',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Log in to continue shopping.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                  const SizedBox(height: 28),

                  // ----- Email field -----
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.alternate_email_rounded),
                    ),
                    validator: (String? value) {
                      final String email = value?.trim() ?? '';
                      if (email.isEmpty) return 'Please enter your email';
                      final RegExp emailRegex =
                          RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
                      if (!emailRegex.hasMatch(email)) {
                        return 'That does not look like a valid email';
                      }
                      return null; // null = valid
                    },
                  ),
                  const SizedBox(height: 14),

                  // ----- Password field -----
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword, // dots instead of letters
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // ----- Login button -----
                  FilledButton(
                    onPressed: busy ? null : _submit, // disabled while busy
                    child: busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Log in'),
                  ),
                  const SizedBox(height: 12),

                  // ----- Demo login button -----
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: BorderSide(color: theme.colorScheme.primary),
                    ),
                    onPressed: busy ? null : _loginAsDemo,
                    icon: const Icon(Icons.bolt_rounded),
                    label: const Text('Use demo account'),
                  ),

                  const SizedBox(height: 24),

                  // ----- Go to signup -----
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account? ",
                        style: theme.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed(SignupScreen.routeName),
                        child: Text(
                          'Sign up',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Demo credentials\n'
                    'email: ${AppConstants.demoEmail}\n'
                    'password: ${AppConstants.demoPassword}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.outline, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
