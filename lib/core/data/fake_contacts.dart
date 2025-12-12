/// Fake Contacts Data
/// PHASE 1.5 BONUS: Contacts Screen
/// Mock data for beneficiary management

class BeneficiaryContact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final String? bank;
  final String? accountNumber;
  final String initials;
  final String color; // Hex color for avatar
  final bool isFavorite;
  final int transactionCount;
  final double totalSent;

  const BeneficiaryContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.bank,
    this.accountNumber,
    required this.initials,
    required this.color,
    this.isFavorite = false,
    this.transactionCount = 0,
    this.totalSent = 0,
  });

  BeneficiaryContact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? bank,
    String? accountNumber,
    String? initials,
    String? color,
    bool? isFavorite,
    int? transactionCount,
    double? totalSent,
  }) {
    return BeneficiaryContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      bank: bank ?? this.bank,
      accountNumber: accountNumber ?? this.accountNumber,
      initials: initials ?? this.initials,
      color: color ?? this.color,
      isFavorite: isFavorite ?? this.isFavorite,
      transactionCount: transactionCount ?? this.transactionCount,
      totalSent: totalSent ?? this.totalSent,
    );
  }
}

/// Safe Mode Contacts (Full Access)
class FakeContacts {
  static const List<BeneficiaryContact> allContacts = [
    // Favorites
    BeneficiaryContact(
      id: '1',
      name: 'Thabo Mkhize',
      phoneNumber: '+27 82 456 7890',
      email: 'thabo.m@email.com',
      bank: 'Standard Bank',
      accountNumber: '1234567890',
      initials: 'TM',
      color: '#10B981', // Green
      isFavorite: true,
      transactionCount: 23,
      totalSent: 4500.00,
    ),
    BeneficiaryContact(
      id: '2',
      name: 'Nomsa Dlamini',
      phoneNumber: '+27 71 234 5678',
      email: 'nomsa.d@email.com',
      bank: 'FNB',
      accountNumber: '9876543210',
      initials: 'ND',
      color: '#EC4899', // Pink
      isFavorite: true,
      transactionCount: 18,
      totalSent: 3200.00,
    ),
    BeneficiaryContact(
      id: '3',
      name: 'Sipho Ndlovu',
      phoneNumber: '+27 83 987 6543',
      email: 'sipho.n@email.com',
      bank: 'Capitec',
      accountNumber: '5551234567',
      initials: 'SN',
      color: '#3B82F6', // Blue
      isFavorite: true,
      transactionCount: 15,
      totalSent: 2800.00,
    ),

    // Regular Contacts
    BeneficiaryContact(
      id: '4',
      name: 'Zanele Khumalo',
      phoneNumber: '+27 72 345 6789',
      bank: 'Nedbank',
      accountNumber: '7778889990',
      initials: 'ZK',
      color: '#8B5CF6', // Purple
      isFavorite: false,
      transactionCount: 8,
      totalSent: 1500.00,
    ),
    BeneficiaryContact(
      id: '5',
      name: 'Bongani Nkosi',
      phoneNumber: '+27 84 654 3210',
      bank: 'Absa',
      accountNumber: '1112223334',
      initials: 'BN',
      color: '#F59E0B', // Orange
      isFavorite: false,
      transactionCount: 5,
      totalSent: 950.00,
    ),
    BeneficiaryContact(
      id: '6',
      name: 'Lindiwe Mahlangu',
      phoneNumber: '+27 73 111 2222',
      email: 'lindiwe.m@email.com',
      bank: 'Standard Bank',
      accountNumber: '4445556667',
      initials: 'LM',
      color: '#14B8A6', // Teal
      isFavorite: false,
      transactionCount: 4,
      totalSent: 720.00,
    ),
    BeneficiaryContact(
      id: '7',
      name: 'Mandla Zuma',
      phoneNumber: '+27 81 888 9999',
      bank: 'FNB',
      accountNumber: '2223334445',
      initials: 'MZ',
      color: '#EF4444', // Red
      isFavorite: false,
      transactionCount: 3,
      totalSent: 500.00,
    ),
    BeneficiaryContact(
      id: '8',
      name: 'Precious Sithole',
      phoneNumber: '+27 76 777 6666',
      email: 'precious.s@email.com',
      bank: 'Capitec',
      accountNumber: '8889990001',
      initials: 'PS',
      color: '#06B6D4', // Cyan
      isFavorite: false,
      transactionCount: 2,
      totalSent: 300.00,
    ),
  ];

  static List<BeneficiaryContact> get favoriteContacts =>
      allContacts.where((c) => c.isFavorite).toList();

  static List<BeneficiaryContact> get regularContacts =>
      allContacts.where((c) => !c.isFavorite).toList();

  static int get totalContactsCount => allContacts.length;
  static int get favoritesCount => favoriteContacts.length;
}

/// Duress Mode - LIMITED ACCESS TO CONTACTS
/// In duress mode, users can see contacts but with restrictions
class FakeDuressContacts {
  static const hasAccess = true; // Can view but cannot add/edit/delete
  static const canModify = false; // Cannot add, edit, or delete contacts
}
