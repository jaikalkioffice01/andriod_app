import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/cart_provider.dart';
import '../cart/cart_screen.dart';
import '../category/categories_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../wishlist/wishlist_screen.dart';

/// ---------------------------------------------------------------------------
/// MAIN SHELL - the "logged in" part of the app.
///
/// Holds a NavigationBar (bottom tabs) and an IndexedStack.
/// IndexedStack keeps all 5 tab screens alive (state preserved) and just
/// shows one at a time. This pattern = "single activity, multiple tabs".
/// ---------------------------------------------------------------------------
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  static const String routeName = '/home';

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0; // which tab is selected
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    // Built ONCE. IndexedStack keeps all 5 screens alive, so their scroll
    // positions and local state survive tab switches.
    // Home gets a callback so its "See all" button can switch to tab 2.
    _tabs = <Widget>[
      HomeScreen(onOpenCategoriesTab: () => setState(() => _currentIndex = 1)),
      const CategoriesScreen(),
      const CartScreen(),
      const WishlistScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // watch() -> the shell rebuilds (badge updates) when the cart changes.
    final int cartCount = context.watch<CartProvider>().itemCount;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) =>
            setState(() => _currentIndex = index),
        destinations: <Widget>[
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_cart_rounded),
            ),
            label: 'Cart',
          ),
          const NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Wishlist',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
