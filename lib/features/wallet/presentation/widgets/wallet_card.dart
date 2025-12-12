import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/data/fake_wallets.dart';
import 'package:intl/intl.dart';

/// Wallet Card Widget
/// PHASE 1.5 BONUS: Multi-Wallet View
///
/// Features:
/// - Different styles for main, lunch, and savings wallets
/// - Gradient backgrounds based on wallet type
/// - Savings progress bar
/// - Tap to expand details
/// - Quick actions (Move Money, Add Money)
class WalletCard extends StatelessWidget {
  final WalletData wallet;
  final int delay;
  final bool showProgress;

  const WalletCard({
    super.key,
    required this.wallet,
    this.delay = 0,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _parseColor(wallet.color ?? '#2DD4BF');

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Icon + Name + Balance
          Row(
            children: [
              // Icon
              if (wallet.icon != null)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      wallet.icon!,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),

              const SizedBox(width: 16),

              // Name and Balance
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wallet.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatCurrency(wallet.balance),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Menu
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: context.colors.textTertiary,
                ),
                onPressed: () {
                  // TODO: Show wallet menu
                },
              ),
            ],
          ),

          // Savings Progress (if applicable)
          if (showProgress && wallet.savingsGoal != null) ...[
            const SizedBox(height: 20),
            _buildSavingsProgress(theme, wallet.savingsGoal!, color),
          ],

          // Quick Actions
          const SizedBox(height: 16),
          _buildQuickActions(context, theme, color),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: delay.ms)
        .slideX(begin: 0.2, end: 0, duration: 400.ms, delay: delay.ms);
  }

  /// Build Savings Progress Bar
  Widget _buildSavingsProgress(
    ThemeData theme,
    SavingsGoal goal,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress Stats Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${goal.percentageComplete.toInt()}% Complete',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Goal: ${_formatCurrency(goal.targetAmount)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: goal.progress,
            minHeight: 8,
            backgroundColor: AppColors.glassSurface,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),

        const SizedBox(height: 8),

        // Days Remaining
        if (goal.deadline != null)
          Text(
            goal.daysRemaining > 0
                ? '${goal.daysRemaining} days remaining'
                : 'Goal deadline passed',
            style: theme.textTheme.bodySmall?.copyWith(
              color: goal.daysRemaining > 0
                  ? AppColors.textTertiary
                  : AppColors.danger,
            ),
          ),
      ],
    );
  }

  /// Build Quick Actions Row
  Widget _buildQuickActions(
    BuildContext context,
    ThemeData theme,
    Color color,
  ) {
    return Row(
      children: [
        // Move Money Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Open move money sheet
            },
            icon: const Icon(Icons.swap_horiz, size: 18),
            label: const Text('Move'),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.textSecondary,
              side: BorderSide(
                color: context.colors.glassBorder,
                width: 1,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Add Money Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Add money to wallet
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  /// Parse hex color string to Color
  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return AppColors.primary; // Fallback
    }
  }

  /// Format currency
  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: 'R ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
}
