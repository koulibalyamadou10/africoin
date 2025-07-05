import 'package:africoin/services/currency_service.dart';

class User {
  final String id;
  final String email;
  final String phone;
  final String country;
  final String currency;
  final String fullName;
  double afriCoinBalance;
  String? pin;

  User({
    required this.id,
    required this.email,
    required this.phone,
    required this.country,
    required this.currency,
    required this.fullName,
    this.afriCoinBalance = 50.0, // Solde initial
    this.pin,
  });

  double get localCurrencyBalance {
    final rates = CurrencyService.exchangeRates;
    return afriCoinBalance * (rates[currency] ?? 1.0);
  }
}
