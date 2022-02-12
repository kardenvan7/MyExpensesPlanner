import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/models/value_wrapper.dart';
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

  bool get isAdding => category == null;

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
        uuid: state.uuid ?? DateTime.now().microsecondsSinceEpoch.toString(),
        color: HexColor.fromHex(_colorController.text) ?? Colors.white,
        name: _titleController.text,
      );

      final CategoryListCubit cubit =
          BlocProvider.of<CategoryListCubit>(context);

      if (widget.category == null) {
        cubit.addCategory(newCategory);
      } else {
        await cubit.updateCategory(widget.category!.uuid, newCategory);
        BlocProvider.of<TransactionListCubit>(context).refresh();
      }

      Navigator.pop(context, newCategory);
    }
  }

  Future<void> _addTransaction({
    required Transaction transaction,
  }) async {
    try {
      await categoriesCase.save(
        transaction: transaction,
      );

      emit(state.copyWith(popScreen: true));
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
      await categoriesCase.edit(
        transactionId: id,
        newTransaction: newTransaction,
      );

      emit(state.copyWith(popScreen: true));
    } catch (e) {
      emit(
        state.copyWith(
          snackBarText: 'An error occurred while saving changes',
        ),
      );
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

  void setColor(String? color) {
    final _color =
        color != null ? HexColor.fromHex(color) ?? Colors.white : Colors.white;

    emit(
      state.copyWith(
        color: _color,
        triggerBuilder: false,
      ),
    );
  }
}
