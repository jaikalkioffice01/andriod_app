# 🛒 ShopKart — Learn Android App Structure by Building

A **complete e-commerce demo app** built with **Flutter (Dart)** for Android.
Its #1 goal is to teach you **how a real app is structured** — every file is
heavily commented and follows the same layering used in production apps.

> ✅ 20 dummy products · 6 categories · Login / Signup (+ one-tap demo login)
> ✅ Product details · Cart with quantities & bill · Wishlist · Search
> ✅ Everything persists on the device (survives app restarts)

---

## 1. Run it

```bash
# Prerequisite: Flutter SDK installed  (https://docs.flutter.dev/get-started/install)
cd shopkart            # this repository
flutter pub get        # downloads the 2 dependencies
flutter run            # run on an Android emulator or USB device
flutter test           # run the unit + widget tests
```

**Demo login:** tap **“Use demo account”**, or manually
`demo@shopkart.com` / `demo123`. Or create your own account via **Sign up**
(accounts are stored only on your device — nothing is sent anywhere).

---

## 2. The big picture (read this first!)

The app is split into **4 layers**. Data flows **one way**:

```
┌─────────────────────────────────────────────────────────────┐
│  UI LAYER            lib/ui/…  +  lib/widgets/…             │
│  Screens & reusable widgets. DUMB: they only display state   │
│  and call provider methods.                                  │
└──────────────────────────┬──────────────────────────────────┘
                           │ watch() reads state · read() calls actions
┌──────────────────────────▼──────────────────────────────────┐
│  STATE LAYER        lib/state/…   (Provider + ChangeNotifier)│
│  AuthProvider · ProductsProvider · CartProvider ·            │
│  WishlistProvider — the "brains" between UI and data.        │
└──────────────────────────┬──────────────────────────────────┘
                           │ method calls
┌──────────────────────────▼──────────────────────────────────┐
│  DATA LAYER         lib/data/…                               │
│  repositories/ — the ONLY place that knows where data lives  │
│  (here: dummy lists + SharedPreferences).                    │
│  models/ — plain data classes (Product, Category, AppUser…)  │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│  CORE                lib/core/…                              │
│  theme/ (colors & styles) · constants/ (keys, demo account)  │
│  utils/ (helpers like ₹ formatting)                          │
└─────────────────────────────────────────────────────────────┘
```

**Why layers?** Tomorrow, if you replace the dummy data with a real REST API,
you only rewrite the **repositories**. Not a single screen changes.
That is the whole point of app architecture.

---

## 3. Every file explained

```
lib/
├── main.dart                  ← APP ENTRY POINT
│   Loads SharedPreferences, creates all 4 Providers ONCE at the top
│   of the widget tree (MultiProvider), then starts the app.
│
├── app.dart                   ← MaterialApp: theme + route table
│
├── core/                                  (shared foundation)
│   ├── theme/app_theme.dart               All colors & Material 3 theme
│   ├── constants/app_constants.dart       App name, demo account, storage keys
│   └── utils/formatters.dart              ₹ price formatting (Indian grouping)
│
├── data/                                  (DATA LAYER)
│   ├── dummy_data.dart                    ★ 6 categories + 20 products
│   ├── models/
│   │   ├── product.dart                   One product (+ discount logic)
│   │   ├── category.dart                  One category
│   │   ├── cart_item.dart                 productId + quantity
│   │   └── app_user.dart                  Logged-in user (+ initials helper)
│   └── repositories/
│       ├── product_repository.dart        "Fetch" catalog (fake 800 ms API)
│       ├── auth_repository.dart           Users + session in SharedPreferences
│       └── cart_wishlist_repository.dart  Cart/wishlist JSON persistence
│
├── state/                                 (STATE LAYER — Provider)
│   ├── auth_provider.dart                 login / signup / logout / session
│   ├── products_provider.dart             catalog + search + category queries
│   ├── cart_provider.dart                 add / remove / totals / savings
│   └── wishlist_provider.dart             toggle hearts
│
├── ui/                                    (UI LAYER — screens)
│   ├── splash/splash_screen.dart          Logo 1.6 s → routes by login state
│   ├── auth/
│   │   ├── login_screen.dart              Form + validation + demo button
│   │   └── signup_screen.dart             Form + confirm-password field
│   ├── shell/main_shell.dart              Bottom NavigationBar + IndexedStack
│   ├── home/home_screen.dart              Greeting, search, categories, grids
│   ├── category/
│   │   ├── categories_screen.dart         2×3 category grid
│   │   └── category_products_screen.dart  Products of ONE category
│   ├── product/product_details_screen.dart  Hero, price, qty, add-to-cart
│   ├── cart/cart_screen.dart              Lines + bill + fake checkout
│   ├── wishlist/wishlist_screen.dart      Hearts + “move to cart”
│   └── profile/profile_screen.dart        Avatar, stats, about, logout
│
└── widgets/                               (shared UI pieces)
    ├── product_card.dart                  The tile used in every grid
    ├── shop_card.dart                     Standard card look (one place)
    ├── quantity_stepper.dart              [ − 2 + ] control
    ├── section_header.dart                “Title …  See all →”
    └── empty_state.dart                   Friendly “nothing here” screens

android/                    ← the native Android host project
├── app/build.gradle        App id, sdk versions, signing
├── app/src/main/AndroidManifest.xml   App name/icon/launcher activity
└── …/MainActivity.kt       The ONE Kotlin file: hosts the Flutter engine
```

---

## 4. Concepts you can learn from this repo

| Concept | Where to look |
|---|---|
| **State management with Provider** | `lib/state/*` + `context.watch` vs `context.read` (search for them in `lib/ui/`) |
| **Repository pattern** | `lib/data/repositories/*` — the only files that touch storage |
| **Models & computed getters** | `product.dart` → `hasDiscount`, `discountPercent` |
| **Persistence** | `auth_repository.dart`, `cart_wishlist_repository.dart` (SharedPreferences + JSON) |
| **Navigation** | `app.dart` (named routes), `product_card.dart` (push with object), `login_screen.dart` (pushAndRemoveUntil) |
| **Passing data to a screen** | `CategoryProductsScreen(category: …)` |
| **Callbacks child → parent** | `HomeScreen(onOpenCategoriesTab: …)` in `main_shell.dart` |
| **Forms & validation** | `login_screen.dart` / `signup_screen.dart` (`Form`, `validator`) |
| **Loading / error / empty states** | `home_screen.dart`, `widgets/empty_state.dart` |
| **Lists & grids** | `home_screen.dart` (slivers), `categories_screen.dart` (GridView) |
| **Hero animations** | `product_card.dart` ↔ `product_details_screen.dart` |
| **Badges** | cart count badge in `main_shell.dart` |
| **Theming** | `core/theme/app_theme.dart` (Material 3, `ColorScheme.fromSeed`) |
| **Tests** | `test/smoke_test.dart` (units), `test/widget_test.dart` (full user flow) |

### 🔑 The 3 Provider rules used everywhere
1. **`context.watch<T>()`** in `build()` → widget rebuilds when T changes.
   Used for *data you display* (cart total, wishlist hearts).
2. **`context.read<T>()`** in callbacks → call an action *without* subscribing.
   Used for *button presses* (`addToCart`, `login`).
3. **State changes must end with `notifyListeners()`** — that’s what makes
   every watching widget rebuild. See any method in `lib/state/`.

---

## 5. How a “tap” travels through the app

Example: you tap **+** on a product card:

```
ProductCard (+ button)
  └─ context.read<CartProvider>().addToCart('p7')      UI layer
       └─ _items['p7'] = qty+1                          state updated
            └─ _repository.saveCart(items)              data layer → disk
                 └─ notifyListeners()                   🔔
                      └─ every context.watch<CartProvider>() rebuilds:
                         cart badge in MainShell, Cart bill, card…
```

---

## 6. Ideas to extend it (practice!)

1. **Sorting** — add “sort by price” to the category screen.
2. **Coupons** — a `Coupon` model + field in the cart bill.
3. **Real backend** — swap `DummyData` for
   [fakestoreapi.com](https://fakestoreapi.com) using the `http` package
   (only `product_repository.dart` changes!).
4. **Orders history** — save placed orders to SharedPreferences, list them in Profile.
5. **Dark mode** — add `AppTheme.dark` + a toggle in Profile.

---

*Built as a learning project. All data is dummy; no real payments or personal
data are involved. Passwords are stored in plain text locally for simplicity —
never do this in a real app.*
