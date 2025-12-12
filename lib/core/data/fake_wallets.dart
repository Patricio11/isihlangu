/// Fake Wallets Data
/// PHASE 1.5 BONUS: Multi-Wallet View
/// Mock data for wallet cards and savings pots

class WalletData {
  final String id;
  final String name;
  final double balance;
  final String type; // 'main', 'lunch', 'savings'
  final String? icon;
  final String? color; // Hex color for gradient
  final SavingsGoal? savingsGoal;

  const WalletData({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
    this.icon,
    this.color,
    this.savingsGoal,
  });
}

class SavingsGoal {
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;
  final String? icon;

  const SavingsGoal({
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
    this.icon,
  });

  double get progress => currentAmount / targetAmount;
  double get percentageComplete => (progress * 100).clamp(0, 100);
  bool get isComplete => currentAmount >= targetAmount;
  int get daysRemaining => deadline != null
      ? deadline!.difference(DateTime.now()).inDays
      : 0;
}

/// Safe Mode Wallets (Full Access)
class FakeWallets {
  static const mainWallet = WalletData(
    id: 'main',
    name: 'Main Wallet',
    balance: 12450.50,
    type: 'main',
    icon: '💳',
    color: '#2DD4BF', // Primary teal
  );

  static const lunchMoneyWallet = WalletData(
    id: 'lunch',
    name: 'Lunch Money',
    balance: 250.00,
    type: 'lunch',
    icon: '🍔',
    color: '#FFB800', // Orange/Yellow for food
  );

  static final savingsWallet = WalletData(
    id: 'savings',
    name: 'New Bike',
    balance: 1200.00,
    type: 'savings',
    icon: '🚲',
    color: '#10B981', // Green for savings
    savingsGoal: SavingsGoal(
      name: 'New Bike',
      targetAmount: 3500.00,
      currentAmount: 1200.00,
      deadline: DateTime(2025, 3, 15), // March 15, 2025
      icon: '🚲',
    ),
  );

  static final List<WalletData> allWallets = [
    mainWallet,
    lunchMoneyWallet,
    savingsWallet,
  ];

  static double get totalBalance =>
      allWallets.fold(0, (sum, wallet) => sum + wallet.balance);
}

/// Duress Mode - NO ACCESS TO WALLETS
/// In duress mode, users cannot access the wallet screen at all
/// They only see the ghost balance on the home screen
class FakeDuressWallets {
  // No wallets in duress mode - redirect to home or show restricted message
  static const hasAccess = false;
}
