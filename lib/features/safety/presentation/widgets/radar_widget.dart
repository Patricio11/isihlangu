import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Radar Widget
/// Animated radar scanner effect for safety screen
/// ROADMAP: Task 1.4 - Safety Center with radar aesthetic
class RadarWidget extends StatefulWidget {
  final bool isActive;
  final double size;

  const RadarWidget({
    super.key,
    this.isActive = true,
    this.size = 200,
  });

  @override
  State<RadarWidget> createState() => _RadarWidgetState();
}

class _RadarWidgetState extends State<RadarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(RadarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: RadarPainter(
              animation: _controller.value,
              isActive: widget.isActive,
            ),
          );
        },
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  final double animation;
  final bool isActive;

  RadarPainter({required this.animation, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw concentric circles
    _drawCircles(canvas, center, radius);

    // Draw crosshairs
    _drawCrosshairs(canvas, center, radius);

    // Draw sweep line
    if (isActive) {
      _drawSweep(canvas, center, radius);
    }

    // Draw center dot
    _drawCenter(canvas, center);

    // Draw blips (fake signals)
    _drawBlips(canvas, center, radius);
  }

  void _drawCircles(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw 3 concentric circles
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        center,
        radius * (i / 3),
        paint,
      );
    }
  }

  void _drawCrosshairs(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.2)
      ..strokeWidth = 1;

    // Horizontal line
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      paint,
    );

    // Vertical line
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      paint,
    );
  }

  void _drawSweep(Canvas canvas, Offset center, double radius) {
    final sweepAngle = animation * 2 * math.pi;

    final sweepGradient = SweepGradient(
      colors: [
        Colors.transparent,
        AppColors.primary.withOpacity(0.5),
      ],
      stops: const [0.0, 1.0],
      startAngle: sweepAngle - 0.1,
      endAngle: sweepAngle,
    );

    final paint = Paint()
      ..shader = sweepGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    // Draw sweep line
    final lineEnd = Offset(
      center.dx + radius * math.cos(sweepAngle - math.pi / 2),
      center.dy + radius * math.sin(sweepAngle - math.pi / 2),
    );

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2;

    canvas.drawLine(center, lineEnd, linePaint);
  }

  void _drawCenter(Canvas canvas, Offset center) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 4, paint);
  }

  void _drawBlips(Canvas canvas, Offset center, double radius) {
    // Static blips at fixed positions
    final blips = [
      _Blip(angle: 45, distance: 0.4, size: 3),
      _Blip(angle: 120, distance: 0.7, size: 2),
      _Blip(angle: 200, distance: 0.5, size: 3),
      _Blip(angle: 300, distance: 0.8, size: 2),
    ];

    final paint = Paint()
      ..color = AppColors.success
      ..style = PaintingStyle.fill;

    for (final blip in blips) {
      final angleRad = blip.angle * math.pi / 180;
      final blipPos = Offset(
        center.dx + radius * blip.distance * math.cos(angleRad),
        center.dy + radius * blip.distance * math.sin(angleRad),
      );

      // Only draw blip if sweep has passed it
      final sweepAngle = animation * 360;
      final normalizedBlipAngle = (blip.angle + 90) % 360;

      if ((sweepAngle % 360) > normalizedBlipAngle ||
          sweepAngle > normalizedBlipAngle + 360) {
        final opacity = 1.0 - ((sweepAngle - normalizedBlipAngle) % 360) / 360;
        paint.color = AppColors.success.withOpacity(opacity.clamp(0.0, 1.0));

        canvas.drawCircle(blipPos, blip.size.toDouble(), paint);

        // Draw glow
        paint.color = AppColors.success.withOpacity(opacity * 0.3);
        canvas.drawCircle(blipPos, blip.size * 2.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(RadarPainter oldDelegate) {
    return oldDelegate.animation != animation || oldDelegate.isActive != isActive;
  }
}

class _Blip {
  final double angle;
  final double distance;
  final int size;

  _Blip({required this.angle, required this.distance, required this.size});
}
