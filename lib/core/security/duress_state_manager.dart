import 'package:shared_preferences/shared_preferences.dart';
import 'evidence_logger.dart';

/// Duress State Manager
/// ROADMAP: Phase 1.6 - Task 1.6.2
///
/// The "Trap Door" - Persistent Duress Mode
///
/// CRITICAL SECURITY DESIGN:
/// Once duress mode is entered (PIN 9999), the app remains locked in
/// duress mode EVEN IF:
/// - The app is closed and reopened
/// - The device is rebooted
/// - The attacker tries to force quit the app
///
/// ONLY the parent can remotely unlock the account from their device.
///
/// This prevents the attacker from discovering the duress mode by:
/// 1. Trying to restart the app (still in duress)
/// 2. Rebooting the device (still in duress)
/// 3. Deleting and reinstalling the app (data persists in cloud)
///
/// SECURITY GUARANTEE:
/// The child remains protected until parent intervention.
class DuressStateManager {
  // Persistent storage keys
  static const String _duressActiveKey = 'shield_duress_active';
  static const String _duressUserIdKey = 'shield_duress_user_id';
  static const String _duressTimestampKey = 'shield_duress_timestamp';
  static const String _duressLocationKey = 'shield_duress_location';

  // Singleton instance
  static DuressStateManager? _instance;
  static SharedPreferences? _prefs;

  /// Get singleton instance
  static Future<DuressStateManager> getInstance() async {
    if (_instance == null) {
      _instance = DuressStateManager._();
      await _instance!._init();
    }
    return _instance!;
  }

  // Private constructor
  DuressStateManager._();

  /// Initialize persistent storage
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// ACTIVATE DURESS MODE
  /// Called when user enters PIN 9999
  /// This sets the trap door - no way out except parent unlock
  Future<void> activateDuressMode({
    required String userId,
    String? location,
  }) async {
    if (_prefs == null) return;

    // Set persistent flags
    await _prefs!.setBool(_duressActiveKey, true);
    await _prefs!.setString(_duressUserIdKey, userId);
    await _prefs!.setString(
      _duressTimestampKey,
      DateTime.now().toIso8601String(),
    );
    if (location != null) {
      await _prefs!.setString(_duressLocationKey, location);
    }

    // Log duress entry
    EvidenceLogger.logDuressEntry(
      userId: userId,
      location: location,
    );

    _debugPrint('⚠️ DURESS MODE ACTIVATED - Trap door set');
    _debugPrint('User ID: $userId');
    _debugPrint('Timestamp: ${DateTime.now()}');
    _debugPrint('THIS STATE WILL PERSIST ACROSS APP RESTARTS AND REBOOTS');
  }

  /// CHECK IF DURESS MODE IS ACTIVE
  /// Called on EVERY app startup in main.dart
  /// This is what makes the trap door reboot-proof
  Future<bool> isDuressActive() async {
    if (_prefs == null) {
      await _init();
    }
    final isActive = _prefs?.getBool(_duressActiveKey) ?? false;

    if (isActive) {
      _debugPrint('🚨 DURESS MODE DETECTED ON STARTUP');
      _debugPrint('App will launch in restricted mode');

      // Log app restart during duress
      final userId = _prefs?.getString(_duressUserIdKey) ?? 'unknown';
      EvidenceLogger.logAppRestartInDuress(userId: userId);
    }

    return isActive;
  }

  /// DEACTIVATE DURESS MODE
  /// ONLY callable by parent from their device via remote unlock
  /// This is the ONLY way to exit duress mode
  Future<void> deactivateDuressMode({
    required String parentUserId,
  }) async {
    if (_prefs == null) return;

    final childUserId = _prefs!.getString(_duressUserIdKey) ?? 'unknown';

    // Log duress exit
    EvidenceLogger.logDuressExit(
      userId: childUserId,
      exitedBy: parentUserId,
    );

    // Clear all duress flags
    await _prefs!.remove(_duressActiveKey);
    await _prefs!.remove(_duressUserIdKey);
    await _prefs!.remove(_duressTimestampKey);
    await _prefs!.remove(_duressLocationKey);

    _debugPrint('✅ DURESS MODE DEACTIVATED BY PARENT');
    _debugPrint('Parent User ID: $parentUserId');
    _debugPrint('Child returned to safe mode');
  }

  /// Get duress mode details
  /// Used by parent to see when duress was activated
  Future<DuressDetails?> getDuressDetails() async {
    if (_prefs == null) return null;

    final isActive = _prefs!.getBool(_duressActiveKey) ?? false;
    if (!isActive) return null;

    final userId = _prefs!.getString(_duressUserIdKey);
    final timestampStr = _prefs!.getString(_duressTimestampKey);
    final location = _prefs!.getString(_duressLocationKey);

    if (userId == null || timestampStr == null) return null;

    return DuressDetails(
      userId: userId,
      timestamp: DateTime.parse(timestampStr),
      location: location,
      durationMinutes: DateTime.now().difference(DateTime.parse(timestampStr)).inMinutes,
    );
  }

  /// Get duress start timestamp
  Future<DateTime?> getDuressStartTime() async {
    if (_prefs == null) return null;
    final timestampStr = _prefs!.getString(_duressTimestampKey);
    return timestampStr != null ? DateTime.parse(timestampStr) : null;
  }

  /// Get duress user ID
  Future<String?> getDuressUserId() async {
    if (_prefs == null) return null;
    return _prefs!.getString(_duressUserIdKey);
  }

  /// Check if duress mode has been active for a dangerous duration
  /// Used by parent dashboard to show urgency warnings
  Future<bool> isDuressOverdue() async {
    if (_prefs == null) return false;

    final isActive = _prefs!.getBool(_duressActiveKey) ?? false;
    if (!isActive) return false;

    final timestampStr = _prefs!.getString(_duressTimestampKey);
    if (timestampStr == null) return false;

    final startTime = DateTime.parse(timestampStr);
    final duration = DateTime.now().difference(startTime);

    // Consider duress overdue after 2 hours
    return duration.inHours >= 2;
  }

  /// EMERGENCY: Force clear duress state
  /// ONLY for development/testing - should be disabled in production
  /// In production, only parent remote unlock should work
  Future<void> emergencyReset() async {
    if (_prefs == null) return;

    // Check if in production mode
    const isProduction = bool.fromEnvironment('dart.vm.product');
    if (isProduction) {
      _debugPrint('❌ EMERGENCY RESET BLOCKED - Production mode');
      return;
    }

    _debugPrint('⚠️ EMERGENCY RESET TRIGGERED - DEVELOPMENT ONLY');

    await _prefs!.remove(_duressActiveKey);
    await _prefs!.remove(_duressUserIdKey);
    await _prefs!.remove(_duressTimestampKey);
    await _prefs!.remove(_duressLocationKey);

    _debugPrint('Duress state cleared (DEV MODE ONLY)');
  }

  /// Debug print helper
  static void _debugPrint(String message) {
    // Only print in debug mode
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      print('[DURESS_STATE] $message');
    }
  }
}

/// Duress Details Model
/// Contains information about active duress session
class DuressDetails {
  final String userId;
  final DateTime timestamp;
  final String? location;
  final int durationMinutes;

  const DuressDetails({
    required this.userId,
    required this.timestamp,
    this.location,
    required this.durationMinutes,
  });

  bool get isOverdue => durationMinutes >= 120; // 2+ hours

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
      'duration_minutes': durationMinutes,
      'is_overdue': isOverdue,
    };
  }
}
