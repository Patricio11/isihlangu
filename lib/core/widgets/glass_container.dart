import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Glass Morphism Container Widget
/// Creates a frosted glass effect with blur and transparency
class GlassContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;
  final double blur;
  final Color? color;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  const GlassContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.blur = 10,
    this.color,
    this.border,
    this.boxShadow,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: boxShadow ?? AppColors.glassShadow,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: kIsWeb
            ? Container(
                // On web, skip BackdropFilter as it can cause rendering issues
                padding: padding,
                decoration: BoxDecoration(
                  gradient: gradient,
                  color: color ?? AppColors.glassSurface,
                  borderRadius: borderRadius,
                  border: border ??
                      Border.all(
                        color: AppColors.glassBorder,
                        width: 1,
                      ),
                ),
                child: child,
              )
            : BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: Container(
                  padding: padding,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    color: color ?? AppColors.glassSurface,
                    borderRadius: borderRadius,
                    border: border ??
                        Border.all(
                          color: AppColors.glassBorder,
                          width: 1,
                        ),
                  ),
                  child: child,
                ),
              ),
      ),
    );
  }
}

/// Glass Button Widget
/// Flat neon gradient button with no shadows
class GlassButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Gradient? gradient;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius borderRadius;
  final List<BoxShadow>? boxShadow;

  const GlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient,
    this.color,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.boxShadow,
  });

  factory GlassButton.primary({
    required VoidCallback? onPressed,
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
  }) {
    return GlassButton(
      onPressed: onPressed,
      gradient: AppColors.primaryGradient,
      width: width,
      height: height,
      padding: padding,
      child: child,
    );
  }

  factory GlassButton.danger({
    required VoidCallback? onPressed,
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
  }) {
    return GlassButton(
      onPressed: onPressed,
      gradient: AppColors.dangerGradient,
      width: width,
      height: height,
      padding: padding,
      child: child,
    );
  }

  factory GlassButton.secondary({
    required VoidCallback? onPressed,
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
  }) {
    return GlassButton(
      onPressed: onPressed,
      color: AppColors.glassSurface,
      width: width,
      height: height,
      padding: padding,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null ? (color ?? AppColors.primary) : null,
              borderRadius: borderRadius,
            ),
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              alignment: Alignment.center,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular Glass Button
/// Perfect for action buttons on home screen
class CircularGlassButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? label;
  final double size;
  final Color? iconColor;
  final Color? backgroundColor;

  const CircularGlassButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.size = 70,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassContainer(
          width: size,
          height: size,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(size / 2),
          color: backgroundColor ?? AppColors.glassSurface,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(size / 2),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.primary,
                  size: size * 0.4,
                ),
              ),
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 8),
          Text(
            label!,
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Glass Card with optional glow effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool hasGlow;
  final Color? glowColor;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.hasGlow = false,
    this.glowColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGlow = hasGlow
        ? [
            BoxShadow(
              color: (glowColor ?? AppColors.primary).withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ]
        : AppColors.glassShadow;

    return GlassContainer(
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin,
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      boxShadow: effectiveGlow,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: borderRadius ?? BorderRadius.circular(16),
              child: child,
            )
          : child,
    );
  }
}
