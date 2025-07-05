import '../models/country_model.dart';

class CountryService {
  static final List<Country> _supportedCountries = [
    Country(
      code: 'CI',
      name: 'Côte d\'Ivoire',
      currency: 'FCFA',
      flag: '🇨🇮',
      exchangeRate: 600.0,
    ),
    Country(
      code: 'SN',
      name: 'Sénégal',
      currency: 'FCFA',
      flag: '🇸🇳',
      exchangeRate: 600.0,
    ),
    Country(
      code: 'ML',
      name: 'Mali',
      currency: 'FCFA',
      flag: '🇲🇱',
      exchangeRate: 600.0,
    ),
    Country(
      code: 'BF',
      name: 'Burkina Faso',
      currency: 'FCFA',
      flag: '🇧🇫',
      exchangeRate: 600.0,
    ),
    Country(
      code: 'GN',
      name: 'Guinée',
      currency: 'GNF',
      flag: '🇬🇳',
      exchangeRate: 1000.0,
    ),
    Country(
      code: 'GH',
      name: 'Ghana',
      currency: 'GHS',
      flag: '🇬🇭',
      exchangeRate: 12.0,
    ),
    Country(
      code: 'NG',
      name: 'Nigeria',
      currency: 'NGN',
      flag: '🇳🇬',
      exchangeRate: 800.0,
    ),
    Country(
      code: 'KE',
      name: 'Kenya',
      currency: 'KES',
      flag: '🇰🇪',
      exchangeRate: 150.0,
    ),
    Country(
      code: 'ZA',
      name: 'Afrique du Sud',
      currency: 'ZAR',
      flag: '🇿🇦',
      exchangeRate: 18.0,
    ),
    Country(
      code: 'MA',
      name: 'Maroc',
      currency: 'MAD',
      flag: '🇲🇦',
      exchangeRate: 10.0,
    ),
  ];

  static List<Country> get supportedCountries => _supportedCountries;

  static Country? getCountryByCode(String code) {
    try {
      return _supportedCountries.firstWhere((country) => country.code == code);
    } catch (e) {
      return null;
    }
  }

  static Country? getCountryByName(String name) {
    try {
      return _supportedCountries.firstWhere((country) => country.name == name);
    } catch (e) {
      return null;
    }
  }

  static double convertAfricoinToLocal(double africoinAmount, String countryCode) {
    final country = getCountryByCode(countryCode);
    if (country == null) return africoinAmount;
    return africoinAmount * country.exchangeRate;
  }

  static double convertLocalToAfricoin(double localAmount, String countryCode) {
    final country = getCountryByCode(countryCode);
    if (country == null) return localAmount;
    return localAmount / country.exchangeRate;
  }

  static String formatCurrency(double amount, String countryCode) {
    final country = getCountryByCode(countryCode);
    if (country == null) return amount.toStringAsFixed(2);
    
    return '${amount.toStringAsFixed(0)} ${country.currency}';
  }
}