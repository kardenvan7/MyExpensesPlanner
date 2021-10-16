import 'package:flutter_bloc/flutter_bloc.dart';

class Transaction extends Cubit<TransactionState> {
  final String id;
  DateTime date;
  String title;
  double amount;

  Transaction({
    required this.id,
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
      id: DateTime.now().microsecondsSinceEpoch.toString(),
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
}

class TransactionState {}
