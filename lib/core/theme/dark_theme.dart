import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 0),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.accent),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16),
  ),
);
