import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../../../core/data/fake_family_data.dart';

/// Family Member Mini Card Widget
/// ROADMAP: Task 1.15.2 - Parent Dashboard
/// Compact card showing family member avatar, name, and balance
class FamilyMemberMiniCard extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback? onTap;

  const FamilyMemberMiniCard({
    super.key,
    required this.member,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isChild = member.role == 'child';

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 140,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: isChild
                      ? context.colors.successGradient
                      : context.colors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    member.avatar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Name
              Text(
                member.name.split(' ').first, // First name only
                style: theme.textTheme.titleSmall?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4),

              // Role badge
              if (isChild)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: context.colors.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${member.age} yrs',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: context.colors.success,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              // Balance
              Text(
                'R ${member.balance.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Card frozen indicator
              if (member.permissions.cardFrozen)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.ac_unit_rounded,
                        size: 12,
                        color: context.colors.info,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Frozen',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: context.colors.info,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
