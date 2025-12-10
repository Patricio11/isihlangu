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
  final String role; // 'parent' or 'child' - ROADMAP Task 1.15: Role-Based Screens

  const UserSession({
    required this.userId,
    required this.userName,
    required this.scope,
    required this.balance,
    this.sessionToken,
    this.role = 'parent', // Default to parent for backward compatibility
  });

  bool get isAdmin => scope == SessionScope.admin;
  bool get isRestricted => scope == SessionScope.restricted;
  bool get isParent => role == 'parent';
  bool get isChild => role == 'child';

  UserSession copyWith({
    String? userId,
    String? userName,
    SessionScope? scope,
    double? balance,
    String? sessionToken,
    String? role,
  }) {
    return UserSession(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      scope: scope ?? this.scope,
      balance: balance ?? this.balance,
      sessionToken: sessionToken ?? this.sessionToken,
      role: role ?? this.role,
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
