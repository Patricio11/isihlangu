import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Loading Overlay Widget
/// Full-screen loading indicator with animated shield
class LoadingOverlay extends StatelessWidget {
  final String? message;
  final bool isTransparent;

  const LoadingOverlay({
    super.key,
    this.message,
    this.isTransparent = false,
  });

  /// Show loading overlay
  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => LoadingOverlay(message: message),
    );
  }

  /// Hide loading overlay
  static void hide(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async => false, // Prevent dismissal
      child: Material(
        color: isTransparent
            ? Colors.transparent
            : AppColors.background.withAlpha(230),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AnimatedShieldLoader(),
              if (message != null) ...[
                const SizedBox(height: 24),
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated Shield Loader
/// Rotating shield icon with pulse effect
class AnimatedShieldLoader extends StatefulWidget {
  final double size;
  final Color? color;

  const AnimatedShieldLoader({
    super.key,
    this.size = 60,
    this.color,
  });

  @override
  State<AnimatedShieldLoader> createState() => _AnimatedShieldLoaderState();
}

class _AnimatedShieldLoaderState extends State<AnimatedShieldLoader>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _pulseController]),
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.1);

        return Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: _rotationController.value * 2 * math.pi,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (widget.color ?? AppColors.primary)
                        .withAlpha((100 * _pulseController.value).toInt()),
                    blurRadius: 20 * _pulseController.value,
                    spreadRadius: 5 * _pulseController.value,
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _ShieldLoaderPainter(
                  color: widget.color ?? AppColors.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShieldLoaderPainter extends CustomPainter {
  final Color color;

  _ShieldLoaderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..color = color.withAlpha(51)
      ..style = PaintingStyle.fill;

    final path = _createShieldPath(size);

    // Draw fill
    canvas.drawPath(path, fillPaint);

    // Draw outline
    canvas.drawPath(path, paint);

    // Draw checkmark inside shield
    final checkPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final checkPath = Path();
    checkPath.moveTo(size.width * 0.3, size.height * 0.5);
    checkPath.lineTo(size.width * 0.45, size.height * 0.65);
    checkPath.lineTo(size.width * 0.7, size.height * 0.35);

    canvas.drawPath(checkPath, checkPaint);
  }

  Path _createShieldPath(Size size) {
    final path = Path();
    final centerX = size.width / 2;

    path.moveTo(centerX, 0);
    path.lineTo(size.width * 0.9, size.height * 0.15);
    path.lineTo(size.width * 0.9, size.height * 0.55);
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.85,
      centerX,
      size.height,
    );
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.85,
      size.width * 0.1,
      size.height * 0.55,
    );
    path.lineTo(size.width * 0.1, size.height * 0.15);
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(_ShieldLoaderPainter oldDelegate) => false;
}

/// Button Loading State
/// Inline loading indicator for buttons
class ButtonLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const ButtonLoadingIndicator({
    super.key,
    this.color,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Colors.white,
        ),
      ),
    );
  }
}
