import 'package:flutter/foundation.dart';

/// User Session Scope
/// SECURITY ARCHITECTURE: The backend determines this - client never knows which PIN was entered
enum SessionScope {
  admin,     // Full access - entered Safe PIN
  restricted // Limited access - entered Duress PIN (shows fake low balance, locks real funds)
}

/// User Session Model
/// Contains the session information returned from backend authentication
@immutable
class UserSession {
  final String userId;
  final String userName;
  final SessionScope scope;
  final double balance; // Will be real or fake depending on scope
  final String? sessionToken;

  const UserSession({
    required this.userId,
    required this.userName,
    required this.scope,
    required this.balance,
    this.sessionToken,
  });

  bool get isAdmin => scope == SessionScope.admin;
  bool get isRestricted => scope == SessionScope.restricted;

  UserSession copyWith({
    String? userId,
    String? userName,
    SessionScope? scope,
    double? balance,
    String? sessionToken,
  }) {
    return UserSession(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      scope: scope ?? this.scope,
      balance: balance ?? this.balance,
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }
}

/// Session State for Riverpod
@immutable
class SessionState {
  final UserSession? session;
  final bool isLoading;
  final String? error;

  const SessionState({
    this.session,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => session != null;
  bool get isAdmin => session?.isAdmin ?? false;
  bool get isRestricted => session?.isRestricted ?? false;

  SessionState copyWith({
    UserSession? session,
    bool? isLoading,
    String? error,
  }) {
    return SessionState(
      session: session,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
