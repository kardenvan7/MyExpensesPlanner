import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/config/l10n/localization.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
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
    final _expensesByCategories = _getExpensesByCategory(transactions);
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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

          final _categoryUuids = _expensesByCategories.keys.toList();

          return BlocBuilder<CategoryListCubit, CategoryListState>(
            builder: (context, categoriesState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_expensesByCategories.isNotEmpty)
                    Expanded(
                      child: SizedBox(
                        child: PieChart(
                          legendOptions: const LegendOptions(
                            showLegends: true,
                            legendPosition: LegendPosition.bottom,
                            showLegendsInRow: true,
                          ),
                          chartLegendSpacing: 30,
                          ringStrokeWidth: 35,
                          chartType: ChartType.ring,
                          formatChartValues: (double value) {
                            return value.toStringAsFixed(0);
                          },
                          colorList: List.generate(
                            _categoryUuids.length,
                            (index) =>
                                categoriesState.categories
                                    .firstWhereOrNull(
                                      (element) =>
                                          _categoryUuids[index] == element.uuid,
                                    )
                                    ?.color ??
                                Colors.grey,
                          ),
                          // ignore: prefer_for_elements_to_map_fromIterable
                          dataMap: Map<String, double>.fromIterable(
                            _categoryUuids,
                            key: (_currentUuid) {
                              return categoriesState.categories
                                      .firstWhereOrNull((element) =>
                                          element.uuid == _currentUuid)
                                      ?.name ??
                                  AppLocalizationsWrapper.of(context)
                                      .without_category;
                            },
                            value: (_currentUuid) {
                              return _expensesByCategories[_currentUuid]!;
                            },
                          ),
                        ),
                      ),
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
