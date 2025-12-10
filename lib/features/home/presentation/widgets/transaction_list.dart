import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/fake_transactions.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/utils/haptics.dart';

/// Transaction List Widget
/// Displays transactions with staggered slide-in animation
/// ROADMAP: Task 1.3 - The "Staggered List"
class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const _EmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _TransactionTile(
          transaction: transaction,
          index: index,
        );
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final int index;

  const _TransactionTile({
    required this.transaction,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: 'R ',
      decimalDigits: 2,
    );
    final dateFormat = DateFormat('MMM d, h:mm a');

    return GestureDetector(
      onTap: () {
        HapticService.lightImpact();
        context.push('/transaction/${transaction.id}', extra: transaction);
      },
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        borderRadius: BorderRadius.circular(16),
        child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.glassSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                transaction.icon ?? _getDefaultIcon(transaction.type),
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
                Text(
                  transaction.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  dateFormat.format(transaction.timestamp),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencyFormat.format(transaction.amount.abs()),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: transaction.isPositive
                      ? AppColors.success
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTypeColor(transaction.type).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getTypeLabel(transaction.type),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getTypeColor(transaction.type),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (100 * index).ms)
        .slideX(
          begin: 0.2,
          end: 0,
          duration: 400.ms,
          delay: (100 * index).ms,
          curve: Curves.easeOutCubic,
        );
  }

  String _getDefaultIcon(TransactionType type) {
    switch (type) {
      case TransactionType.sent:
        return '↗️';
      case TransactionType.received:
        return '↙️';
      case TransactionType.purchase:
        return '🛒';
      case TransactionType.refund:
        return '↩️';
    }
  }

  Color _getTypeColor(TransactionType type) {
    switch (type) {
      case TransactionType.sent:
        return AppColors.info;
      case TransactionType.received:
        return AppColors.success;
      case TransactionType.purchase:
        return AppColors.primary;
      case TransactionType.refund:
        return AppColors.warning;
    }
  }

  String _getTypeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.sent:
        return 'SENT';
      case TransactionType.received:
        return 'RECEIVED';
      case TransactionType.purchase:
        return 'PURCHASE';
      case TransactionType.refund:
        return 'REFUND';
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your activity will appear here',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
