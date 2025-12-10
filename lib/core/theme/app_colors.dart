import 'package:flutter/material.dart';

/// Shield App Color Palette
/// THEME-AWARE: Colors adapt automatically to light/dark mode
/// Usage: Use context.colors.background instead of AppColors.background
class AppColors {
  AppColors._();

  // ========================================
  // DARK THEME COLORS
  // ========================================

  // Background Colors (Dark)
  static const Color darkBackground = Color(0xFF0F172A); // Deep Slate Blue
  static const Color darkBackgroundSecondary = Color(0xFF1E293B);
  static const Color darkBackgroundTertiary = Color(0xFF334155);

  // Text Colors (Dark)
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextTertiary = Color(0xFF94A3B8);
  static const Color darkTextDisabled = Color(0xFF64748B);

  // ========================================
  // LIGHT THEME COLORS
  // ========================================

  // Background Colors (Light)
  static const Color lightBackground = Color(0xFFF8FAFC); // Soft Blue-Gray
  static const Color lightBackgroundSecondary = Color(0xFFFFFFFF); // Pure White
  static const Color lightBackgroundTertiary = Color(0xFFF1F5F9); // Light Gray

  // Text Colors (Light)
  static const Color lightTextPrimary = Color(0xFF0F172A); // Deep Slate
  static const Color lightTextSecondary = Color(0xFF475569); // Medium Gray
  static const Color lightTextTertiary = Color(0xFF64748B); // Light Gray
  static const Color lightTextDisabled = Color(0xFF94A3B8); // Very Light Gray

  // ========================================
  // THEME-INDEPENDENT COLORS (Same in both themes)
  // ========================================

  // Primary Accent - Teal (Safe/Success)
  static const Color primary = Color(0xFF14B8A6); // Teal 600
  static const Color primaryLight = Color(0xFF2DD4BF); // Teal 400
  static const Color primaryDark = Color(0xFF0D9488); // Teal 700

  // Danger Accent - Red (Alerts/Warnings)
  static const Color danger = Color(0xFFEF4444); // Red 500
  static const Color dangerLight = Color(0xFFF87171); // Red 400
  static const Color dangerDark = Color(0xFFDC2626); // Red 600

  // Status Colors
  static const Color success = Color(0xFF10B981); // Green 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color info = Color(0xFF3B82F6); // Blue 500

  // ========================================
  // GRADIENTS (Theme-independent)
  // ========================================

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2DD4BF), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ========================================
  // LEGACY STATIC ACCESSORS (Deprecated - use context.colors instead)
  // These return dark theme colors for backward compatibility
  // ========================================

  @Deprecated('Use context.colors.background instead')
  static const Color background = darkBackground;

  @Deprecated('Use context.colors.backgroundSecondary instead')
  static const Color backgroundSecondary = darkBackgroundSecondary;

  @Deprecated('Use context.colors.backgroundTertiary instead')
  static const Color backgroundTertiary = darkBackgroundTertiary;

  @Deprecated('Use context.colors.textPrimary instead')
  static const Color textPrimary = darkTextPrimary;

  @Deprecated('Use context.colors.textSecondary instead')
  static const Color textSecondary = darkTextSecondary;

  @Deprecated('Use context.colors.textTertiary instead')
  static const Color textTertiary = darkTextTertiary;

  @Deprecated('Use context.colors.textDisabled instead')
  static const Color textDisabled = darkTextDisabled;

  // Dynamic accessors for glass morphism (theme-aware via getters)
  @Deprecated('Use context.colors.glassSurface instead')
  static Color get glassSurface => Colors.white.withValues(alpha: 0.08);

  @Deprecated('Use context.colors.glassBorder instead')
  static Color get glassBorder => Colors.white.withValues(alpha: 0.12);

  @Deprecated('Use context.colors.glassHighlight instead')
  static Color get glassHighlight => Colors.white.withValues(alpha: 0.05);

  @Deprecated('Use context.colors.shimmerBase instead')
  static Color get shimmerBase => Colors.white.withValues(alpha: 0.05);

  @Deprecated('Use context.colors.shimmerHighlight instead')
  static Color get shimmerHighlight => Colors.white.withValues(alpha: 0.15);

  @Deprecated('Use context.colors.glassShadow instead')
  static List<BoxShadow> get glassShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  @Deprecated('Use context.colors.glowTeal instead')
  static List<BoxShadow> get glowTeal => [
    BoxShadow(
      color: primary.withValues(alpha: 0.3),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  @Deprecated('Use context.colors.glowRed instead')
  static List<BoxShadow> get glowRed => [
    BoxShadow(
      color: danger.withValues(alpha: 0.3),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];
}

/// Theme-Aware Color Extension
/// Access colors that automatically adapt to light/dark mode
/// Usage: context.colors.background, context.colors.textPrimary, etc.
extension ThemeColors on BuildContext {
  AppColorScheme get colors => AppColorScheme(this);
}

/// Theme-aware color scheme that adapts based on brightness
class AppColorScheme {
  final BuildContext context;

  AppColorScheme(this.context);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  // Background Colors
  Color get background => _isDark ? AppColors.darkBackground : AppColors.lightBackground;
  Color get backgroundSecondary => _isDark ? AppColors.darkBackgroundSecondary : AppColors.lightBackgroundSecondary;
  Color get backgroundTertiary => _isDark ? AppColors.darkBackgroundTertiary : AppColors.lightBackgroundTertiary;

  // Text Colors
  Color get textPrimary => _isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
  Color get textSecondary => _isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
  Color get textTertiary => _isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary;
  Color get textDisabled => _isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled;

  // Glass Morphism (adapted for light/dark)
  Color get glassSurface => _isDark
      ? Colors.white.withValues(alpha: 0.08)
      : Colors.white.withValues(alpha: 0.7);

  Color get glassBorder => _isDark
      ? Colors.white.withValues(alpha: 0.12)
      : Colors.black.withValues(alpha: 0.08);

  Color get glassHighlight => _isDark
      ? Colors.white.withValues(alpha: 0.05)
      : Colors.white.withValues(alpha: 0.4);

  // Shimmer Effects
  Color get shimmerBase => _isDark
      ? Colors.white.withValues(alpha: 0.05)
      : Colors.black.withValues(alpha: 0.05);

  Color get shimmerHighlight => _isDark
      ? Colors.white.withValues(alpha: 0.15)
      : Colors.black.withValues(alpha: 0.1);

  // Shadows
  List<BoxShadow> get glassShadow => [
    BoxShadow(
      color: _isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  List<BoxShadow> get glowTeal => [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: _isDark ? 0.3 : 0.2),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  List<BoxShadow> get glowRed => [
    BoxShadow(
      color: AppColors.danger.withValues(alpha: _isDark ? 0.3 : 0.2),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  // Theme-independent colors (pass-through)
  Color get primary => AppColors.primary;
  Color get primaryLight => AppColors.primaryLight;
  Color get primaryDark => AppColors.primaryDark;
  Color get danger => AppColors.danger;
  Color get dangerLight => AppColors.dangerLight;
  Color get dangerDark => AppColors.dangerDark;
  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get info => AppColors.info;

  // Gradients (pass-through)
  LinearGradient get primaryGradient => AppColors.primaryGradient;
  LinearGradient get dangerGradient => AppColors.dangerGradient;
  LinearGradient get successGradient => AppColors.successGradient;
  LinearGradient get warningGradient => AppColors.warningGradient;
}
