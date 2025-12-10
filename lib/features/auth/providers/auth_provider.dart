import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_state.dart';
import '../../../core/data/fake_family_data.dart';

/// Authentication Provider
/// Manages PIN entry, validation, and panic mode detection
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  // PHASE 1: Mock PINs for UI development
  // SECURITY NOTE: In Phase 2, these will be replaced with Supabase Edge Function validation
  // The client will NEVER know which PIN is which - the backend determines the scope
  // ROADMAP Task 1.15: Added role-based PINs for parent/child testing
  static const String _parentPin = '1234';      // Parent (Thabo) - Safe Mode
  static const String _child1Pin = '5678';      // Child 1 (Lesedi - 14) - Safe Mode
  static const String _child2Pin = '4321';      // Child 2 (Amogelang - 10) - Safe Mode
  static const String _duressPin = '9999';      // Current Role - Duress Mode

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

    // ROADMAP Task 1.15: Role-based authentication

    // Check for duress PIN first (current role stays, but in restricted mode)
    if (state.pin == _duressPin) {
      state = state.copyWith(
        isAuthenticated: true,
        isPanicMode: true,
        // Use parent role for duress mode testing (could be any role in production)
        userId: FakeFamilyData.parent.id,
        userName: FakeFamilyData.parent.name,
        role: FakeFamilyData.parent.role,
        balance: 150.0, // Fake balance in duress mode
      );
      return;
    }

    // Check for parent PIN
    if (state.pin == _parentPin) {
      state = state.copyWith(
        isAuthenticated: true,
        isPanicMode: false,
        userId: FakeFamilyData.parent.id,
        userName: FakeFamilyData.parent.name,
        role: FakeFamilyData.parent.role,
        balance: FakeFamilyData.parent.balance,
      );
      return;
    }

    // Check for child 1 PIN (Lesedi - 14)
    if (state.pin == _child1Pin) {
      state = state.copyWith(
        isAuthenticated: true,
        isPanicMode: false,
        userId: FakeFamilyData.child1.id,
        userName: FakeFamilyData.child1.name,
        role: FakeFamilyData.child1.role,
        balance: FakeFamilyData.child1.balance,
      );
      return;
    }

    // Check for child 2 PIN (Amogelang - 10)
    if (state.pin == _child2Pin) {
      state = state.copyWith(
        isAuthenticated: true,
        isPanicMode: false,
        userId: FakeFamilyData.child2.id,
        userName: FakeFamilyData.child2.name,
        role: FakeFamilyData.child2.role,
        balance: FakeFamilyData.child2.balance,
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
