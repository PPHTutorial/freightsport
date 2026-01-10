import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 600) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

extension ResponsiveText on BuildContext {
  double get scaleFactor {
    final width = MediaQuery.of(this).size.width;
    if (width >= 1200) return 1.2; // Desktop
    if (width >= 600) return 1.0; // Tablet
    return 0.85; // Mobile
  }

  // Helper to scale text dynamically
  double responsiveCapped(double size, {double max = 100}) {
     // A simple clamp isn't enough, we want proportional scaling
     // but bounded to avoid looking ridiculous on ultra-wide
     return (size * scaleFactor).clamp(10, max);
  }
}
