import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

/// PIN Dots Widget
/// Displays 4 dots that glow teal as the user types
class PinDots extends StatelessWidget {
  final int filledCount;
  final bool hasError;

  const PinDots({
    super.key,
    required this.filledCount,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isFilled = index < filledCount;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _PinDot(
            isFilled: isFilled,
            hasError: hasError,
            index: index,
          ),
        );
      }),
    );
  }
}

class _PinDot extends StatelessWidget {
  final bool isFilled;
  final bool hasError;
  final int index;

  const _PinDot({
    required this.isFilled,
    required this.hasError,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final color = hasError
        ? AppColors.danger
        : isFilled
            ? AppColors.primary
            : AppColors.glassBorder;

    final boxShadow = isFilled && !hasError
        ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ]
        : <BoxShadow>[];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? color : Colors.transparent,
        border: Border.all(
          color: color,
          width: 2,
        ),
        boxShadow: boxShadow,
      ),
    )
        .animate(
          target: isFilled ? 1 : 0,
        )
        .scale(
          duration: 200.ms,
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        );
  }
}
