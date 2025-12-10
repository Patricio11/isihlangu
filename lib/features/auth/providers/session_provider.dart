import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_session.dart';

/// Session Provider
/// Manages the user session after authentication
/// PHASE 1: Uses mock data
/// PHASE 2: Will be populated from Supabase Edge Function response
class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier() : super(const SessionState());

  /// PHASE 1: Create mock session based on PIN type
  /// PHASE 2: This will be replaced with actual token validation
  void createMockSession({required bool isDuressMode}) {
    final session = UserSession(
      userId: 'mock-user-001',
      userName: 'Thabo Mokoena',
      scope: isDuressMode ? SessionScope.restricted : SessionScope.admin,
      balance: isDuressMode ? 150.0 : 12450.50, // Fake vs Real balance
      sessionToken: 'mock-jwt-token',
    );

    state = SessionState(session: session);
  }

  /// Clear session on logout
  void clearSession() {
    state = const SessionState();
  }

  /// Logout (alias for clearSession)
  void logout() {
    clearSession();
  }

  /// Update balance (for testing)
  void updateBalance(double newBalance) {
    if (state.session != null) {
      state = state.copyWith(
        session: state.session!.copyWith(balance: newBalance),
      );
    }
  }
}

/// Session Provider Instance
final sessionProvider = StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier();
});
