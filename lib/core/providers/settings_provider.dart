import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App Settings State
class SettingsState {
  final bool biometricEnabled;
  final bool notificationsEnabled;
  final bool transactionAlerts;
  final bool securityAlerts;
  final String currency; // 'R 1,000.00' vs 'R1000.00'
  final String language; // 'en', 'zu', 'af'

  const SettingsState({
    this.biometricEnabled = false,
    this.notificationsEnabled = true,
    this.transactionAlerts = true,
    this.securityAlerts = true,
    this.currency = 'spaced', // 'spaced' or 'compact'
    this.language = 'en',
  });

  SettingsState copyWith({
    bool? biometricEnabled,
    bool? notificationsEnabled,
    bool? transactionAlerts,
    bool? securityAlerts,
    String? currency,
    String? language,
  }) {
    return SettingsState(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      transactionAlerts: transactionAlerts ?? this.transactionAlerts,
      securityAlerts: securityAlerts ?? this.securityAlerts,
      currency: currency ?? this.currency,
      language: language ?? this.language,
    );
  }

  String getCurrencyFormat(double amount) {
    if (currency == 'spaced') {
      // R 12,450.50
      return 'R ${_formatNumber(amount)}';
    } else {
      // R12450.50
      return 'R${_formatNumber(amount)}';
    }
  }

  String _formatNumber(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

/// Settings Notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _loadSettings();
  }

  static const String _biometricKey = 'biometric_enabled';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _transactionAlertsKey = 'transaction_alerts';
  static const String _securityAlertsKey = 'security_alerts';
  static const String _currencyKey = 'currency_format';
  static const String _languageKey = 'language';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    state = SettingsState(
      biometricEnabled: prefs.getBool(_biometricKey) ?? false,
      notificationsEnabled: prefs.getBool(_notificationsKey) ?? true,
      transactionAlerts: prefs.getBool(_transactionAlertsKey) ?? true,
      securityAlerts: prefs.getBool(_securityAlertsKey) ?? true,
      currency: prefs.getString(_currencyKey) ?? 'spaced',
      language: prefs.getString(_languageKey) ?? 'en',
    );
  }

  Future<void> toggleBiometric(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, value);
    state = state.copyWith(biometricEnabled: value);
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
    state = state.copyWith(notificationsEnabled: value);
  }

  Future<void> toggleTransactionAlerts(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_transactionAlertsKey, value);
    state = state.copyWith(transactionAlerts: value);
  }

  Future<void> toggleSecurityAlerts(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_securityAlertsKey, value);
    state = state.copyWith(securityAlerts: value);
  }

  Future<void> setCurrencyFormat(String format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, format);
    state = state.copyWith(currency: format);
  }

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
    state = state.copyWith(language: language);
  }

  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_biometricKey);
    await prefs.remove(_notificationsKey);
    await prefs.remove(_transactionAlertsKey);
    await prefs.remove(_securityAlertsKey);
    await prefs.remove(_currencyKey);
    await prefs.remove(_languageKey);

    state = const SettingsState();
  }
}

/// Settings Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
