/// Fake Statistics Data
/// PHASE 1.5 BONUS: Statistics Screen
/// Mock data for spending analytics and insights

class SpendingCategory {
  final String name;
  final String icon;
  final double amount;
  final double percentage;
  final String color; // Hex color

  const SpendingCategory({
    required this.name,
    required this.icon,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

class MonthlySpending {
  final String month;
  final double amount;

  const MonthlySpending({
    required this.month,
    required this.amount,
  });
}

/// Safe Mode Statistics (Full Access)
class FakeStatistics {
  // Current month spending
  static const double currentMonthSpending = 4250.75;
  static const double lastMonthSpending = 3890.50;
  static const double averageMonthlySpending = 4100.25;

  // Spending by category (December 2025)
  static const List<SpendingCategory> categories = [
    SpendingCategory(
      name: 'Groceries',
      icon: '🛒',
      amount: 1520.50,
      percentage: 35.8,
      color: '#10B981', // Green
    ),
    SpendingCategory(
      name: 'Transport',
      icon: '🚗',
      amount: 980.25,
      percentage: 23.1,
      color: '#3B82F6', // Blue
    ),
    SpendingCategory(
      name: 'Entertainment',
      icon: '🎬',
      amount: 675.00,
      percentage: 15.9,
      color: '#8B5CF6', // Purple
    ),
    SpendingCategory(
      name: 'Restaurants',
      icon: '🍽️',
      amount: 545.00,
      percentage: 12.8,
      color: '#F59E0B', // Orange
    ),
    SpendingCategory(
      name: 'Shopping',
      icon: '🛍️',
      amount: 385.00,
      percentage: 9.1,
      color: '#EC4899', // Pink
    ),
    SpendingCategory(
      name: 'Other',
      icon: '📦',
      amount: 145.00,
      percentage: 3.4,
      color: '#6B7280', // Gray
    ),
  ];

  // Monthly spending trend (last 6 months)
  static const List<MonthlySpending> monthlyTrend = [
    MonthlySpending(month: 'Jul', amount: 3850.00),
    MonthlySpending(month: 'Aug', amount: 4100.50),
    MonthlySpending(month: 'Sep', amount: 3950.25),
    MonthlySpending(month: 'Oct', amount: 4300.75),
    MonthlySpending(month: 'Nov', amount: 3890.50),
    MonthlySpending(month: 'Dec', amount: 4250.75),
  ];

  // Insights
  static const String topSpendingDay = 'Saturday';
  static const int transactionCount = 87;
  static const double averageTransactionSize = 48.85;
  static const String mostFrequentMerchant = 'Pick n Pay';

  // Comparison
  static double get spendingChange =>
      ((currentMonthSpending - lastMonthSpending) / lastMonthSpending) * 100;
  static bool get isSpendingUp => spendingChange > 0;

  // Budget status
  static const double monthlyBudget = 5000.00;
  static double get budgetUsedPercentage =>
      (currentMonthSpending / monthlyBudget) * 100;
  static double get budgetRemaining => monthlyBudget - currentMonthSpending;
  static bool get isOverBudget => currentMonthSpending > monthlyBudget;
}

/// Duress Mode - NO ACCESS TO STATISTICS
/// In duress mode, users cannot access detailed analytics
class FakeDuressStatistics {
  static const hasAccess = false;
}
