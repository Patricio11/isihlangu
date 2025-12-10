import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/domain/user_session.dart';
import '../../features/auth/providers/session_provider.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/card/presentation/card_screen.dart';
import '../../features/activity/presentation/transaction_detail_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../core/data/fake_transactions.dart';
import 'main_scaffold.dart';

/// App Router Configuration
/// Uses GoRouter for navigation with authentication guards
class AppRouter {
  final Ref ref;

  AppRouter(this.ref);

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    refreshListenable: _AuthNotifier(ref),
    redirect: (context, state) {
      final isAuthenticated = ref.read(sessionProvider).isAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';
      final isOnboardingRoute = state.matchedLocation == '/onboarding';

      // Allow onboarding route without authentication
      if (isOnboardingRoute) {
        return null;
      }

      // If not authenticated and not on login, redirect to login
      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      // If authenticated and on login, redirect to home
      if (isAuthenticated && isLoginRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      // Onboarding route (accessible anytime)
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Login route
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Main scaffold with bottom nav (contains home, pay, activity, safety)
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => NoTransitionPage(
              child: Container(), // HomeScreen will be loaded by MainScaffold
            ),
          ),
          GoRoute(
            path: '/pay',
            name: 'pay',
            pageBuilder: (context, state) => NoTransitionPage(
              child: Container(), // PayScreen will be loaded by MainScaffold
            ),
          ),
          GoRoute(
            path: '/activity',
            name: 'activity',
            pageBuilder: (context, state) => NoTransitionPage(
              child: Container(), // ActivityScreen will be loaded by MainScaffold
            ),
          ),
          GoRoute(
            path: '/safety',
            name: 'safety',
            pageBuilder: (context, state) => NoTransitionPage(
              child: Container(), // SafetyScreen will be loaded by MainScaffold
            ),
          ),
        ],
      ),

      // Profile route (outside shell - full screen)
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Settings route (outside shell - full screen)
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Card route (outside shell - full screen)
      GoRoute(
        path: '/card',
        name: 'card',
        builder: (context, state) => const CardScreen(),
      ),

      // Transaction Detail route (outside shell - full screen)
      GoRoute(
        path: '/transaction/:id',
        name: 'transaction',
        builder: (context, state) {
          final transaction = state.extra as Transaction;
          return TransactionDetailScreen(transaction: transaction);
        },
      ),

      // Notifications route (outside shell - full screen)
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
}

/// Auth state notifier for route refresh
class _AuthNotifier extends ChangeNotifier {
  final Ref _ref;
  SessionState? _lastState;

  _AuthNotifier(this._ref) {
    _ref.listen(sessionProvider, (previous, next) {
      if (_lastState?.isAuthenticated != next.isAuthenticated) {
        _lastState = next;
        notifyListeners();
      }
    });
  }
}

/// Router Provider
final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter(ref).router;
});
