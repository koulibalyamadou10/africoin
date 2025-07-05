import 'dart:math';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class TransactionService {
  static List<Transaction> _transactions = [];
  
  static List<Transaction> get allTransactions => _transactions;
  
  static List<Transaction> getUserTransactions(String userId) {
    return _transactions.where((t) => 
      t.fromUserId == userId || t.toUserId == userId
    ).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  static Future<Transaction> sendMoney({
    required String fromUserId,
    required String toUserId,
    required double amount,
    String? description,
  }) async {
    // Simulation d'un délai réseau
    await Future.delayed(Duration(seconds: 2));

    final transaction = Transaction(
      id: _generateTransactionId(),
      fromUserId: fromUserId,
      toUserId: toUserId,
      amount: amount,
      date: DateTime.now(),
      type: TransactionType.send,
      status: TransactionStatus.completed,
      description: description,
    );

    _transactions.add(transaction);
    
    // Mettre à jour les soldes
    final fromUser = AuthService.users.firstWhere((u) => u.id == fromUserId);
    final toUser = AuthService.users.firstWhere((u) => u.id == toUserId);
    
    fromUser.afriCoinBalance -= amount;
    toUser.afriCoinBalance += amount;

    return transaction;
  }

  static Future<Transaction> requestMoney({
    required String fromUserId,
    required String toUserId,
    required double amount,
    String? description,
  }) async {
    await Future.delayed(Duration(seconds: 1));

    final transaction = Transaction(
      id: _generateTransactionId(),
      fromUserId: fromUserId,
      toUserId: toUserId,
      amount: amount,
      date: DateTime.now(),
      type: TransactionType.receive,
      status: TransactionStatus.pending,
      description: description ?? 'Demande de paiement',
    );

    _transactions.add(transaction);
    return transaction;
  }

  static Future<Transaction> topUpAccount({
    required String userId,
    required double amount,
    required String paymentMethod,
  }) async {
    await Future.delayed(Duration(seconds: 3));

    final transaction = Transaction(
      id: _generateTransactionId(),
      fromUserId: 'system',
      toUserId: userId,
      amount: amount,
      date: DateTime.now(),
      type: TransactionType.topup,
      status: TransactionStatus.completed,
      description: 'Rechargement via $paymentMethod',
    );

    _transactions.add(transaction);
    
    // Mettre à jour le solde
    final user = AuthService.users.firstWhere((u) => u.id == userId);
    user.afriCoinBalance += amount;

    return transaction;
  }

  static String _generateTransactionId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNum = random.nextInt(9999);
    return 'TXN${timestamp}_$randomNum';
  }

  static double calculateTransactionFee(double amount) {
    // Frais de 1% avec un minimum de 0.01 AC et maximum de 5 AC
    final fee = amount * 0.01;
    return fee.clamp(0.01, 5.0);
  }

  static List<Transaction> getRecentTransactions(String userId, {int limit = 5}) {
    return getUserTransactions(userId).take(limit).toList();
  }

  static Map<String, double> getTransactionSummary(String userId) {
    final userTransactions = getUserTransactions(userId);
    double totalSent = 0;
    double totalReceived = 0;
    double totalFees = 0;

    for (final transaction in userTransactions) {
      if (transaction.fromUserId == userId) {
        totalSent += transaction.amount;
        totalFees += calculateTransactionFee(transaction.amount);
      } else if (transaction.toUserId == userId) {
        totalReceived += transaction.amount;
      }
    }

    return {
      'totalSent': totalSent,
      'totalReceived': totalReceived,
      'totalFees': totalFees,
      'netBalance': totalReceived - totalSent,
    };
  }
}