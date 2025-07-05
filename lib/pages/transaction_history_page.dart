import 'package:flutter/material.dart';
import 'package:africoin/services/auth_service.dart';
import 'package:africoin/widgets/custom_appbar.dart';
import 'package:africoin/models/transaction_model.dart';

// Écran d'historique des transactions
class TransactionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!;
    final userTransactions =
        AuthService.transactions
            .where((t) => t.fromUserId == user.id || t.toUserId == user.id)
            .toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(title: 'Historique des transactions'),
      body:
          userTransactions.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Aucune transaction',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: userTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = userTransactions[index];
                  return TransactionItem(
                    transaction: transaction,
                    isCurrentUser: transaction.fromUserId == user.id,
                  );
                },
              ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final bool isCurrentUser;

  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.isCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReceived = transaction.type == TransactionType.receive;
    final color = isReceived ? Colors.green : Colors.red;
    final sign = isReceived ? '+' : '-';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isReceived ? Icons.arrow_downward : Icons.arrow_upward,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReceived ? 'Reçu' : 'Envoyé',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$sign${transaction.amount.toStringAsFixed(2)} AC',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

