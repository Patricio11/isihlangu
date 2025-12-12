import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/data/fake_statistics.dart';

/// Statistics Screen - Spending Insights & Analytics
/// PHASE 1.5 BONUS: Additional Mock Screens
///
/// SECURITY: SAFE MODE ONLY - Duress mode users CANNOT access statistics
///
/// Features:
/// - Monthly spending overview
/// - Category breakdown with percentages
/// - Spending trend chart
/// - Budget tracking
/// - Insights and comparisons
class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Note: Duress mode users cannot reach this screen
    // The route guard in app_router.dart redirects them to /home
    // The "Statistics" option in profile is also hidden in duress mode

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('Spending Insights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded),
            onPressed: () {
              // TODO: Month selector
            },
            tooltip: 'Select Month',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Monthly Overview Card
            _buildMonthlyOverview(context, theme)
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.2, end: 0, duration: 600.ms),

            const SizedBox(height: 24),

            // Budget Status Card
            _buildBudgetStatus(context, theme)
                .animate()
                .fadeIn(duration: 600.ms, delay: 100.ms)
                .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 100.ms),

            const SizedBox(height: 32),

            // Section Header: Spending by Category
            Text(
              'Spending by Category',
              style: theme.textTheme.titleLarge?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms)
                .slideX(begin: -0.2, end: 0, duration: 400.ms, delay: 200.ms),

            const SizedBox(height: 16),

            // Category Breakdown
            ...FakeStatistics.categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCategoryCard(context, theme, category)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: (300 + index * 50).ms)
                    .slideX(
                      begin: 0.2,
                      end: 0,
                      duration: 400.ms,
                      delay: (300 + index * 50).ms,
                    ),
              );
            }),

            const SizedBox(height: 32),

            // Monthly Trend Section
            Text(
              'Monthly Trend',
              style: theme.textTheme.titleLarge?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 700.ms)
                .slideX(begin: -0.2, end: 0, duration: 400.ms, delay: 700.ms),

            const SizedBox(height: 16),

            // Trend Chart
            _buildTrendChart(context, theme)
                .animate()
                .fadeIn(duration: 600.ms, delay: 800.ms)
                .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 800.ms),

            const SizedBox(height: 32),

            // Insights Section
            Text(
              'Insights',
              style: theme.textTheme.titleLarge?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 900.ms)
                .slideX(begin: -0.2, end: 0, duration: 400.ms, delay: 900.ms),

            const SizedBox(height: 16),

            // Insights Cards
            _buildInsightsCard(context, theme)
                .animate()
                .fadeIn(duration: 600.ms, delay: 1000.ms)
                .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 1000.ms),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Build Monthly Overview Card
  Widget _buildMonthlyOverview(BuildContext context, ThemeData theme) {
    final currencyFormat = NumberFormat.currency(symbol: 'R ', decimalDigits: 2);
    final percentFormat = NumberFormat('#0.0');

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Current Month Label
          Text(
            'December 2025',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),

          // Total Spending
          Text(
            currencyFormat.format(FakeStatistics.currentMonthSpending),
            style: theme.textTheme.displaySmall?.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // Comparison with last month
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FakeStatistics.isSpendingUp
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 16,
                color: FakeStatistics.isSpendingUp
                    ? context.colors.danger
                    : context.colors.success,
              ),
              const SizedBox(width: 4),
              Text(
                '${percentFormat.format(FakeStatistics.spendingChange.abs())}% vs last month',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: FakeStatistics.isSpendingUp
                      ? context.colors.danger
                      : context.colors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  theme,
                  'Transactions',
                  '${FakeStatistics.transactionCount}',
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: context.colors.glassBorder,
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  theme,
                  'Avg. Size',
                  currencyFormat.format(FakeStatistics.averageTransactionSize),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build Budget Status Card
  Widget _buildBudgetStatus(BuildContext context, ThemeData theme) {
    final currencyFormat = NumberFormat.currency(symbol: 'R ', decimalDigits: 2);
    final progress = FakeStatistics.budgetUsedPercentage / 100;

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Budget',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: progress >= 1.0
                      ? context.colors.danger.withOpacity(0.2)
                      : context.colors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: progress >= 1.0
                        ? context.colors.danger.withOpacity(0.3)
                        : context.colors.success.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  progress >= 1.0 ? 'Over Budget' : 'On Track',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: progress >= 1.0
                        ? context.colors.danger
                        : context.colors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: context.colors.glassSurface,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 1.0 ? context.colors.danger : context.colors.primary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Budget Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: ${currencyFormat.format(FakeStatistics.currentMonthSpending)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              Text(
                'Budget: ${currencyFormat.format(FakeStatistics.monthlyBudget)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
            ],
          ),

          if (!FakeStatistics.isOverBudget) ...[
            const SizedBox(height: 8),
            Text(
              '${currencyFormat.format(FakeStatistics.budgetRemaining)} remaining',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.colors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build Category Card
  Widget _buildCategoryCard(
    BuildContext context,
    ThemeData theme,
    SpendingCategory category,
  ) {
    final currencyFormat = NumberFormat.currency(symbol: 'R ', decimalDigits: 2);
    final color = _parseColor(category.color);

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                category.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      currencyFormat.format(category.amount),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: category.percentage / 100,
                    minHeight: 6,
                    backgroundColor: context.colors.glassSurface,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),

                const SizedBox(height: 4),

                // Percentage
                Text(
                  '${category.percentage.toStringAsFixed(1)}% of total',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build Trend Chart (Simplified bar chart)
  Widget _buildTrendChart(BuildContext context, ThemeData theme) {
    final maxAmount = FakeStatistics.monthlyTrend
        .map((e) => e.amount)
        .reduce((a, b) => a > b ? a : b);

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Chart
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: FakeStatistics.monthlyTrend.map((month) {
                final height = (month.amount / maxAmount) * 140;
                final isCurrentMonth = month.month == 'Dec';

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Bar
                        Container(
                          height: height,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isCurrentMonth
                                  ? [
                                      context.colors.primary,
                                      context.colors.primary.withOpacity(0.6),
                                    ]
                                  : [
                                      context.colors.glassSurface,
                                      context.colors.glassBorder,
                                    ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Month Label
                        Text(
                          month.month,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isCurrentMonth
                                ? context.colors.primary
                                : context.colors.textTertiary,
                            fontWeight: isCurrentMonth
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Average Line
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 2,
                color: context.colors.primary.withOpacity(0.5),
              ),
              const SizedBox(width: 8),
              Text(
                'Avg: ${NumberFormat.currency(symbol: 'R ', decimalDigits: 0).format(FakeStatistics.averageMonthlySpending)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build Insights Card
  Widget _buildInsightsCard(BuildContext context, ThemeData theme) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInsightRow(
            context,
            theme,
            Icons.calendar_today_rounded,
            'Most active day',
            FakeStatistics.topSpendingDay,
          ),
          const SizedBox(height: 16),
          _buildInsightRow(
            context,
            theme,
            Icons.store_rounded,
            'Top merchant',
            FakeStatistics.mostFrequentMerchant,
          ),
          const SizedBox(height: 16),
          _buildInsightRow(
            context,
            theme,
            Icons.restaurant_rounded,
            'Largest category',
            FakeStatistics.categories.first.name,
          ),
        ],
      ),
    );
  }

  /// Build Insight Row
  Widget _buildInsightRow(
    BuildContext context,
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.colors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: context.colors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build Stat Item
  Widget _buildStatItem(
    BuildContext context,
    ThemeData theme,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.bold,
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
      return AppColors.primary;
    }
  }
}
