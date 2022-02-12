part of 'edit_category_cubit.dart';

class EditCategoryState {
  EditCategoryState({
    this.uuid,
    this.color,
    this.name,
    this.triggerBuilder = true,
    this.snackBarText,
    this.popScreen = false,
    FormState? formState,
  }) : formState = formState ?? const FormState();

  factory EditCategoryState.fromCategory(TransactionCategory category) {
    return EditCategoryState(
      uuid: category.uuid,
      color: category.color,
      name: category.name,
    );
  }

  factory EditCategoryState.initialAdding() {
    return EditCategoryState();
  }

  /// Category related
  final String? uuid;
  final Color? color;
  final String? name;

  /// UI related
  final bool triggerBuilder;
  final String? snackBarText;
  final bool popScreen;
  final FormState formState;

  bool get showSnackBar => snackBarText != null;

  EditCategoryState copyWith({
    DateTime? date,
    String? name,
    Color? color,
    bool? triggerBuilder,
    String? snackBarText,
    bool? popScreen,
    FormState? formState,
  }) {
    return EditCategoryState(
      uuid: uuid,
      name: name ?? this.name,
      color: color ?? this.color,
      triggerBuilder: triggerBuilder ?? true,
      snackBarText: snackBarText,
      popScreen: popScreen ?? false,
      formState: formState,
    );
  }
}

class FormState {
  const FormState({
    this.nameErrorText,
  });

  final String? nameErrorText;
}
