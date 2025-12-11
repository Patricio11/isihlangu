import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/fake_family_data.dart';
import '../../../../core/utils/haptics.dart';
import 'family_member_mini_card.dart';

/// Family Overview Section Widget
/// ROADMAP: Task 1.15.2 - Parent Dashboard
/// Horizontal scrollable list of family member cards
class FamilyOverviewSection extends StatelessWidget {
  final VoidCallback? onViewAllTapped;
  final Function(FamilyMember)? onMemberTapped;

  const FamilyOverviewSection({
    super.key,
    this.onViewAllTapped,
    this.onMemberTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final members = FakeFamilyData.allMembers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Family',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    FakeFamilyData.familyName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (onViewAllTapped != null)
                TextButton(
                  onPressed: () {
                    HapticService.lightImpact();
                    onViewAllTapped?.call();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: context.colors.primary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.1, end: 0, duration: 400.ms),

        const SizedBox(height: 16),

        // Horizontal scroll of family member cards
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: members.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final member = members[index];
              return FamilyMemberMiniCard(
                member: member,
                onTap: () {
                  HapticService.lightImpact();
                  onMemberTapped?.call(member);
                },
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: (200 + (index * 100)).ms)
                  .slideX(
                    begin: -0.2,
                    end: 0,
                    duration: 400.ms,
                    delay: (200 + (index * 100)).ms,
                  );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Total family balance
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                size: 16,
                color: context.colors.textTertiary,
              ),
              const SizedBox(width: 8),
              Text(
                'Total Family Balance: ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
              Text(
                'R ${FakeFamilyData.totalFamilyBalance.toStringAsFixed(2)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 600.ms),
      ],
    );
  }
}
