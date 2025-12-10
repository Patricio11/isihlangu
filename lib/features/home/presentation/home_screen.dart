import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/animated_mesh_gradient.dart';
import '../../../core/data/fake_transactions.dart';
import '../../../core/data/fake_user_profile.dart';
import '../../../core/data/fake_notifications.dart';
import '../../../core/utils/haptics.dart';
import '../../auth/providers/session_provider.dart';
import 'widgets/gyroscope_balance_card.dart';
import 'widgets/pulse_indicator.dart';
import 'widgets/transaction_list.dart';
import 'widgets/family_overview_section.dart';

/// Home Screen - The Main Dashboard
/// ROADMAP: Task 1.3 - The Home Dashboard (The "Wow" Factor)
/// Features:
/// - Gyroscope-tilting balance card
/// - Pulse indicator showing shield status
/// - Staggered transaction list
/// - Different data for Safe vs Duress mode
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kDebugMode) {
      print('🏠 HomeScreen building...');
    }

    final session = ref.watch(sessionProvider).session;
    final theme = Theme.of(context);

    if (session == null) {
      if (kDebugMode) {
        print('⚠️  HomeScreen: No session found');
      }
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isDuressMode = session.isRestricted;
    if (kDebugMode) {
      print('🏠 HomeScreen: Mode = ${isDuressMode ? 'DURESS' : 'SAFE'}');
    }

    // Check if user is a parent (for family overview section)
    final isParent = session.isParent;

    final transactions = FakeTransactions.getTransactions(isDuressMode: isDuressMode);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _buildGreeting(context, session.userName),
        actions: [
          // Notifications
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_rounded),
                  onPressed: () {
                    HapticService.lightImpact();
                    context.push('/notifications');
                  },
                ),
                if (FakeNotifications.unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${FakeNotifications.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Profile Avatar
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                HapticService.lightImpact();
                context.push('/profile');
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    FakeUserProfile.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Pulse Indicator
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 8),
            child: PulseIndicator(
              isActive: !isDuressMode,
              size: 40,
            ),
          ),
        ],
      ),
      body: StaticGradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Top spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),

              // Balance Card
              SliverToBoxAdapter(
                child: GyroscopeBalanceCard(
                  balance: session.balance,
                  isRestricted: isDuressMode,
                  onTap: () {
                    HapticService.lightImpact();
                    context.push('/card');
                  },
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, end: 0, duration: 600.ms),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),

              // Family Overview Section (Parent only)
              if (isParent) ...[
                SliverToBoxAdapter(
                  child: FamilyOverviewSection(
                    onViewAllTapped: () {
                      HapticService.lightImpact();
                      context.push('/family');
                    },
                    onMemberTapped: (member) {
                      HapticService.lightImpact();
                      if (member.role == 'child') {
                        // Navigate to child control panel
                        context.push('/family/child-control/${member.id}');
                      }
                    },
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 200.ms),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],

              // Action Buttons
              SliverToBoxAdapter(
                child: _buildActionButtons(context, isDuressMode)
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 200.ms),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),

              // Recent Activity Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to all transactions
                        },
                        child: Text(
                          'See All',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideX(begin: -0.1, end: 0, duration: 600.ms, delay: 300.ms),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),

              // Transaction List
              SliverToBoxAdapter(
                child: TransactionList(transactions: transactions),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 100), // Bottom padding for nav bar
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context, String userName) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          greeting,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        Text(
          userName.split(' ').first, // First name only
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDuressMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ActionButton(
            icon: Icons.payment,
            label: 'Pay',
            color: AppColors.primary,
            onPressed: () {
              // TODO: Navigate to pay screen
            },
          ),
          _ActionButton(
            icon: Icons.add_circle_outline,
            label: 'Top Up',
            color: AppColors.success,
            onPressed: isDuressMode
                ? null
                : () {
                    // TODO: Navigate to top up
                  },
          ),
          _ActionButton(
            icon: Icons.lock_outline,
            label: 'Freeze',
            color: AppColors.warning,
            onPressed: isDuressMode
                ? null
                : () {
                    // TODO: Show freeze dialog
                  },
          ),
          _ActionButton(
            icon: Icons.credit_card,
            label: 'Card',
            color: AppColors.info,
            onPressed: () {
              HapticService.lightImpact();
              context.push('/card');
            },
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassContainer(
          width: 70,
          height: 70,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(35),
          color: isDisabled ? AppColors.glassSurface : color.withOpacity(0.15),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(35),
              child: Center(
                child: Icon(
                  icon,
                  color: isDisabled ? AppColors.textTertiary : color,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isDisabled ? AppColors.textTertiary : AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
