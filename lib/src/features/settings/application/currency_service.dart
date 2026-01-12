import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rightlogistics/src/core/domain/models/country.dart';
import 'package:rightlogistics/src/core/services/persistence_service.dart';

// Provider for the selected country (base for currency)
final selectedCountryProvider =
    StateNotifierProvider<SelectedCountryNotifier, Country>((ref) {
      final persistence = ref.watch(persistenceServiceProvider);
      return SelectedCountryNotifier(persistence);
    });

class SelectedCountryNotifier extends StateNotifier<Country> {
  final PersistenceService _persistence;

  SelectedCountryNotifier(this._persistence)
    : super(_loadInitialCountry(_persistence));

  static Country _loadInitialCountry(PersistenceService persistence) {
    final code = persistence.getBaseCountryCode();
    if (code != null) {
      return Country.all.firstWhere(
        (c) => c.code == code,
        orElse: () => _defaultCountry,
      );
    }
    return _defaultCountry;
  }

  // Default to USA (USD) if nothing selected
  static const _defaultCountry = Country(
    name: 'United States',
    code: 'US',
    dialCode: '+1',
    currency: 'USD',
    flag: '🇺🇸',
  );

  Future<void> setCountry(Country country) async {
    state = country;
    await _persistence.setBaseCountryCode(country.code);
  }
}

// Provider for the Currency Service
final currencyServiceProvider = Provider<CurrencyService>((ref) {
  return CurrencyService();
});

// Future provider to fetch rates once (or periodically if needed)
final exchangeRatesProvider = FutureProvider<Map<String, double>>((ref) async {
  final service = ref.watch(currencyServiceProvider);
  return service.fetchRates();
});

class CurrencyService {
  final String _baseUrl = 'https://api.exchangerate-api.com/v4/latest/USD';

  // Cache rates in memory
  Map<String, double>? _ratesInfo;
  DateTime? _lastFetchTime;

  Future<Map<String, double>> fetchRates() async {
    // Return cached if valid (e.g., less than 1 hour old)
    if (_ratesInfo != null && _lastFetchTime != null) {
      final difference = DateTime.now().difference(_lastFetchTime!);
      if (difference.inHours < 1) {
        return _ratesInfo!;
      }
    }

    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, dynamic> rates = data['rates'];

        // Convert dynamic to double
        _ratesInfo = rates.map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        );
        _lastFetchTime = DateTime.now();
        return _ratesInfo!;
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      print('Error fetching rates: $e');
      // Fallback: Return at least USD 1.0
      return {'USD': 1.0};
    }
  }

  double convert({
    required double amount,
    required String fromCurrency, // e.g., 'USD'
    required String toCurrency, // e.g., 'GHS'
    required Map<String, double> rates,
  }) {
    if (fromCurrency == toCurrency) return amount;

    // Rates are base USD.
    // formula: amount * (rateTo / rateFrom)
    final rateFrom = rates[fromCurrency] ?? 1.0;
    final rateTo = rates[toCurrency] ?? 1.0;

    return amount * (rateTo / rateFrom);
  }
}
