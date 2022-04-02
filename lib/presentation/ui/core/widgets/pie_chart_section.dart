import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/core/extensions/color_extensions.dart';
import 'package:my_expenses_planner/core/extensions/double_extensions.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/domain/models/transaction_category.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartSection extends StatelessWidget {
  const PieChartSection({
    required this.transactions,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  final bool isLoading;
  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    final Map<String?, double> _expensesByCategories =
        _getExpensesByCategory(transactions);
    final double income = transactions
        .where((element) => element.type == TransactionType.income)
        .fold<double>(
          0,
          (previousValue, element) => previousValue + element.amount,
        );
    final double expenses = transactions
        .where((element) => element.type == TransactionType.expense)
        .fold<double>(
          0,
          (previousValue, element) => previousValue + element.amount,
        );

    final double difference = income - expenses;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.only(
        bottom: 10,
        left: 16,
        right: 16,
        top: 10,
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

          if (transactions.isEmpty) {
            return Center(
              child: Text(
                AppLocalizationsWrapper.of(context).no_data_to_show,
              ),
            );
          }

          return BlocBuilder<CategoryListCubit, CategoryListState>(
            builder: (context, categoriesState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_expensesByCategories.isNotEmpty)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PieChartWrapper(
                          expensesByCategories: _expensesByCategories,
                          categories: categoriesState.categories,
                        ),
                        const SizedBox(height: 10),
                        PieChartCustomLegend(
                          categories: categoriesState.categories,
                          expensesByCategories: _expensesByCategories,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (income > 0)
                        Container(
                          margin: EdgeInsets.only(
                            bottom: expenses > 0 ? 10 : 0,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 150,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizationsWrapper.of(context).income}: ',
                              ),
                              Text(
                                income.toStringAsFixed(0),
                                style: const TextStyle(
                                  color: Colors.green,
                                ),
                              )
                            ],
                          ),
                        ),
                      if (expenses > 0)
                        Container(
                          constraints: const BoxConstraints(
                            minWidth: 150,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizationsWrapper.of(context).expenses}: ',
                              ),
                              Text(
                                '-${expenses.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                      if (income > 0 && expenses > 0)
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 150,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizationsWrapper.of(context).difference}: ',
                              ),
                              Text(
                                difference.toStringAsFixed(0),
                                style: TextStyle(
                                  color: difference > 0
                                      ? Colors.green
                                      : difference == 0
                                          ? Colors.grey
                                          : Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Map<String?, double> _getExpensesByCategory(List<Transaction> transactions) {
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

class PieChartWrapper extends StatelessWidget {
  const PieChartWrapper({
    required this.expensesByCategories,
    required this.categories,
    Key? key,
  }) : super(key: key);

  final Map<String?, double> expensesByCategories;
  final List<TransactionCategory> categories;

  @override
  Widget build(BuildContext context) {
    final _categoriesCount = expensesByCategories.length;
    final List<String?> _categoryUuids = expensesByCategories.keys.toList();
    final double _dynamicChartRadius = (80 + 20 * _categoriesCount).toDouble();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: PieChart(
        legendOptions: const LegendOptions(
          showLegends: false,
          legendPosition: LegendPosition.bottom,
          showLegendsInRow: true,
        ),
        chartLegendSpacing: 30,
        ringStrokeWidth: 35,
        chartRadius: _dynamicChartRadius > 400 ? 400 : _dynamicChartRadius,
        chartType: ChartType.ring,
        formatChartValues: (double value) {
          return value.toStringAsFixed(0);
        },
        colorList: List.generate(
          _categoryUuids.length,
          (index) =>
              categories
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
            return categories
                    .firstWhereOrNull((element) => element.uuid == _currentUuid)
                    ?.name ??
                AppLocalizationsWrapper.of(context).without_category;
          },
          value: (_currentUuid) {
            return expensesByCategories[_currentUuid]!;
          },
        ),
      ),
    );
  }
}

class PieChartCustomLegend extends StatelessWidget {
  const PieChartCustomLegend({
    required this.categories,
    required this.expensesByCategories,
    Key? key,
  }) : super(key: key);

  final List<TransactionCategory> categories;
  final Map<String?, double> expensesByCategories;

  @override
  Widget build(BuildContext context) {
    final List<String?> _categoryUuids = expensesByCategories.keys.toList();
    return Wrap(
      spacing: 10,
      children: List.generate(
        expensesByCategories.keys.length,
        (index) {
          final _category = categories.firstWhereOrNull(
            (element) => _categoryUuids[index] == element.uuid,
          );

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.5,
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  color: _category?.color,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  (_category?.name ??
                          AppLocalizationsWrapper.of(context)
                              .without_category) +
                      ' - ' +
                      expensesByCategories[_categoryUuids[index]]!
                          .toAmountString(),
                  style: TextStyle(
                    color: _category?.color == null
                        ? Theme.of(context).textTheme.bodySmall!.color
                        : _category!.color.isBright
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
