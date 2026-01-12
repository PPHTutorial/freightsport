import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main');
});

class PersistenceService {
  final SharedPreferences _prefs;
  PersistenceService(this._prefs);

  static const String _onboardingKey = 'has_seen_onboarding';
  static const String _themeKey = 'theme_mode';

  bool hasSeenOnboarding() => _prefs.getBool(_onboardingKey) ?? false;
  Future<void> setOnboardingSeen() => _prefs.setBool(_onboardingKey, true);

  String? getThemeMode() => _prefs.getString(_themeKey);
  Future<void> setThemeMode(String mode) => _prefs.setString(_themeKey, mode);

  static const String _currencyKey = 'base_currency_country_code';
  String? getBaseCountryCode() => _prefs.getString(_currencyKey);
  Future<void> setBaseCountryCode(String code) =>
      _prefs.setString(_currencyKey, code);
}

final persistenceServiceProvider = Provider<PersistenceService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PersistenceService(prefs);
});
