/// Transaction Model
class Transaction {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final TransactionType type;
  final DateTime timestamp;
  final String? icon;
  final String? category;
  final String? referenceNumber;
  final String? notes;
  final TransactionStatus status;

  const Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    required this.timestamp,
    this.icon,
    this.category,
    this.referenceNumber,
    this.notes,
    this.status = TransactionStatus.completed,
  });

  bool get isPositive => type == TransactionType.received || type == TransactionType.refund;
  bool get isNegative => type == TransactionType.sent || type == TransactionType.purchase;
}

enum TransactionType {
  sent,
  received,
  purchase,
  refund,
}

enum TransactionStatus {
  completed,
  pending,
  failed,
  cancelled,
}

/// Mock Transaction Data
/// PHASE 1: Hardcoded data for UI development
/// PHASE 2: Will be fetched from Supabase
class FakeTransactions {
  /// Transactions for Safe Mode (Normal balance account)
  static List<Transaction> get safeModeTransactions => [
        Transaction(
          id: 'txn-001',
          title: 'Pick n Pay',
          subtitle: 'Groceries',
          amount: -450.00,
          type: TransactionType.purchase,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          icon: '🛒',
          category: 'Groceries',
          referenceNumber: 'REF-PNP-2024-001234',
          status: TransactionStatus.completed,
        ),
        Transaction(
          id: 'txn-002',
          title: 'Salary Deposit',
          subtitle: 'Company XYZ',
          amount: 15000.00,
          type: TransactionType.received,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          icon: '💰',
          category: 'Income',
          referenceNumber: 'REF-SAL-2024-DEC',
          status: TransactionStatus.completed,
        ),
        Transaction(
          id: 'txn-003',
          title: 'Uber',
          subtitle: 'Transport',
          amount: -85.50,
          type: TransactionType.purchase,
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
          icon: '🚗',
        ),
        Transaction(
          id: 'txn-004',
          title: 'Sent to Sipho',
          subtitle: 'Payment',
          amount: -500.00,
          type: TransactionType.sent,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          icon: '👤',
        ),
        Transaction(
          id: 'txn-005',
          title: 'Woolworths',
          subtitle: 'Shopping',
          amount: -1200.00,
          type: TransactionType.purchase,
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          icon: '🛍️',
        ),
        Transaction(
          id: 'txn-006',
          title: 'Netflix',
          subtitle: 'Subscription',
          amount: -199.00,
          type: TransactionType.purchase,
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          icon: '📺',
        ),
        Transaction(
          id: 'txn-007',
          title: 'Refund from Takealot',
          subtitle: 'Return processed',
          amount: 350.00,
          type: TransactionType.refund,
          timestamp: DateTime.now().subtract(const Duration(days: 6)),
          icon: '📦',
        ),
        Transaction(
          id: 'txn-008',
          title: 'Nando\'s',
          subtitle: 'Restaurant',
          amount: -280.00,
          type: TransactionType.purchase,
          timestamp: DateTime.now().subtract(const Duration(days: 7)),
          icon: '🍗',
        ),
      ];

  /// Transactions for Duress Mode (Low balance fake account)
  /// Shows minimal, believable activity
  static List<Transaction> get duressTransactions => [
        Transaction(
          id: 'dtxn-001',
          title: 'Checkers',
          subtitle: 'Groceries',
          amount: -120.00,
          type: TransactionType.purchase,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          icon: '🛒',
        ),
        Transaction(
          id: 'dtxn-002',
          title: 'Taxi',
          subtitle: 'Transport',
          amount: -25.00,
          type: TransactionType.purchase,
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          icon: '🚕',
        ),
        Transaction(
          id: 'dtxn-003',
          title: 'Airtime',
          subtitle: 'Vodacom',
          amount: -50.00,
          type: TransactionType.purchase,
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          icon: '📱',
        ),
      ];

  /// Get transactions based on session scope
  static List<Transaction> getTransactions({required bool isDuressMode}) {
    return isDuressMode ? duressTransactions : safeModeTransactions;
  }
}
