import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';

/// Onboarding Page Data Model
class OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;

  const OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}

/// Single Onboarding Page
/// Displays an icon, title, and description with animations
class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with gradient background
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: data.gradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getGradientColor(data.gradient).withAlpha(77),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Icon(
              data.icon,
              size: 80,
              color: Colors.white,
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                duration: 800.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: 600.ms),

          const SizedBox(height: 64),

          // Title
          Text(
            data.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 400.ms)
              .slideY(
                begin: 0.3,
                end: 0,
                duration: 800.ms,
                delay: 400.ms,
              ),

          const SizedBox(height: 24),

          // Description
          Text(
            data.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 800.ms, delay: 600.ms)
              .slideY(
                begin: 0.3,
                end: 0,
                duration: 800.ms,
                delay: 600.ms,
              ),
        ],
      ),
    );
  }

  /// Extract color from gradient for glow effect
  Color _getGradientColor(Gradient gradient) {
    if (gradient is LinearGradient && gradient.colors.isNotEmpty) {
      return gradient.colors.first;
    }
    return AppColors.primary;
  }
}
