import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/data/fake_contacts.dart';
import '../../auth/providers/session_provider.dart';

/// Contacts Screen - Beneficiary Management
/// PHASE 1.5 BONUS: Additional Mock Screens
///
/// Features:
/// - Favorite contacts section
/// - All contacts list
/// - Add/Edit/Delete contacts (Safe Mode only)
/// - Quick actions (Call, Pay, Edit)
/// - Search and filter
class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = ref.watch(sessionProvider).session;
    final isRestricted = session?.isRestricted ?? false;

    // Filter contacts based on search
    final filteredFavorites = FakeContacts.favoriteContacts
        .where((c) =>
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.phoneNumber.contains(_searchQuery))
        .toList();

    final filteredRegular = FakeContacts.regularContacts
        .where((c) =>
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.phoneNumber.contains(_searchQuery))
        .toList();

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          // Add Contact Button (Safe Mode only)
          if (!isRestricted)
            IconButton(
              icon: const Icon(Icons.person_add_rounded),
              onPressed: () {
                HapticService.lightImpact();
                _showAddContactDialog(context);
              },
              tooltip: 'Add Contact',
            ),
        ],
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
                  });
                },
                style: TextStyle(color: context.colors.textPrimary),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search_rounded,
                    color: context.colors.textTertiary,
                  ),
                  hintText: 'Search contacts...',
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

          // Contacts List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Favorites Section
                if (filteredFavorites.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 20,
                        color: context.colors.warning,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Favorites',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 200.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 400.ms,
                        delay: 200.ms,
                      ),
                  const SizedBox(height: 16),
                  ...filteredFavorites.asMap().entries.map((entry) {
                    final index = entry.key;
                    final contact = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildContactCard(
                        context,
                        theme,
                        contact,
                        isRestricted,
                      )
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
                  const SizedBox(height: 24),
                ],

                // All Contacts Section
                if (filteredRegular.isNotEmpty) ...[
                  Text(
                    'All Contacts',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 400.ms,
                        delay: (400 + filteredFavorites.length * 50).ms,
                      )
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 400.ms,
                        delay: (400 + filteredFavorites.length * 50).ms,
                      ),
                  const SizedBox(height: 16),
                  ...filteredRegular.asMap().entries.map((entry) {
                    final index = entry.key;
                    final contact = entry.value;
                    final delay =
                        500 + filteredFavorites.length * 50 + index * 50;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildContactCard(
                        context,
                        theme,
                        contact,
                        isRestricted,
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: delay.ms)
                          .slideX(
                            begin: 0.2,
                            end: 0,
                            duration: 400.ms,
                            delay: delay.ms,
                          ),
                    );
                  }),
                ],

                // Empty State
                if (filteredFavorites.isEmpty && filteredRegular.isEmpty) ...[
                  const SizedBox(height: 80),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: context.colors.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No contacts yet'
                              : 'No contacts found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Add your first contact to get started'
                              : 'Try a different search term',
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
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build Contact Card
  Widget _buildContactCard(
    BuildContext context,
    ThemeData theme,
    BeneficiaryContact contact,
    bool isRestricted,
  ) {
    final color = _parseColor(contact.color);

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                contact.initials,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name with favorite star
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        contact.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (contact.isFavorite)
                      Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: context.colors.warning,
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                // Phone Number
                Text(
                  contact.phoneNumber,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),

                // Bank Info (if available)
                if (contact.bank != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    contact.bank!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.colors.textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Quick Actions
          Row(
            children: [
              // Call Button
              IconButton(
                icon: Icon(
                  Icons.phone_rounded,
                  color: context.colors.primary,
                  size: 20,
                ),
                onPressed: () {
                  HapticService.lightImpact();
                  CustomToast.showInfo(
                    context,
                    'Calling ${contact.name}...',
                  );
                },
                tooltip: 'Call',
              ),

              // More Options (Safe Mode only)
              if (!isRestricted)
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: context.colors.textTertiary,
                    size: 20,
                  ),
                  onPressed: () {
                    HapticService.lightImpact();
                    _showContactOptions(context, contact);
                  },
                  tooltip: 'Options',
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Show Add Contact Dialog
  void _showAddContactDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.backgroundSecondary,
        title: Text(
          'Add Contact',
          style: theme.textTheme.titleLarge?.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        content: Text(
          'Contact management coming in Phase 2',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
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

  /// Show Contact Options Bottom Sheet
  void _showContactOptions(BuildContext context, BeneficiaryContact contact) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.glassBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 24),

            // Contact Name
            Text(
              contact.name,
              style: theme.textTheme.titleLarge?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // Options
            _buildOptionTile(
              context,
              Icons.star_rounded,
              contact.isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
              context.colors.warning,
              () {
                Navigator.of(context).pop();
                CustomToast.showInfo(
                  context,
                  'Favorites management coming in Phase 2',
                );
              },
            ),

            _buildOptionTile(
              context,
              Icons.edit_rounded,
              'Edit Contact',
              context.colors.primary,
              () {
                Navigator.of(context).pop();
                CustomToast.showInfo(context, 'Edit coming in Phase 2');
              },
            ),

            _buildOptionTile(
              context,
              Icons.delete_rounded,
              'Delete Contact',
              context.colors.danger,
              () {
                Navigator.of(context).pop();
                _showDeleteConfirmation(context, contact);
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Build Option Tile
  Widget _buildOptionTile(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(color: context.colors.textPrimary),
      ),
      onTap: () {
        HapticService.lightImpact();
        onTap();
      },
    );
  }

  /// Show Delete Confirmation
  void _showDeleteConfirmation(
    BuildContext context,
    BeneficiaryContact contact,
  ) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.backgroundSecondary,
        title: Text(
          'Delete Contact',
          style: theme.textTheme.titleLarge?.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${contact.name}?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              CustomToast.showInfo(context, 'Delete coming in Phase 2');
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colors.danger,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
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
