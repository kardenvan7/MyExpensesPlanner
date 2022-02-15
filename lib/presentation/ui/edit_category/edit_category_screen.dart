import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_expenses_planner/config/localization/locale_keys.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';
import 'package:my_expenses_planner/presentation/cubit/edit_category/edit_category_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/edit_category/components/title_input.dart';

class EditCategoryScreen extends StatelessWidget {
  static const String routeName = '/edit_category';

  const EditCategoryScreen({
    this.onEditFinish,
    this.category,
    Key? key,
  }) : super(key: key);

  final TransactionCategory? category;
  final void Function(String? categoryUuid)? onEditFinish;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditCategoryCubit>(
      create: (context) => EditCategoryCubit(
        category: category,
        categoriesCase: getIt<ICategoriesCase>(),
      ),
      child: BlocConsumer<EditCategoryCubit, EditCategoryState>(
        listener: (context, state) {
          if (state.popScreen) {
            onEditFinish?.call(state.uuid);

            Navigator.of(context).pop();
          }
        },
        buildWhen: (oldState, newState) {
          return newState.triggerBuilder;
        },
        builder: (context, state) {
          final _cubit = BlocProvider.of<EditCategoryCubit>(context);

          return Scaffold(
            appBar: AppBar(
              title: Text(
                _cubit.isCreating
                    ? LocaleKeys.addCategory.tr()
                    : LocaleKeys.editCategory.tr(),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryTitleInput(
                      initialValue: state.name,
                      onChange: _cubit.setName,
                      errorText: state.formState.nameErrorText,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ColorPicker(
                        pickerColor: state.color,
                        onColorChanged: _cubit.setColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _cubit.submit,
                          child: Text(
                            LocaleKeys.submit.tr(),
                          ),
                        ),
                      ],
                    ) // TODO: localization
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
