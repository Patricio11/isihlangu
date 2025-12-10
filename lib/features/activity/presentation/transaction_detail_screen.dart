import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../core/data/fake_transactions.dart';

/// Transaction Detail Screen
/// ROADMAP: Task 1.10 - Transaction Details Screen
/// Shows full transaction information with actions
class TransactionDetailScreen extends ConsumerWidget {
  final Transaction transaction;

  const TransactionDetailScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              HapticService.lightImpact();
              CustomToast.showInfo(context, 'Share feature coming soon');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Amount Card
          _buildAmountCard(theme)
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: -0.1, end: 0, duration: 400.ms),

          const SizedBox(height: 24),

          // Transaction Info
          _buildInfoSection(theme)
              .animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 100.ms),

          const SizedBox(height: 24),

          // Action Buttons
          _buildActionButtons(context)
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms)
              .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 200.ms),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAmountCard(ThemeData theme) {
    final isPositive = transaction.isPositive;
    final color = isPositive ? AppColors.success : AppColors.textPrimary;

    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: isPositive ? AppColors.successGradient : AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isPositive ? AppColors.success : AppColors.primary).withAlpha(77),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: transaction.icon != null
                  ? Text(
                      transaction.icon!,
                      style: const TextStyle(fontSize: 36),
                    )
                  : Icon(
                      _getIconForType(transaction.type),
                      size: 36,
                      color: Colors.white,
                    ),
            ),
          ),

          const SizedBox(height: 24),

          // Amount
          Text(
            '${isPositive ? '+' : '-'} R${transaction.amount.abs().toStringAsFixed(2)}',
            style: theme.textTheme.displaySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Merchant/Title
          Text(
            transaction.title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          // Subtitle
          Text(
            transaction.subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          // Status Badge
          _buildStatusBadge(theme),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme) {
    Color statusColor;
    String statusText;

    switch (transaction.status) {
      case TransactionStatus.completed:
        statusColor = AppColors.success;
        statusText = 'Completed';
        break;
      case TransactionStatus.pending:
        statusColor = AppColors.warning;
        statusText = 'Pending';
        break;
      case TransactionStatus.failed:
        statusColor = AppColors.danger;
        statusText = 'Failed';
        break;
      case TransactionStatus.cancelled:
        statusColor = AppColors.textTertiary;
        statusText = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(51),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withAlpha(102)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: theme.textTheme.labelMedium?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Information',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          _buildInfoRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date & Time',
            value: DateFormat('MMM dd, yyyy • hh:mm a').format(transaction.timestamp),
          ),

          if (transaction.category != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.category_rounded,
              label: 'Category',
              value: transaction.category!,
            ),
          ],

          if (transaction.referenceNumber != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.tag_rounded,
              label: 'Reference',
              value: transaction.referenceNumber!,
              copyable: true,
            ),
          ],

          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.fingerprint_rounded,
            label: 'Transaction ID',
            value: transaction.id,
            copyable: true,
          ),

          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.sync_rounded,
            label: 'Type',
            value: _getTypeString(transaction.type),
          ),

          if (transaction.notes != null) ...[
            const SizedBox(height: 16),
            Divider(color: AppColors.glassBorder),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.note_rounded, size: 18, color: AppColors.textTertiary),
                const SizedBox(width: 8),
                Text(
                  'Notes',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              transaction.notes!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool copyable = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textTertiary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (copyable)
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.copy_rounded, size: 18),
              onPressed: () {
                HapticService.lightImpact();
                Clipboard.setData(ClipboardData(text: value));
                CustomToast.showSuccess(context, 'Copied to clipboard');
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              color: AppColors.primary,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GlassButton.secondary(
                onPressed: () {
                  HapticService.mediumImpact();
                  _showReportDialog(context);
                },
                height: 48,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flag_rounded, size: 18, color: AppColors.danger),
                    SizedBox(width: 8),
                    Text(
                      'Report Issue',
                      style: TextStyle(
                        color: AppColors.danger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlassButton.secondary(
                onPressed: () {
                  HapticService.mediumImpact();
                  _showReceiptDialog(context);
                },
                height: 48,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_rounded, size: 18, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Receipt',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GlassButton.secondary(
          onPressed: () {
            HapticService.mediumImpact();
            _showCategorizeDialog(context);
          },
          width: double.infinity,
          height: 48,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.label_rounded, size: 18, color: AppColors.info),
              SizedBox(width: 8),
              Text(
                'Categorize',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: const Text(
          'Report Issue',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Report an issue with this transaction. Our team will review it within 24 hours.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              CustomToast.showSuccess(context, 'Issue reported successfully');
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  void _showReceiptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: const Text(
          'Receipt',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Receipt download and email features will be available in Phase 2.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCategorizeDialog(BuildContext context) {
    final categories = [
      'Groceries',
      'Transport',
      'Shopping',
      'Entertainment',
      'Bills & Utilities',
      'Healthcare',
      'Education',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: const Text(
          'Change Category',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == transaction.category;

              return ListTile(
                leading: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? AppColors.primary : AppColors.textTertiary,
                ),
                title: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  HapticService.selectionClick();
                  Navigator.of(context).pop();
                  CustomToast.showSuccess(context, 'Category updated to $category');
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(TransactionType type) {
    switch (type) {
      case TransactionType.sent:
        return Icons.arrow_upward_rounded;
      case TransactionType.received:
        return Icons.arrow_downward_rounded;
      case TransactionType.purchase:
        return Icons.shopping_bag_rounded;
      case TransactionType.refund:
        return Icons.refresh_rounded;
    }
  }

  String _getTypeString(TransactionType type) {
    switch (type) {
      case TransactionType.sent:
        return 'Money Sent';
      case TransactionType.received:
        return 'Money Received';
      case TransactionType.purchase:
        return 'Purchase';
      case TransactionType.refund:
        return 'Refund';
    }
  }
}
