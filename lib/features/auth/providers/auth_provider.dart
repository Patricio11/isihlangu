import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_state.dart';

/// Authentication Provider
/// Manages PIN entry, validation, and panic mode detection
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  // PHASE 1: Mock PINs for UI development
  // SECURITY NOTE: In Phase 2, these will be replaced with Supabase Edge Function validation
  // The client will NEVER know which PIN is which - the backend determines the scope
  static const String _safePin = '1234';
  static const String _duressPin = '9999';

  void addDigit(String digit) {
    if (state.pin.length < 4) {
      state = state.copyWith(
        pin: state.pin + digit,
        error: null,
      );

      // Auto-validate when PIN is complete (4 digits)
      if (state.isPinComplete) {
        _validatePin();
      }
    }
  }

  void removeDigit() {
    if (state.pin.isNotEmpty) {
      state = state.copyWith(
        pin: state.pin.substring(0, state.pin.length - 1),
        error: null,
      );
    }
  }

  void clearPin() {
    state = state.copyWith(pin: '', error: null);
  }

  void _validatePin() {
    // PHASE 1: Mock validation
    // SECURITY ARCHITECTURE: In Phase 2, this will be replaced with:
    // 1. Send PIN to Supabase Edge Function
    // 2. Backend validates and returns session token with 'scope' claim
    // 3. Client never knows which PIN was entered - only receives 'admin' or 'restricted' scope

    // Check for duress PIN first
    if (state.pin == _duressPin) {
      state = state.copyWith(
        isAuthenticated: true,
        isPanicMode: true,
      );
      return;
    }

    // Check for safe PIN
    if (state.pin == _safePin) {
      state = state.copyWith(
        isAuthenticated: true,
        isPanicMode: false,
      );
      return;
    }

    // Invalid PIN
    state = state.copyWith(
      error: 'Incorrect PIN',
    );

    // Clear PIN after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        clearPin();
      }
    });
  }

  void logout() {
    state = const AuthState();
  }
}

/// Auth Provider Instance
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
