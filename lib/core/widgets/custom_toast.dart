import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../utils/haptics.dart';

/// Custom Toast Notification System
/// Styled toast notifications with icons, colors, and haptic feedback
class CustomToast {
  /// Show a success toast with green glow and checkmark
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    HapticService.success();
    _showToast(
      context,
      message: message,
      icon: Icons.check_circle_rounded,
      gradient: context.colors.successGradient,
      glowColor: context.colors.success,
      duration: duration,
    );
  }

  /// Show an error toast with red glow and X icon
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    HapticService.error();
    _showToast(
      context,
      message: message,
      icon: Icons.cancel_rounded,
      gradient: context.colors.dangerGradient,
      glowColor: context.colors.danger,
      duration: duration,
    );
  }

  /// Show an info toast with teal glow and info icon
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    HapticService.lightImpact();
    _showToast(
      context,
      message: message,
      icon: Icons.info_rounded,
      gradient: context.colors.primaryGradient,
      glowColor: context.colors.primary,
      duration: duration,
    );
  }

  /// Show a warning toast with orange glow and warning icon
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    HapticService.warning();
    _showToast(
      context,
      message: message,
      icon: Icons.warning_rounded,
      gradient: context.colors.warningGradient,
      glowColor: context.colors.warning,
      duration: duration,
    );
  }

  /// Show "Silent Alert Sent" toast for duress mode (testing only)
  /// SECURITY: This should NEVER appear in production for real duress alerts
  static void showSilentAlertTest(
    BuildContext context, {
    Duration duration = const Duration(seconds: 1),
  }) {
    // No haptic for silent alert (security)
    _showToast(
      context,
      message: 'Silent Alert Sent (Test Mode)',
      icon: Icons.shield_rounded,
      gradient: context.colors.dangerGradient,
      glowColor: context.colors.danger,
      duration: duration,
    );
  }

  static void _showToast(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Gradient gradient,
    required Color glowColor,
    required Duration duration,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        icon: icon,
        gradient: gradient,
        glowColor: glowColor,
        duration: duration,
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration + const Duration(milliseconds: 500), () {
      overlayEntry.remove();
    });
  }
}

class _ToastWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final Gradient gradient;
  final Color glowColor;
  final Duration duration;

  const _ToastWidget({
    required this.message,
    required this.icon,
    required this.gradient,
    required this.glowColor,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          .animate()
          .slideY(
            begin: -1,
            end: 0,
            duration: 300.ms,
            curve: Curves.easeOutCubic,
          )
          .fadeIn(duration: 300.ms)
          .then(delay: duration)
          .slideY(
            begin: 0,
            end: -1,
            duration: 300.ms,
            curve: Curves.easeInCubic,
          )
          .fadeOut(duration: 300.ms),
    );
  }
}
