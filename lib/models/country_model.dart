class Country {
  final String code;
  final String name;
  final String currency;
  final String flag;
  final double exchangeRate; // Taux par rapport à AFRICOIN

  Country({
    required this.code,
    required this.name,
    required this.currency,
    required this.flag,
    required this.exchangeRate,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      code: json['code'],
      name: json['name'],
      currency: json['currency'],
      flag: json['flag'],
      exchangeRate: json['exchangeRate'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'currency': currency,
      'flag': flag,
      'exchangeRate': exchangeRate,
    };
  }
}