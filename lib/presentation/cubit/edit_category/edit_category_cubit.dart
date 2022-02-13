import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';

part 'edit_category_state.dart';

class EditCategoryCubit extends Cubit<EditCategoryState> {
  EditCategoryCubit({
    required this.category,
    required this.categoriesCase,
  }) : super(
          category == null
              ? EditCategoryState.initialAdding()
              : EditCategoryState.fromCategory(category),
        );

  final TransactionCategory? category;
  final ICategoriesCase categoriesCase;

  bool get isCreating => category == null;

  bool _validateForm() {
    String? nameErrorText;

    final String? _name = state.name;

    if (_name == null || _name == '') {
      nameErrorText = 'Field must be filled';
    }

    if (nameErrorText == null) {
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
            nameErrorText: nameErrorText,
          ),
        ),
      );

      return false;
    }
  }

  Future<void> submit() async {
    if (_validateForm()) {
      final TransactionCategory newCategory = TransactionCategory(
        uuid: isCreating
            ? DateTime.now().microsecondsSinceEpoch.toString()
            : state.uuid!,
        color: state.color!,
        name: state.name!,
      );

      if (isCreating) {
        await categoriesCase.save(newCategory);
      } else {
        await categoriesCase.update(newCategory.uuid, newCategory);
      }

      emit(state.copyWith(popScreen: true));
    }
  }

  void setName(String? string) {
    emit(
      state.copyWith(
        name: string,
        triggerBuilder: false,
      ),
    );
  }

  void setColor(Color? color) {
    emit(
      state.copyWith(
        color: color,
        triggerBuilder: false,
      ),
    );
  }
}
