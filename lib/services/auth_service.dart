
import 'package:africoin/models/user_model.dart';
import 'package:africoin/models/transaction_model.dart';
import 'package:africoin/services/currency_service.dart';

class AuthService {
  static User? currentUser;
  static List<User> users = [];
  static List<Transaction> transactions = [];

  static Future<bool> login(String email, String pin) async {
    // Simulation d'authentification
    await Future.delayed(Duration(milliseconds: 500));
    
    final user = users.firstWhere(
      (u) => u.email == email && u.pin == pin,
      orElse: () => User(
        id: '',
        email: '',
        phone: '',
        country: '',
        currency: '',
        fullName: '',
      ),
    );
    
    if (user.id.isNotEmpty) {
      currentUser = user;
      return true;
    }
    return false;
  }

  static Future<User> register(String email, String phone, String fullName, String country, String pin) async {
    await Future.delayed(Duration(milliseconds: 500));
    
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      phone: phone,
      country: country,
      currency: CurrencyService.countryCurrency[country] ?? 'GNF',
      fullName: fullName,
      pin: pin,
    );
    
    users.add(user);
    currentUser = user;
    return user;
  }
}
