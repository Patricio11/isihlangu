import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/floating_nav_bar.dart';
import '../../features/auth/providers/session_provider.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/payment/presentation/pay_screen.dart';
import '../../features/safety/presentation/safety_screen.dart';
import '../../features/family/presentation/family_screen.dart';

/// Main Scaffold with Bottom Navigation
/// Manages the main app screens with floating glass nav bar
class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;

  const MainScaffold({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _currentIndex = 0;

  // ROADMAP Task 1.15.7: Role-Based Navigation
  // Parent screens (5 tabs): Home | Family | Pay | Safety | Profile
  final List<Widget> _parentScreens = const [
    HomeScreen(),
    FamilyScreen(),
    PayScreen(),
    SafetyScreen(),
    _ActivityScreen(), // Placeholder for Activity
  ];

  // Child screens (4 tabs): Home | Pay | Safety | Profile
  final List<Widget> _childScreens = const [
    HomeScreen(),
    PayScreen(),
    SafetyScreen(),
    _ActivityScreen(), // Placeholder for Activity
  ];

  void _onNavTap(int index, bool isParent) {
    setState(() {
      _currentIndex = index;
    });

    // ROADMAP Task 1.15.7: Role-based navigation routes
    if (isParent) {
      // Parent: Home | Family | Pay | Safety | Activity
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/family');
          break;
        case 2:
          context.go('/pay');
          break;
        case 3:
          context.go('/safety');
          break;
        case 4:
          context.go('/activity');
          break;
      }
    } else {
      // Child: Home | Pay | Safety | Activity
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/pay');
          break;
        case 2:
          context.go('/safety');
          break;
        case 3:
          context.go('/activity');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider).session;
    final isRestricted = session?.isRestricted ?? false;
    final isParent = session?.isParent ?? true; // Default to parent

    return Scaffold(
      body: Stack(
        children: [
          // Current screen - different screens for parent vs child
          IndexedStack(
            index: _currentIndex,
            children: isParent ? _parentScreens : _childScreens,
          ),

          // Floating navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingNavBar(
              currentIndex: _currentIndex,
              onTap: (index) => _onNavTap(index, isParent),
              isRestricted: isRestricted,
              isParent: isParent,
            ),
          ),
        ],
      ),
    );
  }
}

/// Activity Screen Placeholder
/// TODO: Implement full activity/transaction history screen
class _ActivityScreen extends ConsumerWidget {
  const _ActivityScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.white24,
            ),
            const SizedBox(height: 16),
            Text(
              'Activity Screen',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon in Phase 2',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
