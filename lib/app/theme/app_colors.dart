import 'package:flutter/material.dart';

abstract class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF0B0E14);
  static const Color surface = Color(0xFF141923);
  static const Color surfaceLight = Color(0xFF1C2333);
  static const Color surfaceBorder = Color(0xFF263045);

  // Brand / Accents (GTA VI Vice City Dark Neon Aesthetic)
  static const Color primary = Color(0xFFFF2A7A); // Neon Pink
  static const Color primaryGradientEnd = Color(0xFFFF7A00); // Neon Coral/Orange
  static const Color secondary = Color(0xFF00F0FF); // Cyber Cyan
  static const Color accent = Color(0xFFFFB800); // Neon Gold

  // Category Colors
  static const Color missions = Color(0xFFFF5252);
  static const Color vehicles = Color(0xFF00E676);
  static const Color locations = Color(0xFF40C4FF);
  static const Color collectibles = Color(0xFFE040FB);
  static const Color guides = Color(0xFFFFD700);

  // Status & Feedback
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF1744);
  static const Color info = Color(0xFF29B6F6);

  // Typography
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Overlays & Glassmorphism
  static const Color glassBackground = Color(0x99141923);
  static const Color glassBorder = Color(0x33FFFFFF);
}
