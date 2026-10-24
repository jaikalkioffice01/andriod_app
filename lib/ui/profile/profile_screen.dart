import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/app_user.dart';
import '../../state/auth_provider.dart';
import '../../state/cart_provider.dart';
import '../../state/wishlist_provider.dart';
import '../../widgets/shop_card.dart';
import '../auth/login_screen.dart';

/// ---------------------------------------------------------------------------
/// PROFILE SCREEN (tab 5)
/// Shows the logged-in user, quick stats (cart/wishlist counts) and actions
/// (about dialog, logout). Logout returns to the Login screen.
/// ---------------------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AuthProvider auth = context.watch<AuthProvider>();
    final AppUser user =
        auth.user ?? const AppUser(name: 'Guest', email: '—');
    final int cartCount = context.watch<CartProvider>().itemCount;
    final int wishlistCount = context.watch<WishlistProvider>().count;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const SizedBox(height: 8),

          // ----- User card -----
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 34,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  user.initials,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.name,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      user.email,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ----- Stats row -----
          Row(
            children: <Widget>[
              _StatCard(icon: Icons.shopping_cart_rounded, label: 'Cart', value: '$cartCount'),
              const SizedBox(width: 12),
              _StatCard(icon: Icons.favorite_rounded, label: 'Wishlist', value: '$wishlistCount'),
              const SizedBox(width: 12),
              const _StatCard(icon: Icons.receipt_long_rounded, label: 'Orders', value: '0'),
            ],
          ),
          const SizedBox(height: 24),

          // ----- Action tiles -----
          _ActionTile(
            icon: Icons.info_outline_rounded,
            label: 'About this demo app',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: AppConstants.appName,
              applicationVersion: '1.0.0 (learning demo)',
              applicationIcon: const Icon(Icons.shopping_bag_rounded, size: 40),
              children: <Widget>[
                const Text(
                  'A Flutter e-commerce demo built to learn app structure: '
                  'Provider state management, repository pattern, '
                  'SharedPreferences persistence and navigation.\n\n'
                  'All data is dummy. No real payments or user data.',
                ),
              ],
            ),
          ),
          _ActionTile(
            icon: Icons.bolt_rounded,
            label: 'Login as demo account',
            subtitle:
                '${AppConstants.demoEmail} / ${AppConstants.demoPassword}',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'You are logged in as ${auth.user?.email ?? "guest"}. '
                    'Log out first, then use the demo button on the login screen.',
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // ----- Logout -----
          _ActionTile(
            icon: Icons.logout_rounded,
            label: 'Log out',
            destructive: true,
            onTap: () async {
              // Log out and go back to login (remove all routes).
              await context.read<AuthProvider>().logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),

          const SizedBox(height: 24),
          Text(
            'Made for learning Android app structure 💜',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Expanded(
      child: ShopCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: <Widget>[
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(height: 6),
              Text(
                value,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color =
        destructive ? theme.colorScheme.error : theme.colorScheme.onSurface;

    return ShopCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.w700, color: color),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
