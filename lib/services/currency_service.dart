
class CurrencyService {
  static const Map<String, double> exchangeRates = {
    'GNF': 1000.0,  // Guinée
    'AOA': 800.0,   // Angola
    'FCFA': 600.0,  // Côte d'Ivoire
  };

  static const Map<String, String> countryCurrency = {
    'Guinée': 'GNF',
    'Angola': 'AOA',
    'Côte d\'Ivoire': 'FCFA',
  };

  static double convertToLocal(double afriCoinAmount, String currency) {
    return afriCoinAmount * (exchangeRates[currency] ?? 1.0);
  }

  static double convertToAfriCoin(double localAmount, String currency) {
    return localAmount / (exchangeRates[currency] ?? 1.0);
  }
}
