import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFC76767);
  static const Color secondary = Color(0xFF562B56);
  static const Color accent = Color(0xFFCDA2F2);
  static const Color yellow = Color(0xFFF7C873);
  static const Color beige = Color(0xFFF2E9DC);
  static const Color offWhite = Color(0xFFFDF8FD);
}

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.offWhite,
  fontFamily: 'Inter',
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.offWhite,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
        fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.secondary),
    titleMedium: TextStyle(
        fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.secondary),
    bodyLarge: TextStyle(fontSize: 16, color: AppColors.secondary),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.secondary),
    labelLarge: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
  ),
);
