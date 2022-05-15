import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_expenses_planner/domain/models/transactions/transaction.dart';
import 'package:my_expenses_planner/presentation/cubit/app_settings/app_settings_cubit.dart';
import 'package:my_expenses_planner/presentation/cubit/category_list/category_list_cubit.dart';
import 'package:my_expenses_planner/presentation/ui/core/double_tween.dart';

class OneDayTransactionsColumn extends StatefulWidget {
  const OneDayTransactionsColumn({
    required this.transactions,
    required this.title,
    required this.maxAmount,
    this.animationDuration = const Duration(seconds: 1),
    Key? key,
  }) : super(key: key);

  final List<Transaction> transactions;
  final String title;
  final double maxAmount;
  final Duration animationDuration;

  @override
  State<OneDayTransactionsColumn> createState() =>
      _OneDayTransactionsColumnState();
}

class _OneDayTransactionsColumnState extends State<OneDayTransactionsColumn> {
  late List<CategoryTransactions> previousTransactionsByCategory;
  late List<CategoryTransactions> currentTransactionsByCategory;

  double get amountForDay {
    return widget.transactions.fold(
      0,
      (previousValue, element) => element.amount + previousValue,
    );
  }

  Map<String?, List<Transaction>> get transactionsByCategoryMap {
    final Map<String?, List<Transaction>> _map = {};

    for (final Transaction tr in widget.transactions) {
      final String? _categoryUuid = tr.categoryUuid;

      if (_map.containsKey(_categoryUuid)) {
        _map[_categoryUuid]!.add(tr);
      } else {
        _map[_categoryUuid] = [tr];
      }
    }

    return _map;
  }

  List<CategoryTransactions> get transactionsByCategories {
    final List<String?> _keys = transactionsByCategoryMap.keys.toList();
    final List<CategoryTransactions> _transactionsByCategories = [];

    for (final String? _key in _keys) {
      _transactionsByCategories.add(
        CategoryTransactions(
          transactions: transactionsByCategoryMap[_key]!,
          categoryUuid: _key,
        ),
      );
    }

    _transactionsByCategories.sort((a, b) => a.sum.compareTo(b.sum));

    return _transactionsByCategories;
  }

  @override
  void initState() {
    super.initState();

    final _transactionsByCategories = transactionsByCategories;

    previousTransactionsByCategory = _transactionsByCategories;
    currentTransactionsByCategory = _transactionsByCategories;
  }

  @override
  void didUpdateWidget(covariant OneDayTransactionsColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    final _transactionsByCategories = transactionsByCategories;

    setState(() {
      previousTransactionsByCategory = currentTransactionsByCategory;
      currentTransactionsByCategory = _transactionsByCategories;
    });
  }

  bool get didCategoryAmountDecrease => categoryAmountDifference > 0;

  int get categoryAmountDifference =>
      previousTransactionsByCategory.length -
      currentTransactionsByCategory.length;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 15) / 8,
      child: Column(
        children: [
          Text(widget.title),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.hardEdge,
              width: 16,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black),
              ),
              child: TweenAnimationBuilder<double>(
                duration: widget.animationDuration,
                tween: DoubleTween(
                  begin: 0,
                  end: widget.maxAmount != 0
                      ? amountForDay / widget.maxAmount
                      : 0,
                ),
                builder: (context, value, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: value,
                    child: child!,
                  );
                },
                child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
                  builder: (context, state) {
                    return Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(8),
                          bottomRight: const Radius.circular(8),
                          topLeft: Radius.circular(
                            amountForDay == widget.maxAmount ? 8 : 0,
                          ),
                          topRight: Radius.circular(
                            amountForDay == widget.maxAmount ? 8 : 0,
                          ),
                        ),
                      ),
                      child: BlocBuilder<CategoryListCubit, CategoryListState>(
                        builder: (context, state) {
                          final _transactionsByCategoriesUsed =
                              didCategoryAmountDecrease
                                  ? previousTransactionsByCategory
                                  : currentTransactionsByCategory;
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: List<Widget>.generate(
                              _transactionsByCategoriesUsed.length,
                              (index) {
                                final CategoryTransactions
                                    _categoryTransactions =
                                    _transactionsByCategoriesUsed[index];
                                final int _curFraction;

                                if (currentTransactionsByCategory
                                        .firstWhereOrNull((element) =>
                                            element.categoryUuid ==
                                            _categoryTransactions
                                                .categoryUuid) !=
                                    null) {
                                  _curFraction = (_categoryTransactions.sum *
                                          100 /
                                          amountForDay)
                                      .round();
                                } else {
                                  _curFraction = 0;
                                }

                                return TweenAnimationBuilder<int>(
                                  key: ValueKey(
                                    _categoryTransactions.categoryUuid,
                                  ),
                                  tween: IntTween(
                                    begin: 1,
                                    end: _curFraction,
                                  ),
                                  duration: widget.animationDuration,
                                  builder: (context, value, child) {
                                    if (value == 0) {
                                      return Container();
                                    }
                                    return Flexible(
                                      flex: value,
                                      child: child!,
                                    );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Divider(
                                        color: Colors.black,
                                        thickness: 1.2,
                                        height: 0,
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: state.categories
                                                  .firstWhereOrNull(
                                                    (element) =>
                                                        element.uuid ==
                                                        _categoryTransactions
                                                            .categoryUuid,
                                                  )
                                                  ?.color ??
                                              Colors.grey,
                                        ),
                                      ),
                                    ],
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
          TweenAnimationBuilder<double>(
            builder: (context, value, child) {
              return SizedBox(
                height: 25,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5.0),
                  child: AutoSizeText(
                    value.toStringAsFixed(value < 99 ? 1 : 0),
                    minFontSize: 8,
                    maxFontSize: 14,
                    softWrap: true,
                  ),
                ),
              );
            },
            duration: widget.animationDuration,
            tween: DoubleTween(
              begin: 0,
              end: amountForDay,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryTransactions {
  CategoryTransactions({
    required this.transactions,
    required this.categoryUuid,
  }) : assert(
            transactions.firstWhereOrNull(
                    (element) => element.categoryUuid != categoryUuid) ==
                null,
            'There are transactions in list that have another categoryUuid');

  final List<Transaction> transactions;
  final String? categoryUuid;

  double get sum => transactions.fold<double>(
        0,
        (previousValue, element) => previousValue + element.amount,
      );
}
