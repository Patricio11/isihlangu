/// Fake Card Data
/// Mock data for card management screens
class FakeCardData {
  // Card details
  static const String cardNumber = '•••• •••• •••• 4521';
  static const String cardNumberFull = '5399 8374 2916 4521';
  static const String cvv = '847';
  static const String expiryDate = '09/27';
  static const String cardholderName = 'THABO MOKOENA';
  static const String cardType = 'Visa';

  // Card status
  static const bool isFrozen = false;
  static const bool isLocked = false;

  // Card limits (in Rands)
  static const double dailySpendLimit = 5000.0;
  static const double atmWithdrawalLimit = 3000.0;
  static const double onlineLimit = 10000.0;

  // Default limits range
  static const double minDailyLimit = 500.0;
  static const double maxDailyLimit = 10000.0;
  static const double minAtmLimit = 500.0;
  static const double maxAtmLimit = 5000.0;

  // Card settings
  static const bool onlinePurchasesEnabled = true;
  static const bool internationalTransactionsEnabled = false;
  static const bool contactlessEnabled = true;

  // Virtual card (temporary)
  static const String? virtualCardNumber = null;
  static const String? virtualCardExpiry = null;
  static const int? virtualCardHoursRemaining = null;

  // Card color (for UI)
  static const int cardColorValue = 0xFF14B8A6; // Primary dark
}
