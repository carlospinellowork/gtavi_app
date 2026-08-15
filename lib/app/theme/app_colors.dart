import 'package:flutter/material.dart';

abstract class AppColors {
  // Backgrounds (Deep Vice Night Sunset)
  static const Color background = Color(0xFF0C0714);
  static const Color surface = Color(0xFF180E28);
  static const Color surfaceLight = Color(0xFF25163D);
  static const Color surfaceBorder = Color(0xFF45226E);

  // Brand / Accents (GTA VI Ultra Neon Sunset Palette)
  static const Color primary = Color(0xFFFF007A); // Vice Magenta Neon
  static const Color primaryGradientEnd = Color(0xFFFF6B00); // Sunset Orange
  static const Color secondary = Color(0xFF00F0FF); // Ocean Cyan Neon
  static const Color accent = Color(0xFF9D00FF); // Vice Purple Neon
  static const Color gold = Color(0xFFFFC700); // Sun Gold

  // Category Colors
  static const Color missions = Color(0xFFFF007A);
  static const Color vehicles = Color(0xFF00F0FF);
  static const Color locations = Color(0xFFFF6B00);
  static const Color collectibles = Color(0xFF9D00FF);
  static const Color guides = Color(0xFFFFC700);

  // Status & Feedback
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF1744);
  static const Color info = Color(0xFF00F0FF);

  // Typography
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFD4C7EC);
  static const Color textMuted = Color(0xFF8B7AA8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Overlays & Glassmorphism
  static const Color glassBackground = Color(0xAA180E28);
  static const Color glassBorder = Color(0x40FF007A);
}
