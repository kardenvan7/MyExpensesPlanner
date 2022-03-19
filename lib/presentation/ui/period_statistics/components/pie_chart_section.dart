import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartSection extends StatefulWidget {
  const PieChartSection({
    required this.expenses,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  final List<Transaction> expenses;
  final bool isLoading;

  @override
  State<PieChartSection> createState() => _PieChartSectionState();
}

class _PieChartSectionState extends State<PieChartSection> {
  late bool isLoading = true;
  late Map<String?, double> amountsByCategory;

  @override
  void initState() {
    super.initState();

    final _amountsByCategory = _getAmountsByCategory(
      widget.expenses,
    );

    setState(() {
      amountsByCategory = _amountsByCategory;
      isLoading = false;
    });
  }

  @override
  void didUpdateWidget(covariant PieChartSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      isLoading = true;
    });

    final _amountsByCategory = _getAmountsByCategory(
      widget.expenses,
    );

    setState(() {
      amountsByCategory = _amountsByCategory;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: Builder(
        builder: (context) {
          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          }

          if (widget.expenses.isEmpty ||
              amountsByCategory.keys.toList().isEmpty) {
            return Center(
              child: Text(
                AppLocalizationsWrapper.of(context).no_data_to_show,
              ),
            );
          }

          final _categoryUuids = amountsByCategory.keys.toList();

          return BlocBuilder<CategoryListCubit, CategoryListState>(
            builder: (context, categoriesState) {
              return PieChart(
                colorList: List.generate(
                  _categoryUuids.length,
                  (index) =>
                      categoriesState.categories
                          .firstWhereOrNull(
                            (element) => _categoryUuids[index] == element.uuid,
                          )
                          ?.color ??
                      Colors.grey,
                ),
                // ignore: prefer_for_elements_to_map_fromIterable
                dataMap: Map<String, double>.fromIterable(
                  _categoryUuids,
                  key: (_currentUuid) {
                    return categoriesState.categories
                            .firstWhereOrNull(
                                (element) => element.uuid == _currentUuid)
                            ?.name ??
                        AppLocalizationsWrapper.of(context).without_category;
                  },
                  value: (_currentUuid) {
                    return amountsByCategory[_currentUuid]!;
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Map<String?, double> _getAmountsByCategory(List<Transaction> transactions) {
    final Map<String?, double> _map = {};
    final _expensesByCategories = _getExpensesByCategories(transactions);

    for (final String? categoryUuid in _expensesByCategories.keys.toList()) {
      final double _amountByCategory =
          _expensesByCategories[categoryUuid]!.fold<double>(
        0,
        (previousValue, element) => previousValue + element.amount,
      );

      _map[categoryUuid] = _amountByCategory;
    }

    return _map;
  }

  Map<String?, List<Transaction>> _getExpensesByCategories(
    List<Transaction> transactions,
  ) {
    final Map<String?, List<Transaction>> _map = {};
    final List<Transaction> expenses = transactions
        .where(
          (element) => element.type == TransactionType.expense,
        )
        .toList();

    for (final Transaction _tr in expenses) {
      final String? _categoryUuid = _tr.categoryUuid;

      if (_map.containsKey(_categoryUuid)) {
        _map[_categoryUuid]!.add(_tr);
      } else {
        _map[_categoryUuid] = [_tr];
      }
    }

    return _map;
  }
}
