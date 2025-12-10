import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated Mesh Gradient Background
/// Creates a subtle, moving gradient effect perfect for auth screens
class AnimatedMeshGradient extends StatefulWidget {
  final Widget? child;

  const AnimatedMeshGradient({
    super.key,
    this.child,
  });

  @override
  State<AnimatedMeshGradient> createState() => _AnimatedMeshGradientState();
}

class _AnimatedMeshGradientState extends State<AnimatedMeshGradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: MeshGradientPainter(
            animation: _controller.value,
            isDark: isDark,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class MeshGradientPainter extends CustomPainter {
  final double animation;
  final bool isDark;

  MeshGradientPainter({required this.animation, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    // Base gradient - adapts to theme
    final baseGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              AppColors.darkBackground,
              AppColors.darkBackgroundSecondary,
              AppColors.darkBackground,
            ]
          : [
              AppColors.lightBackground,
              AppColors.lightBackgroundSecondary,
              AppColors.lightBackground,
            ],
    );

    final baseRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final basePaint = Paint()..shader = baseGradient.createShader(baseRect);
    canvas.drawRect(baseRect, basePaint);

    // Animated gradient blobs - more subtle in light mode
    final blobOpacity = isDark ? 0.05 : 0.08;

    _drawAnimatedBlob(
      canvas,
      size,
      offsetX: size.width * 0.2 + math.sin(animation * 2 * math.pi) * 50,
      offsetY: size.height * 0.3 + math.cos(animation * 2 * math.pi) * 50,
      color: AppColors.primary.withValues(alpha: blobOpacity),
      radius: 150,
    );

    _drawAnimatedBlob(
      canvas,
      size,
      offsetX: size.width * 0.8 + math.cos(animation * 2 * math.pi) * 40,
      offsetY: size.height * 0.6 + math.sin(animation * 2 * math.pi) * 40,
      color: AppColors.primaryDark.withValues(alpha: blobOpacity * 0.8),
      radius: 180,
    );

    _drawAnimatedBlob(
      canvas,
      size,
      offsetX: size.width * 0.5 + math.sin(animation * 2 * math.pi + 1) * 60,
      offsetY: size.height * 0.8 + math.cos(animation * 2 * math.pi + 1) * 60,
      color: AppColors.info.withValues(alpha: blobOpacity * 0.6),
      radius: 120,
    );
  }

  void _drawAnimatedBlob(
    Canvas canvas,
    Size size, {
    required double offsetX,
    required double offsetY,
    required Color color,
    required double radius,
  }) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color,
          color.withValues(alpha: 0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: Offset(offsetX, offsetY),
          radius: radius,
        ),
      );

    canvas.drawCircle(
      Offset(offsetX, offsetY),
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(MeshGradientPainter oldDelegate) {
    return oldDelegate.animation != animation || oldDelegate.isDark != isDark;
  }
}

/// Static Gradient Background (For screens that don't need animation)
/// Theme-aware: Adapts to light/dark mode
class StaticGradientBackground extends StatelessWidget {
  final Widget? child;

  const StaticGradientBackground({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.darkBackground,
                  AppColors.darkBackgroundSecondary,
                  AppColors.darkBackground,
                ]
              : [
                  AppColors.lightBackground,
                  AppColors.lightBackgroundSecondary,
                  AppColors.lightBackground,
                ],
        ),
      ),
      child: child,
    );
  }
}
