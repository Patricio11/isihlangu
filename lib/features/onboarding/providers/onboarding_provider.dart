import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Onboarding State
class OnboardingState {
  final bool hasCompletedOnboarding;
  final bool isFirstLaunch;

  const OnboardingState({
    this.hasCompletedOnboarding = false,
    this.isFirstLaunch = true,
  });

  OnboardingState copyWith({
    bool? hasCompletedOnboarding,
    bool? isFirstLaunch,
  }) {
    return OnboardingState(
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }
}

/// Onboarding Provider
/// Manages onboarding completion state
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState()) {
    _loadOnboardingState();
  }

  static const String _hasCompletedKey = 'has_completed_onboarding';
  static const String _isFirstLaunchKey = 'is_first_launch';

  /// Load onboarding state from SharedPreferences
  Future<void> _loadOnboardingState() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompleted = prefs.getBool(_hasCompletedKey) ?? false;
    final isFirst = prefs.getBool(_isFirstLaunchKey) ?? true;

    state = OnboardingState(
      hasCompletedOnboarding: hasCompleted,
      isFirstLaunch: isFirst,
    );
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCompletedKey, true);
    await prefs.setBool(_isFirstLaunchKey, false);

    state = state.copyWith(
      hasCompletedOnboarding: true,
      isFirstLaunch: false,
    );
  }

  /// Skip onboarding (debug feature)
  Future<void> skipOnboarding() async {
    await completeOnboarding();
  }

  /// Reset onboarding (debug feature)
  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_hasCompletedKey);
    await prefs.remove(_isFirstLaunchKey);

    state = const OnboardingState(
      hasCompletedOnboarding: false,
      isFirstLaunch: true,
    );
  }
}

/// Onboarding Provider
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});
