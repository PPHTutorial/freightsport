import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rightlogistics/src/core/services/persistence_service.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  final persistenceService = ref.watch(persistenceServiceProvider);
  return ThemeModeNotifier(persistenceService);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final PersistenceService _persistenceService;

  ThemeModeNotifier(this._persistenceService) : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final savedMode = _persistenceService.getThemeMode();
    if (savedMode != null) {
      state = ThemeMode.values.firstWhere(
        (e) => e.name == savedMode,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _persistenceService.setThemeMode(mode.name);
  }
}

class AppTheme {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF0A1929); // Very Dark Blue
  static const Color accentOrange = Color(0xFFFF6B00); // Primary Action
  static const Color highlightYellow = Color(0xFFFFD600); // Status Emphasis

  // Functional Colors
  static const Color successGreen = Color(0xFF00C853);
  static const Color warningAmber = Color(0xFFFFAB00);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color surfaceGrey = Color(0xFFF5F5F5);
  static const Color textGrey = Color(0xFF757575);

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: accentOrange,
        tertiary: highlightYellow,
        surface: Colors.white,
        surfaceContainerHighest: surfaceGrey,
        error: errorRed,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: GoogleFonts.redHatDisplayTextTheme().copyWith(
        displayLarge: GoogleFonts.redHatDisplay(
          fontWeight: FontWeight.bold,
          fontSize: 32,
          color: primaryBlue,
        ),
        displayMedium: GoogleFonts.redHatDisplay(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: primaryBlue,
        ),
        displaySmall: GoogleFonts.redHatDisplay(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: primaryBlue,
        ),
        headlineMedium: GoogleFonts.redHatDisplay(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: primaryBlue,
        ),
        titleLarge: GoogleFonts.redHatDisplay(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: primaryBlue,
        ),
        bodyLarge: GoogleFonts.redHatDisplay(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: Colors.black87,
        ),
        bodyMedium: GoogleFonts.redHatDisplay(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryBlue),
        titleTextStyle: TextStyle(
          color: primaryBlue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        systemOverlayStyle:
            SystemUiOverlayStyle.dark, // Dark icons for light background
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue, // Primary buttons are blue by default
          foregroundColor: Colors.white,
          elevation: 0, // Flat UI
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.redHatDisplay(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accentOrange, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    const Color darkBg = Color(0xFF060912); // Deep Space Black
    const Color darkSurface = Color(0xFF0F1524); // Rich Navy Surface
    const Color secondaryBg = Color(0xFF161E33); // Elevated Surface

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: accentOrange,
        onPrimary: Colors.white,
        secondary: const Color(0xFF2196F3), // Vibrant Blue for accents
        onSecondary: Colors.white,
        tertiary: highlightYellow,
        surface: darkSurface,
        onSurface: Colors.white,
        error: errorRed,
        outline: const Color(0xFF2D3748).withOpacity(0.3),
        outlineVariant: Colors.white.withOpacity(0.1),
      ),
      scaffoldBackgroundColor: darkBg,
      cardTheme: CardThemeData(
        color: secondaryBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
      ),
      textTheme: GoogleFonts.redHatDisplayTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.redHatDisplay(
              fontWeight: FontWeight.w900,
              fontSize: 32,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            displayMedium: GoogleFonts.redHatDisplay(
              fontWeight: FontWeight.w800,
              fontSize: 28,
              color: Colors.white,
            ),
            titleLarge: GoogleFonts.redHatDisplay(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
            bodyLarge: GoogleFonts.redHatDisplay(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
            bodyMedium: GoogleFonts.redHatDisplay(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.4),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentOrange,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: accentOrange.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.redHatDisplay(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: accentOrange, width: 1.5),
        ),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        contentPadding: const EdgeInsets.all(20),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.1),
        thickness: 0.5,
      ),
    );
  }
}
