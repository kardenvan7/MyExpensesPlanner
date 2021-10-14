class Transaction {
  final DateTime date;
  final String title;
  final double amount;

  Transaction({
    required this.amount,
    required this.title,
    required this.date,
  });
}
