class Transaction {
  final String id;
  final DateTime date;
  final String title;
  final double amount;

  Transaction({
    required this.id,
    required this.amount,
    required this.title,
    required this.date,
  });
}
