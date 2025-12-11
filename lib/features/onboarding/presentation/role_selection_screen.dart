import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/utils/haptics.dart';

/// Role Selection Screen
/// ROADMAP: Task 1.15.1 - Role Selection
/// Allows user to choose between Parent or Child role
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Title
              Text(
                'Welcome to Shield',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: -0.2, end: 0, duration: 600.ms),

              const SizedBox(height: 16),

              Text(
                'Choose your account type',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: context.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: -0.1, end: 0, duration: 600.ms, delay: 200.ms),

              const SizedBox(height: 80),

              // Parent Button
              _RoleCard(
                icon: Icons.family_restroom_rounded,
                title: 'I\'m a Parent',
                subtitle: 'Create a family account and manage your children\'s finances',
                gradient: context.colors.primaryGradient,
                onTap: () {
                  HapticService.mediumImpact();
                  context.push('/onboarding/create-family');
                },
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms)
                  .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 400.ms),

              const SizedBox(height: 24),

              // Child Button
              _RoleCard(
                icon: Icons.person_rounded,
                title: 'I\'m joining my family',
                subtitle: 'Enter your family code to join an existing family account',
                gradient: context.colors.successGradient,
                onTap: () {
                  HapticService.mediumImpact();
                  context.push('/onboarding/join-family');
                },
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 600.ms),

              const Spacer(),

              // Back button
              TextButton(
                onPressed: () {
                  HapticService.lightImpact();
                  context.pop();
                },
                child: const Text('Back'),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 20),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: context.colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
