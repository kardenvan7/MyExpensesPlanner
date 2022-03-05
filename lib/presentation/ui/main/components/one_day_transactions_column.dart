import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/domain/models/transaction.dart';
import 'package:my_expenses_planner/presentation/cubit/app/app_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';

class OneDayTransactionsColumn extends StatelessWidget {
  const OneDayTransactionsColumn({
    required this.transactions,
    required this.title,
    required this.maxAmount,
    Key? key,
  }) : super(key: key);

  final List<Transaction> transactions;
  final String title;
  final double maxAmount;

  double get amountForDay {
    return transactions.fold(
      0,
      (previousValue, element) => element.amount + previousValue,
    );
  }

  Map<String?, List<Transaction>> get transactionsByCategory {
    final Map<String?, List<Transaction>> _map = {};

    for (final Transaction tr in transactions) {
      final String? _categoryUuid = tr.categoryUuid;

      if (_map.containsKey(_categoryUuid)) {
        _map[_categoryUuid]!.add(tr);
      } else {
        _map[_categoryUuid] = [tr];
      }
    }

    return _map;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 15) / 8,
      child: Column(
        children: [
          Text(title),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.hardEdge,
              width: 16,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: maxAmount != 0 ? amountForDay / maxAmount : 0,
                child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
                  builder: (context, state) {
                    return Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        // color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(8),
                          bottomRight: const Radius.circular(8),
                          topLeft: Radius.circular(
                            amountForDay == maxAmount ? 8 : 0,
                          ),
                          topRight: Radius.circular(
                            amountForDay == maxAmount ? 8 : 0,
                          ),
                        ),
                      ),
                      child: BlocBuilder<CategoryListCubit, CategoryListState>(
                        builder: (context, state) {
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(
                              transactionsByCategory.keys.toList().length,
                              (index) {
                                final _curCategoryUuid =
                                    transactionsByCategory.keys.toList()[index];
                                final int _amountOfCategory =
                                    transactionsByCategory[_curCategoryUuid]!
                                        .fold(
                                  0,
                                  (previousValue, element) =>
                                      (element.amount + previousValue).toInt(),
                                );

                                final int _curFraction =
                                    (_amountOfCategory * 100 / amountForDay)
                                        .round();

                                return Flexible(
                                  flex: _curFraction,
                                  child: Container(
                                    color: state.categories
                                            .firstWhereOrNull((element) =>
                                                element.uuid ==
                                                _curCategoryUuid)
                                            ?.color ??
                                        Colors.grey,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5.0),
              child: AutoSizeText(
                amountForDay.toInt().toString(),
                minFontSize: 8,
                maxFontSize: 14,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
