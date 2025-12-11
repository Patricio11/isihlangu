import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/animated_mesh_gradient.dart';
import '../../auth/providers/session_provider.dart';
import 'widgets/radar_widget.dart';

/// Safety Screen - Security Center
/// ROADMAP: Task 1.4 - The "Panic" UX
/// Features:
/// - Radar aesthetic
/// - Security toggles (Ghost Mode, Duress PIN, Trusted Contacts)
/// - Location broadcast indicator
/// - Admin-only access
class SafetyScreen extends ConsumerStatefulWidget {
  const SafetyScreen({super.key});

  @override
  ConsumerState<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends ConsumerState<SafetyScreen> {
  bool _ghostMode = false;
  bool _locationBroadcast = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = ref.watch(sessionProvider).session;

    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Safety Center is admin-only
    final isRestricted = session.isRestricted;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Safety Center',
          style: theme.textTheme.titleLarge?.copyWith(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (!isRestricted)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                // TODO: Navigate to settings
              },
            ),
        ],
      ),
      body: AnimatedMeshGradient(
        child: SafeArea(
          child: isRestricted
              ? _buildRestrictedView()
              : _buildAdminView(theme),
        ),
      ),
    );
  }

  Widget _buildRestrictedView() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80,
              color: context.colors.textTertiary,
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(duration: 600.ms),

            const SizedBox(height: 24),

            Text(
              'Access Restricted',
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
              'You don\'t have permission to access safety features',
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
    );
  }

  Widget _buildAdminView(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Radar Display
          Center(
            child: RadarWidget(
              isActive: _locationBroadcast,
              size: 200,
            )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(duration: 800.ms, curve: Curves.easeOutBack),
          ),

          const SizedBox(height: 32),

          // Status indicator
          GlassContainer(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _locationBroadcast ? context.colors.success : context.colors.textTertiary,
                    boxShadow: _locationBroadcast
                        ? [
                            BoxShadow(
                              color: context.colors.success.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Protection Status',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.colors.textTertiary,
                        ),
                      ),
                      Text(
                        _locationBroadcast ? 'Active' : 'Inactive',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: _locationBroadcast ? context.colors.success : context.colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 200.ms),

          const SizedBox(height: 32),

          // Security Options
          Text(
            'Security Features',
            style: theme.textTheme.titleLarge?.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 300.ms)
              .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 300.ms),

          const SizedBox(height: 16),

          _SecurityToggle(
            icon: Icons.visibility_off_outlined,
            title: 'Ghost Mode',
            subtitle: 'Hide app icon and notifications',
            value: _ghostMode,
            onChanged: (value) => setState(() => _ghostMode = value),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 400.ms)
              .slideX(begin: 0.2, end: 0, duration: 400.ms, delay: 400.ms),

          const SizedBox(height: 12),

          _SecurityToggle(
            icon: Icons.location_on_outlined,
            title: 'Location Broadcast',
            subtitle: 'Share location with trusted contacts',
            value: _locationBroadcast,
            onChanged: (value) => setState(() => _locationBroadcast = value),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 450.ms)
              .slideX(begin: 0.2, end: 0, duration: 400.ms, delay: 450.ms),

          const SizedBox(height: 32),

          // Configuration Options
          Text(
            'Configuration',
            style: theme.textTheme.titleLarge?.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 500.ms)
              .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 500.ms),

          const SizedBox(height: 16),

          _ConfigurationTile(
            icon: Icons.pin_outlined,
            title: 'Duress PIN Setup',
            subtitle: 'Configure panic mode PIN',
            onTap: () {
              // TODO: Navigate to duress PIN setup
            },
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 550.ms)
              .slideX(begin: 0.2, end: 0, duration: 400.ms, delay: 550.ms),

          const SizedBox(height: 12),

          _ConfigurationTile(
            icon: Icons.people_outline,
            title: 'Trusted Contacts',
            subtitle: '3 contacts added',
            onTap: () {
              // TODO: Navigate to trusted contacts
            },
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 600.ms)
              .slideX(begin: 0.2, end: 0, duration: 400.ms, delay: 600.ms),

          const SizedBox(height: 12),

          _ConfigurationTile(
            icon: Icons.warning_outlined,
            title: 'Emergency Triggers',
            subtitle: 'Configure alert conditions',
            onTap: () {
              // TODO: Navigate to emergency triggers
            },
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 650.ms)
              .slideX(begin: 0.2, end: 0, duration: 400.ms, delay: 650.ms),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SecurityToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SecurityToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: value
                  ? context.colors.primary.withValues(alpha: 0.2)
                  : context.colors.glassSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: value ? context.colors.primary : context.colors.glassBorder,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: value ? context.colors.primary : context.colors.textTertiary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: context.colors.primary,
          ),
        ],
      ),
    );
  }
}

class _ConfigurationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ConfigurationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassContainer(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.colors.glassSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: context.colors.glassBorder,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: context.colors.textSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: context.colors.textTertiary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
