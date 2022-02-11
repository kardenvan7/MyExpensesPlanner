import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/models/value_wrapper.dart';
import 'package:my_expenses_planner/domain/use_cases/transactions/i_transactions_case.dart';

part 'edit_transaction_state.dart';

class EditTransactionCubit extends Cubit<EditTransactionState> {
  EditTransactionCubit({
    required this.transaction,
    required this.transactionsCase,
  }) : super(
          transaction == null
              ? EditTransactionState.initialAdding()
              : EditTransactionState.fromTransaction(transaction),
        );

  final Transaction? transaction;
  final ITransactionsCase transactionsCase;

  bool validateForm() {
    String? titleErrorText;
    String? amountErrorText;

    final String? _amount = state.amount;
    final String? _title = state.title;

    if (_amount == null) {
      amountErrorText = 'Field must be filled';
    } else {
      final double? parsedAmount = double.tryParse(_amount);

      if (parsedAmount == null) {
        amountErrorText = 'Invalid format';
      }
    }

    if (_title == null || _title == '') {
      titleErrorText = 'Field must be filled';
    }

    if (titleErrorText == null && amountErrorText == null) {
      return true;
    } else {
      emit(state.copyWith());

      /// TODO

      return false;
    }
  }

  Future<void> submit() async {
    if (_isFormValid) {
      final String title = state.title!;
      final double amount = double.parse(state.amount!);

      final Transaction newTransaction = Transaction(
        uuid: isAdding
            ? DateTime.now().microsecondsSinceEpoch.toString()
            : widget.transaction!.uuid,
        title: title,
        amount: amount,
        date: _pickedDate,
        category: _pickedCategory,
      );

      if (isAdding) {
        _addTransaction(
          transaction: newTransaction,
        );
      } else {
        _editTransaction(
          id: widget.transaction!.uuid,
          newTransaction: newTransaction,
        );
      }
    }
  }

  Future<void> _addTransaction({
    required Transaction transaction,
  }) async {
    try {
      await transactionsCase.save(
        transaction: transaction,
      );
    } catch (e) {
      emit(
        state.copyWith(
          snackBarText: 'An error occurred while saving transaction',
        ),
      );
    }
  }

  Future<void> _editTransaction({
    required String id,
    required Transaction newTransaction,
  }) async {
    try {
      await transactionsCase.edit(
        transactionId: id,
        newTransaction: newTransaction,
      );
    } catch (e) {
      emit(
        state.copyWith(
          snackBarText: 'An error occurred while saving changes',
        ),
      );
    }
  }

  void setTitle(String? string) {
    emit(
      state.copyWith(
        title: string,
        triggerBuilder: false,
      ),
    );
  }

  void setAmount(String? amount) {
    emit(
      state.copyWith(
        amount: amount,
        triggerBuilder: false,
      ),
    );
  }

  void setCategory(TransactionCategory? category) {
    emit(
      state.copyWith(
        category: ValueWrapper(
          value: category,
        ),
        triggerBuilder: false,
      ),
    );
  }

  void setDate(DateTime date) {
    emit(
      state.copyWith(
        date: date,
        triggerBuilder: false,
      ),
    );
  }
}