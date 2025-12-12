import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/data/fake_help.dart';

/// Help Screen - Support & FAQ
/// PHASE 1.5 BONUS: Additional Mock Screens
///
/// Features:
/// - Searchable FAQ section
/// - Category-based organization
/// - Support contact information
/// - Expandable FAQ items
class HelpScreen extends ConsumerStatefulWidget {
  const HelpScreen({super.key});

  @override
  ConsumerState<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends ConsumerState<HelpScreen> {
  String _searchQuery = '';
  String? _selectedCategory;
  final Set<int> _expandedItems = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter FAQs based on search and category
    List<FAQItem> filteredFAQs;
    if (_searchQuery.isNotEmpty) {
      filteredFAQs = FakeHelp.searchFAQs(_searchQuery);
    } else if (_selectedCategory != null) {
      filteredFAQs = FakeHelp.getFAQsByCategory(_selectedCategory!);
    } else {
      filteredFAQs = FakeHelp.faqs;
    }

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _selectedCategory = null; // Clear category filter when searching
                  });
                },
                style: TextStyle(color: context.colors.textPrimary),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search_rounded,
                    color: context.colors.textTertiary,
                  ),
                  hintText: 'Search help topics...',
                  hintStyle: TextStyle(color: context.colors.textTertiary),
                  border: InputBorder.none,
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: context.colors.textTertiary,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(
                  begin: -0.2,
                  end: 0,
                  duration: 400.ms,
                ),
          ),

          // Category Pills (only show if not searching)
          if (_searchQuery.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryPill(context, theme, 'All', null),
                    const SizedBox(width: 8),
                    ...FakeHelp.categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildCategoryPill(context, theme, category, category),
                      );
                    }),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 100.ms)
                  .slideX(begin: -0.2, end: 0, duration: 400.ms, delay: 100.ms),
            ),

          if (_searchQuery.isEmpty) const SizedBox(height: 16),

          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Support Contacts Section
                if (_searchQuery.isEmpty && _selectedCategory == null) ...[
                  Text(
                    'Contact Support',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 200.ms)
                      .slideX(begin: -0.2, end: 0, duration: 400.ms, delay: 200.ms),
                  const SizedBox(height: 16),
                  ...FakeHelp.supportContacts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final contact = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildSupportCard(context, theme, contact)
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
                ],

                // FAQ Section Header
                Text(
                  _searchQuery.isNotEmpty
                      ? 'Search Results (${filteredFAQs.length})'
                      : _selectedCategory ?? 'Frequently Asked Questions',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 500.ms)
                    .slideX(begin: -0.2, end: 0, duration: 400.ms, delay: 500.ms),

                const SizedBox(height: 16),

                // FAQ Items
                if (filteredFAQs.isNotEmpty)
                  ...filteredFAQs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final faq = entry.value;
                    final globalIndex = FakeHelp.faqs.indexOf(faq);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildFAQCard(
                        context,
                        theme,
                        faq,
                        globalIndex,
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: (600 + index * 50).ms)
                          .slideY(
                            begin: 0.2,
                            end: 0,
                            duration: 400.ms,
                            delay: (600 + index * 50).ms,
                          ),
                    );
                  })
                else
                  // Empty State
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: context.colors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No results found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a different search term',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: context.colors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(duration: 600.ms),
                  ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build Category Pill
  Widget _buildCategoryPill(
    BuildContext context,
    ThemeData theme,
    String label,
    String? category,
  ) {
    final isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        HapticService.lightImpact();
        setState(() {
          _selectedCategory = category;
          _expandedItems.clear(); // Collapse all when changing category
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    context.colors.primary,
                    context.colors.primary.withValues(alpha: 0.8),
                  ],
                )
              : null,
          color: isSelected ? null : context.colors.glassSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : context.colors.glassBorder,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isSelected ? Colors.white : context.colors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Build Support Contact Card
  Widget _buildSupportCard(
    BuildContext context,
    ThemeData theme,
    SupportContact contact,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.colors.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                contact.icon,
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
                  contact.type,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.colors.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contact.value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Action Button
          IconButton(
            icon: Icon(
              Icons.arrow_forward_rounded,
              color: context.colors.primary,
            ),
            onPressed: () {
              HapticService.lightImpact();
              CustomToast.showInfo(
                context,
                'Opening ${contact.type}...',
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build FAQ Card
  Widget _buildFAQCard(
    BuildContext context,
    ThemeData theme,
    FAQItem faq,
    int index,
  ) {
    final isExpanded = _expandedItems.contains(index);

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Row
          InkWell(
            onTap: () {
              HapticService.lightImpact();
              setState(() {
                if (isExpanded) {
                  _expandedItems.remove(index);
                } else {
                  _expandedItems.add(index);
                }
              });
            },
            child: Row(
              children: [
                // Category Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: context.colors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    faq.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Question
                Expanded(
                  child: Text(
                    faq.question,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Expand Icon
                Icon(
                  isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: context.colors.textTertiary,
                ),
              ],
            ),
          ),

          // Answer (when expanded)
          if (isExpanded) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 1,
              color: context.colors.glassBorder,
            ),
            const SizedBox(height: 12),
            Text(
              faq.answer,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
                height: 1.5,
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .slideY(begin: -0.1, end: 0, duration: 300.ms),
          ],
        ],
      ),
    );
  }
}
