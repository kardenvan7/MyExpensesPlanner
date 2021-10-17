import 'package:flutter_bloc/flutter_bloc.dart';

class Transaction extends Cubit<TransactionState> {
  final String txId;
  DateTime date;
  String title;
  double amount;

  Transaction({
    required this.txId,
    required this.amount,
    required this.title,
    required this.date,
  }) : super(TransactionState());

  Transaction copyWith({
    String? newTitle,
    double? newAmount,
    DateTime? newDate,
  }) {
    return Transaction(
      txId: DateTime.now().microsecondsSinceEpoch.toString(),
      amount: newAmount ?? amount,
      title: newTitle ?? title,
      date: newDate ?? date,
    );
  }

  void edit({
    String? newTitle,
    double? newAmount,
    DateTime? newDateTime,
  }) {
    amount = newAmount ?? amount;
    title = newTitle ?? title;
    date = newDateTime ?? date;

    emit(TransactionState());
  }

  Map<String, Object?> toMap() {
    return {
      'tx_id': txId,
      'title': title,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Transaction.fromJson(Map<String, Object?> json) {
    return Transaction(
      txId: json['tx_id'] as String,
      amount: json['amount'] as double,
      title: json['title'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
    );
  }
}

class TransactionState {}
