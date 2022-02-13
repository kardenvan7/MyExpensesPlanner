import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/core/widgets/custom_dropdown.dart';
import 'package:my_expenses_planner/presentation/ui/edit_category/edit_category_screen.dart';

class CategoriesDropdownField extends StatefulWidget {
  const CategoriesDropdownField({
    required this.onCategoryPick,
    this.initialCategory,
    Key? key,
  }) : super(key: key);

  final TransactionCategory? initialCategory;
  final void Function(TransactionCategory? category) onCategoryPick;

  @override
  State<CategoriesDropdownField> createState() =>
      _CategoriesDropdownFieldState();
}

class _CategoriesDropdownFieldState extends State<CategoriesDropdownField> {
  late TransactionCategory? _pickedCategory = widget.initialCategory;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryListCubit, CategoryListState>(
      builder: (BuildContext context, CategoryListState state) {
        if (state.isLoading) {
          return Container();
        }

        final _pickedCategoryFromState = state.categories.firstWhereOrNull(
          (element) => _pickedCategory?.uuid == element.uuid,
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
              initialValue: _pickedCategoryFromState,
              onValueChanged: _onChanged,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        _onCategoryEdit(context: context);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
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
                style: const TextStyle(
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
                    _onCategoryEdit(context: context, category: category);
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

  void _onCategoryEdit({
    required BuildContext context,
    TransactionCategory? category,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (editTransactionContext) {
          return EditCategoryScreen(
            category: category,
            onEditFinish: widget.onCategoryPick,
          );
        },
      ),
    );
  }

  void _onCategoryDelete(BuildContext context, String categoryUuid) {
    showDialog(
      context: context,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: const Text(
            'Are you sure you want to delete the category?',
          ), // TODO: localization
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(alertContext);
              },
              child: const Text('No'),
            ), // TODO: localization
            TextButton(
              onPressed: () async {
                await BlocProvider.of<CategoryListCubit>(context)
                    .deleteCategory(categoryUuid);

                if (_pickedCategory?.uuid == categoryUuid) {
                  setState(() {
                    _pickedCategory = null;
                    widget.onCategoryPick(null);
                  });
                }

                Navigator.pop(alertContext);
              },
              child: const Text('Yes'), // TODO: localization
            ),
          ],
        );
      },
    );
  }

  void _onChanged(TransactionCategory? value) {
    setState(() {
      _pickedCategory = value;
      widget.onCategoryPick(value);
    });
  }
}
