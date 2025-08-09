import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

const seedColor = AppColors.accent; // oranye utama

final ColorScheme lightColorScheme =
    ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.light).copyWith(
      primary: seedColor,
      onPrimary: Colors.white,
      secondary: const Color(0xFFFFC107), // kuning amber lembut
      onSecondary: Colors.black87,
      surface: const Color(0xFFFDFCFB), // putih hangat untuk background komponen
      surfaceContainerHigh: const Color(0xFFF7F2EC), // abu krem halus untuk field
      onSurface: Colors.black87,
      // background: const Color(0xFFFAF8F6),
      // onBackground: Colors.black87,
      error: Colors.red.shade700,
      onError: Colors.white,
    );

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
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
  colorScheme: lightColorScheme,

  // Input styles untuk TextField / TextFormField
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.focused)) {
        return const Color(0xFFF0F3F6); // sedikit lebih kontras saat fokus
      }
      if (states.contains(WidgetState.disabled)) {
        return const Color(0xFFF8F9FA); // lebih pucat saat disabled
      }
      return const Color(0xFFF5F7F9); // default
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
