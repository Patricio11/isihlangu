import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/floating_nav_bar.dart';
import '../../features/auth/providers/session_provider.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/payment/presentation/pay_screen.dart';
import '../../features/safety/presentation/safety_screen.dart';

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

  final List<Widget> _screens = const [
    HomeScreen(),
    PayScreen(),
    _ActivityScreen(), // Placeholder
    SafetyScreen(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to corresponding route
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/pay');
        break;
      case 2:
        context.go('/activity');
        break;
      case 3:
        context.go('/safety');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider).session;
    final isRestricted = session?.isRestricted ?? false;

    return Scaffold(
      body: Stack(
        children: [
          // Current screen
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Floating navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
              isRestricted: isRestricted,
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
