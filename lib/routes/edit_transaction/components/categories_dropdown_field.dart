import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/cubit/categories_cubit.dart';
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

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomDropdown<TransactionCategory?>(
                items: _buildItems(context: context),
                initialValue: initialCategory,
                onValueChanged: _onChanged,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        _onCategoryCreate(context);
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
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
        title: Text('No category'),
        value: null,
      ),
    );

    if (categories != null) {
      for (final TransactionCategory category in categories) {
        itemsList.add(
          CustomDropdownItem<TransactionCategory?>(
            title: Text(category.name),
            leading: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: category.color,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _onCategoryEdit(context, category);
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    _onCategoryDelete(context, category.uuid);
                  },
                  icon: Icon(Icons.delete),
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

  void _onCategoryEdit(BuildContext context, TransactionCategory category) {
    Navigator.pushNamed(context, EditCategoryScreen.routeName, arguments: {
      'cubit': BlocProvider.of<CategoriesCubit>(context),
      'category': category
    });
  }

  void _onCategoryDelete(BuildContext context, String categoryUuid) {}

  void _onCategoryCreate(BuildContext context) {
    Navigator.pushNamed(context, EditCategoryScreen.routeName, arguments: {
      'cubit': BlocProvider.of<CategoriesCubit>(context),
      'category': null
    });
  }

  void _onChanged(TransactionCategory? value) {
    onCategoryPick(value);
  }
}
