import 'fake_transactions.dart';

/// Ghost Wallet Data
/// ROADMAP: Phase 1.6 - Task 1.6.1
///
/// This is the "Sacrificial Wallet" - a realistic-looking fake account
/// shown to attackers when the user enters duress mode (PIN 9999).
///
/// SECURITY DESIGN:
/// - Balance: R185.50 (enough for small purchases, appears authentic)
/// - Transactions: 3-5 recent, realistic South African purchases
/// - Purpose: Satisfy attackers while protecting real funds
/// - Evidence: All duress transactions are silently logged
class FakeGhostWallet {
  // Ghost Balance - appears authentic to attackers
  static const double ghostBalance = 185.50;

  // Ghost transactions - realistic SA purchases
  static final List<Transaction> ghostTransactions = [
    Transaction(
      id: 'ghost-1',
      title: 'Shoprite',
      subtitle: 'Groceries',
      amount: -42.50,
      type: TransactionType.purchase,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Groceries',
      icon: '🛒',
    ),
    Transaction(
      id: 'ghost-2',
      title: 'Taxi Fare',
      subtitle: 'Transport',
      amount: -15.00,
      type: TransactionType.purchase,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Transport',
      icon: '🚖',
    ),
    Transaction(
      id: 'ghost-3',
      title: 'MTN Airtime',
      subtitle: 'Airtime',
      amount: -30.00,
      type: TransactionType.purchase,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Bills',
      icon: '📱',
    ),
    Transaction(
      id: 'ghost-4',
      title: 'Allowance Deposit',
      subtitle: 'Weekly allowance',
      amount: 150.00,
      type: TransactionType.received,
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      category: 'Income',
      icon: '💰',
    ),
    Transaction(
      id: 'ghost-5',
      title: 'Spur Restaurant',
      subtitle: 'Dining',
      amount: -87.00,
      type: TransactionType.purchase,
      timestamp: DateTime.now().subtract(const Duration(days: 8)),
      category: 'Food',
      icon: '🍽️',
    ),
  ];

  /// Get ghost transactions for duress mode
  /// Returns recent transactions that appear realistic
  static List<Transaction> getGhostTransactions() {
    return ghostTransactions;
  }

  /// Get ghost balance
  /// This is the fake balance shown to attackers
  static double getGhostBalance() {
    return ghostBalance;
  }

  /// Calculate updated ghost balance after a duress transaction
  /// This creates the illusion that the transaction succeeded
  /// NOTE: This is VISUAL ONLY - no real money moves
  static double calculateGhostBalanceAfterTransaction(double amount) {
    return ghostBalance - amount;
  }

  /// Add a new ghost transaction (for visual continuity)
  /// Called after successful duress transaction to maintain the illusion
  static Transaction createGhostTransaction({
    required String merchantName,
    required double amount,
    required String category,
  }) {
    return Transaction(
      id: 'ghost-${DateTime.now().millisecondsSinceEpoch}',
      title: merchantName,
      subtitle: category,
      amount: -amount, // Negative because it's a purchase
      type: TransactionType.purchase,
      timestamp: DateTime.now(),
      category: category,
      icon: _getCategoryIcon(category),
    );
  }

  /// Get icon for category
  static String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'groceries':
        return '🛒';
      case 'transport':
        return '🚖';
      case 'food':
      case 'dining':
        return '🍽️';
      case 'bills':
      case 'airtime':
        return '📱';
      case 'shopping':
        return '🛍️';
      case 'entertainment':
        return '🎬';
      default:
        return '💳';
    }
  }
}

/// Ghost Wallet Service
/// Manages the ghost wallet state during duress mode
class GhostWalletService {
  // Current ghost balance (starts at 185.50, decreases with transactions)
  static double _currentGhostBalance = FakeGhostWallet.ghostBalance;

  // Ghost transaction history (grows as user makes duress transactions)
  static final List<Transaction> _ghostTransactionHistory =
      List.from(FakeGhostWallet.ghostTransactions);

  /// Get current ghost balance
  static double getCurrentBalance() {
    return _currentGhostBalance;
  }

  /// Get ghost transaction history
  static List<Transaction> getTransactionHistory() {
    return _ghostTransactionHistory;
  }

  /// Process a duress transaction (visual only)
  /// Returns true if transaction "succeeds" (amount < R200)
  /// Returns false if transaction should be blocked (amount >= R200)
  static bool processTransaction({
    required String merchantName,
    required double amount,
    required String category,
  }) {
    // CRITICAL: The R200 limit
    // Transactions under R200 succeed (attacker satisfied)
    // Transactions over R200 fail with fake error (funds protected)
    if (amount >= 200.00) {
      return false; // Block transaction - will show network error
    }

    // Visual transaction success
    _currentGhostBalance -= amount;

    // Add to transaction history (maintains illusion)
    final transaction = FakeGhostWallet.createGhostTransaction(
      merchantName: merchantName,
      amount: amount,
      category: category,
    );
    _ghostTransactionHistory.insert(0, transaction);

    return true; // Transaction "succeeded"
  }

  /// Reset ghost wallet (called when duress mode exits)
  static void reset() {
    _currentGhostBalance = FakeGhostWallet.ghostBalance;
    _ghostTransactionHistory.clear();
    _ghostTransactionHistory.addAll(FakeGhostWallet.ghostTransactions);
  }

  /// Check if transaction amount is within ghost wallet limit
  /// Used by UI to show appropriate error before attempting transaction
  static bool canProcessTransaction(double amount) {
    return amount < 200.00 && amount <= _currentGhostBalance;
  }

  /// Get remaining ghost funds
  static double getRemainingFunds() {
    return _currentGhostBalance;
  }
}
