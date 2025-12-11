import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/animated_mesh_gradient.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../core/data/fake_family_data.dart';

/// Family Screen
/// ROADMAP: Task 1.15.3 - Family Members Screen
/// Shows all family members with parent at top
/// Allows parent to tap children to access control panel
/// Displays family code for sharing
class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  void _copyFamilyCode(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: FakeFamilyData.familyCode));
    HapticService.lightImpact();
    CustomToast.showSuccess(context, 'Family code copied!');
  }

  void _shareFamilyCode(BuildContext context) {
    HapticService.mediumImpact();
    // TODO: Implement share functionality
    CustomToast.showSuccess(context, 'Share functionality coming soon!');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final members = FakeFamilyData.allMembers;
    final parent = members.firstWhere((m) => m.role == 'parent');
    final children = members.where((m) => m.role == 'child').toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Family'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () => _shareFamilyCode(context),
            tooltip: 'Share Family Code',
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

              // Family Info Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Family Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: context.colors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.family_restroom_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Family Name
                        Text(
                          FakeFamilyData.familyName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        // Member Count
                        Text(
                          '${members.length} members',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Total Balance
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet_rounded,
                              size: 16,
                              color: context.colors.textTertiary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Total Balance: ',
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
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.1, end: 0, duration: 400.ms),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),

              // Family Code Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Family Code',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GlassCard(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    FakeFamilyData.familyCode,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      color: context.colors.primary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Share with family members',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: context.colors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () => _copyFamilyCode(context),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: context.colors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.copy_rounded,
                                  color: context.colors.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 200.ms)
                      .slideX(begin: -0.1, end: 0, duration: 400.ms, delay: 200.ms),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),

              // Parent Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Parent',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 300.ms),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 12),
              ),

              // Parent Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _FamilyMemberCard(
                    member: parent,
                    onTap: null, // Parents can't manage themselves
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 400.ms)
                      .slideX(begin: -0.1, end: 0, duration: 400.ms, delay: 400.ms),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),

              // Children Section
              if (children.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Children',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 500.ms),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 12),
                ),

                // Children List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final child = children[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 12,
                        ),
                        child: _FamilyMemberCard(
                          member: child,
                          onTap: () {
                            HapticService.lightImpact();
                            context.push('/family/child-control/${child.id}');
                          },
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: (600 + (index * 100)).ms)
                            .slideX(
                              begin: -0.1,
                              end: 0,
                              duration: 400.ms,
                              delay: (600 + (index * 100)).ms,
                            ),
                      );
                    },
                    childCount: children.length,
                  ),
                ),
              ],

              const SliverToBoxAdapter(
                child: SizedBox(height: 100), // Bottom padding for nav bar
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Family Member Card Widget
class _FamilyMemberCard extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback? onTap;

  const _FamilyMemberCard({
    required this.member,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isParent = member.role == 'parent';
    final canTap = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: isParent
                    ? context.colors.primaryGradient
                    : context.colors.successGradient,
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

            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          member.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (!isParent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
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
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'R ${member.balance.toStringAsFixed(2)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: context.colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (member.permissions.cardFrozen)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.ac_unit_rounded,
                            size: 14,
                            color: context.colors.info,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Card Frozen',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.colors.info,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Arrow (if tappable)
            if (canTap)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: context.colors.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}
