import 'package:flutter/services.dart';

/// Haptic Feedback Service
/// Provides tactile feedback patterns for user interactions
///
/// SECURITY NOTE: Haptic patterns are IDENTICAL for Safe/Duress modes
/// to prevent physical tells that could alert an attacker
class HapticService {
  /// Light tap - Used for button presses, keypad
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium tap - Used for important actions
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy tap - Used for critical actions
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection changed - Used for sliders, toggles
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Success pattern - Double pulse for successful operations
  /// Used for: Successful login, payment sent, card frozen
  /// SECURITY: Same pattern for both Safe and Duress login
  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }

  /// Error pattern - Three short vibrations for errors
  /// Used for: Wrong PIN, payment failed, network error
  /// SECURITY: NO error haptic on duress mode silent failures
  static Future<void> error() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.lightImpact();
  }

  /// Warning pattern - Single heavy vibration
  /// Used for: Low balance warning, security alerts
  static Future<void> warning() async {
    await HapticFeedback.heavyImpact();
  }

  /// Confirmation pattern - Short then long vibration
  /// Used for: Slide to pay completed, card unlocked
  static Future<void> confirmation() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Subtle feedback - Very light tap
  /// Used for: Card tilt, background updates
  static Future<void> subtle() async {
    await HapticFeedback.selectionClick();
  }

  /// Keypad press - Light consistent feedback
  /// Used for: PIN entry (both Safe and Duress)
  /// SECURITY: Identical timing and strength for both modes
  static Future<void> keypadPress() async {
    await HapticFeedback.lightImpact();
  }

  /// Delete/Backspace - Slightly different feel
  /// Used for: PIN deletion
  static Future<void> keypadDelete() async {
    await HapticFeedback.selectionClick();
  }

  /// Long press - Growing intensity
  /// Used for: Long press actions, shake to freeze
  static Future<void> longPress() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    await HapticFeedback.heavyImpact();
  }

  /// Swipe feedback - Smooth selection
  /// Used for: Swiping through cards, dismissing notifications
  static Future<void> swipe() async {
    await HapticFeedback.selectionClick();
  }
}
