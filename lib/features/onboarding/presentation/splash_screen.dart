import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

/// Splash Screen
/// Animated shield logo with gradient background fade-in
/// Displays for 2 seconds then auto-navigates
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // TODO: Check if first launch
      // If first launch, go to onboarding
      // If not, go to login
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colors.background,
              context.colors.backgroundSecondary,
              context.colors.background,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shield Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: context.colors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.primary.withAlpha(77),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  size: 64,
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

              const SizedBox(height: 32),

              // App Name
              Text(
                'SHIELD',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 400.ms)
                  .slideY(
                    begin: 0.5,
                    end: 0,
                    duration: 800.ms,
                    delay: 400.ms,
                  ),

              const SizedBox(height: 16),

              // Tagline
              Text(
                'Safety-First Banking',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: context.colors.textSecondary,
                      letterSpacing: 2,
                    ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 800.ms)
                  .slideY(
                    begin: 0.5,
                    end: 0,
                    duration: 800.ms,
                    delay: 800.ms,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
