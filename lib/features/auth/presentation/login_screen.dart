import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/animated_mesh_gradient.dart';
import '../../../core/security/duress_state_manager.dart';
import '../domain/auth_state.dart';
import '../providers/auth_provider.dart';
import '../providers/session_provider.dart';
import 'widgets/pin_dots.dart';
import 'widgets/pin_keypad.dart';

/// Login Screen - The "Stealth" Auth Screen
/// Features:
/// - Animated mesh gradient background
/// - Biometric icon centered
/// - 6-dot PIN entry with teal glow
/// - Clean keypad below
/// - NO visual difference between Real PIN and Panic PIN
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kDebugMode) {
      print('🔐 LoginScreen building...');
    }

    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final theme = Theme.of(context);

    // Set status bar style (skip on web)
    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(AppTheme.lightStatusBar);
    }

    // Listen for authentication success
    ref.listen(
      authProvider,
      (AuthState? previous, AuthState next) {
        if (next.isAuthenticated && context.mounted) {
          // PHASE 1: Create mock session
          // PHASE 2: Session will be created from Supabase Edge Function response
          // ROADMAP Task 1.15: Pass role and user info to session
          ref.read(sessionProvider.notifier).createMockSession(
            isDuressMode: next.isPanicMode,
            userId: next.userId,
            userName: next.userName,
            role: next.role,
            balance: next.balance,
          );

          // ROADMAP Task 1.4 & 1.6.2: Silent alert + Persistent Duress Mode
          if (next.isPanicMode) {
            // CRITICAL: Activate THE TRAP DOOR
            // Once duress mode is activated, it persists until parent remote unlock
            DuressStateManager.getInstance().then((manager) {
              manager.activateDuressMode(
                userId: next.userId ?? 'unknown',
                location: null, // TODO Phase 2: Get actual GPS location
              );
            });

            // SECURITY: In production, this toast should NOT appear
            // Silent alert should happen server-side without any client feedback
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Silent Alert Sent (Test Mode)',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                backgroundColor: AppColors.danger,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }

          // Navigate to home screen
          Future.delayed(const Duration(milliseconds: 300), () {
            if (context.mounted) {
              context.go('/home');
            }
          });
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedMeshGradient(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // App Logo/Shield Icon
                        _buildLogo(context)
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .scale(
                              duration: 800.ms,
                              curve: Curves.easeOutBack,
                            ),

                        const SizedBox(height: 32),

                        // App Title
                        Text(
                          'SHIELD',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            letterSpacing: 8,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 800.ms, delay: 200.ms)
                            .slideY(begin: 0.2, end: 0, duration: 800.ms, delay: 200.ms),

                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          'Secure Banking',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            letterSpacing: 2,
                            color: AppColors.textTertiary,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 800.ms, delay: 300.ms)
                            .slideY(begin: 0.2, end: 0, duration: 800.ms, delay: 300.ms),

                        const SizedBox(height: 48),

                        // Instruction Text
                        Text(
                          'Enter your PIN',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 400.ms)
                            .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 400.ms),

                        const SizedBox(height: 24),

                        // PIN Dots
                        PinDots(
                          filledCount: authState.pin.length,
                          hasError: authState.error != null,
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 500.ms)
                            .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 500.ms),

                        const SizedBox(height: 16),

                        // Error Message
                        SizedBox(
                          height: 24,
                          child: authState.error != null
                              ? Text(
                                  authState.error!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.danger,
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 200.ms)
                                    .shake(duration: 400.ms)
                              : const SizedBox.shrink(),
                        ),

                        const Spacer(),

                        // PIN Keypad
                        PinKeypad(
                          onDigitPressed: authNotifier.addDigit,
                          onDeletePressed: authNotifier.removeDigit,
                        ),

                        const SizedBox(height: 24),

                        // New User Button
                        TextButton.icon(
                          onPressed: () {
                            // Navigate to onboarding which will handle permission requests
                            context.push('/onboarding');
                          },
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                          label: const Text('New User? Get Started'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 600.ms),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        boxShadow: AppColors.glowTeal,
      ),
      child: const Icon(
        Icons.shield_outlined,
        size: 50,
        color: AppColors.background,
      ),
    );
  }
}
