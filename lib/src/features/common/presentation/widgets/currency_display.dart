import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rightlogistics/src/features/settings/application/currency_service.dart';
import 'package:shimmer/shimmer.dart';

class CurrencyDisplay extends ConsumerWidget {
  final double amount;
  final String? fromCurrency; // Defaults to USD if null
  final TextStyle? style;
  final bool showSymbol;

  const CurrencyDisplay({
    super.key,
    required this.amount,
    this.fromCurrency = 'USD',
    this.style,
    this.showSymbol = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCountry = ref.watch(selectedCountryProvider);
    final ratesAsync = ref.watch(exchangeRatesProvider);

    return ratesAsync.when(
      data: (rates) {
        final service = ref.read(currencyServiceProvider);
        final convertedAmount = service.convert(
          amount: amount,
          fromCurrency: fromCurrency ?? 'USD',
          toCurrency: selectedCountry.currency,
          rates: rates,
        );

        return Text(
          '${showSymbol ? "${selectedCountry.currency} " : ""}${convertedAmount.toStringAsFixed(2)}',
          style: style,
        );
      },
      loading: () => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(width: 60, height: 16, color: Colors.white),
      ),
      error: (err, stack) => Text(
        '${fromCurrency ?? 'USD'} ${amount.toStringAsFixed(2)}',
        style: style,
      ),
    );
  }
}
