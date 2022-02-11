part of 'edit_transaction_cubit.dart';

class EditTransactionState {
  EditTransactionState({
    this.uuid,
    this.date,
    this.amount,
    this.title,
    this.category,
    this.triggerBuilder = true,
    this.snackBarText,
    this.popScreen = false,
  });

  factory EditTransactionState.fromTransaction(Transaction transaction) {
    return EditTransactionState(
      uuid: transaction.uuid,
      date: transaction.date,
      amount: transaction.amount.toString(),
      title: transaction.title,
      category: ValueWrapper(value: transaction.category),
    );
  }

  factory EditTransactionState.initialAdding() {
    return EditTransactionState(
      date: DateTime.now(),
    );
  }

  /// Transaction related
  final String? uuid;
  final DateTime? date;
  final String? amount;
  final String? title;
  final ValueWrapper<TransactionCategory>? category;

  bool get isAdding => uuid == null;

  /// UI related
  final bool triggerBuilder;
  final String? snackBarText;
  final bool popScreen;

  bool get showSnackBar => snackBarText != null;

  EditTransactionState copyWith({
    DateTime? date,
    String? amount,
    String? title,
    ValueWrapper<TransactionCategory>? category,
    bool? triggerBuilder,
    String? snackBarText,
    bool? popScreen,
  }) {
    return EditTransactionState(
      uuid: uuid,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      category: category ?? this.category,
      triggerBuilder: triggerBuilder ?? true,
      snackBarText: snackBarText,
      popScreen: popScreen ?? false,
    );
  }
}

class FormState {
  final String? titleErrorText;
  final String? amountErrorText;
}
