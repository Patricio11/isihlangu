import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/haptics.dart';

/// Custom Pull-to-Refresh with Shield Icon Animation
/// Shield icon fills up as user pulls down
class ShieldRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const ShieldRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        HapticService.mediumImpact();
        await onRefresh();
        HapticService.success();
      },
      color: AppColors.primary,
      backgroundColor: AppColors.backgroundSecondary,
      strokeWidth: 3,
      displacement: 60,
      child: child,
    );
  }
}

/// Advanced Shield Refresh Indicator with Custom Animation
/// Shows a filling shield icon as the user pulls
class AdvancedShieldRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const AdvancedShieldRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<AdvancedShieldRefresh> createState() => _AdvancedShieldRefreshState();
}

class _AdvancedShieldRefreshState extends State<AdvancedShieldRefresh>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isRefreshing = false;
  double _dragOffset = 0.0;
  static const double _refreshThreshold = 80.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);
    HapticService.mediumImpact();
    _controller.repeat();

    try {
      await widget.onRefresh();
      HapticService.success();
    } finally {
      _controller.stop();
      _controller.reset();
      setState(() {
        _isRefreshing = false;
        _dragOffset = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (notification.metrics.pixels < 0 && !_isRefreshing) {
            setState(() {
              _dragOffset = -notification.metrics.pixels;
              if (_dragOffset >= _refreshThreshold * 0.5) {
                HapticService.subtle();
              }
            });
          }
        } else if (notification is ScrollEndNotification) {
          if (_dragOffset >= _refreshThreshold && !_isRefreshing) {
            _handleRefresh();
          } else {
            setState(() => _dragOffset = 0.0);
          }
        }
        return false;
      },
      child: Stack(
        children: [
          widget.child,
          if (_dragOffset > 0 || _isRefreshing)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _ShieldRefreshHeader(
                dragOffset: _dragOffset,
                threshold: _refreshThreshold,
                isRefreshing: _isRefreshing,
                animation: _controller,
              ),
            ),
        ],
      ),
    );
  }
}

class _ShieldRefreshHeader extends StatelessWidget {
  final double dragOffset;
  final double threshold;
  final bool isRefreshing;
  final Animation<double> animation;

  const _ShieldRefreshHeader({
    required this.dragOffset,
    required this.threshold,
    required this.isRefreshing,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (dragOffset / threshold).clamp(0.0, 1.0);
    final opacity = progress.clamp(0.0, 1.0);
    final height = (dragOffset * 0.8).clamp(0.0, 80.0);

    return Container(
      height: height,
      alignment: Alignment.center,
      child: Opacity(
        opacity: opacity,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: isRefreshing ? animation.value * 2 * math.pi : 0,
              child: CustomPaint(
                size: const Size(40, 40),
                painter: _ShieldIconPainter(
                  fillProgress: isRefreshing ? 1.0 : progress,
                  color: AppColors.primary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ShieldIconPainter extends CustomPainter {
  final double fillProgress;
  final Color color;

  _ShieldIconPainter({
    required this.fillProgress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final fillPaint = Paint()
      ..color = color.withAlpha((fillProgress * 255).toInt())
      ..style = PaintingStyle.fill;

    // Draw shield outline
    final path = _createShieldPath(size);
    canvas.drawPath(path, paint);

    // Draw fill based on progress
    if (fillProgress > 0) {
      canvas.save();
      final fillHeight = size.height * (1 - fillProgress);
      canvas.clipRect(Rect.fromLTWH(0, fillHeight, size.width, size.height));
      canvas.drawPath(path, fillPaint);
      canvas.restore();
    }
  }

  Path _createShieldPath(Size size) {
    final path = Path();
    final centerX = size.width / 2;

    // Shield shape
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
  bool shouldRepaint(_ShieldIconPainter oldDelegate) {
    return oldDelegate.fillProgress != fillProgress;
  }
}
