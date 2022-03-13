part of 'edit_transaction_cubit.dart';

class EditTransactionState {
  EditTransactionState({
    this.uuid,
    this.date,
    this.amount,
    this.title,
    this.type,
    this.categoryUuid,
    this.triggerBuilder = true,
    this.snackBarText,
    this.popScreen = false,
    FormState? formState,
  }) : formState = formState ?? const FormState();

  factory EditTransactionState.fromTransaction(Transaction transaction) {
    return EditTransactionState(
      uuid: transaction.uuid,
      date: transaction.date,
      amount: transaction.amount.toString(),
      title: transaction.title,
      type: transaction.type,
      categoryUuid: transaction.categoryUuid,
    );
  }

  factory EditTransactionState.initialAdding() {
    return EditTransactionState(
      date: DateTime.now(),
      type: TransactionType.expense,
    );
  }

  /// Transaction related
  final String? uuid;
  final DateTime? date;
  final String? amount;
  final String? title;
  final String? categoryUuid;
  final TransactionType? type;

  /// UI related
  final bool triggerBuilder;
  final String? snackBarText;
  final bool popScreen;
  final FormState formState;

  bool get showSnackBar => snackBarText != null;

  bool get showCategoryField => type == TransactionType.expense;

  EditTransactionState copyWith({
    DateTime? date,
    String? amount,
    String? title,
    TransactionType? type,
    ValueWrapper<String>? categoryUuid,
    bool? triggerBuilder,
    String? snackBarText,
    bool? popScreen,
    FormState? formState,
  }) {
    return EditTransactionState(
      uuid: uuid,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      type: type ?? this.type,
      categoryUuid:
          categoryUuid == null ? this.categoryUuid : categoryUuid.value,
      triggerBuilder: triggerBuilder ?? true,
      snackBarText: snackBarText,
      popScreen: popScreen ?? false,
      formState: formState,
    );
  }
}

class FormState {
  const FormState({
    this.titleErrorText,
    this.amountErrorText,
  });

  final String? titleErrorText;
  final String? amountErrorText;
}
