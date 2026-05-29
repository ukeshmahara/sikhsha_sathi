import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {

  return ThemeData(

    useMaterial3: true,

    primaryColor: const Color(0xFF4D8DFF),

    scaffoldBackgroundColor: const Color(0xFFF5F5F5),

    fontFamily: 'Montserrat',

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4D8DFF),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(

      style: ElevatedButton.styleFrom(

        backgroundColor: const Color(0xFF4D8DFF),

        foregroundColor: Colors.white,

        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(

      filled: true,

      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
  );
}