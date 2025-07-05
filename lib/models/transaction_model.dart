class Transaction {
  final String id;
  final String fromUserId;
  final String toUserId;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionStatus status;
  final String? description;

  Transaction({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
    this.description,
  });
}

enum TransactionType { send, receive, topup }
enum TransactionStatus { pending, completed, failed }
