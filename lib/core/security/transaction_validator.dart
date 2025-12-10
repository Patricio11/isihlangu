import 'evidence_logger.dart';
import '../data/fake_ghost_wallet.dart';

/// Transaction Validator
/// ROADMAP: Phase 1.6 - Task 1.6.1
///
/// Implements the CRITICAL "Sacrificial Wallet Protocol"
/// - Transactions under R200: SUCCEED (attacker satisfied, user safe)
/// - Transactions R200+: FAIL with fake network error (funds protected)
///
/// SECURITY DESIGN:
/// This is the CORE security innovation of Shield.
/// The R200 limit allows small "sacrificial" payments to succeed,
/// preventing the attacker from suspecting duress mode is active.
class TransactionValidator {
  // CRITICAL CONSTANT: The sacrificial limit
  // Transactions under this amount succeed in duress mode
  // Transactions at or above this amount are blocked
  static const double sacrificialLimit = 200.00;

  /// Validate a transaction in duress mode
  /// Returns TransactionResult with success status and appropriate message
  static TransactionResult validateDuressTransaction({
    required String merchantName,
    required double amount,
    required String category,
    required String userId,
  }) {
    // Check if transaction is within sacrificial limit
    if (amount >= sacrificialLimit) {
      // BLOCK: Transaction too large - protect real funds
      _logBlockedTransaction(
        merchantName: merchantName,
        amount: amount,
        category: category,
        userId: userId,
      );

      return TransactionResult(
        success: false,
        errorType: TransactionErrorType.networkError,
        message: _getRealisticNetworkErrorMessage(),
        shouldShowEvidence: false, // NO indication this was blocked by limit
      );
    }

    // Check if ghost wallet has sufficient funds
    if (!GhostWalletService.canProcessTransaction(amount)) {
      // BLOCK: Insufficient ghost funds
      _logBlockedTransaction(
        merchantName: merchantName,
        amount: amount,
        category: category,
        userId: userId,
      );

      return TransactionResult(
        success: false,
        errorType: TransactionErrorType.insufficientFunds,
        message: 'Insufficient funds. Available: R${GhostWalletService.getRemainingFunds().toStringAsFixed(2)}',
        shouldShowEvidence: false,
      );
    }

    // SUCCESS: Transaction approved (visual only)
    _logSuccessfulTransaction(
      merchantName: merchantName,
      amount: amount,
      category: category,
      userId: userId,
    );

    // Process the transaction in ghost wallet
    final processed = GhostWalletService.processTransaction(
      merchantName: merchantName,
      amount: amount,
      category: category,
    );

    return TransactionResult(
      success: processed,
      errorType: null,
      message: 'Payment successful',
      shouldShowEvidence: true, // Show subtle evidence indicator
      newBalance: GhostWalletService.getCurrentBalance(),
    );
  }

  /// Validate a normal (safe mode) transaction
  /// Returns immediate success for demonstration purposes
  /// In Phase 2, this will integrate with real payment API
  static TransactionResult validateSafeTransaction({
    required String merchantName,
    required double amount,
    required String category,
    required double currentBalance,
  }) {
    // Check sufficient funds
    if (amount > currentBalance) {
      return TransactionResult(
        success: false,
        errorType: TransactionErrorType.insufficientFunds,
        message: 'Insufficient funds. Available: R${currentBalance.toStringAsFixed(2)}',
        shouldShowEvidence: false,
      );
    }

    // Mock success (Phase 2: integrate with Stitch API)
    return TransactionResult(
      success: true,
      errorType: null,
      message: 'Payment successful',
      shouldShowEvidence: false,
      newBalance: currentBalance - amount,
    );
  }

  /// Get a realistic network error message
  /// These errors must be indistinguishable from real network failures
  /// to prevent attackers from detecting duress mode
  static String _getRealisticNetworkErrorMessage() {
    final errors = [
      'Unable to connect to server. Please check your connection and try again.',
      'Network timeout. Please try again later.',
      'Service temporarily unavailable. Please try again in a few moments.',
      'Connection error. Please check your internet connection.',
    ];

    // Use timestamp to select message (pseudo-random but consistent)
    final index = DateTime.now().second % errors.length;
    return errors[index];
  }

  /// Log a successful duress transaction
  static void _logSuccessfulTransaction({
    required String merchantName,
    required double amount,
    required String category,
    required String userId,
  }) {
    EvidenceLogger.logDuressTransaction(
      merchantName: merchantName,
      amount: amount,
      category: category,
      userId: userId,
      wasSuccessful: true,
    );
  }

  /// Log a blocked duress transaction
  static void _logBlockedTransaction({
    required String merchantName,
    required double amount,
    required String category,
    required String userId,
  }) {
    EvidenceLogger.logDuressTransaction(
      merchantName: merchantName,
      amount: amount,
      category: category,
      userId: userId,
      wasSuccessful: false,
    );
  }

  /// Check if an amount would be blocked in duress mode
  /// Used by UI to show warnings before attempting transaction
  static bool wouldBeBlockedInDuress(double amount) {
    return amount >= sacrificialLimit;
  }

  /// Get the sacrificial limit (for UI display if needed)
  static double getSacrificialLimit() {
    return sacrificialLimit;
  }

  /// Simulate network delay for realistic error presentation
  /// Both success and failure should take similar time
  static Future<void> simulateNetworkDelay() async {
    // Random delay between 1.5-3 seconds for realism
    final delayMs = 1500 + (DateTime.now().millisecond % 1500);
    await Future.delayed(Duration(milliseconds: delayMs));
  }
}

/// Transaction Result Model
class TransactionResult {
  final bool success;
  final TransactionErrorType? errorType;
  final String message;
  final bool shouldShowEvidence; // Show subtle "Evidence Recorded" indicator
  final double? newBalance;

  const TransactionResult({
    required this.success,
    required this.errorType,
    required this.message,
    required this.shouldShowEvidence,
    this.newBalance,
  });

  bool get isNetworkError => errorType == TransactionErrorType.networkError;
  bool get isInsufficientFunds => errorType == TransactionErrorType.insufficientFunds;
}

/// Transaction Error Types
enum TransactionErrorType {
  networkError,       // Fake network error (amount >= R200)
  insufficientFunds,  // Actual insufficient funds
  invalidAmount,      // Invalid amount entered
  other,             // Other errors
}
