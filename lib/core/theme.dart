import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFC76767);
  static const Color secondary = Color(0xFF562B56);
  static const Color accent = Color(0xFFCDA2F2);
  static const Color yellow = Color(0xFFF7C873);
  static const Color beige = Color(0xFFF2E9DC);
  static const Color background = Color(0xFFFDF8FD);
  static const Color texe_field_background = Color.fromARGB(255, 251, 236, 251);
  static const Color gray = Color(0xFFD1D1D6);
}

class AppTheme {
  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    secondaryHeaderColor: AppColors.secondary,
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.primary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.texe_field_background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: TextStyle(
        color: AppColors.primary.withOpacity(0.6),
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.secondary,
      selectionColor: AppColors.secondary,
      selectionHandleColor: AppColors.secondary,
    ),
  );
}
