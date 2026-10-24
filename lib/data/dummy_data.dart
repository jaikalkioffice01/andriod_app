import '../data/models/category.dart';
import '../data/models/product.dart';

/// ---------------------------------------------------------------------------
/// DUMMY DATA
/// The "fake backend" of this demo app. In a real app this data would come
/// from a REST API (e.g. https://fakestoreapi.com) or a database.
///
/// Here: 6 categories and 20 products with Indian Rupee pricing.
/// ---------------------------------------------------------------------------
class DummyData {
  DummyData._();

  // ----- CATEGORIES (6) -----------------------------------------------------
  static const List<Category> categories = <Category>[
    Category(id: 'c1', name: 'Electronics', emoji: '💻', color: 0xFFB3D4FF),
    Category(id: 'c2', name: 'Fashion', emoji: '👕', color: 0xFFFFC9DE),
    Category(id: 'c3', name: 'Shoes', emoji: '👟', color: 0xFFFFD1B3),
    Category(id: 'c4', name: 'Watches', emoji: '⌚', color: 0xFFD4C5F9),
    Category(id: 'c5', name: 'Home & Living', emoji: '🏠', color: 0xFFBDEAC2),
    Category(id: 'c6', name: 'Beauty', emoji: '💄', color: 0xFFE8C5E8),
  ];

  // ----- PRODUCTS (20) ------------------------------------------------------
  static const List<Product> products = <Product>[
    // ---------- Electronics (5) ----------
    Product(
      id: 'p1',
      name: 'Wireless Headphones',
      description:
          'Over-ear Bluetooth headphones with deep bass, 30-hour battery life '
          'and fast charging. Foldable design with a premium carry pouch.',
      price: 2499,
      oldPrice: 3499,
      rating: 4.6,
      reviewCount: 214,
      categoryId: 'c1',
      emoji: '🎧',
    ),
    Product(
      id: 'p2',
      name: 'Smartphone Pro',
      description:
          '6.5-inch HD+ display, 8 GB RAM, 128 GB storage and a 50 MP AI '
          'camera. Comes with a 5000 mAh battery and 2-year warranty.',
      price: 15999,
      rating: 4.4,
      reviewCount: 890,
      categoryId: 'c1',
      emoji: '📱',
    ),
    Product(
      id: 'p3',
      name: 'Bluetooth Speaker',
      description:
          'Portable 20 W speaker with IPX7 water resistance and 12 hours of '
          'playback. Pair two speakers together for true stereo sound.',
      price: 1299,
      oldPrice: 1899,
      rating: 4.3,
      reviewCount: 132,
      categoryId: 'c1',
      emoji: '🔊',
    ),
    Product(
      id: 'p4',
      name: 'Action Camera 4K',
      description:
          '4K30 video, electronic stabilisation and a rugged waterproof body '
          'good up to 10 m without a case. Perfect for travel vlogs.',
      price: 4999,
      rating: 4.2,
      reviewCount: 76,
      categoryId: 'c1',
      emoji: '📷',
    ),
    Product(
      id: 'p5',
      name: 'Fast Charger 65W',
      description:
          'GaN USB-C charger that powers laptops and phones at full speed. '
          'Compact size with built-in over-heat protection.',
      price: 799,
      rating: 4.5,
      reviewCount: 305,
      categoryId: 'c1',
      emoji: '🔌',
    ),

    // ---------- Fashion (4) ----------
    Product(
      id: 'p6',
      name: 'Cotton T-Shirt',
      description:
          '100% combed cotton, pre-shrunk, regular fit. Feels soft wash '
          'after wash. Available in classic solid colours.',
      price: 499,
      oldPrice: 799,
      rating: 4.1,
      reviewCount: 540,
      categoryId: 'c2',
      emoji: '👕',
    ),
    Product(
      id: 'p7',
      name: 'Denim Jacket',
      description:
          'Classic blue denim jacket with button closure and two chest '
          'pockets. A timeless layer that goes with everything.',
      price: 1899,
      oldPrice: 2499,
      rating: 4.5,
      reviewCount: 210,
      categoryId: 'c2',
      emoji: '🧥',
    ),
    Product(
      id: 'p8',
      name: 'Summer Floral Dress',
      description:
          'Lightweight knee-length floral dress, perfect for hot summer '
          'days. Breathable rayon fabric with a flared silhouette.',
      price: 899,
      rating: 4.3,
      reviewCount: 118,
      categoryId: 'c2',
      emoji: '👗',
    ),
    Product(
      id: 'p9',
      name: 'Leather Wallet',
      description:
          'Genuine leather bi-fold wallet with 6 card slots and RFID '
          'blocking. Slim profile that fits comfortably in your pocket.',
      price: 649,
      oldPrice: 999,
      rating: 4.0,
      reviewCount: 95,
      categoryId: 'c2',
      emoji: '👛',
    ),

    // ---------- Shoes (3) ----------
    Product(
      id: 'p10',
      name: 'Running Shoes',
      description:
          'Lightweight mesh running shoes with a cushioned sole for daily '
          'runs. Reflective strips keep you visible on evening jogs.',
      price: 2299,
      oldPrice: 2999,
      rating: 4.6,
      reviewCount: 421,
      categoryId: 'c3',
      emoji: '👟',
    ),
    Product(
      id: 'p11',
      name: 'Casual Sneakers',
      description:
          'Everyday sneakers with a breathable knit upper and grip outsole. '
          'Slip them on for errands, college or casual outings.',
      price: 1499,
      rating: 4.2,
      reviewCount: 260,
      categoryId: 'c3',
      emoji: '👟',
    ),
    Product(
      id: 'p12',
      name: 'Comfy Flip Flops',
      description:
          'Soft, water-friendly flip flops with an anti-skid sole. Perfect '
          'for the beach, bathroom or a quick outing.',
      price: 299,
      rating: 3.9,
      reviewCount: 77,
      categoryId: 'c3',
      emoji: '🩴',
    ),

    // ---------- Watches (3) ----------
    Product(
      id: 'p13',
      name: 'Classic Analog Watch',
      description:
          'Stainless steel analog watch with leather strap, 3 ATM water '
          'resistant. A dress watch that works with formal wear.',
      price: 1999,
      rating: 4.4,
      reviewCount: 183,
      categoryId: 'c4',
      emoji: '⌚',
    ),
    Product(
      id: 'p14',
      name: 'Smart Watch Pro',
      description:
          "1.8'' AMOLED display, SpO2 + heart-rate tracking and 7-day "
          'battery. Answers calls and shows notifications from your phone.',
      price: 3499,
      oldPrice: 4499,
      rating: 4.5,
      reviewCount: 612,
      categoryId: 'c4',
      emoji: '⌚',
    ),
    Product(
      id: 'p15',
      name: 'Minimalist Watch',
      description:
          'Slim minimalist dial with a mesh strap — goes with everything. '
          'Ultra-thin case, only 7 mm thick.',
      price: 1299,
      rating: 4.0,
      reviewCount: 58,
      categoryId: 'c4',
      emoji: '🕰️',
    ),

    // ---------- Home & Living (3) ----------
    Product(
      id: 'p16',
      name: 'Scented Candle',
      description:
          'Hand-poured soy wax candle with lavender & vanilla aroma. '
          'Approximately 35 hours of burn time in a reusable glass jar.',
      price: 349,
      rating: 4.3,
      reviewCount: 89,
      categoryId: 'c5',
      emoji: '🕯️',
    ),
    Product(
      id: 'p17',
      name: 'Ceramic Coffee Mug',
      description:
          '350 ml glazed ceramic mug, microwave & dishwasher safe. The '
          'handle is shaped for a comfortable, steady grip.',
      price: 299,
      oldPrice: 399,
      rating: 4.7,
      reviewCount: 402,
      categoryId: 'c5',
      emoji: '☕',
    ),
    Product(
      id: 'p18',
      name: 'Throw Pillow Cover',
      description:
          'Soft linen-blend cushion cover, 45×45 cm with a hidden zip '
          'closure. Instantly refreshes your sofa or bed.',
      price: 449,
      rating: 4.1,
      reviewCount: 64,
      categoryId: 'c5',
      emoji: '🛋️',
    ),

    // ---------- Beauty (2) ----------
    Product(
      id: 'p19',
      name: 'Face Moisturizer',
      description:
          'Lightweight daily moisturizer with hyaluronic acid & vitamin E. '
          'Non-greasy formula for all skin types, 100 ml.',
      price: 599,
      rating: 4.4,
      reviewCount: 231,
      categoryId: 'c6',
      emoji: '🧴',
    ),
    Product(
      id: 'p20',
      name: 'Lipstick Set (3 pcs)',
      description:
          'Matte liquid lipstick set of 3 long-wear, transfer-proof shades. '
          'Enriched with vitamin E so lips stay comfortable.',
      price: 749,
      oldPrice: 999,
      rating: 4.2,
      reviewCount: 156,
      categoryId: 'c6',
      emoji: '💄',
    ),
  ];
}
