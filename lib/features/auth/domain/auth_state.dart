import 'package:flutter/foundation.dart';

/// Authentication State
@immutable
class AuthState {
  final String pin;
  final bool isAuthenticated;
  final bool isPanicMode;
  final String? error;

  const AuthState({
    this.pin = '',
    this.isAuthenticated = false,
    this.isPanicMode = false,
    this.error,
  });

  AuthState copyWith({
    String? pin,
    bool? isAuthenticated,
    bool? isPanicMode,
    String? error,
  }) {
    return AuthState(
      pin: pin ?? this.pin,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isPanicMode: isPanicMode ?? this.isPanicMode,
      error: error,
    );
  }

  bool get isPinComplete => pin.length == 4;
}
