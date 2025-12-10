import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../core/data/fake_family_data.dart';

/// Create Family Screen
/// ROADMAP: Task 1.15.1 - Role Selection (Parent Flow)
/// Allows parent to create a family and get a family code
class CreateFamilyScreen extends StatefulWidget {
  const CreateFamilyScreen({super.key});

  @override
  State<CreateFamilyScreen> createState() => _CreateFamilyScreenState();
}

class _CreateFamilyScreenState extends State<CreateFamilyScreen> {
  final _familyNameController = TextEditingController(text: FakeFamilyData.familyName);
  bool _isCreating = false;
  bool _familyCreated = false;

  @override
  void dispose() {
    _familyNameController.dispose();
    super.dispose();
  }

  Future<void> _createFamily() async {
    if (_familyNameController.text.trim().isEmpty) {
      CustomToast.showError(context, 'Please enter a family name');
      return;
    }

    setState(() => _isCreating = true);
    HapticService.mediumImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isCreating = false;
      _familyCreated = true;
    });

    HapticService.success();
    CustomToast.showSuccess(context, 'Family created successfully!');
  }

  void _copyFamilyCode() {
    Clipboard.setData(const ClipboardData(text: FakeFamilyData.familyCode));
    HapticService.lightImpact();
    CustomToast.showSuccess(context, 'Family code copied!');
  }

  void _continue() {
    HapticService.mediumImpact();
    // Navigate to main app (login with parent PIN)
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Family'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_familyCreated) ...[
                // Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.family_restroom_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),

                const SizedBox(height: 32),

                Text(
                  'Create Your Family Account',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 200.ms),

                const SizedBox(height: 12),

                Text(
                  'Give your family a name to get started',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms),

                const SizedBox(height: 48),

                // Family Name Input
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: _familyNameController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Family Name',
                      hintText: 'e.g., The Smith Family',
                      prefixIcon: Icon(Icons.home_rounded, color: AppColors.primary),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 600.ms),

                const SizedBox(height: 32),

                // Create Button
                GlassButton.primary(
                  onPressed: _isCreating || _familyNameController.text.trim().isEmpty
                      ? null
                      : _createFamily,
                  width: double.infinity,
                  height: 56,
                  child: _isCreating
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Create Family',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 800.ms)
                    .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 800.ms),
              ] else ...[
                // Success State
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    gradient: AppColors.successGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.5, 0.5), duration: 600.ms),

                const SizedBox(height: 32),

                Text(
                  'Family Created!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms),

                const SizedBox(height: 12),

                Text(
                  'Share this code with family members to invite them',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms),

                const SizedBox(height: 48),

                // Family Code Display
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Family Code',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        FakeFamilyData.familyCode,
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GlassButton.secondary(
                        onPressed: _copyFamilyCode,
                        width: double.infinity,
                        height: 48,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.copy_rounded, size: 20, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              'Copy Code',
                              style: TextStyle(
                                color: AppColors.textPrimary,
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
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 600.ms),

                const SizedBox(height: 32),

                // Continue Button
                GlassButton.primary(
                  onPressed: _continue,
                  width: double.infinity,
                  height: 56,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 800.ms)
                    .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 800.ms),

                const SizedBox(height: 16),

                Text(
                  'You can always find your family code in Settings',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 1000.ms),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
