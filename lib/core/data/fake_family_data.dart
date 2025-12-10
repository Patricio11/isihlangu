/// Family Member Model
class FamilyMember {
  final String id;
  final String name;
  final String role; // 'parent' or 'child'
  final int? age;
  final double balance;
  final String avatar; // Initials or emoji
  final DateTime lastActive;
  final FamilyMemberPermissions permissions;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.role,
    this.age,
    required this.balance,
    required this.avatar,
    required this.lastActive,
    required this.permissions,
  });
}

/// Family Member Permissions Model
class FamilyMemberPermissions {
  final bool canMakePayments;
  final bool canViewFullBalance;
  final bool onlinePurchases;
  final bool atmWithdrawals;
  final double dailyLimit;
  final double perTransactionLimit;
  final bool notifyAll;
  final bool notifyLargeTransactions;
  final double largeTransactionThreshold;
  final bool cardFrozen;

  const FamilyMemberPermissions({
    required this.canMakePayments,
    required this.canViewFullBalance,
    required this.onlinePurchases,
    required this.atmWithdrawals,
    required this.dailyLimit,
    required this.perTransactionLimit,
    required this.notifyAll,
    required this.notifyLargeTransactions,
    required this.largeTransactionThreshold,
    required this.cardFrozen,
  });

  FamilyMemberPermissions copyWith({
    bool? canMakePayments,
    bool? canViewFullBalance,
    bool? onlinePurchases,
    bool? atmWithdrawals,
    double? dailyLimit,
    double? perTransactionLimit,
    bool? notifyAll,
    bool? notifyLargeTransactions,
    double? largeTransactionThreshold,
    bool? cardFrozen,
  }) {
    return FamilyMemberPermissions(
      canMakePayments: canMakePayments ?? this.canMakePayments,
      canViewFullBalance: canViewFullBalance ?? this.canViewFullBalance,
      onlinePurchases: onlinePurchases ?? this.onlinePurchases,
      atmWithdrawals: atmWithdrawals ?? this.atmWithdrawals,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      perTransactionLimit: perTransactionLimit ?? this.perTransactionLimit,
      notifyAll: notifyAll ?? this.notifyAll,
      notifyLargeTransactions: notifyLargeTransactions ?? this.notifyLargeTransactions,
      largeTransactionThreshold: largeTransactionThreshold ?? this.largeTransactionThreshold,
      cardFrozen: cardFrozen ?? this.cardFrozen,
    );
  }
}

/// Mock Family Data
/// PHASE 1.5: Task 1.15 - Role-Based Screens
class FakeFamilyData {
  static const String familyName = 'The Molefe Family';
  static const String familyCode = 'SHIELD-7X4K';

  /// Parent member
  static final FamilyMember parent = FamilyMember(
    id: 'parent-001',
    name: 'Thabo Molefe',
    role: 'parent',
    age: 42,
    balance: 12450.50,
    avatar: 'TM',
    lastActive: DateTime.now().subtract(const Duration(minutes: 2)),
    permissions: const FamilyMemberPermissions(
      canMakePayments: true,
      canViewFullBalance: true,
      onlinePurchases: true,
      atmWithdrawals: true,
      dailyLimit: 10000.0,
      perTransactionLimit: 5000.0,
      notifyAll: false,
      notifyLargeTransactions: true,
      largeTransactionThreshold: 1000.0,
      cardFrozen: false,
    ),
  );

  /// Child 1 - Teenager
  static final FamilyMember child1 = FamilyMember(
    id: 'child-001',
    name: 'Lesedi Molefe',
    role: 'child',
    age: 14,
    balance: 350.0,
    avatar: 'LM',
    lastActive: DateTime.now().subtract(const Duration(hours: 1)),
    permissions: const FamilyMemberPermissions(
      canMakePayments: true,
      canViewFullBalance: true,
      onlinePurchases: true,
      atmWithdrawals: false,
      dailyLimit: 150.0,
      perTransactionLimit: 100.0,
      notifyAll: true,
      notifyLargeTransactions: true,
      largeTransactionThreshold: 50.0,
      cardFrozen: false,
    ),
  );

  /// Child 2 - Younger child
  static final FamilyMember child2 = FamilyMember(
    id: 'child-002',
    name: 'Amogelang Molefe',
    role: 'child',
    age: 10,
    balance: 125.0,
    avatar: 'AM',
    lastActive: DateTime.now().subtract(const Duration(hours: 3)),
    permissions: const FamilyMemberPermissions(
      canMakePayments: false,
      canViewFullBalance: false,
      onlinePurchases: false,
      atmWithdrawals: false,
      dailyLimit: 50.0,
      perTransactionLimit: 30.0,
      notifyAll: true,
      notifyLargeTransactions: true,
      largeTransactionThreshold: 20.0,
      cardFrozen: false,
    ),
  );

  /// Get all family members
  static List<FamilyMember> get allMembers => [parent, child1, child2];

  /// Get only children
  static List<FamilyMember> get children => [child1, child2];

  /// Get member by ID
  static FamilyMember? getMemberById(String id) {
    try {
      return allMembers.firstWhere((member) => member.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get total family balance
  static double get totalFamilyBalance {
    return allMembers.fold(0.0, (sum, member) => sum + member.balance);
  }
}
