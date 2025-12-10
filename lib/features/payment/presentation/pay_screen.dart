import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/animated_mesh_gradient.dart';
import '../../auth/providers/session_provider.dart';
import 'widgets/slide_to_pay.dart';

/// Pay Screen - Payment Flow
/// ROADMAP: Task 3.2 - Slide to Pay widget
/// Features:
/// - Large centered amount input
/// - Frequent contacts horizontal scroll
/// - Slide-to-pay confirmation
class PayScreen extends ConsumerStatefulWidget {
  const PayScreen({super.key});

  @override
  ConsumerState<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends ConsumerState<PayScreen> {
  final TextEditingController _amountController = TextEditingController();
  String? _selectedContact;
  bool _showSlider = false;

  final List<Contact> _frequentContacts = [
    Contact(id: '1', name: 'Sipho', avatar: '👨', color: AppColors.primary),
    Contact(id: '2', name: 'Thandiwe', avatar: '👩', color: AppColors.success),
    Contact(id: '3', name: 'Bongani', avatar: '👨‍💼', color: AppColors.warning),
    Contact(id: '4', name: 'Zanele', avatar: '👩‍💼', color: AppColors.info),
    Contact(id: '5', name: 'Mpho', avatar: '🧑', color: AppColors.danger),
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged(String value) {
    setState(() {
      _showSlider = value.isNotEmpty &&
                    _selectedContact != null &&
                    double.tryParse(value) != null &&
                    double.parse(value) > 0;
    });
  }

  void _onContactSelected(String contactId) {
    setState(() {
      _selectedContact = contactId;
      _showSlider = _amountController.text.isNotEmpty &&
                    double.tryParse(_amountController.text) != null &&
                    double.parse(_amountController.text) > 0;
    });
  }

  void _onPaymentConfirmed() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final contact = _frequentContacts.firstWhere((c) => c.id == _selectedContact);

    // PHASE 1: Mock payment
    // PHASE 3: Will integrate with Stitch API

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => _PaymentSuccessDialog(
        amount: amount,
        contactName: contact.name,
      ),
    );

    // Update balance (mock)
    Future.delayed(const Duration(seconds: 2), () {
      final session = ref.read(sessionProvider).session;
      if (session != null) {
        ref.read(sessionProvider.notifier).updateBalance(
              session.balance - amount,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = ref.watch(sessionProvider).session;

    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Send Money',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: AnimatedMeshGradient(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Available balance
                Text(
                  'Available Balance',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, end: 0, duration: 600.ms),

                const SizedBox(height: 8),

                Text(
                  NumberFormat.currency(symbol: 'R ', decimalDigits: 2)
                      .format(session.balance),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 100.ms)
                    .slideY(begin: -0.2, end: 0, duration: 600.ms, delay: 100.ms),

                const SizedBox(height: 48),

                // Amount Input
                Text(
                  'How much?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 200.ms),

                const SizedBox(height: 16),

                GlassContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle: theme.textTheme.displayMedium?.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixText: 'R ',
                      prefixStyle: theme.textTheme.displayMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
                    onChanged: _onAmountChanged,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .scale(begin: const Offset(0.9, 0.9), duration: 600.ms, delay: 300.ms),

                const SizedBox(height: 48),

                // Recipient selection
                Text(
                  'Send to',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms)
                    .slideX(begin: -0.2, end: 0, duration: 600.ms, delay: 400.ms),

                const SizedBox(height: 16),

                // Contacts scroll
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _frequentContacts.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final contact = _frequentContacts[index];
                      final isSelected = _selectedContact == contact.id;

                      return _ContactChip(
                        contact: contact,
                        isSelected: isSelected,
                        onTap: () => _onContactSelected(contact.id),
                      ).animate()
                          .fadeIn(duration: 400.ms, delay: (450 + index * 50).ms)
                          .slideY(begin: 0.3, end: 0, duration: 400.ms, delay: (450 + index * 50).ms);
                    },
                  ),
                ),

                const SizedBox(height: 48),

                // Slide to pay
                if (_showSlider)
                  SlideToPay(
                    onPaymentConfirmed: _onPaymentConfirmed,
                    isEnabled: !session.isRestricted, // Disable in duress mode
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.3, end: 0, duration: 400.ms),

                if (!_showSlider)
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.glassSurface,
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                        color: AppColors.glassBorder,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Enter amount and select recipient',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Contact {
  final String id;
  final String name;
  final String avatar;
  final Color color;

  Contact({
    required this.id,
    required this.name,
    required this.avatar,
    required this.color,
  });
}

class _ContactChip extends StatelessWidget {
  final Contact contact;
  final bool isSelected;
  final VoidCallback onTap;

  const _ContactChip({
    required this.contact,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: contact.color.withOpacity(0.2),
              border: Border.all(
                color: isSelected ? contact.color : AppColors.glassBorder,
                width: isSelected ? 3 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: contact.color.withOpacity(0.5),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                contact.avatar,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            contact.name,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentSuccessDialog extends StatelessWidget {
  final double amount;
  final String contactName;

  const _PaymentSuccessDialog({
    required this.amount,
    required this.contactName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success.withOpacity(0.2),
                border: Border.all(color: AppColors.success, width: 3),
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.success,
                size: 40,
              ),
            )
                .animate()
                .scale(duration: 400.ms, curve: Curves.elasticOut),

            const SizedBox(height: 24),

            Text(
              'Payment Sent!',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              NumberFormat.currency(symbol: 'R ', decimalDigits: 2).format(amount),
              style: theme.textTheme.displaySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'to $contactName',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            GlassButton.primary(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
