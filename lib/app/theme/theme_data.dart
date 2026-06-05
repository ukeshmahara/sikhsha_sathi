import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {

  return ThemeData(

    useMaterial3: true,

    scaffoldBackgroundColor: Colors.white,

    fontFamily: 'Montserrat',

    colorSchemeSeed: Colors.blue,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
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
  );
}