import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F46E5), // Indigo
      primary: const Color(0xFF4F46E5),
      secondary: const Color(0xFF10B981), // Emerald
      tertiary: const Color(0xFFF59E0B), // Amber
      error: const Color(0xFFEF4444), // Red
      brightness: Brightness.light,
      surface: const Color(0xFFF8FAFC), // Slate 50
      // background is deprecated, using surface instead or removing if redundant
    ),
    textTheme: GoogleFonts.interTextTheme(),
    // CardTheme removed to avoid type mismatch
    // cardTheme: CardTheme(...),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6366F1), // Indigo
      primary: const Color(0xFF6366F1),
      secondary: const Color(0xFF34D399), // Emerald
      tertiary: const Color(0xFFFBBF24), // Amber
      error: const Color(0xFFF87171), // Red
      brightness: Brightness.dark,
      surface: const Color(0xFF1E293B), // Slate 800
      // background is deprecated
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    // CardTheme removed to avoid type mismatch
    // cardTheme: CardTheme(...),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E293B),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
      ),
    ),
  );
}
