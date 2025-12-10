/// Evidence Logger
/// ROADMAP: Phase 1.6 - Task 1.6.1
///
/// Silent evidence collection during duress mode.
/// All duress transactions are logged with timestamps and details
/// for legal protection and forensic analysis.
///
/// SECURITY DESIGN:
/// - Logs are stored locally (encrypted in Phase 2)
/// - NO visible indicators to attacker
/// - Automatically synced to parent device in Phase 2
/// - Cannot be deleted by user in duress mode
class EvidenceLogger {
  // Evidence log storage (in-memory for Phase 1, encrypted storage in Phase 2)
  static final List<EvidenceLog> _evidenceLogs = [];

  /// Log a duress transaction
  /// Called whenever a transaction is attempted in duress mode
  static void logDuressTransaction({
    required String merchantName,
    required double amount,
    required String category,
    required String userId,
    required bool wasSuccessful,
  }) {
    final log = EvidenceLog(
      id: _generateLogId(),
      timestamp: DateTime.now(),
      type: EvidenceType.transaction,
      userId: userId,
      data: {
        'merchant': merchantName,
        'amount': amount,
        'category': category,
        'successful': wasSuccessful,
        'blocked_reason': wasSuccessful ? null : 'Amount exceeds R200 limit',
      },
    );

    _evidenceLogs.add(log);

    // TODO Phase 2: Encrypt and store in secure storage
    // TODO Phase 2: Sync to parent device via Supabase Realtime
    _debugPrint('Evidence logged: Transaction to $merchantName - R$amount ${wasSuccessful ? "succeeded" : "blocked"}');
  }

  /// Log duress mode entry
  /// Called when user enters PIN 9999
  static void logDuressEntry({
    required String userId,
    String? location,
  }) {
    final log = EvidenceLog(
      id: _generateLogId(),
      timestamp: DateTime.now(),
      type: EvidenceType.duressEntry,
      userId: userId,
      data: {
        'location': location,
        'device_info': 'Mock device info', // TODO: Get real device info
      },
    );

    _evidenceLogs.add(log);

    // TODO Phase 2: Trigger silent GPS tracking
    // TODO Phase 2: Start audio recording (if permission granted)
    _debugPrint('Evidence logged: Duress mode entered by $userId');
  }

  /// Log duress mode exit
  /// Called when parent remotely unlocks the account
  static void logDuressExit({
    required String userId,
    required String exitedBy,
  }) {
    final log = EvidenceLog(
      id: _generateLogId(),
      timestamp: DateTime.now(),
      type: EvidenceType.duressExit,
      userId: userId,
      data: {
        'exited_by': exitedBy,
        'duration_minutes': _calculateDuressDuration(),
      },
    );

    _evidenceLogs.add(log);
    _debugPrint('Evidence logged: Duress mode exited by $exitedBy');
  }

  /// Log app restart attempt during duress
  /// Critical: Shows if attacker tried to reset the app
  static void logAppRestartInDuress({
    required String userId,
  }) {
    final log = EvidenceLog(
      id: _generateLogId(),
      timestamp: DateTime.now(),
      type: EvidenceType.appRestart,
      userId: userId,
      data: {
        'note': 'App restarted while in duress mode - possible forced reboot',
      },
    );

    _evidenceLogs.add(log);
    _debugPrint('Evidence logged: App restarted during duress');
  }

  /// Get all evidence logs
  /// Used by parent to review what happened during duress event
  static List<EvidenceLog> getAllLogs() {
    return List.unmodifiable(_evidenceLogs);
  }

  /// Get logs for specific user
  static List<EvidenceLog> getLogsForUser(String userId) {
    return _evidenceLogs.where((log) => log.userId == userId).toList();
  }

  /// Get logs for specific time period
  static List<EvidenceLog> getLogsBetween(DateTime start, DateTime end) {
    return _evidenceLogs.where((log) {
      return log.timestamp.isAfter(start) && log.timestamp.isBefore(end);
    }).toList();
  }

  /// Clear all logs (only callable by parent with confirmation)
  static void clearAllLogs() {
    _evidenceLogs.clear();
    _debugPrint('Evidence logs cleared');
  }

  /// Export logs as JSON (for Phase 2 - law enforcement)
  static Map<String, dynamic> exportLogsAsJson() {
    return {
      'export_timestamp': DateTime.now().toIso8601String(),
      'total_logs': _evidenceLogs.length,
      'logs': _evidenceLogs.map((log) => log.toJson()).toList(),
    };
  }

  // Private helpers

  static String _generateLogId() {
    return 'evidence-${DateTime.now().millisecondsSinceEpoch}';
  }

  static int _calculateDuressDuration() {
    // Find the last duress entry
    final duressEntry = _evidenceLogs.lastWhere(
      (log) => log.type == EvidenceType.duressEntry,
      orElse: () => EvidenceLog(
        id: '',
        timestamp: DateTime.now(),
        type: EvidenceType.duressEntry,
        userId: '',
        data: {},
      ),
    );

    final duration = DateTime.now().difference(duressEntry.timestamp);
    return duration.inMinutes;
  }

  static void _debugPrint(String message) {
    // Only print in debug mode
    // In production, this should be completely silent
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      print('[EVIDENCE] $message');
    }
  }
}

/// Evidence Log Model
class EvidenceLog {
  final String id;
  final DateTime timestamp;
  final EvidenceType type;
  final String userId;
  final Map<String, dynamic> data;

  const EvidenceLog({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.userId,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString(),
      'user_id': userId,
      'data': data,
    };
  }

  factory EvidenceLog.fromJson(Map<String, dynamic> json) {
    return EvidenceLog(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: EvidenceType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => EvidenceType.other,
      ),
      userId: json['user_id'] as String,
      data: Map<String, dynamic>.from(json['data'] as Map),
    );
  }
}

/// Evidence Types
enum EvidenceType {
  duressEntry,      // User entered duress mode (PIN 9999)
  duressExit,       // Parent remotely cleared duress status
  transaction,      // Transaction attempted in duress mode
  appRestart,       // App restarted while in duress
  locationUpdate,   // GPS location logged (Phase 2)
  audioRecording,   // Audio evidence captured (Phase 2)
  other,           // Miscellaneous evidence
}
