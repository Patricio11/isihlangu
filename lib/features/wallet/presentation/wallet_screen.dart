import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/data/fake_wallets.dart';
import '../../auth/providers/session_provider.dart';
import 'widgets/wallet_card.dart';

/// Wallet Screen - Multi-Wallet View
/// PHASE 1.5 BONUS: Additional Mock Screens
///
/// SECURITY: SAFE MODE ONLY - Duress mode users CANNOT access wallets
///
/// Features:
/// - Main Wallet (primary balance)
/// - Lunch Money (child's school wallet)
/// - Savings Pot (goals-based saving)
/// - Move money between wallets
/// - Savings progress tracking
class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final session = ref.watch(sessionProvider).session;

    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // CRITICAL: Duress mode cannot access wallets
    // Only show fake balance on home screen in duress mode
    if (session.isRestricted) {
      return _buildRestrictedView(context, theme);
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('My Wallets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              // TODO: Add new savings pot
            },
            tooltip: 'Add Savings Pot',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Total Balance Summary
            _buildTotalBalanceCard(context, theme)
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.2, end: 0, duration: 600.ms),

            const SizedBox(height: 32),

            // Wallets Section Header
            Text(
              'My Wallets',
              style: theme.textTheme.titleLarge?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms)
                .slideX(begin: -0.2, end: 0, duration: 400.ms, delay: 200.ms),

            const SizedBox(height: 16),

            // Main Wallet Card
            WalletCard(
              wallet: FakeWallets.mainWallet,
              delay: 300,
            ),

            const SizedBox(height: 16),

            // Lunch Money Wallet Card
            WalletCard(
              wallet: FakeWallets.lunchMoneyWallet,
              delay: 400,
            ),

            const SizedBox(height: 32),

            // Savings Section Header
            Text(
              'Savings Goals',
              style: theme.textTheme.titleLarge?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 500.ms)
                .slideX(begin: -0.2, end: 0, duration: 400.ms, delay: 500.ms),

            const SizedBox(height: 16),

            // Savings Pot with Goal
            WalletCard(
              wallet: FakeWallets.savingsWallet,
              delay: 600,
              showProgress: true,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Build Total Balance Summary Card
  Widget _buildTotalBalanceCard(BuildContext context, ThemeData theme) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Total Balance',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'R ${FakeWallets.totalBalance.toStringAsFixed(2)}',
            style: theme.textTheme.displaySmall?.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Across ${FakeWallets.allWallets.length} wallets',
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.colors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build Restricted View (Duress Mode)
  /// Duress mode users should never see this screen
  /// They are redirected away or shown this message
  Widget _buildRestrictedView(BuildContext context, ThemeData theme) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('My Wallets'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wallet_outlined,
                size: 80,
                color: context.colors.textTertiary,
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(duration: 600.ms),

              const SizedBox(height: 24),

              Text(
                'Wallets Unavailable',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 200.ms),

              const SizedBox(height: 16),

              Text(
                'This feature is not available right now. Please try again later.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 300.ms)
                  .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}
