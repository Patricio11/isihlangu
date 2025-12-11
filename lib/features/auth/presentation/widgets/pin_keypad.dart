import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/utils/haptics.dart';

/// PIN Keypad Widget
/// Minimal, glass-style keypad for PIN entry
class PinKeypad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onDeletePressed;

  const PinKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 16),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 16),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 16),
        _buildRow(['', '0', 'delete']),
      ],
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 200.ms)
        .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 200.ms);
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: digits.map((digit) {
        if (digit.isEmpty) {
          return const SizedBox(width: 80, height: 80);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: digit == 'delete'
              ? _DeleteKey(onPressed: onDeletePressed)
              : _DigitKey(
                  digit: digit,
                  onPressed: () => onDigitPressed(digit),
                ),
        );
      }).toList(),
    );
  }
}

class _DigitKey extends StatelessWidget {
  final String digit;
  final VoidCallback onPressed;

  const _DigitKey({
    required this.digit,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassContainer(
      width: 80,
      height: 80,
      borderRadius: BorderRadius.circular(40),
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticService.keypadPress();
            onPressed();
          },
          borderRadius: BorderRadius.circular(40),
          child: Center(
            child: Text(
              digit,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteKey extends StatelessWidget {
  final VoidCallback onPressed;

  const _DeleteKey({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: 80,
      height: 80,
      borderRadius: BorderRadius.circular(40),
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticService.keypadDelete();
            onPressed();
          },
          borderRadius: BorderRadius.circular(40),
          child: Center(
            child: Icon(
              Icons.backspace_outlined,
              color: context.colors.textSecondary,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
