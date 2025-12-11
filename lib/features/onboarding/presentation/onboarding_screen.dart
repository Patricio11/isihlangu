import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/utils/haptics.dart';
import '../providers/onboarding_provider.dart';
import 'widgets/onboarding_page.dart';

/// Onboarding Carousel
/// 3-slide walkthrough introducing Shield's key features
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _skipTapCount = 0;

  late final List<OnboardingPageData> _pages;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pages = [
      OnboardingPageData(
        icon: Icons.shield_rounded,
        title: 'Your Money, Protected',
        description: 'Bank with confidence knowing your funds are secure with military-grade encryption and advanced safety features.',
        gradient: context.colors.primaryGradient,
      ),
      OnboardingPageData(
        icon: Icons.family_restroom_rounded,
        title: 'Family Finance Made Simple',
        description: 'Manage your family\'s money together. Set allowances, assign chores, and teach financial responsibility.',
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      OnboardingPageData(
        icon: Icons.security_rounded,
        title: 'Duress Protection',
        description: 'Stay safe in emergencies with our unique duress mode. Your safety is our top priority.',
        gradient: context.colors.dangerGradient,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    HapticService.selectionClick();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _skipTapCount++;

    // Easter egg: 5 taps on skip to bypass onboarding (debug feature)
    if (_skipTapCount >= 5) {
      HapticService.success();
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    ref.read(onboardingProvider.notifier).completeOnboarding();
    // Navigate to permission screen to request critical permissions
    context.go('/onboarding/permissions');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: _skipOnboarding,
                  child: Text(
                    'Skip',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _pages[index]);
                },
              ),
            ),

            // Progress Dots
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? context.colors.primary
                          : context.colors.textTertiary.withAlpha(77),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Next/Get Started Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: GlassButton.primary(
                onPressed: () {
                  HapticService.mediumImpact();
                  _nextPage();
                },
                width: double.infinity,
                height: 56,
                child: Text(
                  isLastPage ? 'Get Started' : 'Next',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
