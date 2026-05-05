import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryRed = Color.fromARGB(255, 147, 203, 14);
  static const Color background = Colors.white;

  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: background,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 139, 200, 16),
      foregroundColor: Colors.white,
      centerTitle: true,
    ),

    // Кнопки
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 126, 200, 16),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Поля ввода
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 123, 200, 16),
          width: 2,
        ),
      ),
    ),
  );
}
