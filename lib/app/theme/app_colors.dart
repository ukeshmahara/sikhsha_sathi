import 'package:flutter/material.dart';

extension AppColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Page background (e.g. Scaffold backgroundColor)
  Color get appBackground =>
      isDark ? const Color(0xFF121212) : const Color(0xFFF7F8FA);

  // Card / container surface sitting on top of the background
  Color get appSurface => isDark ? const Color(0xFF1E1E1E) : Colors.white;

  // A slightly different surface for subtle sections (e.g. toggle track bg)
  Color get appSurfaceMuted =>
      isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100;

  Color get appBorder =>
      isDark ? const Color(0xFF2E2E2E) : Colors.grey.shade200;

  Color get appTextPrimary => isDark ? Colors.white : Colors.black87;

  Color get appTextSecondary =>
      isDark ? Colors.grey.shade400 : Colors.grey.shade600;

  Color get appTextMuted =>
      isDark ? Colors.grey.shade600 : Colors.grey.shade400;
}