import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

/// Slide to Pay Widget
/// iPhone-style slider to prevent accidental transfers
/// ROADMAP: Task 3.2 - Create the "Slide to Pay" widget
class SlideToPay extends StatefulWidget {
  final VoidCallback onPaymentConfirmed;
  final bool isEnabled;

  const SlideToPay({
    super.key,
    required this.onPaymentConfirmed,
    this.isEnabled = true,
  });

  @override
  State<SlideToPay> createState() => _SlideToPayState();
}

class _SlideToPayState extends State<SlideToPay> with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  bool _isCompleted = false;
  late AnimationController _resetController;
  late Animation<double> _resetAnimation;

  static const double _threshold = 0.85; // 85% slide to confirm

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _resetAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {
          _dragPosition = _resetAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, double maxWidth) {
    if (!widget.isEnabled || _isCompleted) return;

    setState(() {
      _dragPosition = (_dragPosition + details.delta.dx).clamp(0.0, maxWidth);

      // Check if threshold reached
      if (_dragPosition / maxWidth >= _threshold && !_isCompleted) {
        _isCompleted = true;
        _completePayment();
      }
    });
  }

  void _onDragEnd() {
    if (_isCompleted || !widget.isEnabled) return;

    // Reset to start if not completed
    _resetAnimation = Tween<double>(
      begin: _dragPosition,
      end: 0,
    ).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOut),
    );

    _resetController.forward(from: 0);
  }

  void _completePayment() {
    // Haptic feedback
    HapticFeedback.mediumImpact();

    // Call the callback
    widget.onPaymentConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxDrag = constraints.maxWidth - 70; // 70 is thumb width
        final progress = _dragPosition / maxDrag;

        return Container(
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isCompleted
                  ? [AppColors.success, AppColors.success]
                  : [
                      AppColors.glassSurface,
                      AppColors.primary.withOpacity(progress * 0.2),
                    ],
            ),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(
              color: _isCompleted
                  ? AppColors.success
                  : AppColors.glassBorder,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              // Text instruction
              Center(
                child: Text(
                  _isCompleted
                      ? 'Payment Confirmed'
                      : 'Slide to Pay',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _isCompleted
                            ? AppColors.textPrimary
                            : AppColors.textSecondary.withOpacity(1 - progress),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                ),
              ),

              // Draggable thumb
              AnimatedPositioned(
                duration: _isCompleted
                    ? const Duration(milliseconds: 300)
                    : Duration.zero,
                left: _isCompleted ? maxDrag : _dragPosition,
                top: 5,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) =>
                      _onDragUpdate(details, maxDrag),
                  onHorizontalDragEnd: (_) => _onDragEnd(),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: _isCompleted
                          ? LinearGradient(
                              colors: [AppColors.success, AppColors.success.withOpacity(0.8)],
                            )
                          : AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_isCompleted ? AppColors.success : AppColors.primary)
                              .withOpacity(0.5),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isCompleted ? Icons.check : Icons.arrow_forward,
                      color: AppColors.background,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
