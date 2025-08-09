import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

const seedColor = AppColors.accent; // oranye utama

final ColorScheme darkColorScheme =
    ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark).copyWith(
      primary: seedColor,
      onPrimary: Colors.white,
      secondary: const Color(0xFFFFB74D), // amber oranye lembut
      onSecondary: Colors.black,
      surface: const Color(0xFF1C1B1A), // hampir hitam tapi ada sedikit warm tone
      surfaceContainerHigh: const Color(0xFF2A2725), // abu gelap hangat untuk field
      onSurface: Colors.white70,
      // background: const Color(0xFF121110),
      // onBackground: Colors.white70,
      error: Colors.red.shade400,
      onError: Colors.black,
    );

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.accent),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16),
  ),

  // Input styles untuk TextField / TextFormField di dark mode
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.focused)) {
        return const Color(0xFF1E1F22); // sedikit lebih terang saat fokus
      }
      if (states.contains(WidgetState.disabled)) {
        return const Color(0xFF1A1B1E); // lebih gelap saat disabled
      }
      return const Color(0xFF181A1D); // default
    }),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primary, width: 1.2),
    ),
  ),
);
