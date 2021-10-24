import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/cubit/categories_cubit.dart';
import 'package:my_expenses_planner/cubit/transactions_cubit.dart';
import 'package:my_expenses_planner/models/transaction_category.dart';
import 'package:my_expenses_planner/providers/categories/sqflite_categories_provider.dart';
import 'package:my_expenses_planner/routes/edit_category/edit_category_screen.dart';
import 'package:my_expenses_planner/widgets/custom_dropdown.dart';

class CategoriesDropdownField extends StatelessWidget {
  const CategoriesDropdownField({
    required this.onCategoryPick,
    this.initialCategory,
    Key? key,
  }) : super(key: key);

  final TransactionCategory? initialCategory;
  final void Function(TransactionCategory? category) onCategoryPick;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoriesCubit>(
      create: (BuildContext context) => CategoriesCubit(
        provider: SqfliteCategoriesProvider(),
      ),
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (BuildContext context, CategoriesState state) {
          final bool isLoaded = state.type == CategoriesStateType.loaded;
          if (!isLoaded) {
            final CategoriesCubit cubit =
                BlocProvider.of<CategoriesCubit>(context);

            SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
              cubit.fetchCategories();
            });

            return Container();
          }

          final TransactionCategory? pickedCategory =
              state.categories!.firstWhereOrNull(
            (element) => element.uuid == initialCategory?.uuid,
          );

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdown<TransactionCategory?>(
                items: [
                  ..._buildItems(
                    context: context,
                    categories: state.categories,
                  )
                ],
                initialValue: pickedCategory,
                onValueChanged: _onChanged,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          _onCategoryEdit(context, null);
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<CustomDropdownItem<TransactionCategory?>> _buildItems({
    required BuildContext context,
    List<TransactionCategory>? categories,
  }) {
    final List<CustomDropdownItem<TransactionCategory?>> itemsList = [];

    itemsList.add(
      const CustomDropdownItem<TransactionCategory?>(
        title: Text(
          'No category',
          style: TextStyle(fontSize: 18),
        ), // TODO: localization
        value: null,
      ),
    );

    if (categories != null) {
      for (final TransactionCategory category in categories) {
        itemsList.add(
          CustomDropdownItem<TransactionCategory?>(
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            leading: Align(
              alignment: Alignment.centerLeft,
              widthFactor: 1,
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: category.color,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _onCategoryEdit(context, category);
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    _onCategoryDelete(context, category.uuid);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            value: category,
          ),
        );
      }
    }

    return itemsList;
  }

  void _onCategoryEdit(BuildContext context, TransactionCategory? category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (editTransactionContext) {
          return BlocProvider.value(
            value: BlocProvider.of<CategoriesCubit>(context),
            child: EditCategoryScreen(category: category),
          );
        },
      ),
    ).then((value) {
      if (value != null) {
        onCategoryPick(value as TransactionCategory);
      }
    });
  }

  void _onCategoryDelete(BuildContext context, String categoryUuid) {
    showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: Text(
              'Are you sure you want to delete the category?'), // TODO: localization
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(alertContext);
              },
              child: Text('No'),
            ), // TODO: localization
            TextButton(
              onPressed: () {
                BlocProvider.of<CategoriesCubit>(context)
                    .deleteCategory(categoryUuid)
                    .then(
                  (value) {
                    BlocProvider.of<TransactionsCubit>(context).refresh();
                  },
                );
                Navigator.pop(alertContext);
                onCategoryPick(null);
              },
              child: Text('Yes'), // TODO: localization
            ),
          ],
        );
      },
    );
  }

  void _onChanged(TransactionCategory? value) {
    onCategoryPick(value);
  }
}
