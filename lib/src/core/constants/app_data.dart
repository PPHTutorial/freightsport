import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rightlogistics/src/features/social/domain/status_model.dart';

class AppData {
  static const String companyName = 'Right Logistics Gh';
  static const String slogan = 'China 🇨🇳 ↔️ Ghana 🇬🇭';

  // Contact Info
  static const String email = 'rightlogisticsgh@gmail.com';
  static const String address = 'Ashongmang Estate-Accra';
  static const List<String> phoneNumbers = ['0550711911', '0549925469'];
  static const List<String> whatsappNumbers = ['233550711911', '233549925469'];
  static const String whatsappSupport = 'https://wa.me/233550711911';

  // Social Media
  static const Map<String, (String handle, String url)> socials = {
    'Instagram': (
      '@rightlogisticsgh',
      'https://instagram.com/rightlogisticsgh',
    ),
    'Facebook': (
      'Right Logistics',
      'https://facebook.com/RightLogisticsGh',
    ), // Assuming URL
    'TikTok': ('@Right.Logistics.Gh', 'https://tiktok.com/@right.logistics.gh'),
    'Snapchat': (
      'Rightlogistics',
      'https://www.snapchat.com/add/rightlogistics',
    ),
  };

  // Services
  static const List<Map<String, dynamic>> services = [
    {
      'title': 'Air Freight',
      'icon': FontAwesomeIcons.planeUp,
      'description':
          'Daily shipments from China to Ghana with Express & Normal options.',
    },
    {
      'title': 'Sea Freight',
      'icon': FontAwesomeIcons.ship,
      'description':
          'Bulk shipping with competitive CBM rates and 45-60 days duration.',
    },
    {
      'title': 'Procurement',
      'icon': FontAwesomeIcons.cartShopping,
      'description': 'Sourcing, Procurement and Supplier inspection services.',
    },
    {
      'title': 'Auto Logistics',
      'icon': FontAwesomeIcons.car,
      'description': 'Car Purchase, Shipment and clearance.',
    },
    {
      'title': 'Containers',
      'icon': FontAwesomeIcons.boxOpen,
      'description':
          'Container Booking, Port Clearance and Empty Container Purchase.',
    },
    {
      'title': 'RMB Payment',
      'icon': FontAwesomeIcons.moneyBillTransfer,
      'description': 'Fast and secure RMB payment services for suppliers.',
    },
  ];

  // Rates - Air Express
  static const Map<String, double> airExpressRates = {
    'normal': 18.0, // $/kg
    'dangerous': 20.0, // battery/powder/Chemical/liquid
  };

  // Rates - Air Normal
  static const Map<String, double> airNormalRates = {
    'normal': 15.0, // $/kg
    'dangerous': 18.0,
  };

  // Special Air Rates
  static const double phoneRateFlat = 30.0; // GHS flat
  static const double laptopRatePerKg = 25.0; // $/kg

  // Rates - Sea
  static const Map<String, double> seaRates = {
    'normal': 240.0, // $/CBM
    'special': 250.0, // Machine and Battery
  };

  // FAQs
  static const List<Map<String, String>> faqs = [
    {
      'question': 'What services does Right Logistics GH provide?',
      'answer':
          'We offer comprehensive logistics solutions including Air Freight (Express & Normal), Sea Freight (LCL & FCL), Procurement services, Auto Logistics (Car purchase & shipping), and secure RMB payment services for suppliers.',
    },
    {
      'question': 'How frequent are your Air Freight shipments?',
      'answer':
          'We have daily shipments from China to Ghana. We offer both Normal Air Freight and Express options for urgent deliveries.',
    },
    {
      'question': 'How long does Sea Freight take?',
      'answer':
          'Sea Freight shipments typically take between 45 to 60 days from departure to arrival in Ghana.',
    },
    {
      'question': 'What are the current Air Freight rates?',
      'answer':
          'Our standard Air Freight rate is \$18.0/kg for normal goods. For sensitive goods (batteries, powders, liquids, etc.), the rate is \$20.0/kg.',
    },
    {
      'question': 'Are there special rates for electronics?',
      'answer':
          'Yes! Phones are charged at a flat rate of GHS 30 per piece, while laptops are charged at \$25.0/kg.',
    },
    {
      'question': 'How is Sea Freight cost calculated?',
      'answer':
          'Sea Freight is calculated per CBM (Cubic Meter). Normal goods are \$240.0/CBM, while special items like machines and batteries are \$250.0/CBM.',
    },
    {
      'question': 'Can you help me pay my suppliers in China?',
      'answer':
          'Absolutely. We provide fast and secure RMB payment services to your suppliers in China, ensuring your procurement process is seamless.',
    },
    {
      'question': 'Do you assist with car purchases from China?',
      'answer':
          'Yes, our Auto Logistics service covers car purchase, shipment, and port clearance.',
    },
    {
      'question': 'Do you offer procurement and inspection services?',
      'answer':
          'Yes, we help with sourcing products, procurement, and supplier inspection to ensure you get exactly what you ordered.',
    },
    {
      'question': 'Where is your office located in Ghana?',
      'answer': 'Our main office is located at Ashongmang Estate, Accra.',
    },
  ];

  // Mock Social Posts
  static List<Map<String, dynamic>> mockPosts = [
    {
      'id': 'mock_1',
      'vendorId': 'admin_1',
      'vendorName': 'Right Logistics HQ',
      'vendorPhotoUrl': null,
      'imageUrls': [
        'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?q=80&w=800',
        'https://images.unsplash.com/photo-1578575437130-527eed3abbec?q=80&w=800',
      ],
      'description':
          'Daily flights from Guangzhou to Accra are now 100% active!',
      'details':
          'We have secured 3 dedicated cargo planes weekly. Express shipping: 3-5 days. Standard: 7-9 days.',
      'price': 0,
      'type': 'logistics',
      'isPurchasable': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(minutes: 10))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 7))
          .toIso8601String(),
    },
    {
      'id': 'mock_2',
      'vendorId': 'vendor_1',
      'vendorName': 'Premier Sourcing Gh',
      'vendorPhotoUrl': null,
      'imageUrls': [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=800',
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=800',
      ],
      'description':
          'Limited Edition Smart Watches - Direct from Manufacturer.',
      'details':
          'High premium build, waterproof, 14 days battery life. Limited stock available.',
      'price': 450,
      'type': 'purchase',
      'isPurchasable': true,
      'minOrder': 5,
      'maxOrder': 50,
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 1))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 2))
          .toIso8601String(),
    },
    {
      'id': 'mock_3',
      'vendorId': 'vendor_2',
      'vendorName': 'Warehouse Elite',
      'vendorPhotoUrl': null,
      'imageUrls': [
        'https://images.unsplash.com/photo-1553413077-190dd305871c?q=80&w=800',
      ],
      'description': 'Our new Warehouse in Yiwu is now open for consolidation!',
      'details':
          'Free storage for the first 30 days for all our premium customers. Secure and climate controlled.',
      'price': 0,
      'type': 'warehouse',
      'isPurchasable': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 3))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 5))
          .toIso8601String(),
    },
    {
      'id': 'mock_4',
      'vendorId': 'vendor_3',
      'vendorName': 'Logistics Promo',
      'vendorPhotoUrl': null,
      'imageUrls': [
        'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=800',
      ],
      'description': '20% Offline discount for all Sea Freight this month!',
      'details':
          'Quote "SOCIAL20" when booking your next container. Offer valid until end of month.',
      'price': 220,
      'type': 'promotion',
      'isPurchasable': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 5))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 15))
          .toIso8601String(),
    },
    {
      'id': 'mock_5',
      'vendorId': 'vendor_4',
      'vendorName': 'Gratitude Logistics',
      'description':
          'Thank you to all our 500+ active users! We appreciate you.',
      'type': 'appreciation',
      'isPurchasable': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 8))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 3))
          .toIso8601String(),
    },
    {
      'id': 'mock_6',
      'vendorId': 'vendor_1',
      'vendorName': 'Premier Sourcing Gh',
      'imageUrls': [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=800',
      ],
      'description': 'New Arrival: Premium Sneakers collection in stock!',
      'price': 1200,
      'type': 'newItem',
      'isPurchasable': true,
      'createdAt': DateTime.now()
          .subtract(const Duration(hours: 12))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 4))
          .toIso8601String(),
    },
    {
      'id': 'mock_7',
      'vendorId': 'admin_1',
      'vendorName': 'Right Logistics HQ',
      'description':
          'Route Update: Port congestion in Tema cleared. Expect faster sea freight delivery.',
      'type': 'logistics',
      'isPurchasable': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 4))
          .toIso8601String(),
    },
    {
      'id': 'mock_8',
      'vendorId': 'vendor_2',
      'vendorName': 'Warehouse Elite',
      'imageUrls': [
        'https://images.unsplash.com/photo-1548092372-0d1bd40894a3?q=80&w=800',
      ],
      'description':
          'Consolidation notice: Container leaving Guangzhou port this Friday.',
      'type': 'logistics',
      'isPurchasable': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 1, hours: 4))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 2))
          .toIso8601String(),
    },
    {
      'id': 'mock_9',
      'vendorId': 'vendor_5',
      'vendorName': 'Global Sourcing',
      'imageUrls': [
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=800',
      ],
      'description': 'Upcoming Pre-order: Next-gen Smartphones coming soon!',
      'title': 'iPhone 16 Series Pre-Order',
      'price': 15000,
      'minOrder': 10,
      'currentOrderCount': 4,
      'type': 'purchase',
      'isPurchasable': true,
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 1, hours: 8))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 10))
          .toIso8601String(),
    },
    {
      'id': 'mock_10',
      'vendorId': 'vendor_4',
      'vendorName': 'Gratitude Logistics',
      'description':
          'Shoutout to our top 10 vendors of the month! Reliable shipping at its best.',
      'type': 'appreciation',
      'isPurchasable': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 2))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 5))
          .toIso8601String(),
    },
    {
      'id': 'mock_11',
      'vendorId': 'vendor_3',
      'vendorName': 'Logistics Promo',
      'imageUrls': [
        'https://images.unsplash.com/photo-1607083229094-fb6724f22795?q=80&w=800',
      ],
      'description':
          'Flash Sale: 50% off all procurement fees for the next 48 hours!',
      'type': 'promotion',
      'isPurchasable': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 2, hours: 3))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 1))
          .toIso8601String(),
    },
    {
      'id': 'mock_12',
      'vendorId': 'vendor_1',
      'vendorName': 'Premier Sourcing Gh',
      'description':
          'New item categorization: You can now group your orders by category for better tracking.',
      'type': 'update',
      'isPurchasable': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 3))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 10))
          .toIso8601String(),
    },
    {
      'id': 'mock_13',
      'vendorId': 'admin_1',
      'vendorName': 'Right Logistics HQ',
      'imageUrls': [
        'https://images.unsplash.com/photo-1494412574735-911b6ecbe0f5?q=80&w=800',
      ],
      'description':
          'Service Expansion: We now ship heavy machinery and factory equipment.',
      'type': 'newItem',
      'isPurchasable': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 3, hours: 6))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 30))
          .toIso8601String(),
    },
    {
      'id': 'mock_14',
      'vendorId': 'vendor_5',
      'vendorName': 'Global Sourcing',
      'description':
          'Direct Factory sourcing for Kitchen Appliances now available. No middlemen.',
      'type': 'update',
      'isPurchasable': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 4))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 14))
          .toIso8601String(),
    },
    {
      'id': 'mock_15',
      'vendorId': 'vendor_2',
      'vendorName': 'Warehouse Elite',
      'description':
          'New security features implemented in our Guangzhou warehouse. Peace of mind guaranteed.',
      'type': 'warehouse',
      'isPurchasable': false,
      'createdAt': DateTime.now()
          .subtract(const Duration(days: 5))
          .toIso8601String(),
      'expiresAt': DateTime.now()
          .add(const Duration(days: 20))
          .toIso8601String(),
    },
  ];

  static final List<StatusModel> mockStatuses = [
    StatusModel(
      id: 's1',
      vendorId: 'vendor_1',
      vendorName: 'Premier Sourcing',
      mediaUrl:
          'https://images.unsplash.com/photo-1596740926401-80c51f32c1c9?q=80&w=800',
      caption: 'New stock arriving tomorrow! 🔥',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      expiresAt: DateTime.now().add(const Duration(hours: 22)),
    ),
    StatusModel(
      id: 's2',
      vendorId: 'vendor_1',
      vendorName: 'Premier Sourcing',
      mediaUrl:
          'https://images.unsplash.com/photo-1595991209241-e9700b77d469?q=80&w=800',
      caption: 'Limited colors available.',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      expiresAt: DateTime.now().add(const Duration(hours: 23)),
    ),
    StatusModel(
      id: 's3',
      vendorId: 'vendor_2',
      vendorName: 'Warehouse Elite',
      mediaUrl:
          'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?q=80&w=800',
      caption: 'Warehouse busy today!',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      expiresAt: DateTime.now().add(const Duration(hours: 20)),
    ),
  ];
}
