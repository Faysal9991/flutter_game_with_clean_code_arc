import 'package:flutter/material.dart';

class AppColors {

  static const Color primaryDark = Color(0xFF0A0E27);
  static const Color surfaceDark = Color(0xFF1A1F3A);

  // Accent
  static const Color accentPurple = Color(0xFF6C63FF);
  static const Color accentGold   = Color(0xFFFFD700);

  // Gradients
  static const List<Color> headerGradient = [
    Color(0xFF6C63FF),
    Color(0xFF4A42B0),
  ];
  // BRAND COLORS
  static const Color primaryGreen = Color(0xFF2CB67D);
  static const Color sea = Color(0xFF0A3A5A);
  static const Color sky = Color(0xFF7BDCB5);
  static const Color ink = Color(0xFF0B2030);

  // EFFECT COLORS
  static const Color glow = Color(0xFF9FFFE0);

  // NEON COLORS
  static const Color neonBlue = Color(0xFF00FFFF);
  static const Color neonGreen = Color(0xFF00FF00);
  static const Color neonPurple = Color(0xFFBB00FF);
  static const Color neonGold = Color(0xFFFFD700);

  // UI SEMANTIC MAPPING
  static const Color primary = primaryGreen;
  static const Color secondary = sky;
  static const Color background = ink;       // Dark eco look
  static const Color surface = sea;
  static const Color success = primaryGreen;
  static const Color error = neonPurple;     // Strong contrast
  static const Color textPrimary = glow;     // Neon readable
  static const Color textSecondary = neonBlue;
}
