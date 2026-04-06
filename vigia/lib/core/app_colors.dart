import 'package:flutter/material.dart';

class AppColors {
  // --- PALETA NOTURNA ---
  static const Color darkBg = Color(0xFF0D0D0D);
  static const Color darkDeepRed = Color(0xFF260104);
  static const Color darkNeonRed = Color(0xFF8C030E);
  static const Color darkAccent = Color(0xFF8C031C);

  // --- PALETA DIURNA ---
  static const Color lightBg = Color(0xFFF2EFDC);
  static const Color lightOrange = Color(0xFFF26849);
  static const Color lightCoral = Color(0xFFF29B88);
  static const Color lightRed = Color(0xFFF22F1D);
  static const Color lightSoftOrange = Color(0xFFF25749);

  static Color getBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBg : lightBg;

  static Color getPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkNeonRed : lightRed;

  static Color getCardColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark 
          ? const Color(0xFF140D10) 
          : Colors.white.withValues(alpha: 0.7);
}