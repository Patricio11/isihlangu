import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Pulse Indicator
/// A glowing green ring around the shield icon that pulses
/// ROADMAP: Task 1.3 - The "Pulse Indicator"
class PulseIndicator extends StatefulWidget {
  final bool isActive;
  final double size;

  const PulseIndicator({
    super.key,
    this.isActive = true,
    this.size = 50,
  });

  @override
  State<PulseIndicator> createState() => _PulseIndicatorState();
}

class _PulseIndicatorState extends State<PulseIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(PulseIndicator oldWidget) {
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
      width: widget.size * 1.6,
      height: widget.size * 1.6,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing ring
          if (widget.isActive)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colors.success.withValues(alpha: _opacityAnimation.value),
                        width: 3,
                      ),
                    ),
                  ),
                );
              },
            ),

          // Inner shield icon with glow
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.glassSurface,
              border: Border.all(
                color: widget.isActive ? context.colors.success : context.colors.textTertiary,
                width: 2,
              ),
              boxShadow: widget.isActive
                  ? [
                      BoxShadow(
                        color: context.colors.success.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              Icons.shield,
              color: widget.isActive ? context.colors.success : context.colors.textTertiary,
              size: widget.size * 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
