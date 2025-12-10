import 'package:flutter/foundation.dart';

/// Authentication State
/// ROADMAP Task 1.15: Added role and user info for session creation
@immutable
class AuthState {
  final String pin;
  final bool isAuthenticated;
  final bool isPanicMode;
  final String? error;
  final String? userId;
  final String? userName;
  final String? role;
  final double? balance;

  const AuthState({
    this.pin = '',
    this.isAuthenticated = false,
    this.isPanicMode = false,
    this.error,
    this.userId,
    this.userName,
    this.role,
    this.balance,
  });

  AuthState copyWith({
    String? pin,
    bool? isAuthenticated,
    bool? isPanicMode,
    String? error,
    String? userId,
    String? userName,
    String? role,
    double? balance,
  }) {
    return AuthState(
      pin: pin ?? this.pin,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isPanicMode: isPanicMode ?? this.isPanicMode,
      error: error,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      role: role ?? this.role,
      balance: balance ?? this.balance,
    );
  }

  bool get isPinComplete => pin.length == 4;
}
