import 'package:flutter/material.dart';

/// Shield App Color Palette
/// Dark Mode Fintech Design System inspired by Revolut, Cash App, and Cred
class AppColors {
  AppColors._();

  // Background Colors
  static const Color background = Color(0xFF0F172A); // Deep Slate Blue
  static const Color backgroundSecondary = Color(0xFF1E293B);
  static const Color backgroundTertiary = Color(0xFF334155);

  // Glass Morphism Surface
  static Color glassSurface = Colors.white.withOpacity(0.08);
  static Color glassBorder = Colors.white.withOpacity(0.12);
  static Color glassHighlight = Colors.white.withOpacity(0.05);

  // Primary Accent - Electric Teal (Safe/Success)
  static const Color primary = Color(0xFF2DD4BF);
  static const Color primaryLight = Color(0xFF5EEAD4);
  static const Color primaryDark = Color(0xFF14B8A6);

  // Gradient variants of primary
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2DD4BF), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Danger Accent - Neon Red (Alerts/Warnings)
  static const Color danger = Color(0xFFFF453A);
  static const Color dangerLight = Color(0xFFFF6961);
  static const Color dangerDark = Color(0xFFDC2626);

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFFF453A), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF64748B);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFFBBF24);
  static const Color info = Color(0xFF3B82F6);

  // Status Gradients
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Special Effects
  static Color shimmerBase = Colors.white.withOpacity(0.05);
  static Color shimmerHighlight = Colors.white.withOpacity(0.15);

  // Shadow for glass elements
  static List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  // Glow effect for active elements
  static List<BoxShadow> glowTeal = [
    BoxShadow(
      color: primary.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> glowRed = [
    BoxShadow(
      color: danger.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];
}
