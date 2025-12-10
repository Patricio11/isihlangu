import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_session.dart';
import '../../../core/security/duress_state_manager.dart';
import '../../../core/data/fake_ghost_wallet.dart';

/// Session Provider
/// Manages the user session after authentication
/// PHASE 1: Uses mock data
/// PHASE 2: Will be populated from Supabase Edge Function response
class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier() : super(const SessionState());

  /// CRITICAL: Restore duress session on app startup
  /// Called from main.dart when persistent duress mode is detected
  /// This ensures the trap door works - duress mode survives reboots
  Future<void> restoreDuressSession() async {
    final duressManager = await DuressStateManager.getInstance();
    final details = await duressManager.getDuressDetails();

    if (details == null) return;

    // Create duress session with ghost wallet balance
    final session = UserSession(
      userId: details.userId,
      userName: 'User', // TODO: Fetch from Supabase in Phase 2
      scope: SessionScope.restricted, // LOCKED in duress mode
      balance: GhostWalletService.getCurrentBalance(),
      sessionToken: 'duress-session-${details.timestamp.millisecondsSinceEpoch}',
      role: 'child', // Always child in duress
    );

    state = SessionState(session: session);
  }

  /// PHASE 1: Create mock session based on PIN type
  /// PHASE 2: This will be replaced with actual token validation
  /// ROADMAP Task 1.15: Added role parameter for parent/child differentiation
  void createMockSession({
    required bool isDuressMode,
    String? userId,
    String? userName,
    String? role,
    double? balance,
  }) {
    final session = UserSession(
      userId: userId ?? 'mock-user-001',
      userName: userName ?? 'Thabo Mokoena',
      scope: isDuressMode ? SessionScope.restricted : SessionScope.admin,
      balance: balance ?? (isDuressMode ? 150.0 : 12450.50), // Fake vs Real balance
      sessionToken: 'mock-jwt-token',
      role: role ?? 'parent', // Default to parent
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
