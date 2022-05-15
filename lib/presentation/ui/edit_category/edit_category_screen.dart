import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/di.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/domain/use_cases/categories/i_categories_case.dart';
import 'package:my_expenses_planner/presentation/cubit/edit_category/edit_category_cubit.dart';
import 'package:my_expenses_planner/presentation/navigation/auto_router.gr.dart';
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
        categoriesCase: DI.instance<ICategoriesCase>(),
      ),
      child: BlocConsumer<EditCategoryCubit, EditCategoryState>(
        listener: (context, state) {
          if (state.popScreen) {
            onEditFinish?.call(state.uuid);

            DI.instance<AppRouter>().pop();
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
                state.isCreating
                    ? AppLocalizationsFacade.of(context).add_category
                    : AppLocalizationsFacade.of(context).edit_category,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _cubit.submit,
              child: const Icon(Icons.save),
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
                      autofocus: state.isCreating,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ColorPicker(
                        pickerColor: state.color,
                        onColorChanged: _cubit.setColor,
                        enableAlpha: false,
                        paletteType: PaletteType.hsv,
                        labelTypes: const [],
                      ),
                    ),
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
