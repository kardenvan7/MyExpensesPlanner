import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';

part './transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit({
    required Transaction transaction,
  }) : super(
          TransactionState(
            uuid: transaction.uuid,
            amount: transaction.amount,
            date: transaction.date,
            category: transaction.category,
            title: transaction.title,
          ),
        );

  void edit({
    required Transaction newTransactionData,
  }) {
    emit(
      TransactionState.fromTransaction(
        newTransactionData,
      ),
    );
  }
}
