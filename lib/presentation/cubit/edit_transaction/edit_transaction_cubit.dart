import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/utils/value_wrapper.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
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

  bool get isAdding => transaction == null;

  bool _validateForm() {
    String? titleErrorText;
    String? amountErrorText;

    final String? _amount = state.amount;
    final String? _title = state.title;

    if (_amount == null || _amount == '') {
      amountErrorText = 'Field must be filled';
    } else {
      final double? parsedAmount = double.tryParse(
        _amount.replaceFirst(',', '.'),
      );

      if (parsedAmount == null) {
        amountErrorText = 'Invalid format';
      }
    }

    if (_title == null || _title == '') {
      titleErrorText = 'Field must be filled';
    }

    if (titleErrorText == null && amountErrorText == null) {
      emit(
        state.copyWith(
          formState: const FormState(),
        ),
      );

      return true;
    } else {
      emit(
        state.copyWith(
          formState: FormState(
            titleErrorText: titleErrorText,
            amountErrorText: amountErrorText,
          ),
        ),
      );

      return false;
    }
  }

  Future<void> submit() async {
    if (_validateForm()) {
      final String title = state.title!;
      final double amount = double.parse(state.amount!.replaceFirst(',', '.'));

      final Transaction newTransaction = Transaction(
        uuid: isAdding
            ? DateTime.now().microsecondsSinceEpoch.toString()
            : state.uuid!,
        title: title,
        amount: amount,
        date: state.date!,
        type: state.type!,
        categoryUuid:
            state.type == TransactionType.income ? null : state.categoryUuid,
      );

      if (isAdding) {
        _addTransaction(
          transaction: newTransaction,
        );
      } else {
        _editTransaction(
          id: newTransaction.uuid,
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

      emit(state.copyWith(popScreen: true));
    } catch (e) {
      emit(
        state.copyWith(
          snackBarText: AppLocalizationsFacade.ofGlobalContext()
              .error_while_creating_transaction,
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

      emit(state.copyWith(popScreen: true));
    } catch (e) {
      emit(
        state.copyWith(
          snackBarText: AppLocalizationsFacade.ofGlobalContext()
              .error_while_changing_transaction,
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

  void setCategoryUuid(String? categoryUuid) {
    emit(
      state.copyWith(
        categoryUuid: ValueWrapper(
          value: categoryUuid,
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

  void setType(TransactionType type) {
    emit(state.copyWith(type: type));
  }
}
