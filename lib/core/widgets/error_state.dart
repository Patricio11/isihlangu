import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../utils/haptics.dart';

/// Error State Widget
/// Displays error messages with retry functionality
class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final bool showRetryButton;

  const ErrorState({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.showRetryButton = true,
  });

  /// Network error state
  factory ErrorState.network({VoidCallback? onRetry}) {
    return ErrorState(
      title: 'Connection Lost',
      message: 'Unable to connect to the network.\nPlease check your connection and try again.',
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
    );
  }

  /// Generic error state
  factory ErrorState.generic({VoidCallback? onRetry, String? customMessage}) {
    return ErrorState(
      title: 'Something Went Wrong',
      message: customMessage ?? 'An unexpected error occurred.\nPlease try again.',
      icon: Icons.error_outline,
      onRetry: onRetry,
    );
  }

  /// Session expired state
  factory ErrorState.sessionExpired({VoidCallback? onLogin}) {
    return ErrorState(
      title: 'Session Expired',
      message: 'Your session has expired for security reasons.\nPlease log in again.',
      icon: Icons.lock_clock_rounded,
      onRetry: onLogin,
      showRetryButton: true,
    );
  }

  /// Server error state
  factory ErrorState.server({VoidCallback? onRetry}) {
    return ErrorState(
      title: 'Server Error',
      message: 'Our servers are having issues.\nWe\'re working to fix this.',
      icon: Icons.cloud_off_rounded,
      onRetry: onRetry,
    );
  }

  /// Permission denied
  factory ErrorState.permissionDenied({String? permission}) {
    return ErrorState(
      title: 'Permission Required',
      message: permission != null
          ? 'Shield needs $permission permission to continue'
          : 'Please grant the required permissions in Settings',
      icon: Icons.block_rounded,
      showRetryButton: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.danger.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.danger,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8), duration: 600.ms)
                .shake(duration: 800.ms, delay: 200.ms, hz: 2),
            const SizedBox(height: 32),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 200.ms),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 400.ms)
                .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 400.ms),
            if (showRetryButton && onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  HapticService.mediumImpact();
                  onRetry?.call();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 600.ms),
            ],
          ],
        ),
      ),
    );
  }
}
