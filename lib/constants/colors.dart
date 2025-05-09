import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (updated to match your dark red theme)
  static const Color primary = Color(0xFF7A0000);  // Main brand color
  static const Color primaryLight = Color(0xFFA13333);
  static const Color primaryDark = Color(0xFF5C0000);
  static const Color secondary = Color(0xFF795548); // Brown accent

  // Text Colors
  static const Color textDark = Color(0xFF212121);
  static const Color textMedium = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Colors.white;

  // Functional Colors
  static const Color price = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA000);
  static const Color error = Color(0xFFD32F2F);

  // Background & Surface
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFEEEEEE);

  // Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const MaterialColor grey = Colors.grey;
  static const Color darkRed = Color(0xFF7A0000);
  static final Color black50 = Colors.black.withAlpha((0.5 * 255).round());
  static final Color black40 = Colors.black.withAlpha((0.4 * 255).round());
  static final Color white90 = Colors.white.withAlpha((0.9 * 255).round());
  static const Color lightGrey = Color(0xFFF5F5F5); 
}